Return-Path: <kvm+bounces-21639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7659E93120B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 12:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 201281F2355D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1BC187557;
	Mon, 15 Jul 2024 10:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AxVRM0UU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B443C172BA6;
	Mon, 15 Jul 2024 10:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721038356; cv=none; b=OrDIuP1DQnrOU5G8aLn7eMmQVaqL//joPc3a99DfgHYDp7Ay3gD00HFu1Q1+d/4OZtQstq/e7U2f1PRRt8QDHR9bt65awY+r3rWmMGzcYSubLAjwATKRFcSzaikyR9YQg4zino0+h9xP16mnGZrkTBLbUWaV123Zg6YyIdPqQSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721038356; c=relaxed/simple;
	bh=PWqkqSvJsWDQly1er/ukGoZ+HvhC1DU8BS2SZm/Nxig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BZq3YQ9jcaIIWjrbyQL3qh3pXKQEvWf+HQ16s/tn556fWkKIZ5hT00wBSopp3yPq+L4Z7jK+o+2JV6RH2knGNDx6RDM26x0TT0EI57wB2SWthsDkZULPOrzn+HVpHVTuemfbZTH9CVZWNcTlbnjp32hJFpuqUOAPJd3D2hSVvfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AxVRM0UU; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721038354; x=1752574354;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PWqkqSvJsWDQly1er/ukGoZ+HvhC1DU8BS2SZm/Nxig=;
  b=AxVRM0UUcNXXZ1imf8JYTz0SbyaT+40sHCxD2UJnJ/MBXaxpr3bKXPqc
   EVMc9CjeRH5MAWGrqU/jpxRcRrJIEt0PnJXXBM037qvWMLWGJwvKHksDP
   3mLe2hp0N5S4dhsIGpp8qgAl8YE5FYV4IalGAU1Z/I2cyIW/bpwuhahdE
   2PoeItAnIr+p0/RNZIHRAEVXjQVBuaIdjrI7AzK8WRAOe4HKCUksqqxWo
   TC9yfv1qz7ejQjtsa6clNv/WbSqSzYOdAI/fxV/5/kcQzxP8yrGGyUcKP
   eWTtARfPLDHQdKvgKuQZWwbSp07lssvjqk/zXceWnb/mEgbWTFs1hhF12
   A==;
X-CSE-ConnectionGUID: elfziXLuTWGUKjzGdQDBdQ==
X-CSE-MsgGUID: 5OoGPU23QFGZWyr4EvAmXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="18023569"
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="18023569"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 03:12:34 -0700
X-CSE-ConnectionGUID: UzDMctGYQKqiu+R/HyZ4jw==
X-CSE-MsgGUID: hT6flkEcR4KJ0ix2q6EQjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="53946610"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.34])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 03:12:33 -0700
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM: VMX: Do not account for temporary memory allocation in ECREATE emulation
Date: Mon, 15 Jul 2024 22:12:24 +1200
Message-ID: <20240715101224.90958-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In handle_encls_ecreate(), a page is allocated to store a copy of SECS
structure used by the ENCLS[ECREATE] leaf from the guest.  This page is
only used temporarily and is freed after use in handle_encls_ecreate().

Don't account for the memory allocation of this page per [1].

Link: https://lore.kernel.org/kvm/b999afeb588eb75d990891855bc6d58861968f23.camel@intel.com/T/#mb81987afc3ab308bbb5861681aa9a20f2aece7fd [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/sgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6fef01e0536e..a3c3d2a51f47 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -274,7 +274,7 @@ static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
 	 * simultaneously set SGX_ATTR_PROVISIONKEY to bypass the check to
 	 * enforce restriction of access to the PROVISIONKEY.
 	 */
-	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);
 	if (!contents)
 		return -ENOMEM;
 

base-commit: c8b8b8190a80b591aa73c27c70a668799f8db547
-- 
2.45.2


