Return-Path: <kvm+bounces-40958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6FCA5FC0B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6544A16B3D3
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEC126A0E8;
	Thu, 13 Mar 2025 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UMi1g39B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573E926A0BA
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883963; cv=none; b=PA2Rp9LFZCZTiCmaSfoJnn2tlOKpumZF9cRO8d4Ywwgy2miwDjMOVfdb4+xnwMZVt3vLXJROMnbywW8eVTmN7BBTedJsWUv3OS45jz9wxGR5/OgAusRZI9bOmv3QI1I3RwGy3meG9sGstjCoHSxJrVNLNGFdtB2EQ56ghVvVnX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883963; c=relaxed/simple;
	bh=rOapAhxsucTXmmvj3a2Zy3fKHxQeQMgYCuWijJzB6sI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=neRWE5EQGaMd6M3xOjhvqWcKb0hghQZzPP+0ZPBemWzhs6nrPHVAimI1Vdiq2kn0Al4ye17f3d3ynL0uajkMDgGpDFLQqfWeya1ZJN1OzfW01bKcwYyMhU1ciBcnv+ZFxFpZ7O/iPcmVyKKll/5HVWDthMx3wFHXWof/Az1M85Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UMi1g39B; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22580c9ee0aso23510985ad.2
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883962; x=1742488762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfpTTedni4gUGfvRcfnvXw4xTvY7JO0pNjOjXTZ7pI8=;
        b=UMi1g39BPGahh/khGEsus1BLDD/Sukvv3gZgV/vIlh+WjCYinxPBS5X/x4x2B+PuW8
         MjUjL4tnqMMO7Sf3D/uv9RUwpYU+VHQhlNIIpUINvF6J7/VvpshkLE6O9fBeyRJiG9Pt
         RKdsCn0MZlizzVO9IfsyxYFijnq/NaXIy1W4N8VZqIeNzbMobeHHm7n4V/t1ov9VyFjF
         xTYicQZgoVUGo4OPmXFwKob3GQ8XJ8vImrzhfNRa575F5wMmIPquTnzdFwBhkri0J0Ko
         8s5CXMiP6LSy79nJVNiUAAEyDWFfUOedhfYQ6CcffzWCLSYAv3vDKXWlBq8YIiRgedKM
         eG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883962; x=1742488762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PfpTTedni4gUGfvRcfnvXw4xTvY7JO0pNjOjXTZ7pI8=;
        b=N2F9n8bDXg24wvS2rzbKqzFowL8I5ZRvQ52HS0I/+AeDbA9N7qIPdEf49mQUskb0DY
         EudZHdbyUpP9PzQyEOsQrf8xSSjvJQtmKbEU8ijTr1mBRKZFbjgMd+r4eBWYXJQeV/24
         8tkN2xHJPesF5gYZyEPluAJjuUZws27uwmJ4Qe2QW/XJNpOPxUfhYJNF8OYlpUFtJ3d9
         UQFJs4PdPmVjGpBqop/NFWi/L8npLnbZ29t5/w1fjD//ItpaBIj3pL+GoYhxF3kp/7Ev
         XJEXJKVL5GpLApx92qQouAa8LwukMdGb552bBseCvmkBSUEwc2cDW9WOz+acl0Au4nSn
         nCAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsXlbg+F9E2Vct9aD+tnknxXmZOr6vDx6n8MnfH7mPjeQY8fBHLwpgArMciKUzPJln128=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyftby5KbG+Ywz2gTLoF5qAjf3XJKasoCoeW6BEbgpGnp3gmLqA
	1tbRdYuPKM1j8LB4yj6QHbIWOZtI0y+h5lV3RHP9RD5U15+JB9lYYEqzUGhghvc=
X-Gm-Gg: ASbGnctAHojFfol8zLKPsOegmduLk9RMAZhQHP9dIOwzUuEZFHTKMzy9A/Y21t8SGmd
	twiOCWNPdcN071MniRYJlnAxdTvqyPFHkt1lMU8gtF6VFIHp82vENR2xbcC12AFq00FQCatmMlJ
	DXWmrlVrnaf+GcCAy4O3ScIqey9QScTPT9l6fQ0yABBPPc6WA3j0wARukZDr6nOnj7FkdqYj+qF
	m/eK3v6tlRyWXCb07n3eFw7KzvzpCqJ3B1KaWwn8IXkt3B5VB4IdVaw4yF2My0Kh/0EAIuJZSdB
	CGh4FdGwD5evlmNKdd/MLJJHHjDFbrpC/j1/b0Lx0LbU
X-Google-Smtp-Source: AGHT+IGoee0FqI1pRrQ30nb92L6Ez6iWr624Iw9VfJKN6XKShQ8vco+xd3ltWnO1olhH1gK/7mxIvg==
X-Received: by 2002:a17:90b:3ccf:b0:2fe:a545:4c84 with SMTP id 98e67ed59e1d1-3014e8bff05mr210801a91.34.1741883961740;
        Thu, 13 Mar 2025 09:39:21 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:21 -0700 (PDT)
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
Subject: [PATCH v4 09/17] exec/ram_addr: remove dependency on cpu.h
Date: Thu, 13 Mar 2025 09:38:55 -0700
Message-Id: <20250313163903.1738581-10-pierrick.bouvier@linaro.org>
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

Needed so compilation units including it can be common.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/ram_addr.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index e4c28fbec9b..f5d574261a3 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -20,13 +20,14 @@
 #define RAM_ADDR_H
 
 #ifndef CONFIG_USER_ONLY
-#include "cpu.h"
 #include "system/xen.h"
 #include "system/tcg.h"
 #include "exec/cputlb.h"
 #include "exec/ramlist.h"
 #include "exec/ramblock.h"
 #include "exec/exec-all.h"
+#include "exec/memory.h"
+#include "exec/target_page.h"
 #include "qemu/rcu.h"
 
 #include "exec/hwaddr.h"
-- 
2.39.5


