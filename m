Return-Path: <kvm+bounces-58636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8778B9A09F
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:32:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A34BB4C3772
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738F330277D;
	Wed, 24 Sep 2025 13:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="iuW/qRMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CE02D7DF1
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758720715; cv=none; b=VjJ1eukClNY8Efa9FTf/572XHcKvghp76/vmsAnD1SO7DCKf7aNJxPkAW57CpjOtTP/BfiS8N3/qtS9B/MX1hB96bdtVolF3Lbg2h517uJHAJlqsQoHRixUGRWSsbV+CWc+50HMIYTg0/g37Em6OM/wTJQ+Cpa6frdLuiujyyXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758720715; c=relaxed/simple;
	bh=yuXU6owTONwJ37j4TOUPBOuXQVVPet2Uv64xo0574yQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nI95a+R7YtGqyatE/KcXHz5TFYzJTc/QkgTUtLsmqDwzLxogg5a3LnR6LPF1uMHOkVTM8VOXL4h7GpYqbC+kBKaxordPmwkOKdB7NnHPknvEWzhKpYl/mvpe+G/rtuJa6lHzrqf8yjQ++g2dOkbbejZt5SiLBj07RDIx9037lIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=iuW/qRMc; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-88432e27c77so190127239f.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 06:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758720713; x=1759325513; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sjr8/7QWc40wBIvcq7xbnNiZ+KKEhi3m1vUvdK7Sd/0=;
        b=iuW/qRMc8p3piBAk5YC7e+vzggAfVwLksK5kfZrWlulNIeeuAqWAaMpfZZ7S9VreUM
         YXfWWkiWoYarUOYOm4B3j/ZbQhI5Hpri07s693/oIwhWABwnxFCL/iJHLuJ5LVqZGeGb
         pSEmP/7iYxdI38WYpqeJ2FgdcWdjENKJru3xGtpb9P7+HIHzq4tXReFG8qGsoCRI3/1F
         cIGCBCuZuJ4r9DuRBOO3c+lG+TSNo/eaBOwAL7UVTFCiKrGmsZ6a3/c/M2eFnThjDa8e
         Zl12JQTxNCUC3PQ64Tik/yKJ+4MmNAfrCxohrpwvV8Q5vXfc04inEVEagn9VeHa0JZuk
         JbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758720713; x=1759325513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sjr8/7QWc40wBIvcq7xbnNiZ+KKEhi3m1vUvdK7Sd/0=;
        b=iQCD6ZCoMJwe8M1YgPKgyodgkxQA5IYArn01F2sMUFD/GL+ZZ28pt1E+jeeAT3av5L
         xTOvlXyWqydobv+7+nMLOgA5DVsUJT3HG2dqtFqzFV1I3xubZxIo4LrDq46H3/hn//sS
         ILrmy3mUnphH7W5Et2SxKG9eMbwWuMPyMXgrSv8qYfz/w5zAQnHrMoiyG1qgPGAv645o
         1T081mqD6tDDuqjzoXmCUAQZ43+zaDZgl/j4pFrTHaCbFR529i/wRzzaWbnB4VOxjg0T
         uImBZ+wLFzxopp4KkQKwOET/lwNxISrAMmExCCAA/858dwuMd6EF/OgHECz3RwRuhnCu
         N64w==
X-Forwarded-Encrypted: i=1; AJvYcCXGbm8YkxVfGlg+galUnLsMdVgXLHaakJAfQqN0E4rtb576O9z2M4GInhDXwLjHOpfVAMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVpZHwn2ygeN9FE9iL484mGmPC/T7ESqlY5GOnz/vaROUZQA43
	X+DwSKEbPHDH7apmPkKXhYCyqwAYC7ty6/t65ps8NJhwX5ZG+yZXEv2nV/ahs3142fA=
X-Gm-Gg: ASbGncv0BdLa14WLzsLatKcf1YahxrAeZIFx/nf6rJHDgq0qJ9ZNMnk7uJHaGr2Kg1i
	PPhlnWatYY+j/HS3Yhp1JvOlDFllxLH8YRTYcdvnlCiIk4diatDxI081ZQ8xG8hzCyZP7PhyIhP
	Rt7wqiK2mG7G4xOtmtb52xKw561/pZnsH7xA8iwcocnxSRDsSbZdJ+sOm72W5YfQFsb/WucBFI5
	VntuLLgKt7l/asLIpwSCg08/AmUskfklJ385DhqDxNK8ihxd/P9nAC+2QC+F2biyMXxu3cBi/OJ
	niSjHO/v2JfJ1mFvSnipNpcTOZR5rNU3Qb4UhNPfXwRaSOqyL0az7KspESgSsK6F927AJSLbkA3
	6ExLx6VXIO4qwnx+HSZxUabR7uRqLmkSoWRY=
X-Google-Smtp-Source: AGHT+IGomox+b2UDBxIjrLVdwH3ZQg0MBial2WDQuoPjUzT0cQ/7OM+jfwuVUQxS7ZLef0sIJoY2Og==
X-Received: by 2002:a6b:6a04:0:b0:893:2ff0:162c with SMTP id ca18e2360f4ac-8e1fd6f67b8mr883021539f.9.1758720712618;
        Wed, 24 Sep 2025 06:31:52 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8a46b2f3405sm646365839f.1.2025.09.24.06.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 06:31:51 -0700 (PDT)
Date: Wed, 24 Sep 2025 08:31:50 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: "Nutty.Liu" <nutty.liu@hotmail.com>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com, anup@brainfault.org, atish.patra@linux.dev, 
	tglx@linutronix.de, alex.williamson@redhat.com, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 03/18] iommu/riscv: Use data structure instead of
 individual values
