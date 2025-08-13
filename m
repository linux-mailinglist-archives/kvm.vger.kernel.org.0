Return-Path: <kvm+bounces-54607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B6779B253E8
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 21:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 716774E5578
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 19:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC4430AADF;
	Wed, 13 Aug 2025 19:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R4ecLTrm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1703093D2
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 19:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755113010; cv=none; b=T86Q1/9FmeA8qKgAzdAhpuIhWKX6UnNV7kc1BKdNV5wGAQsUpcTw6dH8iD4RXiPlYUSzHIwG5pzJ3Q3MnS5WKeElqJTmVj64BBdyeFe7F1+72LRlG6KkdS0r82Dym7RslOx4ClIdVKlHEeM3v/HnB/VybAlKH9jfYmMiTJS7uHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755113010; c=relaxed/simple;
	bh=yxcC6PLyvoIXiffU0zsBAi0/CVilixTwnZojV2rns+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jA6xdKCCdex5LUrD6AzLV+cWtZEIA4b8IBPQqpy+l+zM9SPO4j5kT2ki0jbde7bXb1a3KjVrqLFyw9WQ1z0Sk3Y6PCg3fDfeOutSqkhluCnsEgAwcCmwIxNd82BTgrkT/V0iSa5mA4dXN8XaXPKg2foi7EpayF3MvdZEiyO1zTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R4ecLTrm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755113008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PibFBteea+MuunP9PzGwGNdUntQRuEWOqjmto8Lktc4=;
	b=R4ecLTrmIRnBCkDlyM/WyS/Hyu7cKmCKZF6uVyiQTXLtWy2R4vQkiU+znbAe7Wgo/s1Rij
	B9STGTaCNx9EDHG1EqyK7l0210QgQ5eQ3ruX6preGKTB/DFfjTYTRHohayPu1zmnOVOZYR
	ngYf3e42onDlHH+GPw6LVL7gm3H1esE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-b_EBlnJHMJO6R14sPRUe4w-1; Wed,
 13 Aug 2025 15:23:23 -0400
X-MC-Unique: b_EBlnJHMJO6R14sPRUe4w-1
X-Mimecast-MFC-AGG-ID: b_EBlnJHMJO6R14sPRUe4w_1755113001
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CF551956058;
	Wed, 13 Aug 2025 19:23:21 +0000 (UTC)
Received: from intellaptop.redhat.com (unknown [10.22.81.148])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1FBDF195608F;
	Wed, 13 Aug 2025 19:23:18 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/3] KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present_queued
Date: Wed, 13 Aug 2025 15:23:12 -0400
Message-ID: <20250813192313.132431-3-mlevitsk@redhat.com>
In-Reply-To: <20250813192313.132431-1-mlevitsk@redhat.com>
References: <20250813192313.132431-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix a semi theoretical race condition in reading of page_ready_pending
in kvm_arch_async_page_present_queued.

Only trust the value of page_ready_pending if the guest is about to
enter guest mode (vcpu->mode).

To achieve this, read the vcpu->mode using smp_load_acquire which is
paired with smp_store_release in vcpu_enter_guest.

Then only if vcpu_mode is IN_GUEST_MODE, trust the value of the
page_ready_pending because it was written before and therefore its correct
value is visible.

Also if the above mentioned check is true, avoid raising the request
on the target vCPU.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9018d56b4b0a..3d45a4cd08a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13459,9 +13459,14 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 
 void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
 {
-	kvm_make_request(KVM_REQ_APF_READY, vcpu);
-	if (!vcpu->arch.apf.pageready_pending)
+	/* Pairs with smp_store_release in vcpu_enter_guest. */
+	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
+	bool page_ready_pending = READ_ONCE(vcpu->arch.apf.pageready_pending);
+
+	if (!in_guest_mode || !page_ready_pending) {
+		kvm_make_request(KVM_REQ_APF_READY, vcpu);
 		kvm_vcpu_kick(vcpu);
+	}
 }
 
 bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
-- 
2.49.0


