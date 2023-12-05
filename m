Return-Path: <kvm+bounces-3491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C21EF805095
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EB4E281810
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD445C8E8;
	Tue,  5 Dec 2023 10:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UgEwxt1N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE53D5B
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/WIWJn1iZB/VaTuRHZ/wNE/HTwOYYLMKuDOTkRl2qY=;
	b=UgEwxt1NRcKqD4/KOawZVC8aGid6tEH3jzB5HsNWDZmOdgBRVM/dT2DYgQfLZmc/fWL2kC
	l20i4kcbRuy61LyT48hOFDjB3XxUYio2L4BLez9mv/IdFlZ6UP4DQEbYacNfonj2x5r1se
	mEaN7BJiHE5U4DPy1eyuP8LV7qilzfM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-v5sVJj1yOZKpwfW--DIlaw-1; Tue, 05 Dec 2023 05:36:33 -0500
X-MC-Unique: v5sVJj1yOZKpwfW--DIlaw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 544CC848C0C;
	Tue,  5 Dec 2023 10:36:33 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 804E720271F4;
	Tue,  5 Dec 2023 10:36:32 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 01/16] KVM: x86: xen: Remove unneeded xen context from struct kvm_arch when !CONFIG_KVM_XEN
Date: Tue,  5 Dec 2023 11:36:15 +0100
Message-ID: <20231205103630.1391318-2-vkuznets@redhat.com>
In-Reply-To: <20231205103630.1391318-1-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Saving a few bytes of memory per KVM VM is certainly great but what's more
important is the ability to see where the code accesses Xen emulation
context while CONFIG_KVM_XEN is not enabled. Currently, kvm_cpu_get_extint()
is the only such place and it is harmless: kvm_xen_has_interrupt() always
returns '0' when !CONFIG_KVM_XEN.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/irq.c              | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a565a2e70f30..ecf11b963382 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1136,6 +1136,7 @@ struct msr_bitmap_range {
 	unsigned long *bitmap;
 };
 
+#ifdef CONFIG_KVM_XEN
 /* Xen emulation context */
 struct kvm_xen {
 	struct mutex xen_lock;
@@ -1147,6 +1148,7 @@ struct kvm_xen {
 	struct idr evtchn_ports;
 	unsigned long poll_mask[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 };
+#endif
 
 enum kvm_irqchip_mode {
 	KVM_IRQCHIP_NONE,
@@ -1349,7 +1351,10 @@ struct kvm_arch {
 	struct hlist_head mask_notifier_list;
 
 	struct kvm_hv hyperv;
+
+#ifdef CONFIG_KVM_XEN
 	struct kvm_xen xen;
+#endif
 
 	bool backwards_tsc_observed;
 	bool boot_vcpu_runs_old_kvmclock;
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b2c397dd2bc6..ad9ca8a60144 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -118,8 +118,10 @@ static int kvm_cpu_get_extint(struct kvm_vcpu *v)
 	if (!lapic_in_kernel(v))
 		return v->arch.interrupt.nr;
 
+#ifdef CONFIG_KVM_XEN
 	if (kvm_xen_has_interrupt(v))
 		return v->kvm->arch.xen.upcall_vector;
+#endif
 
 	if (irqchip_split(v->kvm)) {
 		int vector = v->arch.pending_external_vector;
-- 
2.43.0


