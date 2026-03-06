Return-Path: <kvm+bounces-73071-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iDDCDEjgqmlqXwEAu9opvQ
	(envelope-from <kvm+bounces-73071-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:10:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C5FEB2225BF
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:10:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 53FB0319B8F7
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 14:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC323A9DBA;
	Fri,  6 Mar 2026 14:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MZpEtXID"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4341B3B3C1B
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805775; cv=none; b=HNUDqmjH0vvfs2Djh5Sb5x6BIn1vELgi8VcEhnIQ/FY0jUvNocICsh0oT7l1WVNRRmmemJjQhSQBcIAWPg1G9bhfyiScDBXzUHCbZsXhu7I3bp/atlKOeCK95A/2f2f3lqD0Jzh9PPrPNQVy7UhE0P17ByR+AzSZwHB7wA4tzUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805775; c=relaxed/simple;
	bh=V6eWiKg9V+W/g+hdyI2Ge2Jz2TlMcvvQDPsYm+0vBKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PYvqP9/HQooF9JJMYxEdwWEdzgfZM1z6hxloGUUn/HL7tR8c6rmeuBW6QLzoyqwbGVGm6n6mGF3Sl7cGbxWBmJjjRAKrDH82JQi6QOehzAUj6LZLKmvOJ/12ZJ4gNkZOM7wA2QY0Eenad0FknaiZy+k4iwIKKIeeLDtlw9dWj8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MZpEtXID; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6618bc12875so1259129a12.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 06:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805771; x=1773410571; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jrYglMPFnkSqWiX5InhsukY4+nR7R4qhDkeT1Y7YXwI=;
        b=MZpEtXIDwv6nEXE7F5jyqwggnLZnWOXbpFMXQS0TAmgdo2Js6QJ943ngu+m7ydJ4Zu
         B5zvZa6EbJ4l33ZlF4qE0NL37rxR1W1qDGYqHVlbjSViKuERoZB7gLM2mBRv6GnGHYfR
         Nke8zqdhWA7+p5XiYN6Vt2xM45Qe5enhYRe8FF7DCT27XoIun2uZfXwA3VhYwKBf1Wde
         tsRiEhxfKgt7QLu40ACF4rmUIL1x2HTWuotMGZIPHyUIuDnyR4U3A3aif1bI/RvzodSg
         z7GRDeP3s8GaCO1vI3yG0sU99s4Yo0aumUP3C+Ni0/CnkJmcCR3UDfstpEvr9K13+sv0
         zhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805771; x=1773410571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jrYglMPFnkSqWiX5InhsukY4+nR7R4qhDkeT1Y7YXwI=;
        b=BlyIKZiihdqnsYxom55UsPL2NTWLZ9lg+XSwfq6NjPjC23w0DRiXqES7j2asRjlw2b
         cTBLfgl3wMAm1c2iQbyn1HlMV4p1slrE7Hf93PWePB1CZnVlr+qZnX+Abiy0iiYbSJ5v
         9Icz6/8ashFTGt8vgZqy9OeABj4lME/rdgSvxGJQwAaRwpR9gII70/80C56oHj6CY4OC
         KYFzJqbcXg6RtlVcZJAsz9nqgRRaPTts5mTrTki9x9bgYvJM+S75ISETt57glXHK5pos
         6781GJ2ZzW2nE26XX/Dmc+cszNcCX81v8nXzc12iIFrwxyEIZX7F643+OOcAZPYyZKA8
         exQw==
X-Gm-Message-State: AOJu0Yx9JWcIZu2JPTJmf1gRTzZjoRTnYbeVrqs7JVTVgYRB1N754NwO
	efuXUN+cWODZ1FASKFTOGqrA3BBTZIQYyuv9/h2qHfDpzbI7ckTt1zB20tpR8S6g+bUGELOmacI
	lvHHUvtoFziAkWElQyjvRcZ5CGX7HSlVaHMqV5/CKOS2RiMJcD2fVSwzdpsocAnoR0/0HHJGNua
	q9bzclmGAYjAvl1g9FYrtGoRPXocU=
X-Received: from edrc1.prod.google.com ([2002:aa7:d601:0:b0:660:cb32:1c97])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:354f:b0:660:d9c1:1919
 with SMTP id 4fb4d7f45d1cf-6619d51ea6cmr1251752a12.18.1772805770063; Fri, 06
 Mar 2026 06:02:50 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:32 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-14-tabba@google.com>
Subject: [PATCH v1 13/13] KVM: arm64: Clean up control flow in kvm_s2_fault_map()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C5FEB2225BF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73071-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Clean up the KVM MMU lock retry loop by pre-assigning the error code.
Add clear braces to the THP adjustment integration for readability, and
safely unnest the transparent hugepage logic branches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cc6b35efcee5..5542a50dc8a6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1897,10 +1897,9 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 
 	kvm_fault_lock(kvm);
 	pgt = fault->vcpu->arch.hw_mmu->pgt;
-	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
-		ret = -EAGAIN;
+	ret = -EAGAIN;
+	if (mmu_invalidate_retry(kvm, fault->mmu_seq))
 		goto out_unlock;
-	}
 
 	/*
 	 * If we are not forced to use fault->page mapping, check if we are
@@ -1908,16 +1907,17 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 	 */
 	if (fault->vma_pagesize == PAGE_SIZE &&
 	    !(fault->force_pte || fault->s2_force_noncacheable)) {
-		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE)
+		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE) {
 			fault->vma_pagesize = fault->fault_granule;
-		else
+		} else {
 			fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
 									  fault->hva, &fault->pfn,
 									  &fault->fault_ipa);
 
-		if (fault->vma_pagesize < 0) {
-			ret = fault->vma_pagesize;
-			goto out_unlock;
+			if (fault->vma_pagesize < 0) {
+				ret = fault->vma_pagesize;
+				goto out_unlock;
+			}
 		}
 	}
 
@@ -1951,7 +1951,9 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 	if (fault->writable && !ret)
 		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
 
-	return ret != -EAGAIN ? ret : 0;
+	if (ret != -EAGAIN)
+		return ret;
+	return 0;
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-- 
2.53.0.473.g4a7958ca14-goog


