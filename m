Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5239A269699
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgINU1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:27:48 -0400
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:3544
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726146AbgINUUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:20:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCwxQW4C2ohHbeBMlptLrVcfgvbSuVuoi3+9yP6U8FUZbD4e7x3nRt53CDtZ+9JOoS+YWbwWQnKDETKJ/YmeeVYN/wfDtWO7T8ta2506qjQt5FngLkG5I8BAVH/btsxlLtilRy3ZYWtD5YTA5193iLPgYbnpkErIseviXjuide8lBCHsInU4YciLuZhlF3b4eynMOYj08akl+aWW7BPnfN1DdmJvUmcPl9ezKdLLyVMvtSz7XYMgg6u1HLuK8du4EyOITju14dlIvbCbmkt1VExdbuNU9wGcw+bqmkua34PgakzkNUJ5U0HxF2FOQOnnY3ZfQWKstdO/DhK2mUlwlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khOSCZxqUUQNoJaZgiZSlEC4S3HSuFUnROAQQmDZOc8=;
 b=gn9GriVCsRYxG99QR3qEow0V2It9OTRj9c4IPYDWS8lGlehnlw3juOZSHdyF7CpKUdhCHvMzSrvWcyLV1ZYKQSveakFAIMdXHBudhK57gA7oBfjF8lSYiaE3f3wSjfE1UJWmzVJ4YFpr6K6T9hZKgzpYep8vzb1WGRK45sE8p10qzEDeA8IcK5rq72+/kN/5HPfzIF+hAloXrVGrS+g3B9VMCCjK3uyZRMOkBS6k764g0w/6QQJre2bsThkoQVe0VmsS0yTOUOShXIqe4iIGhpJRD6TPJ+r80QgYa9SV+/Iy4pJrBtCwsQkvvdmfrCBkT1tdW2T9WtB/qI4L2//QUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khOSCZxqUUQNoJaZgiZSlEC4S3HSuFUnROAQQmDZOc8=;
 b=Bc8QkxzDCUo3McYhD6q7qEoNL7Uun8PKz1alL6ivmdawM2Q4iCmWiWzoIhZvVRS7QZhjGJwaZOcYFsbwLi42PuaF/w5JLdjXvpMq7X+AnwoPEd+y0h83uSLdfKUs8lHVaKSSQykJHQEs4VmfKhiEMjArrWqi2SPS6lqo2tha4Jc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:19:36 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:19:36 +0000
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
Subject: [RFC PATCH 27/35] KVM: SVM: Add support for booting APs for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:41 -0500
Message-Id: <bd39bf8dcf5bf6a62b18d8014577b9d6b90360e4.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:806:a7::20) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR10CA0015.namprd10.prod.outlook.com (2603:10b6:806:a7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:19:35 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9507546d-3b7d-421d-9295-08d858eb7fe3
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2988DA9C5451D5264FDD42E1EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5BMIhPb3wZ3JikOIY9bHPXuzXezbqx3HIG0CfCX2Y3yyuhxkT2TU2f29yzlrb+Df+BEHRUJ26UzdVY+M2Vv/wuZ8XPaxtsiRcDaj7NUl1jcOqr8uz/Pih1aLzhYSmM/sulkl83bfD1yINHB6jgVPQpnhKyofGyMOsoWwFyD3BYyLsvAHSCZvKMxrh75E+qYJJTrj68LxtyLaBhjDcPqrnaixl6mVnw0qt9om1joXW+FHd8PSGstJ+mle35jToLHFJmqOjoIbXPFjSuScBO4VhJSTQcQY2Vge7/eiB32G7+My8NAA5d4bC1NNcHTxH6s7UL8E0XUZM/YOQWZHwVptw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: awY5CWO2AcQQv5cCc5HOlcQfVKHR91ZXGFOys9F+9/9+NmYQs0gKTauSgWRxQyD1MoJ7EobBpSsl0jgiLQwzj4eyRkCWaBj1VfDpVao0K7ZGD/CrXPyWQ/q9Ld2tvgoRespfe4w2QbhT2gHmXUY+gtDNwBhkn3sb1O5N+hbJwjOY2FczysEmEuaNiVBNOzKMlXIz1iVnLhr+BZlc0x7CGqyVJFohnNK2vzhPIJM3XDn1djJBXRNA9Sd4OExGFsDTBXBWkkCGD2+UnYNOYkrFK8is9EhCgi6tiOqerHAdY0QPlxoDNTgD+3TjyvFQYk4hJbHBBYuQM/efOLB5YP9j/go+X1FA0R0saeIZOCD2MM5Y4j2cMy6fsNcjEoPGalr7s6we9mP5hLfRCZVm5yglqP7ZYQloMVSGNbr5w1dH8tqKsuIjr5aHsWAELqXtcIi1/xT5V1HpVY3mstXQeWyRxMTo3aZyjzExALIwDhPhQKwvg1n4TfHkxZjc4YVGjJ8dLmiy54U0bgAHo5utHhdfPpjE+7MLJ6X2OhW8vA0uk2YsZWnvuL9tkOu6vux/Lj+o9kRmIeS+h4jFdTMrRHOh8cedduByP1sSYGAftBkx/DQe+UmCbKv3HgVFd2JjXCsjf5u7YFk/JGiuNijoLv1oug==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9507546d-3b7d-421d-9295-08d858eb7fe3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:19:36.0793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VB5Bkovnv+z6CcQxanCxeCDDL4Ecm8vSaVpWUo+ywkuAXCUMfGCmgOxdCu8t4+alEblg3bspau7oflspReQBvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Typically under KVM, an AP is booted using the INIT-SIPI-SIPI sequence,
where the guest vCPU register state is updated and then the vCPU is VMRUN
to begin execution of the AP. For an SEV-ES guest, this won't work because
the guest register state is encrypted.

Following the GHCB specification, the hypervisor must not alter the guest
register state, so KVM must track an AP/vCPU boot. Should the guest want
to park the AP, it must use the AP Reset Hold exit event in place of, for
example, a HLT loop.

First AP boot (first INIT-SIPI-SIPI sequence):
  Execute the AP (vCPU) as it was initialized and measured by the SEV-ES
  support. It is up to the guest to transfer control of the AP to the
  proper location.

Subsequent AP boot:
  KVM will expect to receive an AP Reset Hold exit event indicating that
  the vCPU is being parked and will require an INIT-SIPI-SIPI sequence to
  awaken it. When the AP Reset Hold exit event is received, KVM will place
  the vCPU into a simulated HLT mode. Upon receiving the INIT-SIPI-SIPI
  sequence, KVM will make the vCPU runnable. It is again up to the guest
  to then transfer control of the AP to the proper location.

The GHCB specification also requires the hypervisor to save the address of
an AP Jump Table so that, for example, vCPUs that have been parked by UEFI
can be started by the OS. Provide support for the AP Jump Table set/get
exit code.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/sev.c          | 48 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  7 +++++
 arch/x86/kvm/svm/svm.h          |  3 +++
 arch/x86/kvm/x86.c              |  9 +++++++
 5 files changed, 69 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 790659494aae..003f257d2155 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1237,6 +1237,8 @@ struct kvm_x86_ops {
 				   unsigned long val);
 
 	bool (*allow_debug)(struct kvm *kvm);
+
+	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index da1736d228a6..cbb5f1b191bb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -16,6 +16,8 @@
 #include <linux/swap.h>
 #include <linux/trace_events.h>
 
+#include <asm/trapnr.h>
+
 #include "x86.h"
 #include "svm.h"
 #include "trace.h"
@@ -1472,6 +1474,35 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 					    control->exit_info_2,
 					    svm->ghcb_sa);
 		break;
