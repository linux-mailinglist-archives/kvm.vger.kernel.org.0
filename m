Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE70553FCA
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 02:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355506AbiFVAzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 20:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355419AbiFVAzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 20:55:05 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE8830F7E;
        Tue, 21 Jun 2022 17:55:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbkqFebNAkBMnpT9OZ4zJfc+2jGMTAvVQJsZZCzp9rPUzY7mv9K5RxKT/2Uk0si3zJsVgD9riWPxlSS9PPiXL4Ef9arulIs9Ahwm7+1gp4smiAdLN33nFEdCVVJm7RRD+47LKX9HhKsPrOOejyN5WUbKxmtBEHSB2/p/tpaW8Vk7bd9jNlTOVHVYNbl+eAyeoHCXqlMwGCBb4djSSWP0cCHIO3rksBc4KsUYLxuOPmZurlycMtdZ2D3a2HkJLqQGlP8J3eUhic7CDTh/ZnzhXFFTzdGXCTOZTXoKQpNMlBXRNidx0rLH5Im29YhHeAbFbhq2xaq6YCoiDKwLhCkpmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+gidTR64ir8kbPrzSZvcklZUAFYlf+10rXGAH65cA4=;
 b=LXCTK3e7gfD0PvStpjhu1nQg4aheVTdDc7/1m98OOuoXCswtGsHiTrUrTSPr8i8Y0Lpa6ItxK6C+nOEVZoE10Pjg4BDLKylgYvJUNDicHPYhVCfi0V150AQyLV2lB+rTdvJN6Le4TWisbJxEqGzaH0zEHZNLpZShcg0DFsb38NtlY1BBM+qGSF8rMx3pcrWRnTX5BFkiUxl4zMWGt1fPNc8lcO8XQgycrr+bxZ82EYP9SOWt3bwc9rwgwGT7M0Y9+ZUCdUfWg+1REPpB1AKGmoOliMV0suKICAC3tdETrA5Opcxc+vKINnIVruKcd2yZ5LNi8piJUcYhjhmOEBRh3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+gidTR64ir8kbPrzSZvcklZUAFYlf+10rXGAH65cA4=;
 b=lHrM+Am6khk4WVfK8w6iqX+l8y2EoXOMKHLbzlYYpH0rhuu50ayGjZjCIrprsiSm9TT6VWheiisFsF9502At9e6x98IkJE1mDKmwpbuE2EM6pzY0PVIlL/XFr2EFBSjQZitZ8DK/Tv5A0FVnilGTeXAbM4OF6IBOYykV0QjC85fGVFWv4H5roSaRZzlF+DnB54bVtXwJyJ//Ufb6GdKlEYYV2rmEymkNg5w4m8DtkHEfz6MdMHH+RVZeHT92YpLyIQrOF5yRRZUp5fjKiVcIdXImWYqORNAX1/3sHxYOicR1cg/E/IwzOIVs9G4E9phLPA5QVjGBzY0ngeL9TpP4Mw==
Received: from BN9PR03CA0602.namprd03.prod.outlook.com (2603:10b6:408:106::7)
 by CY4PR1201MB0165.namprd12.prod.outlook.com (2603:10b6:910:1c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Wed, 22 Jun
 2022 00:55:02 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::63) by BN9PR03CA0602.outlook.office365.com
 (2603:10b6:408:106::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Wed, 22 Jun 2022 00:55:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 22 Jun 2022 00:55:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 22 Jun
 2022 00:55:01 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 21 Jun 2022 17:55:00 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <chao.gao@intel.com>, <vkuznets@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 6/7] KVM: x86: Add a new guest_debug flag forcing exit to userspace
