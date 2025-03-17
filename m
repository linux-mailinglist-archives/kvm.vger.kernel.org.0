Return-Path: <kvm+bounces-41302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14CA9A65CC3
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:36:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 077E73BBB5C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9831F7904;
	Mon, 17 Mar 2025 18:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RyR2CbGm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BF11F4C8C
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236484; cv=none; b=SVGJVY5gmjl724+o3Z7B4w/Od0gtnxqSKAKSJJyDaMME4VKYfJ76dQjgXOsNeZCHDfE4idos/ZOrnUoxfLX9finIYgUwjsVvMDHPd3KF7WXVtVrlY7M9fWfjeCnRhoc4Iodn2kQ964NJk+IGXS80TTqp55b3MbJpbESmV9CEJqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236484; c=relaxed/simple;
	bh=HWCRrm0GaxX14ykibana2jy+mNovavf3Va2YjCViNUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FGyd0ANrLhs9AbD+InBfvrIw5M8kuHsqAppGa2ogT2CJtw0e69asXkp0nk6Ds2tDw06a2chR4lGSS8qoDq/i5EqnTQDFRBODQsru05bPE0gUvoykdD38d/pi5HsOKKtK3/Q5P+PQtGNp3fB206aZYcgd6kvsxixJMptg85t+e+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RyR2CbGm; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-225d66a4839so58053235ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236482; x=1742841282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vI16NHb2tKWbIxjnq/SoVUTdY/Lep770BkCc47k0Rc=;
        b=RyR2CbGmQ4y1axzsN7Wpdj3klb8xF4x+Pfu97FFewsREGj//Zs2d7FSvtP80dHuer1
         n0Z+1L41iEnlAacS+4YK14uhMgYVppHiS/p/QZ3YlcGEcPCqo7warPxLKu6/LPcv3s2o
         wisZzrjln1povajwiT+Cbijthvl5vRQqpntDls5MBAQg5JfFKN0WqGs3H1aNH6kxAGdO
         5zsK3E+J5b1qXuTzLz7pcxJcXiTeLkjFXds5zhcxvsQaCPLca6R8oj35FtEMru2dmlJQ
         RAP12PfhqR0WTKI21LOSR5cCJuUdWf5I2DhQYfBZVH8kzhydgZ2iu1SNHWtlVvbtPu5g
         pKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236482; x=1742841282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vI16NHb2tKWbIxjnq/SoVUTdY/Lep770BkCc47k0Rc=;
        b=o5qBjkywcSPB+FcY8p1wY4KEIpUnnV3tAafykdb9tfdupFAmAGbPnt3ISIixpsE1Jb
         GjQlYGanZUyKQJN+GlNNV1HMvioxDA3iroAwmLZx/dr3ESkidI04QzE/qjxUSlrN+5xc
         FLKHY77HsMardztMEr5GnHsv9AnONz3vDrXOWC/raM9Ucu1vbY7nZGuZ1itAbADkUY+e
         TGR4nJQQi2E6XDX8E3daWsAqYrrCB8doCjgIQ12VMLuUvw33BxG7xwSXaOq60icxu3LJ
         wm/7P7Muvg0sMG25Q8uB3ihRM67XIkGmYUn9qq9XoaubTPJp20cK8irOkV4TpKGX21gZ
         VODg==
X-Forwarded-Encrypted: i=1; AJvYcCWY3sv5JIJniNyvLourNEXfIKkjCvv1mvNUiEBIAW1MPYfALFp8HfsJXID6+IRbkAJzk4o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc/LQihjAxj7Eex9G4vQBIut5fESYHOAJKXCuNUzxfk2ljoxJk
	UKYgvhZdNd8SBfd65GK9TsdOHH2GDPj4EpVhESVlI+1LQdUmynPrAuOV1YavYJ8=
X-Gm-Gg: ASbGncu1iox8X0DGaFQv8jcfoCcVw60HstQsjkL9dpLsnVYAphxEtlSvLta2ZhDVhde
	9omvv3QX76QKbxUsYjD2+JBGkGtujJqaXpX60mn6SjOefrT9/qDzguO+9AcRyoJRGimHD9x5ni6
	v1CHkNrPJL/ieOFn0aSHkTUOihxf5Ax2BYNCRYT84igSIeToLCVWYgiOJ/HL5Pc7l3lMZwSdFeX
	7C5uMlS+41nHH0eOdsj8oO+VuZY4vbxg/yCYXq7fNBsCwDrvZqmloXQSvOv7GgXyEzUo6+J+d4j
	aKygwuj3/u9qe60mYKqD9Y5wSrdUqTpB9dLmGS94zG6DS9u2BNiEKbU=
X-Google-Smtp-Source: AGHT+IHLCVfoMXXafvmlUL+0Gr6I93fx5MjwwlixqoYIvnF6wjRbfJSSJwsXt8s9Rnrm35OOx0JfRQ==
X-Received: by 2002:a05:6a00:a15:b0:736:9f2e:1357 with SMTP id d2e1a72fcca58-737578016a8mr692906b3a.12.1742236481805;
        Mon, 17 Mar 2025 11:34:41 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:41 -0700 (PDT)
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
Subject: [PATCH v6 15/18] include/exec/memory: extract devend_big_endian from devend_memop
Date: Mon, 17 Mar 2025 11:34:14 -0700
Message-Id: <20250317183417.285700-16-pierrick.bouvier@linaro.org>
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

we'll use it in system/memory.c.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 069021ac3ff..70177304a92 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -3138,16 +3138,22 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
 MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
                               uint8_t c, hwaddr len, MemTxAttrs attrs);
 
-/* enum device_endian to MemOp.  */
-static inline MemOp devend_memop(enum device_endian end)
+/* returns true if end is big endian. */
+static inline bool devend_big_endian(enum device_endian end)
 {
     QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
                       DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
 
-    bool big_endian = (end == DEVICE_NATIVE_ENDIAN
-                       ? target_words_bigendian()
-                       : end == DEVICE_BIG_ENDIAN);
-    return big_endian ? MO_BE : MO_LE;
+    if (end == DEVICE_NATIVE_ENDIAN) {
+        return target_words_bigendian();
+    }
+    return end == DEVICE_BIG_ENDIAN;
+}
+
+/* enum device_endian to MemOp.  */
+static inline MemOp devend_memop(enum device_endian end)
+{
+    return devend_big_endian(end) ? MO_BE : MO_LE;
 }
 
 /*
-- 
2.39.5


