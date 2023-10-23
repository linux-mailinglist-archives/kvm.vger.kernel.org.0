Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220367D3F4B
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjJWScm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjJWScl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:32:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1041A8E
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:32:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po+u7oDoGCdNWLb0bBBtrYsmYlu5/r++XDfiugoV8pm5ZePEqcEbINqCb6WSDV+9f3wEi75SyHegyYprmqlh07lmd2Hb+MlGDpTZKML4Kf6aV7el0rjdjOZQOdhq5mAZVAKr+AR+GDF7sRz7ezK21U9DACIu0qc9jtwF8gfxLqMBJBI/xvPXOgsMuvAK2OHeThpeBO5ANZIgTFmAZifwywa/dmBT0Au2h8SVwBdWhJWz4QDn0eQgQjH1sTJSm4b/kKc2rI7pwWDMrUPogKK0XGYnDZtSuePD7u7IlCRmuL/7zm8jEqImJok9x0C6oFNjP48cBoGBPcm67ZleE6MXbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ez3hcPO0K5JMoP94dFJ08QQsTKREiMSX+DMmcU/muiw=;
 b=Dy+raO6MtSTxpPdgCngtFMzd8J+XX8/v/82ps68bhwOs4MMUhoknaCRtRyUALyjCoHwR1lnitVYeVrVZQ1iyOBZdzGDqaTHgjYwbIxH7UkEmazR02mxRdGDI8YGTs4g8SH1tGpNNjYL2pJz9Sj/JYrSZmShaTxPqcm+AWTCHWXGz6WwwqPOOsYDJBnuhyU1fmHQ0Wi4yJxJGqkt9REx1QQjqePxRqJau8osbnhRflDB4IhXSZqL5tWWRwvq2XIHmMAOe1LZ3RSAmxC0JmBVgEwtkIS9o+PCbL5Nyy+wQ9vQegDAx5Ua+iBHEA8RFSpGtf4jv+NxyxcdyBViOqGUvVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ez3hcPO0K5JMoP94dFJ08QQsTKREiMSX+DMmcU/muiw=;
 b=WGYyFQITmhgaL7/V0/0hhdSML47ArErhS7/QidAWRUvyB+F7kJP28R83LsKMDlGGlDc++/g6/+iXaNVOy7RjmblSxSdsXb6bihTe64Qm9GZuuPpYPETkePL5snhynAgiosp2JP0tPe3Qmui0ufbhg10b9M+I1meoIiqCpH7aNdU0HEdgg26Uwv+vjEzRzsMUNdwvwKh7VoLoHBe3JIVLcIzYjYXcu5SgZA6LXcB7iN9Mc4kUiWFtba+yaS68ue9DPB2EjJ/4rcKDg3ncCc5DX4wMjvf0LDHdFghw5e5TwQPb8cic6UFoXM2h6Wae1xtA7gnHavEluFmhdbaq4o72lw==
