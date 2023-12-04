Return-Path: <kvm+bounces-3337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0474C803416
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B32E4281031
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 13:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 991FC24B30;
	Mon,  4 Dec 2023 13:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="aJjsobrC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8AADF
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 05:12:13 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id 006d021491bc7-58d54612d9cso2957610eaf.1
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 05:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701695532; x=1702300332; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7RWsKxXhxAMEDfXPpZR35TsYFyeNBhVQ2t6NvxM6Pec=;
        b=aJjsobrC4xLthF60nykm5M+H1I0/mqY2kQShWN/a+M5HbS/Z3fT6bB/TJQISmTi5zK
         GIHD5hIlWUw5ZwAIYKNpBXbq5qWb9JU/8cRyc23hqavr5D71t74NPpeCBKHJ7D2JyyZe
         ZpE8dmq6rVmDQjy7qCPrbqFNNgmXTZ7g98InqFexzeU0PfMQPjOvEGSgrqvFgQDe8z8p
         xJAqFS2OogpZINvaI3a1x49sCL1vT1mJDPhQfyua4wSfN/9dRDrsqT69XuZqhx0UvOGN
         +z56kOjo44eP0eRaXZUDZJu6NwnJisdJ1hT2FimB0CpbLips1hzYS+rFhFA9QtIBxdBw
         4MXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701695532; x=1702300332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RWsKxXhxAMEDfXPpZR35TsYFyeNBhVQ2t6NvxM6Pec=;
        b=xTENb3aKRYtN4kZyMlrn8XKMbwpsN1/jYT9VjY9xyBZd1TSd+R+6BvNYhU6Ww/cfVk
         koFiheyH4qMAtXsIbgfxVlVIhPVWG+Ptl/mJ+XGqLTB53uihX/T95+44r2ogSBpSBgo7
         LN8TMpp7DQqSFXHRO9tEH5gD9FH9nUiX+pT+pegN6cn+UEO6inocQqIBPP1/Orl8SNfY
         ezuSTpsc0VYXX1MMPBXzgtK0Gm5WF0R4CCJhDeCGYbsNkvZkTwd3gER8P6zqbjU8e+m4
         XjpZE1QQ9+cVTvBYPSqjOZ3aHu+mm+s/ahmW0aAloUjk7aiBd8jwyVdo1sanMMPt9EA4
         l4Uw==
X-Gm-Message-State: AOJu0YxJmFwosaqW3nI9ayhPwUt0AT5GRQVsRlG+JTLV+7BAkL+culak
	5z93xSAcM3xBg+0KX2b8FprzKQ==
X-Google-Smtp-Source: AGHT+IGoQOzPPQKNgLswcbzAqC7rBuTYY1wEC/9v3DXJqgA/wrMtqAvrBw+cZGFjMr3uAfVfX68LDg==
X-Received: by 2002:a05:6358:299:b0:170:2f86:392e with SMTP id w25-20020a056358029900b001702f86392emr1553337rwj.60.1701695532580;
        Mon, 04 Dec 2023 05:12:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id z21-20020ae9c115000000b0077d8ad77069sm4248899qki.26.2023.12.04.05.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:12:12 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rA8k7-00ArNK-HA;
	Mon, 04 Dec 2023 09:12:11 -0400
Date: Mon, 4 Dec 2023 09:12:11 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Message-ID: <20231204131211.GK1489931@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
 <a0ef3a4f-88fc-40fe-9891-495d1b6b365b@linux.intel.com>
 <20231203141414.GJ1489931@ziepe.ca>
 <2354dd69-0179-4689-bc35-f4bf4ea5a886@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2354dd69-0179-4689-bc35-f4bf4ea5a886@linux.intel.com>

On Mon, Dec 04, 2023 at 09:32:37AM +0800, Baolu Lu wrote:

> > 
> > I know that is why it does, but it doesn't explain at all why.
> > 
> > > 1. Clears the pasid translation entry. Thus, all subsequent DMA
> > >     transactions (translation requests, translated requests or page
> > >     requests) targeting the iommu domain will be blocked.
> > > 
> > > 2. Waits until all pending page requests for the device's PASID have
> > >     been reported to upper layers via the iommu_report_device_fault().
> > >     However, this does not guarantee that all page requests have been
> > >     responded.
> > > 
> > > 3. Free all partial page requests for this pasid since the page request
> > >     response is only needed for a complete request group. There's no
> > >     action required for the page requests which are not last of a request
> > >     group.
> > 
> > But we expect the last to come eventually since everything should be
> > grouped properly, so why bother doing this?
> > 
> > Indeed if 2 worked, how is this even possible to have partials?
> 
> Step 1 clears the pasid table entry, hence all subsequent page requests
> are blocked (hardware auto-respond the request but not put it in the
> queue).

OK, that part makes sense, but it should be clearly documented that is
why this stuff is going on with the partial list. 

"We have to clear the parial list as the new domain may not generate a
SW visible LAST. If it does generate a SW visible last then we simply
incompletely fault it and restart the device which will fix things on
retry"

> > Requests simply have to continue to be acked, it doesn't matter if
> > they are acked against the wrong domain because the device will simply
> > re-issue them..
> 
> Ah! I start to get your point now.
> 
> Even a page fault response is postponed to a new address space, which
> possibly be another address space or hardware blocking state, the
> hardware just retries.
> 
> As long as we flushes all caches (IOTLB and device TLB) during switching,
> the mappings of the old domain won't leak. So it's safe to keep page
> requests there.
> 
> Do I get you correctly?

Yes

It seems much simpler to me than trying to make this synchronous and
it is compatible with hitless replace of a PASID.

The lifetime and locking rules are also far more understandable

Jason

