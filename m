Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD172558AD1
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 23:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiFWVgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 17:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWVgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 17:36:10 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CF54F1C8;
        Thu, 23 Jun 2022 14:36:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctDG4TLVSK0/ZGvH0oJ6ZA4LC55z624Sbz74mgn2nngrxMYWidxmVLMb9h9PM5TRIe1e+4vp9GDgc33Et1DaCqnB8z7UT1qpKAS0dZWQcKys1yf9tUbCk1G5eskMTPlPL/hpqebmOG5x89h4DB1nbMtWSdDjLvFx0HeZ9Qbv3uCFz1lJ4SXw3jQpjtytkRb5kxqbPXAJlymSXoBYCnSPr0EMmAfjo4c3JmLAlrZ2/8a4w/MBrGON2UYUJk2Sf1/A84Itms+6mg5oeFbpZRC8Gp3mnr3Gn/TDStukfPEeiayb01kDcd3hyzzfhfhbhGUUIl34p9HB/HJx0Wu7I2nA6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mb6MjAKdeO0q/QoiJBhQsMLNox1qPZTkRf+rlBYCDM=;
 b=M5cJ+U3/2W317FwkHUCnVLkBLN+1AHfSs94iOQpEj0vuk6IEeODqTh4kGj8JWvTeqv9EUjFP/lAq5y0sl/+VJ4pJjaeVfExz+spoyDb450imTG2Q6+cPPDOgwnEpVoa1DHmq7JDdi9qviumZ03RJOb2HsXbOm1QBRn7E+mT9Vn2VXQ1iUVldLE0mOYrp2hmQ+Cod/6c98Ej8E6oy3rTFARAzjYPKzzOlKMvMI1cAuYgsJxlf3+dKwg2gMIISbUapBjpgzy2zMBne2+3R3Uw4q99loyY1iDlDPlgJaCisN3Nfq+C/bmrvRmsRAc7+q4PF3tK8LGoD1rwAdmJU5rSEqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mb6MjAKdeO0q/QoiJBhQsMLNox1qPZTkRf+rlBYCDM=;
 b=m4YV3uNtF9dk/0y15K1KyhkrfBh2MzdC4826kzw2vLsuJojRM69e8WyPf5RAseWi43RxNkiT9/evqceW9f3GEpP42BZQU/V2mv11EQft+xuFJfKh/sUlU+4wXd1teE0qT8zcoNhjF5k9pGC3uvlitJ+UlLcgogHnyUSFHucUbORmq/b1abUPH2CFPkda7fZn0CBLzzbcF14ciJhUoawsJ9qRX2Gm4GiO2WWvVemfEvPvhcFGMMJGAHPPXsuMyArsLw/GQGuUumWVUoPloQZPfcErmAaknOeGNMGi8lsGvqhqLhizYdmUiP7ZZKEhUCmU/e4KSK8xDvSQXDt9FcOg9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3914.namprd12.prod.outlook.com (2603:10b6:5:1c9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Thu, 23 Jun
 2022 21:36:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 21:36:07 +0000
Date:   Thu, 23 Jun 2022 18:36:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 11/13] vfio/mdev: consolidate all the available_instance
 sysfs into the core code
