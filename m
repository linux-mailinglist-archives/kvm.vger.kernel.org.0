Return-Path: <kvm+bounces-1177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC92C7E5543
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F8581F22010
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1D0171C9;
	Wed,  8 Nov 2023 11:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="dsR9+nlN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D649E171A0;
	Wed,  8 Nov 2023 11:23:38 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B892121;
	Wed,  8 Nov 2023 03:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442618; x=1730978618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+clN3KXok8ZiZV9OuN8bZTBQbm7LUM4xz0FNLSqP1yE=;
  b=dsR9+nlNTvZWeN36ejoNmpatN4/sGj4vb+gYBXXzAUK9DNcGWYxrzcHa
   5mFbkC4BobvbVurjLKznBiWxyIDlS1NdtuzwFIjhDafgssbNWdE61ND1T
   LDMga9lGx/YD2m3KACHUM3y5y8TCyykxkt7CheOxLSVlX2DgSJRQWB7VP
   U=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="42020483"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:23:34 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 7D955A685E;
	Wed,  8 Nov 2023 11:23:31 +0000 (UTC)
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:25245]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.4.34:2525] with esmtp (Farcaster)
 id 5d05d07b-01a7-4a6a-845a-8ba989f4a5df; Wed, 8 Nov 2023 11:23:30 +0000 (UTC)
X-Farcaster-Flow-ID: 5d05d07b-01a7-4a6a-845a-8ba989f4a5df
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:23:30 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:23:25 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 24/33] KVM: x86: hyper-v: Introduce KVM VTL device
Date: Wed, 8 Nov 2023 11:17:57 +0000
Message-ID: <20231108111806.92604-25-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D035UWB001.ant.amazon.com (10.13.138.33) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Introduce a new KVM device aimed at tracking partition wide VTL state,
it'll be the one responsible from keeping track of VTL's memory
protections. For now its functionality it's limited, it only exposes its
VTL level through a device attribute. Additionally, the device type is
only registered if the VSM cap is enabled.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c    | 68 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h    |  3 ++
 arch/x86/kvm/x86.c       |  3 ++
 include/uapi/linux/kvm.h |  5 +++
 4 files changed, 79 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a266c5d393f5..0d8402dba596 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -3022,3 +3022,71 @@ int kvm_vm_ioctl_get_hv_vsm_state(struct kvm *kvm, struct kvm_hv_vsm_state *stat
 	state->vsm_code_page_offsets = hv->vsm_code_page_offsets.as_u64;
 	return 0;
 }
+
+struct kvm_hv_vtl_dev {
+	int vtl;
+};
+
+static int kvm_hv_vtl_get_attr(struct kvm_device *dev,
+			       struct kvm_device_attr *attr)
+{
+	struct kvm_hv_vtl_dev *vtl_dev = dev->private;
+
+	switch (attr->group) {
+	case KVM_DEV_HV_VTL_GROUP:
+	switch (attr->attr){
+	case KVM_DEV_HV_VTL_GROUP_VTLNUM:
+		return put_user(vtl_dev->vtl, (u32 __user *)attr->addr);
+	}
+	}
+
+	return -EINVAL;
+}
+
+static void kvm_hv_vtl_release(struct kvm_device *dev)
+{
+	struct kvm_hv_vtl_dev *vtl_dev = dev->private;
+
+	kfree(vtl_dev);
+	kfree(dev); /* alloc by kvm_ioctl_create_device, free by .release */
+}
+
+static int kvm_hv_vtl_create(struct kvm_device *dev, u32 type);
+
+static struct kvm_device_ops kvm_hv_vtl_ops = {
+	.name = "kvm-hv-vtl",
+	.create = kvm_hv_vtl_create,
+	.release = kvm_hv_vtl_release,
+	.get_attr = kvm_hv_vtl_get_attr,
+};
+
+static int kvm_hv_vtl_create(struct kvm_device *dev, u32 type)
+{
+	struct kvm_hv_vtl_dev *vtl_dev;
+	struct kvm_device *tmp;
+	int vtl = 0;
+
+	vtl_dev = kzalloc(sizeof(*vtl_dev), GFP_KERNEL_ACCOUNT);
+	if (!vtl_dev)
+		return -ENOMEM;
+
+	/* Device creation is protected by kvm->lock */
+	list_for_each_entry(tmp, &dev->kvm->devices, vm_node)
+		if (tmp->ops == &kvm_hv_vtl_ops)
+			vtl++;
+
+	vtl_dev->vtl = vtl;
+	dev->private = vtl_dev;
+
+	return 0;
+}
+
+int kvm_hv_vtl_dev_register(void)
+{
+	return kvm_register_device_ops(&kvm_hv_vtl_ops, KVM_DEV_TYPE_HV_VSM_VTL);
+}
+
+void kvm_hv_vtl_dev_unregister(void)
+{
+	kvm_unregister_device_ops(KVM_DEV_TYPE_HV_VSM_VTL);
+}
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 605e80b9e5eb..3cc664e144d8 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -269,4 +269,7 @@ static inline void kvm_mmu_role_set_hv_bits(struct kvm_vcpu *vcpu,
 	role->vtl = kvm_hv_get_active_vtl(vcpu);
 }
 
+int kvm_hv_vtl_dev_register(void);
+void kvm_hv_vtl_dev_unregister(void);
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf4891bc044e..82d3b86d9c93 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6521,6 +6521,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_HYPERV_VSM:
+		kvm_hv_vtl_dev_register();
 		kvm->arch.hyperv.hv_enable_vsm = true;
 		r = 0;
 		break;
@@ -9675,6 +9676,8 @@ void kvm_x86_vendor_exit(void)
 	mutex_lock(&vendor_module_lock);
 	kvm_x86_ops.hardware_enable = NULL;
 	mutex_unlock(&vendor_module_lock);
+
+	kvm_hv_vtl_dev_unregister();
 }
 EXPORT_SYMBOL_GPL(kvm_x86_vendor_exit);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0ddffb8b0c99..bd97c9852142 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1471,6 +1471,9 @@ struct kvm_device_attr {
 #define   KVM_DEV_VFIO_GROUP_DEL	KVM_DEV_VFIO_FILE_DEL
 #define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE		3
 
+#define KVM_DEV_HV_VTL_GROUP		1
+#define  KVM_DEV_HV_VTL_GROUP_VTLNUM		1
+
 enum kvm_device_type {
 	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
 #define KVM_DEV_TYPE_FSL_MPIC_20	KVM_DEV_TYPE_FSL_MPIC_20
@@ -1494,6 +1497,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_RISCV_AIA,
 #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
+	KVM_DEV_TYPE_HV_VSM_VTL,
+#define KVM_DEV_TYPE_HV_VSM_VTL		KVM_DEV_TYPE_HV_VSM_VTL
 	KVM_DEV_TYPE_MAX,
 };
 
-- 
2.40.1


