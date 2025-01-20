Return-Path: <kvm+bounces-35992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5676FA16C00
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:06:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D40881883C4B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78D91B87F4;
	Mon, 20 Jan 2025 12:05:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535211B87EE;
	Mon, 20 Jan 2025 12:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374755; cv=none; b=sm5TWsGbVhVmoYrC3XJVsCoUfTEdlOGMNtWKeFYXxvP4nu/DCC+6lH63oc4qk7r30srLtDSMf/b43IXBnR/E/JmLhaeEmgna+S4iplpH571B3C5ZzjzImhVnzWioB/sJY7YQ0MMUHOP84wjucBKreYuv8c9rylUY0Fv3aY205AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374755; c=relaxed/simple;
	bh=zpeBuTpYHa2Kqv3XZOLfBNj6vVElaqjrMcRTvvU6jZA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hq9eHCifEtUuttOaWazapypBwArZHnEzFBsTLkjAW1+w/7ZT5RlU/fMeiCeEritBC9OeFvPcjQB3TfyJiNjB+iLCTHE36jm/ZtuSCo5VsnTrk4GiZ+NPMgPYDDI9y+vObQ9grtMIYinIV+T8Ig34LI49FDj53DUEc4Nya9544R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id B175A1008CBF8;
	Mon, 20 Jan 2025 20:05:29 +0800 (CST)
Received: from broadband.. (unknown [202.120.40.80])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 19CF737C975;
	Mon, 20 Jan 2025 20:05:22 +0800 (CST)
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
Subject: [PATCH v5 2/3] KVM: SVM: Remove wbinvd in sev_vm_destroy()
Date: Mon, 20 Jan 2025 20:05:02 +0800
Message-Id: <20250120120503.470533-3-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250120120503.470533-1-szy0127@sjtu.edu.cn>
References: <20250120120503.470533-1-szy0127@sjtu.edu.cn>
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
Suggested-by: Kevin Loughlin <kevinloughlin@google.com>
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


