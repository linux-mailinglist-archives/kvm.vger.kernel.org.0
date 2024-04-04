Return-Path: <kvm+bounces-13602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E271898E4E
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EAFB1F25910
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCE613775D;
	Thu,  4 Apr 2024 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Emmsvbvb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076671327EB
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256644; cv=none; b=HH/TpIOfgjD2+hP3JGUdA88VbP46UOCxcXgWXy/PqPJCFF4cD+nAhiUQSSPHYrAuS9R653JuLt25F/DkvCdOH5QMaOIK5KwQ7gaTzOvXWsDJ26xagoZkrx0B0mjNAwKU7kBTdpQLy0HjPStAZTHI8TQewRpLNxLDVm0noxuqFVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256644; c=relaxed/simple;
	bh=8qvwxxQIeBV1Kd9XCFuoOg02QXfI1v1RFVcHAf+nVjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VwEcEXwHohtAopGOeWyHNnp1pHgcFdBJOtIz7+sT0qIVFy27FaF3klBuMJ+YW8/lvByxCBJSabXjE8BWPvrAgnWo6eroo5/dUC0WWbzn9SEBo6poI5Xu1RfktAiZM3ppseDacmr1bLm3kvo02PmADcBH420qkDpMQzLWTTGHXLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Emmsvbvb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712256640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nCDNNjDt/LfQbgJv7GVyWQGXDRpuwbJ3WGdMzH1/Yp4=;
	b=EmmsvbvbAwFCXw8jzY4TwT02j3Z/Z/IWC86A0NHRyJTUM6Jxe0rVEZa7UuCvW0jQvi8UAp
	wHiDgWps2fJDPsWycLOL6j92FULoCirH1IN78G4RsuhydUvM+NfDlOSgBejPgbDvLdnK0j
	oK2eClecDlEOfmTB3R8N5TJeYC3ERro=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-y1SfbgcDMBylaadPFTIj5A-1; Thu,
 04 Apr 2024 14:50:36 -0400
X-MC-Unique: y1SfbgcDMBylaadPFTIj5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C75113C0F190;
	Thu,  4 Apr 2024 18:50:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A15391C060A4;
	Thu,  4 Apr 2024 18:50:35 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH 05/11] KVM: guest_memfd: limit overzealous WARN
Date: Thu,  4 Apr 2024 14:50:27 -0400
Message-ID: <20240404185034.3184582-6-pbonzini@redhat.com>
In-Reply-To: <20240404185034.3184582-1-pbonzini@redhat.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Because kvm_gmem_get_pfn() is called from the page fault path without
any of the slots_lock, filemap lock or mmu_lock taken, it is
possible for it to race with kvm_gmem_unbind().  This is not a
problem, as any PTE that is installed temporarily will be zapped
before the guest has the occasion to run.

However, it is not possible to have a complete unbind+bind
racing with the page fault, because deleting the memslot
will call synchronize_srcu_expedited() and wait for the
page fault to be resolved.  Thus, we can still warn if
the file is there and is not the one we expect.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 409cf9b51313..e5b3cd02b651 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -499,7 +499,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	gmem = file->private_data;
 
-	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot)) {
+	if (xa_load(&gmem->bindings, index) != slot) {
+		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
 		r = -EIO;
 		goto out_fput;
 	}
-- 
2.43.0



