Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCB8667DD
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 09:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfGLHjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 03:39:09 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36573 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfGLHjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 03:39:07 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so4376245plt.3;
        Fri, 12 Jul 2019 00:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqWHU/XqXefwbFzSri++Ua4yqLq/ROR9Xq2SRMBxUHE=;
        b=ehmPLVKoQfpqY3AmhaE04aPpsSPrIzHd4iH8h3ZQP53aA5Y72dDo8YXnG9vqK6PmBu
         2C1ScJ3xZS/gOcm8s9tOx2gubbvjZ4trbee6YdjmzafhF+midsnNG0ocoJrETTs/mgw0
         0WCuSBvg2qa8ove8aydZExbbYD4oOVJLZ5jVgf7ephFhzQ5ATxfZEFR5xLbEsGIpOrxF
         d1hf/8EiYq5wm4b017kd892Tdu+eikquog/KRIZJAK/+Ws596YVRVOFmLX3Mf3qOjMoW
         oYbhHw8idkj+4Szufsy9cDt1tblqdZfIxvghyMVtjhyvz5LzIWqOAoqwvAO3wtthrB1R
         FP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqWHU/XqXefwbFzSri++Ua4yqLq/ROR9Xq2SRMBxUHE=;
        b=fnUtMrJ3GTIlVMtlsgqdt5IgaqicY3yEupzWQy0+UY6GcPAUmeUvCMYaYwz8l17FMV
         mnJpJJTVKyDfkDmigVF6SSIklHQcvl32soLhWP+B+66XU0lEQp53b/VCoLfD/xCAsZ7D
         U855sQvjNSlDUUxEx8YYcRW2uFnoxqoKvMBKFAWglUMuSEAGWMMHSHvS7QhtU2tA1GNf
         oom74GIyCI41A2EL3Rj2bNqK7gbHmMADXX2af9jdWBW2ml5ow5JxoYKqMeU64wZdjyrW
         Hy54P5CPUPZ2VpBDWU9OcwPK7hex4VlyxR2KLNTMRGwzae3s9v0W5OSci/Q/0bkdLPrO
         n/vw==
X-Gm-Message-State: APjAAAUPNLWsqrEWnwBMu/HtzWdcmD7/83jK4K0xvrUBOFC8HpWowvmh
        b47aghfQizLYUwy/yUm4e5yP9lEGjJ8=
X-Google-Smtp-Source: APXvYqzGXHKVDDW4prdPnC2ScKkMMvC22+4PZhW52RKbfR7i2p5Z02EkMeYdcrkIoDSClTqMTQBfAA==
X-Received: by 2002:a17:902:2baa:: with SMTP id l39mr9836991plb.280.1562917146467;
        Fri, 12 Jul 2019 00:39:06 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d6sm6661309pgf.55.2019.07.12.00.39.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 12 Jul 2019 00:39:06 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND 2/2] KVM: X86: Add pv tlb shootdown tracepoint
Date:   Fri, 12 Jul 2019 15:39:00 +0800
Message-Id: <1562917140-12035-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562917140-12035-1-git-send-email-wanpengli@tencent.com>
References: <1562917140-12035-1-git-send-email-wanpengli@tencent.com>
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

