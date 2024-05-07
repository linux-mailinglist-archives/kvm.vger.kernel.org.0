Return-Path: <kvm+bounces-16875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EFC78BE82C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 303B7B28EAE
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083E016F84F;
	Tue,  7 May 2024 15:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GZHugvys"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B8B16D317
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097510; cv=none; b=B+EAvtx/C3EbPqOKtOjbMUdnjnW4/qfwQVaKOhkEjyF+gUPQJdGrxxiIdKQLwx4QEmbiCLSqSBgMh4EdspIG8uDHDGcnXGRoFAuySImsptrfIepqgbvNL5I26GV2Ga8TdtI221Y7HhFG3hx9HFX/tMlBwfxOe6k3D16Vcqg55Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097510; c=relaxed/simple;
	bh=AEDj0QP9X/29ZeWxz7Y3Z4nz0H8Ield92JGUU5fqxk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kSHJkjFub/jhj+1XzX3Z/HdHPI6iC08MA2Vpexw5R6jREYlkMmprSm16X1pPTkSQAxbSKw8zE5+n9sqwhhZiH5mM8nGWpoG44vC5yJCZMeFY/cr/0Sh7QYmVvvezRTRCJEDb10CNG/G05V/+q+X5kBL0FNGfVZrRgq8TMy628qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GZHugvys; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KfYqWHCMNvvr7g3hZxttx2F/NwK+cEPEKDtwCJOPG4M=;
	b=GZHugvysHvvzP6mNrG/N4y1me0Q9cUqSp18i+E4CMWW4uFFVkBb9aHdeqlmj6ncX9rpRJh
	Ja3/PVPT31P+o3ciTxH5DblbHFfTwx7c+0jZEYqN1tHCHH7WhrUVtEauJgHIH4Dls9aVEO
	nudNpkLycdi5CCggEXzn933QUdDMqqo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-3Cwx2YUwN7qLulppB-IAtg-1; Tue, 07 May 2024 11:58:20 -0400
X-MC-Unique: 3Cwx2YUwN7qLulppB-IAtg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33348802BF7;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16C4A401441;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Subject: [PATCH 12/17] KVM: x86/mmu: Explicitly disallow private accesses to emulated MMIO
Date: Tue,  7 May 2024 11:58:12 -0400
Message-ID: <20240507155817.3951344-13-pbonzini@redhat.com>
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

Explicitly detect and disallow private accesses to emulated MMIO in
kvm_handle_noslot_fault() instead of relying on kvm_faultin_pfn_private()
to perform the check.  This will allow the page fault path to go straight
to kvm_handle_noslot_fault() without bouncing through __kvm_faultin_pfn().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240228024147.41573-12-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8e14c2b68a7..fdae6d19e72b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3262,6 +3262,11 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 {
 	gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
+	if (fault->is_private) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
 			     access & shadow_mmio_access_mask);
 
-- 
2.43.0



