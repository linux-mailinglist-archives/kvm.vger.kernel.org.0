Return-Path: <kvm+bounces-71449-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +AcrIED8m2kC+wMAu9opvQ
	(envelope-from <kvm+bounces-71449-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:05:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D165172830
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB5E930378B2
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 07:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BB834B19F;
	Mon, 23 Feb 2026 07:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ssJgzKJf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A7A346A0C
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 07:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771830293; cv=none; b=MsbCqrbv96BppL3SzIAcYDa478Zifg6cHRL+j+nRN9mkseEVZU5+VhqunqGG3ma9NkxuFBKuVC0vHGD2nF7aw4F1kiqXrMKTjiRNnfTsK/eW6BBooPBXA5gT8Qv+8iBE4/zyQFNSH24W7S0nsVIjGsYzd7Pdx6HouOu/ruqQ8XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771830293; c=relaxed/simple;
	bh=w37966m1o0RmX0vyIvS+1AaWr3RY1h7nrLYdurJIUkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S+pyYV2qd8YR/6vBW8dmN1MMpC4nw8hq5sCLqmNF2eb5pyFBRBwUcZtQxsfzrRCVwrbGum92mqSBydd4+L4OfbdhhPzg/TtwxREw2+DKLFOPikNCPaO3USEOMyvy0pRy0byuXJnMDhk/yYzSSJxmyqCS6/gVik5u6RlmrZKc5Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ssJgzKJf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c44bf176so4017688a91.0
        for <kvm@vger.kernel.org>; Sun, 22 Feb 2026 23:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830292; x=1772435092; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5lJdfKFYNuLjR953Ng0mcH/dDhHLbnTZ2j5PCnoQPSQ=;
        b=ssJgzKJfjj3StHv2ZNgcIrJITDH1qRhsBjABDL1pZsmdjr89/dkTfFYKjERlzUkppJ
         GJv+STOgjzvG5GSB7S7NeOFh+fvwOevbtMNiqOacM/VA0pYCFFhnWy2PJpD0FmT6BNy/
         cA6bHCiBgelkvCwVs16xLJ443A1NVjgBUYC7HPP/iK4KcW+A0YbgvzLw4dezj0LOq8pD
         P990bWgdp3siKnitspKpEFtxfXnkKh66mK9c1xu1bn2MmHAFahcEvAR4HxBt+N37fOpI
         EVlfZd7auyZCn3vFY4FacY7wHhsb4zWrWktI1lgbTegYroNq/eMOJFJLTxeencdEWMHS
         jiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830292; x=1772435092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lJdfKFYNuLjR953Ng0mcH/dDhHLbnTZ2j5PCnoQPSQ=;
        b=GeFXQKYqVNrSjo4AjHppiLQQATGfhoXJXoj31fDKtuiirl7D6ljnVWkar9L9q+MEqz
         vISqnv5gKOMOB+NPNsDLrJ1wshtdKuEvLaoLga08pxW2BlkzQeloVJ2uE+rWfO2YvPn/
         sGFCokcirvMqSPaSD4VX7x5q0uA6F4B1F1QfYZHiQC6chmM1GOhDC0/zRzLqkTCFG/l+
         yW9fNvhicAPSSxQh3Af/ILv9MqXtfpePs4S5/M83j30Cps6SvR04rmYcuvvz6zYhPU4v
         1nVgjrqj/gUi1lvuma+fWMbkm4MSvdDzup5Zs7eRf2wYwz52U55XeBf/oeqc3W48oYBi
         +1WQ==
X-Forwarded-Encrypted: i=1; AJvYcCXO9l1cwu/o2pfEuD5EbQLKNq9y88q7pSQroWr5OQskyWbRERFjEGSHf2dO04+RdKhXX/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS77JnXym8xeyljNCEXFbIRBZe9MEzAhaS0IrO5DUyNwQ3tWmF
	JqTM5BRwc2FautO+mbCQ1jH5AlJjOSkhFRCXChuTICg7wQ6aesgQxHBty15qzZTzBm24iy0syQ2
	ErQZextthqOJbNAmzoBRMNVvFXQ==
X-Received: from pjup4.prod.google.com ([2002:a17:90a:d304:b0:34c:2778:11c5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d46:b0:354:ad98:7d1c with SMTP id 98e67ed59e1d1-358ae7fd556mr7480246a91.11.1771830291734;
 Sun, 22 Feb 2026 23:04:51 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:34 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <108d4e27b72480a20e4490d839acadd0b0a2dcea.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 01/10] KVM: guest_memfd: Don't set FGP_ACCESSED when
 getting folios
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
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
	TAGGED_FROM(0.00)[bounces-71449-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[30];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:email]
X-Rspamd-Queue-Id: 2D165172830
X-Rspamd-Action: no action

guest_memfd folios don't care about accessed flags since the memory is
unevictable and there is no storage to write back to, hence, cleanup the
allocation path by not setting FGP_ACCESSED.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
---
 virt/kvm/guest_memfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 923c51a3a5256..2df27b6443115 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -126,14 +126,13 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-				    FGP_LOCK | FGP_ACCESSED, 0);
+	folio = filemap_lock_folio(inode->i_mapping, index);
 	if (!IS_ERR(folio))
 		return folio;
 
 	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
 	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					 FGP_LOCK | FGP_CREAT,
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 
-- 
2.53.0.345.g96ddfc5eaa-goog


