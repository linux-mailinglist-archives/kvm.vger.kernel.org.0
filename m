Return-Path: <kvm+bounces-45840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4927DAAF753
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 12:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 855754E1352
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 10:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06CA1F37D3;
	Thu,  8 May 2025 10:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OGKZ9AvX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345121CBE8C
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 10:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746698531; cv=none; b=iKwrrOHocB6MgdkkLWqrLRhGTvfL7yksC/hSur+zr/gPj54/aXZ7rxmw3OtB8bvd7cgryeneBdcNDTFrBL1+FTUwYeqLmokhZWz9sVhji5lhnOceyZ7jbs8w1THDXrCOCG+kp+jmC09/hmkc/lMPDNM6IOdjijul42NP09XvIgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746698531; c=relaxed/simple;
	bh=dD3XhLv3aLEgd9xznXybGYKnL30+PEHqHxV9/ZWuREQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Gjg776GxZVfl5pw8vRPlQVit7h9QiaaFUWc5USWw3wmbCkd0b2Ng/2ENn5lnDoGtMjNiv7VQXy8CfyyH3iDVzdtOrV1AnQuN9K9Qs/4ZfFsMxebkZtQ+uMI4EirdS46EJWbWdyiPxTxxgg1E9rtC0BOWfaTiUfwx5pMiwRllPAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=OGKZ9AvX; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a0bb8f974aso27444f8f.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 03:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746698528; x=1747303328; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBoYS0wz++EQw8/z3GxgW1EZr6KbY89jyHXnVjV8trs=;
        b=OGKZ9AvXSCzPjBXsG0vy+i7kKicv94Ap26LZwjqrfS3n66x76yARcfYEIxpaY3l7Ux
         jdDfhhluyw9f21EijLdI7mM/tGAbyIHL/g/kFmKGtl7U1tkt9r6xaEL+QKSPp4EuRCU0
         ILWH+EwwH72PCEWam5B8nl9cUZ8j42vSuoxjjlzQa71eluP0BNecal7Cqnnqpml7GKfq
         srckRmiZuEiAciHAUWnBQ+B+eV3CsKt9Aenj+Jo8K8eWVpMLToIW87SclAlb20ggM3EY
         wCYSny06qk41PQnpKx3vxicu9v1b1GEHeWmBGXTO5NwxCkMVM+6SiJoGgENKEXPI9VrB
         TH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746698528; x=1747303328;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WBoYS0wz++EQw8/z3GxgW1EZr6KbY89jyHXnVjV8trs=;
        b=dPoXPzegWp9WwJ3d+XryVe/iR53CMtrnQvhD4C/PKIZvJM9t0NsN5WaCMUb3wQI0re
         d4XcNqDy2xOyp6+PRUonBD57ODBon3oBcsmshbRbzpMVNKEU/K1QbHFvLZPwrql2z7U0
         KO0dvj8k1IjZeMHHdU61oS6VoTWkuCFBsP+xr978n4rZoOozatASTT+kTCzCABOzMS9g
         15RtVAt6EF5MO7SyfWbvboGBrWbZ2Nj7dZZ3Fmp6welPrInTT+aIH26syPI5jpDzfNay
         WaFLURkOGeVP+XWDn+EKzxjntv7zRyTXWwtNrjMNdbTC6Nf1FHhGK1IVRlYXLXZsSJGk
         6m6Q==
X-Forwarded-Encrypted: i=1; AJvYcCViqR/jHa9Wm0gFWmJo/IcbkRrpk9GIA8B/BW1l86Oh9euB3pWR05XBH+gpNAhSEyDeegY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywng9fvRGJHuCmbAcC4KG/fzOlAK8vTVeupgmbhPkK5+nfFko3W
	rI5wmDV1qJoNdaYzLdr9DjmZM18bBD+E3y7vQeXCRR+MuAcM32xWj17C45Dq/lQ=
X-Gm-Gg: ASbGnctrtiGSg4m8u+Vxf/siIywVP9rMjiS38uIHoCKLH0ZRNpCHAzHHLz9EAT5aAF6
	H3lCKQbumf6G8diYw55DgFZHb3aN+zIeNpktMih9dgt0ChvoivW+d7EaF1yhEreticJK/ZIe+k9
	ZkMrwdrkBH9fyTDw6ygg7x1M2hqHOEGyGN7pMpuDF6mqSbXGSXVl1TmlKvZlkXKy6WZFrO1LRKk
	a3/Xo5KlsBnxpz4bxn2Km7eutSvBS04N6b9K472R5CsCRZjOW3pud3jkOlI+cARNiV98uHYMusZ
	F8TqHB0WsxE5K29GaFx3xCk3wcgznPSSkwGyIQ3tIoKHbl3N5X8s2+D/Yfs=
X-Google-Smtp-Source: AGHT+IHUaQx/Mee6s3Ke3xU/t61RV8r367qD/26lQfVX2YZuAy0gm6pedVbgXrEeJfa8XZl3movr0A==
X-Received: by 2002:a05:600c:1c97:b0:43d:301b:5508 with SMTP id 5b1f17b1804b1-441d44bc487mr21958065e9.2.1746698528415;
        Thu, 08 May 2025 03:02:08 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:a451:a252:64ea:9a0e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae7caasm20004897f8f.54.2025.05.08.03.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 03:02:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 08 May 2025 12:02:07 +0200
Message-Id: <D9QOY9TMQXSX.2VOEKVRCXKOO1@ventanamicro.com>
Subject: Re: [PATCH 3/5] KVM: RISC-V: remove unnecessary SBI reset state
Cc: <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Atish
 Patra" <atishp@atishpatra.org>, "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Andrew Jones"
 <ajones@ventanamicro.com>, "Mayuresh Chitale" <mchitale@ventanamicro.com>
To: "Anup Patel" <anup@brainfault.org>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-6-rkrcmar@ventanamicro.com>
 <CAAhSdy3y0-hz59Nrqvvhp=+cWJe1s50K7EpuZmKBqfy-XQFd1Q@mail.gmail.com>
In-Reply-To: <CAAhSdy3y0-hz59Nrqvvhp=+cWJe1s50K7EpuZmKBqfy-XQFd1Q@mail.gmail.com>

2025-05-08T11:48:00+05:30, Anup Patel <anup@brainfault.org>:
> On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcm=
ar@ventanamicro.com> wrote:
>>
>> The SBI reset state has only two variables -- pc and a1.
>> The rest is known, so keep only the necessary information.
>>
>> The reset structures make sense if we want userspace to control the
>> reset state (which we do), but I'd still remove them now and reintroduce
>> with the userspace interface later -- we could probably have just a
>> single reset state per VM, instead of a reset state for each VCPU.
>>
>> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
>
> Queued this patch for Linux-6.16

[5/5] was already applied, which means that [3/5] would be nicer with

  memset(&vcpu->arch.smstateen_csr, 0, sizeof(vcpu->arch.smstateen_csr));

in the new function (kvm_riscv_vcpu_context_reset) where we memset(0)
the other csr context.

Should I add a patch to do that in v2?

Thanks.

