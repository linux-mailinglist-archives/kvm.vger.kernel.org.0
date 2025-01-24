Return-Path: <kvm+bounces-36512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADCD0A1B709
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:39:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D12B3AEBE0
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C68A132105;
	Fri, 24 Jan 2025 13:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qps1qDj6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49C335947
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725921; cv=none; b=HJdkKe9scX4Pi6QPmPe854Bfc85dwE2oH17WMiTHUfpETVVGo05i+jXfO7ecBMQlaL5OVQ0ODIEMuKK3/zVKSitiJU7PEbt1cVMTZcwEYWk2ezPhw9+MG+sXEzgtJQGRm8S4MWASmmmWIz1KaR9vQFF1BM6dWMY6oivJFLxI7kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725921; c=relaxed/simple;
	bh=yjeFsx3DLSpiqpqVn548Wr6nyNm4xYxJhSEfr1UJ2Ho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KEUBF5JsWXgB4xqVsMalgJ/DAnDKdTDoniQe/E+OtG8mzA5OL2Cjg9YS9Qzvl64iKZTSoqks0+Fwjxi2JkuqkXPFaHuLHEa6UMShBJElveoYiS0dSiSKmUSn22c6zHPA22WQlYlwKDZyLo4oXyTz9vPMdqyh2Q+JYJFcfRu4ZtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qps1qDj6; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725920; x=1769261920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yjeFsx3DLSpiqpqVn548Wr6nyNm4xYxJhSEfr1UJ2Ho=;
  b=Qps1qDj6zWFLmSq8u4LUDnqWQ+d8nCrH7Z3H81JcY+IS7XqtwoUSUNKc
   CVEht3XbYiIpti7PH12v7otV6gok+g9rKawXQqGEBPnT52+xOScKge1MU
   VUaTV5EumumrFZ6bHub3hY0+XmVdkjAS9setM0k3Qrwb8nH5mnn3fldc2
   mCk6Lxx9aWYf7NUJNfN8gydihm1IY2oEZIiv0LyAF0TmcIKBDWwAd0PLo
   fm0Wi4YttkAjM2HWGktTZ19WTGGe2WwpHUrAJIzRWUNch/Hqf2d6PdlWR
   xA4aWtaa5+iU1+pmzUes4f9vpNr+IpQYJV5c2rjw+npCLeF4ycGLYr1kT
   g==;
X-CSE-ConnectionGUID: isNyObOOQqeAS8TO9rNb2A==
X-CSE-MsgGUID: jq9Y/29YTQmfRL7djyjSUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246435"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246435"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:40 -0800
X-CSE-ConnectionGUID: s85VyDiiTO6zeiWrug6ntg==
X-CSE-MsgGUID: BGIFg/2wSx62RdhW/FXsjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804331"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:36 -0800
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
Subject: [PATCH v7 26/52] i386/tdx: Enable user exit on KVM_HC_MAP_GPA_RANGE
Date: Fri, 24 Jan 2025 08:20:22 -0500
Message-Id: <20250124132048.3229049-27-xiaoyao.li@intel.com>
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

KVM translates TDG.VP.VMCALL<MapGPA> to KVM_HC_MAP_GPA_RANGE, and QEMU
needs to enable user exit on KVM_HC_MAP_GPA_RANGE in order to handle the
memory conversion requested by TD guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
changes in v6:
 - new patch;
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d7f7f8301ca2..1d0cf29c39f9 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,8 @@
 #include "system/system.h"
 #include "exec/ramblock.h"
 
+#include <linux/kvm_para.h>
+
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/tdvf.h"
@@ -374,6 +376,11 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         }
     }
 
+    /* TDX relies on KVM_HC_MAP_GPA_RANGE to handle TDG.VP.VMCALL<MapGPA> */
+    if (!kvm_enable_hypercall(BIT_ULL(KVM_HC_MAP_GPA_RANGE))) {
+        return -EOPNOTSUPP;
+    }
+
     qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
 
     tdx_guest = tdx;
-- 
2.34.1


