Return-Path: <kvm+bounces-59257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B984BAF95B
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BC631C48F3
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A2B280024;
	Wed,  1 Oct 2025 08:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yryw/4Tn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD9D19DF4F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306973; cv=none; b=iXkyf27aUB9iXSnL1l3o4Y1z9mzyyO98yRMOD6fxIMCgPLNmbrVM1EPrL/UP+UN+/QxdTd6qa39ljG2BX07YvxXSq7daGL2x0eLaAOoWkBbZtoEbhyNxNAhz640sHZM4eu9wfV2W834kfhLFvHa4WFusBGmXpP9ZlQc9lI7wOF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306973; c=relaxed/simple;
	bh=7keHjWahYXQGCkFbBdM0CU3/EUCHSpMy8QGTsmanrMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OvbYL5ihmgaDnkMukA78KZvlxls6ZGZvX/nvsoX4jNsNLoXOTk/L2FxfP49k7UP7xQ5ynXzLroCXgK4GM4rh86Jf7iSiVg/aLpA0HkAc57vh4Sk5SCv2CA92OMFruivQJYNgbTbYLsOLdhBaYYpehUA3yt/gqZatnbV39C291eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Yryw/4Tn; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3f0134ccc0cso4668348f8f.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306970; x=1759911770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bS0AsgoYLx5zmqVgHt+NhBtygpQInsuKcPvgvZX3Bjg=;
        b=Yryw/4Tn1mbAH3gGFtJi8ASfLrKoIdqWsdanjkAs9vSlNnmr400n5NvXetkyz43yxE
         i50/zrk3WO8SNKW8el/hc5aVFu3LAIksLkrXofW7yvBhsfzZzE+PUSyPAi9MkbvTH1tD
         rUcdWyXOG7TiDtO2FMpM+PTKkLxPviRRSD9NtaIh2pie3heEcw/EmcypSX77TsLmaZ0T
         URf2FIXsXRzJYgstfZ8YGTWfyj8uVGncUHpYcNNnmRGiiCpQWQFRnRBGrm5qcNCeqGYD
         Gd85ttk4VngCDHMn/ndfBUlSqAX7+9aAEnVvqmU/QzSjU6nS9g2Ei+1NgjpcQdAdHhQg
         JdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306970; x=1759911770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bS0AsgoYLx5zmqVgHt+NhBtygpQInsuKcPvgvZX3Bjg=;
        b=BCyUpqWlAIW69rHI6LscS5cxtGbE1S0u1OBEhqNsFKYuEjbM9Pnu2eHIBnd7wwcrpw
         ET2KLdwwalPNc4pbau/1RZXtSNkY9f5ZTKTPEfLFzhrK6lGiU/j9HfEGHZAOe30X07uM
         xtccG6i4IXDlxO4wRVbo4I2yyIH/8+XECjHRl3f8efR8oNHzei16xHG/H6KfajaKR7Yy
         shUiUxJcHQHp9BdeBc9ma5DxeGwXpK13T9B3sxHvGwFoIQI6Q+bDxbqo6dXPQKQgKacH
         tO/6rmfKevfwp8bK5n0osbkUqRKnCsXBS1Mi0dIR5z3oDMNSzCOhshg3fkmO1HbuCjNC
         F5iA==
X-Forwarded-Encrypted: i=1; AJvYcCVlox3hFdZlt0RjzAEhVb/mhvtPg+vkWC3iZl9tTT34c+8VhHd0LBXssLk3wW73MORuQsM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxka9bq+QzIHwIFQan9BWpmY3+iklbakj30rUGHBh9O8E8nMpwc
	t7akzgGzBeBPmRUP8rBd3ej4MQoBPe7DVZ9U1L9if0D9STT7ax7R6xIBGqD83gFo7QM=
X-Gm-Gg: ASbGncs2Pf9wHuSrtpACKXx5MP0wzBkTJ4h/QNpoWIUq8NIE23KVwNLXReJSDICKlM/
	hTGsUahAcW9rzcYQD5eAEQ0YlgPiOEhJJC8gksNpdBJQXRfktjiz1sqAAYnknZpZ/csd+q4RrqB
	VdPgOjGYUd/5zmP7U7vj2RDkrIjCcLhgZF9Je1sOI6BdqqfGI9dMi7CaPIj3c2T0eN0u8zBFtRf
	4v1lpFiA2bhA6+QR5CRL28VMtW3WZ3D6DIc48Kt2d4SyA1kmOOQ1w8UJxG+6MqQxDcDlUnHzsQD
	iGPymXnkQ6bqrT0ADYimK7VOz6JenVF8OgCGW4tuhi3klv1dCzQOW1W0H1FqjFLULpp/vO8GWP2
	1jKcSOe2jcX9cXwiKMyjtwtTQPomtOGvRTOqkK7j7NW53WWSucKvRoWR8BZ9cHNMVY22qwgmp7j
	lsPZElkJOctNIRx+mpxlAm
X-Google-Smtp-Source: AGHT+IELRO2S115j4kOaHozbeuDB7zNDQhho1vpx/wRXV7Li514LzRMsEuYYyG6n31n8p/YE2pMIzg==
X-Received: by 2002:a05:6000:2510:b0:3f8:e016:41b5 with SMTP id ffacd0b85a97d-425577f0ab9mr1753806f8f.14.1759306970313;
        Wed, 01 Oct 2025 01:22:50 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb74e46bcsm26245714f8f.8.2025.10.01.01.22.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:49 -0700 (PDT)
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
Subject: [PATCH 15/25] system/physmem: Un-inline cpu_physical_memory_set_dirty_flag()
Date: Wed,  1 Oct 2025 10:21:15 +0200
Message-ID: <20251001082127.65741-16-philmd@linaro.org>
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

Avoid maintaining large functions in header, rely on the
linker to optimize at linking time.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 19 +------------------
 system/physmem.c          | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 809169b9903..6ed17b455b4 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -150,24 +150,7 @@ uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t addr,
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
index 11b08570b62..cb0efbeabb2 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1015,6 +1015,24 @@ uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t addr,
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


