Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB86664B2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 04:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfGLCyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 22:54:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39572 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729051AbfGLCys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 22:54:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so3844659pgi.6;
        Thu, 11 Jul 2019 19:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlJ5SZ08CSnSSRFOp53QvEnZVvpxlaIqKCaeg2qBZWQ=;
        b=rs/u0q0zlimgMudRG30frHH2GJkMqmSWVIoqVgt5q7BczEbHlSVxE+Yi1Zn6yJQllx
         2yBc3L//ezoyamlGIZVw5GkVy1qMBxDJ1UBf2mw/5bV+80FWddBBxBx5DpxrF2vUWhrn
         wz2EH3dz0knCpHKuNQBOUMkq/z0KdMQDl9rkSBvtM5FwO7kloj9XOMF/AYcU9OqbgU1M
         d5frBbF0G3ObdVF1PNasNKuKRjcU/HjJHdSVhGkBXHFY7/QlcwvrXwI3BvJcRBtH4a4m
         NCSo2GRD5WU1/JZ7+sV5RYs7kitKJ8QaFobRAqam3qN+Uh2EKNlijxEKBzqjEIW5jdMv
         +XtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlJ5SZ08CSnSSRFOp53QvEnZVvpxlaIqKCaeg2qBZWQ=;
        b=pcjhw/UL8WD6tIRflnI8zQUlE7koToDkxanmK46n+vGc1e/6Mod4ZGQliWD1YVH6aP
         +rSTVuH7qBSFat9JlGqWWFpVFvaY/T4qm5gxCHzGDQWJl9bN8cdlKO5B5Nio+KOkyvP6
         WumlmOe6tFaTcsgylZqSzU+J12dAQSyEjO29T7FQy90H0MvA3LQqgDckkrYwWkYHgyQf
         9f+27CPmS5Ylja7Dn23TjXlfSNKu3HFGBpuntTZvfdlpW3wy9VOV/akhXKoJX19BOg2S
         5YSs0botN3CT579Q54zwkGKx4u+/dKzFrfXFS4KlvDSdG6j0U5VVNefIHcReSBbKwokf
         THPQ==
X-Gm-Message-State: APjAAAUu+TwRziKoqoY4kvWAvK4OhRmeHJEgtWfplOEA4Ruw50Hapnnf
        0Gz45jareArXN3uarzwrHgERAdTTyEA=
X-Google-Smtp-Source: APXvYqyo6HA6DzVTwivRsf7q25xhytE4Nxc0FBSMKzXSSas3ujuYC1848eLpvDnP/dr2hScB7yX8mA==
X-Received: by 2002:a63:d30f:: with SMTP id b15mr7882555pgg.341.1562900087624;
        Thu, 11 Jul 2019 19:54:47 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id n26sm7786630pfa.83.2019.07.11.19.54.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 11 Jul 2019 19:54:47 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/2] KVM: X86: Add pv tlb shootdown tracepoint
Date:   Fri, 12 Jul 2019 10:54:40 +0800
Message-Id: <1562900080-20798-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562900080-20798-1-git-send-email-wanpengli@tencent.com>
References: <1562900080-20798-1-git-send-email-wanpengli@tencent.com>
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
index bc1688e..a7a0514 100644
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

