Return-Path: <kvm+bounces-42047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92DFFA71F3E
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C12D23B2464
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6372B2571A7;
	Wed, 26 Mar 2025 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d2GglPSU"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBB2254877
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017811; cv=none; b=gJ1vxeHlcK23tiH8MPhbuQIfNhF7VjhD6L8vQNmKkThNNOt46cUNk8doKFBUKsRW9XrlWDZM9qHdkJ6vnFPxblRaVxLFGMmgDUSxMxmbBzwB+YjT+wIrj2iiYvSMPGrqvqLrHNdOlc6HhW3Z8EUYCOCiOEiV3Dq350nvF7m2d6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017811; c=relaxed/simple;
	bh=Y3WC08VrFeQ6uZxgpeN9aH9vd44wF5SWwwD8c/inpF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhCzAzxwh1A2ygAwJDoOy7DyhrVr/VLutEwqd2/EP1q3QK0KvswTtZrkBTRCFAwKQ1pPMnPVyY3Gk4+OGAnyOKagQF9+qhnQk72X/rFrZkm7G0a3ww/i5bo2oh/Z0jYVheFg9QuAn0N+ny+gS/8F4MTs1y+exj4HqEzQGKv3iO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d2GglPSU; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t9U12yU8jdrFWfkjJqfi3B46tgq2yYstaYaMmp9H+sE=;
	b=d2GglPSUUVe0SHojI4/Afc3Lwr8oiBqObpyOGO7cdQ7Sq+QniPiAlIFI8wmaFQXLV0goif
	RfGgtAkIMB7CovKhQC6BuXcDzUgNtKRPg6V9/PoXpsiE4AyF+ZFH+CbgjkXL3nJ9QcxuaK
	gaYimjjLDRzfFuqxVOZHQ4q66RTFvZg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 02/24] KVM: SVM: Use cached local variable in init_vmcb()
Date: Wed, 26 Mar 2025 19:35:57 +0000
Message-ID: <20250326193619.3714986-3-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

svm->vmcb->control is already cached in the 'control' local variable, so
use that.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8abeab91d329d..28a6d2c0f250f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1367,12 +1367,12 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		avic_init_vmcb(svm, vmcb);
 
 	if (vnmi)
-		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
+		control->int_ctl |= V_NMI_ENABLE_MASK;
 
 	if (vgif) {
 		svm_clr_intercept(svm, INTERCEPT_STGI);
 		svm_clr_intercept(svm, INTERCEPT_CLGI);
-		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
+		control->int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
 	if (sev_guest(vcpu->kvm))
-- 
2.49.0.395.g12beb8f557-goog


