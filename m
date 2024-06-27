Return-Path: <kvm+bounces-20583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED112919CD5
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 03:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A70BA28703E
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 01:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43BD0D29E;
	Thu, 27 Jun 2024 01:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KyRIli9t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FA5D51E;
	Thu, 27 Jun 2024 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719450338; cv=none; b=Pzx7lYhqspcmff9qhy7PsKIQvDNfnY3EQrepjIYbx779bp3qpClq6gisnARLC9o3E3RrSNKMYKb9w8jytA5GnFI0Mn7Ia1c/rNbc+kVwRk9XwCX9HvZAOf/8YAZc55vh2axXk0BGi5A0MS1NanuyabUSGqgM2tgTmFoSLld7S50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719450338; c=relaxed/simple;
	bh=u81FSMUN6eqlccWIV8JIHE2+9FvCevMk6DG/OPGYw0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HtyZJGcMlypVV5uHquQMjza8emycPImY3ur/YhNReA0aAxfdNmvHt3QrrXP0/LkggNTu8QhzmaFN3WW7BOTLkl04SIWJbzdPwCo7vSRqCoWT3GYIbBGasRvv9pRnZStDS0hjrk6nfmHCgPJ9YW+GsYgwLU0183zPEX4igIqVvWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KyRIli9t; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719450337; x=1750986337;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u81FSMUN6eqlccWIV8JIHE2+9FvCevMk6DG/OPGYw0o=;
  b=KyRIli9t/07S4c7ywaWkpYOO+Yd1yRWm8re2MOsvbzSP4kYSgqztMz8y
   lAjPBeRNAyo0NuaObc+8f862h9dUrh7RHGdj8KunCLsXeUYzLG+B3sOQx
   NrIU56xFK/6wQUIaR4L+hu3rREZ9l++giwaqoJAk/l/37zFBCLpVAyZYs
   LuRWDI6Opj7WEMugQBofH3UDUzbrLmU0CguEG+Dk2DS0Ni+HnKwj0WTyT
   rzxE6jkTgbdp4+w4Lrp2cImsn2MWLi0ej9mEPQZclSMK8f9HxUzcHPtKi
   rVAzO5TP4NvXwqAH+u0r0dV65DiGW3c0mlxrWb8DZvQXI9Z4RPNR9qo9E
   Q==;
X-CSE-ConnectionGUID: nPgqzjWMT369hc9vQMamyg==
X-CSE-MsgGUID: nstOnjtlT1iqfTNEPIwhyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="27144193"
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="27144193"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 18:05:36 -0700
X-CSE-ConnectionGUID: Jmw9tSW/Qcq/CYhYMcUxLw==
X-CSE-MsgGUID: rHgAxCIPQD6nSQ87v5mMdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="44850466"
Received: from bjrankin-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.73])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 18:05:35 -0700
From: Kai Huang <kai.huang@intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Switch __vmx_exit() and kvm_x86_vendor_exit() in vmx_exit()
Date: Thu, 27 Jun 2024 13:05:24 +1200
Message-ID: <20240627010524.3732488-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the vmx_init() error handling path, the __vmx_exit() is done before
kvm_x86_vendor_exit().  They should follow the same order in vmx_exit().

But currently __vmx_exit() is done after kvm_x86_vendor_exit() in
vmx_exit().  Switch the order of them to fix.

Fixes: e32b120071ea ("KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3c83c06f826..8e7371c9648a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8629,9 +8629,9 @@ static void __vmx_exit(void)
 static void vmx_exit(void)
 {
 	kvm_exit();
+	__vmx_exit();
 	kvm_x86_vendor_exit();
 
-	__vmx_exit();
 }
 module_exit(vmx_exit);
 

base-commit: c2f38f75fc89ebd6c0be5856509329390102d8ba
-- 
2.43.2


