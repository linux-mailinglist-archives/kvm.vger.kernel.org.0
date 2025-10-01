Return-Path: <kvm+bounces-59263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B10E6BAF973
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 613B03C6E69
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73BA3283FE0;
	Wed,  1 Oct 2025 08:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x1Wqvg9T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B672D283FEE
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759307006; cv=none; b=TcBu0KUgXsMvwBRb1wCNNC+/WChyP/V3TMZ23g5qVtr1NLn39iuZcJ2/A0CxnOJy45orber9LKoUOIedN0tFFxfjMSFZi2Mp90UtmjcR0A1aZXz4kiqdBz485wThjXgeICfLTGdqnQ1lHn9nfDR9YZDZ+ur+NsM4veZ54uwmUe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759307006; c=relaxed/simple;
	bh=7hidbMJAVtXbuiL6XwjdIVPWBbZ4yA+MiivYGLAs2ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PD93PrNL9EnJs5W3OoQpHzUPUcYRp9oiH2KrPJ/bUvnD90CcSIC0O5SIF01OopErXX+97EEmTiThfzXsTjwYNSnglSOK/kQPqbpM9vkgFYezbQW1Y15B4t1+xCGBjRtblJlIU/LCtuhU7O7s35hsTQ3LhnpuW7KTOU976Yh7zo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x1Wqvg9T; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46b303f7469so47414095e9.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759307003; x=1759911803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EyykhGLj1jkUgHcU5soenb3/DO81dJbtrcBKTf6Mydo=;
        b=x1Wqvg9TkOANtoIPHv5BMgtk9r1h9SJKa1R23d5WKAdoaVBR7drXC+e+MG/Tl3JF2V
         6kdaB60Ss172KBWOI9VQEG3NChQ6ONZNGBxekLH50Pzh5hPxEl11J9L7CJ9r+2G0m03m
         FGNvfzQZcYD+9eMu9FzMILJvgFU71f5vnoQeE9Ql2jSMvyNOXMhGpE/vQhdqyM06cXsW
         axgMA0JxP3ObNuOAfs84eTbC4XWM4/uTkVEebeVm7DZ5+++SDdBCblZKxijEIBzfntGu
         yKJrC/mhhx9WuZ9sHkoTSHHNpUhouMHV12Q6o+VQS22K7gzE5Q3Mm6nlIwpGojliR2YE
         43fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307003; x=1759911803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EyykhGLj1jkUgHcU5soenb3/DO81dJbtrcBKTf6Mydo=;
        b=WfozC6hLtQ+sOAScP6p1UOk0d5bUa3kqBhlVNyBNTNFnN2NocW84CNj4lmytvCqhaz
         IrXSK8NNyyAmRhwGkskDXcOULpihZmrL8ze4aH4gqTpNwhEuwX4NoOP70V+q9PWEkqBg
         sK0dpUvTCAXtmQM8BktKuFe2IJmcL6D6ieZJsDeomQ0MZm0IWqEudeA9dPZ9e563YP2h
         14eBdD7+G3O4QbhnU+LnMfebEa1DeFbCEKvBBT1v8qhS+DTDothfGeYwLKY1bLwhmHfO
         idEAAYjjxhyPHcczBJcEv0nBUHOZNLerq1eowpPFMRUL47hlW4O02fyJUTLfUksRw5H3
         wo3A==
X-Forwarded-Encrypted: i=1; AJvYcCXskTMt8FzwF9UMk0Eo1oGJXHpZM/F6mGXr4RYq2VKtQi1HdOSrgqLeB+e/7cULQusNkC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzghkNKn9ZS6RYYZPDtBs4E2MmaZhosBUEVLmjrhi47D4qd37BO
	jbwhWoXOmbbgWGSsBopWV1H3zWSEKVJeBWvBgAODa35XEkoLkJZ26K3XjbnBXUAbW1U=
