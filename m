Return-Path: <kvm+bounces-20126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAEF910D7A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01DC1C2133C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FD51B3F3C;
	Thu, 20 Jun 2024 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hwd/bytR"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806A01B3F30
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902038; cv=none; b=nlVNA/tcFgIbtdYAvm4T1nI1fCJA8d90cXIJ7hJnQcXw7ChEhQFYDqehnm0QL7BG4hxmwecNdLLB4wzdqyBnOJ9x8FGmzuRlx67DBjod6aOwExDFXg9sWiKPkjyXgiwIwlP3h+hYK4+DUsPwQtBXc8QDkdsS47lPKm6S4EZ0JzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902038; c=relaxed/simple;
	bh=tJlPrqW1eWQjQsPRwIX2fZ7adL8zHKb6NOP8VUWDKd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcqCamP72RwM0GP72bnI9qSRY8YV5Q3Qx4uPjE/e5VA9fnXR3BwpeH40UyG+zsPTNOkqkPF8mR5LzmARs7sTmV6BNnBFrtG+d4Q9bUhwb3uBbeYxLclku7UCYVkYStHIl09u8wtZAb/Vy3J+ojHuk0WmwbOnxraKtEdI18nIReY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hwd/bytR; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qa5SQ5ZGOqhKVPfOYLLgM23ZGqX6pCTYzsPBsDZvBQE=;
	b=hwd/bytRo8ec6YeZyg0F6NvCN4Pmk3oiItd6ypvdXipJV1VwWz9I4pN/WwcfZGaUaUZ/Oh
	GZgnIukCnp1hOSvOSTywQTfY4ZC2rGzskpAwzN/pzxa36EoD1y8D9vfN83+E6MhVnas3+i
	T+LEUH06hJl69UynvIbMcC/WJtJMttw=
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
Subject: [PATCH v3 06/15] KVM: arm64: nv: Use guest hypervisor's max VL when running nested guest
Date: Thu, 20 Jun 2024 16:46:43 +0000
Message-ID: <20240620164653.1130714-7-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
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

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index aeb08c2d926d..aaad4d68b6e7 100644
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
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
 }
 
-- 
2.45.2.741.gdbec12cfda-goog


