Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDCB1A905E
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 03:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392508AbgDOBX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 21:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392479AbgDOBXz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 21:23:55 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA60CC061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 18:23:54 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id dh19so1569742qvb.23
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 18:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+UiXyULlzq60JcrYizZG5xR6t3RIPIiANzzV8jZ5et4=;
        b=oqpB2vuBxzx65QrcJ0rQHZsF96i4qH7Ccf1rFMcJ6KOnPS2CNK2G/i+chkrdb9a2Ye
         fX6rGMu9RPCe4ZDmyHLd5d4qmhvuPwD0hOrJGwMw5nORi9st6VrLGQ45nlHi2RyMkxHw
         sT0Q/Lq/ib1UjQN672r4x39sYLOTMS6E5jC4JiK68o8u8FG0SJaWourIl4/l/zSoLU8P
         dS5s0Xjb7hinQYUflvWzNAddQsBycWP8wR0GNb8lFPoVv+XGbEik7X6N/9ilApkXTYvX
         vmUWUTbiMWpBvtYwR8BzNY1zoDGx25l3yFRiOgbO4PbrsLgoGMCamPcPhfwY4HOZ7nXo
         MkgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+UiXyULlzq60JcrYizZG5xR6t3RIPIiANzzV8jZ5et4=;
        b=TWrAi7YfKGR5+u6hdw/4vHsqLiyt7f8z3yPX8X4q4iKgpkex5FJPG76cgfz44Z3zR0
         pbuJMWCoxhZvBtSXkoxF2YKoe7Hn6GsM6dqJv+OAXrJbIBx0IquoFVBruQ9I4wWF1jJY
         chjoL1nonqV18vSv04NGOle8K2x2C2VQSilWC0hn8fsJdywWv2ScJ9ZCEmXSxVeD6H9n
         sdJjt8b3hyloVJhIONbucEkfFYOFjBTNVC0WdlWWciZG+xMvYWdUcV/EBsuZPSDwTMCX
         lil5HIOihI5s3PkFOl+YqhS54PLEu/YsFn6ingSaE4thxBNbwU/jGc6QFflQaQgWSQV/
         clxA==
X-Gm-Message-State: AGi0PuYPV5rI42jYjt1hRgNs2DOZ0bIpMCj3cRlJ4BFbW3dyRNC1QYAB
        NGXUCZpc5tOMiJ3ReEKTfA6vdo1fxKCbHw==
X-Google-Smtp-Source: APiQypJFWJeQvzBXxj3d9pW4mxjnL9s22hQArYDAnHt6z6K0vobYszap9H2qGKlaKJvejbA00rEqZ5icFY1N/w==
X-Received: by 2002:ad4:55c4:: with SMTP id bt4mr2703843qvb.225.1586913833875;
 Tue, 14 Apr 2020 18:23:53 -0700 (PDT)
Date:   Tue, 14 Apr 2020 18:23:20 -0700
Message-Id: <20200415012320.236065-1-jcargill@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH 1/1] KVM: pass through CPUID(0x80000006)
From:   Jon Cargille <jcargill@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Eric Northup <digitaleric@gmail.com>,
        Eric Northup <digitaleric@google.com>,
        Jon Cargille <jcargill@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Northup <digitaleric@gmail.com>

Return L2 cache and TLB information to guests.
They could have been set before, but the defaults that KVM returns will be
necessary for usermode that doesn't supply their own CPUID tables.

Signed-off-by: Eric Northup <digitaleric@google.com>
Signed-off-by: Eric Northup <digitaleric@gmail.com>
Signed-off-by: Jon Cargille <jcargill@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b072..4a8d67303a42c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -734,6 +734,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
 		cpuid_mask(&entry->ecx, CPUID_8000_0001_ECX);
 		break;
+	case 0x80000006:
+		/* L2 cache and TLB: pass through host info. */
+		break;
 	case 0x80000007: /* Advanced power management */
 		/* invariant TSC is CPUID.80000007H:EDX[8] */
 		entry->edx &= (1 << 8);
-- 
2.25.1.481.gfbce0eb801-goog

