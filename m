Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3BB30C747
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbhBBRPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:15:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9200 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbhBBRMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 12:12:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601987ef0000>; Tue, 02 Feb 2021 09:12:15 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 17:12:14 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 17:10:25 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 2 Feb 2021 17:10:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKGLb0Ue5+bOQrhxcCsKm2uJWyHZeDTdKBeMZ9SzzS9778EkMrv0rtfUTuUP9TohpKTFAQWj4zreNpWD9oJ/oHWeWt7NWjfJ9uyg11cABImFfyGNX1FCCr4UfBFe3Z7IoXynO72SOvbiJwMoC4NrnznEng9Cr17D+q/TDAju8PJrCwSecf0sogng9Qo9JTHYMCuVuFRueDs7/nQsZF12+yc5YqhmBpW+L68fgrhUjdTPSAOuonqXDlWMH5O5Fxs+7OfDN1/Jok78bKJh1dhS3jhQhrpCXPEAvRaHRqLc9DgeIUm0CIPFnTbyfbZA0Irg0ZSQD7/7EytQCUFXYxE9Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RV+PH22++d/37dWTpKti2udE+plzKen6d1E2uRzMCgY=;
 b=XMLf6xmIDCKmEkEBefWphE3wGYwmV7izjjYI1daque/3t5RoMArNnW2ZrPuUpJC1z5p06iRiS40h/0IrI2Axza6Bi604lvZzWItpcYwpOcmubaZE/oTk1aXYE8whlA5Bmz58qucyMgoxZK/GV57mV+69XlTCOrwlC65MML0AiSSIUbErwcBL0Om4E7XmidDCDIfqG9rG/xS4GAy4/Cm5F4cM0FzTFuroklJq9S7FLoo+ANknz6OJ2LK8KwPPvC8BcXlPmCEH5JRzQbKz8FhBuXXkqOmNPeKG+ZhR6TWaHmcPm2oVNtc6Sce1RJY7OqGzD1u3YtOZG+4hdiEcWRM12w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4451.namprd12.prod.outlook.com (2603:10b6:5:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 17:10:23 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Tue, 2 Feb 2021
 17:10:23 +0000
Date:   Tue, 2 Feb 2021 13:10:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202171021.GW4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210202170659.1c62a9e8.cohuck@redhat.com>
X-ClientProxiedBy: BL1PR13CA0504.namprd13.prod.outlook.com
 (2603:10b6:208:2c7::29) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0504.namprd13.prod.outlook.com (2603:10b6:208:2c7::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.10 via Frontend Transport; Tue, 2 Feb 2021 17:10:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l6zC1-002cSN-5n; Tue, 02 Feb 2021 13:10:21 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612285935; bh=RV+PH22++d/37dWTpKti2udE+plzKen6d1E2uRzMCgY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=BT3etWhfLvDdGhhYnQBTmz9sR5V6LP2ywmMQ3Iy09N/3+wsvueGkKvu2IKR9ESqXk
         OKgH7jSLVaWx2obTRPpViol/XNS0Jc14QWExmQt9YHrUa6sosSCGrrsmOiNshoAQyY
         WjjyEeFst1zEdm+VrZvO3BG2/WWcDXJ7ZrpNgA8xJb6oN0rxar0O9fALXe8ZcWCX5F
         /vf/qSeDcv/X5xQFl8ICRqQvmp6AlFdTTWkVEfsme07+Nw6aw24tAtp6Y49DqOo8iE
         Z3nAuC9EmLjcSMDbXFitNWHKXzOIvDwaZfj0fu21b+yvvekSkK2jcHbx7TYvlQOqXd
         q9C1ni5pfwnPg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 05:06:59PM +0100, Cornelia Huck wrote:

> On the other side, we have the zdev support, which both requires s390
> and applies to any pci device on s390.

Is there a reason why CONFIG_VFIO_PCI_ZDEV exists? Why not just always
return the s390 specific data in VFIO_DEVICE_GET_INFO if running on
s390?

It would be like returning data from ACPI on other platforms.

It really seems like part of vfio-pci-core

Jason
