Return-Path: <kvm+bounces-32057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 130309D278E
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:01:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7C05283701
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6477C1CDA36;
	Tue, 19 Nov 2024 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="l2kGqu0e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67365197552
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732024853; cv=none; b=m94vkZEf+Ce+X9yAmV8Sp9AtwjeQY8zrqz3uszINMkt+S/22FlM41MheAOorVP76FePrX42X0p+w2ii5pEV/7ohtFoTR7xcaNNMpmR+tGGVE4lBn4GP3yIvFjj5l066Qard6BR/O4IrmBduOLWuH0IYiPtTexah6eBTnTpq3qlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732024853; c=relaxed/simple;
	bh=kf3Z6I24SKWn5bdSsa1E0NrkCUFicEWYJkJii1hPtGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCdbr9JbtPQExBP1E0wSOzQxrwVhcR+fkEQ+QG+6jJuwDa6Ibp2jpdYcCEkMYpzAQHeqibKo/Jo53AelOsoYFAH4DhHIZV4my+sOpWQwFQqzH5CyyDB1BCxgMPeJAyjxsLA1A7H4ifZIL5g4MC4ZBHTFAtnDw0ZLSrnrtIoxE2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=l2kGqu0e; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-460b16d4534so5638991cf.3
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 06:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1732024849; x=1732629649; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=utcZjeJ4axtWtuvENXsYE5WdR2pTF/ksB5rq4r17jag=;
        b=l2kGqu0ew9kLEZ8WGxTHKkWAMn5ZBZ6u+ww4hTH3xTRQ9LmXuNgCScfQtOvI983Bxk
         PjaIuvkfWom5B0zB5i67cOCOTHag01vtqntwZ/lxxqjSyvCzj7gwtCHtVk/TSicgHhFW
         7G0QbALTLC/Bx//oG9yPOIdpQzDX2lPneRc5+bSL83R1mYLM7bElAWhT3gEgCuNRJx2x
         ZAggA7jqm8RYdhpPovQdoeb1KhvqH0wgCarQYoVIpS2v1YtQw1MrKVFjJVqqviPsCvMn
         pfgtHvfiCTSudTpF8E17a46YzBK+SBlsGoPeH71oTMmAnwNk2KvKDIRMDuCgnmCgtjq0
         jJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732024849; x=1732629649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=utcZjeJ4axtWtuvENXsYE5WdR2pTF/ksB5rq4r17jag=;
        b=OGOQVh44Xm520I0rhyDT0VJ17b2z19og4JtqT6o1hXiU+0eNk+WtbU6h8+IPOU/JEc
         xMcLskiA48s5RwILaGTsLzCuMwv0odGD3NHQCVQG7QYanA+/UNeybeDOOE0AOHbCBIxK
         +dfRBEh8tewHL4c1sCal/pkumCv4vxWzza5AFp8Tqek7X3Flrh0syB58vh09QzGBdNd8
         uHjEgXwxW+lYXoD95UI19RcWbhCWGCryERrBKrR07pRt2BITgs7HXn7u1HARDxe5LdXx
         C8Hht5P5A3QCN3jYLO8gj/r70HWB3Zg0XCwz2O7KL0zEnq2OsLaRGQnsYtMu/l8o1Bp8
         bfrw==
X-Forwarded-Encrypted: i=1; AJvYcCUyXg36R+ik6GUzUWfJcrOKuCHta+WWCyDOZL+509IiJF1/h/m2N3KEBaQ7xsoUvnVQelo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGkOlPnFtHnR2ZNg6U3JCppkJq9hHeFxccHqaoONlcxPlgk8wz
	hkvifRuB3fSF3TxhRnhJWyu8Hcex8kfwl+EXA+UaUijNLYmpfQuQndSbIwqNolQ=
X-Google-Smtp-Source: AGHT+IHKbzbz2zzGHIA7vNzQrKdrVbH22etzYZttFKms0g8ZJKuTulmGaSp4Zqq0m5k19nTsP7U0iw==
X-Received: by 2002:a05:622a:10f:b0:45f:788:b1b1 with SMTP id d75a77b69052e-46363e2f7d2mr196949061cf.25.1732024849064;
        Tue, 19 Nov 2024 06:00:49 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46392c3c22fsm11239771cf.86.2024.11.19.06.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 06:00:48 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tDOmd-00000003DsE-272U;
	Tue, 19 Nov 2024 10:00:47 -0400
