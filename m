Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8FA66A58B
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjAMWBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjAMWBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:01:47 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D908EE33;
        Fri, 13 Jan 2023 14:01:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUf3Fxi5zWHcblZuzg5+7dLwG7dZ1Rk2GClCH2GsdnJsN3YYxKD+idAAi+gRuJrG+uVEFdMOldvq3fGAl1+57MApqrQ9xvVt6iCinvCqlaefIFCUYUFY91Y5Y6bPSVDp9Ro2O6RPsqO80RsRNJMSYmsGBd8fjRz0b/HzglRF3BM3OaMOHXYtTD60xWCLvHMmg6EgBN3GT7M8AAkLO+J/AyAbzHWrBfJSvxav/6+D8JxXgfyKITcXBluVel6qARJDmevZVwudFvfs0rjQiBOPhON/4bKHY588P4kNq7ugjszjl79YmxFVUxwLbhbjCu5fsfdML3tHZT7hc/9wvTLrnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=umEPoImhx6JKpXbCpuifViAM++7+QEfHv252ZYY+oLw=;
 b=Gqa6sZZD8I/+8lJ5j35AKvnqG+4J3dR1PPfckg2rPNotUzTpSr6edHp8YnK9+KNkYYErTc3pig9TcM3Onw+yl+7yhqhrOlaD4jAjUnrhqWgTl8r3SLa8U2EWbDK1t4p2VJ6VYEGSauiZCwHkzBFsDS7XxGku+YkQAnV7XPBAWMOX9Tb724b0oWiTJe9F0/qgqA1Yd9FwgierrOnv1kf9CefD1i5bFQgOPAkfjrpSHqBniZU4opb+ZIAqjFVeEJgEVFTXWZrzytmW5HIbDD/PRznDvS6TMK2UCPK5sciGKt8idhX9CJh3vt5WBX6lmW7y/kZ64DiYYK+FKV5Q+Al1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umEPoImhx6JKpXbCpuifViAM++7+QEfHv252ZYY+oLw=;
 b=pSozt6YPYsNiSN9Q4zGXitaXC0VQs9dPD/B6WLGYTkzhx8EdEe1RPK8mt6MApR2B7VjTfZW9KUS8Jdw6Xn+k8aKnGo1rlflcoru+M7qVFKVFHHpCVAtJz0yjamQktfB5NubZTzJkzOGsRq+cMF80cn0RixKSoSI9OVp1lPpWqy0M6YNq/2oURiC+AS7p0ygb29yxyCWvPR6nkxXuZA++9oaB9nBuq8qObOwJSJ/SEZr3jWKNrX5RCU8ujuqCSyh/CU9Lt15FDyqYA8ZogPuhr+Aq1ryTbheQdCCLTOhLs9OKcmh5CQHAfaIN+01+/eYtNoR8qQkFylQy751n44MA5w==
Received: from DM6PR01CA0004.prod.exchangelabs.com (2603:10b6:5:296::9) by
 MW4PR12MB5642.namprd12.prod.outlook.com (2603:10b6:303:187::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Fri, 13 Jan 2023 22:01:43 +0000
Received: from DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::59) by DM6PR01CA0004.outlook.office365.com
 (2603:10b6:5:296::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 22:01:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT087.mail.protection.outlook.com (10.13.172.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 22:01:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:01:34 -0800
Received: from dvt1-1.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:01:33 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v5 0/6] KVM: x86: add per-vCPU exits disable capability
Date:   Fri, 13 Jan 2023 22:01:08 +0000
Message-ID: <20230113220114.2437-1-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT087:EE_|MW4PR12MB5642:EE_
X-MS-Office365-Filtering-Correlation-Id: 93c589de-666d-4f88-2e6f-08daf5b1c169
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPuW2GqkPS2bYxufV5ir8FWL0dAqw380VI9Lzak32nIK8KgmBmtYe5VTUaK3Uvq1P5Ye/NfAIuNnld+GQq1X5yGjWzvK8krY6Sg2Y9bbIRW/NQS5/0hgBTBewPcBGzK2PgwV93rpBSKPWPx2kho/rIfTS3XEVaDsR8NjQsZeg4j31cHLdpK0ckAS1lpCj/3K8NmYGbNanvndSySRawyO2fAMSrZh5hGYX5bY5IrGr+Hu1Y7KkbZrH/5frI5UGMH3ZhyLdZCTXUYw22qEEghV2gfD/toYivi5XFgAoyMpZnO5QE8X0KpXwK8jWaHD/J/T03+17N69jW/jb5IqgqHZ6YCDYrreIG30JKNQ+YgGOhCuNx6A5LnbVrf0HQ32KB+7wQ3zHC/g7QCI6OPo2MC5jNnNzuMqOq7q13xCUiPFxoxrrg9bbSeMQfYM7ECe4zZp8vyuHuKCvJLGnAQh5N0RZE8kOmH2a+BkA/blQjCFhyvbD/kS5fFMAj53QWYnv9u2FB2pTF8DBY2MaoQEaRoDBOXc0oIRwPM8fymPqst2O2kNR4eQsz+Tj2hp1WKP29DmQIYwSgWd63XG2yscH9JwrX2CgHnaKswXHPAALSzQMYHYWJn6fQrVXe0oLSV4YpdS/yhJC4tJRcMe3WPdsHCZdQEz80ppzMyqoLNJUduAFtKNhzETQ68En3QMDK6p+3wcIP52E/Jm9AZsLy9cAJ2M0Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199015)(40470700004)(46966006)(36840700001)(26005)(6666004)(36756003)(8936002)(2616005)(7696005)(1076003)(316002)(5660300002)(16526019)(40480700001)(186003)(40460700003)(4326008)(356005)(82740400003)(110136005)(41300700001)(70586007)(7636003)(478600001)(54906003)(8676002)(86362001)(70206006)(82310400005)(47076005)(83380400001)(2906002)(426003)(336012)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 22:01:42.7696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c589de-666d-4f88-2e6f-08daf5b1c169
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5642
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/vmx.c                        |  53 +-
 arch/x86/kvm/x86.c                            |  69 ++-
 arch/x86/kvm/x86.h                            |  16 +-
 include/uapi/linux/kvm.h                      |   4 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/disable_exits_test.c | 457 ++++++++++++++++++
 13 files changed, 626 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/disable_exits_test.c

-- 
2.34.1

