Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BDA35E666
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347803AbhDMSaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347794AbhDMSaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:30:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1241CC061574
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w9so17227000ybw.7
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZH3R+r1mP9A7TFpksm2/wMBCPzsWCgXGqDl2URF8e0c=;
        b=owXXzC9qI/WTs8JgAJXw2iBbcM6GJRcX2Sj6STWjD9aSRhwAbeEK+txS3UWUFW9By8
         dahEF9t8wUHcbNjUdFMLjjiUv0wNPCBwDdkQsDekYzS1SxwnoPqNbrJZ/g2U9p9tOX5u
         mi9xmwpGek12LGIbxowSGaJR2wMehTEQxaBfeGLgyZp6PltwiSLyqLnHO9UvopYJHVTy
         JXnt6ayOnj+2lHzYaoN20O68hCIniSd1dEgjGRCYJtfClhnarbcncH5CkoanyyxZMBYt
         Wdg///Eyt/h0W4i7T1Cl7baBswwDRlpP32QsswS9izaACJSP3jd7onIPTb1bcIv4tJpK
         i0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZH3R+r1mP9A7TFpksm2/wMBCPzsWCgXGqDl2URF8e0c=;
        b=uQW403CObSjcBxiR1Q0G1wTZDBwIHP+JdolUhwLvao1DDBcLlJYTGg78UAOxdB0Hcv
         RcwIf1KSejiYao2WvQ/oWrhIwxL1ya5CXLOjzbtf8JnFw1tx1HaZ8W4MeTiVd592omK8
         Mxw0TuWIXat1Zs1BoKfFf5MuxuVOKJLMhk3ZRtt5xbaO6haGC+lzV05XtB6Mp26luZqR
         XN8NqyCoZlb+lbzEhrzufscTzqSiHSIlqr3b1sdNlyeg2qxQuU/kR6gTYBoGRdr93NGv
         Xnto9LoIMD17TIji0tmhROJfe9Xomzw1jPvRN90EF2OfIIuvgbXXyB4ZCC2xpxCbaTmp
         Z1gQ==
X-Gm-Message-State: AOAM533Z6+tkJDRnZ3X0SjyxbYq0ihqBF/7mKh69mrUHxMw5g4T+Ndmk
        A+ZpNb0xQmITMtE1C4OG/wwKCJs9ybA=
X-Google-Smtp-Source: ABdhPJwe5BGu6diD7tVMyJxmAxDs5AV++7eUpQW5aAxTwDILzmzjS+kIRe1a6098uYNdg4gfxqHkdgfqddk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a25:d70f:: with SMTP id o15mr35167752ybg.403.1618338591313;
 Tue, 13 Apr 2021 11:29:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Apr 2021 11:29:31 -0700
In-Reply-To: <20210413182933.1046389-1-seanjc@google.com>
Message-Id: <20210413182933.1046389-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210413182933.1046389-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [RFC PATCH 5/7] KVM: Move vtime accounting of guest exit to separate helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a standalone helper for guest exit vtime accounting so that x86
can defer tick-based accounting until the appropriate time, while still
updating context tracking immediately after VM-Exit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 444d5f0225cb..20604bfae5a8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -358,16 +358,21 @@ static __always_inline void guest_enter_irqoff(void)
 	}
 }
 
-static __always_inline void guest_exit_irqoff(void)
+static __always_inline void kvm_vtime_account_guest_exit(void)
 {
-	context_tracking_guest_exit_irqoff();
-
 	instrumentation_begin();
 	/* Flush the guest cputime we spent on the guest */
 	vtime_account_guest_exit();
 	instrumentation_end();
 }
 
+static __always_inline void guest_exit_irqoff(void)
+{
+	context_tracking_guest_exit_irqoff();
+
+	kvm_vtime_account_guest_exit();
+}
+
 static inline void guest_exit(void)
 {
 	unsigned long flags;
-- 
2.31.1.295.g9ea45b61b8-goog

