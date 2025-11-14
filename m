Return-Path: <kvm+bounces-63136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5068AC5ABA8
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A035E3B8AAF
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD02923770A;
	Fri, 14 Nov 2025 00:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qdRO9lD1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D44214204
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079199; cv=none; b=o5j8OyQ4BL7ZEilsH1bWsdR7ib3RHV/kyNmpIxU8zR3x/48xlFYh49QtQkk6xgh1DUUl1DGSdNpctP60H8wOdHKpxhTGq1+B5wnXHynpUvC/H4uS3eu+VHY0pN94uF1z9ZMRZjO8SrhTwWezHbaMr4sZGdI1w3EIzSsLdRYFhIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079199; c=relaxed/simple;
	bh=Psf45lpuMxvBIdE9eelJdc9urNNALgw+57nl2EoW2Eg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fc5f9+4+ReIgliVdTSlKlSpGwn1tlwdvdNtcRAAbP0PZ6q96uofqSqkA3XePKGkWOaNaUvl/vVNL7XLZu5V81BVEJwBsdd3O4LjeJzH4UgALYmL3ynNIJYe5iWZ9eGAD4MluHo2maiCd7wDGW/3yWfAJifEWi0K8hN+JfRUXOf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qdRO9lD1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3436d81a532so3112078a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079198; x=1763683998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N1xSBg20ljULzru29O07DSub2YAK3TqFj8H3Wl2csFA=;
        b=qdRO9lD1MQ6m3tn6GFIsfB7JiEdUTuwSKFZLmKdpkkcQf1VVZmJ4nnREs2tNnix7vC
         cORRQJ2nhLVOzv4mQ+ktVr5EOHqBm1m14ceDjT8Ah+aZYw5Dx/I0eopZWCZPgsqwy82G
         wKSvEerW9ftm1uEvB+QHonJTE//R357feeZY2l6pVk13Ov6zT1FNHJS96tsw/w0IEh6X
         6KzuUBOi+VrjTMfSn/VVuKa3cQfqWae4MDoY43638edN/s1lqX8LJC8KP4DV3MTh53Cq
         3ahF7RONp2FdieOa/H2BzanGGwr1ldAtREvTvBhbHZfgTecr8fvPXrLeZqqrRSAwLX1S
         nC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079198; x=1763683998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N1xSBg20ljULzru29O07DSub2YAK3TqFj8H3Wl2csFA=;
        b=DslCI0vYRPyIS0qW7vkkc5l7wW+ZxEhfUpiBvoLJ7ZrnZcx5NOHLJruPhQ42VhdI56
         6vaijO8M5XC4C9SbpX54/YfugBVYPsXjaTsyck7kr9HiZti6ginsaRRV7I6lNtGL4vFn
         rQ00YRmxdR3Us3/o0nAh89Cus/XOYOoQ0/lPoeM9MxiANOzWYCkcxD5h23Cy4wmXAHEf
         KV+d8z7JWV9b6U7w3wiDL2xKWv3p0PwdyYtFpo/jwB84s+pQETaoLDA7NN7aACps7Fr2
         tDIZwnNypxoMxWBvTFp9WmFjaEzOfbFY/hGOEXeeDTKuohKT5HlKjLm1zSfHRY3viiiP
         i+QA==
X-Gm-Message-State: AOJu0YxUBaKcFEJjQFjlfSRPm9Lj6O6YwVDCH9ztFp68mQZ24wFGKD91
	HiNAphKAiuKfr+QK4o04d0RxaWlXF9GUJw5Z0/jlt6gD1RodlA/h3jjw+q7HSYWks1JIhbWQdUH
	zy3n0Ww==
X-Google-Smtp-Source: AGHT+IEYIPOIT5Qnfvi/j0GtgSEbsueRQxvvammoBFdV/Aa55m13oSmM7tNTDbJJMVXieWQ6vmOmcr+ijO4=
X-Received: from pjbfz9.prod.google.com ([2002:a17:90b:249:b0:340:ac4b:f19a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350c:b0:343:c3d1:8bb1
 with SMTP id 98e67ed59e1d1-343fa74d073mr1025730a91.28.1763079198030; Thu, 13
 Nov 2025 16:13:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:51 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-11-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 10/17] x86: cet: Make shadow stack less fragile
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Mathias Krause <minipli@grsecurity.net>

The CET shadow stack test has certain assumptions about the code, namely
that it was compiled with frame pointers enabled and the return address
won't be 0xdeaddead.

Make the code less fragile by actually lifting these assumptions to (1)
explicitly mention the dependency to the frame pointer by making us of
__builtin_frame_address(0) and (2) modify the return address by toggling
bits instead of writing a fixed value. Also ensure that write will
actually be generated by the compiler by making it a 'volatile' write.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 80864fb1..61059ef2 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -10,14 +10,14 @@
 
 static uint64_t cet_shstk_func(void)
 {
-	unsigned long *ret_addr, *ssp;
+	unsigned long *ret_addr = __builtin_frame_address(0) + sizeof(void *);
+	unsigned long *ssp;
 
 	/* rdsspq %rax */
 	asm volatile (".byte 0xf3, 0x48, 0x0f, 0x1e, 0xc8" : "=a"(ssp));
 
-	asm("movq %%rbp,%0" : "=r"(ret_addr));
 	printf("The return-address in shadow-stack = 0x%lx, in normal stack = 0x%lx\n",
-	       *ssp, *(ret_addr + 1));
+	       *ssp, *ret_addr);
 
 	/*
 	 * In below line, it modifies the return address, it'll trigger #CP
@@ -26,7 +26,7 @@ static uint64_t cet_shstk_func(void)
 	 * when HW detects the violation.
 	 */
 	printf("Try to temper the return-address, this causes #CP on returning...\n");
-	*(ret_addr + 1) = 0xdeaddead;
+	*(volatile unsigned long *)ret_addr ^= 0xdeaddead;
 
 	return 0;
 }
-- 
2.52.0.rc1.455.g30608eb744-goog


