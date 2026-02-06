Return-Path: <kvm+bounces-70504-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPQfO5g+hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70504-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:18:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEAD1029B3
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 680DC3071C4F
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A5C449EC0;
	Fri,  6 Feb 2026 19:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="taJ4FaJn"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439354418E1
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404994; cv=none; b=ZG7Qom6EdkCyXzF2428jxv1T+XZPjE5iA2gASUFnhIpw6Fw6U4eiuKCpurF58qQOTwXVA1V6bdWyk2nuRJSmC9XZxEhXcJNXWkX8LoILNHH2shF/id9jHXqf9CNG10VXhcWceeJXEMJTtbvXGHZZ7eUjxlTsaEy5H1t4mPGCpj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404994; c=relaxed/simple;
	bh=YTcYKED/wvqngcm2f7lwHOcbYRZ3YkO3jVQI2neMGIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2+2nB7jBksTuEz0W0wra4hcLA5rhpyXZ/3OhN9SlQ2wAl53wwgwuHaXM9gn7GWATF8Phs1dl2CKpICchs+RtiRTFmCtS9eFZa/DU+yOoNReQwltdO0hWscReHfNvmVVoBkk4scS2kA2JuxuwMHOcCrCyN3eAW7DHlqpr508AS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=taJ4FaJn; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RK+d5ocqMQ7flxrKcmagDp5JVPOYd8dDWt+aOfINdHE=;
	b=taJ4FaJnhsdTtXwbeP7oPgjSfct0q4xMkHmi/QyP/1oYksNQ3BMdCEvUNgEFab1HgwEjrs
	9IWaHHFORX47aM4TXl+sgWJD9NYH7VQ0T0KPu4MY/ShhWC7XzRJqMYBtwiSoFl49ybZEZx
	qs7kfAH2Rxaw5rg2OcLltsSfYEmLYmg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v5 26/26] KVM: nSVM: Only copy SVM_MISC_ENABLE_NP from VMCB01's misc_ctl
Date: Fri,  6 Feb 2026 19:08:51 +0000
Message-ID: <20260206190851.860662-27-yosry.ahmed@linux.dev>
In-Reply-To: <20260206190851.860662-1-yosry.ahmed@linux.dev>
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70504-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 7FEAD1029B3
X-Rspamd-Action: no action

The 'misc_ctl' field in VMCB02 is taken as-is from VMCB01. However, the
only bit that needs to copied is SVM_MISC_ENABLE_NP, as all other known
bits in misc_ctl are related to SEV guests, and KVM doesn't support
nested virtualization for SEV guests.

Only copy SVM_MISC_ENABLE_NP to harden against future bugs if/when other
bits are set for L1 but should not be set for L2.

Opportunistically add a comment explaining why SVM_MISC_ENABLE_NP is
taken from VMCB01 and not VMCB02.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c87738962970..d80b1bde6630 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -852,8 +852,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 						V_NMI_BLOCKING_MASK);
 	}
 
-	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
+	/*
+	 * Copied from vmcb01.  msrpm_base can be overwritten later.
+	 *
+	 * SVM_MISC_ENABLE_NP in vmcb12 is only used for consistency checks.  If
+	 * L1 enables NPTs, KVM shadows L1's NPTs and uses those to run L2. If
+	 * L1 disables NPT, KVM runs L2 with the same NPTs used to run L1. For
+	 * the latter, L1 runs L2 with shadow page tables that translate L2 GVAs
+	 * to L1 GPAs, so the same NPTs can be used for L1 and L2.
+	 */
+	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl & SVM_MISC_ENABLE_NP;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