Date:   Tue, 21 Jun 2022 17:49:23 -0700
Message-ID: <20220622004924.155191-7-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220622004924.155191-1-kechenl@nvidia.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64b50cf6-682e-4b07-952a-08da53e9d6c1
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0165:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01657B6359C5C7E50F6E6CB4CAB29@CY4PR1201MB0165.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hAZ2TcOUEaj2vrKZfr1x8oE/gQsfkxqNlIB6wLqWShK4Znam17zawGtieg8IHDYQHZiax0DYywVOh8sdhM/g6UzELA9JGz8XEtYuJppmepRHaxAsr7nYiPq8agr12R8nObGxy8mDfP04TGqgnzngt3HgJTGiWYTpiFBqfhuCH+P2O4wt5ykQXK4ACjdWE4XD68pgnFJbFCL1sdUR9aAenVc16FXWXfCtm0NYq0IOiy9zIO4+rDmu5kZnjtP4KkkC7MuwIEB+ZMuqiifIyBmhAY0f5vJm1F4HP1uEaSmDPNeQqu7zqSIuodphF6UXHtCmD+3Cj7+dcWAiA5y6pJtvISZuSfn3d25tIOUhSrvK5WHoNhSNPw3pjdFy2GTpI35HE5X6vR66xuQVyKdMUGPoxFpguFklAeOkRqqzr6308IGM5dgobsCdQ2u4nROuI2n3yu/kJkQ/tF1lnrlESA+/E2r1tcf0/C+5Uiua7GS9ukPk/8BwwL/jtQ6BERCBmMAsrTWvtacZdSsSkix7xBiKLQnNj5wMXQV3rOnPMK9pWcnKQJl/NM3JfzcdmJcOubsikAJojnv4eeQ4pgHMQicpZ6jvwhkGGfsGfI0uQ7Sj7F6MNGXnJ0D441IUOXpUqBPNlRxdJcCEIhP/uyAc7VzOVRnYDGItuJrNjYSxFKsfqnXOrHQ6fefAnf7+ZVb7023Nor+/+RDu6cR5NJ0cTP6LI2AkpcKSZHmk6Bx5C0km/jTD3n7BHb4X4t49P04ICUul
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(40470700004)(46966006)(36840700001)(40460700003)(86362001)(36860700001)(82310400005)(5660300002)(81166007)(478600001)(8936002)(2906002)(316002)(356005)(70586007)(426003)(47076005)(54906003)(16526019)(8676002)(40480700001)(4326008)(70206006)(336012)(186003)(6666004)(83380400001)(82740400003)(7696005)(41300700001)(110136005)(2616005)(26005)(1076003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 00:55:02.0124
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b50cf6-682e-4b07-952a-08da53e9d6c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0165
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For debug and test purposes, there are needs to explicitly make
instruction triggered exits could be trapped to userspace. Simply
add a new flag for guest_debug interface could achieve this.

This patch also fills the userspace accessible field
vcpu->run->hw.hardware_exit_reason for userspace to determine the
original triggered VM-exits.

Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 arch/x86/kvm/svm/svm.c         | 2 ++
 arch/x86/kvm/vmx/vmx.c         | 1 +
 arch/x86/kvm/x86.c             | 2 ++
 include/uapi/linux/kvm.h       | 1 +
 tools/include/uapi/linux/kvm.h | 1 +
 5 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7b3d64b3b901..e7ced6c3fbea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3259,6 +3259,8 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 	if (!svm_check_exit_valid(exit_code))
 		return svm_handle_invalid_exit(vcpu, exit_code);
 
+	vcpu->run->hw.hardware_exit_reason = exit_code;
+
 #ifdef CONFIG_RETPOLINE
 	if (exit_code == SVM_EXIT_MSR)
 		return msr_interception(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2d000638cc9b..c32c20c4aa4d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6151,6 +6151,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	if (exit_reason.basic >= kvm_vmx_max_exit_handlers)
 		goto unexpected_vmexit;
+	vcpu->run->hw.hardware_exit_reason = exit_reason.basic;
 #ifdef CONFIG_RETPOLINE
 	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		return kvm_emulate_wrmsr(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6165f0b046ed..91384a56ae0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8349,6 +8349,8 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(rflags & X86_EFLAGS_TF))
 		r = kvm_vcpu_do_singlestep(vcpu);
+	r &= !(vcpu->guest_debug & KVM_GUESTDBG_EXIT_USERSPACE);
+
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f2e76e436be5..23c335a6a285 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -777,6 +777,7 @@ struct kvm_s390_irq_state {
 
 #define KVM_GUESTDBG_ENABLE		0x00000001
 #define KVM_GUESTDBG_SINGLESTEP		0x00000002
+#define KVM_GUESTDBG_EXIT_USERSPACE	0x00000004
 
 struct kvm_guest_debug {
 	__u32 control;
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 6a184d260c7f..373b4a2b7fe9 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -773,6 +773,7 @@ struct kvm_s390_irq_state {
 
 #define KVM_GUESTDBG_ENABLE		0x00000001
 #define KVM_GUESTDBG_SINGLESTEP		0x00000002
+#define KVM_GUESTDBG_EXIT_USERSPACE	0x00000004
 
 struct kvm_guest_debug {
 	__u32 control;
-- 
2.32.0

