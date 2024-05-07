Return-Path: <kvm+bounces-16869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1161E8BE818
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42A7A1C23454
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD6F16E860;
	Tue,  7 May 2024 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J45f7j3h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E401216C863
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097508; cv=none; b=FStUrcKjFuekbXbvEMSvXjU1KuKJFyRqo3R8pjEn0Id8VbtWSfSxcapg51bDWaSLpznO3d2Kyv522GVPZyB4wasyUOo7nnYgmgII3N6F/VAIEcMSbwCyn/tWNYriZSQQhObdWisHKkr7mnP4hE/dZef6GTzBIwiKk7Lg/HwqBiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097508; c=relaxed/simple;
	bh=dgcmhB8XSWOn7jFspuRon54N7yuoHys5FERLE38HDtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bg1WH/a3QAgSyNiF94Ls46dOIEdJI6I6LTFoVYiiuOXr4ZigNW48gECxyU3ND7rK79ad7r93Q7o1u3hg5TWcboJ+ZtsxFXr4CU9g6rTTlVeiQftnO9NBuMPKFTU7AhvozE6zKU7BqxMGFj7On/dgb+L2fd6xuFwwgWUhUgi4xDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J45f7j3h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0Ko3PMhRXri8rWk2ZRhKHNRYJxXRoquuhAcNllLpfk=;
	b=J45f7j3hMpNalE4Oj+3vBdsqUdAB4Dfno9UOkH7eDyf485xIQ4r4lg9v9WifLyG69B2cin
	4pMQRtRLPaeYpOPYVIoSYeeLh/d1qKA48tbUzPNgTTqi8tjdcNklZH/7vDxRd98Yi4I5Km
	9T9VXk8rbmzfO9voIgaiS4jzeOruqI8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-363-KpX76YA5N2OpU2nU7_psLA-1; Tue,
 07 May 2024 11:58:21 -0400
X-MC-Unique: KpX76YA5N2OpU2nU7_psLA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B64E63802AC6;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95646492CAA;
	Tue,  7 May 2024 15:58:20 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 15/17] KVM: x86/mmu: Set kvm_page_fault.hva to KVM_HVA_ERR_BAD for "no slot" faults
Date: Tue,  7 May 2024 11:58:15 -0400
Message-ID: <20240507155817.3951344-16-pbonzini@redhat.com>
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

Explicitly set fault->hva to KVM_HVA_ERR_BAD when handling a "no slot"
fault to ensure that KVM doesn't use a bogus virtual address, e.g. if
there *was* a slot but it's unusable (APIC access page), or if there
really was no slot, in which case fault->hva will be '0' (which is a
legal address for x86).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Message-ID: <20240228024147.41573-15-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7630ad8cb022..d717d60c6f19 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3273,6 +3273,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	fault->slot = NULL;
 	fault->pfn = KVM_PFN_NOSLOT;
 	fault->map_writable = false;
+	fault->hva = KVM_HVA_ERR_BAD;
 
 	/*
 	 * If MMIO caching is disabled, emulate immediately without
-- 
2.43.0



