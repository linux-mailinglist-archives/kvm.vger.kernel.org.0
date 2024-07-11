Return-Path: <kvm+bounces-21452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 249AA92F1F2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47D0E1C21120
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBCD41A708F;
	Thu, 11 Jul 2024 22:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E1dnWrE8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA411A2561
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 22:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736891; cv=none; b=ALbG1RZR4ZUR86IPv6U3cgLbEIhXwtkCoLrbxarq57DcqXR1qGxPjPHVlLggBwsJY0HNkHleb8ayTXkCvFjLm7b+EWjv5fO/eqK68f0paHY8EMsqw/tIKoVL0CHvgH908ryaKBzIXICzFAr+WjhJ3YIJTj3DNvhO3ht1F9CLXdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736891; c=relaxed/simple;
	bh=DmGXtGInNHI307ARIyGEHrYJoBoCKU0M0LjACRQGU5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EEl5J+CN50P25iyrM9b7gvEq1b+wIaOr/imkrQQ5qNbKjr1jOKCm4E29P9fx2wfgvpaRCoffX3GG/z/oKXE7tWs/J4AzO1GFC1rIvOakEo5HCbkyKQsZUyNnwHSwsntn7hVe4CIsBa6N8h7MpIOqrqGZDsi5gbFONytT/rv61fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E1dnWrE8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720736889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cj29ojuCVRWWZsFaxPT41gUNJJ+jA3ygN2YwSApHAEY=;
	b=E1dnWrE8y229ITt2bR+2119kZI+ZyZFTEzhrxReaiVmXp7XWEp9BfdE/GcfX4MdWQ9MYwj
	6+jCxmt7tJHoIVmtWhouThV+PZn+grCFyaOkZguqEkIVYjnXWmmNVtwWz4TjGTUQYnHSG2
	AEIObhMA8yo0sBhwli5BBEk+zomNL18=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-178-pIZurnONNAuSbZjAmS1kxg-1; Thu,
 11 Jul 2024 18:28:06 -0400
X-MC-Unique: pIZurnONNAuSbZjAmS1kxg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2D451955F44;
	Thu, 11 Jul 2024 22:28:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3673A19560AE;
	Thu, 11 Jul 2024 22:28:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH 10/12] KVM: cleanup and add shortcuts to kvm_range_has_memory_attributes()
Date: Thu, 11 Jul 2024 18:27:53 -0400
Message-ID: <20240711222755.57476-11-pbonzini@redhat.com>
In-Reply-To: <20240711222755.57476-1-pbonzini@redhat.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Use a guard to simplify early returns, and add two more easy
shortcuts.  If the requested attributes are invalid, the attributes
xarray will never show them as set.  And if testing a single page,
kvm_get_memory_attributes() is more efficient.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f817ec66c85f..8ab9d8ff7b74 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2392,6 +2392,14 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
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
@@ -2400,40 +2408,30 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
+	unsigned long mask = kvm_supported_mem_attributes(kvm);;
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



