Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F4969B526
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 23:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBQWAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 17:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQWAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 17:00:15 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F32D5CF0B
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:14 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y33-20020a25ad21000000b00953ffdfbe1aso1889981ybi.23
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TJtZTJ5JPqffWwmGPbVek61zu2r3MSyWTFGKlIawwkM=;
        b=iKLRxe0rf3EWYa+Pt1E8vG3dn2F4qcuf/e3ku6voeXWUjIbyEYEksXTUskxcMFzWDI
         fr5h4Rf3Akchs0uVv2Ox2wsYCKIzWWNklfgWUGf3jrMvtz9VsXdPeWh0j09VzcFXRTp2
         9xevs/y81AjTSE41TU2UgO+aKiWhvIBvms8F8XlH2u9IJ53eyuwPlBaHIsFmzb1WOkyO
         mc/DU559ErQBrWWeKUymiSCRCVHYauT68xadOSVVNlYIgcQSa2RXGxIHKC4SatbrGxh9
         d0lQVzx8f3oSPNuGDdNTY9cCC68NFcBra6yuBBJc1ldCCAoYqEIRfxg9v1AJalbpLN9d
         l/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TJtZTJ5JPqffWwmGPbVek61zu2r3MSyWTFGKlIawwkM=;
        b=D3foZb2cQCXjkCvifP9C1sfbmEAJMF+QnisHVqApvDt0iCguHUuBjwFuWo1FrDbwJ8
         nuu3wJD/bpseFkdz/h/znKnoxElLhZTV4jFKae70W8C6uUaPkyO680Tub1w+6QFCBsre
         I9KJ4rkM1X6nF1gB1WbhVq2DxeIgUSC8+7MQT4HYNUp1hGOdC70LEK1I9l8bKS3yAQDe
         0moC4Hhzm0VgCmIlkmXEMZYwqoLI7qcoSHdx2xZe4yv7tgyZn2Zkj/UO/AggdxX/KgfV
         TbsHvVTonZOy61o1j/S4YxyFz0uK+vZfwJfWADGOHBOfDopj6bzjsdsEm3ES8y1nsB1L
         xXEw==
X-Gm-Message-State: AO0yUKXzz6rksK2EwFQasMvXADQhuMO2PRHFOKp33Nc0oYVTpTYTn5Vl
        EQ83KCiprORzKhoL9OqeT6KHx2mZlYuafnAsvMYwetT2NkQBjolYHo1eepWLUJpj7TzqQk5LebW
        qrnrDyoVw4CyLO/EP309/y4CAc/nKhbcr6NZf8fk3XNJZsNEZOxiFrJtTYToAesV0PIUk
X-Google-Smtp-Source: AK7set/PPFkFHLKHvAGlrjHFuARA3toeaA9W5KtYV9p1U6BAKLNAMhPJbia/OiEcPbe9LA3awIb0alH4idxmWnGB
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:4f0:b0:98e:6280:74ca with SMTP
 id w16-20020a05690204f000b0098e628074camr147679ybs.1.1676671213425; Fri, 17
 Feb 2023 14:00:13 -0800 (PST)
Date:   Fri, 17 Feb 2023 21:59:56 +0000
In-Reply-To: <20230217215959.1569092-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230217215959.1569092-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217215959.1569092-3-aaronlewis@google.com>
Subject: [PATCH 2/5] KVM: selftests: Assert that both XTILE{CFG,DATA} are XSAVE-enabled
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The check in amx_test that ensures that XTILE is XSAVE-enabled makes
sure at least one of the XTILE bits are set, XTILECFG or XTILEDATA,
when it really should be checking that both are set.

Assert that both XTILECFG and XTILEDATA a set.

Fixes: bf70636d9443 ("selftest: kvm: Add amx selftest")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 7ee8b68064000..27889e5acbedb 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -175,7 +175,7 @@ static void init_regs(void)
 	xcr0 = __xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
 	__xsetbv(0x0, xcr0);
-	GUEST_ASSERT(__xgetbv(0) & XFEATURE_MASK_XTILE);
+	GUEST_ASSERT((__xgetbv(0) & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE);
 }
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
-- 
2.39.2.637.g21b0678d19-goog

