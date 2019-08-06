Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC6F83914
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 20:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfHFS5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 14:57:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:40914 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfHFS5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 14:57:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 11:56:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="176715080"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 06 Aug 2019 11:56:59 -0700
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
Subject: [RFC PATCH 06/20] i386: Add SGX CPUID leaf FEAT_SGX_12_1_EAX
Date:   Tue,  6 Aug 2019 11:56:35 -0700
Message-Id: <20190806185649.2476-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806185649.2476-1-sean.j.christopherson@intel.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID leaf 12_1_EAX is an Intel-defined feature bits leaf enumerating
the platform's SGX capabilities that may be utilized by an enclave, e.g.
whether or not an enclave can gain access to the provision key.
Currently there are six capabilities:

  - INIT: set when the enclave has has been initialized by EINIT.  Cannot
          be set by software, i.e. forced to zero in CPUID.
  - DEBUG: permits a debugger to read/write into the enclave.
  - MODE64BIT: the enclave runs in 64-bit mode
  - PROVISIONKEY: grants has access to the provision key
  - EINITTOKENKEY: grants access to the EINIT token key, i.e. the
                   enclave can generate EINIT tokens
  - KSS: Key Separation and Sharing enabled for the enclave.

Note that the entirety of CPUID.0x12.0x1, i.e. all registers, enumerates
the allowed ATTRIBUTES (128 bits), but only bits 31:0 are directly
exposed to the user (via FEAT_12_1_EAX).  Bits 63:32 are currently all
reserved and bits 127:64 correspond to the allowed XSAVE Feature Request
Mask, which is calculated based on other CPU features, e.g. XSAVE, MPX,
AVX, etc... and is not exposed to the user.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 target/i386/cpu.c | 20 ++++++++++++++++++++
 target/i386/cpu.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e954eca4dd..e3dd76d3ba 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -776,6 +776,7 @@ static void x86_cpu_vendor_words2str(char *dst, uint32_t vendor1,
           /* missing:
           CPUID_XSAVE_XSAVEC, CPUID_XSAVE_XSAVES */
 #define TCG_SGX_12_0_EAX_FEATURES 0
+#define TCG_SGX_12_1_EAX_FEATURES 0
 
 typedef enum FeatureWordType {
    CPUID_FEATURE_WORD,
@@ -1244,6 +1245,25 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         },
         .tcg_features = TCG_SGX_12_0_EAX_FEATURES,
     },
+    [FEAT_SGX_12_1_EAX] = {
+        .type = CPUID_FEATURE_WORD,
+        .feat_names = {
+            NULL /* sgx-init */, "sgx-debug", "sgx-mode64", NULL,
+            "sgx-provisionkey", "sgx-tokenkey", NULL, "sgx-kss",
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+        },
+        .cpuid = {
+            .eax = 0x12,
+            .needs_ecx = true, .ecx = 1,
+            .reg = R_EAX,
+        },
+        .tcg_features = TCG_SGX_12_1_EAX_FEATURES,
+    },
 };
 
 typedef struct X86RegisterInfo32 {
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6803b1b41d..fe4660effa 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -507,6 +507,7 @@ typedef enum FeatureWord {
     FEAT_ARCH_CAPABILITIES,
     FEAT_CORE_CAPABILITY,
     FEAT_SGX_12_0_EAX,  /* CPUID[EAX=0x12,ECX=0].EAX (SGX) */
+    FEAT_SGX_12_1_EAX,  /* CPUID[EAX=0x12,ECX=1].EAX (SGX ATTRIBUTES[31:0]) */
     FEATURE_WORDS,
 } FeatureWord;
 
-- 
2.22.0