Message-ID: <20250924-01f9a5207f8865555c839abd@orel>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-23-ajones@ventanamicro.com>
 <TY1PPFCDFFFA68A794163FFB7BFAAAC22BEF31CA@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TY1PPFCDFFFA68A794163FFB7BFAAAC22BEF31CA@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>

On Wed, Sep 24, 2025 at 11:25:59AM +0800, Nutty.Liu wrote:
> On 9/21/2025 4:38 AM, Andrew Jones wrote:
> > From: Zong Li <zong.li@sifive.com>
> > 
> > The parameter will be increased when we need to set up more fields
> > in the device context. Use a data structure to wrap them up.
> > 
> > Signed-off-by: Zong Li <zong.li@sifive.com>
> > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >   drivers/iommu/riscv/iommu.c | 31 +++++++++++++++++++------------
> >   1 file changed, 19 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
> > index 901d02529a26..a44c67a848fa 100644
> > --- a/drivers/iommu/riscv/iommu.c
> > +++ b/drivers/iommu/riscv/iommu.c
> > @@ -988,7 +988,7 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
> >    * interim translation faults.
> >    */
> >   static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
> > -				     struct device *dev, u64 fsc, u64 ta)
> > +				     struct device *dev, struct riscv_iommu_dc *new_dc)
> >   {
> >   	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> >   	struct riscv_iommu_dc *dc;
> > @@ -1022,10 +1022,10 @@ static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
> >   	for (i = 0; i < fwspec->num_ids; i++) {
> >   		dc = riscv_iommu_get_dc(iommu, fwspec->ids[i]);
> >   		tc = READ_ONCE(dc->tc);
> > -		tc |= ta & RISCV_IOMMU_DC_TC_V;
> > +		tc |= new_dc->ta & RISCV_IOMMU_DC_TC_V;
> > -		WRITE_ONCE(dc->fsc, fsc);
> > -		WRITE_ONCE(dc->ta, ta & RISCV_IOMMU_PC_TA_PSCID);
> > +		WRITE_ONCE(dc->fsc, new_dc->fsc);
> > +		WRITE_ONCE(dc->ta, new_dc->ta & RISCV_IOMMU_PC_TA_PSCID);
> Seems it will override all other fields in 'TA' except for the field of
> 'PSCID'.
> Should the other fields remain unchanged ?

The short answer is that the current implementation is doing the right
thing. The long answer is that riscv_iommu_iodir_update() and how it's
called from riscv_iommu_attach_paging_domain() could use some cleanup.

A more logical interface would be that new_dc would be completely written,
which means any fields left zero when creating new_dc will result in zeros
being written -- it doesn't do that right now. Also, rather than passing
DC_TC_V through new_dc->ta (as PC_TA_V, even though DC_TC_PDTV = 0), we
should probably just set it directly in new_dc->tc.

We can clean this up separately though, probably as work for adding SVA
support.

> Otherwise,
> Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
drew

> 
> Thanks,
> Nutty
> >   		/* Update device context, write TC.V as the last step. */
> >   		dma_wmb();
> >   		WRITE_ONCE(dc->tc, tc);
> > @@ -1304,20 +1304,20 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
> >   	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
> >   	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
> >   	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
> > -	u64 fsc, ta;
> > +	struct riscv_iommu_dc dc = {0};
> >   	if (!riscv_iommu_pt_supported(iommu, domain->pgd_mode))
> >   		return -ENODEV;
> > -	fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, domain->pgd_mode) |
> > -	      FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, virt_to_pfn(domain->pgd_root));
> > -	ta = FIELD_PREP(RISCV_IOMMU_PC_TA_PSCID, domain->pscid) |
> > -	     RISCV_IOMMU_PC_TA_V;
> > +	dc.fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, domain->pgd_mode) |
> > +		 FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, virt_to_pfn(domain->pgd_root));
> > +	dc.ta = FIELD_PREP(RISCV_IOMMU_PC_TA_PSCID, domain->pscid) |
> > +			   RISCV_IOMMU_PC_TA_V;
> >   	if (riscv_iommu_bond_link(domain, dev))
> >   		return -ENOMEM;
> > -	riscv_iommu_iodir_update(iommu, dev, fsc, ta);
> > +	riscv_iommu_iodir_update(iommu, dev, &dc);
> >   	riscv_iommu_bond_unlink(info->domain, dev);
> >   	info->domain = domain;
> > @@ -1408,9 +1408,12 @@ static int riscv_iommu_attach_blocking_domain(struct iommu_domain *iommu_domain,
> >   {
> >   	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
> >   	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
> > +	struct riscv_iommu_dc dc = {0};
> > +
> > +	dc.fsc = RISCV_IOMMU_FSC_BARE;
> >   	/* Make device context invalid, translation requests will fault w/ #258 */
> > -	riscv_iommu_iodir_update(iommu, dev, RISCV_IOMMU_FSC_BARE, 0);
> > +	riscv_iommu_iodir_update(iommu, dev, &dc);
> >   	riscv_iommu_bond_unlink(info->domain, dev);
> >   	info->domain = NULL;
> > @@ -1429,8 +1432,12 @@ static int riscv_iommu_attach_identity_domain(struct iommu_domain *iommu_domain,
> >   {
> >   	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
> >   	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
> > +	struct riscv_iommu_dc dc = {0};
> > +
> > +	dc.fsc = RISCV_IOMMU_FSC_BARE;
> > +	dc.ta = RISCV_IOMMU_PC_TA_V;
> > -	riscv_iommu_iodir_update(iommu, dev, RISCV_IOMMU_FSC_BARE, RISCV_IOMMU_PC_TA_V);
> > +	riscv_iommu_iodir_update(iommu, dev, &dc);
> >   	riscv_iommu_bond_unlink(info->domain, dev);
> >   	info->domain = NULL;

