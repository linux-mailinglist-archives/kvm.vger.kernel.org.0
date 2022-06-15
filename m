Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D111754BF1F
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 03:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbiFOBRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 21:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbiFOBRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 21:17:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D52240A7;
        Tue, 14 Jun 2022 18:17:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUcD8opI/gVozaqo7XOeOLQ6lK5hp4iMVj6pn+wqxq9TFT6vMFurKF3XocLGShOgTfiGZo+n1AwHJuFdf/kd2mXO+tHlF7rAwzF00biDdyu7a37mj6nrUoPODHni/+4GSSMFqPgpKP6rHLoil+u7p61ni2EOfHr+X/D6zelikwnk2mgn68bNnzlEi95ivShuqbx2V/mfbhrfNiYYSw8nGBPtZ49YrXfhRb4AjlSQPK5hiuAbi2lbjXrZF8eIhZ01lfWAgHu4tN/fW0svnnAt7hEOR29iMqxkC1QefpN4gg9/G4OgSvHdQYM1QkRlCMk7pdVn3k+ccA7Cfr2KYpDWgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ljuyCx6n+QyTp9qiVkf+y2wV2HEy1vWKfzYh+b1IXE=;
 b=er45fDDyykwh+i4NVmoOOK+HgGM+kRZnt/QdcTPT7dZnmUTRVe4dN6aUkPVEA+v8Yw5Q1Sf4AeQgAtoVMQ8Qa6L3WRBdXNupp37R6IWzJ31lSvxursglggOTkjRbQ7/JIGi7YmKCg77dHW7IyAw97z8dJD2Tdlyy0Q/Wu5Qh7cIYBYNkaOjf1JSYbZvBzs1HXsMHfEwTJP+sex+bDgSULeHWGrrZ+gsKVlCPBJiBUH/hxNRdLeqaP9+sIocisE9W+oniRQ9kuEI1fRhdyJAnONQiXl2RV/pUA6cE8Et014Psr/vbo04dc+Jus9rEf+RR6xmD0nLwC4kOUEqJsLKzkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ljuyCx6n+QyTp9qiVkf+y2wV2HEy1vWKfzYh+b1IXE=;
 b=jR7kK1yB2aBiNu/DGLo82Se0wi/oEEarwYeNNxgGZSMQDpraxphQjZgZXExHWpaIParTc2kGKSL0dm0t42GvfEE+tHJBbY+z6qJ1Pt7WBneCvHx1I29wvH3OvOmOhSpomJml2JV0d8iWko3seHraRoJiHAhHzIdCgcyL0igwwZEKwS5iLfWxBrSumtcqoFn0SDW7tB3UEJonspw6XXnUPXw5lzZDkLW1+n+Rx7f2aKJuxf+HDGgW/h3WY9YkMO3J/DQx1iMP6bj65jcK6GnBN3KRL8hPr4x0iAi0gwnxC5uEhFou75WNgApQnWa0TQ8C5aiI8RvAZ4tvE3WpoVYzSA==
Received: from DM5PR16CA0048.namprd16.prod.outlook.com (2603:10b6:4:15::34) by
 CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.16; Wed, 15 Jun 2022 01:17:06 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::9a) by DM5PR16CA0048.outlook.office365.com
 (2603:10b6:4:15::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.21 via Frontend
 Transport; Wed, 15 Jun 2022 01:17:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 01:17:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 01:17:05 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 18:17:04 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <somduttar@nvidia.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 0/7] KVM: x86: add per-vCPU exits disable capability
Date:   Tue, 14 Jun 2022 18:16:15 -0700
Message-ID: <20220615011622.136646-1-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fd85bef-5f3d-4913-4cb6-08da4e6cc2ea
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB39250B1A7523FA2FAF905873CAAD9@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8R3HF9XggrW5ei61fu+2fBsRhY1su6hWfZWWw/9VObs37I9bfZJWQGtSXvzuYwy0fclzLF/VaI5550XTKqMzULamCZOWVLUoR1N7MAm3/yz0OuTvbSU2pqmOy12h0k08+iZDHZxB0BPMqd5mMp90rZ5DOF2y+ceh0s5gc0Yh1aMMizr2z9+JJI1MR277MmeIC+k+BOPurqrxD6+lz+h+ZS+d92lduKwGvzSqCajU6Txsc6gDd5WbCbJsF3q6MLz/96CTFnFP3h6QmDcxOz8BqT/IrtctzrxT64U2rnd4w/dJP7hutPd8iJp4cculDoCGdB/1rIQeCG5MhjN15cKTjHtlBCQwTkSjv/EpNRWXNK3tTZIBYleq5DNnjqWaSB5mTiBhuUSzJzVUUqEro3zwkmatxPSJLGLxxtDaIUpIgzYm5WFkuWlJvDVGqrkNF3V+N9FvEQdbDFmt8zDWxsnHBa/pF8otvyOaHpPWnMezjYx7NJGimr1RnBCJLHm6HlxiW/1fcdlN+jqm+1VLKmQ63Ap5P+ubGHIBYtgrO636qv1BHpOmX+G4btuGUYP8O+TQKWdeY/jQlkOwtNYNHzsecSXq4p4LAnLUHir9O1FIaDNy9TReu8iqsurND6wgJ/BhnX0Yc277UsxpvjioWLSq1kAnyp5ko/MuSyeKgtELQLZZ/YYF78jBH/5mEAI7E0sRM4UXynGBzKNwX24e8AUu+Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(356005)(8936002)(81166007)(508600001)(5660300002)(40460700003)(83380400001)(186003)(1076003)(16526019)(54906003)(82310400005)(86362001)(110136005)(6666004)(26005)(7696005)(2616005)(2906002)(8676002)(70586007)(70206006)(4326008)(336012)(47076005)(426003)(316002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 01:17:05.8509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd85bef-5f3d-4913-4cb6-08da4e6cc2ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/kvm/cpuid.c                          |   4 +-
 arch/x86/kvm/lapic.c                          |   7 +-
 arch/x86/kvm/svm/nested.c                     |   4 +-
 arch/x86/kvm/svm/svm.c                        |  44 +++++-
 arch/x86/kvm/vmx/vmx.c                        |  54 ++++++-
 arch/x86/kvm/x86.c                            |  76 +++++++--
 arch/x86/kvm/x86.h                            |  16 +-
 include/uapi/linux/kvm.h                      |   5 +-
 tools/include/uapi/linux/kvm.h                |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   1 +
 .../selftests/kvm/x86_64/disable_exits_test.c | 147 ++++++++++++++++++
 16 files changed, 330 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/disable_exits_test.c

-- 
2.32.0

