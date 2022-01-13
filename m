Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E88F48E02B
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 23:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbiAMWSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 17:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbiAMWSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 17:18:42 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE178C06161C
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:18:41 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id c10-20020a63a40a000000b0034afd8ee07aso672429pgf.17
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pwLxSdkuKZYpy4IRCx6ewNb1syHurmpU9IGNHdDfbA0=;
        b=rD/769dvm1H1BTBbwgghKhX4b92nzIRCaIKmcrnh4WzVQqJEJBcWRfps+7N2g3HS+x
         Hy6ldB/NJYp0mPLSelkO9odPUHLDQ4ezsgpdKG8ybPdGy+ImlE1nHVSVm5KK6N/hkZgI
         WhAomOtbRIW3OHpMw+aTJfyEJ8cPRkCkBWSOyVG3mVbCfSc9HeIbdCWfgQRdtUuEqLOu
         Pbf+E3VJebX0n1aj2hyLkZhd3hNnhS/HnpsI1LP0SQOFNSlugXkWSTE2nxjhl+m39/lY
         eg0xg55XHbxkeHCrqbXOA7mW/d6QDD2WjXELdxPvN27vD5d4wJMjlwzJNcYSeHT5O9wL
         W4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pwLxSdkuKZYpy4IRCx6ewNb1syHurmpU9IGNHdDfbA0=;
        b=MXIuahsk/oooijVOt/dB2HaNgW789vU4KyJIy+qDX4Tnk2qgskN0WJbOpvTMjIQyaq
         4Tx1JJFmaEiKLF+gkIa+Z3IvH2dWDtBwCgxW19ynMrefXC/PjEQgO9pCV/zz5DN9OrAN
         gbGjgMt4rAxX9xiZxNajD0aivO/ixj4twzASQTEi6/PY7Wdz5cQmMboueeg7KjCe7Okj
         OF5xwXWe5G0FTpLmmGgIj8RImlbE1Qb2MjKDgmkyKTMmlCpkGm17OFKLVYKjM2wsM5Q2
         Hu9qYtwNdoFG7VX9p4PRxJTBtindgxmzJb6pQ3GIxzTix1hvadM4zaYJ7c5wm6mR5/6T
         jL4Q==
X-Gm-Message-State: AOAM533kzxEEjG0aVzx1rHCtf9Y/c6EMjBFjiyohexYlzLLsgQYNEXya
        /HIZYc1GCBY77leW0QKZ+lo775Jf973wSLvOq2Uwis9z0dXA8k1w0v14/N3VmlL17jovQPjWlLW
        VTa24nhr47/6XU+OFwhBNqTyUCF14PSpggsKR+MzrGgrVv2XzOlkjOKFqwrGKqEaXPz9HBtk=
X-Google-Smtp-Source: ABdhPJwsvrCgSfYRR7e1YNmhGpuBRd1yPxOOJCRdr2s7Im0Et+POYfDI17crL/39sHPbnMnwBxTx4LLYYBN8+iJeMg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:c102:b0:14a:8aef:8897 with
 SMTP id 2-20020a170902c10200b0014a8aef8897mr2252771pli.155.1642112321293;
 Thu, 13 Jan 2022 14:18:41 -0800 (PST)
Date:   Thu, 13 Jan 2022 22:18:28 +0000
In-Reply-To: <20220113221829.2785604-1-jingzhangos@google.com>
Message-Id: <20220113221829.2785604-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220113221829.2785604-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v1 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To reduce MMU lock contention during dirty logging, all permission
relaxation operations would be performed under read lock.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/mmu.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cafd5813c949..15393cb61a3f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1084,6 +1084,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	bool use_mmu_readlock = false;
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1212,7 +1213,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	write_lock(&kvm->mmu_lock);
+	if (fault_status == FSC_PERM && fault_granule == PAGE_SIZE
+				     && logging_active && write_fault)
+		use_mmu_readlock = true;
+	/*
+	 * To reduce MMU contentions and enhance concurrency during dirty
+	 * logging dirty logging, only acquire read lock for permission
+	 * relaxation. This fast path would greatly reduce the performance
+	 * degradation of guest workloads.
+	 */
+	if (use_mmu_readlock)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1271,7 +1284,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	write_unlock(&kvm->mmu_lock);
+	if (use_mmu_readlock)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
-- 
2.34.1.703.g22d0c6ccf7-goog

