Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB666D8586
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjDESCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDESCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:02:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D837D87;
        Wed,  5 Apr 2023 11:02:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ak/XaT6ZVJ6+H+MzYjK5xoBadbY46YfMArAL1uhRI43u7F7Ztw/SsW5/2eAOsZ8BtIpefjvPSarUDwLQ5wlilTSXOEvhN/ahdAi7KKpOXQhrNj0Z7WJgJgIkI7KxU5/rYjRgfioTfsItc8jYJMJY6hVzokL6wdjN9lDorZAmnd2iep6Kv0dcfhopAt83dOA/F7ConthWJV4UZ1jc/s+X+OIG/oajRIEmtzKusIf679d+E/KRFsDLArqXtGvVIMkIxL7tspBaijzd1crv+Ra2E9LmJVDaeVD0dm6QCwR3GvUh7CeHq7hA9LHyJVwEgHC5oNAjDIbFPtS2y+PksaYDPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwQUxEBOMHJ6eWfIzwI/es+2mWD6zlsFPG/G51FI1X0=;
 b=Ct1DMFiNQOL9kHeZlibHMGGp3211mtHWuMK9BNkcIBsLQ1eu2jISOFcKorpecekJhHGl5DjRMhWH7hqCB0UaZLqyTcVGAbFOlI38mUifJAhefeQZzCsts9dHftfCDRHyLP0fPHfjANvnoQZt7YWQE4KNYglX0O/6Y9tRzbJR3sSOQY0k8LAot2G9M5U50BRfaDgJErIVR7zBfhW0VHbTGWElpcP6ohC8MZMYTWnrl6z0ZvxVuIb0KlFslH6GRavNS/+EU/wJU+z9aYgOOOgKJNcrpckvXrNSZcXfvMGibAtBoEGcVeLdMoLm8C8THlKPSr0uhc2NTQA3coq8chmAMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwQUxEBOMHJ6eWfIzwI/es+2mWD6zlsFPG/G51FI1X0=;
 b=ExDQYqPKRhxrykyszD0F0t4kd93rIaCMXQD2MTtYlWV2kZkfRxCEPZQ08cBSAa+156kXnmwvLTvVxD7HKtfHk1dHwrkCTe0mPSreEeVEcQvpui9k17OqyirLo6dnrobYqpmLKzJclCnPB2MfVyE0+jckNMpPERJV+OIco9af0Bouc74gJ5505EBEvFYiFX89CDKC+I8W8GO2fEcAIx2itdc0TQaqcK+z2Pvjh5Ge7rL7ncG2K9FbN67sJ6kp+OjWrtV9vmFAwxipkIRg6ylssVrM9FI6+7VcJHQt5tfwJ2AYAO/+frO4aJCurG2EJBYUBf1yjskQIHUqlbisu2wdtw==
