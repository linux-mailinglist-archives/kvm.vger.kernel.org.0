Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D0136F9DE
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhD3MRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:17:48 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232064AbhD3MRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkZOmO2XKBK8BMlwz+YG5a1AWWxwUf4+O+MbLHschalQnRLLqm+YP70bmA2hBrLrHY9BjXcneQYKIo9g+k7GLNbdWaK8H32lXt7zfUqyMZMgsqoW4Qra4jhmQobyrV+o62wqDOfmZMYs+gdQvRhUbuDFy1pTJkNrrZgWO0VpVZyUiUaGvag4LaolRBQc9NeoboF6Siyewb3tn5mSqu9FB8G6CzJzwyKosuzogCRWgLfmHex8vtZSBSRhlIQ7O9/38Kj6DQRE1gdllXBzDH9C9/oidn4ZTxBEBD5QWicpAH20HvZgthmCbixDjHh+fonrJEcRBrAFnX/xttD3i2Asig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xEWNKriK6GthtqYpbXD74e5dLEin+bVpa5qOxZeKuE=;
 b=KmF1SrNr8dqaL5ASwbVWbt1uS17RhsR6JBGWBQQNx7AbOJA87vJs77Fk3xkjk2e8i3Xts4NqYJLRRYBBuELGKOvI6l6Pmca8TruhUH8Oh31WP9k7fZVp+Lw7hd+lADPZdP7vBD7bV+hKfYvdlTeWTQMCBeYCPSIyKsHkE3LRhNrtcR48gTlnJXLpsWY2kjEbb5TYDolj+84D2eNP98iGApATN7h8J9BflFf8GBBNSCKy+A9py7Otm/+QkbaxEe4ZYo3IqCZeI0UdFYYoskei/0NF03qxiJVp4erQzL9OIPxvIb+rU32dxiBVK/ahOFb0y1ZRy8YzQnnXwm6t3cS7iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xEWNKriK6GthtqYpbXD74e5dLEin+bVpa5qOxZeKuE=;
 b=VqZToiQYXi/TSPjDGySAVqc15dHVbtmn5rcvMc5QAELDHYefweQQkSAzp6ib/b77CuSkpM0ymM+gv25zSokQWSCkT/CryfhmVDCZcyh5g+e6WgEZ6IT52LqhCVQNXH7fQ1KHJ0SKl8uVjSVvz4SLtmV2CiDsfaJ45G+8gWbWfJo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:50 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 03/20] x86/sev: Add support for hypervisor feature VMGEXIT
