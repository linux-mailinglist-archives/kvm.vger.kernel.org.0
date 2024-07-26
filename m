Return-Path: <kvm+bounces-22431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5367693DC2B
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AFC91F213BB
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDBD18EFCD;
	Fri, 26 Jul 2024 23:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BHGeKCUl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE5E18E762
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038103; cv=none; b=hkaiTS75LMrScDN72kPB+NeaZdSvH+y99vCyAspxFGf6fJ6PVRLvjxFlE8VobV7m64Ye+eEamU6/0EXrBLsb5ht19sC0f5eIVU+Lo5UwxZnix/wekgT6N4WrLSfo6DjQGNLnxDWtY+WfkocXGSBbHYepOhOK5OteAe3yGarBmwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038103; c=relaxed/simple;
	bh=X/oocC9KK8HLcDY+BN3O4ToHUmzhhLHquCuXU7/bcMw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XzDviVBNszzxwWuuODbQBlweKqMCcBcjofQMl57LbOl1QwlTQcfEcGrsCIgFeQ80sdIwS2ET68SR0vBcBEy9UEX39xiMhYe+qq6k+GRmU4LsZpNsasr2GLCxM6VoXQ+3xX1J3VRRsxV4qc445gBWXkEkWpK4t64IlTJGz4qBOd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BHGeKCUl; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a267d9e7b0so1260369a12.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038100; x=1722642900; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EmsAuvL8HQXwYqsGGesvXxhYre2Gu8OeDMQE+hBNppI=;
        b=BHGeKCUl/GX9NJMFBC6bAqJ9xkP8FblCPsnhgnxpherIm5N3iCU7JFivY+HydgPxen
         v16bzTZv02jXaTFv7Gv/zl9hGdx+J+G1OkaLZx/QqrEvnuW9BSpcYhsTqghIJjinpnCI
         0KFIVstO82fgplO+iBeDtqNj16s/pVH+s+J2qoxShxGyF91NUvxek0L78Cts3+KrkuuS
         wO4B3BOZLXIP60LolSoJB0x8vd+tbV8HUzl8w/6aEFvmUFK0npsAzp/PX5gt2w6VYrnP
         D+CKK5qcUormI3mrYmr4dwQcLyJIHPx2Mw6VhkO+CKmCGNJfqqY31Wbuz/mpHc5y6uok
         ePUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038100; x=1722642900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EmsAuvL8HQXwYqsGGesvXxhYre2Gu8OeDMQE+hBNppI=;
        b=MBH+qLXhXdh1WeXZxLO8LJymCRIr/vfw/lFxGT0BFVrbyY+R7R8eGC7Es3FOwTasVB
         UZIU/7pErJqUa1johT3vq07X+MlQqEc0iTkfLEd3k7Oz1qllIp9F4TtrepsBv/E1o7kB
         lJnL6fX47L7J8yhGjoPuPu7kiUggN/nwGySEVv75wQqLrPMWFASfdLnWMCtMMgyW2qMu
         aoWYz+tjEmn7qhLCiLz+4JU5/Aj7/JZB4zl4bcjPAXxrbN4SM+3zoAaJoaL3yOerDfS3
         IZCHOVRU/oI1+NVSTUM5ionTin743Vo47RqvWq5L4uasz/VbYuGy+RFg/PQgdwwyVnQf
         RltA==
X-Gm-Message-State: AOJu0Yy+O3QTYownQ2Mgk+RamqbKjKGGDLEOxQU10OCuhV1lAdAenCBC
	cXDT2OSYLdjaVfZv827AHt/PCahs/5wdq1/r8PTyuJ4ozh6bpCGqQ/B6Wd3Dlom3qvd4+ouvaYY
	6mg==
X-Google-Smtp-Source: AGHT+IFixvL6M1c2YXLcj1uim9WdRxJ+9f/3q289x5sMH5Ueo8TBf7rPuOmHjx69h4l0El/Ee2ditwF800M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:fca:b0:72b:5113:ec05 with SMTP id
 41be03b00d2f7-7ac8e39fc8dmr2096a12.5.1722038098497; Fri, 26 Jul 2024 16:54:58
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:17 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-69-seanjc@google.com>
Subject: [PATCH v12 68/84] KVM: MIPS: Mark "struct page" pfns dirty only in
 "slow" page fault path
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

Mark pages/folios dirty only the slow page fault path, i.e. only when
mmu_lock is held and the operation is mmu_notifier-protected, as marking a
page/folio dirty after it has been written back can make some filesystems
unhappy (backing KVM guests will such filesystem files is uncommon, and
the race is minuscule, hence the lack of complaints).

See the link below for details.

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index c17157e700c0..4da9ce4eb54d 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -514,7 +514,6 @@ static int _kvm_mips_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa,
 		set_pte(ptep, pte_mkdirty(*ptep));
 		pfn = pte_pfn(*ptep);
 		mark_page_dirty(kvm, gfn);
-		kvm_set_pfn_dirty(pfn);
 	}
 
 	if (out_entry)
@@ -628,7 +627,6 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 		if (write_fault) {
 			prot_bits |= __WRITEABLE;
 			mark_page_dirty(kvm, gfn);
-			kvm_set_pfn_dirty(pfn);
 		}
 	}
 	entry = pfn_pte(pfn, __pgprot(prot_bits));
@@ -642,6 +640,9 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	if (out_buddy)
 		*out_buddy = *ptep_buddy(ptep);
 
+	if (writeable)
+		kvm_set_pfn_dirty(pfn);
+
 	spin_unlock(&kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	kvm_set_pfn_accessed(pfn);
-- 
2.46.0.rc1.232.g9752f9e123-goog


