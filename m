Return-Path: <kvm+bounces-69493-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENQIJ5+2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69493-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB54AAA99
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 06A1930535BD
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DA9B378D75;
	Thu, 29 Jan 2026 01:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vmGrprmL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4DE33F8A6
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649408; cv=none; b=EHRi42PO138QkDD0DKxeh8v8TY1lcPTpLjOVsepLb39LXEtGGeIGc6kzQnfGV45/LqqE5QldEGnx2h/rjpkDz2EbPTyEmGsCZR4V+cY5ggYJRe+BxwdPwrWWz22wIKldOi1TYLSeVpw4IyxSfz1JrLHMnRfqoSHqU0pzKJdx1i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649408; c=relaxed/simple;
	bh=2lbLvW6ijIN279zXFdILobLzEFRXyPlsR+WIhazYkJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TaIeWcwA2ECMWXbP0ZQvJMG1+Xm+zkRNqQ3ZUKYWhM0YUX7oufU4bChccpEggniioDBqDud//jyMUsSc6Jgosc4Uo1cE2A4Tn6rGQUNf1EFdCh/wIqP68AlwuTVn2tQoMcyxIHeM7o1w9aefU9+9MkfgIZbGYFzBdxU7CiBTZPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vmGrprmL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c5454bf50e0so863626a12.2
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649406; x=1770254206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eeY70eVnfoYCtpmYqMWIyko5YIZVo7ravcEk/U6/auE=;
        b=vmGrprmLuMg8VCbykZI9iDxnUl5RzwhjxeeBSrf5iQSNw0RK6BItj4nf/H+BDiBAyt
         1+wlnMESBe4Vrf/p1Hcmtf/VxRf0wfEZQ4YpemMJydS+ybAzrGAQVMXuLdkiWSjrE/ew
         dKHrqvR2/jHZUzF6Z7z37B6rOzmYTBgCPlpOwDdowAUbRwDbW7IiPzG8Eofd8V6nEhAU
         UYtWbogRTyKWeJJg4Aqpfc/36xUgjrSMdoVdfQ1HsyVFO6aKNnuuBthzZd5Xs4KjEiZU
         9i4I+R6uFdItMxZFbhTmqnefODrHxVWMucIG3ZpAcfJUU4aL0XcQP3cwjTDYqVoUluQt
         xx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649406; x=1770254206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eeY70eVnfoYCtpmYqMWIyko5YIZVo7ravcEk/U6/auE=;
        b=s4DN4RSQpLDz4qMS3VwfmH0SPa/ka9BygE/+2n7iMQcEu5AbYvCWEPM4nq9Fg51smX
         Zq9jr3a/h3MSMiOS7zV/rEa3R+bpDA8x6yhtbpi/+6TVHrRExv1bOfrileF+3SVtWgde
         scN9+1T+x9v5ZwLZ/QRg/HndvdK081j0lBK/pivpwNJDlTYU5GbShflb0qPZU5yZx4/5
         e1nswSoLUgN1SWIisOEGCmtQZJibaRt5o5kygppnYxpqaO+8g+XXdMq5qIt4fbOnNeY5
         i1K5af0n7iKlTHfVQMaZotGBq/p8loxoF50zallrGVo9VrhbsT+JD7i2thQZ1GIemHMW
         UxjA==
X-Forwarded-Encrypted: i=1; AJvYcCWwyrP22WJLHUxS1+iawYV6sBwx75FZQR8NmLQRqoFBaEuppDmbQdFqz4xx/vDP8GZawdE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmZqKorrVWoMInLE+b49dMEQDf3w8dBc/WPndn2RNBde5oILM+
	f3Or/zJRuEs9DvLnhp5FS7R7N4HMIm3WIXAO7O23nGpRpRaD0j8WxSjNYddkbkZxhfkhIpy3r8B
	eWivApQ==
X-Received: from pjyu17.prod.google.com ([2002:a17:90a:e011:b0:353:454:939c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:62c4:b0:38d:f62a:a9e5
 with SMTP id adf61e73a8af0-38ec6248055mr7357147637.14.1769649406445; Wed, 28
 Jan 2026 17:16:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:14 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-43-seanjc@google.com>
Subject: [RFC PATCH v5 42/45] KVM: guest_memfd: Add helpers to get start/end
 gfns give gmem+slot+pgoff
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69493-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 7CB54AAA99
X-Rspamd-Action: no action

Add helpers for getting a gfn given a gmem slot+pgoff, and for getting a
gfn given a starting or ending pgoff, i.e. an offset that may be beyond
the range of the memslot binding.  Providing helpers will avoid duplicate
boilerplate code "if" future code also needs to iterate over gfn ranges.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 923c51a3a525..51dbb309188f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -59,6 +59,21 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static gfn_t kvm_gmem_get_gfn(struct kvm_memory_slot *slot, pgoff_t pgoff)
+{
+	return slot->base_gfn + pgoff - slot->gmem.pgoff;
+}
+
+static gfn_t kvm_gmem_get_start_gfn(struct kvm_memory_slot *slot, pgoff_t start)
+{
+	return kvm_gmem_get_gfn(slot, max(slot->gmem.pgoff, start));
+}
+
+static gfn_t kvm_gmem_get_end_gfn(struct kvm_memory_slot *slot, pgoff_t end)
+{
+	return kvm_gmem_get_gfn(slot, min(slot->gmem.pgoff + slot->npages, end));
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -167,11 +182,9 @@ static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
 	unsigned long index;
 
 	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
-		pgoff_t pgoff = slot->gmem.pgoff;
-
 		struct kvm_gfn_range gfn_range = {
-			.start = slot->base_gfn + max(pgoff, start) - pgoff,
-			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
+			.start = kvm_gmem_get_start_gfn(slot, start),
+			.end = kvm_gmem_get_end_gfn(slot, end),
 			.slot = slot,
 			.may_block = true,
 			.attr_filter = attr_filter,
-- 
2.53.0.rc1.217.geba53bf80e-goog


