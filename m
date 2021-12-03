Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BE3467B9C
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382118AbhLCQmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 11:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245508AbhLCQmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 11:42:42 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EFDC061353
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 08:39:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so5582911pjb.5
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 08:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=57Kulmp5q4O2ps0m6S9rdcKyd+t5YdMdTDoqyt+nW4M=;
        b=UvB8UDbdbOrxz/dVoecna26z37ARKbHnAKKaCJwS38jhSdDcFINSHJvuEtlY3J5wKD
         bm4ScH+re97ENzrSU+fq83+eD+qjZLJJhJSSbCHcjg9kxbtbmqYNjkDgewSD3eFCIsFT
         R40HkGk9gc48w32ToeY2F706sK9k3x2hz/9zBW3FX+drAbXbOneR5d/PMU46HnjnvZrZ
         x1vn6lXPfSsHD3o1mVo/aUV8zoAWM6laaq9P97TvM2pjJ/2+PWgF28o3KW0Z9o81xFLs
         0RmAJK7QHgyALx+R3j1ttfhQbqGey5T15GUSPQzLbiJmbEMTqnBs5lYpncYAwnhr2zaq
         zoHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=57Kulmp5q4O2ps0m6S9rdcKyd+t5YdMdTDoqyt+nW4M=;
        b=4SGO+amN5NpQym5FxIaMpGX0Yqi84Hw+Pt1ubw4qPnMZcaWgBGIEok+Wccz4CPhwlC
         UDlmXilRYxEikvGzXf26h7sJDRnSStfLBlgI3d4Ay69VvMttB99/V0RgCIIQQv2V5Ey7
         gX96n+YML9q7N8wmWoH+eDTjww0QXC90stF7uOc3MAIOUCGb5i5jJidG/yyZyUz2P6Qc
         OUBbtcauHNdQGV7tTuEVNdgtuIBU+O132V4EPFJF+hLAZb9mZENlpnqOLtuU8+jFJ/WD
         06EgGIcQX8QyZksYOFN4ixEH9vG/Xw1wI9eUgP6TO5jTmPQJGhqTXWRaJ6tlcvSkmLI7
         Dg9g==
X-Gm-Message-State: AOAM531zqaFpAX4oFsv3MM/ZV80X2ubQlpxUvi+1HASlLAZNdwm9j8TG
        E5MSyX7Ik4P5JGotAABCxFj0QlBGiTQDxw==
X-Google-Smtp-Source: ABdhPJxbVibK91sCwv7hpQd10e+ax+0wH9Sly1dUk+qNTWgzaMG5o0Btq/lcV+cwXJHmqdGIdhU/fA==
X-Received: by 2002:a17:90b:1217:: with SMTP id gl23mr15156126pjb.191.1638549557389;
        Fri, 03 Dec 2021 08:39:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 13sm3700700pfp.216.2021.12.03.08.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 08:39:16 -0800 (PST)
Date:   Fri, 3 Dec 2021 16:39:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
Message-ID: <YapIMYiJ+iIfHI+c@google.com>
References: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 02, 2021, Tom Lendacky wrote:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 713e3daa9574..322553322202 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2353,24 +2353,29 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
>  }
>  
> -static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
> +static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  {

...

> -	return 0;
> +	return true;
>  
>  vmgexit_err:
>  	vcpu = &svm->vcpu;
>  
> -	if (ghcb->ghcb_usage) {
> +	if (reason == GHCB_ERR_INVALID_USAGE) {
>  		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
>  			    ghcb->ghcb_usage);
> +	} else if (reason == GHCB_ERR_INVALID_EVENT) {
> +		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx is not valid\n",
> +			    exit_code);
>  	} else {
> -		vcpu_unimpl(vcpu, "vmgexit: exit reason %#llx is not valid\n",
> +		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx input is not valid\n",
>  			    exit_code);
>  		dump_ghcb(svm);
>  	}
>  
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_code;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	/* Clear the valid entries fields */
> +	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
> +
> +	ghcb_set_sw_exit_info_1(ghcb, 2);
> +	ghcb_set_sw_exit_info_2(ghcb, reason);
>  
> -	return -EINVAL;
> +	return false;

