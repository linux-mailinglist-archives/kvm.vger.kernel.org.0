Return-Path: <kvm+bounces-1175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1C87E5539
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF7091C20DDA
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 999F11640F;
	Wed,  8 Nov 2023 11:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="J1NsGqHF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15B215EBB;
	Wed,  8 Nov 2023 11:23:02 +0000 (UTC)
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE072135;
	Wed,  8 Nov 2023 03:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442582; x=1730978582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2uG1W3dIcChJokJ3iAOnGcK/lDIrdgs97U52b9YNSN4=;
  b=J1NsGqHFv3Xa6QtMyVm8oGK078p8CRMvRUVIsTe1dRNNgJ8icfFfsxiQ
   6ba7qHHPlsg41GHi0sNiUWkrftmRfZFN/RcBaD+ADgBAXKkuvy+cBTkOM
   5vOSibyj0wKulG/rAgDEIdp1UZMjVuH+TY5+SR05nsNv+DCIr88MABMMY
   Y=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="614866194"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:23:00 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com (Postfix) with ESMTPS id B23D3804F3;
	Wed,  8 Nov 2023 11:22:57 +0000 (UTC)
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:52842]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.22.222:2525] with esmtp (Farcaster)
 id 7959fa46-ecea-470f-903c-012efedff35f; Wed, 8 Nov 2023 11:22:56 +0000 (UTC)
X-Farcaster-Flow-ID: 7959fa46-ecea-470f-903c-012efedff35f
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:22:56 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:22:51 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 22/33] KVM: Decouple kvm_ioctl_set_mem_attributes() from kvm's mem_attr_array
Date: Wed, 8 Nov 2023 11:17:55 +0000
Message-ID: <20231108111806.92604-23-nsaenz@amazon.com>
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

VSM will keep track of each VTL's memory protections in a separate
mem_attr_array. Access to these arrays will happen by issuing
KVM_SET_MEMORY_ATTRIBUTES ioctls to their respective KVM VTL devices
(which is also introduced in subsequent patches). Let the VTL devices
reuse kvm_ioctl_set_mem_attributes() by decoupling it from struct kvm's
mem_attr_array. The xarray is now input as a function argument as well
as the list of supported memory attributes.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 include/linux/kvm_host.h |  3 +++
 virt/kvm/kvm_main.c      | 32 ++++++++++++++++++++++----------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 652656444c45..ad104794037f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2394,6 +2394,9 @@ kvm_get_memory_attributes(struct xarray *mem_attr_array, gfn_t gfn)
 	return xa_to_value(xa_load(mem_attr_array, gfn));
 }
 
+int kvm_ioctl_set_mem_attributes(struct kvm *kvm, struct xarray *mem_attr_array,
+				 u64 supported_attrs,
+				 struct kvm_memory_attributes *attrs);
 bool kvm_range_has_memory_attributes(struct xarray *mem_attr_array, gfn_t start,
 				     gfn_t end, unsigned long attrs);
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f20dafaedc72..74c4c42b2126 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2554,8 +2554,9 @@ static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 }
 
 /* Set @attributes for the gfn range [@start, @end). */
-static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long attributes)
+static int kvm_set_mem_attributes(struct kvm *kvm,
+				  struct xarray *mem_attr_array, gfn_t start,
+				  gfn_t end, unsigned long attributes)
 {
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
@@ -2569,7 +2570,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		.start = start,
 		.end = end,
 		.arg.attributes = attributes,
-		.arg.mem_attr_array = &kvm->mem_attr_array,
+		.arg.mem_attr_array = mem_attr_array,
 		.handler = kvm_arch_post_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_end,
 		.may_block = true,
@@ -2583,7 +2584,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range as the desired attributes. */
-	if (kvm_range_has_memory_attributes(&kvm->mem_attr_array, start, end,
+	if (kvm_range_has_memory_attributes(mem_attr_array, start, end,
 					    attributes))
 		goto out_unlock;
 
@@ -2592,7 +2593,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	 * partway through setting the new attributes.
 	 */
 	for (i = start; i < end; i++) {
-		r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
+		r = xa_reserve(mem_attr_array, i, GFP_KERNEL_ACCOUNT);
 		if (r)
 			goto out_unlock;
 	}
@@ -2600,7 +2601,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	kvm_handle_gfn_range(kvm, &pre_set_range);
 
 	for (i = start; i < end; i++) {
-		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
+		r = xa_err(xa_store(mem_attr_array, i, entry,
 				    GFP_KERNEL_ACCOUNT));
 		KVM_BUG_ON(r, kvm);
 	}
@@ -2612,15 +2613,17 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	return r;
 }
-static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
-					   struct kvm_memory_attributes *attrs)
+
+int kvm_ioctl_set_mem_attributes(struct kvm *kvm, struct xarray *mem_attr_array,
+				 u64 supported_attrs,
+				 struct kvm_memory_attributes *attrs)
 {
 	gfn_t start, end;
 
 	/* flags is currently not used. */
 	if (attrs->flags)
 		return -EINVAL;
-	if (attrs->attributes & ~kvm_supported_mem_attributes(kvm))
+	if (attrs->attributes & ~supported_attrs)
 		return -EINVAL;
 	if (attrs->size == 0 || attrs->address + attrs->size < attrs->address)
 		return -EINVAL;
@@ -2637,7 +2640,16 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	 */
 	BUILD_BUG_ON(sizeof(attrs->attributes) != sizeof(unsigned long));
 
-	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
+	return kvm_set_mem_attributes(kvm, mem_attr_array, start, end,
+				      attrs->attributes);
+}
+
+static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
+					   struct kvm_memory_attributes *attrs)
+{
+	return kvm_ioctl_set_mem_attributes(kvm, &kvm->mem_attr_array,
+					    kvm_supported_mem_attributes(kvm),
+					    attrs);
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-- 
2.40.1


