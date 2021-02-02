Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97FB30CB15
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbhBBTNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:13:05 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15738 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239364AbhBBTGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:06:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019a26f0001>; Tue, 02 Feb 2021 11:05:19 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 19:05:18 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 19:05:16 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 2 Feb 2021 19:05:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLGUnVenrw73goCyHmoXPywPNDS38Re8pxQlNPDzjU9FWaqYh6WsukKJeGykHGRCOEZ7ZSH0I1il/WLUZDFw2B+oVZdGPEajSvq9JRMPvEPoc94a7jAByj+kgJubVk4cSagY2fNDXN//AERMcwQ7GMmz8EVPxuPl3ADS3JKQCdlndsJgEpiP0Xk+6mC9Oym9IqM9+1Ww52/cyxGkXQa5RT7E9Fobboj4mW82Un3EaVSzwmzMXbRIdY5mpyrgztEj2rTiJSDI9O8D9G3k/pn7CsCYYsLWU3UAZ9NyXdeu0XpNOcHRwDgUQAgYMgXczScvckprbKhBEg5WFuDVAJjLUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh50z6j/5bak7EU1EFxjWNLIv/Ea3BFTxwAEUfb9alM=;
 b=mFEN/nAN7dvclalUVihEilHT8Zy/VFP0tDes2oilFJK3iJgdqLPy1iAkG0vFR9CoEBS47RRSBYRa9kz2IcKQAHoW3SDJ57J//5AeJn92unurpobSq7Bom5aZF6XXgBK1eeBaTAk+7JKtHX3EUa2jxZVwZhBFaEpCs0ESpd1Y6imVWeYNBUXgee+tgsza25UOsNEUywK7xg7s54j3h0pepAcaIi5WSnfnp5ttWAy2s/juvqsWICS063FYCABqmks4v3p49L6puGROOt25WnjDjF9+8SizFOkrq5Z9fBy0K5ZlSjS2ZxtiK7/igsAdfFlKgC9WG4zYzTlaWJTR5JEmAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3114.namprd12.prod.outlook.com (2603:10b6:5:11e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Tue, 2 Feb
 2021 19:05:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Tue, 2 Feb 2021
 19:05:13 +0000
Date:   Tue, 2 Feb 2021 15:05:11 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202190511.GA4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <20210202105455.5a358980@omen.home.shazbot.org>
 <20210202185017.GZ4247@nvidia.com> <20210202185518.GA3723843@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210202185518.GA3723843@infradead.org>
X-ClientProxiedBy: BLAPR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:208:329::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0076.namprd03.prod.outlook.com (2603:10b6:208:329::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Tue, 2 Feb 2021 19:05:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l70z9-002heh-TJ; Tue, 02 Feb 2021 15:05:11 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612292719; bh=Sh50z6j/5bak7EU1EFxjWNLIv/Ea3BFTxwAEUfb9alM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=f/Yn5NzN82eikdkzCEIMuXPhlSJlt/xCEApYgMoknjtQEbvWMWQlcwwgMu6XsvQjH
         oj+BDMmNcuTfmYR9tpZ1wSVJYvAYoqvx4KCyqRrGYHmHaszHaC1rlwzXM9oteYTbm6
         MiIP/K4lMQHE7Ll9y3DvT6IwQtzHurvhGowzyQlKoKMLqi6XQB9FeBnuks1gx9fyoy
         zMUcBJkTc6Myhv7fLo6t4ShcS/WE21T0W/xOV82CFw2p3hQx/ZCdbguspkqVclrMkp
         ZJoEf6HZAC7aHc33OzyzWDb5RSAYC9My9Rx2r2cvvFivyYTXtiNGr3Qkdw/UBeFJwL
         in0I67HGU/RrQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 06:55:18PM +0000, Christoph Hellwig wrote:
> On Tue, Feb 02, 2021 at 02:50:17PM -0400, Jason Gunthorpe wrote:
> > For uAPI compatability vfio_pci.ko would need some
> > request_module()/symbol_get() trick to pass control over to the device
> > specific module.
> 
> Err, don't go there.
> 
> Please do the DRIVER_EXPLICIT_BIND_ONLY thing first, which avoids the
> need for such hacks.

Ah, right good point, we don't need to avoid loading the nvlink.ko if
loading it is harmless.

Jason
