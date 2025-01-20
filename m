Return-Path: <kvm+bounces-35991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A5B2A16BFE
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:05:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68F2E7A02AD
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260171DFD94;
	Mon, 20 Jan 2025 12:05:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7D91B87EE;
	Mon, 20 Jan 2025 12:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374739; cv=none; b=s04+A9RCKK6l2t8IYHDjx6164zuLddpDhD0sLy2ZCc6Lzn5A+KTZH9fC6tWYro7MLCMvHKX44Q4U3ZykXm52tJeGBh1VroO/QDLN5un9yUEB8sIYRy9nMY1BkbttAItQDyQfna3LGwMUOUot2KoWtl2ukB5IywoWkfp5+ynx3KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374739; c=relaxed/simple;
	bh=zyBrhgj16ZYkACjwL0qJsSO24/rzCJR1WsReWdgVXoE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n9lKM1qATz6f3ETY8w+fKIpVe45oMz5V3ne6NeGOTq1lkaoaiyYd1pCVX+SW+bpGq5/3ptUycXIiOwBAg0/8R4oEN6IrsYv7kvIVkT0wUbmXY4lUufPMkOcnglf9JtxlNBO9gZLrwRuGGBkFVrEXC8tpvrXtTWoMovi6Zre/aV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 1F93C1008CBDE;
	Mon, 20 Jan 2025 20:05:23 +0800 (CST)
Received: from broadband.. (unknown [202.120.40.80])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id D9DC937C955;
	Mon, 20 Jan 2025 20:05:15 +0800 (CST)
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
Subject: [PATCH v5 1/3] KVM: x86: Add a wbinvd helper
Date: Mon, 20 Jan 2025 20:05:01 +0800
Message-Id: <20250120120503.470533-2-szy0127@sjtu.edu.cn>
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

At the moment open-coded calls to on_each_cpu_mask() are used when
emulating wbinvd. A subsequent patch needs the same behavior and the
helper prevents callers from preparing some idential parameters.

Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
---
 arch/x86/kvm/x86.c | 9 +++++++--
 arch/x86/kvm/x86.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c79a8cc57..77f656306 100644
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
@@ -13971,6 +13970,12 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
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


