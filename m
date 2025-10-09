Return-Path: <kvm+bounces-59686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC638BC78D6
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 08:32:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D07241899374
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 06:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAA429B204;
	Thu,  9 Oct 2025 06:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="fDh31YBh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60792B9B9
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 06:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759991513; cv=none; b=MHaHKet2wlenL4UUxlZ5c/u7RJy21sYRgNZ6lt1re/1liXkPpgCaShmrRXp+ystSy7vSaTocY3+X4cOoU3+5c43zTu+Pp31YvEOITcfdLGidesZQY1JIdGuwOtjXeLFroD8bOWOlkt6RQhVvtnvgHBv6dTOrj43mIOEjFTwYlHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759991513; c=relaxed/simple;
	bh=YWnhHQcSyGlFWhF9IR/pq1cQnmO90pMmUASkR0pB2Sg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=dgVUMjtQJ6ZDJG49fEwBHbE31dykkAOBQdXkdaTGoUfGhl9PjgYWE4ZEMQpAnwySNxhRnslUcNVCGNN1ZaatKG/UgDtxVjOhTRHwollTmxfS91QXxFYw2iYyThc7Lbh5RjS1aJ60V4QGW+USpO/FlHeR08284APcr2zIpqERvm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=fDh31YBh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e2cfbf764so769135e9.1
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 23:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1759991503; x=1760596303; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZphDIVd5tmeP6KAhy58kJYA1PrGr3bDOHMWlYgqBwIY=;
        b=fDh31YBh0j84ookgphRxISNEP0JZRmdqjNrT6DMwcDfLhSBv7jVRoRQi1A743a3DEW
         G7Ll0wq1lAsNxD1maeeg071KVHL64a9iLRo3TEP+x/Ush4P/G1b8MxY9ReiTg7Bgbssh
         S4g0ReyA6aOU36IlFLsbkYbR8itGsw/FEx/yX0++3B0gq6fsPW7vexYlFvBKVPC41Bsr
         QSxrK+mkqVFnGWQQW2DOS1MHSPuyLPpLWcLc/ATeftSUAtb+cKK8pQwYSZAP+hs8Cc/S
         F/Un7LMPtOuH/LzqEzaK7wYLhwBZ7r1LL0djihd8HCY7RQR/a8DeapiDJmvO73cWA3dZ
         YLUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759991503; x=1760596303;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZphDIVd5tmeP6KAhy58kJYA1PrGr3bDOHMWlYgqBwIY=;
        b=tKdkRIjAthwWh19k4M1K7kX99nJi8/3gdWm75g/oVl0tMEHeeYPm4vndqnbMyMl5gr
         cRdDG/pVg2vaeVXbCHPl03VQ3C6ivIBaBKli2F3i+LQUr4IkRVKEDb4WY7Snq6QKxWbe
         1uG0DcxAPzrd+Tr4aJnCt7gkOI3lFQpvPYnxQkWRvkPx52r1Gzl7j7XXOHcWxt049Ysj
         wGYjHrcINMzkj92gAVDkFU1/wOhGf+r50XQ9eHWJm7Igxo210OFgE2h2vbQkdpZy9c3p
         kV7fa0hnNtUcIiLq5tGJWuBwy3qdP2gAEMMai1sWKY+rdWnn87Dv8IjwjZh3TknraRCl
         uztg==
X-Forwarded-Encrypted: i=1; AJvYcCVtLibreaDcvgYiC4gg1jcu3fFxYt5wIiZ3Le75zGMf4ZzM/d3R45qTTamkU9KIixz1zMw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3pZ54Vj+oudAxBlFKK1HSQhq+J5wWHhH2B8Yv0ilGsyN/RUXQ
	GwcWlbf3FgYpd4vmLhDmrF9zj0vVGxz78maBt8oiktwuJp/COwXnP6/WLPKD/a790DU=
