Return-Path: <kvm+bounces-14987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E17588A87C9
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 17:37:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F3CCB27397
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A30CE15E211;
	Wed, 17 Apr 2024 15:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QvJyz0LV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9B214901E
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713368101; cv=none; b=RmSGKZxtUmV6CQZxcySdMDUFVcV4Ch2MuLTpub5Idz2Dxw69O2OAqCSak7+5XTdCZ+2CLZGECZp0js3m/Eqb7Lq1MokFe0gfdItCuBdmgoUjJCqiKOdZkHGeNug/OT4SoL1YMu5+d0PuNl5f7e93WvUTIREWmkd6FRL6kpJVmO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713368101; c=relaxed/simple;
	bh=81mARjUpw+KVyq4vQ1KQan74CjOK+s4dvQQ+ghYUVsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tjkFB2bUd/vA/fyrIrRFsda+byZeH8C2X6DHAMmUosh2TqYJys1JNRfkYGD5//W67xhpTCBniRSbAG6/9EGzQMJbTzhMbSb0jhrklWPSDiKr6gXwsy/oQBCBDPwYlflerguuRjqbErbzl51WPt2K1UD5qKZ70EQhR0rCfqT1wOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QvJyz0LV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713368099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=otExSoiFgVMzLYgIYpvIwimsI5D4FF0c+uBWyLnFbGw=;
	b=QvJyz0LVVsBl2fyANuziDbrlGVXhOV5wErxt9RdVcyU+tRzRYDTutls7vpqUfFCyCi124i
	A1zFXSCzKZMB4xf1uSb8luW8jKJ4XeJ6+19x+QSvy7DfV7gfSGvVWU39HSrtqIDGlXdeUo
	M90wkJHw1MmPds654iE3IZ/MRaE+UFo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-tFEeviQnP_64sUjVfisTNA-1; Wed, 17 Apr 2024 11:34:56 -0400
X-MC-Unique: tFEeviQnP_64sUjVfisTNA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 384B7188ACA1;
	Wed, 17 Apr 2024 15:34:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 082F0581DE;
	Wed, 17 Apr 2024 15:34:52 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 4/7] KVM: x86/mmu: Make __kvm_mmu_do_page_fault() return mapped level
Date: Wed, 17 Apr 2024 11:34:47 -0400
Message-ID: <20240417153450.3608097-5-pbonzini@redhat.com>
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

The guest memory population logic will need to know what page size or level
(4K, 2M, ...) is mapped.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <eabc3f3e5eb03b370cadf6e1901ea34d7a020adc.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9baae6c223ee..b0a10f5a40dd 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -288,7 +288,8 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 }
 
 static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					  u64 err, bool prefetch, int *emulation_type)
+					  u64 err, bool prefetch,
+					  int *emulation_type, u8 *level)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
@@ -330,6 +331,8 @@ static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gp
 
 	if (fault.write_fault_to_shadow_pgtable && emulation_type)
 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
+	if (level)
+		*level = fault.goal_level;
 
 	return r;
 }
@@ -347,7 +350,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!prefetch)
 		vcpu->stat.pf_taken++;
 
-	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch, emulation_type);
+	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch,
+				    emulation_type, NULL);
 
 	/*
 	 * Similar to above, prefetch faults aren't truly spurious, and the
-- 
2.43.0



