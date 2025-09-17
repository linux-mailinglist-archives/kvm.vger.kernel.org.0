Return-Path: <kvm+bounces-57941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5533B81F28
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 174A27BD83C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C9A30B539;
	Wed, 17 Sep 2025 21:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C66xWBll"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B863064A3
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144128; cv=none; b=sA2oSkRug/2X0XiYqvv6Y2+d+VtYn79Eo/7L49Yk/G7IDGjCVGWmobnlu0KmB+3KPASBhMqIZFcgXAiU6U9GFG2AkZIJd3R0B1MruNIQGYnS4LF2TNMnpLwGDRky7wPBws3h2+pO3P5GHf/ZabwZmpQR9ScLigln872lF8q4/aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144128; c=relaxed/simple;
	bh=2ECb426czea2SYpYkhE4DmYNqWooTIHU5M0c80YM+So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIptEOnqkPW9ASi+x1nDVo5ZU1y7L/muHGvwbSobGN8IP0V4ZCR7j/417BYD/5qD/19ZdYsN78ITpFDKSnM2hhh1RjFzOog9cDuJgFQNkt25COnjEsYqsmEC8+7CkDDxSCUMtbhIMrlF0uW/sM51INEu64jcOgaKlFikxbrkrCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C66xWBll; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X0/Qc2BPdulXzfpw/A9mgu/rx012qP724b25vcBgdKs=;
	b=C66xWBllv8a5VboTd2riAgHmMXWq8+fWcdel1J+qLpm06LzgAK5neOKLGikjzY9ZGLKy29
	f0ubT/b1OgANBHzxEyoZ2fEKpNMvLtVa+/Tv+wgcHX4sWeBEs05eehFv2i76hqpCOf7/AE
	NzeRnmYVg+X/qjRyIY3i/L8WpgWa0ek=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 11/13] KVM: arm64: selftests: Initialize HCR_EL2
Date: Wed, 17 Sep 2025 14:20:41 -0700
Message-ID: <20250917212044.294760-12-oliver.upton@linux.dev>
In-Reply-To: <20250917212044.294760-1-oliver.upton@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Initialize HCR_EL2 such that EL2&0 is considered 'InHost', allowing the
use of (mostly) unmodified EL1 selftests at EL2.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/lib/arm64/processor.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 5ae65fefd48c..4339de2fc482 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -369,6 +369,12 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
 	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_TTBR0_EL1), ttbr0_el1);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpu->id);
+
+	if (!vcpu_has_el2(vcpu))
+		return;
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
+		     HCR_EL2_RW | HCR_EL2_TGE | HCR_EL2_E2H);
 }
 
 void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
-- 
2.47.3


