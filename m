Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F462D6337
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392631AbgLJROl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:14:41 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392625AbgLJROZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:14:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDzRuO/b7u1qKBnt9UXBS9n2UZjmkzXZoZmx/JyM/BXKGEYQIqGun7xwFK5L4OBVHuShWPEcnzUB+qU6cyFiMLe+Z3DxRoJXP5pZlr+AeHPnQldqhWGQrzE2iK5mHTqufIWlwvQ7P9yhQfvZWCn5Bg39c6fixkcJELhKUoiyu98gRtX9HSCSd5nKNrtCQE6GilPHRgxw8a7G2vz5nOluhqKACmp8QVxqTBkrDOkZqbMKzl5fzn0RtF8+QZpohPkJSQdBdg4e5N+1ds7wQZ0BjgDXpRvBfWJReHRMyLIPUKETAovN+T2YGTFjMmAXw5jE7P5QsLlJCbr5l7G7NUw/AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82V9jjp9v0HIyZGj5zrbsWIzmq2QqzdkrE7DolSJy74=;
 b=STJMPyZCbqT/FUExIcTjqWuL603shj/oiETO5qIKpCOvjcKGvh9EpVPjPKxOgARUIIaUD/Gy51pf67cFrzaNjrQ0zser1emAfBxt8ATJEdA9f0pSn+n803zFZ+sSuhmV1zCgV3zEdf8UW+Ksytc/dQXNxvw6cgGdRvbzJH7IXg4ZPd3aZeTH26u18TWdZS3JjRPG16NJIpbjLZ3/hwhrI+VA4VIIfqfGxSTyutZ65PJzmF0jRq3NszM5qN0x+oDh3f9UVbvQjGL0HM5RDrczuBqJfFKmvZ1n9uobUZZBESsUtTy9K2YcCD/0sG27tIbQBlijY/d+pGcKkB1l+zCUrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82V9jjp9v0HIyZGj5zrbsWIzmq2QqzdkrE7DolSJy74=;
 b=aUPSWcA0fyDvv2S/vZHABuUlyGyF+4kf9lT0ttMEPTydhw8Dbb8lsuwfWEuCe/1H6zyXONs3kZUjPxmsA7OdZtTJ8aW7Q/DqxgJLpYq16uki984wmh6Hfty/hC/JrNm7PoTB2reUKpdSrn+rdfgnaerC2qS3ATMTUNV80Z7sH5I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:12:59 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:12:58 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 18/34] KVM: SVM: Support MMIO for an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:09:53 -0600
