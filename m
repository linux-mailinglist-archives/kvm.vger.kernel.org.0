Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3133D6A104F
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjBWTMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjBWTMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:12:34 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C003558493
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:13 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id p8so11689098wrt.12
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OivBWw2fC0XPAqVFrKNNGqM4Zo9U9YwXqHaW8wBeEGc=;
        b=ZDG3NgABSuo3eKqXu8k0fCIFzS7x293O1xHnTdlbWTZzDzRsDo5w2fxICTyGIU9SZd
         La3hgbWjwAUViIFtj5nzdi9l286i+1BiiR8wgacSaNXsw/d9B2uf546kgw7pRzUOoU/O
         I9KjbX2NEBuvYhL7QbfZxgmJ52GtQy63SHB8mJdwQjIqrjEBSKFYLsgRjjr31IhELq8K
         +jVoVRVpaHAthXJtNr1V4FcLmQ+AKDPpCH7mcBHVUDKSMDSt9OamVRZ3xwxtubEoCSf2
         oIPFuxYBjE/iDAjsJ2hW8lj2oGMrSUTAZif/uT3Llh8ahCoiI45510hGVXSicsDBQ/he
         p4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OivBWw2fC0XPAqVFrKNNGqM4Zo9U9YwXqHaW8wBeEGc=;
        b=fO7GKsx8LMjTej2lvNG/I/c05aUC0KBk+/PFdfEXGRXYxLeSpOdv9h9enNr5jCpzq9
         WYB4wSjksIDNC8RopbXAzjA/otWyIqAS3KwLlQFEHAxyoI47DabW7avn6I3jGZFpeO33
         /ZPve/OG0YeKAm8Yj1wOD8pEazJSg0YovuTPoTDuXLq9Nd4St98D19iUtZpkDfN15lS4
         kkhx9Qfnu5y4vD00kYhNq/waBGauT62cBRblVCrW74VyXkng9kP+VgukDI8kIJxDD9TS
         ZBB0s3hH6ELJ5ToewntbRerc8O7UGi1rA+zDpn/7VyrLVR9P2zwDuSibHwtqipfVyzhf
         OvsA==
X-Gm-Message-State: AO0yUKW6XXcWQ4KPgFtrxgC9hnBQ39L+DCng8bW7RFrKbyCR2sXcJ6D9
        DDQwaOFSvFd5JuVWb8Dne+4OfA==
X-Google-Smtp-Source: AK7set/NLgn5F6/GhEh/DEIwsyZth9V2XRLVxbC7O+VwR1a40tCKWH8Koc0WD22GsiFjFCrm49T0DQ==
X-Received: by 2002:adf:dd86:0:b0:2c7:e60:a41d with SMTP id x6-20020adfdd86000000b002c70e60a41dmr4335140wrl.61.1677179506858;
        Thu, 23 Feb 2023 11:11:46 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:5ee0:5af0:64bd:6198])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d4b8f000000b002c561805a4csm12957286wrt.45.2023.02.23.11.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 11:11:46 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v11 04/12] x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
Date:   Thu, 23 Feb 2023 19:11:32 +0000
Message-Id: <20230223191140.4155012-5-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230223191140.4155012-1-usama.arif@bytedance.com>
References: <20230223191140.4155012-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
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

