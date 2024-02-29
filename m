Return-Path: <kvm+bounces-10383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 739C586C0F7
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE5A41F21EF4
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E3954E1D9;
	Thu, 29 Feb 2024 06:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lS/RdaN3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA2F4C619
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188833; cv=none; b=PDP4uoKyxlMQutxBFLyTV+K2CG5QGxjwYTrKu9h78Aa6yEnQWk9rfCfRZkoFYJWfyRJXZGCS/ozR2ezBAYkTvRq1xWBUomH6WgGGgh9raXEE+D8t8zfzqOaaLpKPBXzuMZhw+n62AzYgL/GdnA4n+2eBLJ+OX2qHv/XYiEAxzF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188833; c=relaxed/simple;
	bh=Gvq++bXmo93zAUhJsRjiDraEH3cCNX+uGjQb5aw6CGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uwbpIlFbHO/Aq4K/Mi3yTCSmFYzoHzK/lr1ksO7a06um0gpgqvrqnjQTBof62dZknVPZYBhEY6/LuGWoUYUGKrmPmr7UKItOQoHYm6F4gHwlg+qy6+1uy5BQ/x4L4BkJTqoR9hoIDK8XgLvplohdk+dmfXBuKAOpZO0Gdc+2wpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lS/RdaN3; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188832; x=1740724832;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gvq++bXmo93zAUhJsRjiDraEH3cCNX+uGjQb5aw6CGM=;
  b=lS/RdaN3dZgSnk+vjQBuZD6B3m2/+y0lWDWHMz1bEVqEqywOku/vraFG
   egITpK/cTjaYzLECpGSRcdTL7HuTI2j2Lle8C3Mw0L0BTHrx7ijTlDNV5
   B4638ibqU04XMKb5wGf4k9ftPFkCFncPMr5+h6rk93ioIPlXpz8pn/quc
   hO4JAeV0Yn7y5MWUhdREtuZjbre0+JpJLsXG7aySH9pPgVM4/KBUdPuZ/
   xUTmzcNwzNzixKMCmv1B9dXo1sbVRupu/eDSOHZAifSOGPssZZhukGdi5
   MxiBqT2M2yQYjsME5XV2fNyShr9liGfHvQudRU6HPgcRdJwb3oSdgZS1p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802772"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802772"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:40:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075530"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:40:25 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 27/65] i386/tdx: Wire CPU features up with attributes of TD guest
Date: Thu, 29 Feb 2024 01:36:48 -0500
Message-Id: <20240229063726.610065-28-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For QEMU VMs, PKS is configured via CPUID_7_0_ECX_PKS and PMU is
configured by x86cpu->enable_pmu. Reuse the existing configuration
interface for TDX VMs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index b6295a644566..262e86fd2c67 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -33,6 +33,8 @@
                                      (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
 
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
+#define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
+#define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
 #define TDX_ATTRIBUTES_MAX_BITS      64
 
@@ -477,6 +479,15 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     return 0;
 }
 
+static void setup_td_guest_attributes(X86CPU *x86cpu)
+{
+    CPUX86State *env = &x86cpu->env;
+
+    tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
+                             TDX_TD_ATTRIBUTES_PKS : 0;
+    tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
+}
+
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
@@ -499,6 +510,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
         return r;
     }
 
+    setup_td_guest_attributes(x86cpu);
+
     init_vm->cpuid.nent = kvm_x86_arch_cpuid(env, init_vm->cpuid.entries, 0);
 
     init_vm->attributes = tdx_guest->attributes;
-- 
2.34.1


