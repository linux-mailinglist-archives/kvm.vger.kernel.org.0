Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BB7212B71
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 19:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgGBRpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 13:45:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56779 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726754AbgGBRpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 13:45:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593711910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2+YKOFsMFqgKEAlgmAfFeYOf9HVs9QXIdHNLGDvzQ5Y=;
        b=dBELHSjb44DN1U+uAWX0eYnf7/7kAupfoZuv1SYt3qItdWn8DrfEq9m9U2pqB2rT0SAtRM
        y/Qjwf3a0cuUzaNnFby0QRO1o7maohSYiF5+JEDQCynmpi9CTfJaVuFe3fKX6b2isevSPy
        gCo6k+pLWgjI2MRz8vZlnx85fP1xJOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-Dorxu1FDMIOrZb7rmwInbg-1; Thu, 02 Jul 2020 13:45:08 -0400
X-MC-Unique: Dorxu1FDMIOrZb7rmwInbg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 950A88015FE;
        Thu,  2 Jul 2020 17:45:06 +0000 (UTC)
Received: from starship.redhat.com (unknown [10.35.206.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1CA4619C1;
        Thu,  2 Jul 2020 17:44:56 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
Date:   Thu,  2 Jul 2020 20:44:55 +0300
Message-Id: <20200702174455.282252-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are few cases when this function was creating a bogus #GP condition,
for example case when and AMD host supports STIBP but doesn't support SSBD.

Follow the rules for AMD and Intel strictly instead.

AMD #GP rules for IA32_SPEC_CTRL can be found here:
https://bugzilla.kernel.org/show_bug.cgi?id=199889

Fixes: 6441fa6178f5 ("KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 57 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..a6bed4670b7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10670,27 +10670,54 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
-u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
+
+static u64 kvm_spec_ctrl_valid_bits_host(void)
+{
+	uint64_t bits = 0;
+
+	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
+		bits |= SPEC_CTRL_IBRS;
+	if (boot_cpu_has(X86_FEATURE_INTEL_STIBP))
+		bits |= SPEC_CTRL_STIBP;
+	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
+		bits |= SPEC_CTRL_SSBD;
+
+	if (boot_cpu_has(X86_FEATURE_AMD_IBRS) || boot_cpu_has(X86_FEATURE_AMD_STIBP))
+		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS;
+
+	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS | SPEC_CTRL_SSBD;
+
+	return bits;
+}
+
+static u64 kvm_spec_ctrl_valid_bits_guest(struct kvm_vcpu *vcpu)
 {
-	uint64_t bits = SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD;
+	uint64_t bits = 0;
 
-	/* The STIBP bit doesn't fault even if it's not advertised */
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
-		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
-	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
-	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
-		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		bits |= SPEC_CTRL_IBRS;
+	if (guest_cpuid_has(vcpu, X86_FEATURE_INTEL_STIBP))
+		bits |= SPEC_CTRL_STIBP;
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD))
+		bits |= SPEC_CTRL_SSBD;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
-		bits &= ~SPEC_CTRL_SSBD;
-	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
-	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
-		bits &= ~SPEC_CTRL_SSBD;
+	if (guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
+			guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP))
+		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS;
+	if (guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
+		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS | SPEC_CTRL_SSBD;
 
 	return bits;
 }
+
+u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
+{
+	return kvm_spec_ctrl_valid_bits_host() &
+	       kvm_spec_ctrl_valid_bits_guest(vcpu);
+}
+
+
 EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
-- 
2.25.4

