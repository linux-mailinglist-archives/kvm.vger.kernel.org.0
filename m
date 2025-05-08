Return-Path: <kvm+bounces-45856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 456F6AAFB5A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A120517C61E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6EC22A7FD;
	Thu,  8 May 2025 13:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Loz0hoos"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB5B4B1E6D
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711072; cv=none; b=L4qK7f29Ivv9ROso+x4a6sIyveWyFi2OnDEhpIsDWIdST1dP2P/xeM5IDCntS45EikK02MeBTqLbEtmGC1YRuPBVcmDUWt0W/pW/g7SwbbwYuK9sabWhLadiDai9eTnP15p+KGfif7sQvrfUVQOO8nH2sptoq5HYGIq6R+1fuPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711072; c=relaxed/simple;
	bh=PTIxFNCKUc6RCmBCpLXRdipjalC9UH6iNZPNrIkp7Uw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=mFtdDeNS35/5IUSg3PBUBoTq3RNT7ic3wrR4OmPhQHdia+fsdhOOYX5Pu7lmoudvyyOf9PhlfXhOZ8vMvTBZIXk9G7xfhtelSUY/AcywHhxopATKF963W3qNVVu1DZQ8oxSphdgU0cAOVxdehtuNuEiR0iBPep465YEvEQaXGGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Loz0hoos; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cee550af2so420655e9.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746711068; x=1747315868; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6S+40JPuRC3gzWdqTu3aQzXeyhaHlO7szVi8IcUpV9U=;
        b=Loz0hoosxbjIh9XfGXwj59Q6xVNvJ/uHTMgTfSbilrV3FYkFJ3NjL9koJmZF5Hkq3f
         w4XHy2UStdeBxIyVCH/ZfMSrGNPAiKhzdVPvRN52nhimI476gay5+HzmwznQv4pkPmL6
         0R7C36boN5Z7+1xrwhf7+aIlcw8afzHWALVxbHpXMfqatfwsMYzVZB2/4reriCFC4G1r
         Lu2FuuBSnxSGvDxSKUepZLTa4t6OEix7lVaNaYt5Ngl9/LdpDy0Lj966YOoowqDJbkIx
         gwT39FjStKIuiY9RYZLOXzSMRatTWqlCrMZxJkFohyx2AEkawAVA9JvC7WZ2cWwjn8qi
         wFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711068; x=1747315868;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6S+40JPuRC3gzWdqTu3aQzXeyhaHlO7szVi8IcUpV9U=;
        b=wZWHz9tHiwshqOt5ufOliptBNiTePRxc+Lrl1lSKNDcC/ERjYKFSbYg2yCx9nGrmmG
         FTFol9CsBc/aqpzlTeH76xxGjUb2Yxah6zrqfEtutEHQ5wyB8/Dr/HVffIfZdG7cu2NR
         nQvrpvOXkGqhnSrbaEzuXkCLUWxmTSllBfUcRm2nn9SD8WaJ1vdER4EfV2q8eLvYH00J
         ZtgNJEOywvz+rrkgzfSuPDIcQhrl29o3yEW++7Uk3LXKf8kn6VkK5qQGtSYkY+0dXtdh
         Co0Oda5MDNe//eKdwzWwAjPf462nnU6HsGRuwMTlgBtkA81pgyqYiVTyB4JHWc549Ko7
         Rj4w==
X-Gm-Message-State: AOJu0Yx/0btO9QOlnrf/orhYhvbrFEx58PA8v0z7kecHRa9RNTlMZ8hG
	8LYPtqrpvUK8+AiKAUfBKcmavcd5UBsXscjYKQriNWYuCTv7lmRl3J/tkYxJ8hU=
X-Gm-Gg: ASbGncsUgLG5LOL27vhs1/kyN8YmR4LElXfavG+y8yb7pDcqI4YEIFqvZC0sG39Uom+
	f3Zeg621EDIZXxPJDlUx6DAccteAOtgiuu9PBahjsaOPNGwl9BOLPmgpDoX1+UcJKkd0CSp5nMA
	l2CUar686jvw/Jzal5+X2u72lIocuYifNr3UhZ9uc0VITHSm6W6mS84sNMYMXBEcSCrBsZ0xOJF
	GUnLk7563EYKT3FQdj2ndH8maxrDBwDlH1JubUtBXdaryUlNbJOZJHhRiyIOjgjXFSf6S2MmGhK
	kPfcRhZ72AL2ci+iOgfun/pS773buxGQ/K6oUmKw9IwjmiBd
X-Google-Smtp-Source: AGHT+IGijAnvSUvNKAgb7ZNKd5QJJ9UF+zXOT/jF3FQWpi7RwPSldc9C2Ir4SMyQ4xieyEHWiNZ1qw==
X-Received: by 2002:a05:600c:1d8c:b0:43b:c825:6cde with SMTP id 5b1f17b1804b1-441d44c4749mr23230845e9.3.1746711068529;
        Thu, 08 May 2025 06:31:08 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:a451:a252:64ea:9a0e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd32f238sm37108665e9.11.2025.05.08.06.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 06:31:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 08 May 2025 15:31:07 +0200
Message-Id: <D9QTEAUN0RNE.11G3ZW4IBGL5M@ventanamicro.com>
Subject: Re: [PATCH 1/5] RISC-V: KVM: Lazy enable hstateen IMSIC & ISEL bit
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: "Atish Patra" <atishp@rivosinc.com>, "Anup Patel" <anup@brainfault.org>,
 "Atish Patra" <atishp@atishpatra.org>, "Paul Walmsley"
 <paul.walmsley@sifive.com>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Alexandre Ghiti" <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com> <20250505-kvm_lazy_enable_stateen-v1-1-3bfc4008373c@rivosinc.com>
In-Reply-To: <20250505-kvm_lazy_enable_stateen-v1-1-3bfc4008373c@rivosinc.com>

2025-05-05T14:39:26-07:00, Atish Patra <atishp@rivosinc.com>:
> Currently, we enable the smstateen bit at vcpu configure time by
> only checking the presence of required ISA extensions.
>
> These bits are not required to be enabled if the guest never uses
> the corresponding architectural state. Enable the smstaeen bits
> at runtime lazily upon first access.

What is the advantage of enabling them lazily?

To make the trap useful, we would have to lazily perform initialization
of the AIA.  I think it would require notable changes to AIA, though...

Thanks.

