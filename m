Return-Path: <kvm+bounces-59353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C64A2BB168A
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80F921C5A58
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05CA1299A9E;
	Wed,  1 Oct 2025 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NYM+UuhV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8708E25E44D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341348; cv=none; b=kSe1dVIZXSOW3dBKokqf3q2TRiUe33B1z0iCoIx7RwOKorW2wZSzP+TbqnrwNVgG5Twu9G7bnAlgDnkHE+igmpPg0V0OBifjrT+G6TZiJtSOUjLrXpenAM1jGC/TT9rr6akBeHNQQKe5qBOOYMyZtVq9niwZyb2ssn16I41WnmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341348; c=relaxed/simple;
	bh=5jvC8RRuPrUJ0404bXz4mepmZC4b3kGsfu7J9kHd0Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P8t8zpzF6zlaN63VcbPBvHWPfajEvYUa85QlWm6sZxGeBfUxkCz6db8W/ti+al+8sQUeGdTsX9v7HUWsJ5FgjWfFCM1VK8a+TRmxYb3vq7DpyFCJkrvJxY18AwiIFifQjjImAusLvtEHPtqk4ni24UuRtzIqj1P0ke8B8VQ0t4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NYM+UuhV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ecde0be34eso752410f8f.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341345; x=1759946145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmAW5Wa2xprjni3CRQ6N2DgDe5FiwN23lEDho++REkQ=;
        b=NYM+UuhVqpuk77to2AzWh23EQ6joAsmSjZQezjy8B4kXkoW1NmK0I2hlmMKHDu8Q9n
         BlXev3eNBTCYArh11IQvo4jzs7u8/kaLTYpjS1IkZmb5Dnrq8ChdfGOa/GPW5EM96GnV
         TRrO/9GrJEJHytH1vQTmMT0K3Vpi6MjU6mFTR21dktHDeJEqfLXcC7LuOUcmmhlZQ3Nt
         TIFRz8vkaQdQ4qTTLgc8cTJKD5hUxJKZlFwJ8EF25PMXWrUVDuzttNiiRfQ8d09eaO1M
         fgfjqDZbr/MV/q20SqTzpDG4UgVUV4OdVHWbUAcDncaczoBdLIBt5BWz24Bf6Urw+AfJ
         NL3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341345; x=1759946145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KmAW5Wa2xprjni3CRQ6N2DgDe5FiwN23lEDho++REkQ=;
        b=EqmFjl9OWW2ItJ4fQYb+tvvRd1b1a1k5UqmjokGJ8ayEKS33gFW4rn9zsJdXylz9im
         JCT2ZOtXAZsf/XZqWBTiDYw2lUCdx6VM0aGE3oxYE0XTVsGhc7sh0a0B7v1fVGJwWZd+
         QfDe07TNsJB6FiAaurf+6reKRIa0o4Km1nmvjKTpHTP2R+D9VmO5RSg9Yef60wJU+sPA
         k2PhE4Npd8rcels2jPJE1qUZUf/cozaC1fYtyGB/p+RqpEv1eXU/nnZlfmwcsJQfmSXX
         vp8XD0kG4la+bHKt3WNEamsUMSYKh/mjkCvUHVvVykFZQLCWD/iEdm0xjAqXSSpIcuz6
         dz4g==
X-Forwarded-Encrypted: i=1; AJvYcCXwcCxVGloAufFr3x6O4uhh+7P4+7ENkpKvOkEsCSvPxY4aw4vTk0q4sMED0zCRdmF40xc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyylPcB6okC56hyZcPvwAybJGysa4DDYf4biSUcsq2CAXBcSur5
	ETAed2sJ2S38X9BWmEini6h5HAx+qn6jHObJGpJDhVyi6zPUGiJ1QGW0UUS8hYzEipk=
