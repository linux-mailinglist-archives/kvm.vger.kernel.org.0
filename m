Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697465226FD
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 00:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbiEJWlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 18:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiEJWky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 18:40:54 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04FA3B557
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 15:40:52 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h128-20020a636c86000000b003c574b3422aso68921pgc.12
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 15:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pbjNQKfFYHhld5/u+FKbeyu1b1KqWuA6X7NqYQGpLkg=;
        b=MP2nJmSXsEUWnHcREGcAUJcoRRxdFSZKGWC74Gd0istoNx+97p4h/J8yGxFTmHUzzk
         dQM8gpuIfeYLsAr6UTKjeJKRBtG4iBfZPOp5Sy0/K79mz+pAZNQuvnStnRX5lNz4xiNM
         znFZUq0Hz7Fem/maBhqkdDddPmubpShRIcfojQe94gqXSKRNMCjsQVcBznkmEnfYp74O
         D8V6qjViORHk8zFF+0Ks8H1BBOdCBrYkszj/5lfS1mhNIwPQOGJKBHXmt52aumddoC2B
         vxsOlPg6Z5RmER/WQnzw6daNdUfurEQkmgbGY+6k5o0MzTzwVBPA11a2QMAhjwdZFvO4
         YLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pbjNQKfFYHhld5/u+FKbeyu1b1KqWuA6X7NqYQGpLkg=;
        b=YVJr+cw/b9MSHL3m8GE7bstXzuY+BeHiJQXMpK5c6PIKm9ZJ9Hw+cagDkC9aH+Ny6p
         wC3pjwOu3Lsef4z6WovsriQ7E3UzVfxBgohCWe17Jz99UiU5imeNwZHAdbTW8ICD/P7j
         Fm8cU+7yK1LI0gFJFE5/z3R/tp9BZbqgIvlGXM0C+8xcC0tnbRaih5OLyY+XmOf+Rckr
         pXM0R8whRZHQ2CYu5CI90t7P0xFItt8LTPVCI1xfsAzYFqvwf0ov9tBk74Gb+Q8qflsd
         DBqPeBI882gS903dWsZR3icExX2UJNtmJCUjkDRWuD27pP8IM5vD7Spon9YB8heQQCyD
         BqNQ==
X-Gm-Message-State: AOAM532kuFNcCviS5MpEw1usV2OkHotOvW17qGZeWy7KBrOwXVVz+c1q
        9bJtKBj+EGjMEY4TtE04yUR+jMAa3cQDcCbNNrd1JX8IGlXV7eETOz4D+x9QjxxaNq5SmecpVz0
        ecosfUgJotyxxNv7fCiZvn60+9w8JAx68SSa0IB6Fw1l36hI9RKA2/3GzAlk5Tho=
X-Google-Smtp-Source: ABdhPJyLPFJHG4oZ37txyYAUQWIP5BOxhDvjYIm6lFqzA27TfCkg0489OoUZpd6gkOLPfXA+Z3VOhyUUlT+enQ==
X-Received: from hawksbill.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:55dc])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP
 id c18-20020a056a000ad200b004f12734a3d9mr22480562pfl.61.1652222451974; Tue,
 10 May 2022 15:40:51 -0700 (PDT)
Date:   Tue, 10 May 2022 15:40:35 -0700
In-Reply-To: <20220510224035.1792952-1-jmattson@google.com>
Message-Id: <20220510224035.1792952-2-jmattson@google.com>
Mime-Version: 1.0
References: <20220510224035.1792952-1-jmattson@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 2/2] KVM: VMX: Print VM-instruction error as unsigned
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the printf format character from 'd' to 'u' for the
VM-instruction error in vmwrite_error().

Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3a76730584cd..f558a14851f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -386,7 +386,7 @@ asmlinkage void vmread_error(unsigned long field, bool fault)
 
 noinline void vmwrite_error(unsigned long field, unsigned long value)
 {
-	vmx_insn_failed("kvm: vmwrite failed: field=%lx val=%lx err=%d\n",
+	vmx_insn_failed("kvm: vmwrite failed: field=%lx val=%lx err=%u\n",
 			field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
 }
 
-- 
2.36.0.512.ge40c2bad7a-goog

