Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B672AC87C
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732324AbgKIW2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:28:48 -0500
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:22273
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732072AbgKIW2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:28:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWr8g0Q6901khQPBM69ntJ7n2o4apNJqnNESw0fcMbw3VwFc9RXZiDrtDZEMMqoSSa6ckkFUEkMmssPfbGFI4JwMxQbtVK0QdPNLGlSGcH2SrStYhDdH07jCz8hJ0kOzQdb8Nfw+u6JavAcjYLH7Yw769NbUqNpGXmYNdnLtB4IQi8SU/B8rsihAJOiKM7PGWKligedEi9rJ1NuJGgd4IYslPCRy2RkcH5yB5ug99XsF/STfjL8fKyZNMTQAd4c8kCpYYR2DGEgilig9Rsis3ktA00c+qmtqWUq/iy97zYepus/exyJQfzp5Eb+tZy2GxNU+rQDM+rt70J3Q9bBoTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkY2UGjlaNsVOb5A0K0psW6mieYB4B1Qm7F7XCUjrXY=;
 b=QGm25+oP3AheN1cDNn26fGsQy/xPvo5HP0ZDB4BfD8Na2oACOCqv2R1X2EfwLfP3iInNBIYxDKObqKU1gvUc5aRTm405RHlY4rr3PiHwDv6kBdYQRRIsw9w2z/qFIIxby6shI02C8nLxg2aKprom98uwP4spn8MfkijXQWoUjZmNuXzn77Y9q+6U+NCUNvygjeVytOT+2gUTIHPJL3jGiLNoZUqTsIWmgYkHACQ+nkSFg2NgTFIkJqI63i5UqbvDIvKZjWajKTmhMMUu2WnZs309nqzAT5EInK4ylbw702aIPQLWz/eNjXAeOQbAgsz+Xkm1ITTivahyVRCrpP0A2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkY2UGjlaNsVOb5A0K0psW6mieYB4B1Qm7F7XCUjrXY=;
 b=qx5IdBoU6JLBwOr044xE15KFGhAKAn4Nb/vLIxP1eiBHlhgQQzlb07aGJ9L3zi4Fl2v36zNlXivdshNXWW7fpJiG4wDa4E5dK1FI7k3AHh6hee8pXD+sgB0bhnAs6JjMolLxPLQb10f68ou+4eeNx0gvc/To83UZ0HOj5M6ZgxQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:28:44 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:28:44 +0000
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
Subject: [PATCH v3 19/34] KVM: SVM: Support string IO operations for an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:45 -0600
Message-Id: <025af5b7f25029bca6d1f7476fc234aacc776bd8.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR07CA0159.namprd07.prod.outlook.com
 (2603:10b6:3:ee::25) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR07CA0159.namprd07.prod.outlook.com (2603:10b6:3:ee::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:28:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c56752e4-461c-431a-13b6-08d884fed15c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058ADCA01F70136829F568EECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jx4sBlB99emGI3UzPWK7RJJ/ybtXk6sbs1YyAPBnJbaRAioFmpTFi848EyWiGFevbUlACG4JjlfoYuG480IMg/SCaPKwuoSBtpJqNqgWoGXBOykiDjLQk+6l3M5s0Mi7s9/xLEluxpE3pChoLZA9xomOmEP+t/zjJfSPNQN8sEZX4jAyqXLrlNHa9/tTWD2kClVVUuzjTUnnPwrxMO/O14tnObVzORajQNOcCgnPXdcP901wdpdsiVpQMriDB8foynTFJj36hohYpNdl/WUJmyRwCN3UwTHDnanXu7JW7nOlfM4fDjiOExtG35B00WEa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MKozGPxuEao52vDfbNr9A4nrKDGMzuP51M2wXAI9wrO/g9KxHMUhClTKUnxNxyN3/IHeTax2JHejwmfn2SUzvEvFXLavI+t6PIpqiUHcM3DzeCLCYle9QK6vN+WJTKoIf1wjYNAZvU51DKIYl2IWW/tggabIgNYZ2pgwh60g8OBmHjehTFR9Fa5YkqgOffhyk/955dqMYjaGWgfSYgiOnxFE/vGwcmdOuB+0GGb0Hoyj3euYtGSkguRrL4MnUrF/YAjyBA9S7+T7WSbLK9eY/bSoqFKcaf18YlzqHDu8XKydiQXErDFq2iT/kM6xEILeGw4cCZs1qvBXy3tneL0/zkwq2t6HLh0/ecJN+pHc3ZR2usyU8IBspUvUqv4XdaEWNx4mmzAuxdwfuaaskrUNti/qTUwrrFDXjWLp2jhMOS+aN2Ca/M11SBrGAM/g52FamKYWSLDG6XlNJfJp4egLqRHwilrWX8K6hPHDl9IlgEBs2qG3aJXW8upbZ4GMCiX0H699ahsoBxWLyzAPtnjmL3uJU/HqJtBOryuQ+FBk+raJLYOQv17RMS12hKZzySnykNUKO/WUvasSEYm1e4KM1Iy/m+//O/jPXuA/5p2ttKb5GMWMOps7l1A2xqsIZfKSA9G0YRkPNhU8/QaytbI4/g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c56752e4-461c-431a-13b6-08d884fed15c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:28:44.3546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qECIztLE+V6s+MYnkydOCIuHIk2CP77PMDbxeHDGSzyoO2Rd+3w3Y4J0Q0r6eeggaD6yYDmvO04yYTKNeliS7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For an SEV-ES guest, string-based port IO is performed to a shared
(un-encrypted) page so that both the hypervisor and guest can read or
write to it and each see the contents.

For string-based port IO operations, invoke SEV-ES specific routines that
can complete the operation using common KVM port IO support.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 18 ++++++++++--
 arch/x86/kvm/svm/svm.c          | 11 +++++--
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 51 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |  3 ++
 6 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7776bb18e29d..4fe718e339c9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -614,6 +614,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_pio_request pio;
 	void *pio_data;
+	void *guest_ins_data;
 
 	u8 event_exit_inst_len;
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9dde60014f01..75a38dbebe79 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1403,9 +1403,14 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_EXIT_INVD:
 		break;
 	case SVM_EXIT_IOIO:
-		if (!(ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_TYPE_MASK))
-			if (!ghcb_rax_is_valid(ghcb))
+		if (ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_STR_MASK) {
+			if (!ghcb_sw_scratch_is_valid(ghcb))
 				goto vmgexit_err;
+		} else {
+			if (!(ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_TYPE_MASK))
+				if (!ghcb_rax_is_valid(ghcb))
+					goto vmgexit_err;
+		}
 		break;
 	case SVM_EXIT_MSR:
 		if (!ghcb_rcx_is_valid(ghcb))
@@ -1772,3 +1777,12 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 
 	return ret;
 }
