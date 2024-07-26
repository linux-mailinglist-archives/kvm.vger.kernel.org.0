Return-Path: <kvm+bounces-22439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9FD93DC45
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C3DC283043
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BC819046C;
	Fri, 26 Jul 2024 23:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GLtaDUrv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4072019004F
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038117; cv=none; b=W899RLy3mLCFfCXtsHtok2Og1KOEbicGf2cBG9s0qXW8ZBkv9hZ/n9aWhY5alh/kUYgT6JiXjE0f1ad1qRna4+R8riGqON0nTH00NQHdUDpGxhUkB431QKhmQb1tgfKjmbnEm4ySkOSDo2jyYsfXb+8h/uBHnhKY8D2K5NYbnvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038117; c=relaxed/simple;
	bh=SUUzhrURtkDY8ACwtRZFtnUrMpf+i7jwgURG3Mw5oko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iQsH0QfWBXK31u/Kn9AalxafxioagLUc3DYqEomQ8FYYdJeR2W5PcgETdrIBFdcxc9l9YbDsLh7+ekvbhUFByTB6fIZ++gyBOslo2YkZV/8sDJ7iUMCUV8n/JY+w+qZA+UB1hqggMNUviMOo4x5qE/lwj8FSxSp8gxopu6whq24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GLtaDUrv; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc52d3c76eso12302175ad.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038116; x=1722642916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gSJgbeqW0EjFVjI/rvx0LQaQxVZn1dW4kzDKJHwZpGY=;
        b=GLtaDUrveUqDcyxp5RkAvPoK0LtbkQw20aUgB3YddyaMWtw5CRqTBTDQbzB+Hgd0qd
         9wCtJF9OJqoVJeDtBeKP9q/bGjA46yy2rrnG6FJTtAqAtoqtJK3RGlM7dwUF6FBE5nAt
         mNnBOsY/ostoBhYnsM1dr/Xbst5EV5Hhp6VQhuj6iFHtKQ98k1QJGAn2b9gW4SutYrln
         WXS9dyjlgwC56rEpQnLAMb+RDLUYbCGyoDvdxZ0DKRfvV5/YR92FzIDbzDqkrOy9QU1Z
         rE/B942bUAwWakpd7ehQ33JecYeJmGXz2qhglZR0Jfd3Z4tvAVHQYSmRm5FJ/RpyItSt
         ty/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038116; x=1722642916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gSJgbeqW0EjFVjI/rvx0LQaQxVZn1dW4kzDKJHwZpGY=;
        b=Vbw5uqyj+MormWtOk6tnoGr5QsB+uk3jnBtPUWA4c0VSH4HC1bAROuWlpxD35lY1ZC
         4AGbXDoIgu/Utp61sNRdEF/uwO92IZwbt6Wii6uhaWDhVYfZFXU5qzbKDm6XTdNHUb8N
         cqo+zDnheQAWU5xKuHYvxBPnSqjWt8b6vqdd6sBO3jeZuBecXx+A7DNJfGiRJ5n4dCjB
         EEhVdEcMz4PqSKxDWlnHhx3xNY8r6J9K3LXPajTS9P6P2amQAiIPjg250QqAH2AXray9
         AB89Jt4dtPi6AC2rymSNSr5FWzXsV/2FYMTRC9ZEgJbZtDUdWcjG5zyJdIQrqC+mHbzi
         +kzw==
X-Gm-Message-State: AOJu0Yw6gLaJgDjE7eAfOTso4PcP9EJw+HowXn86EJS3pqvPb1kQx3O0
	3Gt3m0F2vz3spK0ztDhdxNyoXdN3NZycLRxzx9uKUPxyxcoibeYRxvnJeRcGKnZVbyQUsB/5vo2
	YDQ==
X-Google-Smtp-Source: AGHT+IHxrkKUWCeUEpiaW8aWqxkJkE+eVd4nhH8cGKa9NS3y3LrlRDBQyz/B78NptpquvhhjWf0asoH4ivY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c945:b0:1fc:733d:8465 with SMTP id
 d9443c01a7336-1ff0488cadamr599925ad.8.1722038115596; Fri, 26 Jul 2024
 16:55:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:25 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-77-seanjc@google.com>
Subject: [PATCH v12 76/84] KVM: arm64: Use __gfn_to_page() when copying MTE
 tags to/from userspace
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

Use __gfn_to_page() instead when copying MTE tags between guest and
userspace.  This will eventually allow removing gfn_to_pfn_prot(),
gfn_to_pfn(), kvm_pfn_to_refcounted_page(), and related APIs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/guest.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 962f985977c2..4cd7ffa76794 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1051,20 +1051,18 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 	}
 
 	while (length > 0) {
-		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
+		struct page *page = __gfn_to_page(kvm, gfn, write);
 		void *maddr;
 		unsigned long num_tags;
-		struct page *page;
 
-		if (is_error_noslot_pfn(pfn)) {
-			ret = -EFAULT;
-			goto out;
-		}
-
-		page = pfn_to_online_page(pfn);
 		if (!page) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (!pfn_to_online_page(page_to_pfn(page))) {
 			/* Reject ZONE_DEVICE memory */
-			kvm_release_pfn_clean(pfn);
+			kvm_release_page_unused(page);
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1078,7 +1076,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				/* No tags in memory, so write zeros */
 				num_tags = MTE_GRANULES_PER_PAGE -
 					clear_user(tags, MTE_GRANULES_PER_PAGE);
-			kvm_release_pfn_clean(pfn);
+			kvm_release_page_clean(page);
 		} else {
 			/*
 			 * Only locking to serialise with a concurrent
@@ -1093,8 +1091,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			if (num_tags != MTE_GRANULES_PER_PAGE)
 				mte_clear_page_tags(maddr);
 			set_page_mte_tagged(page);
-
-			kvm_release_pfn_dirty(pfn);
+			kvm_release_page_dirty(page);
 		}
 
 		if (num_tags != MTE_GRANULES_PER_PAGE) {
-- 
2.46.0.rc1.232.g9752f9e123-goog


