Return-Path: <kvm+bounces-22417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4BD193DBFC
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74FF7284402
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323EF15687D;
	Fri, 26 Jul 2024 23:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mjCfZSh0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5DF1862A8
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038071; cv=none; b=LZLyBBCBCHYlPlqnAlRhck1yqAEfCaRwWXU3OwTNDskwFI0HMAIODEk8g18C3vrDClJcsWU2/hHXvGAh5bht2kztLMrvyYjfbM5WUskUaNjLWGDg7q02sOWY6suKMt8m1TU5jU93ueDvXXJBliDlmT8uTGo2SBs47DO51uZnqrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038071; c=relaxed/simple;
	bh=t1qRb0jq3mEdjTFuwQYR/NAnoG1UlhS5OUQ+Ga/OUT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s3LdssSvrmaUJQrOn8f3XIt3p8aekS4JwZEGlm5Vk2MwSTtmIo2VmUGSNMzH4hDVXM9qrpSH/gQOQiPeaBnbosjUISWYCdqHOyYSDCbw/17tyxtIPSQkPibFAb2K0QEERAwhCEiuZZsr2Rg4zw1BaujsQC3QhXY/Gzons2zADCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mjCfZSh0; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d392d311cso1417280b3a.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038069; x=1722642869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Tp8vWxWuEfoTun4nd23rTIy8nVqGGlQS/g8lo8vNdQg=;
        b=mjCfZSh0L1ukb7AwitAar0eelVYdJyADOTicV3AOuBvB7O9/KVBBUT6fQtQULkSrss
         iHmWJjfQC3X8sxIAPv+CiDVIINaHPy5e6x2ssy6YOUVPv2hZ8TJpfwg/G9p3Bab39ZXH
         cTVwCcIRzo8w8urQTE8i3QuL1d6IFfNutV/xQITNcRzjE/6HmYNHJBoVT+zmhrbwRfTH
         qNe0fWgSlHQNgEwmltcjOIKYQtwye7hCYEkjr5oFwbw0TvAf9wEkY1w/mineAWPItC+2
         KueEV/ziKYg5QrSfBP83Uf6P7VIGMp9LcLQu2V0IHFvCAGtNSE7RDr+i0DcgEi228uGb
         X6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038069; x=1722642869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tp8vWxWuEfoTun4nd23rTIy8nVqGGlQS/g8lo8vNdQg=;
        b=oOZYkKH9xdgAeqvqjgXlJ4iUzXdkD0EZ4YVyvnEMr2d6Ls3oYA4GGbqdC22MEVZMrY
         tISU4CaHg5vai0AtKU+aRYkw8t/ZAr11DAUJmmIfcMKbelkRwKlQ2IGHqdFjAstuwvL3
         3XSiskRsj5JuZc8RChAF7/RgRXvj3ghKlkX/9PLhMNLRE002No7nP7K8PZuYrHWEg0WW
         VZG7AJ1Yc3EB+ReIY2GUdsx/mjwn6cs86EuqGzxGOPwqeTqFLtTQYAhOZayydKGcfZg+
         0cISmwdeqEcdUQEaEBn0aZPQYujDeWi3y/eGWcirhDJQvzFYfaMq10+nECx73J8pLNtR
         JeLA==
X-Gm-Message-State: AOJu0YzNJFOEjJkoAQzWfNPpQTgWIzAFr/qXgQuHxGffQwYC0JC0L0z/
	tVFvJNOGQdLU+aw7IbTO1gqpAVLTHNPKR2P27kHOzb7s6oQE/PkoUq99AUAP88CgOFdm4x18cRa
	cpQ==
X-Google-Smtp-Source: AGHT+IGdEcu09Hin88e0jkC1IJzP1gp2m8bzTdpaUdhQIiML2lxsNf415Y84GaeMaBcBrlwhHWl3MjBIRUQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f1c:b0:706:71b3:d7cf with SMTP id
 d2e1a72fcca58-70ece926b55mr9310b3a.0.1722038068878; Fri, 26 Jul 2024 16:54:28
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:03 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-55-seanjc@google.com>
Subject: [PATCH v12 54/84] KVM: arm64: Mark "struct page" pfns accessed/dirty
 before dropping mmu_lock
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

Mark pages/folios accessed+dirty prior to dropping mmu_lock, as marking a
page/folio dirty after it has been written back can make some filesystems
unhappy (backing KVM guests will such filesystem files is uncommon, and
the race is minuscule, hence the lack of complaints).  See the link below
for details.

This will also allow converting arm64 to kvm_release_faultin_page(), which
requires that mmu_lock be held (for the aforementioned reason).

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 22ee37360c4e..ce13c3d884d5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1685,15 +1685,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
+	if (writable && !ret)
+		kvm_set_pfn_dirty(pfn);
+	else
+		kvm_release_pfn_clean(pfn);
+
 	read_unlock(&kvm->mmu_lock);
 
 	/* Mark the page dirty only if the fault is handled successfully */
-	if (writable && !ret) {
-		kvm_set_pfn_dirty(pfn);
+	if (writable && !ret)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
-	}
 
-	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


