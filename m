Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A083E690D43
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 16:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjBIPmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 10:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjBIPmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 10:42:14 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F9F643DC
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 07:42:05 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id hn2-20020a05600ca38200b003dc5cb96d46so4164811wmb.4
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 07:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+woZryxcmbb99mupmnna5okozeg16DDHF5Mj8G3upM=;
        b=gih0aal19S9nSzdM2EI39YXMR5nl2xJGmtK0jzTE06zlTaPK55Qd3mmQbuA+cqaMfi
         UKiLU5aZy7tn5ia+NmqWiU2EIpJXjm+fDDGunmntxWjZlIjdBS/kvJd5YQuENxMxYm+c
         AFCdDwoZNSl8QxCX/2NWvs67wm2cgNRqbNfWyER2oudQkCZDjotapvk0Oq2ROv0FFMgP
         XmfClELw1Wf9sqYOdjcclv1gsharUtQT3NQ8ATagCEfGaKpyiP0YzWR6Cmxn3OclvS6T
         5EBXLwFqCjBILNmTwK63SbEhYwRJSJC+ssLE0iWqSWJRAAZbpJuQ+VdlW+sY17OQEiAl
         oASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+woZryxcmbb99mupmnna5okozeg16DDHF5Mj8G3upM=;
        b=Sn56ZpBFNYptmDGRwK7xqzR15QUJatflwezFgQ8WznkHoqdbN0/vWxc15syFs1ZGX/
         kSePCP89D/UHnCj4JTM/P1sQVkUjJUSHR/bEJcU99VqMz5VyvLVNN8zCr9CZbsl2WhIW
         OpwN2MOy7Fe75jg0IZJReKfKdOHuKo8KlgkscdY5xj/bKL1kxXzH3CcsPMX2JXo7vfu3
         deNdTWiKyNuLgbRu/NlB2VtazQHdsBCz1jBfX8iN3T5ejeD1UgK5xPAgLSK8uGY3hOIi
         yq/8vLRZo2Dix74Q0TtTlZ3HWj2JCf1ot09DKvxGDq+gYsokiOtLMVLrmNxNO1t5BXTR
         s04w==
X-Gm-Message-State: AO0yUKUCTsnYXRXxLVDnUuAFUpbctxeyPmH5HUF6tV7XcoQLcg9iwfVz
        CsfCWQplZrjYg4nB20AUY28d3g==
X-Google-Smtp-Source: AK7set/sWgTNchnuaYWjizrQWtBx268zZySwi/F8bUcd1EeZGHrZZweHAtzLqOUWHa4cn1YWsuFIWg==
X-Received: by 2002:a05:600c:3298:b0:3dd:1c45:a36d with SMTP id t24-20020a05600c329800b003dd1c45a36dmr4683343wmp.27.1675957323675;
        Thu, 09 Feb 2023 07:42:03 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8009:2525:9580:8db2])
        by smtp.gmail.com with ESMTPSA id y6-20020a05600c364600b003df7b40f99fsm5099754wmq.11.2023.02.09.07.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:42:03 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v8 4/9] x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
Date:   Thu,  9 Feb 2023 15:41:51 +0000
Message-Id: <20230209154156.266385-5-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230209154156.266385-1-usama.arif@bytedance.com>
References: <20230209154156.266385-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When bringing up a secondary CPU from do_boot_cpu(), the warm reset flag
is set in CMOS and the starting IP for the trampoline written inside the
BDA at 0x467. Once the CPU is running, the CMOS flag is unset and the
value in the BDA cleared.

To allow for parallel bringup of CPUs, add a reference count to track the
number of CPUs currently bring brought up, and clear the state only when
the count reaches zero.

Since the RTC spinlock is required to write to the CMOS, it can be used
for mutual exclusion on the refcount too.

[Usama Arif: fixed rebase conflict]
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/x86/kernel/smpboot.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 55cad72715d9..3a793772a2aa 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -121,17 +121,20 @@ int arch_update_cpu_topology(void)
 	return retval;
 }
 
+
+static unsigned int smpboot_warm_reset_vector_count;
+
 static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	CMOS_WRITE(0xa, 0xf);
+	if (!smpboot_warm_reset_vector_count++) {
+		CMOS_WRITE(0xa, 0xf);
+		*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) = start_eip >> 4;
+		*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = start_eip & 0xf;
+	}
 	spin_unlock_irqrestore(&rtc_lock, flags);
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
-							start_eip >> 4;
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
-							start_eip & 0xf;
 }
 
 static inline void smpboot_restore_warm_reset_vector(void)
@@ -143,10 +146,12 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 * to default values.
 	 */
 	spin_lock_irqsave(&rtc_lock, flags);
-	CMOS_WRITE(0, 0xf);
+	if (!--smpboot_warm_reset_vector_count) {
+		CMOS_WRITE(0, 0xf);
+		*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
+	}
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
 }
 
 /*
-- 
2.25.1

