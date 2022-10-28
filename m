Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5392C61177C
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 18:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiJ1Q00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiJ1Q0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 12:26:24 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E791F1F810C
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 09:26:20 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so567220pjk.1
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 09:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VLYDE7EBxFh20uXbQCKIPkWdG4JpVfNEou2zFleBWCI=;
        b=oT2y5qALcVbHYn9oIzRFavyjJCqKTRRN8jPAuPX8vKn0uW/2bESH3feEniErLOovrw
         ndbbE8muWJA507SuFAijsnYqoBRDrXbltonYtrLWlO2kCEWI/UCjZh7LYTo5FUgJWe8e
         Odw/GCxAqhOPbCs/7TzAYJ879OQkEECUsK8wgyjjVuX/B5/5MOIHTgq2X3nBAHGvmPge
         +lMYk/yd4epX++bvjmQCMYNGDszcwNlrIl2t3oHlDQ9WQ5wtdBKp/y2K6QmK4caT318n
         LwFABzrPNXrNadYIu3Jv3YSNRxCIsl+5aQikTUorChV7hAzM3/FD9xnZB9ThdYZP3WGi
         Xx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLYDE7EBxFh20uXbQCKIPkWdG4JpVfNEou2zFleBWCI=;
        b=IGinVtTe8JktyY+zG7PC/rVwIXh470P6UyV8qjf6FoQV3+LFWwpXLhZ5CXI3Eq6FJM
         BYXt8iu8SfMDs+iT2v0g64EQ4KVaK/DlwMii5MfIDl3KB6zxA1ER0xwMhLUF52+oeCME
         DAEQ1qvVC5aakpneV1EYSiDALUquf8FiwYJq27cU4loezU6nfdAuk7m4TQvA6tdLaBT2
         N/gLvw8rp1805sgF1EB6ldWNlTretF+u9jvdqhZZxXZn9RgCrNSCaJ02Exaf+cJWml7K
         6UEKOuoM8QHsWEVwrDka4lSg0NTHrkgS0HgwSm6q93GEYXEP7Lf16y8r7V8NnhLxXLQb
         +U5Q==
X-Gm-Message-State: ACrzQf2nMExEjGcWtYjrEifzJQce7t12/iq7XlrlAQKsxig+UwyplCVg
        EAgUlaU8ayo7uBZVdh0V6r8Nog==
X-Google-Smtp-Source: AMsMyM4C8xy7dWFIx5mVNAG1RcIiYQnxdO9KmWtYmihx0h4E4eeTywJ9HEYIplEU2Xqa805M1xWFMg==
X-Received: by 2002:a17:902:74c3:b0:182:57fa:b9c4 with SMTP id f3-20020a17090274c300b0018257fab9c4mr159338plt.104.1666974380297;
        Fri, 28 Oct 2022 09:26:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u7-20020a170902e80700b00174f7d10a03sm3332956plg.86.2022.10.28.09.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 09:26:19 -0700 (PDT)
Date:   Fri, 28 Oct 2022 16:26:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH] KVM: x86: Fix a stall when KVM_SET_MSRS is called on the
 pmu counters
Message-ID: <Y1wCqAzJwvz4s8OR@google.com>
References: <20221028130035.1550068-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028130035.1550068-1-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 28, 2022, Aaron Lewis wrote:
> A stall in this situation could have an impact on live migration.  So,
> to avoid that disable the print if the write is initiated by the host.

...
 
> Fixes: 5753785fa977 ("KVM: do not #GP on perf MSR writes when vPMU is disabled")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9cf1ba865562..a3b842467bd2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3778,7 +3778,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  
>  	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
>  	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> -		pr = true;
> +		pr = !msr_info->host_initiated;

Wasting guest cycles isn't any better, and there are plenty more MSRs that don't
honor report_ignored_msrs, i.e. you'll be playing whack-a-mole.

My first choice would be to delete all MSR printks, but since that's probably not
an option...

---
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Oct 2022 09:20:03 -0700
Subject: [PATCH] KVM: x86: Gate all "unimplemented MSR" prints on
 report_ignored_msrs

Add helpers to print unimplemented MSR accesses and condition all such
prints on report_ignored_msrs, i.e. honor userspace's request to not
print unimplemented MSRs.  Even though vcpu_unimpl() is ratelimited,
printing can still be problematic, e.g. if a print gets stalled when host
userspace is writing MSRs during live migration, an effective stall can
result in very noticeable disruption in the guest.

