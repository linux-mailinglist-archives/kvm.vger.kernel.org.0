Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93F52AC87A
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732278AbgKIW2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:28:42 -0500
Received: from mail-bn8nam12on2051.outbound.protection.outlook.com ([40.107.237.51]:11553
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729807AbgKIW2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:28:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ol/gTmuffdfazxYZ57EvkdRTbu7r/f51t4UP49MLQtD8Gv3hru69mpalJ6eMdGADVU5glyMotAArQwT0zWmbSzPTz2OCOvGQCRT2y7Zq0u9tWEeDsa2MTx7SCi+kAAk7vRwP/hsEckRVlBHt8XQRWgltomjQxXH9XoQIGf8WM+wltfc4fKc3JGoIFXIxj6jwZtS6MVh+VbqN7zh+kgl1SYW325S1EqtlOmu9qIo784BfOJ4km1ctFM4rGHwWfxMTNeooBd3daa8E5rlEMjJNSlA1qlbFmNFbDJyLvRmesyPh5Q89++FwvJVF/fpBcFvfG8w64YHq4lg+OwzWpTPsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1K+7rq30chhAzaB3vpwf0/gYVkVsktdkq+Wskh7yAw=;
 b=Wi8YLAFO6MC+do9x/iF9u55kMrIXIZhyTljbhUdIQdIq0Y8QbDEaK5fs8WsJhM8KSvzPuIEp1mJJgZ7lBzcXGdzu02uMhIPwhS+5jVqUCAZm9OIkHV0Id5SU0zIX+cKtAGEeVTRCFL1bC/ZQ2yY9vGV5W99jc3vaEJG1Q3xkURKLqNngrmrkUBzUvyyX3S/jLQcDoYOT8BJXJN6Xa5CyUulZwbybbpnGbHkWUlLgpX4zduqfgdGv8PdKHFTg2dehj1UJnhNRlu4SbU2Ot1WBPnXjGMPFGzhkiUZNAEwlMhdUo7FHm1RnIy5XXbMcyr4w0Tjr/PwTD59lgRp3tpJbFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1K+7rq30chhAzaB3vpwf0/gYVkVsktdkq+Wskh7yAw=;
 b=jjZTTmLMiIMVMjcvPFTsY3yWMC2Gojb+1fDfAUxpoDWQ2tVUPCmvd//2pQCts0eYRsXFwQROVWVBXcFQQVBxSHz+lMTw89CwyMhUr6wCR4mfbexnpzwlkAsxxr4IoC8O8KAjysvUcgfdJwUWkEQS++Y2aMLOYcDijZ+vr6ooogs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:28:36 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:28:36 +0000
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
Subject: [PATCH v3 18/34] KVM: SVM: Support MMIO for an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:44 -0600
Message-Id: <14df7f0d13078d89ded996231a057a14d3a8e956.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:5:334::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR04CA0013.namprd04.prod.outlook.com (2603:10b6:5:334::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:28:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 056a3f5c-de5f-4c98-1b8e-08d884fecce1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40581CCA7F33DBF02BE72DF1ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: En4vvhiyPRPPgGsaAhYeSMNcsaX48UN6C3srDKNOR/u6ki3nM0e8DmEX7nSULqTMBpjbamxJEpSsX8yG7UMq9MqYyyvinadDQPLFIEnpNxv/tNTJJMtMwIFzrfuLpfTuAQrJV1EBltR5rBmkUlCR6vZYdAiKkuyBj8HWjxTRSTwnjglbITRl4zAQeVFYzlBfCFFjqWK8FGxkk0Ddi8op71ylKpJOFVEN0bvpx9K7BQEEbIi5/FUUaiGfg1+ChGJjsS79/NlRlz+S4OSqhlrgCnE208UGI1vbZBNphXJRDJw41YIGTaXTViTxpDU+zRs+DncRTXX0tgDNIPR20Hu7Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bMNQrRZrF9YZ8v3UdLX56lcwKOcHCpqbKFwts4khItLZjFdQUP6Qj5+fQ7tTNxRL3aw7BCRV9ignVwjJO94J8yJ97xZPxlg0aJh2J8Y+A9Js+O4C/H0b0m65RYk2bgq/hh+kFkLiGNBs6ZoDM1SfmneorZBbQ+JpV3MYM0d+2q5RpOSjxzELOuRcBAVwWZYPXRAEvCFOrzXmecneKOmxtlKg/Z7G5OBcj9mcOZ6WWLCEdbDZS5I2f8b2SIc8QXPXdgGdrs9METiz4/l4dXWNzz3AuVKZ0gyKqpH9i3HyBzi7+2oVwXjR2bpsrJJ0mLmwbvX4i5prZ142fJ9gxtEVcBL36MtnhRZC2N3F5h/kOFc6d/buasA7ak6ys5XgAjxD8d8AG/tSFOUYuRXObpYEEI2uv4DazTxw2BgHUwVdDbh7eF6Dqn2oOQdjpBL1qhz1Cwjwmi2glM1kX/PPvDiKE3F4NmO/p/BlRqXMwK6ipUEiWgDWolBmg6M7vZ2vFdkpDdPhQSQ+9RUjtcgI41oXlUABkXh51BlyleSy2ZE4/YM9NLAdW/0gozWuU0j3XQ7xL6BiDBspE/t7OBldQ3jCGRRMU4Y9aBCnupIr0XVVdzI4iSurtns0zdCSQN2l+LcT059oKUPDLYANl+ALeULR2g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 056a3f5c-de5f-4c98-1b8e-08d884fecce1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:28:36.8798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: auZ1sYagabnP7g28pcw7iFCIdxvK5mMheHyiP0RPtmOHJBn4zbLXBFpBb/aBXGWNagghPXcX1jyQiGWB6j92LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
 arch/x86/kvm/svm/sev.c | 124 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |   6 ++
 arch/x86/kvm/x86.c     | 123 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |   5 ++
 4 files changed, 258 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 50081ce6b0a9..9dde60014f01 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1259,6 +1259,9 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_guest_memory(svm, svm->vmsa, PAGE_SIZE);
 	__free_page(virt_to_page(svm->vmsa));
+
+	if (svm->ghcb_sa_free)
+		kfree(svm->ghcb_sa);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -1433,6 +1436,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
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
@@ -1467,6 +1475,24 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
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
@@ -1501,6 +1527,86 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
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
@@ -1638,6 +1744,24 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 
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
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7e3f8e3e0722..f5e5b91e06d3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -173,6 +173,12 @@ struct vcpu_svm {
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
index 7b707a638438..fe9064a8139f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11266,6 +11266,129 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
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
index e7ca622a468f..4a98b1317cf4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -407,4 +407,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
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

