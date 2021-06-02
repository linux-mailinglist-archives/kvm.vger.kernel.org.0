Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762EA399195
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 19:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhFBR0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 13:26:13 -0400
Received: from mail-co1nam11on2080.outbound.protection.outlook.com ([40.107.220.80]:57241
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230054AbhFBR0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 13:26:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKh/Q88dkP7kHNh5Vb5E3l8ncleTq4+3qdBMoAybdRAErouPlOr+A95pVJ5oy8c7E9WSwD6d5dPXzPUJ+lgBkiDkcieZpnt7zTRO1PDuXpum/Hgjwb/Dl6GJpiJYek9QqWWuA8sBGS/KokusEFZQGXolFLhajR46AXxEIPsktJXLOMR9Pqk38+vsbHk1qGgFLc65zeAbcpVT7bEgt80CnKBS7YB0iarELcOcVzjD0cn9wXekt7vo7pKVPcmOBGjDZ4/anotaazCGIuobNrDOIOg7uVM6Uu4olDicM1dqPt4gw/tzN48mHD+ubEjLHX7SqlZ+90pBLtqypShSeUBlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3x1nNBzCTZjUDqYHusKdAA4tvAw2jrZNM53lnaLmwY=;
 b=ngUc18zDaVPMrnJpGcRZn2gitZmhex+LBbx7JF3Zex7JThR8gH5R049fw1wulQ2NqQjvisQlF84BxtlAuYK2Mz8KIdbTQHqO5F7tpqqGkBvOOmYaND23XgT1WaC5ubOn08TJFr1az5Yf1xJd4o2w/xAA44LSGe2P+1OC4DHfA6zRbr+4LRPGJZwpa957V0a3oCQ30J4v8QVNVgSMV+CWuWuGEzhSxAYhfpYlT39XIZpPwtUne3sBErLql9YDmWG5SYpxg7GkGKpVsGsku9Jomcgo+i+0bEBavcEwFmbNW0RxoI7DnCxQjZf/UwzEKXGWn7NbOGPbOK8wD/C8pIOQ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3x1nNBzCTZjUDqYHusKdAA4tvAw2jrZNM53lnaLmwY=;
 b=Ie/HVgEKLr28bP7fsUWJG6k7yFnPG+n7BUUtmyr6U2dhdTA6vCzu+8ePIyL4AQzqir1twmltT/GH1TbaAnv5uAtoS66+gHqjwdxzaSZ7wRcrahKmn5Ol4DLxp503NrpSFr7JCTxwZGIr38FEc8YTOb82ddJK/LwYO4H8U/ORRIvKIjhR6c5Mtd3Yld25fzMapXY774bdSi170rfmyJgh90r37F/ZRxdhETeDpxyGBSS8SmlmDeyKZe2j9THgylsMxBQ4L4qy5hPOEN08rAb/kNLB2ajrzcclcQzRElaV/ortVTah8K6N9hnPBwTCFCw22s93i+5GIrmyeHDzXBd6Nw==
Authentication-Results: metux.net; dkim=none (message not signed)
 header.d=none;metux.net; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5030.namprd12.prod.outlook.com (2603:10b6:208:313::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 17:24:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 17:24:25 +0000
Date:   Wed, 2 Jun 2021 14:24:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602172424.GD1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <bb6846bf-bd3c-3802-e0d7-226ec9b33384@metux.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb6846bf-bd3c-3802-e0d7-226ec9b33384@metux.net>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:208:120::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR10CA0013.namprd10.prod.outlook.com (2603:10b6:208:120::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Wed, 2 Jun 2021 17:24:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loUbQ-000ITu-62; Wed, 02 Jun 2021 14:24:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adeaf6b4-fa56-41ef-8eab-08d925eb44f7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50305E5AA1B47C1B8653248DC23D9@BL1PR12MB5030.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J2BG3dsZE9bUowKUO2UUxTzWWNRbfshDmda+7pdZ5+mE6IqhvStL0faLffADPXAwRCtCLeauPjakfoxOTDWFWQIlSHP+OFgcu1y29OVhzVQHmpmAXwApUnizdk2Te3RFrpW6bobEQ176l3rV8d61cpyyW85HJ2pFQcTksvb+OXrO7xrBKv0DhYwRg65QlfOehwkDYXUoBoN8JiwBWSwZuaaJgm9iFpgPequE5PAlVMoK5NlKLWgnnAea4VUuPxdm3Nk2+/wlDu7NPdRKp3akpcL8jVTUr7lxI4DFi+8s845+mD2m6kjxmi1ZMZufKYpmcO/zvlqg7s3HPBO2K5lAWsJQFijcBEjNJ8CqeOvWVcB4ZPDdyrXT2Brmm/BTBeXO6SoYfO1wsWDhKWkVW/n+mJTKKKdDjsrB4shfB38zsV83kqbw4XG/y/9C6KP/TvT/Y2tOmBAdEYNngv0pbjXdR+eBnHINYOjsM+Z3ZZ+SqBeVrRVIV+CCfzzdDc4qMqICHvGhg/nsVvrlrBoArV7WDF9Bje7lWyzM0bCg/X6jY0YH+3/ovwPKtRkVB2NjwFeL+pTqAheNwkoouaYMSE30tTuqLJb+pkbGhYW7852+z3E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(186003)(8676002)(478600001)(26005)(4744005)(36756003)(6916009)(426003)(2616005)(316002)(2906002)(86362001)(1076003)(66556008)(9786002)(5660300002)(7416002)(4326008)(66476007)(9746002)(66946007)(54906003)(8936002)(38100700002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PG0Qjf4leool65OrVS8TJL6U92s3pIuHv8MudeuTMnFMMhlDLCVCU5PxB0bQ?=
 =?us-ascii?Q?50uxTsphtVR/GKTXnNVKPtlLJsTLrJ+VEe6duylLa0zcj8Hx+OE+XFE9uBBa?=
 =?us-ascii?Q?8TP6xX2ELkVUDC3ZUYLVm8i/SBqIeLEnFdhTt9QHYNM00L7Irr5hhKh9Hlb4?=
 =?us-ascii?Q?q3VvL8rula/cXfp2OfpYAbo+2PioYDqGjPQDs7JzKhQprHIKUHfXFmxRP0XE?=
 =?us-ascii?Q?8+bbRi/7Q0uZ+GZAfvfI/9YrhNmbGdh5o0ApU51/V4JrhxUQwovTmxolZqOJ?=
 =?us-ascii?Q?8FTTMoIGdWd6KIuQ3yC4xTr+ANJL77/GOACLthBQSvnL7oiJ9qOI8gCzxuK/?=
 =?us-ascii?Q?X2PbTbD0KoiMTQ3f2Jh++PdmynMOBy017wZsNeJJ4fHKw0XJ/xNAHnkTIcAh?=
 =?us-ascii?Q?01hMcdKno4wxiRxgyl1hWINlDJ421MiYxVMU3aWWoIvNxg8G5MWyjwj8kmFh?=
 =?us-ascii?Q?KumZoR7GPaC4QYlMBT0FE58TZwM3fj1cr3qBUuoBUkeL26u4SGVvg00QW4FU?=
 =?us-ascii?Q?9zwzAaryUQ2IkgVz4+ggXTu64c9M69VykIvO7waAKe0/uj5ChfVyGHS5BciZ?=
 =?us-ascii?Q?OXqQVvGOHS68kuRkSso9oIx8Hz1PnWs6hq6bZSOFxTI3A+4Tmhj6xHFoENqf?=
 =?us-ascii?Q?f2QpURujQWSMtRtptfftH66IM2cwftSqRaU85KljzWyEGnbIOF03L2GLcwq1?=
 =?us-ascii?Q?izw+Ogj7fYFjuYpJwhJ5l/fABRsmf99mvA3m5nxmDx+6bPraYnyo7sGUIKm9?=
 =?us-ascii?Q?Xp6grt4WIGcQfIVInL2sX/TRpJthrD0gai7Hfpa5niCiTwfmNp+8DKkaFUQS?=
 =?us-ascii?Q?H8HPWNv10bFj6AgD6MyKPae44p+mDj9yv7oV3edIl5GEE4r0Fv+7+lhkb71u?=
 =?us-ascii?Q?2wfDeFE9tvAgE7jEIQEcoW0D7Lns0xo+QzzWKwCMaycBk/5lhw3CTN9vmsk1?=
 =?us-ascii?Q?ipSz9Evfdk1xefhBJUgAG/f/v1dXNYlTq4zZ/a+MUAwyeQHC+aEjaG21A1sh?=
 =?us-ascii?Q?9rerESOR21PbeQqS/T9VlX+7ErkvJclqpcEEEmhuYo5J0CxMNR/m7s7mNTvj?=
 =?us-ascii?Q?7vFM6q7pXXrW2oE0Mw3Yy6CyjeAd+BiZD/TLZ7QPeMrg2MrP4mWP0JD0sOWk?=
 =?us-ascii?Q?kig2ovwzPFjTmAdxHXf5KXe8RIFBigz4iNvr4rgZ2lLc1egRaH6m7LWfqc6j?=
 =?us-ascii?Q?EeEWjetH3Iqjrw+OuUePZDTY15S0Sc2WkLZKWSBQaZLNBb1u3ynxeUoV2sJR?=
 =?us-ascii?Q?j+lV0TpmWn1y32gXBZ+ZNh+tV+p3Tu4c11tfYnuPbDnhX1srZXV9PsmsQrHH?=
 =?us-ascii?Q?MrSvbMrxR4UZRDjTARizIOSG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adeaf6b4-fa56-41ef-8eab-08d925eb44f7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 17:24:25.5855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXvqPqCKBUGvN2TVfi52atQD5Au7MTLBgdTQFRcC38Mscyrk0xymRkBtyRjKwrr0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5030
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 10:56:48AM +0200, Enrico Weigelt, metux IT consult wrote:

> If I understand this correctly, /dev/ioasid is a kind of "common supplier"
> to other APIs / devices. Why can't the fd be acquired by the
> consumer APIs (eg. kvm, vfio, etc) ?

/dev/ioasid would be similar to /dev/vfio, and everything already
deals with exposing /dev/vfio and /dev/vfio/N together

I don't see it as a problem, just more work.

Having FDs spawn other FDs is pretty ugly, it defeats the "everything
is a file" model of UNIX.

Jason
