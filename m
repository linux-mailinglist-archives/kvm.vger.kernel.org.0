Return-Path: <kvm+bounces-1158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0F67E54EC
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AA2BB210C7
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 090CB15E96;
	Wed,  8 Nov 2023 11:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="YPK5Up4/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E609171A7;
	Wed,  8 Nov 2023 11:19:16 +0000 (UTC)
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D64519BD;
	Wed,  8 Nov 2023 03:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442356; x=1730978356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xwm80GfbjkdS94nlx2StfaEHABGwZZtCfK9AfoMHOMQ=;
  b=YPK5Up4/JXj73WVhsq8zCU9Ya+YBhJDPIMsH7BJvTzQnBqvsL1mXOfrH
   +dztxjHsnisUYBzKgrPs9+ni7x+c1/Gs/lt/hhwumU30MMqti7MYK26fm
   NYp62hyOQUAfkIBX4sRNlukC0abaP3+4Za61ENg97K5f3xei7i9TFeQZu
   A=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="614865362"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:19:12 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id 9D678804AE;
	Wed,  8 Nov 2023 11:19:10 +0000 (UTC)
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:22087]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.187:2525] with esmtp (Farcaster)
 id d33121c7-11f2-4715-adf8-59384f014902; Wed, 8 Nov 2023 11:19:09 +0000 (UTC)
X-Farcaster-Flow-ID: d33121c7-11f2-4715-adf8-59384f014902
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:19:09 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:19:04 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return prologues in hypercall page
Date: Wed, 8 Nov 2023 11:17:38 +0000
Message-ID: <20231108111806.92604-6-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

VTL call/return hypercalls have their own entry points in the hypercall
page because they don't follow normal hyper-v hypercall conventions.
Move the VTL call/return control input into ECX/RAX and set the
hypercall code into EAX/RCX before calling the hypercall instruction in
order to be able to use the Hyper-V hypercall entry function.

Guests can read an emulated code page offsets register to know the
offsets into the hypercall page for the VTL call/return entries.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>

---

My tree has the additional patch, we're still trying to understand under
what conditions Windows expects the offset to be fixed.

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 54f7f36a89bf..9f2ea8c34447 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -294,6 +294,7 @@ static int patch_hypercall_page(struct kvm_vcpu *vcpu, u64 data)

        /* VTL call/return entries */
        if (!kvm_xen_hypercall_enabled(kvm) && kvm_hv_vsm_enabled(kvm)) {
+               i = 22;
 #ifdef CONFIG_X86_64
                if (is_64_bit_mode(vcpu)) {
                        /*
---
 arch/x86/include/asm/kvm_host.h   |  2 +
 arch/x86/kvm/hyperv.c             | 78 ++++++++++++++++++++++++++++++-
 include/asm-generic/hyperv-tlfs.h | 11 +++++
 3 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a2f224f95404..00cd21b09f8c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1105,6 +1105,8 @@ struct kvm_hv {
 	u64 hv_tsc_emulation_status;
 	u64 hv_invtsc_control;
 
+	union hv_register_vsm_code_page_offsets vsm_code_page_offsets;
+
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 78d053042667..d4b1b53ea63d 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -259,7 +259,8 @@ static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
 static int patch_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
-	u8 instructions[9];
+	struct kvm_hv *hv = to_kvm_hv(kvm);
+	u8 instructions[0x30];
 	int i = 0;
 	u64 addr;
 
@@ -285,6 +286,81 @@ static int patch_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 	/* ret */
 	((unsigned char *)instructions)[i++] = 0xc3;
 
+	/* VTL call/return entries */
+	if (!kvm_xen_hypercall_enabled(kvm) && kvm_hv_vsm_enabled(kvm)) {
+#ifdef CONFIG_X86_64
+		if (is_64_bit_mode(vcpu)) {
+			/*
+			 * VTL call 64-bit entry prologue:
+			 * 	mov %rcx, %rax
+			 * 	mov $0x11, %ecx
+			 * 	jmp 0:
+			 */
+			hv->vsm_code_page_offsets.vtl_call_offset = i;
+			instructions[i++] = 0x48;
+			instructions[i++] = 0x89;
+			instructions[i++] = 0xc8;
+			instructions[i++] = 0xb9;
+			instructions[i++] = 0x11;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0xeb;
+			instructions[i++] = 0xe0;
+			/*
+			 * VTL return 64-bit entry prologue:
+			 * 	mov %rcx, %rax
+			 * 	mov $0x12, %ecx
+			 * 	jmp 0:
+			 */
+			hv->vsm_code_page_offsets.vtl_return_offset = i;
+			instructions[i++] = 0x48;
+			instructions[i++] = 0x89;
+			instructions[i++] = 0xc8;
+			instructions[i++] = 0xb9;
+			instructions[i++] = 0x12;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0xeb;
+			instructions[i++] = 0xd6;
+		} else
+#endif
+		{
+			/*
+			 * VTL call 32-bit entry prologue:
+			 * 	mov %eax, %ecx
+			 * 	mov $0x11, %eax
+			 * 	jmp 0:
+			 */
+			hv->vsm_code_page_offsets.vtl_call_offset = i;
+			instructions[i++] = 0x89;
+			instructions[i++] = 0xc1;
+			instructions[i++] = 0xb8;
+			instructions[i++] = 0x11;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0xeb;
+			instructions[i++] = 0xf3;
+			/*
+			 * VTL return 32-bit entry prologue:
+			 * 	mov %eax, %ecx
+			 * 	mov $0x12, %eax
+			 * 	jmp 0:
+			 */
+			hv->vsm_code_page_offsets.vtl_return_offset = i;
+			instructions[i++] = 0x89;
+			instructions[i++] = 0xc1;
+			instructions[i++] = 0xb8;
+			instructions[i++] = 0x12;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0xeb;
+			instructions[i++] = 0xea;
+		}
+	}
 	addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
 	if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
 		return 1;
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index fdac4a1714ec..0e7643c1ef01 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -823,4 +823,15 @@ struct hv_mmio_write_input {
 	u8 data[HV_HYPERCALL_MMIO_MAX_DATA_LENGTH];
 } __packed;
 
+/*
+ * VTL call/return hypercall page offsets register
+ */
+union hv_register_vsm_code_page_offsets {
+	u64 as_u64;
+	struct {
+		u64 vtl_call_offset:12;
+		u64 vtl_return_offset:12;
+		u64 reserved:40;
+	} __packed;
+};
 #endif
-- 
2.40.1


