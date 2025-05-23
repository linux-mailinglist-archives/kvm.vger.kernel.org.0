Return-Path: <kvm+bounces-47587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C30AC2376
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 15:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D9FA4E6D79
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E12B014A09C;
	Fri, 23 May 2025 13:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="fV7qpTZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B26433A8
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 13:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748005689; cv=none; b=ZZfAAjK7xWnXqB54X7GH+OmulOZhDpJyFke9F+ukvIxImZahEQkn949rSdEJPT7CGDiqbpqzZJGVOaysuMnnzWCozG5ZhmwyXYGHD5IQpi9S5botw+sLSPZUPvxU/i37Qh4Vfnw2ES1z9/XqU1ucNb5DXPN/bqRK0Kx7s/aFnBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748005689; c=relaxed/simple;
	bh=KARpSC0ktVs2EmfgMj89WaDgPQ701M83Nyx3KMNRgAE=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=SyqdTUlLMTMTI/kIiy9SneCp5OQOlDbgJcG80hnLZpP6czF+M+zyFhMyhg6O38wARWrchw6uQDw1IgWQrKHbLXHhO57Jo0ljLtvWcZWZVWgh+4OZgR4upaYcufc/mtyiSJLd06YK97pFHfFovKPbLOQP1YkxqFh4Qrdi8lgIQWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=fV7qpTZ4; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a374754e03so427010f8f.1
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 06:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748005686; x=1748610486; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KARpSC0ktVs2EmfgMj89WaDgPQ701M83Nyx3KMNRgAE=;
        b=fV7qpTZ4UxFQBj3YWufiN5mpRDqPv8PzhvMY8SEiki4+pSAX7jbxwvH6LWJWPSs7LX
         Gaz+uf5qdoGROv8NPDwWKWdSaBH/I8TWkaHOypbz9NmgcfgEELldZB++EuNIyvbk71cA
         MmD2ekJ9fbRh1hUeO8WwDjBffvAbMKnUELxI/SwAzq8f/oXwJvKlIbfwwFj2iuoP+XrN
         GV3ecTdwt544Idb9InFWGlQAbaQRd30nPZTraSu614qdVsY/YWSwvwE6t6R1wpq89QSo
         ZqmwW55d3jfk2J8x6K9Z9WJh96bnDNsa9xTuHDcd1Rv2C0srQZxmnRbUi6FDVhEGWVfW
         nwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748005686; x=1748610486;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KARpSC0ktVs2EmfgMj89WaDgPQ701M83Nyx3KMNRgAE=;
        b=UEtWQPPe9RsihjX5h2E73ov6JZoJB3kroTYL+KCZLO0SevF+1GO3vs+g7CG7yNDr4f
         XUJNwi15Zf0/HswHJ/6AbaCyyThumhnQYSyCZT8ttImaXM6LZsIUtcY3EAi16CcVZa8G
         Rc9raLO5I0hc94kE/o6toUzQPnQ45878igHYx3ThfgT+/RtxmGwf44Xss+AGdT+Hmu1j
         f5HGFicZrrIGyPT/KK5Wa+FOtZlxkvNDrLPzENPN6OZjoDupOC5axA6tj+0RmxNJnV0S
         kgtIUJYgv5DSW9Mdal68yMqeGR0TyFYv/8rQkemMBPfNf0WVKgy+TLCc3k4g5k6X3C4K
         urwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoZeZl4gAXWJaJsKZGsG7OA3i2NJ2NOL1W33PCJYN8dDaTp8Pt1qvxxUBC0C8bcxqTgrk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIHlJvUWctmdM017IRiCj3dQzNpwSzwobMHMNB0FV2WND07cXM
	nYnQQByrop5wndYO9q+DshqlZH2DKfcQ6IqNopvRyp2mC2+F78SzkDtS84Le2S39wzk=
X-Gm-Gg: ASbGncsLgiyWRA/o1/a03jYdyvRjkbGSljDKV5HBKoasj3bMwwj6ucWa8ZBF6a/+x/a
	bgS/plihR8q2grRzdaiNeo7KyFe5qSe5XIbVLjvQAtTlNibuVr/J3wNq2SNslwKhzpl6mY5Pnmn
	iEFwkgqaHP6IVw2nls1BEgG0AK63cGdveilUEqi2ZFP/yebwUMrwrGvlfBVow8KKtxyqchl5CQz
	XYsnYzm7B5q+9aEW1N6vOXBKuOqKbjWITn2+FPKA7XU3rs0GrsOcUHPQZo1ftXxam2qrU1irlx1
	OA8+De1QnvnXbmfZxlaf157Hxmgc+HMHks0PBb+5djGnWOXGTTXb0q1PgyqoxSLVAb2+tQ==
X-Google-Smtp-Source: AGHT+IEQlpZ+MHYlhIdSbIKkOQ9vfMtZ42DEnpA7EqlzBwx2H4tZNz3AtELJClLMWV4vaH5ju8V/Tg==
X-Received: by 2002:a05:6000:184d:b0:39f:728:4324 with SMTP id ffacd0b85a97d-3a4c2d327a9mr972266f8f.9.1748005685763;
        Fri, 23 May 2025 06:08:05 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:be84:d9ad:e5e6:f60b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca8874bsm26894531f8f.67.2025.05.23.06.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 06:08:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 May 2025 15:08:04 +0200
Message-Id: <DA3KATTIZQ99.2M1SWQ64M9WX8@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH v8 14/14] RISC-V: KVM: add support for
 SBI_FWFT_MISALIGNED_DELEG
Cc: "Samuel Holland" <samuel.holland@sifive.com>, "Andrew Jones"
 <ajones@ventanamicro.com>, "Deepak Gupta" <debug@rivosinc.com>, "Charlie
 Jenkins" <charlie@rivosinc.com>, "Atish Patra" <atishp@rivosinc.com>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@rivosinc.com>, "Paul
 Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Anup Patel" <anup@brainfault.org>, "Atish Patra"
 <atishp@atishpatra.org>, "Shuah Khan" <shuah@kernel.org>, "Jonathan Corbet"
 <corbet@lwn.net>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-kselftest@vger.kernel.org>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
 <20250523101932.1594077-15-cleger@rivosinc.com>
In-Reply-To: <20250523101932.1594077-15-cleger@rivosinc.com>

2025-05-23T12:19:31+02:00, Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>:
> SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
> misaligned load/store exceptions. Save and restore it during CPU
> load/put.

How do you plan to access the value of hedeleg & MIS_DELEG from
userspace?

(I think that modeling medeleg in ONE_REG is a clean solution.)

Thanks.

