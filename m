Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580CF2FC503
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 00:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbhASXqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 18:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730760AbhASXqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 18:46:19 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2933DC061573
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 15:45:39 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id g15so967718pjd.2
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 15:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dV/5VOT7tyIqPDG6JNcIPQ9CGyn+MA2Lx+QvsRY3jAU=;
        b=FrYR48URBI/1jNNfAzj8C8qVNfgeg51O8r9wkp+5nDBYR1FAxyOwmZnsWemLTOzj4A
         mHUpqvetCMRjgJ5chG8IZosODMUoDDyaRiRk6sRXg+ohIbk4EH/RGccFZHxGogm3Mo1+
         ds7bktBM1SUW9y0rStdW1uHgJxHGRtUWehHb3j+HjRRPuWYNC4u5naAKmM9UN5fS3DQ8
         E9FiajeOn1Ij5qn2v64LrcjCzzCIRppz9oJJnmIpU1LEMLk/vlVV4tjjXOJG/kOoOwRb
         Zt8/Z0MQEhzLdvuCn5AAZinKksIf9QIK3M7Q3dgaLMDSYhW7+tENz0cOwaKJsehIwPGO
         ORfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dV/5VOT7tyIqPDG6JNcIPQ9CGyn+MA2Lx+QvsRY3jAU=;
        b=TCMouvNEeCuAtySHy9WAhFOpJeCFdf9yI0tVpCGtCzVUmkNgNL41OoYDrzOPsnqJp4
         XmOWHkep1gSNVrZ2YhPwV/UfI4AumG8/aUs6POm3Q3rCtirxyqS4dlf9mmGpEL1fvfjb
         JlCDaw1norlplxqOBlXp/wpbw7/yEBcXTb7hAti/6sLjuct2LAi80N6XBsUL7Qe56KNM
         X2XTh7DchszVh/Fsc/NB4XZAdyAHDA764TtKrju37Xmd541IuWbAenCxWVC/KmwKqoHd
         OcFLSdqbfTxlmEhywp7GEYDxj6c/M4iZQCVm1nk2xEsJTu5EZSwsp/7Z2f/BN+mT1Zde
         5+vg==
X-Gm-Message-State: AOAM533I2JIYzOg2AdH9u9Hhd9EwoZNCUx9kDob//DgY3GTbrr/6yssR
        m5baYJyZF3Tbevp5kOvh5wt1cg==
X-Google-Smtp-Source: ABdhPJxCaGRsnlKFaHYeNlT9jQJVFg4OxLA4bp3oL3oX0QowYLBtbFUTs9aaTXnICJaF92ZcUZJi5Q==
X-Received: by 2002:a17:90a:5802:: with SMTP id h2mr2430282pji.68.1611099938467;
        Tue, 19 Jan 2021 15:45:38 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id m62sm196779pfm.135.2021.01.19.15.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:45:37 -0800 (PST)
Date:   Tue, 19 Jan 2021 15:45:30 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, fenghua.yu@intel.com, tony.luck@intel.com,
        wanpengli@tencent.com, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, peterz@infradead.org, joro@8bytes.org,
        x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com, jmattson@google.com
