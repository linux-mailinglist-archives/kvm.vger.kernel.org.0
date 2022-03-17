Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B15C4DCCA9
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 18:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbiCQRo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 13:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiCQRo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 13:44:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A201A5EB9
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 10:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647538987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HoIVlewLLrWIsR3CrVpt5UiSdF0B/PRNFCUkdtGUUyU=;
        b=WBBg9J6CRBvHlljUN0Y478mvIegyL9bDCBb/zEcUdtQzzI7dGEib22VeQm8pfuWujbr0Z5
        KT/3WfrcHDFYbHvbdnvWkQuQlP6hSeylGXWzjjZUpr4BG8Fo2QRgbh/B4p8LMgBLJkizcK
        +UO66f6LKXYFPBoaQDWhrkfSMA+Hm1U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-IO-S2nZOOqufQhCzZaktug-1; Thu, 17 Mar 2022 13:43:05 -0400
X-MC-Unique: IO-S2nZOOqufQhCzZaktug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FAA51C05152;
        Thu, 17 Mar 2022 17:43:05 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBEC64029B6;
        Thu, 17 Mar 2022 17:43:03 +0000 (UTC)
Message-ID: <3bbe3f8717cdf122f909a48e117dab6c09d8e0c8.camel@redhat.com>
Subject: Re: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Thu, 17 Mar 2022 19:43:02 +0200
In-Reply-To: <20220217180831.288210-7-pbonzini@redhat.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
         <20220217180831.288210-7-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 13:08 -0500, Paolo Bonzini wrote:
