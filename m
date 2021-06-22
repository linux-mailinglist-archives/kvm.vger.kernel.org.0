Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FDB3B0C59
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhFVSG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhFVSFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:05:55 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB62C07E5E0
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:49 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c29-20020ac86e9d0000b0290247b267c8e4so33759qtv.22
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LTdWaGBB+4s5m2BBkCxc7E6E/euT/fJ4rCSegaNd6CU=;
        b=rm+C67MCyZUSKw7JFoVlyx3PKqIAWeOtjpjpZU2QLM9zJkJG1S/E8hbxQtyG4cIhMw
         R06SCfptDnbvipdh8pN/PR1e0qEhu1pZP+PTt4KIbJ9wHYtg24JszsbO8OTE1Y5njbp1
         krkOQ3nQ7l6UrMX6WZ1/cx4xaMTmEH4g1KvqNrnGq9H35TZIwKylJLBU3GLwG6gndk5W
         +ONu5SDF/x7RpruixI26BcpBvFuQVtNkw9v132lBXPfblr1V989IFzmQCYYsbKFuzTXe
         tNKA90O7WBCmJt0Ny91YNnGAseb5rKX6xYRNWae29LRUZNbEWdFl2IDTJwW5Glqv4O7F
         zN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LTdWaGBB+4s5m2BBkCxc7E6E/euT/fJ4rCSegaNd6CU=;
        b=TfdBlc3rqOSazOnCvhO7jWRJsdSBbFlzi5JIZUCziAW1/JvwWMSAgqlqvI9F7Wu69g
         mtOHnF98sgNEEqB1XlX7zFAtMCY1kzKyywwQbJesFrvDp6+/ok4yrql34vHIB9gM3qXA
         oizf8T4pMcLQvMvfPVtEl4RAHEOIBLXRVBGJ8C3g7V/Ydj+mLLonbyPXd6WS9FLvHcJo
         bapS20nRYasr6Xm4S38BsFfwKRgskagB6uv2+bp8d/Vsmj1kz4Etde/qDVQrjBojzQ8l
         FdlCIFvdarYzXXa+TP6LeQN4w8Vd/e035jnwBNWv31WNc467XlsD8fFRCPNBKgZw9gFf
         rSHA==
X-Gm-Message-State: AOAM5309Wtc4X8KvoSvW7Wprggi4Hwzx4aqTACsmRztrwxZtoC+j6C/L
        vxKP36cdigawWI3DAINSNvGhjyB+Kp0=
X-Google-Smtp-Source: ABdhPJzT6UOVzUyWsMpZYiXvi7no3jLkErUSZR0L8SA9EGI8L/8F3SKbe4Vz84UsWINDLeug2LbhMC6jq9E=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:bb0b:: with SMTP id z11mr6168135ybg.449.1624384788721;
 Tue, 22 Jun 2021 10:59:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:34 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-50-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 49/54] KVM: x86: Enhance comments for MMU roles and nested
 transition trickiness
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

Expand the comments for the MMU roles.  The interactions with gfn_track
PGD reuse in particular are hairy.

Regarding PGD reuse, add comments in the nested virtualization flows to
call out why kvm_init_mmu() is unconditionally called even when nested
TDP is used.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 59 +++++++++++++++++++++++++++------
 arch/x86/kvm/svm/nested.c       |  1 +
 arch/x86/kvm/vmx/nested.c       |  1 +
 3 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index be7088fb0594..2da8b5ddbd6a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -269,12 +269,36 @@ enum x86_intercept_stage;
 struct kvm_kernel_irq_routing_entry;
 
 /*
- * the pages used as guest page table on soft mmu are tracked by
- * kvm_memory_slot.arch.gfn_track which is 16 bits, so the role bits used
- * by indirect shadow page can not be more than 15 bits.
+ * kvm_mmu_page_role tracks the properties of a shadow page (where shadow page
+ * also includes TDP pages) to determine whether or not a page can be used in
+ * the given MMU context.  This is a subset of the overall kvm_mmu_role to
+ * minimize the size of kvm_memory_slot.arch.gfn_track, i.e. allows allocating
+ * 2 bytes per gfn instead of 4 bytes per gfn.
  *
- * Currently, we used 14 bits that are @level, @gpte_is_8_bytes, @quadrant, @access,
- * @efer_nx, @cr0_wp, @smep_andnot_wp and @smap_andnot_wp.
+ * Indirect upper-level shadow pages are tracked for write-protection via
+ * gfn_track.  As above, gfn_track is a 16 bit counter, so KVM must not create
+ * more than 2^16-1 upper-level shadow pages at a single gfn, otherwise
+ * gfn_track will overflow and explosions will ensure.
+ *
+ * A unique shadow page (SP) for a gfn is created if and only if an existing SP
+ * cannot be reused.  The ability to reuse a SP is tracked by its role, which
+ * incorporates various mode bits and properties of the SP.  Roughly speaking,
+ * the number of unique SPs that can theoretically be created is 2^n, where n
+ * is the number of bits that are used to compute the role.
+ *
+ * But, even though there are 18 bits in the mask below, not all combinations
+ * of modes and flags are possible.  The maximum number of possible upper-level
+ * shadow pages for a single gfn is in the neighborhood of 2^13.
+ *
+ *   - invalid shadow pages are not accounted.
+ *   - level is effectively limited to four combinations, not 16 as the number
+ *     bits would imply, as 4k SPs are not tracked (allowed to go unsync).
+ *   - level is effectively unused for non-PAE paging because there is exactly
+ *     one upper level (see 4k SP exception above).
+ *   - quadrant is used only for non-PAE paging and is exclusive with
+ *     gpte_is_8_bytes.
+ *   - execonly and ad_disabled are used only for nested EPT, which makes it
+ *     exclusive with quadrant.
  */
 union kvm_mmu_page_role {
 	u32 word;
@@ -303,13 +327,26 @@ union kvm_mmu_page_role {
 	};
 };
 
+/*
+ * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
+ * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
+ * including on nested transitions, if nothing in the full role changes then
+ * MMU re-configuration can be skipped. @valid bit is set on first usage so we
+ * don't treat all-zero structure as valid data.
+ *
+ * The properties that are tracked in the extended role but not the page role
+ * are for things that either (a) do not affect the validity of the shadow page
+ * or (b) are indirectly reflected in the shadow page's role.  For example,
+ * CR4.PKE only affects permission checks for software walks of the guest page
+ * tables (because KVM doesn't support Protection Keys with shadow paging), and
+ * CR0.PG, CR4.PAE, and CR4.PSE are indirectly reflected in role.level.
+ *
+ * Note, SMEP and SMAP are not redundant with sm*p_andnot_wp in the page role.
+ * If CR0.WP=1, KVM can reuse shadow pages for the guest regardless of SMEP and
+ * SMAP, but the MMU's permission checks for software walks need to be SMEP and
+ * SMAP aware regardless of CR0.WP.
+ */
 union kvm_mmu_extended_role {
-/*
- * This structure complements kvm_mmu_page_role caching everything needed for
- * MMU configuration. If nothing in both these structures changed, MMU
- * re-configuration can be skipped. @valid bit is set on first usage so we don't
- * treat all-zero structure as valid data.
- */
 	u32 word;
 	struct {
 		unsigned int valid:1;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 927e545591c3..94389f974ba9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -424,6 +424,7 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
+	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
 	kvm_init_mmu(vcpu);
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 183fd9d62fc5..77fc51a852cf 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1098,6 +1098,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
+	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
 	kvm_init_mmu(vcpu);
 
 	return 0;
-- 
2.32.0.288.g62a8d224e6-goog

