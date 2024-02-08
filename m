Return-Path: <kvm+bounces-8323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F0C84DC7F
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 10:12:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA685B239CC
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 09:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3135F6BFBB;
	Thu,  8 Feb 2024 09:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n59bghUE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52639339BF
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 09:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707383479; cv=none; b=Uylw0iQWotRN9dRKxI6pRkUey/g9w1ZsdhLYWLyRR6GI6obd9b6K6MPgDE7kdTLpMX9kHFI0oB/zhwssw7DByzBEj0Bu1q1W6In4+LWLw1bAiMeuLPLv/rvQNi56Ek5Hqq0ry1Rf28dvPggUQlWunml4jHd02ekh4FGcGYiwR98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707383479; c=relaxed/simple;
	bh=p7M5LRY2IIR3JbhYpi12gul04UVDehtCNBndvFQhT4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EQ3L9V2W938+hlCW39cYraDDIaHUr+Z0O9RvrQkrucmUg2AtDaczWLLaca0MD11BQ1f1oEGxhevFPheDR24ekcu/5hQp/4xxbUs13vZHaO7IUEfz5Dq8D+B7aXOIHJHJsvXptGbaPxdE1OdlT+cotzYpgtal6egZUAlFg6zSkfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n59bghUE; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-511616b73ddso2743937e87.0
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 01:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707383475; x=1707988275; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o6hMNIZUaBRVM7gi8uDMiowpTMxtF27cC2fdkjBJWH8=;
        b=n59bghUEZpcupbyWHTOfn5fjBy3lHpyanCd3+vpbeNeQygNyJzf9U8bchu+ymVMBH2
         ZiUZappNAzxSGHH+j1QJVV0jz8Jrw3v0dEZ45dRaIbjFO3FAU364yjybdpblnOhU/5kE
         PsyNirQDRDYX25xf7uABvAVnw9DroPZ2kARfGAoH8uov7LZOTafBYSzpcewav9N+fBBR
         fPzYrZQ+a3EzMjbFr7Rh2lpFU9jOxqXSJ1e0B8AJH3ZEfRX2WXdClLtb7PsGxFL2eFW5
         9wQZpIdTG5U87HUq5uNLTjPxvQR58YV7QeekO9VOlba+GUQd40AiHTolEf+Gpd9wa/Zk
         kPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707383475; x=1707988275;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o6hMNIZUaBRVM7gi8uDMiowpTMxtF27cC2fdkjBJWH8=;
        b=DmZ7a1Zog9EzJVp1+Ci1z9b9ieLuBnRyGFdXFWZ4QtUPoylyUZBuWft85FRCNrZePw
         tE5BujVTrUeoEVT0IpNSRNQb1+xh7NzTCB5EsSZPK9yEuj9qvjGXUEBFYYCDDj6U5wgn
         JtBWmTYrPlE9Oz8QFeJo23oshoz6HeYVRYa4Kl8/Ws5LxwZ8+NxU7a4RQ2SxUoRY+y5t
         HCUUMbx5DdvpCfunEUt+YMfDkKy/kid8WNs3bCCzPovY3rTzaYVsapqn1ocNCdnECS/L
         8H0hes6flb0YM0148F5sb/Gg6hVmNINNPvlV6yLvdVkfm1dJ7Lf0GLVzZ/tTtaOBFJ+/
         jKJA==
X-Forwarded-Encrypted: i=1; AJvYcCWe2XeFFMcBaPZU5gZnKn3iQCd9rGBbRyXM3mt8rw2PbCCoiHawq3Bwh9plX8SxWxH6rhRPPZomahzjUfPqxwPj/AZN
X-Gm-Message-State: AOJu0Yy3YoQ5A/i/eq0NFULRoqbziJl7f72Bs75jx3kkrX1bVsN2Ysjt
	fQ/Lqyffn4k2ANRRjCZZfSU+8QReDhiVlgiscmDLXbdL5grNl2Ra8pANqU880evm+LKjSTqiuX/
	1RZ/B6E19y34jNK7dLXefKnBGooNaETuFY7xBvQ==
X-Google-Smtp-Source: AGHT+IEdMMmX0qUysZ36JNG6vjjPDWbDnwCkmT8i09RQZO80h9rQ9AXsc+CoHbdB4Czk7n8tQfMWuFQWC0VHbAenhUk=
X-Received: by 2002:ac2:4107:0:b0:511:6d76:4a6 with SMTP id
 b7-20020ac24107000000b005116d7604a6mr980330lfi.49.1707383475362; Thu, 08 Feb
 2024 01:11:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207013325.95182-1-baolu.lu@linux.intel.com>
In-Reply-To: <20240207013325.95182-1-baolu.lu@linux.intel.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 8 Feb 2024 17:11:04 +0800
Message-ID: <CABQgh9G_KCNjj4TvKzG04cQVPsWn2OCSEd_vK10fBtJtWX4E0Q@mail.gmail.com>
Subject: Re: [PATCH v12 00/16] iommu: Prepare to deliver page faults to user space
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, 
	Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Joel Granados <j.granados@samsung.com>, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Feb 2024 at 09:39, Lu Baolu <baolu.lu@linux.intel.com> wrote:
>
> When a user-managed page table is attached to an IOMMU, it is necessary
> to deliver IO page faults to user space so that they can be handled
> appropriately. One use case for this is nested translation, which is
> currently being discussed in the mailing list.
>
> I have posted a RFC series [1] that describes the implementation of
> delivering page faults to user space through IOMMUFD. This series has
> received several comments on the IOMMU refactoring, which I am trying to
> address in this series.
>
> The major refactoring includes:
>
> - [PATCH 01 ~ 04] Move include/uapi/linux/iommu.h to
>   include/linux/iommu.h. Remove the unrecoverable fault data definition.
> - [PATCH 05 ~ 06] Remove iommu_[un]register_device_fault_handler().
> - [PATCH 07 ~ 10] Separate SVA and IOPF. Make IOPF a generic page fault
>   handling framework.
> - [PATCH 11 ~ 16] Improve iopf framework.
>
> This is also available at github [2].
>
> [1] https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/
> [2] https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v12
>

Wandering are these patches dropped now,

[PATCH v2 2/6] iommufd: Add iommu page fault uapi data
https://lore.kernel.org/lkml/20231026024930.382898-3-baolu.lu@linux.intel.com/raw

[PATCH v2 4/6] iommufd: Deliver fault messages to user space
https://lore.kernel.org/lkml/20231026024930.382898-5-baolu.lu@linux.intel.com/

And does iouring still be used in user space?

Thanks

