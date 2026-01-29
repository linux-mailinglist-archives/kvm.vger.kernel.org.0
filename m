Return-Path: <kvm+bounces-69501-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6OpqHDPOemnU+gEAu9opvQ
	(envelope-from <kvm+bounces-69501-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 04:04:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC98AB4F9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 04:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D5B830166C3
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 03:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5251E3590B9;
	Thu, 29 Jan 2026 03:03:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from h5.fbrelay.privateemail.com (h5.fbrelay.privateemail.com [162.0.218.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6E43542DE;
	Thu, 29 Jan 2026 03:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.0.218.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769655820; cv=none; b=ETlfbDKdfwsAw2yacnVgevQTOYzRVeHNfr3nAivsban4AYm5qQotCt6RbvdMu9cEI+jQrAo6EmbN0z/BoU7FY9ufYiMnj0DnRM3tbeAQE2oqBvndFBMhkpIX1FzJq+7Gm3CAh5E+TFsouJQ+EYYeqz62qbIjaIoTFU5pKi7VpLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769655820; c=relaxed/simple;
	bh=h+dB0U1OleH55tNzlsA0BERJiankGfEB1HgGpF6pCmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lMMMKxrCwyMq+ba5m1u5AStrkQPQKk+r21tgKIHmQpaWDNj89v+i7m/ZqEMQJI1jH4WT8RunISHiWsn2Se0fnrB6EA2g6SjegQx5FjMaCF0TH9XVwHDcMbIJ6ZvFOJQbWXiTGrXtngnYrGp1jYrBW+qgBflWEu/YUDR/fcnvN8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=effective-light.com; spf=pass smtp.mailfrom=effective-light.com; arc=none smtp.client-ip=162.0.218.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=effective-light.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=effective-light.com
Received: from MTA-11-3.privateemail.com (mta-11.privateemail.com [198.54.118.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by h5.fbrelay.privateemail.com (Postfix) with ESMTPSA id 4f1kVN6TJyz2xMm;
	Thu, 29 Jan 2026 03:03:24 +0000 (UTC)
Received: from mta-11.privateemail.com (localhost [127.0.0.1])
	by mta-11.privateemail.com (Postfix) with ESMTP id 4f1kVF1nJDz3hhWs;
	Wed, 28 Jan 2026 22:03:17 -0500 (EST)
Received: from localhost.localdomain (tor01.telenet.unc.edu [204.85.191.9])
	by mta-11.privateemail.com (Postfix) with ESMTPA;
	Wed, 28 Jan 2026 22:03:02 -0500 (EST)
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
Subject: [PATCH v2] KVM: x86/mmu: move reused pages to the top of active_mmu_pages
Date: Wed, 28 Jan 2026 22:02:30 -0500
Message-ID: <20260129030231.567759-1-someguy@effective-light.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_FROM(0.00)[bounces-69501-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[effective-light.com];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[someguy@effective-light.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.988];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CCC98AB4F9
X-Rspamd-Action: no action

Move reused shadow pages to the head of active_mmu_pages in
kvm_mmu_find_shadow_page(). This will allow us to move towards more of
a LRU approximation eviction strategy instead of just straight FIFO.

Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
---
v2: move logic to kvm_mmu_find_shadow_page().
---
 arch/x86/kvm/mmu/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02c450686b4a..d89099ba1fca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2325,6 +2325,9 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 out:
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
+	if (sp && !list_is_head(&sp->link, &kvm->arch.active_mmu_pages))
+		list_move(&sp->link, &kvm->arch.active_mmu_pages);
+
 	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
 		kvm->stat.max_mmu_page_hash_collisions = collisions;
 	return sp;
-- 
2.52.0


