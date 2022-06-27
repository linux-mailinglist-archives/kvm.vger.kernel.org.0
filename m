Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ED155C160
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbiF0QLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238976AbiF0QLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:11:34 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B422A1401A
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:11:33 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u6-20020a17090a1d4600b001ec8200fe70so3808973pju.1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Vm6CWKkk0vcBM/ITT9ZuqNZ+NsRI70iKvi8Vcwr0ZgM=;
        b=diirC/5qOh5uYJTxN16TQh2neQoqsxwBtPnFQJsGuMvEm8vHrIwK39WhNR2g0cqEbs
         iM+FTSlvz5uyfSw3GS2j9tD4BoAJCw6M4Og5RGUAfA0XlnnSdc2XM/HnLdSi+0JTBYz3
         AJgWQXrU8f8I9+ciC73qOL5zr1wth4UIlcS745o+0YchmjRHRtjh1/p4uhbie+DZsORO
         UVZjkRwJgb/P5TCLR/WoxSobLTFBvVt+eBGPq0//lEA+fF4a7D6eIJ8TrdJYeRROv6dA
         N4P3t3i7UgLgA5cdQ3wCROo3MdhGPpYHVPgEonYFkdzZJv0IMV3uHgSGZ92eqd9dGJMi
         sbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Vm6CWKkk0vcBM/ITT9ZuqNZ+NsRI70iKvi8Vcwr0ZgM=;
        b=TRQ3mP2qYlmUx54WDMMbaOf3UCkHSnftQ62VRd0EFHZAqYWfK2YaE4nqlUy2PVKeLd
         c81HkixOc0raQWeCm9SjpT382mK5yvJRmlPC7tG7fIMvrNgx+f8IZ0H66dtzFZ+/UTRW
         b+lrKOJ1e0EEtiXeJrmXZOuszcCHG08KhHxaMyR0MQiVvngl+sO5z5AlpfiG1htfNARb
         U84JJjQEMBKh8wxkHS6DoqeF+uzv6dcnvCc29bU3LRgU8qAFK65iXRhtB26E+7LYUaeL
         VDdqyit4E5sRIb3go5B8ywfpYaxerQrH7MxDQ2VHaUNMzwoDYFbQfUFemK6rN3+Z825a
         Ppmw==
X-Gm-Message-State: AJIora//qCKAJj780OESKAqLdIg1l29T+dnScaddlcMyJ8zWK8diHa0W
        7Uq0vYeAyL8JKJ1ZpVeEXQXnLqBd9fAzy7uc1LmhSBSipj4IlRLsS9Ch34qt9qaVr9G/cSO7hMp
        cLvBgq6d9Kegi0w2HNEfNXAX9kGgSFRwvtGejAxy0yjCtiTfjlPx1jjY4Ow==
X-Google-Smtp-Source: AGRyM1vRLsrdEX5T5LTgKzTKdp4koUBPD5WaxEgpNNeV52DzErfcRMso70mxbkfDSHIYLLuf26P+KyudkbY=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:947d:e037:1597:c48e])
 (user=pgonda job=sendgmr) by 2002:a63:2bd2:0:b0:40d:62e4:b880 with SMTP id
 r201-20020a632bd2000000b0040d62e4b880mr12861030pgr.488.1656346293145; Mon, 27
 Jun 2022 09:11:33 -0700 (PDT)
Date:   Mon, 27 Jun 2022 09:11:23 -0700
Message-Id: <20220627161123.1386853-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] KVM: SEV: Clear the pages pointer in sev_unpin_memory
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Greg Thelen <gthelen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clear to the @pages array pointer in sev_unpin_memory to avoid leaving a
dangling pointer to invalid memory.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kvm/svm/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 309bcdb2f929..485ad86c01c6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -452,6 +452,7 @@ static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
 	unpin_user_pages(pages, npages);
 	kvfree(pages);
 	sev->pages_locked -= npages;
+	*pages = NULL;
 }
 
 static void sev_clflush_pages(struct page *pages[], unsigned long npages)
-- 
2.37.0.rc0.161.g10f37bed90-goog

