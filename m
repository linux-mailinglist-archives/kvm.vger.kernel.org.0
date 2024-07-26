Return-Path: <kvm+bounces-22410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80CB693DBE3
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE72B1C214C4
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8675C18411C;
	Fri, 26 Jul 2024 23:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i2wuxh4O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F160A1836E4
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038057; cv=none; b=eZZVfEMQH2QJVcsaeTB18WFukIXnv5em8TtXoDUgNxX3/5Nv/RUDsaF46u4bctDNwBXeBgQQQ1hVx9swa7etKvhtR2wRu5vtMQkw3AlYcpqfrm2e8qP/okFZldGf7jw3m+u5lAftGBhRAGm/3ungVmdTcumDFQInfh09tEshTxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038057; c=relaxed/simple;
	bh=irQbhT8vq6NMlHJubauhZeuUKNqR9u7Db5+BI1KIaQc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P/QRvHZ1Cwfp4NW9AFn7L/5Act0D8gqLWI4RMcyrrEgR9ifRe2/qtTyPsUrh/yXtiXOsYjvq6T6otQqyCX+IdvnFW+7V4cSkYhWPMdcCTCRCrF+0DlO4sKf1dzISzru17lJ4rUbYvNKJhR8zFjT73Se4lx4Wk/0PuTnOKE9Pzgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i2wuxh4O; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66a2aee82a0so6613927b3.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038055; x=1722642855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gyzdwZRgQhOlsIfYTCemvzcmHdUAJy3wvQe/vDjl5Fg=;
        b=i2wuxh4O8bx9A2JsnlwAGN0/30VXy29eAXs6SU4rAdIjSv25BVJ7nBFsZ2JTmHUDkO
         Lu8lhdYqfUiLDwmeu5o+EONm6kH8hGlH12GxphVwVPyubgPD/37KO0jXDZhN5JR49ZFp
         FGlDoGO4NaWGZV7CRnSYbOdgWzIDikZMLxnxvVjB3nS9ZdqJ6fkSi+v/u9oh87t7MFE0
         Eh9Nna3Gi6BuxJwKPApO1KoFPy5+8F6GZwYJMScnAUSiT45OemUr/LmlhwWYn+hJQHKQ
         dtELVrILPiyJPA5jGxNTAC0mFx+j08jFUkkDpfneszUsTTre8U3T8nrSXyVLZEmdAen+
         9ROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038055; x=1722642855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gyzdwZRgQhOlsIfYTCemvzcmHdUAJy3wvQe/vDjl5Fg=;
        b=bE3GvzEzGUExofi9zVRGRR3Cja8dkZU2MqVzuhteilMLvipLUdzga6pJm/p5LJh8lf
         P2fOc3ruCR/kiCNUv57q0030AVRIR1BeFyg4LubPNUPRX4yeFkd7hbbBv0F65/BPyuA1
         VXkFwFNg/RxX30gj1R2mqIhaVte6VOAXXsBoXD87y5ktGAjrYYJW4ePAFTCRGwde27H6
         hlBfVoqCgdnlyWQtItMoUwZvCExRNeYJHeViQmx3LbpyqUsMBdmblA1fhBvGCqHmxfeF
         X/64Ja6NIFC2/w6gRZARU5YLk9i1nUO08G7o1za+QKSHgbcA7KM1bK5i1b2HapAdrjId
         XClw==
X-Gm-Message-State: AOJu0YxjWCoV5fB049zTd+SeQWEVyqJE/UiZGjbrIuY7vmoqfe26Iwtf
	IyCwaTRgi5lq0B7RsfWjhla8gqxoidRmMihVq3/gqHNddrek/vf/YnGr/Kgpx/OA4fD3DMRsM3A
	SUg==
X-Google-Smtp-Source: AGHT+IFpeG9OHD4NFko0QV+s2bLKC/mOPhRZ2kdDMQUp9/Z6e7qKWnbHym6UcCLJKsXB8YuZDTrWfSN5tHI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:14:b0:66a:764f:e57f with SMTP id
 00721157ae682-67a0abd50e9mr49107b3.7.1722038055008; Fri, 26 Jul 2024 16:54:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:56 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-48-seanjc@google.com>
Subject: [PATCH v12 47/84] KVM: x86/mmu: Don't mark unused faultin pages as accessed
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

When finishing guest page faults, don't mark pages as accessed if KVM
is resuming the guest _without_ installing a mapping, i.e. if the page
isn't being used.  While it's possible that marking the page accessed
could avoid minor thrashing due to reclaiming a page that the guest is
about to access, it's far more likely that the gfn=>pfn mapping was
was invalidated, e.g. due a memslot change, or because the corresponding
VMA is being modified.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3cdb1bd80823..95beb50748fc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4339,7 +4339,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 	 * fault handler, and so KVM must (somewhat) speculatively mark the
 	 * folio dirty if KVM could locklessly make the SPTE writable.
 	 */
-	if (!fault->map_writable || r == RET_PF_RETRY)
+	if (r == RET_PF_RETRY)
+		kvm_release_page_unused(fault->refcounted_page);
+	else if (!fault->map_writable)
 		kvm_release_page_clean(fault->refcounted_page);
 	else
 		kvm_release_page_dirty(fault->refcounted_page);
-- 
2.46.0.rc1.232.g9752f9e123-goog