E.g. the profile below was taken while calling KVM_SET_MSRS on the PMU
counters while the PMU was disabled in KVM.

  -   99.75%     0.00%  [.] __ioctl
   - __ioctl
      - 99.74% entry_SYSCALL_64_after_hwframe
           do_syscall_64
           sys_ioctl
         - do_vfs_ioctl
            - 92.48% kvm_vcpu_ioctl
               - kvm_arch_vcpu_ioctl
                  - 85.12% kvm_set_msr_ignored_check
                       svm_set_msr
                       kvm_set_msr_common
                       printk
                       vprintk_func
                       vprintk_default
                       vprintk_emit
                       console_unlock
                       call_console_drivers
                       univ8250_console_write
                       serial8250_console_write
                       uart_console_write

Reported-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c  | 10 ++++------
 arch/x86/kvm/svm/svm.c |  5 ++---
 arch/x86/kvm/vmx/vmx.c |  4 +---
 arch/x86/kvm/x86.c     | 18 +++++-------------
 arch/x86/kvm/x86.h     | 12 ++++++++++++
 5 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 0adf4a437e85..4aacd9bd1e3d 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1404,8 +1404,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		return syndbg_set_msr(vcpu, msr, data, host);
 	default:
-		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
-			    msr, data);
+		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 		return 1;
 	}
 	return 0;
@@ -1526,8 +1525,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 			return 1;
 		break;
 	default:
-		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
-			    msr, data);
+		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 		return 1;
 	}
 
@@ -1579,7 +1577,7 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		return syndbg_get_msr(vcpu, msr, pdata, host);
 	default:
-		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
+		kvm_pr_unimpl_rdmsr(vcpu, msr);
 		return 1;
 	}
 
@@ -1644,7 +1642,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 		data = APIC_BUS_FREQUENCY;
 		break;
 	default:
-		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
+		kvm_pr_unimpl_rdmsr(vcpu, msr);
 		return 1;
 	}
 	*pdata = data;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d9357..432da7752c2f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3010,8 +3010,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!lbrv) {
-			vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTL 0x%llx, nop\n",
-				    __func__, data);
+			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
 			break;
 		}
 		if (data & DEBUGCTL_RESERVED_BITS)
@@ -3040,7 +3039,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_VM_CR:
 		return svm_set_vm_cr(vcpu, data);
 	case MSR_VM_IGNNE:
-		vcpu_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
+		kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
 		break;
 	case MSR_F10H_DECFG: {
 		struct kvm_msr_entry msr_entry;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..def6c1961355 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2105,9 +2105,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR: {
 		u64 invalid = data & ~vcpu_supported_debugctl(vcpu);
 		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
-			if (report_ignored_msrs)
-				vcpu_unimpl(vcpu, "%s: BTF|LBR in IA32_DEBUGCTLMSR 0x%llx, nop\n",
-					    __func__, data);
+			kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
 			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
 			invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
 		}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..a2f0f7f2eb56 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3539,7 +3539,6 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	bool pr = false;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 
@@ -3590,15 +3589,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data == BIT_ULL(18)) {
 			vcpu->arch.msr_hwcr = data;
 		} else if (data != 0) {
-			vcpu_unimpl(vcpu, "unimplemented HWCR wrmsr: 0x%llx\n",
-				    data);
+			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
 		break;
 	case MSR_FAM10H_MMIO_CONF_BASE:
 		if (data != 0) {
-			vcpu_unimpl(vcpu, "unimplemented MMIO_CONF_BASE wrmsr: "
-				    "0x%llx\n", data);
+			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
 		break;
@@ -3778,16 +3775,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
-		pr = true;
-		fallthrough;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 
-		if (pr || data != 0)
-			vcpu_unimpl(vcpu, "disabled perfctr wrmsr: "
-				    "0x%x data 0x%llx\n", msr, data);
+		if (data)
+			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 		break;
 	case MSR_K7_CLK_CTL:
 		/*
@@ -3814,9 +3808,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		/* Drop writes to this legacy MSR -- see rdmsr
 		 * counterpart for further detail.
 		 */
-		if (report_ignored_msrs)
-			vcpu_unimpl(vcpu, "ignored wrmsr: 0x%x data 0x%llx\n",
-				msr, data);
+		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 		break;
 	case MSR_AMD64_OSVW_ID_LENGTH:
 		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 829d3134c1eb..4921a0774bf7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -330,6 +330,18 @@ extern bool report_ignored_msrs;
 
 extern bool eager_page_split;
 
+static inline void kvm_pr_unimpl_wrmsr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	if (report_ignored_msrs)
+		vcpu_unimpl(vcpu, "Unhandled WRMSR(0x%x) = 0x%llx\n", msr, data);
+}
+
+static inline void kvm_pr_unimpl_rdmsr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	if (report_ignored_msrs)
+		vcpu_unimpl(vcpu, "Unhandled RDMSR(0x%x)\n", msr);
+}
+
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
 	return pvclock_scale_delta(nsec, vcpu->arch.virtual_tsc_mult,

base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 

