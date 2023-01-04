Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB4E65D9C8
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 17:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbjADQ3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 11:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240121AbjADQ2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 11:28:32 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279C33FC8A
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 08:27:54 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o31-20020a17090a0a2200b00223fedffb30so34824417pjo.3
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 08:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p5ldDYIOXfvjTc4b7EJAJFOKCZXF3rJ2nLQt59UJk44=;
        b=Si1p1uZKMKgyRnjdIvLXnojExDV9ZK1rRqYqjWMbzUTveSQerXE071iqeblGg4GHSZ
         1KjX4A0dVJO2IBwh9ZUH3ZmEe7O9cnYKyHbRHDFgXcj9EZaPWI+wSv0rm2k17/uCNF2N
         qcubAjIZUnSg+nGqu1LVq5PAkIJYQKSKuI1jLITCtM4P02/LIf6x5gh2AguPDMHZRm8S
         wy62QEomimNBNSjda9cJAkIzLFk8Zw9pBT7wetgGgB1xMGPhHiWtuUj7PskUZGk+Pi0R
         gjEFWxg2Yl2Tl683w/Ttr5Ezj3EVccJ5YkC3Mq451ByA928icLllPtn0uh/hKhp9VvBV
         guDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p5ldDYIOXfvjTc4b7EJAJFOKCZXF3rJ2nLQt59UJk44=;
        b=yIjD2dbHcxRQShDG9/g6esKdsdOGG5DGx3DLlI1Cy4tFfGxLyM4JcmZPRPEmf6Pcok
         relymG2y6+Wf+9a1VxmVtmY1dauq+VTAnTJMhBn8IIQBiF3vmnAJqXoKhBWpZCf6zvG9
         fs4OWad5835dYAIcUJW3B07S66wvNc2YW4aerekXOA/ik6u8XArbCQNZtxhVePtOYU4m
         wInpuTmwyCk3ZUoOFhhJuXmVFT+orw2kG+bhpfULkM/N7ZFOpcv6TRMZPsDH2XI8FiVu
         EEZBAVmCCGp9tSBamRXJqXT3+0KTV+z0Qst3TvjiSDs2rmziZ6r5fmCgPcXMfmLBXmYB
         zpsw==
X-Gm-Message-State: AFqh2kr52DkiozdN97iP6VJ80G9S6gT8KOLRfqqmNpEbX/NdPRjx3sZq
        WAxPS+ZbxxlKUyhMJTSK6wq/Sg==
X-Google-Smtp-Source: AMrXdXu8mMtXWTK1RWwNPLvw0Ofzeg7CfYQc6Zmv3knrG55MAkZn5NM5UYCz148yt+fXTIgvsW50kw==
X-Received: by 2002:a17:902:d4d1:b0:189:3a04:4466 with SMTP id o17-20020a170902d4d100b001893a044466mr4712627plg.2.1672849673390;
        Wed, 04 Jan 2023 08:27:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x17-20020a170902ec9100b00192b93a6ce4sm9106786plg.86.2023.01.04.08.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:27:52 -0800 (PST)
Date:   Wed, 4 Jan 2023 16:27:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86: Ignore host accesses to higher version PMU
 features MSRs
Message-ID: <Y7WpBSx5fBJFhFR4@google.com>
References: <20221226111710.51831-1-likexu@tencent.com>
 <20221226111710.51831-3-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226111710.51831-3-likexu@tencent.com>
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

On Mon, Dec 26, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Higher version PMU features are obviously not supported on hosts with
> lower version Arch pmu, such as trying to access FIXED_CTR registers
> and PERF_GLOBAL registers from pmu.version >1 on a host with version 1.
> 
> Ignore host userspace reads and writes of '0' to those PMU MSRs that
> KVM reports in the MSR-to-save list, but the MSRs are ultimately
> unsupported. All MSRs in said list must be writable by userspace, e.g.
> if userspace sends the list back at KVM without filtering out the MSRs
> it doesn't need.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f570367463c8..fcb9c317df59 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3881,6 +3881,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_DS_AREA:
>  	case MSR_PEBS_DATA_CFG:
>  	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> +	case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
> +	case MSR_CORE_PERF_FIXED_CTR_CTRL:
> +	case MSR_CORE_PERF_GLOBAL_STATUS:
> +	case MSR_CORE_PERF_GLOBAL_CTRL:
> +	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr))
>  			return kvm_pmu_set_msr(vcpu, msr_info);
>  		/*
> @@ -3984,6 +3989,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_DS_AREA:
>  	case MSR_PEBS_DATA_CFG:
>  	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> +	case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
> +	case MSR_CORE_PERF_FIXED_CTR_CTRL:
> +	case MSR_CORE_PERF_GLOBAL_STATUS:
> +	case MSR_CORE_PERF_GLOBAL_CTRL:
> +	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:

Having to manually handle each MSR is again a maintenance burden.  Rather than
manually add the affect PMU MSRs, I think we should just allow benign accesses
to all "MSRs to save".  The lookup will be a linear search, but the array isn't
_that_ big and this should be a rare occurrence.

That might also make it easier to handle non-PMU MSRs that want similar treatment.

I'll send a series with the patches I've proposed, along with the patch to clean
up the unimplemented MSR printks[*], which was never formally posted.

[*] https://lore.kernel.org/all/Y1wCqAzJwvz4s8OR@google.com

---
 arch/x86/kvm/x86.c | 51 ++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 87bb7024e18f..4ad7e3065c69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3561,6 +3561,18 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
+static bool kvm_is_msr_to_save(u32 msr_index)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_msrs_to_save; i++) {
+		if (msrs_to_save[i] == msr_index)
+			return true;
+	}
+
+	return false;
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	bool pr = false;
@@ -3884,20 +3896,18 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.guest_fpu.xfd_err = data;
 		break;
 #endif
-	case MSR_IA32_PEBS_ENABLE:
-	case MSR_IA32_DS_AREA:
-	case MSR_PEBS_DATA_CFG:
-	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
+
 		/*
 		 * Userspace is allowed to write '0' to MSRs that KVM reports
 		 * as to-be-saved, even if an MSRs isn't fully supported.
 		 */
-		return !msr_info->host_initiated || data;
-	default:
-		if (kvm_pmu_is_valid_msr(vcpu, msr))
-			return kvm_pmu_set_msr(vcpu, msr_info);
+		if (msr_info->host_initiated && !data &&
+		    kvm_is_msr_to_save(msr))
+			break;
+
 		return KVM_MSR_RET_INVALID;
 	}
 	return 0;
@@ -3987,20 +3997,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_DRAM_ENERGY_STATUS:	/* DRAM controller */
 		msr_info->data = 0;
 		break;
-	case MSR_IA32_PEBS_ENABLE:
-	case MSR_IA32_DS_AREA:
-	case MSR_PEBS_DATA_CFG:
-	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info);
-		/*
-		 * Userspace is allowed to read MSRs that KVM reports as
-		 * to-be-saved, even if an MSR isn't fully supported.
-		 */
-		if (!msr_info->host_initiated)
-			return 1;
-		msr_info->data = 0;
-		break;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
@@ -4256,6 +4252,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
+
+		/*
+		 * Userspace is allowed to read MSRs that KVM reports as
+		 * to-be-saved, even if an MSR isn't fully supported.
+		 */
+		if (msr_info->host_initiated &&
+		    kvm_is_msr_to_save(msr_info->index)) {
+			msr_info->data = 0;
+			break;
+		}
+
 		return KVM_MSR_RET_INVALID;
 	}
 	return 0;

base-commit: eee17ec1d2c43ab3fcba604c4b88c6eb2d728fcd
-- 

