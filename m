Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EB136FA75
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhD3Mjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:39:45 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:15105
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231696AbhD3Mjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbC6fntHx8WQrOFfS1oMo9M9Cv3ofqWnUxw5sYQZSpHAUNpzDPTZ3IXGpJ8C4FJQseoybP/QmbFGrGS6ALx4e27UBrheuAhkjrkXuAzDarNXbBUBGxPBO6yxB/yOncuKD2E7M88/MRSELUgQIOQ0ZJy7RvSZNmt4xAFa3OvfhAfp+a9i3lu+NmT1BMbxkToGuMfCRaykPudHJU9X/oN3zwjm6g3YfzpC+0Iud5QE/bh2XwATW1oo+nwkP1304shEWm+Bvf2KXXr46R4l1eVhiWuO6wdkVUdJAT4Kxm13Sb55g9f7uUbUDRCPQzTeWj7fvi9PFLWYgwK3hjw3pATROA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMI48TF+FLivggMVMqIDTa5FlClU/ZB2/9LsP4EYhxc=;
 b=OfXt4B5SxIEqHEw0Z/A14rik2ywsF0qD0XcK7EoOaccNljSpB6knGLzK5/ARjk5i7unoNdOy9s8OtKMONW2pf/EViDc7zDTJn+PP7eSzI31kA5s8h5dev0hQKN/wM+rLZlDE4k4yRqZGXg99dmtKwfCCoyZP8SRgyurhKg9kbY1feVzb/pfNnEZKKD8OylG6B4dlv49pr+JDGUC2mj1w5GxEFCFoC0mJajKflcToMbmZp5RoU3Vuvm3+BimiB9HLwgIjD92xeA68KBx99trfr0KCjQg2FYaejtsn0+J4WSK5kZA8Jjwk96zjlxErwH9BANTOZEM9+njx6oXATmpmyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMI48TF+FLivggMVMqIDTa5FlClU/ZB2/9LsP4EYhxc=;
 b=ECVHdf0YyS4zXgsAP3XCPmRux3CASTYNQgRhemI5GRA6rnxcxN3ieUNYLihWaYaZ9HTe9i2IUvSmXmStQGvN8RM/Jzeh/qC4sihmP1QfztEhKeEkGZ9nCEWJ5lKGFanIucIF1ovmkRKb396I8s0usUPltOiSM++HsxZcpwPx7y8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:38:54 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:54 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 01/37] KVM: SVM: Add support to handle AP reset MSR protocol
