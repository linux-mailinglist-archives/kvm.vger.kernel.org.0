Return-Path: <kvm+bounces-18567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB9A8D6CCB
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE0B61C23B06
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD791353FF;
	Fri, 31 May 2024 23:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l4bNhPJ3"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6135813210A
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197273; cv=none; b=IRNyJqXxV6CZ3gAHgfza+TT+aJSQ1oOU9TLCaiGTP1uDyhts9qJWThoxWNysFfDnPiDXQy5BUn/PoFBTkMKFRpoOzv0obhhR+BMt4Xo1slk8HJ3DeAU28xuKA1y9wFH7Io65tQmtM2eM06NpK1kGZ1bWH4smUWaCTVN6v1QLQNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197273; c=relaxed/simple;
	bh=D7Zt66b1qk+rO2I4szZdh1ZY/OUl0QZgWAMHf506pGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugxFlzfJNk/P9oxR9eHHlcn4szXZHCWCWjnoSwtREY+mMcUCnSCpNVS7krSZPwbiVmRAkpsTe14f+2gbmEXBKDf84kFWjA9HOg7us3t4AiU8/Y/JeVoby8309iqquMNjKHqKv9VlwpX3RfTR2prksGmEIsXSw3Xe6vAelgMKVgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l4bNhPJ3; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWnX2756TccvQTYyzwienLX4hWKGtSZ6i2FdLd9tmUk=;
	b=l4bNhPJ32RzHFAWJSddOcM2VkZx7ofGHtMs7OlvKSBz8D/3QjN4p20uDIYJG4pbnFh6jQh
	U2ItKK2Qbzp8KXPcdQWZVWtWQZHQjtsRrfZa9DzLkKrRARivQywe1IxwpoLHIqBP5ExANY
	y4FxZa/ZD2pgYQyrnH0S6HViQW40FCc=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 10/11] KVM: arm64: nv: Honor guest hypervisor's FP/SVE traps in CPTR_EL2
Date: Fri, 31 May 2024 23:13:57 +0000
Message-ID: <20240531231358.1000039-11-oliver.upton@linux.dev>
In-Reply-To: <20240531231358.1000039-1-oliver.upton@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Start folding the guest hypervisor's FP/SVE traps into the value
programmed in hardware. Note that as of writing this is dead code, since
KVM does a full put() / load() for every nested exception boundary which
saves + flushes the FP/SVE state.

However, this will become useful when we can keep the guest's FP/SVE
state alive across a nested exception boundary and the host no longer
needs to conservatively program traps.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 697253673d7b..d07b4f4be5e5 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -85,6 +85,19 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
+	/*
+	 * Layer the guest hypervisor's trap configuration on top of our own if
+	 * we're in a nested context.
+	 */
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		goto write;
+
+	if (guest_hyp_fpsimd_traps_enabled(vcpu))
+		val &= ~CPACR_ELx_FPEN;
+	if (guest_hyp_sve_traps_enabled(vcpu))
+		val &= ~CPACR_ELx_ZEN;
+
+write:
 	write_sysreg(val, cpacr_el1);
 }
 
-- 
2.45.1.288.g0e0cd299f1-goog


