Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FA32AC888
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732448AbgKIW3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:29:18 -0500
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:48608
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731378AbgKIW3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:29:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKnze15A/hxzAHqtdmXK7+Wc5iVWzyPwi04DUoSF0LO/LB0esgY6fbHMrTykyfodS4rgGh4unE5p52B07FRDv125RP7eTRr3vMmfmlvokgaZOhAmWkZso1B4xt1DLH9MyKOJrJHBZizUhk0i0K3FxR7JjFaUuTP9VSpdZ8i1wOsSYUYA4Kj99/UkospGbitOI1Aprjbbg3dscpJbll4PdrSP+ToAVc9ORkQMqHSyf5Z/jtFRZbg6IguZMnPFfYfvXEsarWrH6Q6DpXm+R14k6I81HD9GWEVtouFLqFBOSfPRpT3GV6gV9z4bck9NijeDTiTDCwoDFI5IL9OCdkoEJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwygHFNUnmYsdQoMJ1B1iL8/17ChjO18hGJK7Aexfxk=;
 b=CEklxlKXMxKxG67NCNnvqOJI1Y8ALgYAZTOzSODpyVYZ4W347TUKvMgL6YIKWHF+L01mBsvDpCt+/c/4nxLB4tBGxIXutMyr2iDPlhBuxT/iJPEsxB4kqOx6oI+Rw5L61uX2xQUpmZowPt8NKEndGgbO7/mS1hp4vy5FSa6Ku0pmSC/UXatTJGIj7+Pg69klvdn+bO1BZ1/iPcJM7ntyl56Qy1TY5uV9Qzf6aqf+EHny5aZgF1zPpn4/xV6KFIjoEVsk9jOirB1Zb9EibWyVii8ovbw3eBVUgK+JMNSvnT2ysoPRbGVBN1ShhifCuFBP1lF9mZ8i/3fOQH/pMvhwVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwygHFNUnmYsdQoMJ1B1iL8/17ChjO18hGJK7Aexfxk=;
 b=cyYgONifTeaV+ba4kL/Jic+BaM35Y6P3OZQFWywsFM5N9iB4KWPyqHydFZGPFTbK2i1ZowdFgAVL+rk6q/69pcHVZKcr631iow6bpbmdSZHFiZHVcbP6hKV7r8umFH+hIOnz2Rj3iJiGZGsP+T01afvAHfVHIhzurzixZjj/1w4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:29:14 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:29:14 +0000
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
Subject: [PATCH v3 23/34] KVM: SVM: Add support for CR8 write traps for an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:49 -0600
Message-Id: <cad3a2ec956fc6f78e6b8004a97c58e0abedcd2a.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:5:100::20) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR03CA0043.namprd03.prod.outlook.com (2603:10b6:5:100::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:29:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad845075-f557-4ebf-8fa7-08d884fee348
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40584364879B76F2410DB9F4ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qEmwgWdmbDpOriXzwQZc7daoCg5fzWAGtqlq1GRrAll4Iv9gqBUASaj61w5/D5Ih+ZH/XYaZ1GQr+vlO9L15PefxGLxhQeswoxiklduRPziHSLooUHLb9bur1AzND17lFjrnYG5veM5VkDwghrdtTx28DnT+vFNngJVbbceNqNGQen6oPbAuqRweMica+ePsgsBjY8ud6ZA+0vhr0moGg+1KdNuPvCnEauw5KksAVnUCwWwFv6P17CwYh9JJ5dbTX9r1mNEPIoI3M187QA+UiUAWNHeKM6puAZaEJtbUXnkdZDk4o+gOIazqRQQQVKkK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5XhnKzCRV146Rh+18DY5iZQM/b1tIOHxQ+gZehQdPGQyuqDczvuq7V8N6QKv3GeWBpb8sucvmoFG2j76vv0S3M7OsyLogGTDwF+tePFGBrwWH58xw0XYOvPC7vFynKh2C60f1y5Jpq6Pvk2H1HCyEb6OUFp0pym1QOwktSxIiMHN1hy0uJHoCQzcoCQQZU8At2GgQ0oWd1ivmyBkmV3uwbXFDdUCmhPlsUnAEspLLU5MS7pbqesCta9X/pCVkoF5StKeA24AA2o2S85TQFPpsvL5AuTNCRPClt8SLTTpSH3C0lmdinFe39458Nq5/CKa1hoki+fiE133TQ3lFvQ7/dEqPxE8QMVLXMbwyE/BfGSxv5gpogiW8MRoMpdBWg7dVzR7eNDh5op1XCzh4pIaRQqLe9ZAhVXcBQ1jCzgHEahtVQXFiJIbL1Wjj6/cWfmtLchAF8O0QwaF2tmdxYoLBKFp+s1Is8s86kFioYoBJD+NtCWyDOHOu5iiTcXoPSyvxoHGbOnieIBs+eEbdC4Os8BmFTr4+Z5Uvb++G06R2dXqZTjzv7c0odvCgv6vyj5Zk+2JmBCDNCPF4g78BlFy7qzjO9/CpSUHBw7F5c/1Ak35fYAQ5Y/chrp1foJrp5dHmrC+Bn6vw3iir/rqvIglrQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad845075-f557-4ebf-8fa7-08d884fee348
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:29:14.4307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drZs7oXfAWtzb8VMs5e++tqbBnQ/toIk5cpFMTqTFrCEcd8KjZFjFivqKxkkdrcxpNvMsetKa5u6fP1apCHEzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index 20cf629a0fdb..fb529d5cb36d 100644
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

