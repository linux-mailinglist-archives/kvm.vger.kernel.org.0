Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DDB3116EF
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 00:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhBEXVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 18:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhBEKFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:05:12 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3752CC06121F
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:04:01 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o16so4200422pgg.5
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IC2QNWrsviuW49vH66X38HKXHrsgTnzDfoKNb+X8LdE=;
        b=1s/b1HqHxzpBnf2PB93OczXUYXJG6q/GyUoy/kuh8AcVvSYCkk7O1Wjs1Y4f85D596
         aN9gsFdBWYxz/wG+mjswPfAlgBK2JPjIKR+viON6bYq+FH3/62K058ppH68ihOgauCnS
         EQWdPDV154cJxO4HFkW80/C/BYnHEpOn60fo8OqbS8gT2X72/5E3u1Jtd5x7W1ocD6Kp
         +aipViAbOBeROIu2Iefc1njBoyNtjIpE+tVH6+G07k1Q5ICGDnYbGDB+5+M4c+nvLTSY
         7LcGypSFGy7JMt8UUxrvYEucDYT/3UjtegDSGy+koIrThPRqmF/+Z5L7XA/e0/l2utbY
         NDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IC2QNWrsviuW49vH66X38HKXHrsgTnzDfoKNb+X8LdE=;
        b=E9IOipjTWLUKQq8gKa4Kv98NGmKOHCdkZ2lt0D3WS8BPber0/SdPWt5mtRzErF9hk8
         mg9Cq8Sx7aUkTcPlVl22vII6sv/thAiE+ti4w9TGUE31zMVVMUSRSlaMRqQXpkKwIyKT
         u/Aic204Q4/ZGJee8G9arXnm2JFMAuKcauelEPnSmm8v7IiryZq7206m6PzvcJmqTipx
         HPGixlP5pqtsBMhcM+OpC7LOH6j+HZOZ8NVfbafGwN3RrUNlB07D0A69ySi6MFm3du/W
         pn/WfLNieAtB0fMLKOBqICCkcxrywjonjkYEsyqw78YaYHdmXisA6b8PcIrz57hFQUO+
         AkPw==
X-Gm-Message-State: AOAM531UJU3l6+O1G7NA6+HoV/2p20wEZGJrB3ysLLFyT8vIUS90lMyv
        NAoQBDzLwHRpky7+IHH2v4sppQ==
X-Google-Smtp-Source: ABdhPJy/VsIsFlwktXzo6Tnx2RQLugENjrdS/2ECxhSWrqiEXLIPa0Q78hUVvA2Q7EpNe/dm6BusPg==
X-Received: by 2002:a63:c64c:: with SMTP id x12mr3653133pgg.293.1612519440810;
        Fri, 05 Feb 2021 02:04:00 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.03.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:04:00 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RFC: timer passthrough 5/9] KVM: vmx: use tsc_adjust to enable tsc_offset timer passthrough
Date:   Fri,  5 Feb 2021 18:03:13 +0800
Message-Id: <20210205100317.24174-6-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

when in vm:
rdtsc = host_tsc * (TSC multiplier) + tsc_offset(<0)
so when vm write tsc_deadline_msr the value always less than
tsc stampcounter msr value, the irq never be triggered.

the tsc_adjust msr use as below, host execute
rdtsc = host_tsc + tsc_adjust

when vmentry, we set the tsc_adjust equal tsc_offset and vmcs
tsc offset filed equal 0, so the vm execute rdtsc the result like this:
rdtsc = host_tsc + tsc_adjust + 0
the tsc_deadline_msr value will equal tsc stampcounter msr and
the irq will trigger success.

Signed-off-by: Zhimin Feng <fengzhimin@bytedance.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index be8fc230f7c4..7971c9e755a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -534,6 +534,7 @@ struct tick_device {
 struct timer_passth_info {
 	u64 host_tscd;
 	bool host_in_tscdeadline;
+	u64 host_tsc_adjust;
 	struct clock_event_device *curr_dev;
 
 	void (*orig_event_handler)(struct clock_event_device *dev);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f824ee46e2d3..44b2fd59587e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6659,6 +6659,27 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
+static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, bool to_host)
+{
+	u64 tsc_adjust;
+	struct timer_passth_info *local_timer_info;
+
+	local_timer_info = &per_cpu(passth_info, smp_processor_id());
+
+	if (to_host) {
+		tsc_adjust = local_timer_info->host_tsc_adjust;
+		wrmsrl(MSR_IA32_TSC_ADJUST, tsc_adjust);
+		vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
+	} else {
+		rdmsrl(MSR_IA32_TSC_ADJUST, tsc_adjust);
+		local_timer_info->host_tsc_adjust = tsc_adjust;
+
+		wrmsrl(MSR_IA32_TSC_ADJUST, tsc_adjust + vcpu->arch.tsc_offset);
+		vmcs_write64(TSC_OFFSET, 0);
+
+	}
+}
+
 static void vmx_host_lapic_timer_offload(struct kvm_vcpu *vcpu)
 {
 	struct timer_passth_info *local_timer_info;
@@ -6690,6 +6711,7 @@ static void vmx_host_lapic_timer_offload(struct kvm_vcpu *vcpu)
 				PIN_BASED_VMX_PREEMPTION_TIMER);
 	}
 
+	vmx_adjust_tsc_offset(vcpu, false);
 	wrmsrl(MSR_IA32_TSCDEADLINE, 0);
 	if (vcpu->arch.tscd > guest_tscl) {
 		wrmsrl(MSR_IA32_TSCDEADLINE, vcpu->arch.tscd);
@@ -6711,6 +6733,7 @@ static void vmx_restore_passth_timer(struct kvm_vcpu *vcpu)
 	u64 guest_tscd;
 
 	if (vcpu->arch.timer_passth_enable) {
+		vmx_adjust_tsc_offset(vcpu, true);
 		local_timer_info = &per_cpu(passth_info, smp_processor_id());
 		host_tscd = local_timer_info->host_tscd;
 		rdmsrl(MSR_IA32_TSC_DEADLINE, guest_tscd);
-- 
2.11.0

