Return-Path: <kvm+bounces-59330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1ED1BB146E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C8E27A3F09
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2420E28CF5F;
	Wed,  1 Oct 2025 16:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qADdKXo0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D8527F010
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337112; cv=none; b=S66bLwDur5gcRS/2zmRI0fzWwwjT+UmWFf53lSBDq7HucTm0SHlmOXObldC+jEN26FeSamtagFEmN0nKY4K1Wh+GRrJsLtGoCam76PNe54I31kDDR0ylHOSU3M9imZiG1m4TvbDbLm/22totlBdKQGjD/a5hNG+/zNmIFkDiq00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337112; c=relaxed/simple;
	bh=jfZj71vYmUJ6oQbzOBjlL/tCxlDCiW53U04XKuwu8t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rg/qE9QzpDn5zaE6CsHqn1NzryLSOyKgYPu7zeiCPYDAsDUdaFT9ol8yrzMDY3nGIg/wQKkDHpNf4B4q1S0JNiOAXxx3rEGEU+ze6kht+SnJmQs+Ag7HaO/2LNX0zqh3kIRO/sNmjhX4/zFrhqaGOtHnRIbmxtMrlUAlDjs7k0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qADdKXo0; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3f2ae6fadb4so17479f8f.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759337108; x=1759941908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8b7SjVDM7x27mqOISYHK6sGtoV+Vz1yW6Bp7Z2odYdE=;
        b=qADdKXo0Rg9u2cQtpRotjBbPBJ8XKCKBxGdgGMRHKJmUd1C1qN3fYOkLmbPIRM+jg9
         UskP0Hms9LDTGAqBD3oj8lUEVz4Nuf1O5h1v2bP3aKhYNBnT1cTWIylWDC+JyU6dqpJo
         rfz9d+3FJZVgvYl/FbGlwlfXxNnaHZXnlZihxV8bxIutIw39VKSfRrGlUdTD+H7Rjd7k
         cuAkiKHXbzy7KqtPX/dvTaQCv7Ti73in5RLL1leda2iNLt9KgJLphQCr5mqqStSgvXk/
         7r5KKmYiim6Uqg0rbDZVsoaxKlkybeQnkaAfHSADEKFp710LFLUPFef6OXc7s8SbT39P
         G8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337108; x=1759941908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8b7SjVDM7x27mqOISYHK6sGtoV+Vz1yW6Bp7Z2odYdE=;
        b=LB4V17PGk1pQwDl+7wmVJc2G8rRJgq/+/w3vFBkmpMki8bVRIRjiZYN6w2k7PsGytj
         dzLqFGs8YVmtHXLWXw+u8t2nWwlj+iNmik4/1C9/Dlqz2QxXPuzNpQX6QFEPIGiPqBwd
         MwSlFfdqrqIm1jiOMoYmR/uMu9ovCJLC8xVrK8DNnrjPC3FuMvuJyiNZTkvYV6VU4Rec
         dvLFdD4tmrHSYwrCNo/xy/4J8qPrG7ziNoWf2ZptEbGU8Ro8Tb6+fU35of5fRtbzzYDS
         gIZsQB/Be1fWXj/jdGpZQWDqVV5keYP624pXV+/cNqE+ZmQnMfo0twXVsoG/8yR9HZE5
         zseQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdAzto8i/6u7XxQb+MeSYca0eMaryflnMxbefKMGKilFUrmrtyUJ7e3Q7gJO53EJhKdgE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr4XgBoCkOxQGaZKebmPeKN2Nh56x0BnVTeYre352h0bzezu4q
	beTuk3JCroDTbkS4EiPNndeghWIZIJDXPY+8yiMfw7WFjlISGNCh80b0QH7Y/t/qllw=
X-Gm-Gg: ASbGncsis4boXTYCLDjvS++vHL2m4HKTxxnDREsNCgCvMFIwBSjmBfHx3J68ck8jxQJ
	nC7UJqkWrxBvgmsro9MJNVgmOZx6Wot3L88973rmhhxCp9RNvWAUjxaeLjvVJu6pf1ASyjEhqPE
	1O43hv3Nxdd5x4jpkvSqiXIe4hBotKTwjownRsRTiU/lC3viWzpjqP16nHHBA6n6+SE4sczIXg2
	r8cum+01d6n+NIHPVCPd+GVoBwY5hZksWBC3wbecvXW/qdbzoKQr1eVcfrXfLK87OETeUDNRoal
	4RqUKksMSU+7PaznuhZXS4aWBY/h42dFkeXTrolSwvQcqMLA92BRFA30fBKDd3z6U0tx8kUIKRN
	PZf8ny9XZ18N222Y6GAkEUc82d2lWfHNYx9mbw5wSdIDMvbcdSNiL8+WRcDlKvGgH336dzHhavf
	8g0PZvb4YosciarYCxtEst
X-Google-Smtp-Source: AGHT+IHMHiIv3Gm0O2fKETILRigrKi9nt4DR/GCQ5opvYfK7xcl36n2RWU61ts9bNcXzgiUvtcFXsQ==
X-Received: by 2002:a05:6000:2388:b0:3d4:f5c2:d805 with SMTP id ffacd0b85a97d-425577ea471mr3018368f8f.16.1759337108303;
        Wed, 01 Oct 2025 09:45:08 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6921b7dsm27494281f8f.42.2025.10.01.09.45.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 09:45:07 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 2/6] system/ramblock: Move ram_block_is_pmem() declaration
Date: Wed,  1 Oct 2025 18:44:52 +0200
Message-ID: <20251001164456.3230-3-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001164456.3230-1-philmd@linaro.org>
References: <20251001164456.3230-1-philmd@linaro.org>
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


