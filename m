Return-Path: <kvm+bounces-62029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D8CC32E00
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 21:05:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D94C3422607
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 20:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0C5304BB7;
	Tue,  4 Nov 2025 20:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a/CRIOIF"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7833D302768
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 20:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286429; cv=none; b=WAtWVSvyYkyoWey5yeayZt5EvTIPzVdh0AMzO9g4oBLkgZrfzwkrBDL5E9FDE+3pL5k0bc8FyKX7xunbgbN55sE8xA0VN/uUse545JvSg9BmkUDr0cldtPz3CajBLzmUnlK7FC2xcewckNbxA8bb0zRwDMMobVsZKOeBHdI5iIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286429; c=relaxed/simple;
	bh=EcgIhoJJP/s77cHSglnPoKdccWLA4uvOMrJzEbgg9sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBnDDS3BA0nIp6ErfzX5vo32vkxK7jGvMRmZz5tvQEabv/UVuPQ7U5i2RIFIsIUxyD9mAfuJicqTK/7TvTTEwm3gWSyeb9jYlAtzy+FLotZor0F9e3zL64rd1sBOTLvM3scw/OSBFWbcFqmRH07NJIhu3YxRfHP4HBh5aHtIpl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a/CRIOIF; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762286424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WjJ9YRNXaKKMg1wAlHxjNe5KXoC9eITnLkE0v1TW1y8=;
	b=a/CRIOIFznMb2Bs0qFJvKNoImNa97DniwO8CpeBBfDJM1XM2sAlS4awJ/WCUdJZzpaqGdB
	rav9nd+z9XPvq/5aUFU+n4grq6MwzZC3bHfKBpZtQhTEpj7YDpuP17cjEDpS8AS2GROpeL
	z8ZfTfTTHPevkDfFyIivso36GPMvsHQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 11/11] KVM: nSVM: Only copy NP_ENABLE from VMCB01's nested_ctl
Date: Tue,  4 Nov 2025 19:59:49 +0000
Message-ID: <20251104195949.3528411-12-yosry.ahmed@linux.dev>
In-Reply-To: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'misc_ctl' field in VMCB02 is taken as-is from VMCB01. However, the
only bit that needs to copied is NP_ENABLE. This is a nop now because
other bits are for SEV guests, which do not support nested.
Nonetheless, this hardens against future bugs if/when other bits are
set for L1 but should not be set for L2.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a223887e5b78d..81d8b10e26cdf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -821,8 +821,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 						V_NMI_BLOCKING_MASK);
 	}
 
-	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
+	/*
+	 * Copied from vmcb01.  msrpm_base can be overwritten later.
+	 *
+	 * NP_ENABLE in vmcb12 is only used for consistency checks.  If L1
+	 * enables NPTs, KVM shadows L1's NPTs and uses those to run L2. If L1
+	 * disables NPT, KVM runs L2 with the same NPTs used to run L1. For the
+	 * latter, L1 runs L2 with shadow page tables that translate L2 GVAs to
+	 * L1 GPAs, so the same NPTs can be used for L1 and L2.
+	 */
+	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl & SVM_MISC_CTL_NP_ENABLE;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
-- 
2.51.2.1026.g39e6a42477-goog


