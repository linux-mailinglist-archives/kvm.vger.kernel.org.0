Return-Path: <kvm+bounces-63548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20EE5C6A08D
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 15:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id E0D502CCA5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 14:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A951B35E545;
	Tue, 18 Nov 2025 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="B/WGySyv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB37A1A08A3
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763476208; cv=none; b=XwJyO1O7H5rzxepjKsffWskkwkVAnryefmuYWkqotQSm5sK3rnqyy/b5WP1YsYRrGebmiUHuuSgbBV8lmk9Of5IPJGRVZ3uK3OevPXfTmjwT1kCPjd91vlohlWi+j5Txoer9C3j+QOjD9qE9yJNoIq+LubO6X13w8cRnoLCALYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763476208; c=relaxed/simple;
	bh=Vzm9kAK03gjq3/EFXB7Lf/qLfrswTurpUBT72P7Q9wQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b9b7qx6IZdZONdAUCJJ2DHH1LmDDEtJI9NhWDLF0tOUVfHCc+8oDJqjWxz78/yXTwHdB25+gXQxdtf58Dhm5qZ7dKC4eC4rFQfE3SsauUuca64KsY+HusH+84hPufWRLyS0woFAoCIrDqbRTm8Pd2PDuzPSnqz1EqoQZTbISb+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=B/WGySyv; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b1e54aefc5so469861085a.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 06:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763476205; x=1764081005; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gAj/lhLwXUkQIe838UyunLw5D1V/iLtJCJGMnOEEnt8=;
        b=B/WGySyvLaU8JIymArDTv5WHkDz63O8yjgtHNuDkhXoWlTVVEPwduRMKJRIl0VF0pt
         8TX3wC2CbRl78X8YvI6a76RvnNUvSap8sF82eEalnIXUMlSH6IQZ2lf/EfXMaqK3D0ge
         X5WIamr7y8ESnWfA/FuSzY5Ur6gzM7VRfSLkcWXG5ZJT1jx/WSECD5qqvvLR/jW4FtK5
         lXAqbLAS2gBp1REviCoz1CfM4ZfT1CkwTYXQnaa+Q+f0AhzEUqD9RCYPP7bMY70mYbIq
         d0nSRxqUw+WlBG8E/FBiGUk4abSaitO3o2hlCXsKqA/G/VWD92vKkCqNV5klizdv4fJN
         4ByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763476205; x=1764081005;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gAj/lhLwXUkQIe838UyunLw5D1V/iLtJCJGMnOEEnt8=;
        b=IxM+/Dfsw07Amf7dZxVl1q7cpaHbMITdT0r1S8jmxF86P/f7/4iBA7FpSvmNrVjQJG
         ldwtql59Sa2lGBLKOa95cT9wkoc3g+ncv4HXZkSVgjwfj9omIpHnV2IaU+xXqbKPqPOI
         rzTVbv2TFhU+pjmd/1IpaDp++HHk2viMBO9HkI7fl9IjTEuLpL0/iXfHHVIlUFGoX9ka
         Zrdinir5dVgL74FHsod/rme0sKUL2qlu4C8sXeQVbd9VxZxOJAWz8xlAI914IOyhPD72
         wn3FOyd/ZE86JaP1NnNCUL2lkS7+R1zyz6jJ+kW4c0TiDtrFAFns9rGgtAxCvqq6m+pG
         C+aA==
X-Forwarded-Encrypted: i=1; AJvYcCU1WSv+NSlmsRPMUGfAaqbv0W7D6pvqw2AUtA5KTYEY1CaBp1UyWcG1yYHtQZaPuQnngIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFbL8yd88L7vll1qJxwoMFj4WRDQqF6/Yr3b0V5zy9LvKszlBB
	zJp2tV3sUkpHaDm5p3AwiDWFzVUc1MMfJS6lYHGK8h9sjcnTmLLVs8aQuRaF3YHV1qU=
X-Gm-Gg: ASbGncsmPWv8A7zOglFUuUfqlAILp2ALru5FuEGbjYIU9xPNRP5r7ApMsszGZwZ1JHA
	w9JlA18OE8QKeU2gpqG1vrKefVFrvCmy/n0LG22Ip4pLf59Lk1svP1YVMmskKPTLWFrsdytfjqn
	o1y6X87z3NCjtrxtniITifn+3gTU8BEpxueGzMuhu4NwwwhnTwGuvg23dRrC2CHEymE36IEyzDQ
	hR1vuwZeQ5M1PQTeOI3fFUFnhnOzPHWn0Lb9doAHk515+E4UL5VAtjUemxYzOGRc/MzEwc1gPUo
	JQxJCxBSAhFrqievlzH/r8CG6S51kvvD2p8eGsd/aRbSkjAL30EcjI5OxyiPqqjsjyfyuY+AEiv
	uyHJBWeiU2seuRhVTPjsmHkpnFWYEXyZKfXsjvyJAi5qX0ZEJGE6RvNuDYlQcf4sT1Z4Rzuf5LL
	bf8YMC3at8PRbDxJCrw47BrcltaiUclGqMevIV9q2GH04JRTdrIZ8TX7NBy+Uah7EbVKU=
X-Google-Smtp-Source: AGHT+IGl2QxjkDkgi5jKGR6lwtLy9hLDUjSd3xhjzd2vh/OGWRtCENW0fUVdt2sQ45uUuO7DIyidjQ==
X-Received: by 2002:a05:622a:4a15:b0:4ed:df82:ca30 with SMTP id d75a77b69052e-4edfc875136mr206770331cf.13.1763476204719;
        Tue, 18 Nov 2025 06:30:04 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-882862d0944sm115395396d6.9.2025.11.18.06.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 06:30:04 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLMiZ-00000000NFZ-1yj6;
	Tue, 18 Nov 2025 10:30:03 -0400
Date: Tue, 18 Nov 2025 10:30:03 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v8 11/11] vfio/nvgrace: Support get_dmabuf_phys
Message-ID: <20251118143003.GH17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-11-fd9aa5df478f@nvidia.com>
 <SA1PR12MB7199A8A0D17CDC980F819CC6B0D6A@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR12MB7199A8A0D17CDC980F819CC6B0D6A@SA1PR12MB7199.namprd12.prod.outlook.com>

On Tue, Nov 18, 2025 at 07:59:20AM +0000, Ankit Agrawal wrote:
> +       if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
> +               /*
> +                * The P2P properties of the non-BAR memory is the same as the
> +                * BAR memory, so just use the provider for index 0. Someday
> +                * when CXL gets P2P support we could create CXLish providers
> +                * for the non-BAR memory.
> +                */
> +               mem_region = &nvdev->resmem;
> +       } else if (region_index == USEMEM_REGION_INDEX) {
> +               /*
> +                * This is actually cachable memory and isn't treated as P2P in
> +                * the chip. For now we have no way to push cachable memory
> +                * through everything and the Grace HW doesn't care what caching
> +                * attribute is programmed into the SMMU. So use BAR 0.
> +                */
> +               mem_region = &nvdev->usemem;
> +       }
> +
> 
> Can we replace this with nvgrace_gpu_memregion()?

Yes, looks like

But we need to preserve the comments above as well somehow.

Jason

