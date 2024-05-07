Return-Path: <kvm+bounces-16864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 656308BE812
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0461C1F2994C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB98916D4D7;
	Tue,  7 May 2024 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3fZdWd1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDED16ABF2
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097506; cv=none; b=IniU+RV7Uh7J42mD/LwZDJJGmgQJzFB7lBEHiPx3MDbQE+Pql7oSdRJcHIkRQ+r5q8FnjPhR564DShXkOJeQ/2M4zR5FK0cJWmWXN5e9WaA5yCMf+9TTVo3RTZt69yMeSei1VTTcgfQGWFwj2DmGAVl9P8P5Ihlcnu5EvQvP/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097506; c=relaxed/simple;
	bh=ODFZZ8d+SWP0XNs2wsvqmCW7R0GYR0Ecn26Iz0CsQ3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WPznVJSHV/bcBs76DRZEWyOZEFbc86IyfN2NL1temNgMripOCjP/QPcFW7MSGEIkiKl+cKUmcaRNjOyP+9G4Klsv3U8Y1UagnifhfWM8FC/bBvbGQbglctF8Ig9JrBw4jHWQYOnVX9CjyUzDd+S6Oc6flPL4oBxK5GHxGL2ZOz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T3fZdWd1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715097503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=00bIdkKU7IiQvRDc2CeuHoJggB43wbBXZ1HWrMjjV7o=;
	b=T3fZdWd1myoTWopQlGOG/kuIna+wwFN30uqYXVIb4S8amB39281wc8Y5sAZA9rHJ/wqYxr
	zbtKZop+7HenEbylkOA95mfdmEWmAmLt19X3yMwKzMgC9DQlRr9PzZ5d3U08u9EO3KVukj
	Sf2pF8Q2+yEtmvVvQEiYKaAX2YbRzbc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-241-uw8ZhJCAO229GeyubDCfVg-1; Tue,
 07 May 2024 11:58:19 -0400
X-MC-Unique: uw8ZhJCAO229GeyubDCfVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78D113C3D0CF;
	Tue,  7 May 2024 15:58:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C962200C7D5;
	Tue,  7 May 2024 15:58:19 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Subject: [PATCH 09/17] KVM: x86/mmu: WARN and skip MMIO cache on private, reserved page faults
Date: Tue,  7 May 2024 11:58:09 -0400
Message-ID: <20240507155817.3951344-10-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Sean Christopherson <seanjc@google.com>

WARN and skip the emulated MMIO fastpath if a private, reserved page fault
is encountered, as private+reserved should be an impossible combination
(KVM should never create an MMIO SPTE for a private access).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240228024147.41573-9-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d52794663290..0d884d0b0f35 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5819,6 +5819,9 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
+		if (WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))
+			return -EFAULT;
+
 		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
 		if (r == RET_PF_EMULATE)
 			goto emulate;
-- 
2.43.0



