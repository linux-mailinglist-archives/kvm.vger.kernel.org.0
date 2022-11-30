Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B457D63D72E
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 14:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiK3NvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 08:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiK3NvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 08:51:07 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C054525C67
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 05:51:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiLQRTiMRoXqTOV0yzDxHFQ5k+ABHXBlYycIp1bSKs/vxfFDSVcSDLcw4jPIspnvwpuWY7nTPtOmwO6J8ghGh7BL6f0WADRpvGYy765Gmb/jhjlGfz1xfgexOGlbLCQ+4XfYofkdsu/eWLtinDsBo6ssnR+rnoQRdJTSlHOu1hB4H0thG46Cp8Jyq/q80OmcWvj/yystDrOUDjzl5QIAtfh9Ab2RIcivaHnrT9dCadyrPQlFnjuT+1ZKwJdnGhk/+snHs3LlulCSoXc501lgufjmMSRpQ4O9RgwmZuuHzA7LgpibpO1FOJ54pmUnryRjiOOsHDmSVuvG0Hfq7vMbvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mDS0JSdvQsncUDiSC7oAZfpKsa/uwQeIChbBG9RCu4=;
 b=Bkg5YRzlc/8x5et3c/H3GdeW6879C8kPvWTU8ztg3qefG9xvgJ6+ZwVxn+qwOCRgemLn5OQftgvh2MyHGqXBhs2s8PZJ9hY8yV07lxcOBTplPFVs0jfyYJpwTIOb5wHHCn5VQ3vt98teGozTOigYxLBnnpLbih+NO3yTXeZeKhDRaLQ+SMRGBy1eeMZ8BhCUyk9LDygh+VoneyfiIf/kmIJRZxm0NtTCvpljBhLESHgrnrh8xJqC1M5KNXE1W67UQyC+6bq9fJrWqfq3f0sDOFB/Ye2xDGtkRLCZBlYg3QhHPlALHVxaYojbgORG7E+g/G74g6Pz11tQ3n4cbbnyJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mDS0JSdvQsncUDiSC7oAZfpKsa/uwQeIChbBG9RCu4=;
 b=EoxZkUf/0P8urtS6tIlJ5WO8CKfj+9BRlbCQmtHy+Meml6KwUIf92ib053FINtWN7dJCdCQL5wG66k/GYleFoPiKdVdeGHaULxxzGZUtQTmjguHfdKmEocEyQyVZIYI+I6oNoUe7gnjw3pCVpp+EQxwOJGjgSzTY38mbo5fPUIbrK5mQFwP+sreD94m5XAbk8zkwOa17w+LDqYKULVUjJ3nNm2h4GN76QqAqRBIZLyiF+9jPUrxyh1ciVxeXjMeyfPAQ2h0a3TWWhKIyhrHSH3gKBc2JshdXjcEEN+SQ5ysZGZBObB7pQn6wB538ynPddaCWW6t0rSaxpQ3nZHpeQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 13:51:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 13:51:03 +0000
