Return-Path: <kvm+bounces-39318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91FE1A46943
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:15:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 448AC18890EB
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2987235BF5;
	Wed, 26 Feb 2025 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5ubC/bY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7CF233145
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593705; cv=none; b=N4UB7cuHDxxxofr9cWx+1LRNR8vxX3pRRW6d7Yk7D+KYuVq3UiOrqkaPcn4zkD/DfF77ZUvKlgmuLEBp1Pq0ZdK6YvWAGeq1quSFdaah5v1oP+7F5MZQvf8/Phj9F8RN9n1RYf5YLIAGhCYWDzzBZhb7PArkMBAIJS8+KZf9+4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593705; c=relaxed/simple;
	bh=yK3ISj9Lh0799JabXSSEqdIFZ4fH8yM8hkDCGUF86fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bmTzKNSbH02XHNGtG1F0hZKgmfmsfCSL8GOLcymcpTkIvMAkBjLZaJ1pGY80GZVJqjy2ds7sMAzOKbhreT8zTIz6atlV0ranJk1WsCYTQlwQFCSLhWHKqCtOreXmv/yENAZ05ECss2UQhG+QH8eBPnILwedjYbs0EeE1Nvy7YS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5ubC/bY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/CNuOgHcSv/f8JvXDnI0o+vDFmf7q4logjIKEY454/o=;
	b=G5ubC/bYbLo6QcaeGkg/aWGJPmWVKZnXrfOoMfByJo6sKFMhi3oeIbE9/VzJAHQFuEsOQL
	64Q3tpNryQ9WHRZnSfdauFS+7v/kj9+m4dmuSmVc3lXIO18PMFBAfBsgDdoTgxrk2A03AI
	yxl5uQwhVXjvPb3iGcw4KQ0++IuKXT0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-iz2hAVNANTCnV0u86SB7VQ-1; Wed,
 26 Feb 2025 13:14:59 -0500
X-MC-Unique: iz2hAVNANTCnV0u86SB7VQ-1
X-Mimecast-MFC-AGG-ID: iz2hAVNANTCnV0u86SB7VQ_1740593697
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB99D18D95EE;
	Wed, 26 Feb 2025 18:14:57 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C589A190C544;
	Wed, 26 Feb 2025 18:14:56 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 02/33] KVM: x86: move vm_destroy callback at end of kvm_arch_destroy_vm
Date: Wed, 26 Feb 2025 13:14:21 -0500
Message-ID: <20250226181453.2311849-3-pbonzini@redhat.com>
In-Reply-To: <20250226181453.2311849-1-pbonzini@redhat.com>
References: <20250226181453.2311849-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

TDX needs to free the TDR control structures last, after all paging structures
have been torn down; move the vm_destroy callback at a suitable place.
The new place is also okay for AMD; the main difference is that the
MMU has been torn down and, if anything, that is better done before
the SNP ASID is released.

Extracted from a patch by Yan Zhao.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6fc4ddc606bd..514fc84efc92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12878,7 +12878,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	}
 	kvm_unload_vcpu_mmus(kvm);
 	kvm_destroy_vcpus(kvm);
-	kvm_x86_call(vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
@@ -12888,6 +12887,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	kvm_x86_call(vm_destroy)(kvm);
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)
-- 
2.43.5



