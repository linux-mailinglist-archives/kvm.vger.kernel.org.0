Return-Path: <kvm+bounces-64418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74145C820CA
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D22393ADC9A
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03E7317712;
	Mon, 24 Nov 2025 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="hmipOWQw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038542BE7A1
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 18:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764008125; cv=none; b=KAkYqgvjYMYOo/y8eJufY85c8clevluKleyiGTt0ewdhNxYSI49IeBmcNBoneRrRHfX7DmkfSnD/Tfu8EL9K/CstmHR4mxSIVNCSiQOouJP+Pqh4lqw9WZEzaTLt5B3Hnm85utRRcnyi5khPk1yKwGlgo/s3W3xOdfdfVDu34EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764008125; c=relaxed/simple;
	bh=oaO9+ksMmAmFh8G3d/UWZR17wgRENiWkTx5pMqdCZ/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dVcHI5//UT+xOwJF7Zz1wbD8V0rssUuWRa20LwGyyqWo5LFzOJRSmOYotSO3KoqgLjkz9Yy/13KKIXL+xULvGXLc+fUAaQA50AHkrlFPjvx1C1BouI1D8V/d/gApy32AA/nnOI0OULlAnKTqNuAPzrIqrE/1AlBpY9O2VCGgKBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=hmipOWQw; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2dcdde65bso682742185a.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 10:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1764008123; x=1764612923; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XAHO0RxAUU9BHjlHal7mcB9U9OIjPdFjUpW/PKR/KN4=;
        b=hmipOWQwwy+PGTCJJiKj+ngmq6blH/4QSn6Vu6Tg1jKfel9Vq2lNw4WEYwDgaL65ns
         TCfLu1EMnWe7OfUAFQAYwJzvSD4pKWz5jJoa4ek+nf4NIBjWju5gAbayU134tBtIIDmE
         KyXKtgTqbpNO48qi5Ekvj116WMwdXViNjMzJhoWbRJQoFjr8arIgvl2AAtQFfvfrRAK4
         weQCDUqmN208FhB3SKQ1t7GDJCDsJUvZ3fwb5uwBBQz8f3VeL5izqgdtLGbz623VBvsX
         vfGb9gA0JW2osUYMwokP7iC9t48b+qKZWPYq2EdLH6XPmddjuD9sSwgZqDchZMiSmVeT
         cR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764008123; x=1764612923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHO0RxAUU9BHjlHal7mcB9U9OIjPdFjUpW/PKR/KN4=;
        b=RKtMkK8ANV7/cQ3RWd+goA0RLnA1K6viYZC1tlJlGJfqk0HZRNiKyn77zMzpafcBH6
         n3dlGFIC7B0ln4anq3oaQsgikCRbyZZ1crQx5G4Ad+n5ZL9YRR/sgrVpy/E5RCAjg+0u
         TZ92qoVk3exAnLs63md4sF7m9ndumnivF2FNjC25uolO3ncXUpBXSMV9HNNuNuLOYjbB
         QHUA7ztfRNFyZM3lHHOvh8flrfy57CX25wIzXJ/mHDSgKO/uqyhW5OKaU/NYRLSuQnDY
         EPWF9eJl8kJYU0sgfmAF+7suqN82mzkFqdMKWkwJcESOEsACilE6ynRAFdLIqU6ifIWl
         2qAA==
X-Forwarded-Encrypted: i=1; AJvYcCXsQKRFSBIlNzmihnw+z6aflv2kDHIqMq8LXQdvFVT5sMCerP7cFNmX1W2l48qHgaZHUsY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfPax6/tbIQV4fWReq8jZl6QzxuHZsSpwPMT9o2mEdeBp5y4fi
	Zy9dkZjIQzxvqWwdEwUikFSm8osAhlaimAnD+j6IPWCIYoUnct/eizOB5Dih0IauDjo=
X-Gm-Gg: ASbGncshjUTP4HXafSxHBGhvgWhlyE6IotvMuXxrlqWCkqDGrjlRyLc5t0AqYJaW/IK
	QeR+7+oOcfAYOeR8X7MO5Vbqs9Bu590L9XBYxovkdjX8gpogZP9Ht1uoQHfslazJ5E9x9DxOCYg
	f++mxpsNY9bGd3Uto0YNNjMSL0h2IHjzleVnInwIi1dNj2+PPXaUNxWzOpIm6TpU/Yr9b6G0B2a
	zME5nVjsl8HYH2fvtythnMBuGemJxci+xGmBIBJtj9uOvtyBEnhfM6YtFQgV9ryZTd4VjAA4di5
	u4HSnV1qFRwsrdRQnDk/0sXqYJg1Kknacye2liOe2W/8VDb6zA+2cinlc2WYiHfA4ZpJFt13z4a
	+QCNpBgXhTqgyBAYp+cSWO2LZwie/68dAOf4kooY44ZIzfLoZm4RV0t/NTqR1iJ3SoFycLEwhR9
	tisuPnOy6PBhFZUyTGh0L9z0FE0aXBhf6oNFD+DJl6g+Qs6HWoe1iGiaPA
X-Google-Smtp-Source: AGHT+IGEDEsDVHu0ai07iEFLkFyQqkbEzzKRecphdpKKSUM3yi9cRx3p6uQMP7udunSiJx1xq9RjJw==
X-Received: by 2002:a05:620a:c50:b0:8b2:e598:e319 with SMTP id af79cd13be357-8b33d4b4ea8mr1713953485a.49.1764008122703;
        Mon, 24 Nov 2025 10:15:22 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3295c3306sm999887985a.31.2025.11.24.10.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 10:15:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vNb5t-00000001xAo-2h5U;
	Mon, 24 Nov 2025 14:15:21 -0400
Date: Mon, 24 Nov 2025 14:15:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: ankita@nvidia.com
Cc: yishaih@nvidia.com, skolothumtho@nvidia.com, kevin.tian@intel.com,
	alex@shazbot.org, aniketa@nvidia.com, vsethi@nvidia.com,
	mochs@nvidia.com, Yunxiang.Li@amd.com, yi.l.liu@intel.com,
	zhangdongdong@eswincomputing.com, avihaih@nvidia.com,
	bhelgaas@google.com, peterx@redhat.com, pstanner@redhat.com,
	apopple@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiw@nvidia.com, danw@nvidia.com,
	dnigam@nvidia.com, kjaju@nvidia.com
Subject: Re: [PATCH v5 3/7] vfio/nvgrace-gpu: Add support for huge pfnmap
Message-ID: <20251124181521.GV233636@ziepe.ca>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124115926.119027-4-ankita@nvidia.com>

On Mon, Nov 24, 2025 at 11:59:22AM +0000, ankita@nvidia.com wrote:
> +static size_t nvgrace_gpu_aligned_devmem_size(size_t memlength)
> +{
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +	return ALIGN(memlength, PMD_SIZE);
> +#endif
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +	return ALIGN(memlength, PUD_SIZE);
> +#endif
> +	return memlength;
> +}

This needs a comment why it is OK to change the size up? Seems really
surprising (and wrong!). The commit message should explain it too.

Jason

