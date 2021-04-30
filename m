Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E5E36F9E2
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhD3MRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:17:53 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:57920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232064AbhD3MRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4G/5p42BgsRK17F6NhkAdwRH+fGMFmdc5xZhD4mgHZgNzx/u4wO/ljtKA5rXj8JS1Qr+J1KgRsCV5voHGKjWI+a9lNWqAjuUST6PZXZkQXHgNnQ7kcAOs2jQHPymVBPOCaOIaksl/1vsTjyyf4C4jgN7ea+YaAwQY5RkZZPRAJvXKL+rsEtoJpVQC/LDOpNbvZ1StdcaibXMnLgjpcA8VAeDdpu+FYAMC5T2gqhazw4tKrp+u6Bk2e9bFlx4ylmpWqy6JY0S3Xv1qRPzzGIhvglkTq16rPX2/2GHyWnY0wAExCUvo0rLnwDtpgweeNphPAV9wdROG1Piwif+QD04A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OmfjwVMLeR65cgmjDS1noCicu5Ts3m77stPDdhBDwFM=;
 b=fNZT5n8zs8nzzbe0XPnXV+4EB9ruu0g3OjhrMWuO0kit0b6vcgYBC1Hkf6mTkijg9mHzYm0knglbOhzflhMx8EReT1phizbPVzo1PnI0x4hQ2UobzY6FxtJl23ZzGBrSkkEq3neBBaLimlCj5PK7Yccswk1zjGr3LSGVn09MiGAyittr3HZuNy+7OadwelG7Bhz0t50/LeFCjUW5t6cdrBpv4rYiDQsnmjEimgG/tu6JEz9ttWT5bA1vUqxZ+NZu+B0hqpAsKntf4oS+49lTGMlhbL1vV88KUDiD8c1BnMGQgaiI4AWKiPNm+tq1kyDWUBpBAdSWBI5barqe9o5FAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OmfjwVMLeR65cgmjDS1noCicu5Ts3m77stPDdhBDwFM=;
 b=XBYtPE0V9GTFphqTsbab6U01pksSYlb1UJ518Yi7+dpzxNRKMxibuO8t75W2k6fbThEXDTR2pRmRZhk+fozkX1zdxDXF/gJunpKKCR52od8m5NffHCsymnvMge8GyZ99ecjcd83SoBw16SjSFGkYoYpHI8sx5lhhx3NovpY0+c0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:16:53 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:16:52 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 05/20] x86/sev: Define SNP Page State Change VMGEXIT structure
