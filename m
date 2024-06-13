Return-Path: <kvm+bounces-19625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 019B1907D59
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 066A51C22F72
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2E813B5BD;
	Thu, 13 Jun 2024 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G9wxBycg"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ABB13B59C
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309927; cv=none; b=MHN5hxin3K78q8v7csW3hW/S216RamlWQZAKPtpoTnwJSt25mXKZw6LReEpFRnxuBBxAQMHPy7NSjk/RierVLR9vm29orRCGIQ4YfyCk81Jr3jCV7AhX47Df8gaAEu9vIJKqbTi6x1dMhuVgzZNHMgvoN4WIZwOUnITe2EvfMbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309927; c=relaxed/simple;
	bh=VPhj3ZV7pc5XQPimbFa7abcfD6OOUtRpMfqkUE3bXJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZliVh+Zvsql1/YsumxbD7dBDgJwbLtLkBAq07w/jZEtefCZYBPpkLFI0z9fC5lbsGah0QnS7iPEPfcBgQpt0TzvYqWPsaF1aG7o0JdkgzLxm2myvZJz8fPbKOh7fKT4DeAsCJF9mrVp033kuWiJlFLC/znEcI5ZaLX9jC0G0Vzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G9wxBycg; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bAPTXgIv3PeNYlA9AfrrSfEwtDvz9XkSajZIpwmTYAg=;
	b=G9wxBycgF/RJA0XtYAMN6QyQ6w7SfKr2CYomQiFVDzpMFhT/Oac2wPL8a8x3VuoDDFgEsT
	ZT5/UTCB32D+SSKn0OzfGpmZpXViT+WTB6jW/zORFYRdD2lf5/R7qY+DGi78O4mjmkOwgD
	TisqIidh/PBY6mMTiBQECbZebksHlm8=
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
Subject: [PATCH v2 08/15] KVM: arm64: nv: Use guest hypervisor's max VL when running nested guest
Date: Thu, 13 Jun 2024 20:17:49 +0000
Message-ID: <20240613201756.3258227-9-oliver.upton@linux.dev>
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

The max VL for nested guests is additionally constrained by the max VL
selected by the guest hypervisor. Use that instead of KVM's max VL when
running a nested guest.

Note that the guest hypervisor's ZCR_EL2 is sanitised against the VM's
max VL at the time of access, so there's no additional handling required
at the time of use.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 71a93e336a0c..0a6935a18490 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -314,10 +314,22 @@ static bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * The vCPU's saved SVE state layout always matches the max VL of the
+	 * vCPU. Start off with the max VL so we can load the SVE state.
+	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr);
 
+	/*
+	 * The effective VL for a VM could differ from the max VL when running a
+	 * nested guest, as the guest hypervisor could select a smaller VL. Slap
+	 * that into hardware before wrapping up.
+	 */
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))
+		sve_cond_update_zcr_vq(__vcpu_sys_reg(vcpu, ZCR_EL2), SYS_ZCR_EL2);
+
 	write_sysreg_el1(vcpu_sve_zcr_el1(vcpu), SYS_ZCR);
 }
 
-- 
2.45.2.627.g7a2c4fd464-goog


