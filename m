Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F426A5995
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjB1M6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1M6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:58:15 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A15AD1A;
        Tue, 28 Feb 2023 04:58:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqWYvmIgr0w1QZmD1x/YTydTud/ADlG3W/4IctapIcxIiOkmR9KOEQDVFN80irbnKEIk+ecI8TETmnpmEg13St3kkuRV03JOrYRH7RJOHb5J033N4KwoJWhwwpfpRdhuXd6K7S3Os67h6DARgER7QmFeMetrC7Rm4M6JB+RwP0Pzmu6zdQ/fy6nKYphCV343vLEIwhX+ZK7GZg4HZEEi5tuZUO6APmXV6lBK0RBRCM6OlPjijEQnglcqBXxCgal6QFZqpW86yzEzNWxGd4PO+BB7T20PorpTLzsSXwY43krF/A1YShdZ4YBQ6aKhu/6zksPYVhrkbZg0jYJ5qf0XEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqgxdLyPfwOFbf5rV94JoTLXhlzmbyDezsj5C+AQoRI=;
 b=SJSbfH7mvNe/sNkm6JMJDAB/Sem8dAyakqrbbQjWbyidk0tWHQHZiz+l1yc5E0QwkwWOcz0Ai04YpraVEe1eWtvaqCeo7j/QwynQbwLGcuoPFegiANf2v8dsZxfV+/kEegR3W/jlAH8oGlDZu/XQd5J69RQfxzi2tyPTUHfKNQAyF5ymVJ3inWhOKdnU9eviA6ZZW4TYKIAhfS/yOHHLs7CFh19GOQlT8EUrnJ2kTAJvhHk/b5v39eXdlD7Mcy5jWecyjHjvxdsphW7p6lOf8RBxF5LEng0/u2dB00bw3bcJ4/W+Vxt3kV5JJT2A9wHcmo4FrH6PGMDq+wfYuOkQbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqgxdLyPfwOFbf5rV94JoTLXhlzmbyDezsj5C+AQoRI=;
 b=FKXMlcmP2UxDsQM67BghH3VcQ7kHqE3Kffquw4PSgpqG42lCjc6tVRPOymS9B8HFNu0Rq+p3UGWJGtZ+ZPOPR0ovpHItLg1x3dSZYiqZfVwrZ57UL6VbVO9X+6MjCwNRfiatQkDkoNhlxCMizjG1t1R9KHzuMXNEPzYjzY0TYSYRo1jN0DQN8HhvJH0iuGM4dwzmssl+LoNcgSIb67TfN5W0rB/lxVeyIZx7PHLBjx2xwLgwi7GXcl2krUlh+yNdjtrMUYNAcVPbNlsJKwSEJdy+F0xftmav7PuR7SWBO12oc2aUoiPJW4jnK2Q3U6WuZQBQbSMri1R1nmSS/NzyVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5364.namprd12.prod.outlook.com (2603:10b6:208:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:58:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 12:58:12 +0000
Date:   Tue, 28 Feb 2023 08:58:10 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Message-ID: <Y/36YkcdzsJNCQFJ@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com>
 <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB75298144318DBA9690DC756FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30CgUSbkpFN20b@nvidia.com>
 <DS0PR11MB75293900EA1FAD0EFD13EA2AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/34+Vr4Mblf1G4i@nvidia.com>
 <DS0PR11MB75292608BBF3686A5FBE9D1FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75292608BBF3686A5FBE9D1FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:208:36e::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5364:EE_
X-MS-Office365-Filtering-Correlation-Id: fd272e14-2624-4af2-e9a1-08db198b72a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Y4I3b6eL9ouzS8RCAYS/hFmM0kJDOCv3egx6JMRTqFkATrg0jZUHp52uIRz3vffA8q9MaInaVbdmM2Z09AuE9NKUk/2XCHymEQrjIOgH8otUamik/5CklsgOpv+WqZK7Ye/Ay52ZaQRt1QqiliLvWEJB/1cSiwoYLcFce3tHXqDe4OdLvt+8h0e+J0nPUj+3BcnMprKnXHcBumXhmoVD14VM7nzXjjfeINBuTCXCrnsJFsY3KEbAp+PraiM1QNlnnsscVXTOYDeCRex1JvLSCSjgtfIq6Aa9JyfSiG4JgEk6WMA02aQV5mqfg5JzrRXLRsm1DyIOb6S2orpsK+vEE5JshZ2x8PW+v9uFIf5auxT6BI3EmOxUmidlOM3FeUP6ChPwSLRnqytkgII7dOfPAktyre3JkQgaSiIeeY3c7goMy1acCTGNDiaO4lNAm3Dln07hcvQdl5tMGoVKH9uEuFBXgV9eiR6Ke+NkugnNxTsUhp8yK/IFrwP15IikHTZKLcuH3pHrZEAs/wlugLUlM2sYzNzsvd7Gkv26yBK6sVbyQimIeeqmYFPIwDsLzmO7G+mlwW67zKExsvG9QXfpE+2RWoix8QkE9k8EZFuIWU/l4jgQxYBdnomn3fR4LspqA7HpJ0+lfjrC4+3LX0P7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199018)(66946007)(66556008)(66476007)(5660300002)(8676002)(6916009)(4326008)(41300700001)(7416002)(8936002)(2906002)(36756003)(86362001)(38100700002)(478600001)(6486002)(316002)(6512007)(6506007)(186003)(26005)(54906003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Li6AFz7t4UXSeuhxmkRqSaxgXItK7T7evMWjj8xo/AcjpjpOMKFRtIGW17Si?=
 =?us-ascii?Q?N28AwJa2vAQt+tn9s4EUfFyq6rqXGASZ2yy/KShh+8HXAZmlOdMim9JGGbel?=
 =?us-ascii?Q?u/dPATXnFZ4vke745DTI1w6eA8yrfQdrPBfmL8kQo2CLYi7XgdFZt/hdztiW?=
 =?us-ascii?Q?AHpj9QuLMIwMYERmNLMho9fSsCUIBz8wSh0BMRse70H782tSFK2RKhkfMTGY?=
 =?us-ascii?Q?HKTzbtPQufKZtBqZpaCwA2EL7ZfcZ1soApXuWp5tVqWukw4vMu+jLzuJzn75?=
 =?us-ascii?Q?zRslxE5gFEoOLTejBi7q1/lApqm8pimZjLZVm0kU74KkMyWvTwNV6C4TcCQf?=
 =?us-ascii?Q?XP8FBAsm0laCsaFNdjH98gFdopadanS53/ZsWuU0Jf6dsJZmadR2teMeRQzC?=
 =?us-ascii?Q?mCk8gVqH8cFz6mO6oqAD58vrh99qcQl07UAqKUevOkp/zYSDsx0+ZKsOCaU/?=
 =?us-ascii?Q?kDVh2STBgoPqIMQsH1y2f0Cp7AGlo9r8h03M2/ENJGWDs2bix9sWoa79yf41?=
 =?us-ascii?Q?z6QpPgvtPS0CeuEy7T3kkXFNwBy97VBM/0mkornEOOGxuq23CMBMDB8po/69?=
 =?us-ascii?Q?Ld9Hx9E+BkkCeRcEv5ngSpXBVi8yiTqE8RReuanNa85m7RCIvAoqBNyqrgAb?=
 =?us-ascii?Q?KYypVxPVrvE/SzdXFDhcTG191WCRtQnvZhrlUt45atWVrtBLSUjJdSvlfdKA?=
 =?us-ascii?Q?fju+vrnz0LY+I5EU+vwcXrNFr+KzjTZqn9g5GmWypLfpTliOFcKr88T+nX9S?=
 =?us-ascii?Q?mEGDiAMo6nZy61S54XK3hGONl4UGxSF6nNyAEn1dUQjAjtMgzIJQreWQpHpY?=
 =?us-ascii?Q?yXAyFphqDWwqpqXSmFTO4HfqKZI28UdGHZYdVNt1V3N/yMPn9RmJZ/O7ZxSq?=
 =?us-ascii?Q?E2rcmNiWip4DUCiDcp1EZOT0t0RT8cdQiXjlM9gCAiwlv7DGNLmbGrkuhWiD?=
 =?us-ascii?Q?usfygcoGXl3gCXPTFBvvHwR3Ib7swqz0qtNe9bSnxrSeOBRtgNAN9N1ojqIx?=
 =?us-ascii?Q?rB5zezJJgspd4qKgrlBiSHgGqqeKV3J8owiOWt8j8xZVO2L2Vusubf+w702A?=
 =?us-ascii?Q?/svvhScea6U0YYgcLX23wULtgO4TXrokQQHqEWUXxE7Lg4cl/4paig0opYHN?=
 =?us-ascii?Q?KkAOK+qcWowrjhStJIIxQT2fRJw1kvIXJJ7ZIAtyCHkyYXoEV/zf9nfLq88E?=
 =?us-ascii?Q?m1gPVC4T4ibz6nwzrLUSN7Nw7uF95wJ9OtkciHzKs9BvD7Ka0wvNcPKIAd/t?=
 =?us-ascii?Q?5SpoxMK2s+qdO608/23OxYXoPlVdnCBA6nHwdGl9XOfrCA2GjQNB3oL51HqW?=
 =?us-ascii?Q?g4kynvDs/62bMOduQSvzDjBl7ZiGb3t2CXahqNBBVgL8tR+UeqEP6kby2+PD?=
 =?us-ascii?Q?1pDVqPRY1qvIk0c6BOg0xsi5SXTRuARIQaEzrY5nKgebNPsyW+anU/r+ydAc?=
 =?us-ascii?Q?kyQlLj84uEifTP2SU64KBh+piPI1MJk8s6tSW2+HdTf5MbBbhfyoIbqCAmIH?=
 =?us-ascii?Q?WDPwdy+dyrn6bB363vBEUl/m18nq5xhPNjE8tPoLOYGzbq2e4oLz5WWQzH5Q?=
 =?us-ascii?Q?dj0LJC/iaTFw1pcg66ohL+WtzTCQejNQyiYTxGq1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd272e14-2624-4af2-e9a1-08db198b72a3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 12:58:11.9737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5UIMYXswbnwX0DEk7DbTKuUCCPLJOYPMPYWP+kfo+SNV8vYazp9ohIO+lH/b7MJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5364
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 12:56:11PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 28, 2023 8:52 PM
> > 
> > On Tue, Feb 28, 2023 at 12:45:47PM +0000, Liu, Yi L wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, February 28, 2023 8:31 PM
> > > >
> > > > On Tue, Feb 28, 2023 at 06:58:38AM +0000, Liu, Yi L wrote:
> > > >
> > > > > Seems like pt_id is no more needed in the vfio_iommufd_bind()
> > > > > since it can get compat_ioas_id in the function itself. Cdev path
> > > > > never passes a pt_id to vfio_iommufd_bind() as its attach is done
> > > > > by separate ATTACH ioctl. Can we use the dev_id pointer to indicate
> > > > > if it needs to get the compat ioas and attach it?
> > > >
> > > > In this case you need to split the group code to also use the two step
> > > > attach and then the attach will take in the null pt_id.
> > >
> > > This seems to be the current way in this patch. Right? Group code passes
> > > a pt_id pointer to vfio_iommufd_bind(). While the cdev path just passes
> > > in a null pt_id pointer. Its attach is done later when user gives pt_id.
> > 
> > I mean actually explicitly call attach and remove the implicit attach
> > during bind flow entirely.
> 
> Okay, so I can wrap the iommufd_vfio_compat_ioas_id() and ops->attach_ioas
> in a helper for group code to do attach after bind_iommufd. This can avoid to
> moving the iommufd_vfio_compat_ioas_id() out of iommufd.c as your original
> remark.
> 
> Is this ok?

Yes, some 'attach compat' helper makes sense

Jason
