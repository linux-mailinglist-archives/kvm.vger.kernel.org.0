Return-Path: <kvm+bounces-4186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D91580EFD3
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 132B81F21626
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 15:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250937541F;
	Tue, 12 Dec 2023 15:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="FMl03O02"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318A2CA
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:14:49 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-67ac8e5566cso41293366d6.3
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1702394088; x=1702998888; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yf/vxoxAPU7AjoQT7h5u+3hNOV3CcW9wSJKxeUZD+0Q=;
        b=FMl03O02/1497tDPB0e5nBLBRNsm3HXi2heayTfAklnFBMDc57cv33+cTkj7p6u92W
         +m4dH2pTl6glzjTmx7ZwaehYO4vPbW6YPp5NLd6AhCJ3EwUji8582Vew7Ji3CnGUZjMf
         xPIPcgZHVz1Ja0Rnt6+G9m/9pqYFafbGLelVF1ecjGUq1/v8PIhQybD179byBmIkVdvY
         gA9/ZqRjArdVc9iB7uffEVm2CeQdPZsY4mXMmGifmun8o1KslZcPsiFsSc1E15qP2sUU
         faisXOEgIXd4lB2tIv6x5MwZANstTpw2tDE5IfKWdHpcjJjw7Ezlk+HYcB2xijrVE/Uq
         IzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702394088; x=1702998888;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yf/vxoxAPU7AjoQT7h5u+3hNOV3CcW9wSJKxeUZD+0Q=;
        b=JsZivA7xjfbJaw949RuouzW/eVI6cjUSs7jyqDNjvXtaM+qZN1GYto9zib/6XLRQxC
         FsKw2/T0P/xp78ANByaTuZllMS03O4LgqXIduAcGrMn1GYxlEbvSKfT/ax9zYRoUlT3y
         P1CXfKh60CN7HHtIjylgDL30gPfajKA05j8aDxjZT4HnTu5o776K5qdMDhMFFv/eZQoU
         Vyoo7kFYr551KH74TxLOA0SQ4y0teh6kc9mm5FWuh5NLdkl0sYyBn9xGA4n3wRbXtXzq
         KKbGUQaF+M9lWvXch96rSfFRNZTeXMMkIToFh74XKsOfFzJXtO8GZ7eJt2NSR489ImEl
         YmHg==
X-Gm-Message-State: AOJu0YwdM3WWsozHzgXKRPlJGNkZ1br/4qtiK2cqouXf7jEt5stxYOsq
	XTmyldJdcQx7WnTRRejMmjZhkgmBOSuTuEUtJj0=
X-Google-Smtp-Source: AGHT+IGO0U0gsQvPEQe12yrbRz8NbA/1wHR/0MK9Uqm+C0W3pgcHg4DAVW0sKOtW1Iga6sBwe4Qurg==
X-Received: by 2002:ad4:5146:0:b0:67e:ed9e:d217 with SMTP id g6-20020ad45146000000b0067eed9ed217mr730301qvq.24.1702394088317;
        Tue, 12 Dec 2023 07:14:48 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id n7-20020a0ce947000000b0067a53851126sm4267023qvo.98.2023.12.12.07.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 07:14:47 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rD4T9-00Ck0Y-AN;
	Tue, 12 Dec 2023 11:14:47 -0400
Date: Tue, 12 Dec 2023 11:14:47 -0400
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
Message-ID: <20231212151447.GC3013885@ziepe.ca>
References: <20231207064308.313316-1-baolu.lu@linux.intel.com>
 <20231207064308.313316-13-baolu.lu@linux.intel.com>
 <20231211152456.GB1489931@ziepe.ca>
 <416b6639-8904-4b31-973c-d5522e2731d8@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <416b6639-8904-4b31-973c-d5522e2731d8@linux.intel.com>

On Tue, Dec 12, 2023 at 01:17:47PM +0800, Baolu Lu wrote:
> On 12/11/23 11:24 PM, Jason Gunthorpe wrote:
> > Also iopf_queue_remove_device() is messed up - it returns an error
> > code but nothing ever does anything with it 🙁 Remove functions like
> > this should never fail.
> 
> Yes, agreed.
> 
> > 
> > Removal should be like I explained earlier:
> >   - Disable new PRI reception
> 
> This could be done by
> 
> 	rcu_assign_pointer(param->fault_param, NULL);
> 
> ?

Not without a synchronize_rcu

disable new PRI reception should be done by the driver - it should
turn off PRI generation in the IOMMU HW and flush any HW PRI queues.

> >   - Ack all outstanding PRQ to the device
> 
> All outstanding page requests are responded with
> IOMMU_PAGE_RESP_INVALID, indicating that device should not attempt any
> retry.

Yes

Jason

