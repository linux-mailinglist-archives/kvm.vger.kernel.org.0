Return-Path: <kvm+bounces-73270-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cIUnLmaHrmnKFgIAu9opvQ
	(envelope-from <kvm+bounces-73270-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:40:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 586C4235937
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 771A03031CE9
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 08:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B4A3016E0;
	Mon,  9 Mar 2026 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NeCF/CZL"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D71125B1CB;
	Mon,  9 Mar 2026 08:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773045541; cv=none; b=d9cTKnN1Jh/ISKkTluY0EZQko9lIXNBt7DEmtceShPJ6CssArqTS729zj3XwHQ9hBOjHtprorMauhjZOxU4wAZhyCKW4PxP3RCJX5MRd1oJsfhOxCYe/toQrzkxv37YDMiVBO5fsZ9xUYEBtArG/z7OIlxKv2oHZKoo7z3AMg1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773045541; c=relaxed/simple;
	bh=TQTLifyu2zqwbCWFiY8ibGwTvmt/pIaW9LTL1XUPaSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G3uRk0/2oCioeBi3hiRPp1xAwSf/rSVaenrtqp9GXBdC43oM7tPSzyiNc7rw+DxbBqiPROFK2NCyN8t/x/VxLH4mpgTcEkFYnh97mFJxAmJvP67+VyLaCurTfL34ap4n2YKGg65xXhZ6r20D1tkKngnPVlNqMS8LhNWYZvRZF/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NeCF/CZL; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ka
	wnl0rjcaGCiqPX+Qe1/SCSsRQ7d3Y4Fu+4GKNQY+U=; b=NeCF/CZLd4/kUi1bjZ
	Zyr5pJKSaeJbCSL35nxd9rJ7VU1zhZUusmB1A1ErfCpNOGDxV4x9n88DMBYGyOsK
	cHOhbEVi/1JcOTGtNBFSwEYBCynt/W2u4fQTnQTmcp0aL9TcfuS8ZtqcMZgcxar4
	TXHuh8CUZqPaqZxPUXRa4wiUs=
Received: from a317-tower2.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wC3HXIUh65pPnIkRQ--.28712S2;
	Mon, 09 Mar 2026 16:38:45 +0800 (CST)
From: pcjer <pcj3195161583@163.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/tdp_mmu: Fix base gfn check when zapping private huge SPTE
Date: Mon,  9 Mar 2026 16:38:44 +0800
Message-ID: <20260309083844.217215-1-pcj3195161583@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3HXIUh65pPnIkRQ--.28712S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFyDtr13JrW7Aw48Aw13urg_yoW3WFb_Z3
	W7K3yxGrW5JF18Xa1Ikws0yrW3Cwn7ur4ruFs5tryjy3WDtFs0yw4Ik3WDA3y8JrZ8WFZ8
	CFZxCFWfGr42kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8fsqJUUUUU==
X-CM-SenderInfo: 5sfmjiqzvrliqvytqiywtou0bp/xtbC8hXss2muhxWDgwAA3t
X-Rspamd-Queue-Id: 586C4235937
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
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-73270-lists,kvm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pcj3195161583@163.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.970];
	FREEMAIL_FROM(0.00)[163.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Signed-off-by: pcjer <pcj3195161583@163.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1266d5452..8482a85d6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1025,8 +1025,8 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 			slot = gfn_to_memslot(kvm, gfn);
 			if (kvm_hugepage_test_mixed(slot, gfn, iter.level) ||
-			    (gfn & mask) < start ||
-			    end < (gfn & mask) + KVM_PAGES_PER_HPAGE(iter.level)) {
+			    (gfn & ~mask) < start ||
+			    end < (gfn & ~mask) + KVM_PAGES_PER_HPAGE(iter.level)) {
 				WARN_ON_ONCE(!can_yield);
 				if (split_sp) {
 					sp = split_sp;
-- 
2.43.0


