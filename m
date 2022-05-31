Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3984553907E
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 14:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344145AbiEaMSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 08:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiEaMSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 08:18:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D143937A1B
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 05:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653999490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9uLoEnI8xm05pZOEfh79Bm5RkqDb66wzQpVIVDjFd1Y=;
        b=LI+Ws8UEL+oWt3KOgKDhyMsoW0wyzq5+Pen/xBnlZHcD+MS/l5naDYGTvzjIAd/CKZpPXN
        Cl5flXI83yPpcoMBGJUpHbfnKlWKgrCel2gSs+OtJdWhUT+W+6E7dzmk5RDHOXamPxAOlw
        aE5VUbH6UJdUKSdmMjXiwlPPEabMM7A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-kfmhLeQJMLKe6Wq8Id34VQ-1; Tue, 31 May 2022 08:18:09 -0400
X-MC-Unique: kfmhLeQJMLKe6Wq8Id34VQ-1
Received: by mail-ed1-f71.google.com with SMTP id g7-20020a056402424700b0042dee9d11d0so235843edb.3
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 05:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9uLoEnI8xm05pZOEfh79Bm5RkqDb66wzQpVIVDjFd1Y=;
        b=IPwlLBMu/lHlaTJR2VJJOEb7s9k6HOr9BZfokWishwPE3VnOzDauDrOWVFuQJMzSbR
         IUclyvExV6mXG4UunK6eb+lspMRH5JMVdJj0bbSB2KbpVgLPG3xjOPaGl4FecTfXIAIO
         P9y11D5C7XIz5kO+mEAL0feiCuOd7vCHK0Xe2OLPhedYzsJXTlFnBxR3rdwlrHTmh4CI
         GPsm26+v6+VBm0N6pFKAS8lGwQ1QEFHTxGq31ZdGKcfUyc8S4bI09c+OmUXPHmMSNtnr
         QSj2x2HkPimNyFSDihs7sCvVEih6jP6xxS22ObL9rVun6ANTxRRfjKvceh/RNVU0n12l
         EUSQ==
X-Gm-Message-State: AOAM532rhQszN+PYHmIt3efNu4nZB343sMToi1XmrOiaa3jBx7PaSqJN
        sflkpzbi4QACz7xXKPMF2gJG7pC5ywbbCkjuqBu+1YkLkfd1xbViOEaKk/SnmiS43LcRAIJRLbw
        7NCMBGKTKQKtf
X-Received: by 2002:aa7:d789:0:b0:42b:cf4e:d585 with SMTP id s9-20020aa7d789000000b0042bcf4ed585mr15494184edq.321.1653999486629;
        Tue, 31 May 2022 05:18:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQfkPdyC7SgNA2BaBjdFN/n5w5hMEYyZWasZX+lhZnbuwJEkjpOYRv4tu109MMrSfJjcY91Q==
X-Received: by 2002:aa7:d789:0:b0:42b:cf4e:d585 with SMTP id s9-20020aa7d789000000b0042bcf4ed585mr15494160edq.321.1653999486398;
        Tue, 31 May 2022 05:18:06 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f13-20020a170906390d00b006fee961b9e0sm4840341eje.195.2022.05.31.05.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 05:18:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 21/37] KVM: nSVM: hyper-v: Enable L2 TLB flush
In-Reply-To: <20220527155546.1528910-22-vkuznets@redhat.com>
References: <20220527155546.1528910-1-vkuznets@redhat.com>
 <20220527155546.1528910-22-vkuznets@redhat.com>
Date:   Tue, 31 May 2022 14:18:05 +0200
Message-ID: <874k15q4jm.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Implement Hyper-V L2 TLB flush for nSVM. The feature needs to be enabled
> both in extended 'nested controls' in VMCB and partition assist page.
> According to Hyper-V TLFS, synthetic vmexit to L1 is performed with
> - HV_SVM_EXITCODE_ENL exit_code.
> - HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH exit_info_1.
>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/hyperv.c |  7 +++++++
>  arch/x86/kvm/svm/hyperv.h | 19 +++++++++++++++++++
>  arch/x86/kvm/svm/nested.c | 27 +++++++++++++++++++++++++--
>  3 files changed, 51 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
> index 911f51021af1..088f6429b24c 100644
> --- a/arch/x86/kvm/svm/hyperv.c
> +++ b/arch/x86/kvm/svm/hyperv.c
> @@ -8,4 +8,11 @@
>  
>  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	svm->vmcb->control.exit_code = HV_SVM_EXITCODE_ENL;
> +	svm->vmcb->control.exit_code_hi = 0;
> +	svm->vmcb->control.exit_info_1 = HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH;
> +	svm->vmcb->control.exit_info_2 = 0;
> +	nested_svm_vmexit(svm);
>  }
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index dd2e393f84a0..6ea78499e21b 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -33,6 +33,9 @@ struct hv_enlightenments {
>   */
>  #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
>  
> +#define HV_SVM_EXITCODE_ENL 0xF0000000
> +#define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH   (1)
> +
>  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -48,6 +51,22 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>  	hv_vcpu->nested.vp_id = hve->hv_vp_id;
>  }
>  
> +static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct hv_enlightenments *hve =
> +		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
> +	struct hv_vp_assist_page assist_page;
> +
> +	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
> +		return false;
> +
> +	if (!hve->hv_enlightenments_control.nested_flush_hypercall)
> +		return false;
> +
> +	return assist_page.nested_control.features.directhypercall;
> +}
> +
>  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  
>  #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index b203e6cd75dc..083b95d85495 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -171,8 +171,12 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  		vmcb_clr_intercept(c, INTERCEPT_VINTR);
>  	}
>  
> -	/* We don't want to see VMMCALLs from a nested guest */
> -	vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
> +	/*
> +	 * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
> +	 * flush feature is enabled.
> +	 */
> +	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
> +		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);