Date:   Fri, 30 Apr 2021 07:15:59 -0500
Message-Id: <20210430121616.2295-4-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 964d61e5-2ee0-4d48-ffc5-08d90bd1d4db
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4431F009269E949260A6D164E55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zhj224HhQhHvCD0/5UkFZlXf0xYgd6V+7uswIcLZ7jiXxyKR7xrM3RXbe7/oBHCBwr/3VqknSlH3IdQO9PehjuGcQd+aPnwIc0PCKP4aogXA2rbpQC8BLGTIjdDpB4qU4JpXjsua7AjJJh9QRIHLbRcDspaRbkGA67OmOAxqO5+i+VzRRKkYbgyYiaOmb3WpqZbz6ZbmE/W1YkamHdeuDmc02nf3zCAFlZO8mHTa7cOJiIeGLgIjLXa88OXapAm7e05pCyUFlIBRm4VbLL2tvU1U2yJAtetc2CeCyCQq5o+9AKVyx6zLDliszOCq1/h7BPCeS374vCKVXj+sIkfPf+nxHPAuHHJutZQxU31y27DYmyoEoC2PFBKZVZai+KVWjwlvd72PqB+CY0bn3D3lyHEA7eB7SV6zmjLTvFmKYF9IvkgjkaQLo2oFQZY6BgmdycPs1HwvGQqa2e6Rym+shdHVwjqeG+VuSrWF2uCt/F8cegZ/fteiKUPBlPvHb6385bzBKC3H/ymNsdZSP0OrQYZznfqDEvhvykzH06l+6XCuPxurq7c9txy0RAahUzJSGMzSF2AjpPKINxViXq+1hHOkAZVzXbM2/PJ4I0RcY4G2jdfQw9A/wOLccWIjANay+yQxC6bqR58zEyLbCvCX7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FYBqoBRALVULEu9MivBtSM0yZzBPtTCogzCod/t0F+Mvqqg0WFFCYWev/OKc?=
 =?us-ascii?Q?ytJe5ZTSXcewSKE5U7qSqiX0tNR/kXrhSut+YqeWxvXK2EFqUVzsGWtLas8f?=
 =?us-ascii?Q?+JM4PAFcfthtDAPldRD6+vZLt2ohjHAyHSrkx9FgoiHaWyyj0LpNIFjAsB0B?=
 =?us-ascii?Q?QcX9rol7e+ITbb09Sfs39twnRYs1v4jMWk3Ij0iWmvRAVizyRsH36tTkuBjw?=
 =?us-ascii?Q?F6XQMmNDi9Np9MzH704MySZ3BgjU2IE/GyjEpoxPgOeDMdtzTpms5PVHLSgY?=
 =?us-ascii?Q?xB29Ky8xY5joIcB7/goA8AUsb8Y9m6Dyi58znJojz5rlYIguaOvgeYXvDA9s?=
 =?us-ascii?Q?NkmIqUqLYgh0xNu3fz9Pa+OAKT6Z7ZBvTejl2sUBGAfnuuCB4s1Pf+3IMnXj?=
 =?us-ascii?Q?C+qvNSe83haMQ0cyLq4D67Jf2olRckfWECACjbXhO309ndFo4h0z7HPPtZwh?=
 =?us-ascii?Q?4lax7c99oFSI6oSftLmitJmhYzwHngPd7lSFFMRqx6U2222/2zI0htrf4gSP?=
 =?us-ascii?Q?bbq9iapjPRfxCxFegpS4TLwT4wrN6N/ySDvjDkLahJVIk8N0Kib8ybQ9W52H?=
 =?us-ascii?Q?Wztp9RdVAdyM8RetRYsUpGCHrw+bnQDKiLCL40Atw6QR3CjNU18J/7ROErIv?=
 =?us-ascii?Q?zNxENhTjvp6eTR/AE1i3iYQIHX4j/yw5fqLESteznfvotFCi6VgGpsIVg2RH?=
 =?us-ascii?Q?5bmPKrGGtHM3gBDrQC1ZQxnNKhMlM9+ywy//I8EJgJJC7r020yHVy42dAJNu?=
 =?us-ascii?Q?PpVSQ1HYGYbdTf6CNCS544XI4VGqyr7Ri3YEDDo7F4HCdlJ7x3XD0NJ9D73l?=
 =?us-ascii?Q?3y0FMD/nuF9/7EfH1KPZBlyeAO+RBoxD15hCsJi4fvASkEXdqT0hxguJNEOv?=
 =?us-ascii?Q?4X8/0uRzJyoyemt/tCb7aKVsgbYktwDyWlxGovH6reQYtQ9BfW641MCODE6I?=
 =?us-ascii?Q?BTcvJHoLO9ahCkqLQplClA7UXewTujXZGZLs0Fmgfh0eHdJSqk+hyLgns8bU?=
 =?us-ascii?Q?UGsiCjLjqr9p7Pn6z+fjeUpH8kYFuy6ExSslllcctgSZjN5n211zTdsohSjP?=
 =?us-ascii?Q?2h0vECDVKwzewvOZCkrZmvd+Qv7NnYi1mXTnu3eTpUpG/2L+Dtmzc5OW8/ma?=
 =?us-ascii?Q?J12lDqq+sPl0mtA6x4y41Rn1G7fb83DCb4NyJhte2qvBst8UImAW4p1amy75?=
 =?us-ascii?Q?VvTRfOLOec2bHRo7/KpWgombmExx3IdlTEqvUPtA4Xrv8QVi7oD2L4cmG0rF?=
 =?us-ascii?Q?TnZ0W3mOtHH9+komL/sgjaLmUY5lSUPsxS2AtPmqmSmzVe8C7Xp/3uIF6pTQ?=
 =?us-ascii?Q?yotd1A6Vjbz0uWA9Sp5o/s+T?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964d61e5-2ee0-4d48-ffc5-08d90bd1d4db
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:49.8213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMNCtDA00uYED2j6RkxUAH09Gn/sVX0oJfFyT0N5l3GP9v+bVY4f5xAB2crSmK45mEaaQyQvMTjBU3ys+439ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of GHCB specification introduced advertisement of a features
that are supported by the hypervisor. Define the GHCB MSR protocol and NAE
for the hypervisor feature request and query the feature during the GHCB
protocol negotitation. See the GHCB specification for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h | 17 +++++++++++++++++
 arch/x86/include/uapi/asm/svm.h   |  2 ++
 arch/x86/kernel/sev-shared.c      | 24 ++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 9f1b66090a4c..8142e247d8da 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -51,6 +51,22 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	0xfffffffffffff
 
