Return-Path: <kvm+bounces-36608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5101CA1C788
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 12:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4E413A539F
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 11:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39558156C74;
	Sun, 26 Jan 2025 11:37:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CFA155C87;
	Sun, 26 Jan 2025 11:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737891449; cv=none; b=ILBaRup7dPkLB/nPG60QjL8gMAxzcHfOSK6oHduZyXhIEy+GqIHaDLcjoJNWIasayyKaGCYsoFKjbGiAwNCgE33Gbs+vAptao3ql5fKLQkdBj9yeyGEUQCgCQqxImSq7OUlDKWSzdUoBthceX6Op0z9EVlwTb4oR3K1wS+mfPrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737891449; c=relaxed/simple;
	bh=aXlbBblBf10y6gHnVZodpVi9WWOUnJ6TR8vEOSe9WZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lGsjcmnbgOwx4jkRJWrwejpnUsAyrE13x/aVM6XngKgHfZf8cAWfZ8Iuc5ds8V7CVizVhAZqEr4Vemua6/oM5yWBGQbgwDVDC5yuBeS4AzAnJrbLFx1k2hSIw+tvR8m2C8PkBs4rf5KMxYx/EHun38saoCcpa7zTYB48oHRcnrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id A7063812A4;
	Sun, 26 Jan 2025 19:37:10 +0800 (CST)
Received: from localhost.localdomain (unknown [101.80.151.229])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id 135833FC394;
	Sun, 26 Jan 2025 19:37:02 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: thomas.lendacky@amd.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	kevinloughlin@google.com,
	mingo@redhat.com,
	bp@alien8.de
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: [PATCH v6 2/3] KVM: SVM: Remove wbinvd in sev_vm_destroe()
Date: Sun, 26 Jan 2025 19:36:39 +0800
Message-Id: <20250126113640.3426-3-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250126113640.3426-1-szy0127@sjtu.edu.cn>
References: <20250126113640.3426-1-szy0127@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before sev_vm_destroy() is called, kvm_arch_guest_memory_reclaimed()
has been called for SEV and SEV-ES and kvm_arch_gmem_invalidate()
has been called for SEV-SNP. These functions have already handled
flushing the memory. Therefore, this wbinvd_on_all_cpus() can
simply be dropped.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
---
 arch/x86/kvm/svm/sev.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a..1ce67de9d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2899,12 +2899,6 @@ void sev_vm_destroy(struct kvm *kvm)
 		return;
 	}
 
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
 
 	/*
 	 * if userspace was terminated before unregistering the memory regions
-- 
2.34.1


