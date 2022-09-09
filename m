Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1805B3CE5
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 18:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiIIQYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 12:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIIQYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 12:24:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082D9135D7B
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 09:24:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrTdKRboYmyXK5aeGV3j5eT/VNPJ2Z7F92T8QlsjTH14ZS2BQhgs3BhVHTYZbLa26qXRIRMCrDVvwflv2Q+e6E1uyMbArAeReZ34gPgmKUiXwGWF+oMKXOpmxQzI9qOnBZaO+4HB3/Y7eJSePzD/es5g+R5oIe7up5tXTnI4OZ9y4zlU0ZvuQQwHl0cHg5f9gfGN3RDUQ//+KYUh5u0lL1ybvBXB239NSI0Q8wdkK8jA6Bm5cJ6hjK/i5wVrIvJ1D5hvOm/Xj2FSo366JJBykzcXPr948FfR6zU6oy9Lx/ILjfbfeN/7NAY4kGb/aMgglVmbEUiIVC9w2mGjEoQWWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9pdnXTB55qgItnz+cP1/A37AhyjsICURGUhhhHVB42w=;
 b=SuRYUS84JzUwrNrmNpEZ4/RVmF+4PxHpApYLGYrNkFo5+zzLH4bcd8VJC3RmguxmUutI33XVETjwn/7wjxx/whznMjNQzegXT23+rdQS/S3eCRYM5PmHE0Ngsz2TAjasa8m5GcBn9I18wXxuCTKQoJp/67VTxNatlQtZlukHb0PzG3FJEz+kKpickMBAimsIpUo+Eal5xmqGqB7DaBXp3D9BKlHE/35aqkV23cnlkm8vTeLBehPogUR5440up/dkjvrRifzWfFckFgd5H2NYRhzpt8wkQgiGSJ+R9JDDrxqaxBXlqLqx3EKtKITXkjxeEuhnukfRhc6Evd3zLEPTcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9pdnXTB55qgItnz+cP1/A37AhyjsICURGUhhhHVB42w=;
 b=PSazGf8XCfAX+OPL6mg0t54M1hu3uVpzwYgmgxvy3sZcQyGNZ9NoOQwiZhTYvCbcW1VkT4jQBKctdia7pCScW667XlWMZlJ/zl834PORiLdABemaq3Af8VYQDO7kD9xmhEoJKHshPG6egBwlpbZOENFTekj/UMCYJ4SYBJJuVd9PG+JUPlzZ5hcfprGOowl29iKLQwNhmlInsjV2uuW5R4r3pawQSOQuUI3Z4wkDSXQX+8tmgOhPOVwoxHWw9rBQDkw6zV8uMk8LtqDU1Gi4udNz2Y4v0zRHgiIAFjmtoFBLaOCNFbGxWvDUJy/nH6SKyASfuS+McLfylSuwcsx3rg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS0PR12MB6533.namprd12.prod.outlook.com (2603:10b6:8:c2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Fri, 9 Sep
 2022 16:24:16 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 16:24:16 +0000
Date:   Fri, 9 Sep 2022 13:24:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 0/4] Fix splats releated to using the iommu_group after
 destroying devices
