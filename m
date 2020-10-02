Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9902818AA
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388474AbgJBRFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:46 -0400
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:24518
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388198AbgJBRFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFiRObFpi6fJfeAQTZc7kSGruWoT9QfcT9WVEdIXbCP4lJrMjkhcAIVue/xt71OLeO+pRBG+Bep0S3qOAQdw3P5oToSCmCjpPZGOa/RUdMIQLp1aB4IdvHDlZKpEF5kydpQkfgQT6J1vxD9Q7EdxTHY1V9H1KoeFyov2XtMunDn032rEhdGmgc7ak6q+bO/kCNiy9KEG6453hcDAKdYJ3ZajL4GomJdGP1++hr6a7yuEnuAe4Fme7tFpgzynbI2GrTONOFAgV6EyDYIIjG65PoCnKa9wMSEXS874umB+TK5VEmS3konLYsmVtK+xowEbj/kkYYXAYCVS6glZ08fwqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RSdGhtk1E3mSjucVSkTyMgCzgOvGXsXO3JqUJtQD/Q=;
 b=nA6angxme2H+THIQuFm3jQ/HiXfjfxhO8FKHURuvmZRUlgYYorbiOssNG0pgf7vkUnZinxmra+wXBChII5UXMlWlfKO/H41HFbQN5TW7DAS8Sg57u8gybtMYBCW58M/sfQQ5UOGqpc4gN0MU9ndsXURYcpA+yXo65BtGIb1QBaolovh0FtNWU+2ckm/lp7zA4R7hm98lEki1j3+asfpHl1RKy4a/lMAZNdLEie3U01NwvmrQMpfuvxPbAKvTXEpERqsy0oIgLlRPsO269MwaF7EOJZNGCNz7xn+NUHTbnbdss3x+TiD43bOiVR/Q9fWaRpk5mx1rmn1oRHjk5eli0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RSdGhtk1E3mSjucVSkTyMgCzgOvGXsXO3JqUJtQD/Q=;
 b=OGNfWVjS/7ap/wML7GLKqkRSr9zUTGOwrAMWqJQEXy0pR8Dz2QrFhb7OTdUpqX9bFcpIMZBl7GnfQBmRPgrnFjJq7wn0LZNvr35h7cYuVvTbEf1DoV8g9z0OqCD8U4MXsxFWTi2Ei2fe5Yp+eL1A7ujpOE71Lnr4d+GZfE/2TX0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:05:36 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:05:36 +0000
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
Subject: [RFC PATCH v2 17/33] KVM: SVM: Support MMIO for an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:41 -0500
Message-Id: <cb24dcca6034d0412c5a10f6ac32919081c3757a.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR16CA0039.namprd16.prod.outlook.com
 (2603:10b6:805:ca::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR16CA0039.namprd16.prod.outlook.com (2603:10b6:805:ca::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Fri, 2 Oct 2020 17:05:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 290ca138-fcb3-4ed7-adc2-08d866f56142
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218686C7882ADFAF00EB1C4EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9DlewhCbmbw5p+nYnTWVyfLvpEAJ1slxgdM8tsaiSyHLsZE8V1ySz3nlTMcmEeXXIWBNzI98gSCqqDJmJCYR+rX9a67nRibn38yaQYO2wpntXBMSz6xENqQN0BM4hHfqRQDbI3gFk2xxtq/9m/0kEdVStT/T5QdMP5ADf0enQeyFeIYjS8SShTiizB6P7FepaasJzB9WNwBaDUbpU+Cp89GQ7NhsZ8fBQKSB0yxphEXZypHixyHg5G9wO59E5WRaad+lfg8hJcDdy1aBSP25Bojmp4lhGFe2aZTdZVI0O7vgT2WZWu4gfXrl0vUMZfJgcS09QIUhqtJ6c5PIy6PL6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1Bl9Ep/DQOa1K7QLuGmOjLhtitE/l8/tFDVJELpORO0mSCH3yEDygniCO6Zw9ZNSIHObsO12fcAsuXHaDV5oI7oEaFzcsN0V/uPmntpWKStkieMC8q2bF37HYDJPT3+Ed/HAILp8Ga2EwgGSBZe6vep+C2x9MpB8qmvtLgMZRS8FxX0ydx6eBgIJ5K+s/xx1KUUUY7tmPWoqZccUXMU/U4ifY3YLGS6sgtEZRJ7UPEWtbuYDYZnzqaYwB/CVeN2f0qgQzeXdfXbfTNItaYS5GQQ3tZGg2GH9E3qAHGJsbjT/l6we+m7uACBrD0UxkztTVyvh3zPuWF+3gtsp298GDcrAbHdOn5H8RPDOo2VN4+gXpaxvkiWTaHbhVZKgKnJdLidGYQR7gvbFbja1ha8F0ZMEoG537ayBMPSxT2ukWad+eq1+HMR89b8R1/cF5d0cignDtU8mXtumB7JgcjkgZ0E4EJmjXeVG9R9CMniirdB5u6XvLYGZ2NJK8ey9NkoVGJCqCt3M+mTp9Ulf8AYTZeu8iknMOKex6lGH49JG1juC9+an88LD+rAzHkwTYEQVIwN2Zv5GYv0E3nYK2vvDvxAzqKRxvNXMV7MlzxhvoPCV7mlZSnfmThV7r4YqpsBaqjAPFFYT7evggZOPFhDI3A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 290ca138-fcb3-4ed7-adc2-08d866f56142
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:05:36.0614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XAF1Cm+lBdCuQgs91JaE5265B8Ld6+lD+pzyV2a82KIssaAhIa2KSx8MKRRo0LbaLlcyD+v+PLfoRbAML0+Fsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For an SEV-ES guest, MMIO is performed to a shared (un-encrypted) page
so that both the hypervisor and guest can read or write to it and each
see the contents.

The GHCB specification provides software-defined VMGEXIT exit codes to
indicate a request for an MMIO read or an MMIO write. Add support to
recognize the MMIO requests and invoke SEV-ES specific routines that
can complete the MMIO operation. These routines use common KVM support
to complete the MMIO operation.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 121 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |   3 +
 arch/x86/kvm/svm/svm.h |   6 ++
 arch/x86/kvm/x86.c     | 123 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |   5 ++
 5 files changed, 258 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4a4245b34bee..1d287f5cffac 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1350,6 +1350,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		    !ghcb_rcx_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_MMIO_READ:
+	case SVM_VMGEXIT_MMIO_WRITE:
+		if (!ghcb_sw_scratch_is_valid(ghcb))
+			goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		break;
 	default:
@@ -1378,6 +1383,24 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
 	if (!svm->ghcb)
 		return;
 
+	if (svm->ghcb_sa_free) {
+		/*
+		 * The scratch area lives outside the GHCB, so there is a
+		 * buffer that, depending on the operation performed, may
+		 * need to be synced, then freed.
+		 */
+		if (svm->ghcb_sa_sync) {
+			kvm_write_guest(svm->vcpu.kvm,
+					ghcb_get_sw_scratch(svm->ghcb),
+					svm->ghcb_sa, svm->ghcb_sa_len);
+			svm->ghcb_sa_sync = false;
+		}
+
+		kfree(svm->ghcb_sa);
+		svm->ghcb_sa = NULL;
+		svm->ghcb_sa_free = false;
+	}
+
 	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
 
 	sev_es_sync_to_ghcb(svm);
@@ -1412,6 +1435,86 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
+#define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
+static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
+{
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct ghcb *ghcb = svm->ghcb;
+	u64 ghcb_scratch_beg, ghcb_scratch_end;
+	u64 scratch_gpa_beg, scratch_gpa_end;
+	void *scratch_va;
+
+	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
+	if (!scratch_gpa_beg) {
+		pr_err("vmgexit: scratch gpa not provided\n");
+		return false;
+	}
+
+	scratch_gpa_end = scratch_gpa_beg + len;
+	if (scratch_gpa_end < scratch_gpa_beg) {
+		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
+		       len, scratch_gpa_beg);
+		return false;
+	}
+
+	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
+		/* Scratch area begins within GHCB */
+		ghcb_scratch_beg = control->ghcb_gpa +
+				   offsetof(struct ghcb, shared_buffer);
+		ghcb_scratch_end = control->ghcb_gpa +
+				   offsetof(struct ghcb, reserved_1);
+
+		/*
+		 * If the scratch area begins within the GHCB, it must be
+		 * completely contained in the GHCB shared buffer area.
+		 */
+		if (scratch_gpa_beg < ghcb_scratch_beg ||
+		    scratch_gpa_end > ghcb_scratch_end) {
+			pr_err("vmgexit: scratch area is outside of GHCB shared buffer area (%#llx - %#llx)\n",
+			       scratch_gpa_beg, scratch_gpa_end);
+			return false;
+		}
+
+		scratch_va = (void *)svm->ghcb;
+		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
+	} else {
+		/*
+		 * The guest memory must be read into a kernel buffer, so
+		 * limit the size
+		 */
+		if (len > GHCB_SCRATCH_AREA_LIMIT) {
+			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
+			       len, GHCB_SCRATCH_AREA_LIMIT);
+			return false;
+		}
+		scratch_va = kzalloc(len, GFP_KERNEL);
+		if (!scratch_va)
+			return false;
+
+		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
+			/* Unable to copy scratch area from guest */
+			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
+
+			kfree(scratch_va);
+			return false;
+		}
+
+		/*
+		 * The scratch area is outside the GHCB. The operation will
+		 * dictate whether the buffer needs to be synced before running
+		 * the vCPU next time (i.e. a read was requested so the data
+		 * must be written back to the guest memory).
+		 */
+		svm->ghcb_sa_sync = sync;
+		svm->ghcb_sa_free = true;
+	}
+
+	svm->ghcb_sa = scratch_va;
+	svm->ghcb_sa_len = len;
+
+	return true;
+}
+
 static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
 			      unsigned int pos)
 {
@@ -1549,6 +1652,24 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 
 	ret = -EINVAL;
 	switch (exit_code) {
+	case SVM_VMGEXIT_MMIO_READ:
+		if (!setup_vmgexit_scratch(svm, true, control->exit_info_2))
+			break;
+
+		ret = kvm_sev_es_mmio_read(&svm->vcpu,
+					   control->exit_info_1,
+					   control->exit_info_2,
+					   svm->ghcb_sa);
+		break;
+	case SVM_VMGEXIT_MMIO_WRITE:
+		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
+			break;
+
+		ret = kvm_sev_es_mmio_write(&svm->vcpu,
+					    control->exit_info_1,
+					    control->exit_info_2,
+					    svm->ghcb_sa);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(&svm->vcpu, "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
 			    control->exit_info_1, control->exit_info_2);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index db821f70e561..ac5288a14f18 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1392,6 +1392,9 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 		}
 
 		__free_page(virt_to_page(svm->vmsa));
+
+		if (svm->ghcb_sa_free)
+			kfree(svm->ghcb_sa);
 	}
 
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8a53de9b6d03..386b6b21d93a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -171,6 +171,12 @@ struct vcpu_svm {
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
+
+	/* SEV-ES scratch area support */
+	void *ghcb_sa;
+	u64 ghcb_sa_len;
+	bool ghcb_sa_sync;
+	bool ghcb_sa_free;
 };
 
 struct svm_cpu_data {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 61fda131d919..762f57ca059f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11152,6 +11152,129 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 }
 EXPORT_SYMBOL_GPL(kvm_handle_invpcid);
 
