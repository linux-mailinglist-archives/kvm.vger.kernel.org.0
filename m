Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C99614331
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 03:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKACZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 22:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiKACZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 22:25:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311E4101E0;
        Mon, 31 Oct 2022 19:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667269518; x=1698805518;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=93hyB3s3jYTeEmmwLhdxxyKJFPpYXYsilpRvm7mmI20=;
  b=PJKRY7sSdZQ7TQUo7Z0bJ55zYi0xGTFntRRy80gl84WQwVXurjTVqd8H
   LyC5ByCsMiPAW1hoMRADBFqJprpmuOWPPleAIuSsClR4BeuWydJXXiSrn
   u++hZGy7ElP/cnk+szlZZUN8uUzwM3J5oniO4EV6shALJLRy7l0APHKEG
   7cqG9/ASEcSgQLDBHW/Ddhc6Hdl/Vv5i2zCuapH8doVgyRFlRAM2LVg+T
   n5k1jE26WXQCVMGXObzh1kEDiIOBJD7oteRV+KMiwLbGCNoamr0kZvoGX
   Wq6eFemH0Y1dyhj8Unpzb4b5PgPmxhLiVc0LjZPZTyYQKMRM0DPJA20Lv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="371129080"
X-IronPort-AV: E=Sophos;i="5.95,229,1661842800"; 
   d="scan'208";a="371129080"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 19:25:17 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="739179521"
X-IronPort-AV: E=Sophos;i="5.95,229,1661842800"; 
   d="scan'208";a="739179521"
Received: from aellsw1-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.105.29])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 19:25:15 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, jarkko@kernel.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: [RESEND PATCH v3] KVM: VMX: Allow exposing EDECCSSA user leaf function to KVM guest
Date:   Tue,  1 Nov 2022 15:24:22 +1300
Message-Id: <20221101022422.858944-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new Asynchronous Exit (AEX) notification mechanism (AEX-notify)
allows one enclave to receive a notification in the ERESUME after the
enclave exit due to an AEX.  EDECCSSA is a new SGX user leaf function
(ENCLU[EDECCSSA]) to facilitate the AEX notification handling.  The new
EDECCSSA is enumerated via CPUID(EAX=0x12,ECX=0x0):EAX[11].

Besides Allowing reporting the new AEX-notify attribute to KVM guests,
also allow reporting the new EDECCSSA user leaf function to KVM guests
so the guest can fully utilize the AEX-notify mechanism.

Similar to existing X86_FEATURE_SGX1 and X86_FEATURE_SGX2, introduce a
new scattered X86_FEATURE_SGX_EDECCSSA bit for the new EDECCSSA, and
report it in KVM's supported CPUIDs.

Note, no additional KVM enabling is required to allow the guest to use
EDECCSSA.  It's impossible to trap ENCLU (without completely preventing
the guest from using SGX).  Advertise EDECCSSA as supported purely so
that userspace doesn't need to special case EDECCSSA, i.e. doesn't need
to manually check host CPUID.

The inability to trap ENCLU also means that KVM can't prevent the guest
from using EDECCSSA, but that virtualization hole is benign as far as
KVM is concerned.  EDECCSSA is simply a fancy way to modify internal
enclave state.

More background about how do AEX-notify and EDECCSSA work:

SGX maintains a Current State Save Area Frame (CSSA) for each enclave
thread.  When AEX happens, the enclave thread context is saved to the
CSSA and the CSSA is increased by 1.  For a normal ERESUME which doesn't
deliver AEX notification, it restores the saved thread context from the
previously saved SSA and decreases the CSSA.  If AEX-notify is enabled
for one enclave, the ERESUME acts differently.  Instead of restoring the
saved thread context and decreasing the CSSA, it acts like EENTER which
doesn't decrease the CSSA but establishes a clean slate thread context
using the CSSA for the enclave to handle the notification.  After some
handling, the enclave must discard the "new-established" SSA and switch
back to the previously saved SSA (upon AEX).  Otherwise, the enclave
will run out of SSA space upon further AEXs and eventually fail to run.

To solve this problem, the new EDECCSSA essentially decreases the CSSA.
It can be used by the enclave notification handler to switch back to the
previous saved SSA when needed, i.e. after it handles the notification.

Cc: Haitao Huang <haitao.huang@linux.intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

This is just a RESEND (with adding "Cc: Haitao" explicitly).

Btw, Haitao said there's use case using EDECCSSA w/o AEX-notify:

https://lore.kernel.org/lkml/00b07459-5512-b00b-636b-f35845ec369f@intel.com/T/#me559bfb5be8970b993fc7119ca95b257dc7a8901

So this one can actually be merged independently.

v2 -> v3:

 - Updated subsystem tag to "KVM: VMX:" (Sean).
 - Updated changelog (Sean).
 - Added Sean and Jarkko's Acks.

---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 arch/x86/kvm/reverse_cpuid.h       | 3 +++
 5 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b71f4f2ecdd5..d0d7edd0d641 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -304,6 +304,7 @@
 #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
 #define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
+#define X86_FEATURE_SGX_EDECCSSA	(11*32+18) /* "" SGX EDECCSSA user leaf function */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index c881bcafba7d..d95221117129 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -75,6 +75,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_SGX_LC,			X86_FEATURE_SGX	      },
 	{ X86_FEATURE_SGX1,			X86_FEATURE_SGX       },
 	{ X86_FEATURE_SGX2,			X86_FEATURE_SGX1      },
+	{ X86_FEATURE_SGX_EDECCSSA,		X86_FEATURE_SGX1      },
 	{ X86_FEATURE_XFD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_XFD,			X86_FEATURE_XGETBV1   },
 	{ X86_FEATURE_AMX_TILE,			X86_FEATURE_XFD       },
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index fc01f81f6e2a..f53944fb8f7f 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -40,6 +40,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PER_THREAD_MBA,	CPUID_ECX,  0, 0x00000010, 3 },
 	{ X86_FEATURE_SGX1,		CPUID_EAX,  0, 0x00000012, 0 },
 	{ X86_FEATURE_SGX2,		CPUID_EAX,  1, 0x00000012, 0 },
+	{ X86_FEATURE_SGX_EDECCSSA,	CPUID_EAX, 11, 0x00000012, 0 },
 	{ X86_FEATURE_HW_PSTATE,	CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7065462378e2..15c1c5bbb10d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -665,7 +665,7 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init_scattered(CPUID_12_EAX,
-		SF(SGX1) | SF(SGX2)
+		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
 	);
 
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473d0184..4e5b8444f161 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -23,6 +23,7 @@ enum kvm_only_cpuid_leafs {
 /* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
 #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
+#define KVM_X86_FEATURE_SGX_EDECCSSA	KVM_X86_FEATURE(CPUID_12_EAX, 11)
 
 struct cpuid_reg {
 	u32 function;
@@ -78,6 +79,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
 		return KVM_X86_FEATURE_SGX1;
 	else if (x86_feature == X86_FEATURE_SGX2)
 		return KVM_X86_FEATURE_SGX2;
+	else if (x86_feature == X86_FEATURE_SGX_EDECCSSA)
+		return KVM_X86_FEATURE_SGX_EDECCSSA;
 
 	return x86_feature;
 }

base-commit: 7b72c823ddf8aaaec4e9fb28e6fbe4d511e7dad1
-- 
2.37.3

