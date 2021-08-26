Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3796F3F8B6E
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 18:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbhHZQB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 12:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbhHZQB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 12:01:58 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30219C0613C1
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 09:01:11 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id y23so3452844pgi.7
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 09:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I1bph11Wd0ZbjyAzIWa4mfAM/Oiqq+VnKfVLVM9GnTQ=;
        b=cl1CixXlMCeneZwlE0PUc0DQwS9ypz/ka6GAIANMo+Lj11uONEBvtKdu0h40aMDBLK
         41X6v49U06VxoJcLS31r19WsGKw38AdOBRj1Cutxpb4NOWPMpyg3TBiHhRWxSd5tAUL+
         p7CokmWxRViGk5POtKIdg+H0NGjoD3RLFFtpWe3aia/+SNJLwY7Tj0P5msdE2ntwjyNd
         Zq1tsI+CLUto2DQ97YMQjHgNrjBeM9F/LXX2UiRZTY1VD+bV7VzTXikIJdIYswyUM05F
         LdmhCjOEyfnh0ixVqYZNLzDsl/YRun9tpZkZJXOezAgmLZupVOTXQKCWadTjag0KcK6j
         dN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I1bph11Wd0ZbjyAzIWa4mfAM/Oiqq+VnKfVLVM9GnTQ=;
        b=T+VvKgv5Z840MS8/XA/79Q8dtUUwRiEXBASWWHCSnPL4V2h4TVpp16dC8x2apCAPWR
         urYy046vdvbk8GBX7rSroYCNyuofOJLGaOsbXBBIakl21AA2mNuigYec5ZFpFatOHj80
         aRcmvY97a0iigMSxAprh8y94LdGCq4eJ0oyGoTBtAhO74WM78dIURfSvV9LPDaq40ez3
         2hDWj16VRcdUfhJRxgzNp/wCyuK933Z/RTXuSCxqKHXN5JH6C5g6QTAy3gqg12rUQsDb
         Md+UTQAb/xgEmQ6ZOt7wcC3GtFTFUsjAINB9Kdr99zOa4QaCGCZE0u6tS/2EXfdXh88r
         rGDg==
X-Gm-Message-State: AOAM533os/JNzTF/dFwow7M/aoJV2L0WfceSKgPIe0jz0cGjJ0gV8+vK
        x0Gs7Bxfosu5d3SDsg/+EOVaPQ==
X-Google-Smtp-Source: ABdhPJxXWQqP2E26c8cgG68T7KQcAPfejUNZcRWq7HEkud5KhiFuKuvan24jNgscOC3rRnqF2L6Xcw==
X-Received: by 2002:aa7:93b0:0:b0:3f1:bb85:a37d with SMTP id x16-20020aa793b0000000b003f1bb85a37dmr4539509pff.10.1629993670310;
        Thu, 26 Aug 2021 09:01:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gm5sm3095339pjb.32.2021.08.26.09.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 09:01:09 -0700 (PDT)
Date:   Thu, 26 Aug 2021 16:01:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: VMX: avoid running vmx_handle_exit_irqoff in
 case of emulation
Message-ID: <YSe6wphK9b8KSkXW@google.com>
References: <20210826095750.1650467-1-mlevitsk@redhat.com>
 <20210826095750.1650467-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826095750.1650467-2-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021, Maxim Levitsky wrote:
> If we are emulating an invalid guest state, we don't have a correct
> exit reason, and thus we shouldn't do anything in this function.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

This should have Cc: stable.  I believe userspace could fairly easily trick KVM
into "handling" a spurious IRQ, e.g. trigger SIGALRM and stuff invalid state.
For all those evil folks running CPUs that are almost old enough to drive :-)

> ---
>  arch/x86/kvm/vmx/vmx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fada1055f325..0c2c0d5ae873 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6382,6 +6382,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> +	if (vmx->emulation_required)
> +		return;

Rather than play whack-a-mole with flows consuming stale state, I'd much prefer
to synthesize a VM-Exit(INVALID_GUEST_STATE).  Alternatively, just skip ->run()
entirely by adding hooks in vcpu_enter_guest(), but that's a much larger change
and probably not worth the risk at this juncture.

---
 arch/x86/kvm/vmx/vmx.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32e3a8b35b13..12fe63800889 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6618,10 +6618,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		     vmx->loaded_vmcs->soft_vnmi_blocked))
 		vmx->loaded_vmcs->entry_time = ktime_get();
 
-	/* Don't enter VMX if guest state is invalid, let the exit handler
-	   start emulation until we arrive back to a valid state */
-	if (vmx->emulation_required)
+	/*
+	 * Don't enter VMX if guest state is invalid, let the exit handler
+	 * start emulation until we arrive back to a valid state.  Synthesize a
+	 * consistency check VM-Exit due to invalid guest state and bail.
+	 */
+	if (unlikely(vmx->emulation_required)) {
+		vmx->fail = 0;
+		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
+		vmx->exit_reason.failed_vmentry = 1;
+		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
+		vmx->exit_qualification = ENTRY_FAIL_DEFAULT;
+		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2);
+		vmx->exit_intr_info = 0;
 		return EXIT_FASTPATH_NONE;
+	}
 
 	trace_kvm_entry(vcpu);
 
--

or the beginnings of an aggressive refactor...

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf8fb6eb676a..a4fe0f78898a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9509,6 +9509,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
                goto cancel_injection;
        }

+       if (unlikely(static_call(kvm_x86_emulation_required)(vcpu)))
+               return static_call(kvm_x86_emulate_invalid_guest_state)(vcpu);
+
        preempt_disable();

        static_call(kvm_x86_prepare_guest_switch)(vcpu);

> +
>  	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
>  		handle_external_interrupt_irqoff(vcpu);
>  	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
> -- 
> 2.26.3
> 
