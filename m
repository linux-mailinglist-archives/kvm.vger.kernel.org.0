Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395093F7E8E
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhHYW1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbhHYW1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:27:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40298C0613CF
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c63-20020a25e5420000b0290580b26e708aso1019759ybh.12
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gBBpExPHBrD8wHL5W5GLEX4v/zMlifXeaXLoHzlAXzE=;
        b=ss5I9W1PhylNSSY92ktjAWoi5tHeOhSb5qXd7sLgq6Jxl5HohnI479i3IJ1b9jML6R
         edIlLBaSxHF/jKdGak4tUrNTOu0vDn6/tTK4Kfv0piZNxGyt/NGk49RyZRl7ciepRCxo
         xkdeqmGWjDSjHHbv7x1za7yqIeHaN42WyfJ6H4jjRpZsK6BW/N+xnlzQUOiqATX8lOt1
         xjyTz/f0EYtfayVGZsb9ZWLEyeiqaccLX0aXRqsER4eQK8TYMRw+S2uLEgXpg8oNFLoK
         lIGT1W64o4w28ImJR8R8nJPDLT0jcw/cQpqSQjPvclAlmo1FVQedW4BgTXVzEydL8xdc
         Iv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gBBpExPHBrD8wHL5W5GLEX4v/zMlifXeaXLoHzlAXzE=;
        b=e0n/cGYBdoZunSFpwk07MsvboSSmi3rHfo6QEis3zKETm4FwhfZT1NcHDLxzbmpKsv
         9QN9wZmzH52oHGz6LFQsow+0vxMy97VZKwAzn6/rwMiptKwO5OkHmiM9JAyjQfqZp9ui
         L3rDNLHTUNhgv56cY0zT84Z4iSKCemtDGvbr27gUOAJ7GziGzNwjaFBsadd/xUU4kp/u
         /GREOYSOwN9Y5ep5cED676E0c6STZhPNvtVnyHMHDIUECc3wiklMPE+ZF5S3BplolXot
         o8RPd6q8V7pPtUOiWsIsfD3oGQOXcRJYrtBSGfQZastKEd1QWWJV6zANRAz3SQBvRg4R
         V1Nw==
X-Gm-Message-State: AOAM531UpL4J/UegBpNOZN2ekXPo3y0Drp2fTt6pve7XCM0bhj34ldNK
        WzCsbourhe5Pt1IJHKWnzRs2Y2VTcvUOWmdYPrvJ86oADd9fby07IQdfVFqndE592yGtnTJa4mz
        yPf/M6oU2jr6WYdigHMJddfO+IjeFhjAxvw69BauftKXLjAjp1oR7Sg==
X-Google-Smtp-Source: ABdhPJwcCWfMqABzG4jvaY1TarWT3G+7rEX4Dnxk6DwYhCudo24tEZ3bgYc8xM9WFK6GfBZ2y5agX4utPw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:bb35:184f:c54d:280c])
 (user=morbo job=sendgmr) by 2002:a25:7a03:: with SMTP id v3mr1291556ybc.202.1629930385434;
 Wed, 25 Aug 2021 15:26:25 -0700 (PDT)
Date:   Wed, 25 Aug 2021 15:26:03 -0700
In-Reply-To: <20210825222604.2659360-1-morbo@google.com>
Message-Id: <20210825222604.2659360-4-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 3/4] x86: umip: mark do_ring3 as noinline
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

do_ring3() uses inline asm that has labels. Clang decides that it can
inline this function, which causes the assembler to complain about
duplicate symbols. Mark the function as "noinline" to prevent this.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/umip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/umip.c b/x86/umip.c
index c5700b3..5ae6f44 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -114,7 +114,7 @@ static void test_umip_gp(const char *msg)
 
 /* The ugly mode switching code */
 
-static int do_ring3(void (*fn)(const char *), const char *arg)
+static int __attribute__((noinline)) do_ring3(void (*fn)(const char *), const char *arg)
 {
     static unsigned char user_stack[4096];
     int ret;
-- 
2.33.0.rc2.250.ged5fa647cd-goog

