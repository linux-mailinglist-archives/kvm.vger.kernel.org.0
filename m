Return-Path: <kvm+bounces-73064-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UD2dL/nfqmlqXwEAu9opvQ
	(envelope-from <kvm+bounces-73064-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:08:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5680922253D
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:08:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4EFE318A6CD
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 14:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A183AE6FF;
	Fri,  6 Mar 2026 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y7bbz/m1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A15D3AE19C
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805767; cv=none; b=ONqbsPXnjWGqX/ByPAaQxGqTO4uMh+/qPjZ3si6aPx1WX3XAj9Hj1rh3SqflUh6djWiZwlz74h75T1u4JUGHaK0WR6eGZljNu85NpnGrwBa1REqtAHWbFvCI2rtIYl8XeAMsZjwshawMAngiB0+lmfesp1TaZBpTqWOOlG4LaC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805767; c=relaxed/simple;
	bh=BMbVT7miz8KQ7+AZQDsGiqCWygy7M90I6XCpAU+izv0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nlkLN4mHAzVAUGsUC4T0T6aeB+Lys+XprgkTQXI01iTXhZ6y2zOfnD/oNV86W4PGTmkTAtX/x4NtyJJxhehk/cvpTe7XbIXQIhNTUWplra8tCaJQJ96nlj2re8JJuzPTeAvOLukc1a5nw840g2VMY5d6k6Q69Xrog1e5GJpqZNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y7bbz/m1; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b9407779e3fso210615566b.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 06:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805763; x=1773410563; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KT44YeiLTJyOwAcprGitUZ5uZxYG91k2apEts1OjnSo=;
        b=Y7bbz/m1VfLXrUFV4bqAN2nQdmW84t+uBIDxde3txgMeZ5o9WbZq5ZIzVYJSjhftrA
         JrV6F0oqjHtrSQyAj6H/CzrtzVHZ0VUGDtAet7Lkq4psHUTeHil+ngzs5fgNLv+IeI/G
         nPaWzzJIBHPfv5WyVGfHnLRSuD0nXVYJx6V336H1lbMb+YPjlYIhuCk9vJaY1Uu72pBt
         388/RSYNts/VxgzcXDNTTH93gTcCrX/4LkFvjok+hTdoOlcpAzPV3ELArXYNdw6xXiMc
         qjVI6gZ+CL9USdOJvkbJQ3A1NsMeOeRpLJwVBmPlBlzhRx3b8ldUWqMKCFEwYNJjLvNE
         RTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805763; x=1773410563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KT44YeiLTJyOwAcprGitUZ5uZxYG91k2apEts1OjnSo=;
        b=mZfKq52S209xDoaq2k/ohjiJjP2eVDovXxjVEPo25Y/OfDq9nG7VsjRwM78S1cKG1q
         X1jkkAh3js5dUukrHp9KRxt2CLXNZZvWVkTvBUo81SaWthaIII4gJWhFGSgf1N4H4nCn
         fOfLie4IPh+GC5StgsXoeuPJrNA+LWbi1nUNU1O4iSXTRK13pR5T+3SYr/eV72nTkkj+
         uHZV3YMYIgGVNAmZcrPPNxkqMJ34lPhM221AaXZLcL+0TNm0Z+1Mh5quuXforlPZt83W
         YM5qaHutxCp/rfnD2tFJhSu5eLW9Qjb4tr8cBPin4iMhSb+AK0YXq1ZV1HHvNa6UhPYG
         piag==
X-Gm-Message-State: AOJu0YwM9YzKK6QlwXBgSS5+4v61SG7o5BR3bTRuzjwJtnPHXMCSyvBE
	qBAL/FwLheYYTHg+AWZ+i4MXwjWf7p/cdwmM9KhKPgRBmYFoLal76qfrG8HQntYb/zyZMQEL232
	Y9gZpHCdN9D/OD2in1lKt3/6Lsz3AkbFlLLrjJdX3MrMGWMNRkBtj2UqsoJFc2GM4aIS0Xg4mSq
	d5QqvghvJqORCLrwuHrqXXdT00B/k=
X-Received: from ejfw12.prod.google.com ([2002:a17:906:a0c:b0:b94:f06:dc6e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:d54b:b0:b93:5ef5:904f
 with SMTP id a640c23a62f3a-b942d1b1bebmr143967466b.26.1772805762935; Fri, 06
 Mar 2026 06:02:42 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:26 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-8-tabba@google.com>
Subject: [PATCH v1 07/13] KVM: arm64: Simplify nested VMA shift calculation
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5680922253D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73064-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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

In the kvm_s2_resolve_vma_size() helper, the local variable vma_pagesize
is calculated from vma_shift, only to be used to bound the vma_pagesize
by max_map_size and subsequently convert it back to a shift via __ffs().

Because vma_pagesize and max_map_size are both powers of two, we can
simplify the logic by omitting vma_pagesize entirely and bounding the
vma_shift directly using the shift of max_map_size. This achieves the
same result while keeping the size-to-shift conversion out of the helper
logic.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 833a7f769467..090a906d3a12 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1646,7 +1646,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 				     bool *force_pte, phys_addr_t *ipa)
 {
 	short vma_shift;
-	long vma_pagesize;
 
 	if (*force_pte)
 		vma_shift = PAGE_SHIFT;
@@ -1677,8 +1676,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
 	}
 
-	vma_pagesize = 1UL << vma_shift;
-
 	if (nested) {
 		unsigned long max_map_size;
 
@@ -1703,8 +1700,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 			max_map_size = PAGE_SIZE;
 
 		*force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
-		vma_shift = __ffs(vma_pagesize);
+		vma_shift = min_t(short, vma_shift, __ffs(max_map_size));
 	}
 
 	return vma_shift;
-- 
2.53.0.473.g4a7958ca14-goog