Date: Tue, 19 Nov 2024 10:00:47 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, tjeznach@rivosinc.com,
	zong.li@sifive.com, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, anup@brainfault.org, atishp@atishpatra.org,
	tglx@linutronix.de, alex.williamson@redhat.com,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 08/15] iommu/riscv: Add IRQ domain for interrupt
 remapping
Message-ID: <20241119140047.GC559636@ziepe.ca>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-25-ajones@ventanamicro.com>
 <20241118184336.GB559636@ziepe.ca>
 <20241119-62ff49fc1eedba051838dba2@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119-62ff49fc1eedba051838dba2@orel>

On Tue, Nov 19, 2024 at 08:49:37AM +0100, Andrew Jones wrote:
> On Mon, Nov 18, 2024 at 02:43:36PM -0400, Jason Gunthorpe wrote:
> > On Thu, Nov 14, 2024 at 05:18:53PM +0100, Andrew Jones wrote:
> > > @@ -1276,10 +1279,30 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
> > >  	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
> > >  	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
> > >  	struct riscv_iommu_dc dc = {0};
> > > +	int ret;
> > >  
> > >  	if (!riscv_iommu_pt_supported(iommu, domain->pgd_mode))
> > >  		return -ENODEV;
> > >  
> > > +	if (riscv_iommu_bond_link(domain, dev))
> > > +		return -ENOMEM;
> > > +
> > > +	if (iommu_domain->type == IOMMU_DOMAIN_UNMANAGED) {
> > 
> > Drivers should not be making tests like this.
> > 
> > > +		domain->gscid = ida_alloc_range(&riscv_iommu_gscids, 1,
> > > +						RISCV_IOMMU_MAX_GSCID, GFP_KERNEL);
> > > +		if (domain->gscid < 0) {
> > > +			riscv_iommu_bond_unlink(domain, dev);
> > > +			return -ENOMEM;
> > > +		}
> > > +
> > > +		ret = riscv_iommu_irq_domain_create(domain, dev);
> > > +		if (ret) {
> > > +			riscv_iommu_bond_unlink(domain, dev);
> > > +			ida_free(&riscv_iommu_gscids, domain->gscid);
> > > +			return ret;
> > > +		}
> > > +	}
> > 
> > What are you trying to do? Make something behave different for VFIO?
> > That isn't OK, we are trying to remove all the hacky VFIO special
> > cases in drivers.
> > 
> > What is the HW issue here? It is very very strange (and probably not
> > going to work right) that the irq domains change when domain
> > attachment changes.
> > 
> > The IRQ setup should really be fixed before any device drivers probe
> > onto the device.
> 
> I can't disagree with the statement that this looks hacky, but considering
> a VFIO domain needs to use the g-stage for its single-stage translation
> and a paging domain for the host would use s-stage, then it seems we need
> to identify the VFIO domains for their special treatment.

This is the wrong thinking entirely. There is no such thing as a "VFIO
domain".

Default VFIO created domains should act excatly the same as a DMA API
domain.

If you want your system to have irq remapping, then it should be on by
default and DMA API gets remapping too. There would need to be a very
strong reason not to do that in order to make something special for
riscv. If so you'd need to add some kind of flag to select it.

Until you reach nested translation there is no "need" for VFIO to use
any particular stage. The design is that default VFIO uses the same
stage as the DMA API because it is doing the same basic default
translation function.

Nested translation has a control to select the stage, and you can
then force the g-stage for VFIO users at that point.

Regardless, you must not use UNMANAGED as some indication of VFIO,
that is not what it means, that is not what it is for.

> Is there an example of converting VFIO special casing in other
> drivers to something cleaner that you can point me at?

Nobody has had an issue where they want interrupt remapping on/off
depending on VFIO. I think that is inherently wrong.

> The IRQ domain will only be useful for device assignment, as that's when
> an MSI translation will be needed. I can't think of any problems that
> could arise from only creating the IRQ domain when probing assigned
> devices, but I could certainly be missing something. Do you have some
> potential problems in mind?

I'm not an expert in the interrupt subsystem, but my understanding was
we expect the interrupt domains/etc to be static once a device driver
is probed. Changing things during iommu domain attach is after drivers
are probed. I don't really expect it to work correctly in all corner
cases.

VFIO is allowed to change the translation as it operates and we expect
that interrupts are not disturbed.

Jason

