Return-Path: <kvm+bounces-40736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 089C6A5B7DE
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:10:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AD63173A52
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054E0221DA5;
	Tue, 11 Mar 2025 04:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EggGCey/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73DF1EB9E5
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666158; cv=none; b=jcaIHH7MWQ53LzX04VX7USJLWyo7MQNrExGHpFIAkUGUJ6EMjixx95+y1L01JpRjfafUfD2FvIVdHaJqOmI7R7lBsikuCVn9gwdg7+yuACdPI9/jN331tEUy4E8RXdIEE8ySv/lh+ekdmflyY6zJYFu7mKgpdk9ZudaNmXgQ63s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666158; c=relaxed/simple;
	bh=V7caGdwpPvVcMTz4Ryr0C3nFSPGFRfnlil4NUl3Djzk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fm602FmOvm5Y+tpDF2XavCMmpAsvKjm7B3F8FWbSig7oeJM/15tvm8EzbWEAH5wiH2s2oVNopzJ2EhnIaSkqryDzsdiqWcOT4AEzJ4OSs8D+1S7kKjVtEwoqqhgb/19mwjx9ActY9itNwP+RX7TGGIhh6hy84m004MhDWMy+pHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EggGCey/; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ff4a4f901fso7397719a91.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666154; x=1742270954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3CzVNwffqVfXfk4NE2Z+/4EFEG8FprDV2OFnBt+VLQ=;
        b=EggGCey/UZKA2NU5GcU6KXeOqcoi/hTxo2/RkgVIpub5vzvQXAru99l2v2PlJgBXIb
         pYsA+HS5rQPqUokJJy4pzm5ywhSeF+BRhuSMSs3XQXyh1bPtAb/TgXoZO05yI3Cg+5um
         u6k+75jF2zIM60BZevJTPR/J5JGA00cRi0+B/pmBBT4S7mmPq4K2mSH46Cao7gUFtCa/
         0kaYZj2EjKA4Q465AYXmP/aYVjFeg6laf4qvqsrwDZJmOtuL6UqYQHtzZYX8aKrxIRMt
         2KxMn+v6z8CZp6ULnXrtk2YZrdVMCdn3DqhIQSf3cq1go9BXvmOGDsiao2rNVyX6wHtZ
         qoCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666154; x=1742270954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v3CzVNwffqVfXfk4NE2Z+/4EFEG8FprDV2OFnBt+VLQ=;
        b=hQEd796zfLIuuzAirl+/+LI78tn1j96nrxY6SreHdagAS0vVr2wUo0kZJJS+r1uX7D
         DFW1iGhZ3nOgHJMopjWCPDj8TJNCfEsuCHwqiGHmNFmq686h1abgyd2xB8h6jGijKKbU
         lRuZMTqlMvnKCMny/FrzWGEUZ+VcVLazHMflZftsSERgvz1oUlr4rOmbLg3FZsan6hrs
         +G2Aab3QQJ46/E3/Rkg4JX95NxP2Fe4/N5+Om1eXrWDTBkctViB4ALxwdvOwq1i4DaYO
         GknKMSBBkM0xZ0JBp5DK61rFUo8P978FHaZlwbBAuMubDzgQEoayt4xNjl3YzqmeGA7L
         ZAJw==
X-Forwarded-Encrypted: i=1; AJvYcCX68AwjgE4EE7ZbChZiLBws8MHaHVIYtfc89Qct6kpFKwyx49U9M4tPPz3pewo6tMliVfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxELqttC5ozbMxCS/wYuExDtaQ3E26S6N8vc4EgV5iAauKsYOMf
	SWa5Oq2E4OXjO2OiAykqL7m3iGENKhGPDeOkyOfNzVUT29q5884wL1JZ++HlODo=
X-Gm-Gg: ASbGncuTEzclp+iReZZXkEFR5hBrOECBul0Sn1RqMcOFfaBeaaiYmdUNvAUK9aj9VZp
	tOWwSMgSZ+7LTP7MXSgMIgs9FmvzesUFPPr4BUURIfCHW7I3V62AB4Sl4LkMnJKkba7RmghWWwK
	KC8TRMCE45D4qtMsHfRWMFfiqcJuR7XZlD6qHxtlN487X+Hk8YY+CKgza9iFHJxXNtCRm1RU4dy
	TKi9QswHlJmUWePi3BqG1TPjJW0bB7G8Jz4PlSWYOnNIN8Az5EpXS+1k2pny3nY3kP776fY2FsR
	QLvI6I0mxQwVObRo6HfIMzC+b4WjoUd/IiV/WnUpo8fi
X-Google-Smtp-Source: AGHT+IFvXFjaslvNGXJjltHn8NjSjDrKRDjnKt7uWKtRausP/KT3hgu5XPa6ctrl8hlKzv3rih4ocw==
X-Received: by 2002:a05:6a20:c6c1:b0:1f5:59e5:8ad2 with SMTP id adf61e73a8af0-1f58cb40fa8mr3753307637.24.1741666153903;
        Mon, 10 Mar 2025 21:09:13 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:13 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 15/16] system/memory: make compilation unit common
Date: Mon, 10 Mar 2025 21:08:37 -0700
Message-Id: <20250311040838.3937136-16-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


