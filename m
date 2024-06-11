Return-Path: <kvm+bounces-19302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7218F9034FB
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 10:12:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BC5A1C233F1
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 08:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7FD172BCE;
	Tue, 11 Jun 2024 08:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dpDLmDmb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C2616F8EC
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 08:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718093493; cv=none; b=AlCgyWT4BoUB/C2Zq6qkw5fam29HK6U2lIlxwpOsRbGUaHyJr1JuDfDMbm1sjD6geCFpyUWXMr2uwjIhaEqx8IdqSB/va+xu25+x/YQaeavsVEgdKw9POhhc0UfyoPLImM1oXqDeP3v8Fb0JFujfTdMANPWrPA/jzqDtqB9/Q3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718093493; c=relaxed/simple;
	bh=HTNYOw+/f2aa3QtL2Ogl8hMTizcliwOty28Tv1VGdhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bqKb0BV0R9YVFlv6AioU20svqeUIVsaO4XxDguQrsc0kXN8P2Wz5trhVM7eJiQmr3OsSF229JiaX3RuzXuWy9WHUdI+tmUfzi+TVGCCqWY2+PtkcAC/NrD4QndU9+dJiSmP6LIoHCyJoFWpoISrlHdpTc4mH7CCEL1E6BC4J59s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dpDLmDmb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718093490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iEiFPKaZxInySow1QYHYIL0tSIhJVYnSxikl/zI1x4E=;
	b=dpDLmDmbehTChw2lbjHBJ4pj8upePo6QRXUTqM3dPVcPrkjeh+zpdfEHFY325RmPmpzRjY
	N0GMyBwwFlhENZct4tKhyOtROSPTGToPn9X9vuPfBpDNV2u2+tCzGRKCK2NMcDHB3PBHOQ
	pN/Pn4X19Zv9AbM99vvsccHf1lgJt7c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-VxUfIvIzPdqjXdF5JSPN0g-1; Tue,
 11 Jun 2024 04:11:26 -0400
X-MC-Unique: VxUfIvIzPdqjXdF5JSPN0g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 847F3195608E;
	Tue, 11 Jun 2024 08:11:25 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C295619560AB;
	Tue, 11 Jun 2024 08:11:24 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH] KVM: x86/tdp_mmu: Sprinkle __must_check
Date: Tue, 11 Jun 2024 04:11:23 -0400
Message-ID: <20240611081124.18170-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDP MMU function __tdp_mmu_set_spte_atomic uses a cmpxchg64 to replace
the SPTE value and returns -EBUSY on failure.  The caller must check the
return value and retry.  Add __must_check to it, as well as to two more
functions that forward the return value of __tdp_mmu_set_spte_atomic to
their caller.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Message-Id: <8f7d5a1b241bf5351eaab828d1a1efe5c17699ca.1705965635.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 36539c1b36cd..effb70f7dcba 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -530,7 +530,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
-static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
+static inline int __must_check __tdp_mmu_set_spte_atomic(struct tdp_iter *iter,
+							 u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
 
@@ -572,9 +573,9 @@ static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
  *            no side-effects other than setting iter->old_spte to the last
  *            known value of the spte.
  */
-static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter,
-					  u64 new_spte)
+static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter,
+						       u64 new_spte)
 {
 	int ret;
 
@@ -590,8 +591,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	return 0;
 }
 
-static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter)
+static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter)
 {
 	int ret;
 
-- 
2.43.0


