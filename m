Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109A42FF18B
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 18:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388526AbhAUROk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 12:14:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732664AbhAURMt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 12:12:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611249072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=INSBEkpO+6muX4mYFBYj8xxbV1vd/rbXbWz9Y91SPtc=;
        b=CKETkTM3xuKUEpXuB166eDR6PXgRX25o6GeRuwGoliPSUwhRqKf/1Y/jNWqf5WfEW6BgEe
        sfrS8LWUXrnMQFMXIBzc99Tw/FRjItFNJKcs2KlAv19EGAutbAKqWHfZMBu1Zaya18RHg3
        QDnmr1TDZz5QvcAWScdOu5+rcxyAQXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-a55jlSKANseJkSuw1HgZxg-1; Thu, 21 Jan 2021 12:11:08 -0500
X-MC-Unique: a55jlSKANseJkSuw1HgZxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71FA0802B42;
        Thu, 21 Jan 2021 17:11:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E7796E41C;
        Thu, 21 Jan 2021 17:10:56 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/2] KVM: nVMX: trace nested vm entry
Date:   Thu, 21 Jan 2021 19:10:43 +0200
Message-Id: <20210121171043.946761-3-mlevitsk@redhat.com>
In-Reply-To: <20210121171043.946761-1-mlevitsk@redhat.com>
References: <20210121171043.946761-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is very helpful to debug nested VMX issues.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/trace.h      | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.c |  5 +++++
 arch/x86/kvm/x86.c        |  3 ++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 2de30c20bc264..ec75efdac3560 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -554,6 +554,36 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__entry->npt ? "on" : "off")
 );
 
+
+/*
+ * Tracepoint for nested VMLAUNCH/VMRESUME
+ */
+TRACE_EVENT(kvm_nested_vmenter,
+	    TP_PROTO(__u64 rip, __u64 vmcs, __u64 nested_rip,
+		     __u32 entry_intr_info),
+	    TP_ARGS(rip, vmcs, nested_rip, entry_intr_info),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		rip		)
+		__field(	__u64,		vmcs		)
+		__field(	__u64,		nested_rip	)
+		__field(	__u32,		entry_intr_info	)
+	),
+
+	TP_fast_assign(
+		__entry->rip			= rip;
+		__entry->vmcs			= vmcs;
+		__entry->nested_rip		= nested_rip;
+		__entry->entry_intr_info	= entry_intr_info;
+	),
+
+	TP_printk("rip: 0x%016llx vmcs: 0x%016llx nrip: 0x%016llx "
+		  "entry_intr_info: 0x%08x",
+		__entry->rip, __entry->vmcs, __entry->nested_rip,
+		__entry->entry_intr_info)
+);
+
+
 TRACE_EVENT(kvm_nested_intercepts,
 	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions,
 		     __u32 intercept1, __u32 intercept2, __u32 intercept3),
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0fbb46990dfce..20b0954f31bda 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3327,6 +3327,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
+	trace_kvm_nested_vmenter(kvm_rip_read(vcpu),
+				 vmx->nested.current_vmptr,
+				 vmcs12->guest_rip,
+				 vmcs12->vm_entry_intr_info_field);
+
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
 	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a480804ae27a3..757f4f88072af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11562,11 +11562,12 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter_failed);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter_failed);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
-- 
2.26.2

