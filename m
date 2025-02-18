Return-Path: <kvm+bounces-38454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6917A3A1DC
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 16:56:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 200D37A4945
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 15:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E2D26E17D;
	Tue, 18 Feb 2025 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="orOvZGbL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336CD26E14D
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 15:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739894175; cv=none; b=f5buguVPevjrn+rUmkwDOyE3A+c+RxYMKeA26N5Rkf5gvtz+oCwU9/8ga3hEp04tgS2z0qdXOxPLrfTcMvNZjlgHfZSxfaqViXz2LYIq/zlfcUEfUfb7qYqXuP9Q8O8VVrpnHoVfuHZMk5TVltFy4RusMTYKyX3yFqvFe09C/sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739894175; c=relaxed/simple;
	bh=OxwXkUwfdd9O2efR81hHEid3P6MZbMOImo0mqZ4pV7k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V2HDqEl/n6gQwCF+PBZpSyI/u7QRhS0BlgtF9fAsFg3x1FyZ2qK6BD746oNJkQu9mVGLS9Zgy4BrzM5/Wen3IxvcMAZfcgHYPN6weGMqAKhBKxX3/ftrLIm23p+9TExQxDbF3516DMZrGLC2mWw1DhFTTrii04Rlaiumlz6mbRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=orOvZGbL; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220bf94cb40so91571065ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 07:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739894173; x=1740498973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=amAiEH9p0JjjlIoDG8vUk3rwkUw6ePiV6D4s+4AzIhM=;
        b=orOvZGbLM+7JZ9GKfGoj0TXDsRDvdotK5RssVMwnnaVmGZi5NOywhDK7S+46xcFWJi
         Vfz2DHLl99gWNAOx65qT/vgEY6HFTFGjMCnQiAiaUzYyZIgRfkFrNnBswGeR897uhP33
         1e3lxix99c0zp/jSRQjVCxWXL9/eWGJ49vf7P48QAjlDVLt3a87oIBddYv7v3c7vYgsv
         vsr0+/MQ2aGaN/eOY4ygo+Q8VWqALzFbQF6pB6D1FTxOx7TDhPCu12wHqUQSzl4bFfl5
         EK9PHje4HERedn9LxBH9FLz/tW3hF9zjQik43CsvA9gIK45W+u0i2bxjfphdF8lzKThN
         0f9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739894173; x=1740498973;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=amAiEH9p0JjjlIoDG8vUk3rwkUw6ePiV6D4s+4AzIhM=;
        b=s4zqYiRQmEDzLAVeYCjc/hcRyFhy5qMlV//eVXQYyGuSqtgn7g/l3tHvrA7P0S5tRd
         Tn8km2UvHP0QIGo/DLXUZmns15WSHIZgdi2iQDgEKOncSHT5ua4dmeL3enNWTjt6AZ4l
         weVX3rkQ0Goi/cZNvzza0Sd4aop2ceAS6tZCB3mK95X2pQa5J2aTqzyma72pqw5c5leU
         8tuLAljWh9Qr3XPA41biUYmEcZYbSs4CS27R3FT+iKeXlHsfxC5xihqw5aAWoKNCdc8B
         +TVYPENTp/NhoFKxeUG58p482kA2eIN0biCh6PCO4ExIeE4GPDaBt9cneseQksAYtVcZ
         XPZA==
X-Forwarded-Encrypted: i=1; AJvYcCWIp/PfHVqTnXBWYRcYgP29Ujg07KdZ8FHR3DEinrj9re867SYFLfdY9E763/4gYvfNv5I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEy6iqRw149B7xjCCGjmGDEuupbR0lKrZ+J33S04Nftx5qOym9
	UV/mkIrHhLXflnVTKL4NoRiXYXxALP6ZgbH2FWs+eWVnnxZHHfrCWbR4i8yTei33LWRQqck2vP5
	LDg==
