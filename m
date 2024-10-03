Return-Path: <kvm+bounces-27845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC17A98F079
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 15:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6000C1F223D8
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 13:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960A919C55D;
	Thu,  3 Oct 2024 13:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="aC5Bd2/d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2F319B3ED
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 13:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727962407; cv=none; b=OMe3jUf9qYXKCjIKjbDXNuktjuwfhoOWFGAUCKAGWyp+gHJbtwL9Tme4mA9skYibHSNczF1FIuqTp8Ym2gL6EnKgARhRs1PLRO5rqCN0vAxfEMS37LkHImtLz+4dVB/49668YUOTwtZJ9wU1jCgys5q5rQu+ZSVTRQ+rutEn6PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727962407; c=relaxed/simple;
	bh=ru5EfHEC2xYx7sJrFNE6UgCz7R3Tdiv5uWDzLygWL3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBsuY3OCmBkCGaN2E3qwqFjN8mcVhc5TWLFBfug04fcWRn0/mh8Djt8jz9PJke3zo1pANUm3n/oJi3ltV5yar5T0NuogwIITURS6PoSnKlrvrI72tOJ8JSxbz/sLc4vugt5OMtDHUMdPi0jUrY65Tq6nCfSDpp9AMmFhSJbR17A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=aC5Bd2/d; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6cb22e9c6dbso6055856d6.1
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 06:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1727962405; x=1728567205; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8dQ/gk58hUlGStzLPNPz+tqcQ3+D0/hVEA8eHIyZCn0=;
        b=aC5Bd2/dhJf9fKs2BqfXGibi0Rb4Paggm5wxNHOi+8dgkaKZl3sYSoajE8lr7P57r5
         CZsVfdN+KptxetJ8VkdW4U6EhvcgPubogkttCVRdzmcDLFUnrmDZ3zgJhLslJOaZTxMT
         v437LvvpyTQTkG2QNdYV4ophc2M38YjG1kuufs1gHYh+Np/zRPG0rN1JCFu6bXBU52SH
         G9aaSliwRdB9v44X/TGeS1mR5Ok+3CRSKGk5tYJnaV3K0oqzBpo4+YdR2br98+J7+VUw
         SRwxiBmPdGZMWZmYAFrhRyCtiqQGE0IRLgQHKBPMTdNazzJ7r4ibjNBE/XV1xzfB4kjM
         4koQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727962405; x=1728567205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8dQ/gk58hUlGStzLPNPz+tqcQ3+D0/hVEA8eHIyZCn0=;
        b=pRIMYXnz7G9sw1W0ugG+eWn/Axi0zwNWV62SSGLSeMKgJu5qnrDw0wKIwEF22Obg5v
         x1YMteT1sL5hKh5UH8f70RUIcRy2ZqNKcaNyvtYN9o9fiwxE4/4GeyluZYOBOlrF/1Hk
         I9jGUnpvefW9pRXY8a1FqS4MsYVWcPojcmUQm8AV5pwvtkJ1Cw6DXym2s71z/J9WNFRG
         5BNEmmTBq2kdIqAl0oq7ahsxBB7cZQ3+BzgNupZdsq+Q/XvWm0ZbVGrJWNiCm3ArbKr1
         GqmrAp1Oo3AsKCefZS1W2fT2uI4sk8Smjhshs+3SV8drqaQf5uJXl2PTQSRJ9r6oxPvw
         8diQ==
X-Forwarded-Encrypted: i=1; AJvYcCWou9StCueBIkc5rmmM+4Spp9wY+8Z1zw+i3Kvmmspz3oxWZx9AiU/D7rqAEyr4E3Rp20c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKWKEm9v9vB1Lq0dT6r5oA8T5nVstlqAFkVJUFdBtNITROuDCD
	+Eaqq2HEa+D+943x2ZX/XSagRgMARwBBJ7HVl4DYDCTQL4xgy1q9ICnda+dD9EY=
X-Google-Smtp-Source: AGHT+IHs6HB9tlbYAhVev9UHmvUhD6mUcL6pLiiMeMpBirOjKBi5OGNhsG7hwNB7h9ua6MEKwvVLvw==
X-Received: by 2002:a05:6214:450c:b0:6cb:3644:7ee1 with SMTP id 6a1803df08f44-6cb81a1066emr94967236d6.28.1727962404750;
        Thu, 03 Oct 2024 06:33:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cb9359bad5sm6515846d6.5.2024.10.03.06.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 06:33:24 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1swLxL-00ASUf-OH;
	Thu, 03 Oct 2024 10:33:23 -0300
Date: Thu, 3 Oct 2024 10:33:23 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Gowans <jgowans@amazon.com>
Cc: linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
	iommu@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Alexander Graf <graf@amazon.de>, anthony.yznaga@oracle.com,
	steven.sistare@oracle.com, nh-open-source@amazon.com,
	"Saenz Julienne, Nicolas" <nsaenz@amazon.es>
Subject: Re: [RFC PATCH 11/13] iommu: Add callback to restore persisted
 iommu_domain
Message-ID: <20241003133323.GB2456194@ziepe.ca>
References: <20240916113102.710522-1-jgowans@amazon.com>
 <20240916113102.710522-12-jgowans@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916113102.710522-12-jgowans@amazon.com>

On Mon, Sep 16, 2024 at 01:31:00PM +0200, James Gowans wrote:
> diff --git a/drivers/iommu/iommufd/serialise.c b/drivers/iommu/iommufd/serialise.c
> index 9519969bd201..baac7d6150cb 100644
> --- a/drivers/iommu/iommufd/serialise.c
> +++ b/drivers/iommu/iommufd/serialise.c
> @@ -139,7 +139,14 @@ static int rehydrate_iommufd(char *iommufd_name)
>  		    area->node.last = *iova_start + *iova_len - 1;
>  		    interval_tree_insert(&area->node, &ioas->iopt.area_itree);
>  	    }
> -	    /* TODO: restore link from ioas to hwpt. */
> +	    /*
> +	     * Here we should do something to associate struct iommufd_device with the
> +	     * ictx, then get the iommu_ops via dev_iommu_ops(), and call the new
> +	     * .domain_restore callback to get the struct iommu_domain.
> +	     * Something like:
> +	     * hwpt->domain = ops->domain_restore(dev, persistent_id);
> +	     * Hand wavy - the details allude me at the moment...
> +	     */
>  	}

The core code should request a iommu_domain handle for the
pre-existing translation very early on, it should not leave the device
in some weird NULL domain state. I have been trying hard to eliminate
that.

The special domain would need to remain attached and some protocol
would be needed to carefully convey that past vfio to iommufd,
including inhibiting attaching a blocked domain in VFIO
startup. Including blocking FLRs from VFIO and rejecting attaches to
other non-VFIO drivers.

This is a twisty complicated path, it needs some solid definition of
what the lifecycle of this special domain is, and some sensible exits
if userspace isn't expecting/co-operating with the hand over, or it
crashes while doing this..

> @@ -576,6 +578,9 @@ struct iommu_ops {
>  	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
>  						 struct mm_struct *mm);
>  
> +	struct iommu_domain *(*domain_restore)(struct device *dev,
> +			unsigned long persistent_id);
> +

Why do we need an ID? There is only one persistent domain per device,
right?

This may need PASID, at least Intel requires the hypervisor to handle
PASID domains, and they would need to persist as well.

Jason

