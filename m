Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C765F2B6B51
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgKQRLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:11:11 -0500
Received: from mail-dm6nam11on2077.outbound.protection.outlook.com ([40.107.223.77]:15520
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728724AbgKQRKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:10:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnKWFGcuQLhGgCrYjNBEeCw1oIPYcwVod5I6w7h6cqZ69MR9sKEU+IYMDciYaILES1M1a1y4SPr36XUnFt4gVJ1vlJeUFaCGSmWdUAcOz/j7JLSduBtlhqMnJZ7LoIYCZJxRb4uLKx5uA9S1hPC7FvYcSYxZjZytaGhEc0VQAipf46RdQiNgCoF6tbeZzyG0pcaKqqLaVWJNCp1wYIiA55x+HrC+zaMXMlDZJupYl53FoVVyV6gNTcTu9V2Q1VZ75IJuIWbgHsdE4VktjAU23WswPROI/lLUzXMEZJ2PCxDWKV2li8F5xOw38f+yzb6DjSyIbZk3OUIFiRySaFnM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hbY8uveVEnyeeOkeJUghCuocXWqo4A8lomyKViLlww=;
 b=Z2DlMIsBNsBEzerlcJ8FV2xas6IcOBTeOwUa9FLXCzwDnrSNGA6L/7MoI141Ex3OIZNGU74YTyhETHt/RY+sryD0pbh4Jvu2p03HPebO+dnHEa7L2RbkrIDUg2ku0SDrYkotDEYTjOXJCaj5sHWz87ZobgEbHdkPhUEEJVcSZbAaT0FLCOcKzUc9DcmUtF4Yn5J80jJLPlWFQiQgRjFjA61FnpGc55O7Q3W/jMpwQNfk62tG3ke48LTOZbsQSjY7YmMom80ZAwW9wo9XcZel488luQ4p9/Oy57x2DlohVsEle9PisKN2hSnsMiYTQGqYDEWVxK6X0WkyFpPakc1KNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hbY8uveVEnyeeOkeJUghCuocXWqo4A8lomyKViLlww=;
 b=qlRKjsx/kDEjiHYh/LoznAH41GN3Cuc46vZQ0hEpNe2AhqmuVPyBNVSEepcvzXgCGj2xbogw9XGmEz9Qe4sybLUlr+Mi6I+Mv2Ead9td6cpk5jf1D6XsZtLcJLUCWCt4nBjXsuJlWvpu5+/9dxmZW15QUihTZHAqCKH0klNJ2Tg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:10:50 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:10:50 +0000
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
Subject: [PATCH v4 23/34] KVM: SVM: Add support for CR8 write traps for an SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:26 -0600
Message-Id: <6e32aac0580cff0da77042b2f0db986af814b6f2.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0146.namprd05.prod.outlook.com
 (2603:10b6:803:2c::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0146.namprd05.prod.outlook.com (2603:10b6:803:2c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:10:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 107fe14b-b4eb-435a-15b2-08d88b1bbbbe
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772A3B80745EE860B159F9AECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TxvpgK5qtz/QgvWe3/R+LfRFcZ5liFvisLNBVq8w3g/QjdKddC96p3laPTtEFuiCdulG0KY2azToAqvrCTey6SPgNTZaShtxnuBW6VN8rA1kQV0sToZNZHv1fqAlicTkJQsoUgA/SXJmYutSQ3puSfWTgE/Opim6/ymtrYcp/vHNrGZz4U7ljW8KwNsparbBB8aoRLrfBvgAsFM9ZbQ6U1uirbDh2iPUmQdEBJgJil21QugUpaWFFEYWD+urZk+/DWhvcXN4ybtxAvszLiTVBEZeeP1dckbB8XdOYx3tc/C7HGuJkRaUNbnJgzENTN2B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fw85rMR0O3r8EWKNhC8ZjZ2rkYCAjC5QVI1hnmFOig9UOHYD0YW0gcdQBOs7NJq/s4UDRuvtMg03wrw+BGXtPhGyHAE/IzpHVBRrU4PXGyy7k7m0wfRhJMGwKlfH2e7uSTv9uEPg+V6dvylOyTR3MZZM+eJpV9XHyNeDNN/aL3k2WgHqa9ISp+o2QTdC9Cx/iPaWbH1LAl4hITrYo1AFc0+5Xv0nNP1fdbXCYwTYuTZXQZlvD32QfsirO+dHt0dCZFIGa0F8t4vcHz6ofQtrS16YnpyNq5+nrcWPg8w9xEdTCsBPTZXmILbtb36jpw8kAZnll+oGlIKeOUw2qFeKwTzgwWZLUcFmFC1xcpRxa/yNK6b+1LgFjN+CWscSidpp/iY2yOsrUvypTkHP9AQx2ZCszCV6CUEiI/bamzYBP33uGKvDQsqgDh2QUtR50HcpLdtJPCQ0GPbGOFeyodODcJhjsno8yKimkqlLsQzT4OMjCXpYLtuOhwcCSI8Ax3eEuh+9BIhATxmuHGAkTDRWq5bTGJUfUAQHtcsCBkPFkBl5UMLHgcQZPpoK+/x6BKIpI1Rd0zA3/pXb4tYL6lPYhnJbk/sYBirMPkscYasPdDRJFdG7EE181/m1gt62rYXmfSBfsGk6gmp4bxCEjtfV4w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107fe14b-b4eb-435a-15b2-08d88b1bbbbe
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:10:50.5168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mc12I+4lfCVa1ew/UtrF0nQTZUcIPXdQulNfSRiq/7NzrIMAKxvHDQmRx57O7ImagasbVm+fOlktzC4TklbUcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
 arch/x86/include/uapi/asm/svm.h | 1 +
 arch/x86/kvm/svm/svm.c          | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index c4152689ea93..554f75fe013c 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -204,6 +204,7 @@
 	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
 	{ SVM_EXIT_CR0_WRITE_TRAP,	"write_cr0_trap" }, \
 	{ SVM_EXIT_CR4_WRITE_TRAP,	"write_cr4_trap" }, \
+	{ SVM_EXIT_CR8_WRITE_TRAP,	"write_cr8_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 146dbfeb5768..f5188919a132 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2486,6 +2486,9 @@ static int cr_trap(struct vcpu_svm *svm)
 
 		ret = __kvm_set_cr4(&svm->vcpu, old_value, new_value);
 		break;
+	case 8:
+		ret = kvm_set_cr8(&svm->vcpu, new_value);
+		break;
 	default:
 		WARN(1, "unhandled CR%d write trap", cr);
 		ret = 1;
@@ -3077,6 +3080,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
+	[SVM_EXIT_CR8_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
-- 
2.28.0

