Return-Path: <kvm+bounces-3159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF80801384
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 20:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61EF5B212B1
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 19:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0142B4F20A;
	Fri,  1 Dec 2023 19:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IAsX0OPD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B36F2
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 11:20:29 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1fa22332ca1so420085fac.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 11:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701458428; x=1702063228; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I2OeVOQrD9mA7MkxNCDuZeDEn1PaLfVovbPcfbgEPHs=;
        b=IAsX0OPD4NJxDKjHZYaPeA1RaI7SRW99J/WrY8IFv5YTzgiTai7tQYa9AIxQSYm+Gn
         SQkGKtJELCPateOq6K3dVhgo6vURv6c2adEUDIi/jhsc7wiLKuKunKMSc2PnXt/r728X
         xJ6b3raUyCZfwoduFdSCsITm7gU/yL0rh1J1glQDI/dvDyTioaFuK4FSwpG8z4yJ1sJG
         lC/zDjw0D/qgqkjBn5Owu1kBQ1FDFwGigdpl7bA4bpLcF8PgIBt/AXci9z5NBsOmxe/L
         LuPNK4ddissh94BT6jAxPklYE1mE7vg0oDpbQS9tg0njOyEz9wuROCwrr9q9s3fQrwt/
         bsgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701458428; x=1702063228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2OeVOQrD9mA7MkxNCDuZeDEn1PaLfVovbPcfbgEPHs=;
        b=UIGB4oRKfuHocS4qP3XBgUaLEFmyHN3XYulzrxWDDvNrUaASukRq1+TfQgFHaixuz/
         JeC9komGAqnf33ePcZOZvuudn34HlzW9uK+EL/iTOQ3TS5/SToRWjSLYdaQni+lnxZ/M
         nw3yZkV90Q94dCg6ZWJAFPM/e2kn2YmVtJhkv/5Pm/NO8opWSY6awj8Gl50ubb++6Rih
         trnM4MJHC1/8XoQOeSWmqNV6cUzs0UXa/AIsyJcqKSkfB4ePEGiEoI5wPthVcMrARE0A
         lh4usCyh8/oXmRk/mjjvTvF2/EpYsAkigTVKCFjHkdhXil9+aAyFHI/SkTspDr9K26Vg
         tMIw==
X-Gm-Message-State: AOJu0Yzvh1MNToZZdvNxlk7j7CsfXcqWenDFOjAvq5+mOWMAbODXPFgd
	xo+PSyDryEZfHO/k1S4V/UNMHablFQNzkZl4LYs=
X-Google-Smtp-Source: AGHT+IEQWhwo+YQs87zSg16Es/DvsBvlD+J/VYbJsutxQ5RoA/cQ603E7sqNxOjxpSBkuubb9x+1Iw==
X-Received: by 2002:ac8:7f8c:0:b0:421:b323:bffe with SMTP id z12-20020ac87f8c000000b00421b323bffemr88819qtj.10.1701457750139;
        Fri, 01 Dec 2023 11:09:10 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id w2-20020ac87182000000b00423de58d3d8sm1731502qto.40.2023.12.01.11.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 11:09:09 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1r98sv-006Hqv-2W;
	Fri, 01 Dec 2023 15:09:09 -0400
Date: Fri, 1 Dec 2023 15:09:09 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/12] iommu: Merge iommu_fault_event and iopf_fault
Message-ID: <20231201190909.GD1489931@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-8-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115030226.16700-8-baolu.lu@linux.intel.com>

On Wed, Nov 15, 2023 at 11:02:21AM +0800, Lu Baolu wrote:
> The iommu_fault_event and iopf_fault data structures store the same
> information about an iopf fault. They are also used in the same way.
> Merge these two data structures into a single one to make the code
> more concise and easier to maintain.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  include/linux/iommu.h                       | 27 ++++++---------------
>  drivers/iommu/intel/iommu.h                 |  2 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  4 +--
>  drivers/iommu/intel/svm.c                   |  5 ++--
>  drivers/iommu/io-pgfault.c                  |  5 ----
>  drivers/iommu/iommu.c                       |  8 +++---
>  6 files changed, 17 insertions(+), 34 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