+	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->ap_hlt_loop = true;
+		ret = kvm_emulate_halt(&svm->vcpu);
+		break;
+	case SVM_VMGEXIT_AP_JUMP_TABLE: {
+		struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+
+		switch (control->exit_info_1) {
+		case 0:
+			/* Set AP jump table address */
+			sev->ap_jump_table = control->exit_info_2;
+			break;
+		case 1:
+			/* Get AP jump table address */
+			ghcb_set_sw_exit_info_2(ghcb, sev->ap_jump_table);
+			break;
+		default:
+			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
+			       control->exit_info_1);
+			ghcb_set_sw_exit_info_1(ghcb, 1);
+			ghcb_set_sw_exit_info_2(ghcb,
+						X86_TRAP_UD |
+						SVM_EVTINJ_TYPE_EXEPT |
+						SVM_EVTINJ_VALID);
+		}
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		pr_err("vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
 		       control->exit_info_1,
@@ -1492,3 +1523,20 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	return kvm_sev_es_string_io(&svm->vcpu, size, port,
 				    svm->ghcb_sa, svm->ghcb_sa_len, in);
 }
+
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/* First SIPI: Use the the values as initially set by the VMM */
+	if (!svm->ap_hlt_loop)
+		return;
+
+	/*
+	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
+	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
+	 * non-zero value.
+	 */
+	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+	svm->ap_hlt_loop = false;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 48699c41b62a..ce1707dc9464 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4343,6 +4343,11 @@ static bool svm_allow_debug(struct kvm *kvm)
 	return !sev_es_guest(kvm);
 }
 
+static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	sev_vcpu_deliver_sipi_vector(vcpu, vector);
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
@@ -4486,6 +4491,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.reg_write_override = svm_reg_write_override,
 
 	.allow_debug = svm_allow_debug,
+
+	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9f1c8ed88c79..a0b226c90feb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -67,6 +67,7 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 };
 
 struct kvm_svm {
@@ -165,6 +166,7 @@ struct vcpu_svm {
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
+	bool ap_hlt_loop;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
@@ -565,6 +567,7 @@ void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 
 /* VMSA Accessor functions */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a53e24c1c5d1..23564d02d158 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9772,6 +9772,15 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 {
 	struct kvm_segment cs;
 
+	/*
+	 * For SEV-ES, the register state can't be altered by KVM. If the VMSA
+	 * is encrypted, call the vcpu_deliver_sipi_vector() x86 op.
+	 */
+	if (vcpu->arch.vmsa_encrypted) {
+		kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, vector);
+		return;
+	}
+
 	kvm_get_segment(vcpu, &cs, VCPU_SREG_CS);
 	cs.selector = vector << 8;
 	cs.base = vector << 12;
-- 
2.28.0

