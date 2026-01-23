Return-Path: <kvm+bounces-68952-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oHf0DO44c2l/tQAAu9opvQ
	(envelope-from <kvm+bounces-68952-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 10:01:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 938D872E56
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 10:01:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD4DD3059333
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 08:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D1D358D06;
	Fri, 23 Jan 2026 08:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lHiUoaIk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86269352C2D
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 08:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769158734; cv=none; b=fIvfZbqIOIf8jdRAQ1Pryii8KrYdbQxZLL2owAPDF/pbMvsK3vOWha5N3G9zKfb2trPYH+jex9BUS9eCNYzlcJDHH5SXpA99k3zqsH2fDmzSm0uPM3w5loQCwVtpM/6RsRIqpAN6J4jPgbGIfSC/r1VyRgFPsfheOGP9GGciFHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769158734; c=relaxed/simple;
	bh=H3kIgqZ1fpIQgO5dvj4uCp4+YHfpl+70b9+j6uz199k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tUVriSuzeEqJ/TV90aPhpxb0yQ+nkv0xIAyMNm9gcuTqdZbaL1fjHIYiWimQqFuQAIk9vTkuPCJvaWfFqOYhjUi9oI+vynB0MgYCyIE7KxqSXbByQGmlPtIijKdOccO7oCsNlDlR6BFg6OlezFLvqQi4QwsuPTbN2GnLUFT0YRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lHiUoaIk; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a0c09bb78cso13558125ad.0
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 00:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769158730; x=1769763530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tw87ncFPvx87YF4rRJcW420dhLX4aAoK8XINI/y7618=;
        b=lHiUoaIkHquSC2uXFusOL3zGCxZ6PzvXBOsCAirwNVY343UC3TesL1evpXOTpsi+Ch
         14/WNDhXYgek6+okFntIkcjyNgom8geIsulVkQvCczgVVnUMwHVJD7EwK/3AgzxRjjvE
         gG5BxXsjs3vduH/lCPg24WRAbOi0JM3bef8vWmq69a2A9ESIq38XXttXDqwZc2KfbXCH
         VuQzWYAs95y9vl/cXzZVytx5LrFlczG2LqeY5+nRBg12zLRiqls/dNJomViFmEYv9pnr
         6m76O66cqk97hhanjlAD5GGQ6osIvHjJvYAqXm73VKkuwelCxzI9SOSImGhz1/RixzhD
         cTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769158730; x=1769763530;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tw87ncFPvx87YF4rRJcW420dhLX4aAoK8XINI/y7618=;
        b=HAKCDvnMV9nxWUYVeaoGx/LjzLKj0qnCFDIp7O4eFwDhaTID4f5ckPnsdYfBIVr3ls
         1L/tKfLQMa3QcwdnbQeq+EfX5oJ/MkbAaagYjq3Texhp0s5JXusfQs5RqO9DL//gsbU2
         xKmJu6jxDp2ZJx1OmPiw/qzmvJMbfqr1gYWMZ7MBx8u0hfIhEJBOD0+WFxLJb2VEpVy1
         ZHgdqNweek6JCUUY7Bdg38i+6/YIWut7ahQ2B6NyxGISRXgl4ke9Xn1nPBY5mOIPxeYe
         BTAb6dxIRlr8XdZVejh2RCaW4Ivb8mE0JyrjFPuv9s3hDisDCYK0OaUiA8GzWNMGKm7j
         iaSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcbVyrnY9XytX286wphkCHDU8wQr3F0FqS+fxk1O6qT+d4FFB8ydEXtiY8XgMG3g/9yDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTLkA1QKw1fV01up86lijjebpvdvMOBU1rYx9XbmLoI1YNO2EA
	F/pTmAiO7Y9aNbecpe83a4TI7FWuvjG07mBkKv3wy6a6oB/0zb7Ebr4R
X-Gm-Gg: AZuq6aJ6zaP8E0MTspm9UkqXwXzBV7OUc4VWIOXv+EhD7dG5Wbw+gBTbhRVQ5+OX7YY
	4Si98nwHoIbXy/7h1h/niZZiH1QvfnwDZkmWDNOOUiM0jH4heAUojReX0hBN9YK4Y2JogWP0OvP
	kFYui+a3XmpPOgb1ESRiEmgP+XXgIn61rn6UuY7oU+c3+3s3ZJ5ZZtA0PfOFqSGPqTxO6GFYXW1
	ePorqRivUgItTGEx3tlzZ57IjpwSdw/6m3H3hzSRvcG38YkMzSDSoFgBAU2VZ+T1GIp3Ds/tLq+
	WDWSZRvxJ4f6bkdABopNKxMVUacurb5S8Jr+VelxXLtgqwtqc63o6l845b9zmmD/7zxQISjAWOa
	cxfF7pyojSLoBZwCTRRIpep/KJMnTZylC3VeWVwtewxs1G2aFC7REvDB/Ix86bImbQcOg9+F0eZ
	6Bv73ia4NnP1U=
X-Received: by 2002:a17:903:4b0d:b0:2a0:eaf5:5cd8 with SMTP id d9443c01a7336-2a7d2f17f93mr46191495ad.9.1769158730217;
        Fri, 23 Jan 2026 00:58:50 -0800 (PST)
Received: from localhost ([240b:4000:bb:1700:7b36:494d:5625:5a0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802dcd776sm13937155ad.26.2026.01.23.00.58.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Jan 2026 00:58:49 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86/mmu: Don't check old SPTE permissions when trying to unsync
Date: Fri, 23 Jan 2026 17:03:02 +0800
Message-Id: <20260123090304.32286-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_FROM(0.00)[bounces-68952-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiangshanlai@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[kvm];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[antgroup.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 938D872E56
X-Rspamd-Action: no action

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Commit ecc5589f19a5 ("KVM: MMU: optimize set_spte for page sync") added
a writable permission check on the old SPTE to avoid unnecessary calls
to mmu_try_to_unsync_pages() when syncing SPTEs.

Later, commit e6722d9211b2 ("KVM: x86/mmu: Reduce the update to the spte
in FNAME(sync_spte)") indirectly achieves it by avoiding some SPTE
updates altogether, which makes the writable permission check in
make_spte() much less useful.

Remove the old-SPTE writable permission check from make_spte() to
simplify the code.

This may cause mmu_try_to_unsync_pages() to be called in a few
additional cases not covered by commit e6722d9211b2, such as when the
guest toggles the execute bit, which is expected to be rare.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c         |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/spte.c        | 12 ++----------
 arch/x86/kvm/mmu/spte.h        |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c     |  2 +-
 5 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02c450686b4a..4535d2836004 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3073,7 +3073,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			was_rmapped = 1;
 	}
 
-	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
+	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, prefetch,
 			   false, host_writable, &spte);
 
 	if (*sptep == spte) {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 901cd2bd40b8..95fccee63563 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -954,7 +954,7 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	host_writable = spte & shadow_host_writable_mask;
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	make_spte(vcpu, sp, slot, pte_access, gfn,
-		  spte_to_pfn(spte), spte, true, true,
+		  spte_to_pfn(spte), true, true,
 		  host_writable, &spte);
 
 	/*
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 85a0473809b0..a8e2606ccd22 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -186,7 +186,7 @@ bool spte_needs_atomic_update(u64 spte)
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-	       u64 old_spte, bool prefetch, bool synchronizing,
+	       bool prefetch, bool synchronizing,
 	       bool host_writable, u64 *new_spte)
 {
 	int level = sp->role.level;
@@ -258,16 +258,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * SPTE.  Write-protect the SPTE if the page can't be unsync'd,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
-		 *
-		 * When overwriting an existing leaf SPTE, and the old SPTE was
-		 * writable, skip trying to unsync shadow pages as any relevant
-		 * shadow pages must already be unsync, i.e. the hash lookup is
-		 * unnecessary (and expensive).  Note, this relies on KVM not
-		 * changing PFNs without first zapping the old SPTE, which is
-		 * guaranteed by both the shadow MMU and the TDP MMU.
 		 */
-		if ((!is_last_spte(old_spte, level) || !is_writable_pte(old_spte)) &&
-		    mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, synchronizing, prefetch))
+		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, synchronizing, prefetch))
 			wrprot = true;
 		else
 			spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask |
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 91ce29fd6f1b..cf9cd27bcd4f 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -543,7 +543,7 @@ bool spte_needs_atomic_update(u64 spte);
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-	       u64 old_spte, bool prefetch, bool synchronizing,
+	       bool prefetch, bool synchronizing,
 	       bool host_writable, u64 *new_spte);
 u64 make_small_spte(struct kvm *kvm, u64 huge_spte,
 		    union kvm_mmu_page_role role, int index);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9c26038f6b77..8dfaab2a4fd9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1188,7 +1188,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
 		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-				   fault->pfn, iter->old_spte, fault->prefetch,
+				   fault->pfn, fault->prefetch,
 				   false, fault->map_writable, &new_spte);
 
 	if (new_spte == iter->old_spte)
-- 
2.19.1.6.gb485710b


