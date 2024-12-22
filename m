Return-Path: <kvm+bounces-34315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 353459FA7CE
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C0841885EE0
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C141C2324;
	Sun, 22 Dec 2024 19:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYNJDqtE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09481B87F4
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896116; cv=none; b=Q0Yv/QhcctNVWcHL3B6u9pw3yKAZYOFrseuAMfSOzyap0uIgpfzsYsOM4znU38+8qhHqHVKta4Wm8ggeuhcIcmFB87Tn4c9SV+L4ZaXZsrDjkHW0ARtK2xw0gY0PT4QNCon23rJL/V9yvv6F+r/N+bM4NBVTiKnaO8/JiescR3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896116; c=relaxed/simple;
	bh=IDV+DSbTNaXgU2Ae925Ik7HQpjUoisNptD/FC21+5Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f6EJhwCoOdkiW00yxr304S3r8HULmQppW0pIP7k6vnDaMHnqIfjaeuOuVoGlAu4gFt9oCFLD4QbbhMLIysYMGDNoqx+1xxA0sDSiwKJwzoOgK0jDlXVAHMCuwqU9SDjqoDba7Gi88gpLNcAgXt2RdmfytiZ/PI6eq3ZBQ9uQRnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UYNJDqtE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Enjgk57xxatw09oRbuNl5YS/66/ZI5hxx2qz+awAErA=;
	b=UYNJDqtE6bFtd35dtH6K0xMj+/QPJSFzUgPIqoSax9geK6iPUVE11HzGOn+diYCvKZC2ps
	vpYjT9wu/yNMo+mS0igrZgldDP8HloFsct62RgiwzWUBGADiaSMM+hNnIizF+uNynlPtgr
	SJ+aXX1MXhvESakTik59zJgN30JuV7o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-597-lDGb5Wy-Mz22m6zabyw2mw-1; Sun,
 22 Dec 2024 14:35:10 -0500
X-MC-Unique: lDGb5Wy-Mz22m6zabyw2mw-1
X-Mimecast-MFC-AGG-ID: lDGb5Wy-Mz22m6zabyw2mw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B7B9195608C;
	Sun, 22 Dec 2024 19:35:09 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 94AAD19560AA;
	Sun, 22 Dec 2024 19:35:08 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v6 17/18] KVM: x86/tdp_mmu: Don't zap valid mirror roots in kvm_tdp_mmu_zap_all()
Date: Sun, 22 Dec 2024 14:34:44 -0500
Message-ID: <20241222193445.349800-18-pbonzini@redhat.com>
In-Reply-To: <20241222193445.349800-1-pbonzini@redhat.com>
References: <20241222193445.349800-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Don't zap valid mirror roots in kvm_tdp_mmu_zap_all(), which in effect
is only direct roots (invalid and valid).

For TDX, kvm_tdp_mmu_zap_all() is only called during MMU notifier
release. Since, mirrored EPT comes from guest mem, it will never be
mapped to userspace, and won't apply. But in addition to be unnecessary,
mirrored EPT is cleaned up in a special way during VM destruction.

Pass the KVM_INVALID_ROOTS bit into __for_each_tdp_mmu_root_yield_safe()
as well, to clean up invalid direct roots, as is the current behavior.

While at it, remove an obsolete reference to work item-based zapping.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-18-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ca2b95b75ca4..046b6ba31197 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -999,19 +999,21 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	struct kvm_mmu_page *root;
 
 	/*
-	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
-	 * before returning to the caller.  Zap directly even if the root is
-	 * also being zapped by a worker.  Walking zapped top-level SPTEs isn't
-	 * all that expensive and mmu_lock is already held, which means the
-	 * worker has yielded, i.e. flushing the work instead of zapping here
-	 * isn't guaranteed to be any faster.
+	 * Zap all direct roots, including invalid direct roots, as all direct
+	 * SPTEs must be dropped before returning to the caller. For TDX, mirror
+	 * roots don't need handling in response to the mmu notifier (the caller).
+	 *
+	 * Zap directly even if the root is also being zapped by a concurrent
+	 * "fast zap".  Walking zapped top-level SPTEs isn't all that expensive
+	 * and mmu_lock is already held, which means the other thread has yielded.
 	 *
 	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
 	 */
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	for_each_tdp_mmu_root_yield_safe(kvm, root)
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, -1,
+					   KVM_DIRECT_ROOTS | KVM_INVALID_ROOTS)
 		tdp_mmu_zap_root(kvm, root, false);
 }
 
-- 
2.43.5



