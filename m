Return-Path: <kvm+bounces-65982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF1ECBED12
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04EB930762D1
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ACC930F7E4;
	Mon, 15 Dec 2025 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ugr8vi+d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D4230BB8D
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814150; cv=none; b=tOs4o5dacGmapgPAPuCb/r9t2WXXP40qjZ5wXtcjmSqc57gZ1J3a5eK7TzdNtpb3/wvjT9GwDpFjpAG2/Lq/Nt+kVfk/1fikhUoF0O/bBwjwAU4kMq+GMfMXZOpBmwdAQtD9LT4w1s8YUkQzFLBMamq0hFmNd6qw2kUBVuC0Fxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814150; c=relaxed/simple;
	bh=/VCI7DQ+7GTI8zeB2aLIPeI3jA56WcE85XhXuFDRCp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PxzO39lSGhDQ0NawPi1dGmZNmV0/Fgwo3ZPKcepqRyA59OdzXQHhEnGtRN287AcbePkImX+dX9uLXXSRPnKyqmz2JaOwleUPK6XUE/ZRIz20QNkAdqm/S3in5R0NmGDb8aF+hKQuwwoi0fyY5nesYEYUDr0femwTZHgFzqN9yuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ugr8vi+d; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4788112ec09so26326135e9.3
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 07:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765814146; x=1766418946; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YA7YNO0BIUCF/IaZgjS1+s+NSnXmnEjkXZMNklvVQWE=;
        b=Ugr8vi+ds12rJlqGntH+GEHNGgS8yEY8ZxahHjSAIMOsLhYHFusxYbVAkMs80uIXfa
         Bm6Ck140uSnvmXAwWTlJR/2Zyyv6um0/2ZVFPkloAKzmMsp6txWWRdHk1tX02EXSpTmW
         yUyBliNPo0GVU04ONiFnwpdLukJP2I4wGkywtPmQkZhT78K5s5nzhtLEeWLb2vMySilz
         BJvKSggjXCxp9WxxpKB2yOT3Tf0sqroH4QJZIMC41Fu+4FLeSK0vQ7N7ZZSI7f+5szGA
         GgLWDUpeV0vmsd+aPezRM3SS2kZkpuOIbka03LazNXsNtUniiIfA3J/lTZHe9nTlS8SY
         SfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765814146; x=1766418946;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YA7YNO0BIUCF/IaZgjS1+s+NSnXmnEjkXZMNklvVQWE=;
        b=HfPvzMKZckaJKY2ANWKroiSm0kImXm9Nc+csklbExTsNRURsGL+FaVBaxGtgAzUJxw
         PpXw/9ISqnLe3XQ4AUgVpXZ96d2V7ld+tdQRL5XGfuH28k6YDFMjLKoLgMVrzvau7Etw
         /UCUI/yGPqdR8sRjokQHr3LajMzwI5roqaQsuRCRveIABZWl3iShUBL7ool2SO7Ggkv0
         XzgWzvAjzhjeXlpSvOpWmXTaPzx+0x3OlRPadrmXFofmlZYmIb+/8GvIqzNjUdQgjfs3
         7egOKk9dPou2gpF50jY4L2hEHYpn8SmWseXoS+S4S7VIAW5vGfWcvt2rZ2SkV/DJoZO3
         wZTQ==
X-Gm-Message-State: AOJu0YwIHVs0k0tZP9jvF//Vy3oXP3ZxPb7ZHQJ6x5/nR2z1fUyaJLNO
	9BoGz33PjbftaBmU2BsJKmBpqIAKV3+YW9T3nV6R2mqlZ33fsdI6kCft2N3OkLtgNAwlkuz6fA2
	/MdQjWZW6qaQX8vgyin8BRfSZOt5JOfQo0KxRs+ReQqj0BRt2wNuwZl+em69J4SJcint59MXPnK
	di9kOfPHTijzyKJ7A+Z4GkPBxZ7Bw=
X-Google-Smtp-Source: AGHT+IHVONBeIFBkzi6rtmUEcrmrzmdxikWNKTnci9gPY1tpEK1eVpHJS0UNsoTsuHS+M0gT57IgyrzmMw==
X-Received: from wmon4.prod.google.com ([2002:a05:600c:4644:b0:477:a678:a39a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e42:b0:477:7d94:5d0e
 with SMTP id 5b1f17b1804b1-47a8f90e838mr109916135e9.27.1765814146029; Mon, 15
 Dec 2025 07:55:46 -0800 (PST)
Date: Mon, 15 Dec 2025 15:55:39 +0000
In-Reply-To: <20251215155542.3195173-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215155542.3195173-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215155542.3195173-3-tabba@google.com>
Subject: [PATCH v1 2/5] KVM: arm64: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The implementation of `page_align()` in `processor.c` calculates
alignment incorrectly for values that are already aligned. Specifically,
`(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
boundary even if `v` is already page-aligned, potentially wasting a page
of memory.

Fix the calculation to use standard alignment logic: `(v + vm->page_size
- 1) & ~(vm->page_size - 1)`.

Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/arm64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 5b379da8cb90..607a4e462984 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -23,7 +23,7 @@ static vm_vaddr_t exception_handlers;
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
-	return (v + vm->page_size) & ~(vm->page_size - 1);
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
 }
 
 static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
-- 
2.52.0.239.gd5f0c6e74e-goog


