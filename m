Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2207126AC6B
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 20:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgIOSpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 14:45:38 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:61551 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbgIOSpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 14:45:19 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f610bbb0000>; Wed, 16 Sep 2020 02:45:15 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 11:45:15 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Tue, 15 Sep 2020 11:45:15 -0700
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 18:45:14 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 15 Sep 2020 18:45:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+bRsbeEiaG49hWG6mPxIYOmuhOoftEsK2RkcnJmdbAMGQszKDbXK9S84QWxtXTGKzD+StNwLce9hwDigSQ8+GPQvwaEViYGjCTRCaKU/1y42/KHrl8iiow2zxdB8JTFLhgJ1SlEznDVkWobuimQCD/D776sgGif+xie+DCDS+lR2t9zyPoIzc6I4RAm+oqjsQPjETgP+G0IiONK4rBd9Q1nTpFjWMnx84PFKO/4SRe9V5EtzO2PwozsnmRVGV+mQOABUeORoYqnAppHSZyKemR+jHzpktFq3LGZoUPW43flMUV6Ph5MYEsfsa36KOTrea36G4M5lSPaljdSqgXpRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOShLfDdFsw7ASY3FUm6bgWGb+iYiu2VydKUJtp4LwA=;
 b=Ld8XUEes//SRVlgwK5Ml4eZ78dXZ7KBI9HCfQt0N/CujexpG2SAebHf2v728+NSPlGdKTjZe9WCbni2Bif65C4uE+pV+XCgljvwFlpWT8Uk28uwLXYsksL/+LgwsxOQ6rgkv1ZWXmn9cFyWKVxbohY9nyrMeQrV9xV4Ssoj9P4nm/305fKZr5H8UrFG4lr2ZayC2fnw7QrRFKsS3uQgC5Zbjnig4SNq+EiKfRPVn3mi5yBl56G+srGg3w85G2ZJHO9IuBILNS9ruUNxh35lNBwchHDXO/sep63u/cM2QAeR8c6O7dMyXuAG8YJ+3+8oVOhhvWf+5xqV0p+YJqOdw0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4810.namprd12.prod.outlook.com (2603:10b6:5:1f7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.18; Tue, 15 Sep
 2020 18:45:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 18:45:12 +0000
Date:   Tue, 15 Sep 2020 15:45:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jacob.jun.pan@linux.intel.com>,
        <jun.j.tian@intel.com>, <yi.y.sun@intel.com>, <peterx@redhat.com>,
        <hao.wu@intel.com>, <stefanha@gmail.com>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jacon Jun Pan <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200915184510.GB1573713@nvidia.com>
References: <20200914134738.GX904879@nvidia.com>
 <20200914162247.GA63399@otc-nc-03> <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home> <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home> <20200914190057.GM904879@nvidia.com>
 <20200914224438.GA65940@otc-nc-03> <20200915113341.GW904879@nvidia.com>
 <20200915181154.GA70770@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200915181154.GA70770@otc-nc-03>
