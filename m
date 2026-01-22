Return-Path: <kvm+bounces-68919-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yAl/JwBfcmnbjAAAu9opvQ
	(envelope-from <kvm+bounces-68919-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:31:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 325ED6B56E
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D421D3056A51
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA093859D0;
	Thu, 22 Jan 2026 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oiwTiO4P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163313806A4
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769101009; cv=none; b=Ds0IhEbuZPkv4QjoZTvTW7SjJbfI+V8/TFGVJuYudRFwxTFLKMWLyxzJrf5zQx7jT/rC5fbdE7Gp53FtHto+6CbBEZbZ+a++EWABsLl0epWvFmXazHeYPzchNFj9fZnN/HBEa/mlW5iFTWx9W2crRJLWgJFdoL009OebjE4aIwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769101009; c=relaxed/simple;
	bh=Yf+igg/0T/SpQYPavLQMecLpXEeSCNSZYUcGUDrvzCY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CV1paalT+Ei2D5mrzx2qobVMSeywx/nM7h+8Hm7M6Ybuj47MBEVvwv26f5jocp/8C3O78XO8uZ3AITrozNWJhNvpAw+ab8xOM98638Fyqq7SFwmQGSita6+Q4b7SAmA5lontvRncqOrscjHEPWvGduHYgJLELjVz6OLXIhmnHAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oiwTiO4P; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab459c051so2297871a91.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 08:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769100997; x=1769705797; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+IiM9zxRKuZ+6sYf4z2FhEzx3BA+tRZU19IyCToaTCc=;
        b=oiwTiO4PbzdYKQxlU3BoDVMEUp2RymOy2wrZ8tKcNIjZxXC+tiAPsQ972SYK8Qjoht
         t26+kP7RBI5i+MmJVShlWeBFdipbsWwdz8To48ib/fE2iWls5PfPN0OvFz8QmV0mnYKL
         E9sFcvC8SOh4dwtUgQ4aBln3PcbRhtcNO8HERI29Winj+t9vAT6ioCS2FsL6xJIbC/vK
         Olc8jwry6UfMnmqMXozjccI5bL3sDt7xPwMdMMEum4YSyinVT+mARADqFlNa0yqLCmuS
         PzK1/Iqs++r2BmackYerl8BQlaVhGWE43ZWENd0bRDFxu/Tmvw/e40ywGkdLBu6hYerU
         n0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100997; x=1769705797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+IiM9zxRKuZ+6sYf4z2FhEzx3BA+tRZU19IyCToaTCc=;
        b=lldVPD2TUv1A9H6QfB4A1VHhJfCYQHQFgZcfGIGuFGgqXL5VppcbTrToa+5G+clT1q
         GXxF80J6RDdUmzqYdB4RJFwmogYt8jIigYK6emZdlAAwTrXhWe97p9fCJQWqNj+v4vf8
         6kMEDlc6AUUUhsiBzDNKrp5xbY2Lm52CxzxC+vPDyGCfyZu9txt/s7LnPVYBCRc3Zbdv
         AwdAQUPVno74zxE95rtVMn4N0G6R9yvTJUtSv0x3D01DmenFSioK0PTSgeLQRa9gev+h
         trjcMNYDTeQL4tyXtTEWN0Omcke/ycMu6iuV1kw2UA0GFi7TZNMgCkNWQBXcXRTrc7+J
         uA4A==
X-Forwarded-Encrypted: i=1; AJvYcCVULS+qNLJihvvSKu1TjXo6KyampRorIk/nXvo0tJuu/AJNnFNgg+KHlIJ6QPPWmziD2WM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjgscsr80V5VHiIEhk/T85ROwvcTIVDG3z4ooVQAPtlXXlQf+w
	vXhF5DguOJNXLgQARi9+pqENfNwfKgDpQCkJHDpZvP7ng5mCCGlHhp7F1Vvnw/bGoNyfhtbcVtq
	Q1ye0Dw==
X-Received: from pjbmj3.prod.google.com ([2002:a17:90b:3683:b0:352:b687:3b20])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b07:b0:32e:38b0:15f4
 with SMTP id 98e67ed59e1d1-35367015637mr155901a91.7.1769100997358; Thu, 22
 Jan 2026 08:56:37 -0800 (PST)
Date: Thu, 22 Jan 2026 08:56:36 -0800
In-Reply-To: <20260121225438.3908422-6-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-6-jmattson@google.com>
Message-ID: <aXJWxIzxf8nLTPSB@google.com>
Subject: Re: [PATCH 5/6] KVM: x86/pmu: Allow HG_ONLY bits with nSVM and
 mediated PMU
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68919-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 325ED6B56E
X-Rspamd-Action: no action

On Wed, Jan 21, 2026, Jim Mattson wrote:
> If the vCPU advertises SVM and uses the mediated PMU, allow the guest to
> set the Host-Only and Guest-Only bits in the event selector MSRs.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 85155d65fa38..a1eeb7b38219 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -262,8 +262,13 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>  		pmu->global_status_rsvd = pmu->global_ctrl_rsvd;
>  	}
>  
> -	pmu->counter_bitmask[KVM_PMC_GP] = BIT_ULL(48) - 1;
>  	pmu->reserved_bits = 0xfffffff000280000ull;
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SVM) &&
> +	    kvm_vcpu_has_mediated_pmu(vcpu))
> +		/* Allow Host-Only and Guest-Only bits */

Meh, no comment needed if the macro is more descriptive.

> +		pmu->reserved_bits &= ~AMD64_EVENTSEL_HG_ONLY;
> +
> +	pmu->counter_bitmask[KVM_PMC_GP] = BIT_ULL(48) - 1;

Spurious code movement?

>  	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
>  	/* not applicable to AMD; but clean them to prevent any fall out */
>  	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

