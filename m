Return-Path: <kvm+bounces-36423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DEDA1A9F2
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 20:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28CF0188AF24
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 19:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E203B1ADC73;
	Thu, 23 Jan 2025 19:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="uvLv3gxW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9DE14A4FB;
	Thu, 23 Jan 2025 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737659033; cv=none; b=tDlOhl1Nao7pkOLza0S4F9wHkedwbP9TZFl8/E+Z80VnMnSO0EVTYjzTcKzB+jLIMa6kLR5/02ZScOJlEsjupmNsx7ZeNT7fdSesmVuGoKgl2qoDK6SMhFz9UlO+nZ7Ze6r/sGExuDFYPA6G9POsx/erXUh1Qyjm1t29AKsLKOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737659033; c=relaxed/simple;
	bh=v6WY3ejYSVEbWP8+euITQ1sLLWgQLcrQl1w2qb4OhZE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PYCD1mHd/cSKXafvY84Z0EABpXvnlsH8WlhRMH6fE0O1k2cGmhS0GGigsrJxmAg0HyReGbbGrKxDDVNQ4EUWsg/S8nwAuWS6r9PbOxnNY5seV/FtfxqSzdtveUKGhz8pFDZhvxZs3hV+Fe01P0TQ1JBxYGu4fPOonbMmkikluBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=uvLv3gxW; arc=none smtp.client-ip=99.78.197.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1737659031; x=1769195031;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+Weo7nq53cssNLx9atS4Hnhx+PvjEQq16dcM+yILaQM=;
  b=uvLv3gxWAq7XGlseEpQQH1utM1q5IInaIMLT6AAOLoLcTtmV4G1APr9W
   u+Dr7zZnCXiOGBhjC3UtPZ2R+UnsMpJGDFd2aG+teKt2q27l2jsbTo0Nj
   4Z/hZj29FahuKSpYNMOMqpYGC7fMheWGgpxhC/AWDx1n3OyfjtnzHmb+j
   Y=;
X-IronPort-AV: E=Sophos;i="6.13,229,1732579200"; 
   d="scan'208";a="16652907"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 19:03:48 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:39723]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.45.135:2525] with esmtp (Farcaster)
 id 9206942a-a86a-4a56-bf96-3f7a958e444a; Thu, 23 Jan 2025 19:03:47 +0000 (UTC)
X-Farcaster-Flow-ID: 9206942a-a86a-4a56-bf96-3f7a958e444a
Received: from EX19D007EUA003.ant.amazon.com (10.252.50.8) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 23 Jan 2025 19:03:46 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUA003.ant.amazon.com (10.252.50.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 23 Jan 2025 19:03:46 +0000
Received: from email-imr-corp-prod-iad-all-1a-059220b4.us-east-1.amazon.com
 (10.43.8.6) by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Thu, 23 Jan 2025 19:03:45 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com (dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com [10.13.244.152])
	by email-imr-corp-prod-iad-all-1a-059220b4.us-east-1.amazon.com (Postfix) with ESMTPS id 961B2420F6;
	Thu, 23 Jan 2025 19:03:44 +0000 (UTC)
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <kvm@vger.kernel.org>
CC: <griffoul@gmail.com>, <vkuznets@redhat.com>, Fred Griffoul
	<fgriffo@amazon.co.uk>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant
	<paul@xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: x86: Update Xen TSC leaves during CPUID emulation
Date: Thu, 23 Jan 2025 19:02:53 +0000
Message-ID: <20250123190253.25891-1-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The Xen emulation in KVM modifies certain CPUID leaves to expose
TSC information to the guest.

Previously, these CPUID leaves were updated whenever guest time changed,
but this conflicts with KVM_SET_CPUID/KVM_SET_CPUID2 ioctls which reject
changes to CPUID entries on running vCPUs.

Fix this by updating the TSC information directly in the CPUID emulation
handler instead of modifying the vCPU's CPUID entries.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/kvm/cpuid.c |  3 ++-
 arch/x86/kvm/x86.c   |  1 -
 arch/x86/kvm/xen.c   | 24 ------------------------
 arch/x86/kvm/xen.h   | 21 +++++++++++++++++++--
 4 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index edef30359c19..77f50273d902 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -2005,7 +2005,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		} else if (function == 0x80000007) {
 			if (kvm_hv_invtsc_suppressed(vcpu))
 				*edx &= ~feature_bit(CONSTANT_TSC);
-		}
+		} else
+			kvm_xen_may_update_tsc_info(vcpu, function, index, eax, ecx, edx);
 	} else {
 		*eax = *ebx = *ecx = *edx = 0;
 		/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..2e4aaa028238 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3253,7 +3253,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				   &vcpu->hv_clock.tsc_shift,
 				   &vcpu->hv_clock.tsc_to_system_mul);
 		vcpu->hw_tsc_khz = tgt_tsc_khz;
-		kvm_xen_update_tsc_info(v);
 	}
 
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a909b817b9c0..f5d1c8132bec 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -23,7 +23,6 @@
 #include <xen/interface/event_channel.h>
 #include <xen/interface/sched.h>
 
-#include <asm/xen/cpuid.h>
 #include <asm/pvclock.h>
 
 #include "cpuid.h"
@@ -2247,29 +2246,6 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 	del_timer_sync(&vcpu->arch.xen.poll_timer);
 }
 
-void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid_entry2 *entry;
-	u32 function;
-
-	if (!vcpu->arch.xen.cpuid.base)
-		return;
-
-	function = vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3);
-	if (function > vcpu->arch.xen.cpuid.limit)
-		return;
-
-	entry = kvm_find_cpuid_entry_index(vcpu, function, 1);
-	if (entry) {
-		entry->ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
-		entry->edx = vcpu->arch.hv_clock.tsc_shift;
-	}
-
-	entry = kvm_find_cpuid_entry_index(vcpu, function, 2);
-	if (entry)
-		entry->eax = vcpu->arch.hw_tsc_khz;
-}
-
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	mutex_init(&kvm->arch.xen.xen_lock);
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index f5841d9000ae..03ee7d28519a 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -10,6 +10,7 @@
 #define __ARCH_X86_KVM_XEN_H__
 
 #include <asm/xen/hypervisor.h>
+#include <asm/xen/cpuid.h>
 
 #ifdef CONFIG_KVM_XEN
 #include <linux/jump_label_ratelimit.h>
@@ -35,7 +36,6 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
 int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
 			 const struct kvm_irq_routing_entry *ue);
-void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
 
 static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
 {
@@ -92,6 +92,21 @@ static inline int kvm_xen_has_pending_timer(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline void kvm_xen_may_update_tsc_info(struct kvm_vcpu *vcpu,
+					       u32 function, u32 index,
+					       u32 *eax, u32 *ecx, u32 *edx)
+{
+	u32 base = vcpu->arch.xen.cpuid.base;
+
+	if (base && (function == (base | XEN_CPUID_LEAF(3)))) {
+		if (index == 1) {
+			*ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
+			*edx = vcpu->arch.hv_clock.tsc_shift;
+		} else if (index == 2)
+			*eax = vcpu->arch.hw_tsc_khz;
+	}
+}
+
 void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu);
 #else
 static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
@@ -157,7 +172,9 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
 	return false;
 }
 
-static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
+static inline void kvm_xen_may_update_tsc_info(struct kvm_vcpu *vcpu,
+					       u32 function, u32 index,
+					       u32 *eax, u32 *ecx, u32 *edx)
 {
 }
 #endif
-- 
2.40.1


