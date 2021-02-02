Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F202030CD3F
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 21:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhBBUpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 15:45:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16926 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbhBBUpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 15:45:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019b9b90000>; Tue, 02 Feb 2021 12:44:41 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 20:44:39 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 20:44:37 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 2 Feb 2021 20:44:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsdecvKRqThP450ljVO7YwhTvBzEg2hy5hYbYGw1Fib5LQSlnFVL1WFzMOBR81TL11RKjp76shx8aDmMx0bmTbD4aK+/FO35W6NliA8L6JxnPVNYUy2zMZeqyKUbDCaShvIgLHyZtP3HxdqicvpC85AY4jK3I2+2kRG7QVDgoPaNnlPOcuAL0e3kVgbEGHFMS52sNcEXKYwriqZJV+ugrhFp/pukFzDDpyvGiQ9WESJGHyoAks57ympwWA/M95GMl/Yc+Q4BccvFUJ1xMzhmCQuilHVwgwkjcrnREQR8D8ySRnSOecjIcGqa4JBKJHfhPQlOs2K4Did11f66KUEcAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOQRACzq9RM+7ec/Ovq6IaqY6eedpCrqd5zerWgGhxY=;
 b=SVFhgEt+k1oEwHgJSmzddPVhvDdQ6nIzA6o2UJ24urMqfLQqf9ApfanHJ1jr/3kf4wSwbn0Nd4ERhWSTiyA1VlL0a+fAsRP/weVWeDVYa7yNLvdGemyFsTZI8waWO2ZOeY/smo4ZREH8B+3Lf/jw6Ppc8Dza4s/9YVfUqD/9srg02gviJWEkdHPA9vFdJQS0daV3Wzf45RGmnmy65b56W/pPA9/kTIu8icNDXm6daO3PPixK+vpbP4w7z0SbrdsEoB3zuj139h50aX6qhK2/popX3k936LiKoBjAk5BgAa715hdGlXioNwU0faOtK/H3y4IvgvtdBG8JQrv+420ciA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1339.namprd12.prod.outlook.com (2603:10b6:3:70::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Tue, 2 Feb
 2021 20:44:34 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Tue, 2 Feb 2021
 20:44:34 +0000
Date:   Tue, 2 Feb 2021 16:44:32 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202204432.GC4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <20210202105455.5a358980@omen.home.shazbot.org>
 <20210202185017.GZ4247@nvidia.com>
 <20210202123723.6cc018b8@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210202123723.6cc018b8@omen.home.shazbot.org>
X-ClientProxiedBy: MN2PR19CA0045.namprd19.prod.outlook.com
 (2603:10b6:208:19b::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR19CA0045.namprd19.prod.outlook.com (2603:10b6:208:19b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Tue, 2 Feb 2021 20:44:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l72XI-002jxP-AE; Tue, 02 Feb 2021 16:44:32 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612298681; bh=WOQRACzq9RM+7ec/Ovq6IaqY6eedpCrqd5zerWgGhxY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=ARmreLUE3EUqnxMTEv4NF9uVmziCsFJXtzoAms3by17nODKmXrG0NF3YytJSkU9Xf
         FHZQnvHzMMk/utfDcyPrpLlSmVKcZJUMhg2Q8ey6RnPnutoBSaZm/5WweP+PU6igtE
         mJsK1xCqi7eUTdH55wcja4wF6Jd2bl9YvLeKrCPqZbMAV+Jf5lglx0mwGyzSazR3yT
         ceT7dr+FVKqvCfKwnl1GuuIK6F8/yNtSrc8CLJrVziXAP+XbElmtw8ykKK2nNwzlFM
         b+ScB3rSS0znQlTDcLqTpaWxWys9jaFbdTBD7jKr5zV/FcVxDplmuGjQ3MhP3W5t5A
         lF6YlWTjZBf5w==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 12:37:23PM -0700, Alex Williamson wrote:

> For the most part, this explicit bind interface is redundant to
> driver_override, which already avoids the duplicate ID issue.  

No, the point here is to have the ID tables in the PCI drivers because
they fundamentally only work with their supported IDs. The normal
driver core ID tables are a replacement for all the hardwired if's in
vfio_pci.

driver_override completely disables all the ID checking, it seems only
useful for vfio_pci which works with everything. It should not be used
with something like nvlink_vfio_pci.ko that needs ID checking.

Yes, this DRIVER_EXPLICIT_BIND_ONLY idea somewhat replaces
driver_override because we could set the PCI any match on vfio_pci and
manage the driver binding explicitly instead.

> A driver id table doesn't really help for binding the device,
> ultimately even if a device is in the id table it might fail to
> probe due to the missing platform support that each of these igd and
> nvlink drivers expose,

What happens depends on what makes sense for the driver, some missing
optional support could continue without it, or it could fail.

IGD and nvlink can trivially go onwards and work if they don't find
the platform support.

Or they might want to fail, I think the mlx5 and probably nvlink
drivers should fail as they are intended to be coupled with userspace
that expects to use their extended features.

In those cases failing is a feature because it prevents the whole
system from going into an unexpected state.

Jason
