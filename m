Return-Path: <kvm+bounces-22421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F6E93DC09
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70F722860F7
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54239157466;
	Fri, 26 Jul 2024 23:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z1GHr4iw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFDF187847
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038081; cv=none; b=ncudHujk5tg/Jf76uOM4i1NKiYUrwHs0ak7Dpu7erscY+ToDtud+CLqY86J1h5S08JyOKtBjw4Pkb8ibvF8Bt9QcpoZdx4iH0wsB1VJFZNd9cDp1tz2MbaTIpHrNt+elWFV3Kx/TFj5lq1hJ5OcBWYSD+Y2ZooG7j+gIim15FrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038081; c=relaxed/simple;
	bh=QKdqSeDurXwkoaj80ZjKrbgXs0BzbdNHTlCFTKbvwVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mdoGEeaEJlJuQ7DbT7vY32SdLshPJRf4zHLPpSzYn9WClh9/pqRwXKv8uJmo/0j5GGltHFrJIMa8+ldQ7i3j8hXIZFjuZAM6KVSe6YcFqumN6ccKmTCg3PA1JW2OwrTP3OFDMYW+BXSZ8CDRbBJle+OSN1uL3wYISqCVVESdrqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z1GHr4iw; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-66c0f57549fso7716067b3.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038079; x=1722642879; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lKpu7mXAQaRbYxbEDOwpqeV9V2sn6fCg4Pm2+RclqqE=;
        b=Z1GHr4iwyaZgScL7x3Qd9YOawsiE8lfDmyYEQLoLQHM2UyzIZOxvhUHiyF9qM2lo5z
         o5iB8yPaFYoB6jqPBVslKHR+G+7Q4f8VSWiTt0fV3+r5VgiE8/YKLxN193I8RhrImfom
         MPWbZeByHAuKAG1vUDjUEYEYxqFJ6RIeQyfEIcLEU1v1lxnocm7f8+JsVEVBHJlAfdk+
         FnOw0Kidl0+sE8lhy5ccYILsUSK+lWaHJlLdQr5ntFDGcWYEARl6+w2fZb7SXyXoHzBJ
         HyFEiibuf5GxvRN9UbNg161NSLgHsZ5dDSBUPxl0Wzszb7Z2b4i2Zp0c6jiLTEHxm7+R
         IY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038079; x=1722642879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lKpu7mXAQaRbYxbEDOwpqeV9V2sn6fCg4Pm2+RclqqE=;
        b=wzlDAC6yzdKYcAX0yej7OvCUIhvQZrHusaflmiIeYTYuuWUhhyWvVBeKilnl093rNk
         ewkR+ncZrn+wKbgs1j1eZI+cOxNixciGlCtz1RrY0inH6p3coqCuaVWtuhvRDGEQLIco
         22jGlV4a+gBUFXeBilsyH9GSFommnRLb9b/gTXROzehoS2saTcZbRFkiuVtEO6n7vPO5
         d4Mqwxd/PzsJCXW6V16pa680qrbpUUSEMIB2qYeBG2Rh+vv4YEiqfpv0HAtAuaCyHx29
         BwPEovyctIvhjOpwe937fq9ZRjqx1jGiqkcrNmHY1zcjQC1EH3iFo0lsPgWSx8J6+dL9
         GeaA==
X-Gm-Message-State: AOJu0YxW4fcYIIJ/4qWJ/yoM6XOArVkF9tkqy2mctQNz8J+I3Ri4O3Ss
	jLSJQwb4DZdVvU93yjYD/ykPtO0KP82sGu7lUPOc6xG5/M5/unq5zG6EzUJOd4qbE0Kv8fsYnao
	Blg==
X-Google-Smtp-Source: AGHT+IHhzhjU3Z65Ec9zcL96WqENi83QMIcwPrprR++iZTSrPH87Hnrc6/v3lgb0Tgsr4AkAwll8yu22uIk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ec3:b0:663:ddc1:eab8 with SMTP id
 00721157ae682-67a088f07bfmr790257b3.4.1722038078515; Fri, 26 Jul 2024
 16:54:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:07 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-59-seanjc@google.com>
Subject: [PATCH v12 58/84] KVM: RISC-V: Use kvm_faultin_pfn() when mapping
 pfns into the guest
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

Convert RISC-V to __kvm_faultin_pfn()+kvm_release_faultin_page(), which
are new APIs to consolidate arch code and provide consistent behavior
across all KVM architectures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 806f68e70642..f73d6a79a78c 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -601,6 +601,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
 	unsigned long vma_pagesize, mmu_seq;
+	struct page *page;
 
 	/* We need minimum second+third level pages */
 	ret = kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
@@ -631,7 +632,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
-	 * vma_lookup() or gfn_to_pfn_prot() become stale priort to acquiring
+	 * vma_lookup() or __kvm_faultin_pfn() become stale priort to acquiring
 	 * kvm->mmu_lock.
 	 *
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
@@ -647,7 +648,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	}
 
-	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writable);
+	hfn = kvm_faultin_pfn(vcpu, gfn, is_write, &writable, &page);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
 				vma_pageshift, current);
@@ -681,11 +682,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		kvm_err("Failed to map in G-stage\n");
 
 out_unlock:
-	if ((!ret || ret == -EEXIST) && writable)
-		kvm_set_pfn_dirty(hfn);
-	else
-		kvm_release_pfn_clean(hfn);
-
+	kvm_release_faultin_page(kvm, page, ret && ret != -EEXIST, writable);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
-- 
2.46.0.rc1.232.g9752f9e123-goog


