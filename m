Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3248BFCF79
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfKNUPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:55 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727264AbfKNUPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MiQ9xv78YLQ55GuNwCqeuLtP3oHB6Z0/YIXgB1qRZiwhzBRfufBSbrSt1UYTsrctfJ5IllGoe4Efxu3zQO6kQk1IaQyDAesFglkaMcPz4HfsWYTmNcpQlcQ+fjL2Mgd4EVELXYUzpLVjz1CRJQeth/UoFYpLUs7pU5zBhZ8HkwVIwjUrycgNhLtgEwcNf0EIonKsTvKjg8Ss+txo//eJfv2L9KHdryl+J4sl68gVepFfdCkXH/73EC9JT1ZaZVLEvZ9H5k5mRrPMYBBreofcy1on6ihl+3leQOpKuBYeg+yAmmoq68YLsLfxe4Cz64dSz/hYE+HPO0xdRmhP9r53sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pz6ihk0kNZNPLguM1X7r00kVPhnR4PzcR/vut0cWNg=;
 b=XCOQ8sz7T0Ao3FNT7KIJoNOcGHpZ20q7VoPU8eQjDWJz5qQs8/URSX9YRwJTuHSOhXxPrCOyeeSd/ZXKYdXkItlCsX9BRGaZqKVny2FXB2Q02zgIVo6JNzdLcGzXIAW9X1Q35lAp+QglUZ1UhmkwZtrV9FYFkuDYgipV8en6YtLc11Deoa6jC6exVd+clOAI+wjWcusyMW+q9K1w5NCthFc031qAykzPyyN/OjEc+B/Y9LYgYmj8fjOXk4lJLuMsHQAjPtBo+xn/SjuCrnjQ8xzNLSP50OCGpVezy7oNSFr0T9YdolVruUB0qcOh9RPWTGxj8cgs0y6MXAJBURfqgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pz6ihk0kNZNPLguM1X7r00kVPhnR4PzcR/vut0cWNg=;
 b=voOUx5dtSGFSgAZPaefCcaQ164wbQDjq0o0IlTu0hIDMwjAZDzNbwFIxfdmwFPRH0owv7963u6XB5UUJ/AXAfFIuXmum6S6Z+YVCfbfc47dpWH1e8GU7oUrE/eHqQQZ3z//yDpZC36KvC45zdnCqZaIXuq/iDF/GUNf5maP7Do0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:46 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:46 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 12/18] svm: Deactivate AVIC when launching guest with nested SVM support
Date:   Thu, 14 Nov 2019 14:15:14 -0600
Message-Id: <1573762520-80328-13-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5b36aa6-048e-4d9c-383b-08d7693f6f14
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739E6EB9FDA41A247EB759BF3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZdggCOjGlWCM6uhda2JBJvWWQ+6Hlm9jtcEQDmQyLCfqYMKagTx93xEHWaEhaOoGIvT/VUN33ythAhZ4TCBUVL3/ZnWLEBxdZsL6tBN/6RzMcFewysRxkv4p6GF/9HQp7/JSrOQFl6kaLfcE7M0WBqjULFlftYfE47FiLG+DN8rxVf7kkpVYQaZe8KTnLiYe/nsMO5Fh5Iz4EQiQb3iTSItCnmhA2KxILx+3sYvy8+JO7sX42mUmZ/h0UVdkUANn/5g9cz6JQQT1T8fMO4alnK60nZbefoTZ55sFO1yaJ57iGcoZ1BTFNdSTxpQ+J7daKBattSCy+fDq1MmnhEmznX8sXlOd6JUxWNNc0jPQTj7x9monTdfGcWEQBhLF1mjv48l+J64PKeSgV1A7rqxISwAtSWeXd+Ryp7exsec5OkxrXj2xurIu7YbLIDE0cVQi
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b36aa6-048e-4d9c-383b-08d7693f6f14
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:46.5455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RkF40ZWEb7a3TLUiMjR1te2nBMSWJRUE9llh2rGi/IIMCZKQfB3AwAw0Uh2Gx5pb63SKaGqkgKSlZlBAnvsaNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since AVIC does not currently work w/ nested virtualization,
deactivate AVIC for the guest if setting CPUID Fn80000001_ECX[SVM]
(i.e. indicate support for SVM, which is needed for nested virtualization).
Also, introduce a new APICV_INHIBIT_REASON_NESTED bit to be used for
this reason.

Suggested-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5d1e4a9..6c598ca 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -851,6 +851,7 @@ enum kvm_irqchip_mode {
 
 #define APICV_INHIBIT_REASON_DISABLE    0
 #define APICV_INHIBIT_REASON_HYPERV     1
+#define APICV_INHIBIT_REASON_NESTED     2
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5e80b7e..ac4901c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5963,6 +5963,14 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 		return;
 
 	guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
+
+	/*
+	 * Currently, AVIC does not work with nested virtualization.
+	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
+	 */
+	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+		kvm_request_apicv_update(vcpu->kvm, false,
+					 APICV_INHIBIT_REASON_NESTED);
 }
 
 #define F(x) bit(X86_FEATURE_##x)
@@ -7244,7 +7252,8 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 static bool svm_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
-			  BIT(APICV_INHIBIT_REASON_HYPERV);
+			  BIT(APICV_INHIBIT_REASON_HYPERV) |
+			  BIT(APICV_INHIBIT_REASON_NESTED);
 
 	return supported & BIT(bit);
 }
-- 
1.8.3.1

