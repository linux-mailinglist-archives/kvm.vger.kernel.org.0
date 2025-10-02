Return-Path: <kvm+bounces-59382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 051A8BB26EA
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 05:28:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8F36321194
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 03:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DD32580EC;
	Thu,  2 Oct 2025 03:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HyYZU9hy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6F4149E17
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 03:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759375710; cv=none; b=WnrjTRpmVcpxxNBX5IsaOYUx0RK7yN1U48CEUmeA7dXGZAWwouKzQrboEXNPt3ter3XVRgzMT9l7EgvKJjgwFcoaATtFjxlNbIqXDompiKQtBo2hNuOyP9SNodCXfBjUm30jlfBmfoW2LEWYXMWOwflcirxhzIQEubYQM3DZ8/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759375710; c=relaxed/simple;
	bh=/MO+Ft+w3l/l1PL3YfpFsChZ4YxScFtsJMElOTBCzTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a5isEHMWXC9IOh3jx+KTqRq9eb0MuR+r0mMpkMRK9MMrl0PPLPHhZVplQmAslvMwIIaJMpjuwPrbGPAzozLST1T22/3fUTfIkzddNrBcAhO+23a2/nHfbhJ3WoxyfZvlwt0p/RAh6A/aXESsgP4arv8aToFG8IpWy7AmAiwqsm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HyYZU9hy; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3ee1221ceaaso278902f8f.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 20:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759375707; x=1759980507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7/eaSTeP9UuFjUtgukk67zblH/osf+XrQn3BX925Ps=;
        b=HyYZU9hyWq+LXUUpBzpcnvmA7NbNR4MrlgVTs1Cf3tLUYgA3CdXHTJPLp30pD9eUKE
         JNQhH1qVHOlSy4K8jrEuU4TcqdgkmTKHnND3MlKtVNTjk/Trn6oCcjJ0A0CN0OY8eAh2
         az8CjNhYN5D0WyQtR/BPpmfMito7DT5TEkPzoTe0EDeGdQNucWW7AQ5OURcv+04o06d9
         mgPt3O4tKAEqc75lAEYgrSTtNjo15tHTUMj61wKLGiPAHPXQS2yYzoruPOnYB6WIxqz5
         ycr/kawyKDPoDO5+W/2eBBpeivcgLSY3YUD34zYa6FRK6r2zNq5/nv3WKGrutWdOE1I6
         86Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375707; x=1759980507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7/eaSTeP9UuFjUtgukk67zblH/osf+XrQn3BX925Ps=;
        b=UPFQXyLbtYuSZAbXWns70JdgeATKa3P15s5ahalbEaT5DJBj1zhqG8/HYgtv2+51YJ
         sg/9CwhcohN1Qm9F1ipsfBnarnmFts6oV3+ik527/DpYgLdjuE7Vv/tV5zzZaTrZ8uIt
         F+mY+vC8a0yPemZK5BHkt/rnG6GLwBFpNmUyyep9mV58IE+auyuzziQ8TEVDTsWZ9Dx+
         rVQ+GE9Kru+eTLg4oAxC9pX8v0lSSoz0mpeTNgHzKMIedsaNeVaiD+sn9enZm9u/VhMM
         tWshaUNmR+NCu2+Q0GtpFkiBH+wLFNwpyyk0bwJpvA3foNztPJ9Dw8D3RgwyVZohetmS
         VDmg==
X-Forwarded-Encrypted: i=1; AJvYcCU8o1NjsRlZKeW2AITZFY7P/GuzrPjqRV3XnvWsrFoRBHC0KGWfb5nx7wZOIdZyxTqohPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfA2vVuCkklkzscT5iR6NNnEdP/lk7UxTIijwgnWvOExPPJvcv
	9VpxtDe2ZlLHDBjVchtHOP7FkrlXlntcgQbsaYzvFAtbOjIPQ54Q9kH/n3adxc8F/2g=
X-Gm-Gg: ASbGnctKqDZNVOM+Asp9gD5Z+Buf+qnx4Nx6jT6fEOd6+LQsTxJMTXVtPHCbLz5A5Cg
	aM2r8jODNKmJkauCFUAQJ5WA049o9ipAq586tYQFgNAL0p7cNOosH13ADmEKHavfn1GL18hudx3
	3T2C5VvXIauWKxBG5LhesHIIStSwhMctGFuZGRTWwlQ0rEOPZ3+LrPVnbpBBYYZZlFVTY3CjqrU
	73DnjmHN9ifZQUx+5cqeTRLL3eVBN8MK7Em2nZAXps7L5Fgupu56YxrBTspcVafkHSCwFdDgsaY
	Gt+xWgrVpjAhmp2AQsmcX6BOPNBEfU1m3FhCEkRd70iHRrc7qAhLVZacAXTAa40u0AsWnERdMxm
	GATvw0utR0jixpCi987+BKmYfxfZni0C9fXPCUi4FyxuIYCY4bGNttgNONbMgS1HiNs8xI4j6/7
	SstXnp8zvY1MD3z26r5UmdtNur9QQBhg==
