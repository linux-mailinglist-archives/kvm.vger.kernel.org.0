Return-Path: <kvm+bounces-59252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6FABAF94C
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D12881C4A6F
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D9A279782;
	Wed,  1 Oct 2025 08:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MuZ04asq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D1227A465
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306947; cv=none; b=X3K6cD+d75QpXuyXgtRNvCJYGXmJ2Ervv1ejZkixSuuK88UvDXSmEBwhxRAq/E0xkTZwafuBs0TyKkygGJLu04Ok+hTcnlqODbeARscD/37d72orMhmkaw5qq+apNaQ8sOAb0CfFdG/iwJRGetIsvuCp9suo/R0RQsAlgNTyJMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306947; c=relaxed/simple;
	bh=QwqTg1slhVhE9msF6oYyY9ne36SmUVEXuOlUoiD3SeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W38l/jt+5OJs8/JHR8XFbmPjFTjUIGm36PKgFsVg81go+yQctLfAMiSGYQhQZ6BUOeA0a9PsfPif+X8O0+KHS4+2VcGXIl4IWeIjhK+3FEDeewlB595gDkLGAd8ga25F1sH3FwK2+Jl30vnyyOkcaQbECYN1PdPfKbH72FzOs4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MuZ04asq; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso5691406f8f.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306943; x=1759911743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gfs8F1Ipyz4H9B11C2jVRNZlMC7r5eBMH2+MLD+93zw=;
        b=MuZ04asqr2IXn/ER+j8DuEEN/qnmBsaBfvVuROjz6xe9jvHDkeJwHyND5yeMlDg25L
         5YZ0ztJB40kH22QRmQASgNYVE0Q0jnukreVO9vBRfJC73sDVMqFwf5GCLW5Gglmmgx67
         FXadsJYeY4X84vHBc0FiuQXqs3LT4Htcbh+zQlQ56N/G8rw0zm6i8VvQNf3pBJJ1+Ot+
         IF+YsOq95Vgf0My7ePNeyfoSef1RZN5zgb0WCxY8JzQTC0mvv7ZPCKVL+OgISLq/ErNt
         1zMrHZ8j65c5UTUZj8siPq+s5Af2BakIea234zLPKbkalwM3eRo95T1qSOyjZCV8VyFW
         2Ljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306943; x=1759911743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gfs8F1Ipyz4H9B11C2jVRNZlMC7r5eBMH2+MLD+93zw=;
        b=bUUVqnYBk/uAcfdkQPxcia+iO+DwMnJo9VOVArP8Y3EkS+KYx0Vv3nfTLqnqFASL8r
         zw+tyiWLwPA2W0SopjvNgcXhynnDkeKsT/lKzvRgfTRf9Udt781609F0Y9sQcoXf+Jaf
         m/600iTpKrGZErwe57v+DzkE94UUxprwP17hE1DxxhfGApNXUqGHbls7IhrZpn97dVge
         nRHoKnrnr13l3Kkh7qzsiAConmMrFuhf0NiXN0oBBr5JrYwQxRzbeoqrPiVyIjgg4QDp
         vIoLkdq1NW6qKVjRhuhiGzDMzULja8lfu3gft3pLfgKloIn/X/WscxYb/JZxtYBj9RrL
         sVAg==
X-Forwarded-Encrypted: i=1; AJvYcCWLazSQLutPVdkJQODkYtob0Jaku9KLBRbQpPvF0zIsZ6DCY6pXi50kIGwXvPbu/iKmbSY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyWLR1ZX76XRS1ZvF2eO2/XkR4Qfo0Ao9HmvkRcBi6nJKr97FJ
	JC4gPNynlbgBr/wMqpgcGRCIb7MSb6tQdZE3LAy1vYFHMQGOOyJif/5EJEV+lkcuj2s=
X-Gm-Gg: ASbGnctEScQ4/A0L4Ns2C/rqklGv6jy83kpmr/JW6kxFFjGXr+/YvOpV3HiH2xCjwPw
	KjUcX8TBcYBlyvipMQf6frpr6HF/epv0dyzwOPkoD/zjyehnqx0JYyIzdvvjxAovlSKogbuAX2U
	vhpuvZbIs5xWKRN4WrWG+UIMOnAlNjEguhJnLnTt3q5SZsMvrIC3ZQCqePR9aPNjfy3HAAZ3FRd
	1JwZbaC+nFRhdzzDjoytekBDEwi6hyrforffsIXBJrUpDhRCBRXF/XVHWnUXLxmXBDiOcx6Zh9M
	ImAv970jdseUL/dJj7TvZI3R65MMChPCTs7RuBdZWjOJu4iKkMETTH0Ov+AhAI6lkpmBg6rgZTx
	X1X3/NzrvLiXTED6xTVqC6+eLG8lPFYfguqv/7ypj0Af8GxSYmMtNnVxuDm3lxEDuCO7W8LqUxq
	82W+2jtkQiPnR69nvaMKyN
