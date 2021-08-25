Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF5D3F7E8C
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhHYW1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhHYW1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:27:07 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486F6C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v126-20020a254884000000b005991fd2f912so1023113yba.20
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lRgdlxFIwTaI+1pj1FLW7Tr0XAFZPB2xermJc5qu0rQ=;
        b=CXAG0orV7/SPrt1NPgfhYvHnwVRXs33lp/DzOk0mTLb6Jts5osxYHzHDZBaqYPdGFc
         VU/jAATZsN4MfDLnHJV4ARj44KfMpgB6+mEhv0JKANE12axW4KiDm1+Y0Asuf+1aCJjh
         k0/EKplsE9cBgBe8xI+KZTwY567YgUJlF75qIOuMwl5ojk427cu8uqjHN3gfiobqlZPD
         +zE48RMag8UOz8xwLxxsz2FxNXvuo3IvevSLk4dJychgU/tMzMqMuL74kAdizjT8Hycr
         4qqZ1eFlX2nFufI4+4EnwPt2f0dqifFUfJbRolbOgfoHwEBPxkK8Ifa/cMsljh5Hdkwg
         +xgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lRgdlxFIwTaI+1pj1FLW7Tr0XAFZPB2xermJc5qu0rQ=;
        b=BhqSVKvs5brCQ+7P4rKI+9VKx/eS2hNLOULrMDIZWc1VZzmwF5P8X5m2TCnCBJQD5I
         U/gx9ZZFJIbv95TUjs9SyvxPkiRV9yFWTcW4gIcz21jXFMYkmMwX6ebx2IJUsy9/bUCc
         5Uttu+sM6iLPL1/BlwmqrujxBV/AUxuHmHEfRLCyeao6QsBv8Czg0B73FnKMgA97EfK4
         l7NccaHzkNVGOlipV1rp8DP7UEvU4awvfuA/2ooT1c+1f/ALlaVVlPZ1E9N9zfhV1cK7
         Od3498WTxZ2h6nuKqhAd9odKzm3RT03w25hdKhJ8BYsXuI4N/oFVYflcHDYtF7qZHAso
         3cRg==
X-Gm-Message-State: AOAM533mgEcLzp6itoYC6ByZxwP9BJj8dwrQul/k5AyNKrMYkpbnrmcr
        dn6Q7hL9253FfycmEewhFw7LlhHl7Uyl5lWBK5EvifXKseE42n75kzHf/cHGrcVUoW1QQn13C3J
        r+38kVX2wuSELnU1BLSOvJB91ZAVR1mxq/KpbqjWsdAdueebZjGzXRA==
X-Google-Smtp-Source: ABdhPJzGHFBctMJoHz9ZMvzkx5RaqHad1ZaU8QSL1w0ewWtWExzRlWNqm+ZUJkfCvraeXkE+7XcUr9/jBQ==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:bb35:184f:c54d:280c])
 (user=morbo job=sendgmr) by 2002:a25:d711:: with SMTP id o17mr1159807ybg.394.1629930380451;
 Wed, 25 Aug 2021 15:26:20 -0700 (PDT)
Date:   Wed, 25 Aug 2021 15:26:01 -0700
In-Reply-To: <20210825222604.2659360-1-morbo@google.com>
Message-Id: <20210825222604.2659360-2-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 1/4] x86: realmode: mark exec_in_big_real_mode as noinline
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

exec_in_big_real_mode() uses inline asm that has labels. Clang decides
that it can inline this function, which causes the assembler to complain
about duplicate symbols. Mark the function as "noinline" to prevent
this.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/realmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index b4fa603..56bd238 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -178,7 +178,7 @@ static inline void init_inregs(struct regs *regs)
 		inregs.esp = (unsigned long)&tmp_stack.top;
 }
 
-static void exec_in_big_real_mode(struct insn_desc *insn)
+static void __attribute__((noinline)) exec_in_big_real_mode(struct insn_desc *insn)
 {
 	unsigned long tmp;
 	static struct regs save;
-- 
2.33.0.rc2.250.ged5fa647cd-goog

