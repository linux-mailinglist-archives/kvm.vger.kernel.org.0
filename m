Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B55F580937
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 03:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiGZB7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 21:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiGZB7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 21:59:54 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8102724F38;
        Mon, 25 Jul 2022 18:59:53 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id i14so23155023yba.1;
        Mon, 25 Jul 2022 18:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=NdgKT6SaTNKojgfJKfqgdSqd0oell3o88UU1+M+qARk=;
        b=fP04uaUslXBC4HLEh6pnlc/6exHv1c931okXhMEJ14GNRoHWA4vUqSN2UV2LI4voB5
         XvTDksTc2pKhcb30xKVp+7R6E7yS+XRTtnjkctxUMNUYN8fOg9V2iCQm8KQ4EidlXGPS
         Xd2wdWEV/2ILHel8ezE90gFqEn5/sSKfDR2uh+3DM45BTj30Gq4lDRS6sVDIi+lksUK7
         hTIF38Z1f4Oieo6Rm3wVUICBoQSqsITeyYU1mw8g1GsM4N161ub4x2LCzt4W6TGPE+6V
         fkGuV5uaHA1gM5nePU1Dh0Tty9AGWO7zLgNuD5PFSbCapT35WugLQBL3Ad1uQFz0HToh
         KhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=NdgKT6SaTNKojgfJKfqgdSqd0oell3o88UU1+M+qARk=;
        b=5Xj93no2TulCJZ7dNdCSVeSef+4RjWrJuZV39ePjbm4fNudhPMcWoomNdwJ64dbzRD
         aEsw7vvfKqHWOpLsQQgZ5Ba2FCrvDRxupJIrCEXka1NMJEKT+Dkf1gBS3v7Bh1up9LHt
         KFOb6S7ofiozWjp0vdUc3D641XPGMEpRNAJ9tYfUIriUDAv+0b/IIzMQpIQAr5tBTn4E
         tk3qjR3gry3FyenPjdWGzDKWs4QDM99mjucMu9d3rNrSyZkWAn0RTcevUMBG3JJQebLI
         Jyi6nCPeeCw4mz5UM9ArrN7mq3E8N2BDBWY50MJahGw7nqY6EV/m67sttg+6ZJ9xGTSq
         8AZg==
X-Gm-Message-State: AJIora82nNp3cLyyP2BjuRsmPDT2iTwEIsIDG5jpBo6ysiq6oBn+4QGA
        K8rwZH8Mjeho2FGZ5IRr8W3F/rqGPj9C8ayTTCWzwoSmGmBayw==
X-Google-Smtp-Source: AGRyM1tFXzOkg0Laj0r40uCbyfV2vxwXs+n86QkgRZ0klUyBGCrxfFzDyjuBFLsdHz/cUq9Ruo3IUN5NfmQVmhVtOZc=
X-Received: by 2002:a25:9cc5:0:b0:671:5732:a446 with SMTP id
 z5-20020a259cc5000000b006715732a446mr3803099ybo.347.1658800792806; Mon, 25
 Jul 2022 18:59:52 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Tue, 26 Jul 2022 09:59:42 +0800
Message-ID: <CAPm50aLYb9+wsm3WA8buhC+ePfR6TrGbDR0nMju+bLzf0Tozuw@mail.gmail.com>
Subject: [PATCH] kvm: mmu: Simplify judgment conditions
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

kvm_shadow_root_allocated() has been checked before in
mmu_first_shadow_root_alloc,
and subsequent kvm_memslots_have_rmaps() does not need to check
kvm_shadow_root_allocated() again.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 52664c3caaab..ecd64c06f839 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3584,7 +3584,7 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
         * Check if anything actually needs to be allocated, e.g. all metadata
         * will be allocated upfront if TDP is disabled.
         */
-       if (kvm_memslots_have_rmaps(kvm) &&
+       if (!is_tdp_mmu_enabled(kvm) &&
            kvm_page_track_write_tracking_enabled(kvm))
                goto out_success;

--
2.27.0
