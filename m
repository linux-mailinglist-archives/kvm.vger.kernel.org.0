Return-Path: <kvm+bounces-40386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04272A570BB
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E42FD3B766B
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0725224418D;
	Fri,  7 Mar 2025 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iT8jmdby"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B637219E98
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372894; cv=none; b=H5PeI9uR/6nB5mBbp0v2MbesYiR9nOP3JVhqyG1Lnb1sA1JmSJ6R9FBLJe3tt8Iv92b7MG+3tko81OlQYXCNRgjfWS55+ph2YNzdton6HnFC7t7cXP0AGhUzjn9gbbdsFz9yf6suuvV7FtNefil7UUYbpWA5n0UwF/J3ozQF83k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372894; c=relaxed/simple;
	bh=UvzmKRZnWS5qe6wJ9VUtUGmpd7ZB6tEvtI1phepadOs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nP/wCweWAOMGDP85nlNEIu97hW8KrlL8CWO389kpQT2kch6PgkznzYrmGU2Eht0IZuE/5owp4r+VJG3ouhg5pM2kIVDGg8Upv7WOMEQKo3elHsviW9J3SWW0IkFJZDp94sQGfReHOx2WNLvHr0hM1GBYXy/awuMq3yugWxlslU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iT8jmdby; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741372891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+7l1kWaVWNu6icMwRM4pO8CVq1CxSt3kSWCinAdGCUw=;
	b=iT8jmdbybTZXnU/4tR8xcKD99meNq7FKcknlN7thY2P84tQRObx69r4ElDh0rYwOsT4Zc0
	cDqj+2Vhucq3uT5Ki76A7eXxZn59azruri5FXeeVlh3XhXaJMFHswkFe6Ry9XNHMJ49Uad
	24lu69u6cWMEd6FcPtjs7tFg4TDoLkE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-j1M1fCBeP7yETzgBdqeVyw-1; Fri,
 07 Mar 2025 13:41:28 -0500
X-MC-Unique: j1M1fCBeP7yETzgBdqeVyw-1
X-Mimecast-MFC-AGG-ID: j1M1fCBeP7yETzgBdqeVyw_1741372887
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 403F51955D4B;
	Fri,  7 Mar 2025 18:41:27 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B461D1956095;
	Fri,  7 Mar 2025 18:41:26 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: Forbid the use of kvm_load_host_xsave_state() with guest_state_protected
Date: Fri,  7 Mar 2025 13:41:25 -0500
Message-ID: <20250307184125.2947143-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

kvm_load_host_xsave_state() uses guest save state that is not accessible
when guest_state_protected is true.  Forbid access to it.

For consistency, do the same for kvm_load_guest_xsave_state().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++--
 arch/x86/kvm/x86.c     | 5 ++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c291f0e89c7..51cfef44b58d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4251,7 +4251,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
 
 	clgi();
-	kvm_load_guest_xsave_state(vcpu);
+
+	if (!vcpu->arch.guest_state_protected)
+		kvm_load_guest_xsave_state(vcpu);
 
 	kvm_wait_lapic_expire(vcpu);
 
@@ -4280,7 +4282,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
-	kvm_load_host_xsave_state(vcpu);
+	if (!vcpu->arch.guest_state_protected)
+		kvm_load_host_xsave_state(vcpu);
 	stgi();
 
 	/* Any pending NMI will happen here */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b416eec5c167..03db366e794a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1182,11 +1182,10 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.guest_state_protected)
+	if (WARN_ON_ONCE(vcpu->arch.guest_state_protected))
 		return;
 
 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
-
 		if (vcpu->arch.xcr0 != kvm_host.xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
 
@@ -1205,7 +1204,7 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.guest_state_protected)
+	if (WARN_ON_ONCE(vcpu->arch.guest_state_protected))
 		return;
 
 	if (cpu_feature_enabled(X86_FEATURE_PKU) &&
-- 
2.43.5


