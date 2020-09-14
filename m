Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30139269646
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINUVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:21:11 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbgINUTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:19:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksmjwkWOn1NZrt0n+JwbyU4XADR+wr9R8oWSHf8EIpDnsEI9OK4cWYS5xHSUU0tq3ugr6T2h16OR3FmGJHwWfTtX/q57Z4PYXn0ArC9rYwl2a5n5ksdL4cZtDzpxCqrmK6XgjYUdQU35ImZ7pbLdvjx61G4NkoFJ/5edvD0kIpAht0i6iZcir11YkpL/yEkwOlE4axe8L299ZsMoDFCvKNx/SUBLsbBlA9u2PCKFqavHYyyl4RPnjNOJ9qlJiYZ+cAmd/n1XnjmBL7pm5Wfsc2EYhTdbGXUMhvifRX5YhrzgGtVJfLx6HsBx1pyQZgilR5lokaXo92yPdYNhgozHzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROl8OqG52lq9mjocY9K85fWvKzIccodatAaa6DCpOjY=;
 b=X2eKfZKdPNMA/d+e13uHw9eYLJOIpJ4shXAtZd/oQ2bB4Z685I8dBgO24SOu08UxeaT53mre53mO2n64lhPnYjHS7iM/k9GO7qNLRP1VoGVh/QXz5AUyivewSkl5sLBC1J0jcrwTCvkGi1+FUv9arvPw+9UUk11JwxxovbWZY8YzvdX8P0L6PkWW/jb09tKgh6eVQbJyXqRU1PtModH0QMLfTNYYmg4URg1CIw6xvwLPxt2QpnkvqWWetk8C9/krowVCrrtkkiCdyKy+59rQ9Yagaie97Orh/M/gTqWHQHAycPquEK3IGQVL5R+Ja6BEhmk5Cus2ieqGvPxg7Z7hZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROl8OqG52lq9mjocY9K85fWvKzIccodatAaa6DCpOjY=;
 b=IOi8TApnBg5IB2OpsotviAK+laN3dakxoSgVQ3YgsOkZfe54/mUDW+tHYM0vXNJQU/dvnH6Rpo+7kVfG+cWFoa6QlD+adr/TcKmsgfaCar+dEor9LMkCNxjfXB/GY577rwq7cp+HgWEfN3dJSOEG4Z90hc5U/OyolZXz3L9Y/ZI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:18:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:18:22 +0000
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
Subject: [RFC PATCH 18/35] KVM: SVM: Support MMIO for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:32 -0500
Message-Id: <a452d49276bc7dfb41c300cd2abde198400f90ac.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0003.prod.exchangelabs.com (2603:10b6:804:2::13)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN2PR01CA0003.prod.exchangelabs.com (2603:10b6:804:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:18:21 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba570b8f-318d-467b-007c-08d858eb53e1
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11635CC6175447AF89B724C6EC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F2/l0HR+oP/dMDkAIo86luoCU2SAJzRNjoevR6bsH6Ghbx7OwV8ZAaH0oWYME/oFMOI762EZ4NS97eyJUkiE82qI7mwc4ap+F/Grqhwu225hMQ+4yY2tTjFLogYu1bDgEgqJKv7kVr4Aopb4eM1E5SbgXB5NR2wAy3coFVwyICFLPUZhY1ONJeagwyyYigvuCNvEu4SKGHS0oFwao2VTU8mYyFtM+pDoliZf6Fa0sFaWBpV78m2zhrl3MAd2wXcCMMNh0q3m9ZWM+caBxy+ZldkczXJXzMYb9GAlb13m/a95ky8/En0lxGmyy4c9+5sg5f5fJ7JUcznf/5nRHZgANg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZDhWMO0dcQKZHQlbQ9Sl6Mukb8SxvaglDQZfJ3CQA4YMmU3tbyJlKTLhz1tLPw3Ak1Iv/cCwjE6307GTBQSy2O1bV0rUUTUxbyNAMNCYeeFXU9VL7kWJSprvc/IyMzqib/v2WcxVx9D5LatHlnhaZXtwpLM0LiJ2lGA6yEVDXNKguWBQbtsHlVI3hCvjYe6+ctQtXGHMS7mPswm11IPZNWx4eBYD4uIV6sQsaecHx+NKRxTpRBROdqhqL4Y5vaAoePe1io3OOzzEYD6uKNf3e2mIkVx2DuCrSKS8rijRffw3MPADf5foUU69K0tS2j9mVRUyAn0xWHP5YOMi39cz39O9ISsDcM/2MpjKRzQXb0Y2i9EYpDlq8lfgbnxVlCZiD2oqCMfTNGPxLyy4JkJQizipKjgtiQGZQ1+KHvO39ZXBkVW+a53NJoA7qELFOILqgZh1XQ9rIoKjN4L0uOdfaMz1tzu2ld44JtoH8tQLHibyXB89yS6VsYEZSCwcdJJmC24vCkaD2MkZ5W5lUiPZoj759xPiUR2En71Gtj39+fYyLbUuyX03/Jq6gEtfV/VhCF6V3P1lxnt32Ld3uWA7/wHHnzjuKFRDHHaXVjo5WdsLSs8yLoyHgYKhJdroyH4NcIqs2jzZN1O+oCaIgAlq4g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba570b8f-318d-467b-007c-08d858eb53e1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:18:22.3267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Pbr5CglFpOPzeYpM/RZ7ssziyS5zCrQ1oy9gowwh/FD/ndWb3d3A4FYSxNtqTKzO7PDiOF9q0LMrFAWEhtj2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
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
 arch/x86/kvm/svm/sev.c | 116 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |   3 +
 arch/x86/kvm/svm/svm.h |   6 ++
 arch/x86/kvm/x86.c     | 123 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |   5 ++
 5 files changed, 253 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 92a4df26057a..740b44485f36 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1191,6 +1191,24 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
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
 
 	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
@@ -1223,6 +1241,86 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
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
@@ -1356,6 +1454,24 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 
 	ret = -EINVAL;
 	switch (ghcb_get_sw_exit_code(ghcb)) {
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
 		pr_err("vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
 		       control->exit_info_1,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 89ee9d533e9a..439b0d0e53eb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1306,6 +1306,9 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 		}
 
 		__free_page(virt_to_page(svm->vmsa));
+
+		if (svm->ghcb_sa_free)
+			kfree(svm->ghcb_sa);
 	}
 
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3574f52f8a1c..8de45462ff4a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -165,6 +165,12 @@ struct vcpu_svm {
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
index 2a2a394126a2..a0070eeeb139 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10768,6 +10768,129 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 }
 EXPORT_SYMBOL_GPL(kvm_fixup_and_inject_pf_error);
 
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
index 995ab696dcf0..ce3b7d3d8631 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -398,4 +398,9 @@ bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
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

