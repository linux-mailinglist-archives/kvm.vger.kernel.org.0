Return-Path: <kvm+bounces-39375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFC1DA46B92
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBAAE3A4AD6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC85326E160;
	Wed, 26 Feb 2025 19:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PYOmi0tL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D378269896
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599757; cv=none; b=G+aB2IcQ/QrKD2yIjzg06d0dIK3RqYofqt1D0KRDP2luEztn0MoQxVCicFJpyLbE+EF6YM+X/mjAm36h6BsdO+nRAu6qvnTHLWeNSUZWo/H6koOhs1aJouDzycgafPiSLrF0lUQ3bN62wQdsfHEJxzooR7yngqxf1JhRXA/dGbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599757; c=relaxed/simple;
	bh=F025vLV3UwG21q9cdNaC0aKHZ+8i1sVJ+mfSsqoR2V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HD0tJCVdTEEfRn+W/203unZYSBPXbTcX4g7CyEUcy95Li5XCmk4EoMgpyNsjBRAhoPcpEE0dpsOdTs4oByl3yJTinJL0ymmv8N/DPtag7ipbrzSKVid5hW63sGr/TB+xFnj8PjQWuPHJQhVvdQo4mlLKl33Y7GfSsFKPUQZA+vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PYOmi0tL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rA7NLTcBfcUdNskRipGyQAefqVduQKvAjJ9oSoOlNKY=;
	b=PYOmi0tL949nqiFILlmDcaSY7rIEUqqBT8b+dmYpjn782nIZFrq7vu2uj65QFXxr6+j0Xv
	ygeTmrJi9x2jKiKeewO6yxYEMgH2hgyyaMRNIYllIrbY+EnkDZ/VHxT/R7KBmW3mzDFSlq
	mekwzwgRCe32s1T6fVk1lcneyiMKhUQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-423-PvXdJRFKOiicNwyJR4RI0g-1; Wed,
 26 Feb 2025 14:55:51 -0500
X-MC-Unique: PvXdJRFKOiicNwyJR4RI0g-1
X-Mimecast-MFC-AGG-ID: PvXdJRFKOiicNwyJR4RI0g_1740599750
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B185219783B4;
	Wed, 26 Feb 2025 19:55:50 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BD6C3300018D;
	Wed, 26 Feb 2025 19:55:49 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 14/29] KVM: TDX: Require TDP MMU, mmio caching and EPT A/D bits for TDX
Date: Wed, 26 Feb 2025 14:55:14 -0500
Message-ID: <20250226195529.2314580-15-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Isaku Yamahata <isaku.yamahata@intel.com>

Disable TDX support when TDP MMU or mmio caching or EPT A/D bits aren't
supported.

As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
support for TDX isn't implemented.

TDX requires KVM mmio caching. Without mmio caching, KVM will go to MMIO
emulation without installing SPTEs for MMIOs. However, TDX guest is
protected and KVM would meet errors when trying to emulate MMIOs for TDX
guest during instruction decoding. So, TDX guest relies on SPTEs being
installed for MMIOs, which are with no RWX bits and with VE suppress bit
unset, to inject VE to TDX guest. The TDX guest would then issue TDVMCALL
in the VE handler to perform instruction decoding and have host do MMIO
emulation.

TDX also relies on EPT A/D bits as EPT A/D bits have been supported in all
CPUs since Haswell. Relying on it can avoid RWX bits being masked out in
the mirror page table for prefaulted entries.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
Requested by Sean at [1].
[1] https://lore.kernel.org/kvm/Zva4aORxE9ljlMNe@google.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c  |  1 +
 arch/x86/kvm/vmx/main.c |  1 +
 arch/x86/kvm/vmx/tdx.c  | 10 ++++++++++
 3 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 800684c3b2c9..48a7e6f32f7f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -110,6 +110,7 @@ static bool __ro_after_init tdp_mmu_allowed;
 #ifdef CONFIG_X86_64
 bool __read_mostly tdp_mmu_enabled = true;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0444);
+EXPORT_SYMBOL_GPL(tdp_mmu_enabled);
 #endif
 
 static int max_huge_page_level __read_mostly;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 8ed08c53c02f..a4cb3d6b2986 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -3,6 +3,7 @@
 
 #include "x86_ops.h"
 #include "vmx.h"
+#include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
 #include "posted_intr.h"
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 09c4d314e6f5..a44a50db9199 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1528,6 +1528,16 @@ int __init tdx_bringup(void)
 	if (!enable_tdx)
 		return 0;
 
+	if (!enable_ept) {
+		pr_err("EPT is required for TDX\n");
+		goto success_disable_tdx;
+	}
+
+	if (!tdp_mmu_enabled || !enable_mmio_caching || !enable_ept_ad_bits) {
+		pr_err("TDP MMU and MMIO caching and EPT A/D bit is required for TDX\n");
+		goto success_disable_tdx;
+	}
+
 	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
 		pr_err("tdx: MOVDIR64B is required for TDX\n");
 		goto success_disable_tdx;
-- 
2.43.5



