Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCDA2696A7
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgINUa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:30:59 -0400
Received: from mail-dm6nam08on2041.outbound.protection.outlook.com ([40.107.102.41]:6432
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726200AbgINUSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:18:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZ+0qPbuZakviUONZVMXN/4UYBoQhfYx+GHkNegErPsrpmwM2xXsKKJGWv6VWs/QyJCYOgRf/QDNkaOM5JBg1Q4uuN9/DBpJSdj3BpK0/0P5Z0VzlMBUts+CO8K3sLA4dsV/+nwBBvUzwfIVYL83Ex8a/Qjqwq/gwMK5r/HM/CzmUzavUKBQ5+wSb5ze3CEcGzP7gVJXdCXeF6tofclgUijiA1dPFSRWekOIK9NS2BuIO4T42iQ03MC43GDds7XscEZk2k/f7l1sEL5gYTphqBe21nQOrDOcYC5CpZB3dggS2C+dB5hVDOtBuwsPbxn+WmBRmckB2DV0HjbV8/19zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPegZH37cYRnzfVJGxloOF3Y7RStiMNMLoXqBhqhCvQ=;
 b=bG9mVKcyMgl5qM3G+A2vWOOJ3o2COZvEpGHGLgBQRCHzxFLiclsmuelD890ogdMQjW+ma7ERKSDuMv5xiVDXCGJql1Ti6bWya95fkfO9IPwiSRWp/XyI4grk5YWgqiRVylM9Z749JkFs3hDayg3kuDzwHeEyCM0PRaZIRUYd3uDr+wZ16pnKD7KQyNIo6BXbwKBCZDT1st0M2GHztuNDPBnAY2yFTgKf/KTwwk3ifT+GqP5NuKWHwSiWtdtT5lnaJKUsiSqJ4IAPCTBIAsIMwWYNwiqmf+YHThMC9l0RdcPp9qutUXAoV/5VhtiLlJQZz7RMu3K7Ha3B4cDtrqcJng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPegZH37cYRnzfVJGxloOF3Y7RStiMNMLoXqBhqhCvQ=;
 b=AEksWau5/XlVonur8AcLZUOMFrjXnmIDHfTddk472cD9bSuflHely+8qxBQEmzxcJRYS3TlTboiDkFMAbth1A4y//S7f7Cx8EEt56raE5ln7fR8KGtxKVOhrT06UN8HUNFH7fd6Jsgulf2skssjYn5Aci6ds+mPESAazynAHrUE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2828.namprd12.prod.outlook.com (2603:10b6:5:77::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Mon, 14 Sep 2020 20:18:30 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:18:30 +0000
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
Subject: [RFC PATCH 19/35] KVM: SVM: Support port IO operations for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:33 -0500
Message-Id: <6f7e098b00172c2ae9a9ada9224fa4e8a8839cc2.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:806:20::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR03CA0008.namprd03.prod.outlook.com (2603:10b6:806:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:18:29 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4065fd22-fd22-4f52-0377-08d858eb58c0
X-MS-TrafficTypeDiagnostic: DM6PR12MB2828:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2828D391890B8DC9945EE68FEC230@DM6PR12MB2828.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ty6+6tc2CryEcVDwkBMsdkaKpdqtznYm480LFSvt5c0DlSmjve7/WKzIyhEaGq0LyPcxvHLr3XSFxc36LKRxKYrNjsxb4x2V+VnSL0ISdZCxOcjlch8nFin53lGUbN/3eYMCkJjWUQyyjYz6h1WzcJD73X4OG7I16vRbw2DmsRD5+10gl7kkzWgqxCOEUaTP6DJung6DkWIKLvkG1WYnHjkVMBxgM/giRLSe2DN4HZSM7OHErfpP4io/A1BYGWLBmBeLV+DwBbjDwgVBcAjlGz189s5PFczPLN2KrnD3yKb0rjUg7lSJ57J5YBPbAVF6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(66946007)(36756003)(5660300002)(86362001)(8936002)(8676002)(66556008)(66476007)(7416002)(4326008)(956004)(2616005)(6486002)(52116002)(83380400001)(7696005)(478600001)(186003)(26005)(16526019)(316002)(6666004)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VLOS9ylVarGbB0AW0NbmdzTX2byWwZ3d8E3vgpi9rpOErQreRaQeUEXu7JqnVoQ7HnrtsbrzypsjlVbV0axdSX2SIn3foifXpBL01j3EPf+D+7s3NIijHxkoLVdqhVfNSty4ZROyunKhoJtOYcQur82tQpAdufqDec7wEHDBG9n+iGhhE8nJwwrM5/92N//6xfPDzQAVS/q7X2ZcdSLbpuZbDySbbQxcyf7adSnTiWjdczGdDuUqqDajjVHogi++JQEY8NgYhMNsUoIfQpb0VB47fOUo6X7ebb9zIZZnhzLbI95GAruJf+2F8u0Vt9fd9x/1scuqsn0jfIUcNf5WMi3Wx0h5RxGfoAGfUz39rJ9IK8D1twp9Z+AfyX1YylMu0QzyL5+Fwv+0Pg+9/TB1PsZMg5p/wVbEAmB0Ywvnwyy9ouCj5mo8uahFFDjCgz73SRXIyizQ6UzoMi1BEEhlseSWTzv8O6vENaObeLIIPwsi1fCMUaZgf4LEdPObIckSuAlw2NdYF8Dg1Pu538P6g4RZMAZU1NcMRdAbLiUIkgKV0hW+y/MKQ0/SOYVEmoS3Smw1YE/DfbLRJP7m/pIhn4wrUq+UOXfNnwHKMuVmudwi4J3f2769ymg73q7dRb+R0yt11OhI//upMv6iOGwvTA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4065fd22-fd22-4f52-0377-08d858eb58c0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:18:30.4122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x6DSFT13hXQpQDov9/yz5UZDSHa0V4Y9Mh6ep6svu4kdAO7Tks6eGTZLlV17lKMVrU9Lr+CtTgnXmsnEHM9TbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2828
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For an SEV-ES guest, port IO is performed to a shared (un-encrypted) page
so that both the hypervisor and guest can read or write to it and each
see the contents.

For port IO operations, invoke SEV-ES specific routines that can complete
the operation using common KVM port IO support.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          |  9 ++++++
 arch/x86/kvm/svm/svm.c          | 11 +++++--
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 51 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |  3 ++
 6 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e2a3d2a8ba8..7320a9c68a5a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -613,6 +613,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_pio_request pio;
 	void *pio_data;
+	void *guest_ins_data;
 
 	u8 event_exit_inst_len;
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 740b44485f36..da1736d228a6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1483,3 +1483,12 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 
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
index 439b0d0e53eb..37c98e85aa62 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1984,11 +1984,16 @@ static int io_interception(struct vcpu_svm *svm)
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
index 8de45462ff4a..9f1c8ed88c79 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -564,6 +564,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
+int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 
 /* VMSA Accessor functions */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a0070eeeb139..674719d801d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10372,6 +10372,10 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
 {
+	/* Can't read RIP of an SEV-ES guest, just return 0 */
+	if (vcpu->arch.vmsa_encrypted)
+		return 0;
+
 	if (is_64_bit_mode(vcpu))
 		return kvm_rip_read(vcpu);
 	return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
@@ -10768,6 +10772,53 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 }
 EXPORT_SYMBOL_GPL(kvm_fixup_and_inject_pf_error);
 
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
 static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ce3b7d3d8631..ae68670f5289 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -402,5 +402,8 @@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 			  void *dst);
 int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 			 void *dst);
+int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
+			 unsigned int port, void *data,  unsigned int count,
+			 int in);
 
 #endif
-- 
2.28.0

