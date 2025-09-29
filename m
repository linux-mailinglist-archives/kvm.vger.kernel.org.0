Return-Path: <kvm+bounces-58992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A097ABA9D53
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C1CB3AE015
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 15:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDB530B52A;
	Mon, 29 Sep 2025 15:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vjPSfNCn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ADA306B08
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759160744; cv=none; b=VrADo/q9wWmlwKPnO4k30LJFWDSEV5f8HnqVNB8xP+deI+YkbE9dUze+gpeKjJ0AHi5v9e/05vEGqh0eLyMPW1dj5K8Di/zkJUFFxVkv2oYxq3xwiybu7NnfmGljGvZRBQqby4xneRQelARGnVv6I4aXu0olJVIgoNkhaMsOEjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759160744; c=relaxed/simple;
	bh=FfpmmQy+5lXiPVxcsrz0PZ6DVelTLpL9SsP8Yjvb/r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UC2hNmBJkz0Lap9kneFbKqZVHu9JARcZSa9gka2SxNSY8yQXmn03//WsDWy6YXivYDYt04toJxWFJsAd9Erc90LVIigtWJbkFhij4l7hjkbzfnhtCAFQGhUOUqCAYMWm3IvhaBNfBfPPFX3btEu+yefu8zBKVD1cxwx8a/um1ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vjPSfNCn; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee12a63af1so3177515f8f.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759160741; x=1759765541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ier7ZLUPhxlD0fGogfBr0oZm5kAnkym39eZlbfBVpIE=;
        b=vjPSfNCnRiHbblloqVpoagsqIzEExDrOT89NqMEiu0i72SvQOsoGPIU0WaPQLfGptE
         areHhv3lif4JjspHDvVEWPhs3skDiLiKmi7KZYDGCQGoywbVQZjadgwkjxdoVcRZqjID
         94a5aNs2bltVbi6LjQU4XXuPULxZWBGK99RP2B/3v5sXLdeK3R3z5pEllZSYuM6rmGnr
         wsaQwxnZALr7G9NCvI1Fv+/UdsVbj2ABs/otCh1G0mtVKnkl+VPglImw4C0SETFb8Cau
         Yeq8Jq382m3KCcnRSjtm6/61zkSkUVnu0oSnzGrrhhH0CCrKbF6VGduG/X8mpXWU950w
         U0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759160741; x=1759765541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ier7ZLUPhxlD0fGogfBr0oZm5kAnkym39eZlbfBVpIE=;
        b=ugtzhbJSh0mK4gljgp7itO1zCIuxD70hNP8btkBLeK13gmQUMZVNEVUFekpPI/pb3m
         pCWQKDQYGgAaxZ8on/ZaApwkJHhyzx+vafbv8etBy+pI9Re2hj3BndPqae8ftRIJcOSA
         zk4Z0w6Hna0a7XoIdvEoP1DqQM5LgoGnreSHnu+cmnK3EY3tyRjZrcbQrorMDgMrWYcI
         fEB80zcrCgwqZkw0DjY4iNyBiys581JS4mtgDs7SaOqffITdH2kshtfxijJCUh3PLHNv
         6up6n6HBVpKi6UlOdo+TZk1H3XVxmPqsZm3UB80gICdZfoPqDpjJh9IGnidpdtRlbcft
         ElFA==
X-Forwarded-Encrypted: i=1; AJvYcCV5uNF/r/ePB1sM5wPX4ptyfzfrlhyjQaeruc5f3j4VqA7P/OTVqhO9WV8OUTfFJpKv1Ls=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWVZVeAs8ntvENZDwIpS50oJXrE/FM2KbZPds1fUNZtPHIy5ac
	M2plgDMlM1ACUZPqyzwEnw++p6BDDdEW3AAMBanjo+9XtoXNgZMt94tNv+zuXDTeqrc=
X-Gm-Gg: ASbGncsBS60CPU8HNUSRkVhMBJfiXp3VxDWef1g6/HBVZ1+ESOGVON5PyJAcCwwvH4G
	KyJypzpDTJKl5uqKUIFPsJElFufb1VXznq+c6HoNUvdo0SKzvXQ0PZuTuWCaZBop96MiRJIwzml
	cbQV+O2lgCXlOYxnBDCfV8CeIeh/yoztCR1Ah+nS8xpevB7cx3nJ4PMrBCihNiTc7i/kLrwb1wl
	89Fq/ZkicWzfjbXxyU6eAXCqpivIHBzPqZ90BD93NxfPVAui2yrVO+DESzUld6ScnqZg2SxwZj1
	vGVmlSBYi2ywxwxnVeWUye3LOEDAN/M//FJ/h7W6oITkXtLYOZm1S9g1BHW23bKCZeWcK0SfPAj
	mYGR4pDHiLGulJxMCQBl+K7l4MMYlI/0LHsNJS6A1tD0knRP2RCrYn2knXdvmYVocBH8tbuvZ1W
	oIegrzCeU=
X-Google-Smtp-Source: AGHT+IH9iVMg3sncAg6Mjrqkf34b84fuhD2iKYy8WAQ/+/TUPiyjYY3xhW8ytrinUFRfyHO92RR0MA==
X-Received: by 2002:a05:6000:1ace:b0:400:6e06:e0ae with SMTP id ffacd0b85a97d-40e4cc62efbmr15549709f8f.47.1759160740972;
        Mon, 29 Sep 2025 08:45:40 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e59af1975sm402735e9.3.2025.09.29.08.45.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 08:45:40 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Fabiano Rosas <farosas@suse.de>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 2/6] system/ramblock: Move ram_block_is_pmem() declaration
Date: Mon, 29 Sep 2025 17:45:25 +0200
Message-ID: <20250929154529.72504-3-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929154529.72504-1-philmd@linaro.org>
References: <20250929154529.72504-1-philmd@linaro.org>
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
index 8999206592d..12f64fbf78b 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -108,4 +108,9 @@ void ram_block_attributes_destroy(RamBlockAttributes *attr);
 int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
                                       uint64_t size, bool to_discard);
 
+/**
+ * ramblock_is_pmem: Whether the RAM block is of persistent memory
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


