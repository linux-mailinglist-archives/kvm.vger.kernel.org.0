Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6A86A59F9
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 14:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjB1NZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 08:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjB1NZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 08:25:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022132A16E;
        Tue, 28 Feb 2023 05:25:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFtxU0cz56lbkIcJVUhuv8qRPJjcSJ6f7e9v1MFgEPVszKK5gY7/zGaNKiI8XkDCpeQ9wOWe0jlNQOGPC8gndKtFx+rkeRKJEm8bt3sjtAuulowUyQVIcUhSDRm254Za58tMAWvEhhwKXRsd16TBlgMUdJTyu0dYegC5MWdxR2ceXAwrNSvZ6ofkDs03sPAoAvpN2YA+zlX+U+Dv3AFOrn+UA27NHxzOOk2xgmBvuSk+HSt0LBrDY6tbzmmeljAPFvHpfSXiurT6Bz06i3TaWPX83U9fB/sutMkYD4ircR86kR10ymx4fuNchh4mgnQqB/Q8A3BdmIQogKmfeuxuVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awQfOCT+S1lAskzXDPt2tPWt9/tQMdVlbE2/tkpQ9Ho=;
 b=DsOVqr/gZfzzivxE7RnTVZhq0kuB0wc8yAkE355nbFAdJM1xhQufsYp8w/4qg/2/aFn89Q0iLpXvSge87iP7iCZTwhXIfJZO2KhiYXYa0967086EyEAMqa46K+tTVGOb9c4IqzNeSiKSKzYVsJxMK5phQsDWS0tcgqDeJpmgOqfuViLmPBQhRtM4p9KeIZgkS8uqgUqirFlSLU9KtCSr3r116/fvg8fAI2u6p6+akX0lzaZGeRUmyJpWEgEVngtZg34d5qtCrTIpMf8r39aUCxznsve+uvaJseLDiWRn95oGbjNRfN26kAPJ7WzNzkhLI93pp+nzXWZc3r0/216ZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awQfOCT+S1lAskzXDPt2tPWt9/tQMdVlbE2/tkpQ9Ho=;
 b=dnj6YquWDF96XEqHsnux+DMlHi1Cj4b59qvyxUzDAJCqxa3sjkD9zaftQ2MF89xV9AvCRsV33DfQwIvMp1WkBayZ6zSubq+FHOd4B7X6d95dytSZy6lNz5ZjA5+CS8DTtKvrbIBZiS7sySQOEzs0scxVXvKxybsE1UbMt9gjCGdpvd5YQ0d6Fa0nSokc7lEK4FhtftvBTIXDCvB14wWQQ89hKtqUtYbn56NhQBrpVq2i041YQNp4YlTsKQSuJw8SfuX5uEaCG/y4KwWmBurT4BZUP7hKLqoBm386FZSaz8YNtAwRqbtqNBQA3CBp30+izUa0bRZiM3mU+k5Kx8Ylzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4264.namprd12.prod.outlook.com (2603:10b6:610:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 13:25:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 13:25:34 +0000
Date:   Tue, 28 Feb 2023 09:25:32 -0400
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
Subject: Re: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Message-ID: <Y/4AzJbjeR4R2rcO@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-18-yi.l.liu@intel.com>
 <Y/z400uzn7Nk0CXe@nvidia.com>
 <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ZTi69p9cCuPn@nvidia.com>
 <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:208:c0::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4264:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb2c386-28e6-4349-9c73-08db198f456a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DRzpsstC1o3s2QGW5Mlzyobf1xNdwiytVsku1YEkLYZZQOL2EiSrPTxdojPsuK5GMDJom4ed5TsQUgt8NC3DDPDH1GzFU0XNKJcUMrQFzvy0ujh/qjNDkVnDD244FwaY04KmryRqPgibbAjvfweT6FLC1Zr1ZIAkCNvPTyI4v1ylAc2z2/1MBD6dQ83fwavikuToQ7CNeBUu/Qf4N2l8yHUvDuZJOiOklxmffJ5zmMwIhbv5JI/aWhdLT9XkPadt1TiPDEwG+bg6UQdP/0lyTlHy8EH4J4cJQmYXlNN2s9RUubuKLorsa1Ho1oOLw3t1XcmrVDspspDDtPcJIC97gISwFOiBwGyl6fttCrulV5AW32wAgbPpLILEANd90i/f+QUsuILFCRex1ksWjxsEGX30pzSnmFYiTD0rGt1NGypzkE+dgrNok2tZWUGJ0pGL9usqhBh+H8Sb4THI5N3g08qCqpQZoFqqMtaCsrjTffAiloikpeKCQUTUPjiNasdUFwNeFxB9peA02GAwTcmq5ovqNdaSTE7iykyBwMy02jDEGCPQrr/ggzEH+Vidg1sSHZyru3dan6YWF4dc7AdzGlv25AjaRUVWzsU/WxWOaoUY1anHbeYaOdN5oVzVjsIA23K3nCPVLKjKrJ0cZfgvWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199018)(86362001)(36756003)(41300700001)(66946007)(66556008)(66476007)(7416002)(8936002)(5660300002)(4326008)(8676002)(2906002)(4744005)(6916009)(38100700002)(6486002)(478600001)(54906003)(316002)(2616005)(186003)(26005)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?At0L05gF9cSzqlVldQ8/CVLyG0/GLzeELTO5cR9Fu0mZpm/mrd7rSl6g/Nb9?=
 =?us-ascii?Q?Ktb5XCMAS9sYPeBT5rpWW4js/plT9jbS8fRt/TY0ilEM0wCsUOc9yfy+l9aK?=
 =?us-ascii?Q?0gTe5eIyldtChUghSuH+YJKYBR6lNMLrTud7h8DG2dd9pfStl0yFveAWwvgg?=
 =?us-ascii?Q?C5WmaIDdGlUd4EHdNLGxIEqjcWyUPB2i85hWI+NhelmiQhVm8vNlEfz9Ztn4?=
 =?us-ascii?Q?GGnb95alS/esSEvGQ1piKPlVSLiW5Tv1EHVwrkogk6EVcTZfYkOuNRi1u9Ew?=
 =?us-ascii?Q?zs9m0owQwEW8cYCT+/gE3b895CmCFGbktCOpJcI4SjFaCIFvsM2GhIxcC3lz?=
 =?us-ascii?Q?eZtieWChYoDtMNrem687YNkuOqNR08EQYh7KS7wEyUNtQi2lQKJt1MWZ6bxs?=
 =?us-ascii?Q?LkIRLMvLhgfIaUXioT5E9xKPfnZxP42qQR/7Nba0a3BJtmS08CIZDvDPHx/1?=
 =?us-ascii?Q?Jo/OjsPUrEr59LioKCww/37b/L44k+bmNaCkppZhVCj8aCeY5a2tr2Q2vqOX?=
 =?us-ascii?Q?9iIqcmFbeYoaFNoED+D4eJbmKlT/XmaO4oPrXx0wOXuHXHH1e4JN6DFoSrH1?=
 =?us-ascii?Q?7W2LKO3mA1XxSh5Y91q7JUzwPsMuyT3MyhI4YDq9mOqibjTOHnem6O527mz/?=
 =?us-ascii?Q?QpIEyttHVpWA8VG6j7IEO6UUHdm7A8WV8yqeeNY8SVYV9HW6yA2oiATPbWGO?=
 =?us-ascii?Q?eoxgOWGne5QytCqcFa1TaDG8QPcscUu2keMP3BBxhmDHnZoT3LWHVQYvSduP?=
 =?us-ascii?Q?ioccijCnxGBUrSPLwgMdJvKx4wipmPU+1y5PE+35Wrpyc5dBaw9xqqNhoQ8x?=
 =?us-ascii?Q?UcXJ2fqeqAwcGeKtJ/Cr4ei5Ec1uAtW7MJN1eQwti2aw8FFyGJq1JpZVOcws?=
 =?us-ascii?Q?Vi8EIOTxh5k+M1VloYcDCnaNUxyPniGiAmLt+Nzdd/S2TE0WmXgjM7KM/dva?=
 =?us-ascii?Q?/ZzLA4pfCKEaRoHUycnitNEfpynIbGxiWqy7OWWwlIF0NPK0qZrNiM5+8PFu?=
 =?us-ascii?Q?9sDCsHFlc518qNyrrFcTB/UEnC+7fEDdMkl0hZ7rMj+YIN2SFQZqqjEeWTnv?=
 =?us-ascii?Q?7c//ZNnb56lYhKvndkY/aKu9czzMlOKA7MiqoKlStLS8CO0dRjgxJ22Q3Ujf?=
 =?us-ascii?Q?lO5kwDjzN9Y/O3hErJTQ3kCj7Cyqaa6jek1an/sBKgx0mFnu/YL0Vyuw/kRI?=
 =?us-ascii?Q?JBDSbo2A6YjvyVFKIHBQQUqmckhAAOylsBtL0XxBXBsOdTD/cSOUh+kyX1HV?=
 =?us-ascii?Q?pBilUVRj3I5Vs+kcA1AO6ta664grY+k8UfSWZMUGULf0cwjfUc3T+2bC//3w?=
 =?us-ascii?Q?HaeFkmDlHJEKm3hc7gvWo2W8IswTkeE/jvhN2dPdvzl8C1+6Q2jvI+cPl8f4?=
 =?us-ascii?Q?PGgZXFRQ9rXQYEnhQXrB66SnFclVhGCBBRgzm9qFqEZRt/OlUF011zdkXHym?=
 =?us-ascii?Q?OIXUSj4OnqWjLCTUv81abCgC9eTWAA4omW14UCSwx55CvJkkPm3+MNEAH7vM?=
 =?us-ascii?Q?QUve6ViwurR5J3s9Nufzzbgne5z34/M8B58s8nbz9ZqSNZJUzZYqjoOoXtgp?=
 =?us-ascii?Q?ozrvt0IULYQs89AsB4DnifapTBrP7tx9Xey2qlbB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb2c386-28e6-4349-9c73-08db198f456a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 13:25:34.0876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F1Vz/FbQ3sf0BFTy2su+MV6ScPl3ZBXcGq/aXBi0IudC6N6Yh19JuK9pcUJqX4mv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4264
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 01:22:50PM +0000, Liu, Yi L wrote:

> > A null iommufd pointer and a bound df flag is sufficient to see that
> > it is compat mode.
> 
> Hope df->is_cdev_device suits your expectation.:-) The code will look
> like below:

Yes, this is better.. However I'd suggest 'uses_container' as it is
clearer what the special case is

Jason
