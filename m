Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0F3623891
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiKJBEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiKJBD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:03:58 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA15222A8
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:03:57 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id b18-20020a170903229200b00186e357f3b9so259522plh.6
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iDDHXPhFkGdnX95qrgqVPt+r6rQuoMhyEFBChOuB5Os=;
        b=MZXsVlUfoTlGHrSgXpEusui6O66VcUV2rNkXmCsIYuB2zgTgveT3K6JVT4csrJd90U
         SXCtzooBnC8HqrgOJJN9VQBbR0m2YhW0tTeK2fda96kBkTbEk/gi3H/UzM/lhIwnbOWb
         0b4fuRW57MXJcr/4xBfNJViYkwGD6hAcn/q3fOV4E2kXE7ozNQ5oN/bz/A5ijG/OGtWj
         QFlvR7+yF8Y6jGGv8gp6B3Pb1uGJXRvP+Yyk9UM61o9KayrsP+Ow4bmX5eKnilzn7HQ0
         f48hnQDwHp0VZU99uhTmFSBmeX2FmSI4WZYvVLzKIR7WrPJH5MimWY7Oxac8y0BQs2Mo
         xF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iDDHXPhFkGdnX95qrgqVPt+r6rQuoMhyEFBChOuB5Os=;
        b=wteIsSj13HasgSNxCoPlyFO/MKPkFPad6pibTBh7uBBXS/fmjbrL4VDJH2Xn2QY/mr
         hAidmqL9VQn6tvqEvxvCwcNPH0l+cd0JT8RC04jJGWFH47emNhM2OeJApbsj8/q5c5ay
         gSXTV9x6ATKEZ7Oah8JqgYOb6VnE7Vxw/K4T+hMV9BswJAv9dLJVLcg63Y913jKkT3ln
         dRHt8nA3nrqQfXhX2VONB8luLVuSblVdAzgMjhT5XijrLYq1FVm6zA6CLIpdEqSFehYc
         cyQQ9Ps46lGy1ZJrxbWV53tbBhZWZO55LC/F2S9PrvLWuIiVq8tEDYkXoFB8wtQFdhsI
         f2AQ==
X-Gm-Message-State: ACrzQf33Z6AskCaN4jCmjUOxKdiRJAyKb2vri3uILwLu1UEfcz9a340S
        868H0mVKAIbVutfwK2jglla0w0XAvqY=
X-Google-Smtp-Source: AMsMyM7m81/Mbrrd3QVHFCB5IYx7Mek7wWQ+j7ee25Sj5VzTZu5i1gn4NeN2p5sgfqY453GnHEeBXIikYUs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:72c4:b0:212:f923:2f90 with SMTP id
 l4-20020a17090a72c400b00212f9232f90mr1211629pjk.93.1668042236783; Wed, 09 Nov
 2022 17:03:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Nov 2022 01:03:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110010354.1342128-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Remove unnecessary export of kvm_cpu_has_pending_timer()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Don't export x86's kvm_cpu_has_pending_timer(), the helper isn't used by
KVM x86's vendor modules.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index d8d50558f165..04a009fbdf8a 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -31,7 +31,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 
 	return r;
 }
-EXPORT_SYMBOL(kvm_cpu_has_pending_timer);
 
 /*
  * check if there is a pending userspace external interrupt

base-commit: d663b8a285986072428a6a145e5994bc275df994
-- 
2.38.1.431.g37b22c650d-goog

