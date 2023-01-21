Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92046762DB
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 03:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjAUCIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 21:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUCIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 21:08:06 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49670707C6;
        Fri, 20 Jan 2023 18:08:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhP61QdRidolbx1aXGtfEFH6Iu5e2jOXc80EzNj0sSp8Ok5VdEkXEgg7eCUrUQRyNyMlB9JThjOeg7BpXBcQ0cRVcwKiSWLjHNLk7JZnhqqjl9/MYYt31M4WWxS8R0c9OVByBU6lj60bY5LTB+EXOcokHlrfovuRG8zBxXEJDuhOMMhwZh4M61bQXjr8PZ6tUI1zlri4JZCwy51jBkWTdB0ozUYX2Sr2rlZnO8OeQFksMqMll9dMVqSmgoM4eocRWwQJxWHJ+Z7cBdNjTvYI+s3pOe2G/55EV167WrKh6t3WWxC5N0lHeSJ798P0/TFwJrfqnJkHp4hjPoQ6biQ+0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaKYS4RA5LRPG5V4FnIZDxapVgpc83hhZcOO7ojKVWM=;
 b=ntm1NGyoWv8CW4DBOAqcKKfmZqgPlagZEKL/YKpon5LV2s8zyTd0mce9n2Zm59xZxw2o0auAmSIOFQIKW6KF+cngcJs1Xgg5O5yaVrIWQR+r443VFp41kpqU6BEClo2RioLupfCZow0wLlm2jolqPzxlYj3un1bG49xUcj7/YZu4Icsuz088ToXbTTzuUD+Qb3lp/6tVxlg8wGas/uKoq7ebDABfAI/GtPc2dFT+vABRBSbJx0jnMjgb64gGzKvRHeQluzgj3L3sSuD8uwhvQgP3Fv1pXp9aF5x2qb6PzOXV3IjeCx5q3y1zFl+ygZylfystrz74qQ597aoE8Xg7Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaKYS4RA5LRPG5V4FnIZDxapVgpc83hhZcOO7ojKVWM=;
 b=ITN+QerpLeSuYPJeV4KCgZFSVA+zWGnxvKe/CVHRLNPz+kXq+5wFjf+vXm9Olai51Zoj8WkQOOmtcU7uxr3n5IG6q0v36qGy4jdiLZyWkF6Wv8BdJ7/eVsxGA+t24U2Iw0vVzvoKybSiHR4rKJc+KZTVZ5jGqk084F2JyMGqi2ghJ/O1+xXt5kQ/B4FrB4IFLahDC8esXbIxzFyLQvTnpBlO1tVUYc2hTDG96u4mVXuHlWoIIjyb9fzaUKaiGmbOZh76b8MHJyEpJ3Po/h2n11+gPOjbpbPSMVQdI9ujcI3x/P9CT7MGXyZADE6dcA1Vj7BQkaeocKTMst3apAx48g==
Received: from DM6PR06CA0038.namprd06.prod.outlook.com (2603:10b6:5:54::15) by
 MN0PR12MB6294.namprd12.prod.outlook.com (2603:10b6:208:3c1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.27; Sat, 21 Jan 2023 02:08:03 +0000
Received: from DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::e) by DM6PR06CA0038.outlook.office365.com
 (2603:10b6:5:54::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27 via Frontend
 Transport; Sat, 21 Jan 2023 02:08:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT071.mail.protection.outlook.com (10.13.173.48) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sat, 21 Jan 2023 02:08:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:03 -0800
Received: from dvt1-1.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:02 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <zhi.wang.linux@gmail.com>, <chao.gao@intel.com>,
        <shaoqin.huang@intel.com>, <vkuznets@redhat.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v6 0/6] KVM: x86: add per-vCPU exits disable capability
