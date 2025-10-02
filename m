Return-Path: <kvm+bounces-59415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9DABB34DA
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2D1B54E1EEC
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3699313544;
	Thu,  2 Oct 2025 08:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ig5ke0Ph"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F052FB094
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394591; cv=none; b=o0Nf5nrd2EEY+XJEyCUAnpkJdli1XzfEWoVujJQRWg8AAav0FFsH0uKYtha0ruHQIcEZo6WS199vvE8AWyRO2fZNPxwkO85Zm94QxJSOVAdnznanX8b03mvq4lpOqHZsThS6wApRTL9JAVRPvzT1Ee/K7pmCZ5wLisYpEv0Q2M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394591; c=relaxed/simple;
	bh=r4F3QuYpph0Qx9jWEW+Da9l3w7vMQe+vDJR9e3flMr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DdZUFv94McwE1qeC0ICFtFIKgGz9GnRlQjewWISEw0QYcy01MT+WdLAnosuNf8zcCNC9f045lMwfu2715AzoL2nBvC45TCgxvC+fWCtRZuzvM98iJXqDanHnGIYNTnPwSbGNWeIqPijd4c4V6ElzQdToc2uHtVgj4KzHDOjV52Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ig5ke0Ph; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e3cdc1a6aso4624485e9.1
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394588; x=1759999388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VaFs+E7RwXKG3PK6PiXPvBWe0XSzQsXZvT65+7chMhk=;
        b=ig5ke0PhwQAxANW3xk9DVrdCCkiz3qtXBXVoslj1awobqzn4FOes33Wytu4RKfUwTe
         I4ZeCM8RpPOuPwi2sbiFX1UdATu2efK+lvID0n0qIjTX8/kdiEjNcVhHqK5WXsp8n2gR
         jCkATg18JBfIBFcqNOj+DGlBvH3OunYyX2+NneERLUPlRtOomhgMK9/+nJkJ5MIDXxZB
         etOfNOOdyQkIXqH1UXHbW5WR469zGPpfoV1B9uSaimTBbNELZeo29WDMaZGfD3zE92Iv
         T7XGzSs8a8C901baicdF5XtKVbjM2sRcjxhrgnGwve939yJ4BO6zNyfWiiHscz7P454s
         eFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394588; x=1759999388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VaFs+E7RwXKG3PK6PiXPvBWe0XSzQsXZvT65+7chMhk=;
        b=rWnlDtf7HagPWukuxi+EYHsREZVFt6VbHbNk3kyzrE1PmBqA6L1LxFddoI45uCLPh/
         +60/8AtcnAtQeQuHjWN1iRvLEqgBhzR0iQyddQU4Ii3vq1udnGxr2+3FZtRLffyKQEXS
         lHwWB6NdV3vWSdKfQvr2NPpuSdOwhk6y6r/LVI2MCNW5EEALgQIQ1Mw9VFJhZFX1SBSf
         DklvIXEH+EoL+R4nPBBDndDAkS1rhQo440K/qQCkDtZzm3Srd6j3zvTcTpG3AVE5NqWB
         JT8IFZZQVtTtl18n53FhQr+vPWM4If3uHu9QELMSuhKtFrZc7z8nWvg5bCCLiw/v8uC/
         MJqg==
X-Forwarded-Encrypted: i=1; AJvYcCWzwJutqD0hHzHfl9KnxNc7QDMwRG54kOROD20JjvIDBH7w3kyPrCXZE+NLwRDXHOssTf4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQaxVBav5cmSy/Pfw1xXhQjYnhHnEsL6K13K7Oi8zq8G44v2Ui
	ZkMyHQ5kDMDPBXSwEoBkIyQTorBZCLVe/YqGa895L7HMCBPW4SX8GVsFgfaD6wfb8Ds=
X-Gm-Gg: ASbGnctujB4ZnszfwUfYJFtFV2pkP+o1m8N+VDT79EMRs0MSySVwSvFUKx4YYXELiPX
	NcGSFwnlleI9FXIVRkhhiM5Vfd1EbvDn+9pZWk4Gd9Hi3dmcAsiakPfLC5IYRKV3PfQ8CxWcbRK
	sUw1vBdCIyapdBlW+LIbTW0T60iACqjBx4odR3CMzIGO1BtAZ6l86JAQ/3vcKs3UVw+AZNA8r7M
	K47oCqIYMBYc4yZW82QjRS2hYfTnQaCyM/oq3GeJn3GQ0xA1jgmIBv6RawYA28LB17eaTGpDn7+
	EkMiBVxqNMyfWC5ly9rwJVkvbrM8ckgCAm7CQoZFl7CTzLbg0KFDiom6mTkxKsyolkq54ABJcDi
	HX9AmrBPQYJhhWsRh3NUvpWgTLLBKjMBCvJZB54HBOubkuUpc7vDjeFDTX7Ihp6TjvwlIe1xRyz
	VLQEnozAZDnvKX0vphzR3l1D6q4MrjBQ==
X-Google-Smtp-Source: AGHT+IH3oBDcFkCrZW4zdMmmdzvura7CGJv+T+de06uu1CRKlNDCaUMsAj1fOdp2bPK62ElNJTRC7Q==
X-Received: by 2002:a05:600c:408a:b0:46d:38c4:1ac9 with SMTP id 5b1f17b1804b1-46e68ba134bmr12450485e9.2.1759394587659;
        Thu, 02 Oct 2025 01:43:07 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e693c2ea5sm24632555e9.16.2025.10.02.01.43.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:43:07 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v4 13/17] system/physmem: Un-inline cpu_physical_memory_read/write()
Date: Thu,  2 Oct 2025 10:41:58 +0200
Message-ID: <20251002084203.63899-14-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In order to remove cpu_physical_memory_rw() in a pair of commits,
and due to a cyclic dependency between "exec/cpu-common.h" and
"system/memory.h", un-inline cpu_physical_memory_read() and
cpu_physical_memory_write() as a prerequired step.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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
index 29ac80af887..d5d320c8070 100644
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


