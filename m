Return-Path: <kvm+bounces-59038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C77BAA508
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24D2E1922843
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1817123C51C;
	Mon, 29 Sep 2025 18:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zzmb1woO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE1578F5D
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170846; cv=none; b=ezLUBAX3hEshK7/XuOamfCruAhdIpZVFbJRSzR2eyCDYwcyHdqWo0FumuaI1WvpySSiz4Gz/zhQZkJooOCVlIJT3QVtiKmW8mzjcCkjXkJmNTs08TxZHYfOPjEWFNqn7xYHQ9zZ/4RYRWZmzEC4oUlS2dfD/PwAMilm5dbjS47I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170846; c=relaxed/simple;
	bh=tioMunxZBZqa7WOFuKkoZd7RyMTU/HuapTZkHuK7h3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P2opDX7hmv4TLXE19naApOILtqiE7dsCYRHDBR0mG8BRV1jQ9IclOzpU1Mqfm6Dlo7b8jHl/J27DzR+V8xlczmEmRz2pjR4kwc6ArUyaz2nnjlE17UmjtYVWf/NAz9157X6AGyMsQoBoiwx4QxXq2JS5+aZEhQacnOpIHrFTiGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Zzmb1woO; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e4ad36541so23889135e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170843; x=1759775643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LuYVzxDYsV8q8g9d3IDIaYEYUyrQfEG5rj8P4oQ0OGY=;
        b=Zzmb1woOwq0a6JkyZTRQg8iqnUSBMx+a9oPxBqvJyPXa36bOSjXjhDQIVVhAbS8IIg
         A+G7UD5fErBuHSqryEcPOQpOBAMzTCeIRDHFRRfqKlzD51MvZ4lp/3g8ngi0Vj4Wfohb
         EmFkY2KkuWGTWJWS8ikN7y62k3zTW4QJOqpUR3EYbBHWP1SeB3ywMVLAWdL/IIsTrqhZ
         Vk4ZVvMaP5PoJxrAgcvdJsMFCyMKCA0JaOQ5xamUP+pJUc5F15nEgXB0gL8E8JQT7eQL
         Et/8jza8EpkFiIZ/uRoBxXdifipWZXD/tYBYlBXHzfGfoiKVffHlHfQ1UU5Olc5DSvYl
         9lpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170843; x=1759775643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LuYVzxDYsV8q8g9d3IDIaYEYUyrQfEG5rj8P4oQ0OGY=;
        b=CFi9WOkmJwYhjsU7o08f1M8CIds4zsCfXV9PoMy0ALP40VGsI/fqapU+kKOe3cwEBD
         zgOS9jlHesJSbnhOD5BUwUVE8n7Om4sSXTNg3ZTTK/AYvir/mk+KK/WY2MmdfCN8qsDq
         gpBP30hENRURClt0f5M2uW1SOmyVT4z7+ZVn5Ni/XG1KNoIXLga6CTzhA/AgynqCooW6
         D8+qi/PKoa2XHgbBoO75ria1P2OqTSlVEmfp1Dwj20ydzdyVFpzYQ03qvllaDqLeYNVX
         sEoaNmYJMRarpaLCudVQdiJi+yNbfsTwkAYLvd3MHq6JRVuSB0BTIeQYPOHZXat8BsGp
         q0zA==
X-Forwarded-Encrypted: i=1; AJvYcCVeKoZLdFNTuDWCoSDKv7M6rXvNrglrm9J1R6WBewuv9646XcL+2tH9Pj9n2LTnZXYIk64=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP9SPKnDh7kxILvle4oTcj04csuboqoUY0iiWJozxYHJ54nHv6
	08SZpOduuiIDAxMgDti7id67YpOSlrq+7qtdAJ5xAc8BMZW+2s6u6fa+MjC8EZ4BLBA=
X-Gm-Gg: ASbGncuHaZNUL0E6aYkdHoZVl7Uq30T2gunnzGse5HEDnzpNB3OReVBEXtUrJrzxrZ1
	8KM+kXJynqtHNavPNt/eMhqlj3OiVXE79i9776V3qwIJzInkk1vWkg0Ck72z0+Iz+1lG1XqreJ1
	bQf24K+UJ6Ip6dj223SpWUS4/vtlt2/Si5vEm3OEapEa/FPnwd+uotDSMTzhVEKDVql+Aj1EmZo
	pjf7FOfiYKq75UB7HFOHjAE8CQpHCobxrcbp/PTYlMcRWOsTbZpP2G32hCgURra/J2MNKMLzeLl
	28/IxOmqna/9gpMGfpbwlDaBKXf8ygT2vwsq9R5kuQQ0NuzAub1thfl7BawMM0P+BqTNVxY2tM3
	4T7JDXc/IdgOaL32w+HY0F+mDw1h8Ru2/AfElCRd1utV4Cmp4KXgKnbhGgZRCECLS99JWXGGtwd
	ag/ujws6wHyWAczd6BEg==
X-Google-Smtp-Source: AGHT+IHxkSBKZz9UIKJGJ2MuyS+JOGfRYnVKVs7Y+XK907wXLr+RITSG6kYiNQobFw2cPjU7tACI6g==
X-Received: by 2002:a05:600c:a47:b0:45d:e6b6:55fe with SMTP id 5b1f17b1804b1-46e32a32b56mr143974255e9.34.1759170842607;
        Mon, 29 Sep 2025 11:34:02 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e46de67e1sm103906645e9.6.2025.09.29.11.34.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:34:02 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>,
	qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	kvm@vger.kernel.org,
	Eric Farman <farman@linux.ibm.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	xen-devel@lists.xenproject.org,
	Paul Durrant <paul@xen.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Anthony PERARD <anthony@xenproject.org>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 12/15] system/physmem: Un-inline cpu_physical_memory_read/write()
Date: Mon, 29 Sep 2025 20:32:51 +0200
Message-ID: <20250929183254.85478-13-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929183254.85478-1-philmd@linaro.org>
References: <20250929183254.85478-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Un-inline cpu_physical_memory_read() and cpu_physical_memory_write().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/exec/cpu-common.h | 12 ++----------
 system/physmem.c          | 10 ++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 6c7d84aacb4..6e8cb530f6e 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -133,16 +133,8 @@ void cpu_address_space_destroy(CPUState *cpu, int asidx);
 
 void cpu_physical_memory_rw(hwaddr addr, void *buf,
                             hwaddr len, bool is_write);
-static inline void cpu_physical_memory_read(hwaddr addr,
-                                            void *buf, hwaddr len)
-{
-    cpu_physical_memory_rw(addr, buf, len, false);
-}
-static inline void cpu_physical_memory_write(hwaddr addr,
-                                             const void *buf, hwaddr len)
-{
-    cpu_physical_memory_rw(addr, (void *)buf, len, true);
-}
+void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len);
+void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len);
 void *cpu_physical_memory_map(hwaddr addr,
                               hwaddr *plen,
                               bool is_write);
diff --git a/system/physmem.c b/system/physmem.c
index dc458cedc3f..5a0ee3b8e58 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3188,6 +3188,16 @@ void cpu_physical_memory_rw(hwaddr addr, void *buf,
                      buf, len, is_write);
 }
 
+void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len)
+{
+    cpu_physical_memory_rw(addr, buf, len, false);
+}
+
+void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len)
+{
+    cpu_physical_memory_rw(addr, (void *)buf, len, true);
+}
+
 /* used for ROM loading : can write in RAM and ROM */
 MemTxResult address_space_write_rom(AddressSpace *as, hwaddr addr,
                                     MemTxAttrs attrs,
-- 
2.51.0


