Return-Path: <kvm+bounces-30646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A61919BC583
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DE56B22422
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB3F1F754A;
	Tue,  5 Nov 2024 06:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NNLqft3w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DEB1F6667
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788634; cv=none; b=s2kxX1K5qVfxP8+JP5wtR3jOe/OQoJDt7imGGubphfP5BPZVgsJNPlJhzh/xuEtrjMYfc7EZdO92HWoqnkWL3W4LVRB3UnnIiJanbMvLasWQgDUHYkn9ShL+vfyb3/Y24q0MIyg6RCbYJnsskvt/0YpXhAFoENDKN2d/MLAbW38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788634; c=relaxed/simple;
	bh=oOcXPFYjwedzTDjXBfJ22esNNNhA5wHUGcb1V46w02g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ColYE6u4DsXYk6s3GHTNOmfyWhvhI1+u3Q/MiLw+eCRTkR28i8n1vYBmBZaFXv1X6jPavtpeAZI+bbgwfYw9tniAcBcKPTHuS+t96YGXoHuGGbC9ICFwUWl4Suah0Jgz+S/il/jAoYnaDE/9YFOFEjSXNmowevGwocehGQFn9hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NNLqft3w; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788633; x=1762324633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oOcXPFYjwedzTDjXBfJ22esNNNhA5wHUGcb1V46w02g=;
  b=NNLqft3wSOPvZ+0JeRXtHtiXVegc9C96x9fd9S44w4xRh60jiXKwUQcw
   ApAOFEAAiw39/W0SScskIAq2kW9sSpy2xKNFW5vXhLmXiaWn1Y/9NeawU
   3XOmRzwA+EeyvjaDMpBnJ6lOj3NufVzXaUeQw2nLtI0S2zIh+gtIwNGQ5
   11HMGprWwwB1gRrsT5ba4CQ5nVveyf1fkk4u+d60QVT0iYGhL/GMqDUpF
   hHRrcfSBbZEvTislm99Yv+teqa1kX+uDuaoP6SGA7Ilid66vxizWlKb86
   RauTc3htClcYquSb3/kHRHPlMB2cr4zWaN8tQOPLzCm7hCxtLW/FSK+cQ
   g==;
X-CSE-ConnectionGUID: crnOrcC0QYSIg2WaR5oo+A==
X-CSE-MsgGUID: Tkor2lEpStuwEcQ446kAsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689407"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689407"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:37:13 -0800
X-CSE-ConnectionGUID: S/SrZVnbRye6tYey39q1gQ==
X-CSE-MsgGUID: gPwWQciUSUSPcF3ezm7Hdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988765"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:37:09 -0800
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
Subject: [PATCH v6 12/60] i386/tdx: Wire CPU features up with attributes of TD guest
Date: Tue,  5 Nov 2024 01:23:20 -0500
Message-Id: <20241105062408.3533704-13-xiaoyao.li@intel.com>
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

For QEMU VMs,
  - PKS is configured via CPUID_7_0_ECX_PKS, e.g., -cpu xxx,+pks  and
  - PMU is configured by x86cpu->enable_pmu, e.g., -cpu xxx,pmu=on

While the bit 30 (PKS) and bit 63 (PERFMON) of TD's attributes are also
used to configure the PKS and PERFMON/PMU of TD, reuse the existing
configuration interfaces of 'cpu' for TD's attributes.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e8fd5c7d49e7..6cf81f788fe0 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -21,6 +21,8 @@
 #include "tdx.h"
 
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
+#define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
+#define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
 static TdxGuest *tdx_guest;
 
@@ -139,6 +141,15 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
     return KVM_X86_TDX_VM;
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
 static int setup_td_xfam(X86CPU *x86cpu, Error **errp)
 {
     CPUX86State *env = &x86cpu->env;
@@ -200,6 +211,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
+    setup_td_guest_attributes(x86cpu);
+
     r = setup_td_xfam(x86cpu, errp);
     if (r) {
         return r;
-- 
2.34.1


