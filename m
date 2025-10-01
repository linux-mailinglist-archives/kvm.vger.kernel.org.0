Return-Path: <kvm+bounces-59329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4CF2BB1468
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9673D2A091D
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB2927F000;
	Wed,  1 Oct 2025 16:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WfqJISAI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144EA296BA7
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337106; cv=none; b=RALLbCVrPm5kPXvYru601C84jzvdZJYZo3+QJXY5WiTi+vds65YJYmR3enRFpGURITbOSnH60II38w7+X7P5sRKciXe09Nk1myLpjSeQVEyl4EePQk4RnWxNI8EoqrEh+cdsBCTtAYOJAIUB8caxN4P/n5QGUPSIYtbUdSamDN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337106; c=relaxed/simple;
	bh=slBLAVh+oEIXiWoa3fOcyT0zcBK2GZDozC/t5svsLgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RTQol+JnVAT88mBCfe9rb/5p2C5vvSfYzdTkAvv0870BMoTLwpVt0zRF0Gyr16NJF0h2fZiJbuIpx3MTlrV5veRecYH7vaspQLllUIQ9t6iQPwYnO2Ix9MF6xci9t1EClwqLVNyIp3AyvYp36gXwWbXJiM+6ZPJg5+Mp9lKqUUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WfqJISAI; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e2c3b6d4cso51005e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759337103; x=1759941903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=caJIjlQVI1zG/C/he2yH9f+M89HcV8DgqjfXZVRQPEU=;
        b=WfqJISAIBLVIYLF2N6jmAROWu2/bQ7E7g8TN9BC4T5r8YiV8IeQrw1P+xHbUSkIr8P
         SuWAuJt7AKaL1IGKcp9/TmmIckmGIc23TK2jRu2KalFsIlyAPbqTfM3RoMvGRnuPiA3z
         ZiHntVbYRNI/VGoYKWpq9c7R4ljhFoa697RMwNuQqSX3vEA133QGsutZ/C84+W04CjtK
         aibCypDF/6vVEZ3OmzPXeCwXBOCSn/Ag/JIdP5uU16cLELY+tOZMoo+eFafKEW1fhPrM
         oMu3FhhCUuDB5hJWcACDtUnCLo5gsgPrpnuSZyDfgb+iiAa9KbVJqnkg3MAQTELOX3bn
         D5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337103; x=1759941903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=caJIjlQVI1zG/C/he2yH9f+M89HcV8DgqjfXZVRQPEU=;
        b=J+nTGWR+RcqCMnHVOAAmtToYSFQYZgq9mAZSPpEd6oy0zqJt9dPadkntVHG2BPsM4p
         Fv0VpQd84nDa13jFnCRozoa4Nhnv8cBgubnpMUs8k8zDE9fqJHf+M7g9Vd8P0zVcalRq
         b5M9RIDg56gpYvp2zTcQ+3j3r5RsTQUcqn23/wCY5laQIO61tUBBN9Je001Lx5ebIZLQ
         7Sj2MTpUWlTE0EJ/k2YGebvidRv+PhLjZztVvZbLINxgm0yPHhYGbhAGb7aW8JmwJKJQ
         402q/gULOe5H/m09FKfonxBuLxrFfFZvTZm20+uKBydDgConX4MwyKXurH4vWAKXJsXd
         YjTA==
X-Forwarded-Encrypted: i=1; AJvYcCX7A//woFUVGtlT+4qRzzveO0p0XfhbCkTTBiSQdJrsTrMrbJDjevVMyY1InMFxlUI0u4w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl0hPb3EzDbKjTf7PqEt0D1iAxJu0gD6EoYqLDFXwlHip43eI2
	W4LKujE9uNjDjMy4KLbXG7GRjHzx00/eOqDDXwwZGsxtG3QWiBqmCunpCkUR2mWKxv0=
X-Gm-Gg: ASbGnctkiVZtMUwclApCs/rf3AvCNqET1HBGL55/XeTmsrcoZ1nlo8L4i05wPpTTTjN
	f5SGnmmmlkEYHu/yfubMJ7O++WldZ5O/tknTc4eafi26iwqZlCdgpKDIVyCX6FBml7fdTMxOnvS
	3xMKQ5t0kiPntZ1RU5uvfS3l50rfzTLRHjDNT3+tNwXcWkEN8xvEyULdntJTAVm39QibmsugRQ/
	cU4WhhEA/UkuGhsuZ7qKI+d+nCGFHQO1MCkgL5K24WT51U8USB0iKLyKRW1yUYQI6FH37/3x5Mo
	DBzPw+UG3HyMB38c5h8vSq64QA7AK5i1pCwLGXDkdURMWxOUjfStpK0U8WhpA+zf5Nxkry72XXr
	HMF2/qVJfyptApBT2ovqDPRKeU5Kuu9rYtZV8gWYijhbyl+bJjVS+JfWcWkyzIRhWHFq6r7VTIw
	c/lYqIjJIuo+iJpdOKeNJY
X-Google-Smtp-Source: AGHT+IHSXLf/MaBMGoP1ipyo6HIx1farhws9Inco9aGTj7aaRrCeY0cgBMm3s7sKT+uA83mkq0UQnw==
X-Received: by 2002:a05:600c:1f8c:b0:45d:e5ff:e38c with SMTP id 5b1f17b1804b1-46e612daeccmr28760345e9.32.1759337103419;
        Wed, 01 Oct 2025 09:45:03 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5b5f3015sm41174145e9.1.2025.10.01.09.45.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 09:45:02 -0700 (PDT)
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
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 1/6] system/ramblock: Remove obsolete comment
Date: Wed,  1 Oct 2025 18:44:51 +0200
Message-ID: <20251001164456.3230-2-philmd@linaro.org>
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

This comment was added almost 5 years ago in commit 41aa4e9fd84
("ram_addr: Split RAMBlock definition"). Clearly it got ignored:

  $ git grep -l system/ramblock.h
  hw/display/virtio-gpu-udmabuf.c
  hw/hyperv/hv-balloon.c
  hw/virtio/vhost-user.c
  migration/dirtyrate.c
  migration/file.c
  migration/multifd-nocomp.c
  migration/multifd-qatzip.c
  migration/multifd-qpl.c
  migration/multifd-uadk.c
  migration/multifd-zero-page.c
  migration/multifd-zlib.c
  migration/multifd-zstd.c
  migration/multifd.c
  migration/postcopy-ram.c
  system/ram-block-attributes.c
  target/i386/kvm/tdx.c
  tests/qtest/fuzz/generic_fuzz.c

At this point it seems saner to just remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 include/system/ramblock.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 87e847e184a..8999206592d 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -11,11 +11,6 @@
  *
  */
 
-/*
- * This header is for use by exec.c and memory.c ONLY.  Do not include it.
- * The functions declared here will be removed soon.
- */
-
 #ifndef SYSTEM_RAMBLOCK_H
 #define SYSTEM_RAMBLOCK_H
 
-- 
2.51.0


