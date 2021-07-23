Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC173D3A1C
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 14:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhGWLmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 07:42:43 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:52320
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234601AbhGWLmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 07:42:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZI+zdIvHIfNtvQMTG4usx6QXf0IzdCix7jElg4XmWhJOxFNzyAHliztAkO4tUz3gh66i2zBmmzeNZVFuh0kBn2ystpbFT4+POVok9c2Oho24ypn6yq35q6sQzPn6JG/uEt+ZNut8bA6DqWAlAtd+lRrW5J7JH//3j6Dmr4gbJZpFCQ6GC11j9qMQooFZWLY/Qd7Ve2oLK4swoRwxOA2p7JsAirgp9DBmH65vZpAkcqnGbSR2+uTY8+K/Bn3I4QKiWZfJ7geAAMDt8MPFMoE2iE5m2zbgm5mMzxFDtLNQMdI5Z/HqGvWC/wQmrByEqsyoJi2i89aDJbRRh/5nfETcxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTXo08/a0K5k7C6Iy+goWsfjg/0Kn4VAZHhllsiUGWo=;
 b=YjXg1TvN55Q/p3i/2DEB8AB2qnoL4QiaKMpUMRPCR5IfPYEob3D/WzGOkTZ0beENGXEShZloA7ERqTyQUC2wLHpR4FFJ0U5laOMVCTMIUQiZ6ZpGOOblDkMeKhtYc0nNZ6CMxx8tI4/yK07QaGxP+qbgF+6WVx09j9NVAbs5GkwRzj0FaJrPnzqEKRsRmxXEVg2Oupa+HVQWmpWsvnVuov8UAq+JMxGQ66p+JXQwfBqda4xRsjjr8UV3Fi5im9RuESsoFsB6ABfKfZNdZdZXeI/LtAAzNGXHISPrLRzm91S0aTeiZNknKL7WvlYOmDTI9bOhDIencA1N5ikwyHvXrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTXo08/a0K5k7C6Iy+goWsfjg/0Kn4VAZHhllsiUGWo=;
 b=qJTV1A0DGKDZrrKP6voULIIVaWR5pnSZMjQQDdlVY6ojP8VxAul7XOUxKgrDb/lv+IOQ1QOqOXYTy0YgBu6Ij8rhcUmefZdxZh9lcOLTV4G+ameFJAItptAK85J8fwyvrqJFvMNAOOK9RnhFZNhF8RfP1odvz+A0MsFX7Ka6paTWv+lHB395Obb2aQpy/zSkD/87iIKJ8EECCrrj7p68wi0Ut2G4Ip/cF5pePIWQlXNu0LYWVywHb2AQARx9sd/jlAd6bi2MBMS1FpQldauEO/ChVAgtibLfq+tLgSrP5Z13auNLxtrZwa5XkD8WNAuz66uAmtGS0jrC99G4nI8YVQ==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Fri, 23 Jul
 2021 12:23:14 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.029; Fri, 23 Jul 2021
 12:23:14 +0000
Date:   Fri, 23 Jul 2021 09:23:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 07/14] vfio/platform: Use open_device() instead of
 open coding a refcnt scheme
Message-ID: <20210723122312.GS1117491@nvidia.com>
References: <0-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
 <7-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
 <20210723074521.GB2795@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723074521.GB2795@lst.de>
