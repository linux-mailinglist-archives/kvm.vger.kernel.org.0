Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B489322557
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 06:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhBWF0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 00:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBWF0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 00:26:01 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE27FC061574;
        Mon, 22 Feb 2021 21:25:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t9so1047674pjl.5;
        Mon, 22 Feb 2021 21:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1Zd+6SGGzX9w5QvmKHBdsCtUaSK+dUjwE9j2QN/NjCI=;
        b=cDatUG1v1bsJMlsYVvsneG0Y6dVnQ7ceTxY8n9FT0acxQw9tbUFzBGKGENvgeBD8Ou
         ED7AwYOiZBbwF2oo4F6UaYNp/z6hd6tq1ryCox+E8EiOWWNB+KiR7fVT10Rmt8oBm86W
         rWT2JNB/lYCZSwQ9XWP8fSkmtQ4NjbqdawtMfCjm8/yxdINA95ImMDXrw/zZGNsZt7rA
         wEUDWHnkeJpYZ8Y0/tpbaZEm1f1wpCNnP0iXsX5U07H0K7FbqcySLTckeLl6ZnhNhxcp
         cCWczxFyF6NVt4XoF96cS7AJvFGFOYaaAOqWzNMEEqTvPgATiZ3kGFDC+1WFMtHqd18v
         vLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1Zd+6SGGzX9w5QvmKHBdsCtUaSK+dUjwE9j2QN/NjCI=;
        b=FRQOwboz8gD14TzdU1tleeeUUrpx30QSFte12kHvkkwz49NCgBgcQbkJXPngxxpfow
         Uq18RMGQ5jQ1QFpFl9BTpMGyrbcpIYIa8ZC5ypVwgqUGuWPVzlboAnKh1NXYpqJfESyp
         Iz4Xr0AUsaUZPVbnpxwHaEJg+rZF8ujjvNbks8zvQ2CcPbed7d/HzKvmX+hPf385GK/m
         cJP1/t9GCb5jJl8imZ53dmxJRcoD/Pmr6RrEdVWFxvMIT43h7u+pG/csiOTDCaEZ2DLd
         UPHSfY/4FT/dXzNfLdj/5dNAko7TVOxNhMFmk5oTy83iQXDVhHxRXRKmdY14w8+dffxy
         OfkA==
X-Gm-Message-State: AOAM5300yU3OT4fNFJDa62W6DeGlIHQXWoTHfawBerrSGRq+9fX1vRVl
        si3/+pUoGL1/0SNY987K9D4dHuWlIIA=
X-Google-Smtp-Source: ABdhPJzp8HozZoDI1nlPJ7qr8dmKPjvlG5VZkSHHCSvKQj3GjJwkahCE8bk9/y4VTjngGfvAPwv75A==
X-Received: by 2002:a17:902:d901:b029:e3:8f73:e759 with SMTP id c1-20020a170902d901b02900e38f73e759mr26292655plz.63.1614057917985;
        Mon, 22 Feb 2021 21:25:17 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id k69sm20869672pfd.4.2021.02.22.21.25.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Feb 2021 21:25:17 -0800 (PST)
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
Subject: [PATCH] x86/kvm: Fix broken irq restoration in kvm_wait
Date:   Tue, 23 Feb 2021 13:25:02 +0800
Message-Id: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
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

This patch fixes it by adding a local_irq_disable() after safe_halt() 
to avoid this warning.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5e78e01..688c84a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -853,8 +853,10 @@ static void kvm_wait(u8 *ptr, u8 val)
 	 */
 	if (arch_irqs_disabled_flags(flags))
 		halt();
-	else
+	else {
 		safe_halt();
+		local_irq_disable();
+	}
 
 out:
 	local_irq_restore(flags);
-- 
2.7.4

