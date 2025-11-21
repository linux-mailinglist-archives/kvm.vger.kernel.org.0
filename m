Return-Path: <kvm+bounces-64249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7BBC7BACC
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 21:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E900355950
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C096730171C;
	Fri, 21 Nov 2025 20:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wSqyYPRo"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3443272E6E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 20:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763758112; cv=none; b=A5xKMP0Q996q2QesnKrVYu+EwLG8tDoqpM4j+6+b4P79yPTqlIYEREPMajMx7iwrOxHNNNiBGiz/HbcI7wZXzM/syOnFjEBIcPUF1LwfMJ0c0WV5F9RRxiaOvjCZYerdJ1LltADFBLDWlGdQcskGC0RUHkOpEItSETaTT/V+wXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763758112; c=relaxed/simple;
	bh=hpyXCaLd7ew/dcqvDFl4C3niWWixFynCHD8DMr1j4Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWGRNgp7RJ+lvwSx2b1eOXXWKRjpuLn6+7kzX6wEfQIoDidlncWR5pq3gaH7TiAapvDWJ9i0PauPMk5LANqiZQnTgdIqRkfbtGy2iu2MVLJKjmitF0OMfbVNV58idgI/ihnQI5N6vd5io8uX3yGLdGRUhFpaBUEX8mnnUvGaxSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wSqyYPRo; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763758108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2BYEOKG5IPmbsqL2nPCG6aN8j59rRcYF/PmqlgakoQc=;
	b=wSqyYPRoWggxPTvnvUqepo9+zsJHVUpK3CsYmxnFBn8WSB2RUYwFJKUkCkpKcy8N5nKL0Z
	+laumH67fdbrvgch2yhFaNGDOG5Aa1Mv6cpk83GDOtIBChW196HqAZro1BVurZSVwieDfC
	CaQTKJ6slkSg4hLpQ72+07fJeTBM8/E=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 1/4] KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF when SVME==0
Date: Fri, 21 Nov 2025 20:48:00 +0000
Message-ID: <20251121204803.991707-2-yosry.ahmed@linux.dev>
In-Reply-To: <20251121204803.991707-1-yosry.ahmed@linux.dev>
References: <20251121204803.991707-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jim Mattson <jmattson@google.com>

GIF==0 together with EFER.SVME==0 is a valid architectural
state. Don't return -EINVAL for KVM_SET_NESTED_STATE when this
combination is specified.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c81005b24522..3e4bd8d69788 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1784,8 +1784,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
 	 */
 	if (!(vcpu->arch.efer & EFER_SVME)) {
-		/* GIF=1 and no guest mode are required if SVME=0.  */
-		if (kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
+		/* GUEST_MODE must be clear when SVME==0 */
+		if (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)
 			return -EINVAL;
 	}
 
-- 
2.52.0.rc2.455.g230fcf2819-goog


