Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464727A2C7B
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbjIPAe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbjIPAeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:34:24 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C645810D9
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:32:05 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59b5a586da6so52660347b3.1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824325; x=1695429125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xxhu5mShS80K2/3vPmWMk/nseLaV4p5fitYU0fke5+k=;
        b=I0twIbH0JWDnve96saXAKVyhd09K4ELG8M0LyS636cxkXlCdGwfc8cMH/2napwy6L6
         kwxP8eYF66+YeOwkMvIAfRGMqc+Idqqzof6dupRSi7LsejOODbUYP43KPeQzeITwE5pu
         Rq442nYS09zx/bwnt9NFvBkQ7bJ8b8rZhUNM99sGT3cE1Vmu0I6QA0ngcoF/0AFqt/3g
         abOA5+iG7SRrFJKspHTWyb0K7zSMVzmVb0QhxUtsK7vEsDBABuS9q7jnsYrmVP9PTar4
         aa3kYKL8Rxgh2n+rtckXA9FfTVW3KksoNht9J/SSkTQlGfbIUf4Quy9U9kfsgwP4Zc14
         fgBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824325; x=1695429125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xxhu5mShS80K2/3vPmWMk/nseLaV4p5fitYU0fke5+k=;
        b=eNgMZ8hJ4bmC96rKvAIST3hXdY9nuQpIugfO/Jp+O8ki82FhPSaxXxbmdHas2wZXFO
         tlSQe2LmS3FZH4vJYyQiPyAW0X7uHuNbNqKHCPVBPgADwsHxeEBtSfS21faLnglNocfH
         4LmD68ak0qrs2JDmgvjnDYc0XENOripzAcEOF8oQd9f/z9w33v8i5hRP2p9MpgpfFMdz
         dMwPhl9abJWTAitFl4E+9HrYoPcQFnjF0FpVr0WaNnBIWHPk8f5loAPVFifa/7dPOywy
         bJOnSnGLFZ6GZBxeJ168ZOAoz4Y6o+hiF/SbmEEo8ly8GtJJrHumJSccFLDqw8yNftZi
         rzQw==
X-Gm-Message-State: AOJu0Yz6z9etIv56r4gcHK2SaO7h31rQ3RhdRswVMNh6FXOcT2EJZgJ1
        /sxTEVES6kQK+SZCWDvRbyteOvlP9nw=
X-Google-Smtp-Source: AGHT+IFivAqBzULaKYZ+rdlM5WV3p7FxezM4z6b9SH0+UFxp1erLN5VtiAhqE4c7vi4i2igDi9x6k3utDco=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2f05:b0:589:a533:405b with SMTP id
 ev5-20020a05690c2f0500b00589a533405bmr205315ywb.3.1694824325035; Fri, 15 Sep
 2023 17:32:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:31:14 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-23-seanjc@google.com>
Subject: [PATCH 22/26] entry/kvm: KVM: Move KVM details related to
 signal/-EINTR into KVM proper
From:   Sean Christopherson <seanjc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move KVM's morphing of pending signals into exits to userspace into KVM
proper, and drop the @vcpu param from xfer_to_guest_mode_handle_work().
How KVM responds to -EINTR is a detail that really belongs in KVM itself,
and removing the non-KVM call to kvm_handle_signal_exit() will allow
hiding said API and the definition of "struct kvm_vcpu" from the kernel.