+static int complete_sev_es_emulated_mmio(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+	struct kvm_mmio_fragment *frag;
+	unsigned int len;
+
+	BUG_ON(!vcpu->mmio_needed);
+
+	/* Complete previous fragment */
+	frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment];
+	len = min(8u, frag->len);
+	if (!vcpu->mmio_is_write)
+		memcpy(frag->data, run->mmio.data, len);
+
+	if (frag->len <= 8) {
+		/* Switch to the next fragment. */
+		frag++;
+		vcpu->mmio_cur_fragment++;
+	} else {
+		/* Go forward to the next mmio piece. */
+		frag->data += len;
+		frag->gpa += len;
+		frag->len -= len;
+	}
+
+	if (vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments) {
+		vcpu->mmio_needed = 0;
+
+		// VMG change, at this point, we're always done
+		// RIP has already been advanced
+		return 1;
+	}
+
+	// More MMIO is needed
+	run->mmio.phys_addr = frag->gpa;
+	run->mmio.len = min(8u, frag->len);
+	run->mmio.is_write = vcpu->mmio_is_write;
+	if (run->mmio.is_write)
+		memcpy(run->mmio.data, frag->data, min(8u, frag->len));
+	run->exit_reason = KVM_EXIT_MMIO;
+
+	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
+
+	return 0;
+}
+
+int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
+			  void *data)
+{
+	int handled;
+	struct kvm_mmio_fragment *frag;
+
+	if (!data)
+		return -EINVAL;
+
+	handled = write_emultor.read_write_mmio(vcpu, gpa, bytes, data);
+	if (handled == bytes)
+		return 1;
+
+	bytes -= handled;
+	gpa += handled;
+	data += handled;
+
+	/*TODO: Check if need to increment number of frags */
+	frag = vcpu->mmio_fragments;
+	vcpu->mmio_nr_fragments = 1;
+	frag->len = bytes;
+	frag->gpa = gpa;
+	frag->data = data;
+
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_cur_fragment = 0;
+
+	vcpu->run->mmio.phys_addr = gpa;
+	vcpu->run->mmio.len = min(8u, frag->len);
+	vcpu->run->mmio.is_write = 1;
+	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
+	vcpu->run->exit_reason = KVM_EXIT_MMIO;
+
+	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_write);
+
+int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
+			 void *data)
+{
+	int handled;
+	struct kvm_mmio_fragment *frag;
+
+	if (!data)
+		return -EINVAL;
+
+	handled = read_emultor.read_write_mmio(vcpu, gpa, bytes, data);
+	if (handled == bytes)
+		return 1;
+
+	bytes -= handled;
+	gpa += handled;
+	data += handled;
+
+	/*TODO: Check if need to increment number of frags */
+	frag = vcpu->mmio_fragments;
+	vcpu->mmio_nr_fragments = 1;
+	frag->len = bytes;
+	frag->gpa = gpa;
+	frag->data = data;
+
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_cur_fragment = 0;
+
+	vcpu->run->mmio.phys_addr = gpa;
+	vcpu->run->mmio.len = min(8u, frag->len);
+	vcpu->run->mmio.is_write = 0;
+	vcpu->run->exit_reason = KVM_EXIT_MMIO;
+
+	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_mmio;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 3900ab0c6004..65396753b6ab 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -401,4 +401,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 	__reserved_bits;                                \
 })
 
+int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
+			  void *dst);
+int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
+			 void *dst);
+
 #endif
-- 
2.28.0

