Return-Path: <kvm+bounces-48097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E89AC8C9E
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 13:09:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 488611BA53BB
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 11:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADBE226D1E;
	Fri, 30 May 2025 11:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="a5KKOTlm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E609222562
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 11:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748603388; cv=none; b=cX2bLkyl2Ih1wGylUhltLl1yVTZ1ohSBJl58fvJH5SHC4I02RvquLbznUOPkjv4MwIuZMGbcwDu5DJuzv8SfLbGaYWJqI0R+H9xes2ngHxJiCr1FUsDqiZi3swWcus0XTnAziFAfltvXP//907hpVNY0xqHo+tcrY7tTCiXy004=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748603388; c=relaxed/simple;
	bh=or/cFM9w3xIlM9jzAAD47M+TFLTk+EUJQ2P/TRJDHnI=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=gXLLj5EPXGUp8JPV5PDE9Zc6BKokHg3Wx+QiDoeC/3/cQ6RQEXfDw/DF2I8YvAsLEvroGsnmly6SFjT34pi3TZcyFZeYV9Jv4RVU3omdKnomFi7oBGdpDp2rP3iLQp4Am+4ro9wjMmSu7fC3g3D9O6PEXqfmDKXvs+DYvCIWgkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=a5KKOTlm; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a4e62619afso301111f8f.1
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 04:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748603385; x=1749208185; darn=vger.kernel.org;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKHlHU74s9id5ECnlxromIqBTzfUbM5l+HheDzzqFcg=;
        b=a5KKOTlm8lrvJCvoAepNsW3t3q2KNwi5cWQTG+qGawkks7iWwDjfblbRcvnee5eex4
         FZ3SCMRvIUjqwaUvP1RGL/zbOpNTFjq7V0ADheLDIydQKTyxn1RoAgYCUNZj3tyatQ+/
         CZl/MaXmHT7K85xstZC3JVbYEJ5jBRhS7jMTyZlABVBVwnD+JBlqfJ6pj+zyVcLQmw0u
         9ZjLuq9wZaJiP3ogOxftwAFeOuHSGioevRjJGMr1iQPmNRyveL62VB2zI2YRw9s57JAK
         HgHw9Ewjiq7zOSS5ZS7+ILicRtCBDS2iKUKyYNjSdDYIeANMqF8OYy/aAVma9q5ggZef
         fOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748603385; x=1749208185;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nKHlHU74s9id5ECnlxromIqBTzfUbM5l+HheDzzqFcg=;
        b=sBrZW5F7gZx3zdw7IfVUaxeWDukhB1SdM+HJk9SDT9KA6DP/cwpm5aoWqnsn7DpGYF
         M4pRHZ3MMnB+ly13ridY5v9sPm//v6+7iSQwke447bk3MK+HAEJL/NwDdao6eASfhgwP
         4QKsK5RP3qziQeY9VKrjIVOn4P0gXOgnuLpmJsODP8lz9qZHVLYqF/XYJsf3EhWel+IG
         xrF8tgITJorNBhJwOKoDgRUchjHj2k+BwOZeRZ5kz57w/8LgDkBciWsjsbXAQh6iyLn6
         8x3smQUTBb9nzaUmP/Sa/VPvSLkHkbS7Q5xQOr0Tghd1vCXo4Ckm+0DE82HTJJMa2MYN
         q0zg==
X-Forwarded-Encrypted: i=1; AJvYcCX6uAdOJjS0p283OwaWhnkPZv8G6vZymbdXfi7HivFO4vZ6VXTKfU+Bv01yyvQK++TTocs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9I2v+7J6ax8gmG8TCGDrnp8KSGV+CJmh/hD/OXczMlTeeyOtS
	9Fnx6veJcBCS07c7GI9zPP/JOPYEB6zseJeSBSYlZgEDGEaaVaztlBPZYXkznkspGiU=
