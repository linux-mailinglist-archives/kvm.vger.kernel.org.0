Return-Path: <kvm+bounces-50514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90626AE6B6F
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 17:41:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F8D51C401AF
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FE03074A7;
	Tue, 24 Jun 2025 15:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WZK6ZJ3A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615812D4B7C
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 15:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750778876; cv=none; b=gn6p2qm+jEn3Qk33vWxITKM5x5geD7EYic7bjq2jr8SdhxbASiV/r275WV7hJIyi0zsFIEyEU8W7cMw7fdOKNQ7ndVXu0AdTGzF6keSlr0+X487X/t2MRTA87R3izm6AYcgO36t5g+BK5nrTusNu3TxteCsT0H/GOUx1hhy0K30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750778876; c=relaxed/simple;
	bh=MepxRO2ogI5XQ3ZUzw1gcXY64ic46PvTDY+KYhuA9P0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rjlUVuzrYfnqF5C8cIUgwM8HWoWGiJQqHwCxicE/0XI7xFs+Wk8sDhMqkIon6sOKaaMp0Q24u4p/8BS2+kJ8d6MGiJ8qWuyHzjXu/1Bx/Il+0xEhRb5131siGhu+dclWcMYijNtP3sAHXtvg3rqN5wRAPnXr9nnkTVfRH2W8tWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WZK6ZJ3A; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2349fe994a9so43506615ad.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 08:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750778874; x=1751383674; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ozpzeYt4xTkvHRuQkIJTdoQYtXmcQ7LICuVmYRW9gk=;
        b=WZK6ZJ3AuiGdvP2b+SBCaWG2/HwwkhXTBNXfMqnckLRQMPj0MJ4iZ14Hmp7ZdULO+X
         DslGD5rMmwc6tWFnbIFSQzHR16uUTpRLwPi7KaAhdE7EBprCSyzT0Dtx8nI84pDwcqNk
         zYBrRrQTWp5ZrjAb+2LUgUD3S4ki7FqBl3QGomQ5bOgxJWrFhUAUVvPsQy/eVLZJVPqB
         uoVml+AG9ETMzACojMoKizPs0JQu64axF4SZJMV6N/QtqESGESuMJ7cwfUI4g0LJ7dvX
         ssg4lzk41nqtojkamz36RhZVOV9VYnQ9hefZhYPxWTZ/8V8utCGKB1x0/KIL2YSWvnBY
         Scog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750778874; x=1751383674;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ozpzeYt4xTkvHRuQkIJTdoQYtXmcQ7LICuVmYRW9gk=;
        b=GeSS+qwOLrC4HA7uktsKy5g45RNxTQj1hvI/i8kSq/GGJY6UPSp7m5DZWkZA4BFvj5
         OdPq2nESQj6BNx9tzMPxp9wUkckvNotam39rG9nQGuCTKpMYPl8UDRKzvsV3Eub5TGf9
         IHGbQ6Bqj5x8q4ArZ1/RtJ0jwr5dM1M23bPqmdHCm94ws7TSNYhr3mEIMCy4VuvFkayA
         DUTsVBYvFCTAcz8Aqrk+aAf32ZgOrGT2rEZiXEqrCxEq7t0zTJ8Jte6ji/1cqRZdSm2V
         GObfuKUTalgLxLYRVLWr5w73le6l8iLWrt2aGRwhkiRg3GnTAYW2x7cvf6OJwL71er15
         ggcg==
X-Forwarded-Encrypted: i=1; AJvYcCWwG3/Q2X/GxXuqv0uNcMpWGjq1IJL/2fTHTDmtpfroSHeGfcq1II604COaotYJwrn+PsY=@vger.kernel.org
X-Gm-Message-State: AOJu0YykValtNcCo7Ayi7oUaY/8lPxtvNwDQf89L5p+oUtUGu/RWmICY
	3vED/wAxoO2jY+gO5azUxXX5rHkEsu8xTo+8YSVgOZczXTKRy8y693x4TJXWhGH/ifb/EB4axdm
	oNBUGNw==
X-Google-Smtp-Source: AGHT+IFUejh1pO/KNNRbnpHWhaff//dtVImgTpNy+o6XsUzk8HP9FdRsW+ItyD5wajOAd09IzHcqdYMV9uY=
X-Received: from plbky5.prod.google.com ([2002:a17:902:f985:b0:223:f7e6:116d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dac6:b0:236:7165:6ecf
 with SMTP id d9443c01a7336-237d9a7c3a9mr312281565ad.38.1750778873740; Tue, 24
 Jun 2025 08:27:53 -0700 (PDT)
Date: Tue, 24 Jun 2025 08:27:52 -0700
In-Reply-To: <20250328171205.2029296-7-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328171205.2029296-1-xin@zytor.com> <20250328171205.2029296-7-xin@zytor.com>
Message-ID: <aFrD-Pn9cmHcVxWs@google.com>
Subject: Re: [PATCH v4 06/19] KVM: VMX: Set FRED MSR interception
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, andrew.cooper3@citrix.com, luto@kernel.org, 
	peterz@infradead.org, chao.gao@intel.com, xin3.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 28, 2025, Xin Li (Intel) wrote:
> @@ -7935,6 +7945,34 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>  }
>  
> +static void vmx_set_intercept_for_fred_msr(struct kvm_vcpu *vcpu)
> +{

This function should short-circult on

	if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
		return;

Functionally, it shouldn't matter.  It's mostly for documentation purposes, and
to avoid doing unnecessary work.

> +	bool flag = !guest_cpu_cap_has(vcpu, X86_FEATURE_FRED);

"flag" is unnecessarily ambiguous (eww, I see that the exiting PT code does that).
I like "set", as it has (hopefully) obvious polarity, and aligns with the function
being called.

> +
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, flag);
> +
> +	/*
> +	 * IA32_FRED_RSP0 and IA32_PL0_SSP (a.k.a. IA32_FRED_SSP0) are only used
> +	 * for delivering events when running userspace, while KVM always runs in
> +	 * kernel mode (the CPL is always 0 after any VM exit), thus KVM can run
> +	 * safely with guest IA32_FRED_RSP0 and IA32_PL0_SSP.
> +	 *
> +	 * As a result, no need to intercept IA32_FRED_RSP0 and IA32_PL0_SSP.
> +	 *
> +	 * Note, save and restore of IA32_PL0_SSP belong to CET supervisor context
> +	 * management no matter whether FRED is enabled or not.  So leave its
> +	 * state management to CET code.
> +	 */
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, flag);
> +}

