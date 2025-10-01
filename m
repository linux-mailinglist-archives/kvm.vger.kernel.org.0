Return-Path: <kvm+bounces-59264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C967DBAF976
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FDFB1922A77
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C36283130;
	Wed,  1 Oct 2025 08:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TAI+azL2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6844A27F75F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759307015; cv=none; b=Jx92AY/W5vew9oKNF+u2G9ASm4rnaEYUYA6Azr+dB4bYIun3V9kYEsmv2OZ87TasydxUJezM6qVVHtl+/0w156klNtFZYGZ1D9N2fJB2HLBC//A2S2Pg7dWjnTonA0YJtQnCkG54W5dWm8bpigHnEbj0ypPnV7b8DGrSOogYxL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759307015; c=relaxed/simple;
	bh=u5rez8eB1rZ7eT8zlHEIPEamQV3o36mADH9Rvegh82I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sSKJDv5Fn/Z2cu682CvNg4eVGWOn0ahJC2dfPMAGn5DFOk5Wr4YUN0A8HnISzhjrdThBe3a+D7WIkoQQ06hDDoB5l6vIaOfcdBThPF8v9si/11TdBqzpNzblTnPpXGS+oFIhZOhd2ZxI/COcqAy4Ildk0cMX22gu1YQpZMxDzh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TAI+azL2; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e47cca387so50720005e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759307009; x=1759911809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zegXXCpa9ASQOrNtWqt+ADNwdFoZ3Z29Rva7UQGyObo=;
        b=TAI+azL2lqZfl8LlWaVhcgcsRpmKNQifUJmBqKZb71q56FyuQtJ/tenw5v/UnV8FnF
         4H4yMWCzdZUEtCR37gM4MHTBRQmtdbsS5KhadPl1slcRILhpm6nfdqk3J6ZwWLSIeft5
         9jK32AOOS5oNXUnGWJV8nh9c+GysiUfRJDjasBzrDFOJFxeoDf4twBIGt8dbaBY2PMqU
         zKxCjBm0cHn28uQqXXuTJTDwhUV7bYNXhrd4LwruPRrgT3sopKUdnZqPwyhaDW0bUZmd
         sJQ1ypa6FP4I+Ohr0rnuW2atBTksnjL70BB/cZsdYNrZJJ7wW90YlpQ7GDoeoyjhxtQy
         EHvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307009; x=1759911809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zegXXCpa9ASQOrNtWqt+ADNwdFoZ3Z29Rva7UQGyObo=;
        b=UORHItWfFpvp0iAQLTraAaDPZWenF5JDDvtwsOBKCRW8/5VAbpSaFc+ASgdWZ3DILC
         m00VjboCVRFsAENocQ1fk9CEpFYTFUS1LRYP5hC2xGpHpnhx5kRV5YoW+U29Zhr5SYS5
         hw6RTEupLMXma6MotQGlkx+kEaGRvw8LbXm1he9L7dqBxsw/Fugsd76NOHwmGuUrlavg
         uP0t7LzosoMys5mLdUfXouja01TV+Ieo2mLeqJdzqTomNmb3nfdydDlLS6OypU7n+U2S
         P3StMMJ0F5jE6MYZpDAmnuY7K23Hq3Z9otlLaMqNWedfKDuxMqWP4XMTQKPL2CC8bPuz
         e3kw==
X-Forwarded-Encrypted: i=1; AJvYcCVE9wqPGzd07n21AZnpQB7ptVWDKoGj69Nd8P+YgHx98cSClbJREP2duxMqkQiz7bpVkX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVJLPLGRgd3bEkP+lcCHss+8Zw4w0kyMa24v3wpGn5wYRlyAoL
	c/2XW1sqCDkqp2AwGfBEgjXuclhNHwwuVBTKfL+5gMJ2PQo46G5p85dCqlLB996vc20=
