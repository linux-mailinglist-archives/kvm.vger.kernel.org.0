Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184433B0BFA
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhFVSAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbhFVSA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:27 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77059C061760
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:10 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 44-20020aed30af0000b029024e8ccfcd07so69915qtf.11
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UvWOiZNIX7hCeQXFYIlCFQ6LdPOFZrfts8z5QCqyL0U=;
        b=oDnh2Quk2OxkzewIMcVO6Z65slyLPg2A6HSZBCtvjs6itrPS8R/0+q358KpJ/Gju2y
         Qhe2B+5GN6BiHsUCbnClOjG9o4dL4/cYuh2Ss5GUIBeAt2TKlgyk8XWt+dKXqj4flReS
         UPhedyp09aR9TcHcqg659LjqfcGDaeCWSqngScokdH8X1jxsv6Eev3dAaeapESy6R9qr
         Fz7Xr3CE/syMaVS9OcpEFhqDvhGjmpru9FFQmnbCzUN7iCHRq41LqZcoUEtJiKTB+eCI
         l+Jlcfnz8J8gjHdUOwIsVU9qn2pNQdS4rZSY8/ItdMdYYdsADxPB104GPblkPDsyUZM/
         Vq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UvWOiZNIX7hCeQXFYIlCFQ6LdPOFZrfts8z5QCqyL0U=;
        b=p+i+rliN/dfNFSypGLIb5lRY7PQ64grjYrRTCDb25fKn1RLIqF0OU2Btwt8ZwE9sc7
         vlz9XWlKiEkfpPf+HpTqSPnbgJPXoWrIbqhlJkHlPUouw7OyqVGrsdfAPCEECw6h9B25
         xbxfczE3+8egkLCducKNNNVXSKLOPAdx88YTGmMAl42CImE/OFZ2t6uoSIimszmutQCD
         xs90qDBN8bQ1t0Nh3LFCBclkcXZaU8ge0tG9hs5bwAtXjZEDUswC5Lg39CL3tdrKzpRH
         olwiJMN1UQxhCqAp8lf3nvieu7CkZhheYQCBf7TPTe2KJ0AO1LYh1GAIWb6OI/L2r03k
         t1yQ==
X-Gm-Message-State: AOAM532VpGh4PinWRjUWqf8yCo+vXrR8stKmk8CCkENvO/PQJKMaRc8L
        6TZlUyMjHGDzFr3ASEb4RF6YhjjGD0I=
X-Google-Smtp-Source: ABdhPJwYEA+Qrti8CZz/HffI7CWhUsl0klOtkUVNZq4ZYdO06MlUHWYqBSR7V5t5Hn0+u0gmATJF+ioOp34=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:be8a:: with SMTP id i10mr6596444ybk.176.1624384689502;
 Tue, 22 Jun 2021 10:58:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:51 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 06/54] KVM: x86: Force all MMUs to reinitialize if guest CPUID
 is modified
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invalidate all MMUs' roles after a CPUID update to force reinitizliation
of the MMU context/helpers.  Despite the efforts of commit de3ccd26fafc
("KVM: MMU: record maximum physical address width in kvm_mmu_extended_role"),
there are still a handful of CPUID-based properties that affect MMU
behavior but are not incorporated into mmu_role.  E.g. 1gb hugepage
support, AMD vs. Intel handling of bit 8, and SEV's C-Bit location all
factor into the guest's reserved PTE bits.

The obvious alternative would be to add all such properties to mmu_role,
but doing so provides no benefit over simply forcing a reinitialization
on every CPUID update, as setting guest CPUID is a rare operation.

Note, reinitializing all MMUs after a CPUID update does not fix all of
KVM's woes.  Specifically, kvm_mmu_page_role doesn't track the CPUID
properties, which means that a vCPU can reuse shadow pages that should
not exist for the new vCPU model, e.g. that map GPAs that are now illegal
(due to MAXPHYADDR changes) or that set bits that are now reserved
(PAGE_SIZE for 1gb pages), etc...

Tracking the relevant CPUID properties in kvm_mmu_page_role would address
the majority of problems, but fully tracking that much state in the
shadow page role comes with an unpalatable cost as it would require a
non-trivial increase in KVM's memory footprint.  The GBPAGES case is even
worse, as neither Intel nor AMD provides a way to disable 1gb hugepage
support in the hardware page walker, i.e. it's a virtualization hole that
can't be closed when using TDP.

In other words, resetting the MMU after a CPUID update is largely a
superficial fix.  But, it will allow reverting the tracking of MAXPHYADDR
in the mmu_role, and that case in particular needs to mostly work because
KVM's shadow_root_level depends on guest MAXPHYADDR when 5-level paging
is supported.  For cases where KVM botches guest behavior, the damage is
limited to that guest.  But for the shadow_root_level, a misconfigured
MMU can cause KVM to incorrectly access memory, e.g. due to walking off
the end of its shadow page tables.

Fixes: 7dcd57552008 ("x86/kvm/mmu: check if tdp/shadow MMU reconfiguration is needed")
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  6 +++---
 arch/x86/kvm/mmu/mmu.c          | 12 ++++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 916e0f89fdfc..4ac534766eff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1501,6 +1501,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu);
 void kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
+void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b4da665bb892..c42613cfb5ba 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -202,10 +202,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
 
 	/*
-	 * Except for the MMU, which needs to be reset after any vendor
-	 * specific adjustments to the reserved GPA bits.
+	 * Except for the MMU, which needs to do its thing any vendor specific
+	 * adjustments to the reserved GPA bits.
 	 */
-	kvm_mmu_reset_context(vcpu);
+	kvm_mmu_after_set_cpuid(vcpu);
 }
 
 static int is_efer_nx(void)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5024318dec45..e2668a9b5936 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4903,6 +4903,18 @@ kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
 	return role.base;
 }
 
+void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Invalidate all MMU roles to force them to reinitialize as CPUID
+	 * information is factored into reserved bit calculations.
+	 */
+	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
+	kvm_mmu_reset_context(vcpu);
+}
+
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
-- 
2.32.0.288.g62a8d224e6-goog

