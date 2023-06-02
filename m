Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC472075A
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbjFBQU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbjFBQUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:20:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C522DB4
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:20:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8337ade1cso3117342276.2
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722802; x=1688314802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jB6mZ6+sZkvbswM4H6nQ7omw8CujCnjIDUHOjQN9Lak=;
        b=WzG81VZ+IOZZWpA5d8GyyFB+GNO5rd59XBOMZDWSQkbTFSpgSDMeCniff6+7OHEij5
         6hoTs84id29QOXjOw8EHoZcr4T/0ZYFYEFe944xT/JJ+tF9azU/Cuirs/Pg7/Q2L7Xpt
         Hq8OKt/J6F5RePSKWMF5TvjkErofFJ4JT6hlxyRWSfFhkQLu+zptKjem6S1xudWoMoSO
         G7hp297qXl4sRDf1NkyFEEZysCmJrGxmUW4a79PFknUySCy8Dm2g/bW4ST5IKz9IXg/M
         jBH17KffIsGU6XV+UNRoQBPgrqaSlxHp1aoOr9WN04DdPMDQTnEZoiXXPrCCrrMOMWbA
         mYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722802; x=1688314802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jB6mZ6+sZkvbswM4H6nQ7omw8CujCnjIDUHOjQN9Lak=;
        b=DN780zCWA1QDEGbiJxo+ghFhYzLg4TqXxsOpAIU+ypxIcj+xbtsl++tmY2EX9Z2FFq
         ux3oSufj4kl7FgE8des3DNxfHNoDsqRXgWguCOs9xfdDvWYvxgXKCB1WiWw+k828Bkpt
         uPUrRAQ+evArtBJjM5J3sKs+x8wg9iAHumpEXjsrgra7SfGiicCtEq94Mn40+1GIRPTf
         J0zzMSGtdoKkYE8lGiuXsm8xaur/iQWR1hZ8bIcOhUlqf0fpp1lIrCRtEsrjAImwtHed
         xppnFUbJmSdRt5A4RVH7Sofuot7N52yprl8hACjdx4loKOBQ0Uj2jgV+FiU8/GqV/U+n
         Affw==
X-Gm-Message-State: AC+VfDxjT/ck/txeQKsXyoHtWrOMYHhAzhFBDF7UHZWvaCY+OayCnNW1
        FPXNRJGQYb6OvChdCK9tzez/RtNHYqSj9A==
X-Google-Smtp-Source: ACHHUZ5CZs2sEm/aP6c7Rto4UGYg7s6RPhTIofLLjydHszjo7abjQfyJ+FalU2Ytv3XZVw4SIwBatK59S9rkfQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:e706:0:b0:bac:5d2c:844b with SMTP id
 e6-20020a25e706000000b00bac5d2c844bmr1317036ybh.8.1685722802127; Fri, 02 Jun
 2023 09:20:02 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:16 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-12-amoorthy@google.com>
Subject: [PATCH v4 11/16] KVM: arm64: Implement KVM_CAP_NOWAIT_ON_FAULT
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

Return -EFAULT from user_mem_abort when the memslot flag is enabled and
fast GUP fails to find a present mapping for the page.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/arm64/kvm/arm.c           |  1 +
 arch/arm64/kvm/mmu.c           | 16 +++++++++++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aa7b4024fd41..8a1205f7c271 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7783,7 +7783,7 @@ bugs and reported to the maintainers so that annotations can be added.
 7.35 KVM_CAP_NOWAIT_ON_FAULT
 ----------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: -EINVAL.
 
 The presence of this capability indicates that userspace may pass the
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b34cf0cedffa..46a09c4db901 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -235,6 +235,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_NOWAIT_ON_FAULT:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3b9d4d24c361..5451b712b0ac 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1232,6 +1232,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	bool exit_on_memory_fault = kvm_slot_nowait_on_fault(memslot);
+	uint64_t memory_fault_flags;
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1325,8 +1327,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, exit_on_memory_fault, false, NULL,
 				   write_fault, &writable, NULL);
+
+	if (exit_on_memory_fault && pfn == KVM_PFN_ERR_FAULT) {
+		memory_fault_flags = 0;
+		if (write_fault)
+			memory_fault_flags |= KVM_MEMORY_FAULT_FLAG_EXEC;
+		if (exec_fault)
+			memory_fault_flags |= KVM_MEMORY_FAULT_FLAG_EXEC;
+		kvm_populate_efault_info(vcpu,
+					 round_down(gfn * PAGE_SIZE, vma_pagesize), vma_pagesize,
+					 memory_fault_flags);
+		return -EFAULT;
+	}
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
-- 
2.41.0.rc0.172.g3f132b7071-goog

