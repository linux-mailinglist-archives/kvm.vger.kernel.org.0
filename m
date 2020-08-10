Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9BD241177
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 22:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHJUMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 16:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgHJUMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 16:12:00 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884B7C061787
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:12:00 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id q4so8028046qvu.6
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sOMEn0K6jrOMRw0X2/vhJfeR19zk5k6nzsJWKIT2bMI=;
        b=D/WXZF2cCnwUnGp48QIWtDV5bjcR/HTLtaUAvPbpIz6KdSssYsEIKehsmc4bu0lbhY
         Az2qtcq45T2Xyi6VrL+RoWctqnhTEpsxQW3ueZAKyimfRpp8T507AUfVOh0efkHRM5lD
         ZmhI0/KdA1yHxmxRwv+PGnGzzv8GM0vQWqbrHRAckRU6Wn4h54WABUz2u96xrYJP13PT
         eNujUZPdX2MzDpP130PYjcjFyporw+57iZpotLdhYD0Ev9WzZq1VDdEtlpyAIiopmIr6
         O1QaSLY95kjPsludhdl8lEx/+o9ulke9a+tgSYi2z/W+dv6Ijm+XtH19fPaDb4vYf/tK
         sUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sOMEn0K6jrOMRw0X2/vhJfeR19zk5k6nzsJWKIT2bMI=;
        b=qCDvYUjYcwEQfbRAK2Jdn6Kmt3uBEb1LkWhXdAxztRlt4RciNKL+8Cy1JpCn8igXCb
         /fXFW0MKZAvpkjP0Vk4Br1GjRu34ieRzcJXRuVsbuh3hllLxTK6zGehSzjts8RWFldY8
         agz9Ppy1v0pnPgA3AKAbpRa4Y4UuOYvtwAjfWpWCc2A8AplPyS8fNgAtTiXfcAIsMstB
         iHEWZWRWstadyLCYBL/fkPkeYsP4mWORpKwW73N6FvvGvBcoN4D7bkDfnx1wdLx1CMyL
         wKIhjhgw7RR7J1q+gRJXFc0+UxUnwEyDsm5L4bZWbhwsXmOTOMvKGJJ8Hc2SpHbDdD6o
         OFtw==
X-Gm-Message-State: AOAM531fg8CDO2WYlFsHmNbWXgxoN4TtIHGa3cQEbkR4RossOHNqkG0B
        RZETxiMgQl6FeHyQZ7+cPXV1kEtZgSMUpunV
X-Google-Smtp-Source: ABdhPJy6B31b9vrSrqvw6DX91UL6tvZ558B+TUkbnxv3Xlnib5JClzxPe+lOslCkuyFT4UJFg49PmFkcDOowxBhz
X-Received: by 2002:a0c:f6cb:: with SMTP id d11mr30964423qvo.84.1597090319517;
 Mon, 10 Aug 2020 13:11:59 -0700 (PDT)
Date:   Mon, 10 Aug 2020 13:11:32 -0700
In-Reply-To: <20200810201134.2031613-1-aaronlewis@google.com>
Message-Id: <20200810201134.2031613-7-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200810201134.2031613-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 6/8] selftests: kvm: Fix the segment descriptor layout to
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
2.28.0.236.gb10cc79966-goog

