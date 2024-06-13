Return-Path: <kvm+bounces-19619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7995907D53
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 808F81F212EF
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D205413A3F2;
	Thu, 13 Jun 2024 20:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g4BWyqOg"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB1C6EB5B
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309917; cv=none; b=elniNYbmTQGbOWkyNYmc/GwrPBVt0+hWxIWNqhixTmpdDBT1rxoi/OL71scUofnxB21sFzwjYA024hg7Oj51MkUGvNZDPc/bbPKUWeq0VIYhQ1VnwQGzKJhvmdsprLYTYJgobL0NdcunJ3L3Uxtqcj02PNlo0wbskDeofgsHwIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309917; c=relaxed/simple;
	bh=Ub7cBhaZghp/7EIZw3h+YoSzZNnE61znv3YAaWGcYl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBla/EF7qjqKYvazawelcyqCPgZ13VTmRTsD2EOgj9IG+m2hJQqYlzNsFQdICDgHFjDD4Bjz64OoKJa7u7ojQmeOWUYVazCaOmJudRbOP4E/QtgS1QWC25y4nPmFWjAQgZz82aPKMwObE+Qoscewje9Ni0v2QBiQpBPcKCft/hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g4BWyqOg; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=64M8FdEtOB1Ojo+PxZZQjCNBmwNN4pM6Gv5X8EBKM08=;
	b=g4BWyqOghbEwZXnQnIZXuofIBE5WjAfHjLtbm6f+7pb8wcZTXz0sSwoH3kyv7PMkXzfmAS
	4XaG5P+GGNL4wdyW1JsypQ+HwHmQpGafaszFWYj/WjRHoeByR55Fm+3ONNT7txljVFG9Or
	mzDtPVS37EkpycW4UHXcsapwsp5PUhM=
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
Subject: [PATCH v2 02/15] KVM: arm64: nv: Forward SVE traps to guest hypervisor
Date: Thu, 13 Jun 2024 20:17:43 +0000
Message-ID: <20240613201756.3258227-3-oliver.upton@linux.dev>
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

Similar to FPSIMD traps, don't load SVE state if the guest hypervisor
has SVE traps enabled and forward the trap instead. Note that ZCR_EL2
will require some special handling, as it takes a sysreg trap to EL2
when HCR_EL2.NV = 1.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h    | 4 ++++
 arch/arm64/kvm/handle_exit.c            | 3 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c3c5a5999ed7..cc5c93b46e6f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -641,5 +641,9 @@ static inline bool guest_hyp_fpsimd_traps_enabled(const struct kvm_vcpu *vcpu)
 	return __guest_hyp_cptr_xen_trap_enabled(vcpu, FPEN);
 }
 
+static inline bool guest_hyp_sve_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	return __guest_hyp_cptr_xen_trap_enabled(vcpu, ZEN);
+}
 
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 59fe9b10a87a..e4f74699f360 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -217,6 +217,9 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
  */
 static int handle_sve(struct kvm_vcpu *vcpu)
 {
+	if (guest_hyp_sve_traps_enabled(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index b302d32f8326..428ee15dd6ae 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -348,6 +348,8 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)
 			return false;
+		if (guest_hyp_sve_traps_enabled(vcpu))
+			return false;
 		break;
 	default:
 		return false;
-- 
2.45.2.627.g7a2c4fd464-goog