Received: from DM6PR17CA0022.namprd17.prod.outlook.com (2603:10b6:5:1b3::35)
 by BL3PR12MB6644.namprd12.prod.outlook.com (2603:10b6:208:3b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 18:02:05 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::82) by DM6PR17CA0022.outlook.office365.com
 (2603:10b6:5:1b3::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Wed, 5 Apr 2023 18:02:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.28 via Frontend Transport; Wed, 5 Apr 2023 18:02:05 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 5 Apr 2023
 11:01:35 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 5 Apr 2023 11:01:34 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 5 Apr 2023 11:01:34 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <naoya.horiguchi@nec.com>,
        <maz@kernel.org>, <oliver.upton@linux.dev>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
Subject: [PATCH v3 0/6] Expose GPU memory as coherently CPU accessible
Date:   Wed, 5 Apr 2023 11:01:28 -0700
Message-ID: <20230405180134.16932-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|BL3PR12MB6644:EE_
X-MS-Office365-Filtering-Correlation-Id: 32c0a2c3-803f-48f9-5185-08db35ffddb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5bMWUgavq7pEqU/JQ0Aq5R35zfL1jKY6s7nKrpjQ4i23zFNDutfJxDN0Ig2Hvm5IR1lz0c4+Z9CApsR991/1+mb+alFOKPODbAIJOf6SQ1aInVuL4wjROYLh8lR5LdyQbA149ZoCMljm59xbk1U2CiMtojWKykhRkZpDHxpZ9sU9KTIXZQLpl3LpxfpDRHh068TjXuP0ccJaMcHUXU+OwOmiMnT31XsXOl0TcBR3ZEeJzsyI3s0ha5zBwz/QvuozE3iZZkZ8oYVY0QlP8qu+dEB9ZwlBxRO9aBjyRFdDOETVyoon1nWVmtuqmj8abaGBbD4oReBX0Jbl+x0R4BjCdLoSNTrHhmfVUQBP67QNXk3ZzbYGALyBTCCPKA0N6FTm6j3EbNoRx5zxWvBMIUJGwoXNHYktwrze8fKY6rODKwQinZT8Kz/n/7Fn0XFwQi6nuOrwKGoCB5f6yO7NarCkj9SIPgkS2FNKgu0hP3mAGfs89Ysv0/xBKMmAzcFUuIYfwXuq9PJNpE5w6fY1gYv51/ZF8r61gDcweA8QG42YqKm1hyvVeIxx0hY8GOnMER0Cptvb4sl3dfOcF5Q2RXREox+dcdoWEVUJO1VUqq3NJv/sejX437g+pGhChl1J62Lyve3glFyB2OsaBoAUoF5Cex5SkHCWtxQxe2NNUtGs78JyShw+7sVZQamqO89wh/LtOhOLkGcRoNyzTyfCbgNFRJUfpk5Ss/KWnHzw4kNIXZlLY36amxJR/OcZeCiLquY2fdGbEUbQQ+Ue030guHvqHTENKQj/0tIEhmWvQMNZRo=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(82310400005)(36756003)(2906002)(2876002)(966005)(7636003)(40480700001)(2616005)(47076005)(336012)(426003)(186003)(1076003)(6666004)(83380400001)(26005)(316002)(8676002)(70206006)(82740400003)(70586007)(36860700001)(4326008)(478600001)(40460700003)(5660300002)(356005)(54906003)(8936002)(110136005)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 18:02:05.4296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c0a2c3-803f-48f9-5185-08db35ffddb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6644
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
for the on-chip GPU that is the logical OS representation of the
internal propritary cache coherent interconnect.

This representation has a number of limitations compared to a real PCI
device, in particular, it does not model the coherent GPU memory
aperture as a PCI config space BAR, and PCI doesn't know anything
about cacheable memory types.

Provide a VFIO PCI variant driver that adapts the unique PCI
representation into a more standard PCI representation facing
userspace. The GPU memory aperture is obtained from ACPI, according to
the FW specification, and exported to userspace as the VFIO_REGION
that covers the first PCI BAR. qemu will naturally generate a PCI
device in the VM where the cacheable aperture is reported in BAR1.

Since this memory region is actually cache coherent with the CPU, the
VFIO variant driver will mmap it into VMA using a cacheable mapping.

As this is the first time an ARM environment has placed cacheable
non-struct page backed memory (eg from remap_pfn_range) into a KVM
page table, fix a bug in ARM KVM where it does not copy the cacheable
memory attributes from non-struct page backed PTEs to ensure the guest
also gets a cacheable mapping.

Finally, the cacheable memory can participate in memory failure
handling. ECC failures on this memory will trigger the normal ARM
mechanism to get into memory-failure.c. Since this memory is not
backed by struct page create a mechanism to route the memory-failure's
physical address to the VMA owner so that a SIGBUS can be generated
toward the correct process. This works with the existing KVM/qemu
handling for memory failure reporting toward a guest.

This goes along with a qemu series to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device.
https://github.com/qemu/qemu/compare/master...ankita-nv:qemu:dev-ankit/cohmem-0330

Applied and tested over v6.3-rc4.

Ankit Agrawal (6):
  kvm: determine memory type from VMA
  vfio/nvgpu: expose GPU device memory as BAR1
  mm: handle poisoning of pfn without struct pages
  mm: Add poison error check in fixup_user_fault() for mapped PFN
  mm: Change ghes code to allow poison of non-struct PFN
  vfio/nvgpu: register device memory for poison handling

 MAINTAINERS                          |   6 +
 arch/arm64/include/asm/kvm_pgtable.h |   8 +-
 arch/arm64/include/asm/memory.h      |   6 +-
 arch/arm64/kvm/hyp/pgtable.c         |  16 +-
 arch/arm64/kvm/mmu.c                 |  27 +-
 drivers/acpi/apei/ghes.c             |  12 +-
 drivers/vfio/pci/Kconfig             |   2 +
 drivers/vfio/pci/Makefile            |   2 +
 drivers/vfio/pci/nvgpu/Kconfig       |  10 +
 drivers/vfio/pci/nvgpu/Makefile      |   3 +
 drivers/vfio/pci/nvgpu/main.c        | 359 +++++++++++++++++++++++++++
 include/linux/memory-failure.h       |  22 ++
 include/linux/mm.h                   |   1 +
 include/ras/ras_event.h              |   1 +
 mm/gup.c                             |   2 +-
 mm/memory-failure.c                  | 148 +++++++++--
 virt/kvm/kvm_main.c                  |   6 +
 17 files changed, 586 insertions(+), 45 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgpu/main.c
 create mode 100644 include/linux/memory-failure.h

-- 
2.17.1

