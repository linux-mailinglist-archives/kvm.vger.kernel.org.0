Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE694F6F16
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiDGAX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiDGAXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:23:24 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BE9133179
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:21:24 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s11so3431173pla.8
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CJv//X/6OjsoBSgLnTCClG6PHjqd7F3kkrmSxKSA0X0=;
        b=DtGA8KbEt3N+DgWQsiNRixsb976kilYLEw8V0DNlZBZjfPmjyu2zhYx2kAP3uJrnwF
         kxhmPh1eWqEc+Uttqo0mXriv0s2+i7423D1Zr2TnzexKmLxT8bTedSuhfqaPSOrLZFmQ
         RE/H7bRirI0s9kPlKaeQBkg97kAX8Ils2Y0kbL0Z0pksUWHkbU+v7h/ycisIR+e+5ZiP
         qrSjeFkHKTtQwvp+EcAQYkWGTXawOY/K9fj/1Su61N3wnwjNoeUYW5y57OJEdIunZKp2
         NRBLn78YPcLRLlXqbrVORFKE+MspZJDCuFKTICLPKvEEazkcDTjPL/KGhhrUyAxUzfad
         YqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CJv//X/6OjsoBSgLnTCClG6PHjqd7F3kkrmSxKSA0X0=;
        b=J1Xw09KYL3NvWetgsFQkcmhnil0QAwA+Qj9kYRIwEIPjqey9SGn5XUSvmCDBthffbH
         x3QIj1ITCPM+AP5vTBN2mgrhEeSPGGoeYR/gaWXRT8sPNXhz5zirbQRUxDQrp87Hs/H6
         gPF1rVRa2YTus1M0jYub2QLTo8jmGcpTq4gEF0/Umh3T1IEmDqm4rxIhkDS7iIY9JvAS
         A+PF9aS450sD9i/rff7rYbxe6FKlYOrYYhRpxMTy9pslsaEPs3reQaSGe+Nktk648I/A
         34CVYvbNz4jMbudmIqxeRL+mgEJ4fx7B+UZZN3ttn27JmnY4INX8KSFhI/MWdDtSFGvg
         NhIg==
X-Gm-Message-State: AOAM532JJZgtPsgkSlX/pPYRvSWlAn/mpebuft8Lbx9vnOc5EPRFi0ul
        +PQ/gbec1I1qxom6R5nBg9mpMA==
X-Google-Smtp-Source: ABdhPJyC9OBNGp/LnHWFaXr53mXYld41nshq52otrKCiVTAEPFJZxBMWsyKf2caeWkbxu/qj+9VLCw==
X-Received: by 2002:a17:902:f0cb:b0:156:9c51:ca4 with SMTP id v11-20020a170902f0cb00b001569c510ca4mr11013101pla.93.1649290884181;
        Wed, 06 Apr 2022 17:21:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004faaf897064sm19811166pff.106.2022.04.06.17.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:21:23 -0700 (PDT)
Date:   Thu, 7 Apr 2022 00:21:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 2/8] KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL
 ctrl bits across MSR write
Message-ID: <Yk4ugOETeo/qDRbW@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301060351.442881-3-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022, Oliver Upton wrote:
> Since commit 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
> VM-{Entry,Exit} control"), KVM has taken ownership of the "load
> IA32_PERF_GLOBAL_CTRL" VMX entry/exit control bits. The ABI is that
> these bits will be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs if
> the guest's CPUID exposes a vPMU that supports the IA32_PERF_GLOBAL_CTRL
> MSR (CPUID.0AH:EAX[7:0] > 1), and clear otherwise.
> 
> However, commit aedbaf4f6afd ("KVM: x86: Extract
> kvm_update_cpuid_runtime() from kvm_update_cpuid()") partially broke KVM
> ownership of the aforementioned bits. Before, kvm_update_cpuid() was
> exercised frequently when running a guest and constantly applied its own
> changes to the "load IA32_PERF_GLOBAL_CTRL" bits. Now, the "load
> IA32_PERF_GLOBAL_CTRL" bits are only ever updated after a
> KVM_SET_CPUID/KVM_SET_CPUID2 ioctl, meaning that a subsequent MSR write
> from userspace will clobber these values.
> 
> Note that older kernels without commit c44d9b34701d ("KVM: x86: Invoke
> vendor's vcpu_after_set_cpuid() after all common updates") still require
> that the entry/exit controls be updated from kvm_pmu_refresh(). Leave
> the benign call in place to allow for cleaner backporting and punt the
> cleanup to a later change.
> 
> Uphold the old ABI by reapplying KVM's tweaks to the "load
> IA32_PERF_GLOBAL_CTRL" bits after an MSR write from userspace.
> 
> Fixes: aedbaf4f6afd ("KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()")
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/pmu.h     |  5 +++++
>  arch/x86/kvm/vmx/vmx.c | 12 ++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 7a7b8d5b775e..2d9995668e0b 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -140,6 +140,11 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
>  	return sample_period;
>  }
>  
> +static inline u8 kvm_pmu_version(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu_to_pmu(vcpu)->version;
> +}
> +
>  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
>  void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
>  void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3a97220c5f78..224ef4c19a5d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7261,6 +7261,18 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>  			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
>  		}
>  	}
> +
> +	/*
> +	 * KVM supports a 1-setting of the "load IA32_PERF_GLOBAL_CTRL"
> +	 * VM-{Entry,Exit} controls if the vPMU supports IA32_PERF_GLOBAL_CTRL.
> +	 */
> +	if (kvm_pmu_version(vcpu) >= 2) {

Oh c'mon, now you're just being mean.  Not only is this behavior obliquely described
in the changelog and not explained in the comment, it doesn't even use the same code,
e.g. grepping for ">= 2" didn't lead me to the "> 1" check in intel_is_valid_msr().

Rather than encourage open coding the version check, how about adding a helper in
vmx.h and using that in pmu_intel.c?

---
 arch/x86/kvm/vmx/pmu_intel.c |  2 +-
 arch/x86/kvm/vmx/vmx.c       | 12 ++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  6 ++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index efa172a7278e..7cabc584da6c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -212,7 +212,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		ret = pmu->version > 1;
+		ret = intel_pmu_has_perf_global_ctrl(vcpu);
 		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 53225b1aec46..ce0000202c5e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7262,6 +7262,18 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
 		}
 	}
+
+	/*
+	 * KVM supports a 1-setting of the "load IA32_PERF_GLOBAL_CTRL"
+	 * VM-{Entry,Exit} controls if the vPMU supports IA32_PERF_GLOBAL_CTRL.
+	 */
+	if (intel_pmu_has_perf_global_ctrl(vcpu)) {
+		vmx->nested.msrs.entry_ctls_high |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	} else {
+		vmx->nested.msrs.entry_ctls_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	}
 }

 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d4b809abda62..fbdd00250bbf 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -100,6 +100,12 @@ bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);

+static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_vcpu *vcpu)
+{
+	/* Oliver needs to add a comment here as penance for being mean. */
+	return vcpu_to_pmu(vcpu)->version > 1;
+}
+
 struct lbr_desc {
 	/* Basic info about guest LBR records. */
 	struct x86_pmu_lbr records;

base-commit: fdc20fdbbb5b1982bd5cec3db509ede60c85222e
--


