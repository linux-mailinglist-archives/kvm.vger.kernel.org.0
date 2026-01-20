Return-Path: <kvm+bounces-68664-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kNLXKcwXcGkEVwAAu9opvQ
	(envelope-from <kvm+bounces-68664-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:03:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 346124E429
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 28CE09A0CF8
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7803E42188B;
	Tue, 20 Jan 2026 23:54:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from h7.fbrelay.privateemail.com (h7.fbrelay.privateemail.com [162.0.218.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F124413248;
	Tue, 20 Jan 2026 23:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.0.218.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768953277; cv=none; b=qf7DYYnvDrFnCajoAD/5H6ylMaz8SBDpFm+9PgkfVNLTGltRaQW34ZVZ2b5F/OALYUQCdx7LDr3KwqYDnGJ+DwjjJrg4rWoEb6jKmnfgCLSUGpiNAx/0tfsnvbEOcwrbSXY6Sd4hCsEF6bNXKRcVXQEqrw5NQYuaNKYGWLaxGSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768953277; c=relaxed/simple;
	bh=m0bqG1Uh+7GuYrIkTf7Q82+/GEWFCzT1VWr5lMZX2oM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CVSMeZWQpGLrIKaTB48I+plBIuzuBWLO7MtjMJHaygcK9UHXQaoM5DYCYeqGjdSczM9MvyMhEGbv6mOEhcKkvMMDaXO+dCOM1ReG3J7XGHs5umBVLdicO7Iva9EzMQPNph8iX9ixog53RPzXQZgsAljU7ecyA6GnVyWDn6+d2fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=effective-light.com; spf=pass smtp.mailfrom=effective-light.com; arc=none smtp.client-ip=162.0.218.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=effective-light.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=effective-light.com
Received: from MTA-14-3.privateemail.com (mta-14-1.privateemail.com [198.54.122.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by h7.fbrelay.privateemail.com (Postfix) with ESMTPSA id 4dwkQ85wSGz2xDR;
	Tue, 20 Jan 2026 18:42:24 -0500 (EST)
Received: from mta-14.privateemail.com (localhost [127.0.0.1])
	by mta-14.privateemail.com (Postfix) with ESMTP id 4dwkQ04TZBz3hhTQ;
	Tue, 20 Jan 2026 18:42:16 -0500 (EST)
Received: from localhost.localdomain (bras-base-toroon4332w-grc-44-142-112-152-160.dsl.bell.ca [142.112.152.160])
	by mta-14.privateemail.com (Postfix) with ESMTPA;
	Tue, 20 Jan 2026 18:42:03 -0500 (EST)
From: Hamza Mahfooz <someguy@effective-light.com>
To: kvm@vger.kernel.org
Cc: Hamza Mahfooz <someguy@effective-light.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: move reused pages to the top of active_mmu_pages
Date: Tue, 20 Jan 2026 18:41:15 -0500
Message-ID: <20260120234115.546590-1-someguy@effective-light.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spamd-Result: default: False [0.24 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68664-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[effective-light.com];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[someguy@effective-light.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	R_DKIM_NA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 346124E429
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Move reused shadow pages to the head of active_mmu_pages in
__kvm_mmu_get_shadow_page(). This will allow us to move towards more of
a LRU approximation eviction strategy instead of just straight FIFO.

Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02c450686b4a..2fe04e01863d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2395,7 +2395,8 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 	if (!sp) {
 		created = true;
 		sp = kvm_mmu_alloc_shadow_page(kvm, caches, gfn, sp_list, role);
-	}
+	} else if (!list_is_head(&sp->link, &kvm->arch.active_mmu_pages))
+		list_move(&sp->link, &kvm->arch.active_mmu_pages);
 
 	trace_kvm_mmu_get_page(sp, created);
 	return sp;
-- 
2.52.0


