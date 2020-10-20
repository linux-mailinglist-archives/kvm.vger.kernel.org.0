Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B5E2880AB
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 05:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgJIDVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 23:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgJIDVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 23:21:39 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38603C0613D2;
        Thu,  8 Oct 2020 20:21:39 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 144so5676230pfb.4;
        Thu, 08 Oct 2020 20:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0n2V4MNRGwK1cK7V9UjFbAKsyNZxYNY7DcB/CQ3zBuc=;
        b=FmR7r7WuUzf6gUGF6OFjv2dQL5leGw/lgwp81U2pADktuMUVBLv7fwGXphDnnbvyzB
         QyOolcHzcRu4uPTA1p6DAvn/hTv/HX3v/XDXJmX/lGzsl8Mct2hd3NSIJyBgMLyNR/Lc
         mE+X8NR4Us1Zx7B3D4mzGR4x566SJ8XB422YLPkIQYLmlrPGtv1X/fQ5f4uJGrRxm/rV
         wZ/oiDyDEiaXaXCroTtEOzCqCXm8RPJNGYMIRXRN+pKFUMFeADBn4U23UzSsgFit/LIB
         kvULcnWtjB8frMWwi/58Bsnk3GX+LToNHhM2FV4LNRiNu2+vBpQ7MboDHh77LVhmKtwg
         wFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0n2V4MNRGwK1cK7V9UjFbAKsyNZxYNY7DcB/CQ3zBuc=;
        b=XynTTp8kct97y735f6bPt4ohPcJXaLGlGHIJoU6iI3qlIsZGnqLISHSdzr5Q07gVYd
         apdPybabBWfRdWB/FV/zekfd5r3pQB/edHiIH6+edgwlYSDU2m9tIwyuiFZbAO0nUVpI
         52EWfBROgA9xsiV8KZ65/G1f+k5qYaMcxKQLllHody49LOex9XKydYQxXVruyIDuPCQu
         lUUzMqi12C2Xic8AhYPjA0TtK6RZn1tcpp6X4K2tC5BP5E9qj8eYzGMGU+Q/xM+L+J8Y
         z9CLxKV8L2H/lD9B7QhMYX0ebB+1robDt9Lqo72B9IDin4BoRJ650vMc7q/y1xYRgCFB
         HGzg==
X-Gm-Message-State: AOAM531nNfo3V3TDIQuW6L17eARUKa3X7REBx8JKx3ZVlQCibRAImKjJ
        TjwPuxJ1XVLqrzTQoNciCnL2uzR8udPB
X-Google-Smtp-Source: ABdhPJxzqbUV/5/fLWGXY727cgDJb+dYic2DCum+KeYwdQN1029d1bqNe6L0CaPXNlAY0CvZLda1AA==
X-Received: by 2002:a17:90a:248:: with SMTP id t8mr2458390pje.64.1602213698403;
        Thu, 08 Oct 2020 20:21:38 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id gl24sm378241pjb.50.2020.10.08.20.21.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 20:21:37 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v2] KVM: x86: Add tracepoint for dr_write/dr_read
Date:   Fri,  9 Oct 2020 11:21:30 +0800
Message-Id: <20201009032130.6774-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

When vmexit occurs caused by accessing dr, there is no tracepoint to track
this action. Add tracepoint for this on x86 kvm.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
v1 -> v2:
 * Improve the changelog 

 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/trace.h   | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c | 10 ++++++++--
 arch/x86/kvm/x86.c     |  1 +
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4f401fc6a05d..52c69551aea4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2423,12 +2423,14 @@ static int dr_interception(struct vcpu_svm *svm)
 		if (!kvm_require_dr(&svm->vcpu, dr - 16))
 			return 1;
 		val = kvm_register_read(&svm->vcpu, reg);
+		trace_kvm_dr_write(dr - 16, val);
 		kvm_set_dr(&svm->vcpu, dr - 16, val);
 	} else {
 		if (!kvm_require_dr(&svm->vcpu, dr))
 			return 1;
 		kvm_get_dr(&svm->vcpu, dr, &val);
 		kvm_register_write(&svm->vcpu, reg, val);
+		trace_kvm_dr_read(dr, val);
 	}
 
 	return kvm_skip_emulated_instruction(&svm->vcpu);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index aef960f90f26..b3bf54405862 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -405,6 +405,33 @@ TRACE_EVENT(kvm_cr,
 #define trace_kvm_cr_read(cr, val)		trace_kvm_cr(0, cr, val)
 #define trace_kvm_cr_write(cr, val)		trace_kvm_cr(1, cr, val)
 
+/*
+ * Tracepoint for guest DR access.
+ */
+TRACE_EVENT(kvm_dr,
+	TP_PROTO(unsigned int rw, unsigned int dr, unsigned long val),
+	TP_ARGS(rw, dr, val),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	rw		)
+		__field(	unsigned int,	dr		)
+		__field(	unsigned long,	val		)
+	),
+
+	TP_fast_assign(
+		__entry->rw		= rw;
+		__entry->dr		= dr;
+		__entry->val		= val;
+	),
+
+	TP_printk("dr_%s %x = 0x%lx",
+		  __entry->rw ? "write" : "read",
+		  __entry->dr, __entry->val)
+);
+
+#define trace_kvm_dr_read(dr, val)		trace_kvm_dr(0, dr, val)
+#define trace_kvm_dr_write(dr, val)		trace_kvm_dr(1, dr, val)
+
 TRACE_EVENT(kvm_pic_set_irq,
 	    TP_PROTO(__u8 chip, __u8 pin, __u8 elcr, __u8 imr, bool coalesced),
 	    TP_ARGS(chip, pin, elcr, imr, coalesced),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4551a7e80ebc..f78fd297d51e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5091,10 +5091,16 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 
 		if (kvm_get_dr(vcpu, dr, &val))
 			return 1;
+		trace_kvm_dr_read(dr, val);
 		kvm_register_write(vcpu, reg, val);
-	} else
-		if (kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg)))
+	} else {
+		unsigned long val;
+
+		val = kvm_register_readl(vcpu, reg);
+		trace_kvm_dr_write(dr, val);
+		if (kvm_set_dr(vcpu, dr, val))
 			return 1;
+	}
 
 	return kvm_skip_emulated_instruction(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4015a43cc8a..68cb7b331324 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11153,6 +11153,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_dr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
-- 
2.18.4

