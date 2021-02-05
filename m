Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477AB3108B6
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 11:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhBEKId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 05:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhBEKF4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:05:56 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83334C0611C2
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:04:30 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d13so3325263plg.0
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EOkSmx0nzWCg7Ju8BIKgOHPEShmKKy8TZJh1ZUBU3Qc=;
        b=yjCWfwET4vQjJkjSviS4kVLYQNaO/QnkKsUO5WKnejqXaSYCTGPC0ZXtxVH8BylLef
         w4kv5bKY88YXSxeCHqcgT9HIfZCoHxIJuRXtogByYc4N3rX9NKMo5EHKGClyMIUYWMOU
         6kvb0spqJV/QclRQxSR4fBwPERG4ytoVgw9IL1IhbHZuID7jUrp5Z3huTb5ddNj7Q5f6
         0EvehEgPeb2cKeSDPa3b5ycTj5vJ6loU2eaKO2elBGXTQA4igRO1e24J++p7RgjoHtrR
         ZEEaITpaaLt92bxZ+vEAzWcECyaTgT53ZB6zNH8OGvWvp+NRFYYddGZ+QaQnFbEriRna
         Zv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EOkSmx0nzWCg7Ju8BIKgOHPEShmKKy8TZJh1ZUBU3Qc=;
        b=HXJ6l3g7+qhMiu27olvtyYyXOmqDfwv1Q46qVJuirN3y7iuZdilL9T2prBOM2Y2A4h
         gYAbABhLkx06X8bHajB7GXig+XJpSrpR+rx+0mZQ13PwC0dM9D+ZfJCVgVkZXkNLfVvT
         qLoxGPl2kpUfPPehQ7r6Gf98G+s5rsJRoYSN7ok+z1T5aHTRMQHXppfiYMhCxPZtsYIk
         u4TSaR4f5ooTR2xsFwchCoRP2EczMeoPg5XhRVaz9x5jwW+4RjSU8dGOFjVNnyx2lJzK
         LHQj6MC4TNg5DUvf5eN+8WzXcP3VGT5toTqRuSBwUwYuFhLPJADKHc+NTBUxf8nt/Q0W
         zZFQ==
X-Gm-Message-State: AOAM531vg8p9OeQVE5nrqHOpvuxH+1QWBMqs90p5DCy+/JbKLlRdnuRi
        +ftJnGLvvOZJQdTqhdfVDxIghQ==
X-Google-Smtp-Source: ABdhPJyvFAseeMpr8cI86pNzbqDS1BIzuH0SOEo0fdHC4ysLMv2wevxsNtHvNeZXKOseN2pVOpI/nQ==
X-Received: by 2002:a17:90a:46cb:: with SMTP id x11mr3492995pjg.124.1612519470112;
        Fri, 05 Feb 2021 02:04:30 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.04.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:04:29 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RFC: timer passthrough 9/9] KVM: vmx: query the state of timer-passth for vm
Date:   Fri,  5 Feb 2021 18:03:17 +0800
Message-Id: <20210205100317.24174-10-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

query the state of timer passthrough of specific vm

Signed-off-by: Zhimin Feng <fengzhimin@bytedance.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
 arch/x86/kvm/x86.c              |  6 ++++++
 include/uapi/linux/kvm.h        |  1 +
 tools/include/uapi/linux/kvm.h  |  1 +
 5 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9855ef419793..189c4f6f9d5d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1306,6 +1306,7 @@ struct kvm_x86_ops {
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	void (*switch_to_sw_timer)(struct kvm_vcpu *vcpu);
 	int (*set_timer_passth_state)(struct kvm *kvm, void *argp);
+	int (*get_timer_passth_state)(struct kvm *kvm, void __user *argp);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b88f744478e9..b760aa7bc6d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7883,6 +7883,16 @@ static int vmx_set_timer_passth_state(struct kvm *kvm, void *argp)
 	return r;
 }
 
+static int vmx_get_timer_passth_state(struct kvm *kvm, void __user *argp)
+{
+	int state = atomic_read(&kvm->timer_passth_state);
+
+	if (copy_to_user(argp, &state, sizeof(state)))
+		return -1;
+
+	return 0;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -8013,6 +8023,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.switch_to_sw_timer = vmx_passth_switch_to_sw_timer,
 	.set_timer_passth_state = vmx_set_timer_passth_state,
+	.get_timer_passth_state = vmx_get_timer_passth_state,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7db74bd9d362..a32927697e82 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5698,6 +5698,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = kvm_x86_ops.set_timer_passth_state(kvm, argp);
 		break;
 	}
+	case KVM_GET_TIMER_PASSTH_STATE: {
+		r = -EFAULT;
+		if (kvm_x86_ops.get_timer_passth_state)
+			r = kvm_x86_ops.get_timer_passth_state(kvm, argp);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6e26bc342599..2c0cefb8ffe2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1558,6 +1558,7 @@ struct kvm_pv_cmd {
 #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
 
 #define KVM_SET_TIMER_PASSTH_STATE  _IO(KVMIO,   0xc7)
+#define KVM_GET_TIMER_PASSTH_STATE  _IO(KVMIO,   0xc8)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 6e26bc342599..2c0cefb8ffe2 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1558,6 +1558,7 @@ struct kvm_pv_cmd {
 #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
 
 #define KVM_SET_TIMER_PASSTH_STATE  _IO(KVMIO,   0xc7)
+#define KVM_GET_TIMER_PASSTH_STATE  _IO(KVMIO,   0xc8)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.11.0

