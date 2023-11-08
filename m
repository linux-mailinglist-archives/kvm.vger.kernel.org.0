Return-Path: <kvm+bounces-1176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA957E553C
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A86EF2815BA
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CD3171C6;
	Wed,  8 Nov 2023 11:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="fx21Mtjt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A972A168CD;
	Wed,  8 Nov 2023 11:23:09 +0000 (UTC)
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA8A1FE7;
	Wed,  8 Nov 2023 03:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442589; x=1730978589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c+LzbRrbsSUyvlGgFH27jCwf7iTA/jQxajqqAaH5CaQ=;
  b=fx21MtjtuEYg4WSnWWtyzoP5MoH0tXFLtnQBIffZJ8BwJx9rNFKxkXqY
   uCthuyHuyYHVocvqF1+i2tQPqXX346ecbzUbofxrbUEfzzZbprlZ32WPv
   wFZgRWZ1XrOOheF9kYWirku2+mWbD1Gdht/jFGPjEwKkU+/mL2UUSZ3Mq
   c=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="164959605"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:23:07 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id 1A2F0A12E2;
	Wed,  8 Nov 2023 11:23:02 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:48574]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.187:2525] with esmtp (Farcaster)
 id 78327385-25a6-4125-94a0-25fd575b12d8; Wed, 8 Nov 2023 11:23:01 +0000 (UTC)
X-Farcaster-Flow-ID: 78327385-25a6-4125-94a0-25fd575b12d8
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:23:01 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:22:56 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 23/33] KVM: Expose memory attribute helper functions unanimously
Date: Wed, 8 Nov 2023 11:17:56 +0000
Message-ID: <20231108111806.92604-24-nsaenz@amazon.com>
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

Expose memory attribute helper functions even when
CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES is disabled. Other KVM features,
like Hyper-V VSM, make use of memory attributes but don't rely on the
KVM ioctl.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 18 +++++++++---------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c2bec2be2ba9..a76028aa8fb3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7250,7 +7250,6 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range)
 {
@@ -7377,6 +7376,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	return false;
 }
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 					    struct kvm_memory_slot *slot)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ad104794037f..45e3e261755d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2387,7 +2387,6 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long
 kvm_get_memory_attributes(struct xarray *mem_attr_array, gfn_t gfn)
 {
@@ -2404,6 +2403,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74c4c42b2126..b3f4b200f438 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2435,7 +2435,6 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 /*
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * matching @attrs.
@@ -2472,14 +2471,6 @@ bool kvm_range_has_memory_attributes(struct xarray *mem_attr_array, gfn_t start,
 	return has_attrs;
 }
 
-static u64 kvm_supported_mem_attributes(struct kvm *kvm)
-{
-	if (!kvm || kvm_arch_has_private_mem(kvm))
-		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
-
-	return 0;
-}
-
 static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 						 struct kvm_mmu_notifier_range *range)
 {
@@ -2644,6 +2635,15 @@ int kvm_ioctl_set_mem_attributes(struct kvm *kvm, struct xarray *mem_attr_array,
 				      attrs->attributes);
 }
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+static u64 kvm_supported_mem_attributes(struct kvm *kvm)
+{
+	if (!kvm || kvm_arch_has_private_mem(kvm))
+		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+
+	return 0;
+}
+
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
-- 
2.40.1


