Return-Path: <kvm+bounces-30662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF71B9BC5A0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75E98B2192B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA2841FEFB9;
	Tue,  5 Nov 2024 06:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eoplg+BF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4874F1FCF71
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788704; cv=none; b=ufm95Thv/7YxhyM5p1MRGvFEUyc3PjCNLO8x91o81eacJZ+u4gcTXh3YVGkThFPdF+hMpf23h4yU3nPTYHUcLn1VnEiKosP5tBDvS6qunVYaNAFkGyRCXgLyWzV/N3VOvIKBOsmv0x2gPEnPjjXd6A1yh6Gn/TJzctGF1zYr1gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788704; c=relaxed/simple;
	bh=yTZNX+NQ5Q3yptqAX7/efQmRoNrRURBtZaK/2Teq53U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HnFDuxrmLf9EDgbV57t+SMuJTzpkDXViHYkXfDuCWnrha0lHUATebsE+qxmf8CybtvHnUh9aaIXJhdoHsQ5CjKbBuwI/WGTKlWZr3nbtVkvicPXKML0lp/0UYvh/xWFrZmTNifVeuoUKw/zoPqp74JPSl8pKweYssKSE0fEsl6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eoplg+BF; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788703; x=1762324703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yTZNX+NQ5Q3yptqAX7/efQmRoNrRURBtZaK/2Teq53U=;
  b=eoplg+BFCHEirWZ7zobYMtfhqY+p9DygR9zjl6afpUBvhEw/mdKP3sBs
   s461kOqSIBXJl2v7JUrtUMxBvN4FFD3npW3xEJHKfsVc2X2feFkWpfj1Z
   KgSFuipoZO9TvtRwHg40AhHBtKASpYEwxLn3IiqHv7iBx3xqL3LUyXCzQ
   P0rOLCtdObc+niQCgAqlvWw8eajdSYjIht679WsXFnvzytzew5S8uP5zP
   UYZiB2pXUPW9+5Ovy7Z9Qr8kVmDWXQZ2OlzC5POctvmAIZpJwyP4lIm9g
   OoT2+iFUsJoGl0gEDTmrD6e4OUXU9Sh0GoUgOpGwzg/mwv0kynscBgJx1
   Q==;
X-CSE-ConnectionGUID: bn/kwFCgQ324J3AqbK9RDA==
X-CSE-MsgGUID: TQ2SibEPQ3SbyhjcquxQeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689615"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689615"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:23 -0800
X-CSE-ConnectionGUID: BJdYU1grQeKHRWNJj1QRwA==
X-CSE-MsgGUID: M0YwmNanRkGKH2IyrQ+pEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989093"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:19 -0800
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
Subject: [PATCH v6 28/60] i386/tdx: Enable user exit on KVM_HC_MAP_GPA_RANGE
Date: Tue,  5 Nov 2024 01:23:36 -0500
Message-Id: <20241105062408.3533704-29-xiaoyao.li@intel.com>
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
index 33d7ed039051..b34707e93f4d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -20,6 +20,8 @@
 #include "sysemu/sysemu.h"
 #include "exec/ramblock.h"
 
+#include <linux/kvm_para.h>
+
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/tdvf.h"
@@ -362,6 +364,11 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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


