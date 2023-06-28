Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671457410F4
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 14:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjF1Mes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 08:34:48 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:22371
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230152AbjF1Meq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 08:34:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCuc6FtBUPixKa1HfOac7vTyeCWy7Wjm8rs6+Tpzzts2M8Oy4aPyaHfjZ3/zgmME361F5iF7uTm0ZY8eOSNOyaMc2n4pSwKHhJdf5K1qs77PFN7jXBI9HJkUcbRSOBchCANaycXYeGTm+9qB9q/Bw0M3JM5xupmgsmI2p3uKaRpQ4j51m9c9Qksv8m2jz4N2d9yGPydJM7oe1PUmnkhBFeZBgV4os1I5rKi30ApF6EdGcNnymIn3qst3mwtmuTOR/4xUujwh7GoNBoLAKJGgJQ384JUJZUsglCPWBx8J29bzviPYhB87Ck9IEoLahrB3KKU5wiP32sg/2E0/qNV3CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2Pt1brvS/Q/eJG3s7DXAXbgP249941YNvOHNKW0abU=;
 b=ij0w9PT4br6L25GVjBW0JJknekujnfV7sIxGEmgfi2F4lMdhmp2YLSnyjZNgiQrHfxdr+IJiwqM0agjmOehRui41ALwI+y4gK//IIlsiTTDnFir+Pz1ozo4n43mMscObm0FGgDkk4upWdXr2VFLX2SekbqS08fUQUZYwR4NyMcsV9FbMdjp1WZyOFixJUbahg7cS32CGa/dj+QLkObSGK2mhgwfodLTJy0iRmyj2KzOz7iq5KttvUgCYoFzzLg0poAdHtUoVdRm96P8J2tsf3T89N+OdobSNMIG4oLXNN4RdBXTRseiQSi3qWku3cDD2Ob+FzsiGDS4UuFRdO/0Prw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2Pt1brvS/Q/eJG3s7DXAXbgP249941YNvOHNKW0abU=;
 b=h21PCRyyB96uegczq6RHNlP4mhuCsF5wjqTgfG/bLa8KwL12fy6MJCVeP44yAIwDqxr79JKZue38F4STSxx55nw6ERWFM7yCPVNnfOmIZNXLGCZY548RYlchpiEi6TV+/jUpxwWr8M3jbM2HEBh2iTArvW68MTJuubdIbndaTwadCmRBBU+kzFru1KCjA6/lYaVBNshpPqRwRVjQcww+WgpVDLmaRqCN5cDo7Dv5ln1YqJ5mPuSXTae//HHVulLaezbyLJXXTVdCIGzOumlKPKd5sc81VloVorDORv1Zd7AmUS7WhCTXo7Erw8z7l6Jem6pcRt+o+2dqDtkuS0DZXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7485.namprd12.prod.outlook.com (2603:10b6:510:1e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Wed, 28 Jun
 2023 12:34:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Wed, 28 Jun 2023
 12:34:40 +0000
Date:   Wed, 28 Jun 2023 09:34:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v13 22/22] docs: vfio: Add vfio device cdev description
Message-ID: <ZJwo360Ckn4KvayL@nvidia.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
 <20230616093946.68711-23-yi.l.liu@intel.com>
 <20230621155406.437d3b4d.alex.williamson@redhat.com>
 <DS0PR11MB7529C5F9C31CE343AB66B0D4C327A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZJsKXoK7SF359Tb2@nvidia.com>
 <20230627113430.129811ef.alex.williamson@redhat.com>
 <DS0PR11MB7529FD534104E123BC7A3CE2C324A@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529FD534104E123BC7A3CE2C324A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7485:EE_
