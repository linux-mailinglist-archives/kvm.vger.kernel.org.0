Return-Path: <kvm+bounces-3590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E26805920
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 16:53:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9DBFB210A2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C2968EB8;
	Tue,  5 Dec 2023 15:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="omH/MVU0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8611C3
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 07:52:49 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-77f0756a097so91167585a.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 07:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701791568; x=1702396368; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BrWHWTFaRknhgdb4x9no/GQPxrAlB7YYcLeiCxHpSTA=;
        b=omH/MVU0AynBQig/jzB+n1U7MiiEU9Qv0lydXi7gyqffGCQQ9XcttjqfRtm9/JYZSd
         Le5LLNgha9NIpjxcE8+cJRYVKauuJ2WU9GqzjKPjHwl24Gs09m0gk7s1dJj/o9n9wk1x
         JgX3CFM0MCfsAPWlYPLsfaXEH3Ta5qtO7r+cUGO2jk5yke4lfaH0ANEOivsQ32N9HKh6
         DdcUCR0hMgIyg0o68aOJrFUWkB6wsxwE8bBrkF6BP7UclqxliUgDneLDC7G6lK3eGVLy
         6BSotzdqa8aHWyAMT7Cg6K/q5fJSd0EBjGeC5PF9GrdR3vRXOYWkLNjukGnpYPA2A4qD
         od5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701791568; x=1702396368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrWHWTFaRknhgdb4x9no/GQPxrAlB7YYcLeiCxHpSTA=;
        b=lL1yiB245Nez9/oVzR0vpxqWyrFU7pQxwyiAEtKeSczHx2WMOTu3uhDJMBPlUsAQjk
         9o79BAJshUSI/SpjeVds7nDw3XPisc45MKV+HDR59qkZ6m4iioUfzlgwFVQEBdpo38MC
         whYvqwrylxuzxlP4KZQuIXta0dXG+48F57ODuRV32IHCLNIcWzeTKlUKld8sHmfQbo2a
         ZSu3BkhjhVwIzcI+ZT/qUz8Z43LKsJ2Z82pd3OK+FDQRo4i+XIHBBJ0oYtAEbP/yFoOi
         jsYHGgBtH/ZM3A1+gHh2I1m3N4tQ0O4r4WTm/ZNZO/N2/vdDke2ZzG4mTaArSr1+CT/9
         6M9A==
X-Gm-Message-State: AOJu0YyxsumecQDkQNka63vZ2r/NXbHef+G+HWId0LqcRDr/4yv9YbpC
	JFtI/h4CoykLtLIztfW9FeWAvA==
X-Google-Smtp-Source: AGHT+IEWTjimK7HJTjtG4zURBrKJAMSWy2Q5Rd8yPZ4Mg4dhFMa48d0hohgGPIWQhH1eR0Unx2klsA==
X-Received: by 2002:a05:620a:e84:b0:77d:992f:857e with SMTP id w4-20020a05620a0e8400b0077d992f857emr1354994qkm.61.1701791568321;
        Tue, 05 Dec 2023 07:52:48 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id y18-20020a05620a44d200b0077da7a46b0fsm5189422qkp.69.2023.12.05.07.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 07:52:47 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rAXj4-00BiMh-Cl;
	Tue, 05 Dec 2023 11:52:46 -0400
Date: Tue, 5 Dec 2023 11:52:46 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Message-ID: <20231205155246.GR1489931@ziepe.ca>
References: <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
 <a0ef3a4f-88fc-40fe-9891-495d1b6b365b@linux.intel.com>
 <20231203141414.GJ1489931@ziepe.ca>
 <2354dd69-0179-4689-bc35-f4bf4ea5a886@linux.intel.com>
 <BN9PR11MB5276999D29A133F33C3C4FEA8C86A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231204132503.GL1489931@ziepe.ca>
 <BN9PR11MB5276908231BA164E4AF8806F8C85A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231205015306.GQ1489931@ziepe.ca>
 <BN9PR11MB527687FD2CD3EB17F04B22458C85A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527687FD2CD3EB17F04B22458C85A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Tue, Dec 05, 2023 at 03:23:05AM +0000, Tian, Kevin wrote:

> > I didn't said the PRI would fail, I said the ATS would fail with a
> > non-present.
> > 
> > It has to work this way or it is completely broken with respect to
> > existing races in the mm side. Agents must retry non-present ATS
> > answers until you get a present or a ATS failure.
> 
> My understanding of the sequence is like below:
> 
> <'D' for device, 'I' for IOMMU>
> 
>   (D) send a ATS translation request
>   (I) respond translation result
>   (D) If success then sends DMA to the target page
>       otherwise send a PRI request
>         (I) raise an IOMMU interrupt allowing sw to fix the translation
>         (I) generate a PRI response to device
>         (D) if success then jump to the first step to retry
>             otherwise abort the current request
> 
> If mm changes the mapping after a success PRI response, mmu notifier
> callback in iommu driver needs to wait for device tlb invalidation completion
> which the device will order properly with outstanding DMA requests using
> the old translation.
> 
> If you refer to the 'retry' after receiving a success PRI response, then yes.
> 
> but there is really no reason to retry upon a PRI response failure which
> indicates that the faulting address is not a valid one which OS would like
> to fix.

Right

> > Draining has to be ordered correctly with whatever the device is
> > doing. Drain needs to come after FLR, for instance. It needs to come
> > after a work queue reset, because drain doesn't make any sense unless
> > it is coupled with a DMA stop at the device.
> 
> Okay that makes sense. As Baolu and you already agreed let's separate
> this fix out of this series.
> 
> The minor interesting aspect is how to document this requirement
> clearly so drivers won't skip calling it when sva is enabled. 

All changes to translation inside kernel drivers should only be done
once the DMA is halted, otherwise things possibily become security
troubled.

We should document this clearly, it is already expected in common
cases like using the DMA API and when removing() drivers. It also
applies when the driver is manually changing a PASID.

The issue is not drain, it is that the HW is still doing DMA on the
PASID and the PASID may be assigned to a new process. This kernel
*must* prevent this directly and strongly.

If the device requires a drain to halt its DMA, then that is a device
specific sequence. Otherwise it should simply halt its DMA in whatever
device specific way it has.

> > Hacking a DMA stop by forcing a blocking translation is not logically
> > correct, with wrong ordering the device may see unexpected translation
> > failures which may trigger AERs or bad things..
> 
> where is such hack? though the current implementation of draining
> is not clean, it's put inside pasid-disable-sequence instead of forcing
> a blocking translation implicitly in iommu driver i.e. it's still the driver
> making decision for what translation to be used...

It is mis-understanding the purpose of drain.

In normal operating cases PRI just flows and the device will
eventually, naturally, reach a stable terminal case. We don't provide
any ordering guarentees across translation changes so PRI just follows
that design. If you change the translation with ongoing DMA then you
just don't know what order things will happen in.

The main purpose of drain is to keep the PRI protocol itself in sync
against events on the device side that cause it to forget about the
tags it has already issued. Eg a FLR should reset the tag record. If a
device then issues a new PRI with a tag that matches a tag that was
outstanding prior to FLR we can get a corruption.

So any drain sequence should start with the device halting new
PRIs. We flush all PRI tags from the system completely, and then the
device may resume issuing new PRIs.

When the device resets it's tag labels is a property of the device.

Notice none of this has anything to do with change of
translation. Change of translation, or flush of ATC, does not
invalidate the tags.

A secondary case is to help devices halt their DMA when they cannot do
this on their own.

Jason

