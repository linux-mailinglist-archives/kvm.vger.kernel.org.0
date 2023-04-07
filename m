Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656146DA704
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 03:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239290AbjDGBjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 21:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjDGBjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 21:39:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CBD5FFB
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 18:39:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x15-20020a25accf000000b00b3b4535c48dso40618441ybd.7
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 18:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680831544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cnRzfyzI+UY6zqZu7950JAiupbhaGdQtV9MG+1slD40=;
        b=Y4524jRw3W+rLRsHRjuLlT9k7xi/MKQdxqdP39rTMH31JAwcXg/T7RAlYDa00xKnHM
         BLHHvnUSaElmfo4D1komDu4DICeBntRTZtnX6afs3vytQ787D0fF8ZUQCPGdDLJDK2FB
         wfdewcjzzxnF2vDrG4u5Bo1WpfbzYS55YfIOBuEQhaPQgB7eKCCY2s++K3wgUANmSN+L
         s5fitK3gubAuPeA2exKjwS/dNSbyyQ3jxhyp5ioa/txncG0CFd76sKBIWfHT0PihB/0u
         Agy+pVUqnF924Y150/8wDl/aVpDubX32ssRYcYX/19BUbu7LqeMhDbPc+FYpEMUxmQLe
         PjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680831544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cnRzfyzI+UY6zqZu7950JAiupbhaGdQtV9MG+1slD40=;
        b=JIB3EWFOQBYeqBlHE229MlT/E7hvI3pbbDoqcdQkJb0tPSVgjgVNzotzytMgSloYjA
         M98j3JWMh7+JRyVGYDwWRnepBbNS2fPcsDYmgvaeVZHOH0JEBkhttBiCvSapQz0X3k19
         17sl4jvko2JLAUOK4LtXuytaBTnaAMb5iVprbkMHs27nmdp1x6+32gSNRWaRrCivD8XO
         6/f3GR0zcyFndaySkKMay/eMHgpFckHwJ4+UM29lflOD9p6OtQVfG3iUo0bwTABhPbKp
         LPRJQ8MpHRP5eWvYmHcx18NvFcZQVGF5cRpjKWFCrH3qakNMY5+/XqZOIS8cyFsxD/X6
         YpSA==
X-Gm-Message-State: AAQBX9eML5ETzakOn5Ziv72WEUDqotaZxSODYJE6Fou+lBsF4kERIDDn
        b9Tatwz224Z38alUpJ7f6MTfYvgdbPY=
X-Google-Smtp-Source: AKy350b5Vsgx2wZUSbTO2NknkQL1122pL6zWUjx9ESwdl2mDLmZED3lD3f2PMeKjFd1n69JEwkvaeA7sPds=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:431e:0:b0:545:883a:544d with SMTP id
 q30-20020a81431e000000b00545883a544dmr175931ywa.9.1680831544075; Thu, 06 Apr
 2023 18:39:04 -0700 (PDT)
Date:   Thu, 6 Apr 2023 18:39:02 -0700
In-Reply-To: <20230214050757.9623-7-likexu@tencent.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com> <20230214050757.9623-7-likexu@tencent.com>
Message-ID: <ZC90Ni/DaoObtE7o@google.com>
Subject: Re: [PATCH v4 06/12] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs
 handling x86 generic
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Feb 14, 2023, Like Xu wrote:
> @@ -574,11 +569,61 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
>  
>  int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	u32 msr = msr_info->index;
> +
> +	switch (msr) {
> +	case MSR_CORE_PERF_GLOBAL_STATUS:
> +		msr_info->data = pmu->global_status;
> +		return 0;
> +	case MSR_CORE_PERF_GLOBAL_CTRL:
> +		msr_info->data = pmu->global_ctrl;
> +		return 0;
> +	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +		msr_info->data = 0;
> +		return 0;
> +	default:
> +		break;
> +	}
> +
>  	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
>  }
>  
>  int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	u32 msr = msr_info->index;
> +	u64 data = msr_info->data;
> +	u64 diff;
> +
> +	switch (msr) {
> +	case MSR_CORE_PERF_GLOBAL_STATUS:
> +		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))
> +			return 1; /* RO MSR */
> +
> +		pmu->global_status = data;
> +		return 0;
> +	case MSR_CORE_PERF_GLOBAL_CTRL:
> +		if (!kvm_valid_perf_global_ctrl(pmu, data))
> +			return 1;
> +
> +		if (pmu->global_ctrl != data) {
> +			diff = pmu->global_ctrl ^ data;
> +			pmu->global_ctrl = data;
> +			reprogram_counters(pmu, diff);
> +		}
> +		return 0;
> +	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +		if (data & pmu->global_ovf_ctrl_mask)
> +			return 1;
> +
> +		if (!msr_info->host_initiated)
> +			pmu->global_status &= ~data;
> +		return 0;
> +	default:
> +		break;
> +	}
> +
>  	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
>  	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
>  }

Please tweak these to follow the patterns for other MSR helpers (see below).  I
don't actually mind the style, but people get used to the pattern and make mistakes
when there are unexpected deviations.

int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
{
	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
	u32 msr = msr_info->index;

	switch (msr) {
	case MSR_CORE_PERF_GLOBAL_STATUS:
		msr_info->data = pmu->global_status;
		break;
	case MSR_CORE_PERF_GLOBAL_CTRL:
		msr_info->data = pmu->global_ctrl;
		break;
	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
		msr_info->data = 0;
		break;
	default:
		return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
	}

	return 0;
}

int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
{
	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
	u32 msr = msr_info->index;
	u64 data = msr_info->data;
	u64 diff;

	switch (msr) {
	case MSR_CORE_PERF_GLOBAL_STATUS:
		if (!msr_info->host_initiated)
			return 1; /* RO MSR */

		pmu->global_status = data;
		break;
	case MSR_CORE_PERF_GLOBAL_CTRL:
		if (!kvm_valid_perf_global_ctrl(pmu, data))
			return 1;

		if (pmu->global_ctrl != data) {
			diff = pmu->global_ctrl ^ data;
			pmu->global_ctrl = data;
			reprogram_counters(pmu, diff);
		}
		break;
	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
		if (data & pmu->global_ovf_ctrl_mask)
			return 1;

		if (!msr_info->host_initiated)
			pmu->global_status &= ~data;
		break;
	default:
		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
		return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
	}

	return 0;
}