X-ClientProxiedBy: YQXPR0101CA0039.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:14::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YQXPR0101CA0039.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:14::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 15 Sep 2020 18:45:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIFx0-006eZK-4F; Tue, 15 Sep 2020 15:45:10 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49b61ce9-aa3b-4f90-d3c5-08d859a77a39
X-MS-TrafficTypeDiagnostic: DM6PR12MB4810:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4810D0CD0B94FAC15A8FEAA7C2200@DM6PR12MB4810.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hxrTCjpt29m752ex/ErFzVRPD8/8xz9JeZXicYWRb7M0rRrVtm7LJFxjaLOy+zVE6g30X2GuBU0A4uHvtf7nZlx+E9XN5PCsx2txuu6x/hUPGzpmGuuPE6Ll3U13hQmL6ApUFvV8Yu46gnyNNG119833ajAfGqJCvu76m/K6pFWq+nwIK3xMuuo+Ams8cgXsie1dMH8KkjQGMT17A+zHTJuadMB8u+hcdT4LhFzR/JdabG8M+kF8ijOa1aGBQp26QEKcGLwOYbC4x2nZ9Kmi+jsyT/xWRGPvKeBWogErqIFOOMJ+Vi36FZ1RyXWlA5Nc3RCzdrAJYQNDMYKCKTG1fQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(7416002)(1076003)(478600001)(83380400001)(6916009)(2616005)(9786002)(9746002)(2906002)(54906003)(36756003)(86362001)(66946007)(8676002)(4326008)(5660300002)(316002)(26005)(186003)(66556008)(66476007)(33656002)(426003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0qTy7sJk/nflPU40je/H3Vs7aYGmAGZ1x+dIB+/+nPAsvHuRM/sRD2CoJ9O2g7d1cu7EVq6tbCXtRazpEWFqu1YA6SC71wj6xnsA7OrtfdkUzsJr3WdI31fitUODVVE68Ag7SmvlilGYeIRl0H+lEDZP4B21lgFVSvfo6HU5JxqcW+AbfR/szEQOQUPev478vRS2x5631m1N4MrSUSvvYelRCYPabExKYYKnqbpffa7XW59IwSkZ2VO+2PD21e+/rky+p34FHmxhNttHXPW5bhlEgNA90nLJzj6bFpXGIuFb8D450AWcrSpQQoNNRAf5YDvHuueq8pYlZ7Fuk6IgqPbb4YJbiC2/TgW5EbESEhL+/+u13Hvm1URD2jpHIwmZhjEBo95QLMzAvrGm7p/TZLVSPKwfrEz0NG2/kXxSFdx1ormCVlS3PlWKialQBeqBWEF2buyyzV7Hk6YJ4SjRgPeM5kLvfCPW3sr8wGkRD0t7AFuWhb4fibo5H2El7BSWTbUM1jj5n9WeRkZDXUMXkituSsfoLGqPGeyHp+wg6Tp2TS5NTlElPwVG3yGyY7AzOePDeuPVB1dumlYQ1qnc62tGjZILUrDlVu8/g5K7zyPZb4a1EQYdc7PZm4MZ6rLCHp74tGhBZRVmPbjiONigGw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b61ce9-aa3b-4f90-d3c5-08d859a77a39
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 18:45:12.1473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EG1GZAaOIKGpJd5a6BNU8icKkSAs0VBgr52SaPytQ+F2sP87nZzrkvkpcABh5cvq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4810
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600195515; bh=VOShLfDdFsw7ASY3FUm6bgWGb+iYiu2VydKUJtp4LwA=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=VvkFdBPR1urYFnqoxPK8HPwL+wP2gupo/zswe0UcLNLWEUwRvW1sRpLGl6/jnBvLr
         djbqw3VDzfP/OG1TmIzHoTDd1W6dT/FG9NWKRDt1KT4UGA7uqmLKFOJSE+qgJIwQQK
         9pPY6gV8SaOhHjxxn1RDkVT148mouKGR3chq9m/rV/7JZFgYWlQ5nXFLtTJJZuVFw8
         fXwc4741iZUyQSS+3HhJeKjG+jOGzy5Lm7CjTun2rotvmys1koVgJEogjDtrWKOB6/
         bQESO/u/3AMM1/JN+re1Yme3K13j7O4YNJyQMmZo+evZXdL60jU2GEdHDUlka4VkUx
         6kRrxTywQECFg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 11:11:54AM -0700, Raj, Ashok wrote:
> > PASID applies widely to many device and needs to be introduced with a
> > wide community agreement so all scenarios will be supportable.
> 
> True, reading some of the earlier replies I was clearly confused as I
> thought you were talking about mdev again. But now that you stay it, you
> have moved past mdev and its the PASID interfaces correct?

Yes, we agreed mdev for IDXD at LPC, didn't talk about PASID.

> For the native user applications have just 1 PASID per
> process. There is no need for a quota management.

Yes, there is. There is a limited pool of HW PASID's. If one user fork
bombs it can easially claim an unreasonable number from that pool as
each process will claim a PASID. That can DOS the rest of the system.

If PASID DOS is a worry then it must be solved at the IOMMU level for
all user applications that might trigger a PASID allocation. VFIO is
not special.

> IIUC, you are asking that part of the interface to move to a API interface
> that potentially the new /dev/sva and VFIO could share? I think the API's
> for PASID management themselves are generic (Jean's patchset + Jacob's
> ioasid set management).

Yes, the in kernel APIs are pretty generic now, and can be used by
many types of drivers.

As JasonW kicked this off, VDPA will need all this identical stuff
too. We already know this, and I think Intel VDPA HW will need it, so
it should concern you too :)

A PASID vIOMMU solution sharable with VDPA and VFIO, based on a PASID
control char dev (eg /dev/sva, or maybe /dev/iommu) seems like a
reasonable starting point for discussion.

Jason
