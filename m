Return-Path: <kvm+bounces-59350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4520BB1681
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DDCD3B402E
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B76286889;
	Wed,  1 Oct 2025 17:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jHdd1fyh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13325E44D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341332; cv=none; b=JTr/+VxVKINljx9LpdDd6Rejze7eA0cVT4X1eeBUaAIMlwEwqRYplNJfcDRG1CMuVncFG5SL5MD5hpI/FLZcHn1nm0WlaZazsUoA3ejdM/P8rgeHi0VNOM25CYXGnw+1oQg2q25XlE5YS9AnGtz3PEBkfk3X1y8Wer439G7unLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341332; c=relaxed/simple;
	bh=kwgwd7OAdvLvSq/M/1r0rFpuwpXkW9xA0DW9Yb0fSGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Os7Kyq0XUBOk4887Fzja6Tce6sRfyLXSj2eBcxpLJctBVSR28502G3lnhjLDtlya2y4ZpTZ6DkYvVBzY9YWJWAkIT5qStVFpM4dmrbce3g5AjZGJmC6IoRSmUvTOIexzpSrWqsaWayMJ/TWR13RXQmLLar8MNIJ2/R6MYwmP9fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jHdd1fyh; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e2826d5c6so763135e9.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341329; x=1759946129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fleHOEnabQgFu4exvE553p6CfO/pKwnn0eJLyN72P70=;
        b=jHdd1fyhvTrZDDGW5J8B7xZ/JnYmh8mxpuF8JDhiAGwkAkzU4AdfzXA/mQMolAkaLc
         hw5Spud3PMwuDfRJPgf9NFZBeu4CQAOZ+gGXijqjuYRn/qJGTVmSOd0AIXHqF0GJk3MR
         fhBe+43d7LLwYAbm3JQYq/dCSN/MC1FM2wA6HOabwSC6orbhPI1g30E00jYrZziF8A82
         F78SacpbKtprAZKaB4rZhAG5Yb2nPbO4kJPX5R/HjqVkdEDdli9f7SK+2hJHFQpWdisU
         LwySDz1ZcSgTWQ0mabeAmmyFWcV/bQuZvVFhixwTITmowrY6TWmTX0s7/X+sq0RLX7EL
         WfRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341329; x=1759946129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fleHOEnabQgFu4exvE553p6CfO/pKwnn0eJLyN72P70=;
        b=C7C2ZoqElBerjnLMAHNlg8T3ETxvVhRCS2uL5rvCw01IeefQtjvodwUmwyJYUUOPD6
         tU4onx8iUGd8u6bTFnEUdu+chKH4VM+TbdcdzQ8b+nwmKTVT8ziy8nzSQl+nfINKy//K
         HPobTpRses3g9N8rdLULnvg/uBbr5yQ9TuPu7tHGUeHY3fIQEQ7PJJMlrAjJgMGsk9Hh
         BGQlK0GGUgKu5Ql4umYTAORLc9PRtF/2JP1LTIcbl7ChcQB80oexIJrQJZByghmJ6WGA
         RNH5Welm2M7TlRf2Iw7We/A3ha5RC5VjyuFNpppVLgPZ42WfrtZIVXarwXx5dfijp5KA
         Wneg==
X-Forwarded-Encrypted: i=1; AJvYcCXWqny9zGYAI0+hlRWic2S1fx4Y83E4bMHXRkpqhtf0sR2FFADVfBD+Djm3a0BnPcy7uck=@vger.kernel.org
X-Gm-Message-State: AOJu0YykCx0kcqWJGj560dm878sm/Fp80o4uWNyb2vXrGmYnDhGZGC2f
	KoEQ+3ptA/xnBGuM6p3UgJAVBxNA/ZYTzLEec+KMW/k6vX0NweE8IwodTXAdEAhy2Fg=
X-Gm-Gg: ASbGncvQmIEctEeX1BkJOwKQuQQ1JmFgfT0utualNoR8U2vErvOAi7fCFWdKHjpuKbG
	YSUnuQECwK++VMhmdk4IuNEFdNr5IoJlLhlOltcdOFUpnIkgVzJYPcL3jfnJn6n8+Mgf7ERYPVf
	S/qCZo7qBmeRInPagJ1CWRxve40nthiohPJt8k12OMg154IbLJTifSeqprFSBSXWF2m7pDhZBQQ
	QpHOaVWNE+HtP2/52DJ7EZsleVies97/IksK3jeQ0QfcVmvi981bvOAXnDoh8TN5vpO4aupmSJP
	cZNSTTi1aRAWkLr7Hc+UcHAZ3VdISlP3URSXocE4O/VmF7SsbIs5Q5CUftMCwN+F5twXQ7hdcwW
	sia7GJG9QUvZqs3J7Y8Qvd0Cq80MI9voYElP10d7q2bh/SwFo5+w+swjBXu/D3FbaUe6X4yMvOI
	zFu16DJMyBGOgPREOBsXsdFJNH/w==
X-Google-Smtp-Source: AGHT+IFMtKi1Svtg3gm2PuIJU4mwz8reGwTlJrr0LpXP0uY8sPVOOOXNQc26D9Q0woV86ESbmtFHHQ==
X-Received: by 2002:a05:600c:8119:b0:46e:385c:3e0e with SMTP id 5b1f17b1804b1-46e6128604bmr35524515e9.29.1759341328882;
        Wed, 01 Oct 2025 10:55:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e693c2e6fsm1006675e9.17.2025.10.01.10.55.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:28 -0700 (PDT)
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
Subject: [PATCH v2 07/18] system/physmem: Un-inline cpu_physical_memory_get_dirty_flag()
Date: Wed,  1 Oct 2025 19:54:36 +0200
Message-ID: <20251001175448.18933-8-philmd@linaro.org>
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

cpu_physical_memory_get_dirty() doesn't involve any CPU,
remove the 'cpu_' prefix.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 46 +--------------------------------------
 system/physmem.c          | 44 +++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index f74a0ecee56..f8a307d1a3d 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -142,46 +142,6 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
 #define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
 #define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
 
-static inline bool cpu_physical_memory_get_dirty(ram_addr_t start,
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
-    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
-    page = start >> TARGET_PAGE_BITS;
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
index 0ff7349fbbf..a8d201d7048 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -901,6 +901,50 @@ void tlb_reset_dirty_range_all(ram_addr_t start, ram_addr_t length)
     }
 }
 
+static bool physical_memory_get_dirty(ram_addr_t start, ram_addr_t length,
+                                      unsigned client)
+{
+    DirtyMemoryBlocks *blocks;
+    unsigned long end, page;
+    unsigned long idx, offset, base;
+    bool dirty = false;
+
+    assert(client < DIRTY_MEMORY_NUM);
+
+    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
+    page = start >> TARGET_PAGE_BITS;
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