Date:   Sat, 21 Jan 2023 02:07:32 +0000
Message-ID: <20230121020738.2973-1-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT071:EE_|MN0PR12MB6294:EE_
X-MS-Office365-Filtering-Correlation-Id: d54d45c5-858b-4b81-f5eb-08dafb545463
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0MSgRnQ4cZ+Vb+0mrROu68FN0XZxCeK8nuZFMk+xXJpdQa5X6p4P6UlvPj7WW/rWoht9gjCCjwKHffdKDI6Va32d/lXX9CvgBldQqzCD1PF7h18R05g0MNWEEDjEX6bR6RBydgYY1O1GXGnaSY1m7PHpgMq9BdF33rG9+jX4gCrauoyZtxw8Bj/p+nNZ4j3+wo90d2jNbzDzotF6ht84Poh6xXenuOeNphKS7j2AIzCeGDxtdcoZueK0SBzxBIR68wIoX9n/DBbszaB/nDAAx3UMeygjrk68nvRgOoMoy0JGcmFugZ8zQ/M15IOczJChX0pRtFz+WH3Arro4KX93SJ0AAT1tE03c6FXzHVsLGA9zQeqIUoto9CYVZT1arMqw9hEJ8YpOPO87RA+hNdBKcEBeFHgMMgouf82AJyXOXYUZx2tdTzmSrKbyCrBjGgvuqFJiGlK5jRtKNIz3IPiptrvQvcBaOQt6ifObc/BAVLnuiU1l1aTCDevnXsX8GTLv3lf1lYGk9yiI8X/V0KNY+pD/YU19V8pQ/gsAI2ITzd7FYRXfshrc/PNzqF30+cUFKkM8zWS4pzxs7HxwGHIgrRiJunSSotc/ZFwEBdhAys/I8Qne93HhN2i8syu9Kvi9EZqn9JA+8vt1iB16s5SlvMik5NGt9isbbVJdgnSlN8ZY+MkhSUogz3fP4ztJBRnOadyOy9gi99Ya05e+4iGhBg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199015)(46966006)(36840700001)(40470700004)(36756003)(2616005)(40460700003)(7696005)(40480700001)(110136005)(478600001)(16526019)(26005)(6666004)(186003)(5660300002)(70206006)(41300700001)(2906002)(8936002)(54906003)(316002)(4326008)(8676002)(70586007)(336012)(1076003)(36860700001)(82740400003)(356005)(86362001)(7636003)(47076005)(426003)(82310400005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2023 02:08:03.6602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d54d45c5-858b-4b81-f5eb-08dafb545463
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6294
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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

Tested on AMD machines.

v5->v6 :
- Correct the selftest tests design for HLT executes in guest cases,
  wakeup is required for all these cases (Zhi Wang)
- Refactor the test helper functions encapsulation

v4->v5 :
- Drop the usage of KVM request, keep the VM-scoped exits disable
  as the existing design, and only allow per-vCPU settings to
  override the per-VM settings (Sean Christopherson)
- Refactor the disable exits selftest without introducing any
  new prerequisite patch, tests per-vCPU exits disable and overrides,
  and per-VM exits disable

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

Kechen Lu (3):
  KVM: x86: Move *_in_guest power management flags to vCPU scope
  KVM: x86: add vCPU scoped toggling for disabled exits
  KVM: selftests: Add tests for VM and vCPU cap
    KVM_CAP_X86_DISABLE_EXITS

Sean Christopherson (3):
  KVM: x86: only allow exits disable before vCPUs created
  KVM: x86: Reject disabling of MWAIT interception when not allowed
  KVM: x86: Let userspace re-enable previously disabled exits

 Documentation/virt/kvm/api.rst                |   8 +-
 arch/x86/include/asm/kvm-x86-ops.h            |   1 +
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/kvm/cpuid.c                          |   4 +-
 arch/x86/kvm/lapic.c                          |   7 +-
 arch/x86/kvm/svm/nested.c                     |   4 +-
 arch/x86/kvm/svm/svm.c                        |  42 +-
 arch/x86/kvm/vmx/vmx.c                        |  53 ++-
 arch/x86/kvm/x86.c                            |  69 +++-
 arch/x86/kvm/x86.h                            |  16 +-
 include/uapi/linux/kvm.h                      |   4 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/disable_exits_test.c | 363 ++++++++++++++++++
 13 files changed, 532 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/disable_exits_test.c

-- 
2.34.1

