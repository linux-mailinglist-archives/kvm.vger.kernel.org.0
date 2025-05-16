Return-Path: <kvm+bounces-46786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F88AB998F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 11:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD63717A47A
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C110F235362;
	Fri, 16 May 2025 09:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mYujRaZn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5719231842
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 09:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747389401; cv=none; b=oLH/Bksbr1Lkvt7/2idIms75Q2aCTZmXXVah8dg8D+MbqoWK1GRHh/MAkPjYRHP/VwQFlPGZGoDSHJRZuiZlhzLJ4wPyjbSf2nPYSNIJalisWWae+06rHDmB18NwZKRRRktcs9mo5ugEBWMtYnydkoqbzrxEt1h0xDZwok2w8+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747389401; c=relaxed/simple;
	bh=4X67REA9r+ghn/5V4fyB008xDYh4aHfUgGG1zyzi+Bo=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=cerJaRr0y43oBQScoSNOfpJxluf3DWcfj5/2MH1k81T8q/RyN+3Y0QvMvMVOb+DvM0cmDIn9K+tHSvn/ZxevptOpj+3UoCrHBv04diYFuAWpyhZmhB64HDbrJdZngLkxT+ypTvnom7aW7Xs/b8GXh+CX66MH+aGYAXbkJsnotsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=mYujRaZn; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-60179d8e65fso690436a12.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 02:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1747389397; x=1747994197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ti4ZqP+Hl0JDcB2DFZd59wj7uwh2SBcukM1irTJ/QT8=;
        b=mYujRaZnfFY5Ob8SR8TqUhIyw3i8/O6QwYISyT9+6QY2+EmU/Sg3Se2zy04gz+D69z
         SvFUHeNp/FPYVFFYSpjp9wptFA3SM5FoALJueDlY7vS7GvJP1mv+DRxy7ecMLPJyVjtw
         ZUGupVNzoCo1nZ6lIT3NpX6uXGR/yZRbJ3g07W4IEZDbTUuH1r77uobB00e4zWgfBDrO
         b9D4RVvVXQfLN7LkB2GCBE/HQXsGKpzHV/1R6jzNFJCNqTK5swl1sf2a0DaHCvuUpY7z
         NeKk+WD8c1hJlha+4HTc20dMNBB86S0c7/4zUK0xa3UsRw1lI26xJCqQtIjTxpJ2uxAB
         SIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747389397; x=1747994197;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ti4ZqP+Hl0JDcB2DFZd59wj7uwh2SBcukM1irTJ/QT8=;
        b=fue4o+I62llc6QY3yCtAO5acXVFq0kLU/LfvjrbiwyC0nbmStONmUbWCW7CKs+XFkr
         wuV/vPImMYOtMhiE/Tm+ptfzYLUbA7EXmNZ11lckhZ0YxVHRh1d2Dp6m60s+z1YGOqwb
         u9GGGRf/5e3UIVXcjT0C2bFSLgOPjHUKfL6OLHI9gZRC8OamG1NvrhBBjrbeEIJ1yamR
         9VOgnmDT6HI/g+f4YHR5fDdK5F/sX1uMaE8IV7SLaGkax1tAN18V0G/eARovlAd1s1qI
         TVUtV+x/faJShEn+Bt2WOBOltuZKbQRYG2bP47rlvUdEH+QnrOjjMKhiNr48Sz0Xk7E8
         B5JQ==
X-Gm-Message-State: AOJu0YzgrUWjA8H4qnu9qrN1NDCiUeR1ojjoL5TvLdTLrM2oLDurNNzU
	yxFLSCn+zd1wnfFTXZuHzSVinlfx4j0L+I9IfF3LKKSxlLudJN13JVXerFU9pUEYCx8=
