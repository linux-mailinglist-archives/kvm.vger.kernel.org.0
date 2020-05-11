Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B743A1CE0ED
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 18:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbgEKQsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 12:48:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58631 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730819AbgEKQsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 12:48:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589215728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IrgzgWOjkXCimZTRmYAgL/WySkGnJpOAWpLdr41OCzc=;
        b=DT1jEbeRn4rgcFsBvE2SOZOD2va9WI8kBeVTKxmHmzLDcihJ+ouQuBOiJ9bDWfSmwCEcO0
        Kr2wtYD7LLnEwIf6NnX+zzQM6+Msbk7bP1j6H2z0bwDrNSIEpIB/0aulCN6ggpKBfIm8SO
        xautUIVfGqaI+HGL6fVWYelMK5GBDm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-M1051vVQNHepjqOCfrQqdQ-1; Mon, 11 May 2020 12:48:43 -0400
X-MC-Unique: M1051vVQNHepjqOCfrQqdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEDACEC1A1;
        Mon, 11 May 2020 16:48:41 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28198196AE;
        Mon, 11 May 2020 16:48:37 +0000 (UTC)
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
Subject: [PATCH 6/8] KVM: x86: announce KVM_FEATURE_ASYNC_PF_INT
Date:   Mon, 11 May 2020 18:47:50 +0200
Message-Id: <20200511164752.2158645-7-vkuznets@redhat.com>
In-Reply-To: <20200511164752.2158645-1-vkuznets@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new capability to indicate that KVM supports interrupt based
delivery of type 2 APF events (page ready notifications). This includes
support for both MSR_KVM_ASYNC_PF_INT and MSR_KVM_ASYNC_PF_ACK.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/cpuid.rst     | 6 ++++++
 Documentation/virt/kvm/msr.rst       | 9 ++++++---
 arch/x86/include/uapi/asm/kvm_para.h | 1 +
 arch/x86/kvm/cpuid.c                 | 3 ++-
 arch/x86/kvm/x86.c                   | 1 +
 include/uapi/linux/kvm.h             | 1 +
 6 files changed, 17 insertions(+), 4 deletions(-)

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
index 3c7afbcd243f..0e1ec0412714 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -209,7 +209,8 @@ data:
 	cpl == 0. Bit 2 is 1 if asynchronous page faults are delivered to L1 as
 	#PF vmexits.  Bit 2 can be set only if KVM_FEATURE_ASYNC_PF_VMEXIT is
 	present in CPUID. Bit 3 enables interrupt based delivery of type 2
-	(page present) events.
+	(page present) events. Bit 3 can be set only if KVM_FEATURE_ASYNC_PF_INT
+	is present in CPUID.
 
 	First 4 byte of 64 byte memory location ('reason') will be written to
 	by the hypervisor at the time APF type 1 (page not present) injection.
@@ -352,7 +353,8 @@ data:
 
 	Interrupt vector for asynchnonous page ready notifications delivery.
 	The vector has to be set up before asynchronous page fault mechanism
-	is enabled in MSR_KVM_ASYNC_PF_EN.
+	is enabled in MSR_KVM_ASYNC_PF_EN.  The MSR is only available if
+	KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
 
 MSR_KVM_ASYNC_PF_ACK:
 	0x4b564d07
@@ -363,4 +365,5 @@ data:
 	When the guest is done processing type 2 APF event and 'pageready_token'
 	field in 'struct kvm_vcpu_pv_apf_data' is cleared it is supposed to
 	write '1' to bit 0 of the MSR, this caused the host to re-scan its queue
-	and check if there are more notifications pending.
+	and check if there are more notifications pending. The MSR is only
+	available if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 941fdf4569a4..921a55de5004 100644
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
index d21adc23a99f..ad826d922368 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3412,6 +3412,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

