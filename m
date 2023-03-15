Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5796BA515
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjCOCSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjCOCSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF302FCF3
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t25-20020a252d19000000b00b341ad1b626so13196660ybt.19
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BGs+CYQNnAC1/1DAeQ0v9jrMES3obN+k4CgQ4vi5pgY=;
        b=N7ufsDwje934tbXbl8Sbrp9u5iaWppQN91BjkQvKljW3t0rZNApdhSjeOHF1cc8vvM
         F6q8JeNIBZ9VNWAT0pj1ZpvqeUND0QdetuJITK3veQuCaRepcAAJ+ZQFIj/qTyQhRLi4
         aw4O9fii/6pe76Wl6/GWw8CsARM163Mouj02lGG7EXHanePsTdQKCec7GS5YwzEp+KrC
         jJHDvQf/qCEeVTmnzmUaybRk26khJqjTXW/oMnJtQAnw8l/yewn+Cs7pExByqXfOe+9a
         GkO7S2yWkio98OaI7g38b1h8m4n2Em/vFRp3zNoFU1qILz+IXRvArUs9HcSEqnlST054
         17Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BGs+CYQNnAC1/1DAeQ0v9jrMES3obN+k4CgQ4vi5pgY=;
        b=X80auA4CoeeaM6VcK1Rxm7xUD7cJ83tt+DZ/Qi0v64OvGCAmS18uq527i+kqWIMb8p
         8iS84lVpjtiuJBfHx6ZsLcGAnOjJJqwU6co7HX72ONhnmMM0aUtxgEajAEbXJ/Gt7dvt
         G4IJibGJ3+d+Zb+LbxRxOfW0eN5JZJhBJ289q5xv/UboHHaJEnO+emlclfDpcl4hZhB1
         GnaFe01GBqF2xZPJzbTYi4usMVK5ConIHPPkMkhztl8LVDPQqQLhZmOsIXWgQT+etneS
         T8nJ2qkICEgtGInm6NVnk8JNMD57FelgyaZDm54sKhb8FD45vZ670EIIHP925vR9c80P
         XP2A==
X-Gm-Message-State: AO0yUKWNEa3G9fHApI80s3JZ4k4k3YWisorCbjoLuLnTxhhsdo7fKtnW
        LmIXfsIOmEslWowFXg71j6SEYQjpzVPSTg==
X-Google-Smtp-Source: AK7set9eDfxDtnAU4+XBrjluNZ8+vxTrom6dCQjntDZEZQYHy12UouqiKx40BwESlt8EtAu+Ml65kvRn+GXshQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:a906:0:b0:52e:d2a7:1ba1 with SMTP id
 g6-20020a81a906000000b0052ed2a71ba1mr26322283ywh.1.1678846689933; Tue, 14 Mar
 2023 19:18:09 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:34 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-11-amoorthy@google.com>
Subject: [WIP Patch v2 10/14] KVM: x86: Implement KVM_CAP_MEMORY_FAULT_NOWAIT
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a memslot has the KVM_MEM_MEMORY_FAULT_EXIT flag set, exit to
userspace upon encountering a page fault for which the userspace
page tables do not contain a present mapping.
---
 arch/x86/kvm/mmu/mmu.c | 33 +++++++++++++++++++++++++--------
 arch/x86/kvm/x86.c     |  1 +
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5e0140db384f6..68bc4ab2bd942 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3214,7 +3214,9 @@ static void kvm_send_hwpoison_signal(struct kvm_memory_slot *slot, gfn_t gfn)
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, PAGE_SHIFT, current);
 }
 
-static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_handle_error_pfn(
+	struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+	bool faulted_on_absent_mapping)
 {
 	if (is_sigpending_pfn(fault->pfn)) {
 		kvm_handle_signal_exit(vcpu);
@@ -3234,7 +3236,11 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
-	return -EFAULT;
+	return kvm_memfault_exit_or_efault(
+		vcpu, fault->gfn * PAGE_SIZE, PAGE_SIZE,
+		faulted_on_absent_mapping
+			? KVM_MEMFAULT_REASON_ABSENT_MAPPING
+			: KVM_MEMFAULT_REASON_UNKNOWN);
 }
 
 static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
@@ -4209,7 +4215,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
 }
 
-static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int __kvm_faultin_pfn(
+	struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+	bool fault_on_absent_mapping)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -4242,9 +4250,15 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+
+	fault->pfn = __gfn_to_pfn_memslot(
+		slot, fault->gfn,
+		fault_on_absent_mapping,
+		false,
+		fault_on_absent_mapping ? NULL : &async,
+		fault->write, &fault->map_writable,
+		&fault->hva);
+
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4274,16 +4288,19 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			   unsigned int access)
 {
 	int ret;
+	bool fault_on_absent_mapping
+		= likely(fault->slot) && kvm_slot_fault_on_absent_mapping(fault->slot);
 
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = __kvm_faultin_pfn(vcpu, fault);
+	ret = __kvm_faultin_pfn(
+		vcpu, fault, fault_on_absent_mapping);
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
 	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_error_pfn(vcpu, fault);
+		return kvm_handle_error_pfn(vcpu, fault, fault_on_absent_mapping);
 
 	if (unlikely(!fault->slot))
 		return kvm_handle_noslot_fault(vcpu, fault, access);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b3c1b2f57e680..41435324b41d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4426,6 +4426,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_X86_MEMORY_FAULT_EXIT:
+	case KVM_CAP_MEMORY_FAULT_NOWAIT:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
-- 
2.40.0.rc1.284.g88254d51c5-goog

