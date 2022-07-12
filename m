Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8335710F9
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 05:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiGLDrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 23:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiGLDrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 23:47:47 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCDB82448;
        Mon, 11 Jul 2022 20:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657597667; x=1689133667;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CUHfPyamTKn4Uo97gZxQSxsd7TrBFnv30gLHQV6TPRs=;
  b=b7lUzwKRM9w52qwVcZipAFdxhoeUflI4QwMPDSSz74JFisJH7JgaCrSW
   uq4NaM/kdvBaLvf/IaSpALWPvrEKGzwnBAtYkq5gIFKAJdLxytunKAuoc
   NpEWtNbFrf9MoY7caOFpT2H6L6KQlUBPiv+9uyc0k5Ous+r5QQlP8KiGR
   2Ji4PgcY3U0B8v4lxq/z4Bj+JFYAhqyWcPCMQCkjn5cXTWAYACwpHET0r
   aPFw62Z4uav5yCTrHChlvyrxiotEZHMiWP6VnRaHPsgNeC8Qs1UAcB5xh
   nAqOMsVNKR5eHSkrQJdwgv3c3vXMsiYwQNmsvcWNoZKjxPYINMRhfYHxU
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="348807717"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="348807717"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 20:47:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="652736798"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 11 Jul 2022 20:47:44 -0700
Date:   Tue, 12 Jul 2022 11:47:43 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 053/102] KVM: TDX: don't request
 KVM_REQ_APIC_PAGE_RELOAD
Message-ID: <20220712034743.glrfvpx54ja6jrzg@yy-desk-7060>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <bcdcc4175321ff570a198aa55f8ac035de2add1f.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcdcc4175321ff570a198aa55f8ac035de2add1f.1656366338.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 02:53:45PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX doesn't need APIC page depending on vapic and its callback is
> WARN_ON_ONCE(is_tdx).  To avoid unnecessary overhead and WARN_ON_ONCE(),
> skip requesting KVM_REQ_APIC_PAGE_RELOAD when TD.
>
>   ------------[ cut here ]------------
>   WARNING: CPU: 134 PID: 42205 at arch/x86/kvm/vmx/main.c:696 vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
>   Modules linked in: squashfs nls_iso8859_1 nls_cp437 vhost_vsock vhost vhost_iotlb tdx_debug kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd i2c_i801 i2c_smbus i2c_ismt
>   CPU: 134 PID: 42205 Comm: tdx_vm_tests Tainted: G        W         5.17.0-rc8 #165 4baba67c36c7c1001d782c47f2964b779a5659c7
>   Hardware name: Intel Corporation EAGLESTREAM/EAGLESTREAM, BIOS EGSDCRB1.SYS.0066.D24.2110072326 10/07/2021
>   RIP: 0010:vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
>   Code: e7 d5 49 8b 1c 24 48 8d bb 78 15 00 00 e8 4c 78 e7 d5 48 83 bb 78 15 00 00 01 74 0d 4c 89 e7 e8 7a 9b fd ff 5b 41 5c 5d c3 90 <0f  0b 90 5b 41 5c 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f
>   RSP: 0018:ffa0000027477b68 EFLAGS: 00010246
>   RAX: 0000000000000000 RBX: ffa00000572d9000 RCX: ffffffffde6864d4
>   RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffa00000572da578
>   RBP: ffa0000027477b78 R08: 0000000000000001 R09: ffe21c006df80008
>   R10: ff1100036fc0003f R11: ffe21c006df80007 R12: ff1100036fc00000
>   R13: ff1100036fc000d8 R14: ff1100036fc00038 R15: ff1100036fc00000
>   FS:  00007fdf1ad32740(0000) GS:ff11000e1ed00000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007fdf15f1b000 CR3: 000000011e462005 CR4: 0000000000773ee0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
>   PKRU: 55555554
>   Call Trace:
>    <TASK>
>    vcpu_enter_guest+0x145d/0x24d0 [kvm]
>    ? inject_pending_event+0x750/0x750 [kvm]
>    ? xsaves+0x31/0x40
>    ? rcu_read_lock_held_common+0x1e/0x60
>    ? rcu_read_lock_sched_held+0x60/0xe0
>    ? rcu_read_lock_bh_held+0xc0/0xc0
>    kvm_arch_vcpu_ioctl_run+0x25d/0xcc0 [kvm]
>    kvm_vcpu_ioctl+0x414/0xa30 [kvm]]
>    ? kvm_clear_dirty_log_protect+0x4d0/0x4d0 [kvm]
>    ? userfaultfd_unmap_prep+0x240/0x240
>    ? __up_read+0x17f/0x530
>    ? rwsem_wake+0x110/0x110
>    ? __do_munmap+0x437/0x7c0
>    ? rcu_read_lock_held_common+0x1e/0x60
>    ? rcu_read_lock_sched_held+0x60/0xe0
>    ? rcu_read_lock_sched_held+0x60/0xe0
>    ? __kasan_check_read+0x11/0x20
>    ? __fget_light+0xa9/0x100
>    __x64_sys_ioctl+0xc0/0x100
>    do_syscall_64+0x39/0xc0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>   RIP: 0033:0x7fdf1ae493db
>   Code: 0f 1e fa 48 8b 05 b5 7a 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48  3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 7a 0d 00 f7 d8 64 89 01 48
>   RSP: 002b:00007ffcf8bdfb38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>   RAX: ffffffffffffffda RBX: 00000000006f26d0 RCX: 00007fdf1ae493db
>   RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
>   RBP: 0000000000000000 R08: 0000000000411d36 R09: 0000000000000000
>   R10: fffffffffffffb69 R11: 0000000000000246 R12: 0000000000402410
>   R13: 00000000006f02b0 R14: 0000000000000000 R15: 0000000000000000
>    </TASK>
>   irq event stamp: 0
>   hardirqs last  enabled at (0): [<0000000000000000>] 0x0
>   hardirqs last disabled at (0): [<ffffffffb40c809a>] copy_process+0xaca/0x3270
>   softirqs last  enabled at (0): [<ffffffffb40c809a>] copy_process+0xaca/0x3270
>   softirqs last disabled at (0): [<0000000000000000>] 0x0
>   ---[ end trace 0000000000000000 ]---

The trace can be simplified to :

WARNING: arch/x86/kvm/vmx/main.c:696 vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
RIP: 0010:vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
Call Trace:
 vcpu_enter_guest+0x145d/0x24d0 [kvm]
 kvm_arch_vcpu_ioctl_run+0x25d/0xcc0 [kvm]
 kvm_vcpu_ioctl+0x414/0xa30 [kvm]]
 __x64_sys_ioctl+0xc0/0x100
 do_syscall_64+0x39/0xc0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Becasue here you just want to record the trace path of WARN_ON_ONCE(),
but not request some help for debugging it.

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8f57dfb2a8c9..c90ec611de2f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10042,7 +10042,8 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>  	 * Update it when it becomes invalid.
>  	 */
>  	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> -	if (start <= apic_address && apic_address < end)
> +	if (start <= apic_address && apic_address < end &&
> +	    !kvm_gfn_shared_mask(kvm))

Minor: please condier to check kvm_gfn_shared_mask(kvm) before range,
means firstly check is or not, then suitable or not.

>  		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
>  }
>
> --
> 2.25.1
>
