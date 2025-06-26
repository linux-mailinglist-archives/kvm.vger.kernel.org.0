Return-Path: <kvm+bounces-50802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C10AE96E3
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FE6B17021D
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D16C123F271;
	Thu, 26 Jun 2025 07:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="kw0KCONi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561EA24E4AF
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923314; cv=none; b=ikh5GzMDQUrTLpY7qWHvTnwifgT0xOLX5ffS1KGo0xdeJeuE2EXwPKnwseq+wb2/tZUeB2g1izzJpfZ7JHG2+AKtPzDCqNKi6ZHesZuoNZTltE/d0usN+jBR9I+jvz7WhPGXAiUPJ008H+Un4e/NGACEJXddRiHcg1hiSBSaD+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923314; c=relaxed/simple;
	bh=0dyOy2xA3w/Q/C9jQnjXZc/TiHPUdzldB5Va5d8VZOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mjn1a8yY3cmPY9ixWS67wHnZ+Aog5b33de90d1f9tziCN/oFiEZVQfBllkJNLE6lNfpYB7omDjMmTf2gnoZ8HK3OFHcWvTDPdr0duHmJNVeOV9nnhWFqQXwDB/FdgyoI5dT0micwO3Cnnqf9hEIpR8b3Dn1mmLhqrw+jOHMOGAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=kw0KCONi; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a50fc819f2so475295f8f.2
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923310; x=1751528110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5j3F0Ab7GiM9m9UzgeiJowbOw4ZjpXnE2U/hoR5lSA=;
        b=kw0KCONixx5EiYzge6iVAV/LjmmHmj5bXPfqVMUjVKb7ESMRNPK6s1CoV2GmD/VE1r
         GhU0HFBB25FDoirb2ob3vmvGa7ALnxn84Xj75mCgukWp53Ihb83g67cYwvTmMDFv1dtz
         rlh9cnIX2YrqABHCvkj0VOHripAWWPxi9FPgmnRQz8tAD1ruoTsXbin1+aDeDim+Jl2P
         VFP9IYQUZO33GAx0efypsMU5TVQZrUt86QpZaTDrEL2+hnxGJfkWBlkiqLvxju4NM9cf
         Bi0RVdTQBwuS2xn9oim9CehgxjsiXYVOKPvIVPk3P/TZzxPO9otVDDXRQzM+vuUxO0Vl
         CwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923310; x=1751528110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5j3F0Ab7GiM9m9UzgeiJowbOw4ZjpXnE2U/hoR5lSA=;
        b=UyS0KxXsi3CGNTdZCxJPKgwKc76z0eUfqNRDAN8fpuks9aaQL/hmyWc5Sn5W2Q6DyD
         Db6d8dyh11ruhn3eN1JyYkcbI4ih1cu44OqAJkgrlfdkIP80KnZugY+3FGCcjN6NsWWU
         CpALbxjxJUjqnM3fsNEH6Ds1e6VAGfw6EU1ROTpTinBkFqswKgxCP8sAbDvyrJekOlrq
         YalDkMfzB9v/gY4avK0oEaeTdBxgK3c88FS7YpFVIE16KNRj/HuUn71yrj9KoZl5Gue2
         rUJGNli9hxe1Q0wgbIVbBHoAqQb5Eed5T2ZmF/FerZfCZU3sgoUuN3XmJ78R7lNygkid
         B6ig==
X-Forwarded-Encrypted: i=1; AJvYcCWQzP91OUfBg4GO3GmKuEahAN436N41NmkiBtDxihkgps87zKh7QDqU1jhvvHjwZvOWW8A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvvmlRSkaDCDShOGOLsa/DhKdYsMDq+mFLVL0bFd9JE9rDENP1
	ujb9E0zOHbgx/mSXOUs6impurAUL3/glSudx897rfNC5S/iLm8jTTqbtpo9PGYVcwGg=
X-Gm-Gg: ASbGnct512/u48bpIwkrfYmq4UJ9BYehERBnzrUwFy9CK2OEDwWy5pX7Ls0qxUKpPaV
	Zz2HTr7IzEU4XnB39uhDaizBIyO6Nr8QSZ0A9xYOhfnT4epUJT2n9oCE13PgwPgBo2t2CGOZTgT
	mKEXTsCFneruE6JA5sO8MHAn5AnrUawWAl1qigjtpKpQkcQQRGrVZ21Vu0G8KuaMcRoa5Ek8p10
	lHSkTRJVDtH1xyhh/HKuOwtQVlmhc6a7XHiCXTSd+n7fAfoSQ7b1yLm8km6bgzUGBnQjulf+JVf
	jhEtc3VOb/EUMJhw3F92OD3EMfgvWsQ+jxPpSb0L65qUdh9eXHzwJqsNc5AXg/ivdicWVoNd4hl
	x7TgKZVN6t4ohrjOQ8DFt7S76PuN91gXG/uygb/BvoeuJqYGKzctbslE=
X-Google-Smtp-Source: AGHT+IHDFC99TBB1hL4iYwCSkUNdxA/zOZ4abUommfvaEVNy+dI4LQicwyVij6YJE+tw2OCcxsp2lw==
X-Received: by 2002:a05:6000:4610:b0:3a4:eeb5:58c0 with SMTP id ffacd0b85a97d-3a6ed5dbcbbmr4621806f8f.20.1750923310571;
        Thu, 26 Jun 2025 00:35:10 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:10 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 09/13] x86: cet: Make shadow stack less fragile
Date: Thu, 26 Jun 2025 09:34:55 +0200
Message-ID: <20250626073459.12990-10-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CET shadow stack test has certain assumptions about the code, namely
that it was compiled with frame pointers enabled and the return address
won't be 0xdeaddead.

Make the code less fragile by actually lifting these assumptions to (1)
explicitly mention the dependency to the frame pointer by making us of
__builtin_frame_address(0) and (2) modify the return address by toggling
bits instead of writing a fixed value. Also ensure that write will
actually be generated by the compiler by making it a 'volatile' write.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 72af7526df69..50546c5eee05 100644
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
2.47.2


