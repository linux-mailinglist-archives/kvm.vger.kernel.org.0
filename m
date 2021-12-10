Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860C8470DD5
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 23:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhLJWcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 17:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbhLJWcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 17:32:41 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4E0C061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 14:29:06 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id u4-20020a056a00098400b004946fc3e863so6442393pfg.8
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 14:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=zuByOoOA6PnFI6sXqBGBHPJRzJ2T5PdsKsZryVtE+nY=;
        b=dCz9WejTK/2Jsnln8mV236qJvvaYIZLyGzrtTbEVL9ViZVBJiRTfsDZAF4BzuerQOW
         PykwgrGiLpD0NIdCuUrbLJXADMCI8yRe9pWVP1QovKL04JtEU2DTCqsGTzQtorIn1qdg
         gf9KeFzEkQtl5uaL3HqkkSS5jIHzkwGVwSMDRrX7Ox5CLH2119zwBINaVQC1GzYyLpH8
         +YideVA3nNx9yYG4jyK7G+ArKaCuqjwMjkwGYtCcuK3iOr5Ph36VnbRo0lHJreCgqDoX
         H8gUHF00FvdTllLBZLVySxxxZcifmFSOQy4WH6WXbh/LwND4S+jBOZvAr3ypfAI0J7op
         aMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=zuByOoOA6PnFI6sXqBGBHPJRzJ2T5PdsKsZryVtE+nY=;
        b=h7Pxy/Qw/q9x7AJ8jpcQi7+3YCTvqa85CXubOFYwTn+7qtdZg1JtBiOh+YXGiPQ79T
         NqbMDLJx4zR7URhFbnOfKznNXODgdE43HnTpCUAKB+3OfJO4BD0OWwhvZ6tQknG7uYz1
         BRP66dlP6Cyt4wQ644XOr7GGz+DPCByKpgScU5dcSEcXD46yGOtoHCoo1S0BxEYixPay
         TAn/AWBLiFd0YobA9cffow9leQR04BEkZZZ/RkIA5+i2TyU4U4uuOUB1hwTamnVJVmjV
         ANDaRemjZRouCl2EhIVHfl+66g9oH2npz7/DBUYFVY1u76UMqcdj2e1oJQEVNY9EAylj
         uPtQ==
X-Gm-Message-State: AOAM532zoV/OE+yaV3PUNeh5DPMQ5w6y9bO4IEM1/aLxmVakBsR7YsiO
        ZL1Btj3CfoNlBGTsfZklSV/gMIifhBY=
X-Google-Smtp-Source: ABdhPJw6hvj6Wv+mt02lTcC3pTe9ZTzRZfeIp5uPcxm9owdY3yeE0AkMrcAmUrwzFmdGf6y2AEgMWcXblI0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr1857812pjb.0.1639175345077; Fri, 10 Dec 2021 14:29:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Dec 2021 22:29:03 +0000
Message-Id: <20211210222903.3417968-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH] KVM: x86: Inject #UD on "unsupported" hypercall if patching fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject a #UD if patching in the correct hypercall fails, e.g. due to
emulator_write_emulated() failing because RIP is mapped not-writable by
the guest.  The guest is likely doomed in any case, but observing a #UD
in the guest is far friendlier to debug/triage than a !WRITABLE #PF with
CR2 pointing at the RIP of the faulting instruction.

Ideally, KVM wouldn't patch at all; it's the guest's responsibility to
identify and use the correct hypercall instruction (VMCALL vs. VMMCALL).
Sadly, older Linux kernels prior to commit c1118b3602c2 ("x86: kvm: use
alternatives for VMCALL vs. VMMCALL if kernel text is read-only") do the
wrong thing and blindly use VMCALL, i.e. removing the patching would
break running VMs with older kernels.

One could argue that KVM should be "fixed" to ignore guest paging
protections instead of injecting #UD, but patching in the first place was
a mistake as it was a hack-a-fix for a guest bug.  There are myriad fatal
issues with KVM's patching:

  1. Patches using an emulated guest write, which will fail if RIP is not
     mapped writable.  This is the issue being mitigated.

  2. Doesn't ensure the write is "atomic", e.g. a hypercall that splits a
     page boundary will be handled as two separate writes, which means
     that a partial, corrupted instruction can be observed by a vCPU.

  3. Doesn't serialize other CPU cores after updating the code stream.

  4. Completely fails to account for the case where KVM is emulating due
     to invalid guest state with unrestricted_guest=0.  Patching and
     retrying the instruction will result in vCPU getting stuck in an
     infinite loop.

But, the "support" _so_ awful, especially #1, that there's practically
zero chance that a modern guest kernel can rely on KVM to patch the guest.
So, rather than proliferate KVM's bad behavior any further than the
absolute minimum needed for backwards compatibility, just try to make it
suck a little less.

Cc: Hou Wenlong <houwenlong93@linux.alibaba.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c |  2 +-
 arch/x86/kvm/x86.c     | 13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 28b1a4e57827..3ccf7b73687f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3734,7 +3734,7 @@ static int em_hypercall(struct x86_emulate_ctxt *ctxt)
 	int rc = ctxt->ops->fix_hypercall(ctxt);
 
 	if (rc != X86EMUL_CONTINUE)
-		return rc;
+		return emulate_ud(ctxt);
 
 	/* Let the processor re-execute the fixed hypercall */
 	ctxt->_eip = ctxt->eip;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26cb3a4cd0e9..1a844ad873ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9026,11 +9026,20 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	char instruction[3];
 	unsigned long rip = kvm_rip_read(vcpu);
+	struct x86_exception e;
+	int r;
 
 	static_call(kvm_x86_patch_hypercall)(vcpu, instruction);
 
-	return emulator_write_emulated(ctxt, rip, instruction, 3,
-		&ctxt->exception);
+	/*
+	 * Eat any exceptions, e.g. if RIP is not mapped writable, and simply
+	 * signal failure to the caller.  Faults on the write are (obviously)
+	 * not from the guest, though the guest is likely doomed in any case.
+	 */
+	r = emulator_write_emulated(ctxt, rip, instruction, 3, &e);
+	if (r != X86EMUL_CONTINUE)
+		return X86EMUL_UNHANDLEABLE;
+	return X86EMUL_CONTINUE;
 }
 
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
-- 
2.34.1.173.g76aa8bc2d0-goog

