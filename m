Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BA717349E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 10:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgB1J4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 04:56:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54540 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgB1J4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 04:56:09 -0500
Received: by mail-wm1-f67.google.com with SMTP id z12so2508551wmi.4;
        Fri, 28 Feb 2020 01:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=hgVcmR7sn/hoLD5sm/7USC3YHt4zWyH2PCKORbufRkw=;
        b=U8YNLw1BklkbHKFSmFrBZRonGw1bCU07mI+9f3gnHLLb9DGHlDa/hp53mIK0w3l2KI
         OItOYdNh0Fv7TFRXvO1EbJzuxEZ9itI7ofYSEKcR3AL1XM9zFH5IZZhED2s8gNmy6+zP
         6pXlNm66fIa7wwaj8qx2UEpO1QOBSisTB9ptYn5Ln1ZwNLOYaaeTX/NnoYOQGX+M8ZR+
         k7M4wGxBMdn5CdJVL2ohqqH8zDezNBpBYhEUC5efPD79VCS/ZmetxmOnRENOS9a7RNn4
         2qhSjjHWLS/efKV8+kyy6II9yx5ZbfTlAHEVW2k0ryZwi2OF8NTHo7tUKUcyytcpSf0u
         K1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=hgVcmR7sn/hoLD5sm/7USC3YHt4zWyH2PCKORbufRkw=;
        b=KpKTroTMccisfAsRXsE5X2jkJjlGcIVEIKMkm57hqJpOY10dYnl8kE8FEgt0V7EXKk
         JcHmvlnTWzXbOSaKzk+5OjShb5wi870ajq0TeKzZwa1i9ZJzb5aI6TJxqTUaeMwCCb1a
         gouVsCLftUZCdAvfWiehSryMysghij/tFBv9SOTIQb29SXNcwMVqrY1lFmINcU6XWfad
         6IlUrFNDj6c4MO8bGNeU6yH9cPeKGcRoFFFGqncd/TSI1rK/YaFBC/bIjpKHRhSQuYJc
         dj/Ltl03xQw2kKDhrQW1CkLU5K3ZcEova0ZLXaPtMO+3UZ2CWje6YwR7Hz1r7AF8jWIJ
         NczA==
X-Gm-Message-State: APjAAAUL2WevGLU3rVNHtt/fbOAPnNKQ6nxRtczSrvLPPysZ2kMDIQpn
        77hVKGyuqTTXMCC08VTXyrNTA6ou
X-Google-Smtp-Source: APXvYqyod6TPpE2Xfif+ncMso0qZDZmpwPO/iPMNVJ9e8WNHlmsfErK+Ptw+fDMGTxu/+aMbntbeng==
X-Received: by 2002:a7b:c088:: with SMTP id r8mr4116774wmh.18.1582883767208;
        Fri, 28 Feb 2020 01:56:07 -0800 (PST)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t3sm11664565wrx.38.2020.02.28.01.56.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Feb 2020 01:56:06 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH] KVM: x86: avoid useless copy of cpufreq policy
Date:   Fri, 28 Feb 2020 10:56:04 +0100
Message-Id: <1582883764-26125-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct cpufreq_policy is quite big and it is not a good idea
to allocate one on the stack.  Just use cpufreq_cpu_get and
cpufreq_cpu_put which is even simpler.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 359fcd395132..bcb6b676608b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7190,15 +7190,15 @@ static void kvm_timer_init(void)
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 #ifdef CONFIG_CPU_FREQ
-		struct cpufreq_policy policy;
+		struct cpufreq_policy *policy;
 		int cpu;
 
-		memset(&policy, 0, sizeof(policy));
 		cpu = get_cpu();
-		cpufreq_get_policy(&policy, cpu);
-		if (policy.cpuinfo.max_freq)
-			max_tsc_khz = policy.cpuinfo.max_freq;
+		policy = cpufreq_cpu_get(cpu);
+		if (policy && policy->cpuinfo.max_freq)
+			max_tsc_khz = policy->cpuinfo.max_freq;
 		put_cpu();
+		cpufreq_cpu_put(policy);
 #endif
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
-- 
1.8.3.1

