Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDFF933BA8
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 01:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFCXBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 19:01:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfFCXBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 19:01:22 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17AB2285B4;
        Mon,  3 Jun 2019 23:01:21 +0000 (UTC)
Received: from amt.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59A251001DE0;
        Mon,  3 Jun 2019 23:01:20 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id AABE410515C;
        Mon,  3 Jun 2019 19:54:57 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x53MsvCh007683;
        Mon, 3 Jun 2019 19:54:57 -0300
Message-Id: <20190603225254.292226777@amt.cnet>
User-Agent: quilt/0.60-1
Date:   Mon, 03 Jun 2019 19:52:44 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-15?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= 
        <rkrcmar@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 2/3] kvm: x86: add host poll control msrs
References: <20190603225242.289109849@amt.cnet>
Content-Disposition: inline; filename=02-pollcontrol-host.patch
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 03 Jun 2019 23:01:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an MSRs which allows the guest to disable 
host polling (specifically the cpuidle-haltpoll, 
when performing polling in the guest, disables
host side polling).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 Documentation/virtual/kvm/msr.txt    |    9 +++++++++
 arch/x86/include/asm/kvm_host.h      |    2 ++
 arch/x86/include/uapi/asm/kvm_para.h |    2 ++
 arch/x86/kvm/Kconfig                 |    1 +
 arch/x86/kvm/cpuid.c                 |    3 ++-
 arch/x86/kvm/x86.c                   |   23 +++++++++++++++++++++++
 6 files changed, 39 insertions(+), 1 deletion(-)

Index: linux-2.6.git/Documentation/virtual/kvm/msr.txt
===================================================================
--- linux-2.6.git.orig/Documentation/virtual/kvm/msr.txt	2018-05-18 15:40:19.697438928 -0300
+++ linux-2.6.git/Documentation/virtual/kvm/msr.txt	2019-06-03 19:37:49.618543527 -0300
@@ -273,3 +273,12 @@
 	guest must both read the least significant bit in the memory area and
 	clear it using a single CPU instruction, such as test and clear, or
 	compare and exchange.
+
+MSR_KVM_POLL_CONTROL: 0x4b564d05
+	Control host side polling.
+
+	data: Bit 0 enables (1) or disables (0) host halt poll
+	logic.
+	KVM guests can disable host halt polling when performing
+	polling themselves.
+
Index: linux-2.6.git/arch/x86/include/asm/kvm_host.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/kvm_host.h	2019-05-29 14:46:14.516005546 -0300
+++ linux-2.6.git/arch/x86/include/asm/kvm_host.h	2019-06-03 19:37:49.619543530 -0300
@@ -755,6 +755,8 @@
 		struct gfn_to_hva_cache data;
 	} pv_eoi;
 
+	u64 msr_kvm_poll_control;
+
 	/*
 	 * Indicate whether the access faults on its page table in guest
 	 * which is set when fix page fault and used to detect unhandeable
Index: linux-2.6.git/arch/x86/include/uapi/asm/kvm_para.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/uapi/asm/kvm_para.h	2019-01-04 12:07:15.936947406 -0200
+++ linux-2.6.git/arch/x86/include/uapi/asm/kvm_para.h	2019-06-03 19:37:49.620543534 -0300
@@ -29,6 +29,7 @@
 #define KVM_FEATURE_PV_TLB_FLUSH	9
 #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
 #define KVM_FEATURE_PV_SEND_IPI	11
+#define KVM_FEATURE_POLL_CONTROL	12
 
 #define KVM_HINTS_REALTIME      0
 
@@ -47,6 +48,7 @@
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
+#define MSR_KVM_POLL_CONTROL	0x4b564d05
 
 struct kvm_steal_time {
 	__u64 steal;
Index: linux-2.6.git/arch/x86/kvm/Kconfig
===================================================================
--- linux-2.6.git.orig/arch/x86/kvm/Kconfig	2019-05-29 14:46:14.530005593 -0300
+++ linux-2.6.git/arch/x86/kvm/Kconfig	2019-06-03 19:37:49.620543534 -0300
@@ -41,6 +41,7 @@
 	select PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
+	select HAVE_KVM_NO_POLL
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
Index: linux-2.6.git/arch/x86/kvm/cpuid.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kvm/cpuid.c	2019-05-29 14:46:14.530005593 -0300
+++ linux-2.6.git/arch/x86/kvm/cpuid.c	2019-06-03 19:37:49.621543537 -0300
@@ -643,7 +643,8 @@
 			     (1 << KVM_FEATURE_PV_UNHALT) |
 			     (1 << KVM_FEATURE_PV_TLB_FLUSH) |
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
-			     (1 << KVM_FEATURE_PV_SEND_IPI);
+			     (1 << KVM_FEATURE_PV_SEND_IPI) |
+			     (1 << KVM_FEATURE_POLL_CONTROL);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
Index: linux-2.6.git/arch/x86/kvm/x86.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kvm/x86.c	2019-05-29 14:46:14.537005616 -0300
+++ linux-2.6.git/arch/x86/kvm/x86.c	2019-06-03 19:37:49.624543547 -0300
@@ -1177,6 +1177,7 @@
 	MSR_IA32_POWER_CTL,
 
 	MSR_K7_HWCR,
+	MSR_KVM_POLL_CONTROL,
 };
 
 static unsigned num_emulated_msrs;
@@ -2628,6 +2629,14 @@
 			return 1;
 		break;
 
+	case MSR_KVM_POLL_CONTROL:
+		/* only enable bit supported */
+		if (data & (-1ULL << 1))
+			return 1;
+
+		vcpu->arch.msr_kvm_poll_control = data;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -2877,6 +2886,9 @@
 	case MSR_KVM_PV_EOI_EN:
 		msr_info->data = vcpu->arch.pv_eoi.msr_val;
 		break;
+	case MSR_KVM_POLL_CONTROL:
+		msr_info->data = vcpu->arch.msr_kvm_poll_control;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -8874,6 +8886,10 @@
 	msr.host_initiated = true;
 	kvm_write_tsc(vcpu, &msr);
 	vcpu_put(vcpu);
+
+	/* poll control enabled by default */
+	vcpu->arch.msr_kvm_poll_control = 1;
+
 	mutex_unlock(&vcpu->mutex);
 
 	if (!kvmclock_periodic_sync)
@@ -9948,6 +9964,13 @@
 }
 EXPORT_SYMBOL_GPL(kvm_vector_hashing_enabled);
 
+bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->arch.msr_kvm_poll_control & 1) == 0;
+}
+EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
+
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);


