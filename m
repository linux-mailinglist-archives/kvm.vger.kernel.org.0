Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB316AD5D9
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCGDqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjCGDqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:46:18 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59FE460B3
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 19:46:08 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e195-20020a25e7cc000000b00a1e59ba7ed9so12728226ybh.11
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 19:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN3sAgatY30dvS/hR4J9z2QVjgT8HvsLL4dUuJImQN8=;
        b=dAK6HETYeiYyond2AcQHrqGNItpAGjAxFodehdXpS0NSXe0LhO1tQRuhGDxUTLkj9c
         XLl9Jrkl5zjP3BlHNlbuGOfg57xfWfUU+nDEU29k8WZcrGPiIqTqhl7p3dlDBNZAkRyt
         2OdJWN38OBvXHQuBrMRr/71cvhTqRzaFxDrIaTYkC+F44z3RGpgwkvinNFnAa7qQ+ZLk
         sAeGXYEn0FYujWYUS0ycmOwjOPCOmv7Pi4jxikYP7aS1G4zCgW3sYmDnyZnKCJeqtmHX
         Fco+wrGTp+Qq40vEh8u0uKi0V99TasPxChnTEV85w2w2RyezJBH+n6pEohyteS4iqmom
         44pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN3sAgatY30dvS/hR4J9z2QVjgT8HvsLL4dUuJImQN8=;
        b=szjvb/aPorgiH8hdQ6qrpa/gKHdFv9ojrzyGQfN48Akx7uV45L3tNrk+4rZYIj/bQL
         lZayZ/uGDysnOOnFkXTiuk30FhX+4l3P1ivuYRcNGG726jlO2dJtajrVxkRc0oTJqwSL
         EMIsaopEp6lS2ajLfKmYkO557YIkWrhvi5c8poIWUhje+2sDP/jou0AiruqHgW/1CYMi
         jV8LAzmcaWk6uSr4Eii/9OpBn+cRVIYU7GoDxUhM92ACaK0WtYfcuZ+Rb3BhX8De7+Z4
         r65xqiZecNTugq1YxB/QmeIEMFkhTjE0pjObXXBbEQhODCKY0wx3bALlhJUf+V94wdQp
         +orA==
X-Gm-Message-State: AO0yUKX8Kd0/FE0NbE+nr0LkyRhBJLqAKyrxIi02d01Wif0ujw5DRqcG
        ENnD11OtlkXLu0JC+LW6OvxLiZ5+l2awsQ==
X-Google-Smtp-Source: AK7set8ee95We8gb4rYyXJWSKJuRj4FB8E8hjjSXq3ql7PAhVhxEmqmhoG9N1QXJ7pfXVYz0MboxUFHbRuwhsw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:b243:0:b0:52e:d380:ab14 with SMTP id
 q64-20020a81b243000000b0052ed380ab14mr6675889ywh.3.1678160768167; Mon, 06 Mar
 2023 19:46:08 -0800 (PST)
Date:   Tue,  7 Mar 2023 03:45:49 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-7-ricarkol@google.com>
Subject: [PATCH v6 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
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

Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
future commit will add some more things to do inside of
kvm_uninit_stage2_mmu().

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 1 +
 arch/arm64/kvm/mmu.c             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 083cc47dca08..7d173da5bd51 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -168,6 +168,7 @@ void __init free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
+void kvm_uninit_stage2_mmu(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 37d7d2aa472a..a2800e5c4271 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -767,6 +767,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return err;
 }
 
+void kvm_uninit_stage2_mmu(struct kvm *kvm)
+{
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+}
+
 static void stage2_unmap_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
@@ -1855,7 +1860,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_uninit_stage2_mmu(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

