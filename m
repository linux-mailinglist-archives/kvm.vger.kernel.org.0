Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD23C1B6E1A
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 08:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgDXGXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 02:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726051AbgDXGXK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 02:23:10 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F6DC09B045;
        Thu, 23 Apr 2020 23:23:09 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t11so4175297pgg.2;
        Thu, 23 Apr 2020 23:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GikLm+2sMpfTcFbUsqFiKD0m1jTGsA7KiCbME+gQlgI=;
        b=bVYSpE7r+8u+N+GKZ0wHjRobNnUkmeTTruOsNhrJXRKU/ce1uIhUBU8yEfdQqtUIn7
         HkKKkfNe31pYIlafQhks4VjVlRYPECjddshsa+yPInWS+o0w++evATVMY3x/3mryNo4p
         7P7IvOTDrvF0QrwcFcR2kIv3iSXe26mrKmFGK2xIuqRvhHc8ZO860RWuifRMrsMu9X+K
         Y0xfyWwVCEkVi+jdr4YCmRCKdeFQG6uY7wsHS7LXMTrmDnuqAq+zu5arBZjHT3VRS2sJ
         /KqRseLflH0B5v88S2VKhZFoManN3Pl1QXov3KqPBJ5Zovi/FtFh4TS+oTJI7Igrb2eT
         HolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GikLm+2sMpfTcFbUsqFiKD0m1jTGsA7KiCbME+gQlgI=;
        b=g/4aAqNIh7NSd11klBDwtRcv0Fqb6WpoLcutyCbdwuZZGF+e2lDlFuO37NFymdqpag
         R1TyufVmP1hDWT6M+4YTjL1vHmTflH52Kbi47NfsQA66O7mvDFNX5RMiphOKh+E9jfOs
         XYGkhB/TY+r6nfpdFyqLeChU67GqtZwoFy8YG9HS3ApTDeKlVZO1ev4TW2sghlIogzuH
         UyhQ9XhaL1Zl/xDe5RY1YDeZ4G1wt8kw8yGLu0vDOgXeZFY1rXSeplhTSYUl8ExqjhBz
         ljuG7XrShk1nXwD9H4Lwwdrdnf0+U/X9Fw67QJYSvKVLSeFx5+pbJzxASQUhkM0D9drz
         I5/w==
X-Gm-Message-State: AGi0PuYlDVKOna7J1oWm12VfEedK8D/158R89/PcES0cMy+XZpBSxTaK
        Fs2gdBZUeMhsVxDwI1np8r0SVFs3
X-Google-Smtp-Source: APiQypK/jTCPL327MGXDIrfzXSb3ChDp/4QmJsxtoOJ8rF8Zoo8fgmYSzurNJAVFmSxWlJwuuYlS7A==
X-Received: by 2002:a63:5413:: with SMTP id i19mr7985408pgb.213.1587709388225;
        Thu, 23 Apr 2020 23:23:08 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l30sm3920674pgu.29.2020.04.23.23.23.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 23:23:07 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v3 4/5] KVM: X86: TSCDEADLINE MSR emulation fastpath
Date:   Fri, 24 Apr 2020 14:22:43 +0800
Message-Id: <1587709364-19090-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch implements tscdealine msr emulation fastpath, after wrmsr 
tscdeadline vmexit, handle it as soon as possible and vmentry immediately 
without checking various kvm stuff when possible.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 18 ++++++++++++------
 arch/x86/kvm/x86.c   | 30 ++++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 38f7dc9..3589237 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1593,7 +1593,7 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 	}
 }
 
-static void apic_timer_expired(struct kvm_lapic *apic)
+static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
 	struct kvm_timer *ktimer = &apic->lapic_timer;
@@ -1604,6 +1604,12 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 
+	if (!from_timer_fn && vcpu->arch.apicv_active) {
+		WARN_ON(kvm_get_running_vcpu() != vcpu);
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}
+
 	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
 		if (apic->lapic_timer.timer_advance_ns)
 			__kvm_wait_lapic_expire(vcpu);
@@ -1643,7 +1649,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
 		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_HARD);
 	} else
-		apic_timer_expired(apic);
+		apic_timer_expired(apic, false);
 
 	local_irq_restore(flags);
 }
@@ -1751,7 +1757,7 @@ static void start_sw_period(struct kvm_lapic *apic)
 
 	if (ktime_after(ktime_get(),
 			apic->lapic_timer.target_expiration)) {
-		apic_timer_expired(apic);
+		apic_timer_expired(apic, false);
 
 		if (apic_lvtt_oneshot(apic))
 			return;
@@ -1813,7 +1819,7 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 		if (atomic_read(&ktimer->pending)) {
 			cancel_hv_timer(apic);
 		} else if (expired) {
-			apic_timer_expired(apic);
+			apic_timer_expired(apic, false);
 			cancel_hv_timer(apic);
 		}
 	}
@@ -1863,7 +1869,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 		goto out;
 	WARN_ON(swait_active(&vcpu->wq));
 	cancel_hv_timer(apic);
-	apic_timer_expired(apic);
+	apic_timer_expired(apic, false);
 
 	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
 		advance_periodic_target_expiration(apic);
@@ -2369,7 +2375,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
 
-	apic_timer_expired(apic);
+	apic_timer_expired(apic, true);
 
 	if (lapic_is_periodic(apic)) {
 		advance_periodic_target_expiration(apic);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4561104..99061ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1616,27 +1616,45 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	return 1;
 }
 
+static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
+{
+	if (!kvm_x86_ops.set_hv_timer ||
+		kvm_mwait_in_guest(vcpu->kvm) ||
+		kvm_can_post_timer_interrupt(vcpu))
+		return 1;
+
+	kvm_set_lapic_tscdeadline_msr(vcpu, data);
+	return 0;
+}
+
 enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
-	int ret = 0;
+	int ret = EXIT_FASTPATH_NONE;
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
 		data = kvm_read_edx_eax(vcpu);
-		ret = handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
+		if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data))
+			ret = EXIT_FASTPATH_SKIP_EMUL_INS;
+		break;
+	case MSR_IA32_TSCDEADLINE:
+		data = kvm_read_edx_eax(vcpu);
+		if (!handle_fastpath_set_tscdeadline(vcpu, data))
+			ret = EXIT_FASTPATH_CONT_RUN;
 		break;
 	default:
-		return EXIT_FASTPATH_NONE;
+		ret = EXIT_FASTPATH_NONE;
 	}
 
-	if (!ret) {
+	if (ret != EXIT_FASTPATH_NONE) {
 		trace_kvm_msr_write(msr, data);
-		return EXIT_FASTPATH_SKIP_EMUL_INS;
+		if (ret == EXIT_FASTPATH_CONT_RUN)
+			kvm_skip_emulated_instruction(vcpu);
 	}
 
-	return EXIT_FASTPATH_NONE;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
-- 
2.7.4

