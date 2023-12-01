Return-Path: <kvm+bounces-3134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D78B800EBD
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07EADB21366
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F0C74AF9B;
	Fri,  1 Dec 2023 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ng68X9q7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC581A6
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 07:42:32 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-77d67000b69so117522185a.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 07:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701445352; x=1702050152; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M5OluPhgDT3nAw0/mpsAOoQF2zqQkql7YLDt75eO1Ow=;
        b=Ng68X9q7uWhzgH8+vw3hnH3jIliA7sQWGau9BEHHVvKFw8t2vgwgzG3WLzdAlwV2h6
         r2aQ/QZJci+VkwE1NXHabaeoIyQq17Naxj1N5Ox7DErwIW15zJ/lmofMIt2gXeKrDWfT
         IzCykAfijXnBy+WVZxuIqdkJwpDPuqtYEJVktxqLcVvrKoW0ceLsPBlEHhs6mUMKum9y
         +uwMJxtD/icDgF7fI6zZbGhGqBX0uLqhrl9hJsdeIhSTUNeAUM1cwncfMmxZdvqq+sao
         BR4jkbxt/EQjZFm5d1Kv28TUr2STeNCCmVb0IGNMBkdzHofnvAEA44OuVY7DzFIgsR/c
         gsvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701445352; x=1702050152;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5OluPhgDT3nAw0/mpsAOoQF2zqQkql7YLDt75eO1Ow=;
        b=ozVhnyYTzZYWJ8zOm3phhSZberSITb5Jhz6vkpegg5dd1BIEqW1IbOZkWsjKm9SSxI
         tqBoORUydH3Ku2kPdRYjkv4jfY8+RGqWGKurIcKPNc6p+xUnHHF+nQ+QgPSP9KbU1Z3t
         GXRVFQsGXifi3dv59XbyBdAXvylTuf66JzHEsV/TMRuvFD6fOHtyc+Xa4V2LdxtT22rk
         f3mXttpze+lZn4FZxVPYmPjpP9dG0dSK1qgOynk2mXZS4i2sKa07cwUCcY2w3PwOCw30
         SJ3GkCR9Cr2p+UUN35Bo7Bk0Z7gDy/9Vvy2Jlb4CSf7CHhcREpSsGqK3K77p3fczw5Gz
         Wf/A==
X-Gm-Message-State: AOJu0YzQwZSFOB3GEBUuMwvbdJBtwZo8vcP5WjraE7XXtb0tPlwAigO7
	9sEGocXEAy4lMl95eHzvu5y+hQ==
X-Google-Smtp-Source: AGHT+IGJqqOzBXgm1gG3l4eq+iJtvvsWrjEeRODObVtVODE5xSIuIkhfCOaHdl0inwKoRnlUy4vC5Q==
X-Received: by 2002:a05:620a:4092:b0:77b:9bf1:6526 with SMTP id f18-20020a05620a409200b0077b9bf16526mr29808153qko.44.1701445351820;
        Fri, 01 Dec 2023 07:42:31 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id 11-20020a05620a048b00b0076e1e2d6496sm1584171qkr.104.2023.12.01.07.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:42:31 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1r95ew-006GSJ-Ja;
	Fri, 01 Dec 2023 11:42:30 -0400
Date: Fri, 1 Dec 2023 11:42:30 -0400
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
Subject: Re: [PATCH v7 02/12] iommu/arm-smmu-v3: Remove unrecoverable faults
 reporting
Message-ID: <20231201154230.GC1489931@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-3-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115030226.16700-3-baolu.lu@linux.intel.com>

On Wed, Nov 15, 2023 at 11:02:16AM +0800, Lu Baolu wrote:
> No device driver registers fault handler to handle the reported
> unrecoveraable faults. Remove it to avoid dead code.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 46 ++++++---------------
>  1 file changed, 13 insertions(+), 33 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

If we do bring this back it will be in some form where the opaque
driver event information is delivered to userspace to forward to the
VM.

Jason

