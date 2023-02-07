Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F76468E420
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 00:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBGXEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 18:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjBGXEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 18:04:47 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90C63FF33
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 15:04:45 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id i5so7917272wrc.0
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 15:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+woZryxcmbb99mupmnna5okozeg16DDHF5Mj8G3upM=;
        b=I6OGmp/zf+SXm16RpuuHG0Cs0grAvvCacNPO9dKsk1CnGRmdMFu6+0NJdJhyZFTM4X
         t222CAl7UR84WcZsi9vxKoozrPUuo3JLOzCIH9sxnbaS2E1xVnpxE5522R2XhnSGXoAq
         H4dMxa2K3aJcC4yIroI+hFKQ3ShkEp8NGiIlepnXYdQeZXr63YjWL9GWbYxgDjB8SqFq
         6hSMRm3TCfJwjZPwZVHhxdN9/3ajo3kOYvz8TDCXvwpUD7+G2VBebFw/w20A52rvxJgq
         tohCQW4m433T31Ja45QB9CYTeV4/Ljp7ac0MTuuxzvTX9xUgS2fkFqmLhmlrsnEBHe/T
         tISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+woZryxcmbb99mupmnna5okozeg16DDHF5Mj8G3upM=;
        b=zXUbP2WOMEyG3DH25Ib8NsJOPf1JZZZuTHNT32+Zs9n3Wv4ouWB55TUxe3DdOsaGho
         3lTyr4EXy8VnVD8PUMXbpHjvPVoaWU/OOhTg7bXk+yH6p+k1kG3ihKN5it1pQtqTQYT+
         eartpOREmaS0zXApci87vNq9z/OzI5s5JqQbQXTC3aXy4WcvkNKHpPuMtMADlpImC2Nx
         G9KwYdvhHESZ8iA/s7yvXc4OFaaMZyP8m4UKQ90WXP6KBDe8XYdPpxsB9tENRvEBDpuy
         6PXWMbFVaLlfZRpJZ43Qf8/59TKoQjP26oWpbPQLW5XLF+dEUwqZbn4JOGV/sKB9c5Dg
         LF7Q==
X-Gm-Message-State: AO0yUKWSijLtgnS2S5/KIBkOSq9HLJxGL/t9AYSQUhMDsEWS1Djc9D3v
        Imbadj+L/NuJTPE0d6GC1HF3Gg==
X-Google-Smtp-Source: AK7set+kviHpO/dgYo6fG95FwmeukrqggqusKN5eb8Q4daAsLpnqIvfLT8PSlOVWaMCGZUHBCi1JdQ==
X-Received: by 2002:a5d:5183:0:b0:2bf:b5ec:4844 with SMTP id k3-20020a5d5183000000b002bfb5ec4844mr4689320wrv.19.1675811084196;
        Tue, 07 Feb 2023 15:04:44 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:c04f:2463:c151:8b87])
        by smtp.gmail.com with ESMTPSA id j14-20020a05600c190e00b003dcc82ce53fsm146485wmq.38.2023.02.07.15.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 15:04:43 -0800 (PST)
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
Subject: [PATCH v7 4/9] x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
Date:   Tue,  7 Feb 2023 23:04:31 +0000
Message-Id: <20230207230436.2690891-5-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230207230436.2690891-1-usama.arif@bytedance.com>
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

