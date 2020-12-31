Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4762E7D68
	for <lists+kvm@lfdr.de>; Thu, 31 Dec 2020 01:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgLaA2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 19:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgLaA2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 19:28:45 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80771C06179E
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:29 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id d187so31548776ybc.6
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=41wwaewfcJslPww7frzv8kWmZ0bKcG8QuMACLByWJEU=;
        b=wMCCuSsz+pinc1Mj+WpSYsfU1nTpkmw9iuZLLXwxdfGKdkVNpDGMntA6BRSabJyS20
         ZnSzKX94N2/XWIKYBi+BfKRV71OvxxokuM/+h17VtmWLrCIM2fUqweOhiwrVyITwix/o
         pb5nwHtRk/fKLQ/JCrLCtAgyA3SAQrDp53HH8vwcGzL1OpaPDrOX/7CErqQwijjfSVe9
         lSo7yP9KI8E2tYly5KdJNUytKeoj9cHNeTrr2hjmJiHhwfSwD3IeOZEKQ9I1eauS1qn7
         8EIKKsS7Em+1i/T72DB2dWcR+F9ZCOqFhRtXtAa/wi8ehCgW8SU6twx6mt1SLYMS2hwn
         t/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=41wwaewfcJslPww7frzv8kWmZ0bKcG8QuMACLByWJEU=;
        b=YxSzcAdQootxHZqzdw7qFXU0sfJDBjzWEDbRh57NYCX+7U16tGtr8FJgeibtvCqx/G
         pPUxOZLIqdHijzPQFDSkktIMLKyqy8HIicbNbOvXR0iNWOTJ3RqhCabEs/F12gnFX7PK
         auV6Z7kf16eqg6T7kaiLpKfx6XsrKOegtBlNXAIsry249L/N2nntE5Qbtq1UCPRJsdBe
         Qmleq3tFyu6sHPIt18uNOBeAQgQeWdMvF3k5iVuB4buJ3BGEQbWIK04cooy5IzGbDNpX
         rWcrUo03j3JiQV0qZAMuzjWeTeVI2xBcF4Wn+6hUdpwOnFDqbdRWghZ12126Xq3PMaft
         2ndQ==
X-Gm-Message-State: AOAM533PHl6GiqjFYr5IDyv30Y9ccJgREzEaE50f4HHlkS7eKz6qRlnJ
        XwNu0dU4/1aEtIzoW7a7z/zPiz7Vi7c=
X-Google-Smtp-Source: ABdhPJxbf3HbdMV1aaBlSXogwf9G9n/zBskYdZe0d0RHK0RHSyxpfbpVLkqSOXzyBWBDfO0j7+J4gxxiCOU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:d753:: with SMTP id o80mr73705503ybg.169.1609374448707;
 Wed, 30 Dec 2020 16:27:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Dec 2020 16:26:55 -0800
In-Reply-To: <20201231002702.2223707-1-seanjc@google.com>
Message-Id: <20201231002702.2223707-3-seanjc@google.com>
Mime-Version: 1.0
References: <20201231002702.2223707-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 2/9] x86/reboot: Force all cpus to exit VMX root if VMX is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David P . Reed" <dpreed@deepplum.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Force all CPUs to do VMXOFF (via NMI shootdown) during an emergency
reboot if VMX is _supported_, as VMX being off on the current CPU does
not prevent other CPUs from being in VMX root (post-VMXON).  This fixes
a bug where a crash/panic reboot could leave other CPUs in VMX root and
prevent them from being woken via INIT-SIPI-SIPI in the new kernel.

Fixes: d176720d34c7 ("x86: disable VMX on all CPUs on reboot")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David P. Reed <dpreed@deepplum.com>
[sean: reworked changelog and further tweaked comment]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/reboot.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index db115943e8bd..efbaef8b4de9 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -538,31 +538,21 @@ static void emergency_vmx_disable_all(void)
 	local_irq_disable();
 
 	/*
-	 * We need to disable VMX on all CPUs before rebooting, otherwise
-	 * we risk hanging up the machine, because the CPU ignores INIT
-	 * signals when VMX is enabled.
+	 * Disable VMX on all CPUs before rebooting, otherwise we risk hanging
+	 * the machine, because the CPU blocks INIT when it's in VMX root.
 	 *
-	 * We can't take any locks and we may be on an inconsistent
-	 * state, so we use NMIs as IPIs to tell the other CPUs to disable
-	 * VMX and halt.
+	 * We can't take any locks and we may be on an inconsistent state, so
+	 * use NMIs as IPIs to tell the other CPUs to exit VMX root and halt.
 	 *
-	 * For safety, we will avoid running the nmi_shootdown_cpus()
-	 * stuff unnecessarily, but we don't have a way to check
-	 * if other CPUs have VMX enabled. So we will call it only if the
-	 * CPU we are running on has VMX enabled.
-	 *
-	 * We will miss cases where VMX is not enabled on all CPUs. This
-	 * shouldn't do much harm because KVM always enable VMX on all
-	 * CPUs anyway. But we can miss it on the small window where KVM
-	 * is still enabling VMX.
+	 * Do the NMI shootdown even if VMX if off on _this_ CPU, as that
+	 * doesn't prevent a different CPU from being in VMX root operation.
 	 */
-	if (cpu_has_vmx() && cpu_vmx_enabled()) {
-		/* Disable VMX on this CPU. */
-		cpu_vmxoff();
+	if (cpu_has_vmx()) {
+		/* Safely force _this_ CPU out of VMX root operation. */
+		__cpu_emergency_vmxoff();
 
-		/* Halt and disable VMX on the other CPUs */
+		/* Halt and exit VMX root operation on the other CPUs. */
 		nmi_shootdown_cpus(vmxoff_nmi);
-
 	}
 }
 
-- 
2.29.2.729.g45daf8777d-goog

