Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EFC398C05
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhFBOOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:14:04 -0400
Received: from mail-dm3nam07on2077.outbound.protection.outlook.com ([40.107.95.77]:45953
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230204AbhFBONe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzKrpe5TwxP4JQFyBdcBGGvDvsIoYvalSN7uOgfv5XYzeCau+cX3t86HvSoAcO3vI/nQfCMBSR22VZL85/jT5EDDQ7VuJWV3sXDHM+XfslmpFUpcdI+Wi/1bCzSmEvxYi7D2ed3onKd6J8Sg31ClLMnPHOFkZ42VwjLJUGI7QYnqf5Q45ZFol4kOkfBgFk1i+kkAYoOJERosnir1sDnd6sm2npeO5AN4fQyekXRPHt+uq8y1hHQoInMwjaIJc56L5Wr6kXBWowPlWu8MP1dURg+LQL8ZGpvD5MK38LmNwl0l0S4fxYa1TifcsRt/XnEM43/UPG5FHbhWX+I1O8bDAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vA9Y7FTLsl3X3KXsPSydxPwo+ZSKbBDJMa3NZmmwxmI=;
 b=kwCY2Km1qEOpqGmLAySR+S0N5EZWD6CfN4XN6jmWs0g75ytdnZgtpbtaYkhI0fT3e/bMAxb83YUDU3Wyu6jWPPh23AAUiafLqeZQd+By3wHqPLo2Q5iEl7e+Y2QnSN3qmRQuARdr+ZtiUVav2P79stQBKcLNB+J3IGasXau1/OwAfzZ33bzFD84GUKdayxY3kTtzkPEVCJSyw4XRVPUNG829yCW933T4Q3j6Lgj1nox2H/y6LXRMeCtrO+R/sJSAYF7Lv17qenFLfy10BUycX6fK56Ncz49oIUxkwkkOENh+QGzZM414H4M2T9lAGLwz3i7rYK1VFiFZ9Q6Eh1AD2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vA9Y7FTLsl3X3KXsPSydxPwo+ZSKbBDJMa3NZmmwxmI=;
 b=2GouCPbDU5yVrZUytDaADmGSJOcD6v00kCxjh5zLr+EIg+lDZNe5kcNGIVV+7mkQOuo2hG5xOOOK4VEHiFQGjV1NFj7fygCfoPHM7y3M6D8Ni67qDSjGWCjQxkrUW4TqubqDrzc4jsXZbEjQOhq/2GzhI3q18U7y7eCca6Y1lpA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:30 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:30 +0000
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 01/37] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Wed,  2 Jun 2021 09:10:21 -0500
Message-Id: <20210602141057.27107-2-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47b0fc7a-3848-4e22-0bbc-08d925d0516f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495E47B235D26DF3D682650E53D9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAdQCQYuW9bo+ta1Dw6hsrXKWyk1kMhpx2riMl7lVsdWaAH9Oy6hG3QiGDZTHYJ8o6u08b5Sc1IqfqbDfdDN5ok3MQ/RLirldHAdsfa/EQ0rJma68aIM5JLDXAm2OLBneWdBkukTNP1hDLwE8AI7MuEvBvAx+QZkF4zZ5a1qs930uxUuwW77vIhLVIWZZJ3h6R0kJYm5mSo8mH7CB3UY3ZGkeKk9BlGWeD1eFGSnOSQlNiycAxHJQxlum/hu0HxPZo9FB+meGNNUGv7ejQ8ZLRIsUOAGe3rvZMSBhADVUeWugIyzkKg46MJzFPlpONfNIWA5cpZQXBXZVe0+hJU4CHVXYo1/h+tLBWoPejo2n4Xiv60AjoyJoa1SLBFN4vBxuClYaP1WIGb2LyVhiygjes8VSjha8lXmYZ6RSup34kQKbjC+Lf/rmKTHM+vyZZDs2NEvcTwPQogQehKz/XTrnvbxWgT5qxIRhbb34CE/+/oz9zN8KB3JL1kepSbE6Wru3qklUSCeRA7Ns02Wn8SBGMOI9sxSp5JbczMtOXLg+P96oGwSxlBhTjq730csNcX6clN5mJTYRQkr7kb6qprAfztDOE5SCePw4FsUdRe1E32Zm6hqMQ4Pm0kEdKkIVO9eRY8NGo4D77EZ4Ct5zZgPUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(54906003)(44832011)(8676002)(2616005)(956004)(478600001)(6486002)(316002)(86362001)(4326008)(7416002)(6666004)(38100700002)(7696005)(38350700002)(52116002)(16526019)(26005)(186003)(2906002)(5660300002)(66946007)(8936002)(83380400001)(36756003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VOC/OmfkogO4b/NPmeECsMq6EP7hA04zC14KYZc6jaRwrAMfUQYyS3y9DyYk?=
 =?us-ascii?Q?gGcy/abwkDD3jJ6Zy6+aVnQJvVs9Ky9QDbjrNUtfcqJi6R5hqtb7tBG3Dsxt?=
 =?us-ascii?Q?DHIkOx1Efh+exn7+2qmHyMss8J0KEKB+y5pwEqqljEEpNdfuKkvrUoJf+5IJ?=
 =?us-ascii?Q?+i1Smoj2kf9FOribUAxLGeBJjfKJGFIaUGfQ8BBQzVtYe7NvD+rDm4lJZqee?=
 =?us-ascii?Q?CMU0Zf+TNYqQPSnGekjmhL2xVvLLYbhf7sMm/e4xlDyJ/E4sw8A/qXwuowsy?=
 =?us-ascii?Q?+V0oaFCEfOI9M0ZRgWo2Jv1rxACuEaY+2ilp4piZV5ZBf1dy7Wk5cpusm+/a?=
 =?us-ascii?Q?WEKW4ypjLXPD6Yc/cjq+bCxPBVy+yKipstHIb8vONA3bHUwvAKBChjTNCA07?=
 =?us-ascii?Q?txIylLouVdIV23hjFho/iLWVmuCquBn1wwUJsTeSlWWmHkYvLmv9ErP85FQJ?=
 =?us-ascii?Q?pfKk1AiA4f0JbTdwZ3jVz7jWhfeOj1z/tKawvWgieLUzl4NZXgE3gtZPWNPj?=
 =?us-ascii?Q?PSQzh5EfzwpyDFiJigy451s1sssSVGcvHiyS/Yi4nov+6pTlPv9YWP/w3Mj7?=
 =?us-ascii?Q?j3BTofYrqcPzZIqphwZYMMq22m1scOns501WXEPmuKK08rPoG+fQTo+uXoVU?=
 =?us-ascii?Q?Fe/pHf8GeesBEYXKDF4WXQGCV2S94RKhZEZpO3BU3rPBsesxpXf3gPg0sDXL?=
 =?us-ascii?Q?QAK36f8wcwQ1tU9WSVbtSjnxUAAbvPWmf1K+6TTeIzjgUZfwXOJlNCpMOQZB?=
 =?us-ascii?Q?kspvkiMZAa6UKXwBBwlxGNlOVdMyVilxeVnIyfzIK4FYUfDiZN59vpnTz5R/?=
 =?us-ascii?Q?cq4edXoIVr7xMXWmPPj7pV5wavxboOMJkRCcKSyjT7fe5PFx/Tek/7DXaZYs?=
 =?us-ascii?Q?I1WSUjXKu7v8ba5lO5ufVdsw9VPmkbSC4IbWtefwtGWWqaEitcVpybK/umKT?=
 =?us-ascii?Q?9N3qPhUQmo9/fJM63Wy4NlPynWY9nRLoUzKiQM/JHl5ToZiE543Ml+Rh770V?=
 =?us-ascii?Q?oBAi+8cBl8TRf6IPgoB7Ltjf7WMdqXxDcv6S+Z8jSWPalCVy2+0FtBsZJ0dD?=
 =?us-ascii?Q?edVsHdyXYl/RGYiOrNtB0p9IrO0fAY56vXzda1Vc1GBjshtblW5XB3qGTMWb?=
 =?us-ascii?Q?c23TJEs2A3mCPPk5KH29I2UGq+aMHdqlT9MnTLUDizYmdlke/yh+DLyLYIi2?=
 =?us-ascii?Q?jho1mTxMoE+hTx+CYg3KBrt6SawTcp8RzH/7mMMDS8mRbsbGA9mFSlZ+sThR?=
 =?us-ascii?Q?QNGDzjzATQdpTTnwIwi40ZAO7dtYLc6bI+vnskRijyx4J5M2YUOeaIZHZhDH?=
 =?us-ascii?Q?c4MIRtphpPpyaHHy7ri9ohTu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b0fc7a-3848-4e22-0bbc-08d925d0516f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:30.0972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1Wfg8N+dm3UZe6n+jcIv3kRDM7hgWmaNaK014CFhnCE/NDd1yJLN3cjxhWRVt1G9MDOVISHyw3lAuHlnUNCwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |  6 ++++
 arch/x86/kvm/svm/sev.c            | 56 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.h            |  1 +
 3 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 47aa57bf654a..97137f1a567b 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -45,6 +45,12 @@
 		(((unsigned long)reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS) | \
 		(((unsigned long)fn) << GHCB_MSR_CPUID_FUNC_POS))
 
+/* AP Reset Hold */
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
+#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
+
 /* GHCB Hypervisor Feature Request */
 #define GHCB_MSR_HV_FT_REQ	0x080
 #define GHCB_MSR_HV_FT_RESP	0x081
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d93a1c368b61..7d0b98dbe523 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -57,6 +57,10 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+#define AP_RESET_HOLD_NONE		0
+#define AP_RESET_HOLD_NAE_EVENT		1
+#define AP_RESET_HOLD_MSR_PROTO		2
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2199,6 +2203,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->ghcb)
 		return;
 
@@ -2404,6 +2411,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -2491,6 +2514,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -2628,13 +2652,29 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
index 0b89aee51b74..ad12ca26b2d8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -174,6 +174,7 @@ struct vcpu_svm {
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
 	bool received_first_sipi;
+	unsigned int ap_reset_hold_type;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
-- 
2.17.1

