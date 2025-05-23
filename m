Return-Path: <kvm+bounces-47525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5901DAC1D7D
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:17:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0B033B7FEA
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 07:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400761C3BEB;
	Fri, 23 May 2025 07:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="P6SKMKi1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A010729A0
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 07:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747984659; cv=none; b=Eq0kaB7/NW1IVE5UywKEPMwGfM4VidQ44Vh5iBgzzhgOAMU0Kjz7WgFlLCIOCXG+6o05scNbZLy5vLj0Tx78D44sgEtHq3oE7/2WrUI1P1VQ007abF7N/F5mnYglU9+m3J9vinFRrcrvp2v+RclYdmzWIPqoGePhFy2glLmx99A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747984659; c=relaxed/simple;
	bh=14OpoNR5wXX/CXfjw1QWL9oJm6ZbCTjIwhXlXxgxunE=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=Td4Do+XIKT3M3mpw0QvHcNl8Fgkb2jsHcKM1pETlbbHFrPbEgYad/t2DEbCYJUiu+L5KEJIpzaNlUKBH8G+OJZIgURcF99STiQGygrykNAuD5HTA3tX0+MyxCYXCxZzm8Nik/UZKQsR9QCFS9A8vfDBvWzb/dhNmPHTow14ilbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=P6SKMKi1; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a36255d0f6so1054717f8f.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1747984656; x=1748589456; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Av0wHf24aS4juStS1TN8W3ncbclQw1XJp/gFY5E/1Cs=;
        b=P6SKMKi14rsQzaxehL087WZRxfh3a4Bp5TBCM9Xmo73gWKS1J3icVwlTaj3VgOC2Ha
         habqjD033O2/q857ROST5/DE2FvfIT0fLYujopHHEuVxyYcFc9ufUQCvimXyjo6z07pC
         8LIjkSoeG60QszKZhjRuOI/kw+KlyrrcTRd4dDXJaZ9ExjyUqrCNz723YLVNLboiU6a2
         +GF1l9bVtTnOU/n5trIsIbml239zObafvdF2cKe6WaMojN6+PodiC9+EXuuUrMMrSHdX
         YtUqj9GEnMMuHK4MOSi9PcMJebL01M6vVAWm94euDiXk/lFanJO3j9wRrN3/NuHMC27R
         BGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747984656; x=1748589456;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Av0wHf24aS4juStS1TN8W3ncbclQw1XJp/gFY5E/1Cs=;
        b=Y7heU0NFwOPOKScfbU/77rWi+ImIHkbYtnlWZ/wPKh4ncFd6rnvpflGSbkh+Iadf9B
         EjUTrf+ETjivAWcALm47h7k/rxDF8h4sc8DppPmgxMDjSc4Od5bokGGCbgN5+hXjzGuH
         2XYVK3O37pFdw6Z1r5qV3I/yuXZ1MwhM66NOkN6GMPqdUaaHema/buaYwEHLrIafrrvm
         40ddfypd+n8pwNLiekW+8P7l8Kzn+usUHo9SeMoln0Qmz/Jot2DfPwtbvbcwmIK3ifHr
         paV/l+KNXmKYnng/D2cnArOJ0tfQsNb2taPGqUBbEYnAycgjSdfgME2XfZFilqpamUSF
         xpmQ==
X-Gm-Message-State: AOJu0Yzv+B7XjlVfe/niPevLdgEMJHKTQ9CYUbfeptCkFY6hWGHk2Arz
	u7xzkiVyP8L/lGx+xN00M57p70ytnMIB50Zge39aYW+pPDRwesNrK1LK6sYCfwQGqiE=
X-Gm-Gg: ASbGncueORyElX5WejgwTuqfkCkV4uWA6b7qKGmcdDQT6njV3TOhEhRZ5eAx6z2i3NQ
	UB3zzfwkTzJJh8e/uGP/wQOW00R+JZWHJVETkMm/RlsILzDKulOErrM2yUyWwgUbiO0EppcpCpz
	p9GjZbEoQdu1rqECEnS0STIfegesJUXLKUKev8r3cAphsHP84dF6GpL38Jx2t5CxIva2Cj2dJhI
	s5DuIPqyx9s01Zj3Ifk205xsFF5ef3mIR6pFAvFPWaui/MTFwnVr0ikjwGsdVZAkxJb6PCGhkic
	AYwJLTwHNqCN1RfYhB8+oOYvdVh/xTrBjLkLXQi013u+4YwwreQ7HRbcTB0E0/HjcyaSlDSRHLF
	tIX7VuJSuiMM=
X-Google-Smtp-Source: AGHT+IHny3D/gWDxUIqfuvTT+wNP4SQN43b5D98pz4Oyz+pD+zxR9Sz3GTWyxH2BvIqBfK8zfh4AVA==
X-Received: by 2002:a05:600c:4f8e:b0:442:e608:12a6 with SMTP id 5b1f17b1804b1-44b8ab9bd9emr3386425e9.1.1747984655676;
        Fri, 23 May 2025 00:17:35 -0700 (PDT)
Received: from localhost (ip-89-103-73-235.bb.vodafone.cz. [89.103.73.235])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f73d4a3csm134133475e9.22.2025.05.23.00.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 00:17:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 May 2025 09:17:34 +0200
Message-Id: <DA3CUGMQXZNW.2BF5WWE4ANFS0@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH v3 0/2] RISC-V: KVM: VCPU reset fixes
Cc: <kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, "Anup Patel" <anup@brainfault.org>, "Atish
 Patra" <atishp@atishpatra.org>, "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Andrew Jones" <ajones@ventanamicro.com>
To: "Atish Patra" <atish.patra@linux.dev>, <kvm-riscv@lists.infradead.org>
References: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
 <1a7a81fd-cf15-4b54-a805-32d66ced4517@linux.dev>
In-Reply-To: <1a7a81fd-cf15-4b54-a805-32d66ced4517@linux.dev>

2025-05-22T14:43:40-07:00, Atish Patra <atish.patra@linux.dev>:
> On 5/15/25 7:37 AM, Radim Kr=C3=84m=C3=83=C2=A1=C3=85 wrote:
>> Hello,
>>=20
>> the design still requires a discussion.
>>=20
>> [v3 1/2] removes most of the additional changes that the KVM capability
>> was doing in v2.  [v3 2/2] is new and previews a general solution to the
>> lack of userspace control over KVM SBI.
>>=20
>
> I am still missing the motivation behind it. If the motivation is SBI=20
> HSM suspend, the PATCH2 doesn't achieve that as it forwards every call=20
> to the user space. Why do you want to control hsm start/stop from the=20
> user space ?

HSM needs fixing, because KVM doesn't know what the state after
sbi_hart_start should be.
For example, we had a discussion about scounteren and regardless of what
default we choose in KVM, the userspace might want a different value.
I don't think that HSM start/stop is a hot path, so trapping to
userspace seems better than adding more kernel code.

Forwarding all the unimplemented SBI ecalls shouldn't be a performance
issue, because S-mode software would hopefully learn after the first
error and stop trying again.

Allowing userspace to fully implement the ecall instruction one of the
motivations as well -- SBI is not a part of RISC-V ISA, so someone might
be interested in accelerating a different M-mode software with KVM.

I'll send v4 later today -- there is a missing part in [2/2], because
userspace also needs to be able to emulate the base SBI extension.

