Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A353553FBA
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 02:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355375AbiFVAym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 20:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbiFVAyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 20:54:41 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9C530569;
        Tue, 21 Jun 2022 17:54:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrKkrAtuxpSLiWb9gqrVi594QFt3HB3DWI5TJr61sNT07yy5kvAAf9E4XcOWA9Oi/A70N2TovWeqbxFJwvSC+do+69kmcGwtONGelI7PrtJlnfTKlwL1Sx52+MBmmqEnwb6kId+00zHrryEj2qePFLzr5YrSUAMB3ZTTJI+gzd/TgZG4MJGpOh6j6c0RpmT+oRAnN78g6XPV1y0weqUS3KvckJCFwd8T2BBkO8w3EcUhM7i1XWjHinH4eWHZthkbUTylkeAXQ+PUFtvXX8EnoaAN7tUR1k3beaAWpdASKQNuX0hpuwlIXC0KYltxuRcMQTrGkyMyRXKazUyoVrEw0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbMi9KsW5yiL8Z6e9HfEG5iGgvLhkePXERkkh6KmAYk=;
 b=Qp+vd2kee+yHKq7twhoAF+wXtzi+d1V2kDR0E5MUQS8b/LBtoCU+Q5AqH6scRQFOouQTep7JO2Yc0cQmmE0H85adtXdLu4ZCRAw8Fm76R6B9Io7npgD1TBSTV2QQ2Y+2tb7yy+Ra4WxDOjSRi9Z3S4GRfce5zNoKXaV09WYcYHbwNQsdAxKsWsBExpUhEfph3OQd6Cub6qIbooqjPcLmcKm/2eJEDtL7Do8/LuLEFVqECUn5GXQQsMVuOvU5ZMqjhgdalEuC8ZlIRnXVwDJ/84BSLcmFRwe4hLcedPRLqBF8f9HnkyvrIPEo1irxz4BQmEH9LTzkDTPnUMdP9SS/9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbMi9KsW5yiL8Z6e9HfEG5iGgvLhkePXERkkh6KmAYk=;
 b=X6XTqY5HLCn+SV17UEWlHirSxT7VVN19AO464cUNjK6eyH4qMMACtFC0k9xJLudRVZ6dOwXKxONVzA6QDdoy2F/LGVNL9UEhjFGa3nmY4T74MU0gHz7i3yQiak8XdGlJzJtYD0n/hsnHTHQmpYTIXIrDOpi0aMKZWTgTBTjCtEDEx2YuitqMVpGot1FDGeTTT8oBDH+Wmgo1zH+qaIu5FdFmIvJlZsPrEyCTfOnp2mFYEZmTess8CpKbVAHF+cEhgYMbaFXlXquXWDhNYpel+OFUkrzwe4af63aNgMF/g6Bej2Phg2UUTa9nI95C9Vjw37BPUqDyPgiOwaGhE7eD4g==
Received: from BN6PR19CA0060.namprd19.prod.outlook.com (2603:10b6:404:e3::22)
 by BL1PR12MB5301.namprd12.prod.outlook.com (2603:10b6:208:31f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Wed, 22 Jun
 2022 00:54:38 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::71) by BN6PR19CA0060.outlook.office365.com
 (2603:10b6:404:e3::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Wed, 22 Jun 2022 00:54:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 22 Jun 2022 00:54:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 22 Jun
 2022 00:54:37 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 21 Jun 2022 17:54:36 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <chao.gao@intel.com>, <vkuznets@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 0/7] KVM: x86: add per-vCPU exits disable capability
