Return-Path: <kvm+bounces-1783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E2D7EBDE4
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2BD7B20C87
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CD1BA55;
	Wed, 15 Nov 2023 07:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ck+SC4LT"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C05BA43
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:22:48 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541EDD1
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032967; x=1731568967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vhVcnJA235Fj2gwGFH0mC11AUNmdkNpBg9xHCT6QPd4=;
  b=ck+SC4LTn6pcJIglUy71ZoVCSI80ZYzqiny6No7OAX/SEbKNV2/kTjeW
   Jl7GWSANkTLGhoW4Rz7QsjSzyP0jEv0JJstQjQBIbjjlgLSC16c6IgbNR
   /iL4Xw1hlZDXJ8jd29feF9Vh552O9rg892su2SZ9RLPff6uoKvpnrJsaW
   w9ZXOUjEpQOslnhWnwmd3u4fbxroVRA7RMm6ep7cJ/si9/IUMAOuGtegE
   RNYaBSPdRLeHOu8szri+6I4YkqVOXY2T3mfUr43yhVaVTcOt/Sqvk/7pj
   wdYG1avk4s5xV/zAXKcUzCNPiyjG4A173C4VA9vfXG0N0YuLBFBtq5MQq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623479"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623479"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:22:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800296"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800296"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:22:39 -0800
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
Subject: [PATCH v3 55/70] i386/tdx: Limit the range size for MapGPA
Date: Wed, 15 Nov 2023 02:15:04 -0500
Message-Id: <20231115071519.2864957-56-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

If the range for TDG.VP.VMCALL<MapGPA> is too large, process the limited
size and return retry error.  It's bad for VMM to take too long time,
e.g. second order, with blocking vcpu execution.  It results in too many
missing timer interrupts.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index b17258f17fd0..96a10b0bb190 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1061,12 +1061,16 @@ static hwaddr tdx_shared_bit(X86CPU *cpu)
     return (cpu->phys_bits > 48) ? BIT_ULL(51) : BIT_ULL(47);
 }
 
+/* 64MB at most in one call. What value is appropriate? */
+#define TDX_MAP_GPA_MAX_LEN     (64 * 1024 * 1024)
+
 static void tdx_handle_map_gpa(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
 {
     hwaddr shared_bit = tdx_shared_bit(cpu);
     hwaddr gpa = vmcall->in_r12 & ~shared_bit;
     bool private = !(vmcall->in_r12 & shared_bit);
     hwaddr size = vmcall->in_r13;
+    bool retry = false;
     int ret = 0;
 
     vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
@@ -1085,12 +1089,25 @@ static void tdx_handle_map_gpa(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
         return;
     }
 
+    if (size > TDX_MAP_GPA_MAX_LEN) {
+        retry = true;
+        size = TDX_MAP_GPA_MAX_LEN;
+    }
+
     if (size > 0) {
         ret = kvm_convert_memory(gpa, size, private);
     }
 
     if (!ret) {
-        vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
+        if (retry) {
+            vmcall->status_code = TDG_VP_VMCALL_RETRY;
+            vmcall->out_r11 = gpa + size;
+            if (!private) {
+                vmcall->out_r11 |= shared_bit;
+            }
+        } else {
+            vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
+        }
     }
 }
 
-- 
2.34.1


