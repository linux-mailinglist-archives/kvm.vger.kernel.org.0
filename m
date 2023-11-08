Return-Path: <kvm+bounces-1165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D68DA7E5509
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9098C281617
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F21915EAE;
	Wed,  8 Nov 2023 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="PBBdMmlK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762C315E89;
	Wed,  8 Nov 2023 11:21:04 +0000 (UTC)
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC0B1BF5;
	Wed,  8 Nov 2023 03:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442464; x=1730978464;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7C45WW2plKc9LGS1hg04kUsdvaSyLe7Yr2kIsIf6Lys=;
  b=PBBdMmlKTVNOph/CauxitBiIZC2KKZDRZoDPYrP9M4s46/tyZCXrGesw
   EopIKJhR5etsB50qYBfKZhCn3BEkZk7/oahfr0RJhI3xKx8AZ9wy5DxYs
   QJ1k7B0GZJsSKlIGCX3MXcBrNLAyqtfsi4dGzUoeQB+V5Wi9flFULTzz6
   Y=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="250876207"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:21:01 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id 11B3F806CD;
	Wed,  8 Nov 2023 11:20:56 +0000 (UTC)
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:3212]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.187:2525] with esmtp (Farcaster)
 id 71b58972-fe97-42fd-b068-56f96eb17f93; Wed, 8 Nov 2023 11:20:55 +0000 (UTC)
X-Farcaster-Flow-ID: 71b58972-fe97-42fd-b068-56f96eb17f93
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:20:55 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:20:50 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 12/33] KVM: x86: hyper-v: Handle VSM hcalls in user-space
Date: Wed, 8 Nov 2023 11:17:45 +0000
Message-ID: <20231108111806.92604-13-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Let user-space handle all hypercalls that fall under the AccessVsm
partition privilege flag. That is:
 - HVCALL_MODIFY_VTL_PROTECTION_MASK:
 - HVCALL_ENABLE_PARTITION_VTL:
 - HVCALL_ENABLE_VP_VTL:
 - HVCALL_VTL_CALL:
 - HVCALL_VTL_RETURN:
The hypercalls are processed through the KVM_EXIT_HYPERV_HVCALL exit.
Additionally, expose the cpuid bit.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c             | 15 +++++++++++++++
 include/asm-generic/hyperv-tlfs.h |  7 ++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a3970d52eef1..a266c5d393f5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2462,6 +2462,11 @@ static bool kvm_hv_is_xmm_output_hcall(u16 code)
 	return false;
 }
 
+static inline bool kvm_hv_is_vtl_call_return(u16 code)
+{
+	return code == HVCALL_VTL_CALL || code == HVCALL_VTL_RETURN;
+}
+
 static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 {
 	bool fast = !!(vcpu->run->hyperv.u.hcall.input & HV_HYPERCALL_FAST_BIT);
@@ -2471,6 +2476,9 @@ static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 	if (kvm_hv_is_xmm_output_hcall(code) && hv_result_success(result) && fast)
 		kvm_hv_write_xmm(vcpu->run->hyperv.u.hcall.xmm);
 
+	if (kvm_hv_is_vtl_call_return(code))
+		return kvm_skip_emulated_instruction(vcpu);
+
 	return kvm_hv_hypercall_complete(vcpu, result);
 }
 
@@ -2525,6 +2533,7 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
 	case HVCALL_SEND_IPI_EX:
 	case HVCALL_GET_VP_REGISTERS:
 	case HVCALL_SET_VP_REGISTERS:
+	case HVCALL_MODIFY_VTL_PROTECTION_MASK:
 		return true;
 	}
 
@@ -2745,6 +2754,11 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		goto hypercall_userspace_exit;
 	case HVCALL_GET_VP_REGISTERS:
 	case HVCALL_SET_VP_REGISTERS:
+	case HVCALL_MODIFY_VTL_PROTECTION_MASK:
+	case HVCALL_ENABLE_PARTITION_VTL:
+	case HVCALL_ENABLE_VP_VTL:
+	case HVCALL_VTL_CALL:
+	case HVCALL_VTL_RETURN:
 		goto hypercall_userspace_exit;
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
@@ -2912,6 +2926,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_SIGNAL_EVENTS;
 			ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
 			ent->ebx |= HV_ACCESS_VP_REGISTERS;
+			ent->ebx |= HV_ACCESS_VSM;
 
 			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
 			ent->edx |= HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE;
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 24ea699a3d8e..a8b5c8a84bbc 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -89,6 +89,7 @@
 #define HV_ACCESS_STATS				BIT(8)
 #define HV_DEBUGGING				BIT(11)
 #define HV_CPU_MANAGEMENT			BIT(12)
+#define HV_ACCESS_VSM				BIT(16)
 #define HV_ACCESS_VP_REGISTERS			BIT(17)
 #define HV_ENABLE_EXTENDED_HYPERCALLS		BIT(20)
 #define HV_ISOLATION				BIT(22)
@@ -147,9 +148,13 @@ union hv_reference_tsc_msr {
 /* Declare the various hypercall operations. */
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE	0x0002
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST	0x0003
-#define HVCALL_ENABLE_VP_VTL			0x000f
 #define HVCALL_NOTIFY_LONG_SPIN_WAIT		0x0008
 #define HVCALL_SEND_IPI				0x000b
+#define HVCALL_MODIFY_VTL_PROTECTION_MASK	0x000c
+#define HVCALL_ENABLE_PARTITION_VTL		0x000d
+#define HVCALL_ENABLE_VP_VTL			0x000f
+#define HVCALL_VTL_CALL				0x0011
+#define HVCALL_VTL_RETURN			0x0012
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX	0x0013
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX	0x0014
 #define HVCALL_SEND_IPI_EX			0x0015
-- 
2.40.1


