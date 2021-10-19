Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C4B433446
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 13:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhJSLEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 07:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbhJSLEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 07:04:09 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D13C06161C;
        Tue, 19 Oct 2021 04:01:57 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so1720024pjd.1;
        Tue, 19 Oct 2021 04:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WNgwR02wKvV99D2pCZhogtDphzYokbzMq2B91dyZpwE=;
        b=WySH3WNgl3isE6aQmWlyHcF5y/brD9eAM4ZB+4I73epIHzbpIa1+rzv7K8q/qOBTMl
         Pqp1qqeRx4Z4yzMhDUk7oEchY9bnGJ4yGGlGwM2zxykSKlFeNufI0c80OJfcs0CkmE62
         rWS6LFrI6dMWar/lFfuGCYZ6cRel396K0XQdGGxpXa+dpqj7osldLUsRF+t0wI8Gl2mb
         9EhZm8BRaDNSZK/PhRcIAewkk7Io0r5H3GvmW/5suSYgmF0i8UB9faBkgvuUjpKAPBqg
         yA8ZHFPw7ZHOuJjOEIt2E7xIRXvzf7SGlS1VhV5nkJmzDPSKmBAJrsJgRvLF5tXbLvIs
         FY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WNgwR02wKvV99D2pCZhogtDphzYokbzMq2B91dyZpwE=;
        b=oNSO4VnS9zSk0+PnPBYmLx29ArgJCq7yJ+2C4g8GsexJcbg0PxunWbhYQU4b+/t9ad
         AnNtjsE+HXp9I9T1HVfAAyGcdXXjBIad+5cV/v8fRRtWxNZUw3OMPgUt1PyYrKhFGnZa
         zxdrj6tQPLiHJnZECK5xkmXHJXe9kkrBVi1iladn/MzGF5mS3Xe0hbHKRmDQESacRy9z
         RdQxRPtzu3pr8OsZVied22ipzXrrwM7CknmBrRDdKQDRhXKmdh+c5ORfNmuC5YCvPhlo
         56tfwGFF9cDf7HbljhJNAEytHVd7fffWzRwhOSg/1pB8SaPsrKNw2KrNy1A7IwJDHWy3
         458g==
X-Gm-Message-State: AOAM532Zh0K5t3Hc0qhyrtPk2pdssgcBfxtFaV45IHBEVDRD5crsxgdH
        XVyjynHgP0oafZMCgUbET2sSTt4HG7Y=
X-Google-Smtp-Source: ABdhPJxOU1LwmG786WY5NmuQ+jvVYpqx9C3InWfwBeGvrfq7WP6FawYujs9bbmWIgeeUxHYP0dayqQ==
X-Received: by 2002:a17:90b:3ec3:: with SMTP id rm3mr5795329pjb.186.1634641316429;
        Tue, 19 Oct 2021 04:01:56 -0700 (PDT)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id me18sm2491812pjb.33.2021.10.19.04.01.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 04:01:56 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/4] KVM: X86: Fix tlb flush for tdp in kvm_invalidate_pcid()
Date:   Tue, 19 Oct 2021 19:01:51 +0800
Message-Id: <20211019110154.4091-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211019110154.4091-1-jiangshanlai@gmail.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The KVM doesn't know whether any TLB for a specific pcid is cached in
the CPU when tdp is enabled.  So it is better to flush all the guest
TLB when invalidating any single PCID context.

The case is rare or even impossible since KVM doesn't intercept CR3
write or INVPCID instructions when tdp is enabled.  The fix is just
for the sake of robustness in case emulation can reach here or the
interception policy is changed.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c59b63c56af9..06169ed08db0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1073,6 +1073,16 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	unsigned long roots_to_free = 0;
 	int i;
 
+	/*
+	 * It is very unlikely to reach here when tdp_enabled.  But if it is
+	 * the case, the kvm doesn't know whether any TLB for the @pcid is
+	 * cached in the CPU.  So just flush the guest instead.
+	 */
+	if (unlikely(tdp_enabled)) {
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+		return;
+	}
+
 	/*
 	 * If neither the current CR3 nor any of the prev_roots use the given
 	 * PCID, then nothing needs to be done here because a resync will
-- 
2.19.1.6.gb485710b

