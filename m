Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6624C8D02
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 14:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiCANz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 08:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiCANz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 08:55:27 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2042.outbound.protection.outlook.com [40.107.212.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49268932A;
        Tue,  1 Mar 2022 05:54:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnbgkaF/jxgAMVLh8W251sJcOuwigAPNoSBrnSdRBEQkOMyGUxtlL+R3e01sLxya/aBu1t2krdFECdMccYCMGPF8v0Srb9AVopwQbw/j6NQ5ec7XjLNSdaKWUFKxROnwwmHYloh1sziTtH2JFcenylExTO4zb+MZAFbw2q+rTEQ9+MWGZ1G/nSDjw/Ir8nen+v/g5yrFvavDhcD+cxPHqsTjYFSQ5nn9ss3a9mfnorWmXVymWp910Tm7VY179t1nEzIs7xbM8QlHCeAxgkagE6kea4+umkZ+fkIu7G7zZxhLMoY1gOvNStXHot/Eke8B0j6jNQPKDkP1bYPF9vmGjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoRe3WIJutAkJHgrttfq04kFRiHg9k1hktjzy79BBUQ=;
 b=c3S2cT2QlFYQdNzU5+hgJbCeT6kSRXEH+a/FPN3UHOYIvhA7Bdx1w1Xc0HxTTXc8t0nWreurUR+yijBobmmHRtrfy49nquMdXxagiHZLU9eLE2q/RCu0xxuwBMAIEn7bDEdgM6U8vU7G3KyCW2PS18tifhDNsoecHl/lg9wlT4ZW0Gr0hNcoVE9zAVADzFjIgi21hMeXKMmM8AzUUuHsfwItCLaeqVC2vPMZh2RnLMELS3rhm83lecdYzUOutvBNnDPmv6ti5YkwFGS0AEx2Em2y85IGRNgktaSBZX9xHBwZC1D1U72zBBJMM44IZ5HZ8Dgo2/LAN4D3EiKa31jMbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoRe3WIJutAkJHgrttfq04kFRiHg9k1hktjzy79BBUQ=;
 b=Os7hCVssIBth0BBse8G3uKcu+WF2b5NOWJbpA8HSB6Rg/uxUV5JMGfexnGe0ffT8e0fCObAj/hHgcsXDctnNR+9McS2pM811RkmE7YBdpxrz9W7qCAA6ggWqyvXPMKRQJ5B+JyXEDdLtdNY46pDNpIOPwjY+Uw5i8NgZFIUxJ4jkk4yEOsx5BctrCuP2bCY4Fnitv3GUa4H3e0K1KkgiZcgQim5QB4raCrKgdE4PagRuPyGaF/0vcElsTL61/TN4ZS/0Uy0DJ0J05rxPUqOb8SJrBWA2HqkPLMLH6hZhSAig8ZQSmsH4bcotVhk1uPvkFiY3mRkAH4DrvVuVNOjkQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW3PR12MB4460.namprd12.prod.outlook.com (2603:10b6:303:2f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 13:54:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.014; Tue, 1 Mar 2022
 13:54:42 +0000
Date:   Tue, 1 Mar 2022 09:54:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220301135441.GX219866@nvidia.com>
References: <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
 <20220228210132.GT219866@nvidia.com>
 <5df75ba7-5c24-6a32-4f47-3d48d217868b@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5df75ba7-5c24-6a32-4f47-3d48d217868b@oracle.com>
X-ClientProxiedBy: MN2PR20CA0036.namprd20.prod.outlook.com
 (2603:10b6:208:e8::49) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d9fe752-c41f-442d-f5bd-08d9fb8b0957
X-MS-TrafficTypeDiagnostic: MW3PR12MB4460:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB446060C1077CD46A20CE0F29C2029@MW3PR12MB4460.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFMWbvpDguERKDsK+iNkdEsRdlmDGLvXvR8XaMsy8ccX5UGgt5AbArGlGCZlmJKcIsOp+itA9ksD0iQScTZdIeYqNbBV8b0T8kC9zH99XNxTa90TsgdDtgmejcTe7sQhXeAu1rxgDvYBdoQrYj+BpthXRjk/2q8oL64Fnx7DFZShmgFnZ3e7ixCv43MhZbe6Oca6siqChz8u9zXpOKy8x2wtAdUazD8Yp2NZSdA6MtEDACVpSiugPW4gcrEeHrbs3avZ4Dx6psRQ05M+X4bQDl05N9AJ08+H6ICneNOxmmxs98TI082Ib0DSToekVcxZXzNEFfac327km61FALaH0Jn125E7RyqB45kElnao3t7MncunMBX7IUPEjQrdIh95pITUUmeumG9Jug+hPAwGbZSI5DRKQxVM+fFN+NAszEI8T+Dt5skDxcGVNLEMY/Dl9BFP0WniAX5DyU56KGcErRe2JrgMZfimfWEA0PL9MCLEPL7r/WLSQ4RVHXCHYFeIhjtSgZpIfc7vV8bgJLjhwskiNts76unlyl5ipvhHuKDiBYjtawnGYeZgiU+kstZIBfS8j3QlMNUmDX2orghic3nwuJhC8TwcfTtCqnjn25ao9zacISenaOtX9YRpK7OihprpXalI9N1MftLBHMB1wvgHsOFDmC0y8rFpk41VY+NSqupwvu57oL04sIHRIc0Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6512007)(1076003)(7416002)(5660300002)(86362001)(8676002)(66556008)(66476007)(66946007)(4326008)(2906002)(186003)(26005)(2616005)(36756003)(6506007)(6486002)(8936002)(83380400001)(6916009)(508600001)(54906003)(33656002)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oG7GnUpzCMp5Lcyg0y19IA3aJzeLSNN6sSFMAvY2pyJOEbbZ/k4rsxMOHl6y?=
 =?us-ascii?Q?ZjLOqsMblEQJa/DDNY+a3GxTkm/cWwpcoYQVMDs7EKQz/+9IWIqfg4+4bGNL?=
 =?us-ascii?Q?Z20zfxQSACixrdBvzRPexlClEZNfh40MB4JLOQ4chBPF3Ya6p0V3DvQx+GR5?=
 =?us-ascii?Q?JCAt6tZeA9gQubpRxJPlZQHrhTC7KLUYWGnKx/ZS6Lm0tueRhGfL3wnWsFxo?=
 =?us-ascii?Q?Mur3ASlfc9ccooa3AxBeZnUCpUcBzM2YHY9qtBxw+uJgmT2z20fVVZnSj6yn?=
 =?us-ascii?Q?Wz/V7MAaYRSPLG+dYYK7Z5QKL0SEeNc6nuPpkdoLu1HRJZqInFC7HwaEjNZH?=
 =?us-ascii?Q?P9+mcvUOBUK55dT9Sxm/8IWlo+fXiorjIt2Gvnd7Nf4nZO1tgHodupCBqMJw?=
 =?us-ascii?Q?p0V4x2qF9HJ7YYuqskDHmmz72Njbe3WOgmzFXiIrnP2WfNw+rg9jv1VRT/Ed?=
 =?us-ascii?Q?djAem7vebhg0kC6cMQHn3o9CHRTfWHG0KrXoKF/LIfs9jpUUzCT/sKxYNbwT?=
 =?us-ascii?Q?a7yN73VmRLrEN4jawYGF+FwINdreHbKgYfrBUY/H+aUqRJch5U4pvzTxBZYn?=
 =?us-ascii?Q?aM0Sh62EOJzGN5bxPUBeIpsr2g+rLYRkxmTL//yiqaWBDE4kyIb2oyzGbjLu?=
 =?us-ascii?Q?6Uw3JmqOAqE9sZ3f5Rq1hfWM1vxWnv55b9I45WH4hdbki8tAfetoEAuaIAPF?=
 =?us-ascii?Q?w0XnzdZvF8e3248b23BnfmIki6Ji6xLg0izuD86Syd9QX419p3U83vXdFS+K?=
 =?us-ascii?Q?quwwkDne175KMlmSTkaiUOIUUSZwdbmCBOBGX60l8YyHkJ0S7TzUoKV31QMC?=
 =?us-ascii?Q?iW2VWKeLm8ud6bsDG0h44gl2KXZjYbGC8Ho0ttvnaf+Xn3MlutWXkKtavmyt?=
 =?us-ascii?Q?B1Ka0GmbvbL6zzXs59Mr9vbTPiW8Wan/zc9bFC0Tk+mGanMCdM8dqZhf2X8v?=
 =?us-ascii?Q?JY6IUYifUny3beOSwGChnCL7ZgqgGwmgUsNk5SPN47T535lSnZgFZ9wj+NQT?=
 =?us-ascii?Q?jhF+K8W4f4KRGdNQ3WB1+mP67z23F19i3FFSbQ0tC+BgVqd8ZVodtpzf66sa?=
 =?us-ascii?Q?aOXEO8GAE1PT8ew8KN/Khh6MbZxPYs6AeLFjA//ZtrUkgaJ1s9DmXS2jbr3g?=
 =?us-ascii?Q?W6n6SfFCsYE5Itp40Tz5Gq4zm1W048vriBLjJeKs4D+fkP5Cw3kCICqw3Z9M?=
 =?us-ascii?Q?xpOquPTodzJeKnB0Y5oXQ9W6X6yUSBZzts10tWOc+4H8azM49Wx+oKq+e0Sd?=
 =?us-ascii?Q?fKNZW0HRAbUiWgaLznzlzdTutmdjhLfT9kO+FfukDPurMj6GJEAUyHPcYdyU?=
 =?us-ascii?Q?OL8p98S8EqYFaZ8Mo1d9QnCB9ZQ29PsPZVdTn0OIsDsZBTkwr/uV/3PKBoJ9?=
 =?us-ascii?Q?ZZqWU+a9sQLNLX+/gINV1hz3RN4P48jgkmYT82O0x+rzHFc3WuvyyJMZQBjV?=
 =?us-ascii?Q?6ehksn7MOt1wBcVXjjVL/v0el8uz7BAJKK2JTuSxXOBGymMkmiDzHwFbt6qD?=
 =?us-ascii?Q?VRHLi3t/l/ylFVnbqn3cVv3McGXwrTFIQ2PggLtZlmhuifBZs+HyF47pPdwl?=
 =?us-ascii?Q?I2nMFAIF3P8upJVM+nE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9fe752-c41f-442d-f5bd-08d9fb8b0957
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 13:54:42.7295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0IbymYOOLQ6Sez+AC4SV+YcRxQoWgdlZKSlh8K79Pl2FzxUv85Ft9rw14+uAj59
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4460
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022 at 01:06:30PM +0000, Joao Martins wrote:

> I concur with you in the above but I don't mean it like a multiplexer.
> Rather, mimicking the general nature of feature bits in the protection domain
> (or the hw pagetable abstraction). So hypothetically for every bit ... if you
> wanted to create yet another op that just flips a bit of the
> DTEs/PASID-table/CD it would be an excessive use of callbacks to get
> to in the iommu_domain_ops if they all set do the same thing.
> Right now it's only Dirty (Access bit I don't see immediate use for it
> right now) bits, but could there be more? Perhaps this is something to
> think about.

Not sure it matters :)

> > One problem with this is that devices that don't support dynamic
> > tracking are stuck in vIOMMU cases where the IOAS will have some tiny
> > set of all memory mapped. 
> > 
> Sorry to be pedantic, when you say 'dynamic tracking' for you it just means
> that you have no limitation of ranges and fw/hw can cope with being fed of
> 'new-ranges' to enable dirty-tracking. 

Yes, the ranges can change once the tracking starts, like the normal
IOMMU can do

We are looking at devices where the HW can track a range at the start
of tracking and that range cannot change over time.

So, we need to track the whole guest memory and some extra for memory
hot plug, not just the currently viommu mapped things.

Jason
