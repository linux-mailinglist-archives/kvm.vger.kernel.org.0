Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7585954BF2D
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 03:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242864AbiFOBR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 21:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242412AbiFOBRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 21:17:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B9ABF43;
        Tue, 14 Jun 2022 18:17:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hl6nDxEBB9sinn+l7WVGfZeuvrvmsZeDVyYLM4A9o8WTzVkLZSGMPoXUq6x3zJ5t/w9f0Jjo5ZepISAQvE1y20thl7LDTRTVONZN5jdlNHTxnGJVDBSf70mrmVUtZCpg9Wfma7CsBQZRPcuTLQgD2wcTflTy2muGIIo1lnAIDSp7AqA23qyX/Mz14Yd9cWodZAvTNgmIiSLvNob2HyIqgctavP3eRzfYrw99557T3OVRPjHNQW1EWzMAA8+8ddgggwZT2lxQ5vinmkUPtBO19b3OwktLW4kFaNe8C0DQkh+i6Ht9vW79DhHJ0lxqakohMpuYOmUUc+4V5Vf2XeLd9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9fqvt8WXo1SFZD30OE6g6Mg6bluDe0RmJ1mLbu6UQ8=;
 b=RDkfmPUaqtp+ecv0uyhSI3ZQe5FKfdYYkufxOiC9JBDZtCfUsHElokjvecIeCZ5eUsx0nDbBkmTFFI3FX+XZUklZxpL3KVT90LDZXQ4EtM0Wp+uD11h77sRM4CHH9qA3gBzkYGMIYL+0vVgzpuSnha7prU8F+gvIzAEaB1XqyVvI5ZhoZQaSC/g5MLJqXD6fFcuSxvKhjJ32G+XVz6b/tsUbO3ziMR9oRxgSMmPkMxn40UUxo5RdarBALSTgPwWViEzhCS2/xYofiuGuTHdacPetjIEFotfu8KJYNFH/ZlsoPz0uWtPP3IAM7y4zxV35ClZIXQ9PVxSYEVnAV0335w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9fqvt8WXo1SFZD30OE6g6Mg6bluDe0RmJ1mLbu6UQ8=;
 b=QfxgedyNx2tyWGLQv2sm4yn6o8cWeF84PI82eq3RrvkmPz/FmUoiPD1y5IlXMdEzee1jVhAzzBSDssqluJUG+6i78iPIVv+DpcjJZATQsxs3C5WXiYKdmCIyLNN+Ze916pYtvFpcQ164oyRzo0k51wVIlV1n+VesWoe11uAqUJaKb0X0+pKzIJw8Glbm0V/438Uvvu9HRX7V+eAsxsTlCIE58ofWneqVBPr60ay8euCccGP2A+adf56QuzthqJAS1hHNjXtNidWR2zCxyTBR49VQSgIiG2JWUg1YSZyayzWxGfn2ML2JT8jLHHSUcPLzAvApKB1gwf/8N9F/k5BP4w==
Received: from DM5PR2201CA0011.namprd22.prod.outlook.com (2603:10b6:4:14::21)
 by MWHPR12MB1821.namprd12.prod.outlook.com (2603:10b6:300:111::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Wed, 15 Jun
 2022 01:17:25 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::6) by DM5PR2201CA0011.outlook.office365.com
 (2603:10b6:4:14::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19 via Frontend
 Transport; Wed, 15 Jun 2022 01:17:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 01:17:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 01:17:25 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 18:17:24 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <somduttar@nvidia.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 6/7] KVM: x86: Add a new guest_debug flag forcing exit to userspace
Date:   Tue, 14 Jun 2022 18:16:21 -0700
Message-ID: <20220615011622.136646-7-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615011622.136646-1-kechenl@nvidia.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c261f6b-0f10-4c9f-8dad-08da4e6cce9a
X-MS-TrafficTypeDiagnostic: MWHPR12MB1821:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB182194D4809924C99B48340FCAAD9@MWHPR12MB1821.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yElWCLynqixRLZqj9PE9P5ZtFC3U8ppK6qCRzL4yX4k2UJRfCux37s04txoWDuBHNH0uBaYxZFV2Pq1Ufju96zHhQm8XCndFC26IxVZBZOAYIGOIkqe78ewP+gEI17Y0X+dkzV5zvLwreABPI0vTNVT+YVWbt4lnXauhsRsQvS9NAYk7YNWX8mYbfRHQzPYnw2ojD+/YhnI0jXbrM/EacPVHcoviA/XC7FaGuXBWxhUkA9u3gzlUNTGn1HVCUWWX6LaZgAffw3P1J/PiwJ85aAP6CnQJKEqqqFmKwPOKnirym/xyZjAfxNwSEcuUbYBVyNnQDvMER9sa1MwVGm9c+gV8SGeCRnj9ZkN/eJhLDMCMx4Uz3JTDWByQgua0axYe4KgBLdKPO6iX0CxxNcVO5/y0bXzg5OieWm4qyay2ztKQyavtLfaZSqs3jt/mCh6t9X09CQerwzoWDlzPhdxGbwmsRjOGAocwHVGc3jPgHiv04aVh9sButvn8Rk8pad6PjcakZ2FUrtKocperpwCt5JunegHu3b2minJDC3PnYDNZQc/KTyRaSaLIQvEjZweatsDrp3w7qjiwhptPI3O6hsGexbpXgHF8dM98WVatUJAHqyaBGRsq8n2nAe47TiNS9tmmJcUom4GwAivuHk8wrDkcqojJrrIVxI/1oav3Zt5zt4XvJeXM4Ngo0xUX8Z5qBh4H9bqRJyt439QO/0Dh2Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(36840700001)(46966006)(7696005)(6666004)(316002)(2906002)(8676002)(508600001)(82310400005)(83380400001)(86362001)(36756003)(110136005)(4326008)(54906003)(26005)(336012)(356005)(186003)(16526019)(2616005)(47076005)(1076003)(40460700003)(426003)(70206006)(8936002)(5660300002)(70586007)(81166007)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 01:17:25.4766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c261f6b-0f10-4c9f-8dad-08da4e6cce9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1821
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 8123309d097f..c6124a7e2180 100644
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