> A few vendor callbacks are only used by VMX, but they return an integer
> or bool value.  Introduce KVM_X86_OP_OPTIONAL_RET0 for them: if a func is
> NULL in struct kvm_x86_ops, it will be changed to __static_call_return0
> when updating static calls.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 15 +++++++++------
>  arch/x86/include/asm/kvm_host.h    |  4 ++++
>  arch/x86/kvm/svm/avic.c            |  5 -----
>  arch/x86/kvm/svm/svm.c             | 20 --------------------
>  arch/x86/kvm/x86.c                 |  2 +-
>  kernel/static_call.c               |  1 +
>  6 files changed, 15 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index c0ec066a8599..29affccb353c 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -10,7 +10,9 @@ BUILD_BUG_ON(1)
>   *
>   * KVM_X86_OP_OPTIONAL() can be used for those functions that can have
>   * a NULL definition, for example if "static_call_cond()" will be used
> - * at the call sites.
> + * at the call sites.  KVM_X86_OP_OPTIONAL_RET0() can be used likewise
> + * to make a definition optional, but in this case the default will
> + * be __static_call_return0.
>   */
>  KVM_X86_OP(hardware_enable)
>  KVM_X86_OP(hardware_disable)
> @@ -77,15 +79,15 @@ KVM_X86_OP(check_apicv_inhibit_reasons)
>  KVM_X86_OP(refresh_apicv_exec_ctrl)
>  KVM_X86_OP_OPTIONAL(hwapic_irr_update)
>  KVM_X86_OP_OPTIONAL(hwapic_isr_update)
> -KVM_X86_OP_OPTIONAL(guest_apic_has_interrupt)
> +KVM_X86_OP_OPTIONAL_RET0(guest_apic_has_interrupt)
>  KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
>  KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
>  KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
>  KVM_X86_OP(deliver_interrupt)
>  KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
> -KVM_X86_OP(set_tss_addr)
> -KVM_X86_OP(set_identity_map_addr)
> -KVM_X86_OP(get_mt_mask)
> +KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
> +KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> +KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
> @@ -103,7 +105,7 @@ KVM_X86_OP_OPTIONAL(vcpu_unblocking)
>  KVM_X86_OP_OPTIONAL(pi_update_irte)
>  KVM_X86_OP_OPTIONAL(pi_start_assignment)
>  KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
> -KVM_X86_OP_OPTIONAL(dy_apicv_has_pending_interrupt)
> +KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
>  KVM_X86_OP_OPTIONAL(set_hv_timer)
>  KVM_X86_OP_OPTIONAL(cancel_hv_timer)
>  KVM_X86_OP(setup_mce)
> @@ -127,3 +129,4 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
>  
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> +#undef KVM_X86_OP_OPTIONAL_RET0
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a7e82fc1f1f3..8e512f25a930 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1541,6 +1541,7 @@ extern struct kvm_x86_ops kvm_x86_ops;
>  #define KVM_X86_OP(func) \
>  	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
>  #define KVM_X86_OP_OPTIONAL KVM_X86_OP
> +#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
>  #include <asm/kvm-x86-ops.h>
>  
>  static inline void kvm_ops_static_call_update(void)
> @@ -1550,6 +1551,9 @@ static inline void kvm_ops_static_call_update(void)
>  #define KVM_X86_OP(func) \
>  	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
>  #define KVM_X86_OP_OPTIONAL __KVM_X86_OP
> +#define KVM_X86_OP_OPTIONAL_RET0(func) \
> +	static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
> +			   (void *) __static_call_return0);
>  #include <asm/kvm-x86-ops.h>
>  #undef __KVM_X86_OP
>  }
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4245cb99b497..d4fa8c4f3a9a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -650,11 +650,6 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  	avic_set_pi_irte_mode(vcpu, activated);
>  }
>  
> -bool avic_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
> -{
> -	return false;
> -}
> -
>  static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
>  {
>  	unsigned long flags;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3daca34020fa..7038c76fa841 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3528,16 +3528,6 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>  }
>  
> -static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
> -{
> -	return 0;
> -}
> -
> -static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
> -{
> -	return 0;
> -}
> -
>  static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3934,11 +3924,6 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
>  	return true;
>  }
>  
> -static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> -{
> -	return 0;
> -}
> -
>  static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4593,10 +4578,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
>  	.apicv_post_state_restore = avic_apicv_post_state_restore,
>  
> -	.set_tss_addr = svm_set_tss_addr,
> -	.set_identity_map_addr = svm_set_identity_map_addr,
> -	.get_mt_mask = svm_get_mt_mask,
> -
>  	.get_exit_info = svm_get_exit_info,
>  
>  	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
> @@ -4621,7 +4602,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.nested_ops = &svm_nested_ops,
>  
>  	.deliver_interrupt = svm_deliver_interrupt,
> -	.dy_apicv_has_pending_interrupt = avic_dy_apicv_has_pending_interrupt,
>  	.pi_update_irte = avic_pi_update_irte,
>  	.setup_mce = svm_setup_mce,
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab1c4778824a..d3da64106685 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -131,6 +131,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
>  	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
>  				*(((struct kvm_x86_ops *)0)->func));
>  #define KVM_X86_OP_OPTIONAL KVM_X86_OP
> +#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
>  #include <asm/kvm-x86-ops.h>
>  EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
>  EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
> @@ -12016,7 +12017,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	return (is_guest_mode(vcpu) &&
> -			kvm_x86_ops.guest_apic_has_interrupt &&
>  			static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
>  }
>  
> diff --git a/kernel/static_call.c b/kernel/static_call.c
> index 43ba0b1e0edb..76abd46fe6ee 100644
> --- a/kernel/static_call.c
> +++ b/kernel/static_call.c
> @@ -503,6 +503,7 @@ long __static_call_return0(void)
>  {
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(__static_call_return0)
>  
>  #ifdef CONFIG_STATIC_CALL_SELFTEST
>  


Believe me or not, but this patch introduced a regression with 32 bit KVM.
(32 bit L1, 32 bit L2, 64 bit L0 since I am not crazy enough)

The following partial revert "fixes" it:


diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 20f64e07e359..3388072b2e3b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -88,7 +88,7 @@ KVM_X86_OP(deliver_interrupt)
 KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
 KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
-KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
+KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a09b4f1a18f6..0c09292b0611 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4057,6 +4057,11 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
        return true;
 }
 
