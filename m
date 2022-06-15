Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592F854CB28
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244348AbiFOOW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238295AbiFOOWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:22:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98B635A97
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:22:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDLrXJ6mBLKw4/3k7XLTIoCQemJd678XklFNZQiVAaovn8+aOybnssa5wEJzS3QLORbB3uVxOy1N/B79RoEp2pfbn1kRiIZopVbZpbxxHwJtxR0rW6dHadVpeVKq7r+7b4uGahiQFYkE579p4gjqYz2SFUdKY6+5bxUB3Eat/s9oqyavNztL8nrlfd+W4BRShGY/bhs0qYJ9Lfv7W4EEWA6+TYYj9fjqKQZGws5tZFsfi2rvDonOhSACP6iBZd3Ww0NDK/0t260LZleqPgPuWl9ixpdmZqtiJiAh1X+u+jrsoZw8GOuG7RhptSodgFr1ei4XGHtnwQLSH0X5rzandA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWHM5T5R0X+ochVnqtqwqT130l8jP32aNSwBtz05v0M=;
 b=PN5IkH8C0xLieYUXuFPDgUgA6YGGNPnUHzFVuCfdVhRSDW6DtbS4kQpQg4dPJz6O0qs7sXWJ8/l7XGnECmuLeiAVG8Ibk6Yx6ASkYoTtrjDe5Yez7PJGnZj77C8+W3gGvMxp+IVkP2duF+pVMw4uhoBNGnn2ZvloFPndS0zHR95+BzvchtR8RL4dGrFDsjAuDdvidunNVnu2TB9wpJeu8jZ4+wdb6epP+B7k+NXglqc6LBhzJBgtiyuJt6OPXSxHtiFe5AZq8/MnoIoJ5QLb1lDhkZKwS5DGaoP2w9GWzAIAX2oaHn+p5oKbbifTwnJp0xMcz7hXXtk4v9QUsWVJyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWHM5T5R0X+ochVnqtqwqT130l8jP32aNSwBtz05v0M=;
 b=k9nQR3ed9u82378SRb/KXj8X/hbHX4aRGGRWZLtwD/vIqfT+OvXZboI+B9hBw2uWDhBWfWnA7NdUlAh7k3LDCYPGMcECva+/uaff92DFzRIR7UzOD5bcDiWEPFABmEp7Xsfoyz42KNHCFd8OBgpLhQKqWaPad8ZMtXSTrbzx+jHDX2tbX1pb7n8gGdZQjI5xHmjmD3B3Ag8qkxIF4POIGtyG0BX+HgtzENc8o35+woiEQXVGX+mPHfTcb6AprYozTS034+fdnEWqu7PG4/8jBnDSXl2fSWy9UNgxDMdHmzyKNCU+cCq/lxVJ5S0d/o/1F4q6MPGkHGVEY/Lw8HH6wQ==
