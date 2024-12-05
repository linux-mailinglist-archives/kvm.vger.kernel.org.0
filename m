Return-Path: <kvm+bounces-33164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2C49E5B17
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 17:14:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8DF11886002
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 16:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2CD225781;
	Thu,  5 Dec 2024 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="B4sLpv/e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89203224B16
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 16:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733415143; cv=none; b=frG6zbJVD5byXsZ61aK9RP3Fu4TSnAgsClp0clRobeRfv+MAvLfqkxwzvu9J4zOeBCGzt5fLrz0K7xPx/jl+c3wETKHmFvNWtrdxQmhfFndDQODJpXCpl+HquKpJGGIv6UKZyUNsRuK7USYLCdbM9HsOqxpY7hZQHEtG8Z7rxc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733415143; c=relaxed/simple;
	bh=Ut8+scTSjVpQnW57Q4gARiffheiB676olnzlE55eiMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRZN8+mOdCDwxClSouGHTyaPmAWZVXr/UNA1z+0WhjBbJhSatjx0skF/gbR+HgK4JrJS9caJXiEW7g0uhjWo65LQEALovRgeA8lTI+/QcTieubmjo5m3KJzsDDXQskb9lkjNLQJ3JHdWVOuYcLXGvdf8Xkhmij+diW1mk+YOfac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=B4sLpv/e; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-434b3e32e9dso11728915e9.2
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2024 08:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1733415138; x=1734019938; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+3xHwvrZFGkgILsc+8sbeeDFiAlqkrIqdKcR5hFeMk=;
        b=B4sLpv/exmyOUHnfBCb8gxCy8CZ3BWOPcLwIawR8N8417SxzLYiqlquJGav5W0wsBE
         +c9gA3JzzHJAzYhBifHzgddHFj+BQh9PV4m8Aug6tVkrKmCmql0ZUzFoi864YxRoHKBb
         EzRhYjuWEKZnHhM5XZXDVxrEmp5A5GwMoeOBW4lUBDDbt4Te76cIIc/1Qo3W3B+cFysH
         O83c/kjm5AdXXKlsEOBYI4kYlcWFwqOXObhYf4zD//CUtWHrdTersHYfDrB3njWcv9UD
         2BQ99nE6/Af8ydEsWI7eZIiX67cRK4Tb/oWOFRZM8xv+IBvj5ujFeRyF73ntatgy749e
         dskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733415138; x=1734019938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+3xHwvrZFGkgILsc+8sbeeDFiAlqkrIqdKcR5hFeMk=;
        b=lPwLAWzouGGBqbo4CZNDxhA+L4zl2jiQz0sdSb5Wgin8OhWo25R7Z88rfJE/XeYirf
         /KLmDLUf77TfQzcWHwLmZqlyZI09ugSlMOyG09lcEZUwFUO4G10cDlho5jDb0xiY6RUp
         rXQdKfQiFis0c6Qagn7fd5zMkUO61TcQ4RA+bWTxqobT+cmyU7jIIHpRFL7fe6EXtA3e
         wACJNvyy/9L9Q361T0K9JALamDM5qBYlYmPuTyx5HMpmn1kdUtxziJFp/9h7XZCo1Lxk
         WodTSFVQnlW6tLLGxWpDNKhRR1iYAUzO0G/wHftlJ5z0ZqfmXXKkbRmM2XfHiydvhD+7
         Vv/g==
X-Forwarded-Encrypted: i=1; AJvYcCUK+gRFHpHxvj4myTsh9BhONZFaNL6P9ZFmTHu8GydWkJmp6hNCfsBSYEqI+O2n0YCBRfI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy71jMUz88HleKRKp5S/GN6dmIINdbJqioxhCMXymdJ6Qb3SSjd
	rMOi6JL1k6TnHuCiIazsG0GOcptTQyP66dPwdYLQ3wxFKeUnVkGUOIrAWzEPhxA=
X-Gm-Gg: ASbGnctmPbaYB3IgRwcJWqDS+6lUdBMTo34LRtzNZ3Utmj2mvjWbrG1XmdkE68H6xlA
	VgSBmiUURndyj/aKYjXpWS7aUfx6WUwboMTKbT4JbltilsGSGJOhrCtMQeizd7s/kjYn9AIxXU1
	YQ4h8kLxpl/ihlvKCu0nBWLh80kh8bXlvegCkj0Nn3jVYB3QWF3qPx1fFDlBzXFXJSzYOoCjkS3
	TuwZNL4uLpvCm2ssGEne1g/hMcI+T9ZaRgkLM+klRnfoYb+qSJ3OmmjrdU52LVXgNt8jTEomD86
	eIwIjqgHeDWmaVvGttIUNp/39E6RbtQLYnU=
