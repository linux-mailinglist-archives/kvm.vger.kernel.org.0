Return-Path: <kvm+bounces-40930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EBF9A5F56E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 14:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F64B4203E2
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 13:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F15267B0A;
	Thu, 13 Mar 2025 13:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="J1Lgso/9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30332673A1
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 13:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741871176; cv=none; b=RiC+0Xgjw7L6+UezhASgItJrmX/fLL8nHXx9kyWHzXpAAG3KWYEkF0gwmhHVIQUDfG0hBNnZ3UXX6/+g0ItLE2Jw2ddihkywYNN9ert0ovT3n77gbi8UQcrwXfSBWSk5JKj4srZuu/bL7o78oXvIHaOmJg6tNoEq5rH08cNF3tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741871176; c=relaxed/simple;
	bh=fIDudF5HjifkvRrbLC104K9OM6Yle4HKyCDfYCYSVCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KYvpIu9eSyps+kjVlnsID6wnx18Kq4giOqRE9TPhbMjs4LdMt84YYw5olC5zLINN4D3AqCbpeWUI+eVxGeOWlJR3mER5cB95GiHKBFaGWSko9aNRNjd/Jxsk6U+45IEkGO+LhDCn5a0BITnNRI/1txc9xFuIbpKK0DnMxfmF8Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=J1Lgso/9; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4393dc02b78so5614735e9.3
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 06:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741871171; x=1742475971; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JykEzm+QtlDREfjY9aCf97M8p4eU9HkNtWKu9+Cs/cE=;
        b=J1Lgso/9SeTyTtYo1LBuVXTKidpIUIN8k2LJVz4dd7kNqEKHmLkuEsjRQodm/b04MT
         k0fy78APUjZiKJAjryvIRG5T7JrdIsQNZyDHofV8G46A+sJiZWI/R5OJFTqyt1hK4Us3
         C5Xfbrjn5Oa7GpsYqoZ7H5CjJOI0YLvuB4fkUW2fwFfdX0aAA9GIKWGM4j77qK6Cq0Bt
         8V/lSvq0uJcV8HxQdJVU6yS/BLt/4RO9x4Ff/vpBv4IiKv3aFuUEtjoOo+eLEozk9ZV5
         wSgttPDCYGBF11hmH7/7BT1QIzKOBDfiAdbbpsRbPztA6VxLa2WbRj7nKqFbLXR9MaQ2
         fB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741871171; x=1742475971;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JykEzm+QtlDREfjY9aCf97M8p4eU9HkNtWKu9+Cs/cE=;
        b=YayCF0sEpQhm/2i4IaNyFopxcHxitERMme+Z6UdQV7L/bodwkl0lNZrcnneqUizBot
         awuDxLGNmkiMUXtWlf2t6H1apkKZEp6B8Hqiz7gvZkeJnAwjcPuc2OSDk5yMs3Gd4sT9
         kpskLrQleVhA1GXxU1sHw8i/DHdFaaBkwk3gNXJ/k6KVnmK4PGcQGUHFnQ+jzeYFd8Gz
         c+W/sjgHLxVHjqqfSFv0dS9zz5YTE1H8n6NFlfoNtpcvlBImiiCJdKHSKDWFylwp2wl4
         jpvY6OpOVy3Ba5YFYsA8k2Qwg/0IjWpR56fip1gnhwdRsGV1jW3l+//0nEwbbXgkhX1l
         ezKQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7gMdBQkN6IEBS3GtecjJP68XCZo/ghKUCSSkgN7dVI/oliVOINURL/Wd52B0fEMAd7QU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSgcD9uspFkgTl0DGto1Fuh1DGuU5BLXfDFJunSBOdSIx7SJYc
	Bzig+G0Izha8Ka8u/oDDXuk5mH9RKj0pVZ2Vczk/vxR32nD6QKMWmXNMHHZ2uDk=
X-Gm-Gg: ASbGncttQu7iiTGkFb2mTznPUTvSz74fow+hRJPICOjZUc7CnHzU8WjZ66db+7xO2yX
	ILrfoOqHryCHCxQ06etFEW1qrkWpPbmRKM+ktXlwofKyiodgvQWe+OHrE9lf5AAI9QcibLZvOf0
	CteDfr+o8E40DxYI8SBDVaZMHWfgmSRPk5UOM7sdle/MmiJbJVERW/FoOKLvKTMu2uGNsHhbeCZ
	qnUe5CxLqyuD2tSZQmy5LIzFBftTA4vYI/ztBaCFy1Q9/ntAAVNNPC6SeCAbccRUuRDc3jiVAa7
	NGgyajOKsGmTVTK3qZKpMYpDtZKDMKux
X-Google-Smtp-Source: AGHT+IHbHWsyXLkkKJFKW9xqRqjCmH9M6Hc04X13GIMAwv1uQuG0cXmClbOatlbE9Co87YMRA/AdwA==
X-Received: by 2002:a05:600c:3b13:b0:43c:e9f7:d6a3 with SMTP id 5b1f17b1804b1-43d01be652fmr113577215e9.13.1741871171136;
        Thu, 13 Mar 2025 06:06:11 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c7df413esm2048987f8f.20.2025.03.13.06.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 06:06:10 -0700 (PDT)
Date: Thu, 13 Mar 2025 14:06:09 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v3 06/17] riscv: misaligned: use correct CONFIG_ ifdef
 for misaligned_access_speed
Message-ID: <20250313-a437330d8e1c638a9aa61e0a@orel>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-7-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310151229.2365992-7-cleger@rivosinc.com>

On Mon, Mar 10, 2025 at 04:12:13PM +0100, Clément Léger wrote:
> misaligned_access_speed is defined under CONFIG_RISCV_SCALAR_MISALIGNED
> but was used under CONFIG_RISCV_PROBE_UNALIGNED_ACCESS. Fix that by
> using the correct config option.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/kernel/traps_misaligned.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
> index ffac424faa88..7fe25adf2539 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -362,7 +362,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
>  
>  	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
>  
> -#ifdef CONFIG_RISCV_PROBE_UNALIGNED_ACCESS
> +#ifdef CONFIG_RISCV_SCALAR_MISALIGNED
>  	*this_cpu_ptr(&misaligned_access_speed) = RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED;
>  #endif

Sure, but CONFIG_RISCV_PROBE_UNALIGNED_ACCESS selects
CONFIG_RISCV_SCALAR_MISALIGNED, so this isn't fixing anything. Changing it
does make sense though since this line in handle_scalar_misaligned_load()
"belongs" to check_unaligned_access_emulated() which is also under
CONFIG_RISCV_SCALAR_MISALIGNED. Anyway, all this unaligned configs need a
major cleanup.


Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew

>  
> -- 
> 2.47.2
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

