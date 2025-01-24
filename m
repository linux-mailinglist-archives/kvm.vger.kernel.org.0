Return-Path: <kvm+bounces-36533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A42A5A1B725
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBEA33A00D3
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D551547F3;
	Fri, 24 Jan 2025 13:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EfsNqMfz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48208632E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737726000; cv=none; b=IvruEoz/DWnG4kiLuGhA4z1XKQow6V+4VWETJFfcBVJMaPIn3FvAfxkfG+i4RiPmFhUdLPFkXGiNAvIO5Rp7dj+xhA4wmFm8Q/jgDY3oRZN9lwD4P9e4axDRh6TPn7gEFw+FUpKLV0mmi10uhkC9jX+1u68Z89m8oy7Ri+Z0LzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737726000; c=relaxed/simple;
	bh=JKMlucssmDcGsanH6kb+uP0DlL1BGA8NocL5uyi4aSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HvpkoVWo1Ky7FxbEO0mil4jKsKMY9trq46KwT2mo57Hc7YXf5LMNwlbkXj+xFRBsyzePLY+gC2mI8Knd34XxAYDseXUq/J8QwrpopbvE5YchqlgiBV+XmAh8nV57aG8BHUqar24VndKK0QBWAW+3dyZzx71bzUb3UaUvlJueM9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EfsNqMfz; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725999; x=1769261999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JKMlucssmDcGsanH6kb+uP0DlL1BGA8NocL5uyi4aSQ=;
  b=EfsNqMfzj795nTOu7lZHrndo0Pz9mn9SMflB1tvvG0JGZeeHn7kxfqE6
   KA6rWsbLshn4VZr3beXHKpFVjVS9PNHdCtblZJs1XipMfqZbOAmOASpNR
   DimkPX+qDfLNx6HdOWjMN9ejYtXRmL2BYvqFwkbCaps+eG7RyY/b8q8OQ
   B9IPygVUS7r9LubKOXkK9SDgS+UUkBlzhyn5rwaPh3VLaMoW94sR/jpUv
   igdbiUBaEP4Jdvyq/btXBhGQT1FAU9HTAEpaDEtzUBp3Nlu9MKPuW0tcO
   B63IcNkR5Lrps0Sl5/clLDUZuZFk3nQHxUv+mX/zeYcWoiqePICK3lVGP
   Q==;
X-CSE-ConnectionGUID: Oz4XBxHVQfGIwPNytH5BWg==
X-CSE-MsgGUID: +DO3QG+JRcyZpeDLe2S2fg==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246617"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246617"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:59 -0800
X-CSE-ConnectionGUID: MhmOIQIkSiiYhKyyfDZaXg==
X-CSE-MsgGUID: F+sYU9DxSfK/Y6tdvLojTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804477"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:55 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 47/52] i386/cgs: Introduce x86_confidential_guest_check_features()
Date: Fri, 24 Jan 2025 08:20:43 -0500
Message-Id: <20250124132048.3229049-48-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To do cgs specific feature checking. Note the feature checking in
x86_cpu_filter_features() is valid for non-cgs VMs. For cgs VMs like
TDX, what features can be supported has more restrictions.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/confidential-guest.h | 13 +++++++++++++
 target/i386/kvm/kvm.c            |  8 ++++++++
 2 files changed, 21 insertions(+)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 777d43cc9688..48b88dbd3130 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -42,6 +42,7 @@ struct X86ConfidentialGuestClass {
     void (*cpu_instance_init)(X86ConfidentialGuest *cg, CPUState *cpu);
     uint32_t (*adjust_cpuid_features)(X86ConfidentialGuest *cg, uint32_t feature,
                                       uint32_t index, int reg, uint32_t value);
+    int (*check_features)(X86ConfidentialGuest *cg, CPUState *cs);
 };
 
 /**
@@ -91,4 +92,16 @@ static inline int x86_confidential_guest_adjust_cpuid_features(X86ConfidentialGu
     }
 }
 
+static inline int x86_confidential_guest_check_features(X86ConfidentialGuest *cg,
+                                                        CPUState *cs)
+{
+    X86ConfidentialGuestClass *klass = X86_CONFIDENTIAL_GUEST_GET_CLASS(cg);
+
+    if (klass->check_features) {
+        return klass->check_features(cg, cs);
+    }
+
+    return 0;
+}
+
 #endif
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 17d7bf6ae9aa..27b4a069d194 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2092,6 +2092,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
     int r;
     Error *local_err = NULL;
 
+    if (current_machine->cgs) {
+        r = x86_confidential_guest_check_features(
+                X86_CONFIDENTIAL_GUEST(current_machine->cgs), cs);
+        if (r < 0) {
+            return r;
+        }
+    }
+
     memset(&cpuid_data, 0, sizeof(cpuid_data));
 
     cpuid_i = 0;
-- 
2.34.1


