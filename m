Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592D238AF63
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243132AbhETNAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 09:00:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37061 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243105AbhETM6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:58:01 -0400
Received: from mail-qt1-f197.google.com ([209.85.160.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1ljiEA-0005Qz-2M
        for kvm@vger.kernel.org; Thu, 20 May 2021 12:56:38 +0000
Received: by mail-qt1-f197.google.com with SMTP id w15-20020ac857cf0000b02901e11cd2e82fso12211773qta.12
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 05:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/kEoSYvTEjD0iUfvRsRgx66EC2X7g8N60VyX04WfcGw=;
        b=VnXQtI5jheaDi4R1dvsVDk415/642BR2iDAYp9kTWSaY5gWAsIFGCYq3AvnXZAUa92
         7b5VQerVX/HO2cTWo/Zz7xM6FSztBmz6YA7K2ZCKos3mjtvHnIVX9zoG1ONJbnBjJa1Q
         ETtU5LCX4ln7RmJgLI5/SYmGt8haJwChjv4UX+6xqlzE5y4SMv4s9EUw0c1zI/ofXCge
         W5wT0v0G7+ASXVcb5Pjc0oR/Gb7nHnOHmqhdh1KSoyiYjegV4yOC5bcF9wpYOQGc+yBI
         7HhQqbaV67ptIbIsQxW2kv9wWgisfoL4QOOmFarBlEupU2ZVKg7TQsMFLsKTIreK87UA
         Q1Hg==
X-Gm-Message-State: AOAM533OPEjuHHMsCSaGxspfy4uJD3ABB5EMpC0J7rCYabCwRQwCsAM0
        bOisOug+5Bu3SRMaEoMf84JJoPMTHaZjC0jPv4mq/ysznDy8P2YezmVU+xyc4Eqkkig9K87gO6Q
        cpliIEnigJ5r+hP8PD/3H2SkotAlSxg==
X-Received: by 2002:a37:ef11:: with SMTP id j17mr3488750qkk.234.1621515397134;
        Thu, 20 May 2021 05:56:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEiXH6P8bE1nzgR5rYzXvnrvuIULpHjI+O+t+FJYaHyHC3Ojm8/Oua5Gn0lMv6nsTQSrypwg==
X-Received: by 2002:a37:ef11:: with SMTP id j17mr3488724qkk.234.1621515396970;
        Thu, 20 May 2021 05:56:36 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id g185sm1931471qkf.62.2021.05.20.05.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 05:56:36 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH stable v5.4+ 2/3] x86/kvm: Disable kvmclock on all CPUs on shutdown
Date:   Thu, 20 May 2021 08:56:24 -0400
Message-Id: <20210520125625.12566-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210520125625.12566-1-krzysztof.kozlowski@canonical.com>
References: <20210520125625.12566-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit c02027b5742b5aa804ef08a4a9db433295533046 upstream.

Currenly, we disable kvmclock from machine_shutdown() hook and this
only happens for boot CPU. We need to disable it for all CPUs to
guard against memory corruption e.g. on restore from hibernate.

Note, writing '0' to kvmclock MSR doesn't clear memory location, it
just prevents hypervisor from updating the location so for the short
while after write and while CPU is still alive, the clock remains usable
and correct so we don't need to switch to some other clocksource.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210414123544.1060604-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/x86/include/asm/kvm_para.h | 4 ++--
 arch/x86/kernel/kvm.c           | 1 +
 arch/x86/kernel/kvmclock.c      | 5 +----
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9b4df6eaa11a..a617fd360023 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -6,8 +6,6 @@
 #include <asm/alternative.h>
 #include <uapi/asm/kvm_para.h>
 
-extern void kvmclock_init(void);
-
 #ifdef CONFIG_KVM_GUEST
 bool kvm_check_and_clear_guest_paused(void);
 #else
@@ -85,6 +83,8 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 }
 
 #ifdef CONFIG_KVM_GUEST
+void kvmclock_init(void);
+void kvmclock_disable(void);
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6b906a651fb1..f535ba7714f8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -555,6 +555,7 @@ static void kvm_guest_cpu_offline(void)
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
 	kvm_pv_disable_apf();
 	apf_task_wake_all();
+	kvmclock_disable();
 }
 
 static int kvm_cpu_online(unsigned int cpu)
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 904494b924c1..bd3962953f78 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -214,11 +214,9 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
-static void kvm_shutdown(void)
+void kvmclock_disable(void)
 {
 	native_write_msr(msr_kvm_system_time, 0, 0);
-	kvm_disable_steal_time();
-	native_machine_shutdown();
 }
 
 static void __init kvmclock_init_mem(void)
@@ -346,7 +344,6 @@ void __init kvmclock_init(void)
 #endif
 	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
 	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
-	machine_ops.shutdown  = kvm_shutdown;
 #ifdef CONFIG_KEXEC_CORE
 	machine_ops.crash_shutdown  = kvm_crash_shutdown;
 #endif
-- 
2.27.0

