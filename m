Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F0C2AC87E
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732242AbgKIW25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:28:57 -0500
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:49536
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731474AbgKIW24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:28:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIdRLMl3FIHYJYjbQgl/J5Lj79Zy2DoVOMZasiGR1cK40ZXEUCOVDQRzvbhjljWh7/8Z1qvdkNhPv3u+Hrzs24cD+B/H+3Nzs1JlCwmHBjMajQyRg0gTiXB2fSi3Iu/k7pMu42vat/0m8rmit+ThAMCQ9GQaUtkr4/ikFk65MetXvk4HAMi/8AHBzGsSSQ881WT6vzxQEtV8G2TCCOAMlPNbsG0AdBY3SAICdW4XXIQxMCtbmVRD/LCg68NzsUodfmjIC4BuzYM7YURe/+GspNh4SvoX5ZdnvnsQYLzULBJI4UuepeAjRgkjUjANf8pt2iZ0NwCB7vjYUqe2O26e9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiowFavMN2/0sCpNzt725V2tuUUBC/2E9C7WrzYkf7I=;
 b=Q7Y9umj4BKiJrfSoZLeWjqV1NRF0RSzGq+cstHtz2KimWaKIY8vqqz+YSXBw6PwBmlk0PSjKpFUxdEwfy1dn/wy/yyTC/qz7fkUb4nvSl+gpkKr2/1ah4UsMzykWxbyvme9y6fyMDojccDBDfH+XF9QAY99EQnkpw3CEqLzDXxaQ1mbmvFxZzSyxcD48/S6tNJ/g/+xwsLxA6m8xNS+4TTluBM+gL1Mv7XE4oLLhgKT/WIKicjhFnF5+dXnMuiP6aGaeB2A1lDffV3slGlHtI9t4O56jqeUnvIlSJpzMsaYbIUyrjN5j88yYxB97ifskj+tOxYOjqNN11by/IuMBKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiowFavMN2/0sCpNzt725V2tuUUBC/2E9C7WrzYkf7I=;
 b=kAFPAvteMF36OtaiVziSzJ7lAN57arEMGc95csipUL4lXhg0Fm0racOAUGG4KWd3Z12U3xtdjjiW5vLX6wxK+l/nnAIpXRU1Dz+TamPexx5IhfaMaIDpfux+20X8D0fnTy9TQ/7/vvCLFELW1xGnPRyU6k+nzMAS9PaDWveoZ1Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:28:52 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:28:51 +0000
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
Subject: [PATCH v3 20/34] KVM: SVM: Add support for EFER write traps for an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:46 -0600
Message-Id: <5325264b490c822f9c282c89a7d3b19d7723be9b.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR21CA0042.namprd21.prod.outlook.com
 (2603:10b6:3:ed::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR21CA0042.namprd21.prod.outlook.com (2603:10b6:3:ed::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.6 via Frontend Transport; Mon, 9 Nov 2020 22:28:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 64e61467-f8cd-4780-442f-08d884fed5d8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058427EFA62F23D8E1D040DECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w7IRMfdAu1IL8oJ9ODhrWnKfVQcKiNO29Ia9hu66KO1S70OCYbPEjb4Lu5kaK1ALyUZILhBfCM4otmzARjaRsundoGLjHEVmB9vXCQriD2k/cUr5My2h4eCtZNz66u3qa/q9sk19iimnPT96DcfG99wt08ocD4Ds0i3IWk7KnM1CjwPyqmUgMh+Vac/kWSrJNZJ1A7Pp2L9S0Aj8Wg0XgQpq92A9zUqTAg133SCdvPWpHwvjlYgKDZDiqPnJy8Q0yx6e1mtnhbE3BCN5lhwx+RHApkixviiZl3QlnpBVaynY2zAbbECTURZDOiCvU19yVtbX/rJq12/nyGDH0GfTQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3r0kmdxYbJQHLmLnBYxwD+NEmF0z0YJZoEJL36PEpoT6dGReccVJkUtk3DlKemc7d0pg9ZZ796CGzbBlWQ9jCZurX0Q5SzrJ715+WMGZx1+wDE8YXgMT7O5+xfYllKl66QJCIgrTwLiPktotHWxsdN9EfuW+9EqTDmSWOQHtorKsvdWhwH0P5vYod+zrRqGI+nx7BUHuwWhH4CcjXcHu9fh28TyyIMW3VbeHvxR+VadbDy4rIbEA+6xlb2Ui5gNJuvHbeG4ki/1KuMbnSmynA1nK2UKs6EiwMa1UrGOaL7a3gmjDJqTVc/0SQFiEBvQ89RlrM2TYWw5blXFgUG5VOGIVvvvxnqOkBi1+I85pbiJ20aVlsvpveuIuEFGEk5aoPt0cShUz7nymTjDGfPyrxhdlHoohxosqbH2j4cfn96FiCkTTArVXf80bhH3VKy8h2Lhe0S2+hb/ugiyW0tzBWW6b6k9zmPtzEyXYXNC6ir8mLtwDXcqVldWKNI7XLFfpMidJ4UsJDlwntlN6Bm1BMYjlkEn4avXYk+t2JkeVV3GHMLcmcsSlsgdchLV10WsX0ksf27o8t1grXzY/LqjkWlmwKQr6LPj+HtmPRAipXtp7OEXm1Q6XtAxfGQcppnLdx78HJG4MmwdokFXbZzZ4rg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e61467-f8cd-4780-442f-08d884fed5d8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:28:51.8734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7TysFnuQA4zWjKJWhcQWPG2aMcdnUw1gnAh1hdh3ErJDY6bRCwpX5pQzXYyX6uWX+C+l20ysy05RmW1Gai8Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index fa15223a2106..e16c1b49b34f 100644
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

