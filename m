Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09EC576859
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiGOUnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiGOUmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:42:51 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF06688CF6
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id i9-20020a17090a65c900b001f03395643dso5754668pjs.9
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+qR0uj9gXOWol3Ut+s7ac3HzpVaWBG1IEuybUOvSxq0=;
        b=C6KjJiMxfi6TfcrSpg7drl9YK/LsDK/v8OH6X3SiR6jz1s3rb8YHxjWdg+OXmFsAUu
         vWh0XYxH4JUpfIcLDuduYIGX2oOus0G/7WQ6R8FfzoiYl+4Qnm2mYw00V4FgPoSU96qx
         /OKP3S/kpJxqEJa90NwGgTedyifKoIWLiZotp8jZfG85+90TEDZZMKiwOShsF0QOESKW
         IUFv4fe41b2FSsV5zovagvyDLC3p46xp8f47/OpL2QrXNF6vv8mAJ4sdCrzIiDutbsx1
         FlU7gDbBgDI5wKcB5U6f0L7qlp+nzMnBAeYbdLahJHOvoXWBqGzQ/yMTj6/S1kyUoRKL
         GPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+qR0uj9gXOWol3Ut+s7ac3HzpVaWBG1IEuybUOvSxq0=;
        b=fYYK0PLJnCcJK8oEpDqz+/K5HIX1rL2nzqnK7z9u4mijxXC0SX0nqJ6RJKzR98qSSB
         7SXHJj/dFQSQDyGkniLZZDStO93Hrwogd30H1pBCCYXdyUrqfvMlTu/7dHN0Wm3Dik/X
         1iK28oM9w4atji4/wiyA+xahL1+uDA6koIVM988CsZfcPGbZdjAW+UFtk+kgKTKQG+T1
         MYjeZDuhtBK2nEP8L5tzheIoHdRb0IEUotC0xkHe8hMtsYnVK6Z0OxwBoBasjTZymdKq
         QNjzFQMt4zXohviu1Bnx7Q8eGB355HlCvlNP6GZZMW3YhSfuIeDBkxaC5tATwhAiXKpn
         CF9g==
X-Gm-Message-State: AJIora86yWEUn3/sj0Ct2Sf3/UPXYdmJZ4m256n2gRZFYJSes9Yl/2Bk
        zdmk/j5/g4VzNnfzwUoCQ0306rxvFW4=
X-Google-Smtp-Source: AGRyM1u6kpeizk0sTrx9oLthKLn2xlFlo/YmGOxFoXKdKdg+H6gNEeavaMLO/1TsQ+Hb3EMEGoPBKMPdG2A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:17aa:b0:52a:e94b:67e5 with SMTP id
 s42-20020a056a0017aa00b0052ae94b67e5mr15999481pfg.76.1657917765969; Fri, 15
 Jul 2022 13:42:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:09 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 07/24] KVM: x86: Use DR7_GD macro instead of open coding
 check in emulator
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Use DR7_GD in the emulator instead of open coding the check, and drop a
comically wrong comment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index bd9e9c5627d0..fdeccf446b28 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4181,8 +4181,7 @@ static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
 
 	ctxt->ops->get_dr(ctxt, 7, &dr7);
 
-	/* Check if DR7.Global_Enable is set */
-	return dr7 & (1 << 13);
+	return dr7 & DR7_GD;
 }
 
 static int check_dr_read(struct x86_emulate_ctxt *ctxt)
-- 
2.37.0.170.g444d1eabd0-goog