Alternatively, entry/kvm.c could be treated as part of KVM, i.e. be given
access to KVM internals, but that's not obviously better than having KVM
react to -EINTR (though it's not obviously worse either).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c      |  3 +--
 arch/riscv/kvm/vcpu.c     |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  1 -
 arch/x86/kvm/x86.c        |  3 +--
 include/linux/entry-kvm.h |  3 +--
 include/linux/kvm_host.h  | 13 ++++++++++++-
 kernel/entry/kvm.c        | 11 ++++-------
 7 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6480628197b4..641df091e46b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -6,7 +6,6 @@
 
 #include <linux/bug.h>
 #include <linux/cpu_pm.h>
-#include <linux/entry-kvm.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
@@ -929,7 +928,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/*
 		 * Check conditions before entering the guest
 		 */
-		ret = xfer_to_guest_mode_handle_work(vcpu);
+		ret = kvm_xfer_to_guest_mode_handle_work(vcpu);
 		if (!ret)
 			ret = 1;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 82229db1ce73..c313f4e90e70 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -667,7 +667,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	while (ret > 0) {
 		/* Check conditions before entering the guest */
-		ret = xfer_to_guest_mode_handle_work(vcpu);
+		ret = kvm_xfer_to_guest_mode_handle_work(vcpu);
 		if (ret)
 			continue;
 		ret = 1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index faf0071566ef..43b87ad5fde8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <linux/tboot.h>
 #include <linux/trace_events.h>
-#include <linux/entry-kvm.h>
 
 #include <asm/apic.h>
 #include <asm/asm.h>
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..aab095f89d9e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -59,7 +59,6 @@
 #include <linux/sched/stat.h>
 #include <linux/sched/isolation.h>
 #include <linux/mem_encrypt.h>
-#include <linux/entry-kvm.h>
 #include <linux/suspend.h>
 #include <linux/smp.h>
 
@@ -10987,7 +10986,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 
 		if (__xfer_to_guest_mode_work_pending()) {
 			kvm_vcpu_srcu_read_unlock(vcpu);
-			r = xfer_to_guest_mode_handle_work(vcpu);
+			r = kvm_xfer_to_guest_mode_handle_work(vcpu);
 			kvm_vcpu_srcu_read_lock(vcpu);
 			if (r)
 				return r;
diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index e7d90d06e566..e235a91d28fc 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -42,11 +42,10 @@ static inline int arch_xfer_to_guest_mode_handle_work(unsigned long ti_work)
 /**
  * xfer_to_guest_mode_handle_work - Check and handle pending work which needs
  *				    to be handled before going to guest mode
- * @vcpu:	Pointer to current's VCPU data
  *
  * Returns: 0 or an error code
  */
-int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu);
+int xfer_to_guest_mode_handle_work(void);
 
 /**
  * xfer_to_guest_mode_prepare - Perform last minute preparation work that
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb6c6109fdca..d520d6801070 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2,7 +2,7 @@
 #ifndef __KVM_HOST_H
 #define __KVM_HOST_H
 
-
+#include <linux/entry-kvm.h>
 #include <linux/types.h>
 #include <linux/hardirq.h>
 #include <linux/list.h>
@@ -2293,6 +2293,17 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 	vcpu->run->exit_reason = KVM_EXIT_INTR;
 	vcpu->stat.signal_exits++;
 }
+
+static inline int kvm_xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu)
+{
+	int r = xfer_to_guest_mode_handle_work();
+
+	if (r) {
+		WARN_ON_ONCE(r != -EINTR);
+		kvm_handle_signal_exit(vcpu);
+	}
+	return r;
+}
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
 /*
diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index c2fc39824157..872617468b4a 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -1,17 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/entry-kvm.h>
-#include <linux/kvm_host.h>
 
-static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
+static int xfer_to_guest_mode_work(unsigned long ti_work)
 {
 	do {
 		int ret;
 
-		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
-			kvm_handle_signal_exit(vcpu);
+		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 			return -EINTR;
-		}
 
 		if (ti_work & _TIF_NEED_RESCHED)
 			schedule();
@@ -28,7 +25,7 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 	return 0;
 }
 
-int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu)
+int xfer_to_guest_mode_handle_work(void)
 {
 	unsigned long ti_work;
 
@@ -44,6 +41,6 @@ int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu)
 	if (!(ti_work & XFER_TO_GUEST_MODE_WORK))
 		return 0;
 
-	return xfer_to_guest_mode_work(vcpu, ti_work);
+	return xfer_to_guest_mode_work(ti_work);
 }
 EXPORT_SYMBOL_GPL(xfer_to_guest_mode_handle_work);
-- 
2.42.0.459.ge4e396fd5e-goog

