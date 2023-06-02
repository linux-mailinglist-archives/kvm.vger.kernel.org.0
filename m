Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78D8720759
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbjFBQUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbjFBQUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:20:02 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E13CB6
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:20:01 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id af79cd13be357-75b07b420a5so342412885a.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722800; x=1688314800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NmNcA4xrgkLcuCGWOYpC0PmEaXmJrDnJmM0yVjAGGFM=;
        b=0IIUK1mWMEG2R6N4d5epNpupo33pLP7t2ryHaqSkREVc7duxUDfOYqbEupeqxyxidc
         A7rZ95wvqt524EgYfMuqPFlV+xw2egXfhPMcz7dGPu1gAkNGZPENuPINAV6DC8a76ANF
         IQxKtqJAI7RbssURcnYAUR07XZZW1kvRP+GXvkk4wrMF49u+xAsb3v4me+WS8QuVbN87
         9UvfaTFppf5lxb3L2CfyH48+R84uevexSATlfBbRU6cOM3MEQsHpeasNIRBiThOu7PnC
         SV0YhLbsVRMUpHiAx6gpKJyQgBnP0fwcgc/StbmQCevxrEVqYp+57ivSKLZj1JG46c4Q
         XmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722800; x=1688314800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NmNcA4xrgkLcuCGWOYpC0PmEaXmJrDnJmM0yVjAGGFM=;
        b=GREewqeSUR81QPajGZ/tru7795Sirydp1bZdF1HAhxyfvIeV5XZuK2mRbTF1mzn9JY
         QR+RhpcRBbc0YHKoV3LPYOUltnFEVQu7l+GbZgX96bGXZFgzyk+DqNcK+EFzCw4v1lqU
         oqOhjgl2QaH1/GHqIunzAk8qUs5DGtUtDV4wRwqPljntdcs4VZbXwGY2BtSuW1es+Os6
         g5J5w5kHDTxYrWKwN03rOga9+/ny5yyEjJ2IeA4mGKNEx44qYQLpNjDCHZ3HqFD+5nZf
         gL5GtIB2ES0KCSPHhMeJdTXqUQZC4yR7BHDGy5W3vhepC9QHTuttvoVVg4zMBxCExgQg
         7k8Q==
X-Gm-Message-State: AC+VfDyi9gq8dBLPvhERs2+ezjSm36v4NgPOk5yoNE12wI0Bd1HMNuvk
        gis3MQt3XjMg5HMZ1hQJ+e20BOIpbt5ssw==
X-Google-Smtp-Source: ACHHUZ6bv1kbPvWMJXUXqPMgDp4g1CaZyD97JDkp7fAkdZjAvm6jS8/kc+tAuHTNuKRQ9BOzT/F7nAiehCTHeA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:620a:29cb:b0:75c:a6ff:3462 with SMTP
 id s11-20020a05620a29cb00b0075ca6ff3462mr3860470qkp.4.1685722800556; Fri, 02
 Jun 2023 09:20:00 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:15 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-11-amoorthy@google.com>
Subject: [PATCH v4 10/16] KVM: x86: Implement KVM_CAP_NOWAIT_ON_FAULT
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
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

When the memslot flag is enabled, fail guest memory accesses for which
fast-gup fails (ie, where resolving the page fault would require putting
the faulting thread to sleep).

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/x86/kvm/mmu/mmu.c         | 17 ++++++++++++-----
 arch/x86/kvm/x86.c             |  1 +
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9daadbe2c7ed..aa7b4024fd41 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7783,7 +7783,7 @@ bugs and reported to the maintainers so that annotations can be added.
 7.35 KVM_CAP_NOWAIT_ON_FAULT
 ----------------------------
 
-:Architectures: None
+:Architectures: x86
 :Returns: -EINVAL.
 
 The presence of this capability indicates that userspace may pass the
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cb71aae9aaec..288008a64e5c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4299,7 +4299,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
 }
 
-static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,
+			     struct kvm_page_fault *fault,
+			     bool nowait)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -4332,9 +4334,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn,
+					  nowait, false,
+					  nowait ? NULL : &async,
+					  fault->write, &fault->map_writable, &fault->hva);
+
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4368,7 +4373,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = __kvm_faultin_pfn(vcpu, fault);
+	ret = __kvm_faultin_pfn(vcpu, fault,
+				likely(fault->slot)
+					&& kvm_slot_nowait_on_fault(fault->slot));
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d15bacb3f634..4fbe9c811cc7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4498,6 +4498,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_NOWAIT_ON_FAULT:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
-- 
2.41.0.rc0.172.g3f132b7071-goog

