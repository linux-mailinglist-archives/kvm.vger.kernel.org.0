Return-Path: <kvm+bounces-69452-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MFulAcu0emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69452-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:15:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70FF4AA8CE
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 84C55301D329
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394571FBEB0;
	Thu, 29 Jan 2026 01:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EPJgd6rI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C4531AAA7
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649334; cv=none; b=sKLf45YCb24+01PsE+Q7+ysKsN1i0ir3BN+0QqwLjNlp94AQf/EVLrdwgZcOnrJrqRNef0RkTiENTntlK041DsmqEKwblBqRw3FG8Uf4xBxWhV/oVrPBtge+UJSB+w3OTmERUk4o7puFFTP53p/8ZMg6lLmLEZID5+ocLcVaqUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649334; c=relaxed/simple;
	bh=512/K9zz3Etgfo/Gtt/+uJuzjMDLWxSOVrO3dn//dXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fhlogGomcbGBAc8Y4Ya0YK4d+EW6w0eLN6SRtvDGaxaEf6Lov7T7CqwCyl+6xvz/aBi4vcGpXH0bDUe8I7xUeAB4eknxj6p4xXsMxl5Ihe1+Br6BraDDKsmCIcySWhnf7LlVE8x5GFrATkVHAeTjsh/vvgRtLrdqc54GXDcgc5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EPJgd6rI; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so239862a12.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649332; x=1770254132; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oJpdJVSHcQzV+/GX2rfzmObrBzUwVa1amlSsrvCn9LM=;
        b=EPJgd6rIwyNYD60F7j17l/C3mVc+WGLFxgc6FobNlrstijQjoF78m82Yr000xztpJK
         Qdz5t2o3WiTCxjXqiX6iIonY+xre/Q8/bO54R5akn4wvl7Edv5Md8Lu+7PxM86WRmaNy
         C/hxCQTHkXQplMMiLk2iRixbfRSd5kihsKxRMHHNt7poI5vb/BVSrTWjtuwThx43oGcT
         Ic8G/i1BgXyyvxe2Mphy5ssRp1dowgzlPZSbT+RwW9jDG/tI1rOfjgumoLfVu8pqRb+H
         KBcmf/xuYmYnfHQhIcn8ElXx8D6btiMvaUIQ1wRdoMOwEKWNn96iI+q9ZP79Tx6xiHVa
         o1vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649332; x=1770254132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJpdJVSHcQzV+/GX2rfzmObrBzUwVa1amlSsrvCn9LM=;
        b=LnJDWBwMcWRnOJBFK/L7cqaYfvih4wXHLosCbQwr5rcxipeeS0o2guF0h/JaxzV6O4
         gK75qFEGoqRjhRqBZyg3zyqnVnOe2chYeo1rC1kTbHc2pE1BGakwMTbSwFRLUnidXOqu
         BYZ4Q3xvhHnBzC613/wXOYYeHVlqxb5ydLi7jEwzF0mf9Yk//DvCy9DugQ6E+Gz4cfyz
         R+Yq45FkeWRonA4PCfl6XcWrk8yWCTeNZXWJ2ZxUuL57YP0dQTYGDXtMTRCVM6+aHUjC
         FMa+4MIeqaODDcgMDowEZVO2NFvFP4tGFTQKy1xTx8P8vl4bjg1/EKy4tBvkyqHr4c5T
         4viw==
X-Forwarded-Encrypted: i=1; AJvYcCVX4d3QejgS+6+ynyeqao9ypU2bjc1N+6F8AEBa2TOp2Qjdt81DG6BhEp64KB3tETe40xw=@vger.kernel.org
X-Gm-Message-State: AOJu0YymFKIzGZxN4IOzHp6A4BqkE9d5LtcqnDPqaE/WALyk9q+8/9G+
	tnPJ1OO2V4qWmQIvhveoBRWl812rmwkOukH8N4bl3Mf6aDuhWLO/IzgJIwDL1P6YUK9fahK82gy
	vNKOglQ==
X-Received: from pgbdk12.prod.google.com ([2002:a05:6a02:c8c:b0:c63:3c6b:9ab6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a6:b0:366:1de8:62dc
 with SMTP id adf61e73a8af0-38ec627bccbmr6327229637.8.1769649331636; Wed, 28
 Jan 2026 17:15:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:34 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-3-seanjc@google.com>
Subject: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if cmpxchg64
 on mirror SPTE "fails"
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69452-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 70FF4AA8CE
X-Rspamd-Action: no action

Pass a pointer to iter->old_spte, not simply its value, when setting an
external SPTE in __tdp_mmu_set_spte_atomic(), so that the iterator's value
will be updated if the cmpxchg64 to freeze the mirror SPTE fails.  The bug
is currently benign as TDX is mutualy exclusive with all paths that do
"local" retry", e.g. clear_dirty_gfn_range() and wrprot_gfn_range().

Fixes: 77ac7079e66d ("KVM: x86/tdp_mmu: Propagate building mirror page tables")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9c26038f6b77..0feda295859a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -509,10 +509,10 @@ static void *get_external_spt(gfn_t gfn, u64 new_spte, int level)
 }
 
 static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
-						 gfn_t gfn, u64 old_spte,
+						 gfn_t gfn, u64 *old_spte,
 						 u64 new_spte, int level)
 {
-	bool was_present = is_shadow_present_pte(old_spte);
+	bool was_present = is_shadow_present_pte(*old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	int ret = 0;
@@ -525,7 +525,7 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	 * page table has been modified. Use FROZEN_SPTE similar to
 	 * the zapping case.
 	 */
-	if (!try_cmpxchg64(rcu_dereference(sptep), &old_spte, FROZEN_SPTE))
+	if (!try_cmpxchg64(rcu_dereference(sptep), old_spte, FROZEN_SPTE))
 		return -EBUSY;
 
 	/*
@@ -541,7 +541,7 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 		ret = kvm_x86_call(link_external_spt)(kvm, gfn, level, external_spt);
 	}
 	if (ret)
-		__kvm_tdp_mmu_write_spte(sptep, old_spte);
+		__kvm_tdp_mmu_write_spte(sptep, *old_spte);
 	else
 		__kvm_tdp_mmu_write_spte(sptep, new_spte);
 	return ret;
@@ -670,7 +670,7 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 			return -EBUSY;
 
 		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
-						iter->old_spte, new_spte, iter->level);
+						&iter->old_spte, new_spte, iter->level);
 		if (ret)
 			return ret;
 	} else {
-- 
2.53.0.rc1.217.geba53bf80e-goog


