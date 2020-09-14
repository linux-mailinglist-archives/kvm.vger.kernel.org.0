Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A8326968D
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgINU1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:27:52 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:9896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726261AbgINUUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:20:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2LPAdhZWqtZBDX4nLbLpHm8ZHfMwk54ENDO02T0H+fZC9EAvTXJyN3vPDEv8uUSxHWaNMeWT/UM5lX8zg0Od/oWlq0fAUk964pUN5FHRaLb1M8PWOOjAzlIOUTF70creBEuOZpEVL9BRrQUuo+YsrcXl9RWqoVcRGI2W55JQ6ShhMwTLT6YSM7Kid5Pq/+XEHvxtE+jK7GHHgHeh91UPute5qndDx0GpJFuZU+eAH/G2CGmCsXo+XzLIsqf6QgiNKoPUoKs/3FK6cN2Y3KwZe/pFHwwk1SjDoVizyc4Ab6LD+WPCWc1IexFKO7jW276me75x1JoyxYkS/V6nbD42g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPom1vPuU/Gag5lzL7rRu47c4WTQKTNTOcmKVA2BaP0=;
 b=gvs/VbsxFOHmAiDkfjij4HBCDeiwiBOlJtSc673bFvVqzxDA81EK5tcYKObsQ/OtkIuQt5muHKVSmeq94FRQn0hlv9yQF4IqlO1AmGwd85gfq3iNcgSuoVSVR25buljMCvH47OR94nvc7tInfT7DI2g9qbvhyGj7NA6V0kuOQn6/Z818LiyDdMA1H0JQxyczEF0a2zehE9MrPzbbcDtOv8qAXb2mS6mTxucUdND/NkTOHeAsuSwhzR2uwG5foKr2eD2sTaNfmi7cBPuCbMsu53zAtUVdp9PHIkJesfn2UWYu5I2MSdNxGgG6rsQtXT7Xn9bR5ld99c/cic7i4++WGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPom1vPuU/Gag5lzL7rRu47c4WTQKTNTOcmKVA2BaP0=;
 b=hJQ7zhYiAvjSH0zZSEzllii32YvcoDHUb/JkB9yb3JBsyL0sinv0dWIQuBN7FIC8l/Q6CWGztAlVJZMYUVD9TRW/x3EJjPOMSFhG0xTIXuvAhZbsXduAbYCRZiPgfgSmgFurNqJC0XSHiLfm7Pn+HXEsi3xqXZavWTSZ2o4k+/o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:19:11 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:19:11 +0000
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
Subject: [RFC PATCH 24/35] KVM: SVM: Add support for CR8 write traps for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:38 -0500
Message-Id: <e3438655021a0ca0c7ef5903b9250c4b4c285d82.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0052.namprd05.prod.outlook.com
 (2603:10b6:803:41::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0052.namprd05.prod.outlook.com (2603:10b6:803:41::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Mon, 14 Sep 2020 20:19:10 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 115c43b4-ae5a-46e6-5c15-08d858eb7114
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2988546081D228D84A2A01A3EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xKawHvhrbvd/BcRDltqMBYMiFPgExPMWXQprG57U59G6QN+97TpQ92g9GgcSrTYeMXTEmQMObJs1578MOcOuXEWwdbmA8vsCuUtG79B4ZAWgFfloqOUEKmSdHvnmsQJ6gJoCM7i+kuly1HWXeV6inGnIpZB2wRxj38Ekvc68mjr7GfYXCLzkbn3yOJsLUNjLy0mvp1X2u/co5k50Ag4OCNLgATWglKTVcdlBMKbws+su8Ma5KL3dd5NwiSSoPi2ry6JsmkfW/yZIOakQIj/Apw5+gPaD0/AxYTvZbv26oqsCb2FY4zfpJDXzEPFHEk8l/tlGB2PZwPBVS7sBy7SusA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 66wH3nymizaOT5RvHgPl+wCch+PVbEcHI0a2fTi345w4anhP2xZuZAIWzniFPWTiKQa29r2E3uCchKsOmc13h+BLzVDegb0ZMgqWFcWC2WmrKRNM2F566nw+6XIzzzNk/T1KKeSWyo4ZBlSGPIWz5QbRwu0JPWCZwpUwLWJRP5VxR0iIsbJzGGa8+suX0Tbk/DWLek0jdzMj3Gol4sCQuW54cqT0ByXHMBJ7oMVt0c/dg5RjNUTd3Ma4DyFoEKRyTMFVzFOniAugjjDqDOQG9A11ZDC5+WEi3gUDfL37REuSoOFH60lqZDsxNM555yF2ySyNHEyiLHXoudXoKm36B1VOwyJeRk6weRgJcpkkPLn1XFvDj7Y7c0YgQwxSwd1i8Rw4cf6h8pwO/fqEQzsWytnW268St4w0InxB5HOzIk+fq2Rg3l+u87XyLHx/VA6DZJt6Frrie8PTw6XMyJh+JA2l7ny678deCZFYYLeYwMg8z5VTAKhoRwZeMV5u2zL6/TEJ7HJwQl1wsM6HBgg+oyj+KA/DLdW3yrZnMwxSFnmzW62IwhVPD3J7BqgDcFYw7iHxkdV4QRFnqOfB3YbeEmjCn+0xY2+lZbR7uJrvHUCglzXvpE7fnIrCVVF8VVLoHQlA8QTasT2IJx3QK2nJ5A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 115c43b4-ae5a-46e6-5c15-08d858eb7114
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:19:11.2462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tjgzf8huhNYJRbO/aj7MtPbUQt+//B1HgXc19FsdQxjLPbLsIW5aqaPCA5+zEYlwTePe1rt5IOVyXeEoWXvCow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV-ES guests, the interception of control register write access
is not recommended. Control register interception occurs prior to the
control register being modified and the hypervisor is unable to modify
the control register itself because the register is located in the
encrypted register state.

SEV-ES guests introduce new control register write traps. These traps
provide intercept support of a control register write after the control
register has been modified. The new control register value is provided in
the VMCB EXITINFO1 field, allowing the hypervisor to track the setting
of the guest control registers.

Add support to track the value of the guest CR8 register using the control
register write trap so that the hypervisor understands the guest operating
mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/include/uapi/asm/svm.h | 1 +
 arch/x86/kvm/svm/svm.c          | 4 ++++
 arch/x86/kvm/x86.c              | 6 ++++++
 4 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e4fd2600ecf6..790659494aae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1434,6 +1434,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
 int kvm_track_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_track_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+int kvm_track_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
 int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
 int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index ea88789d71f2..60830088e8e3 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -203,6 +203,7 @@
 	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
 	{ SVM_EXIT_CR0_WRITE_TRAP,	"write_cr0_trap" }, \
 	{ SVM_EXIT_CR4_WRITE_TRAP,	"write_cr4_trap" }, \
+	{ SVM_EXIT_CR8_WRITE_TRAP,	"write_cr8_trap" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ec5efa1d4344..b35c2de1130c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2426,6 +2426,9 @@ static int cr_trap(struct vcpu_svm *svm)
 	case 4:
 		kvm_track_cr4(&svm->vcpu, svm->vmcb->control.exit_info_1);
 		break;
+	case 8:
+		kvm_track_cr8(&svm->vcpu, svm->vmcb->control.exit_info_1);
+		break;
 	default:
 		WARN(1, "unhandled CR%d write trap", cr);
 		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
@@ -2980,6 +2983,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
+	[SVM_EXIT_CR8_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e5f1e8fed3a..6e445a76b691 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1109,6 +1109,12 @@ unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_get_cr8);
 
+int kvm_track_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
+{
+	return kvm_set_cr8(vcpu, cr8);
+}
+EXPORT_SYMBOL_GPL(kvm_track_cr8);
+
 static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 {
 	int i;
-- 
2.28.0

