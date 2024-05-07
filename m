Return-Path: <kvm+bounces-16870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7903A8BE81E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:02:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43D2DB284A0
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848C616E866;
	Tue,  7 May 2024 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9qM1S8J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA57816C868
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097508; cv=none; b=brhdZP+wizli29ExxYuVzOf/rAa9e2DaPBIPuNAiD2LdvbdRHUQfcpHuLf65GQ61FfFbD4BPizn9+m7kstp5H5SwX88fOyalZVw11PUryqkMP0y7VmQufUr9HPzyJbZ6iA8kv0+w0B0WRY6Q8eohfdX6UfjP8Dnw/o8hD1PAwyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097508; c=relaxed/simple;
	bh=aWR8vi3ctb5xuNS5aLdoGpoQVQX3R/AX8tzJO890OYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ur1cjyfReOrIKeVT9+nfFFU800Ni9Ew5im/sSmTpq32MWoABpuRCVztm5BlkDd+WnNf0aF3eE2caEPIDrJlPJFufN57mbzas4/QA0P0Wh3kds3w70xCcROLOQPApPu6o9zwaVvQx8QotpC0UlATgK3OrZh2VsCKaSGI4ukClgIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J9qM1S8J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QeJwneIQoupo8QkN2Q+WsjpfxqenpfhUm2BwJMPTxBw=;
	b=J9qM1S8JbuOEdLyhhy1bZHn3cCIuKGznJ8Wwgw63GypqEzTYAbCARjbGm88A1bhEaZ0r9O
	5sioV/if5zYGFbkNqWJ5ePs/mWxEs503B0yLy2n0eRgMdPRJVUmndluMg0p2U2VXHXua5I
	T9bzwY6Io1MpHizc1smyafWjxOUqsXY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-EwPh8TxkNUSzca5Oyj3J0w-1; Tue,
 07 May 2024 11:58:21 -0400
X-MC-Unique: EwPh8TxkNUSzca5Oyj3J0w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B6073802AC9;
	Tue,  7 May 2024 15:58:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E866A401441;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 17/17] KVM: x86/mmu: Sanity check that __kvm_faultin_pfn() doesn't create noslot pfns
Date: Tue,  7 May 2024 11:58:17 -0400
Message-ID: <20240507155817.3951344-18-pbonzini@redhat.com>
In-Reply-To: <20240507155817.3951344-1-pbonzini@redhat.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Sean Christopherson <seanjc@google.com>

WARN if __kvm_faultin_pfn() generates a "no slot" pfn, and gracefully
handle the unexpected behavior instead of continuing on with dangerous
state, e.g. tdp_mmu_map_handle_target_level() _only_ checks fault->slot,
and so could install a bogus PFN into the guest.

The existing code is functionally ok, because kvm_faultin_pfn() pre-checks
all of the cases that result in KVM_PFN_NOSLOT, but it is unnecessarily
unsafe as it relies on __gfn_to_pfn_memslot() getting the _exact_ same
memslot, i.e. not a re-retrieved pointer with KVM_MEMSLOT_INVALID set.
And checking only fault->slot would fall apart if KVM ever added a flag or
condition that forced emulation, similar to how KVM handles writes to
read-only memslots.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Message-ID: <20240228024147.41573-17-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d717d60c6f19..510eb1117012 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4425,7 +4425,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(vcpu, fault);
 
-	if (WARN_ON_ONCE(!fault->slot))
+	if (WARN_ON_ONCE(!fault->slot || is_noslot_pfn(fault->pfn)))
 		return kvm_handle_noslot_fault(vcpu, fault, access);
 
 	/*
-- 
2.43.0


