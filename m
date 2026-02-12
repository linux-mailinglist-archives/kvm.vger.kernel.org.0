Return-Path: <kvm+bounces-70947-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNDTOtyvjWmz5wAAu9opvQ
	(envelope-from <kvm+bounces-70947-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:47:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A7012CAC7
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 43C65305A98E
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC74E2EC09D;
	Thu, 12 Feb 2026 10:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="g5BOpCOI"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E72C1DDA24;
	Thu, 12 Feb 2026 10:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770893160; cv=none; b=QgRfAOqT8l6h88VFt64uP2pDWW5EwBIDdgpyVGecDAZiQwC3WMx9IM+GE+YzuJN6+Mq+4ifNQ9jNbrDzHYTvVIMwgQ4c3r3rlJShr9k4qFQj53SrohJkj8dxyBUPeGKN0jV44YCO8006Aj65kIh6oGrvkHxX1CLKEnMW2FtB9WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770893160; c=relaxed/simple;
	bh=Q9lBOtUg68sa9iMHgSNiQwBdqiC8tpa9sl++GN3qSZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhSbglCUu2uOqfxYfxOsE7CY6bxHdC/xQxHB8RiwEi9HaJso2vesMRFRiSPH2wsXindN5vwi6+YVSWjRfKTjC8rzUqeId0ktFvipxjzQ302VKbOT22n1kbkn+XHgEX1h2i5d3qbx8fjlgPSfvVMbkhodY4M416QIMII0723Di4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=g5BOpCOI; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=qe
	ccGjVLjUuQaSbBstJwiQOfIWq48EFo6VoO+Gt3HtY=; b=g5BOpCOIBd4ujm+v3L
	bACpaRc4XLiIdpWizPIMP45pgaMItayZldkEpD6iG3XzjnJ04WTtuiRftr7BWZMK
	yoRqefmKMad48OXCC6niAAiYBrr+24xej+NOxwcprMNKq34fl84Rkja9Jqx/JOrt
	EzXktG0bNSJgKBomI1Nnux+dE=
Received: from 163.com (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wA38f4Tr41pL2eqLA--.10527S6;
	Thu, 12 Feb 2026 18:44:43 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com,
	stable@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: selftests: Fix reserved value WRMSR testcase for multi-feature MSRs
Date: Thu, 12 Feb 2026 18:38:41 +0800
Message-ID: <20260212103841.171459-5-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260212103841.171459-1-zhiquan_li@163.com>
References: <20260212103841.171459-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA38f4Tr41pL2eqLA--.10527S6
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw1ktFW8WF48KrWfXryrZwb_yoW8Ar1kpa
	n3Jr40kr93Ka4fAayxGF4xXF18ZFnrWr40gF1Fy3srZF15Ja4xZw1xKay5Aas3urWSq3y3
	Zas2gw1j9a1DJaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEqg4hUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwhuvmGmNrxvmkQAA3J
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,163.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-70947-lists,kvm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_FROM(0.00)[163.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 19A7012CAC7
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

When determining whether or not a WRMSR with reserved bits will #GP or
succeed due to the WRMSR not existing per the guest virtual CPU model,
expect failure if and only if _all_ features associated with the MSR are
unsupported.  Checking only the primary feature results in false failures
when running on AMD and Hygon CPUs with only one of RDPID or RDTSCP, as
AMD/Hygon CPUs ignore MSR_TSC_AUX[63:32], i.e. don't treat the bits as
reserved, and so #GP only if the MSR is unsupported.

Fixes: 9c38ddb3df94 ("KVM: selftests: Add an MSR test to exercise guest/host and read/write")
Reported-by: Zhiquan Li <zhiquan_li@163.com>
Closes: https://lore.kernel.org/all/20260209041305.64906-6-zhiquan_li@163.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/msrs_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 4c97444fdefe..f7e39bf887ad 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -175,7 +175,7 @@ void guest_test_reserved_val(const struct kvm_msr *msr)
 	 * If the CPU will truncate the written value (e.g. SYSENTER on AMD),
 	 * expect success and a truncated value, not #GP.
 	 */
-	if (!this_cpu_has(msr->feature) ||
+	if ((!this_cpu_has(msr->feature) && !this_cpu_has(msr->feature2)) ||
 	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
 		u8 vec = wrmsr_safe(msr->index, msr->rsvd_val);
 
-- 
2.43.0


