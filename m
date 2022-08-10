Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A019E58E6B2
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 07:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiHJFVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 01:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiHJFVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 01:21:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580C655096
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 22:21:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuC7YJA5Yvaqptv4NaR5RomcZpbEJ38suX2yjXV0WWAsk9RvC3cqAVNAgVKIuTs1T1EoEFHVQjpqs5KDXukmymHkVzwaxMhLv3Ew6a3ldqYeIjcjoHotJRhz2anjS2ZY6Pvy4aZDhDEfbASrOoE96Yyq9ugyfB+GRZsFWY8ViFif+7WdoVnscQ1psSQJcGGVoSPt23p/vfAbUswmX74iqd61ESDJxG92XEu374ttw32CEx6geBIvwAppkZBSptgGX3fZmkY2eDpq6Gjv+pz6bFF5daKST7so37eAF4OFgbko21nH+foOzMNKbyjuVU/np/AD8dIsDuud0jPYVtPBqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noqBMuhLEuLUmTm5XUlb+Hjb1tYDh00SCpz1Gc+YNWE=;
 b=aNlj1wUxzoCBIHtJlS99bAQ1WyYNAL7yTNa+4Wj+CoJVWqN15xhSAlQWTPevMAKDHgzEqmzFCQLW6ojFnHSH0jSfK7IFoBzwTN85DuedHyqTKujzbWqE4HIb1+6Po2d1SWo+3yi0RbUMtDQXcPApjY9NwuBDjKtelf6EpxOb+QQFn6dx5mggZzgoLMmabXtUgLixSZUsIxvUYlBP6USBvYHKkvBIae4nzARbP8HoANrMgWkf2O/VEaYgt7K+x4n+Y30VLFQ33eA+a2t9LvbapDno2GUgPg6auj7f5gTl7Tl+WU7xBvfq06B9Id1vtN3Rsa8JhOocuXjSGXmKzh3KzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noqBMuhLEuLUmTm5XUlb+Hjb1tYDh00SCpz1Gc+YNWE=;
 b=FLlHaYpffMNzwrAay4qhyr5eMIbkLCNIY39jK43U9h4ftCcoicED0UOwm+8weLnbwg4j3VyT2TaogniT6GJzj/dcWU6tndQwnLomllQGwL8Ws8WXSsz+XkzWRBKLHwxINUSJvQpZL7q9OQ/k8DN+p6tho5YLCu5jH/uMTcmfyV4=
Received: from MW4PR04CA0196.namprd04.prod.outlook.com (2603:10b6:303:86::21)
 by SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Wed, 10 Aug
 2022 05:21:04 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::b0) by MW4PR04CA0196.outlook.office365.com
 (2603:10b6:303:86::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Wed, 10 Aug 2022 05:21:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 05:21:03 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 00:20:41 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH v2 1/4] x86: nSVM: Add an exception test framework and tests
Date:   Wed, 10 Aug 2022 05:20:27 +0000
Message-ID: <20220810052027.7575-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220810050738.7442-1-manali.shukla@amd.com>
References: <20220810050738.7442-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a73fcf63-8eeb-416c-0d9b-08da7a901f13
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7082:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jejOrFQ/cT5Gk1Xx8YZYfzCs1SBEUNyJNfbdnv+IfxE1XnXZbc5x256q6RmcOlxvDJdWb0SOposd+zmbdrSdkEKj0VSZVxtNku71sN+zwrwjwGlvQ+4Qt5pGNWqUb9NdXvu5bXf2VbLrVhzlQwl1ygGghI6aCcAufCxegC0K+KXI8H5U4gzjL5odGYY2TfC0a/YltrLtZ1BEbeOwyev4xzkbEF8//ZPNNlYCsfylR4Dwvs/UQ8W5OKOXrhWk767weUhqNip32mrG/2wNEW7WPHcEbgTtx8b3Sqp2T5hgo6VFVThqaav0RbNVgTGpYvHaLKZ6sTBAjwJnIW86nkzGDnrIh9Ma1DlwimflzphaU6cOCZ+Ec+ZtZ/puSGg8ayH0lel3ja78NWSHO3L+6GUvUtG7HymtO/9vNpuRfUz9X+7kEP+rKpl5fMxqP0UUGV4nE9X0wxWaHH/qHl8DdbxvSvxHTYEYtG6T6fb9kFIYM0gn2G4ulkbJOBdvqHepPqcHcSaw4lARLEkwuT6l24hKi5xprMAJ6ElcsWpdXyKpa1PqmDni1YAq+mpboEKs+VVDZrikjLbJO6xLgypbyRvUAhYUSydfyBEwMBEa1Ai3YoB541Ub9TFAiubpvWlUVRdKpf14gDdCKG9bUO6WbHtueovZOCjJMx0JRIMIfzgEzcgGKMrO56H0i884U2ckm/ECgY+7Q/ts4oI7I02uTzQPFAYKmlnysszvXMQAixnXVoDEiZW6T6LyFHnh4vtmThg2h0Sf5qR6NBHv0KDljMtocag5T6r0EAbd9S9CtLwIqdGb37RKYJmjAClrxa7L8Ziq9Szs8xdrhfHJL4uGupNeNQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(396003)(346002)(46966006)(40470700004)(36840700001)(83380400001)(41300700001)(70586007)(6666004)(4326008)(26005)(7696005)(70206006)(8676002)(16526019)(186003)(356005)(1076003)(81166007)(47076005)(82740400003)(426003)(316002)(336012)(2616005)(82310400005)(478600001)(86362001)(36756003)(44832011)(2906002)(40460700003)(40480700001)(54906003)(110136005)(36860700001)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 05:21:03.9380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a73fcf63-8eeb-416c-0d9b-08da7a901f13
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set up a test framework that verifies an exception occurring
in L2 is forwarded to the right place (L1 or L2).
It adds an exception test array and exception callbacks to that array.

