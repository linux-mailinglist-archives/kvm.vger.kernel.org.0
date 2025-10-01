Return-Path: <kvm+bounces-59251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B420ABAF949
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B336189AF54
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A759827D771;
	Wed,  1 Oct 2025 08:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kkqLsMus"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B29279782
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306941; cv=none; b=dc7U/89cqHcYNCJFWcGrxc19QYwLl5kAEBSHpIEgD1DEVToqTAtuSUsX5zHYk1MuJ79rzemm0z+WdjSb6RRN7nMjKZKivRj7Q9koqD8tp2cFga4O+/GY/h14ssajbeIvsIBjxi+CNmeXVRY3/4XcsWEhzxi+IEKz4QsytcdPf04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306941; c=relaxed/simple;
	bh=47tKDe4X57owZTcIWqckgKYIFMkk4prOJq0ArTuwAuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S5BTgqbc9CDyHgBNTq2Cn+VQmggUXszNK4XJfB440CIrBy/d9c2hzRBjKtlqMdAUvWKLm+w2rAIgORsFTFgEu8Z3TuyX0wiVmOZ4NohpcZOHHQpAPrRp69lTFnZ5ESuYpV5iHwnrrjy1TJ2TaO1pUc+bmt9HA0gKN9bUEQ6OBGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kkqLsMus; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so61752415e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306938; x=1759911738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xhfwnxQYenTq/tp2PJW4+khvxCsXeRr52wkCrvc1Lg=;
        b=kkqLsMus42MvBOhhj4XfaazSxb8dADs0MPZAxm7N23HJCL1ZZsxaSvCFhZGHXy/8+j
         55vKT5qD1CsGypIyRkvwF0cskxZekiiBtxRxQKj1y2zEDFzz+OORZg0BnrMHOTup1iOZ
         ucVr7zClN4sOryoiEZSXZBj3JL3gJ6gFcgvyhPkQ8MVt/L6GUNDDQ8wzJ01Td7nKE9bq
         KsexjcaaZhgTaKT6HUwTZRdSUuR6d9UiE1zmryYMsjwY3e9Pa70RHn/9k3JRPqaHI2+c
         Ot9AX7nb6u/z8WmylovfcTeHAuMdFdL1S9B8NXDHvc4E0dcF6InuKqpl+8+tU365A2BU
         NK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306938; x=1759911738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xhfwnxQYenTq/tp2PJW4+khvxCsXeRr52wkCrvc1Lg=;
        b=Qqrb4HE/l/iOFcs6t3OOoeUP1hxch+xhrE+uTv34jfD52eoEzCIcU5AwWNjZflgKN+
         R4xU7H/8jP3F4NdJHLK10ssTXLCNcuwzhPszZnU77sww0IV/8tV9vszcdUmKhz51o2Gn
         fmN80mXY0mk13SvhM+RYfLDdRClCQ/mrmqFV+rWS+hhVpw60KlCyn2ziN6Uwvxvan8WQ
         DKkmaVi1wEBnwGUCn6dD9nO6BD9JBsya1mjpcN5vCQnhUGIsVaxSyFR+w4cIdpDD8UBB
         nSqV13HxgpG0cboTHIqjrerOQaESka5axBnjtXRXdL4zfR1AxpguWpgUC4exB7rEsHcF
         /ILw==
X-Forwarded-Encrypted: i=1; AJvYcCWr5usa51W0Y92+aqNjSv0ah2GDmS64PPqp8OyWjsDGDdo95R/O1/DguaKyuISJL6d9xf0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZOxyQ14LLUcg7KtD8KQuYlGnpR6jMERS3rRl34D43wk4FVA3L
	Fd96Lq2ZRiDFb8unxzIGOQ1Pzyez3dakJUkFo2sbG6HYsPtSG6YlsBeK9kZymzOS5eY=
X-Gm-Gg: ASbGncuqk1xGnLrc0uuDeEKgE9tQAc2Hr65C+k/ole4YIbeRVJhpfOtDEMGwoy4+oIY
	1V1bRomWdixjx810Y87F/fFUhh1UPVM7C0hqJT8JTTygGsxgY3zl7SKagQFUaWpkBub8LC+0nPv
	VGDzGrYivVmmDjxqk9KJy3yjIFbzhq0EJgijCuvayi5kn/Iv5Uap7fjrf+BCsNGLVZLuhqz5v9g
	whdvJkkAFCbxaIVapubcHB3jTNQrHSHo/YQxZ3uPkGCvtiu6hu4I72j5ffqRb0qoVmzpj4636IX
	SYOKa6X6SdzgJ+H/UCAxJ7LfGDLSRz3sqhoTguFvnuDXHvvXHMPNVgCkL52j6dcp1PR6CueupTA
	mhZQv5urPI0GxsvQjm61xoJwzmEhghslhZoNGWz+Ro1KKcVRX3OPjqPrVYBvw3UEizAfcYzSvpd
	BeWJhyi107zkYUiECFCYahVoc+lw9g5jg=
X-Google-Smtp-Source: AGHT+IE3/WBiSCnGGpTVJZHThDWbhBUy9EPBmlkD33neM3UntZWo4n6MtKxXgYiQOUKYg6/g1hOLew==
X-Received: by 2002:a05:600c:524e:b0:45f:2919:5e6c with SMTP id 5b1f17b1804b1-46e6127c38emr26519685e9.16.1759306938235;
        Wed, 01 Oct 2025 01:22:18 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6199f589sm28791645e9.10.2025.10.01.01.22.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:17 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	qemu-arm@nongnu.org,
	Jagannathan Raman <jag.raman@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-s390x@nongnu.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 09/25] system/physmem: Rename @start argument of physical_memory_get_dirty()
Date: Wed,  1 Oct 2025 10:21:09 +0200
Message-ID: <20251001082127.65741-10-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001082127.65741-1-philmd@linaro.org>
References: <20251001082127.65741-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Generally we want to clarify terminology and avoid confusions,
prefering @start with (exclusive) @end, and base @addr with
@length (for inclusive range).

Here as cpu_physical_memory_get_dirty() operates on a range,
rename @start as @addr.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index f74a0ecee56..585ed78c767 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -142,7 +142,7 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
 #define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
 #define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
 
-static inline bool cpu_physical_memory_get_dirty(ram_addr_t start,
+static inline bool cpu_physical_memory_get_dirty(ram_addr_t addr,
                                                  ram_addr_t length,
                                                  unsigned client)
 {
@@ -153,8 +153,8 @@ static inline bool cpu_physical_memory_get_dirty(ram_addr_t start,
 
     assert(client < DIRTY_MEMORY_NUM);
 
-    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
-    page = start >> TARGET_PAGE_BITS;
+    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
+    page = addr >> TARGET_PAGE_BITS;
 
     WITH_RCU_READ_LOCK_GUARD() {
         blocks = qatomic_rcu_read(&ram_list.dirty_memory[client]);
-- 
2.51.0


