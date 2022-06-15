Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9FA54C667
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 12:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbiFOKnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 06:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiFOKnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 06:43:13 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEE74D9C9
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 03:43:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DA4Qe/U5fbwFWcuDftWKNmsOwd+5PVkaKb6xLpqa3B9j94YuvDh1ZNGhJmBngOpbvcJ//1iv5ZUlwoxfZr4Ws/OWH1r28FzCAvem5j2Iku3DE4XD28qc3O6LvFZ1+641ATgSKlReDqtKxvrbtwg1FEHw65oTNON3Jhsgi+80gVeHVb5Qd1A4/Gp2x5p7MkPh0DRMfbVC33PIhciHBuxu5SJXfDzwie22ka2G5xnOHRvNxEyS4l85OD8bXaV/qnPl2hJhG9ZOFpeh5cqck5HOlAFAOmbTA84fguEkLstoz4HLm+yHG6H8SJ6XVg3X/tM57Rcaat1bPXpf8y41Wm4QGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SA5oS7OzWomoTSw71Gk6LhrrQIL5qRaSWSZMqLFQtC0=;
 b=DqWUveYj2HSqh3d202rzgsSuExnxSO6iyzrKLeT/aQPJsTI1jC5sZHwtlflz0PEj0C//XqxzVkLHG+4OFvTT1U0BhXum1PI9eYw52duO9njqjy1rDL6ne8CJWbez+xSh1AoEr+9dgw+Pq4eaTz+JYI8eY2hIMQEpchmiSQzqHM+ifaoFnAlk+2luClGTz8bq879INkhVoX8WQqjKzheRPNNKh6/IJdbG9cE0lPzkRQNTltkH/tyCJGQwTNS460R5sVo1H+JFAgKjVhMg/v044uIWNFdoLy7hIQmby69yBU6HgLulJgp0IY6fz9psHgXK3ov9hKrqPQadPhz237jA9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SA5oS7OzWomoTSw71Gk6LhrrQIL5qRaSWSZMqLFQtC0=;
 b=I1gyj0dYBjTKuXx2ktfEnZpEInwz83GAr5TeeKog7a9s6594IflpEH7IIrxQIUOMrOz3+hJ2UcbEQNTRUyqE/+8NdIY1TDouJsDynBakCq/qkVhUGJ+a167f5J33Ifg41T7SJX3cBufPXUH6K9MeNQ/pvB53gY3ssFsVFxFAdcLg8fIUX6gcfcgUiklj1Nqffu0srna+ZiQQetYQ8axhTmbuUIiQbZYIrxoq7u4S2YZPqsF2ivFyWwZwPRzIk01Tepz+Efu/Dh+oxbuf4xMEZ4b040WeYtlQUYRd7IBXtqWOA8TJCBn65sh8VOSjXbdWb++ntUrm8BGl9KXePh5iyg==
