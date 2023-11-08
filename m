Return-Path: <kvm+bounces-1164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 805577E5505
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EADEFB2135C
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479BF15EAB;
	Wed,  8 Nov 2023 11:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="B2oubJH9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4F215E96;
	Wed,  8 Nov 2023 11:20:35 +0000 (UTC)
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B351BEC;
	Wed,  8 Nov 2023 03:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442436; x=1730978436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QBVqEnmtZNOjPktuGk9xsojMAUYhuWQTJQf/5jldNU4=;
  b=B2oubJH9/QQ5t5/Q0OeG0guV4eO6kmOmkBgbZF7D1k6BpayFGxHSYPhJ
   F8aitM+eksavt7Zw8G7NNTM3kwknGEnRgkGHE9KAL0EiWwkevxBpVLCEV
   etr9kWKoYI8QxvJhcB84JKM5YembBF0auUEjAUSHxKASziVievrPVAfPY
   8=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="618315974"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:20:32 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id B84FB40D92;
	Wed,  8 Nov 2023 11:20:29 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:62810]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.4.34:2525] with esmtp (Farcaster)
 id 3ff2c4a7-a3e7-46e0-936d-e9e005f722e6; Wed, 8 Nov 2023 11:20:28 +0000 (UTC)
X-Farcaster-Flow-ID: 3ff2c4a7-a3e7-46e0-936d-e9e005f722e6
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:20:26 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:20:21 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 11/33] KVM: x86: hyper-v: Handle GET/SET_VP_REGISTER hcall in user-space
Date: Wed, 8 Nov 2023 11:17:44 +0000
Message-ID: <20231108111806.92604-12-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Let user-space handle HVCALL_GET_VP_REGISTERS and
HVCALL_SET_VP_REGISTERS through the KVM_EXIT_HYPERV_HVCALL exit reason.
Additionally, expose the cpuid bit.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c             | 9 +++++++++
 include/asm-generic/hyperv-tlfs.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index caaa859932c5..a3970d52eef1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2456,6 +2456,9 @@ static void kvm_hv_write_xmm(struct kvm_hyperv_xmm_reg *xmm)
 
 static bool kvm_hv_is_xmm_output_hcall(u16 code)
 {
+	if (code == HVCALL_GET_VP_REGISTERS)
+		return true;
+
 	return false;
 }
 
@@ -2520,6 +2523,8 @@ static bool is_xmm_fast_hypercall(struct kvm_hv_hcall *hc)
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
 	case HVCALL_SEND_IPI_EX:
+	case HVCALL_GET_VP_REGISTERS:
+	case HVCALL_SET_VP_REGISTERS:
 		return true;
 	}
 
@@ -2738,6 +2743,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 			break;
 		}
 		goto hypercall_userspace_exit;
+	case HVCALL_GET_VP_REGISTERS:
+	case HVCALL_SET_VP_REGISTERS:
+		goto hypercall_userspace_exit;
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
 		break;
@@ -2903,6 +2911,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
 			ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
+			ent->ebx |= HV_ACCESS_VP_REGISTERS;
 
 			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
 			ent->edx |= HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE;
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 40d7dc793c03..24ea699a3d8e 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -89,6 +89,7 @@
 #define HV_ACCESS_STATS				BIT(8)
 #define HV_DEBUGGING				BIT(11)
 #define HV_CPU_MANAGEMENT			BIT(12)
+#define HV_ACCESS_VP_REGISTERS			BIT(17)
 #define HV_ENABLE_EXTENDED_HYPERCALLS		BIT(20)
 #define HV_ISOLATION				BIT(22)
 
-- 
2.40.1


