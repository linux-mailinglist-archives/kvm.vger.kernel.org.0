Return-Path: <kvm+bounces-43657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9826A93723
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 14:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CDB63A9EE6
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40FF2749F2;
	Fri, 18 Apr 2025 12:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AG4qW+0i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B6126B2D0;
	Fri, 18 Apr 2025 12:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744979555; cv=none; b=AoC0fHXvX00gmKPTOyrt8LJEbOOtl74nDgr1v2MYCyfi5HLkaLEsP/cQHbJYpzh5THJeE4SN6QwYHuvlTiSpCxrQTl1sG8kAlmiW7o03X3EzTiKIKjL8U3KUrXTsYXxYnfFmzAHWQmHaB5M7i1rWmZCcewXbs/IyI4l5XuuDP0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744979555; c=relaxed/simple;
	bh=fi1DbYhlrqF0U7IzqDP/M+/r8vdH95UNS8kWonbjyGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KIoZhD7Ffg+M/xPJWapzig5LnZlDBmnFwb1A28LzfMaVvQ6WzJsT4ZgDCzZKJCmHEW608XXt0z+40IDuqLLiJIxTdy2AtkTdrYWrK/z1Va8WIBp5RTOaeTugf9+H5DebNpKS6ecAxkEaWqygH7IElXDPE+WemuVbi0I6XqGBb04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AG4qW+0i; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-736a72220edso1749800b3a.3;
        Fri, 18 Apr 2025 05:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744979554; x=1745584354; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4uxNqOBD/ogCW1O0rrQ2A0HcfFujRPCySOpF/YO01oA=;
        b=AG4qW+0iMjdDMp9h8+u/8MODMx2ZhRnrNeqNWksxxmnvYLNp1sN4cPNqgxJBWkQHHw
         6ja9kaz4Q5fz4VjSFoqmUKZeGQbCa5MpqyumvCPwfXpggT9WqPVXrihSm6janzBMx1CX
         QahHls910enJIkb/u6kPH7kZ9EqesycJDcnqFE0q+OOiA3HMPiOVjVeakoi/lbPr4Cjd
         OH3ErFFt9pia9G3CJL80MeQHQRPI40Y0lC78IBPn165jnjxBbcTiPNLFYjPB6FrNnIQQ
         OZEpshOMLzwQFEUo4i4UG9KzJMrFW9AIXX/IL3hoMw5zYNyxzSTxDyk9XU+zwlcGeNY3
         2rNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744979554; x=1745584354;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4uxNqOBD/ogCW1O0rrQ2A0HcfFujRPCySOpF/YO01oA=;
        b=vRmpnqsDdwES8Ved1XXA5WUyZ10QGRrfzKC7wL3blLScA8gKL5v/MChN//vVrA58JX
         PjzAE4lZkddCOZn7MnP3IOQ2LYM/gYYp7Ht06SJCdFHCqweGYynyQ5LcPVk3+LqNBEGI
         nfVOhDuuv635V/J2tVPFk2JgChEeufkmiafBUro3mG948rWOeWmzVipinSCsOmOaQXU5
         v8oZ/7P6l3zq4qLXCYRGN06eJp/5AV19PIs4V5ksGZOohlP1xEVY934cbAlRz/oKDS5t
         fGR7AbxWu9NwDyxLeqga8HbNv3RZ3K9OYBGaksOWM47Mxgf6MD/RvHko6vsJ8cYLNaEy
         6CzQ==
