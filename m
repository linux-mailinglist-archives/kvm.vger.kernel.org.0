Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349CDDF950
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbfJVAIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:08:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:26973 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730536AbfJVAIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:08:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 17:08:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="209502717"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 21 Oct 2019 17:08:42 -0700
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
Subject: [PATCH v2 07/16] KVM: VMX: Use VMX feature flag to query BIOS enabling
Date:   Mon, 21 Oct 2019 17:08:38 -0700
Message-Id: <20191022000838.1996-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191021234632.32363-1-sean.j.christopherson@intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace KVM's manual checks on IA32_FEATURE_CONTROL with a query on the
boot CPU's VMX feature flag.  The VMX flag is now cleared during boot if
VMX isn't fully enabled via IA32_FEATURE_CONTROL, including the case
where IA32_FEATURE_CONTROL isn't supported.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 23c9e4b91b31..510f8a778fca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2189,31 +2189,7 @@ static __init int cpu_has_kvm_support(void)
 
 static __init int vmx_disabled_by_bios(void)
 {
-	u64 msr;
-
-	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
-
-	if (WARN_ON_ONCE(!(msr & FEATURE_CONTROL_LOCKED)))
-		return 1;
-
-	/* launched w/ TXT and VMX disabled */
-	if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX) &&
-	    tboot_enabled())
-		return 1;
-	/* launched w/o TXT and VMX only enabled w/ TXT */
-	if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX) &&
-	    (msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX) &&
-	    !tboot_enabled()) {
-		pr_warn("kvm: disable TXT in the BIOS or "
-			"activate TXT before enabling KVM\n");
-		return 1;
-	}
-	/* launched w/o TXT and VMX disabled */
-	if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX) &&
-	    !tboot_enabled())
-		return 1;
-
-	return 0;
+	return !boot_cpu_has(X86_FEATURE_VMX);
 }
 
 static void kvm_cpu_vmxon(u64 addr)
-- 
2.22.0

