Return-Path: <kvm+bounces-20121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8025E910D72
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A53F1F21DE7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0AC1B3756;
	Thu, 20 Jun 2024 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lcnSzIhx"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CE41B29AC
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902032; cv=none; b=RP2uoXXLn50+6//ojZ6UbVnUjbMknx8m10MxwZzDhuV5JZvCy597g54AmW3IcBAMQouTy+B6KGQAzQOv+3KBqTawTcGYgSja4Ba8cMju6/6AG+ngea+OrBytzsL6f1aQdB6oU4zr5E1bypJXLZr/O6JlbiXlCx+eMuvJVM/8HkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902032; c=relaxed/simple;
	bh=ETX0LQ7kYSg7RqI/4kAd77n7iye+m5txnswDWv+x1iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pA214epwtsHTDRAAfWlQUlcza3NvvaChtfN700a5pMNaYp29AnyKrfSYXOP6/Zj6PcAzQ6OblXhTl06NPcsGFrYYps9YBoRANxRGz5WidVXloHuCIk76Ti+Vd5gpxKreLgaC6RCbUkiun2uYrAtiXehsFDCSgoaBNN76UbfBRY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lcnSzIhx; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H05WUL/HhblgxcxQS07XCyaa2Ay55FYE9vwptiKKacE=;
	b=lcnSzIhxLamBw3LAgU4LdacXsVx2zETov7WpP36KoPfoeZh2NHgOtCXK6tSSIk/B9zTxtm
	lT2DBf6zX9yTYS3b3n4GvTk2KJ8vUNFcqNbx99K4dDAuWmYWi7NFiRBFJmrsvA29StLHLj
	gBQ1rd10TnXC29zOCTwkxF63Cyfdz7U=
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
Subject: [PATCH v3 02/15] KVM: arm64: nv: Forward SVE traps to guest hypervisor
Date: Thu, 20 Jun 2024 16:46:39 +0000
Message-ID: <20240620164653.1130714-3-oliver.upton@linux.dev>
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

Similar to FPSIMD traps, don't load SVE state if the guest hypervisor
has SVE traps enabled and forward the trap instead. Note that ZCR_EL2
will require some special handling, as it takes a sysreg trap to EL2
when HCR_EL2.NV = 1.

Reviewed-by: Marc Zyngier <maz@kernel.org>
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
2.45.2.741.gdbec12cfda-goog


