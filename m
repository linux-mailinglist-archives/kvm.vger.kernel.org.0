Return-Path: <kvm+bounces-7922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CAA58484E5
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E30B1C224C7
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BBBD6EB42;
	Sat,  3 Feb 2024 09:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VhF4F9uH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607F56E2DC;
	Sat,  3 Feb 2024 09:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950936; cv=none; b=QYDZxDz/Y10TU9o9kzTi6OwxQ3SolVp0JFe8VALXNddKUe/12VssOSbckD09/UsS2I7Lb7iSdbkXFrKsh7+AEmQEovZKAxbzOvwa8rETneZEaMxgKqKVkdXkQQTDm3m0hFoS9mUVal+o94IaVa+VfrpYPk2U3ECoZ6D1SW1aReQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950936; c=relaxed/simple;
	bh=qd5tUyNdUljBtdVqZxN09u5VE/YXPZNXPRlXvr1e0nQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G+AkXa9y5shuEoDm/VVuEoZLIRMlxQrwRH+JVSyJAXm8iHlSPljtQkHOzawGqMMfGHlRL7jY5XeJn96rbzqSAfSaUB7kGvtsz4KHa3m5xix5obg4yr5T678X7rVlrIc/SkZjv7Shjd6mP7nliFwkATN0RQUTsULWeAufjx7c8Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VhF4F9uH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950936; x=1738486936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qd5tUyNdUljBtdVqZxN09u5VE/YXPZNXPRlXvr1e0nQ=;
  b=VhF4F9uHPsiQEfgzIALsBC591Bf2JZwj+N/i98F27t8blI4rVupo6T0s
   MZvk9eESQBodl2jJAbHCdg5iL/J+eYKJWlXYxfLwBUPCgH92SrUevKYrL
   ZHROiCXCmx4ISEX8hMKUBS8D+7riFxGD9mklvY/i87UngBGJ8mUhrqzxO
   rpc6gTD0bgRlOqCLPw1/XwDqETadKuUlTVxQsa6PdL7W9WgZC+mIG0LUS
   CxSOMkXShxLC9FJ29H52Tu6kr/K6M7W+PzRgKYFCq3bSR2ystbs4i2aqI
   SbeWrqZpVzUqKMR3hqyAfT8STiB/MW3kZPeZy8eyAu3RH1lKCgZQbZcWZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132272"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132272"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:02:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291619"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:02:08 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 26/26] Documentation: KVM: Add description of pkg_therm_lock
Date: Sat,  3 Feb 2024 17:12:14 +0800
Message-Id: <20240203091214.411862-27-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

pkg_therm_lock is a per-VM lock and used in PTS, HFI and ITD
virtualization supports. Add description about it.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 Documentation/virt/kvm/locking.rst | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 02880d5552d5..84a138916898 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -290,7 +290,7 @@ time it will be set using the Dirty tracking mechanism described above.
 		wakeup.
 
 ``vendor_module_lock``
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+^^^^^^^^^^^^^^^^^^^^^^
 :Type:		mutex
 :Arch:		x86
 :Protects:	loading a vendor module (kvm_amd or kvm_intel)
@@ -298,3 +298,14 @@ time it will be set using the Dirty tracking mechanism described above.
     taken outside of kvm_lock, e.g. in KVM's CPU online/offline callbacks, and
     many operations need to take cpu_hotplug_lock when loading a vendor module,
     e.g. updating static calls.
+
+``pkg_therm_lock``
+^^^^^^^^^^^^^^^^^^
+:Type:		mutex
+:Arch:		x86 (vmx)
+:Protects:	PTS, HFI and ITD emulation
+:Comment:	This is a per-VM lock and it is used for VM level thermal features'
+    emulation (PTS, HFI and ITD). When these features' emulated MSRs need to
+    be changed, or when we handle the virtual HFI table's update, this lock is
+    needed to create the atomi context and to avoid competing behavior of other
+    vCPUs in the same VM.
-- 
2.34.1


