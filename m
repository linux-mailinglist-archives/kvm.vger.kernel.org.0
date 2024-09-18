Return-Path: <kvm+bounces-27082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D698F97BE95
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60B201F21D83
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583301C8FD6;
	Wed, 18 Sep 2024 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="u4r8IaIV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC42C79FD
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673301; cv=none; b=soZpPnf8gbjnNdWnD611J0Dj/WjNBj22k+UmhkpKIgbm/RjhVPEN2/LGfR+p6202L81v4rRyyUsW4kaN60cqu0jdZHo6JA9TYde8a0BcOLrgIAJIaO/LRK8ExRO8n37nfSFPo41VHuHJ7J0QKH6oT8ID111UZpRabCMymm3lXtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673301; c=relaxed/simple;
	bh=kh2YDaGShz5thW3QPhYpY9fgec3JXqODlV0AI1myx1A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DrLa6jwC7P0Rep1rNcJ9mi/DZVlz0lpD95QHXaxUomp0rxpHmH8mrchzi54wSqVtxJCJB4C1LumlX0BATSwySfDuB0cxxQ2KP1BQR3X8KIHLtg473R+B6EmeYYCl6Nig+urr0Mz3gXlN7hFgunWpCaX+rtnOOpCAwLnSqdOUn5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=u4r8IaIV; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726673300; x=1758209300;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=0Jyj0savNbJCLUK2pqQ1ijmSGedpVV92FizpmekSTfE=;
  b=u4r8IaIVyRCR8RAxJLQH3hZWu1HIcISEpEjRoFssVqPo2qo3zouN4uhZ
   OYvMYuoP2fJCyuo+3cjm5hcgePvqi6FTUxNvqDXOm7OVmaacyGItGwTbF
   GSzEhj0mvzB2ojav0HqJilKD6lMr7sHonKPieUTW+f6fw1UWC3/RsdQPp
   I=;
X-IronPort-AV: E=Sophos;i="6.10,239,1719878400"; 
   d="scan'208";a="659813185"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 15:28:18 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:13771]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.46.202:2525] with esmtp (Farcaster)
 id eb63749e-64ec-4474-a98c-96448a4608db; Wed, 18 Sep 2024 15:28:16 +0000 (UTC)
X-Farcaster-Flow-ID: eb63749e-64ec-4474-a98c-96448a4608db
Received: from EX19D018EUC004.ant.amazon.com (10.252.51.172) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:16 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D018EUC004.ant.amazon.com (10.252.51.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:15 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 18 Sep 2024 15:28:15 +0000
Received: from dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com (dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com [172.19.104.233])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTPS id 487D94043E;
	Wed, 18 Sep 2024 15:28:14 +0000 (UTC)
From: Lilit Janpoladyan <lilitj@amazon.com>
To: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<nh-open-source@amazon.com>, <lilitj@amazon.com>
Subject: [PATCH 2/8] KVM: arm64: add page tracking device as a capability
Date: Wed, 18 Sep 2024 15:28:01 +0000
Message-ID: <20240918152807.25135-3-lilitj@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240918152807.25135-1-lilitj@amazon.com>
References: <20240918152807.25135-1-lilitj@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Add new capability KVM_CAP_ARM_PAGE_TRACKING_DEVICE to use page tracking
device for dirty logging. The capability can be used only if platform
supports such a device i.e. when KVM_CAP_ARM_PAGE_TRACKING_DEVICE
extension is supported. Until there is dirty ring support, make new
capability incompatible with the use of dirty ring.

When page tracking device is in use, instead of logging dirty pages on
faults KVM will collect a list of dirty pages from the device when
userspace reads dirty bitmap.

Signed-off-by: Lilit Janpoladyan <lilitj@amazon.com>
---
 Documentation/virt/kvm/api.rst    | 17 +++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 17 +++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 4 files changed, 37 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b3be87489108..989d5dd886fb 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8950,6 +8950,23 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
 production.  The behavior and effective ABI for software-protected VMs is
 unstable.
 
+8.42 KVM_CAP_ARM_PAGE_TRACKING_DEVICE
+_____________________________________
+
+:Capability: KVM_CAP_ARM_PAGE_TRACKING_DEVICE
+:Architecture: arm64
+:Type: vm
+:Parameters: arg[0] whether feature should be enabled or not
+:Returns 0 on success, -errno on failure
+
+This capability enables or disables hardware assistance for dirty page logging.
+
+In case page tracking device is available (i.e. if the host supports the
+KVM_CAP_ARM_PAGE_TRACKING_DEVICE extension), the device can be used to accelerate
+dirty logging. This capability turns the acceleration on and off.
+
+Not compatible with KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..5b5e3647fbda 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -326,6 +326,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		7
 	/* Fine-Grained UNDEF initialised */
 #define KVM_ARCH_FLAG_FGU_INITIALIZED			8
+	/* Page tracking device enabled */
+#define KVM_ARCH_FLAG_PAGE_TRACKING_DEVICE_ENABLED	9
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9bef7638342e..aea56df8ac04 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -40,6 +40,7 @@
 #include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_ptrauth.h>
+#include <asm/page_tracking.h>
 #include <asm/sections.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -149,6 +150,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_ARM_PAGE_TRACKING_DEVICE:
+		if (page_tracking_device_registered() &&
+		    !kvm->dirty_ring_size /* Does not support dirty ring yet */) {
+
+			r = 0;
+			if (cap->args[0])
+				set_bit(KVM_ARCH_FLAG_PAGE_TRACKING_DEVICE_ENABLED,
+					&kvm->arch.flags);
+			else
+				clear_bit(KVM_ARCH_FLAG_PAGE_TRACKING_DEVICE_ENABLED,
+					  &kvm->arch.flags);
+		}
+		break;
 	default:
 		break;
 	}
@@ -416,6 +430,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
 		r = BIT(0);
 		break;
+	case KVM_CAP_ARM_PAGE_TRACKING_DEVICE:
+		r = page_tracking_device_registered();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..552ebede3f9d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -933,6 +933,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_ARM_PAGE_TRACKING_DEVICE 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.40.1