X-Google-Smtp-Source: AGHT+IFPqhKGvpTcG3WvR15xNdlmCcTHSx2dYyPg7ppYF/3/HBUysYafNH489eXc+eCO/BIvXlJ+wjUhZ0c=
X-Received: from pghb5.prod.google.com ([2002:a63:d805:0:b0:ad6:992d:5743])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:999f:b0:1ee:6ec3:e82e
 with SMTP id adf61e73a8af0-1ee8cbf7ac0mr26906261637.29.1739894173031; Tue, 18
 Feb 2025 07:56:13 -0800 (PST)
Date: Tue, 18 Feb 2025 07:56:11 -0800
In-Reply-To: <cf013079-ad8a-4b07-bbcf-6f35d1126a92@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
 <20240914101728.33148-6-dapeng1.mi@linux.intel.com> <Z6-wbu7KFqFDLTLH@google.com>
 <cf013079-ad8a-4b07-bbcf-6f35d1126a92@linux.intel.com>
Message-ID: <Z7Stmz1VUE-cZUzq@google.com>
Subject: Re: [kvm-unit-tests patch v6 05/18] x86: pmu: Enlarge cnt[] length to
 48 in check_counters_many()
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025, Dapeng Mi wrote:
> On 2/15/2025 5:06 AM, Sean Christopherson wrote:
> > On Sat, Sep 14, 2024, Dapeng Mi wrote:
> >> Considering there are already 8 GP counters and 4 fixed counters on
> >> latest Intel processors, like Sapphire Rapids. The original cnt[] arra=
y
> >> length 10 is definitely not enough to cover all supported PMU counters=
 on
> >> these new processors even through currently KVM only supports 3 fixed
> >> counters at most. This would cause out of bound memory access and may =
trigger
> >> false alarm on PMU counter validation
> >>
> >> It's probably more and more GP and fixed counters are introduced in th=
e
> >> future and then directly extends the cnt[] array length to 48 once and
> >> for all. Base on the layout of IA32_PERF_GLOBAL_CTRL and
> >> IA32_PERF_GLOBAL_STATUS, 48 looks enough in near feature.
> >>
> >> Reviewed-by: Jim Mattson <jmattson@google.com>
> >> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >> ---
> >>  x86/pmu.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/x86/pmu.c b/x86/pmu.c
> >> index a0268db8..b4de2680 100644
> >> --- a/x86/pmu.c
> >> +++ b/x86/pmu.c
> >> @@ -255,7 +255,7 @@ static void check_fixed_counters(void)
> >> =20
> >>  static void check_counters_many(void)
> >>  {
> >> -	pmu_counter_t cnt[10];
> >> +	pmu_counter_t cnt[48];
> > ARGH.  Since the *entire* purpose of increasing the size is to guard ag=
ainst
> > buffer overflow, add an assert that the loop doesn't overflow.
>=20
> This is not only for ensuring no buffer overflow.

In practice, it is.  As is, there are *zero* sanity checks or restrictions =
on the
number of possible counters.  Yes, the net effect is that the test doesn't =
work
if a CPU supports more than ARRAY_SIZE(cnt) counters, but the reason the te=
st
doesn't work is because such a CPU would cause buffer overflow.

Yes, there are more nuanced reasons for using a large, statically sized arr=
ay.
If the goal was to support any theoretical CPU, the array would be dynamica=
lly
allocated, but that's not worth the complexity.  If the goal just was to su=
pport
SPR, the size would have been set to 12, but that would incur additional ma=
intenance
in the not-too-distant future.

> As the commit message says,=C2=A0 the counter number has already exceeded=
 10, such
> as SPR has 12 counters (8 GP + 4 fixed),

I am well aware.

> and there would be more counters in later platfroms. The aim of enlarging=
 the
> array size is to ensure these counters can be enabled and verified
> simultaneously. =C2=A048 may be too large and 32 should be fair enough. T=
hanks.

No.  Just no.  Unless there is an architecturally defined limit, and even t=
hen a
sanity check is strongly encourage, KVM-related software should never, ever=
 blindly
assume a buffer size is "good enough".