I'd really prefer that this helper continue to return 0/-EINVAL, there's no hint
in the function name that this return true/false.  And given the usage, there's
no advantage to returning true/false.  On the contrary, if there's a future
condition where this needs to exit to userspace, we'll end up switching this all
back to int.

>  }
>  
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm)
> @@ -2531,7 +2540,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>  }
>  
>  #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
> -static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
> +static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)

Same here, but now there's an actual need to return an int...

>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
>  	struct ghcb *ghcb = svm->sev_es.ghcb;
> @@ -2542,14 +2551,14 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>  	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
>  	if (!scratch_gpa_beg) {
>  		pr_err("vmgexit: scratch gpa not provided\n");
> -		return -EINVAL;
> +		goto e_scratch;
>  	}
>  
>  	scratch_gpa_end = scratch_gpa_beg + len;
>  	if (scratch_gpa_end < scratch_gpa_beg) {
>  		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
>  		       len, scratch_gpa_beg);
> -		return -EINVAL;
> +		goto e_scratch;
>  	}
>  
>  	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
> @@ -2567,7 +2576,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>  		    scratch_gpa_end > ghcb_scratch_end) {
>  			pr_err("vmgexit: scratch area is outside of GHCB shared buffer area (%#llx - %#llx)\n",
>  			       scratch_gpa_beg, scratch_gpa_end);
> -			return -EINVAL;
> +			goto e_scratch;
>  		}
>  
>  		scratch_va = (void *)svm->sev_es.ghcb;
> @@ -2580,18 +2589,18 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>  		if (len > GHCB_SCRATCH_AREA_LIMIT) {
>  			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
>  			       len, GHCB_SCRATCH_AREA_LIMIT);
> -			return -EINVAL;
> +			goto e_scratch;
>  		}
>  		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
>  		if (!scratch_va)
> -			return -ENOMEM;

...because this is wrong.  Failure to allocate memory should exit to userspace,
not report an error to the guest.

> +			goto e_scratch;
>  
>  		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
>  			/* Unable to copy scratch area from guest */
>  			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
>  
>  			kvfree(scratch_va);
> -			return -EFAULT;
> +			goto e_scratch;

Same here, failure to read guest memory is a userspace issue and needs to be
reported to userspace.

>  		}
>  
>  		/*

IMO, this should be the patch (compile tested only).

---
 arch/x86/include/asm/sev-common.h | 11 +++++
 arch/x86/kvm/svm/sev.c            | 75 +++++++++++++++++++------------
 2 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 2cef6c5a52c2..6acaf5af0a3d 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -73,4 +73,15 @@

 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)

+/*
+ * Error codes related to GHCB input that can be communicated back to the guest
+ * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
+ */
+#define GHCB_ERR_NOT_REGISTERED		1
+#define GHCB_ERR_INVALID_USAGE		2
+#define GHCB_ERR_INVALID_SCRATCH_AREA	3
+#define GHCB_ERR_MISSING_INPUT		4
+#define GHCB_ERR_INVALID_INPUT		5
+#define GHCB_ERR_INVALID_EVENT		6
+
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 713e3daa9574..60c6d7b216eb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2357,20 +2357,25 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu;
 	struct ghcb *ghcb;
-	u64 exit_code = 0;
+	u64 exit_code;
+	u64 reason;

 	ghcb = svm->sev_es.ghcb;

-	/* Only GHCB Usage code 0 is supported */
-	if (ghcb->ghcb_usage)
-		goto vmgexit_err;
-
 	/*
-	 * Retrieve the exit code now even though is may not be marked valid
+	 * Retrieve the exit code now even though it may not be marked valid
 	 * as it could help with debugging.
 	 */
 	exit_code = ghcb_get_sw_exit_code(ghcb);

+	/* Only GHCB Usage code 0 is supported */
+	if (ghcb->ghcb_usage) {
+		reason = GHCB_ERR_INVALID_USAGE;
+		goto vmgexit_err;
+	}
+
+	reason = GHCB_ERR_MISSING_INPUT;
+
 	if (!ghcb_sw_exit_code_is_valid(ghcb) ||
 	    !ghcb_sw_exit_info_1_is_valid(ghcb) ||
 	    !ghcb_sw_exit_info_2_is_valid(ghcb))
