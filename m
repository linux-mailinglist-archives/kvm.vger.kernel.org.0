Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4D46B1002
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 18:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjCHRPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 12:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCHRO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 12:14:29 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663105A91B
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 09:13:39 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id k37so10292733wms.0
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 09:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1678295618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOzxufV8eJROu56F5G4QV++Rv00ag9T1YDu3ndS0Q6s=;
        b=aTSeqfSknwx6otQWiuICpWDDyGgJ59+KlvJF3/o5m7QH8mXWjdoheSEU5RjzDaf5la
         FEFdQKPegeYNYnisXyvxm2qH0ucKp0rPguZ7YQ0ZEuSBPzwU3920gPTD0ftZon4egzVT
         JToMPVAKkn2Y0mpTGg1PyCgQjs/Ogj3SOlKeeVoFYDDQNOSP6TjpCzJbbIgiI6EfY957
         GLNXDvccYrZzhaFxiPSUcBi0/2gTyILY+89OK3GyJBON7ljMsxyMI9s1ZgRCRTwU0qc6
         Yd65MOJ6jup6Jg8ETVyEdnbrH0KWVed0hGe5C1bWxdHQWyBxYQWop+A+Da2IDNFXGOai
         TkCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678295618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NOzxufV8eJROu56F5G4QV++Rv00ag9T1YDu3ndS0Q6s=;
        b=4KR/9f0JPzvpYnL6z9docV1ic010c5QHG9j09m5pQRul2JpTTTEwkZ0wRwkGpc4xBH
         r9M7XhfIw4ACQZS4W7VRBs0iO2aE3qpZnB+xqzqtd3HDHgGEo0MiyhG2B7Ty7rgDTtz/
         0VRdjuhVADLtpc1dAI7jJ6+Lm12h5hEnizpyh+SOqk1GzyrHuUuGBpTLaVpyiYU3/2q2
         6kukCsRoNksP3D0U2I/MgJaxA27RRjuDznw5GoHVfu6nMOlzawlxYujztNHudOV3YKnF
         pyWuh8HHuPONhllGhSGbP3ZdISMpwuvJG5Wu9CY6biJLpIjEC6YKP6AG52hyiShDX+Ci
         MnHA==
X-Gm-Message-State: AO0yUKVifc3RqmBs49dMHGSFsyM9j9WxzXZ/NHGu+oH4FW62UEdy5ems
        ++mckBoLZXCYOEU6fFzoPW+ysQ==
X-Google-Smtp-Source: AK7set/mNmXDXQVDGB2DN5DW1g+W5eoBZJ6lwnjbLx/tma9NWx/paYASWevwgE6ts6Xccgp4WaCmgA==
X-Received: by 2002:a05:600c:19d4:b0:3eb:38a2:2bd2 with SMTP id u20-20020a05600c19d400b003eb38a22bd2mr16558571wmq.11.1678295617757;
        Wed, 08 Mar 2023 09:13:37 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:fe40:3ba4:afe4:4609])
        by smtp.gmail.com with ESMTPSA id l15-20020a1c790f000000b003e0238d9101sm11668wme.31.2023.03.08.09.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 09:13:37 -0800 (PST)
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
        Usama Arif <usama.arif@bytedance.com>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH v14 07/12] x86/smpboot: Remove early_gdt_descr on 64-bit
Date:   Wed,  8 Mar 2023 17:13:23 +0000
Message-Id: <20230308171328.1562857-8-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308171328.1562857-1-usama.arif@bytedance.com>
References: <20230308171328.1562857-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Build the GDT descriptor on the stack instead.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/x86/kernel/acpi/sleep.c |  2 --
 arch/x86/kernel/head_64.S    | 11 ++++++-----
 arch/x86/kernel/smpboot.c    |  2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 1b4c43d0819a..de89bb4719d0 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -127,8 +127,6 @@ int x86_acpi_suspend_lowlevel(void)
 	 * value is in the actual %rsp register.
 	 */
 	current->thread.sp = (unsigned long)temp_stack + sizeof(temp_stack);
-	early_gdt_descr.address =
-			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
 	smpboot_control = smp_processor_id();
 #endif
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index cc1b145055ac..a5b46c2fba05 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -265,7 +265,12 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	 * addresses where we're currently running on. We have to do that here
 	 * because in 32bit we couldn't load a 64bit linear address.
 	 */
-	lgdt	early_gdt_descr(%rip)
+	subq	$16, %rsp
+	movw	$(GDT_SIZE-1), (%rsp)
+	leaq	gdt_page(%rdx), %rax
+	movq	%rax, 2(%rsp)
+	lgdt	(%rsp)
+	addq	$16, %rsp
 
 	/* set up data segments */
 	xorl %eax,%eax
@@ -667,10 +672,6 @@ SYM_DATA_END(level1_fixmap_pgt)
 	.data
 	.align 16
 
-SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
-SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
-
-	.align 16
 SYM_DATA(smpboot_control,		.long 0)
 
 	.align 16
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 62e3bf37f0b8..a22460a07cf8 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1110,10 +1110,10 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 		start_ip = real_mode_header->trampoline_start64;
 #endif
 	idle->thread.sp = (unsigned long)task_pt_regs(idle);
-	early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
 	initial_code = (unsigned long)start_secondary;
 
 	if (IS_ENABLED(CONFIG_X86_32)) {
+		early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
 		initial_stack  = idle->thread.sp;
 	} else {
 		smpboot_control = cpu;
-- 
2.25.1

