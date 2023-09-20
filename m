Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA7C7A8604
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 16:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbjITOCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 10:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbjITOCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 10:02:41 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCFFCE;
        Wed, 20 Sep 2023 07:02:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksjWE2TLN1v3TlwzaqJge9305wB8WvlRrg5oMxyGQGwWByACloakePookXH5k2B7Y9Mb7oFDjVt0Sx8igPRdVQon3cc+XsxKHmJ90gj2kRoGAnYrj5mLkiMQ4ZF6Z/XzS5qABRmkOcRaLn90Sorgb2SAIFjeCbEzxRgIY+OxnMci2XR+dfyc2uefzIsVV8VQAcNcdmbqs4c5Mt8aowuVbSJQlToPWjPHAsHnj+gLWcUjs+4TK/4kmaZ3PjVM9HhTYXiRZPw0qQtW90ax0xVYraFUoBOMEs505bm5JyppHCt2AEtjjr+mICUlVaf0+ggCRHdx35W8jE8mvFPQHU4XSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZ9WR5mTfWIaAoV3mw5WTI527fuGHb8ijeoqJ8wZ8Pg=;
 b=jtO0AX2CwqhzQ2FSTPHXLOUDPqM5qRCS0Xi13VAkQUtlNgKgnrtmdIghfBeQdVgG+OVFp1+BAlyds6TpcGK/PUdTRaTlsqwA/RBpaW65xrzt/RGGSjI7OYkIqqn7MwVCHBx4FOm7n4mIxyh7ExrozUYwrjaQWrXIU2gM9CRJfqduWNYmP0RBw5xo/sJTNoAVNRkMOoaZfrCmdLDZfgBrzbMJh60G8wW5tVgP8cOGm1K9x7VrZNJXYlMgjQ2UDiTuR4KwJrqPFsV8YF0ETEWzDXKqZeQkYqVgeUE6DXbdzu4CeuZS8zgYooeBt4acCKndfs+FYVQGFx39sZaRFp1KJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZ9WR5mTfWIaAoV3mw5WTI527fuGHb8ijeoqJ8wZ8Pg=;
 b=De1iAOeQOsvMkcUnNanT2AoEnFnhaoZNi0xDTb/+d7zykHAFz/wYh9771OQxue1H94rJp7NRlOqUIg0Kkm9AmYlo4QLVIpEins1yQ8vhWgBd4TOnIjGrootAbQ+SLL7aNncuh7z3QwxwyFmZg6qfnHUw+iZjgEJPwrFcZRIp3NDS7AuQ/cNQtAUR5rZ0DSpzjkJoZ+62qmoXxVTO9ksDQLQ8POAVnpoGhhqy8vIlHApF+vs8m6/fqynxWKSD5ny9f3//W/KvIaznN/jmci9SHx3hgMiPkkm5Zuru1JNtfLjx1oegtd/rR9ptN+GLqojKFvJX3F1iLvWgZ+IBcRNhxQ==
Received: from DM6PR06CA0059.namprd06.prod.outlook.com (2603:10b6:5:54::36) by
 DS7PR12MB6094.namprd12.prod.outlook.com (2603:10b6:8:9d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.28; Wed, 20 Sep 2023 14:02:32 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::31) by DM6PR06CA0059.outlook.office365.com
 (2603:10b6:5:54::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.29 via Frontend
 Transport; Wed, 20 Sep 2023 14:02:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Wed, 20 Sep 2023 14:02:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:18 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:18 -0700
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 20 Sep 2023 07:02:13 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <akpm@linux-foundation.org>,
        <tony.luck@intel.com>, <bp@alien8.de>, <naoya.horiguchi@nec.com>,
        <linmiaohe@huawei.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <anuaggarwal@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v1 0/4] mm: Implement ECC handling for pfn with no struct page
