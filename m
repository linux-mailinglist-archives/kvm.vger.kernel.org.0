Return-Path: <kvm+bounces-57265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6239B524D0
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 01:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60DDB3BABE9
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 23:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 435C927AC54;
	Wed, 10 Sep 2025 23:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2mCtkSek"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1B626C3AA
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 23:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757548335; cv=none; b=l/1glhT+KQWxH78P4V5j3QeZG3pWCbArNakbEx90cr1cgf0o5B/E870tjtqzeujVdR+AfiSwBBlsjQ+GH0lB4CiOQ+3x3Vf2iR30ed2ivASwZ1xM/65c++7aXI3/VSOTz8VVNsk/cJj20Usy+D+SizLqaOw0yf5cR5/rb8Rl9jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757548335; c=relaxed/simple;
	bh=tVUpNQOROq9+jlSa8LLGRdwgNWfNk74taL5qHGVt9Xg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q6zXtvlCCnI7GhseLSHSAxaOu7lGiCI7NrK4P6NDNPM4qQF99T7OWUWT7jj0lv5nGVfx8oNTIgKtBG7EryJW2AGxgTeBnjFB02D2KrtRsksJ/iB+ePtaH7qcRtqonIk4JUFTa/qdVI2OZcI+jvMPEJnDIssYI8sIm0U/bUjdHag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2mCtkSek; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2490768ee5fso651945ad.3
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 16:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757548333; x=1758153133; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3rAHhmeH8sJTP78PdX0dK4yvZeVt6rR4NVHVr4IfA9M=;
        b=2mCtkSekZ89YjIRXyhPbBeHL9DGPAgDTiN4NTKVvVrwiKBJWoaXd+ZiUS8Yc1bqdbq
         9QiLkWBT/bEF6NA7Trv95G6uAK+xzBt2GX0GkLxE6JwYvsqdUwCaIXxb/Gc8AR7rbze0
         3dJG80NhUW1ghWntGY+REVvdV2D6tx5tB4AD0lnmNFrfYKaAT9cZqiS0F6Rq+QmJ+kxJ
         HuRZ3CZUu20IZLQ5fVFQ8N4QarhMIKi2OaCUgE83fv8PNwnUCJkyT+gXAxbj7EI6gCp1
         m7Is8vo3XmwF40XIEptGncGODkM5IPZzwHy7acas7XxX92OEBcIHLvpxRFQVEs5nUXV8
         MXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757548333; x=1758153133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rAHhmeH8sJTP78PdX0dK4yvZeVt6rR4NVHVr4IfA9M=;
        b=MjmLgTYMijoVj7yAztUuOhMsnTPGs7MEzlFfeIWnvZjX7fjKpft88tmDAvUrp8TXMJ
         HNodQlFX2adI/AtoU1DoYRaAWwe736Aw8reFxlGo/YmcY8nYSXresdBdo8Z5/wz/wH8J
         3XYHHDM+KfocHFySiM9VQUycSKGHX3nCQIFd7Olkqz2iUudj9EuPd4fGRaGR3MvqpWvg
         8ZiG+pa5MPmjVkEUbNxgw+5en1pvA/epIW0FSRhd7MRTzRNN79vVJM9sVLHG/dQEiv3r
         R6NsgdXaYeKsMKNWHLltOWB3mM4EkMR0PTS/ELuaA88glfdjI8cxH1ks6UG0x5Ib6xNs
         8uQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtt2LqzWt207jaAu8hFGJWRylmYmF3k+M6AEYH2MjGciCmEqaR8yBMQKXXctJm2IR5xI0=@vger.kernel.org
X-Gm-Message-State: AOJu0YycZkP0BzInjSBANcP4qA0f12AwgkcPW5yvFJbPyjPtvamTlSzk
	LeT5Yw/GkVGxLvJQEE32uxJPivV9cVewu/OvWH+X80HJlQlOoZYKpVEUwsS7OfL++iMXt5HNffz
	jToOTfA==
X-Google-Smtp-Source: AGHT+IFA3ruNLr+sT0ree4DZgAhIHgbm/pxlct4LCBwnUU2QphoTyCXP+uQnYftz53uytoX5q83Ncq51mIQ=
X-Received: from pjbso4.prod.google.com ([2002:a17:90b:1f84:b0:32b:97a3:490b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce82:b0:256:3dfa:1c98
 with SMTP id d9443c01a7336-2563dfa1e6cmr166065135ad.11.1757548333161; Wed, 10
 Sep 2025 16:52:13 -0700 (PDT)
Date: Wed, 10 Sep 2025 16:52:11 -0700
In-Reply-To: <20250718001905.196989-6-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com> <20250718001905.196989-6-dapeng1.mi@linux.intel.com>
Message-ID: <aMIPK6ZeTi3_iLzc@google.com>
Subject: Re: [PATCH v2 5/5] KVM: selftests: Relax branches event count check
 for event_filter test
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Yi Lai <yi1.lai@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Dapeng Mi wrote:
> As the branches event overcount issue on Atom platforms, once there are
> VM-Exits triggered (external interrupts) in the guest loop, the measured
> branch event count could be larger than NUM_BRANCHES, this would lead to
> the pmu_event_filter_test print warning to info the measured branches
> event count is mismatched with expected number (NUM_BRANCHES).
> 
> To eliminate this warning, relax the branches event count check on the
> Atom platform which have the branches event overcount issue.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---

This can be squashed with the previous patch, "workaround errata" is a single
logical change as far as I'm concerned.

>  tools/testing/selftests/kvm/x86/pmu_event_filter_test.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> index c15513cd74d1..9c1a92f05786 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
> @@ -60,6 +60,8 @@ struct {
>  	uint64_t instructions_retired;
>  } pmc_results;
>  
> +static uint8_t inst_overcount_flags;
> +
>  /*
>   * If we encounter a #GP during the guest PMU sanity check, then the guest
>   * PMU is not functional. Inform the hypervisor via GUEST_SYNC(0).
> @@ -214,8 +216,10 @@ static void remove_event(struct __kvm_pmu_event_filter *f, uint64_t event)
>  do {											\
>  	uint64_t br = pmc_results.branches_retired;					\
>  	uint64_t ir = pmc_results.instructions_retired;					\
> +	bool br_matched = inst_overcount_flags & BR_RETIRED_OVERCOUNT ?			\
> +			  br >= NUM_BRANCHES : br == NUM_BRANCHES;			\
>  											\
> -	if (br && br != NUM_BRANCHES)							\
> +	if (br && !br_matched)								\
>  		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
>  			__func__, br, NUM_BRANCHES);					\
>  	TEST_ASSERT(br, "%s: Branch instructions retired = %lu (expected > 0)",		\
> @@ -850,6 +854,9 @@ int main(int argc, char *argv[])
>  	if (use_amd_pmu())
>  		test_amd_deny_list(vcpu);
>  
> +	if (use_intel_pmu())

Checking for an Intel CPU should be done by the library.

