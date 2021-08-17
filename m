Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9975E3EE0E2
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 02:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhHQA10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 20:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbhHQA1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 20:27:25 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE03FC061764
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 17:26:53 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 2-20020a17090a1742b0290178de0ca331so13763126pjm.1
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 17:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GmFYFWgSJqnYvi5uzE7wopljyXsB3O7OfGsKWKCJGuY=;
        b=b4f1FMtWLjJ9VYPvJ9oT6EDEBvLQnL/BGyFRDQvrfDTfhb/IPPcBSbd2AzesdLwfxg
         bxUJuh3+aPqAi8foBEiinZTVoFhUv176g47LSxpy9liUchTLJS9ngNH4whJOedOlHVTZ
         8Uvq00WwgvyiWrrWjeESLEcjTBevgNer8H7o2acqcvKM7ZHizu6tzw2EuOC/4HvamaRq
         0f6W98eLb2ofHtM1vizH8yxC7vt5oLiyCDEWUFE6qi0w5T+G9fyc5IDG7DwL3kw/rCKM
         zmrv739kbhLM5gPECbcHsF2HwQp0SgyKQwe/guyHZBFK0EAKNWGHtZZDTsOvlDPAA8Cx
         iYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GmFYFWgSJqnYvi5uzE7wopljyXsB3O7OfGsKWKCJGuY=;
        b=Iv6hTWfhNcyokSLpwK4FfUS4cg6gIzHgpRqKMSkp3RHxFSPuhvnelM3w6IVJUWbJHM
         yUlFST9rZjxGzGvdsjx/aPr8VUiXoKp27vjDKiBbn0rqAe/9rSKnUJivRMOz3e+wHgLj
         WJbYfpo4/6R/17VTIseRu7rJEfkIql3PunRaNNBOhzzDVJ3qSwyPmANPN1EA/qFx7d+d
         EunmXCPgjxUHcXdFTnrtUhCFnV67tlgXcdYj5x+A7ELfqaxOdE7dfAA8zW3dNBiDLHs8
         jLZWS882E90KUudNFosHmnz3bsZwEkX+fUJK6DhSYqZQRDJBgfZZ8fN+CrjvhtmznuI8
         I2AA==
X-Gm-Message-State: AOAM532j9o/1iSSF7DqTJPj7q8ORqjRBjmG49Mx64wPA3w/Iokcmp9sj
        V8T9dC1AQoNEDbq1jWLQ6lBgnoqupslWwyXogdKaMq/On7nDCBw3KaqskTHYbbg6ixVMguw+WM/
        0iMPJYM4uI3ZAwHRBJeIQbvLMHFDGtlto4brbwaUB9TonbCZBJUftR1lWFahFKxJASzkJCQ4=
X-Google-Smtp-Source: ABdhPJyFaF0EVkxwXDmU6xb8bee1RXFu3kmq7woIq1DfWxoQUoXXuCJt0ujRSFs/vD/RyaMoFKYq5CC/RLU8ApIr4Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:cec3:b0:12d:92c4:1ea6 with
 SMTP id d3-20020a170902cec300b0012d92c41ea6mr563343plg.36.1629160013007; Mon,
 16 Aug 2021 17:26:53 -0700 (PDT)
Date:   Tue, 17 Aug 2021 00:26:39 +0000
Message-Id: <20210817002639.3856694-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH] KVM: stats: Add VM stat for remote tlb flush requests
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new stat that counts the number of times a remote TLB flush is
requested, regardless of whether it kicks vCPUs out of guest mode. This
allows us to look at how often flushes are initiated.

Original-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/mmu.c      | 1 +
 include/linux/kvm_host.h  | 3 ++-
 include/linux/kvm_types.h | 1 +
 virt/kvm/kvm_main.c       | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0625bf2353c2..f5bb235bbb59 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -80,6 +80,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
+	++kvm->stat.generic.remote_tlb_flush_requests;
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d447b21cdd73..27cb69e564cb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1444,7 +1444,8 @@ struct _kvm_stats_desc {
 		KVM_STATS_BASE_POW10, -9, sz)
 
 #define KVM_GENERIC_VM_STATS()						       \
-	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
+	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
+	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush_requests)
 
 #define KVM_GENERIC_VCPU_STATS()					       \
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),		       \
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index de7fb5f364d8..2237abb93ccd 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -80,6 +80,7 @@ struct kvm_mmu_memory_cache {
 
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
+	u64 remote_tlb_flush_requests;
 };
 
 struct kvm_vcpu_stat_generic {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..26b77ab98a04 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -318,6 +318,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	 */
 	long dirty_count = smp_load_acquire(&kvm->tlbs_dirty);
 
+	++kvm->stat.generic.remote_tlb_flush_requests;
 	/*
 	 * We want to publish modifications to the page tables before reading
 	 * mode. Pairs with a memory barrier in arch-specific code.

base-commit: a3e0b8bd99ab098514bde2434301fa6fde040da2
-- 
2.33.0.rc1.237.g0d66db33f3-goog