Date:   Fri, 30 Apr 2021 07:16:01 -0500
Message-Id: <20210430121616.2295-6-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff48fc70-000f-469c-0f37-08d90bd1d5af
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4431F6BD3E0FB9F9C3608940E55E9@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNd4u5pKkwNJUswgNgMB2yrRH/Ke+BPYcE+hSXYwZOIS4TPm1rBMn9ig/lAHbZh6E3mE3jQlFYkOofAXuky6NQUEdE5HXlsHvRiYlN504unwxQY87sjHW8FcdcsTpy8BynRbrHaaCErbk84XnAJ6leIaLprGraKtt0NArOxqQJLO8qGpiV74diuGnTn6GcmRoF+PnWUBoSjkpGzO/pYFmRP3TaUZ6fy50DUn6tU3q15hb1KgG6m+qYwax4JrWeSJ0VeTaDwqyVXTPpBvSpKXrZsjgiwrXZVKkGIwwZ7wP/IQT8A1WLsBUIj41QfsEFJfvPF+Yaldm9szSilTvyZbx2N2Ozu4lyQ6eHqI1V4Inw2JjZ1j09R+pmaojasYwV7Eq2wCz5uikDNtXq+CTghdDZgymQGOpbAUq0/7i6v5xlTAz3OAZQa3I/5TG+1/IcooqO8+0oQAHXSs/JaWAwM+ipCJSzblRTRpP05cONIbkmNryeXpzSh07YRoZ6vMTKuB0YfPOmEvIqpheevbRsoYTozersDc3zTC0VIm83G8U4TPgYu5lNrwzWG/kAxiyoMi03LA2QLzZWP5EjcXTOLKCu27TvwL90fTxo3rQNTQorH+9qlYF6PopLiblFZr0ZhaXi3ryZR7/5R+RRgP9rF6Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6666004)(2906002)(38100700002)(8936002)(316002)(5660300002)(38350700002)(478600001)(1076003)(16526019)(26005)(7696005)(7416002)(186003)(8676002)(52116002)(4326008)(36756003)(956004)(6486002)(2616005)(66946007)(66476007)(66556008)(86362001)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LbaoRTx6y1X3p53uJohRTsroFrnwCXn3zr1ShhwOHrsXLJw6zsFDk+ADLJfp?=
 =?us-ascii?Q?3E8MHJxWcgxzdjqcGlE9BE7olfhNwinINWKdOGbT/09ZtvKF+MI8Lfw+D5gp?=
 =?us-ascii?Q?vw7+8JNh4VfDC8nQdHEHcybtBT0kzB2H2pLbf63+MVf8ctwGLQ/wJU0VlEVO?=
 =?us-ascii?Q?kGddv39/KjXDqk5zbhPLPxmb8mf/bNb+NHpMYOcERzkz8w3rZUJ01JQhoUvQ?=
 =?us-ascii?Q?m6qvPue1hhPRCKTni99D05zEVm/MI/LpUtjXHITWZO7g5fg5g+7vAoNxtRqq?=
 =?us-ascii?Q?i/gA3mIfnjwunm4QN9XbKt3KmPb+YtWsC54eeiKXocdquJmvUvt6zgtxbIz1?=
 =?us-ascii?Q?rORVLta7n5sbF7XwgBm02Z5yZv8xlW268d1V04w4oe2GJw+cXS9CBab7MOCf?=
 =?us-ascii?Q?KKOJrJnE2ynz42kQT0iwND3N4xgUUaY9lKkwV4+D8FaDUeNKuCVW9j+YP8+7?=
 =?us-ascii?Q?+1KgbI5zvKYSjoHQjUhJ0DAw/kPwqCRtExU11CvWRP8aYZGPJc5AlgcbB0kd?=
 =?us-ascii?Q?OVw9g3BEpSFUfPOs3JcXqcIyez6Lu/qL2tI6dEAXgevN6olzW0Vlihh+OTPJ?=
 =?us-ascii?Q?VG6F/d4wanSNZGMxNju4G+tLChW7DtjPkqiiKeE7B88rDdLVBy3qYxOsDYmZ?=
 =?us-ascii?Q?qBEJA3G4SU22+87IutHG80w/p7r803hRy3vS4jQlaj/0HCJiScn8caYaY3fK?=
 =?us-ascii?Q?mStgmDjtK2GOqMhjumVXp5uJdvNg0xKLpnteswFXuB6nmBbgGxIKOMDPxz6V?=
 =?us-ascii?Q?hw0tZvSySk2ncLR+GKoiOLYs1dwa2vVRx6o91e4j0lJViC6IjVenTGW2K4GB?=
 =?us-ascii?Q?RelejtugTQ5zbTwCrDw2+lik65W/CBrTZK+rsXgcCk/YNI26fUGeq/EZFCb1?=
 =?us-ascii?Q?gx6d8ueisVVfZXcRgWAERLBf3UtN9ybCdiTPgrF6W13A+CmPkS/QBEg2bUTW?=
 =?us-ascii?Q?P5rP5TfNxhOvK0Dd/bC2KlYhlXX9G0lFRV56bGhLv1xbQG55gvfGCnIgwzhL?=
 =?us-ascii?Q?XjtFqTIZ0DkwLTIbyrv+TXDVDmHThnzv90Bi59pg5zIE1OoAs7ieYFMykyQm?=
 =?us-ascii?Q?io6UMNvuHhaBiRca2ewWIhw5qymS2hCmg9f7jOwlXJRVCCBMAQN5f+Z6iJog?=
 =?us-ascii?Q?ZBFYKFJ2lclJDVWqGE6LaLsFwF3AOwc6U9BdMzBd8qfdwUMIpoWkPLQt6sjK?=
 =?us-ascii?Q?RrCCxFHvup9sbRSP9ks7B161git8DM96SeqWaH+kOJyoobVCC+YuUxkE369X?=
 =?us-ascii?Q?JG2qAMYTbuS2+EdtCoWiXKcHghulYTsIwQRqg0QcX32I3gTGyKVv17f7/DSp?=
 =?us-ascii?Q?yZEByPvrmUkaVNsVfWcLH5e8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff48fc70-000f-469c-0f37-08d90bd1d5af
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:51.2025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYAzUulY8SHDILUtURjM458Bc2LszF0/S6j06gCOMgDEbnABkbDLTpY2L3PDWnwM1kWZm6Jp8TX2RVRG1JuvWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An SNP-active guest will use the page state change NAE VMGEXIT defined in
the GHCB specification to ask the hypervisor to make the guest page
private or shared in the RMP table. In addition to the private/shared,
the guest can also ask the hypervisor to split or combine multiple 4K
validated pages as a single 2M page or vice versa.

