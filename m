Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA34931C54C
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhBPCPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:15:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:30899 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhBPCPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:15:47 -0500
IronPort-SDR: xiK4qGdkPMJqBW+9vmCrjxGhZHTIgzgNuXNaAevMKWToK5lAMZezdPSbnEZJwuRk1VyJg5ym+P
 3VSNZrnUTTcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="182865762"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="182865762"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:53 -0800
IronPort-SDR: UeepbfHIqHro3Oe0YEBnszN0k3HD0n+ZeFXdp78DRv7POcOCW9F0i0vdGf28jsnsVE0fbS7xRY
 G+ETri2r/2qw==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705450"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:53 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH 21/23] i386/tdx: Use KVM_TDX_INIT_VCPU to pass HOB to TDVF
Date:   Mon, 15 Feb 2021 18:13:17 -0800
Message-Id: <5b25b7ef1249b2a229aa74541665c83009a99faf.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Specify the initial value for RCX/R8 to be the address of the HOB.
Don't propagate the value to Qemu's cache of the registers so as to
avoid implying that the register state is valid, e.g. Qemu doesn't model
TDX-SEAM behavior for initializing other GPRs.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/kvm/tdx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 49b4355849..007d33989b 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -268,10 +268,17 @@ out:
 
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
2.17.1

