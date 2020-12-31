Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24492E7D67
	for <lists+kvm@lfdr.de>; Thu, 31 Dec 2020 01:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgLaA2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 19:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgLaA2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 19:28:07 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BFAC06179B
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:26 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id j1so31401917ybj.11
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rOxjhQpHu1RfWA8cWpiD6IGTVkEoEMcY9+NA6EUVZWk=;
        b=eWtJP4mxfNkHF6+f0Z+ZCUumhU5z4MG+btS9lZOP0MGoxttBnbiPVrOv/cs3QKr2pe
         yYHU/MiR5+CfS5HKckQfismEZ2onO1b43xvLt19DiaRfuuz7E5vm7ESC7NurhcvFBG4Y
         SIfyDAtMkAP2H3hvQd5HaKqfz6yoYoHBQorZSe+M7OH5gl0ySennnI9r2vuP5DPL3QMb
         NrfC+9yDGuMgcc9CPRSs9qNhB9PENGEY8C/jssqK9C16avVIu5pID2cquJ/3YPi0X5Nk
         xc5IqvX88gxCaEJ89h4E4N/UN8ewUCKNETDimIU3V1m4b24vBykeCZS9R9QY100hftEU
         lkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rOxjhQpHu1RfWA8cWpiD6IGTVkEoEMcY9+NA6EUVZWk=;
        b=kPdq6SfGAh81cDL4WjEjqDdpaBZVN+mRcEGjhIuKrUPcEe5Vsfs8NEwo7auY8kHrCl
         imDE7pfqDym3oJd57ncoF7tEOhvQineyY9FsV1iUuqi4zaDjmyGxodcjBDYpmA/dpECb
         2EH8ikEBJzWFalSCQp9/rabySWdiETjHYOT7qMC5oqVuWMP2Tt4FyFfkiwjjC33fcAQ+
         +G7P8YxOzGpVcp2qOcXerJ6olZC2Vm1apRUDEGPeBJPuo7p5OAvrSs2QDtefdvcuwQP9
         NqhRWPuh+WlqfrQ9yGKOx1dBkEgZoMgtTz5RhMAnC83jg1Hz9mwgRU47hWn9XGUamR3V
         zSNQ==
X-Gm-Message-State: AOAM5330Xo9sjuKO7Y9H//SCT+CFjhReWP/NFYilKSYSFYsY5YzGC3tc
        IzQw3ocIdEhvqsWhUnj+BAEI/7kXun4=
X-Google-Smtp-Source: ABdhPJxzJSFVMtUWiaSVuoQJJUIlDSp5lHxECjas4or3vPMGlBJ8HdaSd0PwczifhPn2MQG8W/VGjRXTDA0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:38d0:: with SMTP id f199mr75851834yba.8.1609374446107;
 Wed, 30 Dec 2020 16:27:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Dec 2020 16:26:54 -0800
In-Reply-To: <20201231002702.2223707-1-seanjc@google.com>
Message-Id: <20201231002702.2223707-2-seanjc@google.com>
Mime-Version: 1.0
References: <20201231002702.2223707-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 1/9] x86/virt: Eat faults on VMXOFF in reboot flows
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

Silently ignore all faults on VMXOFF in the reboot flows as such faults
are all but guaranteed to be due to the CPU not being in VMX root.
Because (a) VMXOFF may be executed in NMI context, e.g. after VMXOFF but
before CR4.VMXE is cleared, (b) there's no way to query the CPU's VMX
state without faulting, and (c) the whole point is to get out of VMX
root, eating faults is the simplest way to achieve the desired behaior.

Technically, VMXOFF can fault (or fail) for other reasons, but all other
fault and failure scenarios are mode related, i.e. the kernel would have
to magically end up in RM, V86, compat mode, at CPL>0, or running with
the SMI Transfer Monitor active.  The kernel is beyond hosed if any of
those scenarios are encountered; trying to do something fancy in the
error path to handle them cleanly is pointless.

Fixes: 1e9931146c74 ("x86: asm/virtext.h: add cpu_vmxoff() inline function")
Reported-by: David P. Reed <dpreed@deepplum.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 9aad0e0876fb..fda3e7747c22 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -30,15 +30,22 @@ static inline int cpu_has_vmx(void)
 }
 
 
-/** Disable VMX on the current CPU
+/**
+ * cpu_vmxoff() - Disable VMX on the current CPU
  *
- * vmxoff causes a undefined-opcode exception if vmxon was not run
- * on the CPU previously. Only call this function if you know VMX
- * is enabled.
+ * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
+ *
+ * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
+ * atomically track post-VMXON state, e.g. this may be called in NMI context.
+ * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
+ * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
+ * magically in RM, VM86, compat mode, or at CPL>0.
  */
 static inline void cpu_vmxoff(void)
 {
-	asm volatile ("vmxoff");
+	asm_volatile_goto("1: vmxoff\n\t"
+			  _ASM_EXTABLE(1b, %l[fault]) :::: fault);
+fault:
 	cr4_clear_bits(X86_CR4_VMXE);
 }
 
-- 
2.29.2.729.g45daf8777d-goog

