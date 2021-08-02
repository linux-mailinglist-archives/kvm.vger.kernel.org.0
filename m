Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB0A3DDF3E
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhHBSd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:33:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231167AbhHBSdz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PkDhCDhsOamlo5EjAL2H44dG3irxXE0SxvQCRWziXwI=;
        b=CiuKz8h7ubgYCEQlLGwogH63ZTmLj93+1rymP6bMdVh/EHNQGpjIqTFMZZLmd0F1B1bpmF
        fNCCzmTWJPUFmkDXut+HvuWHRe7hwzWXWrnNB/MU7nofgQyByZI9LereigPPGnkAqryRjm
        I9io9t4uTrubSrJpDObqTojZJ2GJCK8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-k0zjZcpmMiq4gMe972eiYg-1; Mon, 02 Aug 2021 14:33:43 -0400
X-MC-Unique: k0zjZcpmMiq4gMe972eiYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E17A10066E5;
        Mon,  2 Aug 2021 18:33:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A44DD3AE1;
        Mon,  2 Aug 2021 18:33:38 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 02/12] KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range
Date:   Mon,  2 Aug 2021 21:33:19 +0300
Message-Id: <20210802183329.2309921-3-mlevitsk@redhat.com>
In-Reply-To: <20210802183329.2309921-1-mlevitsk@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index 9d78cb1c0f35..9da635e383c2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5640,6 +5640,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	write_lock(&kvm->mmu_lock);
 
+	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
+
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 			slots = __kvm_memslots(kvm, i);
@@ -5671,6 +5673,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	if (flush)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
 
+	kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
+
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d6b4ad407b8..962e11a73e8e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -985,6 +985,11 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
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
index a96cbe24c688..71042cd807b3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -608,7 +608,7 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
 }
 
-static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
+void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
 				   unsigned long end)
 {
 	/*
@@ -636,6 +636,7 @@ static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
 			max(kvm->mmu_notifier_range_end, end);
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_inc_notifier_count);
 
 static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
@@ -670,7 +671,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	return 0;
 }
 
-static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
+void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
 				   unsigned long end)
 {
 	/*
@@ -687,6 +688,8 @@ static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
 	 */
 	kvm->mmu_notifier_count--;
 }
+EXPORT_SYMBOL_GPL(kvm_dec_notifier_count);
+
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
-- 
2.26.3

