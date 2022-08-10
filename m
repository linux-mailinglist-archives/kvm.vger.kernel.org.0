Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3433C58E6B9
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 07:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiHJFXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 01:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiHJFXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 01:23:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F42783F32
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 22:23:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atIzcZVyhwTGzQWYHppkol/YEGHI4hi1NqK9F0WQjYnUbcSG+SiiMyA2dQl+rg1K7vGUz55X4vlgsQ30smVhDtWeBfZIgzCBScaYhYUoDNN91LbS9x6f3+VGtdX546PzgLLu+igtFUbExurIcEd0/QIOUc7DV55eyetGT1U+WhwfP1urTePeLrvtpg/gEorz2tdWhkrZvzVWZdd2Fk8ExvdkGzphs4BqIg/jcrb1GyFx2wgRfwTpI2LNSLvZAEVXnnl4BVoafEoIE/aaoeB5stJ1wE9kp3EI5b0wLkzOu/4H1j3QWReA3qDW8DsDue4BgYk1bRfzdNqRSUUCMKgXFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+B6uccYLBo47XJ/WzFvtm9XYEm+SS9QpcAVkRQEd3U=;
 b=FzM661KCQaiVoXYZw45hWx3fu958l/dBbc347FRQwgEum7QxUQwCSVdO0Jp+Iu03qWyiiivZm5Ak6+IYgWrIRwqbEm7V755Kpg9S6fXI1JKyGfK/FrlYeV8hKigElg6hv91o8TqygNVtxPazsU2xga+TwcE0KkMASCVOZtk6c29veeQsActZYu2PBsFUZTwXKPzB7FQPoRfVMADIquhemHc+IEk1e71Ak/txTDFlEQ/zqWh2vICp0R+eJUaFgXhUaq+k2nl5Ds1NylB+xPY2rnb5fImmmSFhTaLoXNuhMfSFOMYoKiK/wE9g68YAmxp5L5Yjl+Yg9YcWgIJd4jCp2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+B6uccYLBo47XJ/WzFvtm9XYEm+SS9QpcAVkRQEd3U=;
 b=mEFrf8mztsUDib3P7RcX6blgZRZRez2C25mFq8jqxA8NNEOVZjciA+gwwoAW6WMjUEyE2UWk5dGdz407GUyHWfiuuuHgoMQg2NPfCbul8DDXKYb7gZ6gUlYUdE84vU1EAlHBfS0/p+hNS4+Q03B5H6QRJ6VBkTZiOG+KVvv5diw=
Received: from MW4PR03CA0358.namprd03.prod.outlook.com (2603:10b6:303:dc::33)
 by BN6PR12MB1508.namprd12.prod.outlook.com (2603:10b6:405:f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 05:23:34 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::63) by MW4PR03CA0358.outlook.office365.com
 (2603:10b6:303:dc::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14 via Frontend
 Transport; Wed, 10 Aug 2022 05:23:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 05:23:33 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 00:23:30 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH v2 4/4] x86: nSVM: Move part of #NM test to exception test framework
