Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB25628189D
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388409AbgJBRFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:07 -0400
Received: from mail-eopbgr770045.outbound.protection.outlook.com ([40.107.77.45]:52597
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388391AbgJBRFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=io8NOPULkMuVpwQ9QRfIVWzinRBKhiYFoWQpTPNeeRR+rLArdRUNOzVr01CodGuE3RJCRgfLeDykg89QUZk3rOIZoduLmAdcvE8h2warR5f38quweef6FSPtqFG5/aHmFgzoMPY1KbzI/8biGyB+CiL1glubqpkzSeT/zGBWUV2HoPjKqDQjypbPVv8BnggNTfvs3HqVR39uey1/MRqlC2nSU5ee99ZCN0gAEikXa9QN1A12LQT0hvrww/fGQ85od0hfphi8CZQIhwuyFntj7Jxj67XJCvPid3l3gZdhbSKAOJdx0IwsVs9hLPinaH82YA3uRaqQBYSimwp/HJyESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1ESyOoWQ/I22qAVgF/Vkb3/7Q8Bj1eJzQ+Z/x+Qrd4=;
 b=kq5An+/U1Z4+NBdODTE5VT4l+Y9aoKoaRYK+BEUeclNY0sD+yd8BouCtGfqKydCaLDvSG7MJooFR5DAHyaN8kkYnx31rkIPRlPAzDsS0BOrCrlmdQVO6G/yM2grMCrkkcD/mpJXrhuIip7EAQM1eNLWhNoiAeDCQWqcJpesJYWo3/QmUv0kTk59ttRLVKKanYJSKNhZxGjEl64sRQuEmiCB/qU47ShauG8RiezPHxc8oHq5TVjPx9eWPCCybefp80kQK9biVTAocb0wFH5Z+UCxj0BaTwf+DBmUldmPoSHt5XFmRaqOXfbEiTtXwIyjs9G1hEL/MQSW+e6X586BsOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1ESyOoWQ/I22qAVgF/Vkb3/7Q8Bj1eJzQ+Z/x+Qrd4=;
 b=k7+rVdlCJGlyu0+/3M1NveKypxfh0VfyB5pGyYjIX34evpYbEPogncEgiSthhspxU+xh6wpaJ+fk8KdLKA3JbO2V+xMfgw59oI11DSbqj2IARMcFZej0EGJAaaLYwyUNXnMe+3zFE1bsndLA+m5M1rnoLJYwr9H9BNBThPDkFLs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:05:02 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:05:02 +0000
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
Subject: [RFC PATCH v2 13/33] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x002
Date:   Fri,  2 Oct 2020 12:02:37 -0500
Message-Id: <5c2329538584e1f666cfdb7a96d7f48a32d51041.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0022.namprd05.prod.outlook.com
 (2603:10b6:803:40::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0022.namprd05.prod.outlook.com (2603:10b6:803:40::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 17:05:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 581609ae-4e28-4e5b-7ea1-08d866f54d53
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218C22AD8F0FE23754FA9A0EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ympAbhRZhG+afjjNTKKj2cJB15vty0FLrthsfQcvA1fzbkbjl2HVFBLvbZtlbUWlVBZtdTYh/2OM/XkpQIIi9+Aat+8peyeGc6XKxfnM2kaXyQkOKqdZ5jZeAqOCX5ZVmSAzXNnNj+bR7yukpJHI/4sx394oa3HChVmjrotuWC4NYFQnALbCOcE+oqIWhrbMoy5snRlcQFJwUNcua83apelAWpACc6v99/mYhZFeGaD8Lj8y9eW/A5d7MbTA4AF84hInUewqhVDCtL+l0xLG1uTGhyayT6H9A9L7vMle3mWpOF9sCG00pmoqcJcqAHhWY3jzu89yGAY1ngtetiAMcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tF6kaHHKk2nFrFCtyvzSGL5F7AotJ3F//2rp7Ur2lfRSiITcSs3LtVVHx6qpnlMlw+1rcAF6KVyiWpRcP9QBWrTS1Hkyi2xyf4d2LLRQGBJzNP5+W/nw/8xSuOpl6Tk4o1hjMggTVKb32IDSGivkDEuscBPvMJ7y+sYpeG/Mj8X643RyJ5gwqBORjq9C2qGnp1GeEUqfAcTZnYsyY1F3SDX5dldboqMRPIuyMTfAQh+UvnR2fm6Dmm26fvIpOSx+SkYundurYp2rbnL2457KBn+D9WOZ4CtGPlZyQueou721owOPa/O7RjE05rbGsUSCwxpZMY+047YFdMxxG51RNpxBL4cVuckYgsYfqXnuqnbYMvgSu1KLTSJG8RazvxSxv20fWzRlsFPif9r3geJHSiHDfaqSoRPq4ZN1WxkZhz5GJvCMinB/luPp+IqwXMGViOHEREqvN7UNg9WVM0AUnL8bPwhGEpMwpOUVh87jK/wfIrbkct2VrcdqpQZeMjcuqAdMcBkFFH3fd766IQGcFTG+Rf0zEycD+67Gb3h5jGqY4i1dx//M2JGCFg1FltKP126DbNdpOhJEM9PblMbGxKCL5kItlEi+Sc0z2P28yYsk8bcits2EaQ632Y2YxBWsYJdDBdyXp546qiEhHUYCtQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 581609ae-4e28-4e5b-7ea1-08d866f54d53
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:05:02.6611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1IIcc+Mwvu+pNgoii08AM4azL1N9NtqDikGqANGuMPG1uhPH6mRHNeZJ36y2gCoj0OUXTRhKVWVcPygdIqhPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB specification defines a GHCB MSR protocol using the lower
12-bits of the GHCB MSR (in the hypervisor this corresponds to the
GHCB GPA field in the VMCB).

Function 0x002 is a request to set the GHCB MSR value to the SEV INFO as
per the specification via the VMCB GHCB GPA field.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h | 17 +++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 500c845f4979..fb0410fd2f68 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -21,6 +21,7 @@
 #include "cpuid.h"
 #include "trace.h"
 
+static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -1140,6 +1141,9 @@ void __init sev_hardware_setup(void)
 	/* Retrieve SEV CPUID information */
 	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
 
+	/* Set encryption bit location for SEV-ES guests */
+	sev_enc_bit = ebx & 0x3f;
+
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = ecx;
 
@@ -1408,9 +1412,29 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
+static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
+{
+	svm->vmcb->control.ghcb_gpa = value;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
-	return -EINVAL;
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	u64 ghcb_info;
+
+	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
+
+	switch (ghcb_info) {
+	case GHCB_MSR_SEV_INFO_REQ:
+		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
+						    GHCB_VERSION_MIN,
+						    sev_enc_bit));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 1;
 }
 
 int sev_handle_vmgexit(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 67ea93b284a8..487fdc0c986b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -505,9 +505,26 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
+#define GHCB_VERSION_MAX		1ULL
+#define GHCB_VERSION_MIN		1ULL
+
 #define GHCB_MSR_INFO_POS		0
 #define GHCB_MSR_INFO_MASK		(BIT_ULL(12) - 1)
 
+#define GHCB_MSR_SEV_INFO_RESP		0x001
+#define GHCB_MSR_SEV_INFO_REQ		0x002
+#define GHCB_MSR_VER_MAX_POS		48
+#define GHCB_MSR_VER_MAX_MASK		0xffff
+#define GHCB_MSR_VER_MIN_POS		32
+#define GHCB_MSR_VER_MIN_MASK		0xffff
+#define GHCB_MSR_CBIT_POS		24
+#define GHCB_MSR_CBIT_MASK		0xff
+#define GHCB_MSR_SEV_INFO(_max, _min, _cbit)				\
+	((((_max) & GHCB_MSR_VER_MAX_MASK) << GHCB_MSR_VER_MAX_POS) |	\
+	 (((_min) & GHCB_MSR_VER_MIN_MASK) << GHCB_MSR_VER_MIN_POS) |	\
+	 (((_cbit) & GHCB_MSR_CBIT_MASK) << GHCB_MSR_CBIT_POS) |	\
+	 GHCB_MSR_SEV_INFO_RESP)
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
-- 
2.28.0

