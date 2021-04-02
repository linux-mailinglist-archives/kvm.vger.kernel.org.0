Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68560352D3F
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbhDBP60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbhDBP6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:58:14 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A75AC061788;
        Fri,  2 Apr 2021 08:58:13 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d191so2698327wmd.2;
        Fri, 02 Apr 2021 08:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5JxPWupbPkuZVCyDI6dt9FqT0pLLbnkcUSWIjCJmbc=;
        b=UwOkF0r38HQeXZIsZzBOqrUp/zcpHP11ci1dybIoYOJUhAY72Bw6xAlSz5ZK1QYGBN
         SidrGJurGoCbsHHmReweAXhaAsbAZBSzeX52nA4XcVZeQnXx8VNcr8y/vTxpaqFjwC7E
         1dugLFI9OEL6qTK+8+4o25AsTmH21oZnyevVRWTi4FL/oXZVPgrjzVokuekuzziXrc/9
         1+pKOjSl1mVU+yf9uPZOEuCzMsP8UP5tj/yP28RB7ay751D3Q3j1pRb36WBkeb5wzvQ2
         LZcSccpTZCL7txQDpsZrtYvDeotWy8oBs/q1JjrDQsBdJDxaZuDdgIXyMOHDsVszPYiW
         vk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=f5JxPWupbPkuZVCyDI6dt9FqT0pLLbnkcUSWIjCJmbc=;
        b=eVV1WrwPYJrtv89Ay35f0QLA0aPMMLr1g1XO2vhXwjNliWuUvrJRCL+joo6UI+ztHg
         FU0gOJmemZrB+jgwfB6LVq8Vvka8+0VQbLkk3oeXjfXYX5SulATgVkGL3p9540W6pjEC
         xM+lciCkcZKQwryuFgO8YOl9P8Ja4JPi75WHjNApJfb5zGVBCYcLhT2MudDb3ceIV4Iy
         Yfr8+TkyqOy4gTqjQZQCah4vb+smOsrSQsKO/C3Fd1yvF2hbWBrltFGvjzL4J9bsVngc
         HAxPGTFN3tZHNKotgxyZPJISKlZmf5XcuNXADKoWQLXz1wvl4QaCggTrpX/fc31G4wrz
         ZxZA==
X-Gm-Message-State: AOAM5307TKKkR9oz13IjWqLcMtFimQb9fnpL0fweDRd4ceh75wOGlwWR
        jf4RUh3+QMjRUZDmTyMomfG13DcqmU4=
X-Google-Smtp-Source: ABdhPJyS4AApX5w2jvyCJh/h/rDaFrY9VniIbGxQh7xDYuU67D0fVx2jG39QDnlzJSvFx3BJUUADuA==
X-Received: by 2002:a7b:c396:: with SMTP id s22mr13235458wmj.38.1617379092091;
        Fri, 02 Apr 2021 08:58:12 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w11sm2293625wmb.35.2021.04.02.08.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:58:11 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        seanjc@google.com, linux-mips@vger.kernel.org
Subject: [PATCH 3/4] KVM: MIPS: let generic code call prepare_flush_shadow
Date:   Fri,  2 Apr 2021 17:58:06 +0200
Message-Id: <20210402155807.49976-4-pbonzini@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402155807.49976-1-pbonzini@redhat.com>
References: <20210402155807.49976-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since all calls to kvm_flush_remote_tlbs must be preceded by
kvm_mips_callbacks->prepare_flush_shadow, repurpose
kvm_arch_flush_remote_tlb to invoke it.  This makes it possible
to use the TLB flushing mechanism provided by the generic MMU
notifier code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/mips/include/asm/kvm_host.h |  3 +++
 arch/mips/kvm/mips.c             | 11 ++++++-----
 arch/mips/kvm/mmu.c              |  6 +-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 6c8c0ab53be2..d0944a75fc8d 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -1142,4 +1142,7 @@ static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
+int kvm_arch_flush_remote_tlb(struct kvm *kvm);
+
 #endif /* __MIPS_KVM_HOST_H__ */
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 867b8de0fc07..4a22ba70c943 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -204,9 +204,6 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	/* Flush whole GPA */
 	kvm_mips_flush_gpa_pt(kvm, 0, ~0);
-
-	/* Let implementation do the rest */
-	kvm_mips_callbacks->prepare_flush_shadow(kvm);
 	kvm_flush_remote_tlbs(kvm);
 }
 
@@ -995,11 +992,15 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
 }
 
+int kvm_arch_flush_remote_tlb(struct kvm *kvm)
+{
+	kvm_mips_callbacks->prepare_flush_shadow(kvm);
+	return 1;
+}
+
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 					const struct kvm_memory_slot *memslot)
 {
-	/* Let implementation handle TLB/GVA invalidation */
-	kvm_mips_callbacks->prepare_flush_shadow(kvm);
 	kvm_flush_remote_tlbs(kvm);
 }
 
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 7e055e5dfd3c..2cedf908d744 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -490,8 +490,6 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 			unsigned flags)
 {
 	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
-
-	kvm_mips_callbacks->prepare_flush_shadow(kvm);
 	kvm_flush_remote_tlbs(kvm);
 	return 0;
 }
@@ -533,10 +531,8 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	int ret;
 
 	ret = handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
-	if (ret) {
-		kvm_mips_callbacks->prepare_flush_shadow(kvm);
+	if (ret)
 		kvm_flush_remote_tlbs(kvm);
-	}
 	return 0;
 }
 
-- 
2.30.1


