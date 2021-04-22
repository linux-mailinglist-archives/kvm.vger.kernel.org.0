Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE763677B9
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbhDVDGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbhDVDGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:06:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B447C06138C
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n11-20020a25808b0000b02904d9818b80e8so18194068ybk.14
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=076bMPCqECvQlR4ZN7mlK3OTIab6tWkXeVy8ARXnEI4=;
        b=eK/HGJ0nG1gyD95oLF4qyypqQAakoxpWpar1UhJVWKp76nVVKLZJhizTCsC9yc39Tw
         kiStW79rTNDMb8GeqacJCUsf8cM4A3E7roCcXhW9/stVsMqN/sj8Qu4dicAeQM8boJal
         zKqs5I3Xr65vSkxxKIzUwHnLvf6HkOgf6vc9RtElP3e1526GUWgj+TTcQVCGSQslcKyd
         pJYSfDeQqyoEezfolh01EzeYmUJG/H0nWS4ky3xU4WS1IZQJ32Y0eKBUJQzBrq5yNzKb
         gK/8ubKSh3JZVpn8bkQzfai+i7N2r2ll0cr8rYnLtyoTxgOiD2AwWSORZ1lYog3RTSiZ
         09+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=076bMPCqECvQlR4ZN7mlK3OTIab6tWkXeVy8ARXnEI4=;
        b=Vb3khj9nk20Q06xZvCQStLpSyOSRtScHYQQilFUECh3d4It5Mr1JXKtoTuv6uY32JR
         HWLhCLnmd46DMuRgFq7PFSIMRvvJDMXFq3an/KSLts2nQRVYU/4ivVvJtzaoQ/vwrV9C
         HSAdw5axc6acZyimvupmX7tdMXkq8X+jGK7X2MhtcQyh77Zu9nG7cU7ZcywwA5i3N3lm
         8GmwDTP/OCvM2TuwtyTt+aibGMAZRejp0YTdRz6bq+nWm6A4a5So1640+/KmeBvAVT3B
         lKyx5EFjtWvfWLw9//rsNKj7lwWlR3B9Q4/0Jr/mfiqHhT1RftRfkmsWrAEckqnAlBzi
         jBgQ==
X-Gm-Message-State: AOAM531leliDtd3vu1kXoHPi8tU0cOsidszLezjDT6IIbRfwxRHsYIbu
        0XnRIggrSVx0xtSS0Y+FK4lVtvUa1Vw=
X-Google-Smtp-Source: ABdhPJyKclf+s/BdAa67VKdgzpTOZYv6exY/LsyTRY93OFsV6xA/SMemkj/g2vn/oIaJVElaDx79bxLPP0M=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:4fc4:: with SMTP id d187mr1556686ybb.245.1619060740358;
 Wed, 21 Apr 2021 20:05:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:05:04 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 14/14] x86: msr: Verify that EFER.SCE can be
 written on 32-bit vCPUs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that EFER can be written, and that the SYSCALL enable bit can be
set, on 32-bit vCPUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 8a1b0b2..7a551c4 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -29,9 +29,7 @@ struct msr_info msr_info[] =
 	MSR_TEST(MSR_FS_BASE, addr_64, true),
 	MSR_TEST(MSR_GS_BASE, addr_64, true),
 	MSR_TEST(MSR_KERNEL_GS_BASE, addr_64, true),
-#ifdef __x86_64__
-	MSR_TEST(MSR_EFER, 0xD00, false),
-#endif
+	MSR_TEST(MSR_EFER, EFER_SCE, false),
 	MSR_TEST(MSR_LSTAR, addr_64, true),
 	MSR_TEST(MSR_CSTAR, addr_64, true),
 	MSR_TEST(MSR_SYSCALL_MASK, 0xffffffff, true),
@@ -44,6 +42,13 @@ static void test_msr_rw(struct msr_info *msr, unsigned long long val)
 	unsigned long long r, orig;
 
 	orig = rdmsr(msr->index);
+	/*
+	 * Special case EFER since clearing LME/LMA is not allowed in 64-bit mode,
+	 * and conversely setting those bits on 32-bit CPUs is not allowed.  Treat
+	 * the desired value as extra bits to set.
+	 */
+	if (msr->index == MSR_EFER)
+		val |= orig;
 	wrmsr(msr->index, val);
 	r = rdmsr(msr->index);
 	wrmsr(msr->index, orig);
-- 
2.31.1.498.g6c1eba8ee3d-goog

