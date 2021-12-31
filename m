Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DC648247C
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 15:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhLaO7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Dec 2021 09:59:30 -0500
Received: from mga06.intel.com ([134.134.136.31]:23761 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231166AbhLaO7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Dec 2021 09:59:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640962760; x=1672498760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=GYYW4VDo4aLjLd+zWJjAaLbWaXT9U1/xExbUlzLY79w=;
  b=j8t/RnGFAgRfEh+USF9E6wnjVRmLRdJEZH72xn+kYjrm2g+nbW5nJh/R
   pN9sGSJftzNDa8LXW4owLtnf1X0sbfmg7a+E+IqT2har0VSPzYdzIkRKD
   BYFuYbmdRWRtGYfscfCN7xizD/f5zwo6hJ6joMuAgDx6ey6gRZMGiy7+A
   xmiX2zfozbFLrGSAH0PcMEOuZ8vagPhBAtmlWonyapM2D1QEtGGH3ZW0o
   T2kgHD8h5XZISWY2em7+rqT8OMg+1qMGbtRxYGra7IGDs8LjTTJ/X1q96
   CIQhgeVUkXput6POvmR69e5sKfmVfDAx+ByhF/YAZT5PVHw5CddwQD7XP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="302569970"
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="302569970"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="524758458"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:14 -0800
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
Subject: [PATCH v5 5/8] KVM: x86: Support interrupt dispatch in x2APIC mode with APIC-write VM exit
Date:   Fri, 31 Dec 2021 22:28:46 +0800
Message-Id: <20211231142849.611-6-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211231142849.611-1-guang.zeng@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In VMX non-root operation, new behavior applies to
virtualize WRMSR to vICR in x2APIC mode. Depending
on settings of the VM-execution controls, CPU would
produce APIC-write VM-exit following the 64-bit value
written to offset 300H on the virtual-APIC page(vICR).
KVM needs to retrieve the value written by CPU and
emulate the vICR write to deliver an interrupt.

Current KVM doesn't consider to handle the 64-bit setting
on vICR in trap-like APIC-write VM-exit. Because using
kvm_lapic_reg_write() to emulate writes to APIC_ICR requires
the APIC_ICR2 is already programmed correctly. But in the
above APIC-write VM-exit, CPU writes the whole 64 bits to
APIC_ICR rather than program higher 32 bits and lower 32
bits to APIC_ICR2 and APIC_ICR respectively. So, KVM needs
to retrieve the whole 64-bit value and program higher 32 bits
to APIC_ICR2 first.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/lapic.c | 12 +++++++++---
 arch/x86/kvm/lapic.h |  5 +++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f206fc35deff..3ce7142ba00e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2186,15 +2186,21 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
-	u32 val = 0;
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u64 val = 0;
 
 	/* hw has done the conditional check and inst decode */
 	offset &= 0xff0;
 
-	kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);
+	/* exception dealing with 64bit data on vICR in x2apic mode */
+	if ((offset == APIC_ICR) && apic_x2apic_mode(apic)) {
+		val = kvm_lapic_get_reg64(apic, offset);
+		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(val>>32));
+	} else
+		kvm_lapic_reg_read(apic, offset, 4, &val);
 
 	/* TODO: optimize to just emulate side effect w/o one more write */
-	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
+	kvm_lapic_reg_write(apic, offset, (u32)val);
 }
 EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2b44e533fc8d..91864e401a64 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -158,6 +158,11 @@ static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
 	return *((u32 *) (apic->regs + reg_off));
 }
 
+static inline u64 kvm_lapic_get_reg64(struct kvm_lapic *apic, int reg_off)
+{
+	return *((u64 *) (apic->regs + reg_off));
+}
+
 static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
 {
 	*((u32 *) (regs + reg_off)) = val;
-- 
2.27.0

