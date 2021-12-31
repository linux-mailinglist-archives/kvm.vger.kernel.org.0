Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193BA48247E
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 15:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhLaO7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Dec 2021 09:59:41 -0500
Received: from mga12.intel.com ([192.55.52.136]:41074 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhLaO7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Dec 2021 09:59:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640962772; x=1672498772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=613t3uRkyd2KPwLGDQ6MS1aekZdhOm2qmRirEa3kN+A=;
  b=baPQ93eZUAiC33QSH9T6LjI0n7rAuubKU0FQzyavTxaq0nLUgXj6Du+/
   Vx+XLnCy3ixrDfX/wxOcNGPm/R1Q1zM6wqmJ2BEwGKpvd86KfGXq712N5
   sFnUkrA0okeAH7GXVvxVickCKGjP5dPBOAkPiVEUpk96DG0PozB2L0cUH
   zj1N2RF5JIZnF+ds8wYZ1uQHVa0WQuN1aUxcMvGlpqegaqgL7uiX//2N4
   5Tt4mnzP7fgPR9cEywhtYlKzTNNc3SlRKYLO4xeWQ0JM1l3mPcpGa5N4W
   jnD4mWHmywkdc3AT3ekv9HPNVuhzZAwULNWxmNMRfPWo36bELkfpbwWDP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="221815013"
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="221815013"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="524758492"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:26 -0800
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
Subject: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when APIC ID is changed
Date:   Fri, 31 Dec 2021 22:28:48 +0800
Message-Id: <20211231142849.611-8-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211231142849.611-1-guang.zeng@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In xAPIC mode, guest is allowed to modify APIC ID at runtime.
If IPI virtualization is enabled, corresponding entry in
PID-pointer table need change accordingly.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            |  7 +++++--
 arch/x86/kvm/vmx/vmx.c          | 12 ++++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2164b9f4c7b0..753bf2a7cebc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1493,6 +1493,7 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	void (*update_ipiv_pid_entry)(struct kvm_vcpu *vcpu, u8 old_id, u8 new_id);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3ce7142ba00e..83c2c7594bcd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2007,9 +2007,12 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 
 	switch (reg) {
 	case APIC_ID:		/* Local APIC ID */
-		if (!apic_x2apic_mode(apic))
+		if (!apic_x2apic_mode(apic)) {
+			u8 old_id = kvm_lapic_get_reg(apic, APIC_ID) >> 24;
+
 			kvm_apic_set_xapic_id(apic, val >> 24);
-		else
+			kvm_x86_ops.update_ipiv_pid_entry(apic->vcpu, old_id, val >> 24);
+		} else
 			ret = 1;
 		break;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2e65464d6dee..f21ce15c5eb8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7633,6 +7633,17 @@ static void vmx_vm_destroy(struct kvm *kvm)
 		free_pages((unsigned long)kvm_vmx->pid_table, MAX_PID_TABLE_ORDER);
 }
 
+static void vmx_update_ipiv_pid_entry(struct kvm_vcpu *vcpu, u8 old_id, u8 new_id)
+{
+	if (enable_ipiv && kvm_vcpu_apicv_active(vcpu)) {
+		u64 *pid_table = to_kvm_vmx(vcpu->kvm)->pid_table;
+
+		WRITE_ONCE(pid_table[old_id], 0);
+		WRITE_ONCE(pid_table[new_id], __pa(&to_vmx(vcpu)->pi_desc) |
+				PID_TABLE_ENTRY_VALID);
+	}
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -7770,6 +7781,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+	.update_ipiv_pid_entry = vmx_update_ipiv_pid_entry,
 };
 
 static __init void vmx_setup_user_return_msrs(void)
-- 
2.27.0

