Return-Path: <kvm+bounces-33782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9ED59F170C
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2128161905
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D9A1F757B;
	Fri, 13 Dec 2024 19:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjMylI38"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1351E1F7070
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119862; cv=none; b=pijA4/QjymBijRJabDA9yg3xu28wFT+Tm8NhzmUAVijwTO40GEgRxMC+nTcBS3qb0XXkoCt9Y1cfNeE4zCPPa+n9Z5W1zzdE+HgZ2ruWaMXCV8sJg21R9vHXZo3312hWRK2qy0DQPNTRRDH6mIsb9EGXoZXJUBi5iNi/8pZ7tdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119862; c=relaxed/simple;
	bh=N9qfV/xU1ssX30mfKOo8z4hp3Zv6VYftovmgRgT5CVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5kJFa42Y2Qe3AOAPTec38DrFr/ACoha8I9lGaKjAJ0LYWEQk1Mx4AQnSMIMgXLvB/UmAqXrymFKRYV+pQklr5Ocx27dHU9N3hpolhJpeO6pMKVV/vEMBQknTN1GNpYaMOW4MhstiWGRcHhWS+CmLLT3n9mMMPPQQLPGYJj8sjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NjMylI38; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PICVzQSfgfqL9MJ0J3anuUhxiMZy4nOzgCXlqjNsqJQ=;
	b=NjMylI38EWWsNDtrVLI3W0SrBslMD94Xmk+tCWn2jbchZMziTNemYlODLltaf11WUD12bm
	sMLhB62vYo8+uVHUaaZ3BzC/PlyrK1pL1HWZ6+ZKzZyQeF1DT7yBH+XWlcz3fuIayjn8Ii
	T0fqInuRcqiRIc/VYg6WCDQTuCSMORM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-342-gKG02AP1MMitMI3ysszi7w-1; Fri,
 13 Dec 2024 14:57:36 -0500
X-MC-Unique: gKG02AP1MMitMI3ysszi7w-1
X-Mimecast-MFC-AGG-ID: gKG02AP1MMitMI3ysszi7w
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C7CB19560A2;
	Fri, 13 Dec 2024 19:57:35 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29D891956086;
	Fri, 13 Dec 2024 19:57:34 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 17/18] KVM: x86/tdp_mmu: Don't zap valid mirror roots in kvm_tdp_mmu_zap_all()
Date: Fri, 13 Dec 2024 14:57:10 -0500
Message-ID: <20241213195711.316050-18-pbonzini@redhat.com>
In-Reply-To: <20241213195711.316050-1-pbonzini@redhat.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Don't zap valid mirror roots in kvm_tdp_mmu_zap_all(), which in effect
is only direct roots (invalid and valid).

For TDX, kvm_tdp_mmu_zap_all() is only called during MMU notifier
release. Since, mirrored EPT comes from guest mem, it will never be
mapped to userspace, and won't apply. But in addition to be unnecessary,
mirrored EPT is cleaned up in a special way during VM destruction.

Pass the KVM_INVALID_ROOTS bit into __for_each_tdp_mmu_root_yield_safe()
as well, to clean up invalid direct roots, as is the current behavior.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-18-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 94c464ce1d12..e08c60834d0c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -999,19 +999,23 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	struct kvm_mmu_page *root;
 
 	/*
-	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
-	 * before returning to the caller.  Zap directly even if the root is
-	 * also being zapped by a worker.  Walking zapped top-level SPTEs isn't
-	 * all that expensive and mmu_lock is already held, which means the
-	 * worker has yielded, i.e. flushing the work instead of zapping here
-	 * isn't guaranteed to be any faster.
+	 * Zap all roots, except valid mirror roots, as all direct SPTEs must
+	 * be dropped before returning to the caller. For TDX, mirror roots
+	 * don't need handling in response to the mmu notifier (the caller) and
+	 * they also won't be invalid until the VM is being torn down.
+	 *
+	 * Zap directly even if the root is also being zapped by a worker.
+	 * Walking zapped top-level SPTEs isn't all that expensive and mmu_lock
+	 * is already held, which means the worker has yielded, i.e. flushing
+	 * the work instead of zapping here isn't guaranteed to be any faster.
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



