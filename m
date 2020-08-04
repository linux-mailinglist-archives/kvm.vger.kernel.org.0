Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A81723B3CE
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 06:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgHDEVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 00:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgHDEVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 00:21:06 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6712C06174A
        for <kvm@vger.kernel.org>; Mon,  3 Aug 2020 21:21:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r3so3366795pgn.12
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 21:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y+cK3yK3on3iaDXKq4Us8jdSuqq9Ku70bGtopQ6r1/M=;
        b=eKj0lvct4BxJVjKtvPVEob3BDhRfV8xMTYTzuVZaVp2AjNsGHVVGqiAeJXoexpF8S2
         NympPWYf/Xlrc8R+KwnMVKX7M8jacZhIHqBXFUjZt8I0/9fecqkS1N/v3rxRM+LmgBdh
         +MVWow6OEfNr3wQk2R3HLvERuB1Vs/UenkLIfjJbPNduWKiPqUTa04zLaWCX7soXGNUc
         o+GGrfQ/6I9YT9hyCaoc8y1fWNyCztI3e8oAgbdGB8tXDByycPAgf+Kj/j0xV8KA3BH5
         JDwksX09UR42V7P/ymKUrV33Crs3pQhVbTW5bsF+8k8NAapfpVl/W074EaFH8kO5lty1
         9CVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y+cK3yK3on3iaDXKq4Us8jdSuqq9Ku70bGtopQ6r1/M=;
        b=FTwN9eBVYxsqIUuoS4MVEpjZ2wmWchiRKvzCLgvIgWTl+YPvd7Mapecg2/bqGXP0uW
         8ya/Gu9PfYhZFN8jek5RKZV2LJZ1dDhCl//Gs/a0GrlKssVQPHuyH7M/P1r5l4DhIBlU
         YFDUzGjJXkt/iX4gYNtvPyinpxjVIVspa3QwqUyA4B4CPUI+BK/sp1hs9EAKom5qMsTi
         tX4DiwayCQ1sCLybTsAi+ONjkVGpDa90uurVvz2IacY9RzLHM09Yybcv6LCy3lsdA49j
         L88ho2E11Xb6xMxmWb3TxZ7jA5JzrBElNUO8rR+8CEIYdUeUvAIr5E3wxVKFR+0+bm1s
         6GNg==
X-Gm-Message-State: AOAM533ErQ5lS29hvM2YKl7EN6wCPpfr1ymTrF94ePXAhtoFGHislQ0W
        fPIPXV8Sgj4J3E4gFtqyko2sv3/q20Rq6XGl
X-Google-Smtp-Source: ABdhPJz0nEpga0d7QY4mJoDD3tqGN0OiU9OHEGTNE+LAADeOSBTw47613gynb5KKLp1x8bhw2nij8JiLHx1SfgGY
X-Received: by 2002:a17:902:368:: with SMTP id 95mr18050978pld.279.1596514866344;
 Mon, 03 Aug 2020 21:21:06 -0700 (PDT)
Date:   Mon,  3 Aug 2020 21:20:42 -0700
In-Reply-To: <20200804042043.3592620-1-aaronlewis@google.com>
Message-Id: <20200804042043.3592620-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200804042043.3592620-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH 5/6] selftests: kvm: Fix the segment descriptor layout to
 match the actual layout
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the layout of 'struct desc64' to match the layout described in the
SDM Vol 3, 3.4.5 Segment Descriptors, Figure 3-8.  The test added later
in this series relies on this and crashes if this layout is not correct.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 82b7fe16a824..0a65e7bb5249 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -59,7 +59,7 @@ struct gpr64_regs {
 struct desc64 {
 	uint16_t limit0;
 	uint16_t base0;
-	unsigned base1:8, s:1, type:4, dpl:2, p:1;
+	unsigned base1:8, type:4, s:1, dpl:2, p:1;
 	unsigned limit1:4, avl:1, l:1, db:1, g:1, base2:8;
 	uint32_t base3;
 	uint32_t zero1;
-- 
2.28.0.163.g6104cc2f0b6-goog

