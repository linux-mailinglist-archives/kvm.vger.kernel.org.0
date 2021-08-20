Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E85C3F30BF
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbhHTQEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:01 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:42784
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232622AbhHTQCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQG5HK5vJo/hz7s++BX7T6i6uBnLgLkx/IR/Z7ozJolfzoMuFxisGv0VWoIxbvFtIIQsyzZysETCcXnrwwirPqF+cTn5BIpJAIbejC0Q3YGuxdS0iyM1fr3VIBmmbsYk70gRoax1te97fOi5jrylUPduYa6nCtF9vGfm2Yhq8WTLGB+O5PDcqEnYaUSVoFebz9IaK1+4bN4bNgpmEKPiM0YFle0SL0GXZxWyVEvbfwP27/wO4tLxSa+dhiDxblv6XdQOjDk9meSk6PYGg7VR4ZbbfyLryi+2kjOwjiuRExZU6oyHD5Q+RKCTeXK5ZL0ssOSlYtKI8Pr6tLjzUQ6GRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fdd2TDJlrrGVf/MpQ4O8wx2GWeP+/z1Qw8sLPALjGpY=;
 b=eVY3Fps5pLDQcqPF9qx7HF6OfE0U/OYCJWVLc2iFSUYDC4tAsUGxbgoX2kuirWV4AyoqnzstNekRD7US4UZAACmTAmzMd6d+FGNRevKJw4zet0qqOeFRS6AMH8Gl+vfDFPGJaOkkl0/7TnprZXPgfqmHLxD0+aH5RbViGg7YAjYUCRaKPhB32xvwnUd6uJ7c1bw0EIInO13+NG1PmEfRqjsg1iRCGS+N2PQc6AEpq86OaBE0pJJexcNFtUWwoSTRPV+SjXLsFNqwBuswGKiHHuxBbf7m5Fwnh21enZeHp5WuKySjAE+gqqkxBC/sfu+R3796UrYTm8nXMcGhI7l74A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fdd2TDJlrrGVf/MpQ4O8wx2GWeP+/z1Qw8sLPALjGpY=;
 b=lmMEEuOb4iCDwsgTqOb+2VSC2IJVejxGycQFwUnrIlMWwNIAwOzjCPQNN1zRcn7QUV37PDThViBxuG1zjUCN+BaPX5OB7wh4vLnqMMWDP3oBWDLVcIsr9/fqXg7RoYTk5f8Q8xQkEV1vVpRC9D0VxZpnfAAMSAB/O8UXx2VBe5I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:18 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:18 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 19/45] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Fri, 20 Aug 2021 10:58:52 -0500
