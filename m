Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0D633ABD3
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 07:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhCOGzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 02:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhCOGzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 02:55:40 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02468C061574;
        Sun, 14 Mar 2021 23:55:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id s21so5976696pfm.1;
        Sun, 14 Mar 2021 23:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pNjaEjC60Q50gikxhUdZUYYiIOugeurKbAsBaEi4TgQ=;
        b=lwwxmO78ifaVyeZUWmN3XOkuZbwXbDBvkuTkkBOSMjIa3RcS4ZqRcq4Zv/f5zvAsWK
         rcI0F9ZuovKEDRMmOeKsWbRAQ3xhfA9Y6Gy251QVoTQk4wDodNLrBnfwC+TxG4HK3KZN
         iX7h5jrkvbU/X8xYERzsjm0NMMZHjZd3SDgoVMOmuuGT0nUtNt6j2970YWjFUiR5cFME
         azcYeTZg4yCTWYRslsIH+1m8Oc4N4ji6AZM1yZkBJtp9jeWa4xHtJPuIvPyATavGCL31
         SztSbTIYpJDyQk3aQiGFICbuGs2SHByfpuLaExh5YrrtzP2gobnA88FjxrfhQbsgs9Zx
         N0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pNjaEjC60Q50gikxhUdZUYYiIOugeurKbAsBaEi4TgQ=;
        b=t2bXHCLdbjw0bUw3pCzb4woHziXpTWYfrtdAy/QhsCsOXi2E4YJym/clRa5kgVGnMN
         MT2mjlmO4vChG3UgVmGps8pM3a/Kyv6KQLJ2e5vk5TsJY/Eslu9kFEtNVFUXcZ8uWGJT
         0n+VYbSb+g0fjNCIpAS68sEheY+zZaKEAy6WR8LJJ82iL1+2OPQfoVA6t88cykK+eh6B
         lDvTvWappHLYOHt39PFR25h0Q4ShUjq0ExsznGnCNTFku+uLM6dpTUvsiTNK2rjTx/62
         XIc7vMsoIjtsRSj0zpkMb/fhqSRHM+bvJtOVbt9lZrOzyVk0IM/pvSfLny7EXmGELuho
         tK3g==
X-Gm-Message-State: AOAM5337EK9LZ1wPrnt7OMxwsEmSJVxZDUqlBOCns35r3yYgztzXcYJF
        8HN3F1pJYbRcKizEzOwlCZqczxne37M=
X-Google-Smtp-Source: ABdhPJx6nLjQ+jnlByTPf5t/X5LY01MFQoPvhbltV13isKRo0OzMMlhpJUIzSW+fXGK7Ka3e3zYkfw==
X-Received: by 2002:a63:5c23:: with SMTP id q35mr22171258pgb.418.1615791339092;
        Sun, 14 Mar 2021 23:55:39 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id y20sm12472413pfo.210.2021.03.14.23.55.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Mar 2021 23:55:38 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v3] x86/kvm: Fix broken irq restoration in kvm_wait
Date:   Mon, 15 Mar 2021 14:55:28 +0800
Message-Id: <1615791328-2735-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

After commit 997acaf6b4b59c (lockdep: report broken irq restoration), the guest 
splatting below during boot:

 raw_local_irq_restore() called with IRQs enabled
 WARNING: CPU: 1 PID: 169 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x26/0x30
 Modules linked in: hid_generic usbhid hid
 CPU: 1 PID: 169 Comm: systemd-udevd Not tainted 5.11.0+ #25
 RIP: 0010:warn_bogus_irq_restore+0x26/0x30
 Call Trace:
  kvm_wait+0x76/0x90
  __pv_queued_spin_lock_slowpath+0x285/0x2e0
  do_raw_spin_lock+0xc9/0xd0
  _raw_spin_lock+0x59/0x70
  lockref_get_not_dead+0xf/0x50
  __legitimize_path+0x31/0x60
  legitimize_root+0x37/0x50
  try_to_unlazy_next+0x7f/0x1d0
  lookup_fast+0xb0/0x170
  path_openat+0x165/0x9b0
  do_filp_open+0x99/0x110
  do_sys_openat2+0x1f1/0x2e0
  do_sys_open+0x5c/0x80
  __x64_sys_open+0x21/0x30
  do_syscall_64+0x32/0x50
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The irqflags handling in kvm_wait() which ends up doing:

	local_irq_save(flags);
	safe_halt();
	local_irq_restore(flags);

which triggered a new consistency checking, we generally expect 
local_irq_save() and local_irq_restore() to be pared and sanely 
nested, and so local_irq_restore() expects to be called with 
irqs disabled. 

This patch fixes it by playing local_irq_disable()/enable() directly.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * per Sean's suggestion

 arch/x86/kernel/kvm.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5e78e01..72dbb74 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -836,28 +836,25 @@ static void kvm_kick_cpu(int cpu)
 
 static void kvm_wait(u8 *ptr, u8 val)
 {
-	unsigned long flags;
-
 	if (in_nmi())
 		return;
 
-	local_irq_save(flags);
-
-	if (READ_ONCE(*ptr) != val)
-		goto out;
-
 	/*
 	 * halt until it's our turn and kicked. Note that we do safe halt
 	 * for irq enabled case to avoid hang when lock info is overwritten
 	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
 	 */
-	if (arch_irqs_disabled_flags(flags))
-		halt();
-	else
-		safe_halt();
+	if (irqs_disabled()) {
+		if (READ_ONCE(*ptr) == val)
+			halt();
+	} else {
+		local_irq_disable();
 
-out:
-	local_irq_restore(flags);
+		if (READ_ONCE(*ptr) == val)
+			safe_halt();
+
+		local_irq_enable();
+	}
 }
 
 #ifdef CONFIG_X86_32
-- 
2.7.4

