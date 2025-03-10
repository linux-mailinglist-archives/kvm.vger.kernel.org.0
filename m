Return-Path: <kvm+bounces-40561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C1CA58B67
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3A63188C02F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7AFD1D7E5B;
	Mon, 10 Mar 2025 04:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sGGQ/KVn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7193D1D63D0
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582749; cv=none; b=YaQMLdB011HJtKxaw1aW4GjQReP7fIpAJtkHVvqf/6LKx2QHOPOKGj/SVbdtdCblliRvtcAcN1yW29Rm/WuL9HcDoVfP08iXRqTQXhYOMCj6cwcDheEYCtg0aNl7b/D+qFH5LnOEuB3ZncNV6v54w3WcFv2o0HK+F+K4/pYGo+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582749; c=relaxed/simple;
	bh=r/LXUtaTRicvesGetwdLYB7XQ6dbrs5IufDJXlrT/RE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cEDfJor2TyGpgFrzpEZp6/xn5U0G62mTW0nyf9vxWdPiJ0ts5usnF4s1zgRMFY69q4hmBcSbtbX145jXIRYxiPxw6LTlDsmWr1wG9prDJvUbr+V/mXdTGLC3SWkXFsmUhrd+mJpTgKJNvXnIlzN1SHJvklHEqcW28uFycgdtR7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sGGQ/KVn; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224341bbc1dso35375235ad.3
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582748; x=1742187548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ca5XHIZHBD7tCKLnU5sMNG3rMchaOW2xdNGbrtAeUuA=;
        b=sGGQ/KVn8V4tJD47CgdIgKm2uNc4qG05QvrxCSjP0OwyL52KQKxtOn2DacjC4nIRbN
         UNhkprGO46tJ99c7PzgrhYDaSLATA1O+IrUWihDBkqiFbr8BQLFwEo2k05hjxnyxXCX7
         T2xXwVb+Q79r82Mg82nAUxCf1GYIn7JYZMmSRZPHjp/SROSujGZ9K6dB8lL2KBVrB4V/
         CnbPJmP2mZFU+/v9TWr1Pum6iOsHH/dMGsSo2eKgw7yvRrb6Ps+zRUPionLdgebJxQxp
         KgjOYkWGgewUZuPizmvqQQ3CO97Uw6hp8V9YDc31ok5cG2RmOlzJIgMn0rfXqy66FyIR
         qFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582748; x=1742187548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ca5XHIZHBD7tCKLnU5sMNG3rMchaOW2xdNGbrtAeUuA=;
        b=n/1IKaAZfhyFAwJMc4nLJDQ3dSE2mqTU6FhB8JLBkNRuoTXtqmphC1Jlg19/yTe/tZ
         ABJXT9uLRfJWNrSaYY+QfuoStoyIVVTniMkQOJB4wDgHBznwajlAK0aq1cDpjD79UjwA
         7rRXGvgruWLPXZml4Xz6bJv79/yX5rIhMbsHe8iBia/6by3Rxy0KTAZQoCxqdzUV+BPH
         DMYnWJ45wvuIqD4sFMAMey5jlOL+IDjzp6iPmfHR4UXdzQ1qisybbX5FuCR0980npy5g
         ebO+AChl5Yj/GJNU+hxuE3Sksvu+m587RH/q9wLFe/STcQYCGXFZ3Q1JIWvxRRe2cOa1
         U3EQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQT1PlltQzeHz86cvfodtyV9aB6OEfLGHiYmIB9GTXokEzP/UdTHplYaD9GF1AsG/6+RQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmegMw+lHuHm9V5HN2x6h7func6CPbnCADynTkah20asIizNcX
	O1kIdQs7Ou6zrHyZSBdlSLUzNS0XIHQ8Qg6l7uD8QLz1sQB+Vlnf0fZ8xbDtAfk=
X-Gm-Gg: ASbGncuoso2BpMPJ0QJMcIrKSseditrQSlbPm03SBUHWvFmfJShEHZyB95szSBq6SAN
	lPLa6BHyVTtSxkUM9LYd+gbdvHZspWHyn1otcfn5Agat3O4JHhONFfa0xgRCzfcuP6PjLMkaqjZ
	agMIbkOKDdMDsOZnJkOkf1Udk7C5nWnuDUmPCFHEH33JCWdtFRz8ItzRDixkFwt2Ymcbl4jF3GH
	PM3TMYiijvBcMqh6NChaMw5diFlmf20IZ6OphvU7Mhl8zLkUCwGil0goU12+hl8P50h3pTJVuy4
	610eX4avJ91if6L6Df4oHYzft2WrguBDCT8kiSa8ymiP
X-Google-Smtp-Source: AGHT+IHOxR50kjFp3DQk9gSBOkNND2h3Drx9YEHpcRm5j+6hJ+poi1niGnSE9oReFoFKVWczKyJ1NQ==
X-Received: by 2002:a05:6a00:2315:b0:730:7600:aeab with SMTP id d2e1a72fcca58-736aa9fea71mr18336179b3a.13.1741582748003;
        Sun, 09 Mar 2025 21:59:08 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:59:07 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 15/16] system/memory: make compilation unit common
Date: Sun,  9 Mar 2025 21:58:41 -0700
Message-Id: <20250310045842.2650784-16-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 system/memory.c    | 22 +++++++++++++++-------
 system/meson.build |  2 +-
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/system/memory.c b/system/memory.c
index 4c829793a0a..b401be8b5f1 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -355,11 +355,11 @@ static void flatview_simplify(FlatView *view)
 
 static bool memory_region_big_endian(MemoryRegion *mr)
 {
-#if TARGET_BIG_ENDIAN
-    return mr->ops->endianness != DEVICE_LITTLE_ENDIAN;
-#else
-    return mr->ops->endianness == DEVICE_BIG_ENDIAN;
-#endif
+    if (target_words_bigendian()) {
+        return mr->ops->endianness != DEVICE_LITTLE_ENDIAN;
+    } else {
+        return mr->ops->endianness == DEVICE_BIG_ENDIAN;
+    }
 }
 
 static void adjust_endianness(MemoryRegion *mr, uint64_t *data, MemOp op)
@@ -2584,7 +2584,11 @@ void memory_region_add_eventfd(MemoryRegion *mr,
     unsigned i;
 
     if (size) {
-        adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_TE);
+        if (target_words_bigendian()) {
+            adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_BE);
+        } else {
+            adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_LE);
+        }
     }
     memory_region_transaction_begin();
     for (i = 0; i < mr->ioeventfd_nb; ++i) {
@@ -2619,7 +2623,11 @@ void memory_region_del_eventfd(MemoryRegion *mr,
     unsigned i;
 
     if (size) {
-        adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_TE);
+        if (target_words_bigendian()) {
+            adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_BE);
+        } else {
+            adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_LE);
+        }
     }
     memory_region_transaction_begin();
     for (i = 0; i < mr->ioeventfd_nb; ++i) {
diff --git a/system/meson.build b/system/meson.build
index 9d0b0122e54..881cb2736fe 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -1,7 +1,6 @@
 specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
   'ioport.c',
-  'memory.c',
 )])
 
 system_ss.add(files(
@@ -14,6 +13,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'memory_mapping.c',
+  'memory.c',
   'physmem.c',
   'qdev-monitor.c',
   'qtest.c',
-- 
2.39.5


