Return-Path: <kvm+bounces-59357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D1CBB1693
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:56:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 767681C64BA
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D522429827E;
	Wed,  1 Oct 2025 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ShbcSGUq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B3D261B6D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341371; cv=none; b=tsFXvaf79JUyzsedYDDlr0dzyaOjsUuhaDC1n0ZzBim+G4gczK7tkBOfByuAGgMP+X+EDo0oMZp+XqwDnXyPw+RiGnwMPf85M1t1ED3tHH1/QPfaB62HV4v95UVeaRBsaCFwY1cGwzeg//uY+xmJEbTYd/rrjZ/PT/SUNbb5jSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341371; c=relaxed/simple;
	bh=3oELwm+q8M1qpmmukJlISZg85N/1mbKbpVJa4ZH5KV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I5yR0RTFpw97p1ZVNspm2XPR3bguYepGrh9JhjQ6nEnTaalbpII15WK/p/MJqb4y21dyNKsVSw93NSFCacQRsmVNVkCHhzkF9ysWHTMYpGwAsgQ9zupBErmx/gCBgpk/k/jkd4fPV6G4cAmt8vQLSyhsnfDJA5vKrKOm2DFR9To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ShbcSGUq; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee130237a8so73624f8f.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341367; x=1759946167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2zCZOMVxUlH3hD+UCvTWPhCwey1XYt9IvIHTWoVGcc=;
        b=ShbcSGUqAyHbp5PjW27gStFpMHhntg1X1JNpcSXU4UUHsYoWbx88AtrcmWHa75BrO0
         LNGvHVrIt1Rl8WrXd7nlQKA5bVrNT/7mYBX7/4H+l5a/Ef1oS1+auqK9PBSUhHFGXWbn
         6ipS/76ntlSqtkp+L3ukJLEhxm+KIOxNxuCTgZEtlth21e6DY0x5XvjMX/UMXMiscbQy
         iO3Xk+Qw8lAea/6Y0yb3YdcYFKz8hMngMoBHtORcnYkuI34VEaFgTA3iBqw5oRjGfqUI
         OT4p7ZsutgJMui00dNcq0KxElwnoZtrE8N5ImtUZyvgmtkuECyqioxkPcoV4rz557vvI
         NCsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341367; x=1759946167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2zCZOMVxUlH3hD+UCvTWPhCwey1XYt9IvIHTWoVGcc=;
        b=A3kRvW+/uSSsyjHURnzpRdzJDB993gWTm+FAK3wvOL4a/QVEqj0W1NUnlyBIFQ8KAR
         rfS92UFtZ1bdCvOfwfwMKFo0YQS3Xbuer6YXL+qPFPpw61+asYQZkzKRQZtax8VCztlv
         +nQCGdZzkPJqME6OWf9sNt11zhrirqdD1amq+4fF9dWtY118oTI06qRfzcxSNLzihAY/
         4iTFQ1CtmcGMTY0fPKcRNR+QY00eF4cwQ5XxPh8jBaZcpha2O41BuFxN/G+3W4YKMLtS
         c5mkaxHie8wbgw3vks0cWibib5lrSkqnBVMgjdh3JQ8WRfEsVYbYSIiXyss6WzdoPUwQ
         eOSg==
X-Forwarded-Encrypted: i=1; AJvYcCVgYkyLEeOmmrPusVo0wJ6+wSLfQgP1ItY5LylIJDz7vq0akgsddgSVSAZBOovyr9+ulQw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxwQhqsNcP3fu27dyahWBvghCFjc9NsoCfPynttxLEU/fN3qzx
	29Qas0WbY42LQyR1L+UJfT9i6WpchAUnjY03/5yvLKNm05mtV9sekT2F0tABuBzpmOw=
X-Gm-Gg: ASbGnctJxQNF53Kiuj5P4sdoNCeftBEMenBIs3pEBMR2iuMoN6gY3E/TDjEYL+wqCYq
	wkAVwEeQCb6adfsSqyhCJ1CQIKT8Jrod+f9eoVyG28yKZtk9GVbK23qTpOvDs032FolL7Ukpjui
	NufOppGFxiJE3hXAoRdO1wudsxusLGMXG9heI99nEgsovfhPytKLnR5f3ltVSyWb2095kL4F2KK
	R/4h6ko1B6EAhm/SB6M97+2XF5ZABswzwxNEvCSuUbeluKEskiLP1l5vC6yUgs/QE6Js6TU07gw
	yXIF17MXOy9SEUL2ZXuljISMko8WjZ/+HlluaTOpJYZiL9YUlJruvhr3W8M4vUZyeUxMxnKqqb3
	06fSALf9dakpBIA89ZIzbIlANyXRAe3Ixs5BIvXgaKBAa0goQi5aVhA2IEdq6iwWVMxKdhnJYaM
	RyNKrAP8458XQlk2E81/MJT6VOfA==
X-Google-Smtp-Source: AGHT+IEZ4RdBmQpCq+iFSrKM7GSoqCz/Rs3gJ8kFxOIRv4Jyqw9xcJXS42HqR9BMfsO0xILWjGScAw==
X-Received: by 2002:a05:6000:1869:b0:40f:288e:996f with SMTP id ffacd0b85a97d-4255781ea71mr4021012f8f.63.1759341366824;
        Wed, 01 Oct 2025 10:56:06 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a0241bsm46954075e9.11.2025.10.01.10.56.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:56:06 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	qemu-ppc@nongnu.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Eric Farman <farman@linux.ibm.com>,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 14/18] system/physmem: Un-inline cpu_physical_memory_dirty_bits_cleared()
Date: Wed,  1 Oct 2025 19:54:43 +0200
Message-ID: <20251001175448.18933-15-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001175448.18933-1-philmd@linaro.org>
References: <20251001175448.18933-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Avoid maintaining large functions in header, rely on the
linker to optimize at linking time.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 10 +---------
 system/physmem.c          |  7 +++++++
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 49e9a9c66d8..54b5f5ec167 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -19,8 +19,6 @@
 #ifndef SYSTEM_RAM_ADDR_H
 #define SYSTEM_RAM_ADDR_H
 
-#include "system/tcg.h"
-#include "exec/cputlb.h"
 #include "exec/ramlist.h"
 #include "system/ramblock.h"
 #include "system/memory.h"
@@ -164,14 +162,8 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
                                                 ram_addr_t start,
                                                 ram_addr_t pages);
 
-static inline void cpu_physical_memory_dirty_bits_cleared(ram_addr_t start,
-                                                          ram_addr_t length)
-{
-    if (tcg_enabled()) {
-        tlb_reset_dirty_range_all(start, length);
-    }
+void cpu_physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length);
 
-}
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
                                               unsigned client);
diff --git a/system/physmem.c b/system/physmem.c
index e01b27ac252..0daadc185de 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -901,6 +901,13 @@ void tlb_reset_dirty_range_all(ram_addr_t start, ram_addr_t length)
     }
 }
 
+void cpu_physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length)
+{
+    if (tcg_enabled()) {
+        tlb_reset_dirty_range_all(start, length);
+    }
+}
+
 static bool physical_memory_get_dirty(ram_addr_t start, ram_addr_t length,
                                       unsigned client)
 {
-- 
2.51.0


