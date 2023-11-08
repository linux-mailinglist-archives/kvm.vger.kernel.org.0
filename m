Return-Path: <kvm+bounces-1180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 567BC7E554B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D36D7B20F77
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBF5179A2;
	Wed,  8 Nov 2023 11:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="n49ZCsyV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1E717990;
	Wed,  8 Nov 2023 11:23:58 +0000 (UTC)
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11AF1FCE;
	Wed,  8 Nov 2023 03:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442639; x=1730978639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xf82pqS3tbHruxRFe/9qoNTFiZgXupnu5dstVI/jtoA=;
  b=n49ZCsyVQdBfWID3w3tnCBi3s065Hx05roSFRRi6awKchxMxny7b+b69
   HhnWSkpHhcSGMlybeE8G089x52+EEHlLGVd4LeZs4cL/WS55zTRzr6NwB
   c5+xOnVsQ4SzsfvX1nxSycy2CZGiLr1+fZZMkgEOY4RWbkrUIPtEyEE9E
   8=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="164959696"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:23:48 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id 5BC8140D4F;
	Wed,  8 Nov 2023 11:23:46 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:21927]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.4.34:2525] with esmtp (Farcaster)
 id c9b4010e-6bfd-4a71-a295-fab821898611; Wed, 8 Nov 2023 11:23:45 +0000 (UTC)
X-Farcaster-Flow-ID: c9b4010e-6bfd-4a71-a295-fab821898611
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:23:40 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:23:35 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 26/33] KVM: x86: hyper-vsm: Allow setting per-VTL memory attributes
Date: Wed, 8 Nov 2023 11:17:59 +0000
Message-ID: <20231108111806.92604-27-nsaenz@amazon.com>
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

Introduce KVM_SET_MEMORY_ATTRIBUTES ioctl support for VTL KVM devices.
The attributes are stored in an xarray private to the VTL device.

The following memory attributes are supported:
 - KVM_MEMORY_ATTRIBUTE_READ
 - KVM_MEMORY_ATTRIBUTE_WRITE
 - KVM_MEMORY_ATTRIBUTE_EXECUTE
 - KVM_MEMORY_ATTRIBUTE_NO_ACCESS
Although only some combinations are valid, see code comment below.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c | 61 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 0d8402dba596..bcace0258af1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -62,6 +62,10 @@
  */
 #define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
 
+#define KVM_HV_VTL_ATTRS						\
+	(KVM_MEMORY_ATTRIBUTE_READ | KVM_MEMORY_ATTRIBUTE_WRITE |	\
+	 KVM_MEMORY_ATTRIBUTE_EXECUTE | KVM_MEMORY_ATTRIBUTE_NO_ACCESS)
+
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 				bool vcpu_kick);
 
@@ -3025,6 +3029,7 @@ int kvm_vm_ioctl_get_hv_vsm_state(struct kvm *kvm, struct kvm_hv_vsm_state *stat
 
 struct kvm_hv_vtl_dev {
 	int vtl;
+	struct xarray mem_attrs;
 };
 
 static int kvm_hv_vtl_get_attr(struct kvm_device *dev,
@@ -3047,16 +3052,71 @@ static void kvm_hv_vtl_release(struct kvm_device *dev)
 {
 	struct kvm_hv_vtl_dev *vtl_dev = dev->private;
 
+	xa_destroy(&vtl_dev->mem_attrs);
 	kfree(vtl_dev);
 	kfree(dev); /* alloc by kvm_ioctl_create_device, free by .release */
 }
 
+/*
+ * The TLFS lists the valid memory protection combinations (15.9.3):
+ *  - No access
+ *  - Read-only, no execute
+ *  - Read-only, execute
+ *  - Read/write, no execute
+ *  - Read/write, execute
+ */
+static bool kvm_hv_validate_vtl_mem_attributes(struct kvm_memory_attributes *attrs)
+{
+	u64 attr = attrs->attributes;
+
+	if (attr & ~KVM_HV_VTL_ATTRS)
+		return false;
+
+	if (attr == KVM_MEMORY_ATTRIBUTE_NO_ACCESS)
+		return true;
+
+	if (!(attr & KVM_MEMORY_ATTRIBUTE_READ))
+		return false;
+
+	return true;
+}
+
+static long kvm_hv_vtl_ioctl(struct kvm_device *dev, unsigned int ioctl,
+			     unsigned long arg)
+{
+	switch (ioctl) {
+	case KVM_SET_MEMORY_ATTRIBUTES: {
+		struct kvm_hv_vtl_dev *vtl_dev = dev->private;
+		struct kvm_memory_attributes attrs;
+		int r;
+
+		if (copy_from_user(&attrs, (void __user *)arg, sizeof(attrs)))
+			return -EFAULT;
+
+		r = -EINVAL;
+		if (!kvm_hv_validate_vtl_mem_attributes(&attrs))
+			return r;
+
+		r = kvm_ioctl_set_mem_attributes(dev->kvm, &vtl_dev->mem_attrs,
+						 KVM_HV_VTL_ATTRS, &attrs);
+		if (r)
+			return r;
+		break;
+	}
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
 static int kvm_hv_vtl_create(struct kvm_device *dev, u32 type);
 
 static struct kvm_device_ops kvm_hv_vtl_ops = {
 	.name = "kvm-hv-vtl",
 	.create = kvm_hv_vtl_create,
 	.release = kvm_hv_vtl_release,
+	.ioctl = kvm_hv_vtl_ioctl,
 	.get_attr = kvm_hv_vtl_get_attr,
 };
 
@@ -3076,6 +3136,7 @@ static int kvm_hv_vtl_create(struct kvm_device *dev, u32 type)
 			vtl++;
 
 	vtl_dev->vtl = vtl;
+	xa_init(&vtl_dev->mem_attrs);
 	dev->private = vtl_dev;
 
 	return 0;
-- 
2.40.1


