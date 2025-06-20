Return-Path: <kvm+bounces-50063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A50AE1A73
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 14:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A67EF1BC801E
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 12:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3997828AAFC;
	Fri, 20 Jun 2025 12:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="AFP35sF1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6CD27FD56
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 12:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421074; cv=none; b=EkRsXzACUmEAIMc3/I2+iQvmYkaocLgrVRyrIbvyvnGDWY5T+b6u8kSgCWWYgL1sAmjgNHzXxwCRvf0iKr6twAC5G6W7PN6SYJLb5/FCoFjxsFmQPY8zZ7fnoQ5pJnocl/DGoA+fxwJHn9TUPyZE9V5AZgoebxYlbYEId+r3kok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421074; c=relaxed/simple;
	bh=D4CLahTcm02K4MIrgNUooEK1xt6s6SBPZH2zMP2SJFU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Fn238s38TivKED8Zp/MC9PRV2NsJKnOYVH0hwvaX3OSvDX5snqScqMS9Al5anxOoKYq34TV+iOlqQ5u0hl5joq5/fSDIEz/IPjZt5AaKv61/prROSdyx3W/xDrPIuXqSUboUWO3kBpipYtPw8PICjnxBWB2eniDpG0Rv3NEN3T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=AFP35sF1; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a4eb4dfd8eso262404f8f.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 05:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750421071; x=1751025871; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XeTD7cN51Pn2KJSTE1mvF0ehQNPT1Jdjz2pWXS0RPo=;
        b=AFP35sF1RK2x7kFTHo1q0Dvw4GvfVfyJkbsHwj5mndAJMshYV0g5q4C6m0sbQtvgI5
         OToN8Vubm/Tqa2+USeVj39CC+ECIclY6y+oagdLGt3b1JM7GJ8cpUW1NcXFYADCrYKfU
         2Rg+I5nOgEg4JYtqWg6vJaPX/WJKTXkt+bQMvUukceYEmcPChnisO9uC8d9Nuv8UAP0c
         TAOUNitHYNRXCZQ2bbMWkTwINNlXJyySCeBDo2mI4yspsivg9Gv3QAaO0SwBjPigrLvE
         jYRbJemVu4zJDGxxq/hUpeCFswp68EoZzOV9kyOoTdGlc7mrMqKVfKkmTeoGklN2WeVm
         bNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750421071; x=1751025871;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+XeTD7cN51Pn2KJSTE1mvF0ehQNPT1Jdjz2pWXS0RPo=;
        b=Pm799aGZqqpiYIBVigLsu59/sZFKotV/mqnKH2pF9GnmLVbv7mPF15Ateq506XyO55
         j8xUy2FbACLlUG8POQGnDt+QWz9NzG7Rz1oFZlPWToVHrn2v9plcVTk6T3KFDsB3dYj5
         vtT/KJ1z97Sn3GGX0YGgUH/DuOzDgsAGbyLknjRH/cPnq1shOc5IRyhFpkM0mNTGMg7x
         0SATxBbco+g3PhLp8zPgVSfx30GDPem9hQrv+zZlFGwIJO1jFgWJHc7WueWNBig5Cvg/
         N9lbXZ7EgW5Lx4V0DPULzA1fSuenePnGlCdGlf2x7QumGNwzXBP4VK/I1+09KitBfrcy
         bTKw==
X-Gm-Message-State: AOJu0Yy+6C3OVHcxUQ6/Z+3n39j2Mi1VtRjlcE93EGmRq/uq++A2waSO
	FLdWw/CTR5+q7k+9ZlqDV7yFi8K+BhkH1pxhQCpDp3/5ahKwLhS7Y0q54Zk5PNOhIV4=
X-Gm-Gg: ASbGncv/xIa0qmcQMNREJ+N5neiih3wYUcvjmS+SByddUIcAZXBgMLYL2VNn69tc1BL
	+NKyGjD9qFH20GtB+ReDNIf1N2rs8TnUW8evhf+bIn2AIOqpEttx8hlDU/YWjMh9q4IvLk0x/rq
	Jw+ktHMeU4DfTCsjgGE/y7s6rnDYHE1t8OKd8ZFB+fUrY6tUAk5JQgFrqmomROyNKpAzSjKxtUw
	Vy0KQ8bt9dUaCitpXflhM62gxrrOzjJ4Q+mNuzfZuQtd4SN0KNVTQ9z7xYwjXrSVVmzgwHOp3UR
	q5NJ76bWuL74/Db1RVvpprjKMxkebNfcShoe9u2jKKqxm+Pid6cnKoqpv1X1RLLdatdN
X-Google-Smtp-Source: AGHT+IE5Nwx55CYVDH94kaBUPm5U9VYUEHy18TPg0VqIF2/T7Ln2PcZvxS2VOj8pKTt4zB2/NGi+iQ==
X-Received: by 2002:a05:600c:c087:b0:441:c1ae:3340 with SMTP id 5b1f17b1804b1-453657bf6camr6628245e9.1.1750421069056;
        Fri, 20 Jun 2025 05:04:29 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:81c5:fb37:d08e:99a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535ead2a5fsm57299655e9.34.2025.06.20.05.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 05:04:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Jun 2025 14:04:28 +0200
Message-Id: <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com>
Subject: Re: [PATCH] RISC-V: KVM: Delegate illegal instruction fault
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: "Xu Lu" <luxu.kernel@bytedance.com>, <anup@brainfault.org>,
 <atish.patra@linux.dev>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
 <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250620091720.85633-1-luxu.kernel@bytedance.com>
In-Reply-To: <20250620091720.85633-1-luxu.kernel@bytedance.com>

2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> Delegate illegal instruction fault to VS mode in default to avoid such
> exceptions being trapped to HS and redirected back to VS.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> ---
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> @@ -48,6 +48,7 @@
> +					 BIT(EXC_INST_ILLEGAL)    | \

You should also remove the dead code in kvm_riscv_vcpu_exit.

And why not delegate the others as well?
(EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
 EXC_STORE_ACCESS, and EXC_INST_ACCESS.)

Thanks.

