Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5179B16FB2D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgBZJpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:45:11 -0500
Received: from mail-qt1-f201.google.com ([209.85.160.201]:55181 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgBZJpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:45:11 -0500
Received: by mail-qt1-f201.google.com with SMTP id l1so3653650qtp.21
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4WOJEMcFAo8Q+bRyqnBtGx2pV60RRZcS3M/cilyPn98=;
        b=MBfEqHLxyPlYpdt2lHrUY07WKLYXKd7LRvvMgJnDZszkwjMxMDapwX5ufVUCz9E5o4
         BPpLPnK8alVTCw+yZtbXYtR2Bv6KaJnb9Ph8g/kActNfDCNFxuUmvj4lvjrns8Y4GAM0
         1Ro/gJPxAWxlgeV8ISYM3VmpPbQIFKEBIMid1w1haHRZd93idr1MAjIBgIYxX91/Jchw
         6mWjLm7axFpcOYnXzS+pDejlEQgCL3OD8O7T9bUHONre3V25P7bWjS7KMI4W+UIuc4qF
         /XsNPc03JUVaxmD4ZMZDwv2z99LV9Y6n/1MXHTraAd6kjsEcYYybTLekHLeOYTWd8rr/
         HjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4WOJEMcFAo8Q+bRyqnBtGx2pV60RRZcS3M/cilyPn98=;
        b=batSOcBY6aPjhbc1+Hd5wxAtlPmfRQqvGSjuLhBOHXgoge2HrPKL1RE3XFcsUkbAEU
         rwM+mqq8t87qoQjR+Ua4Eng/c+Jf+v2sumbFVyfaIBYCHIPbb65H4OquM+BrwMEsnru7
         QUvJauYjopLBdf2xgMpUt22pWLhIgnhWhFkXVX1axVXXQgaDRCpn/zjfkB/499PEo+R+
         uZzVjBtXe/fLy9Izl4FQ29yctc4nF0AVjVYqAgOP99sVIw5WVKu0FCFJCOFhIfhewjlH
         lZCTtithkDwqFthyZ4YWRdwuDZQVbc4t7RlAUWxzFss7+Dx3zWdUmH0bhDquUBXTE6hU
         9b/g==
X-Gm-Message-State: APjAAAVDlolrbU76FzcnqAHpssksLdaQFs5+otElIi24gF/Xmb7aTqYc
        DVyQOcuZsyV29bxOH9qwxi1hUHv2Nd745PEUUl520GZpsrOWZKFhVHJAqI+Lwt90DilrTN06QsQ
        0IHpu4hA5YWHR8Oia2L3rhhQtRZZtEqFlnYL8ws5NaP5Q9kbKKcbgxA==
X-Google-Smtp-Source: APXvYqxCN/GwM3JCkKF+6xdOBTWqDYPleeTVJgNz1MBMtd7UCwBaVNd9xRkADQ7wrTIhzbVFdGCgcLDPdw==
X-Received: by 2002:aed:3e61:: with SMTP id m30mr4289513qtf.347.1582710308206;
 Wed, 26 Feb 2020 01:45:08 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:31 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-13-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 6/7] x86: VMX: use inline asm to get stack pointer
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only supported use of a local register variable is to specify
registers for input and output operands when calling Extended asm. Using
it to automatically collect the value in the register isn't supported as
the contents of the register aren't guaranteed. Instead use inline asm
to get the stack pointer explicitly.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/vmx_tests.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a7abd63..ad8c002 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2165,8 +2165,9 @@ static void into_guest_main(void)
 		.offset = (uintptr_t)&&into,
 		.selector = KERNEL_CS32,
 	};
-	register uintptr_t rsp asm("rsp");
+	uintptr_t rsp = 0;
 
+	asm volatile ("mov %%rsp, %0" : "=r" (rsp));
 	if (fp.offset != (uintptr_t)&&into) {
 		printf("Code address too high.\n");
 		return;
@@ -3261,8 +3262,9 @@ static void try_compat_invvpid(void *unused)
 		.offset = (uintptr_t)&&invvpid,
 		.selector = KERNEL_CS32,
 	};
-	register uintptr_t rsp asm("rsp");
+	register uintptr_t rsp = 0;
 
+	asm volatile ("mov %%rsp, %0" : "=r" (rsp));
 	TEST_ASSERT_MSG(fp.offset == (uintptr_t)&&invvpid,
 			"Code address too high.");
 	TEST_ASSERT_MSG(rsp == (u32)rsp, "Stack address too high.");
-- 
2.25.0.265.gbab2e86ba0-goog

