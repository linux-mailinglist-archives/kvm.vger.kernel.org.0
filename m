Return-Path: <kvm+bounces-18565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6688D6CC9
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B03371C244DB
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7CE132133;
	Fri, 31 May 2024 23:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nLfSr2EE"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B21A13210A
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197270; cv=none; b=s+v64775Nmoa/7+caE43zfluS1AJTDj0qFQPJQ86AOwG8Lntk+tkqigil/ElKqiTwKQpA6HzbwzzC6On60ppMkKQQsQsM2ol9cNflQhuw1ao5Qj8c3kDC9UfS73IxZgKIzo9lKi8yVsS7DbP0wvrm7Myp2QB/AC+Rn/KZcLv4Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197270; c=relaxed/simple;
	bh=R7yIcMpUMHz2/6zuVxreAZEvfkw8+EJoWnedY5S6AkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex5T406cSATa9Bajf+fGcFX5zmnBVRyHj2LAdRPyD6EUCaNwfmwe6Lb/eME2yBfThDk1CFSFCgz2eDxoFwCDsKMBdelFhSbNnhxfWldXRtAnz4OGqqDNm2/yz6wWoDe6qiIrt0FKK8QPyovv9cfzv7ma3x3FzB5P4qCSQFYx++k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nLfSr2EE; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dLj+sS8bfnZwsflhlK/uP7qt7UV7JOO+rAZQrmf8q6c=;
	b=nLfSr2EEbO95NdG9Oe3fiY7I4IlfLAJmwDyBxT76SnPf5cf/lB0xt9TrCwqgdyJUtPizhC
	5mtzE6zKcCwYLmDRyEYvNGcPJfiIgqn0Q5N31XxSKn2hr40OVmt4/Q68i5800GYrVh6qBp
	agv3nsiy/1MVMRgvhTNLJjBtMTbS59U=
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
Subject: [PATCH 08/11] KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
Date: Fri, 31 May 2024 23:13:55 +0000
Message-ID: <20240531231358.1000039-9-oliver.upton@linux.dev>
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
2.45.1.288.g0e0cd299f1-goog