Message-Id: <af8de55127d5bcc3253d9b6084a0144c12307d4d.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR18CA0012.namprd18.prod.outlook.com
 (2603:10b6:610:4f::22) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR18CA0012.namprd18.prod.outlook.com (2603:10b6:610:4f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:12:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 204a7da3-b1ec-4141-e586-08d89d2ed7e0
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0149494DCC9B82590B80F0EDECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hj3YRX29vYNgm+VqdGV3JEs7owh1ln33dw9VhN35ZHSEEhKUie6YLigYZIPe60kM06lFJd6r2CwiWlwgB+PxgpQbUZd3fgDCoOOUsWUTnOE1ZMUoOqPeaeH0v+oi69sKUmTTEgSpCv9VNvZ6aPHCUgrzJhHpT58nKe3Lnca3FVQcK71b4hsoI5wdG1wjTtq32SkjZ0b6UIXsLPy48dYLKwmx5hmoeeAzG5Lh220JzxOuzw3GBtYLY/Qz/oq8mrPYSainoblVfYYYaHmhP3/07D8J8ELNHgZLjTVjQY7yqBWDEWPc/wNtFM1UtabIBmbukoyZxG/Lyd8DL49LIdhupDjs+IULhrpW6HdqHI3zbFZfSzMAjOv4UeujWAT8l/Xh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7a72TSjU951I8bzT+YctH7TCcy/Qt7D0uyFQqM7/b/lc5Xp3o85Tz7gKeUnf?=
 =?us-ascii?Q?YiL5nRddgAHul3uZMhdR9unxR5XIboFRwzCmGrxyk5EmhJbffoMAW3at7D9c?=
 =?us-ascii?Q?OoCrwiWrbmPHOWQlYvrw7W0+WomM7WX4a+//SY8+LqiJ7p/12gAydEzDatmU?=
 =?us-ascii?Q?5+eypOYunhsE9pEYhx0nGfV/7wd58w2WqpMW6/XgkgonLEoCJwSnsFI+QZ8L?=
 =?us-ascii?Q?05+W3BBp8J0cYeaQImesFBgDr7aOzJjTSfTJ5p0Owwxnj13Hw7W4oGarwbuH?=
 =?us-ascii?Q?dKrgpgLsgsxZlGVOzUW0DWjrLpzE8sdBnhyXhaXqbuxAB9u3M7y3SO5uvKRo?=
 =?us-ascii?Q?4iFH8zFulg5zRqWNnzSRHlwKwlS4aYjwyyaIjfCaKdNxC95+5JL2w3DQ8ZYJ?=
 =?us-ascii?Q?VDN0ISMTpSe1GuCSVvoiV5Okq9MqsEnrpfKac0pItOXTfyjGynOvXKNJUWdj?=
 =?us-ascii?Q?VAuE1y0IHnYms8snPTvGdXA8UI5DQHxRcIrprMrDdBpzvH2tvmsT/F571kxw?=
 =?us-ascii?Q?gAqSukL2CBoAxua6RwnpIMiXdVbOM9l7LTg5sehlwyFS3+BkT4gdxUcZK7PT?=
 =?us-ascii?Q?vCAuNpXQa1Ey1ixLIDTAZIcS8tkLipv4k4CleP6FL4i6jYnOZkjdEn7sHwqb?=
 =?us-ascii?Q?hN1oUpQUCsnO/67wgbuMYjK2LljY5OnKTLYcodRQUkEWIFQsW1W1/eVj6Hwr?=
 =?us-ascii?Q?uC1oPiRwOn2ljvLEw1L2sm6RS9wArMsasIOtds6HKfzFSHhtj7ePQCW89YpV?=
 =?us-ascii?Q?6GEsOXLD9nMaLHtBchdtkAiIKv3zGtc/UFlhHRM5zsnjVOtLC7aDZWmIQRVH?=
 =?us-ascii?Q?HKhUId0JYMwSG8xAhXFEzCGS7/5JfbXO2t0eiaSVJjA5PIID2DfyxW8Om5nT?=
 =?us-ascii?Q?eLFzdh7xFIG1q0FnhFwtsPlTGrpziyXLsqrAMd7frqb8v1pksZobGRkT3EEt?=
 =?us-ascii?Q?2ood8JKMVnSlKpx0AlBYh4CDfNh7KUUE9B2e5fsVebqZqYKVcoRJtDhg9XyW?=
 =?us-ascii?Q?nHf3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:12:58.7602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 204a7da3-b1ec-4141-e586-08d89d2ed7e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2eyxSEww675VM+P04OHGWSlyN8jn5KIw4HwAgTQTC8fJ5OKDQdw2r5fLi8UZIQHsnN8k/knmOJKJaa2yngUVGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
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
index 2e2548fa369b..63f20be4bc69 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1262,6 +1262,9 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_guest_memory(svm, svm->vmsa, PAGE_SIZE);
 	__free_page(virt_to_page(svm->vmsa));
+
+	if (svm->ghcb_sa_free)
+		kfree(svm->ghcb_sa);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -1436,6 +1439,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
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
@@ -1470,6 +1478,24 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
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
@@ -1504,6 +1530,86 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
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
@@ -1641,6 +1747,24 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 
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
 		vcpu_unimpl(&svm->vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fc69bc2e0cad..9019ad6a8138 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -174,6 +174,12 @@ struct vcpu_svm {
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
index ba26b62e0262..78e8c8b36f9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11299,6 +11299,129 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
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
index 764c967a1993..804369fe45e3 100644
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

