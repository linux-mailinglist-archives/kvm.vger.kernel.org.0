Return-Path: <kvm+bounces-38911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1695A4030E
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 23:54:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DEAE4272D9
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 22:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81446254AFC;
	Fri, 21 Feb 2025 22:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G190UbDv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3941EE028
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 22:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740178453; cv=none; b=Bo6gQoEM5YyhSFBHe4ptDLJheer/xpjAP/NPJAKnuxWDqIr/sF6PxQ7n4fnx2ad+ONJsZrW3zJoxrSDkecXJWPF3tp5KeTiUnF/b5t+m+xwekssDT8+I7zPu3nxdT14aKuG4n1QzcMKm6KAOu4MzO2M6RHwT1i9R1h+EcnKIbj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740178453; c=relaxed/simple;
	bh=XRJeD15eAGh1DESpX1klhz612zOX4pybPqpYRmqGFeQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OKQt0YkPhOaR8hupdgvwU6xl2SUX8dMtUgHEmH2xVj28+RK9Y2+Q4Xrktas8I4aMMv+g1BQvrdyqj4Y3XQjRr8HqinGXMAWbGaE1O7dC6VkgUa7QXT30p6YjACiyKvjkG9cfn1/WBScJKQUbdqGYTgdpzmLeXxoI4u2ZMzgMA5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G190UbDv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1a4c150bso5189541a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 14:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740178451; x=1740783251; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5h9ZTmUqiov5wTgWDI4PVWFLdLcBQuwZ6VSghRLfDi4=;
        b=G190UbDvlY/2a0isj1ovNKM9+UahrxiQh7wcRfRlvhnUZRyPXoaFXSoD9kYJQwV5va
         l8F5hPQZYKyzpXFwwY8k0kxWjToh3/H+LslDvejNZWYG5XHI4JM0h3meiUCcAZeaxBDa
         va/07qprzmfHCsL/URop/GytmIMiAsY1KFgKpWTBJr73qGBAcmFoGG7fDJAiLEehVitR
         ZlVMbI5eaLgbxB5Z4sQkjucX/+tyxooIpS8pCeg2sk+XMhu5b93ANL3FZiqC38vRkC+E
         mAJ/NL3Lpz8OkIae73K8imv2bGUaD+dvzug5Efcw8QExlVczHG7Kh18jiRojXJrrpBzL
         TDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740178451; x=1740783251;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5h9ZTmUqiov5wTgWDI4PVWFLdLcBQuwZ6VSghRLfDi4=;
        b=ZnYTO4cha52GISIvfJBblgkhNT6G5WoO/Q1/d219FSlw5tfrJmcTKKtka4y+WXfoCN
         SqECwpPZLkX+yiGMjgpkLt5AiyGPMRJBK8ci5wXYvIrmTJNBtuzAe+YV8QZiMxAYRu2J
         xJU2uiHV7WWqmaZQi0kYQZRcvkf6U6dJuUzmzMxybbaGs2UYvRqOhEGIYg0hq3tvrTjy
         WkLT0J1gAykm2H1AXzWAuB2FW5Xv5w4TXgM+jbgZM7DMJoa+NrvGTXYQZtIShbQ+UK7w
         1Ff8G51TuaGkqTW7JBja5PTLHdNEyr+sm0R54G6aHs8Wc/t20YaABAZkl9NNmJeBBktp
         72NQ==
X-Gm-Message-State: AOJu0Yx3zizQ4vhcYh04rQP1tCvrefjn2DDWbGQDkD/qNEI46lUov8cZ
	OL4ZL/JJrkx3fBtuJb1DPBZMCf7jsboxi7QSA5AVz2XlLDLeyfxTS6dWxH3FCt2EClIdo3Fcwav
	Gjg==
X-Google-Smtp-Source: AGHT+IE4IBvF7Njf6iDDIMzxRYPAmYbHhm923zKO2PV17QJQ5MPw8E0w0ChaWmeLPOKUYFd7AD63QNBdHJE=
X-Received: from pjh7.prod.google.com ([2002:a17:90b:3f87:b0:2fc:201d:6026])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c08:b0:2ee:a127:ba96
 with SMTP id 98e67ed59e1d1-2fce7b04ff7mr6938233a91.23.1740178451434; Fri, 21
 Feb 2025 14:54:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 14:54:05 -0800
In-Reply-To: <20250221225406.2228938-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221225406.2228938-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221225406.2228938-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/3] x86: Commit to using __ASSEMBLER__ instead
 of __ASSEMBLY__
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Hang SU <darcy.sh@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Convert all two of x86's anti-assembly #ifdefs from __ASSEMBLY__ to
__ASSEMBLER__.  Usage of __ASSEMBLY__ was inherited blindly from the Linux
kernel, and must be manually defined, e.g. through build rules or with
explicit #defines in assembly code.  __ASSEMBLER__ on the other hand is
automatically defined by the compiler when preprocessing assembly, i.e.
doesn't require manually #defines for the code to function correctly.

Convert only x86 for the time being, as x86 doesn't actually rely on
__ASSEMBLY__ (a clever observer will note that it's never #defined on x86).
E.g. trying to include x86's page.h doesn't work as is.  All other
architectures actually rely on __ASSEMBLY__, and will be dealt with
separately.

Note, while only gcc appears to officially document __ASSEMBLER__, clang
has followed suit since at least clang 6.0, and clang 6.0 doesn't come
remotely close to being able to comple KVM-Unit-Tests.

Link: https://gcc.gnu.org/onlinedocs/cpp/Standard-Predefined-Macros.html#Standard-Predefined-Macros
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/asm/page.h | 4 ++--
 lib/x86/desc.h     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index 298e7e8e..bc0e78c7 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -15,7 +15,7 @@ typedef unsigned long pgd_t;
 
 #include <asm-generic/page.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #define PAGE_ALIGN(addr)        ALIGN(addr, PAGE_SIZE)
 
@@ -79,5 +79,5 @@ extern unsigned long long get_amd_sev_addr_upperbound(void);
 #define PGDIR_BITS(lvl)        (((lvl) - 1) * PGDIR_WIDTH + PAGE_SHIFT)
 #define PGDIR_OFFSET(va, lvl)  (((va) >> PGDIR_BITS(lvl)) & PGDIR_MASK)
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 #endif
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index a4459127..aa6213d1 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -57,7 +57,7 @@
 #define FIRST_SPARE_SEL 0x50
 #define TSS_MAIN 0x80
 
-#ifdef __ASSEMBLY__
+#ifdef __ASSEMBLER__
 #define __ASM_FORM(x, ...)	x,## __VA_ARGS__
 #else
 #define __ASM_FORM(x, ...)	" " xstr(x,##__VA_ARGS__) " "
-- 
2.48.1.601.g30ceb7b040-goog


