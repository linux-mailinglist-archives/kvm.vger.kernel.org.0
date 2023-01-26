Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A1367D0A9
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 16:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjAZPwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 10:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjAZPwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 10:52:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC40D18B21;
        Thu, 26 Jan 2023 07:52:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75239B81E71;
        Thu, 26 Jan 2023 15:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A5BC433EF;
        Thu, 26 Jan 2023 15:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674748331;
        bh=yFurdQ49Rwg7DtLtaZO+JINMiMVB0Y/m+VJMrTYHJig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jMqratgawpE5kzKHmFEROGiUHVB7feJuizAJ2W+sb+6BFBA1zGKoBDwEhy3iU6Mj0
         9OU2WcyyCbz1I1lf7CGvz+q1fvGdjHi3oURYIL1SGj9SN3ZOswrWczBahC9TvYD9Ku
         YGjoFlU3hVPoc3OCjSqA8iA+Xscmtakkd6xtF6TlByT2bXua4ycUUBzhPMsAuq3gVg
         pAxxSboFLXmPetMBtr5i/3ZJsxeqrag3Z0U4ZgGgeq8nR5mdxSzI44P3+3pgzVxqDz
         7BIBBaZpyOZfensdpdMh6/bVDLkT+qpivjs3fSLAxpPn6ebtSso21jr1vfCJlS1OHA
         PDDxDwCTTGB0A==
Date:   Thu, 26 Jan 2023 15:52:08 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tom Dohrmann <erbse.13@gmx.de>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com
Subject: Re: [PATCH RFC v7 06/64] KVM: x86: Add platform hooks for private
 memory invalidations
Message-ID: <Y9KhqGQlxllAZsKd@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-7-michael.roth@amd.com>
 <Y80vhKwQyw8hS/22@notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y80vhKwQyw8hS/22@notebook>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 22, 2023 at 01:43:48PM +0100, Tom Dohrmann wrote:
