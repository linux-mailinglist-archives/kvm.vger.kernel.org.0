Return-Path: <kvm+bounces-54988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83852B2C67F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F09E7B5BAB
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBA022129F;
	Tue, 19 Aug 2025 14:04:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D0221CC49;
	Tue, 19 Aug 2025 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755612251; cv=none; b=BVzwB8n7dmZaWP0Rqy1vgrrPIbRRxeMXcQEGcdhaz4MCVIUQCPB5IddNJGR3N0Qya4P3Uu93nLXhdAm95V6g7P8AR8YojZW6txHfc6EIETekDQ5V96xSQLPuwozCTSIKzjSd8XVfsAdzIp0pkDZUxuse5h80PYRpDsr3fie4FQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755612251; c=relaxed/simple;
	bh=mWOeWyXZd3HUAU90Y2HTN+tY7VI/QsuVF92m1zQVKMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBvSNm1UEpaj6nGtf0yxhbd3XYdVq2KJXRWdaBrT5q8p9tKW3BItP3GhuRSwZnzmgDvvALXFNlFCKY8dE17m8jNnfONPDgDxA0SRXyWv3QKOaSYd6wcLPzWcmuse9OfHcSuPoHtLTP4MZMgukVXZm3oXeAnQgoMKDJi5oap+T1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1uoMRv-00000001OeO-2UET;
	Tue, 19 Aug 2025 15:32:27 +0200
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR when setting LAPIC regs
Date: Tue, 19 Aug 2025 15:32:14 +0200
Message-ID: <2b2cfff9a2bd6bcc97b97fee7f3a3e1186c9b03c.1755609446.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755609446.git.maciej.szmigiero@oracle.com>
References: <cover.1755609446.git.maciej.szmigiero@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: mhej@vps-ovh.mhejs.net

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

When AVIC is enabled the normal pre-VMRUN sync in sync_lapic_to_cr8() is
inhibited so any changed TPR in the LAPIC state would not get copied into
the V_TPR field of VMCB.

AVIC does sync between these two fields, however it does so only on
explicit guest writes to one of these fields, not on a bare VMRUN.

This is especially true when it is the userspace setting LAPIC state via
KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
VMCB.

Practice shows that it is the V_TPR that is actually used by the AVIC to
decide whether to issue pending interrupts to the CPU (not TPR in TASKPRI),
so any leftover value in V_TPR will cause serious interrupt delivery issues
in the guest when AVIC is enabled.

Fix this issue by explicitly copying LAPIC TPR to VMCB::V_TPR in
avic_apicv_post_state_restore(), which gets called from KVM_SET_LAPIC and
similar code paths when AVIC is enabled.

Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/avic.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a34c5c3b164e..877bc3db2c6e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -725,8 +725,31 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 cr8;
+
 	avic_handle_dfr_update(vcpu);
 	avic_handle_ldr_update(vcpu);
+
+	/* Running nested should have inhibited AVIC. */
+	if (WARN_ON_ONCE(nested_svm_virtualize_tpr(vcpu)))
+		return;
+
+	/*
+	 * Sync TPR from LAPIC TASKPRI into V_TPR field of the VMCB.
+	 *
+	 * When AVIC is enabled the normal pre-VMRUN sync in sync_lapic_to_cr8()
+	 * is inhibited so any set TPR LAPIC state would not get reflected
+	 * in V_TPR.
+	 *
+	 * Practice shows that it is the V_TPR that is actually used by the
+	 * AVIC to decide whether to issue pending interrupts to the CPU, not
+	 * TPR in TASKPRI.
+	 */
+	cr8 = kvm_get_cr8(vcpu);
+	svm->vmcb->control.int_ctl &= ~V_TPR_MASK;
+	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
+	WARN_ON_ONCE(!vmcb_is_dirty(svm->vmcb, VMCB_INTR));
 }
 
 static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)

