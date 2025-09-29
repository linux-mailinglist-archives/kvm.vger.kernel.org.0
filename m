Return-Path: <kvm+bounces-58991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B84D2BA9D4D
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 678D03AA057
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 15:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2AC30BBAC;
	Mon, 29 Sep 2025 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d5sC6OKf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B9A23536B
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 15:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759160739; cv=none; b=Wg842tw1535cumDytjk160HI8+as5CP7oWEbRAkkDcKmrN1GXOaWm8XS2hDykcmLOEIwVP3Gbnogb8cQywtqJf5MdlfM/4DnGwNC1cOQA6hPx3fGxElQkoy30VUu+opM4CWD3evSlAOGUSX1eq+94n44JShpgUlkyzUvbi1xgkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759160739; c=relaxed/simple;
	bh=WNgLZjjTfBSWQ8iHCGn7e2cBjMBG32LA4d2qm+Iwc4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=raQgagvKWIsbteLRZEtL1ZM3vjcovC4fxNDsSwKz2B3CFVRRfiYQZnHXU+qrYFj8ltLOizQZ4f/kDDaoh18pmQRIQ+FOh76795eO1AJsCRDQ6abqqWONnyAI0AixvBbQ0Sm2N6De6I8EChE8SQGAT2Frrda2d8DYzrepMb3fXcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d5sC6OKf; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e48d6b95fso22598725e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759160736; x=1759765536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5duVBAedShsIcSkwo/CkemVnUoYuZ0b5Z9+Uw86N4Pg=;
        b=d5sC6OKfQCyua/cWgjt+vZ7DiCtEQcZYid/0uBfbj686LUkvZxGCL1uFTQEuBADuhB
         yzn247lzVOwXGDXPKe7zX7xuP33uL+PkPaEg9OAlBTcnUL7ya5nYOyxBcq199hX2IEyR
         gWmqeG+VWsVBTy5MrZFn7AZTfRsiyU+TLbp5pJbcOFRjxbGoV0+6+SuPNu2dSnn1BBnv
         Y/c+1jgk7/RSYufYbKdc+A+eQlcPRD5ylqdwiGGcHmExwL/WSrIIRPsVLyggGdvmPhI0
         s+AtHMm53Fco61gzhQ/4fexsNzuRjRahudoYffHJGoqrGA6MbAeLLOlXYJyVCZIsvtyR
         4AJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759160736; x=1759765536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5duVBAedShsIcSkwo/CkemVnUoYuZ0b5Z9+Uw86N4Pg=;
        b=dhjUzMHjALKauyKEkh4cNYRVjIBwG92FW19i6ZVnlLs2JQ6C0ycAX6wad1LwrmRRNI
         MA/lyM1cnOPLrrHbp7V468+L/R2jMv+PZvR6Od0SThmbizsYp3HN5qYfuEQB0/MHc/WB
         0Zv2v37sVO1MM5/LRZDWqF5hCpvy1GW3ELogdcfmDYOlWr6OI+W4wG1blyGhNBqWgifZ
         EvOCT9UqNdMbBtzjYDrNNTeq7U5SNBvFI9uwaNJEZd8tp7c6OlDqwSpvTBgd7hNOCEtj
         qdHiEK8xjboUqNwzQlz9BWDu4LIBN6sWAs7O9kZfwEuiYO6RCrimbT2VdGkEhHjOfnDM
         p9mQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWxPmozcSXIMEpONigrf2gI6AHt8298k9FOgaQgWlNZ8AUl93QY0hvGjPuZlcqIjResO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqvlW2loPaWBZLnCnEwkxB7AKivq4yBuLlkBnC/0QP+9l+uXiB
	nEFhe6JQsXqbzKndfqa6SwFtc+tzApS+jwZlu8/bbHBiZYUMc1SWGx+6MosBBRRiCYw=
X-Gm-Gg: ASbGncsiTa/CNipCFrHS2jQlQ7m+MUpsYes7D339Cr6tkUw0giptWLo2acH41Ig7TKt
	nWPjlw6Ek3kw6523cljeBOxQsi7A2TkWpZ7h/WKdxSMmIe98HIrDvtPnEayE/Nel2s867DGHoRb
	+eh7blea5d/1HHVJmafur7jsN7taS9PNzafhohlypwlpBsvI90lqyrpLmM+K4mOGIeEOeqBjEks
	GdRA6AL3RF9fCC9ugOMNVYT5BB0daTeNQrPF8AvGW+xmq7ex+msyNjTGXqA/0T+DVSAYyyYAt35
	KrhTefOtrdC/QOqQ/cDCt0HOKGknXmQ7VJNWgA/bZDlvU12+iM3ZV4doDf4Gddxcbr4wA/XVuqI
	yKbgm5Z2dcRuog1h4mq12sgajsLxbQgfFBBaKgSZolmNwmYNamA/xeFs6iFhBPDZMaHYDLSqh
X-Google-Smtp-Source: AGHT+IFnrr+DJyaTbMYchai+g7LxYZJVHLrsdZD0UddcfiiaoKSbGm+KV6blFypn4IkDHPPrhdVuzQ==
X-Received: by 2002:a05:600c:1d16:b0:459:d3ce:2cbd with SMTP id 5b1f17b1804b1-46e329ee194mr156056255e9.13.1759160736157;
        Mon, 29 Sep 2025 08:45:36 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f3d754sm18544875e9.4.2025.09.29.08.45.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 08:45:35 -0700 (PDT)
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
Subject: [PATCH 1/6] system/ramblock: Remove obsolete comment
Date: Mon, 29 Sep 2025 17:45:24 +0200
Message-ID: <20250929154529.72504-2-philmd@linaro.org>
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