Message-ID: <Yxtor2eUxbHSZQgi@nvidia.com>
References: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <28f45073-0047-3f8a-c79f-6dd6cc1d4117@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f45073-0047-3f8a-c79f-6dd6cc1d4117@linux.ibm.com>
X-ClientProxiedBy: MN2PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:208:e8::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DS0PR12MB6533:EE_
X-MS-Office365-Filtering-Correlation-Id: 772fdb45-c216-4aa2-468a-08da927fbd2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IpqYmnfVx60SUqyEYVqPiX6GEMxtXITo+hA40dkvUnRbiXKbn8gFtjCAwyWWsxMLjf8C9keQR+i+anuKjUTEsWMFpZNj6Lb4CN7EpyBuciproSeQ+UxYwZ/YQOkNefjLnB7GGX5fzk9vIQWsxEQsLc8uKeT3LRgLfIkC6AEr/pP5c9GZ50fRzuWabe2E3FwwHZTqWDwG1EMYp+q+BHMvQ0drQbYm9bOJ0761IChEpglgtnWcujXsBJpzdj0F7umdbW5KKWG0XUp/9UycNSx+CFJfrPgf0PXa6wzxk6iZmlp1/umDxGUPM1kXIQBLsr0Yj0npCPJa4qSjzVuLhJdbYhYkwQe9VapN9Q+xqxciFiQBEFe7hDrO8TMIe2jcAjI71vz2j4e39MtFc/SwS5ZE838epz7QJ8ZAaCCDRX+GON4Rxp272GOILuH8APpyv/+2Bkb0+Rrr6XyORRr/KV6a4iCWrFr4ZiNPaJWzzmKxZ0UaTPM2bcqBb7jZ/uy7ydwc3v9AkClfFpAyK26N5FiH/oqTMgE/6+FzzO3kJS+58qsZAbnUND01VIvpK1Q9e8V0WxxcHRZuyPWUJTS68Itg2goZBH7cG4jXisU8m3eauYqHllCe3NtZVrS0uibTm10gismhu3WVZnCQEtSPbpVRZKQy/gH17bIWg+3gd4soLLYqy4q/By8pyLYI3WeHSqKfjR3orOVyv3bzEYLCX/WihxJs8a9zLXkRe58NfOqmyW2m1wVGPs4ZHW0dWvU4y+Fymh+4dIiwlMFzs8RHkOc111O/3AgZLfTEaT39Ax8ENnQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(316002)(2616005)(66476007)(6486002)(6916009)(966005)(66556008)(8676002)(54906003)(36756003)(4326008)(186003)(6506007)(6512007)(2906002)(26005)(7416002)(86362001)(508600001)(53546011)(5660300002)(66946007)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?022fYF2dexu/QgaakPQHgBMFQZFghAqpuyNmleADAjT/+xatFil6t6xrhLw2?=
 =?us-ascii?Q?TvmipqT/PY6Om/YRh/FThka9/fFuILrzHY5yU3TSNkj8wTZAlQ5TXz7QmfgQ?=
 =?us-ascii?Q?rkxiOH/X9Cq+4zoKH89nROxw2soRMJzjgtQhqV4/h6UjRjPOin0Okhbbnvqu?=
 =?us-ascii?Q?knsjGWWg33YBAnTCvzejqso5dkQ+E1yobCLIyC0yvpvgHBtWbzRJmZEyLXf4?=
 =?us-ascii?Q?3n24WrXQr7DSIZSX9swGWJzetCya7TEvlsuKU/dRwpU4/n5qilJrPFbO4ah5?=
 =?us-ascii?Q?nKJiDhD+K77koct+LBo+YPgLFzUjRslNwzH5kRQCf+qkHWfRiSK/i/gBsu3h?=
 =?us-ascii?Q?PAGQk6w7s3xNtvrlOmBp9vKDaQOf89d/CtL/tVEmP/VxObbkaWH3cQjzsL8u?=
 =?us-ascii?Q?JuXp0CEfcogFA6lWLmCsGQlFhh7B4aQ2Pw/SkEljUpv2UqoLQLIwrarRsTeQ?=
 =?us-ascii?Q?Bo/18RwO2AAAuC8xftAIftCZbBdzQLYbt0rxwfPGI+23XSUBOTrJ5TJ+0AKJ?=
 =?us-ascii?Q?MTBvwTqt+8hR68dlkvEwDVvErLMvGdL4J/bNwB6G7gTCIbkgub0YoPTPtENs?=
 =?us-ascii?Q?bz2t73lXHQ/RoR1uOPwpSNF6pN+kl/GNzsm/yk9RoWTFOqVbi6N3zVQlw8Np?=
 =?us-ascii?Q?QZlbfAYTIAkCKx9qG/l66Ap6Rptk8ShchVkJ+ZjGXYWAImEKw8ckkYF3s6CG?=
 =?us-ascii?Q?jCXLed9rE48EP4cTyPX32ZBwYGp+Wma8Fldif6mcemjauIIBo4kGobR69FIw?=
 =?us-ascii?Q?8mNA1rOdUhjcS7yZw0nhaXpfH8VS4az/av27qN2iL7HDf0mE7RYmWyukcks2?=
 =?us-ascii?Q?G/vTbdMK6edzbsKTUkOOnDC0wnvTtCabj0Klsh/3Jtf3wAD9bGnAR67GnvQY?=
 =?us-ascii?Q?VWXM2E13dgBvh+QtCIXXlqJH3NH/rJ2LLtq+jMRo94EuawLa/R7MSAoHR+KL?=
 =?us-ascii?Q?rJisrd90L+ICudlh9AA4YH8lGwk9ALnHHmJ5Bn1EyXyEn7R75yOZqITrLt4m?=
 =?us-ascii?Q?5gKz9n7BHnWCwKICZYfKK350TIVyOgB+3FI3H6KEWvgH3a+Pv9+3xlC2F9ul?=
 =?us-ascii?Q?EUlH1WqlQXh/knQfJw3roaKDsfyrji3UR4tXE7/1ojKnKlEsoNJKhQiHJw9b?=
 =?us-ascii?Q?UOoGaTcfNae7fanvDDwUpYkc+1+2Kba3G9uUNQVOxtOCTiesPH5yj3D8i7jp?=
 =?us-ascii?Q?YMTng/6pZ6iiTHj9r/RPK5s9RCZ8nRWiz1+XYYp/vECi75DrTLro4kgWiD2/?=
 =?us-ascii?Q?WWiMOJX0MYaD9UmiwevNwRQuuVBafbf8FTjX45Hst6OEf+Cc4TFagdHTILzz?=
 =?us-ascii?Q?eU0NT0nqARfcfmPkWr4YogSgSxPZ3DI18ozUlvrLsWBe2fhLot72gjxUyaSw?=
 =?us-ascii?Q?OboCMgfdL3RhuaRPo96M8KTRm1NG18S5JTH+Kn9KrYz5BTOOY3AA/NkGxs6L?=
 =?us-ascii?Q?pf/bQ6WaEb34j1c+Bdful85fpwwnnpmLpplK+nPj7c+iwgHjVjWtDptiXdGf?=
 =?us-ascii?Q?I0Rzn89hmCnKhsg1d3m9pjRiH/0SH7WsxQavVTfFqhCFjopIKs7ZD6VLfeuv?=
 =?us-ascii?Q?EDpjWyY/WjcaI6cbCw46n2tBD4KeWDTvaGd5VBoP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772fdb45-c216-4aa2-468a-08da927fbd2d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 16:24:16.0427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyhOMssF1ZQlmW8OgYzzZ6BxQRvW524Z5TrsJfgI8LNvoPgPxMiBcOuEySZS5f39
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6533
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 08:49:40AM -0400, Matthew Rosato wrote:
> On 9/8/22 2:44 PM, Jason Gunthorpe wrote:
> > The basic issue is that the iommu_group is being used by VFIO after all
> > the device drivers have been removed.
> > 
> > In part this is caused by bad logic inside the iommu core that doesn't
> > sequence removing the device from the group properly, and in another part
> > this is bad logic in VFIO continuing to use device->iommu_group after all
> > VFIO device drivers have been removed.
> > 
> > Fix both situations. Either fix alone should fix the bug reported, but
> > both together bring a nice robust design to this area.
> > 
> > This is a followup from this thread:
> > 
> > https://lore.kernel.org/kvm/20220831201236.77595-1-mjrosato@linux.ibm.com/
> > 
> > Matthew confirmed an earlier version of the series solved the issue, it
> > would be best if he would test this as well to confirm the various changes
> > are still OK.
> 
> FYI I've been running this series (+ the incremental to patch 4 you
> mentioned) against my original repro scenario in a loop overnight,
> looks good.

Thanks Matthew, looks like we need some more time on the last patch
but I think the VFIO ones are OK if Alex wants to pick them before LPC
is over.

Jason
