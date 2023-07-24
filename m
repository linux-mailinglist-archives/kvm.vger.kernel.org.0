Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AC075F498
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 13:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjGXLNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 07:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjGXLM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 07:12:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4622C90;
        Mon, 24 Jul 2023 04:12:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-26813cd7a8aso630553a91.2;
        Mon, 24 Jul 2023 04:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690197176; x=1690801976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Ys9wsAPg0+pztFlVDRsU5Q6zEu7VPdrAJWtiMgaW7g=;
        b=NjQTDn3wXm9+uqjSSxUbK5b1TUQdIXQE5ygq0ZyhyXAgpf424nKWwSiCs31PRhogtP
         kRWA1fF5ZSR3U6EvMfmALHvRp0BET2F1wB6ZdbRAwcXjONio2rYS6CkKa03prZP4iuDG
         CbSh0PSF2D4qnE8wWFGyqHzkdZgfZgt+MIIWJtfkOdiOFMNYSTWUzkdxblzJ8Ed+K4/e
         daIkbr1XkyWqUeSfH84qD9E5xJdYEnVjDagrKG5F65r6fdm20uByHCBWwU0qU4riAD1H
         7qhvBjHSOWZU1i+Swps1pa3wwlHxpusEGXOygumhPHgY+ugjpWPbNjnXC9OLyPyklBKX
         WmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690197176; x=1690801976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Ys9wsAPg0+pztFlVDRsU5Q6zEu7VPdrAJWtiMgaW7g=;
        b=STdwMHTBuIufyCQQixxrXqvMQkGUlksGCbvJfPavjWCQO/T0A+6ffQQFABthtumlDl
         +TKC5vt45IEG5B193VYaOs+9ntRbJy1+m6pb/MKbt1Dbzc8QcsL6v1tcEW+WFyTDlfH5
         Z5DfLP70Dk7MeUK/A2Ggp5yIDYgAD7TBso3SyQER1CuCtMwbRPLFjVdzXpgxbmieZpPS
         Ih+x+R0qCJUxYaRP1bZiCr2tDhsYhXrnRKM5hom/WDgoyx5A4kEVyFGLBX6/FduLofvU
         /zi8F0t+EMFOJk9ReQ62Vl14a8qxvlcaG4//A4Hl9yd2fee3XZXcy9WSPoQV2WH05f0U
         FBOw==
X-Gm-Message-State: ABy/qLbUFNH+3C4KJWti9GIK+/WpcKVfyrjvFu9GGyRpacbITYpP182e
        oSMfovySFDrJU/0sSQyXoq0=
X-Google-Smtp-Source: APBJJlGgkiR0IQ3pFFWVNAJ+RdFQSwG4eXJZXDQySy2xQxfLn2R1CqxiZG3KTyoQYhHY7vs8YK5s5w==
X-Received: by 2002:a17:90b:4c0b:b0:262:ffc4:be7 with SMTP id na11-20020a17090b4c0b00b00262ffc40be7mr10371019pjb.37.1690197175665;
        Mon, 24 Jul 2023 04:12:55 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 20-20020a17090a199400b002682392506bsm990380pji.50.2023.07.24.04.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 04:12:54 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/irq: Conditionally register IRQ bypass consumer again
Date:   Mon, 24 Jul 2023 19:12:36 +0800
Message-ID: <20230724111236.76570-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

As commit 14717e203186 ("kvm: Conditionally register IRQ bypass consumer"):
"if we don't support a mechanism for bypassing IRQs, don't register as a
consumer. This eliminates meaningless dev_info()s when the connect fails
between producer and consumer", such as on Linux hosts where enable_apicv
or posted-interrupts capability is unsupported or globally disabled.

Cc: Alex Williamson <alex.williamson@redhat.com>
Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217379
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..8b68a5cb3123 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13185,7 +13185,7 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
 
 bool kvm_arch_has_irq_bypass(void)
 {
-	return true;
+	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
 }
 
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
-- 
2.41.0

