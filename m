Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B42E4FB7BA
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344575AbiDKJj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344529AbiDKJjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:39:22 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585B9403FC;
        Mon, 11 Apr 2022 02:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649669818; x=1681205818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=RSripfRDPX6q0oBFdAW/Me0piSvmrss3ymZMZey5RrI=;
  b=f4xp2pqaPyrSRFvqXgQHk6aICo+JkFu5BB6H6TaO9tScgtag7YwfW7u2
   OU/CUe/nEA/CgKuSflIPxO2utD13OEf5dBYMZxX+0/J0jsPL70OZJCt/L
   ZylIFpx9fgEgPE+a1mQi6RlvHcqOEA5QDoc6y++4S9Hd0ntTfUDyYVV36
   9tl6/M2xoBL/Hrpnk6jwqFGgVJvYi5tXl4IToNbOKd+sqLDe/jTyHMpxI
   Y2VYlwebAWJp1fF4f04RvQziOVhOafEucfJQKqajBzWVzce7QYYgAoSR6
   jnNKCgXfwOLg0AqYV/uJ6iTkX2hPk6tj/biDb3Dw+AFEoeh7XJ7geQUTb
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="259671443"
X-IronPort-AV: E=Sophos;i="5.90,251,1643702400"; 
   d="scan'208";a="259671443"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 02:36:58 -0700
X-IronPort-AV: E=Sophos;i="5.90,251,1643702400"; 
   d="scan'208";a="572050510"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 02:36:52 -0700
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
Subject: [PATCH v8 5/9] KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode
Date:   Mon, 11 Apr 2022 17:04:43 +0800
Message-Id: <20220411090447.5928-6-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220411090447.5928-1-guang.zeng@intel.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 arch/x86/kvm/lapic.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66b0eb0bda94..137c3a2f5180 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -67,6 +67,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
 #define LAPIC_TIMER_ADVANCE_NS_MAX     5000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 
 static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
 {
@@ -2230,10 +2231,27 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
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
+		trace_kvm_apic_write(APIC_ICR, val);
+	} else {
+		val = kvm_lapic_get_reg(apic, offset);
+
+		/* TODO: optimize to just emulate side effect w/o one more write */
+		kvm_lapic_reg_write(apic, offset, (u32)val);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
 
-- 
2.27.0

