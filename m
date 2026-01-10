Return-Path: <kvm+bounces-67651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF26D0CA75
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 01:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F450309E459
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 00:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 268811B042E;
	Sat, 10 Jan 2026 00:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uw5lN4l/"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10211F37D4
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 00:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768006139; cv=none; b=HU9Y1Z6n+dqr7vGz+mNfV6qvkwpXGg2kPRk2lpCDHk/kDE2upByct10xfRTzPq9Izn9qHsqgZQnu5wgG+DgGo9qWoOIvbbADzsEQViAmCNQRevetuP6yzrT/6fTzfLT1Ya7kKXVIPVYHD0sTpY2wYdmeIBIbmgmgfBf/eX5lK3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768006139; c=relaxed/simple;
	bh=SojqqcISYboX1cXFJdxfxa5hH/87y+nEjPAVkWtudds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaJaoTHrQsC0nve1xJ+/SnkQ7w3pQaQcrHqM1EZn6lodcvjR1o8ZcKHvTR7OdyaPn2nyeK0H8IHigES9RxMpREsq6d5imhwW/1HsTe3ZBvkNTxUROd1gB4X0gc8fjA3jNK0p8m+LzVQG2S9ffajOx7SKwDE0inkD+JjBgYa9YrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Uw5lN4l/; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768006129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RhzJ2LrOmxGEQ8FXigQpB+k9CuoXxfE/3uJFqEvpSU=;
	b=Uw5lN4l/2onD4fYJQz79PRUP27iaa4TgEKy1ODanK/eRZ5isk4K8dngwg6Xgr80hFHBaa/
	vClt4diw2RaAjAjUGudQRQXTofkz3Z+cfi8QijKEI5DHOyZbFkrdGVk/UsquoCGuF+dlwc
	xuK76vtesl/FxRao/PzUphB483kC/9c=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 4/4] RFC: KVM: SVM: WARN if VMSAVE/VMLOAD are not intercepted or virtualized
Date: Sat, 10 Jan 2026 00:48:21 +0000
Message-ID: <20260110004821.3411245-5-yosry.ahmed@linux.dev>
In-Reply-To: <20260110004821.3411245-1-yosry.ahmed@linux.dev>
References: <20260110004821.3411245-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f1b032114406..983ae98133e9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1387,6 +1387,14 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (svm->guest_state_loaded)
 		return;
 
+	/*
+	 * Without virtual VMSAVE/VMLOAD, the instruction would directly access
+	 * host physical addresses, so make sure they are intercepted.
+	 */
+	if (!(svm->vmcb->control.virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK))
+		WARN_ON_ONCE(!svm_is_intercept(svm, INTERCEPT_VMSAVE) ||
+			     !svm_is_intercept(svm, INTERCEPT_VMLOAD));
+
 	/*
 	 * Save additional host state that will be restored on VMEXIT (sev-es)
 	 * or subsequent vmload of host save area.
-- 
2.52.0.457.g6b5491de43-goog


