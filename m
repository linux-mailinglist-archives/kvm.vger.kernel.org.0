Return-Path: <kvm+bounces-25660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 13EA4968292
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 10:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59392B21326
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 08:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3B8186E3B;
	Mon,  2 Sep 2024 08:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vkRddNPM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5733C18734F
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 08:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725267479; cv=none; b=Q/1mT66M/b6+AuyW4fM07AM6ntKiyp9ZsogGAQYSd3EOS7PrMnHVqLp8Dk6XwLfIfPXOIGL0PUmXToAbrUbGAAASB3KyTXI8h2KuCJMqRGjAfaQ5x8iw36jN3Cirp5gDwYNd7LSdLE23qhrcKFwbTehT1ZgcbDVJQ3ZJIs8vai8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725267479; c=relaxed/simple;
	bh=c0OW0xQ0WrcxXFjOgX053qT4DVNz5MYcUfMesZuHjIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLtIptr2M8yyaLGPYLGid7L2ARIx7GES6TTjAsIsdqoF5sdzZ4ILJqcJWDtkvkCsJuWVb8nXJgjDJ4bKn/aW8NdeeuO9jxqih/07jB0JqgWE9QnhQ0wcbQVmyLSS8gMijmykJALDTVFZTCFphPP2ha6zGyj/7jBELL2I/lWjWfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vkRddNPM; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42bba6a003bso61905e9.0
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 01:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725267476; x=1725872276; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rDJ3c/SnX1xtZaObviOe/fqhAy0qt+DAWX/W/IrfKf8=;
        b=vkRddNPMA6DbDZi17PzUP08G7rXIpFf/JE5gv/YEmbmHvNjXntwQIGINc6afLrynRe
         IYUTyLoG1K3oBOBnH8GUvxnL7cgb/mawb+pCV/UhPApSyBTR6VTBF/s9bsHp9TBaFdX+
         NxFyS/I5ObQMlrKuD7LQy+3Q47dmdKTo8o0fA0qoLLaOCjlHTtQskRpHO9BSQdlbvcVd
         UwZ2Rt5/1FrZKWZZ2H8O2KG7IwI0TnFpaq5RoXdt3bh69M1NO8WkSctd8/R07DQlNuXF
         /5eWYTD5PAkN9ZHZy91W9gAn7is0woVyzX7WuVKKHIzxltQ53Lo4L51i56RyEQ5LAxp4
         opTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725267476; x=1725872276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDJ3c/SnX1xtZaObviOe/fqhAy0qt+DAWX/W/IrfKf8=;
        b=KkM15Zc0BXZDHVYYWJ2YcJ47D85CKqIXCuO1Z65zapm23RjghkbKby4een+1EZLQyG
         8c0/KVWQFpOWlyRfkQWu71h13PXke+QkQw63snY2rBEVG4x+e8SChJUkvsCvuM48QK80
         MwKQ0cuWIuJl/KxF0VXtCNRO/YQ9GY6iKCMuGNWpMCHZB41jXXmOhISRS0sFLn8lzaDH
         E9nFMfmFtQTs+ZS30UD3QlKVpTByMcC3l/zSPJDW6ww+qEATU9zUw3Uig82LaCH1KFXo
         IQJnMyWWApxQuAkOb6Xj6F2e0bfRGMmez9hxHHdMOS1mjO5rZo3AZ2jT3o8z7cYjutZH
         8WFw==
X-Forwarded-Encrypted: i=1; AJvYcCUcvvo9fib12aCZSXlLxUSdbnShKNB9wPORHTb8yjhmVlOdkfoJ/8RpaLAvdj/ecGVzhPM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyscUnFz0+tR7kJCTOnPxGpIc9Lg2/tdE/wfXzQSURunQLarde
	PYMI6vaiylayszhoXETbDIXqzhiecP3/nc/OeVT6T+4I9UlZwsHdHiLuMSzWVA==
X-Google-Smtp-Source: AGHT+IEaLVJ/wTV51wop3m+lk/qJDgyUDoC18kpCfu1q8TvT9dKkREX0von9jbn66ji3B2gnWNgrVA==
X-Received: by 2002:a05:600c:3ac8:b0:428:31c:5a4f with SMTP id 5b1f17b1804b1-42c787685fbmr1905585e9.3.1725267475261;
        Mon, 02 Sep 2024 01:57:55 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374c2ffe062sm4918816f8f.29.2024.09.02.01.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 01:57:54 -0700 (PDT)
Date: Mon, 2 Sep 2024 08:57:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Message-ID: <ZtV-DvqIDx5ZFAph@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHkxFrojjXplvvn@google.com>
 <20240830171817.GY3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830171817.GY3773488@nvidia.com>

On Fri, Aug 30, 2024 at 02:18:17PM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 30, 2024 at 03:27:00PM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Tue, Aug 27, 2024 at 12:51:37PM -0300, Jason Gunthorpe wrote:
> > > For SMMUv3 the parent must be a S2 domain, which can be composed
> > > into a IOMMU_DOMAIN_NESTED.
> > > 
> > > In future the S2 parent will also need a VMID linked to the VIOMMU and
> > > even to KVM.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > index ec2fcdd4523a26..8db3db6328f8b7 100644
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
> > >  			   const struct iommu_user_data *user_data)
> > >  {
> > >  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > > -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> > > +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> > > +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
> > >  	struct arm_smmu_domain *smmu_domain;
> > >  	int ret;
> > >  
> > > @@ -3116,6 +3117,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
> > >  	if (!smmu_domain)
> > >  		return ERR_PTR(-ENOMEM);
> > >  
> > > +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
> > > +		if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING)) {
> > > +			ret = -EOPNOTSUPP;
> > I think that should be:
> > 	ret = ERR_PTR(-EOPNOTSUPP);
> 
> Read again :)

Oops, sorry about the noise.

Thanks,
Mostafa
> 
> static struct iommu_domain *
> arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
> 			   struct iommu_domain *parent,
> 			   const struct iommu_user_data *user_data)
> {
> 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> 	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> 				 IOMMU_HWPT_ALLOC_NEST_PARENT;
> 	struct arm_smmu_domain *smmu_domain;
> 	int ret;
>      ^^^^^^^^^^^^^^
> 
> err_free:
> 	kfree(smmu_domain);
> 	return ERR_PTR(ret);
>            ^^^^^^^^^^^^^^^^^^
> 
> Jason

