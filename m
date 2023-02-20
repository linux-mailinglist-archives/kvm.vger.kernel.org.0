Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D1169D39C
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbjBTTAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbjBTTAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:00:12 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B2B1E9F5;
        Mon, 20 Feb 2023 10:59:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLV3QQsEGZSu8710w2osmcV4RHcw2UgPGml7vwAorec4dyGcVoMFz+ERVqw5ryGa1PkMTr7znLv5dlBEKGoI4HW2X6FCmPsctFlpygzMwApuV/Qc5gj27/p1GzRh8U056X5xEW8yKq3r9FB3QtLoLtIaGgA0WUzTTvkUzbODKjGikN7yudCF5qIrPSU/Kk4rMQdPKZuG/jg/y05yfk5wzcmYcqVcNOr58BaPbWaX+pCEYbqYKmVYg8mhSyA9pJ9Qu2nTkwJU7uKWV9va4MkAKqC6JRXVkCy+2klAmHTGKqofPlsrEvo7147e3SV79167D3o/RE9SAjvZMCuiZueBag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9dPtb0J/B6n406AfrJg339OIKYCnCNwo7m/uhWDMfY=;
 b=UmAd5w/a+zj2LcI890mdC8xgGIqNs8NcNryEFeldtQXc7VbCEAaoVoXW4mIUb7goc97S6fU34S2kXx2vzRtkwJvu8K5P9nYiU+bQIg+a1+SfjMlpPxvSwXNwoZCKalrz0n9tNpGCSK3zabE0gW8/kDbsZJwAFoJlX9RgTOIbDoNvaOoSseYcDplLcWPOqX/TqQTETKSpE4Q+vvuR8/JgMdHNklfouuMF/y5gwwNsvzzhW5JRtNhcorYalAvEHWy5T+oZu+cAQSWwGzShGdWCv6I2CAeMaZBdyLNypkdMAnX7ZI77tmqUFv4vb2T2Cl9V1/Lf1OiyOPV05RVjpuF11A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9dPtb0J/B6n406AfrJg339OIKYCnCNwo7m/uhWDMfY=;
 b=MCpI3e1WmlGp5o3G5hOLQwYy58HQ81kP6avyRb3xtqyJFOLwuKr71uasLywu7+Ok6Bxa7BKQ0jjxe7+4SZbhXGZAUi+Fyj8GghV5tr7+VhqZ7JNuZ6SihzpvAbFlmVMu2B8tfrnDQdBW2HrftK+iVezGJhEJu1ogiOgX1Kfl2fg=
Received: from MW4PR02CA0013.namprd02.prod.outlook.com (2603:10b6:303:16d::13)
 by PH8PR12MB6963.namprd12.prod.outlook.com (2603:10b6:510:1be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:58:35 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::1) by MW4PR02CA0013.outlook.office365.com
 (2603:10b6:303:16d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:58:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 18:58:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:58:34 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 49/56] KVM: SVM: Implement .fault_is_private callback for SNP
Date:   Mon, 20 Feb 2023 12:38:40 -0600
Message-ID: <20230220183847.59159-50-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT013:EE_|PH8PR12MB6963:EE_
X-MS-Office365-Filtering-Correlation-Id: a626403f-4abd-4245-6a54-08db13747814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xsTmTtwZ3Q/QLmceQLkWyD+sMYUrSej4eqJpbsjCTCgYmGIgp+UT3HnpbWytpaIUWo1AZQHbUaRX/Ou2fe383JrK9NCpYa8ku0G70oT2lIPw0J/pkh4d5QjVOfpVHd2UqrTGAI8uu2l6P0zYYAXtGGl1lPmozORWBwiqaCwOJ4vwQj5Z08ebbLm/oa4pqHWWGVsOlb8FMRskLyWQBhveWtISfHInADI0vXuex8FDw5TupECKbhnXLsGX2qgN2PQqXjAIbwfdRBpT+bEyj7RKYxIr3p2VWu+Eub3MGsEH9MsoCr6MXmgeckOr7aLFA/kraaWuydECTARYWE0w8jWkn9Dzb0hpQyORYI+ox1KpFDu0Wtq/L6PjX2Mghj5QIdDCVE1RGfmQ83Qr9E4oiHIRnEh1RIbO0f8VQWF/ix3M+DKU2xWrPJBZv8XhJ9ryicyPTlt/Lj+2ik4euHDtojYujG7c3onX11F9Y0fqL/lRHJBiYYG70zJ5Q02p2p3w++mS3QYpiE198zRARphm16Ok9xRKrPfPCszVzeIBZLnDCQSohvksTFKYjDaCixw5gol0xWk0CnjT/0XlsO6IPO9pTFzVN9aAmxxixw6f3nUTZ+xFN5oUpAdlfi5DSIWYqon+IQtDeLSc/IR5Df9t4I0d4tFu1tlf6PQr9E+mkWdm0xAqmQ5HqsHmQErrCt9GK7qK48ywfFfBRCWDuNcVyzfrSJDuiqYIj2tMG0gzryqeQouDaiharWPfn79/tyHbGUmTs9UOgC+A9LcpT4MPQfi2A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199018)(46966006)(36840700001)(40470700004)(7406005)(7416002)(2906002)(44832011)(8936002)(5660300002)(47076005)(36860700001)(426003)(83380400001)(36756003)(6666004)(16526019)(26005)(2616005)(1076003)(70586007)(186003)(81166007)(40480700001)(356005)(86362001)(70206006)(40460700003)(41300700001)(82740400003)(6916009)(8676002)(4326008)(478600001)(316002)(336012)(54906003)(82310400005)(142923001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:58:35.3076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a626403f-4abd-4245-6a54-08db13747814
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6963
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM MMU will use this to determine whether an #NPF should be serviced
with restricted memory or not.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  2 ++
 3 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 73d614c538da..7a74a92cb39a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4499,3 +4499,13 @@ int sev_update_mem_attr(struct kvm_memory_slot *slot, unsigned int attr,
 
 	return 0;
 }
+
+bool sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault)
+{
+	if (!sev_snp_guest(kvm))
+		return false;
+
+	*private_fault = (error_code & PFERR_GUEST_ENC_MASK) ? true : false;
+
+	return true;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e2edc4700e55..18e4a6c17d11 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4861,6 +4861,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.adjust_mapping_level = sev_adjust_mapping_level,
 	.update_mem_attr = sev_update_mem_attr,
+	.fault_is_private = sev_fault_is_private,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 50a2bcaf3fd7..97038afa8020 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -728,6 +728,8 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_update_mem_attr(struct kvm_memory_slot *slot, unsigned int attr,
 			gfn_t start, gfn_t end);
 
+bool sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
+
 /* vmenter.S */
 
 void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
-- 
2.25.1