X-Gm-Gg: ASbGnctwBmhJ4FpXrpZhIj1OpFvvfahd7AByjZN9JfGafBEzJfbHJYh+i92yPDvHLyr
	liMiYt7Jr6QMNxcSmNi/VztxmcVOUHhoW0GDab6hWdcPcDesZMs5s3aorKcWV0XJXeUubWfibXQ
	4SGBFpCQ4YF7gqXz8BvCvzS16I+igpUGzAbN6Qp9L/tCOz1E4J7uHeOWFq0pdAYuIEpnSnLTjEq
	1NIKHU1SHwPIGdREbHy7rpGIe8mBQf4gKla8/xHDHsm5SGQk0m9ZBh1YOfznW8JkLx9vaEonBBF
	EljGXxSRkDDt34BJbtU4zAY1qu8EdwJ7QJZI5O5AbylY1cFjaAwl1sIpd5NfJ+c1z45h
X-Google-Smtp-Source: AGHT+IFh2zAJl1Uj5Dr32GIK/RqZ9T0owi1RiR8KLA1E0llsHrNCCqszm3h/QZEbyvFvfkdXsmjKfg==
X-Received: by 2002:a17:907:9624:b0:ad2:4da6:f573 with SMTP id a640c23a62f3a-ad52d5ba810mr300923366b.41.1747389396719;
        Fri, 16 May 2025 02:56:36 -0700 (PDT)
Received: from ?IPv6:::1? ([2a00:11b1:101e:447e:2959:9e3d:ac05:c19d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d490789sm127955866b.130.2025.05.16.02.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 02:56:36 -0700 (PDT)
Date: Fri, 16 May 2025 11:56:31 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
CC: kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] RISC-V: KVM: Remove scounteren initialization
In-Reply-To: <20250515-fix_scounteren_vs-v3-1-729dc088943e@rivosinc.com>
References: <20250515-fix_scounteren_vs-v3-1-729dc088943e@rivosinc.com>
Message-ID: <C74B29B0-FB1F-4E67-AFDF-FAD7C86FB329@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On May 16, 2025 1:11:18 AM GMT+02:00, Atish Patra <atishp@rivosinc=2Ecom> w=
rote:
>Scounteren CSR controls the direct access the hpmcounters and cycle/
>instret/time from the userspace=2E It's the supervisor's responsibility
>to set it up correctly for it's user space=2E They hypervisor doesn't
>need to decide the policy on behalf of the supervisor=2E
>
>Signed-off-by: Atish Patra <atishp@rivosinc=2Ecom>
>---
>Changes in v3:
>- Removed the redundant declaration=20
>- Link to v2: https://lore=2Ekernel=2Eorg/r/20250515-fix_scounteren_vs-v2=
-1-1fd8dc0693e8@rivosinc=2Ecom
>
>Changes in v2:
>- Remove the scounteren initialization instead of just setting the TM bit=
=2E=20
>- Link to v1: https://lore=2Ekernel=2Eorg/r/20250513-fix_scounteren_vs-v1=
-1-c1f52af93c79@rivosinc=2Ecom
>---
> arch/riscv/kvm/vcpu=2Ec | 4 ----
> 1 file changed, 4 deletions(-)
>
>diff --git a/arch/riscv/kvm/vcpu=2Ec b/arch/riscv/kvm/vcpu=2Ec
>index 60d684c76c58=2E=2E9bfaae9a11ea 100644
>--- a/arch/riscv/kvm/vcpu=2Ec
>+++ b/arch/riscv/kvm/vcpu=2Ec
>@@ -111,7 +111,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> {
> 	int rc;
> 	struct kvm_cpu_context *cntx;
>-	struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch=2Eguest_reset_csr;
>=20
> 	spin_lock_init(&vcpu->arch=2Emp_state_lock);
>=20
>@@ -146,9 +145,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> 	if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
> 		return -ENOMEM;
>=20
>-	/* By default, make CY, TM, and IR counters accessible in VU mode */
>-	reset_csr->scounteren =3D 0x7;
>-
> 	/* Setup VCPU timer */
> 	kvm_riscv_vcpu_timer_init(vcpu);
>=20
>
>---
>base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
>change-id: 20250513-fix_scounteren_vs-fdd86255c7b7
>--
>Regards,
>Atish patra
>
>

Signed-off-by: Andrew Jones <ajones@ventanamicro=2Ecom>

