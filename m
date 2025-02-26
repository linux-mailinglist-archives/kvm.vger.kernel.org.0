Return-Path: <kvm+bounces-39227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E641A456D6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 08:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F4403A46D1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 07:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3EE26BD86;
	Wed, 26 Feb 2025 07:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BaQbodRH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BaQbodRH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E427123CE
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 07:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740555701; cv=none; b=iFxRocC/SP4Tp3MBBSJnXeaJ6i1hvOwt5QiAMvrsmuexLlelNMh4xwik7759rDKGOW4u9x3smW/V1WF4OWtlcaEeiHFAWmIdcEac2pYIRJM0GBETKgA5bB0xNcMF8Iwsdz0QBiynFLakJb1XtGsLRTWmLqiY6Guq8d5ee+FHqaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740555701; c=relaxed/simple;
	bh=y6WCm9bbrDsgmWbhvGYhRKxExKN2B1RTi2Cu+Jl+O5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=raP0bWjjY204bx7EwJOoSlRYW8C84ohelDKB9RpVc/rzXuyqugy/QS9D0tmENDEOn5XwNQMS6JYkjgH6NJh1JZvEZNzj0BFwT7CpNqngfoEU/xhLENCM97m2FGTYvHEkooT1hnvpnvAMx/6dSQ3JPTvvkM9lBKJnrXKX9uwa5wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BaQbodRH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BaQbodRH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 00A2E1F387;
	Wed, 26 Feb 2025 07:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740555698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PSkRu+6VB1vPm2cvxIGSKliv3HzshW5ao+Cnd260MC4=;
	b=BaQbodRHfq3Groanji9XOVb3WNnzWRBDis4J1uO2WgpvzFH93Z7cwx23P818cWIqhbmx7E
	t4/n6OJ4Ei34VXUc+/tm0A7JFtcgMgfiRf5KdSISo3MbZwF3ICfupVFKmY1WmkvN53T/EK
	NiNq27Jv3gL2UxJeZX2oVeTRtVuISwM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=BaQbodRH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740555698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PSkRu+6VB1vPm2cvxIGSKliv3HzshW5ao+Cnd260MC4=;
	b=BaQbodRHfq3Groanji9XOVb3WNnzWRBDis4J1uO2WgpvzFH93Z7cwx23P818cWIqhbmx7E
	t4/n6OJ4Ei34VXUc+/tm0A7JFtcgMgfiRf5KdSISo3MbZwF3ICfupVFKmY1WmkvN53T/EK
	NiNq27Jv3gL2UxJeZX2oVeTRtVuISwM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6CF913A53;
	Wed, 26 Feb 2025 07:41:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m9IDJrHFvmceNwAAD6G6ig
	(envelope-from <nik.borisov@suse.com>); Wed, 26 Feb 2025 07:41:37 +0000
From: Nikolay Borisov <nik.borisov@suse.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH] KVM: x86/tdp_mmu: Remove tdp_mmu_for_each_pte()
Date: Wed, 26 Feb 2025 09:41:31 +0200
Message-ID: <20250226074131.312565-1-nik.borisov@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 00A2E1F387
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

That macro acts as a different name for for_each_tdp_pte, apart from
adding cognitive load it doesn't bring any value. Let's remove it.

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 046b6ba31197..e5ba33e8ba4a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -774,9 +774,6 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _kvm, _root, _start, _end)	\
-	for_each_tdp_pte(_iter, _kvm, _root, _start, _end)
-
 static inline bool __must_check tdp_mmu_iter_need_resched(struct kvm *kvm,
 							  struct tdp_iter *iter)
 {
@@ -1235,7 +1232,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
+	for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1904,7 +1901,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
+	for_each_tdp_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1931,7 +1928,7 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 	struct tdp_iter iter;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
+	for_each_tdp_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
-- 
2.43.0