Date:   Wed, 20 Sep 2023 19:32:06 +0530
Message-ID: <20230920140210.12663-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|DS7PR12MB6094:EE_
X-MS-Office365-Filtering-Correlation-Id: b2d279b5-c173-4101-6432-08dbb9e23be8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 825oSOByUb/cBTlj9EfyOhnC16MF1cATirVI7plUrtb+FME3kaV9KcCSvp89ZPsof1Liagu5Fc7bnLxgdg6sHar/XMT7GXpevvqlyiYjnhG5vmRUxVZszjt9u4Tpsh+sJSFL/APdl48cNi93vph/1w53GTXi+RamjfNuzBptKPsxTiQrjIakhQdv+WmeA5qdiKIqHwztpmF0IkdTvCuCLW4UrV05h54iofOg7nucR/lGNowdYk60LRB0rqkvHwBM8ldfNv5QcDy/Umqi564KfQefH0G5VYrUewUMlH7t0JyEFKPzoe0CDFz1D6iZE6oV5Be3nHmuwu1g0I/gRBs/b/9Lz+oFMtVfoJYjOSBo1DgHhTXfs+qlGwey2hiANf953YSm0SmXuRktF+j6gRkKgRJvd5LkGq+lP6ApVyXR7mRda3HBEXfYzeprxRJRxoDwlu5plXZBZtwE0ntXlzLvMS3yZnQN7hdFsJQzcw3fDILpzKTbDO6948uohwbrhaDV4cCVp7NGeKW42jSQofS7CskqLspYq3Qf/KyyhhmuKJ2HbC4yssFPIwKClMB8+E2pv21Qj6E7/TgQOp8j+rl8TyLXYin6V/CNaL3xvgOJG/MOb5Q8yKGGekniFJ/6ahmIQrQd8ku/77kQYWAOqVsNVl1LXHN2QbyGJYAIPm3YLtGdlS3fenv2uI4QczX8E466Vlf0dJdjKdC1SXb7MugnNzhteCqFB5qMaCAveeLkQuRjI/J6auYx8J1w7UGjfwTjXM1qrOmB5ngBNCDoqzN3zKHdufhLpsDoXbZh747mHKU=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(376002)(346002)(396003)(82310400011)(186009)(451199024)(1800799009)(40470700004)(46966006)(36840700001)(7696005)(6666004)(966005)(83380400001)(478600001)(47076005)(26005)(336012)(426003)(2906002)(2876002)(2616005)(70206006)(70586007)(54906003)(8676002)(110136005)(4326008)(5660300002)(41300700001)(8936002)(316002)(7416002)(356005)(40460700003)(36860700001)(1076003)(86362001)(36756003)(7636003)(82740400003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 14:02:32.0484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d279b5-c173-4101-6432-08dbb9e23be8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6094
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

The kernel MM currently handles ECC errors / poison only on memory page
backed by struct page. As part of [1], the nvgrace-gpu-vfio-pci module
maps the device memory to user VA (Qemu) using remap_pfn_range without
being added to the kernel. These pages are not backed by struct page.

Implement a new ECC handling for memory without struct pages. Kernel MM
expose registration APIs to allow modules that are managing the device
to register its memory region and a callback function. MM then tracks
such regions using interval tree.

The mechanism is largely similar to that of ECC on pfn with struct pages.
If there is an ECC error on a pfn, MM uses the registered memory failure
callback function to notify the module of the faulty PFN, so that the
module may take any required action. The pfn is then unmapped in Stage-2.
When the VM tries to access the page, it gets trapped in KVM, which calls
the vm ops fault function. If the module fault function returns
VM_FAULT_HWPOISON, KVM sends a BUS_MCEERR_AR to the usermode (Qemu) mapped
to the poisoned page.

Lastly, nvgrace-gpu-vfio-pci module make use of the new mechanism to get
poison handling support on the device memory.

Patch generated over v6.6-rc2 and with [1] applied. [1] is currently under
review.

[1] https://lore.kernel.org/all/20230915025415.6762-1-ankita@nvidia.com/

Ankit Agrawal (4):
  mm: handle poisoning of pfn without struct pages
  mm: Add poison error check in fixup_user_fault() for mapped pfn
  mm: Change ghes code to allow poison of non-struct pfn
  vfio/nvgpu: register device memory for poison handling

 drivers/acpi/apei/ghes.c            |  12 +--
 drivers/vfio/pci/nvgrace-gpu/main.c | 107 +++++++++++++++++++++-
 drivers/vfio/vfio.h                 |  11 ---
 drivers/vfio/vfio_main.c            |   3 +-
 include/linux/memory-failure.h      |  22 +++++
 include/linux/mm.h                  |   1 +
 include/linux/vfio.h                |  15 ++++
 include/ras/ras_event.h             |   1 +
 mm/Kconfig                          |   1 +
 mm/gup.c                            |   2 +-
 mm/memory-failure.c                 | 135 +++++++++++++++++++++++-----
 virt/kvm/kvm_main.c                 |   6 ++
 12 files changed, 270 insertions(+), 46 deletions(-)
 create mode 100644 include/linux/memory-failure.h

-- 
2.17.1

