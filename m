Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5897B9F54C
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbfH0VlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:41:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:61902 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730866AbfH0Vkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919779"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 14:40:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 14/14] KVM: x86: Add comments to document various emulation types
Date:   Tue, 27 Aug 2019 14:40:40 -0700
Message-Id: <20190827214040.18710-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document the intended usage of each emulation type as each exists to
handle an edge case of one kind or another and can be easily
misinterpreted at first glance.

Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3f524cea20ad..8221e68bbb0c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1308,6 +1308,36 @@ extern u64  kvm_default_tsc_scaling_ratio;
 
 extern u64 kvm_mce_cap_supported;
 
+/*
+ * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
+ *			userspace I/O) to indicate that the emulation context
+ *			should be resued as is, i.e. skip initialization of
+ *			emulation context, instruction fetch and decode.
+ *
+ * EMULTYPE_TRAP_UD - Set when emulating an intercepted #UD from hardware.
+ *		      Indicates that only select instructions (tagged with
+ *		      EmulateOnUD) should be emulated (to minimize the emulator
+ *		      attack surface).  See also EMULTYPE_TRAP_UD_FORCED.
+ *
+ * EMULTYPE_SKIP - Set when emulating solely to skip an instruction, i.e. to
+ *		   decode the instruction length.  For use *only* by
+ *		   kvm_x86_ops->skip_emulated_instruction() implementations.
+ *
+ * EMULTYPE_ALLOW_RETRY - Set when the emulator should resume the guest to
+ *			  retry native execution under certain conditions.
+ *
+ * EMULTYPE_TRAP_UD_FORCED - Set when emulating an intercepted #UD that was
+ *			     triggered by KVM's magic "force emulation" prefix,
+ *			     which is opt in via module param (off by default).
+ *			     Bypasses EmulateOnUD restriction despite emulating
+ *			     due to an intercepted #UD (see EMULTYPE_TRAP_UD).
+ *			     Used to test the full emulator from userspace.
+ *
+ * EMULTYPE_VMWARE_GP - Set when emulating an intercepted #GP for VMware
+ *			backdoor emulation, which is opt in via module param.
+ *			VMware backoor emulation handles select instructions
+ *			and reinjects the #GP for all other cases.
+ */
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
 #define EMULTYPE_SKIP		    (1 << 2)
-- 
2.22.0

