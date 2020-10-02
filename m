Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E943D2818B8
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387935AbgJBRGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:06:23 -0400
Received: from mail-eopbgr770057.outbound.protection.outlook.com ([40.107.77.57]:20810
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387768AbgJBRGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:06:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=li565goalCRQuVatfJHT+xn6LsCAa25mC/prY3QS7YjY+4x8XANmkej10OPw4nxM8CGNwIEc+NJkRMUWcfElihY9WqUvZKfDsf8tvKDZfPgSJ2OqHgQuR01pb6jPH80YfcTd4MGHF2XX5IUnmlDzDn7UwbWXFWZQMutAmMEIe6kduDXOFT5yV+tyd+IRx7vugptE58z1w21Fd6/ioNDKbMJChhTSIn2J7JUW+Cu7H6HQXVc9p0IF5jjBxm/x/FXgP0fE6ucrH8mXO0Q+5AdYHfupRPhpATG93vWP1ljuThyvCEkVd5fSRmSTvH8atIrQRnF+KvBMca6/QH41BRB4yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8uHn3oGMeNGY5tPJlU7KaacMCyiglrrpnQZ6yJ3q4s=;
 b=aqqEaOIlZkLeC+t5lDciqf6AmF1xLFMkoQMoMPDcL23h0qXkj0jH76erlL0xD52B5jgdqFK5nAaP5jBWvm6ROVxOgz8NwP0zm16TjvV3WFQzInkYYo5qPgSlV++d5VXtfsrJymyB5IRmBePDiy5AE/1eRtfgvo/GIisqhAKdFj+ZBoAGUpqmYDw8qbHQh4SfN/g7Dd9Izla5+kdaJ8m8KDDAhG9JU/Gxkoa6l1pRO/TMRHbtIEbRdbjIfmbA+SZSAU55OSD2V07rORwcaMoW+xqTeXTDimr3620nLEpa17yk63+CFcWCGmqap7W+ToipOWcTWFmPJQjIwj7RhZosAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8uHn3oGMeNGY5tPJlU7KaacMCyiglrrpnQZ6yJ3q4s=;
 b=wvdI9Ky3OBJpuZS3kz1YFPaAVtPJBzVBx0JXmBS1IPy1tC/OqduKRpGiElmA6ebJ3qPtVm0Qt9H3Kuusnr4aNCpoDJsytIGAWdPTctcWDdg1P+u97CKAmfe186+v3shyltjzmKnh/nJVn2OXWKUGu+7+Gzrv08vSiar16Jtrgrk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:06:18 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:06:18 +0000
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
Subject: [RFC PATCH v2 22/33] KVM: SVM: Add support for CR8 write traps for an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:46 -0500
Message-Id: <804d4b6fbd859089ba5bd1299755ebd37fb9300a.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR01CA0022.prod.exchangelabs.com (2603:10b6:805:b6::35)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR01CA0022.prod.exchangelabs.com (2603:10b6:805:b6::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend Transport; Fri, 2 Oct 2020 17:06:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf7778c8-f188-42e3-0274-08d866f57a74
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB421866EA43C08CD6F9AAE46CEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gBSKe/7gyto916RSOSBpKhzmOd5VRalI8VcyqURxSRIa41ijWwKToRvNctV3YYKqTTGVAfrgrSQwr4bzPkj1wiQUCGPWXiSP2tCh3ZDU9dr3xOjxVDZpZ8X6uxjB8qU7bVxUXvuTIQIa+LtA1c2g5lVOlmTQLQd1HXwXSNloG0retxKceIG7+GGHdHcGAfiHNg0waMLXtcw0sDHR09lE2/wwoi6gSD9r/NhoMtpWo2Vps89Xf3Icx+bwxFFEMmwxsPlSdjazctT/fRtsgqbK02N7Pen5qTSN8TXCpx0YCPoo/bC08tuRp6bz4HxzmmNu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iqYfsWk4KeqrFtssQy7CkeodEUEIJErNz/4+aKLzgBBmE5i5N9mtI5eqOStJG+aJS2MwTX95BL+bYJ1Q81yxkvrS8ED+zgJ9aFP6vSbYJuT6GvoQ9QPdYycN6eJAu7iM30uqwCotGx71V2BZFhxWCLTPuFcDcGTH4ja1vRHgNqt5d8eDnu1KZ/Pln18IfnVglATINJbm2M98X3itPIBhdu7UKjmXIj2PV+IuWviF5Wy4vKQAwWjr7WG7iXZW13y9agEiYSkPq+eX8Z8+4zV2mvyG0ZYTXVUSftOhN+tk/SC8OHP5ZBkWSaLi1S0ZFYKgTsC0FYj1EjZFJ8zqd7p5D5l55guaXJfbsVy8zs6NGShPNbeQ+Sja77yUFZs5/1I13600qEbdbMsZbZzfRXLglCJlb6kqu1RkeMNXEAJmSTXw8UK4tnkXug/uwmBaXVKpKjwE8ReUT1PfarLyiqdzhtTnM0ftx6RQ0XROUzNhQAepuek4tkZIimrrGZhAoagvDjaO2co7qvvuyjgQ4YS6VueDVvOhlt0Q06PE1ciqhhpTy9ae215zcYsR0tWy1HTVs8i2q2L7oyBH25gJbI6Uo5R7wL4ae3O3xniRX644t0NeH4RDaVyTHzAtmvIkgtZZ06kfWCHswfvolnBTP9zh1w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7778c8-f188-42e3-0274-08d866f57a74
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:06:18.1868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ab1kePHb8CEOoqV/RyXysZXIvo/BdBYb+rARDNVoOrpNqQcAqemFG0ok2WxlEa+AmjZcNtW8LpJNdH88l4cS3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index 423f242a7a8d..b486c02935ef 100644
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
index 6b6cf071e656..7082432db161 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2498,6 +2498,9 @@ static int cr_trap(struct vcpu_svm *svm)
 
 		ret = __kvm_set_cr4(&svm->vcpu, old_value, new_value);
 		break;
+	case 8:
+		ret = kvm_set_cr8(&svm->vcpu, new_value);
+		break;
 	default:
 		WARN(1, "unhandled CR%d write trap", cr);
 		ret = 1;
@@ -3089,6 +3092,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
+	[SVM_EXIT_CR8_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
-- 
2.28.0

