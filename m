Return-Path: <kvm+bounces-62632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4796AC4999B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:36:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DA89188CF9F
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 22:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171B234A788;
	Mon, 10 Nov 2025 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CtLichXf"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE93340D81
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 22:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762813807; cv=none; b=uP2TrQtwdiD8OiFGMjYynUdPUT7ZYuVMMOVQTyfm0mRaRyZGSUGyN6fL0LyB6/FPahLyX7TSz131DNt/7DdWr5BUBINuhydXWSoc0f1OhCHNWuK+LKpSqu7NmhJNkYr03t84g/KKZasPFvLiUt+0cOcTQO1LZu6TRvIpoEJxQfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762813807; c=relaxed/simple;
	bh=cp97R3GdqDcm5NylaZccmJl3gy9Tx4+loyUIVJzusNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7/5au0x2w0b+acqcyF9fSqNKe8PZ94qdpp9ccNjwmh0t9bIrhDZMz3gCNCkmje3wMa57z2fmUiLUj4Hc85y5hJ1kbladVLpYPFomoxAMj0olo13r+xJf+w0Auy9cjo1rP/GsyOy/yGeItLTzbzG2ojWIkN8gf5H47OTP6KDgKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CtLichXf; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762813803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LaX7+H5ws1ElWVssSHUHDq3sKJLlQwFG3aehtAQ6AmU=;
	b=CtLichXfu636fEu6ihIFPj85dXsPwIG87igdhtmaKtn4HEsdv3VJoDz8xSuOAUeWr+WUbK
	V+FIAJ9Jnp2J/ozVl8MalyTkVZFTP4v6demE4QVN9SogKudzwYvq4d3j5m5rjhHqtjnPkm
	ovAtlj52IaKooGM2el2ZgIU2cD3unXU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 13/13] KVM: nSVM: Only copy NP_ENABLE from VMCB01's misc_ctl
Date: Mon, 10 Nov 2025 22:29:22 +0000
Message-ID: <20251110222922.613224-14-yosry.ahmed@linux.dev>
In-Reply-To: <20251110222922.613224-1-yosry.ahmed@linux.dev>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
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

Opportunistically add a comment explaining why NP_ENABLE is taken from
VMCB01 and not VMCB02.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 503cb7f5a4c5f..4e278c1f9e6b3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -837,8 +837,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
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
 
-- 
2.51.2.1041.gc1ab5b90ca-goog