X-MS-Office365-Filtering-Correlation-Id: 39f1edca-327b-4ac9-10da-08db77d40b0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d4N3aqk5AeV0VmoLS2Ug5yi5uP/ErCAAcJndwYsu1g3ZzpAS3n/BqVrYQmzK2rE4HTN94KLMHPSOYJS6sk2Xs5wL1sJd9GnOIZgO/EOyM/sGafD57WKsctv9+iIfPha8LbnQ4WtcN7roIPyWXwgVCBzoOrUhMrOpjXJwOoO6SiVNm4yT46OqKBEufHYdssz9I2jlhEpnYY0tZoaR5BLcfTdZ1IKi2qXPy1M4hdGVxCgs53PzJD5NPQ6n4mNhGJ3fs5ZwUectXQnoT/pxhf/jOTbcfTaQECdFo17lVXluKXpsAtFDTCmje1HR7P3Xw/wDIJQ8BBPvFIRxvBnIpcwCMzlbsnkh0esvWy93H+dLvcFYEvRCqGfB2+ki0dSP2phJ+Dd6MmrdoZUhsAJota8s3hGR71TryjF6yUaZc6CTV8sc1lHt5tcVOIn1lChiF8JBOIYNLKMtGRqU7SOrAQP2X8MEpecirObDc55MGTOWZ2VxxCoCOzUs5wAov44JmyT+mxXKTxQN70FKEhcbdttftPJkyQ76S9bei96KbMGpq/WP7v3bA6UHAe+m+gcFuGr+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(83380400001)(8936002)(6486002)(316002)(8676002)(54906003)(4326008)(41300700001)(36756003)(86362001)(38100700002)(2616005)(7416002)(4744005)(5660300002)(6512007)(66946007)(66556008)(66476007)(6916009)(478600001)(2906002)(186003)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7z36FO5NNbt7AuAuMraF1jVdbrJowKKbGdWhlSW1sGhCzHXNSCGIsHeDM1j2?=
 =?us-ascii?Q?GW2LAIaljZgej2L57Gr68BMszNjfIXpImmGIfmWsDTdIVfaPbn/dCrnTCZTO?=
 =?us-ascii?Q?f2+FlzhgM0j6Q+4o+stZx9C+K6hobbRmbosOBQnvs29RekeLK9pzGsbED/cN?=
 =?us-ascii?Q?6ru02DGI3sZjp3hyBy4Hz2ZmUzMVpKR5w4BtXPcFqL3p1fsgGzBmwX35ayrw?=
 =?us-ascii?Q?fEBLwuHCsMsTX2/6L03pkFhyd6tQoDaZAaDdCmngHMyXAdDKuLtcDCX8WDyZ?=
 =?us-ascii?Q?VkYKtMDbYhEuZnh/75WCLgD+XvluqIXqxDyE3XUga05ALWUv9RVpAogzwUGA?=
 =?us-ascii?Q?pTkvntltQzDwc0IOdY6qp0MDj5OhfOVD3h2Siiy6GocsCFBTqPqfr8iQGP+B?=
 =?us-ascii?Q?UqiI9e2+LWJBshpRdcDolkBRF9fvDtNxIl4xh43X1Zak25OAet0MkVgzM12Z?=
 =?us-ascii?Q?RyIwDm2Vt6RFTStX1HWDZzktVhL2IQDJbQCr9kewYOvhNtnqfZEK1+3vxAOP?=
 =?us-ascii?Q?gBbMIVMY2Z0FoDnlzXGxKp7qtu8eif0fiY7V8nAr4tBTtw3+XfxwPXdbfQ5K?=
 =?us-ascii?Q?u/RwHFmWpIqSBb9wQY+v1QJKksufC1O9wz7BQPfgf+m/XO0bp4aHLbv4VQBM?=
 =?us-ascii?Q?TXq2UERsWKQxCxXMqQItTahQv93ap56NiglQtEdrOTolGh/2CF100w/9dtnA?=
 =?us-ascii?Q?2JGEcHp3+3PDYgGCG3rUZ6opnUBFzt2WmmHRxx4dH2bbW6//fETeuTyGB62q?=
 =?us-ascii?Q?NLb4OdJn4l5OxJ4YeZuazGPHER3LL++ByTGBGfV74mGDnHMOJRKzDQgYghqb?=
 =?us-ascii?Q?7QhKNxX8KVTH/U0Gc5EpHrdqOdQjrsqFBUkRF16IUlhXNsKy7evzbPXslrvZ?=
 =?us-ascii?Q?mx68zsBqo/U7xyBLyclLXBOZ5frRQTkdKTUIrIjY3OHhxqAKpFjU7tugYYyJ?=
 =?us-ascii?Q?1nEN3cAEK0GZgvVJ3J0erEsKX3VThOP1HNa5T/12HojdTZr956ymA6+Is+kC?=
 =?us-ascii?Q?/IcPsttIkuL2bWg4m9qo1zgns3OATGbfOceiv65wivgOtTajslL5zyxTI2EW?=
 =?us-ascii?Q?c1L/AQnQev9eYh7p/MrOMZhb2NBegOkQQwIkcJh1fbNn3InjtYl2Hr0z86Dx?=
 =?us-ascii?Q?YX8wgjIooydEX5vHUsV6W4p5tIqKqsk3RIYm4qZgk8+QNQiGrSVFFGvYCcaQ?=
 =?us-ascii?Q?l8XfqckjMBmHAJMu8AsYtL7bEtB1LTzk3HB83mnFvohqAaNM0IBuwy9PsktQ?=
 =?us-ascii?Q?hEJIxAj9Og8w8ujBSaJsMRPWkxQ9LGUC38KERXVMLaLJQWNEVYi7QqH3fs82?=
 =?us-ascii?Q?6FU3XnBYbGxNM0iNL0oQ4TLtxsWTxDVq7iKmwzoLRF6oNXFF9kjkzD33TtxI?=
 =?us-ascii?Q?sdARqV0dlUqUDC2eu3VRzUOnz000eicNOXjj9yXnaDTMWTKGatoHhp98pQyY?=
 =?us-ascii?Q?24DNOf0YEfLzBbLCbJTqygPdcRbu5tsmqfCYpu6CQNb3VEZHGNNidUzrjqEV?=
 =?us-ascii?Q?13lGOtoK9iK9IlDJ5UvDws0BfKymT77Ro7srLH1fLNfFmtMibxMrnsIvlSZ8?=
 =?us-ascii?Q?uMS+jFwvA+AKExr2Ei5yJHXos0KlDVh82okDGfID?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f1edca-327b-4ac9-10da-08db77d40b0f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 12:34:40.6771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErpcIcLXjj2K+LlMyw2VyHtJ9C5FwQx0ssaMJcZQDNmZwYl9gm8htoIyZ7FsbrOz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7485
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 01:10:11AM +0000, Liu, Yi L wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, June 28, 2023 1:35 AM
> 
> [The Cc list gets broken in the reply from Alex to Jason, here I reply to
> Alex's email with the Cc list fixed. @Alex, seems like the same symptom
> with last time, do you have any idea on it?]

It is weird...

> > Are you suggesting a post-merge-window pull request for v6.5 (also
> > frowned on) or are you suggesting that it simmers in both our next
> > branches until v6.6?  Thanks,
> 
> It appears to me the latter one. When 6.5-rc1 is released, we immediately
> apply the hot-reset and cdev series onto it and put it in a shared tree to
> assist the other iommufd feature development (e.g. nesting). Jason, is it?

Yes, no reason to try to bend the rules with Linus at this point

Jason