X-Google-Smtp-Source: AGHT+IHa5lee9Sxqmls08SUxS6uuiGe/lvzblZfbVXScCZEse7mEYCbZITkpv0Vj+gpxQag2jSxbIw==
X-Received: by 2002:a05:6000:18ab:b0:385:e8ce:7483 with SMTP id ffacd0b85a97d-385fd3ccbbfmr9165309f8f.4.1733415137730;
        Thu, 05 Dec 2024 08:12:17 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3861f4a874dsm2290643f8f.24.2024.12.05.08.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 08:12:17 -0800 (PST)
Date: Thu, 5 Dec 2024 17:12:16 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, anup@brainfault.org, atishp@atishpatra.org, 
	alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 01/15] irqchip/riscv-imsic: Use hierarchy to reach
 irq_set_affinity
Message-ID: <20241205-2ed14db745f00a0ee9be444b@orel>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-18-ajones@ventanamicro.com>
 <87mshcub2u.ffs@tglx>
 <20241203-1cadc72be6883bc2d77a8050@orel>
 <87a5dcu2wq.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5dcu2wq.ffs@tglx>

On Tue, Dec 03, 2024 at 05:50:13PM +0100, Thomas Gleixner wrote:
> On Tue, Dec 03 2024 at 17:27, Andrew Jones wrote:
> > On Tue, Dec 03, 2024 at 02:53:45PM +0100, Thomas Gleixner wrote:
> >> On Thu, Nov 14 2024 at 17:18, Andrew Jones wrote:
> >> The whole IMSIC MSI support can be moved over to MSI LIB which makes all
> >> of this indirection go away and your intermediate domain will just fit
> >> in.
> >> 
> >> Uncompiled patch below. If that works, it needs to be split up properly.
> >
> > Thanks Thomas. I gave your patch below a go, but we now fail to have an
> > msi domain set up when probing devices which go through aplic_msi_setup(),
> > resulting in an immediate NULL deference in
> > msi_create_device_irq_domain(). I'll look closer tomorrow.
> 
> Duh! I forgot to update the .select callback. I don't know how you fixed that
> compile fail up. Delta patch below.
> 
> Thanks,
> 
>         tglx
> ---
> --- a/drivers/irqchip/irq-riscv-imsic-platform.c
> +++ b/drivers/irqchip/irq-riscv-imsic-platform.c
> @@ -180,7 +180,7 @@ static void imsic_irq_debug_show(struct
>  static const struct irq_domain_ops imsic_base_domain_ops = {
>  	.alloc		= imsic_irq_domain_alloc,
>  	.free		= imsic_irq_domain_free,
> -	.select		= imsic_irq_domain_select,
> +	.select		= msi_lib_irq_domain_select,
>  #ifdef CONFIG_GENERIC_IRQ_DEBUGFS
>  	.debug_show	= imsic_irq_debug_show,
>  #endif

Hi Thomas,

With this select fix and replacing patch 03/15 of this series with the
following diff, this irqbypass PoC still works.

Based on what Anup said, I kept imsic_msi_update_msg(), which means I
kept this entire patch (01/15) as is. Anup is working on a series to fix
the non-atomic MSI message writes to the device and will likely pick this
patch up along with your changes to convert IMSIC to msi-lib.

I'd like to know your opinion on patch 02/15 of this series and the diff
below. afaict, x86 does something similar with the DOMAIN_BUS_DMAR and
DOMAIN_BUS_AMDVI tokens in x86_init_dev_msi_info().

Thanks,
drew

diff --git a/drivers/irqchip/irq-msi-lib.c b/drivers/irqchip/irq-msi-lib.c
index 51464c6257f3..cc18516a4e82 100644
--- a/drivers/irqchip/irq-msi-lib.c
+++ b/drivers/irqchip/irq-msi-lib.c
@@ -36,14 +36,14 @@ bool msi_lib_init_dev_msi_info(struct device *dev, struct irq_domain *domain,
                return false;
 
        /*
-        * MSI parent domain specific settings. For now there is only the
-        * root parent domain, e.g. NEXUS, acting as a MSI parent, but it is
-        * possible to stack MSI parents. See x86 vector -> irq remapping
+        * MSI parent domain specific settings. There may be only the root
+        * parent domain, e.g. NEXUS, acting as a MSI parent, or there may
+        * be stacked MSI parents, typically used for remapping.
         */
        if (domain->bus_token == pops->bus_select_token) {
                if (WARN_ON_ONCE(domain != real_parent))
                        return false;
-       } else {
+       } else if (real_parent->bus_token != DOMAIN_BUS_MSI_REMAP) {
                WARN_ON_ONCE(1);
                return false;
        }