Received: from CYXPR02CA0021.namprd02.prod.outlook.com (2603:10b6:930:cf::9)
 by PH7PR12MB7186.namprd12.prod.outlook.com (2603:10b6:510:202::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Mon, 23 Oct
 2023 18:32:35 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:930:cf:cafe::3e) by CYXPR02CA0021.outlook.office365.com
 (2603:10b6:930:cf::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.34 via Frontend
 Transport; Mon, 23 Oct 2023 18:32:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Mon, 23 Oct 2023 18:32:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 23 Oct
 2023 11:32:35 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 23 Oct
 2023 11:32:34 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 23 Oct 2023 11:32:33 -0700
Date:   Mon, 23 Oct 2023 11:32:32 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Zhenzhong Duan" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Message-ID: <ZTa8QO9zmdt/bfcj@Asurada-Nvidia>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231021162321.GK3952@nvidia.com>
 <ZTXOJGKefAwH70M4@Asurada-Nvidia>
 <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
 <f6f13ff9-ec92-4759-bd0a-9d17a87509cc@oracle.com>
 <ZTa3n+1WQWRLrhxo@Asurada-Nvidia>
 <f9178725-5706-4d56-b496-5f1bc1c48ef6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f9178725-5706-4d56-b496-5f1bc1c48ef6@oracle.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|PH7PR12MB7186:EE_
X-MS-Office365-Filtering-Correlation-Id: 76e1d5ab-afcb-471c-afd3-08dbd3f66d6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jya/1K46sFjOSTr9rvyKDRlVPFORH4Zpka1VdNGNkjTlqKJgLgQrUxqj5vAmByB0E1FHOH+FC35gngFHZ4uR61tBJOnvfkRJzU9Cdlj3cfIX/4DVAERsu+Tcj0x2KYvtXJkfWpzlJ0RKuPkHkqwbR3PWjL00vNzrc8Tr7AcQCDbOZ/DhYcGJkDnBYHzhVBmvx1UocVpmszMk/dIXNo0kw4Ixp/g58xe/gfMpgqNCv8PnH/zwVdaNtzz7wOZfj1J84mPZHvvVmsIZIUSq50BsMOsPK5q9EclJiRN2Rpv3gj0Dh34LBKLras9zI/V7wqrQv86qDC4v123sr4cfbctfJkEaURs0hCtWaXX7G+fO1ZBIbqUcm6LyVr6/wqfTojTIg3RlX6Nuti3k9qYL7dOSQcDK2TWPeEaIPscaI8lj6tJdxiYEzFzKnxBYUKEdGexi3OzPqg9n4/HPpsX+EYBecPUmikVay7kQn8l2LCsp38QPiWWPf3uDzv1z2zLWeWveacZ6kpIl86+1RwdGLKZRA7uudKXHKiT7tmz1D/qnj1vGFN+91t1FdiKM3G6/K+duNizSKttaCwAj1DCfwqNlXVbuiaBf74J83DNwRcAeFqjI5VUFd4WmssVH+Iyo/MGt6yrZZUuDKPVVWyewbPCCstadehK1UH9fibo6sMdk+Nq26BOdtNHkKkQWueEjo8I+NQWZGl58CCFxCYv2ovNPXLyOian5gVwxeihcz5bkhVsRx8ItXgXZvLA34SIC2vySWSCdVs8+E2HO72EQWaPpww==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(346002)(136003)(376002)(230922051799003)(451199024)(82310400011)(1800799009)(64100799003)(186009)(40470700004)(36840700001)(46966006)(55016003)(2906002)(70586007)(6916009)(316002)(82740400003)(356005)(70206006)(54906003)(478600001)(7636003)(426003)(336012)(40480700001)(9686003)(53546011)(47076005)(83380400001)(45080400002)(41300700001)(4326008)(40460700003)(5660300002)(7416002)(86362001)(8676002)(8936002)(36860700001)(26005)(33716001)(14143004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 18:32:35.3152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e1d5ab-afcb-471c-afd3-08dbd3f66d6b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7186
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 07:21:09PM +0100, Joao Martins wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 23/10/2023 19:12, Nicolin Chen wrote:
> > On Mon, Oct 23, 2023 at 12:49:55PM +0100, Joao Martins wrote:
> >> Here's an example down that avoids the kernel header dependency; imported from
> >> the arch-independent non-atomic bitops
> >> (include/asm-generic/bitops/generic-non-atomic.h)
> >>
> >> diff --git a/tools/testing/selftests/iommu/iommufd.c
> >> b/tools/testing/selftests/iommu/iommufd.c
> >> index 96837369a0aa..026ff9f5c1f3 100644
> >> --- a/tools/testing/selftests/iommu/iommufd.c
> >> +++ b/tools/testing/selftests/iommu/iommufd.c
> >> @@ -12,7 +12,6 @@
> >>  static unsigned long HUGEPAGE_SIZE;
> >>
> >>  #define MOCK_PAGE_SIZE (PAGE_SIZE / 2)
> >> -#define BITS_PER_BYTE 8
> >>
> >>  static unsigned long get_huge_page_size(void)
> >>  {
> >> diff --git a/tools/testing/selftests/iommu/iommufd_utils.h
> >> b/tools/testing/selftests/iommu/iommufd_utils.h
> >> index 390563ff7935..6bbcab7fd6ab 100644
> >> --- a/tools/testing/selftests/iommu/iommufd_utils.h
> >> +++ b/tools/testing/selftests/iommu/iommufd_utils.h
> >> @@ -9,8 +9,6 @@
> >>  #include <sys/ioctl.h>
> >>  #include <stdint.h>
> >>  #include <assert.h>
> >> -#include <linux/bitmap.h>
> >> -#include <linux/bitops.h>
> >>
> >>  #include "../kselftest_harness.h"
> >>  #include "../../../../drivers/iommu/iommufd/iommufd_test.h"
> >> @@ -18,6 +16,24 @@
> >>  /* Hack to make assertions more readable */
> >>  #define _IOMMU_TEST_CMD(x) IOMMU_TEST_CMD
> >>
> >> +/* Imported from include/asm-generic/bitops/generic-non-atomic.h */
> >> +#define BITS_PER_BYTE 8
> >> +#define BITS_PER_LONG __BITS_PER_LONG
> >> +#define BIT_MASK(nr) (1UL << ((nr) % __BITS_PER_LONG))
> >> +#define BIT_WORD(nr) ((nr) / __BITS_PER_LONG)
> >> +
> >> +static inline void set_bit(unsigned int nr, unsigned long *addr)
> >
> > The whole piece could fix the break, except this one. We'd need
> > __set_bit instead of set_bit.
> >
> 
> I changed it set_bit in the caller of course

Can you confirm the test results too? I am seeing test failing
and BUG_ON since this commit:

1d2ac3b64486 (HEAD) iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO

-----logs-----
# ok 133 iommufd_dirty_tracking.domain_dirty128k.set_dirty_tracking
# #  RUN           iommufd_dirty_tracking.domain_dirty128k.device_dirty_capability ... 
# # iommufd.c:1577:device_dirty_capability:Expected IOMMU_HW_CAP_DIRTY_TRACKING (1) == caps & IOMMU_HW_CAP_DIRTY_TRACKING (0)
# # device_dirty_capability: Test terminated by assertion
.....
# # FAILED: 151 / 161 tests passed.

-----bug_on-----
[   29.209521] BUG: unable to handle page fault for address: 000056258adc0000
[   29.209771] #PF: supervisor read access in kernel mode
[   29.209965] #PF: error_code(0x0001) - permissions violation
[   29.210155] PGD 112975067 P4D 112975067 PUD 112976067 PMD 10e5a8067 PTE 800000010973b067
[   29.210446] Oops: 0001 [#1] SMP
[   29.210594] CPU: 1 PID: 857 Comm: iommufd Not tainted 6.6.0-rc2+ #1823
[   29.210842] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[   29.211267] RIP: 0010:iommufd_test+0xb7a/0x1120 [iommufd]
[   29.211480] Code: 82 a8 00 00 00 4c 8b 7d 90 c7 45 98 00 00 00 00 4d 89 cd 4c 89 5d 88 4c 89 75 80 48 89 45 a8 4c 89 95 78 ff ff ff 48 8b 45 b8 <48> 0f a3 18 73 5e 48 8b 4d a8 31 d2 4c 89 e8 49 f7 f4 48 89 c6 48
[   29.212131] RSP: 0018:ffffc900029f7d70 EFLAGS: 00010206
[   29.212348] RAX: 000056258adc0000 RBX: 0000000000000000 RCX: ffff888104296498
[   29.212638] RDX: 0000000000000000 RSI: 0000000094904f49 RDI: ffff888103fa23c8
[   29.212928] RBP: ffffc900029f7e00 R08: 0000000000020000 R09: 0000000001000000
[   29.213214] R10: ffffc900029f7e10 R11: ffffc900029f7e30 R12: 0000000000000800
[   29.213501] R13: 0000000001000000 R14: ffff888104296400 R15: 0000000000000040
[   29.213786] FS:  00007f485e907740(0000) GS:ffff8881ba440000(0000) knlGS:0000000000000000
[   29.214072] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.214310] CR2: 000056258adc0000 CR3: 0000000112974001 CR4: 00000000003706a0
[   29.214592] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   29.214882] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   29.215171] Call Trace:
[   29.215265]  <TASK>
[   29.215358]  ? show_regs+0x5c/0x70
[   29.215496]  ? __die+0x1f/0x60
[   29.215638]  ? page_fault_oops+0x15d/0x440
[   29.215779]  ? exc_page_fault+0x4ca/0x9e0
[   29.215923]  ? lock_acquire+0xb8/0x2a0
[   29.216064]  ? asm_exc_page_fault+0x27/0x30
[   29.216207]  ? iommufd_test+0xb7a/0x1120 [iommufd]
[   29.216435]  ? should_fail_usercopy+0x15/0x20
[   29.216577]  iommufd_fops_ioctl+0x10d/0x190 [iommufd]
[   29.216725]  __x64_sys_ioctl+0x412/0x9b0
[   29.216823]  do_syscall_64+0x3c/0x80
[   29.216919]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   29.217050] RIP: 0033:0x7f485ea0d04f
[   29.217147] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[   29.217593] RSP: 002b:00007ffddef77ca0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   29.217785] RAX: ffffffffffffffda RBX: 0000562588e29d60 RCX: 00007f485ea0d04f
[   29.217982] RDX: 00007ffddef77d30 RSI: 0000000000003ba0 RDI: 0000000000000005
[   29.218177] RBP: 0000562588e29038 R08: 4000000000000000 R09: 0000000000000008
[   29.218372] R10: 0000000000000001 R11: 0000000000000246 R12: 000056258adc0000
[   29.218567] R13: 0000000000000000 R14: 0000000000000040 R15: 0000562588e29d60
[   29.218772]  </TASK>
[   29.218835] Modules linked in: iommufd ib_umad rdma_ucm rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core
[   29.219117] CR2: 000056258adc0000
[   29.219216] ---[ end trace 0000000000000000 ]---