X-Gm-Gg: ASbGncu/oDfqCyoZoqUvIAhLFwwfxQLhFrOKdC9j92s1mOTV/GDlTTrOOPGOlzLsIpz
	iZre+Cpwyg8F+ldgG8wpUbURjOtOgY5muuW0kKFmkGKeUz2lh8d7jIxp3uUPwR41yb1Zagi/BZS
	Id8keUnpbr/DZCbOfNu6YAE+ot3OUUfIxoegwEJVMFampLyzOewJqP2URsikMU6scsNHcW/88Hy
	F28m4YOH8Qqk0zJsjt6hvInyFBwJv3GEw5LytIYEI3FjAeQJwEqHA/n4Np/kFvkHu4I8eJDa1Rl
	1JvtdcSFMWq2omnmsdqT74XCC/GYYCm62tffP/Btv/IDTW3dT6AnyAElIxhX+6TNZdRwR654asR
	mJpYvDquwf8aggfffslx3kbmGnwB29n8dTFnUdJ84JAioT/IWKze3qg7ceJI=
X-Google-Smtp-Source: AGHT+IEIf07lX5X1t9lPoRt1uKJDa5WT2TozooFfyQvTgQYIm3IKeoNZOzn9APYtFiu6W4PehuHHyQ==
X-Received: by 2002:a05:600c:548b:b0:46e:3d3d:ea92 with SMTP id 5b1f17b1804b1-46fa9b06cabmr25204355e9.5.1759991502804;
        Wed, 08 Oct 2025 23:31:42 -0700 (PDT)
Received: from localhost ([193.86.240.59])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4255d8abf38sm32664903f8f.20.2025.10.08.23.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 23:31:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 09 Oct 2025 08:31:41 +0200
Message-Id: <DDDKX1VNCCVS.2KVYNU4WBEOVI@ventanamicro.com>
Subject: Re: [PATCH] RISC-V: KVM: flush VS-stage TLB after VCPU migration to
 prevent stale entries
Cc: <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
 <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
 <liujingqi@lanxincomputing.com>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <tim609@andestech.com>, "Hui Min Mina Chou"
 <minachou@andestech.com>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: "Ben Zong-You Xie" <ben717@andestech.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20251002033402.610651-1-ben717@andestech.com>
In-Reply-To: <20251002033402.610651-1-ben717@andestech.com>

2025-10-02T11:34:02+08:00, Ben Zong-You Xie <ben717@andestech.com>:
> From: Hui Min Mina Chou <minachou@andestech.com>
>
> If multiple VCPUs of the same Guest/VM run on the same Host CPU,
> hfence.vvma only flushes that Host CPU=E2=80=99s VS-stage TLB. Other Host=
 CPUs
> may retain stale VS-stage entries. When a VCPU later migrates to a
> different Host CPU, it can hit these stale GVA to GPA mappings, causing
> unexpected faults in the Guest.

The issue can also be hit with a single VCPU migrated over two harts:

  1) [hart A] accessing X as Y, caching X->Y in first stage TLB
  2) [hart B] remapping X to Z, sfence.vma
  3) [hart A] accessing X as Y, instead of correct Z

Migration from 2 to 1 does hfence.gvma, but that doesn't flush first
stage TLB, so the translation produces an error due to stale entries.

What RISC-V implementation are you using?  (And does the implementation
have the same memory access performance in V=3D0 and V=3D1 modes, even
though the latter has two levels of TLBs?)

> To fix this, kvm_riscv_gstage_vmid_sanitize() is extended to flush both
> G-stage and VS-stage TLBs whenever a VCPU migrates to a different Host CP=
U.
> This ensures that no stale VS-stage mappings remain after VCPU migration.
>
> Fixes: b79bf2025dbc ("RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sa=
nitize()")

b79bf2025dbc does not change behavior.
The bug must have been introduced earlier.

> Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
> Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
> ---
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> @@ -146,4 +146,10 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu =
*vcpu)

The function is now doing more that sanitizing gstage.
Maybe we can again call it kvm_riscv_local_tlb_sanitize()?

> =20
>  	vmid =3D READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>  	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> +
> +	/*
> +	 * Flush VS-stage TLBs entry after VCPU migration to avoid using
> +	 * stale entries.
> +	 */
> +	kvm_riscv_local_hfence_vvma_all(vmid);
>  }

I had some nits, but the approach is sound,

Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

Thanks.

---
There is a room for a RISC-V extension that tells whether the two TLB
flushes are needed, or hfence.gvma is enough. :)

