Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AF853BE6F
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238378AbiFBTLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238423AbiFBTLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:11:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8C4E6C;
        Thu,  2 Jun 2022 12:11:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzdiz8cvPlP0WUA+F9/HVt38b1/bjAxT+2+M7lnfO02BoWuDYSVezT8M5X/pYmx1k+mP5CkxACGfEExqvazKlKNxt6qolIcULcrLTcWrdhnF2B/yz6rWyQ8zj5WHGzGLR4R7NpldfI3HudwKh2L6K3JRfsu3pzuhG30eAX+xkgPiCLWh800ydxokZA3IPcgx7gi3+MsWfEQhubtIpCKPrV/HA8GGxBGYq6eCjofkuTdrA3OomPEl/IrWcaNM8dKlrwKWZI3O5eDNrQbZWUXMTBBwEvq9EQnFHlvRIqn/d6rK8e4ZxHo/JianBh7juZ00C/UXbB3h03KUCdlQlRFOfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfFIkZy/5N9Vs14l9tQ0D6k0ZOZcm3PnuCCp1Tfm1Vg=;
 b=gTcIvcdw8VGVA6T5TV62IsrlGHegY5jBifCM6cY7acsNQwVQtecvegLDsEc+OsH+siIN9vY33RwjMTq44IKabt2KxQYTOWlzBDobgzdaWfFUnw9Op6kiY87LzQlxM5IAW0VDCUvOzYlx2B4acgEz26CUxqY4XIGuAEosEOhqTy9jxbgIjYjC+3o1Yvpr+gDKcw/pOtMFjdw/wROd6DdLsSuH5kP+Yistw3TF9NijL4p3JsQm5DAfYq39g/J2oLhNf9RQtHEniwWtkdwdj6TQTSKoUxHkyUTneOZPe+l2Tc80/tvbXRlpZDM950rOWPvtYLP2TIqyeCGWwBHUfE+Diw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfFIkZy/5N9Vs14l9tQ0D6k0ZOZcm3PnuCCp1Tfm1Vg=;
 b=fYZjywiVJ9pp0/tEY/74LuSHQY32wfVDre3/BFd01B/BqjsNKTYQ8pDF3O+FyMKfsdllZLNGyyl1UGIHV019JI8xcm+BXUXnNGct5C8KBqn3gDm9vYn8ft7baUWjNlc9bYaRNUmo5g3fzcpaJQgD1fwSsYiiQ7zZVrELKOR7M/UeQ6Mrha7gyVU+vwU4oQNbx7n3DztBGC+PtJBf+ibhWQhLZcXvyVnCfKNT7eEvnn0sprNC0RQ+KzURlBpXKlF7AaWStikFJ/os/i35t/3+U7frDyShi2Ih3n04ZbEcrCrkDURNYX7FClq3JVB76muMZB07b4Y8w6fdsRm27y4TuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB2467.namprd12.prod.outlook.com (2603:10b6:207:4c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 19:11:16 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:11:16 +0000
Date:   Thu, 2 Jun 2022 16:11:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 11/18] vfio/ccw: Refactor vfio_ccw_mdev_reset
Message-ID: <20220602191115.GH3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-12-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-12-farman@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0129.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6efddb4-137d-40b1-fa45-08da44cbab0b
X-MS-TrafficTypeDiagnostic: BL0PR12MB2467:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2467BFEF6D1CEB73D06B0008C2DE9@BL0PR12MB2467.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jy3a+wMINMIFY7O+rQxsDkbvCYERu2xV+l4zBrTAgKbcVL9hsAopiDqagf8WyE5Pb9X+Yn/UOZGM1Bw00n/ddVv4T89xqxRxUWPDjcWgRn8ohZZFfBchJ9D/F9V8reoxpck1AO+Q5u73AHSMs6UnZkwhWyQnHit8we+StkG35PAkABRnYn0i7WDBt0UXTCbE2NsOvTQimlb0uWsDfLqZLaeKS4Jw71vLsV3IZb1KjUMQ/eKABf0iHcB1AH67zamm4+byWSUKn8GQT7MUR3YbtlfgMCl2hkOTttjeSihrj40jvuUBjnGTu8fgusEi9XvyPAVIcRRbQ374jw2QXN2yQWZAZgqrjBNTDMrv7xsypn1KiAqqAWGebxoPGxIP6YCXOOIP52OTL0oZ+ugodSr0VviYJw1pkC8DfZfJv0zBTXbAuc+0thrv2w6Sz4NxNnr8DdI3bDr95NuEV+GTfkZzfAfknLlJXG3WbQY5ybkfsdJC3JD8QOTCAWPbMwGF202s+0Ogu/ifi4PewyOyKckD3IJGoM2RD2pk1JYI8hUg2tmD6fMeriIGyPfdksRe7PyoZJIdPjFjY8bPU8dSrSzUCRCTqwh+aTSLUu669ePa1r/XP8BNkEzK4mAFMUpDhXJltXEwJA7f6lLIiYfP55r2Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(26005)(83380400001)(6916009)(6512007)(186003)(6506007)(86362001)(36756003)(316002)(508600001)(38100700002)(33656002)(8676002)(66476007)(4326008)(2616005)(66946007)(5660300002)(66556008)(4744005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ZPGxv4cyDI2VK0nGum0iYK+ST3dxMpxRaAQAspazliyCUWNZuzMzo7h77bJ?=
 =?us-ascii?Q?z7PeocS1VTH8wM45WIap0xmvC7O6K1T0fpR7Cb7p0HK4XrE/vhCgGIC68L8T?=
 =?us-ascii?Q?hgYxFc10/ZlHoYLI6v4VZxwkO0pf8o/UCKW3msyucf9hOoYd2qD2Ufd0mpVX?=
 =?us-ascii?Q?0ae7FHD4c11Z5olt7qQ2z2lF3BtEYLZWBko5GoIAvfFThb1WxKIzq1umZRMH?=
 =?us-ascii?Q?0/D2bI6W0I+/QeOH30vbv+/uN4jO1GKo1Ud3+oN2j522yuV65WFRaahZ8Zzo?=
 =?us-ascii?Q?TEpga4EkK1y8+BNmKZl7bBevFheG5/QaPLXNonNl1CN9EwxM6c3bTOov3NWe?=
 =?us-ascii?Q?aUPZaZGOrFMq3HiM6lh3nwUcJE1EOWElkh1XYmnUjTiz6elw2eEz6f1EBCYr?=
 =?us-ascii?Q?DMKgfLHwEtmBgNLgdyEjPCD9Yh2Q7g7QHMh78bB2MQVQefZWKBibCssi5QZ9?=
 =?us-ascii?Q?5a5Uws+uk5uQ0FBQpYwnnuYHz51wOdBbXQ/8UzBifkg0tfxm7cqblQ5Pslxw?=
 =?us-ascii?Q?A5s7rGFO4SKZ6uEDPABbcgpNq3YTonD4KmLGhSTttQixJoBvx20QZ2kv/blS?=
 =?us-ascii?Q?DD+tW268nYwm8kqtMRyXFA8WH9hG9CXM9weboncNSojA2YN1P2rShCPU4Plb?=
 =?us-ascii?Q?mAhpJTAbob6HG0fzxzH7UW8TdYK2kMh7w8q57UWMG1gqajMsDE7Go/6mnhsT?=
 =?us-ascii?Q?/hb8+w3oVkYtmKh4+AxEIdU4MeKChNpzvKckwRgQLRWR2Z1rCiEzhncO0oiR?=
 =?us-ascii?Q?83cc8V7acjt+L3j6SzT3DwgAo/H/c93v9g/LxhaCxNL1oSVXL7hz9os7MQMi?=
 =?us-ascii?Q?3UYQtLBF0JYLTSeskw0KCK8zXgpztTS69n+l1q5F/JVZo7sae8rctNGF6c2y?=
 =?us-ascii?Q?KXZz12dAqBL0Lrnoh1eTnhyAebcijt/8J/5CQkiMZGCo2Fa2D1Y6p21cihme?=
 =?us-ascii?Q?vzBTRcXNAlpB6eto6ZTs1ACSQ0bJ6ZnTMXnpk8xFdiKPSbZddsfAzJKVktGt?=
 =?us-ascii?Q?0aQtA1rKuMaN7WIDVLeRaLTMkFNB5iY8rplzbecxbI/fSD19lDRawx9PSzcU?=
 =?us-ascii?Q?19D/fEBRSKO9+ycZbUfRVNQnyGkgMfCy9+mSAzBIT0P8vhXyzjNJGcLz9dyK?=
 =?us-ascii?Q?q1IKsioUWCDiX6gQBBYPbybXoqmIX6dYFM49CHSgvYDB8/neRBNIO+dq1iuA?=
 =?us-ascii?Q?+PEohEYSslGcfmu8fybJ9mtFO88eVByDQBaksJrqg84STVJJejO9wVDp0IND?=
 =?us-ascii?Q?f1wtH0xf3oOVkVFtIJSlUhoalu9//QXQOrApySM5NG9fbqbES3CusqYVyk2i?=
 =?us-ascii?Q?2YNyu3Pf6OXoToqT2zW31kH8XP0hjJJGaaHmJHXluDSLDma2t1pPc7JUjoYB?=
 =?us-ascii?Q?2lQtXFS+SCJMd5kQONp7hXNqomY5xoTcNmAQZb8wFsi0gbRv/pb2s2LTVexN?=
 =?us-ascii?Q?d/f6/4C8FwNdBKepjcqa1pHVYGTa5CS5q8DMLbyv3SGXF+yug/hBdOz+4Maq?=
 =?us-ascii?Q?lhG0GhYZGHZU7XbQ9ZRJ34zA/5xQ9S1IYlWqBzH+teNl43/US6SkzHAMsp31?=
 =?us-ascii?Q?4OIqxQkAU+SA+flUR+iD0yBg9LG0mohKGL9U4NV040nUy+iHDNM1oa7gy3li?=
 =?us-ascii?Q?jBV/XreJhm/LGPv77aldcg2xP0HGNFedTKwPPqzWzpXM5GVJJhrNgujZwbdK?=
 =?us-ascii?Q?ElGhi+PrVgJXBSVqCmWi22kv2OEJHlNRenPot69hIftCFVmzlmcHp+/ynrh4?=
 =?us-ascii?Q?6n6f9v6YFw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6efddb4-137d-40b1-fa45-08da44cbab0b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:11:16.6022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HckTTUKeTFVtYYFXM7fx0TAHw6BYFLpumGhWlMg+LRZJNoZeLx86hbsmpTbJsFwM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2467
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:41PM +0200, Eric Farman wrote:
> Use both the FSM Close and Open events when resetting an mdev,
> rather than making a separate call to cio_enable_subchannel().
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_ops.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
