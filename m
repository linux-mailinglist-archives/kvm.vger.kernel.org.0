Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403D24E3534
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 01:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiCUXvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 19:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbiCUXvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 19:51:12 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BA61959FD
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:16 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ob7-20020a17090b390700b001c692ec6de4so437357pjb.7
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3m1W1T75EhNPFRfjof7HoQxGZ4zdcLUtCtOcDM/n6y4=;
        b=bH7mF2kTNI6R9mqs/j3WnNRaTz53LMn3cG+XFNKKsojz7Erkkcrw6O4LzU4qaDoUmk
         U6emSh7jsHYg0cKvkSk5657wzZvuGxwV9P24j10++KR+L8N4dYhXpUUtHYi2Wn1DDw5k
         mTet9eA6qZ/EByyry2C8ig+YydTCvmKnPpDQvm4om2lhvE27JMCTarC5Q0d9z+kz2i/K
         9RCLcCCXXqsixdkDoSSzyk2xnX15MbqopTzGwi19TW5JyJBgOtNRCztMatkBVPm8mvAP
         8uPdYNBbsqDCoyMfQ1CzSP7R0WdHm44rWvN7zRXLjVNY13zAmxgX5JU5r4D0hQS8WNaZ
         rWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3m1W1T75EhNPFRfjof7HoQxGZ4zdcLUtCtOcDM/n6y4=;
        b=siqafQAr2G/ZBaqmh67i0pMLLSuOmSCUebljb5vUvHba8nkR5CiZMBLlKnlzbOh384
         3Ffv05f3y8RRPZgiynVVpLnl4iBEOisx7xr6u54CFq0hHRsYsPaEiL1gIcoGXp8xMG4z
         sWdAxgZEhgE/ZYcxlT7+D9jRhKLmjQ32TKlrBTKBA8pidfJflLuqOI5sSpzaF52DDgOp
         OpRyYuyqmeLKdUSrqCDhDOzTSy+OxD1Hkw3Cdtu70m2Il6E3y+YWVO9IKzI+y66p7ot9
         sx5f+NkuLlJnlgQS1lDSjn723VZKqFNb1cIDbLDg6uELIhv+7/d7eDchIM/SshrGAP1N
         AY2w==
X-Gm-Message-State: AOAM531FbPRzN5fpgZ0F22rsFvQPlfDQ5cVWLbGCtii4c13NaZlZYE6W
        0efQNn5UGUSsZVpHlM5RsB9oOT0d+t28
X-Google-Smtp-Source: ABdhPJwYF1kawNqVseiO7m27DBt/cqs+ne+QGTzIFChBVKDCqpuIaX8cdJTaoOjN8Cv37L+XEUkjHTj8iQJH
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:90a:1b2e:b0:1c6:d5ed:3ca4 with SMTP id
 q43-20020a17090a1b2e00b001c6d5ed3ca4mr1678022pjq.171.1647906555633; Mon, 21
 Mar 2022 16:49:15 -0700 (PDT)
Date:   Mon, 21 Mar 2022 16:48:42 -0700
In-Reply-To: <20220321234844.1543161-1-bgardon@google.com>
Message-Id: <20220321234844.1543161-10-bgardon@google.com>
Mime-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 09/11] KVM: x86/MMU: Allow NX huge pages to be disabled on
 a per-vm basis
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

In some cases, the NX hugepage mitigation for iTLB multihit is not
needed for all guests on a host. Allow disabling the mitigation on a
per-VM basis to avoid the performance hit of NX hugepages on trusted
workloads.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu.h              | 1 +
 arch/x86/kvm/mmu/mmu.c          | 6 ++++--
 arch/x86/kvm/x86.c              | 6 ++++++
 include/uapi/linux/kvm.h        | 1 +
 5 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0a0c54639dd8..04ddfc475ce0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1242,6 +1242,7 @@ struct kvm_arch {
 #endif
 
 	bool nx_huge_pages;
+	bool disable_nx_huge_pages;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index dd28fe8d13ae..36d8d84ca6c6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -177,6 +177,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 {
 	return READ_ONCE(kvm->arch.nx_huge_pages);
 }
+void kvm_update_nx_huge_pages(struct kvm *kvm);
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefetch)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dc9672f70468..a7d387ccfd74 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6195,9 +6195,10 @@ static void __set_nx_huge_pages(bool val)
 	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
 }
 
-static void kvm_update_nx_huge_pages(struct kvm *kvm)
+void kvm_update_nx_huge_pages(struct kvm *kvm)
 {
-	kvm->arch.nx_huge_pages = nx_huge_pages;
+	kvm->arch.nx_huge_pages = nx_huge_pages &&
+				  !kvm->arch.disable_nx_huge_pages;
 
 	mutex_lock(&kvm->slots_lock);
 	kvm_mmu_zap_all_fast(kvm);
@@ -6451,6 +6452,7 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 	int err;
 
 	kvm->arch.nx_huge_pages = READ_ONCE(nx_huge_pages);
+	kvm->arch.disable_nx_huge_pages = false;
 	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 0,
 					  "kvm-nx-lpage-recovery",
 					  &kvm->arch.nx_lpage_recovery_thread);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 51106d32f04e..73df90a6932b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4256,6 +4256,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6048,6 +6049,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+		kvm->arch.disable_nx_huge_pages = true;
+		kvm_update_nx_huge_pages(kvm);
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ee5cc9e2a837..6f9fa7ecfd1e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1144,6 +1144,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
+#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 214
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.894.gb6a874cedc-goog

