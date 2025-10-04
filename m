Return-Path: <kvm+bounces-59491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B69FBB88C7
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 05:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6A7A3C8AFE
	for <lists+kvm@lfdr.de>; Sat,  4 Oct 2025 03:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD55C1DE892;
	Sat,  4 Oct 2025 03:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwaNt6H2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CE614A9B
	for <kvm@vger.kernel.org>; Sat,  4 Oct 2025 03:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759547359; cv=none; b=XWGgvTrJj/eZVr8rBCG3ZRHxiio0pjCm28Y0cdG43/2/9XqxzfsH/orAfpTeGez04OJEEED1kPfjKmMpxZsSuRcwHdxyWcO9V+VELJ87cfjGUUAYx1YRH6UReQZTGXD+I1WqBRdiGCpdQMAdO8gkM7LHw3e/02IDA7fVJPcRazQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759547359; c=relaxed/simple;
	bh=l6Ef44f9+AzpaixRgRAp8RGfj3Zk1wioLQw76MXl1So=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jtkgvLzbkhOmKt6Yi4I6J4Ahgayoo1U8j/pz8cNgjoBgay7qpl13euKm2QmQBYe5ZrlSdl9UeHQ2EI89spuzsJOjoEAeQJGzZ1klg441bcvbgrmxYnZX8sN+cdqJWFWfiSj0euPmre+sSKL8on5D/TpTl7yoEhMcNLOUM6xRLeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WwaNt6H2; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so2474551b3a.1
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 20:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759547357; x=1760152157; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=llyEZQY0mloy3RaEkBiyvFLO4+4gWq62N7isj8QKbEw=;
        b=WwaNt6H2/F/9Aj7vcBh6AQfceOq9RJHY3327eZRF2uYiI+lh5Jez95gMP2+/DIhWIV
         j/OKQm7LnnUVH7TqMbLqrxjSSx22DFgVOtCO7KGToTGpdZrNUosIeFlzrwFKbJ1TxlGX
         a3GdMLt6fHc541MAN1DfpqmGfH8heQIlwT6DDRE8xXNOH4YYMn4NCBMognErkrvwGoPP
         Iz9te5yjvVKFjeeSF9/lVa708f50gbCqh9P/k3qeGFKsyiz8FWkcdX/V9MsW/bNORffu
         fVYrjFhRhNEdBR9tcVxr7IMs9AzqLITcxFRcNIz/wYic134Pa3tFHsTkF0hbsR7z9JaC
         FXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759547357; x=1760152157;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=llyEZQY0mloy3RaEkBiyvFLO4+4gWq62N7isj8QKbEw=;
        b=FyMWM1tQJ20GLV0+KiMcCFlXTrsy4eQBtBes0HJIAFGYCszzmvuKfqg6yEAhRmaZlM
         OR+/8w7+9ta8rajDj9lF4N+WpORTzDBI4ln5D7a0/76x2aAy9tyPYouPjYfKcJlDuNPb
         YXmse0bc/bfmTYDDzkpaa0XuKQvOjoSO6QhelgAi3VAhznKvlstYfO7/CpDJlWE9SagX
         yu5BYP8noV/gaUhJSvdsLVFCTWYd+mv6dDSKXr/jFHfO8W+a36KHPoK0x11SQu8a3rn2
         lCgnKiPudlqEm8Ix2BkvGbRuMae1lkhLbWGvN8ltfLtzYBFm3ca6G2WskMXFj1oLYbtO
         CNHQ==
X-Gm-Message-State: AOJu0YyoTeoaxAm8hBr44mIqCkHZDK5mYgnPicOiGx3FQhlKbScO/Vu1
	9eOi13ZoSsXdlTXANaPrdoNcNYqvRx5R4IyVjj2fHZS3x9Sat42ZLgwC
X-Gm-Gg: ASbGncubTTOXc5xBYr1W9Koyoqp3iYCDs3kbHYPTSJvZ+v/kx5NTb2cDPapTcWKpGy2
	8z/OJQ/6gQ4IjLiDBi053rugjyDAM3s1XA75agjswf0kQTpeGCQuXHCVhnsPbWhCrV+agV5pscb
	TysRUBdyCytCCYLxGiDTPOttMTtecvuDd/z0ngwguHE/R/3SWiceEXdrOTb8hr3fIehx+djDufI
	ky1d+YN1P4w55S2zAe/Rmd6Ni1sLd7Z1TB0ILVF8Ftj7vEfUkur3xtnNX5P1ufDtvnr/jxuoYv+
	wCy8KHjudnSLnwVDkjuXJQnQEW4F43KgX/VH3TjTj44+6t5vl/EVCcY1BbjrcyTKC6AVWku6W1t
	XYRjkzktFpnbKGqLbgtgY8xTK6U0lgImxLn4Csoo9J8EhejyGoXlJrsjmbkpkVw==
X-Google-Smtp-Source: AGHT+IGn24rRAn3ohvoYNubWucjGX8u0BlqwWrNTlIP1SEBmyKD0H/UK+YAx711lmWxrLLSbDrTeYA==
X-Received: by 2002:a05:6a00:4fd3:b0:77d:c625:f5d3 with SMTP id d2e1a72fcca58-78b021ebcd4mr11645062b3a.1.1759547356824;
        Fri, 03 Oct 2025 20:09:16 -0700 (PDT)
Received: from ryzoh.. ([2804:14c:5fc8:8033:c5aa:36f3:14cd:8995])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-78b0206e809sm6256279b3a.71.2025.10.03.20.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 20:09:16 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH] KVM: use folio_nr_pages() instead of shift operation
Date: Sat,  4 Oct 2025 00:02:10 -0300
Message-Id: <20251004030210.49080-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

folio_nr_pages() is a faster helper function to get the number of pages when
NR_PAGES_IN_LARGE_FOLIO is enabled.

Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 virt/kvm/guest_memfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7d85cc33c0bb..5fc5475cf826 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -77,9 +77,9 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 * The order will be passed when creating the guest_memfd, and
 	 * checked when creating memslots.
 	 */
-	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
+	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, folio_nr_pages(folio)));
 	index = gfn - slot->base_gfn + slot->gmem.pgoff;
-	index = ALIGN_DOWN(index, 1 << folio_order(folio));
+	index = ALIGN_DOWN(index, folio_nr_pages(folio));
 	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 	if (!r)
 		kvm_gmem_mark_prepared(folio);
-- 
2.39.5


