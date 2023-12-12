Return-Path: <kvm+bounces-4189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C41ED80EFEF
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:19:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FBA2281C0A
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 15:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D7175433;
	Tue, 12 Dec 2023 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="EhSgBEPX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4698FF2
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:18:51 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-77f380d8f6aso342907085a.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1702394330; x=1702999130; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1J0E2muSgNl3hAqEUv0GBJG6tt73IDHG5CgFbhTFcMw=;
        b=EhSgBEPXUEmUfrqxO2ccPwp8Q7ITnt4Movuvomz99HzoJsC7z1jk1gAosktoqh2qns
         81Hg+XMslyR/+gJ61sxx8Q451lItJDfF3Os1DHM8TGKOFkXmLye6k93bFLWwmu3a58Da
         R4H20bS+qHAkWXx/SP43rq4lA1cuSnR40DZfoZ5kGEx6/uY2tm7M8UEx/TrVdhY/2DCP
         ZzNMom1MtTnYG7ow9VONdRCDAICkG+cWKa6y4SgCVU8hzrYga50M+79iOTGwBmacrbJ9
         hbg7XBhNz+nXaire2bWzxXfoRhTHuTCR2yADV8M8x9Fkc644DbPdoUpEX39T92kDdWKV
         K5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702394330; x=1702999130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1J0E2muSgNl3hAqEUv0GBJG6tt73IDHG5CgFbhTFcMw=;
        b=bdmmVBaSw8pBG+DKEbCXWcQSnqhEdaGEnEqH7XfAo4AHv73JYFmRFiC447i3r//+mw
         qoai0s8yCc1janlEmKkFOQinlyhqdBqy5YuDDfXqMzwWE0YPhcmhez60t1+JpgxMf7bH
         1e6PIjSeVSNY5zqDFkfcF8tNrFTgSo/z4UMss4PvCAi9JgwIn4LL03VLqiNnjiH5kziR
         NG0aABFBrwUWjLjEi3Y/s1F+XWxDP1OytHG/Lp5Md/FsVyT4cb7uK93vna8fntYwA45S
         FzT/8NrVZfV3UbKpmvt8yEqFQDet49TyB/GAR4ZlpG+qe+ZhcDRxiuTwejq8uXmPuZxN
         gsKA==
X-Gm-Message-State: AOJu0Yx08awcnPBcw8U+z9Qkh00BmxI/WNPExspDlbiYUPERNm7aZmI4
	UqVr1/KqVJoSKchbwWrAkP1mtw==
X-Google-Smtp-Source: AGHT+IFq3Ckq2KVmneMTzmQ2mKKjd0RAxPdbXcCdtNxUscr3KZI+A2xNjS/BTczw0TiEfU7gwIenjQ==
X-Received: by 2002:a05:620a:27c9:b0:77e:fba3:9d05 with SMTP id i9-20020a05620a27c900b0077efba39d05mr7703626qkp.105.1702394330403;
        Tue, 12 Dec 2023 07:18:50 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id w5-20020a05620a148500b0077d65ef6ca9sm3745656qkj.136.2023.12.12.07.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 07:18:50 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rD4X3-00Ck2z-Fd;
	Tue, 12 Dec 2023 11:18:49 -0400
Date: Tue, 12 Dec 2023 11:18:49 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 12/12] iommu: Use refcount for fault data access
Message-ID: <20231212151849.GE3013885@ziepe.ca>
References: <20231207064308.313316-1-baolu.lu@linux.intel.com>
 <20231207064308.313316-13-baolu.lu@linux.intel.com>
 <20231211151235.GA1489931@ziepe.ca>
 <62131360-e270-4ea5-92cb-8dd790be8779@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62131360-e270-4ea5-92cb-8dd790be8779@linux.intel.com>

On Tue, Dec 12, 2023 at 11:44:14AM +0800, Baolu Lu wrote:
> > @@ -210,7 +211,8 @@ struct iommu_domain {
> >   	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
> >   	struct iommu_domain_geometry geometry;
> >   	struct iommu_dma_cookie *iova_cookie;
> > -	int (*iopf_handler)(struct iopf_group *group);
> > +	int (*iopf_handler)(struct iommu_fault_param *fault_param,
> > +			    struct iopf_group *group);
> 
> How about folding fault_param into iopf_group?
> 
> iopf_group is the central data around a iopf handling. The iopf_group
> holds the reference count of the device's fault parameter structure
> throughout its entire lifecycle.

Yeah, I think that is the right thing to do

Jason

