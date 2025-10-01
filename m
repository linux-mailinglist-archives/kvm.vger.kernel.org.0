Return-Path: <kvm+bounces-59253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 159A4BAF94F
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8D843C6CFD
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006BA27FB0E;
	Wed,  1 Oct 2025 08:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BnLG7/JN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B0227B35B
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306952; cv=none; b=D5elJwW3muNjzyN5eapu+XYfVuVBK5SrtQPvMiySK4EJP3CvmsugQQeVIvnibAu0TJ9IWcyZSzFks9XgPHlIQbwmIieTPjnQJm7bHLDsr97v4vKgH5UnCMaRxNmbiFSdo8RAwTTzSx+d4cxY69VEZ6tXhS5qZC08g8Q9tmfdOu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306952; c=relaxed/simple;
	bh=6wKvjfCFrjJ8u4CPobX0hP4EaNVQN62JkQpAPxP/Gos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZ48uXoJupgvJY4OAcIS90K7gXKI+TaeBE7ox69x5uRax3Rxji1nB2wI2rHd3qrYMd6HSeZAy8v3uGobqJ1UKUkjJplSMk1xXvRcBouB+9G89FQe+vcbT+xu03TIIEXHUX7fvweZbc5h4DkRWtyZFBe4GYb2U8yI0x+pl6aIbN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BnLG7/JN; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ee1221ceaaso5515898f8f.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306949; x=1759911749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9IGpJufeP6E66MY+FRkIfF2QgQ90YgPFg2n1Q4hyMg=;
        b=BnLG7/JNR69EGq+ro+x0CQqj7aosGnEM+TRFE4pqY9YoN2d+1oRrqlH8ajlcNKDXHc
         lbKZIqTLE4JolNtvuJ7DtTI9rrg0FLCirfMBZLzYbswzvAz6zFWP1gB3xDFKd4PTxX3l
         S7eNWaB3xNvl9450XbI5uMzWbsHei8EWrDl1KABlBr7qai1/Cv7FQT+rX7t571mJrddX
         JTAjR8aSY8FwAzXvOliywuuOouuVrZ1NYU0/PZZm9gW/FcYNmlTz2K7Z4kSDmSy8OLjt
         HSkdN2XQtda9dN0cAQx4RlihyaExXut0KYwDGGpJk6d716mszFZrQXM8igjfbhxEP7cx
         786Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306949; x=1759911749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V9IGpJufeP6E66MY+FRkIfF2QgQ90YgPFg2n1Q4hyMg=;
        b=rAsVmv2LL6nAMLRBLNAg2Sh5d+xMqetngztUOPHaxGLdxbAPA0hBK8WDK62L1FQGWV
         Okb5WTF3q2hESKvFoxDcVzdEy4BITVrXnEqofL1JJi24Ik21GvXO661v1r87X9iJZUJa
         rN0bzUsJhKQB3WULzi/ZLssTyxzPAhbhOf+21ZlQZYYCR5Y5CZxvK2YeLoa0CV754zxu
         x+HG0YuSEbljU7UxBHfU4ujiuJuqSEaZQX025JH4m3as8PdGJF4D1RiBEW09lVcyD5y0
         G3XwgnMikweIoA8DfEUOyA/eqyyAG5Kc4n2LWR3Lj4OfNiBImgKxMfimjJKGdidT4cXH
         v6FQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlFJYjG/SvQKSBDkYz7kFbL7CSDkDEPGvRuCGY/G54s/a35e46A4ueKepBNvBAxV3ibQE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4+C5LmQ0RepDJjbw3/4f85R+1lHQBBZ8Q9P+tzeE9Z+sdRFbf
	PVXXkY4cQBrT8g3u/XihghdZ5JjHQZqjepz1E5GVLKq4ZJ4tGy6IWb32ZE6uItqa5uM=
X-Gm-Gg: ASbGncsJwK42aqbqWQOSh7gpZSzGZipTFEIyVGlUP+aBRoQLBRl3z1HumE81TeCru85
	Rj3ETL/qzSpbmD/9/EPYXCR4mrrF7K996Rv9N4sLQEGyAZd5p7T6MOOjU7msnlrUrRxlE6hXyTg
	CQP8/7iqGoYZknQshwojVtpNVGUPK2IVC3KA4GP/Xj4f4eOJ/+S6cED5jKrEg3zHzYiyPmjsmJK
	Aekv55aMvWn2AhM4vXYw543xQ0LhZAXrpzvU/bw7NJaKzuCu16ntJMYw7J9lzKnn0VmVhq2j5ix
	fSWpRh0uL6gQqj+pSa0E1UQEbd9fZe/NuzzryDOx3/aPmmdUBkLS2PSQgmF4cW7mV4LBhOdW0B1
	VXo9ygG8TxVD2Lm0VUXb5W+cPflttZ5A2zI73lBskOljeTDr0EybP4wskkmFGeZ29kn2oD/s3ha
	VDVys1m0qmP+ZlggvQRSfg
X-Google-Smtp-Source: AGHT+IE7KkPLvaR1QK3ujSOd6vDORA988gltgTw9ux7aYxUsmtBHV92rbuikFKmOoYRH4wm0uOW4Ew==
X-Received: by 2002:a05:6000:400b:b0:3e7:535e:986c with SMTP id ffacd0b85a97d-425577ee89cmr1798733f8f.2.1759306948890;
        Wed, 01 Oct 2025 01:22:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b7e37sm27742425e9.1.2025.10.01.01.22.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:28 -0700 (PDT)
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
Subject: [PATCH 11/25] system/physmem: Un-inline cpu_physical_memory_is_clean()
Date: Wed,  1 Oct 2025 10:21:11 +0200
Message-ID: <20251001082127.65741-12-philmd@linaro.org>
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

Avoid maintaining large functions in header, rely on the
linker to optimize at linking time.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 9 +--------
 system/physmem.c          | 9 +++++++++
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index f8a307d1a3d..cdf25c315be 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -183,14 +183,7 @@ static inline bool cpu_physical_memory_all_dirty(ram_addr_t start,
 
 bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
 
-static inline bool cpu_physical_memory_is_clean(ram_addr_t addr)
-{
-    bool vga = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_VGA);
-    bool code = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_CODE);
-    bool migration =
-        cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_MIGRATION);
-    return !(vga && code && migration);
-}
+bool cpu_physical_memory_is_clean(ram_addr_t addr);
 
 static inline uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
                                                                ram_addr_t length,
diff --git a/system/physmem.c b/system/physmem.c
index 7973448b3f8..b27519c3075 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -946,6 +946,15 @@ bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client)
     return physical_memory_get_dirty(addr, 1, client);
 }
 
+bool cpu_physical_memory_is_clean(ram_addr_t addr)
+{
+    bool vga = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_VGA);
+    bool code = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_CODE);
+    bool migration =
+        cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_MIGRATION);
+    return !(vga && code && migration);
+}
+
 /* Note: start and end must be within the same ram block.  */
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
-- 
2.51.0


