Return-Path: <kvm+bounces-47512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1EAAC1993
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 536B71C06DCD
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC92F2DCC17;
	Fri, 23 May 2025 01:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wb/dkA5c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676362566
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747963083; cv=none; b=bMBJ5XoPcazihFBleewlE/+p1ODAbz2x6P1ULjcfQ+KhmI/9l7VphWZOOuPJm/4pOwYaGWtqr5sIfSODK9fKpIoNKn3zYLWfSBlU5EewWy0IK6WcFmikoIMlHq8+uDoXCxK6XdTvxwXrJromCuYQj6nl9Kjyh6tOJnrZ0GFR9Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747963083; c=relaxed/simple;
	bh=NvuqvCPgnQ92aEAvwxdw3ZIVmayzoEG8SN2JilVlEUU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hqGLsaHKyNHdOzalUqGbCCvegHSkCqGyDjfopyXbKrSY8dPuvwb+uZkKLzfbxgBufW5w/YJ5uwkvrECxS/6psi9gRZmWvOrcvCFEgnRuYBd3ePA/iqfnpII0vUPJzZdadjCO/5Py148PYYYYNd9+rW5mltYkRxw9ecAaU/4HjbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wb/dkA5c; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ec5cc994eso4831242a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747963082; x=1748567882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rI/vnFBqTVpLs4/0IdbviGwHNeIm39eoJp7REcUpk+M=;
        b=wb/dkA5cQcmg1FPvJ13CtwJec73zSfLpPt8SeTvLYu7YUIoywxJnGOU1h7PFQFVwU2
         igl/kwp4nY8WCB0k+vZo8lRO0BCiHmsvM340/cNyayymtB0oaKgX45a1DsVF6Rqb6iqh
         pppb9xZ9dzM31NCahsNAFhhf2IJiz32KOhXmtMh/lU8EAzadTe3XCfnFGmme25Vvelp6
         HPARWpu0W1mNKR4qOzP8eubJmgDL7YzTX3tqTtw2lbieuLQRKaLj5P4WffA2NmATzHcj
         cDPbIDS+e0iy7ieerxlgXK8QrHLXgeUt6CIx11teg/jzbsAyTMfxbWP7umo3RNqp3Pfw
         Crxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747963082; x=1748567882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rI/vnFBqTVpLs4/0IdbviGwHNeIm39eoJp7REcUpk+M=;
        b=Ryn0wqZ1xc8KP7UODunGDhZwP3dnHGJysVKCjrJZU3kKu3bMXKD1rgdg/RGIEY82JZ
         tj0fIYsTO00Pa3iW2QQOeHJjBU8Tq7cJV1I/BZBfbXGi6LCZ4gpFCHOr8TZB0kjJAwea
         UWB1mkUI/2fv2pdGE6g6jiPFhKUr6UUZFLqF9BJSha1VRWO8UANr/VPLgeT1/zZPfnha
         NRKNrgzAq9+JqnSu4IW3GzI7uRm459hBZaZmUcJntumFEEnGJMtQGLGvNv/EZ46xq2pq
         Af9FJTZdzl42FWb0vre5NV67HfkfywWMDawcqKqxQSHaaGHZU2KAQpirpl+yGwP59b/C
         ClxQ==
X-Gm-Message-State: AOJu0YwdD3WAO4FWLxumK/YEJ4hqkUF3RcqilltrocQQYKnymY2GY+/r
	j57Zdl2dTwngde90EMy+uiMgPbIo97vAK7hw8Qwn2c5c+vZxdEIIj0EEAetRX5DIDI0Wz4GSuDX
	j6dYH0g==
X-Google-Smtp-Source: AGHT+IHLl5bCAqQXVkkQxqrNz2rEoCWWa5k1A4wEL6dWtWfKB08joHCVVO4G9A0LH9Pbassi3Sg1u1Jjxtg=
X-Received: from pjuw7.prod.google.com ([2002:a17:90a:d607:b0:308:867e:1ced])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1ccc:b0:30e:823f:ef3a
 with SMTP id 98e67ed59e1d1-30e823ff012mr40871933a91.30.1747963081726; Thu, 22
 May 2025 18:18:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 18:17:52 -0700
In-Reply-To: <20250523011756.3243624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523011756.3243624-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523011756.3243624-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: x86: Avoid calling kvm_is_mmio_pfn() when
 kvm_x86_ops.get_mt_mask is NULL
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Guard the call to kvm_x86_call(get_mt_mask) with an explicit check on
kvm_x86_ops.get_mt_mask so as to avoid unnecessarily calling
kvm_is_mmio_pfn(), which is moderately expensive for some backing types.
E.g. lookup_memtype() conditionally takes a system-wide spinlock if KVM
ends up being call pat_pfn_immune_to_uc_mtrr(), e.g. for DAX memory.

While the call to kvm_x86_ops.get_mt_mask() itself is elided, the compiler
still needs to compute all parameters, as it can't know at build time that
the call will be squashed.

   <+243>:   call   0xffffffff812ad880 <kvm_is_mmio_pfn>
   <+248>:   mov    %r13,%rsi
   <+251>:   mov    %rbx,%rdi
   <+254>:   movzbl %al,%edx
   <+257>:   call   0xffffffff81c26af0 <__SCT__kvm_x86_get_mt_mask>

Fixes: 3fee4837ef40 ("KVM: x86: remove shadow_memtype_mask")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cfce03d8f123..f262c380f40e 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -209,7 +209,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 
-	spte |= kvm_x86_call(get_mt_mask)(vcpu, gfn, kvm_is_mmio_pfn(pfn));
+	if (kvm_x86_ops.get_mt_mask)
+		spte |= kvm_x86_call(get_mt_mask)(vcpu, gfn, kvm_is_mmio_pfn(pfn));
+
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
 	else
-- 
2.49.0.1151.ga128411c76-goog


