Return-Path: <kvm+bounces-3339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB048034DE
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 362F31F2124C
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 13:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DEE2576C;
	Mon,  4 Dec 2023 13:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IFfed4nR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188EF271D
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 05:27:35 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-77efc30eee3so36350585a.1
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 05:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701696454; x=1702301254; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D9LwUnJIABIYXynmRpnw8pFA/pix8HVAwnnjKzJe6go=;
        b=IFfed4nRNRW34bnfJg0K5t+m7Qs/6Ibys9PBnRhbntxFz1p70fTUj9Sdz7E2p89/GH
         5ZnUmfpVDqcjJc8TVh29Zo8hnUMidkibRGpcbqM05hHTYkFMXk8BNhvVG9LW4wTYz1rU
         FNcILSfSOzss+x55aKQykriC9tM3LEs37qV5Xom4E409/PyCK0mXt8ZltCslONcG9CXw
         hYRq7Qwb8mqslU1Ss9XDxU6PZESOmTAyH1LDpkqIaWrWDXxHQU3E92EJo3AIU2rQQsBP
         JmGmIQOWbVNmywxyHBZU1jo2mcMyLWkdhYvxRB5NMegtb1IpSaEZafkLIPy+vMFMqge0
         QjEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701696454; x=1702301254;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9LwUnJIABIYXynmRpnw8pFA/pix8HVAwnnjKzJe6go=;
        b=m+WHYCeLD1NZ6Vr0S+pqs8YbsSSrfRTl7GDhOgm9mF8GsfmVveo2vPkWOTiS5aQX4P
         6+iKVOWvUq6PygXh7iWfLi6UuFGjMrDXFsOm96HzLT2ugzBwqQYEf0UWkUm6Lja+ZERw
         g4THq9ypWuRcZc8it4BfD4yAhfWfNmOs0/D6Xptbmjun+yD7XilbsYv/kU+3Ki/PEiVR
         U9xzswJ49O/aJ7zulNH9Nqk/Ra3WDOCLzkkSCOkS7GARCElKWeIffq+lFLcp5JADqpxB
         nHrnpdv4+WNU+RXlpvUSX9iMCQ3bSZdHSqRsQgVH9JErs7LiMStJMcnVZHJUZfJdmayL
         uaeQ==
X-Gm-Message-State: AOJu0Yz7+lGHfbXkXtrKLNuFLzCOWlODszlHulW+l/Q/JP55RgCgTOMA
	DxO/NX56X0nTj6iARe95QDuDFg==
X-Google-Smtp-Source: AGHT+IFwJd+mm5yr9E/Hib/UfERIuq8yXaFwHF06npvbzKqM7QtB126feDLE1ZVHpqSCvPB5b1ED4w==
X-Received: by 2002:a05:620a:1913:b0:77e:fba3:a787 with SMTP id bj19-20020a05620a191300b0077efba3a787mr2055508qkb.101.1701696454008;
        Mon, 04 Dec 2023 05:27:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id l15-20020ae9f00f000000b0077da8c0936asm4239213qkg.107.2023.12.04.05.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:27:33 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rA8yz-00AsTP-01;
	Mon, 04 Dec 2023 09:27:33 -0400
Date: Mon, 4 Dec 2023 09:27:32 -0400
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
Message-ID: <20231204132732.GM1489931@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
 <93a57e63-352c-407c-ac3f-4b91c11d925d@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93a57e63-352c-407c-ac3f-4b91c11d925d@linux.intel.com>

On Mon, Dec 04, 2023 at 11:46:30AM +0800, Baolu Lu wrote:
> On 12/2/23 4:35 AM, Jason Gunthorpe wrote:

> I am wondering whether we can take patch 1/12 ~ 10/12 of this series as
> a first step, a refactoring effort to support delivering iopf to
> userspace? I will follow up with one or multiple series to add the
> optimizations.

I think that is reasonable, though I would change the earlier patch to
use RCU to obtain the fault data.

Jason

