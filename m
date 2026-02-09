Return-Path: <kvm+bounces-70571-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gEVZLDdjiWla8AQAu9opvQ
	(envelope-from <kvm+bounces-70571-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:31:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F52310B921
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:31:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC113302B394
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 04:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D259A2D12F3;
	Mon,  9 Feb 2026 04:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="A+bQ1oOp"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135FA126F3B;
	Mon,  9 Feb 2026 04:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770611413; cv=none; b=APoM0idQQ+mnRgT47Y8H4HPJUYKMD6woPEBdlizlEDsG2K+PvVw7nVvRJEu4nd89KkQo/ViXsGp6w5bkbDfoYtPbdBeAb6uRRHMNhrMBP9fVah9wIGd4/zOwH76EWLYgC52kSxWlJ3DpaBg/4V9oVHJVXIcDsQizpOGBr9GCdOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770611413; c=relaxed/simple;
	bh=VPNs08T7JRAAD+FtB2viQACpxJDWKcCN819zahfODp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbdGKWbSYpGQ+oAErPGAM1MYSWbYU36gGhN2Vzy9PMvs18HUxKeJGgDL6tIqDkMpkcvu6oQe17YR55qx6a+Yy1y0aPd47jtzJwsmNl+3M8neJmbPB/NXMNEGsL/pybDC2kYU9QObxqlMicj9pqnVB+D2pobworf8slA6GT+2MBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=A+bQ1oOp; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=i1
	+c8F8gRCphXAzoD8IgyPUlkrVbg7Bop7xNGBSKdQ8=; b=A+bQ1oOp3GMLB+JkWh
	VSB3YXtEI9jeBuK5ntF9lMoMZPm7YXNMgvvUyokxuatOUGdzk9bBcscS1bNNlgyX
	F3MayAnJo5JQ9VadmLie9K0gJBQKSOFPPw2j80y8vl5x5nRLiKHI1sibu7i6lRk1
	pFUkuMh2MvrV4qebgDCGiLULo=
Received: from 163.com (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgD3F+yvYolpOQZEQw--.25673S5;
	Mon, 09 Feb 2026 12:29:37 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH RESEND 3/5] KVM: x86: selftests: Avoid failures due to reserved memory address regions on Hygon
Date: Mon,  9 Feb 2026 12:13:03 +0800
Message-ID: <20260209041305.64906-4-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260209041305.64906-1-zhiquan_li@163.com>
References: <20260209041305.64906-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgD3F+yvYolpOQZEQw--.25673S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFykCr1Uuw4UJF1DKr4kJFb_yoW8ZF1Dpa
	4fCw45WF48GF1ay3yxXws7ZFyvkFn7CF4xKryjy343u3W5WF13Zr4Sk3WYvrW3CrWrZw13
	Aa4fJF4Duw4jqaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UzxRDUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbC6hGBammJYrE9UgAA3M
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70571-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,163.com];
	FREEMAIL_FROM(0.00)[163.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4F52310B921
X-Rspamd-Action: no action

There are similar reserved memory address regions for Hygon
architecture, mapping memory into these regions and accessing to them
results in a #PF.

Hygon CSV also makes the "physical address space width reduction", the
reduced physical address bits are reported by bits 11:6 of
CPUID[0x8000001f].EBX as well, so the existed logic is totally
applicable for Hygon processors.

Following test failures are fixed by this change:
- access_tracking_perf_test
- demand_paging_test
- dirty_log_perf_test
- dirty_log_test
- kvm_page_table_test
- memslot_modification_stress_test
- pre_fault_memory_test
- x86/dirty_log_page_splitting_test

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
---
 tools/testing/selftests/kvm/lib/x86/processor.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 64f9ecd2387d..252b04c8e944 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1270,8 +1270,8 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 
 	max_gfn = (1ULL << (guest_maxphyaddr - vm->page_shift)) - 1;
 
-	/* Avoid reserved HyperTransport region on AMD processors.  */
-	if (!host_cpu_is_amd)
+	/* Avoid reserved HyperTransport region on AMD or Hygon processors. */
+	if (!host_cpu_is_amd && !host_cpu_is_hygon)
 		return max_gfn;
 
 	/* On parts with <40 physical address bits, the area is fully hidden */
@@ -1285,7 +1285,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 
 	/*
 	 * Otherwise it's at the top of the physical address space, possibly
-	 * reduced due to SME by bits 11:6 of CPUID[0x8000001f].EBX.  Use
+	 * reduced due to SME or CSV by bits 11:6 of CPUID[0x8000001f].EBX.  Use
 	 * the old conservative value if MAXPHYADDR is not enumerated.
 	 */
 	if (!this_cpu_has_p(X86_PROPERTY_MAX_PHY_ADDR))
-- 
2.43.0


