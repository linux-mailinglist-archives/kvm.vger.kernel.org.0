Return-Path: <kvm+bounces-59254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F22BAF952
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBAAE1C4342
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF0819DF4F;
	Wed,  1 Oct 2025 08:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XatFwkPT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB07127A456
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306957; cv=none; b=PNwq5L0wLQ9qqPYCH1hah9ybbPvOjk4Y1lRCMuwe5lZB+wdHHJYKsN13+5vO7qNQIr9i3bRhjt96xRpKE+rVHCw/Hwie9QpP95uxyNTKmh876wnyzrb+q1JG/QH019Nu7IPJeATie4yCGTdrjiLOgZplz5ROWLePwNwo9e9FWbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306957; c=relaxed/simple;
	bh=+SXA9XCBHEip0Zva4OuKdPlWL5Aq7TM+LAb1/+BTrGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U499kGIKdyZ96sKpoH97/6NT3vD8rzM2oZiPjwH0gizT0JM2kJBooKHm1Yqdkv74k8uTnoNQMcKwLyif3lX+C4X8CyDaVPMefx8SXEBHDhyMVQ6kr9bNlwzFxiiHLqIlPOW1jincGuMaiVxr3fgqoDfSmlVh3RzioizOFI/H1qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XatFwkPT; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e6674caa5so980725e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306954; x=1759911754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDgeo2zJE06h8QgA17T0RsOYYTnGmADPzWOfZYKLdkw=;
        b=XatFwkPT9QKumcfu40RdqYulGp0hA6+fAoi5gPgaeGukmBIBFGCtJ+VcdlYUfU+gin
         tVs4J3tEwdN8M1zxtZyu7WKa7WlpnV91PHpocm2YjwbI+MtL90xwhnOrb5QkNnql6Rib
         pmpM3ckkMk/tg+sbdheBLI7XWgY3bZfgW3IzD/ZjWN0BOLnL34iPZJriGEH+88aui4ne
         3qnNdV2kKFwqGPTgGVWkq6aayOJkZYebciRllmeHh82uUYgHPJES+tysFYka9a118rkm
         wk8H7XBF1vPDESf2lbS5rt2KdWeXuDjXsrVhGuWEoc53avPv3sWnjAvxH3ku7VcbUmJV
         TiLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306954; x=1759911754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDgeo2zJE06h8QgA17T0RsOYYTnGmADPzWOfZYKLdkw=;
        b=QEZrCB3Ps3n0eFAp3nXNkAu6rzTcX1N/QF4n6XtQFZ6xmwE0B4f76OKa0wXy+l0Mmc
         udvMBb/b4JoEy4BPjzmj7HYOHSqdRtBvTDNZ8xA4ypzHPbcL68+aqGxhuboa5n9vWleZ
         VdDMelJqYWIoHksCjPN0XRVffzEJG1VhAUhODNkUnOjYPu790qeqOS6DcJ18g02bWdUx
         73IyC11p4JokvQHcrrLkSw0qFHJKFJ8N01Kg80kawwelXMKfcnjTasJKZclJ+3KB0V+0
         fNLA4Sw5Ph/2OYKeTte0wpgDqb6+kBdSxvtODI/8j70knVqrNPowu1IDTHG/4KETOWzN
         Xfew==
X-Forwarded-Encrypted: i=1; AJvYcCWxViskuKdcNg1eTOdU9N5St5PJYq5czw9auss+uDhoppdvmb+9o0gEBRE7Keu+BrWmkk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEvIG7qg3QBXeEKALpyp9X2Woutvq2WQ2vDnPMBCl/C0iDhHk7
	/38ZJ7+izahfvS29Altf14T3QtPrImmhfAnSqwhD4dKyCVng0hJSEO69VuHtqzSSKgU=
X-Gm-Gg: ASbGncs2PuYXeDH0E62v1CbR+bVKiCDEOTreg8BLF0gV9y8jnftKpfFjEzCC3kwAdOL
	Elo5PYq4nmEdfs1x/Ch5mqrJXfKglHQzQqzLjcWLBpA4bZhDNtAGkKLG0HjsbmqURpvcyQawca+
	TM3Okp2eJD06cOCdvW6HyVjuCqigzHj97zg5za+V2Nf7MoRYxF5YBc6N7/JXonQfkuVzbnJ4rvM
	9l3eoQHP8evLVvOp0MaMizPPaXDc4inCe1QotS8zGIGwdlX+JME2wM96uh3HHbHlo7dJSjIDc+U
	bOVLdC2hLy85wU++I1VoPWinWkyWVK75XNrtJl1rHs9OY7/8BPpe8OLE4NPiKlEAX9Zof30Lfnd
	Tj/FylAQ8DTDohUP6WizvO2z4K/kCTRcn8GZyB8GXU+kivlR8eX2zkvznpn+axsizP4RzTi1eUF
	uiyI59eQxnvwgLDoaGlckS
X-Google-Smtp-Source: AGHT+IHvBo+V8oomdTfosMLuI0EpMsA23PUCxfHTKlB72ocxI/viBCxHR6lbgB29b5WbCh/EkkRIww==
X-Received: by 2002:a05:600c:a30b:b0:46c:adf8:cd82 with SMTP id 5b1f17b1804b1-46e58aac99cmr48828895e9.3.1759306954128;
        Wed, 01 Oct 2025 01:22:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6111c1f4sm17544135e9.0.2025.10.01.01.22.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:33 -0700 (PDT)
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
Subject: [PATCH 12/25] system/physmem: Rename @start argument of physical_memory_all_dirty()
Date: Wed,  1 Oct 2025 10:21:12 +0200
Message-ID: <20251001082127.65741-13-philmd@linaro.org>
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

Here as cpu_physical_memory_all_dirty() operates on a range,
rename @start as @addr.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index cdf25c315be..7a9e8f86be0 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -142,7 +142,7 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
 #define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
 #define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
 
-static inline bool cpu_physical_memory_all_dirty(ram_addr_t start,
+static inline bool cpu_physical_memory_all_dirty(ram_addr_t addr,
                                                  ram_addr_t length,
                                                  unsigned client)
 {
@@ -153,8 +153,8 @@ static inline bool cpu_physical_memory_all_dirty(ram_addr_t start,
 
     assert(client < DIRTY_MEMORY_NUM);
 
-    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
-    page = start >> TARGET_PAGE_BITS;
+    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
+    page = addr >> TARGET_PAGE_BITS;
 
     RCU_READ_LOCK_GUARD();
 
-- 
2.51.0


