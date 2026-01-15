Return-Path: <kvm+bounces-68137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78921D21FF6
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:21:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1ABFC30C7BB8
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BEF327AC57;
	Thu, 15 Jan 2026 01:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LxWrpQ9X"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED85E2EDD78
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439655; cv=none; b=fQqziM+eCFH/AoikAot8qQgymYbK4HvhJzGWod6+/lXKTKyDXeWj26hKv95BKpD3DaC0ZoiCbhMPA4CSbsgUYWAvuSwtS9fVezaEY/xoKvnP3v/rei0/J8fhDVPqo7ZC8QZw0r+7vlg0Tl2hPpZX2y4jaV/EecNBfacPx3q2ohI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439655; c=relaxed/simple;
	bh=UVpG+EowREj/Awus5qFoFw4/iJjJS9YFFtLxBIvxXkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OROTxY7nbaUEnAY2vR0w5T9WudVkvrNHpIT9NI1vYpqwFvBSA9rORcHl6MX6WtA/C7+QOi49wnITBJBLPHYgLSsJYXo4EZy5wmnT5NfVREBUooD2t2qZy1kUGThVegmAL4TbUgAKMuUSG4QuEBPTHE0N4lgnC3jU82Mb1t7dGQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LxWrpQ9X; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ldoCItHVLee7RyUR5hi7FAn/d6Xlp6dLDsYhKHH3XQ=;
	b=LxWrpQ9XUl9FttggHFtQ2DYhNp+ZOR2KUSQotMhpunpoxMut278NYtUHMlMBc7Maf9xNBu
	QkiKLVEdSeNk3J9qeFQ8nQD+fipOski4fAW5LXRrnN+Dgj/cxt8o5GNNPB4zIFUyXbkov5
	NLzCa2MvBjtD6UmULJfN8it4iPPnzA8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v4 26/26] KVM: nSVM: Only copy NP_ENABLE from VMCB01's misc_ctl
Date: Thu, 15 Jan 2026 01:13:12 +0000
Message-ID: <20260115011312.3675857-27-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'misc_ctl' field in VMCB02 is taken as-is from VMCB01. However, the
only bit that needs to copied is NP_ENABLE, as all other known bits in
misc_ctl are related to SEV guests, and KVM doesn't support nested
virtualization for SEV guests.

Only copy NP_ENABLE to harden against future bugs if/when other bits are
set for L1 but should not be set for L2.

Opportunistically add a comment explaining why NP_ENABLE is taken from
VMCB01 and not VMCB02.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e62fd6524feb..b3a90ff262d5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -856,8 +856,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
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
2.52.0.457.g6b5491de43-goog


