Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013F83677AC
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhDVDFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbhDVDFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:05:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EEBC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u73-20020a25ab4f0000b0290410f38a2f81so18204349ybi.22
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nHcWdzb0XhQi4QlsO7LmwsFD16llxMgU/74d4ZRWlZw=;
        b=D2JzKJqHjJteWl3sof+pGV0S2zgDoGRVlLX7cwJQ0ayI9xM0VfVLyz3wzh0aAmD9kg
         ox79dwVivYa6R0m+9ZRqLi1clA7jeolvTu+gadAbyc2WtfuFq6xmicvG1FaZy6pDD/Kf
         tURIMAfcACywQAyft0l/LLABT7EkjpxONx7o/HAHHpZwnOqfJKYZwNspdpHMK2VGSvGm
         0n0barYVkTlHG81oeBrUmrBtrX5478buf7TLuhi8Pz5mKOcLmp8+wpvn6ht3yYjHBpec
         g26A5Rh9oaGAhGAqsnnxNzwhMEPw3LW4LceDrS+HwVlDPKkk1e00/3UOnFkFEWAKJJGO
         zuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nHcWdzb0XhQi4QlsO7LmwsFD16llxMgU/74d4ZRWlZw=;
        b=ZssLiWoVqN9IG14mwVGo1azbiepkQpXAfqisEon0Sm/ID6e+ZZtE6TlNqjxt3/wWZo
         PvUzIlnPQkEZVCX17fOMowTELo9PmpRjUEh6bWQs1BIgJ4SrfmzrGpKHJ9brCdnz9pV+
         xHhdF+zWAZZX6HNjuKs0wJTKfATqjokyvyTlbsJarnc47ZtbGdkqRYJUoZfjUohtO3Yq
         KU0vc14bYtNPDemkdLeun5Ivqqkh1mIRVlXPHIfJzOLUDEm+gtIBZiuYl/tp+k5cdNND
         3an9Ss/iJRhcCMgjFeZnTWPSyMNJoPypmu8HnUPezY9/3X2D3oDvwG0HKIsvgS+R8417
         Td8w==
X-Gm-Message-State: AOAM532RDh7K/0d6Ap/O1RKSyHhNN5aL1blvfdbF91u8AzMur/QVG43u
        q07Au1/9EzEHodh1plXjXxLlMmj9/Xk=
X-Google-Smtp-Source: ABdhPJxLbApf4tEVBeM51RtYEfuL5zZAymNJnucyaoJ8wGyx1OXt4Xn6ufLXYe09rp1WF7zYyXDIXK7kJg0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:5d0:: with SMTP id 199mr1584859ybf.56.1619060710852;
 Wed, 21 Apr 2021 20:05:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:51 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 01/14] x86/cstart: Don't use MSR_GS_BASE in
 32-bit boot code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Load the per-cpu GS.base for 32-bit build by building a temporary GDT
and loading a "real" segment.  Using MSR_GS_BASE is wrong and broken,
it's a 64-bit only MSR and does not exist on 32-bit CPUs.  The current
code works only because 32-bit KVM VMX incorrectly disables interception
of MSR_GS_BASE, and no one runs KVM on an actual 32-bit physical CPU,
i.e. the MSR exists in hardware and so everything "works".

32-bit KVM SVM is not buggy and correctly injects #GP on the WRMSR, i.e.
the tests have never worked on 32-bit SVM.

Fixes: dfe6cb6 ("Add 32 bit smp initialization code")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cstart.S | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index 489c561..91970a2 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -89,13 +89,31 @@ mb_flags = 0x0
 	.long mb_magic, mb_flags, 0 - (mb_magic + mb_flags)
 mb_cmdline = 16
 
-MSR_GS_BASE = 0xc0000101
-
 .macro setup_percpu_area
 	lea -4096(%esp), %eax
-	mov $0, %edx
-	mov $MSR_GS_BASE, %ecx
-	wrmsr
+
+	mov %eax, %edx
+	shl $16, %edx
+	or  $0xffff, %edx
+	mov %edx, 0x10(%eax)
+
+	mov %eax, %edx
+	and $0xff000000, %edx
+	mov %eax, %ecx
+	shr $16, %ecx
+	and $0xff, %ecx
+	or  %ecx, %edx
+	or  $0x00cf9300, %edx
+	mov %edx, 0x14(%eax)
+
+	movw $0x17, 0(%eax)
+	mov %eax, 2(%eax)
+	lgdtl (%eax)
+
+	mov $0x10, %ax
+	mov %ax, %gs
+
+	lgdtl gdt32_descr
 .endm
 
 .macro setup_segments
-- 
2.31.1.498.g6c1eba8ee3d-goog

