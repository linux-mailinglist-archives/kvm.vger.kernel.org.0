Return-Path: <kvm+bounces-14258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB068A16AF
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 16:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DF651F23669
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5952114F137;
	Thu, 11 Apr 2024 14:05:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA58F14D6E9;
	Thu, 11 Apr 2024 14:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712844345; cv=none; b=GF9Lt66xsCuCQrfmDqCye8erOgwhPEesK4vyghjQberppknydpoQ8gg1713Mj5mWhnuvg1XhsbJ6Z4DL0BYZ6Gtp9yADfg+Xvtzh0XcCHVgr46wljswiBr6z2ql022YWDDw5XJl/hCIvnr84j71IL5rCBaqrYkENIc9tqujkypo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712844345; c=relaxed/simple;
	bh=wZo1d7w+fKNU/nCeTnZm6TixtAVd3nzykMCZw9ga/mg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K2TP0j38IGi8lWGIXBrbdOsSUqKRqATPd2gbJ62ZvnVR7TLduiptOcv9gh+E4JacVPg2ZWiF6Ag8CYd4bbQ4UpY+NVm01PvzVyDEYYeq5jjlTMcz8Wgo+nV52n6yv0W2rGxrpExmO7q9ATTmxWSTP2beAhlO6bkgxIl2g5nj0kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id AED4A1006BD4E;
	Thu, 11 Apr 2024 22:05:31 +0800 (CST)
Received: from broadband.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id D85F837C963;
	Thu, 11 Apr 2024 22:05:26 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: thomas.lendacky@amd.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: [PATCH v4 1/2] KVM: x86: Add a wbinvd helper
Date: Thu, 11 Apr 2024 22:04:44 +0800
Message-Id: <20240411140445.1038319-2-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411140445.1038319-1-szy0127@sjtu.edu.cn>
References: <20240411140445.1038319-1-szy0127@sjtu.edu.cn>
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
index 48a61d283..dba9b8749 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8144,8 +8144,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
 		int cpu = get_cpu();
 
 		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
-		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
-				wbinvd_ipi, NULL, 1);
+		wbinvd_on_many_cpus(vcpu->arch.wbinvd_dirty_mask);
 		put_cpu();
 		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
 	} else
@@ -13871,6 +13870,12 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
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
index 2f7e19166..cbb426756 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -542,5 +542,6 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
+void wbinvd_on_many_cpus(struct cpumask *mask);
 
 #endif
-- 
2.34.1


