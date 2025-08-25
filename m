Return-Path: <kvm+bounces-55650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84713B347E3
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 18:45:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6442C5E2689
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E18E3019CB;
	Mon, 25 Aug 2025 16:44:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B575221F32;
	Mon, 25 Aug 2025 16:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756140292; cv=none; b=cI2c8vBHyGjsyrDiFwLL/B9krunHBLa+wAPq0GrxR/djGjiCIm4fLatPoTYiLTuyMDXpy+9iv78JxK38rmTCdcMTHebWkTfmCm8RdMBE8NkbmwBdNMpblL7K743bG4rkJo7qigGPKm8bhQegPoLNHh64Dn13H3L0MeLtHnVwdhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756140292; c=relaxed/simple;
	bh=OfQXdmPThHcEMsFk9gVXp1uPOlRN9AX3jV4emLSZ37I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qo/n7CH2bmEWGiBIyGQTVJGm5/FgLJS4x+NyjAKyyZFn6q0jR3pQwErWcHNcRIXlUhEqPIVT5FBPMiDS8b/2gVuYwQxN87S/bX50Lxj+3gWMt6lJcqC5D8OC5IKfAncf2WLK+dIaZLzPv1WXgIQaQO20swQ8leAv1CS01Jrv5Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1uqaJE-00000001lNm-2IYS;
	Mon, 25 Aug 2025 18:44:40 +0200
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
	Naveen N Rao <naveen@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active
Date: Mon, 25 Aug 2025 18:44:28 +0200
Message-ID: <c231be64280b1461e854e1ce3595d70cde3a2e9d.1756139678.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756139678.git.maciej.szmigiero@oracle.com>
References: <cover.1756139678.git.maciej.szmigiero@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: mhej@vps-ovh.mhejs.net

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Commit 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
inhibited pre-VMRUN sync of TPR from LAPIC into VMCB::V_TPR in
sync_lapic_to_cr8() when AVIC is active.

AVIC does automatically sync between these two fields, however it does
so only on explicit guest writes to one of these fields, not on a bare
VMRUN.

This meant that when AVIC is enabled host changes to TPR in the LAPIC
state might not get automatically copied into the V_TPR field of VMCB.

This is especially true when it is the userspace setting LAPIC state via
KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
VMCB.

Practice shows that it is the V_TPR that is actually used by the AVIC to
decide whether to issue pending interrupts to the CPU (not TPR in TASKPRI),
so any leftover value in V_TPR will cause serious interrupt delivery issues
in the guest when AVIC is enabled.

Fix this issue by doing pre-VMRUN TPR sync from LAPIC into VMCB::V_TPR
even when AVIC is enabled.

Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..1bfebe40854f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4046,8 +4046,7 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 cr8;
 
-	if (nested_svm_virtualize_tpr(vcpu) ||
-	    kvm_vcpu_apicv_active(vcpu))
+	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
 	cr8 = kvm_get_cr8(vcpu);