X-Gm-Gg: ASbGncscuNbJ3XmBftcCUTbXmgs+uHVLMtiOyban94dqOC7rrxVmNipBcvy9pBzzqje
	dAASV4AFYi7ZJdMcuvLbEJAZk3iSQxZgGYeidOyQ9Jm2D6TDja1stblllgJPkHTfuELH+egw9np
	mpcHTHd4GGjUpvgXzxRlAGcPE8gyWWpWWNn1s2aRNlVJXgbSa+li1JquTY6aRISThtsHDWTW/Ya
	FtCGH8fRKnWkFy+cpIo7RsHBXhvyuAlW/4UwjZn5DAEgZJh7xASvajL2eDvFQUWbPImG9/igHfR
	7DY9CGnnxPhztinMIyDPu+QX2JW0M9CcuA0G44Zuq29kat6ME/UL5wlhaDjeLIEFbcuLVTov0RP
	N0midzkhuXO6oaHwhzRZiqzKWGoSyT+SlAAO6VQhWvzlR+ItZEiek3x/aMr9wE/eO9pWX3d8jvO
	lzM6XpWtZc5cQFyukHuDKE
X-Google-Smtp-Source: AGHT+IEW9r/bw8qCoszWMVZkXC0nqD1HfNOEbFg+tiQXxaL8h0CvjflOEJAU8J3R9AYYkEr7d7Yj3w==
X-Received: by 2002:a05:600c:154e:b0:46e:6042:4667 with SMTP id 5b1f17b1804b1-46e612e6912mr20563595e9.33.1759307003069;
        Wed, 01 Oct 2025 01:23:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc88b0779sm25778005f8f.58.2025.10.01.01.23.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:23:22 -0700 (PDT)
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
Subject: [PATCH 21/25] system/physmem: Rename @start argument of physmem_test_and_clear_dirty()
Date: Wed,  1 Oct 2025 10:21:21 +0200
Message-ID: <20251001082127.65741-22-philmd@linaro.org>
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

Here as cpu_physical_memory_test_and_clear_dirty() operates on
a range, rename @start as @addr.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h |  2 +-
 system/physmem.c          | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 7197913d761..3899c084076 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -166,7 +166,7 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
 
 void cpu_physical_memory_dirty_bits_cleared(ram_addr_t addr, ram_addr_t length);
 
-bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
+bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t addr,
                                               ram_addr_t length,
                                               unsigned client);
 
diff --git a/system/physmem.c b/system/physmem.c
index c475ce0a5db..9e36748dc4a 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1092,7 +1092,7 @@ void cpu_physical_memory_set_dirty_range(ram_addr_t addr, ram_addr_t length,
 }
 
 /* Note: start and end must be within the same ram block.  */
-bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
+bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t addr,
                                               ram_addr_t length,
                                               unsigned client)
 {
@@ -1106,16 +1106,16 @@ bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
         return false;
     }
 
-    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
-    start_page = start >> TARGET_PAGE_BITS;
+    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
+    start_page = addr >> TARGET_PAGE_BITS;
     page = start_page;
 
     WITH_RCU_READ_LOCK_GUARD() {
         blocks = qatomic_rcu_read(&ram_list.dirty_memory[client]);
-        ramblock = qemu_get_ram_block(start);
+        ramblock = qemu_get_ram_block(addr);
         /* Range sanity check on the ramblock */
-        assert(start >= ramblock->offset &&
-               start + length <= ramblock->offset + ramblock->used_length);
+        assert(addr >= ramblock->offset &&
+               addr + length <= ramblock->offset + ramblock->used_length);
 
         while (page < end) {
             unsigned long idx = page / DIRTY_MEMORY_BLOCK_SIZE;
@@ -1134,7 +1134,7 @@ bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
     }
 
     if (dirty) {
-        cpu_physical_memory_dirty_bits_cleared(start, length);
+        cpu_physical_memory_dirty_bits_cleared(addr, length);
     }
 
     return dirty;
-- 
2.51.0


