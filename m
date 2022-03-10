Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C28C4D4F9D
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244168AbiCJQrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244071AbiCJQr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:47:28 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5924C197B73
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:14 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id q7-20020a63e207000000b003801b9bb18dso3211774pgh.15
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NW+z7HtQmlg5a0U0koIIQucOMtvMCE0mN+TldjWFMzI=;
        b=A6tZ8fUNYKG6WFUuHJ21b9uCD5dMPkYBBYMpTMl6dEvJNqI5oVKTYYMiWMMhBj2xqA
         3KVbpQg3rc1rZ8oNcG59/bueMJfgsOakAHvl/T5d8eP8SXPS+j85IKFUp5xjwJfgIgTh
         UPGxoOIMIi+w24D+zOkg1hPhVMRxIzy5pL8sh1J1C4qu22NfkuSGvqeNwkYjdPaVtwX/
         DLPpcqKCeZkKHFqB7BECyiFMOKg0q5A5xn9LNxX3ACRS+nO/QOqag32TpFVwPchTSpkd
         LAZSYn4vAYZh1krjAbG+UpB5X2aGByV8XeWwqyr9FguBm8V+P3rGXY2UpKf8yJ5DKb0D
         Eeqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NW+z7HtQmlg5a0U0koIIQucOMtvMCE0mN+TldjWFMzI=;
        b=CvmQK6vHXaJcV38nDydt8+XUUrUE2KNKVDmYZRD5MYYbv9IGu6bpeLxypqkrXpF/GX
         6Zq/gNzU7vcYltwAFR+YNjNgGGhsMtz95oJccHYT+DvtB4KCZWOrZohu31gnEtjI0Gxe
         DOVxPuPIhgfvXG2/8AMNPV9snJxYGJErrMTTiIw2FvoqUaBUB7gW/hg8oyZXX9MlPq1+
         vSbiD63v9Co7HCvVl/CWW2ZQsh6hLzZoNnPP1YiMtsCQFI8GsOdRqNK2TNxLhflXlG3d
         xYefkVXi66MHzBhAIwUSv5qRf8zoNHN09J53oEfUjY65UY3XKyQXKEicFKWzbWo3m4Xi
         fxRQ==
X-Gm-Message-State: AOAM531OzgNh5KxpIr3n1l4437k8Ue24W4jx+gyMCKv8v2RNlm+oEMgl
        5Wl6Un2/vzFONA/OeSWKJslIicEoC5/O
X-Google-Smtp-Source: ABdhPJzEz+KcGZn1TBz/jV3Jq6wYxRTubaL8HoPTXQnSO/rJqUdU3ejJQpxctcAMk9C/B5Af7mWSDlEYVDvP
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a17:90a:2ec2:b0:1bc:8bdd:8cfc with SMTP id
 h2-20020a17090a2ec200b001bc8bdd8cfcmr17171203pjs.237.1646930773835; Thu, 10
 Mar 2022 08:46:13 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:29 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-11-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 10/13] KVM: x86/MMU: Allow NX huge pages to be disabled on a
 per-vm basis
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
2.35.1.616.g0bdcbb4464-goog

