Return-Path: <kvm+bounces-19626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CF98907D5A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:19:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A44F51F23CA2
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33EB5137905;
	Thu, 13 Jun 2024 20:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OMQxiMpG"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F373D13B5B6
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309929; cv=none; b=ffoUekjjOCwU7xPEL26Fhp1vZ2m7mEiu8F/KP2ARa9gAP2eJRYFvz9wMkC5ZOvAliemOZYZfIPwoG90H6WbB6yLN4C+BO521yl1nU5jbVYq6crpgb8j9v1a4FgpxgjP6YgU4UVUtubRk9aUMiz+0Peh7762YAEIH6bpHOpP1+QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309929; c=relaxed/simple;
	bh=vZpSDKJJKCBjmfKgXHhQnUdls4VJOb7g3qqn5Q0IhkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tohn4NkLkDarqFQ/5nUL1QauwBJK724T7tkdLxYa59zBXBzbIvEwgyyQBkdNJ13WGIm22Gs4myk9/XkPJ+wG+ehfXUzhhcglYB6SgaWWmkMeA4c4x5nlobYqqtwB6VOvUqreMoc+wNB063b5io0+pGMuT4hqq6Zb3jhZqi58Wcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OMQxiMpG; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/N4HwIRI6RfqJ7tdpRm7rKOSFshkwGH2p2wXo67EDDE=;
	b=OMQxiMpGOoL1yIxsLirg64xUne/nGRwrfF1POVPpRqb9rMyEaZUzwTKVR4QOCT8f9tNSqh
	80g8hCuZ2AZH88jAAjDL5Jj0vtyVMqESIdrsHv3d3MCIiDrkM+VN6kgqPW4r1Cu8DN1Mit
	QqzDc2YriDBUhf8UkMmrnmNpil3rfaA=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 09/15] KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
Date: Thu, 13 Jun 2024 20:17:50 +0000
Message-ID: <20240613201756.3258227-10-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It is possible that the guest hypervisor has selected a smaller VL than
the maximum for its nested guest. As such, ZCR_EL2 may be configured for
a different VL when exiting a nested guest.

Set ZCR_EL2 (via the EL1 alias) to the maximum VL for the VM before
saving SVE state as the SVE save area is dimensioned by the max VL.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/fpsimd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 53168bbea8a7..bb2ef3166c63 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -193,11 +193,14 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			 * Note that this means that at guest exit ZCR_EL1 is
 			 * not necessarily the same as on guest entry.
 			 *
-			 * Restoring the VL isn't needed in VHE mode since
-			 * ZCR_EL2 (accessed via ZCR_EL1) would fulfill the same
-			 * role when doing the save from EL2.
+			 * ZCR_EL2 holds the guest hypervisor's VL when running
+			 * a nested guest, which could be smaller than the
+			 * max for the vCPU. Similar to above, we first need to
+			 * switch to a VL consistent with the layout of the
+			 * vCPU's SVE state. KVM support for NV implies VHE, so
+			 * using the ZCR_EL1 alias is safe.
 			 */
-			if (!has_vhe())
+			if (!has_vhe() || (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)))
 				sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1,
 						       SYS_ZCR_EL1);
 		}
-- 
2.45.2.627.g7a2c4fd464-goog


