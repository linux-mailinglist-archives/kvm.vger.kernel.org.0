Return-Path: <kvm+bounces-19621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C9715907D55
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 641BBB28665
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0790813B2AD;
	Thu, 13 Jun 2024 20:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rUXm19dS"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D5213B280
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309920; cv=none; b=K3oSltRG/lUsgUudwiWrCOdKyTkH8Dm6ZyZkIpATy9hv8qgljZqXz0nv7SY9pEWEwr5Zq8j+twxaGfigZMpmWdsmwgP7T74M6jGZbP5N+WtuxnBENNr/j0aEw8mgwhITtRqn8baim1uWSuATaCiXWn23kK6qzCqX0iGH0X6Q92s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309920; c=relaxed/simple;
	bh=q1WdDQ+HeEjaZ/yBoJf5uikztTTlsNKOeX49+T8EpzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZW2PXXZyiskN/MyGH2vhXzQjsR2bgbHtiChNjy69R19ZAQ0eUenQSQsSela5pcUucKN+euE+SbYm5Ust3l9xdOVdDPLDBi1p9O0QSLfYM8+lN3ZDfQE57s5n68VAz9aNZm89tOZt7poQHkhMzpDPuZx3Os6EwAQuwf4fSbjEKEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rUXm19dS; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uDX5yj1qdxFe0BrumYN2nImPkKHU1f5FztTUo4hmGPw=;
	b=rUXm19dSd7G1ts/yjtJdRdyLFkQa5NLcpe1m6oaanIyAIT8rWbqkF9uvuaoh6gZHEN6/tX
	qli0YtcRyr8B67JlYMVTaXh3YG2fYAdl9jrlQpxm3m+/PTuy1XhY8m7MGrOpVoyr5jUxWN
	+7xUl3jHIcrm/Yvw/d7BDWz5+Twduls=
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
Subject: [PATCH v2 04/15] KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap
Date: Thu, 13 Jun 2024 20:17:45 +0000
Message-ID: <20240613201756.3258227-5-oliver.upton@linux.dev>
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

Round out the ZCR_EL2 gymnastics by loading SVE state in the fast path
when the guest hypervisor tries to access SVE state.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++++
 arch/arm64/kvm/hyp/vhe/switch.c         | 27 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 428ee15dd6ae..5ecd2600d9df 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -345,6 +345,10 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		if (guest_hyp_fpsimd_traps_enabled(vcpu))
 			return false;
 		break;
+	case ESR_ELx_EC_SYS64:
+		if (WARN_ON_ONCE(!is_hyp_ctxt(vcpu)))
+			return false;
+		fallthrough;
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)
 			return false;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index fed36457fef9..f6e5ecd8b310 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -284,11 +284,38 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static bool kvm_hyp_handle_zcr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+
+	if (!vcpu_has_nv(vcpu))
+		return false;
+
+	if (sysreg != SYS_ZCR_EL2)
+		return false;
+
+	if (guest_owns_fp_regs())
+		return false;
+
+	/*
+	 * ZCR_EL2 traps are handled in the slow path, with the expectation
+	 * that the guest's FP context has already been loaded onto the CPU.
+	 *
+	 * Load the guest's FP context and unconditionally forward to the
+	 * slow path for handling (i.e. return false).
+	 */
+	kvm_hyp_handle_fpsimd(vcpu, exit_code);
+	return false;
+}
+
 static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (kvm_hyp_handle_cpacr_el1(vcpu, exit_code))
 		return true;
 
+	if (kvm_hyp_handle_zcr_el2(vcpu, exit_code))
+		return true;
+
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 
-- 
2.45.2.627.g7a2c4fd464-goog


