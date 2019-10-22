Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FEADF94E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbfJVAIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:08:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:64364 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730538AbfJVAIj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:08:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 17:08:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="209551702"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 21 Oct 2019 17:08:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 06/16] x86/cpu: Clear VMX feature flag if VMX is not fully enabled
Date:   Mon, 21 Oct 2019 17:08:36 -0700
Message-Id: <20191022000836.1907-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191021234632.32363-1-sean.j.christopherson@intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the IA32_FEATURE_CONTROL MSR is guaranteed to be configured and
locked, clear the VMX capability flag if the IA32_FEATURE_CONTROL MSR is
not supported or if BIOS disabled VMX, i.e. locked IA32_FEATURE_CONTROL
and did not set the appropriate VMX enable bit.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/feature_control.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/feature_control.c b/arch/x86/kernel/cpu/feature_control.c
index 57b928e64cf5..74c76159a046 100644
--- a/arch/x86/kernel/cpu/feature_control.c
+++ b/arch/x86/kernel/cpu/feature_control.c
@@ -7,13 +7,19 @@
 
 void init_feature_control_msr(struct cpuinfo_x86 *c)
 {
+	bool tboot = tboot_enabled();
 	u64 msr;
 
-	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr))
+	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr)) {
+		if (cpu_has(c, X86_FEATURE_VMX)) {
+			pr_err_once("x86/cpu: VMX disabled, IA32_FEATURE_CONTROL MSR unsupported\n");
+			clear_cpu_cap(c, X86_FEATURE_VMX);
+		}
 		return;
+	}
 
 	if (msr & FEATURE_CONTROL_LOCKED)
-		return;
+		goto update_caps;
 
 	/*
 	 * Ignore whatever value BIOS left in the MSR to avoid enabling random
@@ -23,8 +29,19 @@ void init_feature_control_msr(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_VMX)) {
 		msr |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
-		if (tboot_enabled())
+		if (tboot)
 			msr |= FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX;
 	}
 	wrmsrl(MSR_IA32_FEATURE_CONTROL, msr);
+
+update_caps:
+	if (!cpu_has(c, X86_FEATURE_VMX))
+		return;
+
+	if ((tboot && !(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX)) ||
+	    (!tboot && !(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX))) {
+		pr_err_once("x86/cpu: VMX disabled by BIOS (TXT %s)\n",
+			    tboot ? "enabled" : "disabled");
+		clear_cpu_cap(c, X86_FEATURE_VMX);
+	}
 }
-- 
2.22.0

