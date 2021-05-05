Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB958373312
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 02:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhEEA2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 20:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhEEA2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 20:28:45 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40282C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 17:27:50 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d13-20020a05622a05cdb02901c2cffd946bso4717514qtb.23
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 17:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8VmneownvRiBDOCyf/WT7mY7HGmlZaT0ZagzLkVER4s=;
        b=oCd8B3F/UTfILVZUWrdLF+pvd1RlR9XDTo0h1qVI77FIpxJAIO9Ax/Pf/N/ForhSVT
         Lg2OnnPEQKxO4nWBNJItIW0g1iTulDZhJBd2AaSsv04wsyRO5qWG+0y0DYBJKbV6OmIt
         pAZShJlD2PTHdfyGQr9XPJQHQPLBKVf169EbsPHljD+FbaMSIgR2281C2tdIvgJVlfI4
         XsBKeHNBiqKq+PxaEufgDGPJXd/NefLz4JP0NZcG8soX3Sj/sgKdv4QuRDey31dbNMts
         alNKy9IMUiodV2xKOKxRln2Tpg6nKI+8tdHaX7/Um1sgVEuADXhXUoCFG83/O6ZkifdJ
         kTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8VmneownvRiBDOCyf/WT7mY7HGmlZaT0ZagzLkVER4s=;
        b=cEiWzEyuJWdjGkC1TH/9BCnRIsbOt6jHxZy5c3E6QvJzs/WEnGWC9RANA2fV8tAMo+
         yTu5dHR5WlqW+0HZt6eSdmZAhEnXdr4kpVib+3rcftUgRHADUpPibhmWD4Lq4WHKiJjv
         4JYZk3QV5T7U2OsZe1j0ENdkEZzLjAnhdK/jOt8sdOjFenNP9IkyyeM70/fCvQt8UUsh
         7gN7vRHNK4POppIHM8ILfyJjyn8hdUSoLVUsm4C5CEPbWlZNhSnEHQwwDcBYeEB16wwH
         USEhIgAhuGNWoQ+9Cyi5m1HfnNOHqQnm5vkh3h7vxDu8EraGX4E3k07EK4fV1jf9RVbB
         B6+g==
X-Gm-Message-State: AOAM530IwmnyGCM2KAtn1cKIcPA5mqDjbzW3lXhgjO/Ru1YVEcAYFvVu
        slGuNu8P8Ep3b5jz4fKYLo4pNkVic5M=
X-Google-Smtp-Source: ABdhPJw4PT82bVQOoqQY5MU7nnhRBtlemwIy3I3yaq3UJcUJb7h7xsmWHPyDKHEcnKjivOsuFN2ql6b7YYk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:ad4:4908:: with SMTP id bh8mr28611423qvb.55.1620174469407;
 Tue, 04 May 2021 17:27:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 17:27:29 -0700
In-Reply-To: <20210505002735.1684165-1-seanjc@google.com>
Message-Id: <20210505002735.1684165-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210505002735.1684165-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v4 2/8] context_tracking: Move guest exit vtime accounting to
 separate helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <frederic@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Provide separate vtime accounting functions for guest exit instead of
open coding the logic within the context tracking code.  This will allow
KVM x86 to handle vtime accounting slightly differently when using
tick-based accounting.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Cc: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/context_tracking.h | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index b8c7313495a7..4f4556232dcf 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -137,15 +137,20 @@ static __always_inline void context_tracking_guest_exit(void)
 		__context_tracking_exit(CONTEXT_GUEST);
 }
 
-static __always_inline void guest_exit_irqoff(void)
+static __always_inline void vtime_account_guest_exit(void)
 {
-	context_tracking_guest_exit();
-
-	instrumentation_begin();
 	if (vtime_accounting_enabled_this_cpu())
 		vtime_guest_exit(current);
 	else
 		current->flags &= ~PF_VCPU;
+}
+
+static __always_inline void guest_exit_irqoff(void)
+{
+	context_tracking_guest_exit();
+
+	instrumentation_begin();
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 
@@ -166,12 +171,17 @@ static __always_inline void guest_enter_irqoff(void)
 
 static __always_inline void context_tracking_guest_exit(void) { }
 
-static __always_inline void guest_exit_irqoff(void)
+static __always_inline void vtime_account_guest_exit(void)
 {
-	instrumentation_begin();
-	/* Flush the guest cputime we spent on the guest */
 	vtime_account_kernel(current);
 	current->flags &= ~PF_VCPU;
+}
+
+static __always_inline void guest_exit_irqoff(void)
+{
+	instrumentation_begin();
+	/* Flush the guest cputime we spent on the guest */
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
-- 
2.31.1.527.g47e6f16901-goog

