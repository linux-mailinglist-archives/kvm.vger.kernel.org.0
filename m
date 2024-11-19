Return-Path: <kvm+bounces-32042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13AB89D20F5
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 08:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916F31F216A0
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 07:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CD5157469;
	Tue, 19 Nov 2024 07:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="XwBDjrTu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F1F1482E8
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 07:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732002581; cv=none; b=n2O5szpHGCphkITOEGpPFSHyPPOF5dAJK7vQXR7LRbkUsZ19fhvCTWFpE3smNHbSmxa6uBbUs/BnmuYfdztYr+cbUkNq+IVg7XvsI5bFoVXoqPAj0Cqdo8E/pAlCbTeMpBn1eNJdnqgL0NCsbc+8/ZuTwrEPVLaBiaK3kizC36U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732002581; c=relaxed/simple;
	bh=IaOmPR/iyXz/gE2tIqhYLRtRkctqg6/SvtDytNmpBsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1fzPEFTHuN7bE4K4Q1QUYg5vFLSzvoJs/6hdhRW0N8b+Mdd6jSIhL4mjfIbrXblNSc3QtlwvTe/8LcDek3+Np7HvtoWI93R4WMTQkuxReZGlGFFlP9v45ruM/jWRI1NTJlYDDBD2xsx2dOMKyxWhAfuY5pP3ZW4GNIfvvOFBiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=XwBDjrTu; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4319399a411so5321455e9.2
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 23:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732002578; x=1732607378; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NYBbT7qYRsGmfiJkt6bNI0oAoiQc6F6a4Czuh6tR0Qw=;
        b=XwBDjrTussjY6RHezcIuHZKjMrm1R4KQ5RX+9HR0eIlkiHxE+eGunbjL06TCC8o6gJ
         RnytoW+3hI1JQwhexKoxBs7IoJz8OqvapJSCnVup1Yfy9yu35HJqmKTpD308spM6SY5u
         EY4vkiUDqvaU7glgLVssResUMqE9UP7JwmVFWqiHwJ8hFTQRjmBz06r6yiDObfoToBSc
         A9S13BtLM/bGrLrvN9xNjWRF92nNWNEcm9RS8mieB7fm41GNVVNq8FRNuQJ+eoU/w652
         ZhIuHvm4+ZbG7KlGVMIgIB85i9iRgtN4w90k/u8rmCYRyw8xWVZzk4OIPHIDTkhr4Y9o
         87HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732002578; x=1732607378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYBbT7qYRsGmfiJkt6bNI0oAoiQc6F6a4Czuh6tR0Qw=;
        b=tIc2NnV8GrfGxRroQRxHDmcWQEPyrcJLEwVWwjv5nLVXjFS+KEKl41ANEa7rdlb/Kd
         hQz6ya7AUQ+d9RG5mN/OiOn+yu+1yumLbO5cTfC+5n+QY0keKSSbK7YigG50OJDHuA4k
         YkHQOeTRaxSJBllvXq2kqf3OEEbtbIlk87FrZM1hCV832HDqDGCy4jnPRHjsyRbAxluc
         Gx+Ft+kykaKTDsD4hSzPUbJyJT+vY2k1wxUdjelJo01GosgMSH8IJOVlr8lSpSQeTC9m
         hLznVF3I5y67/mnHszL5g/wUi+ViFSjEWnmiOpzBim5ZNQNZSQL2+l5FOTq6k4qgV7b/
         mjLA==
X-Forwarded-Encrypted: i=1; AJvYcCWHpfys9eBx1LnIGXxSSoR0Y1J8tR5qK5EeWX2gYm8oVDXvaZ2hipO6n6C72zRh4H3xt8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiHWR/dqq9gLwhPcXnI/oilDdjllCQzKnn0jPGV2fPKT2wzkJ6
	h6GuyUWwv0n+l3q+sqhUOfiwaw8gr7M640Ns08ofD9n2t5x4qQaRR8eheYWVBF8=
X-Google-Smtp-Source: AGHT+IFe5ZmtjhLXYqttDHgdk3C4AFgFbxG7y2tLe4XO1qVtRECgKa8Bx3LhB6YxSZPNMfHR5Z6PNw==
X-Received: by 2002:a05:6000:2d01:b0:382:5030:7b94 with SMTP id ffacd0b85a97d-38250307d48mr353908f8f.13.1732002578369;
        Mon, 18 Nov 2024 23:49:38 -0800 (PST)
Received: from localhost (cst2-173-13.cust.vodafone.cz. [31.30.173.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382462dbb5esm5733966f8f.52.2024.11.18.23.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 23:49:37 -0800 (PST)
Date: Tue, 19 Nov 2024 08:49:37 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, anup@brainfault.org, atishp@atishpatra.org, tglx@linutronix.de, 
	alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 08/15] iommu/riscv: Add IRQ domain for interrupt
 remapping
Message-ID: <20241119-62ff49fc1eedba051838dba2@orel>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-25-ajones@ventanamicro.com>
 <20241118184336.GB559636@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118184336.GB559636@ziepe.ca>

On Mon, Nov 18, 2024 at 02:43:36PM -0400, Jason Gunthorpe wrote:
> On Thu, Nov 14, 2024 at 05:18:53PM +0100, Andrew Jones wrote:
> > @@ -1276,10 +1279,30 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
> >  	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
> >  	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
> >  	struct riscv_iommu_dc dc = {0};
> > +	int ret;
> >  
> >  	if (!riscv_iommu_pt_supported(iommu, domain->pgd_mode))
> >  		return -ENODEV;
> >  
> > +	if (riscv_iommu_bond_link(domain, dev))
> > +		return -ENOMEM;
> > +
> > +	if (iommu_domain->type == IOMMU_DOMAIN_UNMANAGED) {
> 
> Drivers should not be making tests like this.
> 
> > +		domain->gscid = ida_alloc_range(&riscv_iommu_gscids, 1,
> > +						RISCV_IOMMU_MAX_GSCID, GFP_KERNEL);
> > +		if (domain->gscid < 0) {
> > +			riscv_iommu_bond_unlink(domain, dev);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		ret = riscv_iommu_irq_domain_create(domain, dev);
> > +		if (ret) {
> > +			riscv_iommu_bond_unlink(domain, dev);
> > +			ida_free(&riscv_iommu_gscids, domain->gscid);
> > +			return ret;
> > +		}
> > +	}
> 
> What are you trying to do? Make something behave different for VFIO?
> That isn't OK, we are trying to remove all the hacky VFIO special
> cases in drivers.
> 
> What is the HW issue here? It is very very strange (and probably not
> going to work right) that the irq domains change when domain
> attachment changes.
> 
> The IRQ setup should really be fixed before any device drivers probe
> onto the device.

I can't disagree with the statement that this looks hacky, but considering
a VFIO domain needs to use the g-stage for its single-stage translation
and a paging domain for the host would use s-stage, then it seems we need
to identify the VFIO domains for their special treatment. Is there an
example of converting VFIO special casing in other drivers to something
cleaner that you can point me at?

The IRQ domain will only be useful for device assignment, as that's when
an MSI translation will be needed. I can't think of any problems that
could arise from only creating the IRQ domain when probing assigned
devices, but I could certainly be missing something. Do you have some
potential problems in mind?

Thanks,
drew

