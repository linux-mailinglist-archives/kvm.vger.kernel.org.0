Return-Path: <kvm+bounces-40963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73591A5FC11
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50A523BC087
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F32E2698BE;
	Thu, 13 Mar 2025 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zQ/Yyb9a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0842426A1B3
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883969; cv=none; b=pyjKnQKEEDW1E/nK4aQh7GT6Yti9rqTMUScc4sSAKs9mbeOkhe0ZcULuRFwu5VcEeaUlHwXwFBTiEHBIfzUwtcJs5BpN0KVhpyFrq8/4kwBQoVqRyYA2A33UUCSJYZcgVnDk6YVrbppoOtLsS7L27MzW9XBO4i9VvHCffsAZw3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883969; c=relaxed/simple;
	bh=HWCRrm0GaxX14ykibana2jy+mNovavf3Va2YjCViNUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kHq7OH6GLdJS4+K+HFeGciw6OjqaZJs6/EkkPR9JdQKVR4FgkhP62weY0ODsKxcMWAXD7xrBMJbZsG7Kk6EaZudnW9jKPnhkasfzsc9jkec3MOixBAM+i7bNwdcidSS/xhuDqsVAmh24V5974w1H6DEq7cE75fX5Fp2wM/BlwIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zQ/Yyb9a; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2239aa5da08so24790815ad.3
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883967; x=1742488767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vI16NHb2tKWbIxjnq/SoVUTdY/Lep770BkCc47k0Rc=;
        b=zQ/Yyb9aYXW5/nPezVUSZj9zCsu9NVgJpn3xUvjGNJ9ETS6tpW4hgpfgWtGjn0Ild/
         JcSIVgNmNYIzsDhl+wBlEiHYzR0yn8tg5DZ6/fMGRhpya1HCMrzctH0Bx41nkD6x5XFL
         UitAlxi4A9opiMuEtNmvc8JNFGQsXMulbaHx4Gmho1RRZqquytizYeX323SmhvUw6oNV
         iWIbL72hoIWaReWFj3kkJhUkb2d301ieavyw9/cMnv9j1LS+QJlJ1RmqfLZ6Nj4hv87d
         60AdvNbVQNHFco03LQ3FqzCfA6pa1JVt2LqZM+PyECcgZ/LDsQOM9TfFsZDYQp7JAmo4
         ZDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883967; x=1742488767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vI16NHb2tKWbIxjnq/SoVUTdY/Lep770BkCc47k0Rc=;
        b=J7EHIDzkNLDdwukmwhjAfqCADSJqGKJpfvQIicyF964x79cUKWiI8+H791tv51X+Zk
         t5C41NdLNn4E6qnJBGZkIf9mkXtWLUM9FLM9b6FDB7Xn9CO5E+ns+ErvxiWdRKdF7ltw
         Sy6aDz+EqmJjd/zxfGrXgOuTAg6nv2Htj4ZhBXvj6FPQ8q80cuOAzaLd+0+D5u8QzFxo
         MRiljvzoIbhhWi8NmQXfxS837ONl9xdWcxLY1dErU1xoNvFQ+X5l7L6X+dEeDAUrz63e
         TpVLMdUuyMknwWMIqNney923kabtIJlFR+TF/+4SfdO3i5hGnC3pNQ9YM/L0FeURmMkG
         oDSA==
X-Forwarded-Encrypted: i=1; AJvYcCUltv/LSQnS0FZJafJy1Gaz5b73qEm2fj6KxFm50doVmfzW97HtjK+cIBrcRVYPu3U4zKY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvoCuFTDCiNY0kw2Nao6FIscYJ/pjubHnj0ZRKXOKl1XCS22tF
	gRCvBIMigUiDSeB+4SuB9VbljCr69Vwyvye2aBOm2ALHNrK7jGS+Lft9ROtk56A=
X-Gm-Gg: ASbGncurF7LsZBEE2TjeUsqdSvTdng0aTg3dFliNp7c5dRpAKGvDsZC2+TkiRNJ5uFV
	GacW1KifcQwF4aWANoYYKIZCPm++mB8dMuPnhPtj3D43/DMDkbruBgRTg9RtVqXQSF45cZV6+ln
	D7wlMaRWK+OhfglDeLUri3wefyuQr/SInYbQsT2DGrrdRXGA6lu2T2mS54FXB7lrpPVz29Em2ea
	/keNUY25ORwxiXTnLIO2OjxDUvHTLsdhqcO13ANI7Pm/7LM0kOQBZklPjTKcbOz+unYqJq0U1sy
	THY2RPfznLkqwsUturq0OP5ZJVyw7JsEIpmllw9fPhn+TWo/y0jptdA=
X-Google-Smtp-Source: AGHT+IFcq5bUjsmA5zzk8huR+izs7UMfjfhsI/1Y2larg5eumFEccAwXse4tJs4zAbzQaGCcQS+wlQ==
X-Received: by 2002:a17:902:cecd:b0:220:e924:99dd with SMTP id d9443c01a7336-225dd8b9922mr2731115ad.34.1741883967572;
        Thu, 13 Mar 2025 09:39:27 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:27 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 14/17] include/exec/memory: extract devend_big_endian from devend_memop
Date: Thu, 13 Mar 2025 09:39:00 -0700
Message-Id: <20250313163903.1738581-15-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
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


