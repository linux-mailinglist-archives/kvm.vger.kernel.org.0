Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3AF75589C
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 00:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGPWac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 18:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGPWab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 18:30:31 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5C11B2;
        Sun, 16 Jul 2023 15:30:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB2OZSVyPWxc/s37D/crIr9iV3GV6K12Bol62h7ZJgZ9kAJpeWyvdoqNbIa6/YaPZ/M827qcjOBtE1RJYhJN0T7RKmj2YPCUJX11kKzGPp3zvoCWjD21YFm0WFCN4/l9e7WALqe6CsJjbbOQ6DmuToJNvztkAok704YSaa3mpyzQSObWwMw4YKeMZHTphJF6QTl0Z10Q8lMAtDrL5WH/73AgRbXAoJWlyfmKYufM3+dxMEfVwqgKzHGA2e7pvlQHal3X5zv53jP90VWgCUVvAlrZuiBsRmbSeCscZHFEhudI8NJL4kxO8mliOk24s2C4FdiREI9UU3WIBnmlwm5daQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cT6dL6NjKoIS/Lnw15pwIZwQG595wZvCh0+SZHCQAb8=;
 b=P1yT4D1xSBCkJwuzRvVJR+jZQUyS+BgHYwomdToyRDUrdjU0gVYDIfYdd5lK2BdaVa08AOMpo/NMJS7bSOr+su7mjhR2BRh1dQV6dxke67JB3gCVfc7rRkeBYN2LuJcvG9l4g9dXKDlXSwhlXJkjv1IwJnfI06s9jeJip0+UJsbwNb1l9HaXwmQ0NpO9aIx3KgclTbpHNZcF8IDorPqGK6xrp6mhcua0G8/3OjpL4B0Vi8YiOvv1BEaEFzFveiV3CICZt2ZGFTPbd/3otLRGAxCLdSeQ1iratcc737SJbG1/n/usB7XlaSKvHz9HJus8+C8QGqTGWRh/se/aEHKLZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cT6dL6NjKoIS/Lnw15pwIZwQG595wZvCh0+SZHCQAb8=;
 b=aDsNBPYOZEi33/1g7PqNJODssHsHfLmDjgQ0OQ7/Bwe5UpaBxt/0lUBNibEc35+zOa9dJI6VkuHvN49Jdg5wbRMHzkYATcQY4tOkRoNJPEKm+bWJf2iBZiu6yumbHjm0wULkTgJfu6YLIlivw9zfABusVlaa6QgDHYaPCNvJZeAD0FLk9Xu+bzMnHQsTSIAEXozjMs7qyqm44GuIuSSHBNHJWJsIIgxCvM8FYhP9Li16G5FwGVEZMPLt++v1fT7adWL5ZKEMeEJKGRda3Wb/EcY04j5zdfhwWWb77xmjWBKTkW75oEE7PqoCMgB+N2xjv57aAbnNugleUKV/ssbc7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7508.namprd12.prod.outlook.com (2603:10b6:208:440::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Sun, 16 Jul
 2023 22:30:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6588.031; Sun, 16 Jul 2023
 22:30:25 +0000
Date:   Sun, 16 Jul 2023 19:30:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
        alex.williamson@redhat.com, naoya.horiguchi@nec.com,
        oliver.upton@linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Clint Sbisa <csbisa@amazon.com>, osamaabb@amazon.com
Subject: Re: [PATCH v3 1/6] kvm: determine memory type from VMA
Message-ID: <ZLRvf1M3gk4jjPp0@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
 <20230405180134.16932-2-ankita@nvidia.com>
 <86r0spl18x.wl-maz@kernel.org>
 <ZDarrZmLWlA+BHQG@nvidia.com>
 <ZHcxHbCb439I1Uk2@arm.com>
 <67a7374a72053107661ecc2b2f36fdb3ff6cc6ae.camel@kernel.crashing.org>
 <ZLQIDkFysVJ8kzkQ@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLQIDkFysVJ8kzkQ@arm.com>
X-ClientProxiedBy: YT3PR01CA0107.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7508:EE_
X-MS-Office365-Filtering-Correlation-Id: b720841f-411c-4c5a-afeb-08db864c4011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G239vWAex6cj3lUh83fgAVlys5n4ScRq3qJEYmuLVJRtNUlsK56vvOL4qcgCAtUbww3tNdA1L2x4X8KeBF6gxGzD7doiiiaKcA8Qvnz2FBcUpZmLJLNPfLcSrWXND8KHDHNZ5a+G0t6ER5wuj5hqRi58W5NQKMLEihVnXeWdhKUMMSwSUgdKm45U0v0I00l3LlHb4LJGidrw70n3x+Lh5TjPF70yx0FDQOvFXJnhbevfbgPbtHqW40ovAj+xrye2QUB/JYI/c7pnkvqT2bcKiUY1Z88pKUZ8mdiJbUMKEtgxG0GSG5CBEw01HgA+Cxk0pKK1hw9YFipTneFf2JkM1ZUBftNoLOz0vTU5Iazmiu5+r/nk73D6xX5AOz5TBcyVAMAoKhDMaVIkzLlXHEl+PyL2P8D2FYVPmakFpb57ArNwBc56eos9eaFdhyWfXLP8iE+jSEzfbiEYHAzxuIoXBX0UIrScPG6JvkZWn2oO7aLjCXBWDg0nhctHe29u0fD6eXiFx9oLjsRsoUZan6wZQZvF/qZjksL7u0eORnIwY2PDXqIo1vM4+TzeDXbHXqaI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199021)(6512007)(6506007)(26005)(54906003)(66476007)(66556008)(66946007)(36756003)(38100700002)(7416002)(5660300002)(86362001)(2906002)(316002)(6916009)(4326008)(8676002)(8936002)(41300700001)(6486002)(478600001)(2616005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dOmWtTcJ7dWn4naN4pDr0YpY4LZKyiuyKq+4I/gSp/VgN/LcVsw8uy47K/lC?=
 =?us-ascii?Q?KWgMgz1AOdHRFnPg9geFQyNV+6YWS3A/pPUBCAcdsh1sreed/z9nqnxdHdgR?=
 =?us-ascii?Q?8IRS9oklcCFZjAJdM1LE1I9PZs3WFsqfiASzqVWoBkN6dMk3odD/i7EvGqXR?=
 =?us-ascii?Q?LSTZdYJ2ncLU7FMi86Nh3436ElelBWP2HUv0+VGxajieRS3P1Ntvy4OMo4e/?=
 =?us-ascii?Q?lQmiQRalVXZx+jxVRUdS2Y59xpMvjUBvgK3Df5EhAjhiPEREutTzHIcVEc+I?=
 =?us-ascii?Q?h6GEPeVOHG1ayQVySnTA9COA03EohdgSIt105nO5YIY4XD2XAkREfZiVZXWJ?=
 =?us-ascii?Q?48/J7zuOYKXGn003tosbKbWHj+WRbJh46jeykM8k0WJSt0JEP4fQM+cosDWz?=
 =?us-ascii?Q?9e8lHkFtR/2zQLeHvA/2mCm0G0zAMIuOJsHxJJjDRQrgI93STYhMax66JgKi?=
 =?us-ascii?Q?6X4D604Shlt0Z++ogTXs3G1hE1XBrZfyFSKrB0yexHdTH2sFXy3fRzXsJIoE?=
 =?us-ascii?Q?bKxx2E/33HTbPw2oicyiKNbHTT+goJxuOJpNsbh7fn7sWxwtU5/F+uGATVWC?=
 =?us-ascii?Q?Kk4mHyZ7l9ZtaAASa0ZeeeIHnrYCFQP7DbCjkGYuuoPw+DGSyC3v6ZnwgtWA?=
 =?us-ascii?Q?yctkqOsEhKM2JHj2NRjDytuqymrr2FZiHlhNa0NNP3/7yC8L0bWrGP+pyY2F?=
 =?us-ascii?Q?1JXU6toF2zilulm3nGQYFjF1XFCenGAoy0JVyW0FH8jGeyIyQJoCZJgJ13lV?=
 =?us-ascii?Q?pn7Xy0+TEAUJhL5mhqLhPReh5N+SSZjzzuxF3drZhAlR1ov9UZ0mXb79Z3wK?=
 =?us-ascii?Q?/CWdeHsdu4CsA7iGvcpyB+VOsc3Y1rPhI2dJJVVJ+d58MVQY3Z/AMw7w1W8y?=
 =?us-ascii?Q?4YplSjMuWqpuHxBWIXRfoa/dCBl7qAl8DGMFAc9qL0+/lhwzNH6RDJC7HOwa?=
 =?us-ascii?Q?/E1aRCCgXxAWtKToVmchakf0azaweAv8CldcVJ5i2eeJ2yskEizK0HlwFRtK?=
 =?us-ascii?Q?/6v9e3JNA6OgudnJJjjVmgbdvf/Ohzey2zFZsRf/clCrFPBOO1leInxCPfSj?=
 =?us-ascii?Q?3f2L3AA+Dd+9UHqnZeA3GidFVmTqabpDFy8yG3pnIqtgXupAujcfqyQqlpui?=
 =?us-ascii?Q?LUtv9aSIIT0u/SFuhUk139MpMoji7oOIZyAj119GsQPUO17XlMC/Qn+TemJE?=
 =?us-ascii?Q?dwaGhL/akLRWXCdE2vo3V3jQ+XeYr83/TH0WkgoVuphAEOqSkjY0AKww29l1?=
 =?us-ascii?Q?z0fqZDHQKz54W11YzGBACa4MVhUMTgS1Z8JZtXxJMgvVWcb09U9JRTa9LBX7?=
 =?us-ascii?Q?qE7sHHTIdj1QOFMzS5DUnKEMwQ8PTeImDVK8Gx5d9O0XR+wxxRHpxmcSRbID?=
 =?us-ascii?Q?ocw+/Iy1h/gW/XJySszNOeK8xM6KKjq3DZUdTJNlfrAMWXp3tE7xkuIWmXOt?=
 =?us-ascii?Q?/gGY+vQSMrq/WMtmxyNcb32ixsMg63sHkQc8PjWcscO2kAIhI77wxicNGg9y?=
 =?us-ascii?Q?Sa8H8iT1BZd2YJduvVMazcYMq89O0F80soMiDe+HvDj+5I8BDIjIoQmoIqQ/?=
 =?us-ascii?Q?l5hpgQmHxznb57ifWRc7t/MdfxD8fyR7DjEbf0uJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b720841f-411c-4c5a-afeb-08db864c4011
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2023 22:30:25.6646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fd4X/IlFgBMMJZYuaRei3VfUzQApRSea22BJk+eSgfT6wEdxjKkn1fUK3hfGa3c4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7508
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 16, 2023 at 08:09:02AM -0700, Catalin Marinas wrote:

> In terms of security for arm64 at least, Device vs Normal NC (or nc vs
> wc in Linux terminology) doesn't make much difference with the former
> occasionally being worse. The kernel would probably trust the DPDK code
> if it allows direct device access.

RDMA and DRM already allow device drivers to map WC to userspace on
demand, we expect the platform to support this.

> > So the userspace component needs to be responsible for selecting the
> > mapping, the same way using the PCI sysfs resource files today allows
> > to do that by selecting the _wc variant.
> 
> I guess the sysfs interface is just trying to work around the VFIO
> limitations.

I think just nobody has ever asked for VFIO WC support. The main
non-VM user is DPDK and none of the NIC drivers have wanted this (DPDK
applications areis more of throughput than latency focused typically)

> > This is particularly suited for the case (which used to exist, I don't
> > know if it still does) where the buffer that wants write combining
> > reside in the same BAR as registers that otherwise don't.
> 
> IIUC that's still the case for some devices (I think Jason mentioned
> some Mellanox cards).

Right, VFIO will have to allow it page-by-page

> I think this interface would help KVM when we'll need a cacheable
> mapping. For WC, we are ok without any VFIO changes.

Yes, it may be interesting to map cachable CXL memory as NORMAL_NC
into userspace for similar reasons.

Jason
