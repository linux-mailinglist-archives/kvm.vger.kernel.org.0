Return-Path: <kvm+bounces-44201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF41FA9B534
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:28:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 611549257EA
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3CC28D827;
	Thu, 24 Apr 2025 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="anS+6W0Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9400E28A40A
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745515721; cv=none; b=dAM0L1CaIuRdR7yH7F2DB5uuA6gZzRKvSLabhtLv5M+thkvwv/RThinCRviO8mbQa8bCwp+K72TOoAaerox6UhXXkOLveJeFXNIGjjzHnT5m6f0/gyjR29+WGZKjhnYc5HE7DtakzezQwlCZgOqSqM2sqlgGsWFKZSKg+EbmzwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745515721; c=relaxed/simple;
	bh=1HqLQ3YZh70ZNkGmU2mK9InfcNAWorDdlkXLec74Sqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nO3Z/MjKG1VocpNZxVfab2YfBMHzzXQYtHbwdxaMMkLUZ2ztibKJ2XswEB59q7lU2JPrYCbjr8nLBMYvZ3VtFXbdoZNYRSUGTf6m5pPKK5j7pFny4dVVsFOHKP6peJGHYvNJJainDTf7zFNdsHtO2i2m5nsooLvxMQ2vMtwZTWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=anS+6W0Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745515718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9ZG9YrbKiFItvh1cWxjw3CM1aJWpjuP1SdA+uk1qv0I=;
	b=anS+6W0QwYvLYI+Zyxy6Y/z5NTCG5umSG8Ek09oAP0EbgleK9hmHLr0xi2NIAVm7AJHVyT
	tOGaDZEK6edcqVDSvCHMjHG9VUe3dWN1iE95pVPdmnGXnmdNn6YbhcpqhP4nccnZv4OzUc
	kI7AdbY6z/vWrjQRJ7l5VAwer4srpJ4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303--wJBHBPbP0WIvcChOE1VOQ-1; Thu,
 24 Apr 2025 13:28:35 -0400
X-MC-Unique: -wJBHBPbP0WIvcChOE1VOQ-1
X-Mimecast-MFC-AGG-ID: -wJBHBPbP0WIvcChOE1VOQ_1745515714
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6E8D1800879;
	Thu, 24 Apr 2025 17:28:33 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 367381800374;
	Thu, 24 Apr 2025 17:28:33 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	oliver.upton@linux.dev
Subject: [PATCH v2] KVM: arm64, x86: make kvm_arch_has_irq_bypass() inline
Date: Thu, 24 Apr 2025 13:28:32 -0400
Message-ID: <20250424172832.401651-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

kvm_arch_has_irq_bypass() is a small function and even though it does
not appear in any *really* hot paths, it's also not entirely rare.
Make it inline---it also works out nicely in preparation for using it in
kvm-intel.ko and kvm-amd.ko, since the function is not currently exported.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
v1->v2: leave extern declaration in place and don't touch arch/powerpc [Sean]

 arch/arm64/include/asm/kvm_host.h | 5 +++++
 arch/arm64/kvm/arm.c              | 5 -----
 arch/x86/include/asm/kvm_host.h   | 6 ++++++
 arch/x86/kvm/x86.c                | 5 -----
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e98cfe7855a6..08ba91e6fb03 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1588,4 +1588,9 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+static inline bool kvm_arch_has_irq_bypass(void)
+{
+	return true;
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 68fec8c95fee..19ca57def629 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2743,11 +2743,6 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
 	return irqchip_in_kernel(kvm);
 }
 
-bool kvm_arch_has_irq_bypass(void)
-{
-	return true;
-}
-
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bdae454a959..7bc174a1f1cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -35,6 +35,7 @@
 #include <asm/mtrr.h>
 #include <asm/msr-index.h>
 #include <asm/asm.h>
+#include <asm/irq_remapping.h>
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/reboot.h>
@@ -2423,4 +2424,9 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+static inline bool kvm_arch_has_irq_bypass(void)
+{
+	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
+}
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3712dde0bf9d..c1fdd527044c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13556,11 +13556,6 @@ bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
 
-bool kvm_arch_has_irq_bypass(void)
-{
-	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
-}
-
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
-- 
2.43.5


