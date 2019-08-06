Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDA48391E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 20:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfHFS5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 14:57:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:40914 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbfHFS5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 14:57:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 11:57:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="176715111"
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
Subject: [RFC PATCH 16/20] hw/i386/pc: Account for SGX EPC sections when calculating device memory
Date:   Tue,  6 Aug 2019 11:56:45 -0700
Message-Id: <20190806185649.2476-17-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806185649.2476-1-sean.j.christopherson@intel.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to detect if SGX EPC exists above 4g, and if so, where SGX
EPC above 4g ends.  Use the helpers to adjust the device memory range
if SGX EPC exists above 4g.

Note that SGX EPC is currently hardcoded to reside above 4g.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 hw/i386/pc.c              | 10 +++++++++-
 include/hw/i386/sgx-epc.h | 12 ++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 8c8b404799..614d464394 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1882,8 +1882,14 @@ void pc_memory_init(PCMachineState *pcms,
             exit(EXIT_FAILURE);
         }
 
+        if (sgx_epc_above_4g(pcms->sgx_epc)) {
+            machine->device_memory->base = sgx_epc_above_4g_end(pcms->sgx_epc);
+        } else {
+            machine->device_memory->base =
+                0x100000000ULL + pcms->above_4g_mem_size;
+        }
         machine->device_memory->base =
-            ROUND_UP(0x100000000ULL + pcms->above_4g_mem_size, 1 * GiB);
+            ROUND_UP(machine->device_memory->base, 1 * GiB);
 
         if (pcmc->enforce_aligned_dimm) {
             /* size device region assuming 1G page max alignment per slot */
@@ -1962,6 +1968,8 @@ uint64_t pc_pci_hole64_start(void)
         if (!pcmc->broken_reserved_end) {
             hole64_start += memory_region_size(&ms->device_memory->mr);
         }
+    } else if (sgx_epc_above_4g(pcms->sgx_epc)) {
+            hole64_start = sgx_epc_above_4g_end(pcms->sgx_epc);
     } else {
         hole64_start = 0x100000000ULL + pcms->above_4g_mem_size;
     }
diff --git a/include/hw/i386/sgx-epc.h b/include/hw/i386/sgx-epc.h
index 91ed4773e3..136449cd80 100644
--- a/include/hw/i386/sgx-epc.h
+++ b/include/hw/i386/sgx-epc.h
@@ -60,4 +60,16 @@ extern int sgx_epc_enabled;
 void pc_machine_init_sgx_epc(PCMachineState *pcms);
 int sgx_epc_get_section(int section_nr, uint64_t *addr, uint64_t *size);
 
+static inline bool sgx_epc_above_4g(SGXEPCState *sgx_epc)
+{
+    return sgx_epc != NULL;
+}
+
+static inline uint64_t sgx_epc_above_4g_end(SGXEPCState *sgx_epc)
+{
+    assert(sgx_epc != NULL && sgx_epc->base >= 0x100000000ULL);
+
+    return sgx_epc->base + sgx_epc->size;
+}
+
 #endif
-- 
2.22.0

