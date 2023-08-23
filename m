Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D669785A65
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 16:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbjHWOZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 10:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbjHWOZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 10:25:18 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8144E52;
        Wed, 23 Aug 2023 07:25:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WigXYXGmeBUGURws0Wrw3fHTKkFHTmvSv4O6yCgnYryrTeW3qP6ZBv+xgWJUImU8obC5gO6gvY+vC7lH8xnMKf19IhS4qBNIdmIJQDISWOERjMb+BooP1bOJ3FQUZI6CrhNv/vayP7M9K6HNQQz2lqPPvRtPHGU74guYBO6IpZCMatRCmr8VWZ5eyvcdciZnlg5Eg4GysyMONGj6/rojafdltsrO5i1g/dHXd885/fiUn8XC1M1ndG5IVKWWJAazEVuNCHvl0BmPBwJyR4csbScdwYpOTh1ZXMenpS1k+cWMnuV2ZnYa0tLFjQ3rpn/BgbAli6aHBqYsh+yLTVwwDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mjNnhaNpaaIAEx1aRq3czPGjaf9NAEvyg+AgThChYI=;
 b=ONmLmgyTxfJ06z5d4w9qrqDYxuFzWGiUihj8n/eHTvSBEMicOo3UrHVuX3zhmVKKfkG8qNTG/SxXgPbXRUz4b7ITyohtP+1y/Kw8qZWCT8sNNTXI+E0x49tKQzYLugLa+X1HXxoHe46WspmK2FwokNjpllgeBI8lClGkHa4yIpTRQCzGoFI/rwalULSn/IvcT12OwCn/3tBt0sdAdUe6dCJkciJvKW8ntr87Iggt7yrrLOP4tjASkOZSK1HFcNI46WGloYn7j3Xm/c5vTVtNQiiYISM2uFQhFWhwcZ/IVZjjwvqUWACpwsiyeXycoaDnJauDGWtswyG7aTyrmgbrBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mjNnhaNpaaIAEx1aRq3czPGjaf9NAEvyg+AgThChYI=;
 b=PBxMq8eH0Gw67tlwUlraBFN3uhpcViKvH0kpKVo8WhPPjhBP5I8qMJyUaEbskHWDVpCpYTurk0BKymhC4RjhUrIu9CzN7wNQ8we83+4WczfIsE05th/jgLKlyZIDuOQjdebGQUvzSbX7xZ9YoQu7OKfleh0pAsAUyFazH11RpuCQeit05NPlutNNfw1Db+zDkwYJUZzxBbT++OC6Cr9J8XJgCOULo69naP+qrJi+U0CeB2t3O703NkN/ikVozvGpcKIiza46rg4rHoqFtAv+WVPgD8d2ZKy0L6uQN32REaJJNnIlq0g+T81iHjwVoYumQw1hGnfe/HXTv5136uN2PA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6729.namprd12.prod.outlook.com (2603:10b6:303:1ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Wed, 23 Aug
 2023 14:25:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6699.020; Wed, 23 Aug 2023
 14:25:14 +0000
Date:   Wed, 23 Aug 2023 11:25:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Ankit Agrawal <ankita@nvidia.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZOYWx+ny0bCJYtbD@nvidia.com>
References: <20230822202303.19661-1-ankita@nvidia.com>
 <ZOYP92q1mDQgwnc9@nvidia.com>
 <BY5PR12MB37635FB280AECC6A4CF59431B01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB37635FB280AECC6A4CF59431B01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
X-ClientProxiedBy: SJ0PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: 438ea4eb-0a68-4016-921a-08dba3e4c428
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nYE1fnGCdcSQ7Rr+vferFoBHeRwh2byBMzyRdAN5W4wQJlixXRAd3hvG67Gctgsl6MBUt5Ljl4MoY+37Dpcdks9DHTnVL7+2/A6Jfc0n0y2vbVTz9Agltbon5aILSvykksTwvL3+A+tVsKP3GMEMPAu55PA3hcvztKKiMN826mbxTuPtzsk52pz75wkPbNgwVwLaP99QQC0FG9tYMCYQVpNdN/j8luHkACq6XQMWqQ2PwqwbaF44/St0t01V74UxvmCCc9TZ+S/5+pOPyoSVrNTvIovKpQM3CaZP4ckX3dbgsN2X30NyNF+sA32Ffo74BQT/6uijPPMzyKgGN55w02p4UQxMCte3T/9hexVJWWgEc/wHOPhp9YfLwFL0M9IoP3ApAMtRjzptwtKYMNNuzAjgDB8X1dy5Qp6YLlY/1qorBq3yrGmmcpUvL9L7u8b46wL3E5QxpMmElpwKW28gm3FtnfWWood1iLJ8kLg3EfIy24ygwDR5R6T4X7+hKqS9CEdwJ5BTDa7Fp2D4XJqMsk7qwAawIH/a7U0dAaAdUCA1OPeDN3isB1v+gcXtvkYlSkvelBUG0Ijndkl3+zDeJg8FyhBSHOa6qWYs+VeAxtc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(366004)(376002)(1800799009)(186009)(451199024)(66476007)(66556008)(54906003)(37006003)(6512007)(316002)(8676002)(4326008)(2616005)(6862004)(8936002)(6636002)(41300700001)(36756003)(478600001)(66946007)(6666004)(38100700002)(6486002)(6506007)(2906002)(4744005)(83380400001)(86362001)(5660300002)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+iWyLBgdxJQyaWmi2u4Sf8YfuJqrLUUB5zZd4ygaiRjJx7aWPJMOM5CWEHWg?=
 =?us-ascii?Q?GTTRxi9VwMKfFqcX3ViL6zRc4oZvf0r+sebtBT/3HtNv9yiwysa8YDxKiZu8?=
 =?us-ascii?Q?Nec4CDvvKGCnpTYOXfX2QwKGYa0xnyE+zMvAgrMWeanWdXrcTHgrPgzVJSam?=
 =?us-ascii?Q?+mQXroOI73MizhyeAI0Npa/6byblOhSAVrRoH5/7btxNbaaOKgX1zZiQkIVd?=
 =?us-ascii?Q?gQDsXj9zK1oPn3eInRkLPx9D8dPTp7IHCiC14Rie2C6kFjVm6taiB2FbJQdv?=
 =?us-ascii?Q?Y/pJuYR+c1neHVIIgYIG6GOxslvsgfbYIEzJXXlg6vj9Sh71eOfQzeUfPx6O?=
 =?us-ascii?Q?y80lpEbt5bjm2keUd+UGnHOTQ3G0L7RZLEflMoRR9gSzWHQ/Bam1rv2/tf53?=
 =?us-ascii?Q?FO5jfeqBf6OgeWMI15SHvrXzaxm061B5w3RlR04YQ+wByPm5Ushre5sUbpTv?=
 =?us-ascii?Q?tB90wOnqiZG6tkJkA3cyuLco09yGJ5SGOoXOyOC7RbqqZCS7YfM2dIC/Id7c?=
 =?us-ascii?Q?UZ49KSUSGRW2J6yOCllZhuM5LYouiYpAOzM8UKCAe4cKcCGPkYbqnBDkS38r?=
 =?us-ascii?Q?jPneBZpTU4k/8OZtG74o+nc4vwy1pMFMh0lBboFho5KB1bxenunIKF0GtG8U?=
 =?us-ascii?Q?DQbwAK2XxFoLofqrFrJtHGgHX2gMG6lVhUhmsKm7bIWSeOF1H5HbDPywDIL0?=
 =?us-ascii?Q?7Qm5HLg+nTh06KVbBUxKm+S9PuHfgvykiHbngR4wuZg9w+La3ND/Aro5x2wf?=
 =?us-ascii?Q?2v5qmJJ45hQigwHICuoGmgC2X/GhG82LU0v32CeaJ2DJ9uvUkX6SQwnJdPi5?=
 =?us-ascii?Q?nHIBOP2BXaKNojbRREEQ53MmIJep0JC4rXVadU+SeEcPcwgP1PQcD7sGxFvl?=
 =?us-ascii?Q?seGY4feyyiJK9oBhUJfV54LPfgQXZJ+gZVez47QHTkssEj3hFpIVceGsgXVd?=
 =?us-ascii?Q?AnxS90hI2i6TyryG0kcSNRfoYQTy05Fck8xkVBiT1M0+rF8jj8PURV4H5kOb?=
 =?us-ascii?Q?oTsIW/O9auLvbda53J4Djna2R8eHNESWwydZAlHH8tVFOpm18F7JGAa/uaSd?=
 =?us-ascii?Q?e4ItMI9d7J79ii+atr6/4aAm+ZHfdBa8RB934rLuVxD0fbajblK8SyBmc/aP?=
 =?us-ascii?Q?DLtmCadi482iJweR48OPqIe/SuvgdSqZ/2IpQ/KGngncrBFcy75cxVwR7Nlm?=
 =?us-ascii?Q?AYKfMwRy2Wmgv+DRY8ncG/5FPgBg8dmWhYy/uUYeUy2M0VRvsBfsP2+FV2Hx?=
 =?us-ascii?Q?F452PlxayBalqmiXwpHw6EJZDIE0vKdBwnOQpvQvoDOl4cjNUEjRPnpKqapM?=
 =?us-ascii?Q?6OmJnBxMYIQt6K6brn2sjk4J54pWuB54a80Teebu/hHqT2Vm/zfmkN+KEia3?=
 =?us-ascii?Q?YCOnbMZlS/QYTHAxdeoD58D3LccDRinbWzQDvgHQqgn5m0tNS8Yzoo709jMD?=
 =?us-ascii?Q?W7ePRmyZ1x/tOzXc2012vy0ZQ111i0yHOz7y2ez7uqviTg+YWLjInDIG11b1?=
 =?us-ascii?Q?N/Hs6aXG25mzFXKz4cwzpzlGlHqt19x8loRw+5/jlXyYshssCIO69j3Qqlv6?=
 =?us-ascii?Q?1PvZ3fi7BL45D/W2gVmQhtRxuMq9YifxNMT0PAIb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 438ea4eb-0a68-4016-921a-08dba3e4c428
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2023 14:25:14.3563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVJyN6PTbAG/V3tGcmzA4+QKuCWYBQCcabL2SlxRfUl+KXG3UB3YwYlhFgn25i5m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6729
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023 at 02:18:52PM +0000, Ankit Agrawal wrote:
> >> +
> >> +     /*
> >> +      * Handle read on the BAR2 region. Map to the target device memory
> >> +      * physical address and copy to the request read buffer.
> >> +      */
> >> +     if (copy_to_user(buf, (u8 *)addr + offset, read_count))
> >> +             return -EFAULT;
> >
> > Just to verify, does this memory allow access of arbitrary alignment
> > and size?
> 
> Please correct me if I'm wrong, but based on following gdb dump data on
> the corresponding MemoryRegion->ops, unaligned access isn't supported, and
> a read of size upto 8 may be done.

Regardless, you used MEMREMAP_WB which is equivalent to normal system
memory. It supports all accesses, including atomics, and doesn't
require __iomem accessors.

Jason
