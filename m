Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74DE513FF5
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353710AbiD2BHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353687AbiD2BHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:07:37 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F05BBC864
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:21 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s68-20020a637747000000b003aaff19b95bso3197426pgc.1
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/F7u5jcoDKD988Ymfw3LyvU9T0g0ALLsxhHqY4ZHDtk=;
        b=PbjvjOQF/BvQXETJcl+J7q8EaS4zuBddtEwwwpADTGWDhKMoSUKzNtyQns4VfpF016
         w5uRA5JSQOtRPKhde8ZxgVY1UT3rkSzjqWtBv2+82cJEATdFrg1zl2bXy7pRf4AabgpK
         LykpdMmgqaic4KNDFJ2T0SbEYJzjOPJ17+6SK6DKwGopSb4IqCfoRVZFA72uaeTLfSzC
         YOVfHktLQxg3gJ1HQuVWrtELRPHJ14SGodXFiLJf14tS1QyHBKbjjigaEhd5rM/F5j+i
         1bRFT86TBUQJW95uyRjwrcOokp4aWOgTM7csqSJjROtLNyc9tygZ0bD6lE/CPzJ3T7hZ
         5/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/F7u5jcoDKD988Ymfw3LyvU9T0g0ALLsxhHqY4ZHDtk=;
        b=l9i9CwyZ/0mI+X7+8pu5wgUwG32XEIx9t4rHGuc9bRXU/vThKM2GnEEfta3ol6tLKh
         2b3TM1h3tLXbseBo4KtOFjltjs0AaVLh7NucvwiHtGmQlfkJvQqKuIMXMDe7lc1PvnAT
         XL6ZbNdwUOOrccq3FK+r+Q2A4bYO8Bxs77vRT7JAkFqT1j6I1j6gYW4xohP8BnFyzJXS
         jAbmvGN++K7ArdV+Fodr+kXHZmdZG0zpo5j2bFyT8Q5hm/WBl/8R28qAZRXUym1raWR4
         NUBGLtJA2QohFPRQW2c+DO3tztQSc9YlGTDQYFTDr22NfeVL+p8Yozm9ULrHObxMwMJp
         W0yg==
X-Gm-Message-State: AOAM5309WhlNnSGrgroxqLs+WDkZ7XYd3elnXh6aupQoDKQkXZxrvOXN
        ynHNf7Y2oYN3K2wOhXsbsPsi0WbJ1fk=
X-Google-Smtp-Source: ABdhPJxf2rEbyEyrxjUedAKmd5l36jeK0WkS8NlEIIFXxaQo+b7d6qLdeIoJsxzvBwS6qb8RA9UJol53CME=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP id
 t16-20020a17090ae51000b001d9ee239fa1mr184049pjy.0.1651194260328; Thu, 28 Apr
 2022 18:04:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 01:04:07 +0000
In-Reply-To: <20220429010416.2788472-1-seanjc@google.com>
Message-Id: <20220429010416.2788472-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220429010416.2788472-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 01/10] KVM: Do not zero initialize 'pfn' in hva_to_pfn()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the unnecessary initialization of the local 'pfn' variable in
hva_to_pfn().  First and foremost, '0' is not an invalid pfn, it's a
perfectly valid pfn on most architectures.  I.e. if hva_to_pfn() were to
return an "uninitializd" pfn, it would actually be interpeted as a legal
pfn by most callers.

Second, hva_to_pfn() can't return an uninitialized pfn as hva_to_pfn()
explicitly sets pfn to an error value (or returns an error value directly)
if a helper returns failure, and all helpers set the pfn on success.

Note, the zeroing of 'pfn' was introduced by commit 2fc843117d64 ("KVM:
reorganize hva_to_pfn"), and was unnecessary and misguided paranoia even
then.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0848430f36c6..04ed4334473c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2567,7 +2567,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 		     bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
-	kvm_pfn_t pfn = 0;
+	kvm_pfn_t pfn;
 	int npages, r;
 
 	/* we can do it either atomically or asynchronously, not both */
-- 
2.36.0.464.gb9c8b46e94-goog