> On Wed, Dec 14, 2022 at 01:39:58PM -0600, Michael Roth wrote:
> > In some cases, like with SEV-SNP, guest memory needs to be updated in a
> > platform-specific manner before it can be safely freed back to the host.
> > Add hooks to wire up handling of this sort to the invalidation notifiers
> > for restricted memory.
> >=20
> > Also issue invalidations of all allocated pages during notifier
> > unregistration so that the pages are not left in an unusable state when
> > they eventually get freed back to the host upon FD release.
> >=20
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >  arch/x86/include/asm/kvm_host.h    |  1 +
> >  arch/x86/kvm/mmu/mmu.c             |  5 +++++
> >  include/linux/kvm_host.h           |  2 ++
> >  mm/restrictedmem.c                 | 16 ++++++++++++++++
> >  virt/kvm/kvm_main.c                |  5 +++++
> >  6 files changed, 30 insertions(+)
> >=20
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/=
kvm-x86-ops.h
> > index 52f94a0ba5e9..c71df44b0f02 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -134,6 +134,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_rea=
sons);
> >  KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
> >  KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
> >  KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
> > +KVM_X86_OP_OPTIONAL(invalidate_restricted_mem)
> > =20
> >  #undef KVM_X86_OP
> >  #undef KVM_X86_OP_OPTIONAL
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 13802389f0f9..9ef8d73455d9 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1639,6 +1639,7 @@ struct kvm_x86_ops {
> >  	int (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, b=
ool *private_fault);
> >  	int (*update_mem_attr)(struct kvm_memory_slot *slot, unsigned int att=
r,
> >  			       gfn_t start, gfn_t end);
> > +	void (*invalidate_restricted_mem)(struct kvm_memory_slot *slot, gfn_t=
 start, gfn_t end);
> > =20
> >  	bool (*has_wbinvd_exit)(void);
> > =20
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a0c41d391547..2713632e5061 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -7183,3 +7183,8 @@ void kvm_arch_set_memory_attributes(struct kvm *k=
vm,
> >  		kvm_update_lpage_private_shared_mixed(kvm, slot, attrs,
> >  						      start, end);
> >  }
> > +
> > +void kvm_arch_invalidate_restricted_mem(struct kvm_memory_slot *slot, =
gfn_t start, gfn_t end)
> > +{
> > +	static_call_cond(kvm_x86_invalidate_restricted_mem)(slot, start, end);
> > +}
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f032d878e034..f72a2e0b8699 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2327,6 +2327,7 @@ void kvm_arch_set_memory_attributes(struct kvm *k=
vm,
> >  				    struct kvm_memory_slot *slot,
> >  				    unsigned long attrs,
> >  				    gfn_t start, gfn_t end);
> > +
> >  #else
> >  static inline void kvm_arch_set_memory_attributes(struct kvm *kvm,
> >  						  struct kvm_memory_slot *slot,
> > @@ -2366,6 +2367,7 @@ static inline int kvm_restricted_mem_get_pfn(stru=
ct kvm_memory_slot *slot,
> >  }
> > =20
> >  void kvm_arch_memory_mce(struct kvm *kvm);
> > +void kvm_arch_invalidate_restricted_mem(struct kvm_memory_slot *slot, =
gfn_t start, gfn_t end);
> >  #endif /* CONFIG_HAVE_KVM_RESTRICTED_MEM */
> > =20
> >  #endif
> > diff --git a/mm/restrictedmem.c b/mm/restrictedmem.c
> > index 56953c204e5c..74fa2cfb8618 100644
> > --- a/mm/restrictedmem.c
> > +++ b/mm/restrictedmem.c
> > @@ -54,6 +54,11 @@ static int restrictedmem_release(struct inode *inode=
, struct file *file)
> >  {
> >  	struct restrictedmem_data *data =3D inode->i_mapping->private_data;
> > =20
> > +	pr_debug("%s: releasing memfd, invalidating page offsets 0x0-0x%llx\n=
",
> > +		 __func__, inode->i_size >> PAGE_SHIFT);
> > +	restrictedmem_invalidate_start(data, 0, inode->i_size >> PAGE_SHIFT);
> > +	restrictedmem_invalidate_end(data, 0, inode->i_size >> PAGE_SHIFT);
> > +
> >  	fput(data->memfd);
> >  	kfree(data);
> >  	return 0;
> > @@ -258,6 +263,17 @@ void restrictedmem_unregister_notifier(struct file=
 *file,
> >  				       struct restrictedmem_notifier *notifier)
> >  {
> >  	struct restrictedmem_data *data =3D file->f_mapping->private_data;
> > +	struct inode *inode =3D file_inode(data->memfd);
> > +
> > +	/* TODO: this will issue notifications to all registered notifiers,
> > +	 * but it's only the one being unregistered that needs to process
> > +	 * invalidations for any ranges still allocated at this point in
> > +	 * time. For now this relies on KVM currently being the only notifier.
> > +	 */
> > +	pr_debug("%s: unregistering notifier, invalidating page offsets 0x0-0=
x%llx\n",
> > +		 __func__, inode->i_size >> PAGE_SHIFT);
> > +	restrictedmem_invalidate_start(data, 0, inode->i_size >> PAGE_SHIFT);
> > +	restrictedmem_invalidate_end(data, 0, inode->i_size >> PAGE_SHIFT);
> > =20
> >  	mutex_lock(&data->lock);
> >  	list_del(&notifier->list);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d2d829d23442..d2daa049e94a 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -974,6 +974,9 @@ static void kvm_restrictedmem_invalidate_begin(stru=
ct restrictedmem_notifier *no
> >  					  &gfn_start, &gfn_end))
> >  		return;
> > =20
> > +	pr_debug("%s: start: 0x%lx, end: 0x%lx, roffset: 0x%llx, gfn_start: 0=
x%llx, gfn_end: 0x%llx\n",
> > +		 __func__, start, end, slot->restricted_offset, gfn_start, gfn_end);
> > +
> >  	gfn_range.start =3D gfn_start;
> >  	gfn_range.end =3D gfn_end;
> >  	gfn_range.slot =3D slot;
> > @@ -988,6 +991,8 @@ static void kvm_restrictedmem_invalidate_begin(stru=
ct restrictedmem_notifier *no
> >  	if (kvm_unmap_gfn_range(kvm, &gfn_range))
> >  		kvm_flush_remote_tlbs(kvm);
> > =20
> > +	kvm_arch_invalidate_restricted_mem(slot, gfn_start, gfn_end);
>=20
> Calling kvm_arch_invalidate_restricted_mem while the KVM MMU lock is taken
> causes problems, because taking said lock disables preemption. Within=20
> kvm_arch_invalidate_restricted_mem a few calls down, eventually
> vm_unmap_aliases is called which tries to lock a mutex, which shouldn't h=
appen
> with preemption disabled. This causes a "scheduling while atomic" bug:
>=20
> [  152.846596] BUG: scheduling while atomic: enarx/8302/0x00000002
> [  152.846599] Modules linked in: nf_conntrack_netlink(E) xfrm_user(E) xf=
rm_algo(E) xt_addrtype(E) br_netfilter(E) xt_CHECKSUM(E) xt_MASQUERADE(E) x=
t_conntrack(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_tcpudp(E) nft_compat(E) n=
ft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(=
E) nf_tables(E) libcrc32c(E) nfnetlink(E) bridge(E) stp(E) llc(E) bonding(E=
) intel_rapl_msr(E) intel_rapl_common(E) amd64_edac(E) edac_mce_amd(E) kvm_=
amd(E) tun(E) ipmi_ssif(E) rfkill(E) overlay(E) ghash_clmulni_intel(E) sha5=
12_ssse3(E) sha512_generic(E) aesni_intel(E) libaes(E) crypto_simd(E) crypt=
d(E) rapl(E) wmi_bmof(E) binfmt_misc(E) kvm(E) irqbypass(E) nls_ascii(E) nl=
s_cp437(E) vfat(E) fat(E) snd_usb_audio(E) snd_usbmidi_lib(E) snd_hwdep(E) =
mc(E) snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E) snd_s=
eq(E) ast(E) snd_seq_device(E) drm_vram_helper(E) drm_ttm_helper(E) snd_tim=
er(E) ttm(E) joydev(E) snd(E) ccp(E) drm_kms_helper(E) soundcore(E) sg(E) i=
2c_algo_bit(E) rng_core(E)
> [  152.846629]  k10temp(E) evdev(E) acpi_ipmi(E) ipmi_si(E) ipmi_devintf(=
E) ipmi_msghandler(E) acpi_cpufreq(E) button(E) squashfs(E) loop(E) sch_fq_=
codel(E) msr(E) parport_pc(E) ppdev(E) lp(E) ramoops(E) parport(E) reed_sol=
omon(E) fuse(E) drm(E) efi_pstore(E) configfs(E) efivarfs(E) ip_tables(E) x=
_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E) mbcache(E) jbd2(E)=
 rndis_host(E) cdc_ether(E) usbnet(E) mii(E) hid_generic(E) usbhid(E) hid(E=
) sd_mod(E) t10_pi(E) crc64_rocksoft(E) crc64(E) crc_t10dif(E) crct10dif_ge=
neric(E) crct10dif_pclmul(E) crct10dif_common(E) crc32_pclmul(E) crc32c_int=
el(E) ahci(E) libahci(E) xhci_pci(E) libata(E) bnxt_en(E) xhci_hcd(E) scsi_=
mod(E) ptp(E) scsi_common(E) pps_core(E) usbcore(E) i2c_piix4(E) usb_common=
(E) wmi(E)
> [  152.846657] Preemption disabled at:
> [  152.846657] [<ffffffffc146a09a>] kvm_restrictedmem_invalidate_begin+0x=
ba/0x1c0 [kvm]
> [  152.846688] CPU: 108 PID: 8302 Comm: enarx Tainted: G        W   E    =
  6.1.0-rc4+ #30
> [  152.846690] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.4=
 04/14/2022
> [  152.846691] Call Trace:
> [  152.846692]  <TASK>
> [  152.846694]  dump_stack_lvl+0x49/0x63
> [  152.846695]  ? kvm_restrictedmem_invalidate_begin+0xba/0x1c0 [kvm]
> [  152.846723]  dump_stack+0x10/0x16
> [  152.846725]  __schedule_bug.cold+0x81/0x92
> [  152.846727]  __schedule+0x809/0xa00
> [  152.846729]  ? asm_sysvec_call_function+0x1b/0x20
> [  152.846731]  schedule+0x6b/0xf0
> [  152.846733]  schedule_preempt_disabled+0x18/0x30
> [  152.846735]  __mutex_lock.constprop.0+0x723/0x750
> [  152.846738]  ? smp_call_function_many_cond+0xc1/0x2e0
> [  152.846740]  __mutex_lock_slowpath+0x13/0x20
> [  152.846742]  mutex_lock+0x49/0x60
> [  152.846744]  _vm_unmap_aliases+0x10e/0x160
> [  152.846746]  vm_unmap_aliases+0x19/0x20
> [  152.846748]  change_page_attr_set_clr+0xb7/0x1c0
> [  152.846751]  set_memory_p+0x29/0x30
> [  152.846753]  rmpupdate+0xd5/0x110
> [  152.846756]  rmp_make_shared+0xb7/0xc0
> [  152.846758]  snp_make_page_shared.constprop.0+0x4c/0x90 [kvm_amd]
> [  152.846765]  sev_invalidate_private_range+0x156/0x330 [kvm_amd]
> [  152.846770]  ? kvm_unmap_gfn_range+0xef/0x100 [kvm]
> [  152.846801]  kvm_arch_invalidate_restricted_mem+0xe/0x20 [kvm]
> [  152.846829]  kvm_restrictedmem_invalidate_begin+0x106/0x1c0 [kvm]
> [  152.846856]  restrictedmem_unregister_notifier+0x74/0x150
> [  152.846859]  kvm_free_memslot+0x6b/0x80 [kvm]
> [  152.846885]  kvm_free_memslots.part.0+0x47/0x70 [kvm]
> [  152.846911]  kvm_destroy_vm+0x222/0x320 [kvm]
> [  152.846937]  kvm_put_kvm+0x2a/0x50 [kvm]
> [  152.846964]  kvm_vm_release+0x22/0x30 [kvm]
> [  152.846990]  __fput+0xa8/0x280
> [  152.846992]  ____fput+0xe/0x20
> [  152.846994]  task_work_run+0x61/0xb0
> [  152.846996]  do_exit+0x362/0xb30
> [  152.846998]  ? tomoyo_path_number_perm+0x6f/0x200
> [  152.847001]  do_group_exit+0x38/0xa0
> [  152.847003]  get_signal+0x999/0x9c0
> [  152.847005]  arch_do_signal_or_restart+0x37/0x7e0
> [  152.847008]  ? __might_fault+0x26/0x30
> [  152.847010]  ? __rseq_handle_notify_resume+0xd5/0x4f0
> [  152.847013]  exit_to_user_mode_prepare+0xd3/0x170
> [  152.847016]  syscall_exit_to_user_mode+0x26/0x50
> [  152.847019]  do_syscall_64+0x48/0x90
> [  152.847020]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  152.847022] RIP: 0033:0x7fa345f1aaff
> [  152.847023] Code: Unable to access opcode bytes at 0x7fa345f1aad5.
> [  152.847024] RSP: 002b:00007fff99d6c050 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
> [  152.847026] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00007fa34=
5f1aaff
> [  152.847027] RDX: 00007fff99d6c188 RSI: 00000000c008aeba RDI: 000000000=
0000006
> [  152.847028] RBP: 00007fff99576000 R08: 0000000000000000 R09: 000000000=
0000000
> [  152.847029] R10: 0000000001680000 R11: 0000000000000246 R12: 00007fff9=
9d752c0
> [  152.847030] R13: 00007fff99d75270 R14: 0000000000000000 R15: 00007fff9=
9577000
> [  152.847032]  </TASK>
>=20
> This bug can be triggered by destroying multiple SNP VMs at the same time.

I can also reproduce this one.

If I do "cargo test -- --test-threads=3D1", then this does not happen.

Even then I get this:

[  232.054359] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  232.061466] ------------[ cut here ]------------
[  232.061467] WARNING: CPU: 18 PID: 2436 at arch/x86/kvm/../../../virt/kvm=
/kvm_main.c:3665 mark_page_dirty_in_slot+0x99/0xd0
[  232.061472] Modules linked in: af_packet irdma intel_rapl_msr i40e ib_uv=
erbs ib_core dell_smbios wmi_bmof dell_wmi_descriptor evdev mac_hid dcdbas =
amd64_edac edac_mce_amd edac_core intel_rapl_common crc32_pclmul polyval_cl=
mulni polyval_generic gf128mul ghash_clmulni_intel sha512_ssse3 sha512_gene=
ric aesni_intel libaes crypto_simd cryptd rapl deflate efi_pstore bonding t=
ls cfg80211 rfkill ip6_tables xt_conntrack nf_conntrack nf_defrag_ipv6 nf_d=
efrag_ipv4 xt_tcpudp ip6t_rpfilter ipt_rpfilter xt_pkttype nft_compat nf_ta=
bles libcrc32c sch_fq_codel nfnetlink atkbd libps2 serio vivaldi_fmap loop =
tun tap macvlan bridge stp llc ipmi_ssif ipmi_watchdog dm_round_robin dm_mu=
ltipath kvm_amd mgag200 drm_shmem_helper drm_kms_helper i2c_algo_bit fb_sys=
_fops syscopyarea sysfillrect sysimgblt ice ptp pps_core sp5100_tco watchdo=
g k10temp i2c_piix4 ptdma virt_dma hed tpm_crb wmi acpi_ipmi ipmi_si ipmi_d=
evintf ipmi_msghandler tpm_tis tpm_tis_core tpm acpi_power_meter nls_iso885=
9_1 nls_cp437 vfat fat
[  232.061525]  tiny_power_button button ccp rng_core drm pstore fuse backl=
ight i2c_core configfs efivarfs ip_tables x_tables autofs4 ext4 crc32c_gene=
ric crc16 mbcache jbd2 sd_mod ahci libahci xhci_pci xhci_pci_renesas libata=
 xhci_hcd nvme nvme_core scsi_mod usbcore t10_pi crc32c_intel crc64_rocksof=
t crc64 crc_t10dif scsi_common crct10dif_generic crct10dif_pclmul crct10dif=
_common usb_common rtc_cmos dm_mod dax
[  232.061547] CPU: 18 PID: 2436 Comm: enarx Not tainted 6.1.0-rc4 #1-NixOS
[  232.061549] Hardware name: Dell Inc. PowerEdge R6515/068NXX, BIOS 2.6.6 =
01/13/2022
[  232.061550] RIP: 0010:mark_page_dirty_in_slot+0x99/0xd0
[  232.061552] Code: 83 04 01 00 00 4c 2b a3 b0 00 00 00 85 d2 74 27 c1 e6 =
10 5b 49 8d bd f8 19 00 00 5d 4c 89 e2 09 c6 41 5c 41 5d e9 07 aa 00 00 <0f=
> 0b 5b 5d 41 5c 41 5d c3 cc cc cc cc 48 8b 83 c0 00 00 00 49 63
[  232.061553] RSP: 0018:ffffc169265978f0 EFLAGS: 00010246
[  232.061555] RAX: 0000000080000000 RBX: ffffa0c045c49600 RCX: 00000000000=
00000
[  232.061556] RDX: 0000000000000001 RSI: ffffffff92d076bd RDI: 00000000fff=
fffff
[  232.061557] RBP: ffffc1692177d000 R08: 0000000000000001 R09: 00000000000=
01000
[  232.061557] R10: 0000000000000001 R11: 0000000000000001 R12: 00000000000=
ffe02
[  232.061558] R13: 0000000000000000 R14: ffffc1692177d000 R15: 00007f6cacf=
89000
[  232.061559] FS:  00007f6cacfc3540(0000) GS:ffffa0cfffa80000(0000) knlGS:=
0000000000000000
[  232.061560] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  232.061561] CR2: 00007f6cacf89020 CR3: 000000208c9c6005 CR4: 00000000007=
70ee0
[  232.061561] PKRU: 55555554
[  232.061562] Call Trace:
[  232.061563]  <TASK>
[  232.061566]  __kvm_write_guest_page+0xac/0xf0
[  232.061569]  snp_launch_update_gfn_handler.cold+0x5e/0xfe [kvm_amd]
[  232.061578]  kvm_vm_do_hva_range_op+0x142/0x1c0
[  232.061579]  ? sev_launch_update_gfn_handler+0x470/0x470 [kvm_amd]
[  232.061585]  sev_mem_enc_ioctl+0x4dd/0x1270 [kvm_amd]
[  232.061591]  ? sev_pin_memory+0x159/0x1a0 [kvm_amd]
[  232.061595]  ? sev_mem_enc_register_region+0xe3/0x130 [kvm_amd]
[  232.061602]  kvm_arch_vm_ioctl+0x6a6/0xc20
[  232.061604]  ? __blk_flush_plug+0x102/0x160
[  232.061606]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  232.061609]  ? get_page_from_freelist+0x1451/0x15a0
[  232.061612]  ? __mod_node_page_state+0x7c/0xb0
[  232.061615]  ? try_charge_memcg+0x466/0x800
[  232.061618]  ? __mod_node_page_state+0x7c/0xb0
[  232.061619]  ? __mod_memcg_lruvec_state+0x6e/0xd0
[  232.061620]  kvm_vm_ioctl+0x7ba/0x1290
[  232.061622]  ? folio_add_lru+0x6e/0xa0
[  232.061624]  ? _raw_spin_unlock+0x15/0x30
[  232.061626]  ? __handle_mm_fault+0xace/0xc70
[  232.061629]  ? handle_mm_fault+0xb2/0x2a0
[  232.061630]  __x64_sys_ioctl+0x8a/0xc0
[  232.061634]  do_syscall_64+0x3b/0x90
[  232.061636]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  232.061638] RIP: 0033:0x7f6cad0c1e37
[  232.061659] Code: ff ff 48 89 d8 5b 5d 41 5c c3 66 0f 1f 84 00 00 00 00 =
00 48 89 e8 48 f7 d8 48 39 c3 0f 92 c0 eb c9 66 90 b8 10 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b1 0f 0f 00 f7 d8 64 89 01 48
[  232.061660] RSP: 002b:00007ffee9081668 EFLAGS: 00000216 ORIG_RAX: 000000=
0000000010
[  232.061661] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f6cad0=
c1e37
[  232.061662] RDX: 00007ffee9081748 RSI: 00000000c008aeba RDI: 00000000000=
00004
[  232.061663] RBP: 00007ffee888e000 R08: 0000000000000006 R09: 00000000000=
00000
[  232.061663] R10: 0000000000001000 R11: 0000000000000216 R12: 00007ffee90=
8a260
[  232.061664] R13: 00007ffee908a210 R14: 0000000000000000 R15: 00007ffee88=
8f000
[  232.061665]  </TASK>
[  232.061666] ---[ end trace 0000000000000000 ]---
[  232.759176] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  233.449477] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  235.284941] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  237.129469] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  237.978020] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  239.034002] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  239.598148] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  240.152122] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  240.718185] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  241.271235] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  241.836286] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  242.390345] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  242.962499] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  243.501430] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16
[  244.093547] SEV-SNP launch update failed, ret: 0xfffffffb, fw_error: 0x16

There is no cumulative klog output, i.e. only first run of cargo test emits=
 this.
Also software runs without issues, including attestation and everything.

BR, Jarkko