X-Gm-Gg: ASbGncuNk6N3Pd/Y32BMDB5xuL0tbp2q463B7vG25J3utS+95DH4T/ODhDf5ddT28U9
	6uXN8olfIzggD3qKvIGrbrtdd0jwEFBfa5BgkdrOqDfC2YYkVMWuNzDy02QT490F1oU3Ne1xYNk
	fkBGk1luIj9uMB58odGKVpfNLpt1tNW2q3xiUvuNJZoY301n9FJ/tw0InFL3+KjzcU2oDQxANho
	k3ALZkJGiyUKpjPOrG2AbsXT8dWBca/D6IDbnjoGp5oDi2tmCI1tSXReJTh2RM+s8oWoEFCslKm
	GamuWmqdC3DwM9rw8NunRqkhlIbj6mbbnIEnkDseGb1OOAgZw5TXLklTBmJqSbYHreFU7Z/2jIA
	4f+NVte+YR3V/tvVAT9SAvF276wZUbMC9LBoKH2fuFCdHOzGCaNSNdp7ts+JW7ACE5bbuDpmiiE
	30WY4C3JLtpuWcSuSmV16s
X-Google-Smtp-Source: AGHT+IG3vnUwmmtH6S8njdb++5bFx0+A0p48CnO15CBnkP8W5zkTavOHjjeODL9wCrfaHIz1bpH0yA==
X-Received: by 2002:a05:600c:8b71:b0:46e:1fb7:a1b3 with SMTP id 5b1f17b1804b1-46e612bc098mr20498785e9.23.1759307008619;
        Wed, 01 Oct 2025 01:23:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5b6b4cc0sm30642885e9.4.2025.10.01.01.23.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:23:28 -0700 (PDT)
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
Subject: [PATCH 22/25] system/physmem: Reduce cpu_physical_memory_clear_dirty_range() scope
Date: Wed,  1 Oct 2025 10:21:22 +0200
Message-ID: <20251001082127.65741-23-philmd@linaro.org>
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

cpu_physical_memory_clear_dirty_range() is now only called within
system/physmem.c, by qemu_ram_resize(). Reduce its scope by making
it internal to this file. Since it doesn't involve any CPU, remove
the 'cpu_' prefix. As it operates on a range, rename @start as @addr.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 9 ---------
 system/physmem.c          | 9 ++++++++-
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 3899c084076..c55e3849b0e 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -177,15 +177,6 @@ bool cpu_physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
                                             ram_addr_t start,
                                             ram_addr_t length);
 
-static inline void cpu_physical_memory_clear_dirty_range(ram_addr_t start,
-                                                         ram_addr_t length)
-{
-    cpu_physical_memory_test_and_clear_dirty(start, length, DIRTY_MEMORY_MIGRATION);
-    cpu_physical_memory_test_and_clear_dirty(start, length, DIRTY_MEMORY_VGA);
-    cpu_physical_memory_test_and_clear_dirty(start, length, DIRTY_MEMORY_CODE);
-}
-
-
 /* Called with RCU critical section */
 static inline
 uint64_t cpu_physical_memory_sync_dirty_bitmap(RAMBlock *rb,
diff --git a/system/physmem.c b/system/physmem.c
index 9e36748dc4a..40ec67572b0 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1140,6 +1140,13 @@ bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t addr,
     return dirty;
 }
 
+static void physical_memory_clear_dirty_range(ram_addr_t addr, ram_addr_t length)
+{
+    cpu_physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_MIGRATION);
+    cpu_physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_VGA);
+    cpu_physical_memory_test_and_clear_dirty(addr, length, DIRTY_MEMORY_CODE);
+}
+
 DirtyBitmapSnapshot *cpu_physical_memory_snapshot_and_clear_dirty
     (MemoryRegion *mr, hwaddr offset, hwaddr length, unsigned client)
 {
@@ -2076,7 +2083,7 @@ int qemu_ram_resize(RAMBlock *block, ram_addr_t newsize, Error **errp)
         ram_block_notify_resize(block->host, oldsize, newsize);
     }
 
-    cpu_physical_memory_clear_dirty_range(block->offset, block->used_length);
+    physical_memory_clear_dirty_range(block->offset, block->used_length);
     block->used_length = newsize;
     cpu_physical_memory_set_dirty_range(block->offset, block->used_length,
                                         DIRTY_CLIENTS_ALL);
-- 
2.51.0