X-Forwarded-Encrypted: i=1; AJvYcCU20zLeXPB6GHQ2HsaK94sCZjgarLZMO/rUlfvYKDUbvUXJhMceLe2uGCrH1Rrb5m1146TokGcTkJ8vxtQ=@vger.kernel.org, AJvYcCWTnfrUz8cv0ZcTGkQumsnERYk9lbIbL4WUP/5Dr6x49QCDiwTyAEFZ2i+aQBTsGnKTcB/RTnkd+Ht5DA==@vger.kernel.org, AJvYcCWdV06fK+ZAcwDMQvkyDhOH3GBiXD9UptK+gwwd9kbw3U+jFwcnfhckNRfVvzmH4Fj94KY=@vger.kernel.org, AJvYcCWu25HxhOwetbOX2cRRICTSRLul3OhmhQfq8b+6qSBpGOzodaY4rCV6B62MQHS8a9oK3jkn0ZoW1Oqd@vger.kernel.org, AJvYcCXUgGTrkNaeV1NRXsKeQuskAw/PFFcRNiB7ojigcp9xA8oHm9qxjNedjcZBfg1EGI9WeyoFxcVe2af8swZL@vger.kernel.org, AJvYcCXZYDcsUiaWnvJKYozdMCulF7X59X7RJV2i4AUqdK4JEV4vGK2c+4o5AzgJHt4cuqSs6vqZ0XaJ9xEQ@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwe1rsioiPYtQHWizUlzgI4WF5R0IfOLDoO16JpxiBcx/gR2gE
	+0tqo2v6GT1CgKTiv1QV8DkQ+fAE5beAuCg8uMfoO5sxpdUuM35UQ4MMXjaWZk0B1PFyeXG8SvN
	tgEost9lgnBY6YGHrFMONnhDQJ4w=
X-Gm-Gg: ASbGnctUBpR+gUSetI7U5hzaGXrS3uz79DnUr/DNOUwx3Bf5/joR9nuD2B4BvIjq1Rs
	O5BCvJUlt9JUUp0K3EF9UlJJFcV7bWGvhPZqT7c0ocqvWAzcfl+KiD4ryHSx318uij79oWZjx+7
	0c2dFb/ojfP3WnyGglLH6TOtwjh+nMA/px9LL7b6Ro/glkvc6LB+zYPzaC
X-Google-Smtp-Source: AGHT+IE6KPLtDnTScFEtJJlvCdwmMFGgLV6Sh+PZ7MHmYiMb3jtvP1cSpc1ynbu9LO+7GJYkCunnvOZCbjH4BPDTV0s=
X-Received: by 2002:a17:90b:2e03:b0:2fc:c262:ef4b with SMTP id
 98e67ed59e1d1-3087bb6f117mr4849982a91.18.1744979553652; Fri, 18 Apr 2025
 05:32:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1744825142.git.leon@kernel.org> <670389227a033bd5b7c5aa55191aac9943244028.1744825142.git.leon@kernel.org>
 <1284adf3-7e93-4530-9921-408c5eaeb337@kernel.org>
In-Reply-To: <1284adf3-7e93-4530-9921-408c5eaeb337@kernel.org>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Fri, 18 Apr 2025 18:02:08 +0530
X-Gm-Features: ATxdqUGyYBEsfK-IN2nZn9q0XDVh1xSRZINsNgbIk6fSYXOiPXAs6WAhmbL1EUw
Message-ID: <CA+1E3r+9kEs-fqND-VD+y6FWfiGqr1vN8M0GufD3oHdwLdFcrQ@mail.gmail.com>
Subject: Re: [PATCH v8 24/24] nvme-pci: optimize single-segment handling
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Kanchan Joshi <joshi.k@samsung.com>, Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>, Robin Murphy <robin.murphy@arm.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
	Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org, 
	Niklas Schnelle <schnelle@linux.ibm.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Dan Williams <dan.j.williams@intel.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Leon Romanovsky <leonro@nvidia.com>, vishak.g@samsung.com
Content-Type: text/plain; charset="UTF-8"

> > +     if (nr_segments == 1 && (iod->flags & IOD_SINGLE_SEGMENT)) {
>
> nvme_pci_setup_prps() calls nvme_try_setup_prp_simple() which sets
> IOD_SINGLE_SEGMENT if and only if the req has a single phys segment. So why do
> you need to count the segments again here ? Looking at the flag only should be
> enough, no ?

Yes, the flag will be enough.
I started with nr_segments first, but felt the need of a flag when I
reached to handle the unmap part.

This can be changed if the series requires an iteration.
Or I can do this as part of the cleanup which I anyway need to do to
replace the "iod->aborted" field with a flag.

-- 
Kanchan

