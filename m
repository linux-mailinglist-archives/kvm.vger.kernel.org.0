Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECAB36B048
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhDZJKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbhDZJJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 05:09:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCAFC06138C
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so4895731pja.5
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CyW+WjVffqnD9VFGsqpSFk2yAUyd3GC+azDgWQuCGt8=;
        b=NfvuDJlz/4axwtjejO6Bhm8ZUOSpcdBl5CqsZzYNOleZcxJvwfRh2sth2duBAfJN1Q
         HTeUGen/ixs8Ww2Wzn+BxsyYRO2WwerMCpnUZ1W8V00BPJXr8gTd/r6QsQkrxdH19DnF
         wSiNGd7vmSRRV2YuJA6mT293nZ+w9XrrFUaU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CyW+WjVffqnD9VFGsqpSFk2yAUyd3GC+azDgWQuCGt8=;
        b=ADllKI633r982KPuOwK/h14DAjsDazIyDkBtL3N06aydq7JGH6Jzi89h3oBXc9Nmls
         G8eo+QgIeMiyrkW6jqzAuBuEAJHRZY1ExYWT1epeJT8BeagTupjDCzvEoVrlyRuxbBP6
         l4ZCSUJSL+H4ngmB5BKCYhlwS2ctrgTJ4bXXVcFUOtL7sUUmL3xCaJ+Zw2F+406S0P3Z
         kmR+1xjZQAk/4Z8oD82ZhcptKLlFiYT6rgqfEhyyZLWJzhcCs1/hZWIOY1w4dawVqTgW
         d8WUiPkmswAVQ2ZJA7cEYmCTloFj7bq02GkLLOvK6vWxTQS0Jt98A47U+/pOrTNJsVNb
         e2TA==
X-Gm-Message-State: AOAM530T3jHHNaHv/rv2YWgM0+CcXcVu3LFATFjSrQK1EuuGAGFNdqCl
        15g5VQc3QtaiJb8T/5f7nlDVftDvReqRyw==
X-Google-Smtp-Source: ABdhPJw3ORFptR2N7NrnhHVAT4v5iW/nbwpLcjFHss3abkqyk5Qm0Xs2DBLzRql6Q6CPi6PKDjFl2g==
X-Received: by 2002:a17:90a:a61:: with SMTP id o88mr7915546pjo.8.1619428110375;
        Mon, 26 Apr 2021 02:08:30 -0700 (PDT)
Received: from localhost (160.131.236.35.bc.googleusercontent.com. [35.236.131.160])
        by smtp.gmail.com with UTF8SMTPSA id x2sm10358014pfx.41.2021.04.26.02.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 02:08:30 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     kvm@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [RFC PATCH 2/6] x86/kvm: Add a struct and constants for virtual suspend time injection
Date:   Mon, 26 Apr 2021 18:06:41 +0900
Message-Id: <20210426090644.2218834-3-hikalium@chromium.org>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
In-Reply-To: <20210426090644.2218834-1-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds definitions that are needed by both host and guest
to implement virtual suspend time injection.
This patch also adds #include <linux/kvm_host.h> in
kernel/time/timekeeping.c to make necesarily functions which will be
introduced in later patches available.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

 arch/x86/include/uapi/asm/kvm_para.h | 6 ++++++
 kernel/time/timekeeping.c            | 1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..13788b01094f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -33,6 +33,7 @@
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_HOST_SUSPEND_TIME	16
 
 #define KVM_HINTS_REALTIME      0
 
@@ -54,6 +55,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_HOST_SUSPEND_TIME      0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -64,6 +66,10 @@ struct kvm_steal_time {
 	__u32 pad[11];
 };
 
+struct kvm_host_suspend_time {
+	__u64   suspend_time_ns;
+};
+
 #define KVM_VCPU_PREEMPTED          (1 << 0)
 #define KVM_VCPU_FLUSH_TLB          (1 << 1)
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6aee5768c86f..ff0304de7de9 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -22,6 +22,7 @@
 #include <linux/pvclock_gtod.h>
 #include <linux/compiler.h>
 #include <linux/audit.h>
+#include <linux/kvm_host.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
-- 
2.31.1.498.g6c1eba8ee3d-goog

