Return-Path: <kvm+bounces-73070-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qD3KCdHeqmlqXwEAu9opvQ
	(envelope-from <kvm+bounces-73070-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:04:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA75222423
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DBCFA3011A73
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 14:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2D03ACF1D;
	Fri,  6 Mar 2026 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GA0q+NLj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D8B3AEF3B
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805774; cv=none; b=n9SC4oYUW7O/jO4UpyFlAWv+qBKZATX9SuqXY7qgCqT2A+aYuyQaLmvhiOxDZnnoVEDbPN/HNcEJXfhCqh8a8dYSP2Ua4HHv1fNR67qpQODmr3fzoAUtDmLE85xl1duH1VYXv1dGS5aAUFKHVsKgtwvy58+meAP/D74QJ1BUP+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805774; c=relaxed/simple;
	bh=3OQfV3w/2qk9lemOSyqAInJWfA1kcX3/Dpbr8AywQL8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aKxdKkom/XdchVPy1PzlnhElt3axylVjkuKMz7NTYzfwI/HVSgiIEtmPE/wot5twVCpy6P01wD7jBRMR9ao4uknvwWzOtqA0Hz3H9v5oy4voY3Bdx6R5rWqfQwHNo3+bZSvqQWSyeIbdGsxIAg9wH3dl2ngmcydchc7+UtDSyhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GA0q+NLj; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-661aff85c3eso1245828a12.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 06:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805769; x=1773410569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CtHGmGW+kuNXfpqkwV8R0QzbahP6BhHBAQuRE9dnG2k=;
        b=GA0q+NLjnNeaPAAluYbcRBq7jiDl4E0cPz8MM81EeodbtofmR9pLTdrbi4dtkf556C
         cedfSngBU7wlpByleh112nAdfj7Q6ASSKK9vw0xF5OFWgSHT1+vpa9FTd05j8dO2aHlc
         DXigjhM1QcfA057AT15YeJ6BE2l6BwRKwh6YJ8O3LtfrKWPPbbifqCdTaDcVZIf9HrEt
         OywH45JJ4KlckaMk2JHM+6/k5dXuBfJwTU8Gdvz1Pl7Ry8hxSaqrJaheptOv438sGVF7
         rpaLC546hS04GgHk8ICBC3wm9S1SOX/7CSdBzYvmZXGJ37seBVniWkbDb8N9ywauJ1BN
         e8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805769; x=1773410569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtHGmGW+kuNXfpqkwV8R0QzbahP6BhHBAQuRE9dnG2k=;
        b=ZJw2wck5Bqbf2d0n0ih67OhD9Okreh8lf5j/pR88bNW4czVyUP5idl0vUUerEndhxo
         z6i5V/K3xih4KEcn/nU1gLBFYrsyqKA8aZ2A4fwskRY0zkHr/OUqHUeVEnybPcHGiPpd
         VU0ev3iIGiF1J9LY3mej6yE3rDPZoi7RD2wcNaAU+pOgScaXn5DqwKrgCvhIa8e17Y8I
         CVtiJ27ozSWyETn7mzWfHZg9Xl7MchVgxiTarlV4nCRlAaQn9G6AfRVy5sFbAV0Atk5x
         cqRaF79USDXpZJcS0fQO5i4WTIMP6mpMJr3CCjgfIB5KUrcmx+6D4Uo8jSXfgMyVylFb
         DsaQ==
X-Gm-Message-State: AOJu0YzfjSmVfwMof5U2XxiwflY/p8I/HeZdBWp69uWwcO+XrCCCI/w7
	2JaZ1zHraKtyLl8UFfy2qFb+TN8eKk55RJrEWxPjrShulITT1ufBd3Jcy0oEUYQ7ruN3QGEG5E7
	bmudz3gTmNtQIHcTibFIjd4lCdBX7V4EQieFFEj1+/8FUxg9GQRMzMcOLju/2gW+OtUUkONV6dL
	aEbYnYOrY4rFnb4JJH/qZXciWkHn8=
X-Received: from edoy18.prod.google.com ([2002:aa7:c252:0:b0:660:e9bd:31af])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2807:b0:658:1304:b699
 with SMTP id 4fb4d7f45d1cf-6619d50626dmr1271444a12.31.1772805768583; Fri, 06
 Mar 2026 06:02:48 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:31 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-13-tabba@google.com>
Subject: [PATCH v1 12/13] KVM: arm64: Hoist MTE validation check out of MMU
 lock path
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9AA75222423
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73070-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Simplify the non-cacheable attributes assignment by using a ternary
operator. Additionally, hoist the MTE validation check (mte_allowed) out
of kvm_s2_fault_map() and into kvm_s2_fault_compute_prot(). This allows
us to fail faster and avoid acquiring the KVM MMU lock unnecessarily
when the VMM introduces a disallowed VMA for an MTE-enabled guest.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9265a7fc43f7..cc6b35efcee5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1870,18 +1870,21 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
 	if (fault->exec_fault)
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
-	if (fault->s2_force_noncacheable) {
-		if (fault->vm_flags & VM_ALLOW_ANY_UNCACHED)
-			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
-		else
-			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
-	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
+	if (fault->s2_force_noncacheable)
+		fault->prot |= (fault->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
+			       KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
+	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		fault->prot |= KVM_PGTABLE_PROT_X;
-	}
 
 	if (fault->nested)
 		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
 
+	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
+		/* Check the VMM hasn't introduced a new disallowed VMA */
+		if (!fault->mte_allowed)
+			return -EFAULT;
+	}
+
 	return 0;
 }
 
@@ -1918,15 +1921,8 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 		}
 	}
 
-	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
-		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (fault->mte_allowed) {
-			sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
-		} else {
-			ret = -EFAULT;
-			goto out_unlock;
-		}
-	}
+	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
+		sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-- 
2.53.0.473.g4a7958ca14-goog


