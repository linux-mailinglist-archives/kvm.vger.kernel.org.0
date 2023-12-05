Return-Path: <kvm+bounces-3485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F4680508A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 818E02817B0
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E398E59E56;
	Tue,  5 Dec 2023 10:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TG/SFBSc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E7ED6C
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YTmtFQB9aJWif+75s3pXmYiwr5mMXHae5k8OhTlgFfo=;
	b=TG/SFBScP0NKVMR35/zp/UcSVDdeprhWf6zSWU14KaONqnman2Y1LDd6a2eq5DaXseNzIi
	z2PvJtpiIYKhZ6Np7uZlnDqQG1MO8Z3B+7w/DuOZXzaSXcYYIJMNitRPFav1H7QlIcCc33
	fNpK2QocVUwrmUCcQmr71RULzkjCrdQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-103-f5bvDZctOg27tLnNDe6Mcg-1; Tue,
 05 Dec 2023 05:36:38 -0500
X-MC-Unique: f5bvDZctOg27tLnNDe6Mcg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEF123C28647;
	Tue,  5 Dec 2023 10:36:37 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC0A82026D66;
	Tue,  5 Dec 2023 10:36:36 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 05/16] KVM: x86: hyper-v: Introduce kvm_hv_synic_has_vector()
Date: Tue,  5 Dec 2023 11:36:19 +0100
Message-ID: <20231205103630.1391318-6-vkuznets@redhat.com>
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

As a preparation to making Hyper-V emulation optional, create a dedicated
kvm_hv_synic_has_vector() helper to avoid extra ifdefs in lapic.c.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.h | 5 +++++
 arch/x86/kvm/lapic.c  | 3 +--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 1897a219981d..ddb1d0b019e6 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -105,6 +105,11 @@ int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 
+static inline bool kvm_hv_synic_has_vector(struct kvm_vcpu *vcpu, int vector)
+{
+	return to_hv_vcpu(vcpu) && test_bit(vector, to_hv_synic(vcpu)->vec_bitmap);
+}
+
 static inline bool kvm_hv_synic_auto_eoi_set(struct kvm_vcpu *vcpu, int vector)
 {
 	return to_hv_vcpu(vcpu) && test_bit(vector, to_hv_synic(vcpu)->auto_eoi_bitmap);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f7abc1008cad..3242f3da2457 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1475,8 +1475,7 @@ static int apic_set_eoi(struct kvm_lapic *apic)
 	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
 
-	if (to_hv_vcpu(apic->vcpu) &&
-	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
+	if (kvm_hv_synic_has_vector(apic->vcpu, vector))
 		kvm_hv_synic_send_eoi(apic->vcpu, vector);
 
 	kvm_ioapic_send_eoi(apic, vector);
-- 
2.43.0


