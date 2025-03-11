Return-Path: <kvm+bounces-40790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F256DA5D022
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BD633B9EF6
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F403264A65;
	Tue, 11 Mar 2025 19:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oB0K550h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA3A215F49
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723096; cv=none; b=a6Y/ns5uUc5GDasfgwSj8J8p1eATG7bMg6XtV+moKiaodbvgOsj67xpOqVZH30rX0WiuGAOsiaszqR1wiCZqFFObOq6QkwizZjP7bOmcGo2W459Ec6m4/FN0AoKBmlnqsisKdrhCJnwuNhbc+1VqJt9KhKHyR9vMi8PIBfaIIho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723096; c=relaxed/simple;
	bh=oqW9tTQslkYwWgYQ4FVxpgiaLvEuigwHwZLhfUQTCic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=idGFgmzk1Zj1WxpGEKMHAQatLKyjYBFr1wGCUkb9lhQEREvJBU6J21d3qrGUUeGaqPrWI8DJ6PPJ7WDQy/gATVQb/mQHtH4Q+xKq2KVhcpW9QWgs4vNp2ukKxltH6HjCOkvhY5FAtvSDXHxf6+QI0VJJhcijfZsH8nejPEsHXf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oB0K550h; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-224341bbc1dso80068595ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723094; x=1742327894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcP4MFj0H7Fu3AxOxTbJlPG2KgbdJwiBtz5sSPdKZDU=;
        b=oB0K550hfPujYi1eYsGJTOyjW/V4WqEJXF9MiNdiy6blVBqSpiEmb6lEwSY/h7gLHE
         M3dnPa3SuI6Bjmy3Lnwhr1Az38Jw1IToEs1DbHJt3gUMX3rOmQM4fzT5Sr2mSkPG/sx2
         +hg5X8zdlMcdA7Uimqo0no0WyiEbkNQtksvXr6tiQnOdrRCr4IS0hJ5nsp/35zbmsXNx
         TJeH4m923CO/7zg5wolb62AVhVQk0Ed+jeuKQU/6Kizkjm0K60S+8FfJo1X6GBmE7Kqq
         YMzn//1veh796lcSmlLM20x4pjSfk7pyFARPE2aRL/ILbdC8WAmdapJhL04FkpgeAQ2o
         wDkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723094; x=1742327894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcP4MFj0H7Fu3AxOxTbJlPG2KgbdJwiBtz5sSPdKZDU=;
        b=KMqDk+suCobul7mR6IfHB3eC1Q2IfWL3q6sVFY67zGJibckxSFj7UVSRFGe4qZ06pg
         1IAMlwiJsGAinT6sUcaUEHSX1hBTm7nJkZsFIp30t4UIkSaOH7Zg8LErXHqUqBmPgn7k
         KyDSJXYb1l++8IwXwn1AbLF2dA86ufJwk5x1OflEa5P4O1Q0Z8T9RGQnHf3xJ4pT/W/L
         BG6brlIkSfdbqs7haXfo0M/sdKK6hKfEJhbS7l9G0hr2QUF/cf5AebfSKWZkEpV/RLhY
         6MIHxtJ+X2dlwTwcIR4Qxhi/xMuNiXTV0fhGk8x5Si5QbjVjCIeMC/oTztVrT/vwabH3
         AixQ==
X-Forwarded-Encrypted: i=1; AJvYcCXE+JMrqcvBO0UiZb2nuAozpxRpWI2SVt7tx82PoOAElbBmrw3v/L3htO5jSssty/PclyA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxodps3e02AWb1idN9ykAIwSB3vzngxNa5m/ECZN7qXRjStuvMc
	UxhkZn6E80wzKOeBEGauP4GuRchOV0NFuePTLGfhpFavPjj826/p5Z4Ae5Gl/n4=
X-Gm-Gg: ASbGncuMFE6o3Hv7G50pYDW6boMXsHHIy6BmI6xFLgkYV64PSoZb00cTS3cal5erLDM
	QaI2UVK79eagJviRnrHplcOZigWUvHnmQfX9KRx+8qy24iOrSe70ClV4+0RwTZlSkiWwJrvu/8n
	ycksyC9bhziE8Dzw8GoE/K4G5cy1VLntkOXBA7JDs07qby7yQhl2Rw7+s25K3Gj42fqp6ySi07f
	9H84oZyiwGuDHrrxfJXKMH9Py8IxytdTdoQqTTgCcdBCx/n0nDh2b3+b8x/iSgD7C6EtqhAxGap
	EmaghOMZVsMRLmeyW+Ifdm1/h10OJkmNDDCihOv+qktI
X-Google-Smtp-Source: AGHT+IHtn3wjueX80hXlhR3WWJLzlWQ/GjOadBaAC9ISUpU84/t/abdjw/+6bEkcmiHY0rapbw+ALA==
X-Received: by 2002:a05:6a00:189b:b0:736:755b:8317 with SMTP id d2e1a72fcca58-736eb8a15femr7017121b3a.21.1741723094173;
        Tue, 11 Mar 2025 12:58:14 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:13 -0700 (PDT)
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
Subject: [PATCH v3 03/17] exec/memory_ldst: extract memory_ldst declarations from cpu-all.h
Date: Tue, 11 Mar 2025 12:57:49 -0700
Message-Id: <20250311195803.4115788-4-pierrick.bouvier@linaro.org>
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

They are now accessible through exec/memory.h instead, and we make sure
all variants are available for common or target dependent code.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h         | 12 ------------
 include/exec/memory_ldst.h.inc |  4 ----
 2 files changed, 16 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index e56c064d46f..0e8205818a4 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -44,18 +44,6 @@
 
 #include "exec/hwaddr.h"
 
-#define SUFFIX
-#define ARG1         as
-#define ARG1_DECL    AddressSpace *as
-#define TARGET_ENDIANNESS
-#include "exec/memory_ldst.h.inc"
-
-#define SUFFIX       _cached_slow
-#define ARG1         cache
-#define ARG1_DECL    MemoryRegionCache *cache
-#define TARGET_ENDIANNESS
-#include "exec/memory_ldst.h.inc"
-
 static inline void stl_phys_notdirty(AddressSpace *as, hwaddr addr, uint32_t val)
 {
     address_space_stl_notdirty(as, addr, val,
diff --git a/include/exec/memory_ldst.h.inc b/include/exec/memory_ldst.h.inc
index 92ad74e9560..7270235c600 100644
--- a/include/exec/memory_ldst.h.inc
+++ b/include/exec/memory_ldst.h.inc
@@ -19,7 +19,6 @@
  * License along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifdef TARGET_ENDIANNESS
 uint16_t glue(address_space_lduw, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
 uint32_t glue(address_space_ldl, SUFFIX)(ARG1_DECL,
@@ -34,7 +33,6 @@ void glue(address_space_stl, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stq, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
-#else
 uint8_t glue(address_space_ldub, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
 uint16_t glue(address_space_lduw_le, SUFFIX)(ARG1_DECL,
@@ -63,9 +61,7 @@ void glue(address_space_stq_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stq_be, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
-#endif
 
 #undef ARG1_DECL
 #undef ARG1
 #undef SUFFIX
-#undef TARGET_ENDIANNESS
-- 
2.39.5


