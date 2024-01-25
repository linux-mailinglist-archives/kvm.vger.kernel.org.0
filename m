Return-Path: <kvm+bounces-6954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3F183B831
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02F04280F84
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96A212B8A;
	Thu, 25 Jan 2024 03:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cjb/mBZY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952ED12B70
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153441; cv=none; b=N2s0hiOP1fdVD9IoRRdIKbddOlXDwFBCFkUeDjXj1hz3q0b/rY0w1XFqxTxO7HBh8z9WS3OW7FjwzBU8OndrSvNynn3t3B9p38ieKvBbR4JEviiwjeCtfnau6Sc+aabLCzuA227WMC5woxuwvRH+2cwBzyMFsTSicocoXEGz3P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153441; c=relaxed/simple;
	bh=fDht0M8HIC/RtXrcbvEg+wKbn8OdTSNmi650IuzqiJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o1y+Eikkss3S1s11iyI9s6jrSefJJzTfVqWfR2BEdz2g6q/d5iQOZ6tHjbtmaMYwzcv928e6kpSQuLmCA6oO8w9aX/RLMqeW5Z6aTyzfXQhm6cxjb+1+MJuiW9aVIOvZycQzLcDDkQKEBRkHSnbzW6HGr/8SiYocfxjbTY1n+E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cjb/mBZY; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153439; x=1737689439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fDht0M8HIC/RtXrcbvEg+wKbn8OdTSNmi650IuzqiJs=;
  b=cjb/mBZYIUFXxdoZ62Ye6cV7+hFFod2peaRDOZnbSDU1afA7+OB/sje/
   1lYl3yKCFoUpi7a+wJs1+DgES+/K18BOU+MpvOUrxjcNuC7MhdDXk7erh
   HX7kvqGYXZqBOgPhQ02mafdx1+1aeW94sQDsb9o8LJ54zj+9ykmWBVLs/
   bZeippaOtxF1cZ3T9xAWWdESlp2+7bWxdJM+jJMXOqNt5DUtDcDRyccDV
   ibzESsOVjxpKlVq3AzPT48i0axnxQC6MJ7+7r0RVus93yNnWVPuXWs2Vs
   VuYu2wEiAOZvj+bJou0tLoxnkJAwaUQRkNH+5VRAfdPZuJ28m42k9qIAS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9430085"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9430085"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:28:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086138"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:28:17 -0800
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
Subject: [PATCH v4 52/66] i386/tdx: Handle TDG.VP.VMCALL<REPORT_FATAL_ERROR>
Date: Wed, 24 Jan 2024 22:23:14 -0500
Message-Id: <20240125032328.2522472-53-xiaoyao.li@intel.com>
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

TD guest can use TDG.VP.VMCALL<REPORT_FATAL_ERROR> to request termination
with error message encoded in GPRs.

Parse and print the error message, and terminate the TD guest in the
handler.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 39 +++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h |  1 +
 2 files changed, 40 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index f1c60274c448..1c79032ca262 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1078,6 +1078,43 @@ static int tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     return 0;
 }
 
+static int tdx_handle_report_fatal_error(X86CPU *cpu,
+                                         struct kvm_tdx_vmcall *vmcall)
+{
+    uint64_t error_code = vmcall->in_r12;
+    char *message = NULL;
+
+    if (error_code & 0xffff) {
+        error_report("TDX: REPORT_FATAL_ERROR: invalid error code: "
+                     "0x%lx\n", error_code);
+        return -1;
+    }
+
+    /* it has optional message */
+    if (vmcall->in_r14) {
+        uint64_t * tmp;
+
+#define GUEST_PANIC_INFO_TDX_MESSAGE_MAX        64
+        message = g_malloc0(GUEST_PANIC_INFO_TDX_MESSAGE_MAX + 1);
+
+        tmp = (uint64_t *)message;
+        /* The order is defined in TDX GHCI spec */
+        *(tmp++) = cpu_to_le64(vmcall->in_r14);
+        *(tmp++) = cpu_to_le64(vmcall->in_r15);
+        *(tmp++) = cpu_to_le64(vmcall->in_rbx);
+        *(tmp++) = cpu_to_le64(vmcall->in_rdi);
+        *(tmp++) = cpu_to_le64(vmcall->in_rsi);
+        *(tmp++) = cpu_to_le64(vmcall->in_r8);
+        *(tmp++) = cpu_to_le64(vmcall->in_r9);
+        *(tmp++) = cpu_to_le64(vmcall->in_rdx);
+        message[GUEST_PANIC_INFO_TDX_MESSAGE_MAX] = '\0';
+        assert((char *)tmp == message + GUEST_PANIC_INFO_TDX_MESSAGE_MAX);
+    }
+
+    error_report("TD guest reports fatal error. %s\n", message ? : "");
+    return -1;
+}
+
 static int tdx_handle_setup_event_notify_interrupt(X86CPU *cpu,
                                                    struct kvm_tdx_vmcall *vmcall)
 {
@@ -1112,6 +1149,8 @@ static int tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
         return tdx_handle_map_gpa(cpu, vmcall);
     case TDG_VP_VMCALL_GET_QUOTE:
         return tdx_handle_get_quote(cpu, vmcall);
+    case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
+        return  tdx_handle_report_fatal_error(cpu, vmcall);
     case TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT:
         return tdx_handle_setup_event_notify_interrupt(cpu, vmcall);
     default:
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index cedc7d7e226f..37fdd845f462 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -20,6 +20,7 @@ typedef struct TdxGuestClass {
 
 #define TDG_VP_VMCALL_MAP_GPA                           0x10001ULL
 #define TDG_VP_VMCALL_GET_QUOTE                         0x10002ULL
+#define TDG_VP_VMCALL_REPORT_FATAL_ERROR                0x10003ULL
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT      0x10004ULL
 
 #define TDG_VP_VMCALL_SUCCESS           0x0000000000000000ULL
-- 
2.34.1


