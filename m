Return-Path: <kvm+bounces-68758-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFTxBvkZcWmodQAAu9opvQ
	(envelope-from <kvm+bounces-68758-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:24:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D502F5B39E
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:24:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 06EFA84C53D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A1D30BF75;
	Wed, 21 Jan 2026 17:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GncHZifM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE03931D372
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769016634; cv=none; b=kLi4yc+WZSwNHq4a1KCKO2bHZMuVdAZ1/RdSddgIkYk/RPpnKoyTfO1TIS2pAvIIbUAZ8J9s6djigIQLqerx4Tr9FXG/eLOuvq5nVfq3cF6K9yBvvfEKvWl5lKxOXTkkKWMrFSrc/FdbCRztRaQ3ksZKocArsdLUOqGywG2W3F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769016634; c=relaxed/simple;
	bh=Qoafun8TPUoF50Bl0CtUH0N1SSM5uiL5PWVSwhhsa98=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HAFzl58juFW/z0/w6tuaaDdQYDZ2PFIxKfYuFOdORqX3Am0+dJcAj537rJ6tglgUOf9xmLOkQXMKBIbtckQvJD8ENe/8fQqwL3ZaBtuCkdJsxh+/84U7iZw175L5Jjs8QyQuBSdo6uHwDrZvudbcvTnwRKII0Zzbcp2c9YTIWJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GncHZifM; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a7701b6328so1118535ad.2
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 09:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769016630; x=1769621430; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zRsUd6Xf2ozPGKhI88Ak/EIDsiU/pGPTJfbBTKTczlo=;
        b=GncHZifMFjE05Iw1Q1jmMemX+HXtbfNzEn2+yOjflYzuPSWjJ6orsks1OzrDjHToEm
         YkCK/A8JL0jfBa8qOqzcyc21BqhelLSEoRJQMjB8T1uolFiDJMIy+0YwOVDmnfHoa4Mr
         sbeGAhollcI5XaYNSM3dgN6pxTe0NmYjCavSQh4sK8mrMJ+EXAWkSiLcGVUu97u0XiB6
         IDO1tc6IP+IZ8OxRayTWtbX8GU+KQg4EQpPH51dgX79Whf8ZevSqomfgYQsGTRqFUhLC
         SPorHyrs9JaWv8l1HDsHrT02zEjyaCpqYWkjHyXmcybrB6+xWtoDFGj+TLFOSXZttaJS
         udbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769016630; x=1769621430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zRsUd6Xf2ozPGKhI88Ak/EIDsiU/pGPTJfbBTKTczlo=;
        b=oGJn4lYIacPMH3CfSy+Hf5tj9ROG99Kh3/yfoAsshOiGY6dXEP8HPHkJPN+kziuZLH
         JRc2N6/nb0n87VVG3vVSsvUj1zWUDfFrjNUcevDdF9RGmwoBjt/TGJzpToQfITVeQrrv
         2b0uUB9GJ4Hu1xLIaQDLS6NZlJlmfg1+3j4A/Q4NogaL/cTC0h+wzeGgbKFtKlE/+1pe
         oSxqMaCrulxKZGRaMAO1PcOKAaRCzfLLoFvO7R5TrtroBXF1vItpYqXv1doN6Mor7RFR
         atX5w+HIAfIp/SFS0w0Ir4PolERaD6//8rKqBu5LoF9hST/chyPZIj/v5wUraLt1Ji9i
         HXuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlK4eVN5vL+kPflRPm1b06QB961JdayfxfW5sITR20COfmKoRTVcC41MPYqs9aLOhmxK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbJNALRmX0CEdNZsqLS1R1uPG5WWl7kuOAlsUkRU22Vg94xNf9
	+oLdPc9IiH06JcAeUR3RRqHClWl6D2LJIax13f+MbH3R+8NIM2s03lQLQbqASMtb/nOmzzJKu5f
	1d9DVPw==
X-Received: from plpa6.prod.google.com ([2002:a17:902:9006:b0:2a0:e952:ed65])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b25:b0:295:9e4e:4092
 with SMTP id d9443c01a7336-2a76b1696c2mr49823155ad.56.1769016629985; Wed, 21
 Jan 2026 09:30:29 -0800 (PST)
Date: Wed, 21 Jan 2026 09:30:28 -0800
In-Reply-To: <b9487eba19c134c1801a536945e8ae57ea93032f.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102331.25244-1-yan.y.zhao@intel.com>
 <b9487eba19c134c1801a536945e8ae57ea93032f.camel@intel.com>
Message-ID: <aXENNKjAKTM9UJNH@google.com>
Subject: Re: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for splitting
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fan Du <fan.du@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>, 
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Chao P Peng <chao.p.peng@intel.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Jun Miao <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spamd-Result: default: False [0.04 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,intel.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,linux.intel.com,suse.com,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[29];
	TAGGED_FROM(0.00)[bounces-68758-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: D502F5B39E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026, Kai Huang wrote:
> On Tue, 2026-01-06 at 18:23 +0800, Yan Zhao wrote:
> I have been thinking whether we can simplify the solution, not only just
> for avoiding this complicated memory cache topup-then-consume mechanism
> under MMU read lock, but also for avoiding kinda duplicated code about how
> to calculate how many DPAMT pages needed to topup etc between your next
> patch and similar code in DPAMT series for the per-vCPU cache.
> 
> IIRC, the per-VM DPAMT cache (in your next patch) covers both S-EPT pages
> and the mapped 2M range when splitting.
> 
> - For S-EPT pages, they are _ALWAYS_ 4K, so we can actually use
> tdx_alloc_page() directly which also handles DPAMT pages internally.
> 
> Here in tdp_mmmu_alloc_sp_for_split():
> 
> 	sp->external_spt = tdx_alloc_page();
> 
> For the fault path we need to use the normal 'kvm_mmu_memory_cache' but
> that's per-vCPU cache which doesn't have the pain of per-VM cache.  As I
> mentioned in v3, I believe we can also hook to use tdx_alloc_page() if we
> add two new obj_alloc()/free() callback to 'kvm_mmu_memory_cache':
> 
> https://lore.kernel.org/kvm/9e72261602bdab914cf7ff6f7cb921e35385136e.camel@intel.com/
> 
> So we can get rid of the per-VM DPAMT cache for S-EPT pages.
> 
> - For DPAMT pages for the TDX guest private memory, I think we can also
> get rid of the per-VM DPAMT cache if we use 'kvm_mmu_page' to carry the
> needed DPAMT pages:
> 
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -111,6 +111,7 @@ struct kvm_mmu_page {
>                  * Passed to TDX module, not accessed by KVM.
>                  */
>                 void *external_spt;
> +               void *leaf_level_private;
>         };

There's no need to put this in with external_spt, we could throw it in a new union
with unsync_child_bitmap (TDP MMU can't have unsync children).  IIRC, the main
reason I've never suggested unionizing unsync_child_bitmap is that overloading
the bitmap would risk corruption if KVM ever marked a TDP MMU page as unsync, but
that's easy enough to guard against:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3d568512201d..d6c6768c1f50 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1917,9 +1917,10 @@ static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 
 static void mark_unsync(u64 *spte)
 {
-       struct kvm_mmu_page *sp;
+       struct kvm_mmu_page *sp = sptep_to_sp(spte);
 
-       sp = sptep_to_sp(spte);
+       if (WARN_ON_ONCE(is_tdp_mmu_page(sp)))
+               return;
        if (__test_and_set_bit(spte_index(spte), sp->unsync_child_bitmap))
                return;
        if (sp->unsync_children++)


I might send a patch to do that even if we don't overload the bitmap, as a
hardening measure.

> Then we can define a structure which contains DPAMT pages for a given 2M
> range:
> 
> 	struct tdx_dmapt_metadata {
> 		struct page *page1;
> 		struct page *page2;
> 	};
> 
> Then when we allocate sp->external_spt, we can also allocate it for
> leaf_level_private via kvm_x86_ops call when we the 'sp' is actually the
> last level page table.
> 
> In this case, I think we can get rid of the per-VM DPAMT cache?
> 
> For the fault path, similarly, I believe we can use a per-vCPU cache for
> 'struct tdx_dpamt_memtadata' if we utilize the two new obj_alloc()/free()
> hooks.
> 
> The cost is the new 'leaf_level_private' takes additional 8-bytes for non-
> TDX guests even they are never used, but if what I said above is feasible,
> maybe it's worth the cost.
> 
> But it's completely possible that I missed something.  Any thoughts?

I *LOVE* the core idea (seriously, this made my week), though I think we should
take it a step further and _immediately_ do DPAMT maintenance on allocation.
I.e. do tdx_pamt_get() via tdx_alloc_control_page() when KVM tops up the S-EPT
SP cache instead of waiting until KVM links the SP.  Then KVM doesn't need to
track PAMT pages except for memory that is mapped into a guest, and we end up
with better symmetry and more consistency throughout TDX.  E.g. all pages that
KVM allocates and gifts to the TDX-Module will allocated and freed via the same
TDX APIs.

Absolute worst case scenario, KVM allocates 40 (KVM's SP cache capacity) PAMT
entries per-vCPU that end up being free without ever being gifted to the TDX-Module.
But I doubt that will be a problem in practice, because odds are good the adjacent
pages/pfns will already have been consumed, i.e. the "speculative" allocation is
really just bumping the refcount.  And _if_ it's a problem, e.g. results in too
many wasted DPAMT entries, then it's one we can solve in KVM by tuning the cache
capacity to less aggresively allocate DPAMT entries.

I'll send compile-tested v4 for the DPAMT series later today (I think I can get
it out today), as I have other non-trival feedback that I've accumulated when
going through the patches.

