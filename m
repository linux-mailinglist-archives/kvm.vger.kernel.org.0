Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982EC30BA83
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 10:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhBBJCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 04:02:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:41964 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232785AbhBBJCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 04:02:09 -0500
IronPort-SDR: Gi/0KOgBT81A6QeDqVeUtEJBx9f0U9WCjMOC2zcZAw361DxcykAuKmhE6bYNJZebrGN7FDXk1M
 mcJgmb66rTcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167929244"
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="167929244"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:01:28 -0800
IronPort-SDR: wCCmJuRcMSIFP4GZGLCuJIrs4XqI/nOgmCW9eTjMfxBsemJmOcWzMtSnSV3NbeaCKltWZLiNNm
 QzRPiGISwfQA==
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="479491938"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:01:25 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: X86: Add support for the emulation of DR6_BUS_LOCK bit
Date:   Tue,  2 Feb 2021 17:04:32 +0800
Message-Id: <20210202090433.13441-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202090433.13441-1-chenyi.qiang@intel.com>
References: <20210202090433.13441-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bus lock debug exception introduces a new bit DR6_BUS_LOCK (bit 11 of
DR6) to indicate that bus lock #DB exception is generated. The set/clear
of DR6_BUS_LOCK is similar to the DR6_RTM. The processor clears
DR6_BUS_LOCK when the exception is generated. For all other #DB, the
processor sets this bit to 1. Software #DB handler should set this bit
before returning to the interrupted task.

In VMM, to avoid breaking the CPUs without bus lock #DB exception
support, activate the DR6_BUS_LOCK conditionally in DR6_FIXED_1 bits.
When intercepting the #DB exception caused by bus locks, bit 11 of the
exit qualification is set to identify it. The VMM should emulate the
exception by clearing the bit 11 of the guest DR6.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++--
 arch/x86/kvm/x86.c              | 3 +++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5b80f92a7fde..44d790cff6aa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -196,11 +196,12 @@ enum x86_intercept_stage;
 
 #define KVM_NR_DB_REGS	4
 
+#define DR6_BUS_LOCK   (1 << 11)
 #define DR6_BD		(1 << 13)
 #define DR6_BS		(1 << 14)
 #define DR6_BT		(1 << 15)
 #define DR6_RTM		(1 << 16)
-#define DR6_FIXED_1	0xfffe0ff0
+#define DR6_FIXED_1	0xfffe07f0
 /*
  * DR6_ACTIVE_LOW is actual the result of DR6_FIXED_1 | ACTIVE_LOW_BITS.
  * We can regard all the current FIXED_1 bits as active_low bits even
@@ -209,7 +210,7 @@ enum x86_intercept_stage;
  * At the same time, it can be served as the init/reset value for DR6.
  */
 #define DR6_ACTIVE_LOW	0xffff0ff0
-#define DR6_VOLATILE	0x0001e00f
+#define DR6_VOLATILE	0x0001e80f
 
 #define DR7_BP_EN_MASK	0x000000ff
 #define DR7_GE		(1 << 9)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1946e6710919..e149cb2c921c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1131,6 +1131,9 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_RTM))
 		fixed |= DR6_RTM;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+		fixed |= DR6_BUS_LOCK;
 	return fixed;
 }
 
-- 
2.17.1