+static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+       return 0;
+}
+
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
@@ -4718,6 +4723,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
        .check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
        .apicv_post_state_restore = avic_apicv_post_state_restore,
 
+       .get_mt_mask = svm_get_mt_mask,
        .get_exit_info = svm_get_exit_info,
 
        .vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,


I guess something with returning u64 made 32 compiler unhappy.

I suspect that __static_call_return0 returns long, which means it returns
32 bit value on 32 bit system.

Maybe we can make it return u64. I don't know if that will break something else though.

This is what is printed when trying to start a VM:


[   22.821817] ------------[ cut here ]------------
[   22.822751] spte = 0xfffffc4465825, level = 1, rsvd bits = 0xffff000000000000
[   22.822771] WARNING: CPU: 14 PID: 3245 at arch/x86/kvm/mmu/spte.c:182 make_spte+0x2d1/0x319 [kvm]
[   22.824452] Modules linked in: uinput kvm_amd(O) kvm(O) irqbypass xt_MASQUERADE xt_conntrack ipt_REJECT tun bridge iptable_mangle iptable_nat nf_nat ebtable_filter ebtables ip6table_filter
ip6_tables rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill sunrpc dm_mirror dm_region_hash dm_log snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec
snd_hwdep snd_hda_core snd_seq snd_seq_device joydev snd_pcm input_leds snd_timer snd crc32_pclmul pcspkr lpc_ich virtio_input mfd_core rtc_cmos button sch_fq_codel ext4 mbcache jbd2 hid_generic
virtio_gpu usbhid virtio_dma_buf hid drm_shmem_helper sd_mod t10_pi drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec virtio_net drm net_failover virtio_console i2c_core failover
virtio_scsi ahci libahci crc32c_intel xhci_pci libata xhci_hcd virtio_pci virtio virtio_pci_legacy_dev virtio_pci_modern_dev virtio_ring fuse ipv6 autofs4 [last unloaded: irqbypass]
[   22.832788] CPU: 14 PID: 3245 Comm: CPU 0/KVM Tainted: G           O      5.17.0-rc8.unstable #49
[   22.833681] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-24-g8f3e834 04/01/2014
[   22.834615] EIP: make_spte+0x2d1/0x319 [kvm]
[   22.835088] Code: 01 0f ac f9 07 83 e1 01 8d 0c 89 8d 54 0b ff ff b4 d0 8c 00 00 00 ff b4 d0 88 00 00 00 53 57 56 68 1c 07 9c f0 e8 49 43 c1 d0 <0f> 0b 83 c4 18 89 f0 83 e0 02 74 29 8b 45 e0 f6 80
84 00 00 00 01
[   22.836951] EAX: 00000041 EBX: 00000001 ECX: 00000027 EDX: ed41cd0c
[   22.837570] ESI: c4465825 EDI: 000fffff EBP: c5491bb8 ESP: c5491b74
[   22.838209] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010286
[   22.838914] CR0: 80050033 CR2: 00000000 CR3: 044e5400 CR4: 00350ef0
[   22.839533] Call Trace:
[   22.839788]  mmu_set_spte+0x152/0x319 [kvm]
[   22.840242]  direct_page_fault+0x487/0x510 [kvm]
[   22.840754]  ? kvm_mtrr_check_gfn_range_consistency+0x66/0xe0 [kvm]
[   22.841413]  kvm_tdp_page_fault+0x73/0x7b [kvm]
[   22.841908]  kvm_mmu_page_fault+0x3bb/0x6a6 [kvm]
[   22.842407]  ? timekeeping_get_ns+0x10/0x72
[   22.842849]  ? apic_find_highest_isr+0x24/0x2b [kvm]
[   22.843372]  ? __apic_update_ppr+0x2c/0x67 [kvm]
[   22.843871]  ? apic_update_ppr+0x23/0x57 [kvm]
[   22.844344]  ? kvm_lapic_set_tpr+0x28/0x2a [kvm]
[   22.844875]  npf_interception+0x89/0x91 [kvm_amd]
[   22.845348]  ? npf_interception+0x89/0x91 [kvm_amd]
[   22.845879]  svm_invoke_exit_handler+0x30/0xb6 [kvm_amd]
[   22.846410]  svm_handle_exit+0x17c/0x184 [kvm_amd]
[   22.846914]  kvm_arch_vcpu_ioctl_run+0x11e5/0x14a4 [kvm]
[   22.847478]  ? mod_objcg_state+0xf1/0x10a
[   22.847901]  kvm_vcpu_ioctl+0x16e/0x516 [kvm]
[   22.848365]  ? kvm_vcpu_ioctl+0x16e/0x516 [kvm]
[   22.848879]  ? try_to_wake_up+0x1a0/0x1c9
[   22.849299]  ? put_task_struct+0x15/0x23
[   22.849698]  ? wake_up_q+0x2e/0x39
[   22.850060]  ? __fget+0x1e/0x25
[   22.850377]  ? kvm_uevent_notify_change+0x19a/0x19a [kvm]
[   22.850976]  vfs_ioctl+0x1c/0x26
[   22.851308]  __ia32_sys_ioctl+0x735/0x767
[   22.851714]  ? __ia32_sys_futex_time32+0x125/0x145
[   22.852211]  ? exit_to_user_mode_prepare+0xe2/0x142
[   22.852701]  __do_fast_syscall_32+0x78/0x97
[   22.853149]  do_fast_syscall_32+0x29/0x5b
[   22.853549]  do_SYSENTER_32+0x15/0x17
[   22.853919]  entry_SYSENTER_32+0xa2/0xfb
[   22.854334] EIP: 0xa835c53d
[   22.854624] Code: c4 01 10 03 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00
cd 80 90 8d 76
[   22.856520] EAX: ffffffda EBX: 00000021 ECX: 0000ae80 EDX: 00000000
[   22.857195] ESI: 096509e0 EDI: 3acfeb40 EBP: 3acfcf48 ESP: 3acfcef8
[   22.857818] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000212
[   22.858503] ---[ end trace 0000000000000000 ]---
[   22.859768] get_mmio_spte: reserved bits set on MMU-present spte, addr 0xfffff000, hierarchy:
[   22.860631] ------ spte = 0x8913827 level = 2, rsvd bits = 0xffff000000000000
[   22.860633] ------ spte = 0xfffffc4465825 level = 1, rsvd bits = 0xffff000000000000
[   22.861357] ------------[ cut here ]------------
[   22.862590] WARNING: CPU: 14 PID: 3245 at arch/x86/kvm/mmu/mmu.c:3812 kvm_mmu_page_fault+0x2ad/0x6a6 [kvm]
[   22.863620] Modules linked in: uinput kvm_amd(O) kvm(O) irqbypass xt_MASQUERADE xt_conntrack ipt_REJECT tun bridge iptable_mangle iptable_nat nf_nat ebtable_filter ebtables ip6table_filter
ip6_tables rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill sunrpc dm_mirror dm_region_hash dm_log snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec
snd_hwdep snd_hda_core snd_seq snd_seq_device joydev snd_pcm input_leds snd_timer snd crc32_pclmul pcspkr lpc_ich virtio_input mfd_core rtc_cmos button sch_fq_codel ext4 mbcache jbd2 hid_generic
virtio_gpu usbhid virtio_dma_buf hid drm_shmem_helper sd_mod t10_pi drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec virtio_net drm net_failover virtio_console i2c_core failover
virtio_scsi ahci libahci crc32c_intel xhci_pci libata xhci_hcd virtio_pci virtio virtio_pci_legacy_dev virtio_pci_modern_dev virtio_ring fuse ipv6 autofs4 [last unloaded: irqbypass]
[   22.871921] CPU: 14 PID: 3245 Comm: CPU 0/KVM Tainted: G        W  O      5.17.0-rc8.unstable #49
[   22.872809] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-24-g8f3e834 04/01/2014
[   22.873749] EIP: kvm_mmu_page_fault+0x2ad/0x6a6 [kvm]
[   22.874281] Code: b4 c2 8c 00 00 00 ff b4 c2 88 00 00 00 ff b5 68 ff ff ff 53 51 68 71 03 9c f0 e8 d5 93 c1 d0 89 b5 68 ff ff ff 83 c4 18 eb a6 <0f> 0b bb ea ff ff ff e9 ce 03 00 00 8b 85 7c ff ff
ff 8b 55 80 e8
[   22.876139] EAX: 00000047 EBX: 000fffff ECX: 00000027 EDX: ed41cd0c
[   22.876767] ESI: 00000000 EDI: 00000001 EBP: c5491d80 ESP: c5491cc0
[   22.877400] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010202
[   22.878092] CR0: 80050033 CR2: 00000000 CR3: 044e5400 CR4: 00350ef0
[   22.878716] Call Trace:
[   22.878962]  ? kvm_arch_vcpu_load+0x1a3/0x1ab [kvm]
[   22.879493]  ? avic_update_iommu_vcpu_affinity.constprop.0.isra.0+0xe/0x4a [kvm_amd]
[   22.880257]  ? apic_find_highest_isr+0x24/0x2b [kvm]
[   22.880790]  ? apic_update_ppr+0x23/0x57 [kvm]
[   22.881296]  ? kvm_lapic_set_tpr+0x28/0x2a [kvm]
[   22.881803]  npf_interception+0x89/0x91 [kvm_amd]
[   22.882273]  ? npf_interception+0x89/0x91 [kvm_amd]
[   22.882771]  svm_invoke_exit_handler+0x30/0xb6 [kvm_amd]
[   22.883308]  svm_handle_exit+0x17c/0x184 [kvm_amd]
[   22.883801]  kvm_arch_vcpu_ioctl_run+0x11e5/0x14a4 [kvm]
[   22.884354]  ? mod_objcg_state+0xf1/0x10a
[   22.884764]  kvm_vcpu_ioctl+0x16e/0x516 [kvm]
[   22.885250]  ? kvm_vcpu_ioctl+0x16e/0x516 [kvm]
[   22.885735]  ? try_to_wake_up+0x1a0/0x1c9
[   22.886137]  ? put_task_struct+0x15/0x23
[   22.886532]  ? wake_up_q+0x2e/0x39
[   22.886885]  ? __fget+0x1e/0x25
[   22.887229]  ? kvm_uevent_notify_change+0x19a/0x19a [kvm]
[   22.887796]  vfs_ioctl+0x1c/0x26
[   22.888125]  __ia32_sys_ioctl+0x735/0x767
[   22.888532]  ? __ia32_sys_futex_time32+0x125/0x145
[   22.889006]  ? exit_to_user_mode_prepare+0xe2/0x142
[   22.889516]  __do_fast_syscall_32+0x78/0x97
[   22.889936]  do_fast_syscall_32+0x29/0x5b
[   22.890337]  do_SYSENTER_32+0x15/0x17
[   22.890716]  entry_SYSENTER_32+0xa2/0xfb
[   22.891107] EIP: 0xa835c53d
[   22.891398] Code: c4 01 10 03 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00
cd 80 90 8d 76
[   22.893339] EAX: ffffffda EBX: 00000021 ECX: 0000ae80 EDX: 00000000
[   22.894090] ESI: 096509e0 EDI: 3acfeb40 EBP: 3acfcf48 ESP: 3acfcef8
[   22.894849] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000212
[   22.895697] ---[ end trace 0000000000000000 ]---

Best regards,
	Maxim Levitsky


