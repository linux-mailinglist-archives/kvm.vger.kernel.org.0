Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83F6339A89
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhCMAwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhCMAvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:51:37 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BA9C061574;
        Fri, 12 Mar 2021 16:51:36 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so11865649pjg.5;
        Fri, 12 Mar 2021 16:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dRSHTuJXO3IQ/87o0yBBwkk9pun6bTQgoCwjJVxdHws=;
        b=qtiWt0VH65vYAQRqSWgkuE/sWwW3Ol15GPaIvTnOeXCaK2iMNYEvDf1RqkLjyOlDrr
         vk1YcWKcaDEg/422Y46tItRwFlerZY/G/uKQDigI7/NLg2GDacaBQcXEjAQVaVtnFRxU
         NexbK/b1wqT8fZWym+XTubm5aZqyu9lnQJXwg41rIhQ/ENgCFMIdynjt8fg+nSoRhD1Q
         tAmzOhgH8r2Ut7Jlbv0hXXhFAVnn982EnI4FgWeXZYQCJEE7XQGQItyQOQxOzA3hljTf
         usvhgpc/6ZTT1jb2jb7oRCh9O3BTGq/CavBULL+sBqXtVN8QEYGzuI/IeUd1nSzep8Vo
         vwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dRSHTuJXO3IQ/87o0yBBwkk9pun6bTQgoCwjJVxdHws=;
        b=iL64SGp/uE2C+Gyhzy8UxRT7/VPpxLJRtca6coc4OXKuw4Nf++QsROClEHUidMS5Ra
         GfSETEsfqiglS5SI0yyttQRWBTTrjMzizNIwRPD+qUCNAmiDD0okmetkJGaH7qsLjTiY
         tNyEReOGwnzrPuf1s7u95obhSHJn6jXJngZ/UVFe1QMyasGXOeq+90ZOPjaN0uXZ2Wt0
         8uT0B8o00r4ldWnE4bO3Zt1pgxvnoJsnJYKyOF3fnjkBXI/1ncUlmWYY/mnxen9fLSn7
         YD2lbL+sz0tIKn/qlJL6QtVvq/rE+uWwgAoam/MJygAWHXWlW2T5YyRrEPnfuI5lU26t
         +Ulg==
X-Gm-Message-State: AOAM533EaxR59QFsPfm3HePXaKMZeH0ZG4B/nHrpmSGcbjwkdTwl/gWl
        dl7CueLpyysRa2QJU0HugS+KPbbDAf8=
X-Google-Smtp-Source: ABdhPJx7CPOsQEzdnXkvuUX6xzBs+2dK2AAtC1rOSPg65XZ2aZYOJHwYyTFLUXpXCo6d4pEFVIc9yQ==
X-Received: by 2002:a17:902:eb11:b029:e4:a5c3:4328 with SMTP id l17-20020a170902eb11b02900e4a5c34328mr1084621plb.7.1615596696086;
        Fri, 12 Mar 2021 16:51:36 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id i10sm14380849pjm.1.2021.03.12.16.51.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Mar 2021 16:51:35 -0800 (PST)
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
Subject: [PATCH v2] x86/kvm: Fix broken irq restoration in kvm_wait
Date:   Sat, 13 Mar 2021 08:51:25 +0800
Message-Id: <1615596685-22269-1-git-send-email-wanpengli@tencent.com>
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
v1 -> v2:
 * select the alternative fix

 arch/x86/kernel/kvm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5e78e01..7127aef 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -836,12 +836,13 @@ static void kvm_kick_cpu(int cpu)
 
 static void kvm_wait(u8 *ptr, u8 val)
 {
-	unsigned long flags;
+	bool disabled = irqs_disabled();
 
 	if (in_nmi())
 		return;
 
-	local_irq_save(flags);
+	if (!disabled)
+		local_irq_disable();
 
 	if (READ_ONCE(*ptr) != val)
 		goto out;
@@ -851,13 +852,14 @@ static void kvm_wait(u8 *ptr, u8 val)
 	 * for irq enabled case to avoid hang when lock info is overwritten
 	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
 	 */
-	if (arch_irqs_disabled_flags(flags))
+	if (disabled)
 		halt();
 	else
 		safe_halt();
 
 out:
-	local_irq_restore(flags);
+	if (!disabled)
+		local_irq_enable();
 }
 
 #ifdef CONFIG_X86_32
-- 
2.7.4

