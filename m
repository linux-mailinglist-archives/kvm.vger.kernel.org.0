Return-Path: <kvm+bounces-36413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBABEA1A8AD
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 18:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01F433A801C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BBE1741D2;
	Thu, 23 Jan 2025 17:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKBHi6Pe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D2D165F13
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 17:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737652267; cv=none; b=PTc+mbMJjp4hoEPEvZw1Yp+u0fqdqlXCmt814woNdC0RoCwzZs4+ovuzYMOYEyvM23jROQdz8pvjHQ7TLDnH/VK5llyScwlRwNUO9UJGN4Y1l1jD/vYWulu7gCjgV8CNqOTig6BD0UvZoL4mqCeZ+j9ghFay1ff5ei3q5SrH7/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737652267; c=relaxed/simple;
	bh=IElpbLrsOsHo9Fqp9+eo4+iSffumW7TRTtUYq1XiB5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0EAHz/fIJsH3I9pY5xo+WwK3AZR5RvQu/G6p1x7itHz2PPSejAHiP2FBZ7QZppa5MszlQG1WISHsL7BC2MFxWj4W03EbI2+7g4mAd0LHNU0t1GdhSCD7O04zlB4Gy/+eILzDgEH98pLJRyZKG46da+suNGvNwqzbprwSekVjOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QKBHi6Pe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737652264;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8fOKblc3FZS7ikfIHW19sV5gSa/Sm7uYNFXMWgCbP3w=;
	b=QKBHi6PeLK8D3XqhY7QixlJnpdwgl//o+qj6BFvQLZQxY22sUG2nvbQmO6FMPgJciMuiei
	3t9WHMr6Pkzj1tHbnEGZeaFVTRWh+xdwIvDwS/cL6QoQQrPoMLt0sITioBVDnvq7nGhV5O
	xWHBuRPWLpjPR0HjonSTnZB9QzJYjfU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-LtxRjnmONnO02fALdcRzbw-1; Thu, 23 Jan 2025 12:11:02 -0500
X-MC-Unique: LtxRjnmONnO02fALdcRzbw-1
X-Mimecast-MFC-AGG-ID: LtxRjnmONnO02fALdcRzbw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43623bf2a83so9493465e9.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 09:11:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737652261; x=1738257061;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8fOKblc3FZS7ikfIHW19sV5gSa/Sm7uYNFXMWgCbP3w=;
        b=KDkvQwlPAviNGrv4nK+vLpvR9j4WvVqnlYEa+u858PZ/XRKICn7PhwjDvqZOT4NQwf
         8EX3WMTG9zicTmaSRzaU/JXHKijdrizDWXEFRe0GVGebtqFB8p+OCrQrp9Q0H1b/Lqd0
         WLuYd7vbpYBCZFGC6K9OI2Gx4OqQWgf+5um1Nh2CI/DSvu+E0kA9SHkAPZjrz5rA58dz
         WczgqiwaUjG4NRj9cOIKlfAGyDWrD+Mlsjp7/667AMtZT5Oz8rxvv6WgyutaVibEzkFk
         4M3SYQEDBaLFozJhlGH1UlRTdg4qCj9cNdvwJbyJaOKRZL6o8oTgOunhJ8P+CfIc4JHX
         bjOA==
X-Forwarded-Encrypted: i=1; AJvYcCV0PKX7DrvwdGvxbk60z76lUzj9aZba615+S6Rz26qeESW7AMNNcxuzHbo2fThvAFjhghc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuAuO3I+gjOTDe9TRP+QyuYGJ9mnKfM68pX+FBCNi/dLVbXk7z
	VW28wk0YPY99yZE21nLBzCLJhoIOcIiVDnk+Z0RdmVye5aWGlZh2xOQp/pbv6w8rN+H5KKcqrPW
	Xy5z+bVA4847iRNlG48mPEeNrqDunQM0fA5keltx4SgU/XyrVKg==
X-Gm-Gg: ASbGncsuK87ihuA4BrrJlN0jE+nNKMwHvTE5j9SxfVeOyibKMHSxcZcDkrduhofAJJh
	lng0boSy++unSqISx37ooqlwW0+HlAczc/btqqCPCQPHRi8YFCuVlhwpBu3uWe+PF5mKE5osUZH
	9QvqO/L3GZ7FXNljXxFBr8frl3In1QT3yo3BrIIDWrGehcjpAhmMsYOe+l/28gzV9uoF/vuLc6Z
	o3XEFpC6WDGPHgE50UKWpr6SBQ9DziW8ILMNjEiJren2ahX/jZObWSbUA5dpmR6FhEb/Xn4Zp1B
	oV47uJOfLp7GYu8xnPLOmfy81Pa+smkmsQCg4e8aOQ==
