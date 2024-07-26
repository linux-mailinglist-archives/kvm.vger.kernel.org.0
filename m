Return-Path: <kvm+bounces-22406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC77093DBD5
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D04851C21154
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2E91822EB;
	Fri, 26 Jul 2024 23:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ONAPJNsi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD9B1822C9
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038049; cv=none; b=S1FPwrjVWq9DNaoWh62gO27jndlI6V2yDxIagy7mWpLDYbYkr3Chj1ZUhxxHe+kQB7/lhrZWHj5/XhfGQHW7QeIZm6WapGfrYO696jWD14PQ2g2cmTFOe8h4vNqzBd8NB7VapPDQ1JqQVfJzKb5Yex4hShWHPo+MOb4sXkVp0vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038049; c=relaxed/simple;
	bh=ZiPrcqIShlRmgFNauo+vxtdzmRhSo46Zz79Lct/JRI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hAi6C7WgXyfi76o7j218OTMM6HUPXuCmUvs6VpZvrYDwwAeZ/XZwEZqKpenDGxNYqvlHX/XMK5iJ8NAuCMiT55bnahn1OK62Qe6uWRoiyNn6NIJ7dFall5ISSOHcoGJehWcGD2YyxKlFY3GAR5w1qJlUIXHf4TSlRGWg4QayZzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ONAPJNsi; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a28f78c67aso1346518a12.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038047; x=1722642847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wxuzXAlWAmTLEMJkRQnxVQGU0NLqznOMJ0954FoR3Ro=;
        b=ONAPJNsibz/4nIIt6+A+oNj8ZMye3fOT/y/O/QYFIPVcyE0UbuyYAM5P3GDyY1k7uR
         HBkWtQTojRHo7K5CBVWtxw2HScBgTHtCbvZ/1jdNUkKAOztHFTcsWscOEu1LXoaSl00/
         3BvVguWqh3UUZi+n4pHj7S94+CH5YAc+WoV36wl3yM/TYmEZhL4I92S80dS8jCqeVfoS
         y17Byau6b3a+znoDrYhPM74o9kg8Kou5jX1Io5kMePc2MDu6F0V6Wi3C8MbW/zHply2a
         B5udnDuCCA+NtvUVt/rzsR+lFE+ftibtUtC60syfc361NCNUbNqOfqeJJVZXSXvdeCTl
         kWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038047; x=1722642847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wxuzXAlWAmTLEMJkRQnxVQGU0NLqznOMJ0954FoR3Ro=;
        b=wpYLMhFDXG60hSNPTHUBtOZZyzM0biqPmaAj3yW0RkgBE5maLysF/noTSkq2qzxqNN
         czAkYM0Xp9+az8hits9MXUUKXdeCqpVl1MpewbWODeISgyNu+wBbS0qlbDEBQDGJq/2z
         1LvozKKbPkU2GLIPA66rzDjwAWRzrrJXNIrzjDPxAVYFDNPwc/CNDwaayBb7SuZ5iN0N
         zdqBRkpLwlnW5+dM79ppQDWGgD6bprIzp/Qazvx4pI43YonbUcOikQAOMiD/ZCD3kfok
         YijaDwvIpARg2KNX8eSSpzRgwKOLO83u588fHuiVbISTVFlp2NwYrqKKcZwl/bTxTbUW
         +TXw==
X-Gm-Message-State: AOJu0YwN5KS+QWtqyfSM/bST6DMkpiKHA0Q6G6227OJxuYIVVzB8T/dQ
	H8Mc8uF/RY/Dy1gEH1nHmGlN7MNkUfCFuTNhI3gcdVAFFug6KhgfuFl4Mw33zEEUvnuO+msXVqh
	1BA==
X-Google-Smtp-Source: AGHT+IHHkDF9jDFipyHQqfPDWUmaQYRR7lKWyDIChzQG4y5VknOXhGJqf1L9qSRAYqKwiuxxpki7u8BCvjE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:141f:0:b0:6e5:ef07:5922 with SMTP id
 41be03b00d2f7-7ac8d9d818bmr4158a12.1.1722038046008; Fri, 26 Jul 2024 16:54:06
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:52 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-44-seanjc@google.com>
Subject: [PATCH v12 43/84] KVM: Add kvm_faultin_pfn() to specifically service
 guest page faults
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

Add a new dedicated API, kvm_faultin_pfn(), for servicing guest page
faults, i.e. for getting pages/pfns that will be mapped into the guest via
an mmu_notifier-protected KVM MMU.  Keep struct kvm_follow_pfn buried in
internal code, as having __kvm_faultin_pfn() take "out" params is actually
cleaner for several architectures, e.g. it allows the caller to have its
own "page fault" structure without having to marshal data to/from
kvm_follow_pfn.

Long term, common KVM would ideally provide a kvm_page_fault structure, a
la x86's struct of the same name.  But all architectures need to be
converted to a common API before that can happen.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 11 +++++++++++
 virt/kvm/kvm_main.c      | 22 ++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ef0277b77375..e0548ae92659 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1217,6 +1217,17 @@ void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 
 kvm_pfn_t kvm_lookup_pfn(struct kvm *kvm, gfn_t gfn);
+kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
+			    unsigned int foll, bool *writable,
+			    struct page **refcounted_page);
+
+static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
+					bool write, bool *writable,
+					struct page **refcounted_page)
+{
+	return __kvm_faultin_pfn(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn,
+				 write ? FOLL_WRITE : 0, writable, refcounted_page);
+}
 
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ad84dab8c5dc..6dc448602751 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3134,6 +3134,28 @@ kvm_pfn_t kvm_lookup_pfn(struct kvm *kvm, gfn_t gfn)
 	return pfn;
 }
 
+kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
+			    unsigned int foll, bool *writable,
+			    struct page **refcounted_page)
+{
+	struct kvm_follow_pfn kfp = {
+		.slot = slot,
+		.gfn = gfn,
+		.flags = foll,
+		.map_writable = writable,
+		.refcounted_page = refcounted_page,
+	};
+
+	if (WARN_ON_ONCE(!writable || !refcounted_page))
+		return KVM_PFN_ERR_FAULT;
+
+	*writable = false;
+	*refcounted_page = NULL;
+
+	return kvm_follow_pfn(&kfp);
+}
+EXPORT_SYMBOL_GPL(__kvm_faultin_pfn);
+
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages)
 {
-- 
2.46.0.rc1.232.g9752f9e123-goog


