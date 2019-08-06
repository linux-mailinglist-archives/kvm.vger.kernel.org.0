Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83D783920
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 20:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfHFS5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 14:57:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:40919 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbfHFS5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 14:57:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 11:57:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="176715109"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 06 Aug 2019 11:57:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 15/20] hw/i386/pc: Set SGX bits in feature control fw_cfg accordingly
Date:   Tue,  6 Aug 2019 11:56:44 -0700
Message-Id: <20190806185649.2476-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806185649.2476-1-sean.j.christopherson@intel.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Request SGX an SGX Launch Control to be enabled in FEATURE_CONTROL when
the features are exposed to the guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 hw/i386/pc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 549c437050..8c8b404799 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1670,7 +1670,7 @@ static void pc_build_feature_control_file(PCMachineState *pcms)
     MachineState *ms = MACHINE(pcms);
     X86CPU *cpu = X86_CPU(ms->possible_cpus->cpus[0].cpu);
     CPUX86State *env = &cpu->env;
-    uint32_t unused, ecx, edx;
+    uint32_t unused, ebx, ecx, edx;
     uint64_t feature_control_bits = 0;
     uint64_t *val;
 
@@ -1685,6 +1685,14 @@ static void pc_build_feature_control_file(PCMachineState *pcms)
         feature_control_bits |= FEATURE_CONTROL_LMCE;
     }
 
+    cpu_x86_cpuid(env, 0x7, 0, &unused, &ebx, &ecx, &unused);
+    if (ebx & CPUID_7_0_EBX_SGX) {
+        feature_control_bits |= FEATURE_CONTROL_SGX;
+    }
+    if (ecx & CPUID_7_0_ECX_SGX_LC) {
+        feature_control_bits |= FEATURE_CONTROL_SGX_LC;
+    }
+
     if (!feature_control_bits) {
         return;
     }
-- 
2.22.0

