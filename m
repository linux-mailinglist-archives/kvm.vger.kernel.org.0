Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06AF83916
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 20:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfHFS5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 14:57:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:40914 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfHFS5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 14:57:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 11:56:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="176715072"
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
Subject: [RFC PATCH 04/20] i386: Add primary SGX CPUID and MSR defines
Date:   Tue,  6 Aug 2019 11:56:33 -0700
Message-Id: <20190806185649.2476-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806185649.2476-1-sean.j.christopherson@intel.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CPUID defines for SGX and SGX Launch Control (LC), as well as
defines for their associated FEATURE_CONTROL MSR bits.  Define the
Launch Enclave Public Key Hash MSRs (LE Hash MSRs), which exist
when SGX LC is present (in CPUID), and are writable when SGX LC is
enabled (in FEATURE_CONTROL).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 target/i386/cpu.c |  4 ++--
 target/i386/cpu.h | 10 ++++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 19751e37a7..f529fb0dc8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1041,7 +1041,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     [FEAT_7_0_EBX] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
-            "fsgsbase", "tsc-adjust", NULL, "bmi1",
+            "fsgsbase", "tsc-adjust", "sgx", "bmi1",
             "hle", "avx2", NULL, "smep",
             "bmi2", "erms", "invpcid", "rtm",
             NULL, NULL, "mpx", NULL,
@@ -1067,7 +1067,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "la57", NULL, NULL, NULL,
             NULL, NULL, "rdpid", NULL,
             NULL, "cldemote", NULL, "movdiri",
-            "movdir64b", NULL, NULL, NULL,
+            "movdir64b", NULL, "sgxlc", NULL,
         },
         .cpuid = {
             .eax = 7,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 8b3dc5533e..62adb2e0d0 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -350,9 +350,17 @@ typedef enum X86Seg {
 #define MSR_IA32_TSCDEADLINE            0x6e0
 
 #define FEATURE_CONTROL_LOCKED                    (1<<0)
+#define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX  (1<<1)
 #define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX (1<<2)
+#define FEATURE_CONTROL_SGX_LC                    (1<<17)
+#define FEATURE_CONTROL_SGX                       (1<<18)
 #define FEATURE_CONTROL_LMCE                      (1<<20)
 
+#define MSR_IA32_SGXLEPUBKEYHASH0       0x8c
+#define MSR_IA32_SGXLEPUBKEYHASH1       0x8d
+#define MSR_IA32_SGXLEPUBKEYHASH2       0x8e
+#define MSR_IA32_SGXLEPUBKEYHASH3       0x8f
+
 #define MSR_P6_PERFCTR0                 0xc1
 
 #define MSR_IA32_SMBASE                 0x9e
@@ -641,6 +649,7 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
 #define CPUID_SVM_PFTHRESHOLD  (1U << 12)
 
 #define CPUID_7_0_EBX_FSGSBASE (1U << 0)
+#define CPUID_7_0_EBX_SGX      (1U << 2)
 #define CPUID_7_0_EBX_BMI1     (1U << 3)
 #define CPUID_7_0_EBX_HLE      (1U << 4)
 #define CPUID_7_0_EBX_AVX2     (1U << 5)
@@ -684,6 +693,7 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
 #define CPUID_7_0_ECX_CLDEMOTE (1U << 25)  /* CLDEMOTE Instruction */
 #define CPUID_7_0_ECX_MOVDIRI  (1U << 27)  /* MOVDIRI Instruction */
 #define CPUID_7_0_ECX_MOVDIR64B (1U << 28) /* MOVDIR64B Instruction */
+#define CPUID_7_0_ECX_SGX_LC   (1U << 30)
 
 #define CPUID_7_0_EDX_AVX512_4VNNIW (1U << 2) /* AVX512 Neural Network Instructions */
 #define CPUID_7_0_EDX_AVX512_4FMAPS (1U << 3) /* AVX512 Multiply Accumulation Single Precision */
-- 
2.22.0

