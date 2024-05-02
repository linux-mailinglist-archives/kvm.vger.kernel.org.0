Return-Path: <kvm+bounces-16458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 664ED8BA415
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 789A51C22731
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E59346557;
	Thu,  2 May 2024 23:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1VeE8fRn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DBA2D045
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 23:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692965; cv=none; b=RsKn2NFvRwpMlwgxI9ll0caVVU417ITd0nf8gCz0VojJshx5cuZfwwlMXCXTWfAZBJjDx1AMHiNULZwu0yAKlNkPY4H9JAfKNNst4bJkBx78GuodM20Wwn54SNjN775SCg/19Dn3DtuwRtMQczTqGipU+XeoXbN1bk2Y9EZZte8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692965; c=relaxed/simple;
	bh=0dwj6bRBqsUtQYoDeVUdjqbm8P3ym0YXikVZmUYSRdg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iSo72ETV7yYWR5l3nD4Mbjh5b9ZZQNvVV3SHyDX2ikkkLomUroD0X2iJyEMFgKaqLQmfXN3lQutjs+ecTlJBX5GkPYi0BHMoeVwedSGp9cbCfxpBBNt55F8FIcT/CQ/O4sEANBYTdSvvwnnJMBxiamSeG4nOTNdfLHC/1XPO4/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1VeE8fRn; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b269686aso14501333276.1
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 16:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714692963; x=1715297763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ecRZPEHvExqS79AgCnGYCH1KXuiTZnddDvYfe16C7IA=;
        b=1VeE8fRnBIorSrPVUWyvqzfvH/wKv8lACmUTx1LfWg2LEOLY2gwKRNWZnnP+ZJtD1N
         qHfa3VVxF8WALXvnpAWgI/gNPjW+mNQXsjuLdBTOu30zFlNS1p36PXaaX3f426J3Wx8s
         FIZxMRshRSK/H6HzLMwGUeurX1isfVKkyTsdqqjKAThi48EwLkn6MLnz6Pbl3scetCQU
         s/U9TXvJk77iS7clxRsR4OHF3Iz+oD9G+dWsDMvzwPB4i/34MYoVPheuMTi7iW3dCkH4
         CkOiYRet/MnCoBqQ3RE+ineycnQ1q15ZH5gbNwAV4TWBtEFC+1g1hRk0gElNZHOJqy6o
         4YeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714692963; x=1715297763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ecRZPEHvExqS79AgCnGYCH1KXuiTZnddDvYfe16C7IA=;
        b=eh0PZQ06LdGFboSFQ9EDtuuHrJE4kPiYQEGVgdTvDOAUCfUTUSEjeFeOK5EIM2G2fa
         7Pm3XUat8VnjNuYlagPnkrTEfapT41TH4V2RXz+FxMTcyPCHT9xmiMF7pwHg/+xiTHyi
         NoG9+8G914ir9TNibSIyXK5anvFpi1HyIFxt7xVkhbZg+U013Z741+lE078/XwdUuedQ
         r5i/BypbLfZSa6kq+3z0WR+3uQxuBALmRB6SI9R1NyjzBY33tOfgBrCW/vMOsLBr/51w
         wFbr5NhQzbkkkaM8F3itT5LIcl9Pj+Y+KEca2ui6xnrE+n7/MuakruKXHfqLB70SRTxm
         vZIA==
X-Forwarded-Encrypted: i=1; AJvYcCUzmhk/NHXqbdlG9d7Iqyhfst8mdwA6+Ztqqs+0rZkVG7tjSjyN3MATOb4KwC+eBG0G0PpMKy7LNgnKNrk7kvu27ZJP
X-Gm-Message-State: AOJu0Yy+a6oGA3IlfjKGtuGsXAkS78H8/T/sdBws4EYHcbskd76SmJ0g
	oVEWw2uwPCDaG0yUPKAKGouIY7RXxSivNIpIzbI7YDxiZi/UGRnTvTQoUiTk0u90VzgzYfFoPGY
	WaQ==
X-Google-Smtp-Source: AGHT+IH8smrXS8uR5PTJLZQ+0LYn4C/hOdclLpqwTA1bf34fQgFNnBWZMMKNl0IRxZ/fICwotoG+8uya7h8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1788:b0:de5:bc2f:72bb with SMTP id
 ca8-20020a056902178800b00de5bc2f72bbmr179258ybb.12.1714692963300; Thu, 02 May
 2024 16:36:03 -0700 (PDT)
Date: Thu, 2 May 2024 16:36:02 -0700
In-Reply-To: <20240425125252.48963-4-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425125252.48963-1-wei.w.wang@intel.com> <20240425125252.48963-4-wei.w.wang@intel.com>
Message-ID: <ZjQjYiwBg1jGmdUq@google.com>
Subject: Re: [PATCH v3 3/3] KVM: x86/pmu: Add KVM_PMU_CALL() to simplify
 static calls of kvm_pmu_ops
From: Sean Christopherson <seanjc@google.com>
To: Wei Wang <wei.w.wang@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Wei Wang wrote:
>  #define KVM_X86_CALL(func) static_call(kvm_x86_##func)
> +#define KVM_PMU_CALL(func) static_call(kvm_x86_pmu_##func)

...

> @@ -796,7 +796,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  
>  	memset(pmu, 0, sizeof(*pmu));
> -	static_call(kvm_x86_pmu_init)(vcpu);
> +	KVM_PMU_CALL(init)(vcpu);
>  	kvm_pmu_refresh(vcpu);

I usually like macros to use CAPS so that they're clearly macros, but in this
case I find the code a bit jarring.  Essentially, I *want* my to be fooled into
thinking it's a function call, because that's really what it is.

So rather than all caps, what if we follow function naming style?  E.g.

	memset(pmu, 0, sizeof(*pmu));
	kvm_pmu_call(init)(vcpu);
	kvm_pmu_refresh(vcpu);

and

	if (lapic_in_kernel(vcpu)) {
		kvm_pmu_call(deliver_pmi)(vcpu);
		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
	}

and

	switch (msr) {
	case MSR_CORE_PERF_GLOBAL_STATUS:
	case MSR_CORE_PERF_GLOBAL_CTRL:
	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
		return kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu));
	default:
		break;
	}
	return kvm_pmu_call(msr_idx_to_pmc)(vcpu, msr) ||
	       kvm_pmu_call(is_valid_msr)(vcpu, msr);

all are easier for my brain to parse.