See GHCB specification section Page State Change for additional
information.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h | 46 +++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/svm.h   |  2 ++
 2 files changed, 48 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 8142e247d8da..07b8612bf182 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -67,6 +67,52 @@
 #define GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION_TIMER		\
 		(BIT_ULL(3) | GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION)
 
+/* SNP Page State Change */
+#define GHCB_MSR_PSC_REQ		0x014
+#define SNP_PAGE_STATE_PRIVATE		1
+#define SNP_PAGE_STATE_SHARED		2
+#define SNP_PAGE_STATE_PSMASH		3
+#define SNP_PAGE_STATE_UNSMASH		4
+#define GHCB_MSR_PSC_GFN_POS		12
+#define GHCB_MSR_PSC_GFN_MASK		0xffffffffffULL
+#define GHCB_MSR_PSC_OP_POS		52
+#define GHCB_MSR_PSC_OP_MASK		0xf
+#define GHCB_MSR_PSC_REQ_GFN(gfn, op) 	\
+	(((unsigned long)((op) & GHCB_MSR_PSC_OP_MASK) << GHCB_MSR_PSC_OP_POS) | \
+	(((gfn) << GHCB_MSR_PSC_GFN_POS) & GHCB_MSR_PSC_GFN_MASK) | GHCB_MSR_PSC_REQ)
+
+#define GHCB_MSR_PSC_RESP		0x015
+#define GHCB_MSR_PSC_ERROR_POS		32
+#define GHCB_MSR_PSC_ERROR_MASK		0xffffffffULL
+#define GHCB_MSR_PSC_RSVD_POS		12
+#define GHCB_MSR_PSC_RSVD_MASK		0xfffffULL
+#define GHCB_MSR_PSC_RESP_VAL(val)	((val) >> GHCB_MSR_PSC_ERROR_POS)
+
+/* SNP Page State Change NAE event */
+#define VMGEXIT_PSC_MAX_ENTRY		253
+#define VMGEXIT_PSC_INVALID_HEADER	0x100000001
+#define VMGEXIT_PSC_INVALID_ENTRY	0x100000002
+#define VMGEXIT_PSC_FIRMWARE_ERROR(x)	((x & 0xffffffffULL) | 0x200000000)
+
+struct __packed snp_page_state_header {
+	u16 cur_entry;
+	u16 end_entry;
+	u32 reserved;
+};
+
+struct __packed snp_page_state_entry {
+	u64 cur_page:12;
+	u64 gfn:40;
+	u64 operation:4;
+	u64 pagesize:1;
+	u64 reserved:7;
+};
+
+struct __packed snp_page_state_change {
+	struct snp_page_state_header header;
+	struct snp_page_state_entry entry[VMGEXIT_PSC_MAX_ENTRY];
+};
+
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
 #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 7fbc311e2de1..f7bf12cad58c 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -108,6 +108,7 @@
 #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
 #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
 #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
+#define SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE	0x80000010
 #define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
@@ -216,6 +217,7 @@
 	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
 	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
 	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
+	{ SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE,	"vmgexit_page_state_change" }, \
 	{ SVM_VMGEXIT_HYPERVISOR_FEATURES,	"vmgexit_hypervisor_feature" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
-- 
2.17.1