X-Received: by 2002:a05:600c:c87:b0:434:ff30:a159 with SMTP id 5b1f17b1804b1-438912d54b1mr280615915e9.0.1737652261104;
        Thu, 23 Jan 2025 09:11:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEve2JNXs/aOVwoBIaoWNaT3prodhge18rjmwvoIe2mZAtYGf3exTDDbW8BsosdzSW8HiTIkw==
X-Received: by 2002:a05:600c:c87:b0:434:ff30:a159 with SMTP id 5b1f17b1804b1-438912d54b1mr280615385e9.0.1737652260533;
        Thu, 23 Jan 2025 09:11:00 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31d9a39sm67975795e9.31.2025.01.23.09.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 09:10:59 -0800 (PST)
Message-ID: <fa9b443d-e068-41bc-ad03-9f04818c72e0@redhat.com>
Date: Thu, 23 Jan 2025 18:10:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 02/13] genirq/msi: Rename
 iommu_dma_compose_msi_msg() to msi_msg_set_msi_addr()
Content-Language: en-US
To: Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
 robin.murphy@arm.com, jgg@nvidia.com, kevin.tian@intel.com,
 tglx@linutronix.de, maz@kernel.org, alex.williamson@redhat.com
Cc: joro@8bytes.org, shuah@kernel.org, reinette.chatre@intel.com,
 yebin10@huawei.com, apatel@ventanamicro.com,
 shivamurthy.shastri@linutronix.de, bhelgaas@google.com,
 anna-maria@linutronix.de, yury.norov@gmail.com, nipun.gupta@amd.com,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
 jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
 shameerali.kolothum.thodi@huawei.com, smostafa@google.com, ddutile@redhat.com
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <242034456c0bfcd7ecf75cb29d8e5c99db0675d6.1736550979.git.nicolinc@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <242034456c0bfcd7ecf75cb29d8e5c99db0675d6.1736550979.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




