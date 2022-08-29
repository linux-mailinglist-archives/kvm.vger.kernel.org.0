Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339815A503A
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 17:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiH2Pbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 11:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiH2Pbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 11:31:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289D57B28A;
        Mon, 29 Aug 2022 08:31:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgcgtidJwyElAY9D1kx1olEJD6/eyCgqn0o+3t1LQaDmKF6yZDkJjwE3pO7KbCYLLKV7m7pkHMnd/Mipaoz8QgftXp1qCewEXZ33jF0Sh8PY/W/o5pU1H+3n9D/aY55DzBErtRkS7PZvzCoI03panI0D8peE8BQmQRCfj+Eyio6BNiw4Nip73pfQjAYwB4PS7hpqw0G1LdMs+Mxpc9eN9Y0bhg7VuwCa/BkJQSuHuaun4rcZ9qmDfMj4//sqj81W2z3AZxnt8hfK0JRvkFk9Tm0cL46/9/E/YDPdkqq2BRKj/0YkmmBtubspoSG27C9CBbIM325Gk5ibacTcypwd+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppye9aaNmVhn00F4831Q4UHRsnxuZjKUYm/8hll8VqE=;
 b=Y5AKR3M978/ygVocJs+hk2zvWT/Z66bu2vNEwWA+gYalj1qkvWHNf62dseznoiC6gvDRelEm5leqXI7t+e3b+K9uVhdn6kZ530RM6ecJtjWpXv51nW/rB6wdeP5phSoywAf3iGgWYPvsFzAim5d59Xu4WjezC0/HOtajrftKMFM+B2NLMBGGHtvZEwt+dn7TtQgXngR1pfpRA0Onck907Lu2xxR8Fd2y6hWxLVKh4kMG9IgKvk/E9YIC6oiH/9J2pw9+HZHXCAl5clVCe9ArbJwKMjlAJ2mPkZPC7P9cmUhuvrF1KyTjwnFoA7T8U2slbLA9Uc1erek70yIHKkDuzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppye9aaNmVhn00F4831Q4UHRsnxuZjKUYm/8hll8VqE=;
 b=ZlxXQY8a2SMs7hMaCEHfLnvOhuCx2YG6gqF3+fQdxJ23QwC4QnMNJCRu1KDb5fYtJ4MeEA9j9LeFMA1FMY+ryDUfG4zF16IJKq8RAuPxSwcvKpfqRhNcy5Tmo6ESz5HWRIeIZBPRgGv4TyBMSiIA3SUEykRKCuAMcnNAAJtP9caG1Zs66PgcaM5eEeTEKY7mWu+tkUj58Gi5cJW+fZ44GvSa3QsQLApSYBwUDNQkW3WerKv+5S6VV3Cboe92ifDufBfga7X2Zj6xBZlJebF3UN7437J7ye/O2VpMi7EVn/cq5Wyb9EonQ8FtvhfPJmUDf4RLP3Q4vyy3fQ2aPzt5cA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1750.namprd12.prod.outlook.com (2603:10b6:903:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Mon, 29 Aug
 2022 15:31:46 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 15:31:46 +0000
Date:   Mon, 29 Aug 2022 12:31:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Saravana Kannan <saravanak@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Message-ID: <Ywzb4RmbgbnQYTIl@nvidia.com>
References: <20220817150542.483291-3-nipun.gupta@amd.com>
 <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com>
 <20220824233122.GA4068@nvidia.com>
 <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
 <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
 <DM6PR12MB30824C5129A7251C589F1461E8769@DM6PR12MB3082.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB30824C5129A7251C589F1461E8769@DM6PR12MB3082.namprd12.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0058.namprd20.prod.outlook.com
 (2603:10b6:208:235::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6844f3c6-8fb7-49fe-35fe-08da89d3952c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1750:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sNjs2qmSUZIjSHwe8RpzyYw4TollK0gBdOwA60mni12SMI87vyZD5UqagusYlF7/BQVRHVF+DWGqWaGe0zsZ4UObKRwTBL27Umq4Kp5fPSe9yDEA7lZ+12FVp/RuaFDm4mqZxgvgpifpMeYB/eyTnllM4XOzHwvaDp0ejN8Ec+aZmXyd43L0NvWmiGcqbAySjeboSSxoG641jbG0Sm8sbsx2YLYfasfq2zbNt1qLM7P5o+DP60guZA/VU0urs3hPIpU3e36PHWUkG8YVPLdyPi9bnoDbINrqPzC6rlsyYzt3ecvF/+lzcu8m0ZvW7MtCj2w5RU1gBXoJKr7Uho+G8WfMnW2LCOzh1S1DD3YfnWINpzz0E/HgnQXHx9JwwGazzkkNfFgBoKZixFjoEMl0wefgv14X9Q5ZGM0Ipa73j73Tzfe8+gNC2L74404y6pmVpmb3kw/ihJeElNc0GiTdyzOYu38Jxw1xNoL2JF9J0rnv04YmB5mIiSsi1mll3Agea4LQtWUWBCwi3230JBAJigmybYeXrKhhZyWgJIrQkzc2kXqfvel/y3uYHBdMkjYEorbH6NXQ18LhQl2vOR89Gdriuhh+homwyec4xz7rZaFRvxTGDrhchsN4tTnPKGwfD8Xc3M1kmD3t6fwK6TpXcKhuOaUobu2ohn2ixv8Ld1iD1M5Ou8kOI1Dz93EsW/Wgwc7Vds8akf73+tIkFU3rJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(316002)(6916009)(54906003)(8676002)(86362001)(4326008)(6486002)(66946007)(66556008)(66476007)(478600001)(5660300002)(36756003)(41300700001)(8936002)(7416002)(4744005)(2616005)(6506007)(38100700002)(2906002)(26005)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9bkRGbJPxgfjbMDcdNxAuOPUxsRM0UhIRk0g01UaQb6nfbvvMhTHEJqsyHqO?=
 =?us-ascii?Q?h6Hw4wykvDLkoWrxYCFBaBaR7WjkCkOoGfhVlhowwYZd7BltNqObYOpHUeXC?=
 =?us-ascii?Q?ljAMhQg6Abf/CtcnwEyfpnx/FGmURVhe0J1WZ/bQ0A8cFcDP4RsvNjkTkAb9?=
 =?us-ascii?Q?QHzjkSZ6tJfVVWYct6vaUW7+kWJnU07nNPB35NaWgpDMHX+EttekyYUD4oMm?=
 =?us-ascii?Q?BTG+WhIupHr+57IKH1TeazSSEiLGJLTKGVdh2j5pHU6qiIeNsr0vBChZczqa?=
 =?us-ascii?Q?xBE6dKN9SGeI5oU06hWt7gXLipCL3aYOxA9RDWzCeFniKfaIrd4CqXrnVoq5?=
 =?us-ascii?Q?odANncBcAJNmP7wChwH/MukZPQVnipTRelVDZTJK6UqtG50w9ZVjuI43sF89?=
 =?us-ascii?Q?UFGdpB6g0LeAczKmbcxEhWFieptOkXTADPxSrI0CAH03TNZzFYNSwWGw4UII?=
 =?us-ascii?Q?GoLkTfSuNHTf0ssINVc7WZf09pxCyL5qiQvxVJY5BC3bkYwSSoEZsDL7Wuk5?=
 =?us-ascii?Q?3stFH2Vc/pFXixBb0Je7yfrXkpxMOGWDjaCt1RSn6mckKCtwVI7dr5z3wc0y?=
 =?us-ascii?Q?LOnvqC9ZvUkh16SFK7LbI/vcuW3BjKTLoa12KLylwSzuG8ugIS35OqrFsRqq?=
 =?us-ascii?Q?WEnQ0cI2PoMyw0dRiTr8ZSPjo6moky+ykru715Y+RrdLhLeOdRnCJmxpC8GI?=
 =?us-ascii?Q?y6KLj9ICxxTPLNzCO/+mX4dt7BSi+z6Oo119lnRIeTv+0sxPmFdaZecVOjHv?=
 =?us-ascii?Q?+J/ewURqAYJzllWBgp1MzKiuAQzaXmkSI5WnlxXZrjJWf61ZLbSEJbNqgPfp?=
 =?us-ascii?Q?LAXXE13TNNlhF9n6UhlZLtTXmosDrSiogMmDyrFtp0WrrDE2NfstnrMNCXTK?=
 =?us-ascii?Q?c0VImDxJ6CGs8k8WvnfW67/4VFZgoWAielrDnVPl/i7I5yAmPTbiFBKn8YDY?=
 =?us-ascii?Q?GZCqQrkri6Z6bAD50mIPpcxOk8oFxsWuXoGFKulzNG2xlC0/Dcs8nBeEs3EX?=
 =?us-ascii?Q?tl8yrc849gA9EKko5brKBH7NCyEAaIMDQ/CNPKK+EzBnHEAGhmNKhs1TSKP1?=
 =?us-ascii?Q?ogo0xr8owLaG7yKnsPC1ZTdbYiqUoFm+5TKMGt7BlwE6QsbRPcGZ0XCf3RL5?=
 =?us-ascii?Q?HNCzIUigspt94tXdHmXV8//u38Rfm+/C7g7OGxa1ZNiQmbJZv7rGZG9xGE+L?=
 =?us-ascii?Q?YB9ecNWHVLKeltFftOt+TH+OpZ0RMJkWCbgSp9faPCpLonjNiMoSh+K+2q17?=
 =?us-ascii?Q?Ad3bfteBCf6XSlCJxhblYRkjygZXB5oluDwzuS3fQdcouR3UM85tNPKmRnlZ?=
 =?us-ascii?Q?BIWe9ptcen2RnfDjab/fiis4NiMLlByrkEe9VoTymTGyFniYpBjGjqD3SMjM?=
 =?us-ascii?Q?zedy1R/gP0oN7ak4yf5UdE40/xK+L4mueFxc+cQLxzRwYRdonh5UH7lt/yFD?=
 =?us-ascii?Q?YZ+ltAh5/J6Wb8AEo42Pmn6l1hjZgVfQCb4rcQ0rYg9+Z8uDnqNXNVHujvu7?=
 =?us-ascii?Q?MeR8pmZYG5+t+WJcag1aiKEcgzaZF5zWz5rAn+RI6aMAxnwcx9saRtvH9AV3?=
 =?us-ascii?Q?a8I4IM4pKJbdCV4m8rl78AO/MrlvEJrPIF4mLgMl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6844f3c6-8fb7-49fe-35fe-08da89d3952c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 15:31:46.2965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ItY5JfFvpl7l6i5tvWvD06aeZxtiDbDKGm2bgPP5nl11vn+4RZpoIECYjqMFXWbJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1750
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022 at 04:49:02AM +0000, Gupta, Nipun wrote:

> Devices are created in FPFGA with a CDX wrapper, and CDX controller(firmware)
> reads that CDX wrapper to find out new devices. Host driver then interacts with
> firmware to find newly discovered devices. This bus aligns with PCI infrastructure.
> It happens to be an embedded interface as opposed to off-chip connection.

Why do you need an FW in all of this?

And why do you need DT at all?

It is still not clear

Jason