Received: from DM6PR03CA0023.namprd03.prod.outlook.com (2603:10b6:5:40::36) by
 SJ0PR12MB5634.namprd12.prod.outlook.com (2603:10b6:a03:429::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.20; Wed, 15 Jun 2022 14:22:22 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::2c) by DM6PR03CA0023.outlook.office365.com
 (2603:10b6:5:40::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15 via Frontend
 Transport; Wed, 15 Jun 2022 14:22:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 14:22:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 14:22:16 +0000
Received: from [172.27.13.119] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 15 Jun
 2022 07:22:13 -0700
Message-ID: <572592c1-ff69-fba0-9cda-15d5c584a742@nvidia.com>
Date:   Wed, 15 Jun 2022 17:22:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Bug report: vfio over kernel 5.19 - mm area
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <akpm@linux-foundation.org>, jason Gunthorpe <jgg@nvidia.com>,
        "maor Gottlieb" <maorg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, <idok@nvidia.com>,
        <linux-mm@kvack.org>
References: <a99ed393-3b17-887f-a1f8-a288da9108a0@nvidia.com>
 <3391f2e5-149a-7825-f89e-8bde3c6d555d@nvidia.com>
 <20220615080228.7a5e7552.alex.williamson@redhat.com>
 <00724e48-b6db-4b80-8b53-dbf2b2ca4017@intel.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <00724e48-b6db-4b80-8b53-dbf2b2ca4017@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4580aa88-29b5-4798-2e8a-08da4eda7668
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5634:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5634D4359FD9138A05602CDAC3AD9@SJ0PR12MB5634.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QvkNQitpQqOKoTzbKv3jYXVyyQkRR0o5WzQeWe0morDyS+uvjmUo/vGOi1cW50ZoGP5UdMv4lYdCeIx7bRi6OS1FziZcrzfm7DG0XQSj6lF0AdZ9JpaZPfLyEfHMsjqxMv8rLVFuvtFGsb3saw80UVlP+z+3VKTfIKtC41muDbGzkVDbjYniuraASPUFnnq7MLiyfUVQRd5BYdAhOTfnWhg6/biMBTiZ26vXlqhXU19rSiaSjrXqpV9RKnm31amP8uh+lwOEiKDAkiGsY9ZSswoPGIkr7m5BsId+jY6eSclw8Jzu2c3AltTfjL23yqYergGez0/ItXJt8b8IR7oZp3lcP/MNB3+il9WIHkO+h7nfBO62Vy1T0kT57qqo3GdYi+5WBKHgEuhdt6M/Ktq2X/OsZ/MBDlBcJRq3zxWSN+sIluo+4UFPCYuqCcI8ugT1eNfN8RhR3ovb3nqQLIkB4ybth8IU7DtOulGyZb4z4kvap9CS52D29buKUs2xLX/YvIQcp1LSCvHcByB3hNbp2RANYaMo0prqT1NChUJmLbwXm+raELpyRZu7Q9ItRzttNrxt6vq5+XvtalfvHIUGH91rgufQ1SXNAzTPkjcuzsMS/zwg/O/Lx4qe1XBAWukOWKVBPTuiwSJQYjbYRMVo5vRospz0nECt4sGsgma2bYordlHef5sqP74q7mpC3/gbOQp/fFv1ch9O5LPx3ZzpFyHUCZFJnzqooNREg4Ba+ovIOUleWpHMPj236MaL6yTdfLsICcUJpc+uIKt6gdhQq7JE2N6BbfOVBgs2Vkv8IywpYx2+wB0cYcTjyPrdHGR6ewebq3zyIcgW7WFB3zWomg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(46966006)(40470700004)(47076005)(81166007)(426003)(40460700003)(36860700001)(110136005)(336012)(70586007)(82310400005)(186003)(356005)(31686004)(83380400001)(16526019)(8936002)(16576012)(5660300002)(54906003)(966005)(4326008)(8676002)(86362001)(53546011)(2616005)(31696002)(70206006)(36756003)(316002)(508600001)(26005)(2906002)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 14:22:22.1472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4580aa88-29b5-4798-2e8a-08da4eda7668
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5634
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

On 15/06/2022 17:14, Yi Liu wrote:
> Hi Alex,
>
> On 2022/6/15 22:02, Alex Williamson wrote:
>> On Wed, 15 Jun 2022 13:52:10 +0300
>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>
>>> Adding some extra relevant people from the MM area.
>>>
>>> On 15/06/2022 13:43, Yishai Hadas wrote:
>>>> Hi All,
>>>>
>>>> Any idea what could cause the below break in 5.19 ? we run QEMU and
>>>> immediately the machine is stuck.
>>>>
>>>> Once I run, echo l > /proc/sysrq-trigger could see the below task
>>>> which seems to be stuck..
>>>>
>>>> This basic flow worked fine in 5.18.
>>
>> Spent Friday bisecting this and posted this fix:
>>
>> https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen/ 
>>
>>
>> I expect you're hotting the same.  Thanks,
>
> I also hit a hang at calling pin_user_pages_remote() in the
> vaddr_get_pfns(). With the fix in the link, the issue got fixed.
> You may add my test-by to your fix. :-)


Thanks Alex, it seems to be the same issue, with your fix I don't hit 
the problem.


