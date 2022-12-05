Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5645643174
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiLETOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiLETOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:14:42 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0451C1F2FC
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:14:42 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id v16-20020a62a510000000b005745a58c197so11491477pfm.23
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cp4a3TTeVSHyzpZq13HHY4DuMCRfGEG7am+0frY7pok=;
        b=UTtxWbLmXGiFxLe9ahMJDUr2TqaW7GXluF56sImIqjB/IgosTnOu+yAqVafbn92g5R
         jj84n2DB+LfGrT/NfQJQwXW7zSubpkPy0buTvsg43b4PC1lehF7lJimKeOG+ej/jO2Uo
         EZpzFKFUvbctFu/bcULJEaInHHcZScS8ByOf2AN0qm+xXlu1bkNHwPnx7hN1qureetTv
         7db036V/KaL8C3Pq/KmubGFdu9WrH/4bcSnKGmJrjQQWADO1meCn5DySZdA5mFaOkC9S
         5CIjkeMcsyBZwc7hp8bi6IyCYdHuzJ984l4e+pv9z+lZ+n7m0kfyEY7msfK4OdQvMUN7
         Pj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cp4a3TTeVSHyzpZq13HHY4DuMCRfGEG7am+0frY7pok=;
        b=YcCnkBFvZ9/nQnsuZJwUpc22WGVHizeaOZ+xgEerY6RxOgwtqyKzTXQOQ3iC4WbhR/
         JgXiSnrvvDZ6An4B+FKCkX4Bks6RPmiRhwjny7MOyQ/0iiDtci0eyPH+ZcrR0Ldl7qor
         3CMhuD/yiRj4SSjrx9qNb9Dv6nCDFZnpv8bJqFkPosFQhNQX4gu5Ig6wVDUPwLcambwC
         xQ885vx8JbyZkm3nedfhUmxcKltP/xF4gjAyCf8w5cCKEx9LAG0sYh53gOW5UR4t8Vrk
         Qz/lfxzl2NnGrLmkbYvETww7AdT9v/voyC63FY89big+IV1f/lA1ZxfgfF5GF0LLRIpm
         jW5g==
X-Gm-Message-State: ANoB5pkHP4MPYSAJMCTtUoh9OPcVS1Flz1QqfesyWJ6IJwPGmg7/XWxw
        JGPIZncGjsCNRMKPYrTqDbAwe0XAzVLg
X-Google-Smtp-Source: AA0mqf5Xk9ValEwYsGc3gxrVVzdYM9Fx/O0GbpD6zQqrJu6TXT3PnspW8pjjrxAxWrm9ZvTgWyt7Ck+atkLs
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:10cd:b0:572:5c03:f7ad with SMTP
 id d13-20020a056a0010cd00b005725c03f7admr86470697pfu.17.1670267681504; Mon,
 05 Dec 2022 11:14:41 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:18 -0800
In-Reply-To: <20221205191430.2455108-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-2-vipinsh@google.com>
Subject: [Patch v3 01/13] x86/hyperv: Add HV_EXPOSE_INVARIANT_TSC define
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
2.39.0.rc0.267.gcb52ba06e7-goog

