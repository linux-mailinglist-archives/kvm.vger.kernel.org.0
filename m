Return-Path: <kvm+bounces-6961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A9483B845
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB2D31C21ABD
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4263C11185;
	Thu, 25 Jan 2024 03:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iGZXsVRi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091E28472
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153474; cv=none; b=Ub8qi93kKME0u+KqRASqiLYpS6P+/OmApWs9++SHw+FdaH3NUXDJ+s69Ag08HeoBcROTq+YJwP+i7SmdGqTLHT2CO4EZmF393xZ7fpjPTofLZ62oGo5Imzf4cBF2SIMSz1uTvUcPKltgo7B9bDLDemosi0KlybZk2sfqMHrJT+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153474; c=relaxed/simple;
	bh=kAhbpSvf5mcqCqnuUHwzUyFR0bBkU6DMg1Kt+jDOu9k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T7uuDg0tJdozihMP6D10nr2M177TmOMxa+aFrztGwL9x8gmHcna1b6tLgO6xC4U7WYIYFK4Gx+vb8VJrqPmp3nfvAWcfF//z5doSK6aj5iUCKACxDg6U8vI9+4FMNVKigyZRfgRiIEHnuWzdRFsCnN9iwq0FllVvt4NSAJaCOw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iGZXsVRi; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153473; x=1737689473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kAhbpSvf5mcqCqnuUHwzUyFR0bBkU6DMg1Kt+jDOu9k=;
  b=iGZXsVRix4tpoiDPn0j9uoPBGkc3/d/SWfEE8M4VZaVG7TY8fDM/4LKg
   wDs/BGIfeq0E/mbCOQiaLxbAwjDnUblyZlyABRZui0wogl+E5LUZcEHfa
   M5Bzbn7aO0xLUkts5DEyJwf2z46nbYXoDVYO25sOpzGNgkYW9MNgLRxMf
   e40s86RD4gQilOy7Ex/9LwPQkwywHzMrS9NFoXGiR+GxaD4YU7xbh2QNy
   EyVEN/YpDhEA1p6vdpRyECgMSVQio203X/K2LCooDnrF5xBZ6K73pR1e4
   R3Iz4WQvyNZhuM+79e+giAWguA1ucJGFY5/ZS78ayd/N5esfallSdVM91
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9430409"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9430409"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:29:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086471"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:28:55 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 59/66] i386/tdx: LMCE is not supported for TDX
Date: Wed, 24 Jan 2024 22:23:21 -0500
Message-Id: <20240125032328.2522472-60-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LMCE is not supported TDX since KVM doesn't provide emulation for
MSR_IA32_FEAT_CTL.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm-cpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 9c791b7b0520..8c618869533c 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -15,6 +15,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/boards.h"
 
+#include "tdx.h"
 #include "kvm_i386.h"
 #include "hw/core/accel-cpu.h"
 
@@ -60,6 +61,10 @@ static bool lmce_supported(void)
     if (kvm_ioctl(kvm_state, KVM_X86_GET_MCE_CAP_SUPPORTED, &mce_cap) < 0) {
         return false;
     }
+
+    if (is_tdx_vm())
+        return false;
+
     return !!(mce_cap & MCG_LMCE_P);
 }
 
-- 
2.34.1


