Return-Path: <kvm+bounces-30674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C12A9BC5AC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5097628334A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712B91FCF52;
	Tue,  5 Nov 2024 06:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dPbwa/oO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396771FDF9B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788755; cv=none; b=T3w+JOOClUJ2reP8ZsGX//GJkhGzB+4gYjjO99jtT7WGNrcA8TXnwqXHW7EgekHGohqqVyqXOs/5/tM5C1auRPL5MrQ8w6BKOosScFiEV82PoWj+tNa6iKuawq+qjUWKndfEN3vKjZjsp9mbxW4XNrwZvNWBN1E3orP+2bNv3CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788755; c=relaxed/simple;
	bh=BHXWCaOd3UyAcZOJUgpgw+yI5VVHsxLUYqIIcqCHqr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KeDsL++Z0emyvhKwkuboE8BZVjPYnc8y7lmmLAXc8Zb8Ym0Tq3xtvznJi1j6LW+nrbK99atwbYxNH1ALStPiqJIpzhINXpAwPWDjKLlm+r212Vz35Lii4Pw2DHv1m8cPdZKOm1uzq1hQjhBWTnGulrm9EYD+rED2C9YowcmTRrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dPbwa/oO; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788754; x=1762324754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BHXWCaOd3UyAcZOJUgpgw+yI5VVHsxLUYqIIcqCHqr8=;
  b=dPbwa/oOvolGgx0fV/HFbprQJAo8XMhzGlbrVjQgxyTqmmJ94CD6TSLN
   y+rg+TInAjjqwKHLrdasksULC/LmBdyKwVV8T1JiYAX357KG+tbjCk71V
   FJFb7mBcMyFxAm4pKPc1q56EJATXfyZbSndRSNUttsUMcJi7c99R8RX8C
   gviBitb42V7hRGtpIt/u53RUEXy9Ry/nzBC88IsFgGdLzG0o87yXIpFxd
   jD+Z1sN4cLThjHK4DWbEt7mn98ypuDdfvVyCDhyNJyMWw2Z0zi8ipVKZW
   C3Wig6/dx86W4/5QyIz87C+rP4RmQ2phnjL+7YPqk/m61R2qGyttqLWo8
   Q==;
X-CSE-ConnectionGUID: +4Pxi/LbQQmTcUavgglVsQ==
X-CSE-MsgGUID: hUMBSCP6Sry5Rpb0DHmNEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689761"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689761"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:14 -0800
X-CSE-ConnectionGUID: AYU/sAKLS2q3DkWuAe4Fxw==
X-CSE-MsgGUID: VBH/u/1NTEmaD6xbyYj7Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989566"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:10 -0800
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
Subject: [PATCH v6 40/60] hw/i386: add eoi_intercept_unsupported member to X86MachineState
Date: Tue,  5 Nov 2024 01:23:48 -0500
Message-Id: <20241105062408.3533704-41-xiaoyao.li@intel.com>
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

Add a new bool member, eoi_intercept_unsupported, to X86MachineState
with default value false. Set true for TDX VM.

Inability to intercept eoi causes impossibility to emulate level
triggered interrupt to be re-injected when level is still kept active.
which affects interrupt controller emulation.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 hw/i386/x86.c         | 1 +
 include/hw/i386/x86.h | 1 +
 target/i386/kvm/tdx.c | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 01fc5e656272..82faeed24ff9 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -370,6 +370,7 @@ static void x86_machine_initfn(Object *obj)
     x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
     x86ms->bus_lock_ratelimit = 0;
     x86ms->above_4g_mem_start = 4 * GiB;
+    x86ms->eoi_intercept_unsupported = false;
 }
 
 static void x86_machine_class_init(ObjectClass *oc, void *data)
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index d43cb3908e65..fd9a30391755 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -73,6 +73,7 @@ struct X86MachineState {
     uint64_t above_4g_mem_start;
 
     /* CPU and apic information: */
+    bool eoi_intercept_unsupported;
     unsigned pci_irq_mask;
     unsigned apic_id_limit;
     uint16_t boot_cpus;
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 9ab4e911f78a..9dcb77e011bd 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -388,6 +388,8 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -EOPNOTSUPP;
     }
 
+    x86ms->eoi_intercept_unsupported = true;
+
     /*
      * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
      * memory for shared memory but not for private memory. Besides, whether a
-- 
2.34.1


