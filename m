Return-Path: <kvm+bounces-1784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4483A7EBDE5
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 735CE1C208F8
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492BAC139;
	Wed, 15 Nov 2023 07:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BxhPWXws"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C428EBA5F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:22:52 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3319E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032971; x=1731568971;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8BrgXfAQfZqcjZLSqCUCb/djRTy+aDK5w/IlCWoRec8=;
  b=BxhPWXwsY132f+BimuGVmgtv6hjha1GJDsjDSaKK8LjeOhzHo1RyWLo9
   rXxulUmD/aOPy8BHwACG17p3YJvxFXq4dTEzxwN6Elz/6Lf3Usy/UYs1M
   H7GLRjH+BexJGOedBFFutrGsbVG45Do5tDn2QnCFjaK089jQNxljHjxgt
   vSYqbkuadbmMVTmIlfdZfiboXAFcAWQGpNhou1d6Z7xkM+uTbb9X7wz8X
   gqogcQW3xp/G4fcJ6jlRoqMBWeG1rnMRT8DdUracVHRhCholMgR7iblZU
   i7AaDaAW9hliRDIcdew19UpRVkuB+NKOuIEJyufbEdmNFAbE1kcQO1qUn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623497"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623497"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:22:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800309"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800309"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:22:45 -0800
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
Subject: [PATCH v3 56/70] i386/tdx: Handle TDG.VP.VMCALL<REPORT_FATAL_ERROR>
Date: Wed, 15 Nov 2023 02:15:05 -0500
Message-Id: <20231115071519.2864957-57-xiaoyao.li@intel.com>
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

TD guest can use TDG.VP.VMCALL<REPORT_FATAL_ERROR> to request termination
with error message encoded in GPRs.

Parse and print the error message, and terminate the TD guest in the
handler.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 96a10b0bb190..a42b5cea36c5 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1003,6 +1003,7 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
 
 #define TDG_VP_VMCALL_MAP_GPA                           0x10001ULL
 #define TDG_VP_VMCALL_GET_QUOTE                         0x10002ULL
+#define TDG_VP_VMCALL_REPORT_FATAL_ERROR                0x10003ULL
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT      0x10004ULL
 
 #define TDG_VP_VMCALL_SUCCESS           0x0000000000000000ULL
@@ -1478,6 +1479,42 @@ static void tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
 }
 
+static void tdx_handle_report_fatal_error(X86CPU *cpu,
+                                          struct kvm_tdx_vmcall *vmcall)
+{
+    uint64_t error_code = vmcall->in_r12;
+    char *message = NULL;
+
+    if (error_code & 0xffff) {
+        error_report("invalid error code of TDG.VP.VMCALL<REPORT_FATAL_ERROR>\n");
+        exit(1);
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
+    exit(1);
+}
+
 static void tdx_handle_setup_event_notify_interrupt(X86CPU *cpu,
                                                     struct kvm_tdx_vmcall *vmcall)
 {
@@ -1512,6 +1549,9 @@ static void tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     case TDG_VP_VMCALL_GET_QUOTE:
         tdx_handle_get_quote(cpu, vmcall);
         break;
+    case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
+        tdx_handle_report_fatal_error(cpu, vmcall);
+        break;
     case TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT:
         tdx_handle_setup_event_notify_interrupt(cpu, vmcall);
         break;
-- 
2.34.1