X-Gm-Gg: ASbGnctKbFmg6pGENFS2g9zrwUuQmjt+0Q3Vt26Cwq7r3mxIISLM2Y8frXo/Fg0xxDk
	xifbl09/VZH0lgBlOTdHVPr0AKeSECoQWm/sKlHvuOFMcCwlzmB+g7TrWgeZUswTFqFX8ffz5gH
	BLd9Mal+QXyS20LlZtqlxGpq+7faqMzNXR2wWgs2Ef0laDMbXyD7ALmjpTyu+7S+n67QAlgS0Bt
	SzSA3mOm0iWOnXmIj5CdoAetOezvU7U/ZGQ62GTI6+ptV9tjNoUjxdSdrgzrGzaaJKhqdOY7Shd
	MQvWDQm1FYwjYAJd+rh/ZKfz3KDylxg79AOeVbhQ7L477g6Cn2j8d1ZdnczJblDyZ44NQMObvyN
	9hv3U4XK+G+DUo9MgnDiY6uVcgSy8IHkbC+knz/lQyJNuLE7pj9cl1yWwkpxntCO4eRufXw57yP
	qwVks1lmxzQVZb77YYWGfSSb2kRg==
X-Google-Smtp-Source: AGHT+IHlNku8HY2dcBGT95e9TRS1oHVvhrWrx9c4/rAc6yV10BpHA/xJYolz/jqf6VLW92jj9xdZnA==
X-Received: by 2002:a05:6000:43cc:20b0:415:15eb:216f with SMTP id ffacd0b85a97d-4255d299ecbmr353513f8f.2.1759341344950;
        Wed, 01 Oct 2025 10:55:44 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8efffasm98981f8f.41.2025.10.01.10.55.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:44 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	qemu-ppc@nongnu.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Eric Farman <farman@linux.ibm.com>,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 10/18] system/physmem: Un-inline cpu_physical_memory_set_dirty_flag()
Date: Wed,  1 Oct 2025 19:54:39 +0200
Message-ID: <20251001175448.18933-11-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001175448.18933-1-philmd@linaro.org>
References: <20251001175448.18933-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Avoid maintaining large functions in header, rely on the
linker to optimize at linking time.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 19 +------------------
 system/physmem.c          | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 2dcca260b2b..81d26eb1492 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -150,24 +150,7 @@ uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
                                                  ram_addr_t length,
                                                  uint8_t mask);
 
-static inline void cpu_physical_memory_set_dirty_flag(ram_addr_t addr,
-                                                      unsigned client)
-{
-    unsigned long page, idx, offset;
-    DirtyMemoryBlocks *blocks;
-
-    assert(client < DIRTY_MEMORY_NUM);
-
-    page = addr >> TARGET_PAGE_BITS;
-    idx = page / DIRTY_MEMORY_BLOCK_SIZE;
-    offset = page % DIRTY_MEMORY_BLOCK_SIZE;
-
-    RCU_READ_LOCK_GUARD();
-
-    blocks = qatomic_rcu_read(&ram_list.dirty_memory[client]);
-
-    set_bit_atomic(offset, blocks->blocks[idx]);
-}
+void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
 
 static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
                                                        ram_addr_t length,
diff --git a/system/physmem.c b/system/physmem.c
index 2667f289044..96d23630a12 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1014,6 +1014,24 @@ uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
     return ret;
 }
 
+void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client)
+{
+    unsigned long page, idx, offset;
+    DirtyMemoryBlocks *blocks;
+
+    assert(client < DIRTY_MEMORY_NUM);
+
+    page = addr >> TARGET_PAGE_BITS;
+    idx = page / DIRTY_MEMORY_BLOCK_SIZE;
+    offset = page % DIRTY_MEMORY_BLOCK_SIZE;
+
+    RCU_READ_LOCK_GUARD();
+
+    blocks = qatomic_rcu_read(&ram_list.dirty_memory[client]);
+
+    set_bit_atomic(offset, blocks->blocks[idx]);
+}
+
 /* Note: start and end must be within the same ram block.  */
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
-- 
2.51.0


