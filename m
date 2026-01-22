Return-Path: <kvm+bounces-68909-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8CfGAx9VcmkJiwAAu9opvQ
	(envelope-from <kvm+bounces-68909-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:49:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E76B6A4B0
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:49:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 593723009B33
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53392436379;
	Thu, 22 Jan 2026 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y4v2IVtM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C62372B46
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097858; cv=none; b=N+kIyXlf+WVA7yd3Uk5uluZFVXppK/d1nictgPFQFynR9vqTtFJCQHm77ORkBOZX9wXZdzGdu2WPXc5YInjS0w6EKCySCW1T32zkpc27rtEKawBweXrXx4Aw0c5tUVeSIl+uhvZ3OpmM6+OHBffGdxagxn/gBUnTU1pxyr4/mUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097858; c=relaxed/simple;
	bh=viNnaReSsAyqS/zLOY2ifZng9HyswNpsZThiO/XVk1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VxbFwaITfyo0iHRaVjaMEcxJLrrM+DPx5fzYBooFZkKd5vSiwf6t+9CwdfYoo7Xacrz720NhV4elF1GHmM1dO/h06X2tA7YFqb5EcnQL2C4FX8+9525WK3ftvbBN3HKMeIhGX1f4Spa4XeXDCsr/mFgonjjX0pg+tm8OoXk/xas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y4v2IVtM; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a79164b686so15553365ad.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 08:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769097848; x=1769702648; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LD2LZ6P6QaQ5VD5Wh4MR8dbmyUc9EnoiEwigMQRIrTc=;
        b=Y4v2IVtM0BkDOyuRdJqbjoJxqyfmoGS39JUV2Bo/sM19bW5u6wojwwa35/8lFRDzA1
         quVRKzDNcgwIl5CtdbyNKtsAJmJB9tm6PZDKXDP8neXc9BZX1p9roP7ve17ug39vutro
         urTIOulDUu0OA381er/9Kz+YhvEPbORgueJ67uVT8jLh8qqAjdFFUNvElpf+gMCtNKuz
         dKeSHHy9lsgGHVTCbAXg/GRnJJTzgwYepOYzMNywryy9ccXy2nUgTf32VR7JZr+4MSDO
         NvBuVi+BGLBPoEOpBGKcv8FLgL4FSMrjNjTT9z5EsnAHqHxTOXtf/6PUTFsgDH6zFie+
         bwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769097848; x=1769702648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LD2LZ6P6QaQ5VD5Wh4MR8dbmyUc9EnoiEwigMQRIrTc=;
        b=gbOdf6nzse0Uz8WkXebEe6BvdzVtrjryW5zmYEIm68z2ziIUWbIpkQSBIWVeAut61A
         BQ6484p+iqlU8TAOaOYlxZbQ2IcwNfFmXd0NC2yrc9Cvajrx3YIWqBJ7KOMdFDjrRkVg
         VzsuuAV2b+ofPlUPcFzUsDHx2vSQf9t2PZ8FfL48vls0FH2p8kHVb4f0XMfbmsr0FdpK
         x8nTAvf9roEVvcGXjZAFq3qu9KH623amZpogVZl6FMJX9gK602tEsKQCgj8tUosix2BV
         Y+bsBBWFReLGuEQz1mgNzs3zHw/JA7hyro5lVpLHSovtRalOMLpxs6uXeYIdutiqVnBR
         whYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvueQNlsu+mSR0unZj711Qfy0KhhBjCYuc579lztEL3Fta1OoLam8Jrk66CdRViyNzlM8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5bwFXvp5FwRauSMD7xl+biVhhwJrBo48DXHokk8DK9gIpwZCv
	zDYjaV9XaDsvuiJd7t4SL1sRNpTN3TEH93We/o+PcszgkNrkMgcvO+dqlwa6qEbK/mQrE3zd7+W
	bexAjOA==
X-Received: from plbmi13.prod.google.com ([2002:a17:902:fccd:b0:29f:cd:e7da])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec90:b0:2a2:d2e8:9f25
 with SMTP id d9443c01a7336-2a76ad742e9mr77688705ad.33.1769097848122; Thu, 22
 Jan 2026 08:04:08 -0800 (PST)
Date: Thu, 22 Jan 2026 08:04:06 -0800
In-Reply-To: <20260121225438.3908422-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-2-jmattson@google.com>
Message-ID: <aXJKdlJI3fg42gim@google.com>
Subject: Re: [PATCH 1/6] KVM: x86/pmu: Introduce amd_pmu_set_eventsel_hw()
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
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68909-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9E76B6A4B0
X-Rspamd-Action: no action

On Wed, Jan 21, 2026, Jim Mattson wrote:
> Extract the computation of eventsel_hw from amd_pmu_set_msr() into a
> separate helper function, amd_pmu_set_eventsel_hw().
> 
> No functional change intended.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 7aa298eeb072..33c139b23a9e 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -147,6 +147,12 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	return 1;
>  }
>  
> +static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
> +{
> +	pmc->eventsel_hw = (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
> +		AMD64_EVENTSEL_GUESTONLY;

Align indentation.

	pmc->eventsel_hw = (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
			   AMD64_EVENTSEL_GUESTONLY;

> +}
> +
>  static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -166,8 +172,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		data &= ~pmu->reserved_bits;
>  		if (data != pmc->eventsel) {
>  			pmc->eventsel = data;
> -			pmc->eventsel_hw = (data & ~AMD64_EVENTSEL_HOSTONLY) |
> -					   AMD64_EVENTSEL_GUESTONLY;
> +			amd_pmu_set_eventsel_hw(pmc);
>  			kvm_pmu_request_counter_reprogram(pmc);
>  		}
>  		return 0;
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

