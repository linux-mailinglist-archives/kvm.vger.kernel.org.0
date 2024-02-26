Return-Path: <kvm+bounces-9710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF67D866D44
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60959B233D9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A394379DA3;
	Mon, 26 Feb 2024 08:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fjBvjtBD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41C877F1E;
	Mon, 26 Feb 2024 08:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936125; cv=none; b=o8Tfle4jvtAjxltikrT+OgvbYciQtvAkjvjW4JaGeCbtbAOqTRGyO4mPmfbd6TV1c2IiNtnenHfSVfJwN2oPsPeCR2dwGcNU1HnP1458FTO0jQ0SD2aTICfN0x7N4oT6KGP/ETpRlJbhK4xSbM/6hR74A4uVar4CJVaZopUbQPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936125; c=relaxed/simple;
	bh=myKJ2+UbusG4kdK0f0eyTWXSAekqS+lLcnY6mljYNTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AYuirMiUVGXd+84OsTRSub90edb96Gwtdjod4GOsYkcyQZeVl6Pd6H/UCJ+ZKWD8G5yg4ZZLw9pWo4L1KnuIYWXdMCmHBe5P5bR1RmBO0aYXqVZnODSO5H2RSg0EZSAKUq4apYRNOrnNXWnyRr+/0K0DNza2gUPz1phOYl8kJBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fjBvjtBD; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936124; x=1740472124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=myKJ2+UbusG4kdK0f0eyTWXSAekqS+lLcnY6mljYNTQ=;
  b=fjBvjtBD7SV3uB3T6tDxVmrDweBu1mkNEccDin1Ru2NIzBqVZK9pN8tl
   UnKYKjZ/fDVFkd7WXeqZ4R5H8kRON7A/4bnbvuNHBVbYyGCUQ6skjtvbO
   bKksCrc7MgM9ijLFOgPVLGwEzoVchZc/Okmy5WzqY5vVGgiq6OuBN+bye
   kvija0MnXYurYGKrBN4KwlgSiQTRMsGs8FW2qQrfkxawCKOd/FN6+L08d
   tU7K8DZdKv/2djfYXDC/pOt9hCYTMLTGAEnk4F2lzWY749cgd9sdJAvwZ
   nVKHEhoR1opUPMnlA7tgXxhbVpHEkPjXuWwXNvPbVb7Zh5DZYVuSQoH4l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069534"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069534"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272593"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:43 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 086/130] KVM: TDX: restore debug store when TD exit
Date: Mon, 26 Feb 2024 00:26:28 -0800
Message-Id: <b7a96654fa46593417afa6153959b2989a507842.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because debug store is clobbered, restore it on TD exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/events/intel/ds.c | 1 +
 arch/x86/kvm/vmx/tdx.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index d49d661ec0a7..25670d8a485b 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2428,3 +2428,4 @@ void perf_restore_debug_store(void)
 
 	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
 }
+EXPORT_SYMBOL_GPL(perf_restore_debug_store);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b8b168f74dfe..ad4d3d4eaf6c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -665,6 +665,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	tdx_vcpu_enter_exit(tdx);
 
 	tdx_user_return_update_cache(vcpu);
+	perf_restore_debug_store();
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
-- 
2.25.1