X-Google-Smtp-Source: AGHT+IFa6DuP6+nSTyFdUQXX/N3DTc+ZczxQOaaLe3gO7ffPlke1IGNV+HU8W6+39+/JQKzkCxKctw==
X-Received: by 2002:a05:6000:25c6:b0:3ec:2ef7:2134 with SMTP id ffacd0b85a97d-425577f4fd4mr3773891f8f.18.1759375706962;
        Wed, 01 Oct 2025 20:28:26 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4ccesm1552183f8f.59.2025.10.01.20.28.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 20:28:25 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 2/5] system/ramblock: Move ram_block_is_pmem() declaration
Date: Thu,  2 Oct 2025 05:28:09 +0200
Message-ID: <20251002032812.26069-3-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002032812.26069-1-philmd@linaro.org>
References: <20251002032812.26069-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Move ramblock_is_pmem() along with the RAM Block API
exposed by the "system/ramblock.h" header. Rename as
ram_block_is_pmem() to keep API prefix consistency.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 2 --
 include/system/ramblock.h | 5 +++++
 migration/ram.c           | 3 ++-
 system/physmem.c          | 5 +++--
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 15a1b1a4fa2..53c0c8c3856 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -99,8 +99,6 @@ static inline unsigned long int ramblock_recv_bitmap_offset(void *host_addr,
     return host_addr_offset >> TARGET_PAGE_BITS;
 }
 
-bool ramblock_is_pmem(RAMBlock *rb);
-
 /**
  * qemu_ram_alloc_from_file,
  * qemu_ram_alloc_from_fd:  Allocate a ram block from the specified backing
diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 8999206592d..7059b20d919 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -108,4 +108,9 @@ void ram_block_attributes_destroy(RamBlockAttributes *attr);
 int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
                                       uint64_t size, bool to_discard);
 
+/**
+ * ram_block_is_pmem: Whether the RAM block is of persistent memory
+ */
+bool ram_block_is_pmem(RAMBlock *rb);
+
 #endif
diff --git a/migration/ram.c b/migration/ram.c
index 7208bc114fb..91e65be83d8 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -53,6 +53,7 @@
 #include "qemu/rcu_queue.h"
 #include "migration/colo.h"
 #include "system/cpu-throttle.h"
+#include "system/ramblock.h"
 #include "savevm.h"
 #include "qemu/iov.h"
 #include "multifd.h"
@@ -4367,7 +4368,7 @@ static bool ram_has_postcopy(void *opaque)
 {
     RAMBlock *rb;
     RAMBLOCK_FOREACH_NOT_IGNORED(rb) {
-        if (ramblock_is_pmem(rb)) {
+        if (ram_block_is_pmem(rb)) {
             info_report("Block: %s, host: %p is a nvdimm memory, postcopy"
                          "is not supported now!", rb->idstr, rb->host);
             return false;
diff --git a/system/physmem.c b/system/physmem.c
index ae8ecd50ea1..3766fae0aba 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -43,6 +43,7 @@
 #include "system/kvm.h"
 #include "system/tcg.h"
 #include "system/qtest.h"
+#include "system/ramblock.h"
 #include "qemu/timer.h"
 #include "qemu/config-file.h"
 #include "qemu/error-report.h"
@@ -1804,7 +1805,7 @@ void qemu_ram_msync(RAMBlock *block, ram_addr_t start, ram_addr_t length)
 
 #ifdef CONFIG_LIBPMEM
     /* The lack of support for pmem should not block the sync */
-    if (ramblock_is_pmem(block)) {
+    if (ram_block_is_pmem(block)) {
         void *addr = ramblock_ptr(block, start);
         pmem_persist(addr, length);
         return;
@@ -3943,7 +3944,7 @@ int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
     return ret;
 }
 
-bool ramblock_is_pmem(RAMBlock *rb)
+bool ram_block_is_pmem(RAMBlock *rb)
 {
     return rb->flags & RAM_PMEM;
 }
-- 
2.51.0


