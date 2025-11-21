Return-Path: <kvm+bounces-64264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 170F4C7BDFF
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 23:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29DF33A8433
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D37730C613;
	Fri, 21 Nov 2025 22:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QV8haDhH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D496F30594F
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 22:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763764492; cv=none; b=DjsTQ7ogt9zNmHFotwBI5jE5iozDZ00S4J2BSwJtB3/ZVwxLvu8KZ18v0Z/VIeT8c9dolpDyHtoKbo2PhP57XM3PvmCLDxqjdqa33M/iDQaHDyeVSuZKnuOtCh/Rty1YJYmyJAqq94+R32zmXYIqfBD5vWwyHC9+AwoMuTQozMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763764492; c=relaxed/simple;
	bh=e7RsKRdyXzqO8wbi+wGlXN2nJr4pNMDA7BM2zx30F3k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zg8ZN4C7J4eA7BQFme9yBkXtgHPrDNYZiNIfeGCNvMOORdSek2pn8Fcu8BhJlWUSmUZh3ioV2vpk3meLg31V+8Ow6x96KmZsloVD2ur3qAnHk0royUap2cTxaj75JGHmxnJlbmVPjR2jWdoPtBbxzgpAsjDaAAFRX8AWPdF3frk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QV8haDhH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3416dc5754fso5829592a91.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763764490; x=1764369290; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gYfQkN9u3Ku3wBXo81BUiJiwGWW8HyZzPi7J/C1YrKM=;
        b=QV8haDhHD7JsqWAb1z9mCVdTnCOB2VASdXY+Kfbds9JPhzUm/wT7VD+E0WiHqmiJO1
         QSTo9GQkIYlT4kzTpyAiQl1UvEzsGCYwsMbQLH+09KwJDI8RNULY58JZN+9IY1EOc2eB
         pCU2i+JNP1XJdk0BFxzeecheVZ/LY0zM6b1y33kkfwre0NtTVD6dFYNx0fvK6hCPXpuW
         xvDP+NGITmXlM5k7Ew76ND0FYsOE16OowaSMpdkkpe0C5tfXTHA7cHJ0wdqaZDPT1M/T
         zh2qMwOfFxQ3UZDxI6vw9LbKJDtPDx3wK8LPNc1Q2BwnoDBv7Q20sxn9FODidkd1LsI8
         3L0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763764490; x=1764369290;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gYfQkN9u3Ku3wBXo81BUiJiwGWW8HyZzPi7J/C1YrKM=;
        b=Zz0zcvmCuilcPJclvSPyGZvEdLghMCOd1p3JpqbCIxF5wthTyTO8AvapGstmHJw2FR
         mMgVYbfN1JB8jzcwDChi0P95Q6S/ROKw3/293cx8o0pSOaNYr83InRoj8CW1uUcswG9K
         tZ5ODd84zx8vYxITagPQb/tsZiuBOynWGujqwQUiTUkbEOXCs72RD3qXcP3WYsj4etCM
         tQno30CB7dTRbi6kqemRy4os5YwU8RxCLrxfbY5jYQSYJGeWgJM3CNyakgBedp3w4Tqv
         nkCL/5foFg4fmTnB62ZnutgPLayuf/8COgwZ0xK0OcIHPLThsNyDfMc3Pkf0Ri7P4xLp
         eNZg==
X-Gm-Message-State: AOJu0YyKsBXtfLV2MURWi6tFCJEprmYVv2lQRpBgSH021+A3SGPG9q2x
	jGUwTIpBGV14Zu9tqfiaAyTRptCBQGDWVr3XwU6PPbLjQRTulbfaAOJ9cTVlXYBHekRBextvyFF
	9TSE0lw==
X-Google-Smtp-Source: AGHT+IEXbv9Rr9ebIprQdREDYFBXea2fQri7goRi056aI0TCciVMQ60b3yFhHrSpldN7RkxINC1QgCbQAYU=
X-Received: from pjuk6.prod.google.com ([2002:a17:90a:d086:b0:339:ee5f:ec32])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270d:b0:340:2a16:94be
 with SMTP id 98e67ed59e1d1-34733e5524amr4367353a91.4.1763764490156; Fri, 21
 Nov 2025 14:34:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 14:34:41 -0800
In-Reply-To: <20251121223444.355422-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121223444.355422-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121223444.355422-3-seanjc@google.com>
Subject: [PATCH v3 2/5] KVM: x86: Mark vmcs12 pages as dirty if and only if
 they're mapped
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fred Griffoul <fgriffo@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Mark vmcs12 pages as dirty (in KVM's dirty log bitmap) if and only if the
page is mapped, i.e. if the page is actually "active" in vmcs02.  For some
pages, KVM simply disables the associated VMCS control if the vmcs12 page
is unreachable, i.e. it's possible for nested VM-Enter to succeed with a
"bad" vmcs12 page.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 15 +++------------
 include/linux/kvm_host.h  |  9 ++++++++-
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 40777278eabb..d4ef33578747 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3983,23 +3983,14 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 {
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	gfn_t gfn;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	/*
 	 * Don't need to mark the APIC access page dirty; it is never
 	 * written to by the CPU during APIC virtualization.
 	 */
-
-	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
-		gfn = vmcs12->virtual_apic_page_addr >> PAGE_SHIFT;
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-	}
-
-	if (nested_cpu_has_posted_intr(vmcs12)) {
-		gfn = vmcs12->posted_intr_desc_addr >> PAGE_SHIFT;
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-	}
+	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.virtual_apic_map);
+	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.pi_desc_map);
 }
 
 static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..536d05e2726f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1381,6 +1381,7 @@ bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
+void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map,
 		   bool writable);
@@ -1398,6 +1399,13 @@ static inline int kvm_vcpu_map_readonly(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return __kvm_vcpu_map(vcpu, gpa, map, false);
 }
 
+static inline void kvm_vcpu_map_mark_dirty(struct kvm_vcpu *vcpu,
+					   struct kvm_host_map *map)
+{
+	if (kvm_vcpu_mapped(map))
+		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
+}
+
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
@@ -1410,7 +1418,6 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, const void *data
 			      int offset, int len);
 int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 			 unsigned long len);
-void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 /**
  * kvm_gpc_init - initialize gfn_to_pfn_cache.
-- 
2.52.0.rc2.455.g230fcf2819-goog


