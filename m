Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EB72F6CB0
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 21:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbhANU4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 15:56:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726695AbhANU4l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 15:56:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610657714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xXsMcye107TRTUOx9sAA63kyUX0vbBZCLWLrhOEo8GI=;
        b=WL6B5VPBku1r3GWcgbDwJmQ+tyyhOL1o8m7bXhjXDlByggs7TF/gp+12ISrvzMM6BDWK20
        bpUsEFkNxmFeyZQpV1DmG/jN5ko/yx94xMzbXlNtKBGA2O6F4DWCnmN0xZ5lYSUCtFBWEP
        H2Ef7DUJ5WOzuJpPv3IpHiEvk+MHDvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-Dzb7FMrbMWi4MozDekzYBA-1; Thu, 14 Jan 2021 15:55:10 -0500
X-MC-Unique: Dzb7FMrbMWi4MozDekzYBA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 247C4806663;
        Thu, 14 Jan 2021 20:55:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB6A15C1C5;
        Thu, 14 Jan 2021 20:55:00 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/3] KVM: nVMX: add kvm_nested_vmlaunch_resume tracepoint
Date:   Thu, 14 Jan 2021 22:54:48 +0200
Message-Id: <20210114205449.8715-3-mlevitsk@redhat.com>
In-Reply-To: <20210114205449.8715-1-mlevitsk@redhat.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is very helpful for debugging nested VMX issues.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/trace.h      | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.c |  6 ++++++
 arch/x86/kvm/x86.c        |  1 +
 3 files changed, 37 insertions(+)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 2de30c20bc264..663d1b1d8bf64 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -554,6 +554,36 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__entry->npt ? "on" : "off")
 );
 
+
+/*
+ * Tracepoint for nested VMLAUNCH/VMRESUME
+ */
+TRACE_EVENT(kvm_nested_vmlaunch_resume,
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
index 776688f9d1017..cd51b66480d52 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3327,6 +3327,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
+	trace_kvm_nested_vmlaunch_resume(kvm_rip_read(vcpu),
+					 vmx->nested.current_vmptr,
+					 vmcs12->guest_rip,
+					 vmcs12->vm_entry_intr_info_field);
+
+
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
 	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a480804ae27a3..7c6e94e32100e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11562,6 +11562,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmlaunch_resume);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
-- 
2.26.2

