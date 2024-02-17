Return-Path: <kvm+bounces-8964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0C6858F25
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 12:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 823F71C21377
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 11:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F145C6519E;
	Sat, 17 Feb 2024 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dR7C8TGE"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3123769D3A;
	Sat, 17 Feb 2024 11:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708170027; cv=none; b=dijuAqeNO2EuO5PHOCHQgt6ugMuYCXpHy6LIaFYobG5y71b6ya0L3hJU/i2gw501oY7EelYsPNOu5Di/hWkhqeseGchf/YIGZL+1cg5gV5hxRQ6L5h5YyOBTPi7rS0/Nv8dZSdDRK/aULjcMRT5/wrwowMaBb7nO1peBFh2UHAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708170027; c=relaxed/simple;
	bh=uBcNSjsif+abeDAk+chPtDqj8oWsJNCe+AeGbLMi68c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1nzno2ktMg/inoP6LDJKASvcBdpm+7iX05iZ6HA0kAFYn3jb4awggNhljTGvf0860FgESFaVRi+sKsHAy6xXC0A2qNOrc18IhAlGuYd0+ebyhIgszYf12ROzmDTmwidTP2CUzsRjqGK4uk/SBNHC/V1Qty+v7qKDkjXktzTsb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dR7C8TGE; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hu5J5fx2kJgZnYgwmuVlEzWXhnpobPtK6APDWPWVI+E=; b=dR7C8TGE0kl8P9C0+2Xa4UHkVX
	YAaX/41fHoK2nAYKHjNS+n4EWx5dCYAJqGT1P978pVwJwKE0Y1VUINi5cWvoiULl6z50cvfcolDXd
	9d5okQnkN0jc9SnalBgkpZFIA4DT0mIlPS+xsfzQj/7X2C/uVZ0+vOUx9Jmv5rfiE2AxUiGyoYP6T
	zc7as2IzVWqUKD/CXnY48w1DJJYIbqmb+f1TaLYA9Q1PM/Pe/vm2OzGisfqeg0MwksHF7jOMds8+4
	afy5SQNuin3iQ3YDOc4QtZ4yMVraRNDKruVKW6BoxmpQ6tFG8WEm8rFRUwhXhUa55n1vgvVb89Tj2
	NtOYjmDg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3M-00000000Kvi-41ni;
	Sat, 17 Feb 2024 11:40:21 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3L-00000000349-3LIv;
	Sat, 17 Feb 2024 11:40:19 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	David Woodhouse <dwmw@amazon.co.uk>,
	stable@vger.kernel.org
Subject: [PATCH 2/6] KVM: x86/xen: inject vCPU upcall vector when local APIC is enabled
Date: Sat, 17 Feb 2024 11:27:00 +0000
Message-ID: <20240217114017.11551-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240217114017.11551-1-dwmw2@infradead.org>
References: <20240217114017.11551-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Linux guests since commit b1c3497e604d ("x86/xen: Add support for
HVMOP_set_evtchn_upcall_vector") in v6.0 onwards will use the per-vCPU
upcall vector when it's advertised in the Xen CPUID leaves.

This upcall is injected through the guest's local APIC as an MSI, unlike
the older system vector which was merely injected by the hypervisor any
time the CPU was able to receive an interrupt and the upcall_pending
flags is set in its vcpu_info.

Effectively, that makes the per-CPU upcall edge triggered instead of
level triggered, which results in the upcall being lost if the MSI is
delivered when the local APIC is *disabled*.

Xen checks the vcpu_info->evtchn_upcall_pending flag when the local APIC
for a vCPU is software enabled (in fact, on any write to the SPIV
register which doesn't disable the APIC). Do the same in KVM since KVM
doesn't provide a way for userspace to intervene and trap accesses to
the SPIV register of a local APIC emulated by KVM.

Fixes: fde0451be8fb3 ("KVM: x86/xen: Support per-vCPU event channel upcall via local APIC")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/lapic.c |  5 ++++-
 arch/x86/kvm/xen.c   |  2 +-
 arch/x86/kvm/xen.h   | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2457..75bc7d3f0022 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -41,6 +41,7 @@
 #include "ioapic.h"
 #include "trace.h"
 #include "x86.h"
+#include "xen.h"
 #include "cpuid.h"
 #include "hyperv.h"
 #include "smm.h"
@@ -499,8 +500,10 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 	}
 
 	/* Check if there are APF page ready requests pending */
-	if (enabled)
+	if (enabled) {
 		kvm_make_request(KVM_REQ_APF_READY, apic->vcpu);
+		kvm_xen_sw_enable_lapic(apic->vcpu);
+	}
 }
 
 static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4a24899bbcfa..847d9e75df6d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -568,7 +568,7 @@ void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
 		kvm_xen_update_runstate_guest(v, state == RUNSTATE_runnable);
 }
 
-static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
+void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 {
 	struct kvm_lapic_irq irq = { };
 	int r;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index f8f1fe22d090..f5841d9000ae 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -18,6 +18,7 @@ extern struct static_key_false_deferred kvm_xen_enabled;
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
 void kvm_xen_inject_pending_events(struct kvm_vcpu *vcpu);
+void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *vcpu);
 int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
@@ -36,6 +37,19 @@ int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 const struct kvm_irq_routing_entry *ue);
 void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
 
+static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * The local APIC is being enabled. If the per-vCPU upcall vector is
+	 * set and the vCPU's evtchn_upcall_pending flag is set, inject the
+	 * interrupt.
+	 */
+	if (static_branch_unlikely(&kvm_xen_enabled.key) &&
+	    vcpu->arch.xen.vcpu_info_cache.active &&
+	    vcpu->arch.xen.upcall_vector && __kvm_xen_has_interrupt(vcpu))
+		kvm_xen_inject_vcpu_vector(vcpu);
+}
+
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
@@ -101,6 +115,10 @@ static inline void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 }
 
+static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
+{
+}
+
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return false;
-- 
2.43.0


