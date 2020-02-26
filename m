Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C297E17093C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 21:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgBZUNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 15:13:06 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:37197 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgBZUNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 15:13:06 -0500
Received: by mail-pl1-f202.google.com with SMTP id t12so350920plo.4
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 12:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RIB7zoLlqFIQoJvqoI2dpWIxGsE/dMGJkqPhxqkMWkE=;
        b=tvBy16g+l1UdG6TNTnJ2Mq7UwRcD9jLdze/j7ZtM8llI83AtzFBSamQCQiyvV9tzXO
         RNGdcZbVTTD5IKQWO52jRwmcXSVzX1tdhQpRiN+MAkYkr7WdFdn9ysBj5Tj9YFhi1GRM
         CNkHJWqNE3o78dnk0P/PxJXWHkr0cHEK01ah7suwahUnC8y41z0XP5A6fcRgUI13L/Sw
         OZqwlI6GWJB2AfC0DjfSYLCBpls74+4bst5xR4fE219ixvo/PQM0my+FAEtRX6RFbefv
         qU/Lgr0Akf6MLzyziSboAWjEPWos/PNrjNxZtVV1o6OZ30eVHW28XzLaODyXYLDK9ClN
         qJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RIB7zoLlqFIQoJvqoI2dpWIxGsE/dMGJkqPhxqkMWkE=;
        b=BjW81TptoQV4F0I/ccPLPdTWTlhVaKzqCSdPejCDtfQmRcz+8VpP3NFJofNRvcFgoH
         3nSMjyX9v0sy/HOCXukbPDjACR07LexdntXM4IE5jemK7qh/g57imHoSViH8oxQFWT6x
         sOkROGlMWzjmIoIWlnlghaepGuexzxrfadjhNw2S+x4WIhwKpmJw44h/lGOi/NEPYjPs
         mliKBieqgZ4otBcsTo4f8xh8YZZPSecI7fwlbAMca2MLIpDFqmZkfGvH24vIgDjcsN+M
         bfKoPx/XJnuH0h1/7155jGMQj8MzHUW/lMbpw2bWIA4/WpbYKSDfHQ2DO/0UhnJVJmvq
         MkYg==
X-Gm-Message-State: APjAAAXuRtLT72FT8pmPnhYo6kzNhfi/HohxONE6uRIsztizu6XcMs1J
        HAA3HfWZgEdHDk8HKjAyPvHLsGIIXZGVNGE1b7RwUirakS0BukiH5uG3f2FXJAPq4UD5l3Y4o2B
        COC4NI9UvdLFW3i3ZVjt2ZsbTDnE/VM7wnQ73Xi0siMpmUEqYXUihnQ==
X-Google-Smtp-Source: APXvYqy1OUTt879OCKhac5X76HmflHSqbTYXTIuLsgQzglZqBNOdO7pUAZ1q+tSVPLhqmJBM8B/eEFxjtQ==
X-Received: by 2002:a63:6101:: with SMTP id v1mr527939pgb.318.1582747985132;
 Wed, 26 Feb 2020 12:13:05 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:12:37 -0800
In-Reply-To: <20200226201243.86988-1-morbo@google.com>
Message-Id: <20200226201243.86988-2-morbo@google.com>
Mime-Version: 1.0
References: <20200226094433.210968-1-morbo@google.com> <20200226201243.86988-1-morbo@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [kvm-unit-tests PATCH v3 1/7] x86: emulator: use "SSE2" for the target
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, oupton@google.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The movdqu and movapd instructions are SSE2 instructions. Clang
interprets the __attribute__((target("sse"))) as allowing SSE only
instructions. Using SSE2 instructions cause an error.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/emulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 8fe03b8..2990550 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -658,7 +658,7 @@ static bool sseeq(sse_union *v1, sse_union *v2)
     return ok;
 }
 
-static __attribute__((target("sse"))) void test_sse(sse_union *mem)
+static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
 {
     sse_union v;
 
-- 
2.25.1.481.gfbce0eb801-goog

