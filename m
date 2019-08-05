Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F15C81025
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 04:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfHECDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Aug 2019 22:03:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34867 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfHECDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Aug 2019 22:03:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id u14so38787927pfn.2;
        Sun, 04 Aug 2019 19:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hoi2qggJgGKlBqGJ2GtCroDIXuqb12/f4X0se5rdkzk=;
        b=ELHAEb/c0g8ciUTihz8zTEwp7BEgCe6Jif2phFQXVHydHHkUp6z2DGYbVMY7bemulb
         rnTGgy7Ar/5FVw914qquuOyhNx9fCROm7Jy4SEsXiXKJRKnNTlXuFA/XbCCl5A7eraEq
         StDL+CWkOO7lougYGUsxOZnqNLLzOn/Y+xAGtnPZGraqpPbLSbNHMO8sBWtsdzlLL9SN
         pt5ghjiaitwO50Qf54t4MVv7QbsicNW715PVgRgbBwwDNrVinqhN7drKclxKMvLlNKJ8
         yy6KcDRYTH9r1lNJEdI3DoxJ1SBEi05CE2l0mI8G3JizdLzYk9Vb4AvJhqeklPJomkSF
         vzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hoi2qggJgGKlBqGJ2GtCroDIXuqb12/f4X0se5rdkzk=;
        b=JSpCIUh0It6XIEVLZvz0+kCQQiG2Ot1Vg2ah/ZeXR7/IbN2JTFi4gVctjy/l+3pQ0M
         ARloOEkcJ4lHq2lIY7cH0rWjHUvIFVprP1cI8J8wZyk7oROjEJef423/Q++RlmKRuldQ
         LbWGucgctoLf4p6Kh/lr8uIJT4hCPpKFRU8izhG+mKyQO81FiVsnpqh6Gl+ZZf9lspwC
         dqZoSDbE/tOAtDF4Dciz0Dp9DkFvEHaul1Ux/7QriGEYbr5Uub+Ok7b38OFZAPJEUvEz
         Qve7aLfrYWkr/RBynv8jB/6MVRYwlHg0+hn0EDHpkUKFd/fQjRSDlR3vbB1keql6kTUV
         3y6Q==
X-Gm-Message-State: APjAAAWbgUUiQ/98XWoLg2rw6B+ohRnPqZDd5Hp6knu2qazNhgLkFTmI
        evDiPmT2lX2+ge8Xk46G9+OmEQE4
X-Google-Smtp-Source: APXvYqxDROGQMciy3kn6lTsD8uj9Zufwk/bjW0IymlSN9rRmy6jNJFEGGM9u/GGNAL9RHc/G5O70Wg==
X-Received: by 2002:a62:82c1:: with SMTP id w184mr72018868pfd.8.1564970622332;
        Sun, 04 Aug 2019 19:03:42 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id o32sm14739365pje.9.2019.08.04.19.03.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 19:03:41 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v4 6/6] KVM: X86: Add pv tlb shootdown tracepoint
Date:   Mon,  5 Aug 2019 10:03:24 +0800
Message-Id: <1564970604-10044-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
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
index f715efb..7a302cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2452,6 +2452,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
 	 */
+	trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
+		vcpu->arch.st.steal.preempted & KVM_VCPU_FLUSH_TLB);
 	if (xchg(&vcpu->arch.st.steal.preempted, 0) & KVM_VCPU_FLUSH_TLB)
 		kvm_vcpu_flush_tlb(vcpu, false);
 
-- 
2.7.4

