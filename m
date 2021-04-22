Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1FC3677B7
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhDVDGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbhDVDGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:06:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB94C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so6638244ybn.21
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SuF/DNdMNFHB7yQcfuR/syn5LXlY/Z8OiyRcKZ9nw9I=;
        b=BA8T/RkaD2k2sNIFH6QKi5brAv7JjzOaodMjiyTeh9BLlLzu3x3/nKPA+v3jDr8jft
         4qhZnjhLDf0O1W9926kL6FsTJ8IqRKG7nt3z1B9RsBDWcD3tLJDqU/OsQkvT6x9M6pys
         QHt+1DYLtY5jLt24FZu9UyDZJGUz6fpldTCKOIgTha3tx6nPQ+6jSNgsDwIUwKKX9T4N
         nuKjQduEVTD+CkwMCjTEsPLxHn9naZm5RqonECzI1/EwyULzBmRenCd5049T80u9BT+z
         Wbz6EL780JZA6ea3IP3wA9Ez32AvM4sE4AEpEqOKLJCABd/YlZtXg+Wbr8nYmqTWZHAI
         Ic+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SuF/DNdMNFHB7yQcfuR/syn5LXlY/Z8OiyRcKZ9nw9I=;
        b=MLb6YSo6aDGo0IR2KFr8OZkJhlR/ighnn0spdGyUAl7kVLkCcNYPSPnDFfC6c2uMSY
         FH19rAZnJP87Wiszl1DTsaxNREoOyRXZ1whHYxOARCBppFTKbwoe+6KIg7pRgW5xlUqq
         ldeCJsag2qnKwSb5LKsXyOEoi9XLgvRuWFByRCGdIVx87IgpnE/KFwKl3tGYUV7oq0q9
         9tzAvxrkIVXPEAvkU5Rv0hVrn87eULpejzYsyWdvLJ1ech1ldiSyTEGSAZhDLZIWpV4m
         PffPiEInA+dAX17UkE3dNp/PUgq81m+0AEHkyrnQB/hNtI4yvE+YJTHVRlB/n+t2wj4C
         qNkw==
X-Gm-Message-State: AOAM533hkATlDZECh0f0U3tIe1qEiVhiNz1fohNcc5tlyinfkP0sTWRN
        d8WmlURe7CEsMr9w06waM9vJ2/zSm48=
X-Google-Smtp-Source: ABdhPJz2rzedxuarBN2OOa4iw98B15Q/G+6HaxxW6YWwHn8ROZZJ+5ZJ0q/BjyiwCKL7cs2nzh32aUSh2uA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a5b:5c7:: with SMTP id w7mr1651083ybp.164.1619060733641;
 Wed, 21 Apr 2021 20:05:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:05:01 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 11/14] x86: msr: Pass msr_info instead of doing
 a lookup at runtime
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the msr_info to test_msr_rw() instead of passing a subset of the
struct info and then using that to look up the struct.  Pass the value to
write as a separate parameter, doing so will simplify upcoming patches.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 4473950..4642451 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -38,40 +38,20 @@ struct msr_info msr_info[] =
 //	MSR_VM_HSAVE_PA only AMD host
 };
 
-static int find_msr_info(int msr_index)
-{
-	int i;
-
-	for (i = 0; i < sizeof(msr_info)/sizeof(msr_info[0]) ; i++) {
-		if (msr_info[i].index == msr_index)
-			return i;
-	}
-	return -1;
-}
-
-static void test_msr_rw(int msr_index, unsigned long long val)
+static void test_msr_rw(struct msr_info *msr, unsigned long long val)
 {
 	unsigned long long r, orig;
-	int index;
-	const char *sptr;
 
-	if ((index = find_msr_info(msr_index)) != -1) {
-		sptr = msr_info[index].name;
-	} else {
-		printf("couldn't find name for msr # %#x, skipping\n", msr_index);
-		return;
-	}
-
-	orig = rdmsr(msr_index);
-	wrmsr(msr_index, val);
-	r = rdmsr(msr_index);
-	wrmsr(msr_index, orig);
+	orig = rdmsr(msr->index);
+	wrmsr(msr->index, val);
+	r = rdmsr(msr->index);
+	wrmsr(msr->index, orig);
 	if (r != val) {
 		printf("testing %s: output = %#" PRIx32 ":%#" PRIx32
-		       " expected = %#" PRIx32 ":%#" PRIx32 "\n", sptr,
+		       " expected = %#" PRIx32 ":%#" PRIx32 "\n", msr->name,
 		       (u32)(r >> 32), (u32)r, (u32)(val >> 32), (u32)val);
 	}
-	report(val == r, "%s", sptr);
+	report(val == r, "%s", msr->name);
 }
 
 int main(int ac, char **av)
@@ -79,7 +59,7 @@ int main(int ac, char **av)
 	int i;
 
 	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++)
-		test_msr_rw(msr_info[i].index, msr_info[i].value);
+		test_msr_rw(&msr_info[i], msr_info[i].value);
 
 	return report_summary();
 }
-- 
2.31.1.498.g6c1eba8ee3d-goog

