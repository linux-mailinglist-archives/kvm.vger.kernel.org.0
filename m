Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DDA6E22BC
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 13:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjDNL7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 07:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDNL7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 07:59:02 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79A773C11;
        Fri, 14 Apr 2023 04:58:53 -0700 (PDT)
Received: from [192.168.2.41] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id D85F7217927B;
        Fri, 14 Apr 2023 04:58:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D85F7217927B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681473532;
        bh=K7moLybqmXhFd6ltNJ785cDNhj92t7yPGkeLPl1YI50=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nfC/g7m4x7hgwa65sLf31LrIMDjDB1tSafTa9LS6TTjV9h642tDUsxBItP837O5Ag
         S4cR4pH24/zN/MxCG3Op3bb29is/t0lAOh3iaqpJdKbP9oOfoKoVu7/qtP/E+BYc9S
         d7hToIAsvghFg1U4fWsMAjdIUSqtnutQgLVL7dDc=
Message-ID: <7332d846-fada-eb5c-6068-18ff267bd37f@linux.microsoft.com>
Date:   Fri, 14 Apr 2023 13:58:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: x86: Preserve TDP MMU roots until they are
 explicitly invalidated
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20230413231251.1481410-1-seanjc@google.com>
Content-Language: en-US
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20230413231251.1481410-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-22.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/2023 1:12 AM, Sean Christopherson wrote:
> Preserve TDP MMU roots until they are explicitly invalidated by gifting
> the TDP MMU itself a reference to a root when it is allocated.  Keeping a
> reference in the TDP MMU fixes a flaw where the TDP MMU exhibits terrible
> performance, and can potentially even soft-hang a vCPU, if a vCPU
> frequently unloads its roots, e.g. when KVM is emulating SMI+RSM.
> 
> When KVM emulates something that invalidates _all_ TLB entries, e.g. SMI
> and RSM, KVM unloads all of the vCPUs roots (KVM keeps a small per-vCPU
> cache of previous roots).  Unloading roots is a simple way to ensure KVM
> flushes and synchronizes all roots for the vCPU, as KVM flushes and syncs
> when allocating a "new" root (from the vCPU's perspective).
> 
> In the shadow MMU, KVM keeps track of all shadow pages, roots included, in
> a per-VM hash table.  Unloading a shadow MMU root just wipes it from the
> per-vCPU cache; the root is still tracked in the per-VM hash table.  When
> KVM loads a "new" root for the vCPU, KVM will find the old, unloaded root
> in the per-VM hash table.
> 
> Unlike the shadow MMU, the TDP MMU doesn't track "inactive" roots in a
> per-VM structure, where "active" in this case means a root is either
> in-use or cached as a previous root by at least one vCPU.  When a TDP MMU
> root becomes inactive, i.e. the last vCPU reference to the root is put,
> KVM immediately frees the root (asterisk on "immediately" as the actual
> freeing may be done by a worker, but for all intents and purposes the root
> is gone).
> 
> The TDP MMU behavior is especially problematic for 1-vCPU setups, as
> unloading all roots effectively frees all roots.  The issue is mitigated
> to some degree in multi-vCPU setups as a different vCPU usually holds a
> reference to an unloaded root and thus keeps the root alive, allowing the
> vCPU to reuse its old root after unloading (with a flush+sync).
> 
> The TDP MMU flaw has been known for some time, as until very recently,
> KVM's handling of CR0.WP also triggered unloading of all roots.  The
> CR0.WP toggling scenario was eventually addressed by not unloading roots
> when _only_ CR0.WP is toggled, but such an approach doesn't Just Work
> for emulating SMM as KVM must emulate a full TLB flush on entry and exit
> to/from SMM.  Given that the shadow MMU plays nice with unloading roots
> at will, teaching the TDP MMU to do the same is far less complex than
> modifying KVM to track which roots need to be flushed before reuse.
> 
> Note, preserving all possible TDP MMU roots is not a concern with respect
> to memory consumption.  Now that the role for direct MMUs doesn't include
> information about the guest, e.g. CR0.PG, CR0.WP, CR4.SMEP, etc., there
> are _at most_ six possible roots (where "guest_mode" here means L2):
> 
>   1. 4-level !SMM !guest_mode
>   2. 4-level  SMM !guest_mode
>   3. 5-level !SMM !guest_mode
>   4. 5-level  SMM !guest_mode
>   5. 4-level !SMM guest_mode
>   6. 5-level !SMM guest_mode
> 
> And because each vCPU can track 4 valid roots, a VM can already have all
> 6 root combinations live at any given time.  Not to mention that, in
> practice, no sane VMM will advertise different guest.MAXPHYADDR values
> across vCPUs, i.e. KVM won't ever use both 4-level and 5-level roots for
> a single VM.  Furthermore, the vast majority of modern hypervisors will
> utilize EPT/NPT when available, thus the guest_mode=%true cases are also
> unlikely to be utilized.
> 
> Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> Link: https://lore.kernel.org/all/959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com
> Link: https://lkml.kernel.org/r/20220209170020.1775368-1-pbonzini%40redhat.com
> Link: https://lore.kernel.org/all/20230322013731.102955-1-minipli@grsecurity.net
> Cc: David Matlack <dmatlack@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 80 +++++++++++++-------------------------
>  1 file changed, 28 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b2fca11b91ff..343deccab511 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -40,7 +40,17 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
>  
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  {
> -	/* Also waits for any queued work items.  */
> +	/*
> +	 * Invalidate all roots, which besides the obvious, schedules all roots
> +	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
> +	 * ultimately frees all roots.
> +	 */
> +	kvm_tdp_mmu_invalidate_all_roots(kvm);
> +
> +	/*
> +	 * Destroying a workqueue also first flushes the workqueue, i.e. no
> +	 * need to invoke kvm_tdp_mmu_zap_invalidated_roots().
> +	 */
>  	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
>  
>  	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
> @@ -116,16 +126,6 @@ static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root
>  	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
>  }
>  
> -static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
> -{
> -	union kvm_mmu_page_role role = page->role;
> -	role.invalid = true;
> -
> -	/* No need to use cmpxchg, only the invalid bit can change.  */
> -	role.word = xchg(&page->role.word, role.word);
> -	return role.invalid;
> -}
> -
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  			  bool shared)
>  {
> @@ -134,45 +134,12 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
>  		return;
>  
> -	WARN_ON(!is_tdp_mmu_page(root));
> -
>  	/*
> -	 * The root now has refcount=0.  It is valid, but readers already
> -	 * cannot acquire a reference to it because kvm_tdp_mmu_get_root()
> -	 * rejects it.  This remains true for the rest of the execution
> -	 * of this function, because readers visit valid roots only
> -	 * (except for tdp_mmu_zap_root_work(), which however
> -	 * does not acquire any reference itself).
> -	 *
> -	 * Even though there are flows that need to visit all roots for
> -	 * correctness, they all take mmu_lock for write, so they cannot yet
> -	 * run concurrently. The same is true after kvm_tdp_root_mark_invalid,
> -	 * since the root still has refcount=0.
> -	 *
> -	 * However, tdp_mmu_zap_root can yield, and writers do not expect to
> -	 * see refcount=0 (see for example kvm_tdp_mmu_invalidate_all_roots()).
> -	 * So the root temporarily gets an extra reference, going to refcount=1
> -	 * while staying invalid.  Readers still cannot acquire any reference;
> -	 * but writers are now allowed to run if tdp_mmu_zap_root yields and
> -	 * they might take an extra reference if they themselves yield.
> -	 * Therefore, when the reference is given back by the worker,
> -	 * there is no guarantee that the refcount is still 1.  If not, whoever
> -	 * puts the last reference will free the page, but they will not have to
> -	 * zap the root because a root cannot go from invalid to valid.
> +	 * The TDP MMU itself holds a reference to each root until the root is
> +	 * explicitly invalidated, i.e. the final reference should be never be
> +	 * put for a valid root.
>  	 */
> -	if (!kvm_tdp_root_mark_invalid(root)) {
> -		refcount_set(&root->tdp_mmu_root_count, 1);
> -
> -		/*
> -		 * Zapping the root in a worker is not just "nice to have";
> -		 * it is required because kvm_tdp_mmu_invalidate_all_roots()
> -		 * skips already-invalid roots.  If kvm_tdp_mmu_put_root() did
> -		 * not add the root to the workqueue, kvm_tdp_mmu_zap_all_fast()
> -		 * might return with some roots not zapped yet.
> -		 */
> -		tdp_mmu_schedule_zap_root(kvm, root);
> -		return;
> -	}
> +	KVM_BUG_ON(!is_tdp_mmu_page(root) || !root->role.invalid, kvm);
>  
>  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	list_del_rcu(&root->link);
> @@ -320,7 +287,14 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  	root = tdp_mmu_alloc_sp(vcpu);
>  	tdp_mmu_init_sp(root, NULL, 0, role);
>  
> -	refcount_set(&root->tdp_mmu_root_count, 1);
> +	/*
> +	 * TDP MMU roots are kept until they are explicitly invalidated, either
> +	 * by a memslot update or by the destruction of the VM.  Initialize the
> +	 * refcount to two; one reference for the vCPU, and one reference for
> +	 * the TDP MMU itself, which is held until the root is invalidated and
> +	 * is ultimately put by tdp_mmu_zap_root_work().
> +	 */
> +	refcount_set(&root->tdp_mmu_root_count, 2);
>  
>  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
> @@ -964,10 +938,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
>  {
>  	struct kvm_mmu_page *root;
>  
> -	lockdep_assert_held_write(&kvm->mmu_lock);
> +	/* No need to hold mmu_lock when the VM is being destroyed. */
> +	if (refcount_read(&kvm->users_count))
> +		lockdep_assert_held_write(&kvm->mmu_lock);
> +
>  	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> -		if (!root->role.invalid &&
> -		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
> +		if (!root->role.invalid) {
>  			root->role.invalid = true;
>  			tdp_mmu_schedule_zap_root(kvm, root);
>  		}
> 
> base-commit: 62cf1e941a1169a5e8016fd8683d4d888ab51e01

Thank you, I just tested this and it works wonderfully! Is this still on time for 6.3?
In case you need it:

Tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>

I'd also like to get this backported all the way back to 5.15 because the issue is
already present there. I tried it myself, but this was before async zap and i'm
doing something wrong with refcounts:

I tried:

kvm_mmu_uninit_tdp_mmu()
{
       kvm_tdp_mmu_invalidate_all_roots(kvm);
       kvm_tdp_mmu_zap_invalidated_roots(kvm);
}

and dropping the refcount_inc_not_zero() from kvm_tdp_mmu_invalidate_all_roots(),
but I hit:

[   56.163528] refcount_t: underflow; use-after-free.
[   56.163533] WARNING: CPU: 4 PID: 1137 at lib/refcount.c:28 refcount_warn_saturate+0x9f/0x150
[   56.163539] Modules linked in: xt_owner xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 tls cfg80211 binfmt_misc nls_iso8859_1 xt_tcpudp nft_compat nf_tables libcrc32c nfnetlink kvm_amd ccp kvm hyperv_drm drm_kms_helper crct10dif_pclmul joydev crc32_pclmul ghash_clmulni_intel hid_generic cec rc_core aesni_intel fb_sys_fops syscopyarea crypto_simd hid_hyperv sysfillrect serio_raw cryptd hyperv_keyboard sysimgblt hv_netvsc hid hyperv_fb mac_hid pata_acpi dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua ramoops reed_solomon drm efi_pstore i2c_core ip_tables x_tables autofs4
[   56.163568] CPU: 4 PID: 1137 Comm: qemu-system-x86 Not tainted 5.15.107-00003-g2ee068e4a996 #1
[   56.163570] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090008  12/07/2018
[   56.163572] RIP: 0010:refcount_warn_saturate+0x9f/0x150
[   56.163574] Code: cc cc 0f b6 1d d3 4a 9a 01 80 fb 01 0f 87 3f d1 69 00 83 e3 01 75 e1 48 c7 c7 e8 59 bd a3 c6 05 b7 4a 9a 01 01 e8 df 2b 66 00 <0f> 0b eb ca 0f b6 1d aa 4a 9a 01 80 fb 01 0f 87 ff d0 69 00 83 e3
[   56.163575] RSP: 0018:ffffbefb853f3c60 EFLAGS: 00010282
[   56.163577] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000027
[   56.163578] RDX: ffffa00dffb1f6c8 RSI: 0000000000000001 RDI: ffffa00dffb1f6c0
[   56.163579] RBP: ffffbefb853f3c68 R08: 0000000000000000 R09: ffffbefb853f3bf0
[   56.163579] R10: 00000000ffffe245 R11: 0000000000000246 R12: ffff9ffe43c37590
[   56.163580] R13: ffffbefb854f5000 R14: 0000000000000001 R15: ffffffffffffffff
[   56.163583] FS:  00007f389bcfc6c0(0000) GS:ffffa00dffb00000(0000) knlGS:0000000000000000
[   56.163585] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   56.163585] CR2: 00007f378c030000 CR3: 0000000101c60001 CR4: 0000000000370ee0
[   56.163586] Call Trace:
[   56.163588]  <TASK>
[   56.163590]  kvm_tdp_mmu_put_root+0x11b/0x140 [kvm]
[   56.163622]  mmu_free_root_page+0x9a/0xd0 [kvm]
[   56.163646]  kvm_mmu_free_roots+0x149/0x1e0 [kvm]
[   56.163666]  kvm_mmu_unload+0x20/0x70 [kvm]
[   56.163686]  kvm_arch_vcpu_ioctl_run+0x9da/0x1750 [kvm]
[   56.163709]  ? kvm_vm_ioctl+0x393/0x1120 [kvm]
[   56.163729]  ? kvm_vm_ioctl+0x393/0x1120 [kvm]
[   56.163748]  kvm_vcpu_ioctl+0x2d7/0x7b0 [kvm]
[   56.163767]  ? __fget_files+0x83/0xb0
[   56.163770]  ? __fget_files+0x83/0xb0
[   56.163772]  __x64_sys_ioctl+0x98/0xd0
[   56.163774]  do_syscall_64+0x5b/0x80
[   56.163776]  ? do_syscall_64+0x67/0x80
[   56.163777]  ? exc_page_fault+0x7c/0x150
[   56.163779]  entry_SYSCALL_64_after_hwframe+0x61/0xcb

which shouldn't be possible since we always hold 2 refs.

Jeremi
