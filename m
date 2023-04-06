Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039C16DA0C9
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 21:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbjDFTOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 15:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240332AbjDFTOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 15:14:23 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71B810D
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 12:14:22 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a6-20020aa795a6000000b006262c174d64so17781808pfk.7
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 12:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680808462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XpC0AMuVCGBij5hK2QyeQdF6ADZF0D+i1i1q/8hPrtw=;
        b=a+je1kemcnFvM1xEiMQCqzTASg7ruPxQedFKjBGUOVh1oeXIHHnX6mRFitO4FtCFus
         PKbXZBJLl1TAvYMOm+1454aFLPnhIaBWObs2wKahyqnS2gLahYkK8FBNYYNNYm2AZBWh
         eqI2TVhwTcDgt80TAn8wPtnyclqaNOLBbvQHlqN+FMgDDXAM/YmH2xxLE2XSF+Rzs/1i
         uVXF7Q4cILmmy+xqShulG9edOI6uEHzWpNuUWhuoP07iqBxwOteMlsPdILsu4XrOoG3t
         t12hUWZkZ3Y9rVQD9Q3d2SiGAIu56F041wts5i2yBQxV4z8PYTPDIwV9LD+zJ35+IvjA
         y/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680808462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XpC0AMuVCGBij5hK2QyeQdF6ADZF0D+i1i1q/8hPrtw=;
        b=WWupM0BNNadr2QU+cdUxpuPz/k/ENR8/GOcoFgQvMU+tYiXwj2KAbszIkFMsuCwBB4
         sqLc8ltvRws0BV/fc/qXbGku3dIVX/jSmsE1pd7wLek//R2T6vJPNkKgo5ZdIefn7U8j
         7tC6NxPFjIOuExEaYvbaKxMwtvuu/Zs+EWxGUzzjR3JpLeyaA0GK3p899qxzNMdiIxhs
         PS4lXw/sHofliBapquQPTi+CfEFM+QIa7dI8zjBjliWy/cABpunELImST2DhCkj2JGL3
         Ip5CyH7lb43YJ4PTNiseXgnczrMZUlpVc5eXwWlZjMsOWZvwCucTRRH52bEngmal0xk5
         xFAg==
X-Gm-Message-State: AAQBX9d913Z0ElVNJG4Lf1oOoW2Mzx3YWaFwVUYrBxlxiPhKM810ribv
        pAY85eXWzi9j1650GO6LQ2Ci2jpy3Y8=
X-Google-Smtp-Source: AKy350aCO+nQcIKMor623MgHrr/fA2+H8EzjBuZZBZoe5YMUy9hKD5lFtniAQJ1MER7glZDlAXWEhSSgfAc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:680c:0:b0:513:9f9d:5ba8 with SMTP id
 l12-20020a65680c000000b005139f9d5ba8mr3581465pgt.2.1680808462401; Thu, 06 Apr
 2023 12:14:22 -0700 (PDT)
Date:   Thu, 6 Apr 2023 12:14:20 -0700
In-Reply-To: <bug-217304-28872@https.bugzilla.kernel.org/>
Mime-Version: 1.0
References: <bug-217304-28872@https.bugzilla.kernel.org/>
Message-ID: <ZC8aDNocI0vCDUFL@google.com>
Subject: Re: [Bug 217304] New: KVM does not handle NMI blocking correctly in
 nested virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, bugzilla-daemon@kernel.org wrote:
> Assume KVM runs in L0, LHV runs in L1, the nested guest runs in L2.
> 
> The code in LHV performs an experiment (called "Experiment 13" in serial
> output) on CPU 0 to test the behavior of NMI blocking. The experiment steps
> are:
> 1. Prepare state such that the CPU is currently in L1 (LHV), and NMI is blocked
> 2. Modify VMCS12 to make sure that L2 has virtual NMIs enabled (NMI exiting =
> 1, Virtual NMIs = 1), and L2 does not block NMI (Blocking by NMI = 0)
> 3. VM entry to L2
> 4. L2 performs VMCALL, get VM exit to L1
> 5. L1 checks whether NMI is blocked.
> 
> The expected behavior is that NMI should be blocked, which is reproduced on
> real hardware. According to Intel SDM, NMIs should be unblocked after VM entry
> to L2 (step 3). After VM exit to L1 (step 4), NMI blocking does not change, so
> NMIs are still unblocked. This behavior is reproducible on real hardware.
> 
> However, when running on KVM, the experiment shows that at step 5, NMIs are
> blocked in L1. Thus, I think NMI blocking is not implemented correctly in KVM's
> nested virtualization.

Ya, KVM blocks NMIs on nested NMI VM-Exits, but doesn't unblock NMIs for all other
exit types.  I believe this is the fix (untested):

---
 arch/x86/kvm/vmx/nested.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 96ede74a6067..4240a052628a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4164,12 +4164,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
 				  NMI_VECTOR | INTR_TYPE_NMI_INTR |
 				  INTR_INFO_VALID_MASK, 0);
-		/*
-		 * The NMI-triggered VM exit counts as injection:
-		 * clear this one and block further NMIs.
-		 */
 		vcpu->arch.nmi_pending = 0;
-		vmx_set_nmi_mask(vcpu, true);
 		return 0;
 	}
 
@@ -4865,6 +4860,13 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 				INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
 		}
 
+		/*
+		 * NMIs are blocked on VM-Exit due to NMI, and unblocked by all
+		 * other VM-Exit types.
+		 */
+		vmx_set_nmi_mask(vcpu, (u16)vm_exit_reason == EXIT_REASON_EXCEPTION_NMI &&
+				       !is_nmi(vmcs12->vm_exit_intr_info));
+
 		if (vm_exit_reason != -1)
 			trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
 						       vmcs12->exit_qualification,

base-commit: 0b87a6bfd1bdb47b766aa0641b7cf93f3d3227e9
-- 

 
> I am happy to explain how the experiment code works in detail. c.img also
> reveals other NMI-related bugs in KVM. I am also happy to explain the other
> bugs.

I'm not sure I want to know ;-)  If you can give a quick rundown of each bug, it
would be quite helpful.

Thanks!

