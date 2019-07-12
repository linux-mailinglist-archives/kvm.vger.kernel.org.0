Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9567664B3
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 04:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbfGLCyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 22:54:47 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37510 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729051AbfGLCyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 22:54:46 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so4035821plr.4;
        Thu, 11 Jul 2019 19:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=64j1duN8Q6Xd7kRV0ySvGXg0eZ22bwDTxpKrN9mAXSY=;
        b=AHe1Evh3+uUAWpOBVIXpYTAk/unMWsGn2D3MEAxP2tnBXX6PS4AqyxdsOm1CxGackm
         WsYGT4J7LyN+CgbltLSBBsW6rfAVbVlxjUt3xVay86baYmxOwtQ105Bs4I8hlyVn9t+g
         TIlPy9ajseDKUaNuAhdFg9zZ753Vz2K2/8BgzRCQcG0YfFNe6NjWMIbvh3SP1/yAyxVD
         dtQIlV6lleTl9NWXT2GryG/2bPhXPEKx+i4xCrB0NrXdM5w6Cn71i9bhmu6SII91upEz
         /YNvQ2aGc8yA+RooKxBhZtzNzzSAoGzzAwArDTJbRNkG3V6eTp6+/xdV2PEDMp7/A/Wi
         gQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=64j1duN8Q6Xd7kRV0ySvGXg0eZ22bwDTxpKrN9mAXSY=;
        b=AucxCgqlGhMOCt3iaFdChUDmi073Vw3DrGGuuv1qvrk4y0Vop8y4nFF09QqPsRaQaZ
         p81D/naSu3FOF6wSOVgEyYl11riFPD/ZUl0BXQM49V1gvsE+a5+iSQ8cvuIbMeqEtqU7
         q8c3duHK+ocFtfsvGrNscsbwLcwPMxFOt2jRchWYRrmfzKy64r1BTLkbqAIwt6zY28QC
         tSLlT1yfTEyXILwIKoZYmhERA4JmbSK0cJQcEGI4P58z4BLR0m3Vq7/6wDuOy0Lie3Qy
         qBC6AvXthiJrnxu0uVY8d0Vr6OCelS5Sl/QnJZfud6QRFeoGCxMhtY21iOJBeBaY1Asu
         SVKg==
X-Gm-Message-State: APjAAAURNOl2qUCH42aGerzJGnxgp+4auTpWtFCTe9VJZvKEViPdoaDD
        oFCObuDDkYAKKc3Cg/Ookos6COKGrw8=
X-Google-Smtp-Source: APXvYqxi8dhpdclONkq7oo/LRkDbRkz37L73HpER/lr6g5PmDj65DBKzvhdvjrat/RYt6oo+85/N7A==
X-Received: by 2002:a17:902:b608:: with SMTP id b8mr8579220pls.303.1562900085859;
        Thu, 11 Jul 2019 19:54:45 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id n26sm7786630pfa.83.2019.07.11.19.54.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 11 Jul 2019 19:54:45 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 1/2] KVM: LAPIC: Add pv ipi tracepoint
Date:   Fri, 12 Jul 2019 10:54:39 +0800
Message-Id: <1562900080-20798-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Add pv ipi tracepoint.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c |  2 ++
 arch/x86/kvm/trace.h | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3201d91..72c2a1e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -568,6 +568,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 	int cluster_size = op_64_bit ? 64 : 32;
 	int count = 0;
 
+	trace_kvm_pv_send_ipi(irq.vector, min, ipi_bitmap_low, ipi_bitmap_high);
+
 	irq.vector = icr & APIC_VECTOR_MASK;
 	irq.delivery_mode = icr & APIC_MODE_MASK;
 	irq.level = (icr & APIC_INT_ASSERT) != 0;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b5c831e..ce6ee34 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1462,6 +1462,31 @@ TRACE_EVENT(kvm_hv_send_ipi_ex,
 		  __entry->vector, __entry->format,
 		  __entry->valid_bank_mask)
 );
+
+/*
+ * Tracepoints for kvm_pv_send_ipi.
+ */
+TRACE_EVENT(kvm_pv_send_ipi,
+	TP_PROTO(u32 vector, u32 min, unsigned long ipi_bitmap_low, unsigned long ipi_bitmap_high),
+	TP_ARGS(vector, min, ipi_bitmap_low, ipi_bitmap_high),
+
+	TP_STRUCT__entry(
+		__field(u32, vector)
+		__field(u32, min)
+		__field(unsigned long, ipi_bitmap_low)
+		__field(unsigned long, ipi_bitmap_high)
+	),
+
+	TP_fast_assign(
+		__entry->vector = vector;
+		__entry->min = min;
+		__entry->ipi_bitmap_low = ipi_bitmap_low;
+		__entry->ipi_bitmap_high = ipi_bitmap_high;
+	),
+
+	TP_printk("vector %d min 0x%x ipi_bitmap_low 0x%lx ipi_bitmap_high 0x%lx",
+		  __entry->vector, __entry->min, __entry->ipi_bitmap_low, __entry->ipi_bitmap_high)
+);
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.7.4

