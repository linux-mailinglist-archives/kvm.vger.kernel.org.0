Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2048F4CD047
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 09:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbiCDIlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 03:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbiCDIko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 03:40:44 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D217119D762;
        Fri,  4 Mar 2022 00:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646383146; x=1677919146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=q8WhDt1fJAVdhqFFxJcC9dsIft2QvOtRyhyaF+jsgXI=;
  b=IfSg17M5IUAlyjDR3QrP9Izyp6HXVXGJqg+jnw9eTAr81SyeRniYxfsz
   cYupe5BmtFuKjs6Y4A4i6YgCi271CIFYnj9NKfRbrsyhXeXB6+6DY/eLg
   2eNJ2ESkQl3QMt+lZjelDwsqMtZd1CYZn2HrmhatYCoZI9UIaodzZlTCs
   7dz367QJlMpQV+sgp3eYU8LJg9V0gjNHKHavaLDXsoB94f64KP01o84dP
   2HuGH/GoU2N6gsvMkEEJEWxaE3cN/BUUXG6hrHL/eoipR14tCozGvz5ur
   ZiFfVRnnV/ByLkNq6d3zE+76uL5mRgwGa2uhqxU0Mf3jdm3UjihpZkAKd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="234537716"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="234537716"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:34 -0800
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="552141488"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:28 -0800
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
Subject: [PATCH v7 5/8] KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode
Date:   Fri,  4 Mar 2022 16:07:22 +0800
Message-Id: <20220304080725.18135-6-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304080725.18135-1-guang.zeng@intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming Intel CPUs will support virtual x2APIC MSR writes to the vICR,
i.e. will trap and generate an APIC-write VM-Exit instead of intercepting
the WRMSR.  Add support for handling "nodecode" x2APIC writes, which
were previously impossible.

Note, x2APIC MSR writes are 64 bits wide.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/lapic.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 629c116b0d3e..22929b5b3f9b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -67,6 +67,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
 #define LAPIC_TIMER_ADVANCE_NS_MAX     5000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 
 static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
 {
@@ -2227,10 +2228,25 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
-	u32 val = kvm_lapic_get_reg(vcpu->arch.apic, offset);
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u64 val;
+
+	if (apic_x2apic_mode(apic)) {
+		/*
+		 * When guest APIC is in x2APIC mode and IPI virtualization
+		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
+		 * on Intel hardware. Other offsets are not possible.
+		 */
+		if (WARN_ON_ONCE(offset != APIC_ICR))
+			return;
 
-	/* TODO: optimize to just emulate side effect w/o one more write */
-	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
+		kvm_lapic_msr_read(apic, offset, &val);
+		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
+	} else {
+		val = kvm_lapic_get_reg(apic, offset);
+		/* TODO: optimize to just emulate side effect w/o one more write */
+		kvm_lapic_reg_write(apic, offset, (u32)val);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
 
-- 
2.27.0

