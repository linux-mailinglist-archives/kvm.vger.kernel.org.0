Return-Path: <kvm+bounces-71020-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMzFDoBdjmmdBwEAu9opvQ
	(envelope-from <kvm+bounces-71020-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:08:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 97DE4131A5F
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DEFA53078628
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783D5331215;
	Thu, 12 Feb 2026 23:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c2BziKKm"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE7E33373B;
	Thu, 12 Feb 2026 23:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770937702; cv=none; b=cvqBzpKNLJ/VdKaiHCz6ZDowdMETxVDBdGrU9/TNautmiL8tyHKSdRgscbuwkDbI5ldY2CTDTXV25lvdGIfcfb0yQjK1zoXD0/cJG/WzUFpLGqiSlEA15IuNpI2uholMH9PCvod5tHgcxH1HH7EQjy+aFhELY5LYGrCOzNv0BRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770937702; c=relaxed/simple;
	bh=F2rq/QYq+VDgmercyp1Pz8SbSpv4Yd+LzIuEDP+JTEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d906xN+mG4v8rB+wE9Ffg3/EHRxIZixmQJfr9EbUOF09QBduRRZJlQjUiflhM6ukccRYBWjVCU49CtGhCaAESgCdCPv/0EB82j3EeVNV5oMjL8sToWi60wAQPJQMw0z8xVq5LmOtsmE8RMa2XoAN2VmbAXL+WPxOXeeW14gbCPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c2BziKKm; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770937699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gIvqwA3oUv5Iv4Tz3qmaczAU3wfiUNio/9aouuNfKhc=;
	b=c2BziKKm8dLsguRqFovZXpe/oi8jixDo85HEHP56AVVx1fOdO8Dp5jP7sNoGuEmpFFxV/I
	vokRQ0g9ZqAt5RBkiX/gWL7S8fdI9v1exdgLVgJYDnCru309Y8xopw/cZCuYSirNzThDcf
	npy1BMCz9KLiVN2yNmTkFQp3iUMaDpw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [RFC PATCH 2/5] KVM: nSVM: Use the correct RIP when restoring vmcb02's control area
Date: Thu, 12 Feb 2026 23:07:48 +0000
Message-ID: <20260212230751.1871720-3-yosry.ahmed@linux.dev>
In-Reply-To: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
References: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71020-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,linux.dev:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 97DE4131A5F
X-Rspamd-Action: no action

In svm_set_nested_state(), the value of RIP from vmcb02 is passed into
nested_vmcb02_prepare_control(). However, even if RIP is restored with
KVM_SET_REGS prior to KVM_SET_NESTED_STATE, its value is not reflected
into the VMCB until the vCPU is run.

Use the value from KVM's cache instead, which is what KVM_SET_REGS
updates. Not that the passed RIP is still incorrect if KVM_SET_REGS is
not called prior to KVM_SET_NESTED_STATE, this will be fixed separately.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index eebbe00714e3..aec17c80ed73 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1911,7 +1911,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
+	nested_vmcb02_prepare_control(svm, kvm_rip_read(vcpu), svm->vmcb->save.cs.base);
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
-- 
2.53.0.273.g2a3d683680-goog


