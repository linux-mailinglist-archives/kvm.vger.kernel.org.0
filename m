Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8DC3E84B4
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhHJUxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:53:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234014AbhHJUxl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36oeem5A3ecI31S3fpl+d3D0Ltu4QFNRKLubSg9pAj0=;
        b=MlAdgrrBqowiVun9UovI9sYvAfqkOCqqG7beLE+W4M7qgfmEE3F5PC99RBuhQ5LLuF2N7y
        UIyGr20EVspM921JjnHvI662ZKXWPwvmZ+pPAErkHUmJOejCBznnkZXnTT8EU+M5LU2e4n
        UhnRi3rL6ieWXsHK8/d268qVRcBkzP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-kWGiKowEOda_GaMFm-vp-A-1; Tue, 10 Aug 2021 16:53:17 -0400
X-MC-Unique: kWGiKowEOda_GaMFm-vp-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E17F100CF71;
        Tue, 10 Aug 2021 20:53:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D1015B4BC;
        Tue, 10 Aug 2021 20:53:09 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 04/16] KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range
Date:   Tue, 10 Aug 2021 23:52:39 +0300
Message-Id: <20210810205251.424103-5-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This together with previous patch, ensures that
kvm_zap_gfn_range doesn't race with page fault
running on another vcpu, and will make this page fault code
retry instead.

This is based on a patch suggested by Sean Christopherson:
https://lkml.org/lkml/2021/7/22/1025

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   | 4 ++++
 include/linux/kvm_host.h | 5 +++++
 virt/kvm/kvm_main.c      | 7 +++++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d4e22a9635a9..abaf8e661c61 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5660,6 +5660,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	write_lock(&kvm->mmu_lock);
 
+	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
+
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 			slots = __kvm_memslots(kvm, i);
@@ -5695,6 +5697,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	if (flush)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
 
+	kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
+
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f50bfcf225f0..4e43843fe0d7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -991,6 +991,11 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 #endif
 
+void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
+				   unsigned long end);
+void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
+				   unsigned long end);
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a438a7a3774a..46f55e860b8b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -610,7 +610,7 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
 }
 
-static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
+void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
 				   unsigned long end)
 {
 	/*
@@ -638,6 +638,7 @@ static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
 			max(kvm->mmu_notifier_range_end, end);
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_inc_notifier_count);
 
 static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
@@ -672,7 +673,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	return 0;
 }
 
-static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
+void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
 				   unsigned long end)
 {
 	/*
@@ -689,6 +690,8 @@ static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
 	 */
 	kvm->mmu_notifier_count--;
 }
+EXPORT_SYMBOL_GPL(kvm_dec_notifier_count);
+
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
-- 
2.26.3