X-ClientProxiedBy: BL1PR13CA0444.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0444.namprd13.prod.outlook.com (2603:10b6:208:2c3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Fri, 23 Jul 2021 12:23:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m6uCu-006zSJ-Kj; Fri, 23 Jul 2021 09:23:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7c3107e-61fd-4920-ca2f-08d94dd4a47a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52542586D1D27F9081EC8A48C2E59@BL1PR12MB5254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +BfUI8xVGdfYcK4vqx8FpJvisCp8DNLrOS+/OK+rg4+NIoCmkbF4i19aEf+BXi26WklcnUfOUIjb7E9NCHAUx/S0Q0t+5f3Y2kFPc2loMzPUfhLX/vsab2yVvMMSt9VsuHrFkxbR7IH7h5BOMg9lyP4KEP20MOkQowSvzPm+FoMJfLGYlfm9MQAKFYQI1p1iEG+2sdNhGKvpKTwnPJ0tQefuMJrZRBeU27Bxdaiz5iI1Eq/3sHgXRlRh3rT2qCRXcelEMED+neI9U7mFvkqbJ2Rpv3sdDqiOe/N/CPEEH7GQoLH++1AEokD1oFDwDckJ6kjA6XHosgCxlJhoaA++mjoTgftaR+SmStJebAZ8EBXOaQF7Jb5wipItsxGG3ge5MDZzhdxGwXBTPIEiIooJmJ1vWlmxIjIWo7qJdB+dLTHxot37CsndvarXZjg6HfMx18SnBJgdP23rf04W3EF7NJS+sqV1d019kIC8o4laOMZ2/4Kx5RcPISwfGSFyQy5RE0hGbBEU2hN0WW+VUu5xLuXvXVTvijYTEj6ym9J/4B1pD9TXliywgbzoSf7WmZRA3slo9d9OJnm1/kKe+S17nMBNagPn9VqRmG2pYp6JYbkbJEN+0nbOOTilOe/zR4t87ZoVbkC02SnaC33fhFYiUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(5660300002)(26005)(4744005)(2906002)(83380400001)(36756003)(86362001)(33656002)(9786002)(9746002)(1076003)(8936002)(2616005)(426003)(66946007)(54906003)(66476007)(66556008)(8676002)(6916009)(316002)(508600001)(7416002)(4326008)(186003)(7406005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G9AC90MPVtbVcBHGsh3XLnENqBok2e6H3eTv/y9kV1Q0jJRbZtp/1UnQgyE1?=
 =?us-ascii?Q?OV/krSpY2gtMArk7D9TjCCdWT70MLKeL6NPwBESawb4hnX4Znl/D4AVe82m+?=
 =?us-ascii?Q?UlbH+BsVPkE7XphqZ7xkj/Ig/WukoKQfqmw2N7S7OnuqrcXtrZPzILP3Mbhp?=
 =?us-ascii?Q?ye+tcdEFmIYmJGCG6YYoy2nM7lq2SZxrXFxigxuqEu+KaJXW3NZc/zNoiwXz?=
 =?us-ascii?Q?b2NU6RBqEswvyc7to+SdUhvm8ft1GglcQAhU22kX8mIvEv0wbXxWJyOelELr?=
 =?us-ascii?Q?nVYXEGJ/mOArUBfrGN/RABt0meMr7aW7xo4Vhz/SgAPKgGo7s2F80bHPAkia?=
 =?us-ascii?Q?oeeTlPHh/6tYI5Z8HR0KDrxqb54gspULEpJt94HG2c/8Qf9atfb8PN8tLR2f?=
 =?us-ascii?Q?VA/4pTi5y7spOyOJbg0eBWVPf8Od62lI1w3Kpo9xtwEPW2Tz4Qzrd8fhuhaG?=
 =?us-ascii?Q?wQ4NKYZFP3gC/kPdZEQs0FkciH4yRJuR1qjf6s89sgcdrPw1MDoRqxmBDKZD?=
 =?us-ascii?Q?FSkmdnc87isAmn3HZwmg4F6jotoOaza/Ukuc6YQ/eSsuQuoDpWBtE6FsTS9a?=
 =?us-ascii?Q?T8IA/yKx13kQ4DmIEzXZp2BFk0Ayk05vHxFnxEbzyfBmeAvKcvcelPexnA9H?=
 =?us-ascii?Q?SAYy2sethaQoqr+iOiPXdu6524twjzN6RvwvqdwkbmZVtTtKyrKjE4DDN9ln?=
 =?us-ascii?Q?0vOQFYvzgzyO2Gq2i/LZ5QA+qdDhIYreGffFNkUx/Ex8olu6Xv0Pca92x2CD?=
 =?us-ascii?Q?ykhrUX6jD1j0PmYwr90iQ1YIfyn1Vfd1tgj4IOZo15sq+RR1WXOWCdDTf5+7?=
 =?us-ascii?Q?Z0fL8AWdCCm5oav2jbGJr+onCO7K4oofsTkjRalK2B9x2qM+8CTBnvNuJbCa?=
 =?us-ascii?Q?xbPSNItnFcq/RuQZ4WPsvcc7Y5MWJLJCjSLNnb/qQ1c6rZkXT1qp79guJhoO?=
 =?us-ascii?Q?PPhcYNwy2Yc/U+F/l8Jscrzmfr+m3z9rjtRl0+/bPPaxIE+C7vl/l2E4dqWm?=
 =?us-ascii?Q?DfrphAFFVizpCKD5JQ7unlUNmR5CBQ/ON0t7Std0hKjzzE64nqZs/kkEopHs?=
 =?us-ascii?Q?l+yOIgYpsr+7eYjlmeansH3z1qIV0Qb/ukT7hgk2kGL/yxqHjV7dVYFYirDZ?=
 =?us-ascii?Q?jAzu1mOUbL7C0fyCy7oRbN6VDN2bzRvF1f6RpxXJZWbga5BlSI8k+QdktrQ9?=
 =?us-ascii?Q?Zmb4U0DVx/UAFBwaJ59oCS4Yfa1MpFj2TT0qoQVs2v+CGbVcsIhMqchrlyRe?=
 =?us-ascii?Q?4e2EjjpePS0ON4F+1btOvjOaLUatA7UG06sTfIxDQU6ve8q6xmHutcoBKBMo?=
 =?us-ascii?Q?Uei6Od55fRiJHFQy6UTenufy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c3107e-61fd-4920-ca2f-08d94dd4a47a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 12:23:13.9762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rg3trL03NcN8AySKOxG2kZnyAjvejUfhw9NwZ06duoSBiJvlPyXc073fnEm9hxuw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 23, 2021 at 09:45:21AM +0200, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> On Tue, Jul 20, 2021 at 02:42:53PM -0300, Jason Gunthorpe wrote:
> > Platform simply wants to run some code when the device is first
> > opened/last closed. Use the core framework and locking for this.  Aside
> > from removing a bit of code this narrows the locking scope from a global
> > lock.
> > 
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> 
> Btw, this seems to miss the second from line for Yishai, which should
> match the first signoff.

Hum, I think we ended up co-developing this on, I can reorder the signed
off's

Jason
