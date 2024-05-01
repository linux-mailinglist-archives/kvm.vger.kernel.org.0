Return-Path: <kvm+bounces-16380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB598B91FD
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:07:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB54AB22D2D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 23:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F5131304A1;
	Wed,  1 May 2024 23:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WtOmTfIK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E662D1635D0
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 23:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714604859; cv=none; b=ncjeBe8Ic3ePH9GylIm8ptPqR4uI5K4O4WYxhv430sVnOzSLHiQqyJfqceIadN48m0e4flgE0Fh2Smb2nbUHc3cJoYGO4Z58F4rsMpspbSYJEw1laadk0m+SyJ3upxF88+I7ZbWLddjZrRQT8Uyqi8GAb6Pw9UNoyxO+Uy/T3fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714604859; c=relaxed/simple;
	bh=4QDGvas4u9w8udrkJBB6Q7Kg1UUo6G22Iv+BP5EKegM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HLvvqRH7Qur95RmqhVQuERUO3qjvobWmNcaY1lYAhbQsLIH+rEyv8VaqpkWHrhfIT+Sn1kQU1Im2pMpRq4GQKkgMAe9VD1VcYHrjDcX1BDZ5tay5hWOUnAo5CJ2iow2LKy1n4gXmwWfgRHPxCrFJcvup/9EC4Ma4k9t9WYQ/hWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WtOmTfIK; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b2ef746c9so138404907b3.1
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 16:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714604857; x=1715209657; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hcfy46ofNDIF08JDPxCSwUXWD3ohxE7j32bndZidSTQ=;
        b=WtOmTfIKE+Pe3nFawO4tn+kdHDia6cl6rWovBhp4cOrEseZqY1+KJOL5UkjpAQr95c
         fGHjIITEdJc8LpdfIGKFxw2pFxDFGa0y7HFAoC3VIFDvENUwoagyS7bMciThMRNttX3c
         vlsBW5HOumKiTWvglqeAETcNzE/zLMQ5xkRKSExamVRvsaoyhc/o/mTLsv0IxruIK2Ax
         5CFSl4DwOHUONLy79liwK5HU+ZkbmUvEzGrxMTHswMx69NMiBQq/4HxNSdLRfS1UuczV
         r4zVnwHtqD4juYdPgCRHfeqVr8oOXIObs0w5DTCtydq5g+UPeqzx685jJelB/Ao6B7lA
         7Fig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714604857; x=1715209657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hcfy46ofNDIF08JDPxCSwUXWD3ohxE7j32bndZidSTQ=;
        b=V8bc96STxU6RfbYTNHorsJvMD3bnZ1nAvkZ7rDbvaCMNyS+wBzmq1bOkF23OrUXR4y
         3IUZKNT4MRmJuInWZqpuD0L10E+N45GrMtNz3YVBfDr7qB5R2+DHKheDPfwglaA4ldw+
         XUnkkrErhl9UQKMruXpCBEAMr+bW+2VEIyNG+OIBzhDTKtVsqoRFJDyvu7DF0me6MRt6
         6xAf00DkunBNu0LM6TwJX1zSlW5HCDZzpcPR3Qz3JxMr4Rd/UJxA0ORIq/w16G+iIAVv
         9rfo75/u6PTbdkmVnMUGIyFg9sDAdM6S3VaeeYMwzFtOdH3IJR0J1BxKHCmJsFnoDuOD
         1tFg==
X-Forwarded-Encrypted: i=1; AJvYcCXY9L1p7imKeWb4hLEuQba5WROQEyCCpK2s9mBuLkozJCzyyjoLqqCsaYxZrgzx/3XSzhK/vhfYwluvpCd04ziOq+sO
X-Gm-Message-State: AOJu0YwBMGRjTrjuidvw1turx6gF4vBCMzxdmQ8dis/sCfUVz3WXHXQd
	0c7YBcJxInLLB6A7VqrcbU20eh0MkJhmBeQyNnX9Zl9bz6Q1RvMqtp8WHt2arQae/zCj1iYDmw/
	8WQ==
X-Google-Smtp-Source: AGHT+IEoso9E1EzUZlOXERGVZBES24HUmNdhkCjXroYBDlZzz/sTnYht/qkC0ZK79I1dSTlWsUaLZS+I51w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e212:0:b0:61b:e2eb:f05 with SMTP id
 l18-20020a0de212000000b0061be2eb0f05mr75358ywe.2.1714604856835; Wed, 01 May
 2024 16:07:36 -0700 (PDT)
Date: Wed, 1 May 2024 16:07:35 -0700
In-Reply-To: <20240219074733.122080-23-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-23-weijiang.yang@intel.com>
Message-ID: <ZjLLNyvbpfemyN5g@google.com>
Subject: Re: [PATCH v10 22/27] KVM: VMX: Set up interception for CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Feb 18, 2024, Yang Weijiang wrote:
> @@ -7767,6 +7771,41 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>  }
>  
> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> +{
> +	bool incpt;
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> +
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
> +					  MSR_TYPE_RW, incpt);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
> +					  MSR_TYPE_RW, incpt);
> +		if (!incpt)
> +			return;

Hmm, I find this is unnecessarily confusing and brittle.  E.g. in the unlikely
event more CET stuff comes along, this lurking return could cause problems.

Why not handle S_CET and U_CET in a single common path?  IMO, this is less error
prone, and more clearly captures the relationship between S/U_CET, SHSTK, and IBT.
Updating MSR intercepts is not a hot path, so the overhead of checking guest CPUID
multiple times should be a non-issue.  And eventually KVM should effectively cache
all of those lookups, i.e. the cost will be negilible.

	bool incpt;

	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);

		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
					  MSR_TYPE_RW, incpt);
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
					  MSR_TYPE_RW, incpt);
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
					  MSR_TYPE_RW, incpt);
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
					  MSR_TYPE_RW, incpt);
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
					  MSR_TYPE_RW, incpt);
	}

	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
	    kvm_cpu_cap_has(X86_FEATURE_IBT)) {
		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT) &&
			!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);

		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
					  MSR_TYPE_RW, incpt);
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
					  MSR_TYPE_RW, incpt);
	}

