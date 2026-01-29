Return-Path: <kvm+bounces-69488-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uDNRItO3emmo9gEAu9opvQ
	(envelope-from <kvm+bounces-69488-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:28:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDBDAAC17
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:28:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8222C30A353A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABEE033EB0D;
	Thu, 29 Jan 2026 01:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aWY5uYcR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9D5339857
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649399; cv=none; b=XzuOmlLUyTZFxzPO5QgAPCf8DZRGm3A7dXerUXEDGzY2RkKTcMbzui1pYHsewyjVM1QyM+oPsCOCXqEgtBk8o/E6AtzsBkfUMl8JUvMMny+sRQZAcfnTom4PltI/r3xSzsvIh4pult1NAiPxVKykvFYNClGQkIdIMdjiFe2nP+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649399; c=relaxed/simple;
	bh=Oi162mi6i9IEnnNv6uPixUH7Wd19+um7eCx9W0j7qNY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oz5h2wpMzHhan0zJwQGwkgzE1OGOtFEC8XUQfoXTEyfSfvUY+8TWxXsCzvBq01VBrsdoHxgdWWZ9cM1MU2haw7ZDcEJUW4Cxcji0z2BHdeey1BPK/oDRJHAMpODhr8t/XJ0zddn5KnDmlF6jtE/fi5uV55KZRqSl9rZiax0lxk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aWY5uYcR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab8693a2cso829077a91.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649398; x=1770254198; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f+prWW7rpbp1pSxf9bX6axWwAfKRzuFR7Mjnf0TwcpA=;
        b=aWY5uYcRhVR3rIc/WIhWu0xOEymyFTOdwGCZ0tWTYWKkEp+lkvlMNHNtgGDv5hfbEw
         Lt4vEmZMxuA3b50Ovz+LEGJvCJValJtophtoG4HkV4lLcg9UOAqVzM45+xSJKxlGac62
         1wWrr+/4vC+SZa2A9H2pA6IaUCb7x/VtqgIgJbdGRoewZ+2/VkId1peSmtVW5tAigDsb
         Fn/Vaa/WcAfjorIaFJcpyONedWVGM35o4w0G8faE30hc0YjajhQo/JCJO5MG+CA0HAbK
         qKVCz/aVYbFb89NiqmyzJiBubg23KqRtAjS9TrHfoDtDFBXvaviuyIDEa+gdlF2RAhSL
         Spzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649398; x=1770254198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+prWW7rpbp1pSxf9bX6axWwAfKRzuFR7Mjnf0TwcpA=;
        b=TwXycF6H7qQ3OnkQorOdEY11Q9eGiO5yta/SN9nzh5As+G0ycFK6Aa0S0P9oS2n3ZI
         HwTGU8mCmnwDrORvxL/6srxcfJC3NZvxN06Oj0FcxfiuIOiW3Wh5AgdW1msYDL46uH3o
         qmBY8gdF8/flmpj73RNH28McNalnBy5M/pnmHXHU/e47wB5x35nJuORne4BEcophgn4o
         RTbiZbedcn4gxZ4BlGowleONkudbF636inGzMU2Y48MtPJ5J+iCyoUqGKsWKFDozMthv
         X7kpo76Y9gmSk6Vlfr4yitNAUnpqKEG4ktyJLduQ8+xeva/Oc8ukDY0yh12mW1FS4ZnP
         JUCg==
X-Forwarded-Encrypted: i=1; AJvYcCX/t9S9/jbxZP87cLlmkkIkq16S7PdLsPyMUkspv7QjsQQKzK/aiOjumBqWaCL3s1bMCck=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNvWqZvwJwM2XFCkgGKh7HCdjCT7qoJqsvmNZX2T61V/T/c2b9
	rbNk3/UB4Wn2yn1F7jNhrN2l4lYfKdZlaZ/u3AK9cSykEBvTrkRrd9zV00NUnQJDAyrRl4Rb8ig
	jjJdZnQ==
X-Received: from pjbso3.prod.google.com ([2002:a17:90b:1f83:b0:33b:c211:1fa9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d603:b0:34e:7938:669c
 with SMTP id 98e67ed59e1d1-353feda725cmr6069000a91.25.1769649397968; Wed, 28
 Jan 2026 17:16:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:09 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-38-seanjc@google.com>
Subject: [RFC PATCH v5 37/45] KVM: x86/tdp_mmu: Alloc external_spt page for
 mirror page table splitting
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69488-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 0CDBDAAC17
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Enhance tdp_mmu_alloc_sp_for_split() to allocate a page table page for the
external page table for splitting the mirror page table.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: use kvm_x86_ops.alloc_external_sp()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3b0da898824a..4f5b80f0ca03 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1447,7 +1447,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct tdp_iter *iter)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1461,6 +1461,15 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
 		return NULL;
 	}
 
+	if (is_mirror_sptep(iter->sptep)) {
+		sp->external_spt = (void *)kvm_x86_call(alloc_external_sp)(GFP_KERNEL_ACCOUNT);
+		if (!sp->external_spt) {
+			free_page((unsigned long)sp->spt);
+			kmem_cache_free(mmu_page_header_cache, sp);
+			return NULL;
+		}
+	}
+
 	return sp;
 }
 
@@ -1540,7 +1549,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			else
 				write_unlock(&kvm->mmu_lock);
 
-			sp = tdp_mmu_alloc_sp_for_split();
+			sp = tdp_mmu_alloc_sp_for_split(&iter);
 
 			if (shared)
 				read_lock(&kvm->mmu_lock);
-- 
2.53.0.rc1.217.geba53bf80e-goog


