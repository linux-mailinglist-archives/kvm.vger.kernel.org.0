Return-Path: <kvm+bounces-1174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6480E7E5536
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E6CD281577
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A20515E9C;
	Wed,  8 Nov 2023 11:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="KZxnAQq5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAAB15E8F;
	Wed,  8 Nov 2023 11:22:57 +0000 (UTC)
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D763D1FF6;
	Wed,  8 Nov 2023 03:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442578; x=1730978578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RgZghGDVPKK1y7/jRC8uX7Dc8zxHwsko9uAHRrK/b/E=;
  b=KZxnAQq5x79fecGfeJTdJwy7Asc3OjoDvMstzCK0CsEroWHde6inNPoH
   bAU2j0GSTfcIUcHmqvV6Wua1ulzGl2alPEfcFhkNCqK5ql5IvNSb6LsP9
   lasAo5p7cJN+MQIsFD4w09XMJeESBGC7AfQ4VSo0pakLEqgS+5nD3v4yh
   k=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="593808027"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:22:57 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 6925380801;
	Wed,  8 Nov 2023 11:22:52 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:36451]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.43.105:2525] with esmtp (Farcaster)
 id 6ea11377-1737-4520-be2a-aa11258cc468; Wed, 8 Nov 2023 11:22:51 +0000 (UTC)
X-Farcaster-Flow-ID: 6ea11377-1737-4520-be2a-aa11258cc468
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:22:51 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:22:46 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 21/33] KVM: Pass memory attribute array as a MMU notifier argument
Date: Wed, 8 Nov 2023 11:17:54 +0000
Message-ID: <20231108111806.92604-22-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Pass the memory attribute array through struct kvm_mmu_notifier_arg and
use it in kvm_arch_post_set_memory_attributes() instead of defaulting on
kvm->mem_attr_array.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/mmu/mmu.c   | 8 ++++----
 include/linux/kvm_host.h | 5 ++++-
 virt/kvm/kvm_main.c      | 1 +
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c0fd3afd6be5..c2bec2be2ba9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7311,6 +7311,7 @@ static bool hugepage_has_attrs(struct xarray *mem_attr_array,
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range)
 {
+	struct xarray *mem_attr_array = range->arg.mem_attr_array;
 	unsigned long attrs = range->arg.attributes;
 	struct kvm_memory_slot *slot = range->slot;
 	int level;
@@ -7344,8 +7345,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 			 * misaligned address regardless of memory attributes.
 			 */
 			if (gfn >= slot->base_gfn) {
-				if (hugepage_has_attrs(&kvm->mem_attr_array,
-						       slot, gfn, level, attrs))
+				if (hugepage_has_attrs(mem_attr_array, slot,
+						       gfn, level, attrs))
 					hugepage_clear_mixed(slot, gfn, level);
 				else
 					hugepage_set_mixed(slot, gfn, level);
@@ -7367,8 +7368,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 		 */
 		if (gfn < range->end &&
 		    (gfn + nr_pages) <= (slot->base_gfn + slot->npages)) {
-			if (hugepage_has_attrs(&kvm->mem_attr_array, slot, gfn,
-					       level, attrs))
+			if (hugepage_has_attrs(mem_attr_array, slot, gfn, level, attrs))
 				hugepage_clear_mixed(slot, gfn, level);
 			else
 				hugepage_set_mixed(slot, gfn, level);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 32cf05637647..652656444c45 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -256,7 +256,10 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 union kvm_mmu_notifier_arg {
 	pte_t pte;
-	unsigned long attributes;
+	struct {
+		unsigned long attributes;
+		struct xarray *mem_attr_array;
+	};
 };
 
 struct kvm_gfn_range {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6bb23eaf7aa6..f20dafaedc72 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2569,6 +2569,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		.start = start,
 		.end = end,
 		.arg.attributes = attributes,
+		.arg.mem_attr_array = &kvm->mem_attr_array,
 		.handler = kvm_arch_post_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_end,
 		.may_block = true,
-- 
2.40.1