+/* GHCB Hypervisor Feature Request */
+#define GHCB_MSR_HV_FEATURES_REQ	0x080
+#define GHCB_MSR_HV_FEATURES_RESP	0x081
+#define GHCB_MSR_HV_FEATURES_POS	12
+#define GHCB_MSR_HV_FEATURES_MASK	0xfffffffffffffUL
+#define GHCB_MSR_HV_FEATURES_RESP_VAL(v)	\
+	(((v) >> GHCB_MSR_HV_FEATURES_POS) & GHCB_MSR_HV_FEATURES_MASK)
+
+#define GHCB_HV_FEATURES_SNP		BIT_ULL(0)
+#define GHCB_HV_FEATURES_SNP_AP_CREATION			\
+		(BIT_ULL(1) | GHCB_HV_FEATURES_SNP)
+#define GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION		\
+		(BIT_ULL(2) | GHCB_HV_FEATURES_SNP_AP_CREATION)
+#define GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION_TIMER		\
+		(BIT_ULL(3) | GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION)
+
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
 #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
@@ -62,6 +78,7 @@
 
 #define GHCB_SEV_ES_REASON_GENERAL_REQUEST	0
 #define GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED	1
+#define GHCB_SEV_ES_REASON_SNP_UNSUPPORTED	2
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 554f75fe013c..7fbc311e2de1 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -108,6 +108,7 @@
 #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
 #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
 #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
+#define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 #define SVM_EXIT_ERR           -1
@@ -215,6 +216,7 @@
 	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
 	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
 	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
+	{ SVM_VMGEXIT_HYPERVISOR_FEATURES,	"vmgexit_hypervisor_feature" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
 
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 48a47540b85f..874f911837db 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -20,6 +20,7 @@
  * out when the .bss section is later cleared.
  */
 static u16 ghcb_version __section(".data") = 0;
+static u64 hv_features __section(".data") = 0;
 
 static bool __init sev_es_check_cpu_features(void)
 {
@@ -49,6 +50,26 @@ static void __noreturn sev_es_terminate(unsigned int reason)
 		asm volatile("hlt\n" : : : "memory");
 }
 
+static bool ghcb_get_hv_features(void)
+{
+	u64 val;
+
+	/* The hypervisor features are available from version 2 onward. */
+	if (ghcb_version < 2)
+		return true;
+
+	sev_es_wr_ghcb_msr(GHCB_MSR_HV_FEATURES_REQ);
+	VMGEXIT();
+
+	val = sev_es_rd_ghcb_msr();
+	if (GHCB_RESP_CODE(val) != GHCB_MSR_HV_FEATURES_RESP)
+		return false;
+
+	hv_features = GHCB_MSR_HV_FEATURES_RESP_VAL(val);
+
+	return true;
+}
+
 static bool sev_es_negotiate_protocol(void)
 {
 	u64 val;
@@ -67,6 +88,9 @@ static bool sev_es_negotiate_protocol(void)
 
 	ghcb_version = min_t(size_t, GHCB_MSR_PROTO_MAX(val), GHCB_PROTOCOL_MAX);
 
+	if (!ghcb_get_hv_features())
+		return false;
+
 	return true;
 }
 
-- 
2.17.1