@@ -2449,6 +2454,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		break;
 	default:
+		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
 	}

@@ -2457,22 +2463,25 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 vmgexit_err:
 	vcpu = &svm->vcpu;

-	if (ghcb->ghcb_usage) {
+	if (reason == GHCB_ERR_INVALID_USAGE) {
 		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
 			    ghcb->ghcb_usage);
+	} else if (reason == GHCB_ERR_INVALID_EVENT) {
+		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx is not valid\n",
+			    exit_code);
 	} else {
-		vcpu_unimpl(vcpu, "vmgexit: exit reason %#llx is not valid\n",
+		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx input is not valid\n",
 			    exit_code);
 		dump_ghcb(svm);
 	}

-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_code;
-	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	/* Clear the valid entries fields */
+	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));

-	return -EINVAL;
+	ghcb_set_sw_exit_info_1(ghcb, 2);
+	ghcb_set_sw_exit_info_2(ghcb, reason);
+
+	return 1;
 }

 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
@@ -2542,14 +2551,14 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");
-		return -EINVAL;
+		goto e_scratch;
 	}

 	scratch_gpa_end = scratch_gpa_beg + len;
 	if (scratch_gpa_end < scratch_gpa_beg) {
 		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
 		       len, scratch_gpa_beg);
-		return -EINVAL;
+		goto e_scratch;
 	}

 	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
@@ -2567,7 +2576,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		    scratch_gpa_end > ghcb_scratch_end) {
 			pr_err("vmgexit: scratch area is outside of GHCB shared buffer area (%#llx - %#llx)\n",
 			       scratch_gpa_beg, scratch_gpa_end);
-			return -EINVAL;
+			goto e_scratch;
 		}

 		scratch_va = (void *)svm->sev_es.ghcb;
@@ -2580,7 +2589,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		if (len > GHCB_SCRATCH_AREA_LIMIT) {
 			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
 			       len, GHCB_SCRATCH_AREA_LIMIT);
-			return -EINVAL;
+			goto e_scratch;
 		}
 		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
@@ -2608,6 +2617,12 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	svm->sev_es.ghcb_sa_len = len;

 	return 0;
+
+e_scratch:
+	ghcb_set_sw_exit_info_1(ghcb, 2);
+	ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
+
+	return 1;
 }

 static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
@@ -2658,7 +2673,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)

 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_CPUID);
 		if (!ret) {
-			ret = -EINVAL;
+			/* Error, keep GHCB MSR value as-is */
 			break;
 		}

@@ -2694,10 +2709,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 						GHCB_MSR_TERM_REASON_POS);
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
-		fallthrough;
+
+		ret = -EINVAL;
+		break;
 	}
 	default:
-		ret = -EINVAL;
+		/* Error, keep GHCB MSR value as-is */
+		break;
 	}

 	trace_kvm_vmgexit_msr_protocol_exit(svm->vcpu.vcpu_id,
@@ -2721,14 +2739,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)

 	if (!ghcb_gpa) {
 		vcpu_unimpl(vcpu, "vmgexit: GHCB gpa is not set\n");
-		return -EINVAL;
+
+		/* Without a GHCB, just return right back to the guest */
+		return 1;
 	}

 	if (kvm_vcpu_map(vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->sev_es.ghcb_map)) {
 		/* Unable to map GHCB from guest */
 		vcpu_unimpl(vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
 			    ghcb_gpa);
-		return -EINVAL;
+
+		/* Without a GHCB, just return right back to the guest */
+		return 1;
 	}

 	svm->sev_es.ghcb = svm->sev_es.ghcb_map.hva;
@@ -2788,11 +2810,8 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(ghcb, 1);
-			ghcb_set_sw_exit_info_2(ghcb,
-						X86_TRAP_UD |
-						SVM_EVTINJ_TYPE_EXEPT |
-						SVM_EVTINJ_VALID);
+			ghcb_set_sw_exit_info_1(ghcb, 2);
+			ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_INPUT);
 		}

 		ret = 1;

base-commit: 70f433c2193fbfb5541ef98f973e087ddf2f9dfb
--

