Return-Path: <kvm+bounces-1157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 749577E54E5
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:19:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05AB8B20FAB
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92555171BB;
	Wed,  8 Nov 2023 11:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="TNe4BukL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17B9171A5;
	Wed,  8 Nov 2023 11:19:15 +0000 (UTC)
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B491729;
	Wed,  8 Nov 2023 03:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442355; x=1730978355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G8tv4EqIfPFJRUiW9cZCsErULQwL6MkqMdyO6PRnfzY=;
  b=TNe4BukLRNg0YJfWA90/7JIByXU+dM2VDsbXlcy/qOnFybyCFrYRcHD8
   ZQ2wY9eXVgY73blHeJws0Szlh9DQPrDdIa28YsluQgaSq9LIeTWGrNCzO
   gSWADZe4RXHIN6DqUxD2pE+OXoWeGGMtdU66EPFsK+1fAs3dn0w0wwAlm
   U=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="251427581"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:19:09 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id 8CC3F8057A;
	Wed,  8 Nov 2023 11:19:05 +0000 (UTC)
Received: from EX19MTAEUB001.ant.amazon.com [10.0.43.254:28968]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.103:2525] with esmtp (Farcaster)
 id a4bb631b-a22d-4d34-9086-5dcfe9a4daf9; Wed, 8 Nov 2023 11:19:04 +0000 (UTC)
X-Farcaster-Flow-ID: a4bb631b-a22d-4d34-9086-5dcfe9a4daf9
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:19:04 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:18:59 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 04/33] KVM: x86: hyper-v: Move hypercall page handling into separate function
Date: Wed, 8 Nov 2023 11:17:37 +0000
Message-ID: <20231108111806.92604-5-nsaenz@amazon.com>
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

The hypercall page patching is about to grow considerably, move it into
its own function.

No functional change intended.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c | 69 ++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index e1bc861ab3b0..78d053042667 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -256,6 +256,42 @@ static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
 	kvm_make_request(KVM_REQ_HV_EXIT, vcpu);
 }
 
+static int patch_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u8 instructions[9];
+	int i = 0;
+	u64 addr;
+
+	/*
+	 * If Xen and Hyper-V hypercalls are both enabled, disambiguate
+	 * the same way Xen itself does, by setting the bit 31 of EAX
+	 * which is RsvdZ in the 32-bit Hyper-V hypercall ABI and just
+	 * going to be clobbered on 64-bit.
+	 */
+	if (kvm_xen_hypercall_enabled(kvm)) {
+		/* orl $0x80000000, %eax */
+		instructions[i++] = 0x0d;
+		instructions[i++] = 0x00;
+		instructions[i++] = 0x00;
+		instructions[i++] = 0x00;
+		instructions[i++] = 0x80;
+	}
+
+	/* vmcall/vmmcall */
+	static_call(kvm_x86_patch_hypercall)(vcpu, instructions + i);
+	i += 3;
+
+	/* ret */
+	((unsigned char *)instructions)[i++] = 0xc3;
+
+	addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
+	if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
+		return 1;
+
+	return 0;
+}
+
 static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 			 u32 msr, u64 data, bool host)
 {
@@ -1338,11 +1374,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		if (!hv->hv_guest_os_id)
 			hv->hv_hypercall &= ~HV_X64_MSR_HYPERCALL_ENABLE;
 		break;
-	case HV_X64_MSR_HYPERCALL: {
-		u8 instructions[9];
-		int i = 0;
-		u64 addr;
-
+	case HV_X64_MSR_HYPERCALL:
 		/* if guest os id is not set hypercall should remain disabled */
 		if (!hv->hv_guest_os_id)
 			break;
@@ -1351,34 +1383,11 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 			break;
 		}
 
-		/*
-		 * If Xen and Hyper-V hypercalls are both enabled, disambiguate
-		 * the same way Xen itself does, by setting the bit 31 of EAX
-		 * which is RsvdZ in the 32-bit Hyper-V hypercall ABI and just
-		 * going to be clobbered on 64-bit.
-		 */
-		if (kvm_xen_hypercall_enabled(kvm)) {
-			/* orl $0x80000000, %eax */
-			instructions[i++] = 0x0d;
-			instructions[i++] = 0x00;
-			instructions[i++] = 0x00;
-			instructions[i++] = 0x00;
-			instructions[i++] = 0x80;
-		}
-
-		/* vmcall/vmmcall */
-		static_call(kvm_x86_patch_hypercall)(vcpu, instructions + i);
-		i += 3;
-
-		/* ret */
-		((unsigned char *)instructions)[i++] = 0xc3;
-
-		addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
-		if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
+		if (patch_hypercall_page(vcpu, data))
 			return 1;
+
 		hv->hv_hypercall = data;
 		break;
-	}
 	case HV_X64_MSR_REFERENCE_TSC:
 		hv->hv_tsc_page = data;
 		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE) {
-- 
2.40.1


