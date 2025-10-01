Return-Path: <kvm+bounces-59250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 593AEBAF946
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 047081C440F
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7BD27F75F;
	Wed,  1 Oct 2025 08:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lhODIlpP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEDD27B35D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306936; cv=none; b=H2zi7TTo+xsetFgU4ya5PgwyWK0jKfhdqOyqzSvGDOE1PeURfvoIboqAeLwMYipZmFluxbzzYO/cf1aBofDEigTCpvN5wMdG2BYYP665mFCTAGdPg2WlNTzZlL3xtJySMlqRLb2IA9MMFtfnpbD6FPXXgBut7K+ofd3FVhbhG9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306936; c=relaxed/simple;
	bh=Q+gX7k56p2pjb/dWRCmel49PCACcqpFMH0V+KuTtK54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HFDv135nJE+06c3QnbC8PmGBZKAv6CzLGdiqcPOJkVAhFbWhju5U7u++xtuv++dL8+phFN1a1W76M7FLO/HVE58lvL6zPSbyV6MCeUvkx6rNkKuapG7BTMBMoRbyCpoJSw3DWIpl0KSMfYnT6TgGz8xHbJfRsQxn8fBfMTl5ddQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lhODIlpP; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so24753835e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306933; x=1759911733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TyFBjzM/ZIChvPqFREhzkAXzAXG+v6/MNIDOu8ypqSQ=;
        b=lhODIlpPk788QIA6a4Vl5WwL1PmC92hyrfnGnZ38jGa+xtUlJiqWpwjVUqSY8uz69i
         PJL7ZNIaUMpJQ1OTwv3OQMoJqJgNBMmFaXHB50jCjLs938vQ19sUl3kmVWKt+FWV/JRH
         Epku6uKTAMZLPGB9NzAUmijJbahGBPwiuADRBZPvJLNWoKwbKClweWwIj98acD3RKaFQ
         Uq4awTdCrtE+8yazXn3hOaUlr7yF5cRZVqL8KzoUM+B263dAwjuDDxLq5/INRMkZBThM
         kRfiAVgdu+qL0PriaE6sA8dGaz9IdBl2eGY5QmB+tRxrGjGeLZzdvpTCY+pLrbVrT7M/
         jLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306933; x=1759911733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TyFBjzM/ZIChvPqFREhzkAXzAXG+v6/MNIDOu8ypqSQ=;
        b=B/MDvUYIsnEEMcmKXJEp4Pp4GWO3I3D1L7QDKnq4THw6ApqGGCP2/llILrDRdnIeMd
         TSgwwS2l7UWyrporA1KfXSCOR4jh5PRc+Uio3FCfX1m8BQ8k8/Kk9aYacm56J30R7JLJ
         qIwkGPy8C2Lmo78u4M8RZ9scfjdSQMghPHiGWFEeJCU0LBokLdV5SW2LBaci55QSEJat
         g5n4Be8lh9FWvHZ08ijgIGYHUX8excNh+9CL0hjpKfWNG9gNSfkWatUs6R6x5Q6E6kuA
         m5mKg6Lw06EEZ0fKEgYjwcPcHC+U4w/cmZgp2k8HVEuYw6Ok3bxkitq+Ld/KVGC+t8P9
         Fv4w==
X-Forwarded-Encrypted: i=1; AJvYcCVcnXH2L3v2+NVMoVkPjt9WjPJU6W9ilwKuoVmcQOKuDJLjQcJo+zxssJm3MqT9EwTi8cc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe3AHEVlXa+AmTKquUPMB5NJVNU5CYSqceOkJX3WIDO7haPoW5
	pZ3yAZgZIkemU0GM9QvieyZLeVFdzh/puX6w8Eii8oxjrmQuKywsOeELL9hu51idzgg=
X-Gm-Gg: ASbGncs/Kswn+sLLPZm93y85FMZPRgHFXds3AyE64CNP33hIOEin8I5gI4O8VqAmHz3
	Z599DP9vB1B6YSaiCZfi9GEhCdJExyYXvR6K1H7CD/5U5M6Be5ezKRvTr25LkDNzXGVRup+AG1G
	9fbxlCDwnViXVaLinWwVbF5Q2wsZF6IUOhwq1S5uRyLiQ+oV5+V+lxsBQKzP+l8Fwx7LTaGzMqb
	kVqnaDrLvYCg0XmVA2tJVTp3oD6onNBb5j1gmjyQqOtomcu2cRBhtL/BZFeDMsR4YcbFvcdMZ0i
	NxWMw3H0wVcPD6xq9+QVwYa1E8bCzth3gKllxj9DpufDETkky29FmM2F11y2SKUXacsS+i7Iwm2
	AAMW7J0dOnxjyxQdLETYKuIrzPBddui6WfGJMMJ02oMSFZM/s5ni/lG7GVBCM0hgqWbAp0S1Vzc
	UjjJY20MbNnQ+EDPru/D/B
