Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA473BF30B
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhGHA6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:19087 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230229AbhGHA6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209462002"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209462002"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:57 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770062"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:56 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 23/44] i386/tdx: Use KVM_TDX_INIT_VCPU to pass HOB to TDVF
Date:   Wed,  7 Jul 2021 17:54:53 -0700
Message-Id: <3b5827e8f4004c332d679eb55c98e23cbe53dfeb.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Specify the initial value for RCX/R8 to be the address of the HOB.
Don't propagate the value to Qemu's cache of the registers so as to
avoid implying that the register state is valid, e.g. Qemu doesn't model
TDX-SEAM behavior for initializing other GPRs.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/kvm/tdx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 0cd649dd01..c348626dbf 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -285,10 +285,17 @@ out:
 
 void tdx_post_init_vcpu(CPUState *cpu)
 {
-    CPUX86State *env = &X86_CPU(cpu)->env;
+    MachineState *ms = MACHINE(qdev_get_machine());
+    TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
+                                                    TYPE_TDX_GUEST);
+    TdxFirmwareEntry *hob;
+
+    if (!tdx) {
+        return;
+    }
 
-    _tdx_ioctl(cpu, KVM_TDX_INIT_VCPU, 0,
-               (void *)(unsigned long)env->regs[R_ECX]);
+    hob = tdx_get_hob_entry(tdx);
+    _tdx_ioctl(cpu, KVM_TDX_INIT_VCPU, 0, (void *)hob->address);
 }
 
 static bool tdx_guest_get_debug(Object *obj, Error **errp)
-- 
2.25.1