Message-Id: <20210820155918.7518-20-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 757d54a3-7da1-4b45-6f77-08d963f39b61
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2685E7C481A71748D07D5FECE5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjbw5IK5uM3esxFr/xxHR03hZtMkSD7vVNELm9kB9rtStMmy5eeFKVR7WRGUoika3I0eOaCP4rg4RnfZd09LBEyW7OvqRyDz7OrzaONG9RmyH5RiJEcaQLM6EBLCgqvFqcKx21pGNmtSX3aAAWh1a6ZPoA3SadcrKTiAx2ejNiMoixU/BCzpiC8NgYDF6cqWevTR5bQayxOkeH4rYWO+UkZDfs8eZGS+1p3mt5JZIwQNxaVMtYoZM/HmMfjkUValM89ZYiMT6wbQJvXoxu2DGCWgLF9LR3XN8ClMu7yuezucJKjpddNu3Y7fBzqRYHOlvyjWBBiC73R8parv46mHFpW2pD/dSisyfZdOvpvU6/A2O9gmG3FGqNz0tKutMsRW+Pcobn30s0KGdp9ewSdoL3YTIuu0UVBm2ltqvE5DhzJDx8nvUw+EOj1FtX2aFMFQLkzcaQ9y2yQTtnjFI03AwcnWE2bwDqhOYYLJ8+rsvAROlWzZWJ09qgYveBaLmP8jDcPnuV1ej4a++ZtpLYheKLN7cqng2Ag1xL/NbWoxexsB3SF7WZ+vlMPkwA/4sHUGni/X8IqN0JRvodBjTz9rSgNTOdGGVLsUm61sO0vFC+yxkhoHxL1AoenVW5Ca+EmWCTLpxqrFlgC1UevU1IDaAV2SeGxtZ/w+mCOkJdjXIsyxOPRzOYohsucVLvafXglVc521gjJu0V95fxnUzZbVAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(83380400001)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sa5QY3JG6HjzlvAjlNrL/dqrK3jrsAXJBrOmf5c0l4ZO2QLPjep25yixqvOW?=
 =?us-ascii?Q?CYz3D3EpbpYSb9r/P5IGysL437jvPX2MRS7sAZCZg/TbyB2DauNBJxrk6/JQ?=
 =?us-ascii?Q?BLNXzLXMqvPRB0jPsE22JAx+yYIeTW6Suw9jzBSKSZjflezwE/tk/Pi6gS5B?=
 =?us-ascii?Q?6jwj+pYviVyjgBFX7RRTXRyoLstQNB4gnZ/2LBokLXzcU6hl1SsbFsSzb4V6?=
 =?us-ascii?Q?R4PIYoN8uta8yJAcKZnn2JJsqYyGaAe6FXdrVzOWy6F1jgCmDiz7ZyxjtXO3?=
 =?us-ascii?Q?MD9qrOMcVfW+YEHYmBspLQbhISpIY/hLfy/l9Jamnh94Ox25NHIm9CZiVvg3?=
 =?us-ascii?Q?GKL8fLa/9m0tHN/V7zzka5s8f7BUlpec9Rk8yCMnxiwOK60Y7SfAYEHlwsLy?=
 =?us-ascii?Q?cC4OVq4iXdBvmQ8J2MzEuOw6LVVxRYsI/EERR+iv3dgIGC/c7VUO/mfsJqdz?=
 =?us-ascii?Q?9NnZzKtlpRm/1AwJOdkRUAZ1T3sBY1RIygllr3Xw0OJH9lFJD+XYzDex9sWm?=
 =?us-ascii?Q?nk14BYEesnFBJ5tm9U2seWiKoRjpSuRt3mD7d0dCwfg+VNmcRqnyPsRjk5kM?=
 =?us-ascii?Q?UhrQFYR1xucjAA5Vj19wh6v733IV+u9JAdyfDJbiRxjukC2WElypohA2hxU1?=
 =?us-ascii?Q?r0WdRcWJwnJAKQTq2NVIypOPM5UZjZ7xcy5oTg3pWSGepcjXu4EMRjPj0HEo?=
 =?us-ascii?Q?03QnprgHCMs5iYdYE7L0BiNV4bSJtstbQYy+7+1AhX9TZb1ifGzPZ4XTBNMf?=
 =?us-ascii?Q?YT9hG3ZXZ4p8JgPPxNtpRcU7jMBIk6qsLdMn6fsYJ+kc2dh16kK1jrXxgOn/?=
 =?us-ascii?Q?qzM6FIAqBm26JXBxZqWo4PQyB1qUbfCcfTwsXVVzCuB63cgm5o21aMlpJk6c?=
 =?us-ascii?Q?4HEf8Ts3h5Ew7rVmSjUAQV3PpzZ1WFpELxFM4ql7T7M8y8TdyV9DK7ezcsn/?=
 =?us-ascii?Q?9AVEWPYlLMzYJTXXs8A2ST21yCbIg8AG+V7lYzum2TSbsZvh/HP2TL0yir3e?=
 =?us-ascii?Q?TqZ1Ner9jI3WfdNmDpo8R44YvpHlBypC8qA2ZILygD9QFcrjVOjLTMkSSERU?=
 =?us-ascii?Q?arMXFWkNgx2ZcnSH8XAJpHCKtBxJQ+U7ZOS4dizZNiyx1gkSPVpsAPWdx3No?=
 =?us-ascii?Q?nOfZmU9WsmXbPeNXff6mJT6jMFl9SCcr4DVHxWnJ+TeL6jCmy3zffzi+hyOd?=
 =?us-ascii?Q?9TJJkmYVNsmVPH6OJroHQb67xMDTTWTK0sfhbxxH1b9EKxYhVoaTYl8IWCcd?=
 =?us-ascii?Q?tWB0GG3I2Ts3AXmqhhPd9g2yJARmyUocDCVbcVIhNbMQgnNjMt8C2+ivH9VS?=
 =?us-ascii?Q?4yiQay8i3PCq+V9eJHD2+7Wu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 757d54a3-7da1-4b45-6f77-08d963f39b61
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:18.6271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PD7hZA4QbXVPAR1TUayaVkOsGZ/EBxdCXt/EZOIeMAt9a15/mJZHClU95qsJtk78qmjnmy8DxZKNVAUNFHfQbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 56 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h            |  1 +
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 5f134c172dbf..d70a19000953 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -56,6 +56,8 @@
 /* AP Reset Hold */
 #define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
 #define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6ce9bafe768c..0ca5b5b9aeef 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -58,6 +58,10 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2210,6 +2214,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->ghcb)
 		return;
 
@@ -2415,6 +2422,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_AP_RESET_HOLD_REQ:
+		svm->ap_reset_hold_type = AP_RESET_HOLD_MSR_PROTO;
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
+
+		/*
+		 * Preset the result to a non-SIPI return and then only set
+		 * the result to non-zero when delivering a SIPI.
+		 */
+		set_ghcb_msr_bits(svm, 0,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2502,6 +2525,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -2639,13 +2663,29 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		return;
 	}
 
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->ghcb)
-		return;
+	/* Subsequent SIPI */
+	switch (svm->ap_reset_hold_type) {
+	case AP_RESET_HOLD_NAE_EVENT:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
+		 */
+		ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+		break;
+	case AP_RESET_HOLD_MSR_PROTO:
+		/*
+		 * Return from an AP Reset Hold VMGEXIT, where the guest will
+		 * set the CS and RIP. Set GHCB data field to a non-zero value.
+		 */
+		set_ghcb_msr_bits(svm, 1,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
+				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);
 
-	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+		set_ghcb_msr_bits(svm, GHCB_MSR_AP_RESET_HOLD_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	default:
+		break;
+	}
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8f4cdb98d8ee..5b8d9dec8028 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -188,6 +188,7 @@ struct vcpu_svm {
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
-- 
2.17.1

