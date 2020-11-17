Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4042B6B4A
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgKQRKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:10:32 -0500
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:30208
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728317AbgKQRKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:10:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TncMZ7/woMKQt6dBzN5bG2SdOZPI/8zY4ArIbNaDTvr0syZ+dhIopCB5SzPUTRMEIcF3hpAchhEPSQ4h4amwHxvpbi8snqaoBx4pg7zMR2nJ7BwVFfCRZUiJO3zgsSmqBikfFIxj4OKEu4UwS78OzXp5qyHudDpPYTvxqtrwgdKZQoNWP5wumgqZT80f2Mf/aJgV/xqacugFn24ky+uPB/zlDKk9XaAUx1hYjU19lWVfEnf+a8sh42CnqOMSM3m9NfPTtEsM4lSz+EkXPrZAWcXTuIQ0+5R5YKzCkviDnBnkMxFc5rftg56EiECA+CUtr32KBvNQgSArsq/c8Ce7hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRM8KxiyOg4f05n/z6YN1VjEvXdRbnmsOyCHqV6Y7FI=;
 b=LhieZeiktoJwnigimqAjh+5nCZsBT1NNkyDD+/TWh7drJrj0ARRjt3/67PBsmbKcuK2XIvmAbtkfQEe+pV14UFdNDV+IYX/QPW9CjHS0Hv3pgLD/5dyzM933pbIKGYisgN7OBGNYMKj1mIEPa5ls4iAJK80bXQsACGkORic6UTwPFY+NYFX+ygpDjt93L4eAOprXAFavnudyhXWKops9xCmkuvGb1JyH3frdj9JzRniaqOwY72V1xGr535mD+5ByGjmbLfMSTZ6IOIDmt5JCLFBUgTVnP9UTmZcan5tAQDdOaZq2fDpGE2vcXFaSnQTyz0KwTAkT5VZT9Tgo3LaVlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRM8KxiyOg4f05n/z6YN1VjEvXdRbnmsOyCHqV6Y7FI=;
 b=1S3bu4+BbvKlMFR7pPUlD3rew1sQAfpFtqLFl/tc4B/zq43rq9obZv6aDxcdYks/q0++GAiJxlfm5YoNM8e+EFSTYHAYnG7QLLkiS3ds+sooqUX1oms9oWayXTqRWED/eonOCYaopRmnDwjXKvS6j4pWRciW2MvlGO/2oZn+5tM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:10:26 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:10:26 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v4 20/34] KVM: SVM: Add support for EFER write traps for an SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:23 -0600
Message-Id: <d8a0d7b0d6f032bc0c0ae80d979f500b66efb332.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:806:a7::9) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 17 Nov 2020 17:10:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: abc133d6-e57b-4c53-3999-08d88b1bad45
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772FB09822DCE013F7A6513ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nk8UG5dj2Fd3yk6TTs1WgOov9JxUHyyO9cBxMB8Uwic215nTnXu/jMwX2huhdT2c9MQJSeqIsLhydpmHmasemUCvD9eSVSBqsW62OiauXWaUsClwLwdRyXFD3CZiU8544TJrwYRPml2oTB64GZJLNhdwDBcEMAqDSjYXSQ+VdDQOzFdFfbmqx+SOkzNK60jK4wDDP4VCUft0Ilc8ZlOTL+M34Q+rht5Mjn2mESepM7kVdD3u/7u70P/BunZP1375NV8koyb34pDDZK0sl3scoJ/zNUXxEQBBbPuKQ33fUVbtE5MRWZ8LsFySnbb9IUIYj+hCxElX+lsK2wZ2yPFy8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1d4PXzPbeD0ynm+q3Ftcg949CNDFPr2TH+7KIk706w3yDd90mnfVZZkBbFEA0zyJ4lDZ1EVpBCeeuBL66DqogOxhUXBm7BxqvrWrfRbwt1+7M+LGaQ4Oa+cBex7McpvPVIg6/9SdYitqIpc/S6ZwSBija+13jpPGZtv6QXbWt+7DotiaNXDCYIQnvw+YjyfPx9b44bGIIFLxMy/m/oT3OcDtupIUoii/RRypU0xavmzivO0weq6LdaK581p+3al8g404zpkzc0O+6JD5yrP3oPCZLMBAub9NLU32Cb+j4h2yuC5JKbzWh0KFxGjuD5D3++7YxUmv1ikm6bxbA4QTrX/RUK7zSMxcvgCMciBAg23fdGB3jWVxrrQCx3j29PPbvSAYL1Pmu+KkYmA/p68PmGnHNtaZKQfwuH0wPM5B8DJaeYvBaTXDhBTf67a1lcdrQBgElpx04CX55Eb2Ta7I41uDxPfTAQEI6e8HLrHWVOI5xL4dqfpL4Yw0yZidx7CCcPNm9uQPqCaTMfbjxVKMjwIUUfeYuirY6nmWpAevvFIpKIvu3FS0f4aghPZ4+DHb81Jid6UaU9/rt9aSnARTOc3p3b/wcU1JoNOSjQTNTxAsdv5Zt0cd2wWabwjFpwc8dMhwPZynt88S/eekijo2mg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc133d6-e57b-4c53-3999-08d88b1bad45
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:10:26.2677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWbnOJFyX90E1uBLM5PAokYo9y/ixnG6OhUGkv5mEkXqzDVpVp47Y/QQd4URxrHK/hGdry80VMfhI/GOJnr0gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV-ES guests, the interception of EFER write access is not
recommended. EFER interception occurs prior to EFER being modified and
the hypervisor is unable to modify EFER itself because the register is
located in the encrypted register state.

SEV-ES support introduces a new EFER write trap. This trap provides
intercept support of an EFER write after it has been modified. The new
EFER value is provided in the VMCB EXITINFO1 field, allowing the
hypervisor to track the setting of the guest EFER.

Add support to track the value of the guest EFER value using the EFER
write trap so that the hypervisor understands the guest operating mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/svm.h |  2 ++
 arch/x86/kvm/svm/svm.c          | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 09f723945425..6e3f92e17655 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -77,6 +77,7 @@
 #define SVM_EXIT_MWAIT_COND    0x08c
 #define SVM_EXIT_XSETBV        0x08d
 #define SVM_EXIT_RDPRU         0x08e
+#define SVM_EXIT_EFER_WRITE_TRAP		0x08f
 #define SVM_EXIT_INVPCID       0x0a2
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
@@ -184,6 +185,7 @@
 	{ SVM_EXIT_MONITOR,     "monitor" }, \
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
+	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 02a8035dd6b2..f840e3a3ee45 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2519,6 +2519,25 @@ static int cr8_write_interception(struct vcpu_svm *svm)
 	return 0;
 }
 
+static int efer_trap(struct vcpu_svm *svm)
+{
+	struct msr_data msr_info;
+	int ret;
+
+	/*
+	 * Clear the EFER_SVME bit from EFER. The SVM code always sets this
+	 * bit in svm_set_efer(), but __kvm_valid_efer() checks it against
+	 * whether the guest has X86_FEATURE_SVM - this avoids a failure if
+	 * the guest doesn't have X86_FEATURE_SVM.
+	 */
+	msr_info.host_initiated = false;
+	msr_info.index = MSR_EFER;
+	msr_info.data = svm->vmcb->control.exit_info_1 & ~EFER_SVME;
+	ret = kvm_set_msr_common(&svm->vcpu, &msr_info);
+
+	return kvm_complete_insn_gp(&svm->vcpu, ret);
+}
+
 static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	msr->data = 0;
@@ -3027,6 +3046,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
-- 
2.28.0

