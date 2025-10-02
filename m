Return-Path: <kvm+bounces-59410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 883A1BB3551
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:51:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A570519C532D
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E51313261;
	Thu,  2 Oct 2025 08:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G+azsXEK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2542D4813
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394567; cv=none; b=nCuC6kEEGnERyRoc2SuffATptGl+FQbgjLtlCh0FCb3OZ9mZEMQrLc/E5Y8cL6hKLD3FzCy0cqNMwI2nGXMzQuw18ak9kafZXnlFfr6e8OiuTrnTgwRVqRZJLl7zD2mhOOr6HnqfxLb3HSOTLY+1KYx+eFBr9bojCDnoozSB4Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394567; c=relaxed/simple;
	bh=Ylyu3Xyo8cCR7WJt5QEFRwcq67lRnRLXwPB+fVRbBWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hLvZLNyhvkgXT/oCGwt7Ui4vwbHlORpZsVLzZ2xWAU+EkKTc/D+ma7Dg9knfuHS6mYKpu/jFAPzmHjlQmu7AMvoG8ulXiz1owh2EWHEmpdqMc86ZWKFxvN0jIKT4BDoVVtS25GQgSm8ZZzDvwmw2cRbx37ZKtRouP3CGb5xsZxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G+azsXEK; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so7584345e9.3
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394563; x=1759999363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/V6bK/dS4q8NfIVc1IYGAX2Y2n9tYdVPl2PhRG623tw=;
        b=G+azsXEK8DiVof4noUOWacOEVKwbh5FOub2t9EGHNweDEf9X8eTgU+sukcmVWiteva
         yHoNjsn5p5tYT7FpLWmf57TKai4rAOlLE/BzXWtcvH+Iw+vAINmNHz/qWw+20bJZ0Yvp
         H/uMnwxrxu38h2Ydgc4V5YnyptZFfIr1/sewCzucxa1N/S6MA/P0Ws784Ch9bUuPfk2W
         /Pn0ub/hfkZxFB1cMbCIpw86HluyxYHw3YzfvZZJY5mH13TuUH4eG0sN5JHAGCGsnBmF
         +/An5ZqTfSjv47Sg5eyGLAePY/FMN14m5eto5xj2GuEZh5HSW2NspWElGf3Z1gWdIHnn
         Ul9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394563; x=1759999363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/V6bK/dS4q8NfIVc1IYGAX2Y2n9tYdVPl2PhRG623tw=;
        b=ZigzuMMVioIvcWSgNWYMxOZKZFXR5pPuC5Q+ylN3dR5mI42CII81UhEN//GQA1qGkw
         fHd3My8BEDZbnFqw6L2dhrQCy649i5l4fnq2CzOusq8vAyddCXBP162fC9uuXxVKnyGI
         Ov27AfBUqjbqJMI1qtZ5j5D4tKSTQTCJ0WDHEjNWjKB+jRsPxvq6dEr53iwES8WrQQYZ
         l5ytGP+EyDJplpG/Kla2MqiJI+TImUKsK/F4O7QT+Be0ob7EoSP56TGKcXAs+xsmtP2v
         G9h8ktBpZIoFQ9CbCn0X8ERZF6f5bYHGxh3oju5pib4dtTbnEGcFMJaJ3GR8jJeqvR93
         FaRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVT5glWp6peQauLYHDrFcD5h4bmK4fdwWL0btnA8FyzKRX5YLoyXNHTXQYYVcfs3I1tApQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+J3/OXU0HBBYkQYeJOrJBfymyrvyT0iQMZXvmCOzqooz1dhf3
	PxrKb89OukVyzQOcqoCSD+6WqYOb2PNqPcvACfJE/zNEwoju2E4oV0Xt9bkad8zdIvU=
X-Gm-Gg: ASbGnctv+T/fAZFHb3Xd1Y7MjlUxVKeuZPzyYGSmv0cpSLX4CmMrPzBmxOsjbmU8Yt1
	xIiYsgeH5OEIoUEyC2CTxLRhdQUa2M9fErsuHLEcvf1YBtCHXMDpCBa3rYIBvxFL6XqsP/cH9zV
	JHIq+hMdKFcSblhYdPpneW+5v+LZkIc36gapN+jU4dEGU48TD26lO9EwcFDu7PQBmi9eKxqHFfJ
	VcRZpW4Xvh2VQFKD/wXmiexCcRGVUEFWgNM/vRF0Q1Bpu8vMzAc9S+qz0Wp5I7PjxGkuAUhLGWD
	Zbr760JcGXzJlKjtS56yz8zMcAOElg0akcV3Ee9VZdRDisIHg0ZBUzTTaBJoJt0QzdIUF7z70ly
	UmKAGRBr0wiIA9vP7D5CkJNyQ+KLpuxAdFJ5OX3Vyc4xC/SEIo3PwaYS0w0H8eXu1d0LEk+ioCp
	/BmrtGET6Dn2zLSinN9CUvnZCIDpLE3Q==
X-Google-Smtp-Source: AGHT+IFyxE2f+paPHZWS7atlHQE5YorXbC8H3ZNAWMF66wQjW+bist3zGSpvkgOszGdSmrRhuBdazg==
X-Received: by 2002:a05:600c:1d15:b0:46e:46c7:b79a with SMTP id 5b1f17b1804b1-46e6125d269mr48068925e9.2.1759394563460;
        Thu, 02 Oct 2025 01:42:43 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6b23d4c5sm17135895e9.17.2025.10.02.01.42.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:42 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 08/17] target/s390x/mmu: Replace [cpu_physical_memory -> address_space]_rw()
Date: Thu,  2 Oct 2025 10:41:53 +0200
Message-ID: <20251002084203.63899-9-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When cpu_address_space_init() isn't called during vCPU creation,
its single address space is the global &address_space_memory.

As s390x boards don't call cpu_address_space_init(), cpu->as
points to &address_space_memory.

We can then replace cpu_physical_memory_rw() by the semantically
equivalent address_space_rw() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/s390x/mmu_helper.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/s390x/mmu_helper.c b/target/s390x/mmu_helper.c
index 00946e9c0fe..7bcf1810bca 100644
--- a/target/s390x/mmu_helper.c
+++ b/target/s390x/mmu_helper.c
@@ -23,6 +23,7 @@
 #include "kvm/kvm_s390x.h"
 #include "system/kvm.h"
 #include "system/tcg.h"
+#include "system/memory.h"
 #include "exec/page-protection.h"
 #include "exec/target_page.h"
 #include "hw/hw.h"
@@ -542,11 +543,13 @@ int s390_cpu_virt_mem_rw(S390CPU *cpu, vaddr laddr, uint8_t ar, void *hostbuf,
     if (ret) {
         trigger_access_exception(&cpu->env, ret, tec);
     } else if (hostbuf != NULL) {
+        AddressSpace *as = CPU(cpu)->as;
+
         /* Copy data by stepping through the area page by page */
         for (i = 0; i < nr_pages; i++) {
             currlen = MIN(len, TARGET_PAGE_SIZE - (laddr % TARGET_PAGE_SIZE));
-            cpu_physical_memory_rw(pages[i] | (laddr & ~TARGET_PAGE_MASK),
-                                   hostbuf, currlen, is_write);
+            address_space_rw(as, pages[i] | (laddr & ~TARGET_PAGE_MASK),
+                             MEMTXATTRS_UNSPECIFIED, hostbuf, currlen, is_write);
             laddr += currlen;
             hostbuf += currlen;
             len -= currlen;
-- 
2.51.0


