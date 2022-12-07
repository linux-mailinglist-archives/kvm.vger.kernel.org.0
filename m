Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2938645996
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 13:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiLGMEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 07:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiLGMED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 07:04:03 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E3030F6F;
        Wed,  7 Dec 2022 04:04:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id q15so16346400pja.0;
        Wed, 07 Dec 2022 04:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B48Bgebo64pDPnErOoGn8kP3QfjuFIi7+ZxgDnij3iE=;
        b=ilVdd8D4TxYIzE2AdIA34SYk+96BVbuc6gXJ6ULKeju93aqfrB3raseRvN11x3CuY8
         fOe8wFXBz0mUn+D4C+y+exGD+tw3MKnTbfVfE0RU0vrTr9m/qZFmI8wDn0EzB6XBXXgy
         Cvg/AX0+QZ5DT3PHi5a/xrBbcGzUpMv4wFR2+e9vF8q1e8Klcu5pDKqAg7d+KFmiy8gV
         G08nqA9pm/bU5DA2RVeQRHm6Y1xsvggIrnl2fW7UMPrEjn+FLMaiI+F3t7j/Sqgr/yqC
         N3AdF9dVmYU0naybqat8/JQzFOCaIm0SH+BBUpZPush8/xfGo6C5hWpMF6BD8My/8JfE
         mXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B48Bgebo64pDPnErOoGn8kP3QfjuFIi7+ZxgDnij3iE=;
        b=CjGtaCTaBXYjTjG/MpMEzQF7+poEzbjNLT7u/+QoLkKa2yKU9+H6sfKblJLXbeNzkg
         wtkZ0P+Y1jslnwXAmC5VlV7D4j8402KQAxN+L6p2F0l9e/oSWwULu27TQxMoBuZkZhUG
         iWhhNFjCRku//EVi4pQnXXQp5xS5hZBD8P/56JzQPHOH+SDScE2HsufSOINClDGfn72r
         KUxa+ivxDKfH+30RRv97RSSIwXUCvTe2ygaKTCDzGeym3OfHz5d3rWmIzon30eqDi6Vo
         dBgiDBISxru3D5YufSxbtb2P0Bs/td1FK3khTxYtE327ht+gqTJipX9qdXBGjgRk6zzs
         26zQ==
X-Gm-Message-State: ANoB5pnYfBQo3N21bQcAQzUkBnhM/4aAIzsMCTS5S0Kr4qWf3/eG7Hbe
        1OxSKry2f/38e5fWYvoFtr0XUBwKAc0=
X-Google-Smtp-Source: AA0mqf4FYqazemg7UUTOvHMmpmMEjWrm28Tc/gxwvgGHaTBHvkz/5Dscb/0tBixzLE3FWCN0SXTaKw==
X-Received: by 2002:a17:90a:2dc8:b0:219:baef:3ba with SMTP id q8-20020a17090a2dc800b00219baef03bamr19131172pjm.6.1670414640533;
        Wed, 07 Dec 2022 04:04:00 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902ce8600b001743ba85d39sm14501473plg.110.2022.12.07.04.03.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Dec 2022 04:04:00 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH] kvm: x86/mmu: Remove duplicated "be split" in spte.h
Date:   Wed,  7 Dec 2022 20:05:05 +0800
Message-Id: <20221207120505.9175-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

"be split be split" -> "be split"

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/spte.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1f03701b943a..6f54dc9409c9 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -363,7 +363,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
  * A shadow-present leaf SPTE may be non-writable for 4 possible reasons:
  *
  *  1. To intercept writes for dirty logging. KVM write-protects huge pages
- *     so that they can be split be split down into the dirty logging
+ *     so that they can be split down into the dirty logging
  *     granularity (4KiB) whenever the guest writes to them. KVM also
  *     write-protects 4KiB pages so that writes can be recorded in the dirty log
  *     (e.g. if not using PML). SPTEs are write-protected for dirty logging
-- 
2.19.1.6.gb485710b

