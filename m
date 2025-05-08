Return-Path: <kvm+bounces-45944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5D4AAAFEA6
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:13:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC01A17B3AC
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F0B287517;
	Thu,  8 May 2025 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hLwsckL3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B36F276054
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716823; cv=none; b=PSvx5GU5dUah5+AxE5Z9mZum0qWrMquFZ6k3gk8QLsePuLShBd09WF/jzqZaj2L5NGa8MFuknO5tNLpnS3Ci9YxME9dSC8wrcmPV2aRk8KUvfxZRuXjUZKpAQUfZIvgMc3sxGEGq70f7A77SAGtCqIVKcb0aj/IKZDgqZmAUusE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716823; c=relaxed/simple;
	bh=pOOQrH0r21D3RUmO6grDlkePBA5BARKSWD6S8v1sNVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Plc9FJq8Fqp85la6/AcKP/MbHCoYja9UON33jCaSEqjjkDLeMAggBr0KYZEJrqrDuVxDBBnfm7tKFUPOBaezu4zxEUI/GVfi3ohtW1M/fG4u9I3VjQaOpXTZ5olFLy4BDI/Tw0c5ZCaQBRvA3SW6rjYw65QuxOt10isOQKx1pR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hLwsckL3; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716822; x=1778252822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pOOQrH0r21D3RUmO6grDlkePBA5BARKSWD6S8v1sNVA=;
  b=hLwsckL3spQWcDvRZy8hjbnlnG3JpzOeE8Ej+gOOlox9C6oKFGq7BXf9
   pdIZ/GfGZQ+P2ex+QFQZo7nT28KfsuwQNEP6/h1XioSbkjXV9UtiYIW5i
   7+fVIaC/jPdcd7L5MIV9LLx2YMuwTaGwyTI4J8AJ3WpbMfP8qjo70QO4z
   MHRnHKDuUYNEoSvknM+aJz8NcnjmSXkVk9SvNmlpr0pLYlDRnxMrSnsiz
   Kop2M0xjrFxaHauq+Hzj5+xUQ/EVDQuzjKyUJDeS7L7oVrXdodDNiUnjt
   aP3LuckOoauA8+M+YLD5C63NLPuJEydBSoh2TqRRP8Cbbtn1rZwWXPd5t
   w==;
X-CSE-ConnectionGUID: p2rvj9QvRx28BDw+k2xbPA==
X-CSE-MsgGUID: QE7HODvkT3mNCjFvKDbuWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888415"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888415"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:01 -0700
X-CSE-ConnectionGUID: durcEn7/Q4mZwrA5xTWj6g==
X-CSE-MsgGUID: kg9m63EFRjW4JNemURaQFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440345"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:58 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 41/55] i386/apic: Skip kvm_apic_put() for TDX
Date: Thu,  8 May 2025 10:59:47 -0400
Message-ID: <20250508150002.689633-42-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM neithers allow writing to MSR_IA32_APICBASE for TDs, nor allow for
KVM_SET_LAPIC[*].

Note, KVM_GET_LAPIC is also disallowed for TDX. It is called in the path

  do_kvm_cpu_synchronize_state()
  -> kvm_arch_get_registers()
     -> kvm_get_apic()

and it's already disllowed for confidential guest through
guest_state_protected.

[*] https://lore.kernel.org/all/Z3w4Ku4Jq0CrtXne@google.com/

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v8:
- Fix the coding style; (Francesco)
---
 hw/i386/kvm/apic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 757510600098..cb65fca49586 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -17,6 +17,7 @@
 #include "system/hw_accel.h"
 #include "system/kvm.h"
 #include "kvm/kvm_i386.h"
+#include "kvm/tdx.h"
 
 static inline void kvm_apic_set_reg(struct kvm_lapic_state *kapic,
                                     int reg_id, uint32_t val)
@@ -141,6 +142,10 @@ static void kvm_apic_put(CPUState *cs, run_on_cpu_data data)
     struct kvm_lapic_state kapic;
     int ret;
 
+    if (is_tdx_vm()) {
+        return;
+    }
+
     kvm_put_apicbase(s->cpu, s->apicbase);
     kvm_put_apic_state(s, &kapic);
 
-- 
2.43.0


