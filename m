Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63C13B0F1C
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhFVVDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhFVVDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:17 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFAFC061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:00 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 100-20020aed206d0000b029024ea3acef5bso516017qta.12
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3roEB27IHSAyww1GhUrfxciS1XDaGfhjhokUOuHz8oU=;
        b=nHRgLM0mRyRxReQ2ALJtfGJ7kSU1GqczWckyuJ4P8j1kefZqXyKLjSNbRMSyVgevK2
         Eifh5iQm39v9CXBmq5UG5siI2jk/4dwHXFNzTCq4qH7F3G19Uy96t9VvJm1LvyvuVM2i
         6JX3PfIknYrAXYMC1idtKgnT9P92rTs3HgI1zqGNr5POe8BneR+tSkeDD/BQ1eKwesML
         gzZnfpLQLpfnLIB2rSBieMY+QbaNmN1x92TDaCCp2IjCoCquNk/5m1ja+KDv57BYDhvP
         SYObrxSRw7TzsN8SnKYyyhR332Bl/VUuOaRVS07sSca9Z1M6YNw9O0esKUmltQsf98fC
         WTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3roEB27IHSAyww1GhUrfxciS1XDaGfhjhokUOuHz8oU=;
        b=NM6AV3z4D+HKe7wWjxnKvsJiP5TCjAdgaliAdF+UIy8meBSqcFWTK1zgvhWF9cPYUX
         i8r92mw/Wg8Z+hkTfDwT4s8uajeYVXch5ZBX6iKgqHA8IDO4Zkkd7L2e3cGcoOZ3cIZb
         T4ZWNOB5kA8oyHLUOunPt9DGpvYh7IdXsV5bk/W+B1S6R9bnS2xluiSTwHcy7puqMxOq
         P17UIXTuzpMnhA4mUL88DX169HVSa0jADpBgo/6GEwSAciCHD6GZ2k7Vhql7kXD8+x+D
         FF2o8raAl0KsKA3EuqvRqgSKiUnXqLSLxoIlJMvIGBxlH9DNfTw7J2B7IupVTRqGIXHY
         GHAg==
X-Gm-Message-State: AOAM530Nrl+/aDWQlgRVfS8gv72p8dy9VLxCcZc3FtYndWmbbn8nKsIH
        uZiALHQB8ty6YImm99WMCfXUdeCt1ns=
X-Google-Smtp-Source: ABdhPJwwdK8WNgnzX6J9XW8QCS+QVPg6P39pm1ry2DC/5obBCSCT0CeB4uKg6C6Ectfp4z67xQqI57sjIRs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:f208:: with SMTP id i8mr7155324ybe.340.1624395659180;
 Tue, 22 Jun 2021 14:00:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:39 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 04/12] nSVM: Explicitly save/update/restore
 EFER.NX for NPT NX test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly set EFER.NX in the NPT NX test instead of assuming all tests
will run with EFER.NX=1, and use the test's scratch field to save/restore
EFER.  There is no need to force EFER.NX=1 for all tests, and a future
test will verify that a #NPT occurs when EFER.NX=0 and PTE.NX=1, i.e.
wants the exact opposite.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index aa74cfe..506bd75 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -700,9 +700,11 @@ static bool sel_cr0_bug_check(struct svm_test *test)
 
 static void npt_nx_prepare(struct svm_test *test)
 {
-
     u64 *pte;
 
+    test->scratch = rdmsr(MSR_EFER);
+    wrmsr(MSR_EFER, test->scratch | EFER_NX);
+
     pte = npt_get_pte((u64)null_test);
 
     *pte |= PT64_NX_MASK;
@@ -712,6 +714,8 @@ static bool npt_nx_check(struct svm_test *test)
 {
     u64 *pte = npt_get_pte((u64)null_test);
 
+    wrmsr(MSR_EFER, test->scratch);
+
     *pte &= ~PT64_NX_MASK;
 
     vmcb->save.efer |= EFER_NX;
-- 
2.32.0.288.g62a8d224e6-goog

