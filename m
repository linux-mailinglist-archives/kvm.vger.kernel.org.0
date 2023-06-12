Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8FB72B71F
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbjFLEye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbjFLEyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:54:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98013172A;
        Sun, 11 Jun 2023 21:53:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbK1RVBoLakfJKebKIj2MALNHZzQw1p+CvLKpXQrvPIsWr9eU3Tq5vX+LOgz4uGVGcGkn+wTj9F5QXDRlsADltqd0W9Inak4rJdeJU36Laz4r5uUMs3flHCPYSvHz8PHyp4XjJ9obDPh4F5UL/c3O9sripDINsiCs7XWUNNsVL5PsDBgRgNtnSCR5tEIjccctKrz8lSImgrC+cDBGW2abF/bSTOuF0twR9MDCuawPR/BIxBpiZZ1MVTs6lvNVpkrP+o4kMRzJHJ8WbqK+22hYZSUkzlGny9YhOT9MRq41qZcb9709grEUpxJ2gWFOj1sXtwOG266MqzlJwcSuJpOJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARsbbAueoW5+HOX2d28yHASiDj/JlfTj9Ohag+P+WKw=;
 b=JH05SSQTd321eg5s4dht+w72gHVo0XidnWNqhdm+bk/JXUQl9l+L5Qa40Vf2hGOprYLinLEMbHrMHXCcJ1CyIlzH9SbJnCWnEJ/YDhxd+ZGjkm/Aw0MoxyBZCQ5Y3GUV7DBwAHrvqZR7IYoO9SKfa8wFXQ2/6UuROinLsMoMUmvtbSDehMP8HZQDak0tp+GcRfSIsA/UgJhfD8A/rlTDcfWQmtx9ofFyIfcv6ooMv8mVg+HKGLt0kbMc6v3WjmQP759clxKeZBDVS01YNhJHQu8Ebz9H0ckEixUSZ/ut4jzKRvBjCfGRj5UdLRaZGh5Pk4YdHq0U5+KUa1l3xkRxGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARsbbAueoW5+HOX2d28yHASiDj/JlfTj9Ohag+P+WKw=;
 b=aWz0M+jjPfMVQWsNEAxpSWNSEEyP8OCwkLgtqkb2xCuDpkf/MONxbMolHaFhvmD55pEJJ3rry1se8iEDluYeA2/gUG1nyvAqFwJXhJrfNT0nZBlhPz6cSyTm+yBV+cQkfgxFbF8VH6jjX5YxmYNMTbAsXQU330CStc8BXTUMqr4=
Received: from DS7PR03CA0288.namprd03.prod.outlook.com (2603:10b6:5:3ad::23)
 by DS0PR12MB6581.namprd12.prod.outlook.com (2603:10b6:8:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Mon, 12 Jun
 2023 04:53:55 +0000
Received: from CY4PEPF0000E9D9.namprd05.prod.outlook.com
 (2603:10b6:5:3ad:cafe::6e) by DS7PR03CA0288.outlook.office365.com
 (2603:10b6:5:3ad::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:53:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D9.mail.protection.outlook.com (10.167.241.77) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:53:54 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:53:54 -0500
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 46/51] KVM: SVM: Add module parameter to enable the SEV-SNP
Date:   Sun, 11 Jun 2023 23:25:54 -0500
Message-ID: <20230612042559.375660-47-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D9:EE_|DS0PR12MB6581:EE_
X-MS-Office365-Filtering-Correlation-Id: 0169d4fa-b07c-4f8b-4d08-08db6b010661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TecPksSkmZkpyzqHwDKTafx7h6RP/MFFlXu9cOpeq2Mz2nCzdjJdIukZy3b8j1i8P50hPP+gjbq68Xa+Qecc8aX0/6FwclY+dzJ8es44Xig6ayNdyECOoY3i6QaQosgkUTvlon0U5m8taTtAMWdYWe71aObzQzQ3XaTCqL6EOQEvE6ODIVdbpxCFZ6uCKrnnEk5cG/F3LDA6FbeN9tgyJ5vHgR3va5PXHlIQdCwPOFvRaUm3AjarrXgcsiijz2ncVrWeJOJ3qtqNFufZA7mfDRvzK8ciAziXWJxvLQAMKfGJil1X5366hQRQZNYd5h9gqAUNMj10zk9h4wIcBHy9AgxkH2Y5Rj4oPmoMo6NaFV3VUGzol9cGqG33yA0wo50l6TihXb5jaECxoIR4RZyXEVw7AM45d/CB2Yjq709ipAtrST+G2xW3LqRjeH3O3xdTIoyMoIsdbgZEwcmpjQHKsBwZVvks+4Ix2IKrS0sap5zmocmyX+H+fEbqHQd/CP1yxIWxhh51gyPUeDP0P+MXkxgsFsrSrzcb1tLOCMn46thc3vyvcoTaLsSrnlO1PToy1WH29MYXHfS2+PzUvpEcaGcLL/jC0oVxu0auId4i3hdRaU8UO2QLiwaKtAc9WY3bDVSMSmX81Q4KIwMIgbyjdkFyC6WklESp4IfxxmQt1l2pK1oqNohwBDEhDXSGgNYupQnZ00lTacfnqoDzXy9csXwVWJQdimd6SUd3C8F20VbO7xP1DpqSla8WoNfICsuqnhM9JtBEaqt78sztvbzQtw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(8936002)(8676002)(44832011)(5660300002)(7406005)(7416002)(4326008)(6916009)(70586007)(70206006)(316002)(54906003)(2906002)(41300700001)(36860700001)(40460700003)(478600001)(81166007)(40480700001)(356005)(26005)(1076003)(16526019)(36756003)(426003)(336012)(83380400001)(186003)(47076005)(2616005)(82740400003)(82310400005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:53:54.7986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0169d4fa-b07c-4f8b-4d08-08db6b010661
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6581
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 543926fa3200..adbe8c242d81 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -54,14 +54,16 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
+#define sev_snp_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
-/* enable/disable SEV-SNP support */
-static bool sev_snp_enabled;
-
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
-- 
2.25.1