Message-ID: <20220623213606.GF38911@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-12-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614045428.278494-12-hch@lst.de>
X-ClientProxiedBy: BL1PR13CA0079.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::24) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd814d61-fd82-4d73-139d-08da556061f1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3914:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nq88JGEAacFRnk6dhxFd3HzsYD95oO7HZZyWymumeOHettNgVwjmL5Ni8sYTmjmRCfo6KjxxMZuq4hZVvxh6NrFMBsPpF4tA/92yuv8OVOfC6+2EvG2DYlygQo25+gagRNSNHAGgRbOR8tLdCTQ4mYwZuJUpYVRCKQcc7n/SzZCzuJtnHURRd0MPzCSC8BEis90rmhO7sD8dK9i+ogXHZGghABWooTb0o61HFlMzthT7iHUSkn1C1n1sZgBlOwtOyg6L28Ibzppkfe8n/8l8W98IztP0nQ22fKsAnTBu24BvEBGwZdlgqpk76Ee0DoCm0PshrVdcyK8CWi+6FmTknWhFRjL6DJpcAWlIo0VciCFwFf1pNMa/bdOpzhLJpgUZbZav++UcJxCH1h0zJpmJLawhitr0SuStr7GgiJfzcDQG2bUry598cXYRpS23VJ3MTOGQ7ynx4t3HsyhVMJ5NzStGhuPnZK5mjobvRvm7dyOjo9JilUkP/wdqpdfObEZJ+m8cx7bDfzxoIE7K90auaHqbe6xpK9WUVDcpeWIqzm0ybRfLk8XsEERUhYnVpSx3Z4dpChi6ll/XdVsms8rGw2kJgLtjwvxtj5QJ1YYUoNn32iWqApr1Dn7a9dcQOFXPy1mCZTokf+a4OJ+Z9o1ghV3ZKCFJAJCTBZvnnulu5yoNIjXZg14XU3OU5ImTW8wzQsVBQCEFcSNaJdGxmH0NTxd+LP3zq1ORYrR/L1eUpEp1sprTeO7zfSirN1LgobJM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(2616005)(7416002)(2906002)(186003)(26005)(66946007)(6506007)(6512007)(1076003)(41300700001)(478600001)(6486002)(5660300002)(4744005)(83380400001)(6916009)(8936002)(66476007)(36756003)(54906003)(8676002)(316002)(38100700002)(66556008)(86362001)(33656002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aWiwgPQHcR2uVY2j64zMiVqndOQZjg039KByABL5SXM2jQ6XHqGOajkpnWTa?=
 =?us-ascii?Q?oPB9TxfCm7z1P00b6RxN0iI3vE5zvTGZtAuh3aoY6nyn7+yG21BcWG8gPibI?=
 =?us-ascii?Q?5HU445g85I0cLwnw+zp8c7ZVfdmXT+dss4R7crx84kDsAA94KY/lykRSXRsg?=
 =?us-ascii?Q?MLVZyvFBjOnrSth+8bav1Vm57o7ykgcBoYFfN+0hXzrwpKZe3hWfnZcc+lqA?=
 =?us-ascii?Q?1egHe/6vtThM5IS6tav5wifwISG0RM2z8ZhW9euonNth7qUOKMnHWFzyzFxq?=
 =?us-ascii?Q?+sKkDhcXymeHzu0FNWeYk/zliXvfJ8b80jKF3lExN8L9NrwBD231EdE/Ojwi?=
 =?us-ascii?Q?Zfi6q+ehAgGWk6tCRggY8Oani0pK13XKErvRaEIQzpyFQh87rvvHUR5Q6t5f?=
 =?us-ascii?Q?dPAncwb/q9rU4asbfsC7fBEtgdopcEng6rNId43ayKzW0u7aIG3wWkhn5x5l?=
 =?us-ascii?Q?/zVVUivR777rVQLod351H1TCEq8UjccKpTgb+83NY/QArSvuiLlQRv+iT/Yk?=
 =?us-ascii?Q?yOUfO8d2hhpZdC81Ozr837wW0+k0t+gy+K8mXKMIhLlyMTVP8S7hmP1TK51q?=
 =?us-ascii?Q?37Qe0Eh0Dsh8CqrkEEcN+zqCZSoD+NHW56xOfXfwPMvK5cK7xENjXXaHAtVM?=
 =?us-ascii?Q?A9ggkHVcsVtZF6M5NXsIvn51EBS7oNQqNqX7TJWC98+rs8p2ZXHH5hYOhHuu?=
 =?us-ascii?Q?5cljM7O4Atw7pYI5ZwLt9urQTiQDDop/mhiHrqpQZxw4Ic0/dywJH7JSFEba?=
 =?us-ascii?Q?SXpoJR8j41NV4ppXzhsTMZiLvrzSxp8twv2G15TMkGrCVT4P6KRmX92aZtAz?=
 =?us-ascii?Q?SpdtHwcytB7y301sNYRt3vkAIUj4UGQhrHkZeNURTC473+7TzxoKN0Hn2L0J?=
 =?us-ascii?Q?pFZII+bn1qO91Jt7c2rJ4SKFwMUTZ3D44h+PP/z25LKBJ7YYxqEhiJ86l+QK?=
 =?us-ascii?Q?2UTNZmTPhRFLaRvUCr2p9vkur2zKz5Bsl7ZW7eLr9AN3aJ9yhtvthD1ZV8M7?=
 =?us-ascii?Q?MtV0wX1ltdrBsmEvUOEglZyZgAxU/eqdsrgZ8EM9rWEqYuVD7Ws4a6WWbxFa?=
 =?us-ascii?Q?KdkisapwThK3D2Lg+WSCc/UDhkez97wmaDtubHsPi05/7Aj82I0f+CEG+dr9?=
 =?us-ascii?Q?t5+/aoSI3l3KkivL3uOvbyCW91M29DyqhcuJny9zq3clpIohuqHRaNYTOI7R?=
 =?us-ascii?Q?WesZCyV1nmxTlr6BMAIR7/P2fl4ws9Zzx5pyY7oBO6OCYpTaWk5T9UFOuTRD?=
 =?us-ascii?Q?YxQOZRNrdb9vJDcEnc9M3/bfrAXWbSU4h9JltZGoKAmn8pqr1sk7BonVMN1m?=
 =?us-ascii?Q?1kdNjmyhEpn4ErALNgXyUYPoSq3DKpQ9vwGOH+eciHdOc/aSqDfua2jCeLTE?=
 =?us-ascii?Q?lmpNNNimpNF/MZghLNVZXsiOhkraUg3r/sq/wBvox1SPvoKc7MbAzZI9Pp03?=
 =?us-ascii?Q?NH3jH5Mf2faxIfkgmIUoJXnk+YpEttYkwsxKipvMAn+jz1H0eGVMQowqS0+E?=
 =?us-ascii?Q?6B2IZlbUSDiM+6omhHh6uFMD4qRKYBtd23clBcfTJjK0cQWaQOJsFbdP4m8A?=
 =?us-ascii?Q?CG8DYeZQuUNvjX/Ro377w9RFDu53tZOIan78wP4b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd814d61-fd82-4d73-139d-08da556061f1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 21:36:07.6631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gf00F2nlSS9VWEE0J9ghsoAHnK15KYMVqmyHpcvSMFLk7x0cfZUDRZObVuT8EOi0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3914
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 06:54:26AM +0200, Christoph Hellwig wrote:
> Every driver just print a number, simply add a method to the mdev_driver
> to return it and provide a standard sysfs show function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       |  3 +-
>  drivers/gpu/drm/i915/gvt/gvt.h                |  1 -
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 34 +++++++++-----
>  drivers/gpu/drm/i915/gvt/vgpu.c               | 44 ++-----------------
>  drivers/s390/cio/vfio_ccw_ops.c               | 14 ++----
>  drivers/s390/crypto/vfio_ap_ops.c             | 16 ++-----
>  drivers/vfio/mdev/mdev_sysfs.c                | 11 +++++
>  include/linux/mdev.h                          |  2 +
>  samples/vfio-mdev/mbochs.c                    | 10 ++---
>  samples/vfio-mdev/mdpy.c                      |  9 ++--
>  samples/vfio-mdev/mtty.c                      | 16 ++-----
>  11 files changed, 55 insertions(+), 105 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
