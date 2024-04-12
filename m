Return-Path: <kvm+bounces-14559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B31E48A34E1
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 19:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CCCD1F22157
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 17:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314041514D6;
	Fri, 12 Apr 2024 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LPh09INn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F35414F10D
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943342; cv=none; b=XTnEQ6ZM/KuMTTRpwllflEWHT4xXudPoonBWCWaNeJTz9BSpjG/229hM8RqocFG/JsCJa+tGyxtp97nak5LFYM1EBizQmDutQypWpJGMkoMfgHA5u09DY3497bit9RT+AOz15uIyiijY1lbOqj5VOCC4G5VfQ8xpZqhdg8oFILc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943342; c=relaxed/simple;
	bh=cRh3sCBdYdnEY4iJS5esOzxtTwTnGj6KPOCuuhvLsh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJZjOyqfd7p+lBMbr3upAZGt2cYz/b8bgLusDGYkIXs5XSXf2+68JieUyaIMDP3Xh8T42qH4p1x1txvT42BUIvqlspltR0nW2Cc8FALQGTCWroX+qutwwLb8mI5MdXPK3RVHm1H/jC6YVCj4wAO7kNV2+DHOiTyPUmO8+hXMHmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LPh09INn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712943339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HoJ35V3bK7vtXA0X0O/SFsr03fV4u8Q785/HuzrDGNA=;
	b=LPh09INn2rhLOtasUUbaV2gMPKaMu3EsqyZsPz531RWHr/l59vAa06V1wuK3ZEQOpnqImJ
	X1uqxUp1o18o6umA2rdF27vsjCTgtMzWqV52+tkgCh3ztpUDoI5CNhjM/H6clPXTrcbvFi
	e6X7WEfl1sqDt1E8eUiEqkeIK4bngcY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-Esz3XpneNnyVEafpkas1fw-1; Fri,
 12 Apr 2024 13:35:34 -0400
X-MC-Unique: Esz3XpneNnyVEafpkas1fw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD3EC29AB3F3;
	Fri, 12 Apr 2024 17:35:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 81801492BC7;
	Fri, 12 Apr 2024 17:35:33 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 03/10] KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed SPTE
Date: Fri, 12 Apr 2024 13:35:25 -0400
Message-ID: <20240412173532.3481264-4-pbonzini@redhat.com>
In-Reply-To: <20240412173532.3481264-1-pbonzini@redhat.com>
References: <20240412173532.3481264-1-pbonzini@redhat.com>
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

For TD guest, the current way to emulate MMIO doesn't work any more, as KVM
is not able to access the private memory of TD guest and do the emulation.
Instead, TD guest expects to receive #VE when it accesses the MMIO and then
it can explicitly make hypercall to KVM to get the expected information.

To achieve this, the TDX module always enables "EPT-violation #VE" in the
VMCS control.  And accordingly, for the MMIO spte for the shared GPA,
1. KVM needs to set "suppress #VE" bit for the non-present SPTE so that EPT
violation happens on TD accessing MMIO range.  2. On EPT violation, KVM
sets the MMIO spte to clear "suppress #VE" bit so the TD guest can receive
the #VE instead of EPT misconfiguration unlike VMX case.  For the shared GPA
that is not populated yet, EPT violation need to be triggered when TD guest
accesses such shared GPA.  The non-present SPTE value for shared GPA should
set "suppress #VE" bit.

Add "suppress #VE" bit (bit 63) to SHADOW_NONPRESENT_VALUE and
REMOVED_SPTE.  Unconditionally set the "suppress #VE" bit (which is bit 63)
for both AMD and Intel as: 1) AMD hardware doesn't use this bit when
present bit is off; 2) for normal VMX guest, KVM never enables the
"EPT-violation #VE" in VMCS control and "suppress #VE" bit is ignored by
hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Message-Id: <a99cb866897c7083430dce7f24c63b17d7121134.1705965635.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/spte.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0f4ec2859474..465fa283326b 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -149,7 +149,21 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
+/*
+ * Non-present SPTE value needs to set bit 63 for TDX, in order to suppress
+ * #VE and get EPT violations on non-present PTEs.  We can use the
+ * same value also without TDX for both VMX and SVM:
+ *
+ * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
+ * For VMX EPT, bit 63 is ignored if #VE is disabled. (EPT_VIOLATION_VE=0)
+ *              bit 63 is #VE suppress if #VE is enabled. (EPT_VIOLATION_VE=1)
+ */
+#ifdef CONFIG_X86_64
+#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
+static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
+#else
 #define SHADOW_NONPRESENT_VALUE	0ULL
+#endif
 
 extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
-- 
2.43.0



