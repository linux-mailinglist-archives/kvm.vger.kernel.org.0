Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB7946E7D2
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbhLIL7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:59:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237009AbhLIL7C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 06:59:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639050928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9n3ks/qGBJAFiFoz7WLxCqVjdo8+jnGLy2IDwApqml0=;
        b=AubPuQKFV0zL/RYBFvq8X94RF14JcYg2LhxVw5ReqK2cPMoh6U+r8KNnTprfY2JRN1+fig
        kx+r4if+fF4PNJtHnH/CpG29Hap7fhQ6fT7PMz1JZF0JsMOF9r5XONEtvKzjwgKQHjVP2r
        DzXDH8YPdUPJ1own/qJQuODSPM989KE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-LoSPptpqNrSyYnG0BW9gKw-1; Thu, 09 Dec 2021 06:55:27 -0500
X-MC-Unique: LoSPptpqNrSyYnG0BW9gKw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD8C3190B2A3;
        Thu,  9 Dec 2021 11:55:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57A6860657;
        Thu,  9 Dec 2021 11:55:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/6] KVM: x86: add a tracepoint for APICv/AVIC interrupt delivery
Date:   Thu,  9 Dec 2021 13:54:36 +0200
Message-Id: <20211209115440.394441-3-mlevitsk@redhat.com>
In-Reply-To: <20211209115440.394441-1-mlevitsk@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows to see how many interrupts were delivered via the
APICv/AVIC from the host.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c |  3 +++
 arch/x86/kvm/trace.h | 24 ++++++++++++++++++++++++
 arch/x86/kvm/x86.c   |  1 +
 3 files changed, 28 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 40270d7bc597..c5028e6b0f96 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1100,6 +1100,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			kvm_lapic_set_irr(vector, apic);
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
+		} else {
+			trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
+						   trig_mode, vector);
 		}
 		break;
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 953b0fcb21ee..92e6f6702f00 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1356,6 +1356,30 @@ TRACE_EVENT(kvm_apicv_update_request,
 		  __entry->bit)
 );
 
+TRACE_EVENT(kvm_apicv_accept_irq,
+	    TP_PROTO(__u32 apicid, __u16 dm, __u16 tm, __u8 vec),
+	    TP_ARGS(apicid, dm, tm, vec),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		apicid		)
+		__field(	__u16,		dm		)
+		__field(	__u16,		tm		)
+		__field(	__u8,		vec		)
+	),
+
+	TP_fast_assign(
+		__entry->apicid		= apicid;
+		__entry->dm		= dm;
+		__entry->tm		= tm;
+		__entry->vec		= vec;
+	),
+
+	TP_printk("apicid %x vec %u (%s|%s)",
+		  __entry->apicid, __entry->vec,
+		  __print_symbolic((__entry->dm >> 8 & 0x7), kvm_deliver_mode),
+		  __entry->tm ? "level" : "edge")
+);
+
 /*
  * Tracepoint for AMD AVIC
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1aaf37e1bd0f..26cb3a4cd0e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12693,6 +12693,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
-- 
2.26.3

