Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0DD1E10CD
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404044AbgEYOmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:42:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30940 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404035AbgEYOmD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 10:42:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gcWPQcy0dLcM/idycFzBWKrR20stKK5D971BAOD+nRg=;
        b=Y09MEEnVC7am+z62gP2Ih0JysJ3BzgIjtgOM1anF75uvDvbDDdKtzPimv9iM7Oj+MXNCPz
        PX80QUL++wQxmXbKFhouLN58wercMYy9gHeCwJUotG5BmO9RJPZHonRnPT6KHQwGB21m+g
        qInqzZ3rpKPQRCVcCDbqDnzCTbPvmAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-QbeNpbpcO82crC9H4IItqA-1; Mon, 25 May 2020 10:42:00 -0400
X-MC-Unique: QbeNpbpcO82crC9H4IItqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D186118FE86C;
        Mon, 25 May 2020 14:41:58 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B86B95D9C5;
        Mon, 25 May 2020 14:41:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/10] KVM: x86: announce KVM_FEATURE_ASYNC_PF_INT
Date:   Mon, 25 May 2020 16:41:22 +0200
Message-Id: <20200525144125.143875-8-vkuznets@redhat.com>
In-Reply-To: <20200525144125.143875-1-vkuznets@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new capability to indicate that KVM supports interrupt based
delivery of 'page ready' APF events. This includes support for both
MSR_KVM_ASYNC_PF_INT and MSR_KVM_ASYNC_PF_ACK.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/cpuid.rst     |  6 ++++++
 Documentation/virt/kvm/msr.rst       | 12 ++++++++----
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/x86.c                   |  1 +
 include/uapi/linux/kvm.h             |  1 +
 6 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index 01b081f6e7ea..98cbd257ac33 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -86,6 +86,12 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
                                               before using paravirtualized
                                               sched yield.
 
+KVM_FEATURE_ASYNC_PF_INT          14          guest checks this feature bit
+                                              before using the second async
+                                              pf control msr 0x4b564d06 and
+                                              async pf acknowledgment msr
+                                              0x4b564d07.
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                               per-cpu warps are expeced in
                                               kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index 8ea3fbcc67fd..d409cc26193f 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -213,7 +213,8 @@ data:
 	cpl == 0. Bit 2 is 1 if asynchronous page faults are delivered to L1 as
 	#PF vmexits.  Bit 2 can be set only if KVM_FEATURE_ASYNC_PF_VMEXIT is
 	present in CPUID. Bit 3 enables interrupt based delivery of 'page ready'
-	events.
+	events. Bit 3 can only be set if KVM_FEATURE_ASYNC_PF_INT is present in
+	CPUID.
 
 	'Page not present' events are currently always delivered as synthetic
 	#PF exception. During delivery of these events APF CR2 register contains
@@ -243,7 +244,8 @@ data:
 
 	Note, MSR_KVM_ASYNC_PF_INT MSR specifying the interrupt vector for 'page
 	ready' APF delivery needs to be written to before enabling APF mechanism
-	in MSR_KVM_ASYNC_PF_EN or interrupt #0 can get injected.
+	in MSR_KVM_ASYNC_PF_EN or interrupt #0 can get injected. The MSR is
+	available if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
 
 	Note, previously, 'page ready' events were delivered via the same #PF
 	exception as 'page not present' events but this is now deprecated. If
@@ -361,7 +363,8 @@ data:
 
 	Interrupt vector for asynchnonous 'page ready' notifications delivery.
 	The vector has to be set up before asynchronous page fault mechanism
-	is enabled in MSR_KVM_ASYNC_PF_EN.
+	is enabled in MSR_KVM_ASYNC_PF_EN.  The MSR is only available if
+	KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
 
 MSR_KVM_ASYNC_PF_ACK:
 	0x4b564d07
@@ -372,4 +375,5 @@ data:
 	When the guest is done processing 'page ready' APF event and 'token'
 	field in 'struct kvm_vcpu_pv_apf_data' is cleared it is supposed to
 	write '1' to bit 0 of the MSR, this caused the host to re-scan its queue
-	and check if there are more notifications pending.
+	and check if there are more notifications pending. The MSR is available
+	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 7ac20df80ba8..812e9b4c1114 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -31,6 +31,7 @@
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_ASYNC_PF_INT	14
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..790fe4988001 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -712,7 +712,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
-			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
+			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ffe1497b7beb..cc1bf6cfc5e0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3404,6 +3404,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
+	case KVM_CAP_ASYNC_PF_INT:
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_KVMCLOCK_CTRL:
 	case KVM_CAP_READONLY_MEM:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b..15012f78a691 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_ASYNC_PF_INT 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.4

