Return-Path: <kvm+bounces-44319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 335FDA9C9CD
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 15:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45B521C0037F
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 13:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1437253348;
	Fri, 25 Apr 2025 13:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VBh7Zsan"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E37824BCEA
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 13:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745586326; cv=none; b=MRErazds5rIM7k4/zz71rUwwtXE0pAjeiTT/1XT+yRuW3OuCAqojqAOKFpr7fIycjW7+HJfqUEwRjMicVgtE7JRWUpfh+rAZ9ojRCxHdWyp1MrlmY4qSvxKOVYVnHm83xXJ8OVrRglxXpqijLAq5JeGgu2YhePvEdZmy7ZJ0KEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745586326; c=relaxed/simple;
	bh=sDGtqm1V//9UtS2zFSvlXkA7AXbkU/KZKXPn8F5C724=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIRIvp9MSj82kS7sQgqiBuOB/hkP+8Yhswzca08+W5S2d5UO91vzTYywHO3RnlRwz4xZDhcCCVuj73wKWph0Bt+FzRXdr5ug8AjXHQktmU7f9qL27wFiu5IsuGq2Mj2lRNaHS/iqL93X0+vMaG/4z1UwvxgJF9cOeZxmZT5IaQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=VBh7Zsan; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4394a823036so20733585e9.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 06:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745586323; x=1746191123; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mI4EMCjudvPEsRjkDPJuXzQzHFYKmrud5DGT+FL6aYw=;
        b=VBh7ZsanftC8Wk6x2g7MYzJf9uWLNm1/ukm+IVE06Nzh72R1bgRo7JotbgtROnhpJg
         JBsL9/QoAbzeOucCM+beFkCq0scStKjZnK2UuXyFa1tH0SFfV0NocXqIul188wyulDCL
         w5be+PceYbONFWZBRaIKHVnA/bA2USyG+9/z9+I5/CK8eyTWtCsgTT+DVIrz6ywS5ve9
         x+kQkdMF4r5Gy0b3bpAwUziOZvmbebfSd/WalfjkqiUohcLvyr1NlrpJKjEpdzspDzel
         a1xsWNWLnG83q4wWUeCnmYnCLemf538hu2bnJXX+uMZ9tZPJ4Rym18TRGVIbqLFy0s8V
         CXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745586323; x=1746191123;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mI4EMCjudvPEsRjkDPJuXzQzHFYKmrud5DGT+FL6aYw=;
        b=OW2FtTeFBvSlvwTlObtrQwy0Yklnuw5ovebvRQpyDSTyGHT1YEdr9l2c39i75JyL0t
         7T8EfYvC2yDiTgta7UsA/nKViIrWl3hv8kHnusVumPWOIBBvHT91gaBwfuzdwRiyRUfU
         6JZeGum0+XRclXyz7BmiAl8fB9yqAqfBKwFUWrgSGpOnPgYdufSy7r2x+luuEskmcdnH
         1av5WX/WUC8IpEnlNR9705fKek2i29NvenSmR6J8PLlhe5s5EBmZ4Bh2GEXk8EZIdYi1
         N/zH/eP8VNyJv8lX5oOQoIvnINIkbGvmgYQw42d34s2oG1sYZdZBg58PUvOEW+/mIz6E
         mtPw==
X-Forwarded-Encrypted: i=1; AJvYcCXXEKlu/EUoFOtDBkj6PAuds8Wz7dZ18A37rtKMwWbVrjE07CseiI9dFKG/jK/2IAx7dgA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG3aos/1ybGryywyGIbMXZIvwhKA5EZ7MSD32xqRS6awVu8gTt
	WtFCJI9JM/X4+DdFkDd25Kz44nCiJwFUqbcd9sxRProTebQX2UiEsOi2PN7TYeY=
X-Gm-Gg: ASbGncs9/wvPj/UapE4jpGfo0UEPLrttZ40HrvK1PIRRt9dZiO+VcyWs1/xcqzC1YX7
	jDEALQplUlB8OFm7aCZu/zcUnB4kgZ/P9Ifhkx8teldejNMcM5NjzukTNpFadKQI02qksmeSRgP
	Sh/jk3VqzPCN9DlEpJ2uPDin2dDRyVNPm6xqT+Dx/rQ/1VX12GRdIhflu4G+WPO4FxPdMtCgx2v
	Uz5Qk2Q53AFKR5y7VJ8yee2H6pqdGN+dmcPjHvjrknX8X6Us0lMTxEYVyddtVi6aN3e1QyaXBqk
	U8+3CW5Mc2S4Mugp6TsgSyJRjdd8
X-Google-Smtp-Source: AGHT+IHHErR6NhpMN/Sy9UBcv9Lon9rgyckgM6zPHQxQJs/5oK9vVCdwR1q/Yg1TRreW6QGAYcjYIQ==
X-Received: by 2002:a05:600c:a06:b0:43c:eec7:eab7 with SMTP id 5b1f17b1804b1-440a65d8e66mr16975955e9.11.1745586323513;
        Fri, 25 Apr 2025 06:05:23 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2dfc2fsm55718985e9.33.2025.04.25.06.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:05:23 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:05:22 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Mayuresh Chitale <mchitale@ventanamicro.com>
Subject: Re: [PATCH 3/5] KVM: RISC-V: remove unnecessary SBI reset state
Message-ID: <20250425-adf6ca95915c46a5403fb742@orel>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-6-rkrcmar@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250403112522.1566629-6-rkrcmar@ventanamicro.com>

On Thu, Apr 03, 2025 at 01:25:22PM +0200, Radim Krčmář wrote:
> The SBI reset state has only two variables -- pc and a1.
> The rest is known, so keep only the necessary information.
> 
> The reset structures make sense if we want userspace to control the
> reset state (which we do), but I'd still remove them now and reintroduce
> with the userspace interface later -- we could probably have just a
> single reset state per VM, instead of a reset state for each VCPU.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h  |  3 --
>  arch/riscv/include/asm/kvm_host.h | 12 ++++---
>  arch/riscv/kvm/aia_device.c       |  4 +--
>  arch/riscv/kvm/vcpu.c             | 58 +++++++++++++++++--------------
>  arch/riscv/kvm/vcpu_sbi.c         |  9 +++--
>  5 files changed, 44 insertions(+), 42 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

