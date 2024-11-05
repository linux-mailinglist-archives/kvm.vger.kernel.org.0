Return-Path: <kvm+bounces-30679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9369BC5B1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 480D51F211AB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9511FEFD2;
	Tue,  5 Nov 2024 06:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ipL4Yx5z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96A11714A0
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788777; cv=none; b=Y458ZWt7M3uUwp1WthNZqWvcHYsYB2SNH+q/DIU1oMePxibbvB2u6rjCHzSA+OYsavC+KRARLu8yru9P8P6K/cMhX3Xz3s/eXEWpR3KO69a/6YQ/IhI/kCVGm7UKHWxLYILvqLwLBzSAsPjf/mP11NvPFrLh5P2bpIhKu7DTSI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788777; c=relaxed/simple;
	bh=C2RlAuENX7AQKgB6fkf8PxOsDfhUa1Oh2lPmCd3nnHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZJkYEdn6hLqvZPeX9kAcdAdEeJqOHiul39tL2K0NTOXtfbRfrP3BhfP12gASblmdRwClvbOinzEjE/+RkEGdPtJ9mzyqj7vgCLDIQ4mLukqqoZphka6TjJImJ4JONT4fnHVpoguqhjNPLGYRbatQY3vcSXr00rpsJyBUVGSm+ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ipL4Yx5z; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788776; x=1762324776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C2RlAuENX7AQKgB6fkf8PxOsDfhUa1Oh2lPmCd3nnHY=;
  b=ipL4Yx5zwjFJsYeYktSvZnrfcHBv6U4ijt0dj8XXosfeGgNyrJUGOYD6
   HMK3xBjzikA2ROIe+xkMEAXitVd2kXE8ApgNX8OqC8TFv45jswiundQjV
   7PVtKy6y60HVDVwj/D6yJIxXe8Tms5yee7CUIpuxsQEVYOBPhZg71La35
   RsGHV9tS7eMrNv4mfBfeQtIcxyIvq+vJT0lj/QWCk2rDD78YmdrMAkQXX
   SaFhi5xWRntDGbDWr0YMULpWHmAE77HoO72femjGbmvJ+a3GzLWTQy1Vn
   QC8IyUSu/HNUdUZHyOXGWiXeEL3ru7CO50CHBsdlfDTC0PEmm/AVJgYko
   A==;
X-CSE-ConnectionGUID: vOyDuBkDTvqvRhbav1R1Pg==
X-CSE-MsgGUID: r9MckzrLQdSpt74N4vumPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689812"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689812"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:35 -0800
X-CSE-ConnectionGUID: nQHxqnLjRaOvI8sC+/HFoA==
X-CSE-MsgGUID: w5YMLsrFQWCEEsV4cIXAAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989690"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:31 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 45/60] i386/tdx: Don't get/put guest state for TDX VMs
Date: Tue,  5 Nov 2024 01:23:53 -0500
Message-Id: <20241105062408.3533704-46-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

Don't get/put state of TDX VMs since accessing/mutating guest state of
production TDs is not supported.

Note, it will be allowed for a debug TD. Corresponding support will be
introduced when debug TD support is implemented in the future.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index c39e879a77e9..e47aa32233e6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5254,6 +5254,11 @@ int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp)
 
     assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
 
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     /*
      * Put MSR_IA32_FEATURE_CONTROL first, this ensures the VM gets out of VMX
      * root operation upon vCPU reset. kvm_put_msr_feature_control() should also
@@ -5368,6 +5373,12 @@ int kvm_arch_get_registers(CPUState *cs, Error **errp)
         error_setg_errno(errp, -ret, "Failed to get MP state");
         goto out;
     }
+
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     ret = kvm_getput_regs(cpu, 0);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Failed to get general purpose registers");
-- 
2.34.1


