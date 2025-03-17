Return-Path: <kvm+bounces-41304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E20A0A65CC8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AE83421643
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 220721F9A8B;
	Mon, 17 Mar 2025 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V3lkpcpu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C981C1F790C
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236486; cv=none; b=G4fKl7kUQttSis+fVxwWwmWYFYogxOfgZtb+1/ESaH3R1E48PDuUWhZOGRNGgzvMqO6EQxGDiBqL5EW1lQ7/qXHBG1wp86LSMSDZVoWTqKfd4dK5/+3oyQvszeQ9GoK7O8Y/xpf1ik7TaS8k1RZ+gevc29Dadb46JtxeyoL+v58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236486; c=relaxed/simple;
	bh=IelyUoYuqLIAw6DPSyagCvFpNJxQiv+t0JYUBox7DYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zlhi2Mn4F2GgnsUIYAHeFpn1oAxLvSgt6shmODxKm18HL/k8V/TQWCKJPJpWlbYM5asCkYQDhRt/ipXt88WpJJ+Ie+a+eMGuNRlWRX1eYcw7B1z/o0vC5MYGHaDro+fgwHAuzEM4YSno11bXcNbCUYoXmF4szlgATaaYuOamiK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V3lkpcpu; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-225df540edcso61416785ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236484; x=1742841284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBRugwqnxw4q7Phz2P050i5IjB6Zbf1WGwdoEilqtkY=;
        b=V3lkpcpuUAXZlejWVnO/bTguj31tVs4GAyJeQKf254IkKCcCrUIyiqAoRFHNrpm07/
         SMAudOVF8OlKlfr5OO50kUKsyD/drU6NTR9P8O2WJfrth4CuPWzAIOyanyNkt2Cw+NUk
         tbyVuJq4um/b0q3Tv18nxqk//D4LNslM2u6lX1PcPFfzEgItidVIlWH94nRComaZ8/jD
         FWTMjfcNCOMXDidZKkNUIhcuaJvGro42VbYw3R85H1e3vAFBu+zDe4p/N4TS9PsOlQag
         16jCUYK1RjGj3qzaGwwuUL8kEZMo4Ah/aL5XXvk91CdcMjoR+1gfEY34wC8INQC3ub7G
         mkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236484; x=1742841284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBRugwqnxw4q7Phz2P050i5IjB6Zbf1WGwdoEilqtkY=;
        b=EEQZjkBC2kh/gauOfbZDPB5n+pBw5YEGPlPBdemWZsb2C5vT8Kl3bI2tzxGErr5BYL
         y54JQVreEccbrnNs0mL95kCMl+KHdUHaEOmH8gecRG4TbW5hFwd+goNNME01KPgbp5uG
         llSH5tj2mFJ/SvlYaBPvrgRJY9dsdKoR2L0DePTrt7SzApHWZF4k5G2uScwXkd1aMrcF
         NkuXXc9OuT5lvC6p85uuHBOW1pcfctkkZWo/da0zJOk9CXhgCInywh4e3+GqC3ZrYXCM
         PfhoKepuwszVaWj278J0Iwu23zuld+epxAGJm20HAwQ5boq0C1ASn6k2cxoOvJblUBzL
         FdDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUL+0bQA4gsHAlJfY/qsfssOnFv6EwNhVb/C5en7iV7N6VIAZ+me7szFMrQpMfGqEajZtA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQH60Vvalkm/MaqplfzQYXPG03H7qEetZRM6qy+Wzb0kz0fi5P
	UU4zzPD0RghIK3cz9VzyPhPEyryCjBT5ECD2k+5LsU++YqRJll6PFsUP285Z+zA=
