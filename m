Return-Path: <kvm+bounces-32192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D22CB9D416D
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:48:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45E91B2E90B
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502C215AD9C;
	Wed, 20 Nov 2024 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OegT9nIc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAB81474B8
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 17:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732123291; cv=none; b=ECOi9LsRqwrO/J/8wXaXiEKEYJ60s8lszLSkxkayO82bJUmJ3yrkgaR9bey12gjHSYreegQV8f7+2ky7WCsIvkyMSI1dnPlWobTe9zqm4A+XEdonz+yUbqwMgxYs6QfLWuxqX7kjYnHThhq0cbuKiuQP7zqaVrcQcxt2t7GYKVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732123291; c=relaxed/simple;
	bh=CJop96nqHatEPlDl540FRcn9W9BaV0zzMn5/xJ3Vb7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Way2ls1VKgJcy2VScygMIGwh9Hqo54/jONdY/7al22sq+Ume9/39Y/0tpuPDluvY7HQhkxHXvI1oD7qU14pimrihmdbRobL/uOpZ0jHGRo8LlJIHCXsOrf870bvWX0NDoxxfQCVfmBAenkpPTRblYntpanTSky/dgZjwBIm+f9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OegT9nIc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea4c541b61so41054a91.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 09:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732123289; x=1732728089; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QYm1+/DifmKIs47tY/E+e2Kkbg+hWFuHiR3gJIBG9So=;
        b=OegT9nIcel8NzVP/VKHkc/8AV49Kk8Av7ctR3ZkpilhArlZAoEO9Lve7q2nqx+aPcW
         w82P6NC6Z2yMDNPfQvpvHu24MsY8wEwbnuAIa9gBnL5lIAJxVkCJDjk+rPWUcNHbrf2X
         PJVYUuwE/PXI/Ik6F6c8wcSIRGEW1PW6HIvA2hsBf2cCsmEPIQDsWMChcpLes+W8Zamb
         VprLo+vV9sZW4YDPLfnE9NN9wlMCfcwSCjG2UEJmcI9HT+97p/cUIU0yqA49Zq4ILxq2
         b+nwGvgwGPT0od6vMzJHOUndHC/GuIoIYacE3kBaFmujR5UVnvrId3bhDxbyZSCCLNtX
         i3rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732123289; x=1732728089;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QYm1+/DifmKIs47tY/E+e2Kkbg+hWFuHiR3gJIBG9So=;
        b=AFwhhTInKkbepU17I10FR2aiI8Dfw8haXrM4hYhzUbrFHYxcqdQoPs8FqzIz3E8gWZ
         WDZgBgtEFetqTE+zFT2SjU/HCnSi1g7xVrP0pnYDPPd2OdsNtpN6sqpXcOZBxIPIhA09
         InS1ufssgNcDk++KL1rA92oemg1kOQASfmdfvz/CdPgbY5Pu2cJi1N8/GCbftIYlSZsC
         xnbB2H4tYjgGLrfURpVsgC72nptU4uyU5s29D8XuSM1dRkEnGZtZRdfquIfgXZCrW/HX
         pbv12ZgK2XjLxiDE2pYkhfHEvKN57elxzXfkqHpAXu4RyjdCEGZ1lG3lYNmTjgFZ4EOy
         y0GA==
X-Forwarded-Encrypted: i=1; AJvYcCU14/LgLD2n4T6KlvUzcveNYhrXTjTnpJLL3DhlKqH11vFBtmAO3awQvvhEhvFo1rCE8fo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQepj2IxmLkIN5VNQoylSDMnHwQF6PGCzyQF98CCBx62S5d4YR
	5lHoOuLbu2oYlf/MYAHzCvhBYEZSsLiS3J95ZIXmduN+h2fn0/4q002FUtl7f0mq3+oO5w6x8Am
	l2g==
X-Google-Smtp-Source: AGHT+IFjM0AHV5w/pbVAw/W0N+Azm1Wcmv5XEOjBbMHF+D0N9N9UFx2xjFQJDpvv+DaYVc55A5nUDXwA2wg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2389:b0:2ea:9ae0:6374 with SMTP id
 98e67ed59e1d1-2eaca7db47fmr1930a91.6.1732123288237; Wed, 20 Nov 2024 09:21:28
 -0800 (PST)
Date: Wed, 20 Nov 2024 09:21:26 -0800
In-Reply-To: <e0e402d8-de8b-40fa-9d1f-270d8033d33c@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-25-mizhang@google.com>
 <ZzzE_z5x7D_trxnq@google.com> <e0e402d8-de8b-40fa-9d1f-270d8033d33c@linux.intel.com>
Message-ID: <Zz4alrnDbQhqtkGl@google.com>
Subject: Re: [RFC PATCH v3 24/58] KVM: x86/pmu: Introduce macro PMU_CAP_PERF_METRICS
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 20, 2024, Dapeng Mi wrote:
>=20
> On 11/20/2024 1:03 AM, Sean Christopherson wrote:
> > On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> >> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >>
> >> Define macro PMU_CAP_PERF_METRICS to represent bit[15] of
> >> MSR_IA32_PERF_CAPABILITIES MSR. This bit is used to represent whether
> >> perf metrics feature is enabled.
> >>
> >> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> >> ---
> >>  arch/x86/kvm/vmx/capabilities.h | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabi=
lities.h
> >> index 41a4533f9989..d8317552b634 100644
> >> --- a/arch/x86/kvm/vmx/capabilities.h
> >> +++ b/arch/x86/kvm/vmx/capabilities.h
> >> @@ -22,6 +22,7 @@ extern int __read_mostly pt_mode;
> >>  #define PT_MODE_HOST_GUEST	1
> >> =20
> >>  #define PMU_CAP_FW_WRITES	(1ULL << 13)
> >> +#define PMU_CAP_PERF_METRICS	BIT_ULL(15)
> > BIT() should suffice.  The 1ULL used for FW_WRITES is unnecessary.  Spe=
aking of
> > which, can you update the other #defines while you're at it?  The mix o=
f styles
> > annoys me :-)
> >
> > #define PMU_CAP_FW_WRITES	BIT(13)
> > #define PMU_CAP_PERF_METRICS	BIT(15)
> > #define PMU_CAP_LBR_FMT		GENMASK(5, 0)
>=20
> Sure.=C2=A0 Could we further move all these=C2=A0 PERF_CAPBILITIES macros=
 into
> arch/x86/include/asm/msr-index.h?

Yes, definitely.  I didn't even realize this was KVM code.