I've just noticed that this generates a warning:

[  823.047913] =============================
[  823.048376] WARNING: suspicious RCU usage
[  823.048745] 5.18.0-rc1+ #454 Not tainted
[  823.049098] -----------------------------
[  823.049435] include/linux/kvm_host.h:936 suspicious rcu_dereference_check() usage!
[  823.049791] 
               other info that might help us debug this:

[  823.050756] 
               rcu_scheduler_active = 2, debug_locks = 1
[  823.051410] 1 lock held by qemu-system-x86/8931:
[  823.051747]  #0: ffff8ad90c144fa8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x77/0x700 [kvm]
[  823.052171] 
               stack backtrace:
[  823.052849] CPU: 3 PID: 8931 Comm: qemu-system-x86 Kdump: loaded Not tainted 5.18.0-rc1+ #454
[  823.053230] Hardware name: Dell Inc. PowerEdge R6415/065PKD, BIOS 1.9.3 06/25/2019
[  823.053644] Call Trace:
[  823.054279]  <TASK>
[  823.054695]  dump_stack_lvl+0x6c/0x9b
[  823.055076]  kvm_read_guest_offset_cached+0x14a/0x190 [kvm]
[  823.055504]  kvm_hv_get_assist_page+0x40/0x50 [kvm]
[  823.055932]  recalc_intercepts+0x6f/0x140 [kvm_amd]
[  823.056317]  ? native_load_tr_desc+0x63/0x70
[  823.056696]  ? svm_vcpu_run+0x27f/0x780 [kvm_amd]
[  823.057080]  kvm_arch_vcpu_ioctl_run+0x1a9f/0x2220 [kvm]
[  823.057519]  ? kvm_vcpu_ioctl+0x275/0x700 [kvm]
[  823.057932]  kvm_vcpu_ioctl+0x275/0x700 [kvm]
[  823.058358]  __x64_sys_ioctl+0x82/0xb0
[  823.058747]  do_syscall_64+0x3b/0x90
[  823.059133]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  823.059519] RIP: 0033:0x7fcd123540ab
[  823.059899] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d bd 0c 00 f7 d8 64 89 01 48
[  823.060787] RSP: 002b:00007fcd04dfa478 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  823.061246] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007fcd123540ab
[  823.061702] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000010
[  823.062166] RBP: 00005626d1d13c20 R08: 0000000000000000 R09: 00000000ffffffff
[  823.062628] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  823.063096] R13: 00005626d111fa6e R14: 0000000000000000 R15: 00007fcd04dff640
[  823.063579]  </TASK>
[  823.064024] BUG: sleeping function called from invalid context at include/linux/uaccess.h:69
[  823.064485] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 8931, name: qemu-system-x86
[  823.064956] preempt_count: 1, expected: 0
[  823.065416] RCU nest depth: 0, expected: 0

It is likely a bad idea to read guest memory from recalc_intercepts()
but we don't actually have to, we can cache the whole partition assist
page and update it upon VMRUN (and after svm_set_nested_state()). For
VMX, this can be part of enlightened vmentry.

>  
>  	for (i = 0; i < MAX_INTERCEPT; i++)
>  		c->intercepts[i] |= g->intercepts[i];
> @@ -489,6 +493,17 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
>  
>  static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
> +	 * L2's VP_ID upon request from the guest. Make sure we check for
> +	 * pending entries for the case when the request got misplaced (e.g.
> +	 * a transition from L2->L1 happened while processing L2 TLB flush
> +	 * request or vice versa). kvm_hv_vcpu_flush_tlb() will not flush
> +	 * anything if there are no requests in the corresponding buffer.
> +	 */
> +	if (to_hv_vcpu(vcpu))
> +		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +
>  	/*
>  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
>  	 * things to fix before this can be conditional:
> @@ -1409,6 +1424,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>  int nested_svm_exit_special(struct vcpu_svm *svm)
>  {
>  	u32 exit_code = svm->vmcb->control.exit_code;
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
>  
>  	switch (exit_code) {
>  	case SVM_EXIT_INTR:
> @@ -1427,6 +1443,13 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
>  			return NESTED_EXIT_HOST;
>  		break;
>  	}
> +	case SVM_EXIT_VMMCALL:
> +		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
> +		if (guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
> +		    nested_svm_l2_tlb_flush_enabled(vcpu) &&
> +		    kvm_hv_is_tlb_flush_hcall(vcpu))
> +			return NESTED_EXIT_HOST;
> +		break;
>  	default:
>  		break;
>  	}

-- 
Vitaly

