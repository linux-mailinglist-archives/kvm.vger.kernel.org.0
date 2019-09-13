Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8FEB174B
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfIMCqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:46:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:58608 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbfIMCqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159515"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2019 19:46:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
Subject: [PATCH 05/11] KVM: x86/mmu: Revert "Revert "KVM: MMU: add tracepoint for kvm_mmu_invalidate_all_pages""
Date:   Thu, 12 Sep 2019 19:46:06 -0700
Message-Id: <20190913024612.28392-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the fast invalidate mechanism has been reintroduced, restore
the tracepoint associated with said mechanism.

Note, the name of the tracepoint deviates from the original tracepoint
so as to match KVM's current nomenclature.

This reverts commit 42560fb1f3c6c7f730897b7fa7a478bc37e0be50.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c      |  1 +
 arch/x86/kvm/mmutrace.h | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8d3fbc48d1be..0bf20afc3e73 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5742,6 +5742,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
 	spin_lock(&kvm->mmu_lock);
+	trace_kvm_mmu_zap_all_fast(kvm);
 	kvm->arch.mmu_valid_gen++;
 
 	kvm_zap_obsolete_pages(kvm);
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index e9832b5ec53c..1a063ba76281 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -282,6 +282,27 @@ TRACE_EVENT(
 	)
 );
 
+TRACE_EVENT(
+	kvm_mmu_zap_all_fast,
+	TP_PROTO(struct kvm *kvm),
+	TP_ARGS(kvm),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, mmu_valid_gen)
+		__field(unsigned int, mmu_used_pages)
+	),
+
+	TP_fast_assign(
+		__entry->mmu_valid_gen = kvm->arch.mmu_valid_gen;
+		__entry->mmu_used_pages = kvm->arch.n_used_mmu_pages;
+	),
+
+	TP_printk("kvm-mmu-valid-gen %lx used_pages %x",
+		  __entry->mmu_valid_gen, __entry->mmu_used_pages
+	)
+);
+
+
 TRACE_EVENT(
 	check_mmio_spte,
 	TP_PROTO(u64 spte, unsigned int kvm_gen, unsigned int spte_gen),
-- 
2.22.0

