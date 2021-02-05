Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED03108B5
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 11:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhBEKIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 05:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhBEKFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:05:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD03C061222
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:04:08 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m12so3341307pjs.4
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S5g3KjTF37TfcHKlT3L6KJoPEPgIVLEViokSkw93MzU=;
        b=NXRvu6Mnnlo7bgBrUUIn4t4Py1dZWIR+iWJS9IGIJy89jR/CnbPG3INRt2VQqKEoV8
         vnS/Cg8artOGcsgd1Vb5W0KhHS//WSeUkfEgXw8qBfUeVYrQj+Aig6fVHXGlvH2zBuSL
         TU4wpoklPl1ieNayE/H/EnvxcmAUrAUiMEs9wHnxZPMlLw8XeEjmtqJfw34O88dNYpSB
         OSS4wjN3lk3BnVRfM3mFLh25K6f5qrAZ7bvHHW6jy+8/ZTz+kmFIIGI816uwiVMmXMiA
         4libcPKqHMrOP+xVaijWjRIwqXKtLJSOuaUxofbNn51HcIHcQirXLBQm0Cqai90DBuJE
         2K/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S5g3KjTF37TfcHKlT3L6KJoPEPgIVLEViokSkw93MzU=;
        b=a7x/Jf6fZCvOfUTI7IBAPXXqwWtVTZjlak62fkOcK3Ol8xH1vwNRRZ8DE5yOyBOUzH
         RuDu9KIC2J25gh3AOZWS1/u3HQy5OpX4BFIMc1hhOdyQ1BJ5CGq7Ne3/ODslO9kb+B5z
         GFFK7W4H0l2suI0m6fflEo9MOP9XSQ2ujCkeTXaaReLbnHlNI/w6aFq0BISBAr7tiahc
         u0xu4g6a2fI/fj/QlkqYrw12Mgdt36acg4biqdslSBg0r5S53U/ObAU84nkBukD3Hcrr
         2H9uueORBZwqBgkwH/T8FUULtbaF3r0Bw2CEZ26JPL3nR1dlVonvEx49dHlDMoDg1MiB
         7fug==
X-Gm-Message-State: AOAM532VHfR64iJhBSe7IX1F3DMsZ+iGPX6ugFhLCnMt6+qn+iPxIsGg
        Eio38j9KgTRchi0Ppuz5lmldpg==
X-Google-Smtp-Source: ABdhPJxgNSKPC+0Mk1BDOTDZhST6pkHg6VyxZAKvFAFFq3bpv58uknmblJNTXZ18cdNScr+AVMt9yw==
X-Received: by 2002:a17:90a:468e:: with SMTP id z14mr3576479pjf.174.1612519447834;
        Fri, 05 Feb 2021 02:04:07 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.04.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:04:07 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RFC: timer passthrough 6/9] KVM: vmx: check enable_timer_passth strictly
Date:   Fri,  5 Feb 2021 18:03:14 +0800
Message-Id: <20210205100317.24174-7-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

preemption timer is default disabled
timer passthrough is default enabled

Signed-off-by: Zhimin Feng <fengzhimin@bytedance.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44b2fd59587e..a12da3cef86d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -126,12 +126,12 @@ module_param(dump_invalid_vmcs, bool, 0644);
 
 /* Guest_tsc -> host_tsc conversion requires 64-bit division.  */
 static int __read_mostly cpu_preemption_timer_multi;
-static bool __read_mostly enable_preemption_timer = 1;
+static bool __read_mostly enable_preemption_timer;
 #ifdef CONFIG_X86_64
 module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 #endif
 
-static bool __read_mostly enable_timer_passth;
+static bool __read_mostly enable_timer_passth = 1;
 #ifdef CONFIG_X86_64
 module_param_named(timer_passth, enable_timer_passth, bool, 0444);
 #endif
@@ -8108,12 +8108,17 @@ static __init int hardware_setup(void)
 			enable_preemption_timer = false;
 	}
 
-	if (!enable_preemption_timer) {
+	if (!enable_preemption_timer || enable_timer_passth) {
 		vmx_x86_ops.set_hv_timer = NULL;
 		vmx_x86_ops.cancel_hv_timer = NULL;
 		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
+	if (enable_preemption_timer && enable_timer_passth) {
+		pr_err("cannot enable timer passthrough and preemption timer same timer\n");
+		return -EINVAL;
+	}
+
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
 
 	kvm_mce_cap_supported |= MCG_LMCE_P;
-- 
2.11.0

