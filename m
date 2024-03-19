Return-Path: <kvm+bounces-12164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A51588026A
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 062E1282A16
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752E51804A;
	Tue, 19 Mar 2024 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WcMDMe3c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC71217550
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710866109; cv=none; b=CKlgsuHeTvERLHv8JWc51aLSchY4q1fGbZEaxMsbT9e+lGodbQwmcLVkwyzlLPXrkj9shD+iSKzwf0yndWiMD4NPxBVgG/pAmjDFkqLs6eYSLO8GQYaJYZjIsCqsVIq2QjApMrB1U4hRN4MjSnnYhJrxhQILl60oOR8KGElngJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710866109; c=relaxed/simple;
	bh=DZcIdpEYDtyvpBwX6sQ+oG1Juy4yZCi8Pkp/MZRvJbk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hMxRHipTMtHMjFsnx9DD2kskhkSLgi4FHRUG6MCn16fMOSZDQBoLFNDMMa+sIqNIqFTJhzkkIJlPLzZGuYo5lYsf9FSYU6IToFVEaBkD+0uZjZ62WYMVGY5TqJaNbsDtR76aYsDmXE5NwMX02boC+NJPHVKeGkCx5n3qPC8Sl6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WcMDMe3c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710866106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1A6JplVJpKt9d5YjCUp/W/cMYHIdnlJlDtDSH3FwDD4=;
	b=WcMDMe3c+xBpeOCkMyBnArl9TzhDJ1Qk1lAFbKr5ye/mMpZUJbHyXHPasKOaQmFh/qLbAl
	NvE7IqNwi1wYSdO1bCLoUdJqDsqECNnBQL9kfol8GRNLr249ojni0EtDlG+3WIOkA5XMY8
	xu3I43JwFc3Dag3pnIO3/s0uOQcRsZU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-WmWgR7J4PviBPQvXQR9ICQ-1; Tue, 19 Mar 2024 12:35:03 -0400
X-MC-Unique: WmWgR7J4PviBPQvXQR9ICQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19A9A1801DB9;
	Tue, 19 Mar 2024 16:35:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.225.95])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1C1FE2024517;
	Tue, 19 Mar 2024 16:35:01 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Daan De Meyer <daan.j.demeyer@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC not-to-be-merged] KVM: SVM: Workaround overly strict CR3 check by Hyper-V
Date: Tue, 19 Mar 2024 17:34:56 +0100
Message-ID: <20240319163456.133942-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Failing VMRUNs (immediate #VMEXIT with error code VMEXIT_INVALID) for KVM
guests on top of Hyper-V are observed when KVM does SMM emulation. The root
cause of the problem appears to be an overly strict CR3 VMCB check done by
Hyper-V. Here's an example of a CR state which triggers the failure:

 kvm_amd: vmpl: 0   cpl: 0   efer: 0000000000001000
 kvm_amd: cr0: 0000000000050032 cr2: ffff92dcf8601000
 kvm_amd: cr3: 0000000100232003 cr4: 0000000000000040

CR3 value may look a bit weird as it has non-zero PCID bits set as well as
non-zero bits in the upper half but the processor is not in long
mode. This, however, is a valid state upon entering SMM from a long mode
context with PCID enabled and should not be causing VMEXIT_INVALID. APM
says that VMEXIT_INVALID is triggered when "Any MBZ bit of CR3 is
set.". In CR3 format the only MBZ bits are those above MAXPHYADDR, the rest
is just "Reserved".

Place a temporary workaround in KVM to avoid putting problematic CR3
values into VMCB when KVM runs on top of Hyper-V. Enable CR3 READ/WRITE
intercepts to make sure guest is not observing side-effects of the
mangling. Also, do not overwrite 'vcpu->arch.cr3' with mangled 'save.cr3'
value when CR3 intercepts are enabled (and thus a possible CR3 update from
the guest would change 'vcpu->arch.cr3' instantly).

The workaround is only needed until Hyper-V gets fixed.

Reported-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- The patch serves mostly documentational purposes, I don't expect it to
be merged to the mainline. Hyper-V *is* supposed to get fixed but the
timeline is unclear at this point. As Azure is a fairly popular platform
for running nested KVM, it is possible that the bug will get discovered
again (running OVMF based guest is a good starting point!).
---
 arch/x86/kvm/svm/svm.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 272d5ed37ce7..6ff7cbcb5cac 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -41,6 +41,7 @@
 #include <asm/traps.h>
 #include <asm/reboot.h>
 #include <asm/fpu/api.h>
+#include <asm/hypervisor.h>
 
 #include <trace/events/ipi.h>
 
@@ -3497,7 +3498,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (!sev_es_guest(vcpu->kvm)) {
 		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
 			vcpu->arch.cr0 = svm->vmcb->save.cr0;
-		if (npt_enabled)
+		if (npt_enabled && !svm_is_intercept(svm, INTERCEPT_CR3_WRITE))
 			vcpu->arch.cr3 = svm->vmcb->save.cr3;
 	}
 
@@ -4264,6 +4265,33 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		cr3 = root_hpa;
 	}
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	/*
+	 * Workaround an issue in Hyper-V hypervisor where 'reserved' bits are treated
+	 * as MBZ failing VMRUN.
+	 */
+	if (hypervisor_is_type(X86_HYPER_MS_HYPERV) && likely(npt_enabled)) {
+		unsigned long cr3_unmod = cr3;
+
+		/*
+		 * Bits MAXPHYADDR:63 are MBZ but bits 32:MAXPHYADDR-1 are just 'reserved'
+		 * in !long mode.
+		 */
+		if (!is_long_mode(vcpu))
+			cr3 &= ~rsvd_bits(32, cpuid_maxphyaddr(vcpu) - 1);
+
+		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE))
+			cr3 &= ~X86_CR3_PCID_MASK;
+
+		if (cr3 != cr3_unmod && !svm_is_intercept(svm, INTERCEPT_CR3_READ)) {
+			svm_set_intercept(svm, INTERCEPT_CR3_READ);
+			svm_set_intercept(svm, INTERCEPT_CR3_WRITE);
+		} else if (cr3 == cr3_unmod && svm_is_intercept(svm, INTERCEPT_CR3_READ)) {
+			svm_clr_intercept(svm, INTERCEPT_CR3_READ);
+			svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
+		}
+	}
+#endif
 	svm->vmcb->save.cr3 = cr3;
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 }
-- 
2.44.0


