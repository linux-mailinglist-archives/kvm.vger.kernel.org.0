Return-Path: <kvm+bounces-30649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C00DA9BC58C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76522282E69
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29A51FE103;
	Tue,  5 Nov 2024 06:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lj4Vic8Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD29A1D88DB
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788647; cv=none; b=iNro0avevfWMpEPrqfOt/k6vyzs8qc4e3z17mkySyCXhDoInXk8qsUTJfYYB/dFmAdKcaWZg82UfVGdBHd0C2P62R7OdST2ToDRVPE5FemVHgRfseJV+ET8D/8rGtmt8k07S99OSCsS2MwuqV2cC3ZJIMcv8WY7zDkzKE0lxXM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788647; c=relaxed/simple;
	bh=VOjci9p7Zb1n81rBNztaLxcXzrYXbaFL+FZxHq6NkWo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F0omoz6emsivf0B1k5fo5Ye2hErIDngy9xK/pHYW//o1+GbuEOeE9zc+4mUE6AuNRBwWo5Yy1LrxXdaNdT90y6IFGUJKfLKcX6TppXDdgaagZIDi/sKGGefqkgAs8dZwxADAhNacXwqnCBJP/5fZ+4J1HdySrOFZeeN73QuklR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lj4Vic8Y; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788646; x=1762324646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VOjci9p7Zb1n81rBNztaLxcXzrYXbaFL+FZxHq6NkWo=;
  b=lj4Vic8YfZwfCLstfDxfrsDDPvsPWL3W/kHiude85VQ048Uhgx/0c/GS
   R0ztmLuQUxTIZ30EMvJ2lK/tfZelvkEFmQKz8owHjmulQi8IeQegZuMnZ
   Psm19GkGSNMk+8MnEwxRmCZ/syCT6gbeDGhBvmt7gUnbmEv1LumKW503M
   UjqYEoHMSWuv5eNW8ncfV4U+2tOkP3LBYJA7GS97W7ASIpPduRbT5lYdM
   fkrgaZTNv3SI/R7aAqFmZbvAnKIeRXVMCMCxwkOGLynVSgOM8HnIuJ1t1
   BskYF/VlPktp/RjqOFwC9xA9Bc7K3qx/Dz3Ebnj9LR4TVQfW6+/kECe96
   w==;
X-CSE-ConnectionGUID: LmpmXTaCQvCqcTbz1dOP6w==
X-CSE-MsgGUID: HaeQOKz6QkGkgda1ET+3TA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689444"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689444"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:37:25 -0800
X-CSE-ConnectionGUID: N4Omogx0ShuO9H1a47PWkQ==
X-CSE-MsgGUID: /XLDrWUYQfqYb+xEQj4Gkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988843"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:37:21 -0800
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
Subject: [PATCH v6 15/60] i386/tdx: Set APIC bus rate to match with what TDX module enforces
Date: Tue,  5 Nov 2024 01:23:23 -0500
Message-Id: <20241105062408.3533704-16-xiaoyao.li@intel.com>
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

TDX advertises core crystal clock with cpuid[0x15] as 25MHz for TD
guests and it's unchangeable from VMM. As a result, TDX guest reads
the APIC timer as the same frequency, 25MHz.

While KVM's default emulated frequency for APIC bus is 1GHz, set the
APIC bus rate to match with TDX explicitly to ensure KVM provide correct
emulated APIC timer for TD guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
 - new patch;
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 target/i386/kvm/tdx.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 887a5324b439..94b9be62c5dd 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -234,6 +234,19 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
+    if (!kvm_check_extension(kvm_state, KVM_CAP_X86_APIC_BUS_CYCLES_NS)) {
+        error_setg(errp, "KVM doesn't support KVM_CAP_X86_APIC_BUS_CYCLES_NS");
+        return -EOPNOTSUPP;
+    }
+
+    r = kvm_vm_enable_cap(kvm_state, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
+                          0, TDX_APIC_BUS_CYCLES_NS);
+    if (r < 0) {
+        error_setg_errno(errp, -r,
+                         "Unable to set core crystal clock frequency to 25MHz");
+        return r;
+    }
+
 #define SHA384_DIGEST_SIZE  48
     if (tdx_guest->mrconfigid) {
         g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index bc26e24eb9ac..0aebc7e3f6c9 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -14,6 +14,9 @@ typedef struct TdxGuestClass {
     X86ConfidentialGuestClass parent_class;
 } TdxGuestClass;
 
+/* TDX requires bus frequency 25MHz */
+#define TDX_APIC_BUS_CYCLES_NS 40
+
 typedef struct TdxGuest {
     X86ConfidentialGuest parent_obj;
 
-- 
2.34.1