X-Google-Smtp-Source: AGHT+IGL9WtRdKQnKp3M6w/rb/CiOweA4I8JbHvDy9wOwcjwPw35D7mEMtHwDBAMRcJx5gheiFl6QQ==
X-Received: by 2002:a05:6000:2086:b0:3ee:1233:4681 with SMTP id ffacd0b85a97d-425577f32bbmr2123755f8f.23.1759306943546;
        Wed, 01 Oct 2025 01:22:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb017sm25936129f8f.3.2025.10.01.01.22.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:23 -0700 (PDT)
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
Subject: [PATCH 10/25] system/physmem: Un-inline cpu_physical_memory_get_dirty_flag()
Date: Wed,  1 Oct 2025 10:21:10 +0200
Message-ID: <20251001082127.65741-11-philmd@linaro.org>
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

cpu_physical_memory_get_dirty() doesn't involve any CPU,
remove the 'cpu_' prefix.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 46 +--------------------------------------
 system/physmem.c          | 44 +++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 585ed78c767..f8a307d1a3d 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -142,46 +142,6 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
 #define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
 #define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
 
-static inline bool cpu_physical_memory_get_dirty(ram_addr_t addr,
-                                                 ram_addr_t length,
-                                                 unsigned client)
-{
-    DirtyMemoryBlocks *blocks;
-    unsigned long end, page;
-    unsigned long idx, offset, base;
-    bool dirty = false;
-
-    assert(client < DIRTY_MEMORY_NUM);
-
-    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
-    page = addr >> TARGET_PAGE_BITS;
-
-    WITH_RCU_READ_LOCK_GUARD() {
-        blocks = qatomic_rcu_read(&ram_list.dirty_memory[client]);
-
-        idx = page / DIRTY_MEMORY_BLOCK_SIZE;
-        offset = page % DIRTY_MEMORY_BLOCK_SIZE;
-        base = page - offset;
-        while (page < end) {
-            unsigned long next = MIN(end, base + DIRTY_MEMORY_BLOCK_SIZE);
-            unsigned long num = next - base;
-            unsigned long found = find_next_bit(blocks->blocks[idx],
-                                                num, offset);
-            if (found < num) {
-                dirty = true;
-                break;
-            }
-
-            page = next;
-            idx++;
-            offset = 0;
-            base += DIRTY_MEMORY_BLOCK_SIZE;
-        }
-    }
-
-    return dirty;
-}
-
 static inline bool cpu_physical_memory_all_dirty(ram_addr_t start,
                                                  ram_addr_t length,
                                                  unsigned client)
@@ -221,11 +181,7 @@ static inline bool cpu_physical_memory_all_dirty(ram_addr_t start,
     return dirty;
 }
 
-static inline bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr,
-                                                      unsigned client)
-{
-    return cpu_physical_memory_get_dirty(addr, 1, client);
-}
+bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
 
 static inline bool cpu_physical_memory_is_clean(ram_addr_t addr)
 {
diff --git a/system/physmem.c b/system/physmem.c
index 098824ad1d2..7973448b3f8 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -902,6 +902,50 @@ void tlb_reset_dirty_range_all(ram_addr_t addr, ram_addr_t length)
     }
 }
 
+static bool physical_memory_get_dirty(ram_addr_t addr, ram_addr_t length,
+                                      unsigned client)
+{
+    DirtyMemoryBlocks *blocks;
+    unsigned long end, page;
+    unsigned long idx, offset, base;
+    bool dirty = false;
+
+    assert(client < DIRTY_MEMORY_NUM);
+
+    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
+    page = addr >> TARGET_PAGE_BITS;
+
+    WITH_RCU_READ_LOCK_GUARD() {
+        blocks = qatomic_rcu_read(&ram_list.dirty_memory[client]);
+
+        idx = page / DIRTY_MEMORY_BLOCK_SIZE;
+        offset = page % DIRTY_MEMORY_BLOCK_SIZE;
+        base = page - offset;
+        while (page < end) {
+            unsigned long next = MIN(end, base + DIRTY_MEMORY_BLOCK_SIZE);
+            unsigned long num = next - base;
+            unsigned long found = find_next_bit(blocks->blocks[idx],
+                                                num, offset);
+            if (found < num) {
+                dirty = true;
+                break;
+            }
+
+            page = next;
+            idx++;
+            offset = 0;
+            base += DIRTY_MEMORY_BLOCK_SIZE;
+        }
+    }
+
+    return dirty;
+}
+
+bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client)
+{
+    return physical_memory_get_dirty(addr, 1, client);
+}
+
 /* Note: start and end must be within the same ram block.  */
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
-- 
2.51.0


