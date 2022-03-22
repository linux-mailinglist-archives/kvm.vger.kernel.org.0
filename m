Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A9B4E426A
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 15:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbiCVO7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 10:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238294AbiCVO7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 10:59:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C8B8AE51
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 07:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZRISRVskdQXx1w4ljT3xbZHS2jpHaRQr6zXhqF87iRakKwpnlP2Vil0Q6wvB5Sovqq6uX7Sm29pxlQNrs9MFBYOsLYwWCh5a6HBro+4GZRVbIJRbwp2kgJnfkAWCc629lpLI+x85cys/HBMmfij7HTUlhajHA0aRPSUGwm2roqaa1JMMNXS/TfC6gih7lVllbSOo4cEfWaWEi4sfDQN/cGaM/yNrcqrfSmRTCLs2uNIZ7EjEsxNBrUIR7hjsDy0NNKFQEGDNQhg3JZtG4blg6XbdMPB48zr39XkVeyhD3fVeAnQiBL5Tus7P6Ra7GYJpTA/GTbEM4VIgKUhAq4ZHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjYYEBJvvKUs3YMYTvbolHNdV9MuFT5UBjkNcjMrJRg=;
 b=WBYyGsW8LU9JQ7EjsKXIdxU88BsZqJ6N0JWt6FIttn61iNMQE1/qryP3KQFEeEWs5w4BPMCOpgnqwHxH0LKk43bKCWSOMSFiI29MU53lGsZ4bR+0WHJC+LR5inpSBiWVCiSms1uzrPG+1b/MMK9V24oVmMkVB+Ohj39Pm5GIb5SSvGR1nYWZDNWfAWmh+P1DLjokUiT5vssK5OoQf3CTcpIf+wDGnYGn0So2tbHZljUaXav//bJx0ay21VoHYJ9Fj8JmcdTbHmjXM81LrzP+eJ2lTTBywW0JlApSY/kXnJbJEhKTRdIFM57Rot+dqgmwcSmTv7CgmGBK113amhgjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjYYEBJvvKUs3YMYTvbolHNdV9MuFT5UBjkNcjMrJRg=;
 b=K5O/nd8f3il9aWL929lTmAqJYksmEnyUGn7IPygZMoVNZ2GyUWbzqcoSMG03+kxNQcvtcNUk2ITRjTpFcDXPVwxOUNlzFlGH6GBhbTp4NZgT/ZVefGiJHZCGqcDKYLMTpSrh2BU5dgMixFnbgHV5b63hPkHxDwzHZKJaaKGrIHwc7ncGai1H+BFVfUlAJwXZ9h8+vbWjjiDwBxqXaE94N+FRTZqloJCyvUY0lXlvUKLcENIpeiYNQu0SRG4X2UdA2SSk5UD1iVdx8n7ngVnxRd96laLPWakDK61vjqd8LPVY2G39wna73vYFOB51YiF36zo1Ai1yZLwjJw5Gh91lOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4002.namprd12.prod.outlook.com (2603:10b6:a03:1ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 14:57:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 14:57:42 +0000
Date:   Tue, 22 Mar 2022 11:57:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220322145741.GH11336@nvidia.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
X-ClientProxiedBy: MN2PR15CA0052.namprd15.prod.outlook.com
 (2603:10b6:208:237::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 587eb0e5-20eb-46dc-a481-08da0c1450f2
X-MS-TrafficTypeDiagnostic: BY5PR12MB4002:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB40025FAD2C89B4053C1EB72DC2179@BY5PR12MB4002.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tfPxg/jJKmhoOtKc7sxPLidGA9R1cG3a3OJPMwU3OG1Vt70iIIYUwi+dxxSB02u146H9Xa+l8GJAc1ik4exrKbT/uI7LGop84tBqYNZStkWsNPuSnmsOoLmRzhq4aO5tfsXzpHh4wfzWjxKBGP707WKBHF16JVKC4M0YlxjRjHffqDTO8z6FDNym233sG6QC0f0rZAMB9RgZYS5y3k2oCzXxy19l3xbr7lacbOexEf4Rk1vf7MXFeWfPaY8MPDepYKaXbh58tomwtFGpo/DU5TipxVUEdmYwuQgjOcDPGLSS9movDO7EzA8FOF9r7Dgd0MFERAOS+CZ41at9FX7qj5zqSVjMDkOO4d79GOLG1ssvOHg92jxwJk+f6nKl01AxyBL0/YwV5iPMG6wYWH0UGpuAueXHFLvstyFvJO6D2TdZAWVIYT/5dCKwnWsAld8wG/hKx1XmhoU7HziEz+RqN6utX9FHELk3e3MGqgpmGVZP3BMimAG7CEXUVKr+gM8bM2sczr+Twtn436BfwvMZF3r/RmHm0KK81QcVovyJ/VYaiF0SELGk8NfWQu9nl8E5B9iQV6TF+AGtktouuiGJU+GL7n3aMcIwyoJnjt11D0EDSuph2wlT0IyqCkw0U3XjXl9Gk0Nh2n55KpsjU4IQ9bkA0AWKK3Kmkxyqj1DHITnufXIsWgtb3Tr2ztXlVn/nNt/Ll2SA3s6187FR70xqdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(1076003)(83380400001)(4326008)(38100700002)(8936002)(2616005)(6916009)(5660300002)(7416002)(66946007)(66476007)(66556008)(8676002)(2906002)(508600001)(6506007)(316002)(6512007)(54906003)(6486002)(86362001)(33656002)(36756003)(367364002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TIAvFpJA/8ik/kMA3mSWEA+lrbGEkUHw6QGdxjB111/IsoFyvLQXSaKHWVii?=
 =?us-ascii?Q?rfOUxLjLtJJsEzgYY73s4pOmnkZtKYEuSt7hGhr11gLHfiaQnsBFGdBTqZU8?=
 =?us-ascii?Q?Q+KHQ66EGhz7yE0tJmQsxBBzSCFJg9S8BOwK1hVL8N8rKZ/E3whVhSChtXoy?=
 =?us-ascii?Q?4g15Ga/p5lM44Kc/jD/Ilf6w/H29Uw8sV/ThSyeL9P8eW9/Oi+tMHl0Iwv0s?=
 =?us-ascii?Q?rg7wFLG+vsbnfopYItjvfthXIJeNYSPV9KUW1zQCkHE/pNd+3U8la7IEd5lS?=
 =?us-ascii?Q?pG/a6vYaPI6cxzmSH2TayL3UOsS9+JR5RFXFAKOSPwXRejij8OgcJlophPKA?=
 =?us-ascii?Q?hsZpsIFlZU9MeTzx8nW27gNeE+6fraf8BIy7rOA8haHlZiGZozYtZVO34tR1?=
 =?us-ascii?Q?xKuLvJRrn/cX2/r0KvOmjWp9fTxhVs8dYrcL368RnWIErWnCg/dtX0LpdaHZ?=
 =?us-ascii?Q?eu766OxD+RlEwgr8ZkrmturL65IlgdyenixZkwP6wKfhJ6ral6WYO9NMaEUQ?=
 =?us-ascii?Q?zqse7AUAd5kq3vyD9cNq5KC/S2TdJ9EmeYdcgzlbpD7LSxCq0Zo+DQZYpbRX?=
 =?us-ascii?Q?ZL865Ft5aHvmBhwmX7E62dcy96Ky2Oxs74aLypRna35oCIerO7AmzIGPJwUf?=
 =?us-ascii?Q?v1c9FGDEfkN0Vq4P/fu5UIMzHumkOveZN4uFeWQeYwlKlw+Z2fSyvqVWWjVQ?=
 =?us-ascii?Q?KLjHEkPtdlMDwNkggaszLcgszJkGz7ATFKBdIG0AC0jWpjaHJMzEX2wQuii/?=
 =?us-ascii?Q?mLGP5JHKDr0dAecdJdh1tdJHgZ7X6e5jynpL4xXwHzWrraylc0gbT4N8YKVY?=
 =?us-ascii?Q?TPADH1P4ICS6WSjwFVaxBxmEChWsnsyGid0yIw+96R27Q/8TRMxkO4yOZVpS?=
 =?us-ascii?Q?XTvTQ1fU2ne/rmM0bWCUmXsmRpy1kUawHLfTACeGF7aIlsZkokO/iXifQSQM?=
 =?us-ascii?Q?2ealCUpIlLDUbqdmzYoQG4L4SnmiQ0lOZca0IQgwpA5LGcnuKRt6LAVLkkw4?=
 =?us-ascii?Q?auOeM6SLdkgbDSvdhEvnEoIexuC1kwppwoUWwnyHiFvPhvrAMqOLfAXhto9n?=
 =?us-ascii?Q?IPnC/iFhnKT2/1Zu3587axsULpN9RbQzhfyAVoATRrI5AAcay3s4NJlhIDri?=
 =?us-ascii?Q?GUdldV1ihkyhtCypwAv29O0Yq5zL4YEy3fDPEBnHX2Jbm/LQSIRxxAjp0nc6?=
 =?us-ascii?Q?KQ9AvAtI0WiReMQoltD0JAJskhYsInRYYjUQV8tewqJam3i6PJi5AgwEdhfW?=
 =?us-ascii?Q?4FALtb1OM9SYhMGA1wHc2Phk8hFVrU05r8FDRKxMxRR5KHp1RVRwKG/NKLpc?=
 =?us-ascii?Q?nXBETfMxyW70cd625F7DGvHj7UmhUUtt5arp49lqpx2Lr+52qP0kMHFkX2Xq?=
 =?us-ascii?Q?hs7j0MqbtDL5/ztTBZ0VMuuzXn0a0nxY9CR36XdXJ2jTdnMC0+SrsuK3+wj5?=
 =?us-ascii?Q?dJIryPTfAXk/sZjVduZ2/hDxmhWPa8VH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587eb0e5-20eb-46dc-a481-08da0c1450f2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 14:57:42.6585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZz7fuyF3CE75jI9SQ1GcbdrVZrZcIXW8XnPTQxQJ0DC0AeBZeGZhT1a1+MbFeU8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4002
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 03:28:22PM +0100, Niklas Schnelle wrote:
> On Fri, 2022-03-18 at 14:27 -0300, Jason Gunthorpe wrote:
> > Following the pattern of io_uring, perf, skb, and bpf iommfd will use
>                                                 iommufd ----^
> > user->locked_vm for accounting pinned pages. Ensure the value is included
> > in the struct and export free_uid() as iommufd is modular.
> > 
> > user->locked_vm is the correct accounting to use for ulimit because it is
> > per-user, and the ulimit is not supposed to be per-process. Other
> > places (vfio, vdpa and infiniband) have used mm->pinned_vm and/or
> > mm->locked_vm for accounting pinned pages, but this is only per-process
> > and inconsistent with the majority of the kernel.
> 
> Since this will replace parts of vfio this difference seems
> significant. Can you explain this a bit more?

I'm not sure what to say more, this is the correct way to account for
this. It is natural to see it is right because the ulimit is supposted
to be global to the user, not effectively reset every time the user
creates a new process.

So checking the ulimit against a per-process variable in the mm_struct
doesn't make too much sense.

> I'm also a bit confused how io_uring handles this. When I stumbled over
> the problem fixed by 6b7898eb180d ("io_uring: fix imbalanced sqo_mm
> accounting") and from that commit description I seem to rember that
> io_uring also accounts in mm->locked_vm too? 

locked/pinned_pages in the mm is kind of a debugging counter, it
indicates how many pins the user obtained through this mm. AFAICT its
only correct use is to report through proc. Things are supposed to
update it, but there is no reason to limit it as the user limit
supersedes it.

The commit you pointed at is fixing that io_uring corrupted the value.

Since VFIO checks locked/pinned_pages against the ulimit would blow up
when the value was wrong.

> In fact I stumbled over that because the wrong accounting in
> io_uring exhausted the applied to vfio (I was using a QEMU utilizing
> io_uring itself).

I'm pretty interested in this as well, do you have anything you can
share?

Thanks,
Jason