Date:   Tue, 21 Jun 2022 17:49:17 -0700
Message-ID: <20220622004924.155191-1-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19fec1cb-68b7-4f57-20b6-08da53e9c8b8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5301:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB53016DF15BCC04DB5AB70948CAB29@BL1PR12MB5301.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a7aqCJtTbgMff2+hv1MZ5cDBB9p0rc7Bd6iOvqbp5YRVCyls45EPZBa+5/Uv8SC7QFnqIU4kLOdx1YyUt63C4tD/wDQ1mUrU65YyNOrmniJq0t+xEBIho/5y7Vk/pvWcd3ESYcEQHRbrvYtBarn7BBOb9AgOJbg+xNrVce1XWo65s2RvrJA6Lz3Q7r/3m7yVsKwJX5nfLuzYjMHMWPsmEnzXPP2UF/awL3OZchBdScQDleks9rCle3tP9/5xzF99zuYjJDwyeBMZU4EHqgIuYiUMj1iS8i2+FAgh0pRITffcrJk2bsPsi1NCCmTvgBbIjyCESdX82J1oTe5aLxRbgP4SLJnKPMXhPRF1NASlw+v9VSD0+xoUuR0ldVz5ch0Dc0qSfp7n3lDbCtBVLFfi76WkPvO2Jy5tVmGN8udWnd3pQGc8szqFbMicPI49715viNHFVx20Op2yNqaNoMoSUSFN0mwEg439Qf/CYjtWVS7Qt7f4vRrkLej6tiFi0tvLjwEcORP7Ovfpe+IFiIG35vS1lQ5BYXi2/5Ay8VzAsVR8jcD3XThg7OXZg7sm0A5MUshjBloMT8Wa4tjoLFktf8byQKd8aQ/8EOtfw7W4bujRXE+CBfGPEW7mALh97f0bVLnMQGxQQN5Jw6K6OlCR+1yiK0fYCrQn87TWRhttM5j1pL8a/L51HTj70sURSpDVTn1isSi6uUE0seW3UBRfaL+eaxB++BUzNHseuvwCFCiLYTR7+FPO3KdeWVakBAD0
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(39860400002)(376002)(46966006)(36840700001)(40470700004)(336012)(40460700003)(426003)(47076005)(1076003)(16526019)(186003)(2616005)(86362001)(36756003)(70206006)(36860700001)(70586007)(4326008)(8676002)(316002)(54906003)(110136005)(5660300002)(356005)(8936002)(81166007)(6666004)(41300700001)(478600001)(7696005)(26005)(82310400005)(40480700001)(83380400001)(2906002)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 00:54:38.4623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19fec1cb-68b7-4f57-20b6-08da53e9c8b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5301
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Summary
===========
Introduce support of vCPU-scoped ioctl with KVM_CAP_X86_DISABLE_EXITS
cap for disabling exits to enable finer-grained VM exits disabling
on per vCPU scales instead of whole guest. This patch series enabled
the vCPU-scoped exits control and toggling.

Motivation
============
In use cases like Windows guest running heavy CPU-bound
workloads, disabling HLT VM-exits could mitigate host sched ctx switch
overhead. Simply HLT disabling on all vCPUs could bring
performance benefits, but if no pCPUs reserved for host threads, could
happened to the forced preemption as host does not know the time to do
the schedule for other host threads want to run. With this patch, we
could only disable part of vCPUs HLT exits for one guest, this still
keeps performance benefits, and also shows resiliency to host stressing
workload running at the same time.

Performance and Testing
=========================
In the host stressing workload experiment with Windows guest heavy
CPU-bound workloads, it shows good resiliency and having the ~3%
performance improvement. E.g. Passmark running in a Windows guest
with this patch disabling HLT exits on only half of vCPUs still
showing 2.4% higher main score v/s baseline.

Tested everything on AMD machines.

v3->v4 (Chao Gao) :
- Use kvm vCPU request KVM_REQ_DISABLE_EXIT to perform the arch
  VMCS updating (patch 5)
- Fix selftests redundant arguments (patch 7)
- Merge overlapped fix bits from patch 4 to patch 3

v2->v3 (Sean Christopherson) :
- Reject KVM_CAP_X86_DISABLE_EXITS if userspace disable MWAIT exits
  when MWAIT is not allowed in guest (patch 3)
- Make userspace able to re-enable previously disabled exits (patch 4)
- Add mwait/pause/cstate exits flag toggling instead of only hlt
  exits (patch 5)
- Add selftests for KVM_CAP_X86_DISABLE_EXITS (patch 7)

v1->v2 (Sean Christopherson) :
- Add explicit restriction for VM-scoped exits disabling to be called
  before vCPUs creation (patch 1)
- Use vCPU ioctl instead of 64bit vCPU bitmask (patch 5), and make exits
  disable flags check purely for vCPU instead of VM (patch 2)

Best Regards,
Kechen

Kechen Lu (4):
  KVM: x86: Move *_in_guest power management flags to vCPU scope
  KVM: x86: add vCPU scoped toggling for disabled exits
  KVM: x86: Add a new guest_debug flag forcing exit to userspace
  KVM: selftests: Add tests for VM and vCPU cap
    KVM_CAP_X86_DISABLE_EXITS

Sean Christopherson (3):
  KVM: x86: only allow exits disable before vCPUs created
  KVM: x86: Reject disabling of MWAIT interception when not allowed
  KVM: x86: Let userspace re-enable previously disabled exits

 Documentation/virt/kvm/api.rst                |   8 +-
 arch/x86/include/asm/kvm-x86-ops.h            |   1 +
 arch/x86/include/asm/kvm_host.h               |   8 +
 arch/x86/kvm/cpuid.c                          |   4 +-
 arch/x86/kvm/lapic.c                          |   7 +-
 arch/x86/kvm/svm/nested.c                     |   4 +-
 arch/x86/kvm/svm/svm.c                        |  44 +++++-
 arch/x86/kvm/vmx/vmx.c                        |  54 ++++++-
 arch/x86/kvm/x86.c                            |  79 ++++++++--
 arch/x86/kvm/x86.h                            |  16 +-
 include/uapi/linux/kvm.h                      |   5 +-
 tools/include/uapi/linux/kvm.h                |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   1 +
 .../selftests/kvm/x86_64/disable_exits_test.c | 145 ++++++++++++++++++
 16 files changed, 332 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/disable_exits_test.c

-- 
2.32.0

