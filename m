Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C43E5FE410
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiJMVP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiJMVOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:14:47 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EED192D81
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:51 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id il7-20020a17090b164700b0020d1029ceaaso3952719pjb.8
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ayk7WF1bhRdGwOMvSXaXxnD19B/O1/9Is88g4dKNZ4g=;
        b=RGZk+Vdb53lCuSorY1wAskL95mWskPoDQmOT0OPifoQMxC88+I+sUOzBcNwM2ES118
         iW/lEHriL4Qg+SyNCkAnOE/F6nkNbWpyMPrn2QueInKh5I9bN/usi/JiSlITCWwhzV2w
         F6RhstB4XKOktzSjRK6gkJVtWkzoAHgddgAk7BJQH6HKFMpgykXSfdeLSPliTOAoC2SU
         OhvYMmXuZ77gQ7BXD0oc1vhaLxjItBGg0M0MZ4A4tbio5n4WSVH2CZsZU9ZjKFIddh25
         2ojCOWdDUXvoEAgrXLJgd97RPQuSVYegtFiK5TFLdLpOqU8FtEIs1sigEXVw1rFG6IsE
         rsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ayk7WF1bhRdGwOMvSXaXxnD19B/O1/9Is88g4dKNZ4g=;
        b=FJU1B4Tfcixy6c8aTS41+t2yaF4LBSNFzhLI9aXxUyHMIIp2A2ESL75PuipIabZaGA
         J6ThO397S1YPvo0tx50MgvtdGoZkQkoeadpQGi+TEOs2Od9brn1HZgS6SoH07vlG6F1U
         CZD1vQ57zLiZjT7BkytWnevCG3HqqAnBQad9j5QUnIxDRbXacfJwfiL+MLOrdzMeDCLy
         jkqQI+EpVDS1whWxdSbanKpaOl1kxseKJLQs6sUz4IfvYc80bN8fXWqa0ZbEA04KvaHY
         htzpfFLi/lf6RFcwXVwJgw2M3BtCUvag+28YkOfEDKFYMvtzRDZKGFhEfffr+vOKcvQd
         Hvig==
X-Gm-Message-State: ACrzQf2Y2Jg9zkhBCuzvUXe2nFbZ3QHjBr/1wCo6Oe2CTx91SeS23IoC
        5cqU3H+cGZG/vndTrwhgJXpCsGXn9oo=
X-Google-Smtp-Source: AMsMyM6tAfauzbLm9EvaoW78suvTos1Ey2Zysy7ZW4jVb6C5cbyn4fHYulzadh7ri04uq/mtbeeyli3ZBZE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9614:0:b0:562:b07b:ad62 with SMTP id
 q20-20020aa79614000000b00562b07bad62mr1641934pfg.79.1665695586079; Thu, 13
 Oct 2022 14:13:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:34 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-17-seanjc@google.com>
Subject: [PATCH v2 16/16] KVM: selftests: Mark "guest_saw_irq" as volatile in xen_shinfo_test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tag "guest_saw_irq" as "volatile" to ensure that the compiler will never
optimize away lookups.  Relying on the compiler thinking that the flag
is global and thus might change also works, but it's subtle, less robust,
and looks like a bug at first glance, e.g. risks being "fixed" and
breaking the test.

Make the flag "static" as well since convincing the compiler it's global
is no longer necessary.

Alternatively, the flag could be accessed with {READ,WRITE}_ONCE(), but
literally every access would need the wrappers, and eking out performance
isn't exactly top priority for selftests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index caa3f5ab9e10..2a5727188c8d 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -132,7 +132,7 @@ struct {
 	struct kvm_irq_routing_entry entries[2];
 } irq_routes;
 
-bool guest_saw_irq;
+static volatile bool guest_saw_irq;
 
 static void evtchn_handler(struct ex_regs *regs)
 {
-- 
2.38.0.413.g74048e4d9e-goog

