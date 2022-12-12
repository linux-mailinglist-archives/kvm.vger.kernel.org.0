Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D9664A735
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiLLShf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbiLLSh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:26 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FED11C08
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:25 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id v16-20020a17090a899000b00219b1f0ddebso459478pjn.5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+njGW4VjenMTQbJUIuskcZhM7dDdCQXICJE3uEmTc98=;
        b=ZQ9u9x0jc+g6g3SLO/fDBuNnJLbyN8v5Mp4f9IqdWtSZYz3Oe8f/FTKp97SJBnZITU
         dspnGUAZFMMqDM0mPUPfWxExkLUru43PkNik6taHARntQDAtf+hiNPKOYn1sojBxrvt8
         laDXCBRbfO2vqge8JNDgZEJErg2ix1RCQUvmlVCbOZgnIH48kO6K8nBbqfp6c2H+0lB9
         cN6+V4Edi+CZutedirUU7HemunrZWSy4D+4LBZTi4MpXq5CgEc1u4t/3qcI0hZplrkkl
         vdiLp1qBn2tPZNwOBySx9BH3Ye8jaQTBK7fxuaNhMT7nowS6MCCTRCwA922gFO84Q4Y7
         bknQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+njGW4VjenMTQbJUIuskcZhM7dDdCQXICJE3uEmTc98=;
        b=IvFN+mllqaVxW4dc7jH5iLjinJfIO5ISUdXfAaT6VKtqfJ8qDpyAVKBLPJHX5WVR5I
         revaCMdndSI8pBZWIzda5p52eAt/Z6uPR/ijRq55wXZMT7zwuc9LjqvCbNBjCF1Ez/ni
         U20+wPOGlbDKfxeLCod0LC4br6zWbn5rwrquiiIIQBW4cwMlgTTocU1oUUK4p2PkUkAx
         lKszqfu8hPf7ujlZYI4wLXyfKZ61cpDETH0MDTEwsCahaL/p3troNsDTMcIX9XvAa6ZM
         AD1AC2GBn0dcRpSMc6BCUZK01xxjv7CnLlkfQygs4XO2goRqr+CV7HPuZJ5jfSznA3vS
         +yfA==
X-Gm-Message-State: ANoB5pmt5IHDwQblTyPqDufY4xxNtFkMygsPsldiTFkUPNMvuYWLiGPL
        2WjMoxnjCQ3EMtVEb5KbuJ5haxY9u+8v
X-Google-Smtp-Source: AA0mqf5KMkc5/651W+5Uzzagtvk/Z1Zi+Z5SO9fqVmCF1GEn68XFI1Bq4ItaaOGSW2cUNLhAMdZrF8Ndntt8
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:bd92:b0:219:861b:b108 with SMTP id
 z18-20020a17090abd9200b00219861bb108mr541pjr.121.1670870244693; Mon, 12 Dec
 2022 10:37:24 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:08 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-2-vipinsh@google.com>
Subject: [Patch v4 01/13] x86/hyperv: Add HV_EXPOSE_INVARIANT_TSC define
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Avoid open coding BIT(0) of HV_X64_MSR_TSC_INVARIANT_CONTROL by adding
a dedicated define. While there's only one user at this moment, the
upcoming KVM implementation of Hyper-V Invariant TSC feature will need
to use it as well.

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 3 +++
 arch/x86/kernel/cpu/mshyperv.c     | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index e3efaf6e6b62..617332dd64ac 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -255,6 +255,9 @@ enum hv_isolation_type {
 /* TSC invariant control */
 #define HV_X64_MSR_TSC_INVARIANT_CONTROL	0x40000118
 
+/* HV_X64_MSR_TSC_INVARIANT_CONTROL bits */
+#define HV_EXPOSE_INVARIANT_TSC		BIT_ULL(0)
+
 /* Register name aliases for temporary compatibility */
 #define HV_X64_MSR_STIMER0_COUNT	HV_REGISTER_STIMER0_COUNT
 #define HV_X64_MSR_STIMER0_CONFIG	HV_REGISTER_STIMER0_CONFIG
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 831613959a92..e402923800d7 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -388,7 +388,7 @@ static void __init ms_hyperv_init_platform(void)
 		 * setting of this MSR bit should happen before init_intel()
 		 * is called.
 		 */
-		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x1);
+		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, HV_EXPOSE_INVARIANT_TSC);
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 	}
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

