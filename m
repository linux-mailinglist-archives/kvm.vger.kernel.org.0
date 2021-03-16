Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1D433E1E3
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 00:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCPXIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 19:08:55 -0400
Received: from mail-mw2nam08on2073.outbound.protection.outlook.com ([40.107.101.73]:30817
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229624AbhCPXIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 19:08:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaW14DKbqRR088lXkOVHoaA/JZHbCXI3zauIAD6I01DDkqBNTqAq4Jm5O6kXjSj+1yVrfyJyFjS1/9J63alHjEzaWbAw0ob4NWf6j7Q4OLYJieiVJ7VpoA2xrYEGQlafRfw/2/mFpNGJYH4iJoov6jTb5u7WAFpncxAyvXOyVlD0EneqGkiyygJC7DOzf5MJHEx0N031ES3pmbjV+Vz2FKIkw56CDDinuG4CZo9vmurCoNGU+1F44Gy1JHCOXxH9LGpnB7L0KJLnM1+Dl44VmA2/DI2axZJOAn7pixa07NGxbodZKmGC6ZqVquvxw65ch1879peZDtJGrhvgvu6VCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpP/w57wrUDyLr6+KaP6v31cCrK6ALLnRyHX527ozcI=;
 b=YW8wAJzMjqvIlXWjrcCiZQ1JpZWpl5BR93Bf+QGGEZzAoyKwW6darXBSEFYfsJ+k5fiO16r8QJRI0B/lWlvoWwo0tA44sdZVjSk+GU9QKs1g7/eUm5UA1ft+6GgTifp0NUi+vEdi5VKoxqrFoETo6uCALFHncm+lI6Ofztd/1L3g76PTkfhaOlnpjPe4xzPHupSq15vNja/quKSrHKLsEUr9vkRD9npBE4WaiF0OI8OqXiaGe06wxff5konlhtcWwvXh4uYk8T1LU99XMVW8iFKjVfVdPXuw5WDtM0rlde5bCUR5ltWv2mFZcHlB3lfcjQs3IhhviERLR1Ci8/7odg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpP/w57wrUDyLr6+KaP6v31cCrK6ALLnRyHX527ozcI=;
 b=dD4z2BdrlBIKvZi3G8A0uiqSCZAlpww9e3fLaS41NqJZLG/lQ7ZB3Wf14YU8wl5I4wTMKvr02l9dJ4sdCZqFdkxftTMxsfOCtgngA3VSFbKJy+4+MPjPHjQSvaVYgRvZFanNp3D+LT5w60SS97Cj97+aWt6Wj5C81/6xr6L22zpkm+XmZHgI1/alBh0nH2Kch041rcDKKJU23fIYrhPBLYDjTV6HBVBTQi/emlTiUhrhy3UV0sxpIcWqpxVDIzWzG1WQo1rYD2hEub6kxChTxCI6NG2PDlrSOU+3/bfaBO1NUysL6EflujIIgWeVPII83tKSXwhj6n9sZX9OyQPN5g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4944.namprd12.prod.outlook.com (2603:10b6:5:1ba::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 23:08:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 23:08:50 +0000
Date:   Tue, 16 Mar 2021 20:08:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/14] vfio: Simplify the lifetime logic for
 vfio_device
Message-ID: <20210316230848.GC3799225@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <2-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <MWHPR11MB18865B08DE53D9E9EE04DA5B8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210316142454.401d77fb@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316142454.401d77fb@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:208:329::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0077.namprd03.prod.outlook.com (2603:10b6:208:329::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 16 Mar 2021 23:08:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lMInw-00FwdG-IJ; Tue, 16 Mar 2021 20:08:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 264b1128-3180-4d5d-ad4f-08d8e8d075c5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4944:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4944DDE4AEE60E4A935526F4C26B9@DM6PR12MB4944.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OISFz/ZDFG8RdlZFBP0eYWNlsC1nr1XZhWhuZLw0+nCpDF7cm+5YP8GW+H3QQ//6sFxa74eGzfK2PulF/0J8h5Tm7A9WCA9GjVVQ+N6F/UVqYZTtetSKqLoMsOVnE5rvvboU+uXfDDGuFcarVqyiyqk6QYz30FCEacgjbXyCDfdG7OuhFzqS4NWQKBqnK6HnicNkUYBush+9TXfGsebWtgb7TnRhrQBDq/JtRzsPlcNwfMHMXhNovtSiMIV97pvT4gVHFVHes7Z/hb1QHk6+kj60VOOILUPsQsKSqtWUfElDXBbBBcZ3UoktbLQ2yTaICBYi6/ggWThuZ5uXZeFVWL4MfqUMVo/r0pgKEN7isC+fcXqbVSrhj9XhUhfg2dQ2Jj448tks9WKqRyM5K/zaYpPjixGQ5arqMsIDXxyAbrcVjWOnSy3neOeQHjNanQ5vl4kPb8TWrJsiHdlc1mEYuYmawEe+6OcBshBH+QzSw4EwfJ0K86Dk01fYmOQPBvL2r51pLoGJgAXkbzNfkN4mYl/4yQeWZbSnzD1SB/PodPFxdrr/wwQrSsbi1zTnZh2c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(478600001)(54906003)(2906002)(186003)(8676002)(33656002)(1076003)(2616005)(66556008)(66476007)(26005)(426003)(66946007)(9746002)(83380400001)(36756003)(316002)(107886003)(86362001)(9786002)(6916009)(4326008)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4bp0QfL/lb36WQWXanld8C+CCrmcy2J8mq2gNMs7D57ox0vjn5F48fHVJ6hz?=
 =?us-ascii?Q?NeFYXzOi0+sMs8bd/sbNU4mUzaJrMrB8yuRwyRUfKfndDCsLYVS7CT9Tg1AE?=
 =?us-ascii?Q?temSLroEpQzmiJx7fCnCbHAJmVuYVGKkI/OPSuywfnaxuC/ClH1BCoIVy1zd?=
 =?us-ascii?Q?gqYnA9fU/TtcPr3xnQhi7r2sW1n2xgmwmKqj2YYNAXoIf9kWGiidyu9/DpKu?=
 =?us-ascii?Q?JKWmKFJMRaPKQQxh3ztCuUjboLj+J66gX9Ii0XOv/J2Uc238x6PBrF425fpv?=
 =?us-ascii?Q?6Yp6QVBxU8sye2IH//a8ns3VqokUmxKUtXy+USL7Lt/kX9dXQ5Yxwe8hfgjx?=
 =?us-ascii?Q?kVxxQklln6ypaL8rjzvsm6hQ/9Qyvf6YKi/dmFYovvnPHIuD4UmaG0w0dBG0?=
 =?us-ascii?Q?bvGv+QwoC5qqSO2uWgiSpfGxCDMyIcUpa3V/KKPjjtlY1CGT4UGLOh7cV5yv?=
 =?us-ascii?Q?B8LMgZHpXNSOdsjl7VsrokpxtIzjA5K14aCWYZqGwfNkvxcObYR7VLUkwykN?=
 =?us-ascii?Q?zwDn5DbpFwXEisbsWDqhzDw9Kf41Pa+GYch17ewzL4mihUypBfZBRJHR9hW3?=
 =?us-ascii?Q?MTh/s7+m/w/eAnUFv4lmxiYSlf+aMecsJuGKhr+Oc+NBV4wSysXDWbUOWyaA?=
 =?us-ascii?Q?92IuXgQWMMDCdXVydfv2frlBK9t+X7PXr3ljolKEn2E/MujBMp5aiM50RmfS?=
 =?us-ascii?Q?Jc7wo6RWgTb2VxyeCHW3XH4LwfYbWxr1KYLdhzn/evfoK/gFYAdcY40MlzQC?=
 =?us-ascii?Q?K1RGo5qaaLABNteyDo3tXhENI2uFEqeEjQrxYuYNyopxOLRW3Pgcp2HYegTI?=
 =?us-ascii?Q?PmR3IzvwJqTTV3fAGtHuidI3DQkP9aN+YUfO8s+KvI2hTBS+GtttMyFqc65z?=
 =?us-ascii?Q?bpevDxgNBH1sLRXaLxhr4qbDv3cWvL0ZYV7vdjnIa5RjptuUmSNQ2q1cKBcE?=
 =?us-ascii?Q?f/QByig1KkBw/bHCVBze8APY35NaFtkhb6ilMaOuyYyioQW9hdvhtiuunFSJ?=
 =?us-ascii?Q?9Y5HAwwx/20QUwOGCk2zRT/0IQ22FibzChYB60IL3w75Gv2YWz0jrQWFCMbI?=
 =?us-ascii?Q?/0R98F9nujxA1SSb5xQpKzFH8jKg6yV/JCBi6c3uWomX5FpydBAXDW2wZbuS?=
 =?us-ascii?Q?OaPLJ2CpF09MC8JzgAguwg3R4e9RuoKlvho3m8/KPMtC66JlT/Y32454cD53?=
 =?us-ascii?Q?CuAYp2D5RSk5VhisgDvMtd0r/8EfGB3A1+dQ8G+CKRbLZlE5cTwIjnu5Nx2r?=
 =?us-ascii?Q?Zym5QT1uJp6TxZEWY9vj+8TePQ+/rwf3I/KKDEtZpACwOijIdJ95UOOSDenV?=
 =?us-ascii?Q?d2KwqHma4du/johR5RtU/Oz8Se9kdpq07h417YPwkW7oqA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 264b1128-3180-4d5d-ad4f-08d8e8d075c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 23:08:50.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqW6gG82T5mDSvLdRJoz4YRB02Ox5Ui/tUwj8WVFlmAzyVExwV8A4QnAMYolnlR3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4944
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 02:24:54PM -0600, Alex Williamson wrote:
> > > @@ -935,32 +916,18 @@ void *vfio_del_group_dev(struct device *dev)
> > >  	WARN_ON(!unbound);
> > > 
> > >  	vfio_device_put(device);
> > > -
> > > -	/*
> > > -	 * If the device is still present in the group after the above
> > > -	 * 'put', then it is in use and we need to request it from the
> > > -	 * bus driver.  The driver may in turn need to request the
> > > -	 * device from the user.  We send the request on an arbitrary
> > > -	 * interval with counter to allow the driver to take escalating
> > > -	 * measures to release the device if it has the ability to do so.
> > > -	 */  
> > 
> > Above comment still makes sense even with this patch. What about
> > keeping it? otherwise:
> 
> The comment is not exactly correct after this code change either, the
> device will always be present in the group after this 'put'.  Instead,
> the completion now indicates the reference count has reached zero.  If
> it's worthwhile to keep more context to the request callback, perhaps:
> 
> 	/*
> 	 * If there are still outstanding device references, such as
> 	 * from the device being in use, periodically kick the optional
> 	 * device request callback while waiting.
> 	 */
> 
> It's also a little obvious that's what we're doing here even without
> the comment.  Thanks,

Indeed, that is the explanation why I dropped it.

Thanks,
Jason
