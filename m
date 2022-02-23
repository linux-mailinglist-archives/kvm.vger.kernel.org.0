Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5694C0C1A
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbiBWF1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbiBWF0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:50 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1CB6D392
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:12 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b18-20020a25fa12000000b0062412a8200eso20209666ybe.22
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ADygLqIPpXiMqBEcZG+FIIc+2sjjDL7sC0SphzjVQM8=;
        b=XTSLmsGvhvcUg1TWPppXBzPUQLRac82+QtTaWAJbfENnf+LFsbfGfYAYKSS2y7fP86
         xw06QgEtf7pep5PqE6Q1aM+NyxahQ7SmgpjVkx80n1ORA4q/bqa1CVOsjpTMMWmZloKQ
         uucN4SETymYCsva4W1OHKwzmwTJIk9TZAOYPJ1y+ZPVUmyQQ1PbH7n1l3q9WUPnCWwcM
         Cb3CxmDXmSaVEz0TvEtPSskpBLRm0AocmFGmy3Znq/tmFUH/ahr88pzMeI+oucZvgSN3
         VZ4LlqahzSCUtRhfh8h6InSjlirWGXuPDeznUvG9vYUdMzAnIxg/DQM0QaE6Bs8x3s0G
         p5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ADygLqIPpXiMqBEcZG+FIIc+2sjjDL7sC0SphzjVQM8=;
        b=ZRM68Djh+36Vb9PkNCWi/gySYia/x2fnL/HYNKU8gMwGtzW/hGha/4gBtgI3TKpRrF
         H4dSAEp+5u7CdRU8Dx+NBocuwOR9wKA6XidOBFMSUjaiNuETewB3yhDTA8sm9zF/9iN4
         teNDm4ENFS8Syti9VYTmP+wC8oEcs5+m1xTvFj/zuyzTvS+sNy5cs5V1dV44i3wIEOId
         fNRXpJgwfBl1TWtcEWaVAdkYDvBsQw4rDeaeg+Mj1ckaz++H0zXF69l2jO8Sx290z6dF
         8UAX+mzkclom2j9uTED5xuwFmI/RewHk1OxVl58Lqenfu7dDE4XdNQBoSj3fTMDqQ/2D
         rqJA==
X-Gm-Message-State: AOAM5306gq8SetoQsDOU49p30rKkPf+AB8eUjWkQg3PQG1T9w/mwIn8G
        /MNcbyA/FOn4DfVUTPDzFG6wIPUezJVy
X-Google-Smtp-Source: ABdhPJxnEaZg6RVeib/qxGX0ultucEuvlDuM1/3KZuHHbAgoAGzQNWHho88GWzU0EQgaqkKLhw8qsZUiJNi/
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:354f:0:b0:2d0:e91f:c26 with SMTP id
 c76-20020a81354f000000b002d0e91f0c26mr27033178ywa.318.1645593901360; Tue, 22
 Feb 2022 21:25:01 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:10 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-35-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 34/47] kvm: asi: Unmap guest memory from ASI address space
 when using nested virt
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

L1 guest memory as a whole cannot be considered non-sensitive when an
L2 is running. Even if L1 is using its own mitigations, L2 VM Exits
could, in theory, bring into the cache some sensitive L1 memory without
L1 getting a chance to flush it.

For simplicity, we just unmap the entire L1 memory from the ASI
restricted address space when nested virtualization is turned on. Though
this is overridden if the treat_all_userspace_as_nonsensitive flag is
enabled.

In the future, we could potentially map some portions of L1 memory
which are known to contain non-sensitive memory, which would reduce ASI
overhead during nested virtualization.

Note that unmapping the guest memory still leaves a slight hole because
L2 could also potentially access copies of L1 VCPU registers stored in
L0 kernel structures. In the future, this could be mitigated by having
a separate ASI address space for each VCPU and treating the associated
structures as locally non-sensitive only within that VCPU's ASI address
space.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/mmu/mmu.c          | 10 ++++++++++
 arch/x86/kvm/vmx/nested.c       | 22 ++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e63a2f244d7b..8ba88bbcf895 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1200,6 +1200,12 @@ struct kvm_arch {
 	 */
 	struct list_head tdp_mmu_pages;
 
+	/*
+	 * Number of VCPUs that have enabled nested virtualization.
+	 * Currently only maintained when ASI is enabled.
+	 */
+	int nested_virt_enabled_count;
+
 	/*
 	 * Protects accesses to the following fields when the MMU lock
 	 * is held in read mode:
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 485c0ba3ce8b..5785a0d02558 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -94,6 +94,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 bool __ro_after_init treat_all_userspace_as_nonsensitive;
 module_param(treat_all_userspace_as_nonsensitive, bool, 0444);
+EXPORT_SYMBOL_GPL(treat_all_userspace_as_nonsensitive);
 #endif
 
 /*
@@ -2769,6 +2770,15 @@ static void asi_map_gfn_range(struct kvm_vcpu *vcpu,
 	int err;
 	size_t hva = __gfn_to_hva_memslot(slot, gfn);
 
+	/*
+	 * For now, we just don't map any guest memory when using nested
+	 * virtualization. In the future, we could potentially map some
+	 * portions of guest memory which are known to contain only memory
+	 * which would be considered non-sensitive.
+	 */
+	if (vcpu->kvm->arch.nested_virt_enabled_count)
+		return;
+
 	err = asi_map_user(vcpu->kvm->asi, (void *)hva, PAGE_SIZE * npages,
 			   &vcpu->arch.asi_pgtbl_pool, slot->userspace_addr,
 			   slot->userspace_addr + slot->npages * PAGE_SIZE);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9c941535f78c..0a0092e4102d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -318,6 +318,14 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	nested_release_evmcs(vcpu);
 
 	free_loaded_vmcs(&vmx->nested.vmcs02);
+
+	if (cpu_feature_enabled(X86_FEATURE_ASI) &&
+	    !treat_all_userspace_as_nonsensitive) {
+		write_lock(&vcpu->kvm->mmu_lock);
+		WARN_ON(vcpu->kvm->arch.nested_virt_enabled_count <= 0);
+		vcpu->kvm->arch.nested_virt_enabled_count--;
+		write_unlock(&vcpu->kvm->mmu_lock);
+	}
 }
 
 /*
@@ -4876,6 +4884,20 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 		pt_update_intercept_for_msr(vcpu);
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_ASI) &&
+	    !treat_all_userspace_as_nonsensitive) {
+		/*
+		 * We do the increment under the MMU lock in order to prevent
+		 * it from happening concurrently with asi_map_gfn_range().
+		 */
+		write_lock(&vcpu->kvm->mmu_lock);
+		WARN_ON(vcpu->kvm->arch.nested_virt_enabled_count < 0);
+		vcpu->kvm->arch.nested_virt_enabled_count++;
+		write_unlock(&vcpu->kvm->mmu_lock);
+
+		asi_unmap_user(vcpu->kvm->asi, 0, TASK_SIZE_MAX);
+	}
+
 	return 0;
 
 out_shadow_vmcs:
-- 
2.35.1.473.g83b2b277ed-goog

