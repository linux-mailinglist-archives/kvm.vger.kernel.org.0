Return-Path: <kvm+bounces-33466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF55D9EC186
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00D26285708
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273F9185B4C;
	Wed, 11 Dec 2024 01:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LqKA0CZB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90A31494DD
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 01:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733880790; cv=none; b=mEc/Ipve3ZZW8QiMHZAn2XU4s2sL9OxPpgGKd9ccSGCmOyrRUzTTHwnONWLwZHtxiOjNLZ4JsEr4WU93LMmwr7/9cbb1/pdmA4ZRlui//WAcO7Vw8jprEC65rl5f3/sHQaFFsimIlfZjQ9/XudQ/0jUmsVJASY+q9euCHRJYTKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733880790; c=relaxed/simple;
	bh=8b2AQB973t30BilMva2oh6+dpiiMR2E8ld1nNQT09uQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bvcqzwqb7a8Kfi6ns7ygP5rId6VRWcNaHTSqm2PiHxXfbFrlnLzFykziGJEymuNbKVmAZjf00yxEn3Mbba4Xog7tenVuqJQnvGIKyLUEdCHfrKN63ISzYGJMGFV9U/NI00yaB5MCpA+uP7yqtS3t3wa6YRnD9/iz8Eofk6bgdCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LqKA0CZB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso144683a91.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 17:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733880788; x=1734485588; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1ZQbW1xnyC6NfLXQdYONQhlKi+Sr1eS8AiU/xUyBTs=;
        b=LqKA0CZBU8tlKZt1yAKIJRjMyf6Sosu1WYJ7ext6Dm+rCGW8/331Cb0AWd7dR9omWS
         1hq1X//B6sBjHQYsaLocnstE5I94KU17+1McebfZtUi/qUoVz3AWvs5c3jamCfdHgA6B
         EO0TRWZvGkDzz+9OAr1CpQzKTqaY1ah7rr36r4ZlhpBo3rQxh6ywMkYdxGA25cOTefMu
         Bw2Ktz24nuFPuJvQlD5gmuwsHtbF5QFGIZsu2TwP7OQwv9Ivxwxeta1jGFsUxP9mYL0I
         DuY925OfwM8PTFCZyblUQXRrFdBhQHVE2RNstScg4RexxxbcxFacdYDCyzHQtKi6nzU9
         7XkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733880788; x=1734485588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z1ZQbW1xnyC6NfLXQdYONQhlKi+Sr1eS8AiU/xUyBTs=;
        b=Cl6P/2Uim70LqaQhJSWNiF5Qn6a9qDZBGeLWYZa+san/mWTbMyDJt1JxHkV/AtQC13
         DNQQzzqn4Kz957BY6TVbofBa1ukX8PYBQfyrvNDmu0AAHiSw5njpchKrC2Kyt67XOIMf
         CMFMq9RYg6Zgy8s5x6Xxvu766pKilmgASLA5d9MbzjqAGZhxkdRcIYp3jaP85LoIxVgR
         byK8dU7kpqvBsuKKkpECzIVyKwah4K1jDdZQQ+vjdkR1z2EdEM9wENNRk6hy/iA3umS0
         VXGZt5g0UArOPkIOscjNVOmGkmWmbcy4NR1+fnKw39XH6faWqn//JF5rZnTzQivu2EAA
         EdLg==
X-Gm-Message-State: AOJu0YxhXgICXasZfp1CYtlyGEydDoPrXBBa7gyPYEXxoeXJRWGtmBDn
	EgEr/l67tYibX9ZlA4fKP6VTU9T7jTeH6hz05DjBWOf3gxKw2ojLpfBpH+lMF8UxhHX/5yBQpn1
	3mg==
X-Google-Smtp-Source: AGHT+IGfRkEO+FbAOHWSi0VqbHNSTM5uuurs/BLJsW/phFbs70MA0Op9MVaMK8nzudTz1MdEv6o2b9u5odI=
X-Received: from pjbnc12.prod.google.com ([2002:a17:90b:37cc:b0:2ea:adc3:8daa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5447:b0:2ea:6f19:1815
 with SMTP id 98e67ed59e1d1-2f12802c957mr1812786a91.24.1733880788188; Tue, 10
 Dec 2024 17:33:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Dec 2024 17:32:59 -0800
In-Reply-To: <20241211013302.1347853-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241211013302.1347853-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: x86: Use for-loop to iterate over XSTATE size entries
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework xstate_required_size() to use a for-loop and continue, to make it
more obvious that the xstate_sizes[] lookups are indeed correctly bounded,
and to make it (hopefully) easier to understand that the loop is iterating
over supported XSAVE features.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index edef30359c19..f73af4a98c35 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -58,25 +58,24 @@ void __init kvm_init_xstate_sizes(void)
 
 u32 xstate_required_size(u64 xstate_bv, bool compacted)
 {
-	int feature_bit = 0;
 	u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
+	int i;
 
 	xstate_bv &= XFEATURE_MASK_EXTEND;
-	while (xstate_bv) {
-		if (xstate_bv & 0x1) {
-			struct cpuid_xstate_sizes *xs = &xstate_sizes[feature_bit];
-			u32 offset;
+	for (i = XFEATURE_YMM; i < ARRAY_SIZE(xstate_sizes) && xstate_bv; i++) {
+		struct cpuid_xstate_sizes *xs = &xstate_sizes[i];
+		u32 offset;
 
-			/* ECX[1]: 64B alignment in compacted form */
-			if (compacted)
-				offset = (xs->ecx & 0x2) ? ALIGN(ret, 64) : ret;
-			else
-				offset = xs->ebx;
-			ret = max(ret, offset + xs->eax);
-		}
+		if (!(xstate_bv & BIT_ULL(i)))
+			continue;
 
-		xstate_bv >>= 1;
-		feature_bit++;
+		/* ECX[1]: 64B alignment in compacted form */
+		if (compacted)
+			offset = (xs->ecx & 0x2) ? ALIGN(ret, 64) : ret;
+		else
+			offset = xs->ebx;
+		ret = max(ret, offset + xs->eax);
+		xstate_bv &= ~BIT_ULL(i);
 	}
 
 	return ret;
-- 
2.47.0.338.g60cca15819-goog