>
>> Alex
>>
>>>>
>>>> [1162.056583] NMI backtrace for cpu 4
>>>> [ 1162.056585] CPU: 4 PID: 1979 Comm: qemu-system-x86 Not tainted
>>>> 5.19.0-rc1 #747
>>>> [ 1162.056587] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>>>> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>>>> [ 1162.056588] RIP: 0010:pmd_huge+0x0/0x20
>>>> [ 1162.056592] Code: 49 89 44 24 28 48 8b 47 30 49 89 44 24 30 31 c0
>>>> 41 5c c3 5b b8 01 00 00 00 5d 41 5c c3 cc cc cc cc cc cc cc cc cc cc
>>>> cc cc cc <0f> 1f 44 00 00 31 c0 48 f7 c7 9f ff ff ff 74 0f 81 e7 81 00
>>>> 00 00
>>>> [ 1162.056594] RSP: 0018:ffff888146253b38 EFLAGS: 00000202
>>>> [ 1162.056596] RAX: ffff888101461980 RBX: ffff888146253bc0 RCX:
>>>> 000ffffffffff000
>>>> [ 1162.056597] RDX: ffff88814fa22000 RSI: 00007f9f68231000 RDI:
>>>> 000000010a6b6067
>>>> [ 1162.056598] RBP: ffff888111b90dc0 R08: 000000000002f424 R09:
>>>> 0000000000000001
>>>> [ 1162.056599] R10: ffffffff825c2a40 R11: 0000000000000a08 R12:
>>>> ffff88814fa22a08
>>>> [ 1162.056600] R13: 000000010a6b6067 R14: 0000000000052202 R15:
>>>> 00007f9f68231000
>>>> [ 1162.056602] FS:  00007f9f6c228c40(0000) GS:ffff88885f900000(0000)
>>>> knlGS:0000000000000000
>>>> [ 1162.056605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [ 1162.056606] CR2: 00005643994fd0ed CR3: 00000001496da005 CR4:
>>>> 0000000000372ea0
>>>> [ 1162.056607] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>>> 0000000000000000
>>>> [ 1162.056609] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>>>> 0000000000000400
>>>> [ 1162.056610] Call Trace:
>>>> [ 1162.056611]  <TASK>
>>>> [ 1162.056611]  follow_page_mask+0x196/0x5e0
>>>> [ 1162.056615]  __get_user_pages+0x190/0x5d0
>>>> [ 1162.056617]  ? flush_workqueue_prep_pwqs+0x110/0x110
>>>> [ 1162.056620]  __gup_longterm_locked+0xaf/0x470
>>>> [ 1162.056624]  vaddr_get_pfns+0x8e/0x240 [vfio_iommu_type1]
>>>> [ 1162.056628]  ? qi_flush_iotlb+0x83/0xa0
>>>> [ 1162.056631]  vfio_pin_pages_remote+0x326/0x460 [vfio_iommu_type1]
>>>> [ 1162.056634]  vfio_iommu_type1_ioctl+0x421/0x14f0 [vfio_iommu_type1]
>>>> [ 1162.056638]  __x64_sys_ioctl+0x3e4/0x8e0
>>>> [ 1162.056641]  do_syscall_64+0x3d/0x90
>>>> [ 1162.056644]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>>> [ 1162.056646] RIP: 0033:0x7f9f6d14317b
>>>> [ 1162.056648] Code: 0f 1e fa 48 8b 05 1d ad 0c 00 64 c7 00 26 00 00
>>>> 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00
>>>> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed ac 0c 00 f7 d8 64 89
>>>> 01 48
>>>> [ 1162.056650] RSP: 002b:00007fff4fca15b8 EFLAGS: 00000246 ORIG_RAX:
>>>> 0000000000000010
>>>> [ 1162.056652] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
>>>> 00007f9f6d14317b
>>>> [ 1162.056653] RDX: 00007fff4fca1620 RSI: 0000000000003b71 RDI:
>>>> 000000000000001c
>>>> [ 1162.056654] RBP: 00007fff4fca1650 R08: 0000000000000001 R09:
>>>> 0000000000000000
>>>> [ 1162.056655] R10: 0000000100000000 R11: 0000000000000246 R12:
>>>> 0000000000000000
>>>> [ 1162.056656] R13: 0000000000000000 R14: 0000000000000000 R15:
>>>> 0000000000000000
>>>> [ 1162.056657]  </TASK>
>>>>
>>>> Yishai
>>>
>>
>

