Return-Path: <kvm+bounces-14981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F168A87BF
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 17:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9632C282FFB
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE160148859;
	Wed, 17 Apr 2024 15:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HdUkiF5e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC67147C72
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713368098; cv=none; b=Lhzl5Pj6nfiM+7zb05QfgqJROGvnAkRzFbpSgYJC5KDoInG0x4SgzYot+tUwep+SgCrV6xZ16BLbCERpJsHWZ6SJ84RU38D4USGTfSQ8XJG6i3Ufzbn+bVF6oWtymW2Zn3fRga+kp+XoZ70URJJBKXan/BDkMGwgFtbYE7uC6GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713368098; c=relaxed/simple;
	bh=18C3fkjaGUjut87lyhCZwmA7W+1+Z8WNC7ozIOguMAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e1bNwgZ6a8HDYDVS5zNX+Bzp6LlsQ9m1mveeDUnx8hAQEiA2/hxdmoKv3LO7e7HqyjHMOr0KzlaKlK853cMwshj8Sc5cxulsB7n4tJfeM4x/JCQjcua6wJhztUYc/Dy4x+j+keMUcRQeMDMGoIp/FsFl4QmKFmTAn/RKYdmUUGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HdUkiF5e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713368096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3Uwoo1D+A7Ab673wp0hlYFDcZEPH2tfTFOyRGJRlS0=;
	b=HdUkiF5eBnIHQHKD2xqCHmR4CGAsy01WLLucd5jOfn8NLmAqwt/1OgZvhjPzDahqgSAEMb
	dOHUCkEuLYCoJ/FzgkXQFU3v55PR+zrDqos6FVysnGyY2UFrgMJOQ1PQzX8rcHif5vLRz7
	ocdKgla2HjdHoOu5Q/dzeHv1641PKIc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-S1qZy3LON1i0HI-0c5KOUA-1; Wed, 17 Apr 2024 11:34:53 -0400
X-MC-Unique: S1qZy3LON1i0HI-0c5KOUA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 717CD811000;
	Wed, 17 Apr 2024 15:34:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 40BF1581DE;
	Wed, 17 Apr 2024 15:34:52 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 5/7] KVM: x86/mmu: Introduce kvm_tdp_map_page() to populate guest memory
Date: Wed, 17 Apr 2024 11:34:48 -0400
Message-ID: <20240417153450.3608097-6-pbonzini@redhat.com>
In-Reply-To: <20240417153450.3608097-1-pbonzini@redhat.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce a helper function to call the KVM fault handler.  It allows a new
ioctl to invoke the KVM fault handler to populate without seeing RET_PF_*
enums or other KVM MMU internal definitions because RET_PF_* are internal
to x86 KVM MMU.  The implementation is restricted to two-dimensional paging
for simplicity.  The shadow paging uses GVA for faulting instead of L1 GPA.
It makes the API difficult to use.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e8b620a85627..51ff4f67e115 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -183,6 +183,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
 }
 
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+		     u8 *level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7fbcfc97edcc..fb2149d16f8d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4646,6 +4646,38 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+		     u8 *level)
+{
+	int r;
+
+	/* Restrict to TDP page fault. */
+	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
+		return -EOPNOTSUPP;
+
+	r = __kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
+	if (r < 0)
+		return r;
+
+	switch (r) {
+	case RET_PF_RETRY:
+		return -EAGAIN;
+
+	case RET_PF_FIXED:
+	case RET_PF_SPURIOUS:
+		return 0;
+
+	case RET_PF_EMULATE:
+		return -EINVAL;
+
+	case RET_PF_CONTINUE:
+	case RET_PF_INVALID:
+	default:
+		WARN_ON_ONCE(r);
+		return -EIO;
+	}
+}
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-- 
2.43.0



