Return-Path: <kvm+bounces-1166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B52F97E550D
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:21:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 695C728158F
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A221615EB7;
	Wed,  8 Nov 2023 11:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="tTG2Z5me"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E818A15E89;
	Wed,  8 Nov 2023 11:21:11 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31B3181;
	Wed,  8 Nov 2023 03:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442471; x=1730978471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hsnpzZHwTij1DO+oBadMSuiUb8OXWa0py8QnRL9ObtU=;
  b=tTG2Z5meFI6gLZozCnUrMYh6fXI1igfyppPiCfK8rMdXuUfJ+cr6P9du
   p2bla8f9VUANUldCb68SC8CYgEXpujR8nDAALwrnErClO3UmfojOKzt7q
   EDO9LYKnMuJXcdZGtzE6Mzh57LsCgt3SbP+dtj7GOaSJvkbzWPyC2WCv4
   M=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="366812557"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:21:10 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id 3191748ED2;
	Wed,  8 Nov 2023 11:21:06 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:8159]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.101:2525] with esmtp (Farcaster)
 id b036e4e3-6edd-4dbe-817d-58a60e75dd60; Wed, 8 Nov 2023 11:21:06 +0000 (UTC)
X-Farcaster-Flow-ID: b036e4e3-6edd-4dbe-817d-58a60e75dd60
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:21:05 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:21:00 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 14/33] KVM: x86: Add VTL to the MMU role
Date: Wed, 8 Nov 2023 11:17:47 +0000
Message-ID: <20231108111806.92604-15-nsaenz@amazon.com>
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

With the upcoming introduction of per-VTL memory protections, make MMU
roles VTL aware. This will avoid sharing PTEs between vCPUs that belong
to different VTLs, and that have distinct memory access restrictions.

Four bits are allocated to store the VTL number in the MMU role, since
the TLFS states there is a maximum of 16 levels.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/hyperv.h           | 6 ++++++
 arch/x86/kvm/mmu.h              | 1 +
 arch/x86/kvm/mmu/mmu.c          | 3 +++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7712e31b7537..1f5a85d461ce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -338,7 +338,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
-		unsigned :5;
+		unsigned vtl:4;
+		unsigned :1;
 
 		/*
 		 * This is left at the top of the word so that
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index b3d1113efe82..605e80b9e5eb 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -263,4 +263,10 @@ static inline bool kvm_hv_vsm_enabled(struct kvm *kvm)
 
 int kvm_vm_ioctl_get_hv_vsm_state(struct kvm *kvm, struct kvm_hv_vsm_state *state);
 
+static inline void kvm_mmu_role_set_hv_bits(struct kvm_vcpu *vcpu,
+					    union kvm_mmu_page_role *role)
+{
+	role->vtl = kvm_hv_get_active_vtl(vcpu);
+}
+
 #endif
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 253fb2093d5d..e170388c6da1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -304,4 +304,5 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
 		return gpa;
 	return translate_nested_gpa(vcpu, gpa, access, exception);
 }
+
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index baeba8fc1c38..2afef86863fb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -28,6 +28,7 @@
 #include "page_track.h"
 #include "cpuid.h"
 #include "spte.h"
+#include "hyperv.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -5197,6 +5198,7 @@ static union kvm_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
 	role.base.smm = is_smm(vcpu);
 	role.base.guest_mode = is_guest_mode(vcpu);
 	role.ext.valid = 1;
+	kvm_mmu_role_set_hv_bits(vcpu, &role.base);
 
 	if (!____is_cr0_pg(regs)) {
 		role.base.direct = 1;
@@ -5271,6 +5273,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.level = kvm_mmu_get_tdp_level(vcpu);
 	role.direct = true;
 	role.has_4_byte_gpte = false;
+	kvm_mmu_role_set_hv_bits(vcpu, &role);
 
 	return role;
 }
-- 
2.40.1


