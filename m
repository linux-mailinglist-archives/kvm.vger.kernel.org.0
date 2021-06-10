Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897E33A3148
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhFJQsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:48:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231324AbhFJQsi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 12:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623343601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+02MYCb+xPyJgZIX6GIIlAJWBxzfjQ6ghtM+EVkoCOg=;
        b=ByORnI5IIjyyFy4V8bGCoI1E4QFs2c98eJ7ckB1BFuePvMDk9iA/VYlWEgkvk8/gxpdTcs
        giVJL2xmb6TcqehGC3L75ILmoXFgJzXrF34U+mVkciB97V5c6kp+zHFML2hJ2/PqjS2rmu
        wIAE8xYRXscoW/5KWOztsWHuxkhkMas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-YU_cvo0eOCKo1lGWKQrcLg-1; Thu, 10 Jun 2021 12:46:40 -0400
X-MC-Unique: YU_cvo0eOCKo1lGWKQrcLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F6061927806;
        Thu, 10 Jun 2021 16:46:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B565617C5F;
        Thu, 10 Jun 2021 16:46:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Jing Zhang <jingzhangos@google.com>
Subject: [PATCH] KVM: switch per-VM stats to u64
Date:   Thu, 10 Jun 2021 12:46:38 -0400
Message-Id: <20210610164638.287798-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make them the same type as vCPU stats.  There is no reason
to limit the counters to 64 bits.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h   |  2 +-
 arch/mips/include/asm/kvm_host.h    |  2 +-
 arch/powerpc/include/asm/kvm_host.h |  6 +++---
 arch/x86/include/asm/kvm_host.h     | 22 +++++++++++-----------
 virt/kvm/kvm_main.c                 |  4 ++--
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..d56f365b38a8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -556,7 +556,7 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 }
 
 struct kvm_vm_stat {
-	ulong remote_tlb_flush;
+	u64 remote_tlb_flush;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index fca4547d580f..4245c082095f 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -109,7 +109,7 @@ static inline bool kvm_is_error_hva(unsigned long addr)
 }
 
 struct kvm_vm_stat {
-	ulong remote_tlb_flush;
+	u64 remote_tlb_flush;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 7f2e90db2050..ae3d4af61b66 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -81,9 +81,9 @@ struct kvmppc_book3s_shadow_vcpu;
 struct kvm_nested_guest;
 
 struct kvm_vm_stat {
-	ulong remote_tlb_flush;
-	ulong num_2M_pages;
-	ulong num_1G_pages;
+	u64 remote_tlb_flush;
+	u64 num_2M_pages;
+	u64 num_1G_pages;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bbeb097cadd..94a60998926e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1165,17 +1165,17 @@ struct kvm_arch {
 };
 
 struct kvm_vm_stat {
-	ulong mmu_shadow_zapped;
-	ulong mmu_pte_write;
-	ulong mmu_pde_zapped;
-	ulong mmu_flooded;
-	ulong mmu_recycled;
-	ulong mmu_cache_miss;
-	ulong mmu_unsync;
-	ulong remote_tlb_flush;
-	ulong lpages;
-	ulong nx_lpage_splits;
-	ulong max_mmu_page_hash_collisions;
+	u64 mmu_shadow_zapped;
+	u64 mmu_pte_write;
+	u64 mmu_pde_zapped;
+	u64 mmu_flooded;
+	u64 mmu_recycled;
+	u64 mmu_cache_miss;
+	u64 mmu_unsync;
+	u64 remote_tlb_flush;
+	u64 lpages;
+	u64 nx_lpage_splits;
+	u64 max_mmu_page_hash_collisions;
 };
 
 struct kvm_vcpu_stat {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fc35ba0ea5d3..ed4d1581d502 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4833,14 +4833,14 @@ static int kvm_debugfs_release(struct inode *inode, struct file *file)
 
 static int kvm_get_stat_per_vm(struct kvm *kvm, size_t offset, u64 *val)
 {
-	*val = *(ulong *)((void *)kvm + offset);
+	*val = *(u64 *)((void *)kvm + offset);
 
 	return 0;
 }
 
 static int kvm_clear_stat_per_vm(struct kvm *kvm, size_t offset)
 {
-	*(ulong *)((void *)kvm + offset) = 0;
+	*(u64 *)((void *)kvm + offset) = 0;
 
 	return 0;
 }
-- 
2.27.0

