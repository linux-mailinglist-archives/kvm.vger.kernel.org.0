Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EFF3197DD
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 02:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhBLBIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 20:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhBLBHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 20:07:12 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73505C0617AB
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:15 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id o16so6059011qkj.15
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cEJRTvR1R8mp+nZlLc5IDPe77GXhuZ/MSPi9P8LN9jY=;
        b=abpETcZ2hb0WlkAri6vgnfiqY8Xku/wFJFhluLYbZ5edXXT/xQWniUgmbpkcw5Be65
         mCx67We2tMxTzLSJFw5T89OinhT6RO78GC9hEz6ox1szAjwhJoj6rnMs9Y485+Ap81L3
         zfN6pQKB/Aq9RGIip0JmRwBEK7SbLPTcj+iCO0EaWfGP83z3gjaZ64l/36fTpDbOfOWR
         rHE61zRhTB2vaT/cigBMjacAIoSv3ZRy57Ic5OZrydBtV+ehWYEjXeknwfczZtrzIgwd
         JgywwHG/kWqn0LR7+wTyNEedMbg5Ntp69ply0kGkUOHgUGV8cKm2aaMYd7tsrBHWd1dB
         3/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cEJRTvR1R8mp+nZlLc5IDPe77GXhuZ/MSPi9P8LN9jY=;
        b=DnFdt99l0FuIe4DP3TnIiHNfL2hcBHe+ium0Xmw2GBPAk+1jQR5LkgcNdc2qaDr45H
         msZE+bhzPreswjCX+zDtQJqVgHB//j6FILcLyyPD//zQspspqE0qBrULW3cQbinTVu6H
         hQnKLd7Z/2ApQBUb4yL+W+vDhCmTjE/b3MvNhzGjr/3G8aTFh9X1WV/RGU2yq9Np3dNs
         7wrQLrq3n0Ujmi5VkYtbFU3hkui/HVUi8aBPixpeEUsev/MbKQqHWY1/5BAJqgmKG9W0
         z6IJigSoBpRhQ9DSj/+8KbQgw0+Enyg5nB+is3owkBVuvvB4JZm917dUfpHTHQW4KgOg
         VTBw==
X-Gm-Message-State: AOAM530p1Y+dO2JOUQJkphCZemYqusAjABhuppIJsDlHn6YufoxpkiN9
        RfjrW2+UAyp3qbiyWTHtlgn5g3BmNOA=
X-Google-Smtp-Source: ABdhPJz950wjkbLvEqaZkr7CuN6+xpFhkxiDLKvuDnPUCBT0ebF3wWGIz/wZ4KGMAdUw2ufbF++QSOXAT5Q=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f588:a708:f347:3ebb])
 (user=seanjc job=sendgmr) by 2002:a0c:b611:: with SMTP id f17mr546095qve.42.1613091974598;
 Thu, 11 Feb 2021 17:06:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Feb 2021 17:06:04 -0800
In-Reply-To: <20210212010606.1118184-1-seanjc@google.com>
Message-Id: <20210212010606.1118184-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210212010606.1118184-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 2/4] x86: Iterate over all INVPCID types in the
 enabled test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that INVPCID works with all types, even those that take a PCID,
when CR4.PCIDE=0.  So long as the target PCID=0, INVPCID is legal even
if CR4.PCIDE=0.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pcid.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/x86/pcid.c b/x86/pcid.c
index ee0b726..64efd05 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -70,24 +70,28 @@ report:
 
 static void test_invpcid_enabled(void)
 {
-    int passed = 0;
+    int passed = 0, i;
     ulong cr4 = read_cr4();
     struct invpcid_desc desc;
     desc.rsv = 0;
 
-    /* try executing invpcid when CR4.PCIDE=0, desc.pcid=0 and type=1
+    /* try executing invpcid when CR4.PCIDE=0, desc.pcid=0 and type=0..3
      * no exception expected
      */
     desc.pcid = 0;
-    if (invpcid_checking(1, &desc) != 0)
-        goto report;
+    for (i = 0; i < 4; i++) {
+        if (invpcid_checking(i, &desc) != 0)
+            goto report;
+    }
 
-    /* try executing invpcid when CR4.PCIDE=0, desc.pcid=1 and type=1
+    /* try executing invpcid when CR4.PCIDE=0, desc.pcid=1 and type=0..1
      * #GP expected
      */
     desc.pcid = 1;
-    if (invpcid_checking(1, &desc) != GP_VECTOR)
-        goto report;
+    for (i = 0; i < 2; i++) {
+        if (invpcid_checking(i, &desc) != GP_VECTOR)
+            goto report;
+    }
 
     if (write_cr4_checking(cr4 | X86_CR4_PCIDE) != 0)
         goto report;
-- 
2.30.0.478.g8a0d178c01-goog

