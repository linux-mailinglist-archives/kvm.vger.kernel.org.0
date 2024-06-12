Return-Path: <kvm+bounces-19458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6495690558E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 107AC281229
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6710A17FAA5;
	Wed, 12 Jun 2024 14:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k9B3Av6H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB0617E8F6
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203558; cv=none; b=R9RNpJVRFdi8Y3WluA9ox8j+41GQL1nfOUNu1Dt5oy6oyKKxvTXwWJE+UniwjvDB7APaZ9UK0vRy7siXuy2hrOYoJxpry1HC1GGWofCKH2ZvJuBBVx7LX5Idpx9FGDSWmZCU6KC03775p+cVQ+wspLVm3lQi2K81KJkusQIq8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203558; c=relaxed/simple;
	bh=yqVIQaYfrIrHTNK3OkFmaV+HIjIKWjhtnBb+BAqytCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H7p9p+y3HEJ7O7NCTcwbRBeF/rYGhpsnNwkJE3KnsEASMD3WRJPC9jdnoiSTa7enVbWqb7TfbC1WEbR2ts9Fc+9iQqgNm19vdQH08g4N9YfbB8XnlAtzrHVZKZj+96fkQUMZ+rrReyTN0SruTfj/E7NgHnJMy6EBkSCL+/y84lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k9B3Av6H; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a6269885572so177179966b.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203555; x=1718808355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txPdngU7ZvAHKIsUQF4Or85ok4oAkjD81XgTYTjxzhA=;
        b=k9B3Av6Hu6DttWSjFkqx8eQo2orNsEfp6LcLgvUoi38kR77BcgrG3KBt7BuvyO86Yw
         4BQgo0BPqilZa7GmumE51pEZNoJ/ZV/Mpz8iVQbzIwpRw/pxdDybyilzgzY4C+tzRv6G
         WaGwUBT1ZW0Rc6Y5xNeONtOxkBCPxNv29lY1hRoW6qxOs9Uv2fMMx2kS2bbSzTScGqQV
         I6mcuHFVNAEHyrcgr/eST+DLkXDuWTxgAPZeHghU4CBzpa+VrK5K94AWACZAZxMnvJE0
         UA4ulSc+T6+z9IMe246F9Wv/50DFWopMA5cLRkV2m25BpAKywhNtD2EJijX26K00SFeB
         it7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203555; x=1718808355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=txPdngU7ZvAHKIsUQF4Or85ok4oAkjD81XgTYTjxzhA=;
        b=H3sImt2pWbjFrw3hXOOYLi8dcdIgH2VAzHF8B+P4adfn9yNOn2MoefMcT6adv8J7Hi
         gSnrtUMMqxDgTp4eExcGH9FAVEH1/jAQbxN+ihggYFPQuH0DaF9M7yFBkDT9G2uWgKkz
         YUuA+os76gDkQB7O9+MY2/2cVwZDbpIdLJ2mycNwDQiJ91c3NyGMG5OwiYEmVmi3zf07
         mBkcPksjEinrFTG7HqoASu4xEJG0cMnFYH+A9eak1HqciUFVVBiY7l3F3YK3hdQhzbXC
         aeaKlvpZZE2qjVwAVfr5nbfK8ouMftVQNxcJljj6y+nwxi8I6oq1nslAH0T6Ueoj/8ai
         jzNA==
X-Gm-Message-State: AOJu0YxGCkH9/b2GQR9Ynd+HFEHTRs6fHLeCzinALiSQ/3a3Qfr4tuWi
	G65mk8ADahp36Z1xr69AUrCtmLO3860yumrQ56oqEZCV2eG6v5wcFPAwTKao
X-Google-Smtp-Source: AGHT+IGtfRMppDEgNRdntb1Mk4m3/ezyjhd5RVMXoPm+oZs2xzoLVjtEDJM6D+wsWb9qoo/5wsklTQ==
X-Received: by 2002:a17:907:1186:b0:a6f:2000:9811 with SMTP id a640c23a62f3a-a6f46800881mr143188266b.13.1718203554848;
        Wed, 12 Jun 2024 07:45:54 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:54 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 07/12] lib/x86: Move xsave helpers to lib/
Date: Wed, 12 Jun 2024 16:45:34 +0200
Message-Id: <20240612144539.16147-8-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240612144539.16147-1-vsntk18@gmail.com>
References: <20240612144539.16147-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

Processing CPUID #VC for AMD SEV-ES requires copying xcr0 into GHCB.
Move the xsave read/write helpers used by xsave testcase to lib/x86
to share as common code.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/processor.h | 8 ++++++++
 x86/xsave.c         | 7 -------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b324cbf0..e85f9e0e 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -477,6 +477,14 @@ static inline uint64_t rdpmc(uint32_t index)
 	return val;
 }

+/* XCR0 related definitions */
+#define XCR_XFEATURE_ENABLED_MASK       0x00000000
+#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
+
+#define XSTATE_FP       0x1
+#define XSTATE_SSE      0x2
+#define XSTATE_YMM      0x4
+
 static inline int xgetbv_safe(u32 index, u64 *result)
 {
 	return rdreg64_safe(".byte 0x0f,0x01,0xd0", index, result);
diff --git a/x86/xsave.c b/x86/xsave.c
index 5d80f245..feb8db28 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -17,13 +17,6 @@ static uint64_t get_supported_xcr0(void)
     return r.a + ((u64)r.d << 32);
 }

-#define XCR_XFEATURE_ENABLED_MASK       0x00000000
-#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
-
-#define XSTATE_FP       0x1
-#define XSTATE_SSE      0x2
-#define XSTATE_YMM      0x4
-
 static void test_xsave(void)
 {
     unsigned long cr4;
--
2.34.1