Subject: Re: [PATCH v3 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
Message-ID: <YAdvGkwtJf3CDxo6@google.com>
References: <161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu>
 <161073130040.13848.4508590528993822806.stgit@bmoger-ubuntu>
 <YAclaWCL20at/0n+@google.com>
 <c3a81da0-4b6a-1854-1b67-31df5fbf30f6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3a81da0-4b6a-1854-1b67-31df5fbf30f6@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021, Babu Moger wrote:
> 
> On 1/19/21 12:31 PM, Sean Christopherson wrote:
> > On Fri, Jan 15, 2021, Babu Moger wrote:
> >> @@ -3789,7 +3792,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
> >>  	 * is no need to worry about the conditional branch over the wrmsr
> >>  	 * being speculatively taken.
> >>  	 */
> >> -	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> >> +	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> >> +		svm->vmcb->save.spec_ctrl = svm->spec_ctrl;
> >> +	else
> >> +		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> > 
> > Can't we avoid functional code in svm_vcpu_run() entirely when V_SPEC_CTRL is
> > supported?  Make this code a nop, disable interception from time zero, and
> 
> Sean, I thought you mentioned earlier about not changing the interception
> mechanism.

I assume you're referring to this comment?

  On Mon, Dec 7, 2020 at 3:13 PM Sean Christopherson <seanjc@google.com> wrote:
  >
  > On Mon, Dec 07, 2020, Babu Moger wrote:
  > > When this feature is enabled, the hypervisor no longer has to
  > > intercept the usage of the SPEC_CTRL MSR and no longer is required to
  > > save and restore the guest SPEC_CTRL setting when switching
  > > hypervisor/guest modes.
  >
  > Well, it's still required if the hypervisor wanted to allow the guest to turn
  > off mitigations that are enabled in the host.  I'd omit this entirely and focus
  > on what hardware does and how Linux/KVM utilize the new feature.

I wasn't suggesting that KVM should intercept SPEC_CTRL, I was pointing out that
there exists a scenario where a hypervisor would need/want to intercept
SPEC_CTRL, and that stating that a hypervisor is/isn't required to do something
isn't helpful in a KVM/Linux changelog because it doesn't describe the actual
change, nor does it help understand _why_ the change is correct.

> Do you think we should disable the interception right away if V_SPEC_CTRL is
> supported?

Yes, unless I'm missing an interaction somewhere, that will simplify the get/set
flows as they won't need to handle the case where the MSR is intercepted when
V_SPEC_CTRL is supported.  If the MSR is conditionally passed through, the get
flow would need to check if the MSR is intercepted to determine whether
svm->spec_ctrl or svm->vmcb->save.spec_ctrl holds the guest's value.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cce0143a6f80..40f1bd449cfa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2678,7 +2678,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                    !guest_has_spec_ctrl_msr(vcpu))
                        return 1;
 
-               msr_info->data = svm->spec_ctrl;
+               if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+                       msr_info->data = svm->vmcb->save.spec_ctrl;
+               else
+                       msr_info->data = svm->spec_ctrl;
                break;
        case MSR_AMD64_VIRT_SPEC_CTRL:
                if (!msr_info->host_initiated &&
@@ -2779,6 +2782,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
                if (kvm_spec_ctrl_test_value(data))
                        return 1;
 
+               if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL)) {
+                       svm->vmcb->save.spec_ctrl = data;
+                       break;
+               }
+
                svm->spec_ctrl = data;
                if (!data)
                        break;

> > read/write the VMBC field in svm_{get,set}_msr().  I.e. don't touch
> > svm->spec_ctrl if V_SPEC_CTRL is supported.  

Potentially harebrained alternative...

From an architectural SVM perspective, what are the rules for VMCB fields that
don't exist (on the current hardware)?  E.g. are they reserved MBZ?  If not,
does the SVM architecture guarantee that reserved fields will not be modified?
I couldn't (quickly) find anything in the APM that explicitly states what
happens with defined-but-not-existent fields.

Specifically in the context of this change, ignoring nested correctness, what
would happen if KVM used the VMCB field even on CPUs without V_SPEC_CTRL?  Would
this explode on VMRUN?  Risk silent corruption?  Just Work (TM)?

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cce0143a6f80..22a6a7c35d0a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1285,7 +1285,6 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
        u32 dummy;
        u32 eax = 1;

-       svm->spec_ctrl = 0;
        svm->virt_spec_ctrl = 0;

        if (!init_event) {
@@ -2678,7 +2677,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                    !guest_has_spec_ctrl_msr(vcpu))
                        return 1;

-               msr_info->data = svm->spec_ctrl;
+               msr_info->data = svm->vmcb->save.spec_ctrl;
                break;
        case MSR_AMD64_VIRT_SPEC_CTRL:
                if (!msr_info->host_initiated &&
@@ -2779,7 +2778,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
                if (kvm_spec_ctrl_test_value(data))
                        return 1;

-               svm->spec_ctrl = data;
+               svm->vmcb->save.spec_ctrl = data;
                if (!data)
                        break;

@@ -3791,7 +3790,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
         * is no need to worry about the conditional branch over the wrmsr
         * being speculatively taken.
         */
-       x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+       x86_spec_ctrl_set_guest(svm->vmcb->save.spec_ctrl, svm->virt_spec_ctrl);

        svm_vcpu_enter_exit(vcpu, svm);

@@ -3811,12 +3810,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
         * save it.
         */
        if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
-               svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
+               svm->vmcb->save.spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);

        if (!sev_es_guest(svm->vcpu.kvm))
                reload_tss(vcpu);

-       x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+       x86_spec_ctrl_restore_host(svm->vmcb->save.spec_ctrl, svm->virt_spec_ctrl);

        if (!sev_es_guest(svm->vcpu.kvm)) {
                vcpu->arch.cr2 = svm->vmcb->save.cr2;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5431e6335e2e..a4f9417e3b7e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -137,7 +137,6 @@ struct vcpu_svm {
                u64 gs_base;
        } host;

-       u64 spec_ctrl;
        /*
         * Contains guest-controlled bits of VIRT_SPEC_CTRL, which will be
         * translated into the appropriate L2_CFG bits on the host to

