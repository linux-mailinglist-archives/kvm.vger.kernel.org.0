Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D31434AC6
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhJTMH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhJTMHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 08:07:23 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F472C06174E
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 05:05:04 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t7so7868922pgl.9
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 05:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=waYD8dsvUPs/3L1638bXCQkgi6UBgjkYBImUZ1krvko=;
        b=IPB6vWRptmpwaKLEJ2X1nkyazjjUtdTq5CkxdHOjuBZhT/HfwszGKGLZSkLoLYq0R5
         ztf2MLxBp40XOAYLBCWmO4AK+rH0/qqbhm4tJLLEASl582myoqUsTP0DfzoqHWybF3i/
         7j+Z09yo9qBg9ov5T9IFPSKwM5D7QkuuL7muY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=waYD8dsvUPs/3L1638bXCQkgi6UBgjkYBImUZ1krvko=;
        b=hdDJa67vYyGfd7xDEsNxw6CbpCf7OriUKvK5N0ICTHCm20okxCx0Abi/i9UEKt0Zg1
         b86vOpEpX9GMgnCh79fpLNJyrzz49Xm4A70MvLtibycbuINRIFh6F5pxOlVk6FhnsrhU
         9gojsUnPDaq750AnQFho7PzOANtKhGXT4TMPcguWpXUEF+y3GxQpIfVtCZQgfNqu/6us
         qJRQyrh0FHSaIo2aUNw9chkxFdJq8/kE1wsTG38BHm6/Tj3A+P2AaLJto009ch6b5QI2
         GKRClUSDo8T1mbKfQ3pEYAWjIFbpxlva3kQ86xLXsYIAh4IGl1d6IkwgsdMgn1SWv1vR
         Fq1Q==
X-Gm-Message-State: AOAM532x9byaNyrrpLvhati02eUt5O/ZDMJFdwvOy7DTphrRCMK3KhbS
        KUhhCIHzsPCCIe5QwoNdb1eYKA==
X-Google-Smtp-Source: ABdhPJyAa/wmxbz/aUVIPHp/LNEJI1zHjIqTNYybV06ibBEmD12XdN3Ms4lEYjUO9FXnD0ifkyqlBg==
X-Received: by 2002:a05:6a00:1916:b0:44d:b930:df4f with SMTP id y22-20020a056a00191600b0044db930df4fmr5921135pfi.39.1634731504152;
        Wed, 20 Oct 2021 05:05:04 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:e516:d575:e6f:a526])
        by smtp.gmail.com with UTF8SMTPSA id z11sm2424576pfk.204.2021.10.20.05.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 05:05:03 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com, linux@roeck-us.net, pbonzini@redhat.com,
        vkuznets@redhat.com, maz@kernel.org, will@kernel.org
Cc:     suleiman@google.com, senozhatsky@google.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: [RFC PATCH v3 2/5] kvm/x86: Include asm/pvclock.h in asm/kvmclock.h
Date:   Wed, 20 Oct 2021 21:04:27 +0900
Message-Id: <20211020120431.776494-2-hikalium@chromium.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020120431.776494-1-hikalium@chromium.org>
References: <20211020120431.776494-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include asm/pvclock.h in asm/kvmclock.h to make
struct pvclock_vsyscall_time_info visible since kvmclock.h defines
this_cpu_pvti() that needs a definition of the struct.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

Changes in v3:
- Added this patch.

 arch/x86/include/asm/kvmclock.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/kvmclock.h b/arch/x86/include/asm/kvmclock.h
index 6c5765192102..9add14edc24d 100644
--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -4,6 +4,8 @@
 
 #include <linux/percpu.h>
 
+#include <asm/pvclock.h>
+
 extern struct clocksource kvm_clock;
 
 DECLARE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
-- 
2.33.0.1079.g6e70778dc9-goog

