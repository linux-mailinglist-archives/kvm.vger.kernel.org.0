Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8948C64D0A4
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiLNUFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiLNUEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:04:51 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2047.outbound.protection.outlook.com [40.107.100.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F323F2ED78;
        Wed, 14 Dec 2022 11:59:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jooYwiNZmsaLaKLqUl7rYJpLA4A+Uz0YsJIGIvaYyaDNa4QKamvzuH/TdI83Bl+WMQxQTPR2til4UG4anGO6Fh/oRnBs9/hRfEa2gyZ9WqCu0BPwgkJgk6DORhH68CNJ8DhgYdY6ovmeS/sNAFHqAHpFSGGJdgGBhCFUgdJfAYIfeI7Wgh+CDnHrUN1+u3+8cSN/SdhMGgzr/Mjj0v+hyfjKbRRhbjaflXt2mFn4+LMWR7ZUWZ70m2i7C372YRIWhCznsJ1MGSBm87pUzhhe29zTPkZtr2tv+ClxJjvPSZ3xGv4n/wjO1A6tcbMC7nxLxyIiksmSjfElS0bKAjB19w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9OMyyUVR8eMaZT1tXrQgQK+Hcvc0WsRBQ75uDBC6AQ=;
 b=fm4lpT5Vsn2LXI00MJLqc9rSW07ljgbxHYbNEpAcIIsjxdhmf8brwF99RNxvlp8ihPhQJRlIe0dQkyOfdDI/CRyzVpsH8k1hRw3HDCJ4ieZwOSmMY2ftZLN8P2lVxs96I6ziWqVR9I8w9J0iITUacJJN/VLxsSv5IrxuwHRcU9TbmvnA1SVcmwChIV2X1pjrjy4QYCdPGP4a5niIqZGnhYe/+rlvTuXe/g54cDXo4uaGUB68dacgy81ASwub3WeW9/e3yS7VeVzEP+U4LoCvk3siKEmczWPjhNrciKsh4VUn4i/NK6QIn9AaloKroi/05t5YNw84RKezaoGuOw4UMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9OMyyUVR8eMaZT1tXrQgQK+Hcvc0WsRBQ75uDBC6AQ=;
 b=JgkA0n3SIzbwKW9uA1deQkmrVDRQJ9Jmb5B4rm3nONVnNooXzF2b4VT8XIOPdfNUeoQgZars975Bv1ybYOGuI4lCnXI7sSx72ksze2gMTmv9Ct90r3KMtPK80RCJluix931tcrhvfqVxvG1jjIOzYPbcn4XU7LxB7gmKhme8z38=
Received: from DS7PR05CA0092.namprd05.prod.outlook.com (2603:10b6:8:56::10) by
 BY5PR12MB4260.namprd12.prod.outlook.com (2603:10b6:a03:206::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:59:00 +0000
Received: from CY4PEPF0000C971.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::23) by DS7PR05CA0092.outlook.office365.com
 (2603:10b6:8:56::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.5 via Frontend
 Transport; Wed, 14 Dec 2022 19:58:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C971.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:58:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:58:58 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support to KVM
Date:   Wed, 14 Dec 2022 13:39:55 -0600
Message-ID: <20221214194056.161492-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C971:EE_|BY5PR12MB4260:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dfc367c-6ec4-4aea-1bca-08dade0da42b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Y02O8URML45FklxAygMIa+ZCM/fa5PynNut5ZWgKQTA6ztUAqY6Y76SyEX+V9QP6vwvXypz2PCx/aRXc0rsa9UrkVyQ6uGHeQSTJin+jFLkygvTrai9HcJA6e/NGK0ExAyiDJEK1kKXuf8YdNIpUsf2zVLdVCEH+y8tDnj01Sdg4+BS1o2qTysbAD2VrlGLBkb+WoMZD4glNfSQyNkM0fYBvkLXW+lQr4whROflha8qQm7ZRDJGJ5HZjKIqZqAzaMGQFQV6Tjw9VFBHJ8WsQG/nBijBCgvFUo9So7VwKHRHbfKnavFdkBNvNhqCtOmnjweRLtMdTB62ckrYxOppR+H7d62Nop75G14pS3efm8Gm4K2bcedo3CDTtna+10wylvYsuExGtc5+LiqvT5KVjqPLSI10aiCXd312ZKkUTeXblrJ6AJkq0rpNH7WxBICy8cQndx7/kgvgTkSy0Y9EsraZRi7PE11SOpz+qn4qjPxSLqo5/O1VSMakJrQTTjwvLcpg1XN33Wo3+IoG+a4z05VNd9l3sG9aY/eJwVKTlyC+nGgPRPss/w1hEgy+s7jX8B5hZaVgtc2fYUwPT0duiJbFmxnjZPE/D+R2q8wT6ATcfCdc8sEvyegv/bPiph/jjQ/ZcHIIVwgEqjWbc0jvRjufc4AGYHK3dMc2wwvH+S3Q30CQuu91CAQS5zGrabiU+tDttUJwY2CWnuZZ4g4D00oykrNeWYSTTdTbXJqJuLE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(36840700001)(46966006)(40470700004)(82740400003)(478600001)(2616005)(26005)(36756003)(16526019)(8936002)(47076005)(70586007)(40460700003)(1076003)(70206006)(82310400005)(8676002)(6916009)(54906003)(6666004)(4326008)(316002)(86362001)(40480700001)(2906002)(81166007)(356005)(44832011)(41300700001)(7406005)(83380400001)(336012)(5660300002)(186003)(426003)(7416002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:58:59.5326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfc367c-6ec4-4aea-1bca-08dade0da42b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C971.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4260
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nikunj A Dadhania <nikunj@amd.com>

KVM should use private memory for guests that have upm_mode flag set.

Add a kvm_x86_ops hook for determining UPM support that accounts for
this situation by only enabling UPM test mode in the case of non-SEV
guests.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
[mdr: add x86 hook for determining restricted/private memory support]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             | 10 ++++++++++
 arch/x86/kvm/x86.c                 |  8 ++++++++
 4 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index abccd51dcfca..f530a550c092 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -131,6 +131,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2b6244525107..9317abffbf68 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1635,6 +1635,7 @@ struct kvm_x86_ops {
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
+	int (*private_mem_enabled)(struct kvm *kvm);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 91352d692845..7f3e4d91c0c6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4694,6 +4694,14 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static int svm_private_mem_enabled(struct kvm *kvm)
+{
+	if (sev_guest(kvm))
+		return kvm->arch.upm_mode ? 1 : 0;
+
+	return IS_ENABLED(CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING) ? 1 : 0;
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = "kvm_amd",
 
@@ -4774,6 +4782,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
 
+	.private_mem_enabled = svm_private_mem_enabled,
+
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
 
 	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99ecf99bc4d2..bb6adb216054 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12266,6 +12266,14 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(__x86_set_memory_region);
 
+bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	if (static_call(kvm_x86_private_mem_enabled)(kvm))
+		return true;
+
+	return false;
+}
+
 void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 {
 	kvm_mmu_pre_destroy_vm(kvm);
-- 
2.25.1

