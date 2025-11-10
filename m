Return-Path: <kvm+bounces-62557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D73C488E0
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37E441892C69
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DCB3321DD;
	Mon, 10 Nov 2025 18:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pm/pmTe+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF532331A71;
	Mon, 10 Nov 2025 18:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799087; cv=none; b=UHZtCqLCbyo0ppa8mfeMdo7ZrHJBAUrjh5onAxdWto2c2J4NGUydGkEpkSggjYwjd2YFw0DmwGCKqdrE78Z5cHyBgVr4OQTE/hEEdFSIOkewfDZ0X8s+hKmiC6IKI4FIOhC9B+ZPylxnr6MWnKA3EenUznkqliK1meluiv919ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799087; c=relaxed/simple;
	bh=JdEY9D1v3AeME/Vd8PH/gA211HPcNSlQZiY0XFrMMxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/xwxyEmI40UD1177JJxxPlvBoztYft21FxjmIlntl4aXFpxwq6JZB338czePl3FZhl/HHp3uM1PI6e8KVBrJvmZYdzlxtOdpHi2gBIoSaQZw730DNSIvNieecTrk7QE6ctmOJWiArXW56LIETFB6rWoJNGnR+j2l+PU3TexaOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pm/pmTe+; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799086; x=1794335086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JdEY9D1v3AeME/Vd8PH/gA211HPcNSlQZiY0XFrMMxE=;
  b=Pm/pmTe+vffVr3bOg+LZqeldAm5LYKMUp8/NRQ8W+DenNzj7HskXfECN
   NkJ3Aq1Wse61IBPhWeVm8jwBkZtXmdCUI7RFcQWKCWIUIPgHsWKENqJD+
   LHhDnHPdkRxsq03+wyCQwCmm7tkAsbSnIc9tH7Nxy8L2PS/v2e5Ru7ltO
   fkR6JLnYpcJ87wqwT0LaGu4yGbcwzAP9mk0fjmDR9nvfspaXO3c5+Yklt
   4z8+r/WeGSSLhleMTsOYVKWrsT7SEzMVFlKGwFsp2xf8L2O2peA4VFqDJ
   jptbvDxb1nkXpLdDzdwEolkGIbZiK1I/h1VGCedUt9Eke46AiVqY6VwjI
   g==;
X-CSE-ConnectionGUID: zMGM3z3yRNiiyPpEhUZKyg==
X-CSE-MsgGUID: w9kq7ceBRrakpLhh2SzVHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305499"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305499"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:46 -0800
X-CSE-ConnectionGUID: 4plH02aOR9+0iwk26K4rxw==
X-CSE-MsgGUID: SVBhU90PTa2iMVuKFyjnEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396128"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:46 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 06/20] KVM: VMX: Refactor GPR index retrieval from exit qualification
Date: Mon, 10 Nov 2025 18:01:17 +0000
Message-ID: <20251110180131.28264-7-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a helper to extract the GPR index from the exit qualification
field.

Some VMX exit qualification, in addition to the VMX instruction info
field, encode a GPR index. With the introduction of EGPRs, this field is
extended by a previously reserved bit position.

This refactoring centralizes the logic so that future updates can handle
the extended GPR index without code duplication.

Since the VMCS exit qualification is cached in VCPU state, it is safe
for the helper to access it directly via the VCPU pointer. This argument
will also be used later to determine EGPR availability.

No functional change intended.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 5 +++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4b883ded6c4b..97ec8e594155 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6404,7 +6404,7 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
 
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-		reg = (exit_qualification >> 8) & 15;
+		reg = vmx_get_exit_qual_gpr(vcpu);
 		val = kvm_gpr_read(vcpu, reg);
 		switch (cr) {
 		case 0:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dd8c9517c38c..4405724cb874 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5459,7 +5459,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 
 	exit_qualification = vmx_get_exit_qual(vcpu);
 	cr = exit_qualification & 15;
-	reg = (exit_qualification >> 8) & 15;
+	reg = vmx_get_exit_qual_gpr(vcpu);
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
 		val = kvm_gpr_read(vcpu, reg);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a58d9187ed1d..64a0772c883c 100644
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


