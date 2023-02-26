Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9908C6A2F39
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 12:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjBZLI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 06:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjBZLIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 06:08:44 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD120D337
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:12 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id p26so2519004wmc.4
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DhCtvdISfSJGmSRhPq2AjC5p8wx6Lzbd/eNIYImSXRM=;
        b=QPf5ib00ScA48hMQHUzW1lvTDouPusCaUUg0eekp7SyUTCxTIVpputKMGWZxlRS4cl
         e7A6nOdrq8MA+MyYOWk6tDGeotB6Q+Jfg3V4hsC33H02znsM8kU13ZhW8gcuohULSbY0
         ePlLNBBGzpF8Xh4lCwmyg42+trUDsR5PY26vWEZQlU69ydBlVBnNsJxPYWCOm+WlnTgZ
         J/eqLS1wvlkQW2OdErYPCObH94CZxPsaqVlvSoQCl1sXWB2oZ94UzR3bhAoP3TnAM/9I
         eacNw78Gf/JXYq0zqCUyrSXC5ycicmJL+a7f+kHjEObzxtrXzIXeFvlwuTqyaKzBz30z
         CNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DhCtvdISfSJGmSRhPq2AjC5p8wx6Lzbd/eNIYImSXRM=;
        b=yZeWmwymjsEjAsGhIjYwJyW18QMW5mGR4dKUiEpzwoVViRg0y3W/6TnJAcQXjTLUBT
         re9yj6DmvCKp9MSi/+9mS76OfQ7zyVc3jX4WY3esGh4evAxu5Wp2qrh9R3PibOECh3cm
         XEb0jIj5Cy14Dz4rIhvQ1ZgbZnD2mKn9D98oCgCGR5k7n1QdbyiX0mEqCOjOnlVF9wEr
         0d9bInTjVxtQMn2fehOpJ9xhmy3G65YngIbO8DNJzQccie06iXIKySRPIfL6se/nz43c
         IqizNlNLUvQaH/qpUIqlPNyCvCVcUzdfUJJSTcfWMMRxAm2vbJEd+LB8hz6fJWwygU+z
         mtzw==
X-Gm-Message-State: AO0yUKU7hQvfJ7Znog1hFvrkCPmOFV/Uke4iXyYZtlYRcx9IqUdo3aOI
        r9BR3lIHyGbDyB1hTCXPveKeFQ==
X-Google-Smtp-Source: AK7set+6/4z/p2flyB/SRJYNRhaf64sYyvPSIQezIw8z8JD4evz1ofFmP6ITDmBKURZczFiXSHA16Q==
X-Received: by 2002:a05:600c:830:b0:3eb:399d:ab28 with SMTP id k48-20020a05600c083000b003eb399dab28mr2279436wmp.37.1677409691251;
        Sun, 26 Feb 2023 03:08:11 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:df7b:4668:3e23:d0c9])
        by smtp.gmail.com with ESMTPSA id v22-20020a1cf716000000b003e1fee8baacsm9157318wmh.25.2023.02.26.03.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 03:08:10 -0800 (PST)
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
Subject: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
Date:   Sun, 26 Feb 2023 11:07:58 +0000
Message-Id: <20230226110802.103134-8-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230226110802.103134-1-usama.arif@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
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

From: Brian Gerst <brgerst@gmail.com>

Build the GDT descriptor on the stack instead.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/acpi/sleep.c |  2 --
 arch/x86/kernel/head_64.S    | 11 ++++++-----
 arch/x86/kernel/smpboot.c    |  2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index ab6e29b32c04..236f2423454d 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -112,8 +112,6 @@ int x86_acpi_suspend_lowlevel(void)
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP
 	current->thread.sp = (unsigned long)temp_stack + sizeof(temp_stack);
-	early_gdt_descr.address =
-			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
 	smpboot_control = smp_processor_id();
 #endif
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 5a2417d788d1..0ccca297e90e 100644
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

