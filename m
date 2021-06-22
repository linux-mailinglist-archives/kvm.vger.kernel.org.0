Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F223B0BFC
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhFVSAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhFVSA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:29 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9792EC061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:12 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id e20-20020ac85dd40000b029024ed7d58d2cso85539qtx.8
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ctgmz8Jc6B+eyWn99WgBSldp+EhT4qLAKur7SwAEIBk=;
        b=uJZ33hzLtD41/PRVdarSTW7WwE8queNGV/DSluHHNqvcSCA4rphvrsaM6S4SEr2KEx
         erN/n885YTRofoezFRqWCHyr0+C4wLl3qNayUGK6AKqCcRxuWa+5k/B/Qp17ZAMBxrZP
         1s8lViZ26xxX9cnSnnGtjLZrvmJp4H4ybbZfXVr+rTH2UuvGyaFXK71Ceaf0kh+fXA3S
         vKKO6hzWKx2tfHAkqV1RHt8OtDNsKf1p94lbrwd31hkFBEvrELyEC+XPfO8LFDNCRXW7
         e3hfNe1JNfW8eG2zohelkdAY/w0AcLElghCJArzj8Rktblkpho97TYpCUp4Zg7OueI/Z
         GQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ctgmz8Jc6B+eyWn99WgBSldp+EhT4qLAKur7SwAEIBk=;
        b=d1zj8Go6TyVv4BBRRxv9eA5Obj+tgrglLV0yqWBfl9Ugn57iwZIN1HogJOG9OkbvCt
         9mnB2TDnYWvg0LbG1Qggd8bwjqHSGtkXNpaT8Hn2K2IyIV2tbvsTcBV/Wmnh0f/cRxXG
         jb6ymQ/NCH5aWNPpsufuU2hsfzol3Kxc7weEZf7aN9XliRroGGMGq55ocY9tcJkWttqR
         Q2HAead876bztU3v03KzsqAybQzmtZhun9f+82qBRq83LAfqit6T9GIhFjMWdtY0wst/
         WMCEZSSAZ7HOGmtuSUb/0SJjuH5X/XiroS4vHCFL8NVlrCSaecsFfJl/SHMBc3Lq+bbd
         rY3g==
X-Gm-Message-State: AOAM530uh37yVyLcCL4Tb9nLcC3DpVnWXBYVXDCTOY6jeS5DhgxbbqaO
        F8imVzh5uSRN3v8Ja32WnuPllgiBe+k=
X-Google-Smtp-Source: ABdhPJyjOHX4t4+2a1lnwNObNmXF9ea51NtGJ9XyatRhKb3i6arsOX0OEhdL8QlhsbMoiX7Kg16cAsV4h2Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:7cc6:: with SMTP id x189mr6565472ybc.371.1624384691750;
 Tue, 22 Jun 2021 10:58:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:52 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 07/54] KVM: x86: Alert userspace that KVM_SET_CPUID{,2} after
 KVM_RUN is broken
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

Warn userspace that KVM_SET_CPUID{,2} after KVM_RUN "may" cause guest
instability.  Initialize last_vmentry_cpu to -1 and use it to detect if
the vCPU has been run at least once when its CPUID model is changed.

KVM does not correctly handle changes to paging related settings in the
guest's vCPU model after KVM_RUN, e.g. MAXPHYADDR, GBPAGES, etc...  KVM
could theoretically zap all shadow pages, but actually making that happen
is a mess due to lock inversion (vcpu->mutex is held).  And even then,
updating paging settings on the fly would only work if all vCPUs are
stopped, updated in concert with identical settings, then restarted.

To support running vCPUs with different vCPU models (that affect paging),
KVM would need to track all relevant information in kvm_mmu_page_role.
Note, that's the _page_ role, not the full mmu_role.  Updating mmu_role
isn't sufficient as a vCPU can reuse a shadow page translation that was
created by a vCPU with different settings and thus completely skip the
reserved bit checks (that are tied to CPUID).

Tracking CPUID state in kvm_mmu_page_role is _extremely_ undesirable as
it would require doubling gfn_track from a u16 to a u32, i.e. would
increase KVM's memory footprint by 2 bytes for every 4kb of guest memory.
E.g. MAXPHYADDR (6 bits), GBPAGES, AMD vs. INTEL = 1 bit, and SEV C-BIT
would all need to be tracked.

In practice, there is no remotely sane use case for changing any paging
related CPUID entries on the fly, so just sweep it under the rug (after
yelling at userspace).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  | 11 ++++++++---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 18 ++++++++++++++++++
 arch/x86/kvm/x86.c              |  2 ++
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e328caa35d6c..06e82f07fe54 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -688,9 +688,14 @@ MSRs that have been set successfully.
 Defines the vcpu responses to the cpuid instruction.  Applications
 should use the KVM_SET_CPUID2 ioctl if available.
 
-Note, when this IOCTL fails, KVM gives no guarantees that previous valid CPUID
-configuration (if there is) is not corrupted. Userspace can get a copy of the
-resulting CPUID configuration through KVM_GET_CPUID2 in case.
+Caveat emptor:
+  - If this IOCTL fails, KVM gives no guarantees that previous valid CPUID
+    configuration (if there is) is not corrupted. Userspace can get a copy
+    of the resulting CPUID configuration through KVM_GET_CPUID2 in case.
+  - Using KVM_SET_CPUID{,2} after KVM_RUN, i.e. changing the guest vCPU model
+    after running the guest, may cause guest instability.
+  - Using heterogeneous CPUID configurations, modulo APIC IDs, topology, etc...
+    may cause guest instability.
 
 ::
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4ac534766eff..19c88b445ee0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -840,7 +840,7 @@ struct kvm_vcpu_arch {
 	bool l1tf_flush_l1d;
 
 	/* Host CPU on which VM-entry was most recently attempted */
-	unsigned int last_vmentry_cpu;
+	int last_vmentry_cpu;
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2668a9b5936..8d97d21d5241 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4913,6 +4913,24 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
 	kvm_mmu_reset_context(vcpu);
+
+	/*
+	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
+	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
+	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
+	 * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
+	 * sweep the problem under the rug.
+	 *
+	 * KVM's horrific CPUID ABI makes the problem all but impossible to
+	 * solve, as correctly handling multiple vCPU models (with respect to
+	 * paging and physical address properties) in a single VM would require
+	 * tracking all relevant CPUID information in kvm_mmu_page_role.  That
+	 * is very undesirable as it would double the memory requirements for
+	 * gfn_track (see struct kvm_mmu_page_role comments), and in practice
+	 * no sane VMM mucks with the core vCPU model on the fly.
+	 */
+	if (vcpu->arch.last_vmentry_cpu != -1)
+		pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} after KVM_RUN may cause guest instability\n");
 }
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42608b515ce4..92b4a9305651 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10583,6 +10583,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	struct page *page;
 	int r;
 
+	vcpu->arch.last_vmentry_cpu = -1;
+
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
-- 
2.32.0.288.g62a8d224e6-goog

