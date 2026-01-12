Return-Path: <kvm+bounces-67858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EABD15F63
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9882530AB514
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD06225416;
	Tue, 13 Jan 2026 00:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lSSQjaVb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590B921D5B0;
	Tue, 13 Jan 2026 00:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263504; cv=none; b=GY+uS0BkduSs3NA8itts8XOnXVG4NZLu3klE98n09KY4XPck/5uMyhSt71OJYAkOFeT6jdfLaRY6j3yXTCL1tQYVucjZD6f2WHHwqP+k2RW3hOKbaeTokYOpVh5shPszR9TsTU1J0Ivt51S/hiO9dXgpyF5VzqbKUi72MTPgnL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263504; c=relaxed/simple;
	bh=/2lobkkwFmWXtDIH4lB0kXMZZIgiqIogi4CoptHpdXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebr0bpqeGpartxpWe9jY0SNTSA0tA9VqgWJ9hSpr3Ek7hmjEfV+CyvM5u+pKf9mmaYfcZovcqD8YZku23DnnoCvkPkCtpYUFdAtW/Ccxr1u+aeckzzpKdtpp2JrTpfHTOiD17DbQsTrv5lL5W5HkMkUjFEdLYCEPw4IzxiYg/q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lSSQjaVb; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263503; x=1799799503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/2lobkkwFmWXtDIH4lB0kXMZZIgiqIogi4CoptHpdXI=;
  b=lSSQjaVbAeGJZqv5s9ftQLvMatjs1qSN04tYXgOq9Neb1muPfvWVwLtU
   8NwYZ3UzZjWisMlplGPr6T2hw4Wy/W8JNo0Op0sZ5lFPJQgQv1LAmLW/a
   ofx78HeiQRNOOb2gZj//3RpJF7qxTJDLACl/e2J9/NMyNlH6LdZFZWQ6i
   CMueVDnCsLGAG9MUafsDTdq0DMVydOZh/BPXg8Ubkl/GVwbMGlE0NSnGs
   wL3OutwZrxXtWJxNHSKtiVqx7QLCvTto0gEHR+cTWmN2OHq1ZuTaheUNL
   wqxTXsSboJJqIaUP3DLUJutaZATvpoBp32D0qMuI3g1Ml3ILfi3F4K9DA
   A==;
X-CSE-ConnectionGUID: XNuj8sc0QRSHl2KtLTj5aA==
X-CSE-MsgGUID: 1fBGIv8rTESiQ49M7ZYnvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264224"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264224"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:22 -0800
X-CSE-ConnectionGUID: UkwwTuuMStaIxByX2kWTog==
X-CSE-MsgGUID: kYfhS8tBQeqe3A80Mmbfqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042254"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:23 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 06/16] KVM: VMX: Refactor GPR index retrieval from exit qualification
Date: Mon, 12 Jan 2026 23:53:58 +0000
Message-ID: <20260112235408.168200-7-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112235408.168200-1-chang.seok.bae@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
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
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 5 +++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 144012dd9599..46c12b64e819 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6354,7 +6354,7 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
 
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-		reg = (exit_qualification >> 8) & 15;
+		reg = vmx_get_exit_qual_gpr(vcpu);
 		val = kvm_gpr_read(vcpu, reg);
 		switch (cr) {
 		case 0:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 10479114fd1c..29d588c3b3b1 100644
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
index 2bb3ac8c5b8b..8d3e0aff2e13 100644
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


