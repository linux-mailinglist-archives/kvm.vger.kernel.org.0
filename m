Return-Path: <kvm+bounces-54325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C32F1B1E76A
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 13:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D74C189FEA8
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 11:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 431D02749D7;
	Fri,  8 Aug 2025 11:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OFxzTIrw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D28242D6E
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 11:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652917; cv=none; b=BUEoC+lVfELPrBHvdsXB0gZXcK6A8rfM5rFC4eFBfQ28hb42UzXIwEi17hzK2ZXOQpDIkzPDvk/shM+Zc7fO7fe+DyCUocgZbJF7irxNp6u2vHO9mI+Qy1oW2S6PDxGkqKsTXybeZC74zV5yb1FKDoAnnKdGL0c4MTqsVi6PZ5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652917; c=relaxed/simple;
	bh=CquLhGMQq6SPS9k+2Xd7aktEnvY7w48dkJqJFu3/V9s=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=RIgBVVAHIJoR/f14r4H4b9brOgxR0jZxN34y2ziEzZO6IDL5deWZa/46w0HBvT2t4eTgnuJvcYKYbhEDqPiVNqMtiCpy0QTf0g0fdTqewlox43UHmX1wrpTZ+upNOngLX0VBIz3k906XSFrhkr3bJeoeAxoStD6q4rAeOStnYak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=OFxzTIrw; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b788581079so18450f8f.0
        for <kvm@vger.kernel.org>; Fri, 08 Aug 2025 04:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1754652913; x=1755257713; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bVe0BYxb2hdDOzuqM0QPgQUk4JUNXE4YiObhQZZKcW0=;
        b=OFxzTIrw6kuYFdSWe4ft9TVNCyIxngOudEVFd/LPwFu42NeYks1vYNilZe51CeoarH
         dXGPQelNLhoXCvJc/MyX67U1uI1mXKxN2jPy/KUao64J4+uHOYtRT9N99Lm+GCwiwm+6
         kYm/i3iiPNUa4UZ/C0aCuE/R3/RuWCa5ofwpg22/JSI+RR1YANimK2dSQePGsuGtW9Tl
         n7+s83m2VVd9U1ul7z2L3DLKR6NdB4uMtfvueMwLb3cQ0yfgcX9uHjlqVyKruYxO2ShM
         x29d2scxa+2yZIKjAs2xVMVIk35H9JEvW9BaaQU9JJnIUe1MaiuB3zj/6xvNgwvCZjgT
         bneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652913; x=1755257713;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bVe0BYxb2hdDOzuqM0QPgQUk4JUNXE4YiObhQZZKcW0=;
        b=LJf1g7H9VMRzJ0kR9s6CQPyWwsrEMMyb0X4OW4RSOcDGg49U3ZUR3XqI0QeU+HfyOj
         1TpXneWKsyMZeqS58z6HvYPsyM1Dpw4GG79QNVfLlO+rBVyK+xx3ZYoooAwBevnDBcOa
         dLJCGBzO3JaPWMU7q6FHN/ZMQ8YmvotzyhicyNzGA8k0U8tzWdhsXc0fjg4T6ERtGqvc
         UMHSgMjMZE/rldRUkeKuGmhFqJcdoyrjlv6RTwBwOurJOTQm63HKsSh1ShgT+P5ubP7p
         xiTcFshnAm5AT0HM6rnMS9kW/efqnYx0ZeKiW0+9HyJ3UR+MB5x83oqEUOWcwb+75pZY
         ZCPg==
X-Forwarded-Encrypted: i=1; AJvYcCWHNgPvEm48VJ6epjuxrrgf/ZZwBcYFLJRQ15HYPT527EF5fYZBebkyc3WFxYKjBuzqNSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlEzeWlAY6yh4LYRNUf5pAIFAcp+pkeQInUwYdV5bmMOaml0dG
	SoXFlN03EsrBpmwoNd6kY1NOs1X2WGpf9Ee24CrQ2Raqy1tF/bbqyZYSkEz31GUdPL0=
X-Gm-Gg: ASbGncv8VNj03p1o6LorrED7RphHkPkxE/Jqb/1t8tWNYoVuFqHgnOaRZbV5eexu1By
	qo5zigEhNFhUP1LJbyDjKKkM3KVKNTzSqkcGHxg5itrlNzwqSKiODsMRZWK5f7OVuQpu2kwcx4H
	S9qUutMDu9njnRTnFxJdsF/l/RVwIZKcYUxQ2NQ+UDKJEVlMGWJOhxV6O2VBrkbsoIRDlSokeXj
	BjBTG24mXJ6HlCcGLBTN7ItdRFvyEkXQoI3w9GYwkaxO1vjjrwUGCRgD8k9iGDVT1vLzsLAStKk
	KHgHSd5Mxv6QANzQw0JQeKhNLsCVnnzgktYXpOIJ/2SKPdeF8ZnaeNJfd+VIc+eikxOGC9YW0Ok
	s3t31fRujkODdSYieyVdYV03yfGES
X-Google-Smtp-Source: AGHT+IFliH1IeRlmtSKl6taCyhr9lWYZytazufI3Vxt3GCyH4GgGDnZo7KA2cPTXc0F1MYhLNN1WMA==
X-Received: by 2002:a5d:5d88:0:b0:3a5:8abe:a265 with SMTP id ffacd0b85a97d-3b900b4ca0bmr1072782f8f.10.1754652912918;
        Fri, 08 Aug 2025 04:35:12 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:764c:bb32:dd82:c77])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c338c7dsm30164171f8f.0.2025.08.08.04.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:35:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 08 Aug 2025 13:35:11 +0200
Message-Id: <DBX0JNR61UNM.Z42YERAKRFR8@ventanamicro.com>
Subject: Re: [PATCH] RISC-V: KVM: Using user-mode pte within
 kvm_riscv_gstage_ioremap
Cc: <guoren@linux.alibaba.com>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: <fangyu.yu@linux.alibaba.com>, <anup@brainfault.org>,
 <atish.patra@linux.dev>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
 <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250807070729.89701-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20250807070729.89701-1-fangyu.yu@linux.alibaba.com>

2025-08-07T15:07:29+08:00, <fangyu.yu@linux.alibaba.com>:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> Currently we use kvm_riscv_gstage_ioremap to map IMSIC gpa to the spa of
                                                                    ^^^
                                                                    hpa?

> guest interrupt file within IMSIC.
>
> The PAGE_KERNEL_IO property does not include user mode settings, so when
> accessing the IMSIC address in the virtual machine,  a  guest page fault
> will occur, this is not expected.

PAGE_KERNEL_IO also set the reserved G bit, so you're fixing two issues
with a single change. :)

> According to the RISC-V Privileged Architecture Spec, for G-stage address
> translation, all memory accesses are considered to be user-level accesses
> as though executed in Umode.

What implementation are you using?  I would have assume that the
original code was tested on QEMU, so we might have a bug there.

> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> @@ -359,8 +360,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t =
gpa,
>  	end =3D (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>  	pfn =3D __phys_to_pfn(hpa);
> =20
> +	prot =3D pgprot_noncached(PAGE_WRITE);
> +
>  	for (addr =3D gpa; addr < end; addr +=3D PAGE_SIZE) {
> -		pte =3D pfn_pte(pfn, PAGE_KERNEL_IO);
> +		pte =3D pfn_pte(pfn, prot);
> +		pte =3D pte_mkdirty(pte);

Is it necessary to dirty the pte?

It was dirtied before, so it definitely doesn't hurt,

Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

Thanks.