Date:   Wed, 30 Nov 2022 09:51:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v6 19/19] iommufd: Add a selftest
Message-ID: <Y4dfxp19/OVreNoU@nvidia.com>
References: <19-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <48c89797-600b-48db-8df4-fc6674561417@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48c89797-600b-48db-8df4-fc6674561417@intel.com>
X-ClientProxiedBy: BL1PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:208:256::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5157:EE_
X-MS-Office365-Filtering-Correlation-Id: b7aecea2-c983-441b-02e8-08dad2d9eba2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3SM2Tv3F4EBnZvwQYIKeyqWb8J5pOGiOlcFhe9QdUhy45WtkxpJNqM6eGObmavEnt0UFJWtFIb4TsxbltJjgCcwSNohwyIm7bS5znmrHJ2in+YgYQTE9wKjuebIpITeUvPWTNe99SaKvLuKPkeC35ZpeWO6xhMTs1cddZL7cmNqzIulx3bMhJVDBOMAexNt8ffiGN4nCl8YN8616qQ0FK8ulqcTalL1VREDHheYLrGL3uaCOW7YBfoV/wSv6Te1xJzKSzON+w/4tAMoBISwWZN2njgprRIWke8OTypQ+s9++eaiY8C9LQTVvhiHM6k/V1+yWtq+yPKDe7/+mpe5vqrEIoMWXK11ZNCcskIxVVNYc21gzDRYD8CPjp9woFR3Z3p94WpCAVLqq9QQgfJv5bwzBqP/V9V41ns/VxEFTskQN4/KY4y7BC30eG0DloDOr+W+bZeB9JMsNOGXr2Kt9G6yvOTi8YhfepU4mIkRdqq86EOhLrNq0y/PSV6wPs03dhFIqTA3ly51TXmTHVzpoUS1BGKVNrx6hokhsiNEwG+LFwb2KCk+vNgiztq84kKOq6/qlT/9UjbOOkPAC2kwpD9lNX7cbNTjHwghK3NggGH2EP1y5grDxYBtPzVzJGrcsK9ZYA95GIeokotgNf6Id1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199015)(316002)(478600001)(2906002)(6486002)(66946007)(6916009)(54906003)(36756003)(83380400001)(26005)(38100700002)(53546011)(6506007)(2616005)(6512007)(86362001)(186003)(7416002)(4744005)(5660300002)(41300700001)(8936002)(66556008)(66476007)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WyMJaHBwqvU013nzJCVThj3gsPM0r7a4kua5aevXNlGTYs4Kc2Y1Y1d0tdtZ?=
 =?us-ascii?Q?l/fWzb+a8YaXBFqIB5yIZDQ4ayBviMMCbggJXcKcanTD3Qao1VIiU5HWHT7t?=
 =?us-ascii?Q?uFZ8CSRLCdG/nOMpEbjgCExbq3UkYXaLLkrW7Q10tFVx1jZFxt1iyfDXVEvE?=
 =?us-ascii?Q?xv7xyBl7u6jTxif113QFHtPTAZ8AMygCuCCU2msxO549FDhNjDvWWDS3Lx4O?=
 =?us-ascii?Q?Q6hSrQ+mLnyQ0lzWeVVan6CDGTkKSW5RywH7rr9J1iGqRIL6HV9SR96xdrmo?=
 =?us-ascii?Q?yuMeYdAcyRNC0XgA0vnR0dxYwegxZef4uQzIJRPtmbf0Gnnk9Hm9/jbOLLuo?=
 =?us-ascii?Q?iPe4+BMsqUTl0kCqsAGdb7sgtJMxKjVM0dzCbeMseIvBLcr4GVkoYAFPtg+C?=
 =?us-ascii?Q?gVX015cwQ99UUIbmeOn2xxzSkws2ZVkD5i+z10LukLAFH9eWenhSA2vMtbmn?=
 =?us-ascii?Q?KhbuCmAfJ1jlHcT6lw71/14VCzWX4HYgxovJuAAhcf4CxOdJBqa3uwujTpXr?=
 =?us-ascii?Q?dEWncxf0zCp0g/9UO8MyMxCYT4YWvCMogsKT5v9N+LmptQmDWKEKhQzqUWHK?=
 =?us-ascii?Q?XUH71i8/nBgmOGYY3pP+7CIrh6jepdwU5s9VOPAzmXWG+EWK/V6spm9GcnEp?=
 =?us-ascii?Q?qkoJhkQ/BFXiS9ByE1GHXs5QxeF+Tb/HKgOiNru/801OD8nTRDTM4ZeOM995?=
 =?us-ascii?Q?8It7N7iu2P6xkE056kbAFFDkKFCjLNK3X1rNu4PHC2RuijqsZe7xr8lTdizc?=
 =?us-ascii?Q?0ct6mBYVNMm4JmSq+Tt7NL4lVLnEhbf3496SyGO1xaAjcpHA+pCu4O7Gcevu?=
 =?us-ascii?Q?+rAZfobs4HfPyfTXoyYEXydZH++/yoZhkik9uupBY3qncIzNaqQia7WQA2Vg?=
 =?us-ascii?Q?3fFBCNq5uiJV+KxIShn+5Lw6GxmOuiJ7/8vHAl0knQHDVOs5AcCJKstoMfdh?=
 =?us-ascii?Q?IRX07PC67ls6klufK/UG603ey0aA6hzXYjvaIIc3Y1I+UFR5zedxpY+T/fiJ?=
 =?us-ascii?Q?3XHOQ5xHO4UVEOZJ4/eC5Z+1GhvUVM6t6PWAoASvVv6/XcynkrSthdYux2WF?=
 =?us-ascii?Q?P2qOO7L0jYCdwqZJcd0DXvAsyXvciJ8kOOuFR2EBove8ZpCPsurEINvPOdPE?=
 =?us-ascii?Q?uRXPZSWDd+f2Hz4KGVuBgc2aGl1IwRlzvFvNPPdMQendbWHip5CT2LaVeP69?=
 =?us-ascii?Q?FTt6MPIEptBOLel57TOImDQN/YDd50K8gcjaV2s5HpKADslRF5hWNYqrF2sc?=
 =?us-ascii?Q?SlXNum3fCPuU2CAtGfdsyUEZF//uXbThYS+hCtnCEcH8tWqh/v+uwZB9AHrg?=
 =?us-ascii?Q?dBZWYXmYyGbF/tVEslRrBQZXrFGh4xzhPWdU43HI9EyRKKDg2TFvt9G7Evp5?=
 =?us-ascii?Q?ZFXzELEfKvfURyVhN8kvDYRserr7meEBQIdmPuelfQXznE8KtDwjJY6KiU1T?=
 =?us-ascii?Q?ZP8uG2TYoobXZ6mBSaIcgEUFl3w66F547AgXPKEKoeTew82SFNuEmrZ0nc9O?=
 =?us-ascii?Q?mPiQv5ePW47LJM/6MoeKidR815JkpXC9QYAtTZAjOqlVBVv0Mr3GNF4InGIq?=
 =?us-ascii?Q?5tdduz7VWhJVrawbjas=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7aecea2-c983-441b-02e8-08dad2d9eba2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 13:51:03.2001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yH95koQxjunus6ces6Fgz0XMgqTKYV9G8DDI1SHIZ40BIQDiePdi/xlRGcRYSNGF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5157
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 03:14:32PM +0800, Yi Liu wrote:
> On 2022/11/30 04:29, Jason Gunthorpe wrote:
> > Cover the essential functionality of the iommufd with a directed test from
> > userspace. This aims to achieve reasonable functional coverage using the
> > in-kernel self test framework.
> > 
> > A second test does a failure injection sweep of the success paths to study
> > error unwind behaviors.
> > 
> > This allows achieving high coverage of the corner cases in pages.c.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com> # s390
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> with sudo echo 4 > /proc/sys/vm/nr_hugepages
>
> Both "sudo ./iommufd" and "sudo ./iommufd_fail_nth" works on my
> side.

It is interesting that you need that, my VM doesn't, I wonder what the
difference is

Thanks,
Jason