Date:   Fri, 30 Apr 2021 07:37:46 -0500
Message-Id: <20210430123822.13825-2-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:38:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52723c5b-bd6f-469e-6175-08d90bd4ea66
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45110BA51EC3A763128FD3A2E55E9@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKkMUu348hk2Kfqx/0HAwNE+gm0+pOa+BtmTXdLGT3JpGaN+ufQ0y8rLC7r8aNrUEpI+WDR/WKEqHgiY8ObLG2l8t8GlGtQYa71v7LGi5voIcDGKpleUtF7i/6igteQsRVjfznzYmX4QUBVMTSuh+w9qby8tTCny6DVTcsyuA1GIureRxhpNhnmTfUuyylpPqwuDEHQq2tSs5eiNfgJJxdi4dBzBPA2xtCm8RkyfFmpzu/tSdB8jOwjBFrPnDX5SAFhHdQPawPkqUGkGVwV/Ofl5bduoUUf7B/q0KBPxJlxt2vZsrsg7Xb+6uOjjRwsx0K85anttN1YyTNsR2I+hu571rhi8DQMkO9ghMbpzm2loBI54gNEWimi/SoIMSBMyTVAFAsVZI3WgdJTzdXUzyHMPuO0V97taUKq1Md6z+MeWWn7JBNfLw3xd5iSn9CTfqbDJr9NV1vKHAoWxg1wdMntec+CA1O0dUIOM0xthO9P/HD5g7TnpB8+0Y8F3JaYrBf0GprsswkFeyO39Zw1mB/gvQPer4nSEGhqhx5Y+fuxzThkLyqmPXfV0PVuCk7q3GXnRLR8W2w2VnNtaUx6Juq3/5DP31WlEYjpyZvQake2uKVaf7AEmZfrtBjYm5Mfj0gWqJkFAjom/grzgneU7dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(83380400001)(36756003)(8936002)(86362001)(66476007)(956004)(186003)(38350700002)(16526019)(6666004)(6486002)(44832011)(52116002)(5660300002)(38100700002)(7416002)(66556008)(2616005)(26005)(478600001)(4326008)(66946007)(316002)(2906002)(8676002)(7696005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QsxDGsIT6y2yu4v2fDHAPjEnFpKe2Wb7uh9FgMVh0NZnnYzPhM2nip6aWxqm?=
 =?us-ascii?Q?BkWwYE6hy5GFhkhsTVQurAHI9ikoBpZEsTCmoG2tpC1gJ2eNiXUhsfoZAStV?=
 =?us-ascii?Q?qVZgfoaIVutAxe2p2IxJmipz4mbYPOvBT0x0NqTzzHhcb1zvRtMTe7eIaa/g?=
 =?us-ascii?Q?ThZ9BPsut8P0+zgY+cpFzko9+el4ozLTKoJriyrpu+M4QonI9p6WHg+wO5D3?=
 =?us-ascii?Q?Ygt1+iGBGyH0nKV5PqLq88GhkCECfsfjHhmy1uxWYIHPHnGOl6wkRQcbVjHk?=
 =?us-ascii?Q?4aoWfZ7qujcdtf+M4F7EYTUWlENYyoYmBOsoxnmTK/8cYoCma1/DnloXuVO2?=
 =?us-ascii?Q?IGwjhxvarBjFgkzBTI7MZRSKCH9WeX8Wit1jXWMhT8cuDqM5X9IJUM36AEJl?=
 =?us-ascii?Q?/GI77HW0Xs4mr+uDVRKl4GvhQnK6td0XExB4HR8zrlbxbPEheBOWxRYN45+I?=
 =?us-ascii?Q?o4KPf+pcmQGqqg4IfXVk+5yuAcuE9e7lYL8+Z3fBmVo7mResDU0k1mdSwK67?=
 =?us-ascii?Q?Ut/FoG2XMdgnuU+/MTqCaxvpxMwwP2pCDZ70+TYnJKw7Voy3RcxwKDflumyL?=
 =?us-ascii?Q?j1P2sRZ0D+eAHRsB/luV6oGCWgBLu8MZjIdgFB1mHMcR/Teaa2lh0VIJQ7nH?=
 =?us-ascii?Q?foXb9PAnA+gcBnNbM6kY3tzp6Ix9tv9mb2yAdDBiRgnSwKeQAeUl+YvmoJAo?=
 =?us-ascii?Q?Bo3Mk36WiS2wkIEd+KfqeXWHcsF5qCoeeC/5MDfyIHldfFN/8lOuAiLVn0/m?=
 =?us-ascii?Q?Oy4QMvKNg9oFgn2hpEiEF5kzolZoX8BmlLzs7VMp2nKXTiH22IBdFaLCNSz8?=
 =?us-ascii?Q?btFMlcODXVa+f2Mmz6UP4oY2+0IN0PtLJGjM+AsY8er5QlQ3dHQtWqS2RLbr?=
 =?us-ascii?Q?YwQznRmnnfTKV1dAWTwqlKSN3fsbmtOUCekxBkm/zQDOhtA4aHMtybyXBW5I?=
 =?us-ascii?Q?n8/SjRxxHunLhIWIfymxbmTaBZBtqZioAqDXAZGSaMGcm2TcY5gkqbN7JQI3?=
 =?us-ascii?Q?FXLFl2d1ityEKgwItmUzhTXlMnY9nwe+D6vfQcgvjn4aqh/hcP5e7l/Syr24?=
 =?us-ascii?Q?e5JKFoLhQnbnBcR/vLkKnbR5WvfAsug+YgFd2HiG9SD+9LlvwS3bc5+RQjLR?=
 =?us-ascii?Q?Q5CAPHbZdxXQeEHrqL0d7F8Wxfl89Rhf1PZqdWpjhi9Ui9/dUlL8qmeyGKO5?=
 =?us-ascii?Q?SqxQZbiPBt2dR82Dol9yAvN42tRD15GNGFDKa4WjeJBP9Ei9DzPfhLZ3bYAC?=
 =?us-ascii?Q?MkMEOVoD3f0WRLLo7Dgwr0MIL/5e7BX3EMHbomfyzhP6l1GBK7J1Aio2JxoS?=
 =?us-ascii?Q?7/f88jsaI9CrDlewk/N/VtgW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52723c5b-bd6f-469e-6175-08d90bd4ea66
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:54.4785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqOh+R9Ma6e0o9qAVDj6v6ELY110rwcjXbnp0kOY6zuetzHctvzySumuPYMvn1xhXDEcjv3r1uUZQsccHBW2LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
available in version 2 of the GHCB specification.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 56 ++++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a9d8d6aafdb8..7bf4c2354a5a 100644
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
@@ -2200,6 +2204,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 static void pre_sev_es_run(struct vcpu_svm *svm)
 {
+	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
+	svm->ap_reset_hold_type = AP_RESET_HOLD_NONE;
+
 	if (!svm->ghcb)
 		return;
 
@@ -2408,6 +2415,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -2495,6 +2518,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->ap_reset_hold_type = AP_RESET_HOLD_NAE_EVENT;
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -2632,13 +2656,29 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
index 42f8a7b9048f..dad528d9f08f 100644
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

