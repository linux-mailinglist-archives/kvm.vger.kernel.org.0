Return-Path: <kvm+bounces-9644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 848C6866C60
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B60601C21E1C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773395579A;
	Mon, 26 Feb 2024 08:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ny3P4K5p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A92353E2D;
	Mon, 26 Feb 2024 08:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936073; cv=none; b=kXVgyIhMKh6BqkAOzyYYUQPxLB2g/6jhBAlhNr+HfUWmDzmOn8H8b++ZZfCNY+oIETTlRuiD/TS0UiRq7iGgm3lsJPOvzt1yR+dVu0W3t1jU0DE9kcdx7dX7Xze7KNVl3pn/Kn6JJrXTYGi6M5XJiKislCodLYjHf5wxaC03D8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936073; c=relaxed/simple;
	bh=ZOimDrQPGotChcrBFIpUTI6niKrsT5WJoO34ZaH7XfY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hFrL8eztccLKdBRwFiiRuZnFULM0vU17xim/0XTPi/sx3pHtBHxUX23Btm0SPpOEE4x2K/7eIwp29Hc/fDfrxtEXuDHA4XX4w8bWqR1Fhb1m2P0HG1/6B11JmZ06Jp1YKvJb3w5TCDP+WzdJUFsRT8hJLdx9a1MZ1skiFh921LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ny3P4K5p; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936072; x=1740472072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZOimDrQPGotChcrBFIpUTI6niKrsT5WJoO34ZaH7XfY=;
  b=ny3P4K5ptdLSYeHrYKkyoDcCZLnl+stGQM7hmahZPtx8heecEZzu4Ygt
   TVoNfUPbVaQ/56W+sT5768MyLSuOQ0HnJUxkXqtHAcZ9xw6AvMnaT7s22
   3HJDJWx/H2zx1zhnfGBc5OEBgOvX1VbLxZaHhwzChhfeFjBAOE+YUUjA+
   zZW46mzw8Ozgb2FPkyVAJJg1qrxPILDhHHXi1oFm2MfZ2fiHQlNE9qUTk
   weeJANb3ZU9q0kXZ9KnVKIHcSa5JNryOuIeHTofCV+0IJ0zB26tg+wZ7m
   ZifpJN5tsOcOKRaHTPnBNUNofQgNTwg9RBl+scyHGjHvaHPuM7Lc5vm1Q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631515"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631515"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474365"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:45 -0800
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
	tina.zhang@intel.com,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v19 021/130] KVM: x86/vmx: initialize loaded_vmcss_on_cpu in vmx_init()
Date: Mon, 26 Feb 2024 00:25:23 -0800
Message-Id: <c1b7f0e5c2476f9f565acda5c1e746b8d181499b.1708933498.git.isaku.yamahata@intel.com>
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

vmx_hardware_disable() accesses loaded_vmcss_on_cpu via
hardware_disable_all().  To allow hardware_enable/disable_all() before
kvm_init(), initialize it in before kvm_x86_vendor_init() in vmx_init()
so that tdx module initialization, hardware_setup method, can reference
the variable.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>

---
v19:
- Fix the subject to match the patch by Yuan

v18:
- Move the vmcss_on_cpu initialization from vmx_hardware_setup() to
  early point of vmx_init() by Binbin

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 434f5aaef030..8af0668e4dca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8539,6 +8539,10 @@ static int __init vmx_init(void)
 	 */
 	hv_init_evmcs();
 
+	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+
 	r = kvm_x86_vendor_init(&vt_init_ops);
 	if (r)
 		return r;
@@ -8554,11 +8558,8 @@ static int __init vmx_init(void)
 	if (r)
 		goto err_l1d_flush;
 
-	for_each_possible_cpu(cpu) {
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
+	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
-	}
 
 	cpu_emergency_register_virt_callback(vmx_emergency_disable);
 
-- 
2.25.1