Tests two conditions for each exception.
1) Exception generated in L2, is handled by L2 when L2 exception handler
   is registered.
2) Exception generated in L2, is handled by L1 when intercept exception
   bit map is set in L1.

Add testing for below exceptions:
(#GP, #UD, #DE, #DB, #AC)
1. #GP is generated in c by non-canonical access in L2.
2. #UD is generated by calling "ud2" instruction in L2.
3. #DE is generated using instrumented code which generates
   divide by zero condition.
4. #DB is generated by setting TF bit before entering to L2.
5. #AC is genrated by writing 8 bytes to 4 byte aligned address in L2
   user mode when AM bit is set in CR0 register and AC bit is set in
   RFLAGS.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e2ec954..7544034 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -10,6 +10,7 @@
 #include "isr.h"
 #include "apic.h"
 #include "delay.h"
+#include "x86/usermode.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -3289,6 +3290,118 @@ static void svm_intr_intercept_mix_smi(void)
 	svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
 }
 
+static void svm_l2_gp_test(struct svm_test *test)
+{
+	*(volatile u64 *)NONCANONICAL = 0;
+}
+
+static void svm_l2_ud_test(struct svm_test *test)
+{
+	asm volatile ("ud2");
+}
+
+static void svm_l2_de_test(struct svm_test *test)
+{
+	asm volatile (
+		"xor %%eax, %%eax\n\t"
+		"xor %%ebx, %%ebx\n\t"
+		"xor %%edx, %%edx\n\t"
+		"idiv %%ebx\n\t"
+		::: "eax", "ebx", "edx");
+}
+
+static void svm_l2_db_test(struct svm_test *test)
+{
+	write_rflags(read_rflags() | X86_EFLAGS_TF);
+}
+
+static uint64_t usermode_callback(void)
+{
+	/*
+	 * Trigger an #AC by writing 8 bytes to a 4-byte aligned address.
+	 * Disclaimer: It is assumed that the stack pointer is aligned
+	 * on a 16-byte boundary as x86_64 stacks should be.
+	 */
+	asm volatile("movq $0, -0x4(%rsp)");
+
+	return 0;
+}
+
+static void svm_l2_ac_test(struct svm_test *test)
+{
+	bool hit_ac = false;
+
+	write_cr0(read_cr0() | X86_CR0_AM);
+	write_rflags(read_rflags() | X86_EFLAGS_AC);
+
+	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &hit_ac);
+	report(hit_ac, "Usermode #AC handled in L2");
+	vmmcall();
+}
+
+struct svm_exception_test {
+	u8 vector;
+	void (*guest_code)(struct svm_test*);
+};
+
+struct svm_exception_test svm_exception_tests[] = {
+	{ GP_VECTOR, svm_l2_gp_test },
+	{ UD_VECTOR, svm_l2_ud_test },
+	{ DE_VECTOR, svm_l2_de_test },
+	{ DB_VECTOR, svm_l2_db_test },
+	{ AC_VECTOR, svm_l2_ac_test },
+};
+
+static u8 svm_exception_test_vector;
+
+static void svm_exception_handler(struct ex_regs *regs)
+{
+	report(regs->vector == svm_exception_test_vector,
+		"Handling %s in L2's exception handler",
+		exception_mnemonic(svm_exception_test_vector));
+	vmmcall();
+}
+
+static void handle_exception_in_l2(u8 vector)
+{
+	handler old_handler = handle_exception(vector, svm_exception_handler);
+	svm_exception_test_vector = vector;
+
+	report(svm_vmrun() == SVM_EXIT_VMMCALL,
+		"%s handled by L2", exception_mnemonic(vector));
+
+	handle_exception(vector, old_handler);
+}
+
+static void handle_exception_in_l1(u32 vector)
+{
+	u32 old_ie = vmcb->control.intercept_exceptions;
+
+	vmcb->control.intercept_exceptions |= (1ULL << vector);
+
+	report(svm_vmrun() == (SVM_EXIT_EXCP_BASE + vector),
+		"%s handled by L1",  exception_mnemonic(vector));
+
+	vmcb->control.intercept_exceptions = old_ie;
+}
+
+static void svm_exception_test(void)
+{
+	struct svm_exception_test *t;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(svm_exception_tests); i++) {
+		t = &svm_exception_tests[i];
+		test_set_guest(t->guest_code);
+
+		handle_exception_in_l2(t->vector);
+		vmcb_ident(vmcb);
+
+		handle_exception_in_l1(t->vector);
+		vmcb_ident(vmcb);
+	}
+}
+
 struct svm_test svm_tests[] = {
 	{ "null", default_supported, default_prepare,
 	  default_prepare_gif_clear, null_test,
@@ -3389,6 +3502,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_nm_test),
 	TEST(svm_int3_test),
 	TEST(svm_into_test),
+	TEST(svm_exception_test),
 	TEST(svm_lbrv_test0),
 	TEST(svm_lbrv_test1),
 	TEST(svm_lbrv_test2),
-- 
2.34.1

