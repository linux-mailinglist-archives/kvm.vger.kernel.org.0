Return-Path: <kvm+bounces-70137-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +Lu5LUqsgmnYXwMAu9opvQ
	(envelope-from <kvm+bounces-70137-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 03:17:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 136CBE0C27
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 03:17:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F1DA230523E8
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 02:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2073281530;
	Wed,  4 Feb 2026 02:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ChHHwlDE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6E1255F28
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 02:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770171376; cv=none; b=Lun8c9T01MIlwLKMvx54jC0FN2IiFKK5l6sz204PIAqFV9/+/o31M3SuPKZj5g/20jl6cN5hbERBKIDVhBHfLcKvplk7QrP2YGKZslvHOs76wYw93dpUQ8jEGTKIvccLQ/jSnEea/w+5Nx0jHtzOEDMOP8ZIJ0YgbvN1u6lQfro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770171376; c=relaxed/simple;
	bh=Sf5jVo4PBZ8D8xrb/7N0ZgU5WeJfHYchhsPy0/JAdI4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ozg5+ZV3eTtaokS9LQC5BadrFYVb7cLf0fMus3HLNDcDxFMat2Iu/rAUTCabV15J6Sgn03r8gE4YYQP6Tfa4dKJT8ptDjQjUraJlk1JbUcTTT6tzvL+q7SigFWC0WtBFQ+YohqVRzu4Bel76gBvVzkfJqCQ1D3zqAe2urJpeRbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ChHHwlDE; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c61dee98720so3756087a12.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 18:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770171375; x=1770776175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Mow+gtTd3xBrxz7PLLvBC7PjYT0zAewqKSEgx5mE5o=;
        b=ChHHwlDEldl+UDoXqdEHz5FyY9JUa6GafFosM39ISyfXmwT59fEqVi975duGyGPl9x
         KLKzvz3O7WXMuaNK9dDRgYH2VyuqfjtiQ5PHEsxbIxpIFVTQCiH8Haj4PolLM4cRzVUt
         37vhik7dfqhOSy80yZuxiKDI3XsxgAtkbjVMRebu6jM6kUao8hEFBHCghNoCxTEsbaqs
         LQ1rawcACZzhaCdLgFl5E9xGeoweg1XVPzjlnyPF/MoVdtdb3tz+9D8dq2qq2b/dF3IM
         Yq7zj3eoLFH/ulCDYkwFWtvsTPXqTPPxbHYBw/UyWy7gh1I+CBp4cK94MxqyadnuB6j0
         DnaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770171375; x=1770776175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Mow+gtTd3xBrxz7PLLvBC7PjYT0zAewqKSEgx5mE5o=;
        b=cLhw7K/cRDHlaewJ99VBJNHvNopB9hx5D3XSwTQ7qXjCMqS/7o+egSmis1ZEmTF0Qw
         rZoN+5Y+nDzH5g5FBmQN8YXoYkScStIBTfL5vua1VZhNXv0Z6hXwfUsl4xktwKqgAKQo
         ROcswOVF6cfx61LqqmOImAbUmnehS6BSBcdv7CHqe+BRm1aLHxl7re9FKOVuBwl8B4Vz
         nUDlWnt7aamhKfIlrNEWXjJ161R2B+jwoG7aM/EyXIcvLikwX3I2M5CzGpns7/ZvuAa3
         lwlnbXrT1TsHrPOvPJU9ATjs4//SX55OtvGE2UFHq8+q6KXSrhXO7NOd1Q5mVKlyikQT
         kDnw==
X-Gm-Message-State: AOJu0YxOkUO6S06bV9yYxzkp5bEX8q7Kq8ViA5fJf5U9tk+7KlaH9Bwa
	2dGm0cNV8orWSZpe2RB49srzWv7LzKoILpKy1z/QoJy6yP2BQRoa2FEHDzGBBzsG0qmKm9+P0Rr
	x0emSAQ==
X-Received: from pgan187.prod.google.com ([2002:a63:40c4:0:b0:c51:8b09:2a32])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:6682:b0:38d:e87c:48c2
 with SMTP id adf61e73a8af0-39372498707mr1358827637.58.1770171374750; Tue, 03
 Feb 2026 18:16:14 -0800 (PST)
Date: Tue, 3 Feb 2026 18:16:13 -0800
In-Reply-To: <a2bf6a8d9f9b61ae7264afc37d9925cf2e1f3ea9.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-20-seanjc@google.com>
 <de05853257e9cc66998101943f78a4b7e6e3d741.camel@intel.com>
 <aYJWvKagesT3FPfI@google.com> <a2bf6a8d9f9b61ae7264afc37d9925cf2e1f3ea9.camel@intel.com>
Message-ID: <aYKr7XODY-p6YLYa@google.com>
Subject: Re: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	Vishal Annapurve <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70137-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 136CBE0C27
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Kai Huang wrote:
> On Tue, 2026-02-03 at 12:12 -0800, Sean Christopherson wrote:
> > On Tue, Feb 03, 2026, Kai Huang wrote:
> > > On Wed, 2026-01-28 at 17:14 -0800, Sean Christopherson wrote:
> > > > Extend "struct kvm_mmu_memory_cache" to support a custom page allocator
> > > > so that x86's TDX can update per-page metadata on allocation and free().
> > > > 
> > > > Name the allocator page_get() to align with __get_free_page(), e.g. to
> > > > communicate that it returns an "unsigned long", not a "struct page", and
> > > > to avoid collisions with macros, e.g. with alloc_page.
> > > > 
> > > > Suggested-by: Kai Huang <kai.huang@intel.com>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > 
> > > I thought it could be more generic for allocating an object, but not just a
> > > page.
> > > 
> > > E.g., I thought we might be able to use it to allocate a structure which has
> > > "pair of DPAMT pages" so it could be assigned to 'struct kvm_mmu_page'.  But
> > > it seems you abandoned this idea.  May I ask why?  Just want to understand
> > > the reasoning here.
> > 
> > Because that requires more complexity and there's no known use case, and I don't
> > see an obvious way for a use case to come along.  All of the motiviations for a
> > custom allocation scheme that I can think of apply only to full pages, or fit
> > nicely in a kmem_cache.
> > 
> > Specifically, the "cache" logic is already bifurcated between "kmem_cache' and
> > "page" usage.  Further splitting the "page" case doesn't require modifications to
> > the "kmem_cache" case, whereas providing a fully generic solution would require
> > additional changes, e.g. to handle this code:
> > 
> > 	page = (void *)__get_free_page(gfp_flags);
> > 	if (page && mc->init_value)
> > 		memset64(page, mc->init_value, PAGE_SIZE / sizeof(u64));
> > 
> > It certainly wouldn't be much complexity, but this code is already a bit awkward,
> > so I don't think it makes sense to add support for something that will probably
> > never be used.
> 
> For this particular piece of code, we can add a helper for allocating normal
> page table pages, get rid of mc->init_value completely and hook mc-page_get()
> to that helper.

Hmm, I like the idea, but I don't think it would be a net positive.  In practice,
x86's "normal" page tables stop being normal, because KVM now initializes all
SPTEs with BIT(63)=1 on x86-64.  And that would also incur an extra RETPOLINE on
all those allocations.

> A bonus is we can then call that helper in all places when KVM needs to
> allocate a page for normal page table instead of just calling
> get_zerod_pages() directly, e.g., like the one in
> tdp_mmu_alloc_sp_for_split(),

Huh.  Actually, that's a bug, but not the one you probably expect.  At a glance,
it looks like KVM incorrectly zeroing the page instead of initializing it with
SHADOW_NONPRESENT_VALUE.  But it's actually a "performance" bug, because KVM
doesn't actually need to pre-initialize the page: either the page will never be
used, or every SPTE will be initialized as a child SPTE.

So that one _should_ be different, e.g. should be:

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a32192c35099..36afd67601fc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1456,7 +1456,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
        if (!sp)
                return NULL;
 
-       sp->spt = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+       sp->spt = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
        if (!sp->spt)
                goto err_spt;
 
> so that we can have a consistent way for allocating normal page table pages.

