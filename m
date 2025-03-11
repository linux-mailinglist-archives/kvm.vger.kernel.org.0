Return-Path: <kvm+bounces-40803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFBFCA5D035
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 693163B9EEF
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFBE26562E;
	Tue, 11 Mar 2025 19:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l2T+da19"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE283265616
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723111; cv=none; b=PgJ79xKbcfcPCTbil3YARwE2CNQKogh/arXyMz8BWAU89hcAOkIxMB9a9jxUOGk9N/QA2uS/sbUhYxLftGK+39z9KVjRrzHHPqyjOlpqkS8GCTp+O7qVTk0Q/ZtITaNnbutEOPd2MJYFgIs7oGHScZ4heIkvpkmFe9gK/tHDzZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723111; c=relaxed/simple;
	bh=O8oGnViPTQead0Ya9bRswKXc6Ql9v2ktguJXe+BaWec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kb3QzOKNeVzDjtCgBugugv/PH1rx1UPggGoLAtHyWDvUeGhwpjj3RQOdCO1Beh5SSPYgDF7OeWRe5ZsZsw0tdbjZZbiEmf3XTzQgZiySxhd62OgpjyEsvpBnfjF3uEnLt/nfoCoI3zOxE8om20Lt8yvD3L4NAXF+J8SKJo6oFqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l2T+da19; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22548a28d0cso26060355ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723109; x=1742327909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z06CcN5pABW+zUVUk9wuBNFYUJo3O9KfWdv+N0a9H8A=;
        b=l2T+da19FDknUsdaR/f64HrxB9g2YRuYQYGWNo+00fopIXKATRMyjFhmmT9GxKeafJ
         zEG1i9AvbiOIuH27n0rndGg/93T7DUluJhhPWjb502flE0AN3DrCNsnCU/FKjFEDg3UD
         nIqgsyIeK1jjdGwidFMegnfa0cWaoskzn8OPh1svPmc1IeBUlI6HTDffsSQrytlu+Lxc
         SpkfGmYP71MPqWCw7/GwnnEyszaTLsZxSlhH+jpCw9b1VwfQmFr2eEeY2Qk2Pocqj25Q
         OTFaFB44+bL8UcNlQaGHGv7GcOiNTulh2MSdpks/7jNigXlBQDzt7wEOwOHEt38+UBX8
         NtJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723109; x=1742327909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z06CcN5pABW+zUVUk9wuBNFYUJo3O9KfWdv+N0a9H8A=;
        b=A5kfE9WJK89jr3LKXxiltwZLyqFW8RXSplY/jji1FflSfjL4qpKCtYh4vs+j9EIB2d
         /8er0LsNuQrKQ/0fff4ZMZ2JGKQYbBJYmheMcxyb/1IhIdNDtEx3ad9qwpPbGcOQCqKS
         1e70BymBHUPveXk9AzFhp+f50cI3YklZaHrBOmohUQr2ZuJXCbP/c9QxMhdVh7Sl1x4r
         dySMbMnmUML1RmbqGSSqTe83nQ5It8XYfBLbqlDv1hpljfaG0O3HlWda5wQfDfCXnF6y
         C1olYz2bXHe/MZ7j1jt6PV2MzJn/NoNhLYagriszBPkPeLwvwqDq8Xw1CJ6WDbWV0Q9a
         7QVw==
X-Forwarded-Encrypted: i=1; AJvYcCU3vyciJkrQEd4YEmY15yYZeel9UAgTOkuBPC+7JYCX+lSIEJ79kdHLXtJjwRY8hGOlBsk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSw30s+9MmyItYBiNH3KvNUnOwImGoS27raC5CP2rsadZyRqGO
	LtVxA+kIXaKG+s0QWWG/7yaXHTAdrsyPY7rgzAR4wYfkbwO/JlYl6WxOzVyXAyQ=
X-Gm-Gg: ASbGncuT/eWM5TqmTXWLNQ7koFz0zye7vMZKNi37zYTFU2JSmUnyk/ORR8aDooMr19K
	obBubNDvKLOMoVwvQGRF90m71YDvbAk5hBqi4LB0iejr/oCyyHdnXqLRuLf9vg9UMcvCysh3dZE
	tbc+EZgY0+ZEZyYUWIQ3PP4FISP8aHu13OH99MwpAxCYiXkR2Bj3eJkD3UkmSjqmy2huiKVnZBC
	j3fTtOjAAPTICtmp/tLxEhM9UbxggI48sX8haII59H2hCxGy3nEunRqyWQ+EZVG9AI1qs6DVTif
	p+/1+gInpS0f6DGE7qq/QCaD+NrCXf1YhbnfHfzW6JMQ
X-Google-Smtp-Source: AGHT+IFWZfAhxvvEDgAAce92ETlma5STi2t3r8z3LElksShqNyxmTswS//w9tvWqHBQDxaqLnsB1Kg==
X-Received: by 2002:a05:6a00:2e17:b0:730:95a6:3761 with SMTP id d2e1a72fcca58-736aa9e745amr30276190b3a.3.1741723109168;
        Tue, 11 Mar 2025 12:58:29 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:28 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 16/17] system/memory: make compilation unit common
Date: Tue, 11 Mar 2025 12:58:02 -0700
Message-Id: <20250311195803.4115788-17-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
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