On 1/11/25 4:32 AM, Nicolin Chen wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
>
> The new function is used to take in a u64 MSI address and store it in the
> msi_msg. If the iommu has provided an alternative address then that is
> replaced instead.
>
> All callers have a tidy u64 already so this also consolidates the repeated
> low/high code into a small helper.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/msi.h               | 18 ++++++++----------
>  drivers/irqchip/irq-gic-v2m.c     |  5 +----
>  drivers/irqchip/irq-gic-v3-its.c  | 13 +++----------
>  drivers/irqchip/irq-gic-v3-mbi.c  | 12 ++++--------
>  drivers/irqchip/irq-ls-scfg-msi.c |  5 ++---
>  5 files changed, 18 insertions(+), 35 deletions(-)
>
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index d442b4a69d56..f6369748fc6e 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -296,13 +296,8 @@ static inline void msi_desc_set_iommu_msi_iova(struct msi_desc *desc,
>  #endif
>  }
>  
> -/**
> - * iommu_dma_compose_msi_msg() - Apply translation to an MSI message
> - * @desc: MSI descriptor prepared by iommu_dma_prepare_msi()
> - * @msg: MSI message containing target physical address
> - */
> -static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
> -					     struct msi_msg *msg)
> +static inline void msi_msg_set_msi_addr(struct msi_desc *desc,
> +					struct msi_msg *msg, u64 msi_addr)
nit: msi_msg_set_addr(ess) may be enough as the populated fields are
address_lo/hi
>  {
>  #ifdef CONFIG_IRQ_MSI_IOMMU
>  	if (desc->iommu_msi_page_shift) {
> @@ -310,11 +305,14 @@ static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
>  			       << desc->iommu_msi_page_shift;
>  
>  		msg->address_hi = upper_32_bits(msi_iova);
> -		msg->address_lo = lower_32_bits(msi_iova) |
> -				  (msg->address_lo &
> -				   ((1 << desc->iommu_msi_page_shift) - 1));
> +		msg->address_lo =
> +			lower_32_bits(msi_iova) |
> +			(msi_addr & ((1 << desc->iommu_msi_page_shift) - 1));
> +		return;
>  	}
>  #endif
> +	msg->address_hi = upper_32_bits(msi_addr);
> +	msg->address_lo = lower_32_bits(msi_addr);
>  }
>  
>  int msi_domain_insert_msi_desc(struct device *dev, unsigned int domid,
> diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
> index be35c5349986..6599c56873ad 100644
> --- a/drivers/irqchip/irq-gic-v2m.c
> +++ b/drivers/irqchip/irq-gic-v2m.c
> @@ -87,9 +87,6 @@ static void gicv2m_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  	struct v2m_data *v2m = irq_data_get_irq_chip_data(data);
>  	phys_addr_t addr = gicv2m_get_msi_addr(v2m, data->hwirq);
>  
> -	msg->address_hi = upper_32_bits(addr);
> -	msg->address_lo = lower_32_bits(addr);
> -
>  	if (v2m->flags & GICV2M_GRAVITON_ADDRESS_ONLY)
>  		msg->data = 0;
>  	else
> @@ -97,7 +94,7 @@ static void gicv2m_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  	if (v2m->flags & GICV2M_NEEDS_SPI_OFFSET)
>  		msg->data -= v2m->spi_offset;
>  
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(data), msg);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(data), msg, addr);
>  }
>  
>  static struct irq_chip gicv2m_irq_chip = {
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 92244cfa0464..8c3ab7b471ca 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1809,17 +1809,10 @@ static u64 its_irq_get_msi_base(struct its_device *its_dev)
>  static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
>  {
>  	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> -	struct its_node *its;
> -	u64 addr;
> -
> -	its = its_dev->its;
> -	addr = its->get_msi_base(its_dev);
> -
> -	msg->address_lo		= lower_32_bits(addr);
> -	msg->address_hi		= upper_32_bits(addr);
> -	msg->data		= its_get_event_id(d);
>  
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(d), msg);
> +	msg->data = its_get_event_id(d);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(d), msg,
> +			     its_dev->its->get_msi_base(its_dev));
>  }
>  
>  static int its_irq_set_irqchip_state(struct irq_data *d,
> diff --git a/drivers/irqchip/irq-gic-v3-mbi.c b/drivers/irqchip/irq-gic-v3-mbi.c
> index 3fe870f8ee17..513479da9ee3 100644
> --- a/drivers/irqchip/irq-gic-v3-mbi.c
> +++ b/drivers/irqchip/irq-gic-v3-mbi.c
> @@ -147,22 +147,18 @@ static const struct irq_domain_ops mbi_domain_ops = {
>  
>  static void mbi_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  {
> -	msg[0].address_hi = upper_32_bits(mbi_phys_base + GICD_SETSPI_NSR);
> -	msg[0].address_lo = lower_32_bits(mbi_phys_base + GICD_SETSPI_NSR);
>  	msg[0].data = data->parent_data->hwirq;
> -
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(data), msg);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(data), &msg[0],
> +			     mbi_phys_base + GICD_SETSPI_NSR);
>  }
>  
>  static void mbi_compose_mbi_msg(struct irq_data *data, struct msi_msg *msg)
>  {
>  	mbi_compose_msi_msg(data, msg);
>  
> -	msg[1].address_hi = upper_32_bits(mbi_phys_base + GICD_CLRSPI_NSR);
> -	msg[1].address_lo = lower_32_bits(mbi_phys_base + GICD_CLRSPI_NSR);
>  	msg[1].data = data->parent_data->hwirq;
> -
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(data), &msg[1]);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(data), &msg[1],
> +			     mbi_phys_base + GICD_CLRSPI_NSR);
>  }
>  
>  static bool mbi_init_dev_msi_info(struct device *dev, struct irq_domain *domain,
> diff --git a/drivers/irqchip/irq-ls-scfg-msi.c b/drivers/irqchip/irq-ls-scfg-msi.c
> index c0e1aafe468c..2ac6d89b4cb4 100644
> --- a/drivers/irqchip/irq-ls-scfg-msi.c
> +++ b/drivers/irqchip/irq-ls-scfg-msi.c
> @@ -87,8 +87,6 @@ static void ls_scfg_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
>  {
>  	struct ls_scfg_msi *msi_data = irq_data_get_irq_chip_data(data);
>  
> -	msg->address_hi = upper_32_bits(msi_data->msiir_addr);
> -	msg->address_lo = lower_32_bits(msi_data->msiir_addr);
>  	msg->data = data->hwirq;
>  
>  	if (msi_affinity_flag) {
> @@ -98,7 +96,8 @@ static void ls_scfg_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
>  		msg->data |= cpumask_first(mask);
>  	}
>  
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(data), msg);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(data), msg,
> +			     msi_data->msiir_addr);
>  }
>  
>  static int ls_scfg_msi_set_affinity(struct irq_data *irq_data,


