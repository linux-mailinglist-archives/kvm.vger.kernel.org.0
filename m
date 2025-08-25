Return-Path: <kvm+bounces-55644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 991FDB34727
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 18:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A818716AC27
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2BE3002BE;
	Mon, 25 Aug 2025 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="E6yCiHZX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F49F11713
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 16:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756138935; cv=none; b=HQ1Max9nhaHhmoU/BQFwP9lje5D6u/bBI/EosT1tNwbwQQsEhiZhvMvnAPSdzh9Xyo8rP1bFQBeERcPKOjGoFCgjaaVEwv2/6Y7nsYIRDxTjfIXYzuk8RM7LZ6//f6H4G/Co8wTHU7flfDROqC2TD+IrNjVeynyPuEbLS3NIiZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756138935; c=relaxed/simple;
	bh=JeuslXWF3RXWs7wR6we9lSHOWfjRXXLnSuu4MvbX5yw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eaxyuFKZAYnsMt/ZFu5/BRwNvbOHA+nqMQ1qPLA7ET3RqiWOZkl4I1940zHGe9CxzcS2nVM5c8M0PCMMs2w4prk5h/Ym4+k3sRoNMcwvsvzJVmdc1lzmZBiTFGRqmXvmUq/fJ0zlctCunAOtH12NJqSXoEacaqhbITI0x04ijcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=E6yCiHZX; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3eb71ce0510so22366275ab.0
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 09:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1756138933; x=1756743733; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gN8JTVN3UqrYbcE7si46e+ibxM+XGryuvpF6NcC0BZ0=;
        b=E6yCiHZXLXd/y1hXF2DqMCJ8m1O08w87Su9g5PH6mKTyrIK9QU0UQbRVJK/QSuxbLM
         2gw/t2g2fkmizWPCUic2tCwvNRVKx9EE4iyMzHSzmgc2VdPcHElHO9kiuF02QVko+WUb
         ehhJDWCQRJ06eMBbi4z49J983ttOZAfugUZUpvUZa0tCpKNCbkrBkanmrDh4dud6Ew2i
         yuw2OSRVmJxxagEIOV6DaxkSTiDyVKONz5cwkufYwFvAz8Kv5vOMs8syI6Cnj3sxDITx
         +aJSacFMUYu7SCxKosljIEtmK22+wgHGWjW6+q4iRYsUhNPxaevLJd/WANEH4M2/6V8c
         Lu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756138933; x=1756743733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gN8JTVN3UqrYbcE7si46e+ibxM+XGryuvpF6NcC0BZ0=;
        b=VdJIj61J03JRWiEqL+DXWNR3+fxzq0PXLUU5G00otWKg7l434OIiA9xQTy1YmWhG8N
         fj6E69B+OT87wbWrgQaGULTBNBFkSiYRTdCvwAntXRZfRFqaEfuEo0o2VikuqYM3BIUJ
         cWfRj+xxHw1gtzEcYeccVrYyFZTfT8kefey+Hfrz/m2aMbBvx0BkTU70sau2u3Va46Ch
         HiZJxMeEEoFrWiifXT/H1BrNm336gKevPFrG+FFgydygbNiqr+rIcD0E89JvYkueBL/7
         iU7LW3Jqi7SO6+CCKOVIk/TUVluLqtXcB0vzQIniDqfCjl7t0hb0z/HM3DWeW830Cubh
         RD4w==
X-Forwarded-Encrypted: i=1; AJvYcCUsER94Hp6UQVXT4HRDww4fcjWBOis64YYC/toGCk6/H8Yn53dyWrsdSrdCtk1stP8O3UU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzig87ljolA1c4hxQMsf+h2MmwFviduHN6YTuUVFAmCJqHi4U22
	PiWc2s1TZw5ePVbWLGnu9IZQUehwO//JNrAslYEdsv2qKfqZXJS6Gdco1rep+g2+bwQ=
X-Gm-Gg: ASbGncsOzmbmQYmC0N+OCt7Sa+5JJAaA6PuSZuOTrN0Hx2PCXotsEOtI4BIKekyMdFh
	Z+GEe9R0zSl8jII1957BjVwZLyvhPBzuTaASRNC6u/9eVm7Blr31qMu6bVw1eqBZE1lMe4l1Gha
	ohqm64HPaWrxOxsHWqs/gUUO+2C46GWMP4maLeTfDQDlu1Wki8Bjn+nF7MIDoWMj0EW3vR1kPrY
	HVgllaoiCTsUMs7m8Qgs9V4fwa3mUwgceNUxRhHRrfvtaUVeKyjyDbVALDD3krS1v4HxqrU9o0X
	+F7V6FU6MLL1nWLg8rKqh0hO6NXu1bZMHexTck4SQlVMUwikgvtvCes/EqZvfYmBRVwdD+Ux0uR
	gbqHj2IoZvriciW/8q1YfJWWg
X-Google-Smtp-Source: AGHT+IHxDLcJHAYpyzsrbmn/aJb96iGEjJWm0YdiTY2GoeJB5NHC5Ix7Bwg5uxn0XGZ/yig4LtZaRw==
X-Received: by 2002:a05:6e02:184c:b0:3ec:40cf:2d37 with SMTP id e9e14a558f8ab-3ec40cf2ed7mr61486495ab.31.1756138933068;
        Mon, 25 Aug 2025 09:22:13 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4c28624bsm49231365ab.18.2025.08.25.09.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 09:22:12 -0700 (PDT)
Date: Mon, 25 Aug 2025 11:22:11 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Jinyu Tang <tjytimi@163.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Conor Dooley <conor.dooley@microchip.com>, Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Nutty Liu <nutty.liu@hotmail.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] riscv: skip csr restore if vcpu preempted reload
Message-ID: <20250825-69a3c8b588e0bb1fbb5b7beb@orel>
References: <20250825121411.86573-1-tjytimi@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825121411.86573-1-tjytimi@163.com>

On Mon, Aug 25, 2025 at 08:14:11PM +0800, Jinyu Tang wrote:
> The kvm_arch_vcpu_load() function is called in two cases for riscv:
> 1. When entering KVM_RUN from userspace ioctl.
> 2. When a preempted VCPU is scheduled back.
> 
> In the second case, if no other KVM VCPU has run on this CPU since the
> current VCPU was preempted, the guest CSR (including AIA CSRS and HGTAP) 
> values are still valid in the hardware and do not need to be restored.
> 
> This patch is to skip the CSR write path when:
> 1. The VCPU was previously preempted
> (vcpu->scheduled_out == 1).
> 2. It is being reloaded on the same physical CPU
> (vcpu->arch.last_exit_cpu == cpu).
> 3. No other KVM VCPU has used this CPU in the meantime
> (vcpu == __this_cpu_read(kvm_former_vcpu)).
> 
> This reduces many CSR writes with frequent preemption on the same CPU.
> 
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
> ---
>  v2 -> v3:
>  v2 was missing a critical check because I generated the patch from my
>  wrong (experimental) branch. This is fixed in v3. Sorry for my trouble.
> 
>  v1 -> v2:
>  Apply the logic to aia csr load. Thanks for
>  Andrew Jones's advice.
> 
>  arch/riscv/kvm/vcpu.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

