Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2583917
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 20:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfHFS5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 14:57:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:40919 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfHFS5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 14:57:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 11:57:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="176715099"
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
Subject: [RFC PATCH 12/20] i386: kvm: Add support for exposing PROVISIONKEY to guest
Date:   Tue,  6 Aug 2019 11:56:41 -0700
Message-Id: <20190806185649.2476-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806185649.2476-1-sean.j.christopherson@intel.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM (and the Linux kernel in general) restricts access to a subset of
enclave attributes to provide additional security for an uncompromised
kernel, e.g. to prevent malware from using the PROVISIONKEY to ensure
its nodes are running inside a geniune SGX enclave and/or to obtain a
stable fingerprint.  Currently, only the PROVISIONKEY is restricted by
KVM/Linux.

To expose privileged attributes to a KVM guest, QEMU must prove to KVM
that it is allowed to access an attribute by passing KVM an open file
descriptor pointing at the associated SGX attribute file, e.g.
/dev/sgx/provision, using the capability ioctl() KVM_CAP_SGX_ATTRIBUTE.

If requested by the user (via its CPUID bit), attempt to enable guest
access to the PROVISIONKEY.  Do not error out if /dev/sgx/provision is
inaccessible, i.e. treat failure like any other unavailable feature.
Exit immediately if enabling fails as KVM should report support for
PROVISIONKEY via CPUID if and only if it supports KVM_CAP_SGX_ATTRIBUTE.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 target/i386/cpu.c      |  5 ++++-
 target/i386/kvm-stub.c |  5 +++++
 target/i386/kvm.c      | 25 +++++++++++++++++++++++++
 target/i386/kvm_i386.h |  3 +++
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1bb9586230..a951a02baa 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4560,7 +4560,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *ecx |= XSTATE_FP_MASK | XSTATE_SSE_MASK;
 
             /* Access to PROVISIONKEY requires additional credentials. */
-            *eax &= ~(1U << 4);
+            if ((*eax & (1U << 4)) &&
+                !kvm_enable_sgx_provisioning(cs->kvm_state)) {
+                *eax &= ~(1U << 4);
+            }
         }
 #endif
         break;
diff --git a/target/i386/kvm-stub.c b/target/i386/kvm-stub.c
index 872ef7df4c..b4708386b5 100644
--- a/target/i386/kvm-stub.c
+++ b/target/i386/kvm-stub.c
@@ -38,6 +38,11 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
 {
     abort();
 }
+
+bool kvm_enable_sgx_provisioning(void)
+{
+    return false;
+}
 #endif
 
 bool kvm_hv_vpindex_settable(void)
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index e40c4fd673..dcda0bb0e9 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -4111,6 +4111,31 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg)
     }
 }
 
+static bool has_sgx_provisioning;
+
+static bool __kvm_enable_sgx_provisioning(KVMState *s)
+{
+    int fd, ret;
+
+    fd = open("/dev/sgx/provision", O_RDONLY);
+    if (fd < 0) {
+        return false;
+    }
+
+    ret = kvm_vm_enable_cap(s, KVM_CAP_SGX_ATTRIBUTE, 0, fd);
+    if (ret) {
+        error_report("Could not enable SGX PROVISIONKEY: %s", strerror(-ret));
+        exit(1);
+    }
+    close(fd);
+    return true;
+}
+
+bool kvm_enable_sgx_provisioning(KVMState *s)
+{
+    return MEMORIZE(__kvm_enable_sgx_provisioning(s), has_sgx_provisioning);
+}
+
 static bool host_supports_vmx(void)
 {
     uint32_t ecx, unused;
diff --git a/target/i386/kvm_i386.h b/target/i386/kvm_i386.h
index 06fe06bdb3..d9c3018744 100644
--- a/target/i386/kvm_i386.h
+++ b/target/i386/kvm_i386.h
@@ -66,4 +66,7 @@ bool kvm_enable_x2apic(void);
 bool kvm_has_x2apic_api(void);
 
 bool kvm_hv_vpindex_settable(void);
+
+bool kvm_enable_sgx_provisioning(KVMState *s);
+
 #endif
-- 
2.22.0

