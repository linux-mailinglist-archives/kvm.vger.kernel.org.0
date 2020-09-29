Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A9E27C026
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 10:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgI2Ize (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 04:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgI2Izb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 04:55:31 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B24C061755;
        Tue, 29 Sep 2020 01:55:29 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z19so3845092pfn.8;
        Tue, 29 Sep 2020 01:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yLZJxx2l7hUl8Pgn3o5psWobrD3TjYQxwKuaDcKpaAs=;
        b=P1SOZ08oNzcpvT4+1QdPJIKbuRcOJfMQYnh/POijnSls+YiMR3I01WSLLQF026Ji+X
         sFBFvMWHQy+8WmXb6uZE4C2CbkWqcJPyLYNTydGkMRnQtnAwU/GUhQhCPptmv+1+9o5m
         x+E8wV87cHvjSDpzqY7+yQchBCePaRo8WyWvXXzySB3dkUhQouA/8T0Qscq4EwhqYyV3
         sSE9LR0vxv3Du/u7SqZj35C3wzKvOJlS1xT0KH+2HXiDPUxmMi+2DUVQFsucygQNj0KR
         1BPzUvV5xbBNyLK/gIgPbQU6XKjaOzNNqRxcQkHb3LygnjzPbQ48YaxitC433eIgUAPv
         wU7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yLZJxx2l7hUl8Pgn3o5psWobrD3TjYQxwKuaDcKpaAs=;
        b=ZykxsLdlMfhPCpFcfWvFO/SsMlTQ5jIMGKyliPnIh33dLstQNGHFU3iwrEPIV6QNUw
         Z8+hkKj0Fl58iVIi4xfXXup2n9N/eZ3N7+Lt7znnUDPtfPBSVRQ3sWV9rOZiZwlUv39n
         TuiRRLN+Ho+MgbzNODC30xA97FoSzigxBeSSldW1ZNd1JYttdg2JoSV6+AoyX3NeOk7m
         QyJBBfJc+0Xyd2OKZCAVXG7gFYUpR2KN6T0Vj8XumUoIZI0+ukGI0xN6Nd6RkUOhI8T/
         dVv7fO9FMK8PWDUUU02fpIzatKS8m6shX8J10ZtdZmOcGZE7zFTUQ8fkDFNGCFUOewwW
         pMfw==
X-Gm-Message-State: AOAM533cyBxGEu5TUsTgxG74uum6VVZIFrjQXdrzQ5hJ1dvTlAm7hOFL
        ADQI606Gcerc74wEf2QHmG9sbKe02BjH
X-Google-Smtp-Source: ABdhPJzFiU1OJyLuqrPQYy4g/DXmxjdQ1IuHdxUHeRilWdjdpUgleXtTv+wvD1zReMnlywsDc95k7w==
X-Received: by 2002:a63:1925:: with SMTP id z37mr2502003pgl.23.1601369729029;
        Tue, 29 Sep 2020 01:55:29 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id x185sm4616952pfc.188.2020.09.29.01.55.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 01:55:28 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH] KVM: x86: Add tracepoint for dr_write/dr_read
Date:   Tue, 29 Sep 2020 16:55:15 +0800
Message-Id: <20200929085515.24059-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

Add tracepoint trace_kvm_dr_write/trace_kvm_dr_read for x86 kvm.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
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

