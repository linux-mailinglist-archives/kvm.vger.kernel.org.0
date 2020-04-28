Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA48A1BD07B
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 01:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgD1XLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 19:11:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:60595 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgD1XLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 19:11:37 -0400
IronPort-SDR: Hd3PdiTVBm+X3UQ/cJF4c/rUf2ulRJCpcLpVKNeJ/NpSvKLNWpChg7enalnzH0Rls+hkif21bj
 GgH/Shzkh3Aw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 16:11:36 -0700
IronPort-SDR: Lumyx9Z75N97somQ64mE5rxQtSYZcjdtECX5M/FMACPmubNrqJl0g6KgB/HVZEc2AaIu2lj+IH
 ri67blsxjk5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="294005594"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2020 16:11:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: msr: Don't test bits 63:32 of SYSENTER MSRs on 32-bit builds
Date:   Tue, 28 Apr 2020 16:11:35 -0700
Message-Id: <20200428231135.12903-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Squish the "address" stuffed into SYSENTER_EIP/ESP into an unsigned long
so as to drop bits 63:32 on 32-bit builds.  VMX diverges from bare metal
in the sense that the associated VMCS fields are natural width fields,
whereas the actual MSRs hold 64-bit values, even on CPUs that don't
support 64-bit mode.  This causes the tests to fail if bits 63:32 are
non-zero and a VM-Exit/VM-Enter occurs on and/or between WRMSR/RDMSR,
e.g. when running the tests in L1 or deeper.

Don't bother trying to actually test that bits 63:32 are dropped, the
behavior depends on the (virtual) CPU capabilities, not the build, and
the behavior is specific to VMX as both SVM and bare metal preserve the
full 64-bit values.  And because practically no one cares about 32-bit
KVM, let alone an obscure architectural quirk that doesn't affect real
world kernels.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/msr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index de2cb6d..f7539c3 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -16,6 +16,7 @@ struct msr_info {
 
 
 #define addr_64 0x0000123456789abcULL
+#define addr_ul (unsigned long)addr_64
 
 struct msr_info msr_info[] =
 {
@@ -23,10 +24,10 @@ struct msr_info msr_info[] =
       .val_pairs = {{ .valid = 1, .value = 0x1234, .expected = 0x1234}}
     },
     { .index = 0x00000175, .name = "MSR_IA32_SYSENTER_ESP",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+      .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
     },
     { .index = 0x00000176, .name = "IA32_SYSENTER_EIP",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+      .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
     },
     { .index = 0x000001a0, .name = "MSR_IA32_MISC_ENABLE",
       // reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-- 
2.26.0

