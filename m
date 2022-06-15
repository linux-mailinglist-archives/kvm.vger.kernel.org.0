Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E22254C685
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 12:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241823AbiFOKwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 06:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236870AbiFOKwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 06:52:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A5E42EF2
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 03:52:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTaIyuQto61iCgSa+eE+XesajnL9KL2L6IY5WZtOy4IM+S/G2S7VKpSCXWQW+6GdoImVLk3qkljAxOIMnA7mu5p4VQ3IIEflQKFSKjIxThWBCuA5Zi8cjfmdgb2NVFO4BsH0DyoYkrStIokhrF1nGa++DRmKIJ2b1v0VVioa5t4MUU3C6VFqNcF9RDWhRJuQzloz3uO+3GFxn1iqCgg/lffXTtVzpNqfFIMn/LBo42hP7YaaA+uG54tCrJl2Z/IRxbHnpRUKrGK6/+UfWssY4eMQp4ti9XFgnvJIAi9bMdyIJYyA387MJ7926awQwKB1wKDOdLvdDuUDx6S2xMcSEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZvhkBQ51EbzBJbXNR4hFvll4Fj+5Hmua3WKwPlCof8=;
 b=QxxwbH1Hgtx9RYujT06G8LQ4qK+Y1HgQdX6FZ2eVSWqHh5HsSOpCw2VLNni4UU4tzcWsQGJYj8u/ZKUDqrW98aM5gsaI/S/JFB7wlxOo3vZZdwCTvCGOUqw+JhKeW9s7jSOunNfRNmFg7xensuMthPlZnjWYaeLJLjXvrak4O4cVpVTPT4MnZRlkPXnAiv4hMRparNMJ+PpQC4Z936AM4Je6qq/H1nX7QpGptHhF499SJmIQxI6YGxbo/27pNfyKephP03ElWGdYwuswSzq6Z2D2uy4w4HHFBeNOkbDhhaajNFTGpQxAZZI3AqeXFTY0c67Uf2aP6NDIQYpwInINZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZvhkBQ51EbzBJbXNR4hFvll4Fj+5Hmua3WKwPlCof8=;
 b=EQ9axwuGZ8HDFVnF3UYTSgAqs+8AbRnpOb4oFcBwV6B8IHU2pvUU3Lda8YR1TeBRaQKV8TOz1vp9FYcJiRld4tHxT6TVStl2dcmi6B47emgOo03WRJg/tCyk0tvXlWMCVJOKElPFw0TV9twfO4ydWbSwY7ggwJw9At3OTxz44JqfKAJXVWc1OMvt8LR1UbGZHLr1/damqOevmXN2YQxMTs4aFTNSbOEka6MWrsNiYUGeCwkkeTY1+9GuEtFLT3bxaBbvG/yfSV+ANwJopKLp3MwClxUSBSYim7YSgYyZHV0w/Kd1OegnAMS32n1FT0HLjmvYxISFQkzBlX7L1TBEtQ==