X-Gm-Gg: ASbGnctudRonlxeHOVP0hkfIF5Z/URbiH0+y3yqWeDkyUXUT8rmHer8USiEJBzKRwu0
	/80x+5im4NXV3o/+fXxh/GcNhlRUPgKR1+3Y7q4aAMxj1LMyj7cflNcCoifLPKQ2EQcvg3QI88J
	1ySint/X6LX36H8QIBa2DNvSZ5djLnZzEUYW62EOClpdXRiS9rGlJaFAS1SrdbRLqEszzJoYFV4
	7Nqazg0Ax/4pk9GfR2/L2/1XpJizPqmecBJW98fyX9EPazHHuVOp9c98LlhFyRWwrt7nr+mydQ4
	nl4cU7DFC4YA/lei2cSxmOJCwJu4Ec4mNEpGOclikBeQ
X-Google-Smtp-Source: AGHT+IHaIWG93SjaignFKD4IVBdMoq9cQTxlUlmFhZIj0sg1/yp4Pm5Fp9URm2R1oo2C+UJzak1b5Q==
X-Received: by 2002:a05:6a00:2e84:b0:736:476b:fccc with SMTP id d2e1a72fcca58-737577c60dcmr700300b3a.8.1742236484037;
        Mon, 17 Mar 2025 11:34:44 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:43 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 17/18] system/memory: make compilation unit common
Date: Mon, 17 Mar 2025 11:34:16 -0700
Message-Id: <20250317183417.285700-18-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 system/memory.c    | 17 +++++------------
 system/meson.build |  2 +-
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/system/memory.c b/system/memory.c
index 4c829793a0a..eddd21a6cdb 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -353,15 +353,6 @@ static void flatview_simplify(FlatView *view)
     }
 }
 
-static bool memory_region_big_endian(MemoryRegion *mr)
-{
-#if TARGET_BIG_ENDIAN
-    return mr->ops->endianness != DEVICE_LITTLE_ENDIAN;
-#else
-    return mr->ops->endianness == DEVICE_BIG_ENDIAN;
-#endif
-}
-
 static void adjust_endianness(MemoryRegion *mr, uint64_t *data, MemOp op)
 {
     if ((op & MO_BSWAP) != devend_memop(mr->ops->endianness)) {
@@ -563,7 +554,7 @@ static MemTxResult access_with_adjusted_size(hwaddr addr,
     /* FIXME: support unaligned access? */
     access_size = MAX(MIN(size, access_size_max), access_size_min);
     access_mask = MAKE_64BIT_MASK(0, access_size * 8);
-    if (memory_region_big_endian(mr)) {
+    if (devend_big_endian(mr->ops->endianness)) {
         for (i = 0; i < size; i += access_size) {
             r |= access_fn(mr, addr + i, value, access_size,
                         (size - access_size - i) * 8, access_mask, attrs);
@@ -2584,7 +2575,8 @@ void memory_region_add_eventfd(MemoryRegion *mr,
     unsigned i;
 
     if (size) {
-        adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_TE);
+        MemOp mop = (target_words_bigendian() ? MO_BE : MO_LE) | size_memop(size);
+        adjust_endianness(mr, &mrfd.data, mop);
     }
     memory_region_transaction_begin();
     for (i = 0; i < mr->ioeventfd_nb; ++i) {
@@ -2619,7 +2611,8 @@ void memory_region_del_eventfd(MemoryRegion *mr,
     unsigned i;
 
     if (size) {
-        adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_TE);
+        MemOp mop = (target_words_bigendian() ? MO_BE : MO_LE) | size_memop(size);
+        adjust_endianness(mr, &mrfd.data, mop);
     }
     memory_region_transaction_begin();
     for (i = 0; i < mr->ioeventfd_nb; ++i) {
diff --git a/system/meson.build b/system/meson.build
index bd82ef132e7..4f44b78df31 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -2,7 +2,6 @@ specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
   'ioport.c',
   'globals-target.c',
-  'memory.c',
 )])
 
 system_ss.add(files(
@@ -15,6 +14,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'memory_mapping.c',
+  'memory.c',
   'physmem.c',
   'qdev-monitor.c',
   'qtest.c',
-- 
2.39.5