X-Google-Smtp-Source: AGHT+IE/PTpfa6W1FpPoDRcE8hMigdDVrnIWWOSLLneA/kKTQFtjZB0qqjhW1MeuCmZZ2K1WESJ2+Q==
X-Received: by 2002:a05:600d:41eb:b0:46e:45d3:82fa with SMTP id 5b1f17b1804b1-46e6127a2c9mr22144885e9.10.1759306932959;
        Wed, 01 Oct 2025 01:22:12 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6199f186sm27339275e9.7.2025.10.01.01.22.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:12 -0700 (PDT)
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
Subject: [PATCH 08/25] accel/tcg: Rename @start argument of tlb_reset_dirty*()
Date: Wed,  1 Oct 2025 10:21:08 +0200
Message-ID: <20251001082127.65741-9-philmd@linaro.org>
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

Here as tlb_reset_dirty() and tlb_reset_dirty_range_all()
operate on a range, rename @start as @addr.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/exec/cputlb.h | 4 ++--
 accel/tcg/cputlb.c    | 6 +++---
 system/physmem.c      | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/exec/cputlb.h b/include/exec/cputlb.h
index db7cbf97826..995fe31ef75 100644
--- a/include/exec/cputlb.h
+++ b/include/exec/cputlb.h
@@ -32,8 +32,8 @@ void tlb_unprotect_code(ram_addr_t ram_addr);
 
 #ifndef CONFIG_USER_ONLY
 /* Called with rcu_read_lock held. */
-void tlb_reset_dirty(CPUState *cpu, uintptr_t start, uintptr_t length);
-void tlb_reset_dirty_range_all(ram_addr_t start, ram_addr_t length);
+void tlb_reset_dirty(CPUState *cpu, uintptr_t addr, uintptr_t length);
+void tlb_reset_dirty_range_all(ram_addr_t addr, ram_addr_t length);
 #endif
 
 /**
diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
index 2a6aa01c57c..6807328df82 100644
--- a/accel/tcg/cputlb.c
+++ b/accel/tcg/cputlb.c
@@ -916,7 +916,7 @@ static inline void copy_tlb_helper_locked(CPUTLBEntry *d, const CPUTLBEntry *s)
  * We must take tlb_c.lock to avoid racing with another vCPU update. The only
  * thing actually updated is the target TLB entry ->addr_write flags.
  */
-void tlb_reset_dirty(CPUState *cpu, uintptr_t start, uintptr_t length)
+void tlb_reset_dirty(CPUState *cpu, uintptr_t addr, uintptr_t length)
 {
     int mmu_idx;
 
@@ -929,12 +929,12 @@ void tlb_reset_dirty(CPUState *cpu, uintptr_t start, uintptr_t length)
 
         for (i = 0; i < n; i++) {
             tlb_reset_dirty_range_locked(&desc->fulltlb[i], &fast->table[i],
-                                         start, length);
+                                         addr, length);
         }
 
         for (i = 0; i < CPU_VTLB_SIZE; i++) {
             tlb_reset_dirty_range_locked(&desc->vfulltlb[i], &desc->vtable[i],
-                                         start, length);
+                                         addr, length);
         }
     }
     qemu_spin_unlock(&cpu->neg.tlb.c.lock);
diff --git a/system/physmem.c b/system/physmem.c
index 000bde90c2e..098824ad1d2 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -882,16 +882,16 @@ found:
     return block;
 }
 
-void tlb_reset_dirty_range_all(ram_addr_t start, ram_addr_t length)
+void tlb_reset_dirty_range_all(ram_addr_t addr, ram_addr_t length)
 {
     CPUState *cpu;
-    ram_addr_t start1;
+    ram_addr_t start, start1;
     RAMBlock *block;
     ram_addr_t end;
 
     assert(tcg_enabled());
-    end = TARGET_PAGE_ALIGN(start + length);
-    start &= TARGET_PAGE_MASK;
+    end = TARGET_PAGE_ALIGN(addr + length);
+    start = addr & TARGET_PAGE_MASK;
 
     RCU_READ_LOCK_GUARD();
     block = qemu_get_ram_block(start);
-- 
2.51.0


