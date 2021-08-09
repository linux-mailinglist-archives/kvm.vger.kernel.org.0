Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F693E3E7F
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 05:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhHIDzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 23:55:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:23274 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232948AbhHIDzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 23:55:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="300206608"
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="300206608"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 20:54:54 -0700
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="483125279"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.1])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 20:54:49 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v4 5/6] KVM: x86: Support interrupt dispatch in x2APIC mode with APIC-write VM exit
Date:   Mon,  9 Aug 2021 11:29:24 +0800
Message-Id: <20210809032925.3548-6-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210809032925.3548-1-guang.zeng@intel.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since IA x86 platform introduce features of IPI virtualization and
User Interrupts, new behavior applies to the execution of WRMSR ICR
register that causes APIC-write VM exit instead of MSR-write VM exit
in x2APIC mode.

This requires KVM to emulate writing 64-bit value to offset 300H on
the virtual-APIC page(VICR) for guest running in x2APIC mode when
APIC-wrtie VM exit occurs. Prevoisely KVM doesn't consider this
situation as CPU never produce APIC-write VM exit in x2APIC mode before.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/lapic.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ba5a27879f1d..0b0f0ce96679 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2188,7 +2188,14 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	/* hw has done the conditional check and inst decode */
 	offset &= 0xff0;
 
-	kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);
+	if (apic_x2apic_mode(vcpu->arch.apic) && (offset == APIC_ICR)) {
+		u64 icr_val = *((u64 *)(vcpu->arch.apic->regs + offset));
+
+		kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR2, (u32)(icr_val>>32));
+		val = (u32)icr_val;
+	} else {
+		kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);
+	}
 
 	/* TODO: optimize to just emulate side effect w/o one more write */
 	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
-- 
2.25.1