+
+int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
+{
+	if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
+		return -EINVAL;
+
+	return kvm_sev_es_string_io(&svm->vcpu, size, port,
+				    svm->ghcb_sa, svm->ghcb_sa_len, in);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 02f8e83df2d3..fa15223a2106 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2054,11 +2054,16 @@ static int io_interception(struct vcpu_svm *svm)
 	++svm->vcpu.stat.io_exits;
 	string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
-	if (string)
-		return kvm_emulate_instruction(vcpu, 0);
-
 	port = io_info >> 16;
 	size = (io_info & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT;
+
+	if (string) {
+		if (sev_es_guest(vcpu->kvm))
+			return sev_es_string_io(svm, size, port, in);
+		else
+			return kvm_emulate_instruction(vcpu, 0);
+	}
+
 	svm->next_rip = svm->vmcb->control.exit_info_2;
 
 	return kvm_fast_pio(&svm->vcpu, size, port, in);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f5e5b91e06d3..1c1399b9516a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -572,5 +572,6 @@ void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
+int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe9064a8139f..5f1835cca28d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10757,6 +10757,10 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
 {
+	/* Can't read the RIP when guest state is protected, just return 0 */
+	if (vcpu->arch.guest_state_protected)
+		return 0;
+
 	if (is_64_bit_mode(vcpu))
 		return kvm_rip_read(vcpu);
 	return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
@@ -11389,6 +11393,53 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
+static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
+{
+	memcpy(vcpu->arch.guest_ins_data, vcpu->arch.pio_data,
+	       vcpu->arch.pio.count * vcpu->arch.pio.size);
+	vcpu->arch.pio.count = 0;
+
+	return 1;
+}
+
+static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
+			   unsigned int port, void *data,  unsigned int count)
+{
+	int ret;
+
+	ret = emulator_pio_out_emulated(vcpu->arch.emulate_ctxt, size, port,
+					data, count);
+	vcpu->arch.pio.count = 0;
+
+	return 0;
+}
+
+static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
+			  unsigned int port, void *data, unsigned int count)
+{
+	int ret;
+
+	ret = emulator_pio_in_emulated(vcpu->arch.emulate_ctxt, size, port,
+				       data, count);
+	if (ret) {
+		vcpu->arch.pio.count = 0;
+	} else {
+		vcpu->arch.guest_ins_data = data;
+		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
+	}
+
+	return 0;
+}
+
+int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
+			 unsigned int port, void *data,  unsigned int count,
+			 int in)
+{
+	return in ? kvm_sev_es_ins(vcpu, size, port, data, count)
+		  : kvm_sev_es_outs(vcpu, size, port, data, count);
+}
+EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4a98b1317cf4..f46bb286def5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -411,5 +411,8 @@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 			  void *dst);
 int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 			 void *dst);
+int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
+			 unsigned int port, void *data,  unsigned int count,
+			 int in);
 
 #endif
-- 
2.28.0

