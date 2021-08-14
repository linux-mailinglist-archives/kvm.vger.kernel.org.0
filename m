Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58203EC2E7
	for <lists+kvm@lfdr.de>; Sat, 14 Aug 2021 15:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbhHNNhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 09:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbhHNNhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Aug 2021 09:37:09 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068B6C061764;
        Sat, 14 Aug 2021 06:36:41 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c17so10249550plz.2;
        Sat, 14 Aug 2021 06:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8k5tK7Xqetu9bwPZdm4ZTikD0tIPa7BMMwO2o7nECfc=;
        b=kqh5dyse8qfkx84NXESqb2gXZp2P1MH3qcsicz0UZ7rSX8DtnWzD4vSA1aD+e1LQVC
         anNwmzoLa9XWnK5m9HxsYTpz4NW33IvWeXfv2smRA+LTphW5Y3rurk+cwhOKpxnp94KH
         B3+6YIP3DqzOO0o5Q5uR6fD7XFLmgv9CdNkO55NNfflIpUBoLb2D3UtuhqgfCF2aqrZ/
         orlgt7P+72Nue6u6mpJ8jXMwvD+7v7O8Fxz8CtYeXoA45plqVC4F6prGMQeqe+3U+Me3
         tU/E+INNG3sYnikqU+O+3pBK4S1m7WqSuraHNG2HpKZDgnqiGYUGjgNQpm5yVBJPdM69
         e2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8k5tK7Xqetu9bwPZdm4ZTikD0tIPa7BMMwO2o7nECfc=;
        b=P50Ju4yYqVeqC4ErUw1efMoHfcPODJNrcjBGi35W8j8gxoFQIwPbI7FArM0QZLoVMC
         479I39kWSs4TMCFqDGEGF6vZuDTvaKhSa+8kkNmnm4CtdWAZkpMrHjD0pU+dxGJ3cvcB
         ViB6IEDcHdQa2V0znv8Nrx7LKWxE1S1SHSi3Kgzf5irhk7NQxaYmdOv7zxB9yUPwM9eO
         G1zymzubFtSh+/Z2SKedjyOBqYo/C44mbvF3Ils6BzOAWmXvCOCmyiOZWORnHFzQOj7U
         80n49CTdgZ0ch5ChqcWoyDWgVPdVOjOy70CRym/0LUbUcSegYGk87Vw8FAqEgCNSDzx2
         R9Jw==
X-Gm-Message-State: AOAM530ZQOVT+hs/SB7X6yxFEWST0HpnkKvLF0BmZM3fh+MDfsPIEffh
        cb+eOPel4a9KXepvsxnfHvR7YcZs/Ds=
X-Google-Smtp-Source: ABdhPJy5AVxtMN/QA4LnK23itxMB/U8L8Nq3aEBoSdUzsHuZU4iKFEiCiLUmcNrMOA5LvZFkwgZsbw==
X-Received: by 2002:a17:90a:cc8:: with SMTP id 8mr7675159pjt.194.1628948200349;
        Sat, 14 Aug 2021 06:36:40 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id z24sm4665788pjq.43.2021.08.14.06.36.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Aug 2021 06:36:40 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH] x86/kvm: Don't enable IRQ when IRQ enabled in kvm_wait
Date:   Sat, 14 Aug 2021 11:51:29 +0800
Message-Id: <20210814035129.154242-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Commit f4e61f0c9add3 ("x86/kvm: Fix broken irq restoration in kvm_wait")
replaced "local_irq_restore() when IRQ enabled" with "local_irq_enable()
when IRQ enabled" to suppress a warnning.

Although there is no similar debugging warnning for doing local_irq_enable()
when IRQ enabled as doing local_irq_restore() in the same IRQ situation.  But
doing local_irq_enable() when IRQ enabled is no less broken as doing
local_irq_restore() and we'd better avoid it.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---

The original debugging warnning was introduced in commit 997acaf6b4b5
("lockdep: report broken irq restoration").  I think a similar debugging
check and warnning should also be added to "local_irq_enable() when IRQ
enabled" and even maybe "local_irq_disable() when IRQ disabled" to detect
something this:

    | local_irq_save(flags);
    | local_irq_disable();
    | local_irq_restore(flags);
    | local_irq_enable();

Or even we can do the check in lockdep+TRACE_IRQFLAGS:

In lockdep_hardirqs_on_prepare(), lockdep_hardirqs_enabled() was checked
(and exit) before checking DEBUG_LOCKS_WARN_ON(!irqs_disabled()), so lockdep
can't give any warning for these kind of situations.  If we did the check
in lockdep, we would have found the problem before, and we don't need
997acaf6b4b5.

Any thought? Mark? Peter?

 arch/x86/kernel/kvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a26643dc6bd6..b656456c3a94 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -884,10 +884,11 @@ static void kvm_wait(u8 *ptr, u8 val)
 	} else {
 		local_irq_disable();
 
+		/* safe_halt() will enable IRQ */
 		if (READ_ONCE(*ptr) == val)
 			safe_halt();
-
-		local_irq_enable();
+		else
+			local_irq_enable();
 	}
 }
 
-- 
2.19.1.6.gb485710b

