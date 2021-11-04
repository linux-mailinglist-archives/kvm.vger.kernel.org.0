Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15215444C6B
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhKDAa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhKDA3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:29:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7223FC061203
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:26 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u10-20020a170902e80a00b001421d86afc4so1535804plg.9
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Rh/p9dCBzSE6gfhoLM6qA42nAbGkMHfvz+ihOHus8Bw=;
        b=a0LysDSixF+SvGFoYJAn+9lReuNdeuojzCYwE/5S80HnosejUJ/GB5lSTi0I0B6etw
         PCesr77PK5UoG4qbBnDDmbOplfKjJvN0RSVwwsJ9A6TMfI9nydou7MxD9T7lOeaglEHG
         XNiJ9e6EtswDVfj8NbPNGs3K4UVClUfWt61l+WfszqPbkc9k/eRztWPGJiIa05+786xW
         gJ3qi2D5CO9qdvRG06/gp2Sn2Z2tyJIgyiWYmMzoSHEsDwT7XcmXrmm49tOMjj1utuxC
         5Wr/o1J29XTmPql9v7HTGvlM7g8HATHgYxp+e4CAJr75tfOZ82uzZSP74HenxJ6CsJu8
         wJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Rh/p9dCBzSE6gfhoLM6qA42nAbGkMHfvz+ihOHus8Bw=;
        b=EfrdpvJsBNeY4b4yQtxG2BdLQTYqXLkF+LklautCKfSA2bPbZccwE80RWigPs78ZhT
         2AJZmc2eWcp7Dm6z/RcX+xsp/erULGLVkAvqgSNyuzttjWyNz+WHsPJsvabHPamH+mXU
         aAlv282D7IUQiJzTYhSgrf2HiW7Gx1d4Mkw+F1dktiSPAQVMGaJ5QAVlVkkWgnvZ5CIB
         /FCBvg59RLaQrLQe0vV2PkzFbwEXArXLE0Ugkdf+keA4I4hrnla4Bt5ypXn8KZo2VBOT
         NhqvN9fqmLAz9RH5RZNcjOAu5o4vChuPwbJAE4NAr+w/oKYtSlfwIFfoZlXiHabzlZLq
         fqnQ==
X-Gm-Message-State: AOAM533NdvECVwu/6FRhuBWYGAfZjSWQO7tkJfpZPQm6zZO7biMHHA/t
        QT0KYV+L58e7Ahfxpam6iQFM6Edl4KE=
X-Google-Smtp-Source: ABdhPJyOWq98exFdSMvxgt0VGjIuS13MnOJ47QLgbIC6Hkpi6D0S+Boi55mGWksr+QgQdfajOLURjR0xq4c=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e8d1:b0:141:de15:f596 with SMTP id
 v17-20020a170902e8d100b00141de15f596mr25033911plg.67.1635985585858; Wed, 03
 Nov 2021 17:26:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:17 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-17-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 16/30] KVM: x86: Don't assume old/new memslots are
 non-NULL at memslot commit
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Play nice with a NULL @old or @new when handling memslot updates so that
common KVM can pass NULL for one or the other in CREATE and DELETE cases
instead of having to synthesize a dummy memslot.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 80e726f73dd7..80183f7eadeb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11762,13 +11762,15 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     const struct kvm_memory_slot *new,
 				     enum kvm_mr_change change)
 {
-	bool log_dirty_pages = new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 old_flags = old ? old->flags : 0;
+	u32 new_flags = new ? new->flags : 0;
+	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
 
 	/*
 	 * Update CPU dirty logging if dirty logging is being toggled.  This
 	 * applies to all operations.
 	 */
-	if ((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)
+	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)
 		kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
 
 	/*
@@ -11786,7 +11788,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * MOVE/DELETE: The old mappings will already have been cleaned up by
 	 *		kvm_arch_flush_shadow_memslot().
 	 */
-	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
+	if ((change != KVM_MR_FLAGS_ONLY) || (new_flags & KVM_MEM_READONLY))
 		return;
 
 	/*
@@ -11794,7 +11796,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
 	 * logging isn't being toggled on or off.
 	 */
-	if (WARN_ON_ONCE(!((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)))
+	if (WARN_ON_ONCE(!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)))
 		return;
 
 	if (!log_dirty_pages) {
-- 
2.33.1.1089.g2158813163f-goog

