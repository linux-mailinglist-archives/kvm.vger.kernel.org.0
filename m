Return-Path: <kvm+bounces-22412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 475D993DBEC
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C63FE1F21793
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29297185080;
	Fri, 26 Jul 2024 23:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r8Kfhn5Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E9D184121
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038062; cv=none; b=s6t3y6MyWeReaixpW6+H1pKz+4z/5vBjrZ8ruH9+Dv/VXBGIW2jbUUx+TKxRNEoXnjcZJg6PK9lA1UTwJowIaLNljY5R3C/z0bOZN3SCn2OpYVFYHjPs/BAWCLfi+n+TV1VILnyVSvecayZarXXDwv3XdL7ha0OiU35CDFFeOm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038062; c=relaxed/simple;
	bh=bxK6qVpynswZ8R8KEFFqM/NCnF+uG5Y2NSLbD2Gkxm8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tCxhgQeaM70P0qAmXMvWZQflkNPugXhWYNaM0hwxbnpddS+aTJy4Mmv4Qrs0TwPavZippOHF7DqKZtu/1mRMD39RKiZKEDIYqCoqsqlVJ9QyEYnfU/rmtOTVDdEfqny/Fg+RDYckX7iGQLSWVolqcnTW8PAmVR9yTvnmijsvtLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r8Kfhn5Q; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb6c5f9810so1641846a91.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038059; x=1722642859; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TqUPaGEc7V7k122pX7jZuWDsKBXmCX3Y3KCoLsEzljY=;
        b=r8Kfhn5QIfw8bXRjb7GNZxVaDZZrB8VolGE04H9QaxdvwCj1ESAXkRroNpYJqR0pAp
         Q5iF/xFl3LdO7+u80Jg66zQqFZ43k6rBk/JhEW7FatxTVrGEoAi26/tTUzRMZbFEeung
         zMrUTPR9byVQRSjML4gH0TLU/dIw0APzpg68iWTZmx7bNuDPzDC9Qoi78KKVuVGF0Dfy
         MGgJugFMG/aln2uBkR0kGeoDC0Mn5TSx8v9g7W9wEAKg0H9F16IzFwB/bv0DZiQ+TXqy
         AJaPY4NiQgn4ht1taPocxt6RVaITjzL4O/OcZC6Wi2OG5LkIF6keYvh7Al+4kW/9QjT2
         v8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038059; x=1722642859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TqUPaGEc7V7k122pX7jZuWDsKBXmCX3Y3KCoLsEzljY=;
        b=M/i2vr1L8BTz87BMtQQY/6BWflLYLkmGoUs4HCOrZ0S+UOR4/7bWmN181CXjLvW0HJ
         42irUegqPMWFzbt4baGRGoZFD4YBxfHsjakuTKXcxWORklpokQgWRvBXmBygLW1A62mA
         qHSHFaAzIUruehiIfpQh991miGrQoKYwOrZAljnTnuR0Zv1LCxYn1EdzGYIsYWRUpfDc
         k/YUAvFVbopdt84t+K7uGCBL1VV/P0dZcB58wgv7tFdZBxpph+ztiSndOCZs50KIBjAa
         dvR/hf3wa4AnfPGU3yWAVkSlMiVD+zStd5fEvdT26D07g3gABbNI2VsJqhoiEmqnlGAy
         xaKw==
X-Gm-Message-State: AOJu0Yypw2t7K4KcsgQDPeXIkZv3Hej05MSaEOx7E6zjH0iWG6PTd/mH
	P78iNo+C0h4Zs38CZkAlTz+JEklPAeXe5XKmmQ2EL/rMwvvIfj6EfP5cknQMEEQQbWbpg8M06fB
	tog==
X-Google-Smtp-Source: AGHT+IH7R2Sq6ws3raxo/M+HjUZh8HrSGcUFKZNBVKBew2cgXvpkeEwYajfUFO1jgdCm33mambqvR7vew2A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:19c4:b0:2c8:8288:1f3c with SMTP id
 98e67ed59e1d1-2cf7e08defcmr21966a91.1.1722038058548; Fri, 26 Jul 2024
 16:54:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:58 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-50-seanjc@google.com>
Subject: [PATCH v12 49/84] KVM: VMX: Hold mmu_lock until page is released when
 updating APIC access page
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hold mmu_lock across kvm_release_pfn_clean() when refreshing the APIC
access page address to ensure that KVM doesn't mark a page/folio as
accessed after it has been unmapped.  Practically speaking marking a folio
accesses is benign in this scenario, as KVM does hold a reference (it's
really just marking folios dirty that is problematic), but there's no
reason not to be paranoid (moving the APIC access page isn't a hot path),
and no reason to be different from other mmu_notifier-protected flows in
KVM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..30032585f7dc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6828,25 +6828,22 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 		return;
 
 	read_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
+	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
 		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
-		read_unlock(&vcpu->kvm->mmu_lock);
-		goto out;
-	}
+	else
+		vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
 
-	vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
-	read_unlock(&vcpu->kvm->mmu_lock);
-
-	/*
-	 * No need for a manual TLB flush at this point, KVM has already done a
-	 * flush if there were SPTEs pointing at the previous page.
-	 */
-out:
 	/*
 	 * Do not pin apic access page in memory, the MMU notifier
 	 * will call us again if it is migrated or swapped out.
 	 */
 	kvm_release_pfn_clean(pfn);
+
+	/*
+	 * No need for a manual TLB flush at this point, KVM has already done a
+	 * flush if there were SPTEs pointing at the previous page.
+	 */
+	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
 void vmx_hwapic_isr_update(int max_isr)
-- 
2.46.0.rc1.232.g9752f9e123-goog


