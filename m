Return-Path: <kvm+bounces-67964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1CED1AA03
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7CEFF307A566
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFEE6350D5D;
	Tue, 13 Jan 2026 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tEyHO7vV"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591B2350D50
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768325320; cv=none; b=e6mGBcv7L2Bpusj2XXVw3Qxmwyu9a+bu5CX38H+Nc3ZM9JaOxVgpxvwBZssWT9PWbBHpBU484sMeuu1TkcTEHiQvpf71Jp6mZIwfmbTfu1nxNrT/sxTyK9FuHYjww9kXKhHI0GOuxLYgFd1UvBHxOw6E6oDT7VL67V2R7YIAh9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768325320; c=relaxed/simple;
	bh=Meer6c/+X91D0YLd3GkyH0qSgLCdVWodXhHDmNNWOz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kqKzWK7A3qrfktrx7NrtLT83yX3qVAD1fIBwjCNPbenkNF2hWf6eEfkClrZ640mwvcADnrlFonKVhBMPfKZ5Rd5offqICpAVXfH1qIkUCg9ACJSzemcyAx0gML+XdN6RWO2Ku4hZtqakYY5FY5MunnJiFs4e0FwA+QEKuUv6Apk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tEyHO7vV; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768325306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Rq1GG13WEjuhbrUN4QhlIVzArVbIZqAs8DmSHZ1p7AE=;
	b=tEyHO7vVhD3Kroo5udCD8vXTcxif0X2zs6I+L6NXrXYLrahB9e3qdWNfjHs5TRR2jANoAb
	/9LKSNgp4Ko+DkjiFueJh0XHwYOj/h7cMdAW4l3wCVYLbgpxodh4iAiO5bMj4dVPfX1vxD
	nuAGJVYFhpv4d+WS4vStBpI5/Xr87aw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH] KVM: nSVM: Drop redundant/wrong comment in nested_vmcb02_prepare_save()
Date: Tue, 13 Jan 2026 17:28:07 +0000
Message-ID: <20260113172807.2178526-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The comment above DR6 and DR7 initializations is redundant, because the
entire function follows the same pattern of only initializing the fields
in vmcb02 if the vmcb12 changed or the fields are dirty, which handles
the first execution case.

Also, the comment refers to new_vmcb12 as new_vmcs12. Just drop the
comment.

No functional change intended.

Change-Id: Ib924765541fe3d8753b84b7ead8b47d8a24f0c8d
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f295a41ec659..cb00829896cc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -699,7 +699,6 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	vmcb02->save.rsp = vmcb12->save.rsp;
 	vmcb02->save.rip = vmcb12->save.rip;
 
-	/* These bits will be set properly on the first execution when new_vmc12 is true */
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
 		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
 		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;

base-commit: f62b64b970570c92fe22503b0cdc65be7ce7fc7c
-- 
2.52.0.457.g6b5491de43-goog


