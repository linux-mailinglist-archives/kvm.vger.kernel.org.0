Return-Path: <kvm+bounces-1181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8D37E5551
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BB7BB210C2
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2F617986;
	Wed,  8 Nov 2023 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="C/MdZbLS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8046017981;
	Wed,  8 Nov 2023 11:24:16 +0000 (UTC)
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF6C212A;
	Wed,  8 Nov 2023 03:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442656; x=1730978656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ST5pXoQneZXqxqWwZOJM6gjg/ZZDrAnOFjwipV1/Y4=;
  b=C/MdZbLSlXUQzVOmzjqclHrGAyQn/xkIzbBNFKdvvGB/k4+2AxA7reiU
   pr4iglofX+uAVbi+x3s2UyCnN8I6aWoJ4I1El7gHWCeljwW1zs5lwWqXj
   zx3KsYhYmD7in2+9B/ABuEMCHl0/kJKks8kpHZkNMgKSbU5S5JlE91Vv9
   A=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="683506250"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:24:15 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id B2EAAE2099;
	Wed,  8 Nov 2023 11:24:10 +0000 (UTC)
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:64382]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.103:2525] with esmtp (Farcaster)
 id fa9eeb09-4794-4c6e-b14d-d42e11167bfe; Wed, 8 Nov 2023 11:24:09 +0000 (UTC)
X-Farcaster-Flow-ID: fa9eeb09-4794-4c6e-b14d-d42e11167bfe
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:09 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:04 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 27/33] KVM: x86/mmu/hyper-v: Validate memory faults against per-VTL memprots
Date: Wed, 8 Nov 2023 11:18:00 +0000
Message-ID: <20231108111806.92604-28-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Introduce a new step in __kvm_faultin_pfn() that'll validate the
fault against the vCPU's VTL protections and generate a user space exit
when invalid.

Note that kvm_hv_faultin_pfn() has to be run after resolving the fault
against the memslots, since that operation steps over
'fault->map_writable'.

Non VSM users shouldn't see any behaviour change.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c  | 66 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h  |  1 +
 arch/x86/kvm/mmu/mmu.c |  9 +++++-
 3 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bcace0258af1..eb6a4848e306 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -42,6 +42,8 @@
 #include "irq.h"
 #include "fpu.h"
 
+#include "mmu/mmu_internal.h"
+
 #define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, HV_VCPUS_PER_SPARSE_BANK)
 
 /*
@@ -3032,6 +3034,55 @@ struct kvm_hv_vtl_dev {
 	struct xarray mem_attrs;
 };
 
+static struct xarray *kvm_hv_vsm_get_memprots(struct kvm_vcpu *vcpu);
+
+bool kvm_hv_vsm_access_valid(struct kvm_page_fault *fault, unsigned long attrs)
+{
+	if (attrs == KVM_MEMORY_ATTRIBUTE_NO_ACCESS)
+		return false;
+
+	/* We should never get here without read permissions, force a fault. */
+	if (WARN_ON_ONCE(!(attrs & KVM_MEMORY_ATTRIBUTE_READ)))
+		return false;
+
+	if (fault->write && !(attrs & KVM_MEMORY_ATTRIBUTE_WRITE))
+		return false;
+
+	if (fault->exec && !(attrs & KVM_MEMORY_ATTRIBUTE_EXECUTE))
+		return false;
+
+	return true;
+}
+
+static unsigned long kvm_hv_vsm_get_memory_attributes(struct kvm_vcpu *vcpu,
+						      gfn_t gfn)
+{
+	struct xarray *prots = kvm_hv_vsm_get_memprots(vcpu);
+
+	if (!prots)
+		return 0;
+
+	return xa_to_value(xa_load(prots, gfn));
+}
+
+int kvm_hv_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	unsigned long attrs;
+
+	attrs = kvm_hv_vsm_get_memory_attributes(vcpu, fault->gfn);
+	if (!attrs)
+		return RET_PF_CONTINUE;
+
+	if (kvm_hv_vsm_access_valid(fault, attrs)) {
+		fault->map_executable =
+			!!(attrs & KVM_MEMORY_ATTRIBUTE_EXECUTE);
+		fault->map_writable = !!(attrs & KVM_MEMORY_ATTRIBUTE_WRITE);
+		return RET_PF_CONTINUE;
+	}
+
+	return -EFAULT;
+}
+
 static int kvm_hv_vtl_get_attr(struct kvm_device *dev,
 			       struct kvm_device_attr *attr)
 {
@@ -3120,6 +3171,21 @@ static struct kvm_device_ops kvm_hv_vtl_ops = {
 	.get_attr = kvm_hv_vtl_get_attr,
 };
 
+static struct xarray *kvm_hv_vsm_get_memprots(struct kvm_vcpu *vcpu)
+{
+	struct kvm_hv_vtl_dev *vtl_dev;
+	struct kvm_device *tmp;
+
+	list_for_each_entry(tmp, &vcpu->kvm->devices, vm_node)
+		if (tmp->ops == &kvm_hv_vtl_ops) {
+			vtl_dev = tmp->private;
+			if (vtl_dev->vtl == kvm_hv_get_active_vtl(vcpu))
+				return &vtl_dev->mem_attrs;
+		}
+
+	return NULL;
+}
+
 static int kvm_hv_vtl_create(struct kvm_device *dev, u32 type)
 {
 	struct kvm_hv_vtl_dev *vtl_dev;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 3cc664e144d8..ae781b4d4669 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -271,5 +271,6 @@ static inline void kvm_mmu_role_set_hv_bits(struct kvm_vcpu *vcpu,
 
 int kvm_hv_vtl_dev_register(void);
 void kvm_hv_vtl_dev_unregister(void);
+int kvm_hv_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a76028aa8fb3..ba454c7277dc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4374,7 +4374,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
 	if (!async)
-		return RET_PF_CONTINUE; /* *pfn has correct page already */
+		goto pf_continue; /* *pfn has correct page already */
 
 	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
@@ -4395,6 +4395,13 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
+pf_continue:
+	if (kvm_hv_vsm_enabled(vcpu->kvm)) {
+		if (kvm_hv_faultin_pfn(vcpu, fault)) {
+			kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+			return -EFAULT;
+		}
+	}
 	return RET_PF_CONTINUE;
 }
 
-- 
2.40.1


