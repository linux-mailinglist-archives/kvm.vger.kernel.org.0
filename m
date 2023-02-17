Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000E469B64E
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 00:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjBQXLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 18:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjBQXL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 18:11:27 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69D66BDD4
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:53 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-53657805673so22031037b3.0
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=npHi3V7E0yjLP2ajthwoOQ/SU63n4hMuJXlKMFS+nHI=;
        b=P8vTeMvHJCNfFsDWiLgIMpvKAPjVVwfRvi5yeYuL1WdcjubdsboNwBPVGDt+BksKvF
         4zW5PNtqyX0zM7Qk4N95bYPYTer1L8lrDmHW8jXVK02zLEFiKAonT7XaVBYT7J+iyvgc
         WoJO3O26G7CBJotWPGqB2pmQo8aJi7c25P01waomQQIjiFmsh6q54ESUDx2tqgi5JUid
         OiBR38TxZopIgMZAPbxaItPr7wFx5bFVZmAOUlckkeOOVFE+Ae5o/wsBMzl6KyqJel0K
         6kghLY1vDdnJrl0uydKaQl0uyZWCcekXaH3WIlhWI08zsOo0eWtsQ9LIKOpF4kH771pf
         C2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=npHi3V7E0yjLP2ajthwoOQ/SU63n4hMuJXlKMFS+nHI=;
        b=XKK+W4Ixi1KOmYhDmM/xfgHahGUPdPH3zpl936YiEn3XnCL8MTwSbrH9Hk8ZnhJsZu
         HgeEetWYNegA5nAJpydQ3uI4EfSJ7f75ShsFdRIls8mvqpotL9Asac8P/fu3QCgpwIAI
         VrA3H3ntC1m3wX/V/fy0fhxX9mxZ5WxtWlsaq+JEYDsWgxbkvT2/i8TympCgFHdqwdSA
         H5YFMbpkUz9GiU5Cc/ghJ/8sGmdP0N3vVPj6wMLIhLymfXm7erCuimOa1GnzKTQ+a1ou
         oEX4L1qpN/oYFQC+oJnT3cQxgm/xlVACR+kJKyFIvp3oQJMVh3QQiptTHKSFy2y047Op
         /3LA==
X-Gm-Message-State: AO0yUKUdpHWy0rEUgUgkeDHiaPT92nbLpUHvBQfV/8S8uNaYLnNcdwvU
        7LeTbUdrUPMrgERDlCopC+c7/AsTrbs=
X-Google-Smtp-Source: AK7set8oGKAOIbnVEAcCNMAuimrYVVMgE9qYLpO7OcA6QmLVbcQ5yyl8Qjto6YSNJMSBj5gTWp6gRPcFVmQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9c45:0:b0:913:5de0:5acc with SMTP id
 x5-20020a259c45000000b009135de05accmr1520970ybo.494.1676675448091; Fri, 17
 Feb 2023 15:10:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 17 Feb 2023 15:10:22 -0800
In-Reply-To: <20230217231022.816138-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230217231022.816138-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217231022.816138-13-seanjc@google.com>
Subject: [PATCH 12/12] KVM: x86: Disallow guest CPUID lookups when IRQs are disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM has a framework for caching guest CPUID feature flags, add
a "rule" that IRQs must be enabled when doing guest CPUID lookups, and
enforce the rule via a lockdep assertion.  CPUID lookups are slow, and
within KVM, IRQs are only ever disabled in hot paths, e.g. the core run
loop, fast page fault handling, etc.  I.e. querying guest CPUID with IRQs
disabled, especially in the run loop, should be avoided.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3b604499c35c..0f34774129d8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
+#include "linux/lockdep.h"
 #include <linux/export.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
@@ -90,6 +91,18 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	struct kvm_cpuid_entry2 *e;
 	int i;
 
+	/*
+	 * KVM has a semi-arbitrary rule that querying the guest's CPUID model
+	 * with IRQs disabled is disallowed.  The CPUID model can legitimately
+	 * have over one hundred entries, i.e. the lookup is slow, and IRQs are
+	 * typically disabled in KVM only when KVM is in a performance critical
+	 * patch, e.g. the core VM-Enter/VM-Exit run loop.  Nothing will break
+	 * if this rule is violated, this assertion is purely to flag potential
+	 * performance issues.  If this fires, consider moving the lookup out
+	 * of the hotpath, e.g. by caching information during CPUID updates.
+	 */
+	lockdep_assert_irqs_enabled();
+
 	for (i = 0; i < nent; i++) {
 		e = &entries[i];
 
-- 
2.39.2.637.g21b0678d19-goog