Received: from DM5PR05CA0024.namprd05.prod.outlook.com (2603:10b6:3:d4::34) by
 LV2PR12MB6016.namprd12.prod.outlook.com (2603:10b6:408:14e::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.20; Wed, 15 Jun 2022 10:52:16 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::a9) by DM5PR05CA0024.outlook.office365.com
 (2603:10b6:3:d4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 15 Jun 2022 10:52:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 10:52:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 10:52:15 +0000
Received: from [172.27.13.119] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 15 Jun
 2022 03:52:12 -0700
Message-ID: <3391f2e5-149a-7825-f89e-8bde3c6d555d@nvidia.com>
Date:   Wed, 15 Jun 2022 13:52:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Bug report: vfio over kernel 5.19 - mm area
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        <akpm@linux-foundation.org>
CC:     jason Gunthorpe <jgg@nvidia.com>, maor Gottlieb <maorg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, <idok@nvidia.com>,
        <linux-mm@kvack.org>
References: <a99ed393-3b17-887f-a1f8-a288da9108a0@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <a99ed393-3b17-887f-a1f8-a288da9108a0@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 178cae68-44d0-4de4-a373-08da4ebd1ca6
X-MS-TrafficTypeDiagnostic: LV2PR12MB6016:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB6016AF80F3578290DCA9B3CDC3AD9@LV2PR12MB6016.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3Fk7yiiKhW//kSlJmA78lSEfsIJN30KZleNM03/le7v625tD++lcnO+b+lyzqehkRXcDI/zj5w2TedszUA2/ByBNDv0Ghf6NqVTxvHIN/oIITZBVNtPBDDVecqqxtK6WczR2l2GGOL1oQbLFH67bsYXUfoTBR36j4ldDESYRoW67GlW2SHpBkv0n5q3eT9+DLyX7RMwoKSIvZ/TqJAGSdE7gb/37wXVytJ7EOCHxrf1/q1EhQVhq5yu4YlkoDy23PZZK2ZCz3BNDk0u2+AjnWJeipR/gntIa854dsndCptBXjU7vYC8p9PpIp6vSQmKh34BEH4LP/LeCmtsHmExQkLj/bt9oPA4uuTvSEbVSgKVOQuWYoaB0eKE6qEPJ8RJIgsFij5empcTIspr5tuLmvasy+BDRSN9005TEj2WTbpx/mBXNe0Y/E6ZkvmKRUj5sVTwT6nzVwhWcPm0Zi6qL1Dof2fjVeb+QAYOFuwgBDRr5Tzve5F7z51+eKlBziODa3yLLA7xuBrgaN+XSTY00GKQFtILvqCcjjhOBSDpwFeRfAScgETdnBAXDTn6hJMsiqwO7vqPqyqyzc5Y1Mg+ndgWhicuvC/jvLA/7/l1LnFi5TspzBSfyut9t67PXv04tYxe0q6akgkF5bOactC8VRUT05pvF2tOUr6mV4u4pv0mDSyjp7+m88lf4KYDWWIMUr0jhCfx4ghDAJpxPBqNNrP4sp/CNkK3hELl301+eZ5zvku0kQgzdKKYAzSCtt9ChbF0io74dKQliXPNoRvzrQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(40470700004)(46966006)(54906003)(356005)(2616005)(36860700001)(110136005)(36756003)(316002)(86362001)(16576012)(81166007)(16526019)(82310400005)(186003)(31686004)(83380400001)(336012)(508600001)(426003)(4326008)(70206006)(8676002)(8936002)(70586007)(26005)(31696002)(5660300002)(2906002)(53546011)(40460700003)(47076005)(36900700001)(2101003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 10:52:16.1721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 178cae68-44d0-4de4-a373-08da4ebd1ca6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6016
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding some extra relevant people from the MM area.

On 15/06/2022 13:43, Yishai Hadas wrote:
> Hi All,
>
> Any idea what could cause the below break in 5.19 ? we run QEMU and 
> immediately the machine is stuck.
>
> Once I run, echo l > /proc/sysrq-trigger could see the below task 
> which seems to be stuck..
>
> This basic flow worked fine in 5.18.
>
> [1162.056583] NMI backtrace for cpu 4
> [ 1162.056585] CPU: 4 PID: 1979 Comm: qemu-system-x86 Not tainted 
> 5.19.0-rc1 #747
> [ 1162.056587] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> [ 1162.056588] RIP: 0010:pmd_huge+0x0/0x20
> [ 1162.056592] Code: 49 89 44 24 28 48 8b 47 30 49 89 44 24 30 31 c0 
> 41 5c c3 5b b8 01 00 00 00 5d 41 5c c3 cc cc cc cc cc cc cc cc cc cc 
> cc cc cc <0f> 1f 44 00 00 31 c0 48 f7 c7 9f ff ff ff 74 0f 81 e7 81 00 
> 00 00
> [ 1162.056594] RSP: 0018:ffff888146253b38 EFLAGS: 00000202
> [ 1162.056596] RAX: ffff888101461980 RBX: ffff888146253bc0 RCX: 
> 000ffffffffff000
> [ 1162.056597] RDX: ffff88814fa22000 RSI: 00007f9f68231000 RDI: 
> 000000010a6b6067
> [ 1162.056598] RBP: ffff888111b90dc0 R08: 000000000002f424 R09: 
> 0000000000000001
> [ 1162.056599] R10: ffffffff825c2a40 R11: 0000000000000a08 R12: 
> ffff88814fa22a08
> [ 1162.056600] R13: 000000010a6b6067 R14: 0000000000052202 R15: 
> 00007f9f68231000
> [ 1162.056602] FS:  00007f9f6c228c40(0000) GS:ffff88885f900000(0000) 
> knlGS:0000000000000000
> [ 1162.056605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1162.056606] CR2: 00005643994fd0ed CR3: 00000001496da005 CR4: 
> 0000000000372ea0
> [ 1162.056607] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [ 1162.056609] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000400
> [ 1162.056610] Call Trace:
> [ 1162.056611]  <TASK>
> [ 1162.056611]  follow_page_mask+0x196/0x5e0
> [ 1162.056615]  __get_user_pages+0x190/0x5d0
> [ 1162.056617]  ? flush_workqueue_prep_pwqs+0x110/0x110
> [ 1162.056620]  __gup_longterm_locked+0xaf/0x470
> [ 1162.056624]  vaddr_get_pfns+0x8e/0x240 [vfio_iommu_type1]
> [ 1162.056628]  ? qi_flush_iotlb+0x83/0xa0
> [ 1162.056631]  vfio_pin_pages_remote+0x326/0x460 [vfio_iommu_type1]
> [ 1162.056634]  vfio_iommu_type1_ioctl+0x421/0x14f0 [vfio_iommu_type1]
> [ 1162.056638]  __x64_sys_ioctl+0x3e4/0x8e0
> [ 1162.056641]  do_syscall_64+0x3d/0x90
> [ 1162.056644]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [ 1162.056646] RIP: 0033:0x7f9f6d14317b
> [ 1162.056648] Code: 0f 1e fa 48 8b 05 1d ad 0c 00 64 c7 00 26 00 00 
> 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed ac 0c 00 f7 d8 64 89 
> 01 48
> [ 1162.056650] RSP: 002b:00007fff4fca15b8 EFLAGS: 00000246 ORIG_RAX: 
> 0000000000000010
> [ 1162.056652] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 
> 00007f9f6d14317b
> [ 1162.056653] RDX: 00007fff4fca1620 RSI: 0000000000003b71 RDI: 
> 000000000000001c
> [ 1162.056654] RBP: 00007fff4fca1650 R08: 0000000000000001 R09: 
> 0000000000000000
> [ 1162.056655] R10: 0000000100000000 R11: 0000000000000246 R12: 
> 0000000000000000
> [ 1162.056656] R13: 0000000000000000 R14: 0000000000000000 R15: 
> 0000000000000000
> [ 1162.056657]  </TASK>
>
> Yishai
>

