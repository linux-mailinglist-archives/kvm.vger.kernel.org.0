Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAD64C40B6
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 09:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238735AbiBYIyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 03:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238770AbiBYIyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 03:54:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2922255BC;
        Fri, 25 Feb 2022 00:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645779216; x=1677315216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=aAScniTQ6hnuqdjEfXh/mJB2BVkSgcocqcMrF3sJiqY=;
  b=bdJGMu/u+y48mUpyesbwHsvLx9TKoFTD9YdKkET/bhixqsbzYlVZDhZu
   rY6vF+M0fxrx78Xd3FwJsucwOvDdyhTLwm1Nd3lfH/k30Vt5LS+OdMoYP
   RHjvkPFxUoZOiScR/I37AhMyrVIAa9Wil6hpMj1PSbX+BCLere7MCoRLc
   SHLdu+TXyarKYHmc2w4E6v+4bj6O+vveX/RU7nfVEmtj8yhWnXJ/7jzdH
   SotZDypo1fPH7GkFLpRNKfv0tvkugzF9hLWKN/RzstSP7zeTdu+VmIaAE
   qQ0X1JkN7Ng2RbMN+IKurfLlNIpUbuSrwF/mOjVV3YxJ6j5Mh35b3GA8M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="277090079"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="277090079"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:36 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549186527"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:30 -0800
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
Subject: [PATCH v6 5/9] KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode
Date:   Fri, 25 Feb 2022 16:22:19 +0800
Message-Id: <20220225082223.18288-6-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220225082223.18288-1-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/lapic.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 629c116b0d3e..e4bcdab1fac0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -67,6 +67,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
 #define LAPIC_TIMER_ADVANCE_NS_MAX     5000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 
 static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
 {
@@ -2227,10 +2228,28 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
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
+		if (val & APIC_ICR_BUSY)
+			kvm_x2apic_icr_write(apic, val);
+		else
+			kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
+	} else {
+		val = kvm_lapic_get_reg(apic, offset);
+		/* TODO: optimize to just emulate side effect w/o one more write */
+		kvm_lapic_reg_write(apic, offset, (u32)val);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
 
-- 
2.27.0