Date:   Wed, 10 Aug 2022 05:23:13 +0000
Message-ID: <20220810052313.7630-1-manali.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: b0e56345-06c7-4025-367a-08da7a907817
X-MS-TrafficTypeDiagnostic: BN6PR12MB1508:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RfqS9zaytDsR9CxylkUQ6DExeLUvBaxWcQrVb/pYnJLCcTIzqfmSrPl8lzIQsPPq1npIrg8Upt+TIwt2JzFrgZu6/gKt7s0QWV0xkw7CK6FIdojzlGPPN6rwozSlBPO4MwyxxsCQ0C/YIIlo8COYrNc3odHY456mXzzFX6kLPET+QBwHDEgoIWv9iLHGjPrqMO9AAuZ7yPQQZo9KgyVm17sdrmEm6d39XlwihtdC4m/ZrQQlj/D6YWl/OuTi/avHRfPnjyyVQJC0wYaq7rTjC7HVuK/taTeUO3gREJjoYCkikCY1iBreyYjDmdLhbuZOt0MarpSWarMZJodWrTnsmSagDsZIM44PR/XK7PymLGAgcgMGNYozN1bOsKpku5JS0aQhmKZyc2Ey5MPmPD1hhjUGyKqHCRN8a351t2itL5Qvomf6jhQMQtJ7V+wZG2isPRDq7WBNjyWUQsNLK2WrMeyMJd1LSi8rooh8+zhCI4n4hCwcylaipsz4omAv06cpZn14loyA98fdywEys9CpVXDIo5SO3vvgH3xQ9HR7D5268vwF/NOKahSMVOiYMgZRl9K0ArunRF9BDjifSth1j8uX2oEEhurJMZ89wHZP29Eiue6nu6jWBuw7PlaOrmLbmjKejWRVFb5+nLvFUic0gcfGgs71sksyI07HUukvWqcKaCywNcw9pPM4jriiFE0/sLMY3m+oKNbQwuhsw5G0Hyf0RNb1rmwQQqQPLa7z8C5B1mFWgZticLpk0/5cfRCggnlREe2lustOEG823gcQ+jqG7oRSgQ8dSPuPIMJ379J68IgxvhrW5unp8AeJ+hocWTLvvgLgtXfGWsWs4Fq/Rg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(346002)(136003)(40470700004)(36840700001)(46966006)(1076003)(83380400001)(36756003)(2906002)(82740400003)(8676002)(4326008)(40460700003)(2616005)(426003)(47076005)(6666004)(26005)(336012)(7696005)(16526019)(186003)(41300700001)(70586007)(70206006)(44832011)(36860700001)(8936002)(5660300002)(82310400005)(478600001)(86362001)(40480700001)(81166007)(110136005)(316002)(54906003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 05:23:33.3294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e56345-06c7-4025-367a-08da7a907817
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1508
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the boiler plate code for #NM test and move #NM exception test in
exception test framework.

Keep the test case for the condition where #NM exception is not
generated as it is.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index b0f0980..2ed65c3 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2807,34 +2807,18 @@ static void svm_nm_test_guest(struct svm_test *test)
 	asm volatile("fnop");
 }
 
-/* This test checks that:
- *
- * (a) If CR0.TS is set in L2, #NM is handled by L2 when
- *     just an L2 handler is registered.
- *
- * (b) If CR0.TS is cleared and CR0.EM is set, #NM is handled
- *     by L2 when just an l2 handler is registered.
- *
- * (c) If CR0.TS and CR0.EM are cleared in L2, no exception
- *     is generated.
+/*
+ * If CR0.TS and CR0.EM are cleared in L2, no exception
+ * is generated.
  */
-
 static void svm_nm_test(void)
 {
 	handle_exception(NM_VECTOR, guest_test_nm_handler);
 	write_cr0(read_cr0() & ~X86_CR0_TS);
 	test_set_guest(svm_nm_test_guest);
 
-	vmcb->save.cr0 = vmcb->save.cr0 | X86_CR0_TS;
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 1,
-	       "fnop with CR0.TS set in L2, #NM is triggered");
-
-	vmcb->save.cr0 = (vmcb->save.cr0 & ~X86_CR0_TS) | X86_CR0_EM;
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
-	       "fnop with CR0.EM set in L2, #NM is triggered");
-
 	vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
+	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 0,
 	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
 }
 
@@ -3308,6 +3292,24 @@ static void svm_l2_ac_test(struct svm_test *test)
 	vmmcall();
 }
 
+/*
+ * If CR0.TS is set in L2, #NM is generared
+ */
+static void svm_l2_nm_test(struct svm_test *svm)
+{
+	write_cr0(read_cr0() | X86_CR0_TS);
+	asm volatile("fnop");
+}
+
+/*
+ * If CR0.TS is cleared and CR0.EM is set, #NM is generated
+ */
+static void svm_l2_nm_test1(struct svm_test *svm)
+{
+	write_cr0((read_cr0() & ~X86_CR0_TS) | X86_CR0_EM);
+	asm volatile("fnop");
+}
+
 struct svm_exception_test {
 	u8 vector;
 	void (*guest_code)(struct svm_test*);
@@ -3321,6 +3323,8 @@ struct svm_exception_test svm_exception_tests[] = {
 	{ AC_VECTOR, svm_l2_ac_test },
 	{ BP_VECTOR, svm_l2_bp_test },
 	{ OF_VECTOR, svm_l2_of_test },
+	{ NM_VECTOR, svm_l2_nm_test },
+	{ NM_VECTOR, svm_l2_nm_test1 },
 };
 
 static u8 svm_exception_test_vector;
-- 
2.34.1