X-Gm-Gg: ASbGncu0CEqLI71dXBq7CvxOJsS8z12SMveL3XlJxFLQAgjp4CnoUmTvq6xvTT/SN1s
	xeHldwICy4wW4W3E/t/OD97aCX5HeSXkU/NQGa84nIP5dedkA9G7Fvgjtc2Bh3pHeaeg5t+KTC8
	acdsRdLWPKk9RcLFzR+ac/eQ2z4XqdLRrrByCTBtLgO0pn9XzCupoYAF+ruBqrmOH6UC1j+/BA2
	iTsGAA5AqhA0H1gDmY2s0s3BZnZ6Ktk+MESugW7Qog8MbgUx3xRul2iIsqUhjygz7peSLsuYXl+
	ZFZ6QzHsb3vY76z2EUEimQYAODgN7rccMvv7BCbUq3VYXtTHsqOZSQTxpls=
X-Google-Smtp-Source: AGHT+IHWlRXsHj8fy3YljEwKBbucuDh540moRSz1XXe7HUhMOymhGLaK6eZjYnDZtJV/6QwPDY4NXA==
X-Received: by 2002:a05:6000:228a:b0:3a4:dbdf:7152 with SMTP id ffacd0b85a97d-3a4f7ab6c2fmr730169f8f.14.1748603384676;
        Fri, 30 May 2025 04:09:44 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:23dc:ac4e:5f79:355b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4f00972c1sm4593368f8f.68.2025.05.30.04.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 04:09:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 May 2025 13:09:43 +0200
Message-Id: <DA9G60UI0ZLC.1KIWBXCTX0427@ventanamicro.com>
To: "Atish Patra" <atish.patra@linux.dev>, "Andrew Jones"
 <ajones@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version
 to 3.0
Cc: "Anup Patel" <anup@brainfault.org>, "Will Deacon" <will@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, "Paul Walmsley"
 <paul.walmsley@sifive.com>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Mayuresh Chitale" <mchitale@ventanamicro.com>,
 <linux-riscv@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
 <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
 <DA3KSSN3MJW5.2CM40VEWBWDHQ@ventanamicro.com>
 <61627296-6f94-45ea-9410-ed0ea2251870@linux.dev>
 <DA5YWWPPVCQW.22VHONAQHOCHE@ventanamicro.com>
 <20250526-224478e15ee50987124a47ac@orel>
 <ace8be22-3dba-41b0-81f0-bf6d661b4343@linux.dev>
 <20250528-ff9f6120de39c3e4eefc5365@orel>
 <1169138f-8445-4522-94dd-ad008524c600@linux.dev>
 <DA8KL716NTCA.2QJX4EW2OI6AL@ventanamicro.com>
 <2bac252c-883c-4f8a-9ae1-283660991520@linux.dev>
In-Reply-To: <2bac252c-883c-4f8a-9ae1-283660991520@linux.dev>

2025-05-29T11:44:38-07:00, Atish Patra <atish.patra@linux.dev>:
> On 5/29/25 3:24 AM, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>> I originally gave up on the idea, but I feel kinda bad for Drew now, so
>> trying again:
>
> I am sorry if some of my replies came across in the wrong way. That was=
=20
> never
> the intention.

I didn't mean to accuse you, my apologies.  I agree with Drew's
positions, so to expand on a question that wasn't touched in his mail:

>> Even if userspace wants SBI for the M-mode interface, security minded
> This is probably a 3rd one ? Why we want M-mode interface in the user=20
> space ?

It is about turning KVM into an ISA accelerator.

A guest thinks it is running in S/HS-mode.
The ecall instruction traps to M-mode.  RISC-V H extension doesn't
accelerate M-mode, so we have to emulate the trap in software.

The ISA doesn't say that M-mode means SBI.  We try really hard to have
SBI on all RISC-V, but I think KVM is taking it a bit too far.

We can discuss how best to describe SBI, so userspace can choose to
accelerate the M-mode in KVM, but I think that the ability to emulate
M-mode in userspace should be provided.

