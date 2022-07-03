Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB03356497B
	for <lists+kvm@lfdr.de>; Sun,  3 Jul 2022 21:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbiGCTQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 15:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiGCTQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 15:16:43 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEF660F4
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 12:16:43 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q8-20020a17090a304800b001ef82a71a9eso1065093pjl.3
        for <kvm@vger.kernel.org>; Sun, 03 Jul 2022 12:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MyZAfja8pHSQZae1P+s/WoDVtRcqu2prdMXKK5bAw/o=;
        b=reHtbb3IOtGgZZ8Kly6ke2ELWzu5NfuUpYFWsuNGDWP+9acUEa7eN7GcGDTKD9mFEG
         qYy4CroztpJtLmpjPHzBfr06aW5/bri+bd29sO1XsygggFTrYaXiW7Lso0WHOvuBORXU
         16v9wyJQfRNB6/F/AhNOtUSwY0KSvtF7NBCjIYrxHI9Rs67vRXxV9t70AJd//51fE1cX
         BUD1W4NazZN+bvFgFXdIRZOu1SYa6l9muu+rLyhP1N8FqIrIq3PmYFzYmpHEd4gAysey
         Crnk3k561fcm5RUESVHyocG8tfZb4qpIpUDHFog5+dQ0rSbWm+htS05V6fXWuJBhsdkI
         ap9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MyZAfja8pHSQZae1P+s/WoDVtRcqu2prdMXKK5bAw/o=;
        b=iM+b3E4VdcAmejAMQ8IED8CboS/NtXZ+Y+1JiqH+tR0wO1abhdMlqKJcnN+HfOQcDW
         9VQ43rRTq+8dKC6OPyqyylcACPy53iOjssyUcCUBdetUwjTzm5+3rv2LGLOWGuVAomOH
         7p96jKv28RwBwD9KGS9Gp8L6VmwCvw4nXsXafXoIujJ6o0aZA0TVNihDAQMSRdILDQpq
         dP/Y8sW776Sh8xa5rNTzRZbXyoU4Ofk24cVoI3CKPnxe2x4hte4+Usz8pOo0lvgZRzQq
         HBRvhj1JYumQSmISNMXukmXD9ZA4nGpUJOJHLTw5aXmvk+PayWoKR/e/wHE1zw/fxxGT
         AUew==
X-Gm-Message-State: AJIora+zInTlSJyznjJ3juOU9TtNUMUzTLY/3ndMmnWySCpt83qK8bdi
        UTDgaYF4GIVar4NrvZSXfRh5xNPbc0BvRSiq3YTVbuT4vZI/HjFxy9b9XMXP5UcvZ80h06c+sXt
        E5uGZPw+FGLDdxJMj4Gdh9se8SX0jXcFeTJLEYkviUfiCAMYTdN05jU/pBmmpzluwjo9e
X-Google-Smtp-Source: AGRyM1vDVL5lCMO5OWbWfO6D75zKM4z9uYaiKy2J2vSkbVDefUHBaQcUgV3q+iojwVr/J+MLFG3/cAhC0cN7HFPS
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:d48a:b0:16a:3e7f:db21 with SMTP
 id c10-20020a170902d48a00b0016a3e7fdb21mr32471549plg.50.1656875802537; Sun,
 03 Jul 2022 12:16:42 -0700 (PDT)
Date:   Sun,  3 Jul 2022 19:16:33 +0000
Message-Id: <20220703191636.2159067-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 0/3] MSR Filtering updates
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Fix and update documentation for MSR Filtering.  Then, add a commit to
prevent MSRs that are not allow to be filtered from being sent to
userspace.

Aaron Lewis (3):
  KVM: x86: fix documentation for KVM_X86_SET_MSR_FILTER
  KVM: x86: update documentation for MSR filtering
  KVM: x86: Don't deflect MSRs to userspace that can't be filtered

 Documentation/virt/kvm/api.rst | 132 +++++++--------------------------
 arch/x86/kvm/x86.c             |  16 +++-
 2 files changed, 39 insertions(+), 109 deletions(-)

-- 
2.37.0.rc0.161.g10f37bed90-goog

