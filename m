Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE82C2E7D6D
	for <lists+kvm@lfdr.de>; Thu, 31 Dec 2020 01:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgLaA2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 19:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgLaA2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 19:28:49 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8A4C0617A3
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:37 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id g67so31427819ybb.9
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=s8lcQSUVfrrCRH8wEFilf3d3qdZktxl5kDJ/wTn8kL0=;
        b=lkTEfxWLoLxmVAHlOKbFzeOt+Zji4NnJB5lgOs999WZtXA/WiOFTK+p7N5zOHCDGTO
         MGq0t5bfLRD5C1j7VQ5ePiin2GQE7c2sEe0Re31VpOReBXj0AAPpNpghlgkIkTMxjGBs
         j6+JqX3JmOMGTDkduoTKDnSvaIRbU3OqwEtG5+mVa9Y86Q10xmJ+aFl/3zlcZLX2uBIN
         gWMj6oiYyZfAdvHU5lfCaZTOwkn/jGnLU0wJz0tNBJiHFl9PPf/jRM9t2wcjEWfa9iv4
         Gm7F0/8jUoNkhSVXUW+3yC9RJBAVY0U4pCGOfFD0XuhHEIDczXyY8tY8TEXE2/y1ya47
         +UBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=s8lcQSUVfrrCRH8wEFilf3d3qdZktxl5kDJ/wTn8kL0=;
        b=PE+UVSidoVJUCa0jf2so+lN8bJwkUy0R3dZFQVM3vJnNG1l58qTB2uilgJLwESqxxu
         0akmAtYJu89gQIR0l/+BsO7sYN7MROqraXf27XQVJ68qg+DX8V3lpDvEIfzPp90wH5LS
         3y/Stp4QlEYg+aGwWEfj1CPyg3Et8xP9n1pbTpWbE6rLtC0W7zLFELsWw9pJ9EBD611n
         1yPkW+/olm6Byo6ckJ3ThlEVSZq8DD8AI4DcilRm9Ay2DgXVNyg2qs4gWSMbOqs+Dh1r
         JyZe8UN4COhpxrXW9JW+5gZUs1BcNJ0F1qCZDpWMoXc8gVi+/IXvzPg5pqv/j/MsrG62
         Y8sg==
X-Gm-Message-State: AOAM531XCltb5tvk9rRRs2jkoeNdIn7WGXnaudbDnmsZWYAM0CLeUUJW
        92iiZEPOAfUtnuGNTVBpM+bt0nlurqQ=
X-Google-Smtp-Source: ABdhPJxSw0Li4KDLRvKlY96P7FTBS408h7GYGBLjdJ8tqYmJw92+bLXp8WpiwnkpCC7PekKzBO8/aZ4K7Aw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a5b:148:: with SMTP id c8mr77569092ybp.45.1609374456428;
 Wed, 30 Dec 2020 16:27:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Dec 2020 16:26:58 -0800
In-Reply-To: <20201231002702.2223707-1-seanjc@google.com>
Message-Id: <20201231002702.2223707-6-seanjc@google.com>
Mime-Version: 1.0
References: <20201231002702.2223707-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 5/9] KVM: VMX: Move Intel PT shenanigans out of VMXON/VMXOFF flows
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David P . Reed" <dpreed@deepplum.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the Intel PT tracking outside of the VMXON/VMXOFF helpers so that
a future patch can drop KVM's kvm_cpu_vmxoff() in favor of the kernel's
cpu_vmxoff() without an associated PT functional change, and without
losing symmetry between the VMXON and VMXOFF flows.

Barring undocumented behavior, this should have no meaningful effects
as Intel PT behavior does not interact with CR4.VMXE.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 65b5f02b199f..131f390ade24 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2265,7 +2265,6 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 	u64 msr;
 
 	cr4_set_bits(X86_CR4_VMXE);
-	intel_pt_handle_vmx(1);
 
 	asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
 			  _ASM_EXTABLE(1b, %l[fault])
@@ -2276,7 +2275,6 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 fault:
 	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
 		  rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
-	intel_pt_handle_vmx(0);
 	cr4_clear_bits(X86_CR4_VMXE);
 
 	return -EFAULT;
@@ -2299,9 +2297,13 @@ static int hardware_enable(void)
 	    !hv_get_vp_assist_page(cpu))
 		return -EFAULT;
 
+	intel_pt_handle_vmx(1);
+
 	r = kvm_cpu_vmxon(phys_addr);
-	if (r)
+	if (r) {
+		intel_pt_handle_vmx(0);
 		return r;
+	}
 
 	if (enable_ept)
 		ept_sync_global();
@@ -2327,7 +2329,6 @@ static void kvm_cpu_vmxoff(void)
 {
 	asm volatile (__ex("vmxoff"));
 
-	intel_pt_handle_vmx(0);
 	cr4_clear_bits(X86_CR4_VMXE);
 }
 
@@ -2335,6 +2336,8 @@ static void hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 	kvm_cpu_vmxoff();
+
+	intel_pt_handle_vmx(0);
 }
 
 /*
-- 
2.29.2.729.g45daf8777d-goog

