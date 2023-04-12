Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D506E0105
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDLVfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjDLVfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5865E7A84
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c67-20020a254e46000000b00b88f1fd158fso29214248ybb.17
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335331; x=1683927331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oBWUDJru52jdEOiurtVr+EjXu6VveYkIMdfENGYuqF4=;
        b=5Ov5+ZRfva2c/yhjYr6uvNwVs19NXcF+87yc5OV+Twmw1QDkz0RDskvnZST3sAoaOa
         2DLJh3OJcPj62W7lWGXrhBgFBBN2ym5EzdxJy5WNiNWrRhDCQ7O9J4sD3IdsSDHkNkXH
         IlWrqpFtk2bhPyl/fjbcuDlyAw9LBNJtjlC4/XKTUmyPx+21UfU5rIDVX+W5CyqAo7OS
         gCrK6y4+iCGyxDx3qAIagEau4i7Q7ALYo2KpLBHy09J7o1/ugwnLzj5u7JBFxpuMMCcF
         35wLNLvY8wChWZBVKEsf6irGy49x6q/APUlPlzGWacJC0sJ+CAjiGjEWDZ7ty6c3fUT1
         QQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335331; x=1683927331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBWUDJru52jdEOiurtVr+EjXu6VveYkIMdfENGYuqF4=;
        b=GUzLXObp272/ZR1jf0t32P1mcbHrioqbzmrDhgLjj5Nz2NQM32rE/fYIRwkfMyweeJ
         9GlYV7aO0uUg3159zgqCuXbN3koU64kWSYmIBV124zxGqE9MXU4A0Rrb8RmGgOsJMpW6
         G3koattla0hkIeNItQhoALKl2icRyypjoYIqS1bMluflhERShHieK13DgTj+AXb4m1bO
         CtgJHGu8ylUnbwemipgUJDRmg30BVyhLBiAk1asg/L7qyN1D3ZjBPFpZK1J0XTcZNs1m
         EZSuFC1Ob72ISwyPkgAC0YBfA6GxYR6wxbxT/ju+TyeD8WTgPkq0FUpMPlITBT6a6y0K
         qxJA==
X-Gm-Message-State: AAQBX9cSufaWNlDB5yvcmH6sDPIIZgJI07l9jgn1L2kdJ+qG7w8ifVBk
        vwHJYt72rbAjLhuTcNGPl1RxcsefkegUbQ==
X-Google-Smtp-Source: AKy350Z1Hz16awnvahWD8mb/lMbNByADtMsMOxZyj1zA+7AE5/pqJYBUSB/Hd6Gwg+5ip516oAEqf4bZn9oW7Q==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:ae1d:0:b0:54f:84c0:93ff with SMTP id
 m29-20020a81ae1d000000b0054f84c093ffmr3294464ywh.5.1681335331269; Wed, 12 Apr
 2023 14:35:31 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:35:06 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-19-amoorthy@google.com>
Subject: [PATCH v3 18/22] KVM: x86: Implement KVM_CAP_ABSENT_MAPPING_FAULT
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

When the memslot flag is enabled, fail guest memory accesses for which
fast-gup fails (ie, for which the mappings are not present).

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/x86/kvm/mmu/mmu.c         | 17 ++++++++++++-----
 arch/x86/kvm/x86.c             |  1 +
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7967b9909e28b..452bbca800b15 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7712,7 +7712,7 @@ reported to the maintainers.
 7.35 KVM_CAP_ABSENT_MAPPING_FAULT
 ---------------------------------
 
-:Architectures: None
+:Architectures: x86
 :Returns: -EINVAL.
 
 The presence of this capability indicates that userspace may pass the
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d83a3e1e3eff9..4aef79b97c985 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4218,7 +4218,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
 }
 
-static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,
+				struct kvm_page_fault *fault,
+				bool fault_on_absent_mapping)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -4251,9 +4253,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn,
+						fault_on_absent_mapping, false,
+						fault_on_absent_mapping ? NULL : &async,
+						fault->write, &fault->map_writable, &fault->hva);
+
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4287,7 +4292,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = __kvm_faultin_pfn(vcpu, fault);
+	ret = __kvm_faultin_pfn(vcpu, fault,
+				likely(fault->slot)
+					&& kvm_slot_fault_on_absent_mapping(fault->slot));
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3e9deab31e1c8..bc465cde7acf6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4433,6 +4433,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_ABSENT_MAPPING_FAULT:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
-- 
2.40.0.577.gac1e443424-goog

