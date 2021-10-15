Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311AD42FC9C
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 21:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242900AbhJOT5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 15:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242890AbhJOT5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 15:57:43 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822C8C061570
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 12:55:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t7-20020a258387000000b005b6d7220c79so12347302ybk.16
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 12:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BrIxp5v8XZCOZJr8HcJN8/x1RIKaAdAbAFjYcRhECVY=;
        b=eoVAwNSkXt3ZnZ1bQWkGdev+z1uJtcGOASeb1hP5pPC9Yzj/Aj0Au42e8j7cNey1qr
         qJICMpEiXqYzr1lmtNoPLPr5yt7pHbdDg33DL/I+zSpHyOK60ASc776koRuhGxueuepE
         c+bCqyv+CEud3jqGodH+GCfxT+HfoCYKUXuKZu+Ejw4YMxJaPj0jZ9Rg5ZThMpUTlCAt
         Mj68nYIR2FzWdXZ5xVB4E1QfQhKkosdstsVaP4I50NIIS+X+1hnhuIR1dAM1g90mi9Kz
         wriibkdtoStIE8XMStpg9dvAwBTLtIkZ492yxliX731lNZL0tpG3slEoKCODhy1caz1f
         ykpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BrIxp5v8XZCOZJr8HcJN8/x1RIKaAdAbAFjYcRhECVY=;
        b=lUFZuMrGdXMiY1tPMMTpx0il+7UcwyWGmJJLUtNpeQNz0GvFOCvl483RjL5Td/YD5O
         VxR0Acurw5DcoVMVtsFgapH54AhdfJzyyZZI3Ci+ASqmVU3sYpbRkEh8t2RIpN/PaERN
         iFB+jS/2Biw97zVut7afklYuiUVpMBt0UvY+R2fJ3aU/FaokR5gWj1xP5l7tXDzcu6bp
         ZhC4tYgehrfw0utP9rqe//KoP4SeqyTrpmWkInFaXw8UDoQBlhWQfMDtMWksIkhfqCGg
         N9d7C8yLoZz1fdpX7c1iDMGgiXHU/0EqagsnGO0I2LnG39uin1ZFUaQsO5S1C4nxgdhS
         t1bQ==
X-Gm-Message-State: AOAM530kjuaZ6AYzXFVXifED8OeyL13eybJ0A7FW71Q1h949p+xhYEXM
        0cz2pJMhHGyLJR599B7mwvjXtsZowjMzC6Ixdxh2kZoZKTz5kznosS6NeZRWp0ARYJaGhmasmLt
        JgKCOES6QGT5ls8s7VI0mkUOUmBlgD56K2BdUgYrmAbmZqmXTDGHHYddaVjANByg=
X-Google-Smtp-Source: ABdhPJwlKirNQvBZ2/ozsLGLfM3IUnAjdnf3Gat2WJVTsnBry4BE5LtKHCZFvCZjyxcadHLNvgFa/hiK0K1v6Q==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a25:1d8a:: with SMTP id
 d132mr14161180ybd.56.1634327735083; Fri, 15 Oct 2021 12:55:35 -0700 (PDT)
Date:   Fri, 15 Oct 2021 12:55:28 -0700
In-Reply-To: <20211015195530.301237-1-jmattson@google.com>
Message-Id: <20211015195530.301237-2-jmattson@google.com>
Mime-Version: 1.0
References: <20211015195530.301237-1-jmattson@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [kvm-unit-tests PATCH v2 1/3] x86: Fix operand size for lldt
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lldt instruction takes an r/m16 operand.

Fixes: 7d36db351752 ("Initial commit from qemu-kvm.git kvm/test/")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 lib/x86/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index eaf24d491499..fe5add548261 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -443,7 +443,7 @@ static inline void sidt(struct descriptor_table_ptr *ptr)
     asm volatile ("sidt %0" : "=m"(*ptr));
 }
 
-static inline void lldt(unsigned val)
+static inline void lldt(u16 val)
 {
     asm volatile ("lldt %0" : : "rm"(val));
 }
-- 
2.33.0.1079.g6e70778dc9-goog

