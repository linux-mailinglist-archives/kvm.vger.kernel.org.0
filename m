Return-Path: <kvm+bounces-66448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 39664CD3BBB
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 285B0304C5E4
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7527122D780;
	Sun, 21 Dec 2025 04:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VqXOBcu1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBBD224B14;
	Sun, 21 Dec 2025 04:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291498; cv=none; b=JxRcbDTnNudPf8VrG5vb2y8LerzTFle3LCFvjH/FWdzrL++x0v59Z/G3gG1mw8tm0jhv1O1brP7FDqToJARNxCweWk+igNgExDBcatnimet7hUQM55fUOaEwQFa5LkG5bHBfqSTbJpELC5dfIuDWPogssE92kHedcnn4aaVQ+kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291498; c=relaxed/simple;
	bh=li9hVWBHhty+00eqwTRi0vVQ+K6SA6W4G6nVCNUqAKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcrYfXypdOKUHT5ifXR5hGlbPyTnf494vek8rF4yVKq37HeiNlzg2ui8gF9vpoYE99noIZlbaavwjXiwJS4gJ/2TtVu3ZGKUGuxQz1zsDQdGVhoN4DWkT0tfNcbs5NQ6CSnBsK8B7HnK5yDnRSNxnx057kzzvOiLo/1XTHaDMCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VqXOBcu1; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291495; x=1797827495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=li9hVWBHhty+00eqwTRi0vVQ+K6SA6W4G6nVCNUqAKQ=;
  b=VqXOBcu17N977njR2CPaO2fhnj+I7PxtlEQ9TUOdo8eaZSrqHjlUi99v
   Lm4i41ozOgEK0GFSpsmnuJafjXC4+jy3z3aCsEUkgLpQ6mJsBZfC1bPho
   8NE2k3UKZOB02YtzvmvIpuKA6hi70aLrbKWAusOm0DN2AIbQBy5sfQFRM
   ntnHGQpg0OdKvA2SJfOcdJmk82BhrFStzpYnZF1E7K4K5Wi5ERN9JfbIi
   s2a3SJJpEsAfg8dBWBnnfMPEusR5OEsD8HHeYxojXlYEh1By6ioe2FIfC
   pyoPJvrvQg99512/KgREqmMEtMqYh5rNZFG9M0DkwlXsURZ6SHeGCK+Vm
   g==;
X-CSE-ConnectionGUID: KNW5PAMDTkqG0GSP7JYAsQ==
X-CSE-MsgGUID: q8LknoBfRyC/LVl4MwyyJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132398"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132398"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:35 -0800
X-CSE-ConnectionGUID: 166MSMKVRqi3t4tYmIqgOg==
X-CSE-MsgGUID: UvZ8OuuXSLOAn/pDfgJjaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229884987"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:35 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 06/16] KVM: VMX: Refactor GPR index retrieval from exit qualification
Date: Sun, 21 Dec 2025 04:07:32 +0000
Message-ID: <20251221040742.29749-7-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a helper to extract the GPR index from the exit qualification
field.

VMX exit qualification, in addition to the VMX instruction info field,
encodes a GPR index. With the introduction of EGPRs, this field is
extended by a previously reserved bit position.

This refactoring centralizes the logic so that future updates can handle
the extended GPR index without code duplication.

Since the VMCS exit qualification is cached in VCPU state, it is safe
for the helper to access it directly via the VCPU pointer. This argument
will also be used later to determine EGPR availability.

No functional change intended.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
No change since last version
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 5 +++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 558f889db621..1e35e1923aec 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6353,7 +6353,7 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
 
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-		reg = (exit_qualification >> 8) & 15;
+		reg = vmx_get_exit_qual_gpr(vcpu);
 		val = kvm_gpr_read(vcpu, reg);
 		switch (cr) {
 		case 0:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ae28b06b11f5..d41e710e8807 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5588,7 +5588,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 
 	exit_qualification = vmx_get_exit_qual(vcpu);
 	cr = exit_qualification & 15;
-	reg = (exit_qualification >> 8) & 15;
+	reg = vmx_get_exit_qual_gpr(vcpu);
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
 		val = kvm_gpr_read(vcpu, reg);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ed02a8bcc15e..f8dbad161717 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -411,6 +411,11 @@ static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
 	return vt->exit_qualification;
 }
 
+static inline int vmx_get_exit_qual_gpr(struct kvm_vcpu *vcpu)
+{
+	return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
+}
+
 static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vt *vt = to_vt(vcpu);
-- 
2.51.0


