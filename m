Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA52175454
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 08:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgCBHSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 02:18:36 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45404 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCBHSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 02:18:35 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so5111780pfg.12;
        Sun, 01 Mar 2020 23:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SGYHPYDByh3jgM9qVULEcWknYrO2Uv9Ry5lUP1fq0cU=;
        b=d794cEm4/jGpeACslEH4kzP+y3+j3IKtTRsaga+yf8sTnlUAOHBn9tuqwJ0yTx7dYD
         Vs5dCBO3yx1zEVc5/S/paU18egxiByiViTHUPoYsgMntp9MzgkDYYhpeke8BwVAUzn0S
         mYwv/3Umhk0keqQOdcZNCw6dr2xV4gj3fcytzBnAgN5xdfZFUMSrWJlD0cqJn5JKqk0c
         wiZrpC9JrH8n83UN/39qy5xXjxooSWLv7ccsoyFQZoS5ajgtks7vD7Rnt9M4ZoJ02q3T
         Uha1nYWlfu+/3rQzkUrK4LjW5Yi2jWtSMYEmF0Pc3CdiE1SVp2qGy75z2ub0IwNdf7WM
         hJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SGYHPYDByh3jgM9qVULEcWknYrO2Uv9Ry5lUP1fq0cU=;
        b=mssg4U1Yxc+oVIpkVigBfNHDcps/e0VIAECCo1Pe2m1ZEoUfkfrjChvklC9HwNVQjO
         hrVvcrI+TItLBLw3yhcXzZXFjhv2Q25mpagOQbEkblQv+UftYUkIUwucpOvhIPqEYJCG
         ZjLfGgCmJ7HgZBqIsT9GSyCJJc2+CRez3tMQBlaB4CRV4sSI+0Vsst9EAFfS1qAE4RPW
         Ytb9EXDyPK13iPdi9l/1X8MwEwPgk39KHTJ7A55Xle4pHgQ8xssz02RfzCzQ3G8eOG+8
         VLJS2oNq0wX282XmQZmFyBnPicmbZcQLKZN/x60lERz1BxIURaQd1MPtWA2p9UE2RikU
         tQCg==
X-Gm-Message-State: APjAAAVK3aN/9s7gEj51oJmjKSb9SUvKrklhnmcEkiUuNSdyiUnKn+mO
        3h6iLISPKOUsx6rgBRAbXFNP221pNS9t7w==
X-Google-Smtp-Source: APXvYqxUxPCh2zTtls/G8B2nA/ioRKUNFEaXw0JBRt/6l+WtrYbNC0mZhQKV8wWHP7GixIC12DR/8g==
X-Received: by 2002:a63:2c50:: with SMTP id s77mr17537810pgs.182.1583133514798;
        Sun, 01 Mar 2020 23:18:34 -0800 (PST)
Received: from kernel.DHCP ([120.244.140.54])
        by smtp.googlemail.com with ESMTPSA id z127sm19257989pgb.64.2020.03.01.23.18.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Mar 2020 23:18:33 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH] KVM: X86: Fix dereference null cpufreq policy
Date:   Mon,  2 Mar 2020 15:15:36 +0800
Message-Id: <1583133336-7832-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Naresh Kamboju reported:

   Linux version 5.6.0-rc4 (oe-user@oe-host) (gcc version
  (GCC)) #1 SMP Sun Mar 1 22:59:08 UTC 2020
   kvm: no hardware support
   BUG: kernel NULL pointer dereference, address: 000000000000028c
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page
   PGD 0 P4D 0
   Oops: 0000 [#1] SMP NOPTI
   CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0-rc4 #1
   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
  04/01/2014
   RIP: 0010:kobject_put+0x12/0x1c0
   Call Trace:
    cpufreq_cpu_put+0x15/0x20
    kvm_arch_init+0x1f6/0x2b0
    kvm_init+0x31/0x290
    ? svm_check_processor_compat+0xd/0xd
    ? svm_check_processor_compat+0xd/0xd
    svm_init+0x21/0x23
    do_one_initcall+0x61/0x2f0
    ? rdinit_setup+0x30/0x30
    ? rcu_read_lock_sched_held+0x4f/0x80
    kernel_init_freeable+0x219/0x279
    ? rest_init+0x250/0x250
    kernel_init+0xe/0x110
    ret_from_fork+0x27/0x50
   Modules linked in:
   CR2: 000000000000028c
   ---[ end trace 239abf40c55c409b ]---
   RIP: 0010:kobject_put+0x12/0x1c0

cpufreq policy which is get by cpufreq_cpu_get() can be NULL if it is failure,
this patch takes care of it.

Fixes: aaec7c03de (KVM: x86: avoid useless copy of cpufreq policy)
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5de2006..3156e25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7195,10 +7195,12 @@ static void kvm_timer_init(void)
 
 		cpu = get_cpu();
 		policy = cpufreq_cpu_get(cpu);
-		if (policy && policy->cpuinfo.max_freq)
-			max_tsc_khz = policy->cpuinfo.max_freq;
+		if (policy) {
+			if (policy->cpuinfo.max_freq)
+				max_tsc_khz = policy->cpuinfo.max_freq;
+			cpufreq_cpu_put(policy);
+		}
 		put_cpu();
-		cpufreq_cpu_put(policy);
 #endif
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
-- 
2.7.4

