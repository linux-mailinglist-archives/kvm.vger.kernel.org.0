Return-Path: <kvm+bounces-40547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC18A58B53
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B20A188BBAB
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C741C5486;
	Mon, 10 Mar 2025 04:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HU1sJfTg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A951BDA97
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582733; cv=none; b=dCA43uNTnPSp7V7J6GVXgNZW1rrC+5unvKz+znqdws2YHrUXvyr2QztcZG8xZA5FbykwGw+UaYk423Wn4tVUleK3CBvTLKoShebEz3C4bEmqN/6n9b2uwE/faxwbDeh1YMpHTDWt735Ac/FvoMoQ5qAwyf1egOP5jzMcvo4mdhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582733; c=relaxed/simple;
	bh=cdnYDBL7N1B+lxfili+CtgXi7Pm9oJ6ed1wAbTkIZrc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uvI8AOtnj69kZBRXO0AbuQ2YXon+EHofbuTxpkq9feYIFedwESJ6IlhC/N67kbF8VxL3Hxtxv7Py78CQ9Q6LsKdTlbJNmub4RGD5Gg+dbfwEk5FP6dzpQ6Zz8938wZ1+w5sFIDg5n0FDItusnLSxM8KltEylXCgz8b3RBNJsl6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HU1sJfTg; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22409077c06so47317535ad.1
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582731; x=1742187531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1JZyw573LWlQgbC9bGnVcpJUmDARxtxiYGI4BMcj5vE=;
        b=HU1sJfTgCwmppd8nzkMWpMpLoKSV6D/F+cnCNYe+Q6/SJO/ytyjtAMjq8QkQgttFM9
         TPqENWAGYO/mTPJ5rv7pk9FIunnuuzIgGFtR6DeKACkD2/kU8d5rDjyH1pUWIR3clnAg
         D4V+paa4nCTiy+y+90ysXtzAy9x813KkIBgNkFnMQr5rserIotehxkksxdxcbcGWvjBC
         5GrypAXNbeuJN+IorRN6UJNZsfOGRjD+7fkl/MxVxPGKE5zdEjPEJMKlSoKW0oJzTvgB
         Dcj8eBsN4/uEMnp/jfVfOVQCheyRLwco+trYNJItVjLHFszVZQ1nuihvGrvICziRhdv0
         /1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582731; x=1742187531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1JZyw573LWlQgbC9bGnVcpJUmDARxtxiYGI4BMcj5vE=;
        b=h5Xb1awi1eBFcNbs/Mc3av+gI5Yyws5J18xzRPieif0D7uFwj2JNlp4fnKFc2MO8vb
         Az6eF8v5thmvcQEwy+jLbImXlj2Ugf/y6HQUpWW70JllQQn/wZXo5ocsPVupTw2Q7sr+
         v2L6/+SckcLZ/4x15m2iJ1gZUF4+TIaAnZhJOI2L99EsryLM9ropiYmjWXbtIxPK9uRH
         WJ6MrT3vZkgm83waF8ilSuWTMfBKGkM2M1CG7Cb+88iF/s3OPJ0d8VSfQwC7nySyJ6hU
         jR6lRs+YmEDp1NmMvIepEgsHLEL0mlBbLQvVBKJC3cSHMWWMzWkSO2V5eCdHxSDnGI+8
         7+Cw==
X-Forwarded-Encrypted: i=1; AJvYcCVIwLQx/+syx03ouKF5IhPgauydEFCmB2OmtpSu80vQRTsEaq2ql1oPNEWrNGM1MVqDbHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRCaM2T8XIrzrNA3YvG5+HiJcifBnadi6mg4tGVAH8dBTOiyHj
	hNiezMdtg2bj5rvS+2ICaqGcoeV16zwMkytrK8IRRawsIcBPZ+mrRcw6Ygz2qKI=
X-Gm-Gg: ASbGncur2kHFbEPfo9c1bXkvw+pzIFkWICzniOWpBPEWckv0N/dQc/LP8h3IhXNDsFq
	sXVMgNiThJ5sl7KNVfMhdpeF8Ou1r2JV8es84kkS1E9Tn+93M8TZIslWDHYB5V09AmMHPJdt6pG
	xiQ1w786UZsdN8qRK4J98/xtHBxM8Ij3ipiTrhTTeT6ef1GgvmbwPY/IY1fCUIct6oOb22nxMQp
	M0WmN5+jq4NwC6ErlRnvC3nfB/EpZoWlnGps9A8kTP2olXIi2ITRPXiHpHmZak5QoLkeyLYSW+g
	VYEwcnwsULWzVSqFu/pZzTHILxaLf4RV1TWtoNo8/JGi
X-Google-Smtp-Source: AGHT+IHsrTctZA7T98GoAjZcAG6E707cPIOSM6QcsZhsVvq9UPUg2kUQ9eJxgIpK7zPxh80fLwzPDw==
X-Received: by 2002:a17:902:f644:b0:224:76f:9e45 with SMTP id d9443c01a7336-22428a8c6femr219904905ad.21.1741582731096;
        Sun, 09 Mar 2025 21:58:51 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:58:50 -0700 (PDT)
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
Subject: [PATCH 01/16] exec/memory_ldst: extract memory_ldst declarations from cpu-all.h
Date: Sun,  9 Mar 2025 21:58:27 -0700
Message-Id: <20250310045842.2650784-2-pierrick.bouvier@linaro.org>
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

They are now accessible through exec/memory.h instead, and we make sure
all variants are available for common or target dependent code.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h         | 12 ------------
 include/exec/memory_ldst.h.inc | 13 +++++--------
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 8cd6c00cf89..17ea82518a0 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -69,18 +69,6 @@
 
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
index 92ad74e9560..74519a88de0 100644
--- a/include/exec/memory_ldst.h.inc
+++ b/include/exec/memory_ldst.h.inc
@@ -19,7 +19,8 @@
  * License along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifdef TARGET_ENDIANNESS
+uint8_t glue(address_space_ldub, SUFFIX)(ARG1_DECL,
+    hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
 uint16_t glue(address_space_lduw, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
 uint32_t glue(address_space_ldl, SUFFIX)(ARG1_DECL,
@@ -28,15 +29,15 @@ uint64_t glue(address_space_ldq, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stl_notdirty, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result);
+void glue(address_space_stb, SUFFIX)(ARG1_DECL,
+    hwaddr addr, uint8_t val, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stw, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint16_t val, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stl, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stq, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
-#else
-uint8_t glue(address_space_ldub, SUFFIX)(ARG1_DECL,
-    hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
+
 uint16_t glue(address_space_lduw_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
 uint16_t glue(address_space_lduw_be, SUFFIX)(ARG1_DECL,
@@ -49,8 +50,6 @@ uint64_t glue(address_space_ldq_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
 uint64_t glue(address_space_ldq_be, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-void glue(address_space_stb, SUFFIX)(ARG1_DECL,
-    hwaddr addr, uint8_t val, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stw_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint16_t val, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stw_be, SUFFIX)(ARG1_DECL,
@@ -63,9 +62,7 @@ void glue(address_space_stq_le, SUFFIX)(ARG1_DECL,
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


