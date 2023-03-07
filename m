Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1B06AD385
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 01:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCGA4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 19:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCGAz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 19:55:58 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E72A5D88D
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 16:55:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id l24-20020a25b318000000b007eba3f8e3baso12171599ybj.4
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 16:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678150554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2YcCZvGg7geMfj1VGWaT5nq1sgh1HoUun6qGGNv1Ghw=;
        b=iK1I+L9k4sLfdj/yydU1+EAfbCY26tEmAqfUg1ToBsz/ahqhuiz6+Apo6VOfBjOFou
         qRDpsntLI3X/tAl34niMkBTom88xUTQyQmNqhxa4RvecxLYJAuA7BzeZ8YwDPn2YWbwL
         lEYLEWZde3xpylFVtVUhAxI+Xu1SOCrKlPreMNYKb9Fi2Y4Xtj+EOTPBXeSUzDF8FxRI
         g/duR+Kp9kvzhmKUvdEq+T4mfI/Hyk97fLiqNhJYcfB8P07EJQBz0yXerJG02dR9XwaW
         F+AZBwVGSSu0o+edtDywkfSSbsCEcWeH+TP2R4+KR/vR6pAoqG0Ck6rx3RYVFZhPPMWB
         CdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678150554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2YcCZvGg7geMfj1VGWaT5nq1sgh1HoUun6qGGNv1Ghw=;
        b=fW7mk8213MUv5kauIWj1whwoimQ3FsfZH2qB4mCzdBHGWrrdfbbdQennuTmoNfO+/e
         xzpb30HIQ8mElEW0bkuBei2VmAsvwgeDP8Q/YooeSZ3DtMxbpmIYlc2n8r2dOR0G5K98
         ZRQj5/a3PBMbMnJ48JsZuDOwgBPX5hD8jaY2oNtHG4rtHQdeHDaEdz5Ac07itnyZVkz8
         ykzIHv+GD6S0QS0wIFHIk3V+aC6B8q0XTqE2R04eMiQ+GxGdRG7aDnZi18JeknveEhHS
         d/hUMWupeDEvZfwLKeNyHKQ+0qUrmTLlRe5hY5hYVH4KxYxaQXvyQiKoWYs1K7r15HhF
         Dvjg==
X-Gm-Message-State: AO0yUKUj8K2FyPdUd1uinzO1dFq2ZfvrVTk26+26GZFjVqaDW1LZqV4l
        5RJ+POznXrRVFtxub6CCz/qy2ShfMVQ7Hg==
X-Google-Smtp-Source: AK7set8QmIFT7s4wTBLb4xpg4mQtFCuNCY67TSY3h6Gs7svqIpLXgm3/ngEpVOeeCEqT4YkoIedTNRujnV+oFA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:1cb:0:b0:aa2:475c:2982 with SMTP id
 f11-20020a5b01cb000000b00aa2475c2982mr5938573ybp.1.1678150554320; Mon, 06 Mar
 2023 16:55:54 -0800 (PST)
Date:   Mon,  6 Mar 2023 16:55:47 -0800
In-Reply-To: <20230307005547.607353-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230307005547.607353-1-dmatlack@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307005547.607353-3-dmatlack@google.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: Mark RDPID asm volatile to avoid
 dropping instructions
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Greg Thelen <gthelen@google.com>
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

Mark the asm statement that generates the RDPID instruction volatile.
The compiler within its rights to drop subsequent RDPID asm statements
(after the first) since the inputs never change.

This fixes the tsc test on hardware that supports rdpid when built with
the latest Clang compiler.

Fixes: 10631a5bebd8 ("x86: tsc: add rdpid test")
Reported-by: Greg Thelen <gthelen@google.com>
Suggested-by: Greg Thelen <gthelen@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 x86/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/tsc.c b/x86/tsc.c
index bc403fc78461..b3bb120291ec 100644
--- a/x86/tsc.c
+++ b/x86/tsc.c
@@ -24,7 +24,7 @@ static void test_rdpid(u64 aux)
        u32 eax;
 
        wrmsr(MSR_TSC_AUX, aux);
-       asm (".byte 0xf3, 0x0f, 0xc7, 0xf8" : "=a" (eax));
+       asm volatile (".byte 0xf3, 0x0f, 0xc7, 0xf8" : "=a" (eax));
        report(eax == aux, "Test rdpid %%eax %" PRId64, aux);
 }
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

