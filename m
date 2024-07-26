Return-Path: <kvm+bounces-22349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9687093D8B8
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16E091F218A3
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 18:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0477158875;
	Fri, 26 Jul 2024 18:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LtsO65Bn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B92C15575B
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722019939; cv=none; b=ffp3HRbW16zASSaAc3AvWzV0MVIpQE+uLD5bUnRb8aSleUyN4wWDc33040mS0Gc9OhjYMPWKiGDdi6zM7xzcmXhHVraGlRXLvOlMiTEFGTtbPnvhOVorfIMqBEzDj0iwtnaWn30bD5Bot9q3xNQ9vyhbvmpdrh5EjhiTmNEx1Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722019939; c=relaxed/simple;
	bh=tRmOfP51wV+9jZPLASWdFle6gQpf383/WN4M1AOGJtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7IX6uxmtYX0Msynk+BpsiyxYIMRyQlfoU6pa6FthwLUZ05G4I4gCt8sQjCXascT3/JoCal9fVKlsm27S26d4F5q3e2qptFHpwJg5T+Juyq9Obqx1sRHjxNltAum4/sBupWyb7TU6JPgG6+7MyvJCxb/FftT0gzeoRVdOODWAUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LtsO65Bn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722019936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g+8+16JprI1cjYByMUu0g/0uxoZ4686g4X0q/5qRlUc=;
	b=LtsO65BnYI2SRMY/tnmpfgOjEhdS0r5JKWcO7Ebak306iZm47ZOhnoh9GuKGWf1+jo8aPF
	vMnjB04DOGhQiJLqDpld2dEFMIUhwi5eB8DWyIz/ypTwysvLeWHJLeqcqvufGWd9UQMujl
	2r3blenQi7HnewrH9ccfBzLIu8Ni7BY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-91BFzPAdN0uohizw7eeM_Q-1; Fri,
 26 Jul 2024 14:52:10 -0400
X-MC-Unique: 91BFzPAdN0uohizw7eeM_Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C42FA195609F;
	Fri, 26 Jul 2024 18:52:08 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F37401955D42;
	Fri, 26 Jul 2024 18:52:07 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH v2 11/14] KVM: cleanup and add shortcuts to kvm_range_has_memory_attributes()
Date: Fri, 26 Jul 2024 14:51:54 -0400
Message-ID: <20240726185157.72821-12-pbonzini@redhat.com>
In-Reply-To: <20240726185157.72821-1-pbonzini@redhat.com>
References: <20240726185157.72821-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Use a guard to simplify early returns, and add two more easy
shortcuts.  If the requested attributes are invalid, the attributes
xarray will never show them as set.  And if testing a single page,
kvm_get_memory_attributes() is more efficient.

Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..30328ff2d840 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2398,6 +2398,14 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+static u64 kvm_supported_mem_attributes(struct kvm *kvm)
+{
+	if (!kvm || kvm_arch_has_private_mem(kvm))
+		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+
+	return 0;
+}
+
 /*
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * matching @attrs.
@@ -2406,40 +2414,30 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
+	unsigned long mask = kvm_supported_mem_attributes(kvm);
 	unsigned long index;
-	bool has_attrs;
 	void *entry;
 
-	rcu_read_lock();
+	if (attrs & ~mask)
+		return false;
 
-	if (!attrs) {
-		has_attrs = !xas_find(&xas, end - 1);
-		goto out;
-	}
+	if (end == start + 1)
+		return kvm_get_memory_attributes(kvm, start) == attrs;
+
+	guard(rcu)();
+	if (!attrs)
+		return !xas_find(&xas, end - 1);
 
-	has_attrs = true;
 	for (index = start; index < end; index++) {
 		do {
 			entry = xas_next(&xas);
 		} while (xas_retry(&xas, entry));
 
-		if (xas.xa_index != index || xa_to_value(entry) != attrs) {
-			has_attrs = false;
-			break;
-		}
+		if (xas.xa_index != index || xa_to_value(entry) != attrs)
+			return false;
 	}
 
-out:
-	rcu_read_unlock();
-	return has_attrs;
-}
-
-static u64 kvm_supported_mem_attributes(struct kvm *kvm)
-{
-	if (!kvm || kvm_arch_has_private_mem(kvm))
-		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
-
-	return 0;
+	return true;
 }
 
 static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
-- 
2.43.0



