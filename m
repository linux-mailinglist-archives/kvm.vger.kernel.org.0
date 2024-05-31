Return-Path: <kvm+bounces-18563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 911DB8D6CC7
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C31731C23E7E
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3710384FCD;
	Fri, 31 May 2024 23:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ghl/Iskz"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE208130A4D
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197268; cv=none; b=GdhtbnG5KtvXefZXcTjzuZ5egcRPI7QasKQlH8A/eqo8nR/+YjP2d3Rake6nJ70Un2fz2L4iBjxwuYahowaFbqX4If9RCF4teDz71O5OMyW66LNanu6lnOdnJmwQedyGX+SemDg1hpAzdY4GTsmtCiTIDyrqPYrlfmPUe9uPf4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197268; c=relaxed/simple;
	bh=ZYqCChw0hfWIeJR9KxVug6g2WJ+ytT95ljLL0/noKvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f71vA0DBCGiAXvQsBbmwW3xdjr287u5Gwv0+X2NWsm/JfikXh5x1AuFnZ1cRx2KkVj2zT9KgK/DwpzlzqTbOLQCLH6waEa395YTOGXCMd/AoUWJC1HA7/vnkNK2iANQmrd1kWKxQvNImK7KaCH8Zmq4ZUKLejQPkTjU+IPtOz9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ghl/Iskz; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QihSmQoz0iowSjFRYFy48HKQHNUekF/0Bi4J8iGu+ks=;
	b=ghl/Iskz6sOklQTuwb1xCLhhyeG62isYKB8zqePtNtgsUh3OXjaj8LhQrQz1QbLDBdCBHB
	TZJNKRobvDJopV1f+1jCh1tK7598MqG3SVvR0Ocwh6c2bmzSMXIEKLLRrjOCrga8AnJkK8
	w2ROOHBisH0hrbKsjVkRZkWROjytPbg=
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
Subject: [PATCH 06/11] KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
Date: Fri, 31 May 2024 23:13:53 +0000
Message-ID: <20240531231358.1000039-7-oliver.upton@linux.dev>
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

When running a guest hypervisor, ZCR_EL2 is an alias for the counterpart
EL1 state.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/fpsimd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 1807d3a79a8a..53168bbea8a7 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -173,7 +173,16 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu)) {
-			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+			u64 zcr = read_sysreg_el1(SYS_ZCR);
+
+			/*
+			 * If the vCPU is in the hyp context then ZCR_EL1 is
+			 * loaded with its vEL2 counterpart.
+			 */
+			if (is_hyp_ctxt(vcpu))
+				__vcpu_sys_reg(vcpu, ZCR_EL2) = zcr;
+			else
+				__vcpu_sys_reg(vcpu, ZCR_EL1) = zcr;
 
 			/*
 			 * Restore the VL that was saved when bound to the CPU,
-- 
2.45.1.288.g0e0cd299f1-goog


