Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76A664D0F5
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiLNUSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiLNURo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:17:44 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E08648743;
        Wed, 14 Dec 2022 12:06:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0sunLe5fQ1Kdu9fSnWOX2E0oV9bFUA96BYOt5fQ0jZhIJ4yW8Ui5UQ/Pcw/Ynd87RKYetMDRRW7Lvp8o0WVslK0AmjQ7vrekaogE6ZzU8yzPyqtBAQX1ITwq+g7DaYUTKQ5CZa43B49G2gLJc+fwxT8cOjOnYHbxDErCm3nmURIPHFjNS2NCXORilfyMu3NVmktT3ORTKqrWtdLwpQPFGXhhNx1j8qrm3jV7RFO1tW0a/ZhdWjlmFe4mC2NJT8hASd2/WU8KxZBJcGolLAy0blhBskmCsMnlmouQZEKNT+98aZnuJq1ZO3aWDTheCO4Fkx203lk02aZNtWUeAqNjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDqQcjWyY2cIFrvOsbgzHIjD9E0pfLSJhyuXKLlLr8s=;
 b=PiKnC8ndnZpHj/5Pd1MFOLMzV/DPzpVO6m6Z54fG68yIkYne9AvMlY4OSGe87Cbv0pfQ3LzU2DfzNvkbuPeWFAo5AiS7k0jc4/D0uHOnxnhLIhvGu2YSXe3hpCJLTq1i+uXOFoxQ5ZaW7Sc1S3RWkkJ1CCL840NGAyv/mfXnH++WyIzMqdMuyxZllBhpyV7q8TYIOWtV3hcwQ0fHsAbaIdo4QWREd/LUDDNXBjv3HaP/GgayPr/8Rhkq4EGOqsNlWV4zoDG4CRmf2Pi2L6fYpFVU889NlaeEYueNxB//Oa09w0JwX5rqMT03QpMZXl1AjgvOFKjmhJgSnh4lWBwmKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDqQcjWyY2cIFrvOsbgzHIjD9E0pfLSJhyuXKLlLr8s=;
 b=q3NnRn6phP8ZYit6k9BrPTqI+hpyNWIKhMIG5KA4xgo2PTLvjAwNSEljd2fUfeTV/qSbz+R2w9p44EAccC6Z8MakBg5BhYDD5+kDC6R94UlcApBst+7Y2YqTf/8zsg/BQHVgPpRgEIjE9pu7YM1DFfFSds6mCWzftfmnsJ4n3OI=
Received: from MW4PR04CA0164.namprd04.prod.outlook.com (2603:10b6:303:85::19)
 by BN9PR12MB5161.namprd12.prod.outlook.com (2603:10b6:408:11a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 20:06:42 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::6b) by MW4PR04CA0164.outlook.office365.com
 (2603:10b6:303:85::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:06:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:06:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:06:41 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 05/64] KVM: x86: Add 'update_mem_attr' x86 op
Date:   Wed, 14 Dec 2022 13:39:57 -0600
Message-ID: <20221214194056.161492-6-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT063:EE_|BN9PR12MB5161:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ec48fb-14f8-41fb-83a8-08dade0eb801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9GdpxQggZ8mc4xddKO8SXNdXrz9pFyCn494klrJeSsZe8mcxu0asGOfJvvyHrFvfwQ7pUNiTXZr5CrMIDTM5HAx83u75Rp5YvLyrxo60zqo7Ecp3wroOPSYOpfM6FBWipe6EWJUhRHwLuVFWkZHh3AxGQ9Q79jrdn0l0Byivk//+Qtjp+EOPqVBpvkt1cVTUgIm0lQf3wNKTGA0wgzrli8ENNbKa4atvS7yCEUc1VntAftxP3Kpygi7Vb1LBMVzulwPj8PBaqmztZgflqu37zwod+ob7YzyrB0XzESccxmLYsYGBYBpKXNRXRKa/Yjk1llPpkV8LbKoJZhN5OuLk/qMcLvJMfI4gkFCyobHvSmActk4vBDRuKzrLkZjxSV8437zCgh3NKJOPodFtSg9CcYiTgG+xKpXWHzNd9eaQowvIqiVEcsLLGqbWybl7IWx28pi86OwsfKgC13tr5UW1YfpZbXUo6glFIaGq+keLO1dA6nv07neg4s7NvUE3oniAdFnENhptGNsL7HiJvfJ7HQFEQLS/eXk5tfgOPvVLho6k/riw6OvPYmZ6YIL5nFRRR7tLsFRFqAoR4KOR4pW4ZfbbdcJSFWMHha2fciPZSjjE74PJDjPxm/AzHqMky5NkMmZ/ugPySp7KQaAIn7Xtj84ISY/uO0Curv5MEcvCqB6KIT57aYk9gv+sKFEzI9GaI4iBChxEHcPBtTCXHnwhWSPkpcStI1DTByPTei5fg0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(2906002)(7416002)(7406005)(40480700001)(36860700001)(40460700003)(5660300002)(336012)(8936002)(44832011)(86362001)(1076003)(2616005)(15650500001)(81166007)(356005)(426003)(47076005)(82740400003)(83380400001)(6916009)(54906003)(186003)(316002)(16526019)(6666004)(82310400005)(4326008)(41300700001)(26005)(8676002)(478600001)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:06:42.2799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ec48fb-14f8-41fb-83a8-08dade0eb801
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5161
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This callback will handle any platform-specific handling needed for
converting pages between shared/private.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/mmu/mmu.c             | 10 ++++++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index efae987cdce0..52f94a0ba5e9 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -133,6 +133,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
 KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
+KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 92539708f062..13802389f0f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1637,6 +1637,8 @@ struct kvm_x86_ops {
 			     int root_level);
 	int (*private_mem_enabled)(struct kvm *kvm);
 	int (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
+	int (*update_mem_attr)(struct kvm_memory_slot *slot, unsigned int attr,
+			       gfn_t start, gfn_t end);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 61a7c221b966..a0c41d391547 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7130,7 +7130,7 @@ static void kvm_update_lpage_private_shared_mixed(struct kvm *kvm,
 {
 	unsigned long pages, mask;
 	gfn_t gfn, gfn_end, first, last;
-	int level;
+	int level, ret;
 	bool mixed;
 
 	/*
@@ -7153,7 +7153,7 @@ static void kvm_update_lpage_private_shared_mixed(struct kvm *kvm,
 		linfo_set_mixed(gfn, slot, level, mixed);
 
 		if (first == last)
-			return;
+			goto out;
 
 		for (gfn = first + pages; gfn < last; gfn += pages)
 			linfo_set_mixed(gfn, slot, level, false);
@@ -7166,6 +7166,12 @@ static void kvm_update_lpage_private_shared_mixed(struct kvm *kvm,
 		mixed = mem_attrs_mixed(kvm, slot, level, attrs, gfn, gfn_end);
 		linfo_set_mixed(gfn, slot, level, mixed);
 	}
+
+out:
+	ret = static_call(kvm_x86_update_mem_attr)(slot, attrs, start, end);
+	if (ret)
+		pr_warn_ratelimited("Failed to update GFN range 0x%llx-0x%llx with attributes 0x%lx. Ret: %d\n",
+				    start, end, attrs, ret);
 }
 
 void kvm_arch_set_memory_attributes(struct kvm *kvm,
-- 
2.25.1

