Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792BB75EC6
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 08:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfGZGLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 02:11:11 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44438 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfGZGLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 02:11:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so24236729pgl.11;
        Thu, 25 Jul 2019 23:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqWHU/XqXefwbFzSri++Ua4yqLq/ROR9Xq2SRMBxUHE=;
        b=hsZqkZj7XNRqXobbU3VuqlnbedicLIGZt0w5DyRuBKQ29n1FBifX0YMW3rKza2qKoC
         dlThp/loNioomkckFgxhBwRys8WThWxin+GTbAV1CUTTEeKLmuIA0u9DXp+y3DtwXAI0
         d12ycYbuPc4LpkR/nr6SVsLq5T66Hjtmw9FzN1ig31ncywBeNzqsKIOOmfqSH84FVkEA
         P+Di0sBmSjFCt/jvJI7w118AAmXdnXRueZ8BBMOWxJ5q3z76p9VIyfeyvrdJXjFWsTTi
         UGsOfsJN2/OXzlqn64pYNEhYjykpZ3s0E+bUqUpJNdF8nE/nf1GUmNwz90JRJnWtO9Ho
         ZY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqWHU/XqXefwbFzSri++Ua4yqLq/ROR9Xq2SRMBxUHE=;
        b=iZPb4FHSiR2I0alQVHjfUS0kCDJu9OdEf7eaun3RgkuTlb++A8dggl50AXa/nTCuwQ
         Hq37OPfH11c++VZeMN7uddVz5KtkqAPNZmpKxmLXOKo11NNHRDoV1pBBidbKMQeJ6Kbv
         FYph50QqvVGpnGjR1M/kABbqQ5hmadJczOCoZFnL+hlKd2OumtrfjyXJMDzFvQp9acak
         s14jxJjuBUTlwj+8QAUtazPs/hrcJ7BBQbSEnzdVdlQe6KS1N0qreMeDn1lQg95lTDlS
         8BdRfc13O7LC+7XucscxR+H0QtbpmpYapenykhVwz9e4wPPZGR58l/r7LrMurE2enYrR
         OG7Q==
X-Gm-Message-State: APjAAAUdc17JEBE1jEx2qJe15n/3fsM2ZKZTU8A4LgXWHBqNNBRv+dob
        fvqAAOkz/rGCzS/6UTqg+7kiQ2BnBDE=
X-Google-Smtp-Source: APXvYqyXrmn96AZZYJpZEjnHwcPV6/zTO9idYYEgNTCaS/A4d6b0DP6mJljalvoRVrMBpJLvVUcfXQ==
X-Received: by 2002:a63:460c:: with SMTP id t12mr89148060pga.69.1564121468849;
        Thu, 25 Jul 2019 23:11:08 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id i6sm54622455pgi.40.2019.07.25.23.11.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 25 Jul 2019 23:11:08 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND 2/2] KVM: X86: Add pv tlb shootdown tracepoint
Date:   Fri, 26 Jul 2019 14:11:03 +0800
Message-Id: <1564121463-29448-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564121463-29448-1-git-send-email-wanpengli@tencent.com>
References: <1564121463-29448-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Add pv tlb shootdown tracepoint.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/trace.h | 19 +++++++++++++++++++
 arch/x86/kvm/x86.c   |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index ce6ee34..84f32d3 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1487,6 +1487,25 @@ TRACE_EVENT(kvm_pv_send_ipi,
 	TP_printk("vector %d min 0x%x ipi_bitmap_low 0x%lx ipi_bitmap_high 0x%lx",
 		  __entry->vector, __entry->min, __entry->ipi_bitmap_low, __entry->ipi_bitmap_high)
 );
+
+TRACE_EVENT(kvm_pv_tlb_flush,
+	TP_PROTO(unsigned int vcpu_id, bool need_flush_tlb),
+	TP_ARGS(vcpu_id, need_flush_tlb),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
+		__field(	bool,	need_flush_tlb		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+		__entry->need_flush_tlb = need_flush_tlb;
+	),
+
+	TP_printk("vcpu %u need_flush_tlb %s", __entry->vcpu_id,
+		__entry->need_flush_tlb ? "true" : "false")
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c32311..f487c9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2458,6 +2458,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
 	 */
+	trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
+		vcpu->arch.st.steal.preempted & KVM_VCPU_FLUSH_TLB);
 	if (xchg(&vcpu->arch.st.steal.preempted, 0) & KVM_VCPU_FLUSH_TLB)
 		kvm_vcpu_flush_tlb(vcpu, false);
 
-- 
2.7.4

