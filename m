Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF392361564
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 00:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbhDOWWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 18:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237404AbhDOWWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 18:22:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B08C061761
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n13so3907505ybp.14
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5bZDkTOmF30k3ylXE7mjWEUF6Se+XKGXeTtOG326tls=;
        b=u8/EHms+P5QHbtTJ6SsWhwk29xFysKHQdf/9xINwhk2Wxp21WIFSsVeUCy33wKtjFy
         lUmj0nJPEi1n3Oh0A/Bgumm6PBfeRQ6rZ6U/hC52JnbgBrzx6Jwpq61xXK+tFBYn07IA
         kAc09ehAkcpVLpAu8SPSKStvPEd9Ubx9twCwkgnSJZd30C8OLAntIF86x0Zdvht71NN5
         s84XV5pqBHrcqFv2Av1nDsm/Dn5rp/O/+/cSldZguahj7hUC9TWg1fG2Nd5xxJ9MgVCK
         hmjkzhRlEIteP178WSGuZ8PcLY0tZW6hKtnGHn1ErP7Lmb892CbNGFt4X8R+qosWioiv
         3SSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5bZDkTOmF30k3ylXE7mjWEUF6Se+XKGXeTtOG326tls=;
        b=WMSf6dOMG04I7O9E0xCj4w1yDxlC3Cjk9KPvaIu7IqkipIr08X3/3lML0HOeo7TpKy
         wfr23yberxivfwGLGR73lGig4x7TdR7Ef25JCdvaAwOUYPIGd+Y7rM0Eq8aOmiWSrXl2
         8NYwHizHKdaQkDBFo8yL5FGaK+UndEt7eyt5Oop8CAZ/Eh8yFpTLQOuyGwVCsw8yzF16
         WZ7nv3GKdcWDeI8imnu6gszzo7hKXEKIrrG7W+dxV4mxkEn8UoG7rY87XnJV8OvGUW8l
         f8hYi4FXhnTZOdoyNOv+93ysy2//OlVY4dITROMp9qKUYpi8kTCuX9ShVkaiGWIVLuag
         retg==
X-Gm-Message-State: AOAM5316lmxm4froxLyNPqcgo9aCT+2uh3+o9oZIrpJQfgtRjYqY9JSt
        YbSfrYgYxyAzITk+W02DpgkVki1lOXQ=
X-Google-Smtp-Source: ABdhPJzkSOmVcTYZbMZ5mFcI1gbLLhi87LjETeJ5cPYgxWeheNNd0DFYGFGeWJlxcCCk0oPTkVNLc+BLJCU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c93:ada0:6bbf:e7db])
 (user=seanjc job=sendgmr) by 2002:a25:f80e:: with SMTP id u14mr7738720ybd.428.1618525294052;
 Thu, 15 Apr 2021 15:21:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 15 Apr 2021 15:21:06 -0700
In-Reply-To: <20210415222106.1643837-1-seanjc@google.com>
Message-Id: <20210415222106.1643837-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210415222106.1643837-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH v3 9/9] KVM: Move instrumentation-safe annotations for
 enter/exit to x86 code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the instrumentation_{begin,end}() annonations from the common KVM
guest enter/exit helpers, and massage the x86 code as needed to preserve
the necessary annotations.  x86 is the only architecture whose transition
flow is tagged as noinstr, and more specifically, it is the only
architecture for which instrumentation_{begin,end}() can be non-empty.

No other architecture supports CONFIG_STACK_VALIDATION=y, and s390 is the
only other architecture that support CONFIG_DEBUG_ENTRY=y.  For
instrumentation annontations to be meaningful, both aformentioned configs
must be enabled.

Letting x86 deal with the annotations avoids unnecessary nops by
squashing back-to-back instrumention-safe sequences.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.h       | 4 ++--
 include/linux/kvm_host.h | 9 +--------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 285953e81777..b17857ac540b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -25,9 +25,9 @@ static __always_inline void kvm_guest_enter_irqoff(void)
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
-	instrumentation_end();
-
 	guest_enter_irqoff();
+	instrumentation_end();
+
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 444d5f0225cb..e5eb64019f47 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -339,9 +339,7 @@ static __always_inline void guest_enter_irqoff(void)
 	 * This is running in ioctl context so its safe to assume that it's the
 	 * stime pending cputime to flush.
 	 */
-	instrumentation_begin();
 	vtime_account_guest_enter();
-	instrumentation_end();
 
 	/*
 	 * KVM does not hold any references to rcu protected data when it
@@ -351,21 +349,16 @@ static __always_inline void guest_enter_irqoff(void)
 	 * one time slice). Lets treat guest mode as quiescent state, just like
 	 * we do with user-mode execution.
 	 */
-	if (!context_tracking_guest_enter_irqoff()) {
-		instrumentation_begin();
+	if (!context_tracking_guest_enter_irqoff())
 		rcu_virt_note_context_switch(smp_processor_id());
-		instrumentation_end();
-	}
 }
 
 static __always_inline void guest_exit_irqoff(void)
 {
 	context_tracking_guest_exit_irqoff();
 
-	instrumentation_begin();
 	/* Flush the guest cputime we spent on the guest */
 	vtime_account_guest_exit();
-	instrumentation_end();
 }
 
 static inline void guest_exit(void)
-- 
2.31.1.368.gbe11c130af-goog

