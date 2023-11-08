Return-Path: <kvm+bounces-1162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8986F7E54FD
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4404B280BFF
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9D615EAE;
	Wed,  8 Nov 2023 11:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="C0dt2eL7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134EC15E89;
	Wed,  8 Nov 2023 11:20:20 +0000 (UTC)
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8552D1FC8;
	Wed,  8 Nov 2023 03:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442419; x=1730978419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+q6HaRK4F5IqO9uASaPkSnlSL0f+bqvxqAxqsapmXI8=;
  b=C0dt2eL7HaTLnf+XladYEXWisf8ff8t8FXQGWEY1ORRsP8yKVNUG6dcQ
   Eq4tEIis1CZvWqwIrhNeHYugTgs6YAFQIKVddISCpF40nigHDaRTCl9L+
   gdfO3zAwk0J+wPdQ3mhMrK2UqnhfGb1l5hlOsO7sSxpUU3o7i534VyMoH
   8=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="251427918"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:20:18 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com (Postfix) with ESMTPS id 05BA740D73;
	Wed,  8 Nov 2023 11:20:17 +0000 (UTC)
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:7728]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.33.209:2525] with esmtp (Farcaster)
 id 3cca8fad-d704-4370-b632-03b67dd48c0d; Wed, 8 Nov 2023 11:20:16 +0000 (UTC)
X-Farcaster-Flow-ID: 3cca8fad-d704-4370-b632-03b67dd48c0d
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:20:16 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:20:11 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 09/33] KVM: x86: hyper-v: Introduce per-VTL vcpu helpers
Date: Wed, 8 Nov 2023 11:17:42 +0000
Message-ID: <20231108111806.92604-10-nsaenz@amazon.com>
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

Introduce two helper functions. The first one queries a vCPU's VTL
level, the second one, given a struct kvm_vcpu and VTL pair, returns the
corresponding 'sibling' struct kvm_vcpu at the right VTL.

We keep track of each VTL's state by having a distinct struct kvm_vpcu
for each level. VTL-vCPUs that belong to the same guest CPU share the
same physical APIC id, but belong to different APIC groups where the
apic group represents the vCPU's VTL.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 2bfed69ba0db..5433107e7cc8 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -23,6 +23,7 @@
 
 #include <linux/kvm_host.h>
 #include "x86.h"
+#include "lapic.h"
 
 /* "Hv#1" signature */
 #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
@@ -83,6 +84,23 @@ static inline struct kvm_hv_syndbg *to_hv_syndbg(struct kvm_vcpu *vcpu)
 	return &vcpu->kvm->arch.hyperv.hv_syndbg;
 }
 
+static inline struct kvm_vcpu *kvm_hv_get_vtl_vcpu(struct kvm_vcpu *vcpu, int vtl)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u32 target_id = kvm_apic_id(vcpu);
+
+	kvm_apic_id_set_group(kvm, vtl, &target_id);
+	if (vcpu->vcpu_id == target_id)
+		return vcpu;
+
+	return kvm_get_vcpu_by_id(kvm, target_id);
+}
+
+static inline u8 kvm_hv_get_active_vtl(struct kvm_vcpu *vcpu)
+{
+	return kvm_apic_group(vcpu);
+}
+
 static inline u32 kvm_hv_get_vpindex(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
-- 
2.40.1


