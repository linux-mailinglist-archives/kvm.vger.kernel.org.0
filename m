Return-Path: <kvm+bounces-41090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B129A617BC
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AFFB188B5F3
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A63AE2046BB;
	Fri, 14 Mar 2025 17:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cHy0kKIA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBBC204696
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973510; cv=none; b=iI89O5kpHA5n99MGbXq+LpVqzfmhT/A+4crgkq4G2fqPGqDs85Zlgz8lTV+6+GK2yeuqhxU8QbYw/cHXFO89234hxNfDnK4H9HvvyIq1epCg0FFgSXJAjM0rpSJh2r0Jy9TrUJ4/tMgz6lRhCMIlVysuS+duJRPjR4K3RLMNHMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973510; c=relaxed/simple;
	bh=oqW9tTQslkYwWgYQ4FVxpgiaLvEuigwHwZLhfUQTCic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gxqzvjyztYN7rQ/PUBEXrrLptv8geBsOiOpxkSIho9Z6b8UQrakma8ZledMhL6TeKTHfwKHnbSiPuiRLJV2+lZqnpoP8Oh3YfsYRo+EdzYqAcoCNTByX3zaQdstP5Kx8DUI0HmqDa/SyyBf6zmvhp7fodE3/GKs/1Ij166Go36A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cHy0kKIA; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22580c9ee0aso45154545ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973508; x=1742578308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcP4MFj0H7Fu3AxOxTbJlPG2KgbdJwiBtz5sSPdKZDU=;
        b=cHy0kKIAe9Th4JpMd7/h4oOer4cwnArNfLxjbFGw4dM5jHeJ6H1T5W67tycetDQ7aP
         qQpbCWLTG/dMAGvXQJ8/uXjUOhTD7KKJiQ52OYEmuDLHEUG5Gbp32fF1EgyZedL3NZiz
         xk9viX0PmimPRdaIU/CANH0tvSVR1JvNqdCLdopk0Sq7MrzxLUKCevYumUYYCyH1pYsh
         99XcuOb+QhYDcm/+OXt4m1W1vRJUt5rGTJ1yQ76/DhXpGtdOzfZHk2/ie15x63OnQWTa
         PG2L+fwdB84F9MnVnazyoLjxz5UJR66Y29DyxXjI9eoxteKSP0H7xWeyv6lpnUKYo52Q
         GEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973508; x=1742578308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcP4MFj0H7Fu3AxOxTbJlPG2KgbdJwiBtz5sSPdKZDU=;
        b=cXU866YGBo+EpYYf5vo14E2Q6vEu8hUJp1hvXCPDTgHm3EfiffdR6nQ+0QVu9w70hd
         s/FdVjfdvsdolHSkmdTDcXEsgRN9/yjVcOy+GSr+h3V7h5DvwJv+jHgn6jDjHK/K7weD
         Znp/h3l0LCBJ1/aq6R4cFsuhbrOKuwensqb3B0lkaCZYgA/ASTCyL2i0BwGyCMzshxxR
         p4sRY04YubpwEgg8EeromWTws5bnqynn5axS4IoTReqzGSjVOs4i9j7JEslan1JqVh9H
         AWADMw3BNOcz7+8AzqhXefBStOI5hHY0dvDbkIRYFqRfGiDCXB5gW1RG6ozm0uvWVxmk
         0Hpw==
X-Forwarded-Encrypted: i=1; AJvYcCUCXF3lep5jQ02Z43+n8LsWCKNkBcGvuQCM4o+bOpDWYEYLtZ/8EpE7v51u8dndJXJVoz0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXxu2DMWeA5Oc7bVhW7o8BSjOxssavQlsWCaaPFschivNIxoIY
	3P03hGPQ2AbYwF2XRw+FHiEzYDHtXt+YbntTIar7U1q32s/bJNHpoXZGLqXSODQ=
X-Gm-Gg: ASbGncvviu2zgAlSSazdKio8I9txbcSXGFTnEbUIRCzlEM/BvvHpBt5zfob9fU7Vj+K
	8XBSTGQBy88RsJLfBYJM2hvXMhP7z/dGhp1rLm5GKg7DXJCo26hYJCQGc66Ld86/x7BxMSeMckG
	pGHvkbErHozeQn6KdpbZWwl2jyAFkBB8im7d5LOtxHkZxdC7CWTUgM4u/jOFAdiywj9HHwNQ8rc
	U0v7b2aJ4Y0vGTUW1WjZ/fZgESAiSRExkt0B/NkZ85l4Ex+0/QSzCMR9HPwuSwJ8a1RykRaAjqK
	WrlWkaPfm9uPvd761Epku5XoJnY0xC3LqRHOb2mzANFO
X-Google-Smtp-Source: AGHT+IEybdH1a4UlSgUtF+/hwXdxnavqEZfmFC1l+XuioTIMcBmIgOmIQCQoptJbICxTDzesMl+Yag==
X-Received: by 2002:a05:6a00:a1f:b0:732:5164:3cc with SMTP id d2e1a72fcca58-737223e7399mr3832395b3a.19.1741973508455;
        Fri, 14 Mar 2025 10:31:48 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:48 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 03/17] exec/memory_ldst: extract memory_ldst declarations from cpu-all.h
Date: Fri, 14 Mar 2025 10:31:25 -0700
Message-Id: <20250314173139.2122904-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
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