Received: from BN6PR17CA0048.namprd17.prod.outlook.com (2603:10b6:405:75::37)
 by MN2PR12MB2957.namprd12.prod.outlook.com (2603:10b6:208:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 10:43:09 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::e1) by BN6PR17CA0048.outlook.office365.com
 (2603:10b6:405:75::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Wed, 15 Jun 2022 10:43:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 10:43:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 10:43:07 +0000
Received: from [172.27.13.119] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 15 Jun
 2022 03:43:04 -0700
Message-ID: <a99ed393-3b17-887f-a1f8-a288da9108a0@nvidia.com>
Date:   Wed, 15 Jun 2022 13:43:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
Subject: Bug report: vfio over kernel 5.19 - mm area
To:     <"linux-mm@kvack.org akpm"@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     jason Gunthorpe <jgg@nvidia.com>, maor Gottlieb <maorg@nvidia.com>,
        "Yishai Hadas" <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, <idok@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06175284-b63d-495d-76a4-08da4ebbd696
X-MS-TrafficTypeDiagnostic: MN2PR12MB2957:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2957A530153EC876BB272ED2C3AD9@MN2PR12MB2957.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aiJqnezEXZnkM/kq530TJsnfK17lLJoNc79RC9m0482E3Rw4d0YOMi6jSk0VzzkXjxUgZIxJxGQeHJzAIhhP+uXpTJlDPdung9OBWefP/kzTq2N+sb+57FcxGoJ5h4bmxXEGIeRvK8bxAx+BgZ/ym++ScerwYDx2FzeFLX5udyVg84mwgDwe3m/QThhJixJyWOzKMhx3GGG5QsIPjYKZjuVZ1DQuIj+6zqqYxLNzRC34UHBPTXODFF2uSQgvm0cneMxzhrYJOivg5i+gTa/+ko2Dh9Kxku9Z1XTz8ZCqSwALPs8cJMcuR8lZXO7TAqO1i2cRofdiZMPRissWg00FdYpCvu5Ma5nzLNoNI9P/BF9GTt5swfoasck1VVIKLr1+hunEhjnnXdqBhGZiuHyeBXV10mSy9DDRwnxtdzi4RBh88tbdjz0o9atyNNK2tPPOwp7K7qyydRipUkscJbFDL679A3SJ4qyAcqJCI2McLNiU6/khaLd+54nhDu0fh4ybe7nSJFLOlDaM/Sh7EdZUuWhZXwoJ9r035vi3mWeh2IjwRBi36ziPFUj29yiEdTHw2zLfDjZ37ngTLAwKo0Y1SntQyH6H/DaDob7hT9STmuPLl2cOA5lyUg+yall72g9t7uhvhbZwgcdOSy0kL4yRKo+0xQSz0bNmCVtTbVSqR1Hmzk53Cs0CRs9t/wrtwgMEEZvlN4pO3X393hfVRdKpRt+t0qcZzzPNbBQSXZtczTv7pssp5nYXeH08myp9GSph
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(46966006)(40470700004)(356005)(16576012)(81166007)(86362001)(82310400005)(54906003)(316002)(36756003)(47076005)(426003)(336012)(16526019)(107886003)(36860700001)(2616005)(508600001)(26005)(8936002)(186003)(5660300002)(83380400001)(4326008)(70206006)(70586007)(8676002)(2906002)(31696002)(31686004)(40460700003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 10:43:09.0663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06175284-b63d-495d-76a4-08da4ebbd696
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2957
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

Any idea what could cause the below break in 5.19 ? we run QEMU and 
immediately the machine is stuck.

Once I run, echo l > /proc/sysrq-trigger could see the below task which 
seems to be stuck..

This basic flow worked fine in 5.18.

[1162.056583] NMI backtrace for cpu 4
[ 1162.056585] CPU: 4 PID: 1979 Comm: qemu-system-x86 Not tainted 
5.19.0-rc1 #747
[ 1162.056587] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[ 1162.056588] RIP: 0010:pmd_huge+0x0/0x20
[ 1162.056592] Code: 49 89 44 24 28 48 8b 47 30 49 89 44 24 30 31 c0 41 
5c c3 5b b8 01 00 00 00 5d 41 5c c3 cc cc cc cc cc cc cc cc cc cc cc cc 
cc <0f> 1f 44 00 00 31 c0 48 f7 c7 9f ff ff ff 74 0f 81 e7 81 00 00 00
[ 1162.056594] RSP: 0018:ffff888146253b38 EFLAGS: 00000202
[ 1162.056596] RAX: ffff888101461980 RBX: ffff888146253bc0 RCX: 
000ffffffffff000
[ 1162.056597] RDX: ffff88814fa22000 RSI: 00007f9f68231000 RDI: 
000000010a6b6067
[ 1162.056598] RBP: ffff888111b90dc0 R08: 000000000002f424 R09: 
0000000000000001
[ 1162.056599] R10: ffffffff825c2a40 R11: 0000000000000a08 R12: 
ffff88814fa22a08
[ 1162.056600] R13: 000000010a6b6067 R14: 0000000000052202 R15: 
00007f9f68231000
[ 1162.056602] FS:  00007f9f6c228c40(0000) GS:ffff88885f900000(0000) 
knlGS:0000000000000000
[ 1162.056605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1162.056606] CR2: 00005643994fd0ed CR3: 00000001496da005 CR4: 
0000000000372ea0
[ 1162.056607] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1162.056609] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[ 1162.056610] Call Trace:
[ 1162.056611]  <TASK>
[ 1162.056611]  follow_page_mask+0x196/0x5e0
[ 1162.056615]  __get_user_pages+0x190/0x5d0
[ 1162.056617]  ? flush_workqueue_prep_pwqs+0x110/0x110
[ 1162.056620]  __gup_longterm_locked+0xaf/0x470
[ 1162.056624]  vaddr_get_pfns+0x8e/0x240 [vfio_iommu_type1]
[ 1162.056628]  ? qi_flush_iotlb+0x83/0xa0
[ 1162.056631]  vfio_pin_pages_remote+0x326/0x460 [vfio_iommu_type1]
[ 1162.056634]  vfio_iommu_type1_ioctl+0x421/0x14f0 [vfio_iommu_type1]
[ 1162.056638]  __x64_sys_ioctl+0x3e4/0x8e0
[ 1162.056641]  do_syscall_64+0x3d/0x90
[ 1162.056644]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 1162.056646] RIP: 0033:0x7f9f6d14317b
[ 1162.056648] Code: 0f 1e fa 48 8b 05 1d ad 0c 00 64 c7 00 26 00 00 00 
48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed ac 0c 00 f7 d8 64 89 01 48
[ 1162.056650] RSP: 002b:00007fff4fca15b8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[ 1162.056652] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 
00007f9f6d14317b
[ 1162.056653] RDX: 00007fff4fca1620 RSI: 0000000000003b71 RDI: 
000000000000001c
[ 1162.056654] RBP: 00007fff4fca1650 R08: 0000000000000001 R09: 
0000000000000000
[ 1162.056655] R10: 0000000100000000 R11: 0000000000000246 R12: 
0000000000000000
[ 1162.056656] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000000
[ 1162.056657]  </TASK>

Yishai

