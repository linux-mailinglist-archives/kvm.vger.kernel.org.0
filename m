Return-Path: <kvm+bounces-36716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1653BA20314
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 02:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 588593A7051
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 01:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F2013CA93;
	Tue, 28 Jan 2025 01:54:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102701B59A;
	Tue, 28 Jan 2025 01:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738029260; cv=none; b=ZPvjXAvNuV2LxCzM0ltlrAMhADBizUK4iO/AYtlhRQgHj4uQCn6XQX5xfcdIBI9+ZE584uIrG6ffFYi2S9T6SBGT1q29r97+vTYGYshJ/W79ZrLeDdaat+yrDibzbVCa/A8zd6nkr5MHXkLVW6RiPJbxHtG87JfzuhNwIkv++8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738029260; c=relaxed/simple;
	bh=cbiVZKEg9Uh8BmT6qPPw+jDvE3/obEXdD7yVlAP3YpU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=idAsn9xQUw1WNFP2uWLlbHbfWnwn6K3Sxg3QFAlZAcgCw3V5nm1jZ2fbOS6Z+wOZAOUJELiva1zU3MHS8Mu+9DD10h863AkiKCccC6GdjonPmB5ebKTZprU4XAylBL/wCbadt++DKNGvhjbq/1NxTJapVNpiquHFe4ZapbwuByo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id C170F812A4;
	Tue, 28 Jan 2025 09:54:08 +0800 (CST)
Received: from localhost.localdomain (unknown [101.80.151.229])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id 6AC443FC501;
	Tue, 28 Jan 2025 09:53:56 +0800 (CST)
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
Subject: [PATCH v7 1/3] KVM: x86: Add a wbinvd helper
Date: Tue, 28 Jan 2025 09:53:43 +0800
Message-Id: <20250128015345.7929-2-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250128015345.7929-1-szy0127@sjtu.edu.cn>
References: <20250128015345.7929-1-szy0127@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At the moment open-coded calls to on_each_cpu_mask() are used when
emulating wbinvd. A subsequent patch needs the same behavior and the
helper prevents callers from preparing some idential parameters.

Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
---
 arch/x86/kvm/x86.c | 9 +++++++--
 arch/x86/kvm/x86.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e7134809..b635e0e5c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8231,8 +8231,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
 		int cpu = get_cpu();
 
 		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
-		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
-				wbinvd_ipi, NULL, 1);
+		wbinvd_on_many_cpus(vcpu->arch.wbinvd_dirty_mask);
 		put_cpu();
 		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
 	} else
@@ -13964,6 +13963,12 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+void wbinvd_on_many_cpus(struct cpumask *mask)
+{
+	on_each_cpu_mask(mask, wbinvd_ipi, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(wbinvd_on_many_cpus);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ec623d23d..8f715e14b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -611,5 +611,6 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
+void wbinvd_on_many_cpus(struct cpumask *mask);
 
 #endif
-- 
2.34.1


