Return-Path: <kvm+bounces-22399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5410C93DBBD
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76E841C23729
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4122180A6B;
	Fri, 26 Jul 2024 23:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g2ZVkkO+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F18E1802B3
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038034; cv=none; b=T/CGqT6RiN5/G8/cyfrJ22YdpQdauvX4PCgS+O4zPm+UYHThBJNzga57R/2hxnCw1/mvTWL71ZjVEXMKKpnufovhXynat9Jjp9hPZhgDrTcMAVPB8HAhyOK9Jb993j3h2fMOpVKPfACbkBBcioU35NRneeEj0YEHMax9Ev3rdcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038034; c=relaxed/simple;
	bh=DtXqKMMIismcR5Jrwgm9yWaU7DBxhq5zzlFfV1KGA1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aexWwsoLnh97flOvo19yRHH54viZAQte+V0E1cOZYpsTl3TjA5YoQTzIj+nRkpcs/byBlkNeEPKGpWzNNjETIPn7ob3UF8FzV7ki7WRO/2T06EUWFJCPTHPidOeaNGVyNZ0a+DuLK5KwjhNYhjrhSZa+S6Uv0VjotPTGLqQsqyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g2ZVkkO+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb63abe6f7so1690409a91.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038032; x=1722642832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4+b7zhduK4lVkLFwoy0UCXuK8f7LQragdXHyxQERLss=;
        b=g2ZVkkO+OlZl2mswdGwwn1VJ/RDFk/Q4vALgh5j4WnwElVem1TZ1jcxu4U4rqbgAkN
         I6zeoi+bRC6h+oWnkHKG2xGxd5YedLWx+8EyOLIw3F1/maqWYgpvQOiD7N4oCv6XzMoN
         Zaol5cTbt2KTYJ/45a1Z6368VKXO1EYgss1sU19Y+8B8y/Nhgg1esTFrLXfhtRwK1V2P
         LRWcmk2MMUO0vUPgMTZBlRPIILkfLfylLc847Osqabyo06cZ3tdKVHyJE6ayFkB81opb
         N6GXktVgLow/lyLm9A5qDCQJtlzrXTKJ/Mx/8BbFOKVd1DWnTxKiplCvx+8NqNQBdZSk
         F/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038032; x=1722642832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+b7zhduK4lVkLFwoy0UCXuK8f7LQragdXHyxQERLss=;
        b=nrQFh4PP046k+RZ6sEAkt4GVgsuWdntlxZO3pnVPICWO+tXJO2FsqpVNUPyEK1ETQ0
         zb/ssebBgRqRDxprqTCIMpGIq8v1evAsUQN2PUgj+exkFXLWL5oVOGwScY2c5p8fIxPp
         KbmyxohM7DlTpD08j0EV9djb4jWLQbdE0heXP40d0Z0cVIlxdVIN89z8RYqjK5Y2i1Yj
         QZsd6vpD/WGeuUSWa+UVpP3U/KdJUFERoMfC0JF7LvUIA0Yo8W/Ifl0geCKNvgkm2RYa
         +DPmyR0hf7K6tzNFf1FWeWEJvfEoo55cBc38GVJgK1J2tNx39lPR4yqrjnlVEx7GuO8W
         BrQA==
X-Gm-Message-State: AOJu0YyyydCJdnZXUW1Sg7JMHLQZ4Ff4+tnGQN1FK3n972cGpisYGso8
	6lB9u7WiYZnrDyQ5/ne4+BqjsNiNcqcnEMdwsAb+HXtMEO7C0CzixwMWqRecamVaj0PEjMwxK0c
	YNw==
X-Google-Smtp-Source: AGHT+IH83fBTCbgjCdiYRsrBHzQDSmPEXzxw/dBUECcFBZL6/864S5lAdfsy5Zb31ECaUXnMa239gb1WZDE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4f8b:b0:2c9:759f:a47d with SMTP id
 98e67ed59e1d1-2cf7e84e558mr8570a91.4.1722038031713; Fri, 26 Jul 2024 16:53:51
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:45 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-37-seanjc@google.com>
Subject: [PATCH v12 36/84] KVM: x86: Use kvm_lookup_pfn() to check if APIC
 access page was installed
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

Use kvm_lookup_pfn() to verify that the APIC access page was allocated and
installed as expected.  The mapping is controlled by KVM, i.e. it's
guaranteed to be backed by struct page, the purpose of the check is purely
to ensure the page is allocated, i.e. that KVM doesn't point the guest at
garbage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6d65b36fac29..88dc43660d23 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2612,8 +2612,8 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 
 int kvm_alloc_apic_access_page(struct kvm *kvm)
 {
-	struct page *page;
 	void __user *hva;
+	kvm_pfn_t pfn;
 	int ret = 0;
 
 	mutex_lock(&kvm->slots_lock);
@@ -2628,17 +2628,16 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 		goto out;
 	}
 
-	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (!page) {
-		ret = -EFAULT;
-		goto out;
-	}
-
 	/*
 	 * Do not pin the page in memory, so that memory hot-unplug
 	 * is able to migrate it.
 	 */
-	put_page(page);
+	pfn = kvm_lookup_pfn(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	if (is_error_noslot_pfn(pfn)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
 	kvm->arch.apic_access_memslot_enabled = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
-- 
2.46.0.rc1.232.g9752f9e123-goog


