Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AAC3E1B7C
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 20:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbhHESjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 14:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbhHESjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 14:39:32 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0100DC061765
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 11:39:18 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id v18-20020a0cdd920000b0290344e08aac15so4449872qvk.17
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 11:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=gut7KGVOXGVwjDuVjJlBum3fd0OxKnF/3/p9WcIAzgA=;
        b=OYB1dard195uli2R1UDCQfCJd8J/f2bMU8DFe6YCCvQzjUDDmQod0q/0Ke5zwKOs7Z
         Jo2QNXcnUqfu7c0jqYrkMTgHZDQGuv5ijMnsRm4bnn184xNJGxuu8UwFwjgVqvXF/m36
         DpsozUaZ1e80Q5epqlc9dGZu6GeLkaUBaZq82JIOeTXtLGHJhezKlON+MBztI0n2e3zw
         jFMOqlCfsvqqHVEmu2HCwZkNDfGZMZscK1pVOKUaUNdEcydraRmuzRr5+l8TJ3tfqozw
         iDoTOUWykAsKpkhk4MXqO3idulyXljEmo6/BnY8A6JYXHqJfd1xDMx2/tMOwL1q96d8C
         hq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=gut7KGVOXGVwjDuVjJlBum3fd0OxKnF/3/p9WcIAzgA=;
        b=lfbJcf6159l7cUguzpmEfoaqKOTjgWW1L4iqVgWs/hIkoI4tv0a0XT0wUMvhZZfsxP
         5Op87cgULDTsGmuY6w6hPruvYlmSDRxh40R9uwZtA5QFjgZFDMJeVYISPOcXwj5HYji7
         gVBc0R5XsFfftBh0WV1J9NLwwwDwqBrjibtw69f/+3HCRSAMnOWJiZwUv6edHhQuYUuB
         2uVwlhfVQYE4ARw6KknM3Umv7wsopc0xwv/NDKItIWbOoJHH0HYlEaFUnU1x/gYDDuXc
         4tCkvC0aKNkxjUe0Xx2OIHruwcmg5FIIXPHj96KQvdtskfH4doLOObPLzUyg3RiOAZkd
         x0PA==
X-Gm-Message-State: AOAM532XybgTl1aNj5APjf1DmZPG5PjjbDS6Ez9YCEH6jioNRgzJoeCx
        vTwHAnRwWWreLa7tGyftg6zjY5hRcII=
X-Google-Smtp-Source: ABdhPJxiby64Xc2Lz8eTQrM/JBed8r5wAEVYcaSgk1A/lfJLpvCVkeJeWWeUl/JbBAPJNukHU9o0ztEuuZY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e041:28e5:75db:9055])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2ce:: with SMTP id
 g14mr6665890qvu.46.1628188757204; Thu, 05 Aug 2021 11:39:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  5 Aug 2021 11:38:04 -0700
Message-Id: <20210805183804.1221554-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH] KVM: x86: Allow guest to set EFER.NX=1 on non-PAE 32-bit kernels
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove an ancient restriction that disallowed exposing EFER.NX to the
guest if EFER.NX=0 on the host, even if NX is fully supported by the CPU.
The motivation of the check, added by commit 2cc51560aed0 ("KVM: VMX:
Avoid saving and restoring msr_efer on lightweight vmexit"), was to rule
out the case of host.EFER.NX=0 and guest.EFER.NX=1 so that KVM could run
the guest with the host's EFER.NX and thus avoid context switching EFER
if the only divergence was the NX bit.

Fast forward to today, and KVM has long since stopped running the guest
with the host's EFER.NX.  Not only does KVM context switch EFER if
host.EFER.NX=1 && guest.EFER.NX=0, KVM also forces host.EFER.NX=0 &&
guest.EFER.NX=1 when using shadow paging (to emulate SMEP).  Furthermore,
the entire motivation for the restriction was made obsolete over a decade
ago when Intel added dedicated host and guest EFER fields in the VMCS
(Nehalem timeframe), which reduced the overhead of context switching EFER
from 400+ cycles (2 * WRMSR + 1 * RDMSR) to a mere ~2 cycles.

In practice, the removed restriction only affects non-PAE 32-bit kernels,
as EFER.NX is set during boot if NX is supported and the kernel will use
PAE paging (32-bit or 64-bit), regardless of whether or not the kernel
will actually use NX itself (mark PTEs non-executable).

Alternatively and/or complementarily, startup_32_smp() in head_32.S could
be modified to set EFER.NX=1 regardless of paging mode, thus eliminating
the scenario where NX is supported but not enabled.  However, that runs
the risk of breaking non-KVM non-PAE kernels (though the risk is very,
very low as there are no known EFER.NX errata), and also eliminates an
easy-to-use mechanism for stressing KVM's handling of guest vs. host EFER
across nested virtualization transitions.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

As alluded to in the changelog, I abandoned the idea of forcing EFER.NX for
PSE paging.  With this obsolete optimization remove, forcing EFER.NX in the
host doesn't buy us anything.  Shadow paging doesn't consume host EFER, nor
does EPT, and NPT is already incompatible with !PAE in the host.

 arch/x86/kvm/cpuid.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 739be5da3bca..fe03bd978761 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -208,30 +208,6 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_mmu_after_set_cpuid(vcpu);
 }
 
-static int is_efer_nx(void)
-{
-	return host_efer & EFER_NX;
-}
-
-static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
-{
-	int i;
-	struct kvm_cpuid_entry2 *e, *entry;
-
-	entry = NULL;
-	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
-		e = &vcpu->arch.cpuid_entries[i];
-		if (e->function == 0x80000001) {
-			entry = e;
-			break;
-		}
-	}
-	if (entry && cpuid_entry_has(entry, X86_FEATURE_NX) && !is_efer_nx()) {
-		cpuid_entry_clear(entry, X86_FEATURE_NX);
-		printk(KERN_INFO "kvm: guest NX capability removed\n");
-	}
-}
-
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -302,7 +278,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	vcpu->arch.cpuid_entries = e2;
 	vcpu->arch.cpuid_nent = cpuid->nent;
 
-	cpuid_fix_nx_cap(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
@@ -401,7 +376,6 @@ static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
 
 void kvm_set_cpu_caps(void)
 {
-	unsigned int f_nx = is_efer_nx() ? F(NX) : 0;
 #ifdef CONFIG_X86_64
 	unsigned int f_gbpages = F(GBPAGES);
 	unsigned int f_lm = F(LM);
@@ -515,7 +489,7 @@ void kvm_set_cpu_caps(void)
 		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
 		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
 		F(PAT) | F(PSE36) | 0 /* Reserved */ |
-		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
+		F(NX) | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
 		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
 		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW)
 	);
-- 
2.32.0.605.g8dce9f2422-goog

