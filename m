Return-Path: <kvm+bounces-68953-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANfSGRM5c2l/tQAAu9opvQ
	(envelope-from <kvm+bounces-68953-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 10:02:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 081FB72E81
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 10:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D4D9306B7A4
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 08:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED7B350A21;
	Fri, 23 Jan 2026 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQVD4+l9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2B6337692
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 08:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769158736; cv=none; b=l+ct5XHiHYEhhbkunoYhk3XcqxkdaS/AS+49CvnukeK71daBeCmQ0tezKXdpc5d8LAFewKNLPBR3wH4qmtLE2H69nNCFUvKDcFe8XIPdkTyyuPvg//pCsvMroEgPkMuFO+yyMj9O0M857l8F7s4tzF3OJRXTPEaKYbCZkmfCPiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769158736; c=relaxed/simple;
	bh=Tm5RjqAt3sFWFp6SLw/XgkcKR8IPgFizHw21cbk3pWM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AtSHUkQF0R/mPsBzREM0YU3PC6lraxKhNyNzfzPvIvAT2VjtOSyr980LkklY7yiI44zrnMIbBGlUu7tVHryIxhNNyyuKiyINgWRzktHEtTiFJ0U+IILVjz1zaiBP0NOrLm2gaw73ZryCfUe2+Q/8lcwJhDeNrryX0dyXw2MYVZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQVD4+l9; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2b4520f6b32so3049398eec.0
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 00:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769158733; x=1769763533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQXhhe7l1AVXXuD0gAW8BC+M9NQG4Nfi2UMks9imgTY=;
        b=PQVD4+l9iU/pbYI31Zk0BP3T+rfogUgXJZqbnXnnLsfdlvJDW0ygUyBRXmZYYhpsrx
         +Cmg5E5CLLFRYv50euzfN4BJkhuXjnvT1uIDJtr7wTUtXPG1cnBn4fln20Uze7mlbYCl
         DBbtPw7dIlmTc8Gfk/CLIYZytuHnZ1otuWP5n7CDVOGIcIwhle9Ym3/3Vo+KHIXGOW90
         4DOaJhdxTNXXRy59WY+Cw4eFS7lw+dB3YgDZ4R031pwTpCUd8s3tUInGmsaV0m/B0pVi
         1wrB/wM1/H8ZyjzvvmDb/DE0fhQV5rE3I8aPpofkZYheHuJHQkDjoUYKFnpH1Bi9jASi
         q8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769158733; x=1769763533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xQXhhe7l1AVXXuD0gAW8BC+M9NQG4Nfi2UMks9imgTY=;
        b=hPQ87YbKkgUkZmaUF356nzPxtbmaCC/EUy5zGxn9IJMmm3An+XkFIQ8A6YLrEupimY
         zJ+hwxSyEWOX2P8vyQmbjiHyOwyejOVKvcUB9mslptmop2hDOTkRSR8QLTOtUb9pRqmd
         tsHXbhlR7dF6HOvBuorsc4oCEXG2BEcPBuX4VDXKV1JQd1FH6B1Uyv9dTw8n8kWUQR36
         FWmfvE4A2iCtLANMF6U/894H4SZh3UqKFux5wisG5hjamfYB7VWlpit43Zi6ChGrHHaY
         g53QfAnPFKLIv1jNq55mGQ+wJBV14np8zoZp575KQOhNkl/xAbRo071jCGC3Ufju+7LP
         ds8g==
X-Forwarded-Encrypted: i=1; AJvYcCW6KXQDHemUM4PuYx2XXYVfmFisYF5xQ2SLpJrjAQxekjUAMsWaqGauLnsBur5LDdgF23c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6vHJJr2t/OrrNlc00g4TdQardqd9UnmC/wGFPzBkpJ4hXJ31p
	prfpYbDeRttdDufs5444wMdt84BZKzftQ9n8zI+HYf87EHT9pXQwUhN4
X-Gm-Gg: AZuq6aKZ/zRm/kxxo4iF2N+kAe38IdSOjujY4fM6nnSi0cx+M+GKsxlSYy9Y5f1VjIc
	bQzULeDtQm6fKR4VajL7yuJgmdRetjpdd+D9qf/jAvqfvahlaku1nRu42eu8+VE34wvwEcPcGnt
	ubkdRsqi42WFhfl8KeRwsgmZbxVbtAYtL5sluX1GsWiyvu0127iozlBh9024cHIkKGf96cgeOYV
	qUsieQvOYA8FmuCSpUnBIynM0tFrLseoUm/Qgu6QAx2XZ2mTmfcF+zoBONK/qJMqQmf8wp+lgGm
	mYnMwLqhQiVLCf7VKKS12ycl7xZQrU1dS+c3QFCK3Vt1ps0dGBx1nSsvxBndKW8ofroq2lNIvwe
	d5DWfglsSwsWKIpYIDJEkmx9tPb8ZfFaZNXs4hVr4WaIQ2ZEchrnt8Riq7B4/z9VXFkfbqug4c+
	LJ7a0X0Xu68jZ6kjuUxbdBng==
X-Received: by 2002:a05:7300:80c2:b0:2b4:706d:4e23 with SMTP id 5a478bee46e88-2b7397aa1c7mr859787eec.0.1769158733412;
        Fri, 23 Jan 2026 00:58:53 -0800 (PST)
Received: from localhost ([240b:4004:a2:7900:ecf3:dec8:8c1e:4f5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73a6e9933sm2452245eec.13.2026.01.23.00.58.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Jan 2026 00:58:53 -0800 (PST)
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
Subject: [PATCH 2/2] KVM: x86/mmu: KVM: x86/mmu: Skip unsync when large pages are allowed
Date: Fri, 23 Jan 2026 17:03:03 +0800
Message-Id: <20260123090304.32286-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20260123090304.32286-1-jiangshanlai@gmail.com>
References: <20260123090304.32286-1-jiangshanlai@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-68953-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,antgroup.com:email]
X-Rspamd-Queue-Id: 081FB72E81
X-Rspamd-Action: no action

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Use the large-page metadata to avoid pointless attempts to search SP.

If the target GFN falls within a range where a large page is allowed,
then there cannot be a shadow page for that GFN; a shadow page in the
range would itself disallow using a large page. In that case, there
is nothing to unsync and mmu_try_to_unsync_pages() can return
immediately.

This is always true for TDP MMU without nested TDP, and holds for a
significant fraction of cases with shadow paging even all SPs are 4K.

For shadow paging, this optimization theoretically avoids work for about
1/e ~= 37% of GFNs, assuming one guest page table per 2M of memory and
that each GPT falls randomly into the 2M memory buckets. In a simple
test setup, it skipped unsync in a much higher percentage of cases,
mainly because the guest buddy allocator clusters GPTs into fewer
buckets.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4535d2836004..555075fb63d9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2932,6 +2932,14 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	struct kvm_mmu_page *sp;
 	bool locked = false;
 
+	/*
+	 * If large page is allowed, there is no shadow page in the GFN range,
+	 * because the presence of a shadow page in that range would prevent
+	 * using a large page.
+	 */
+	if (!lpage_info_slot(gfn, slot, PG_LEVEL_2M)->disallow_lpage)
+		return 0;
+
 	/*
 	 * Force write-protection if the page is being tracked.  Note, the page
 	 * track machinery is used to write-protect upper-level shadow pages,
-- 
2.19.1.6.gb485710b


