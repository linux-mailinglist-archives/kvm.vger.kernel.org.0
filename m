Return-Path: <kvm+bounces-70444-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eNIHMPX+hWnUIwQAu9opvQ
	(envelope-from <kvm+bounces-70444-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:47:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F44FFF287
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 08FB8301020A
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 14:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCBFC421F15;
	Fri,  6 Feb 2026 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oizlH8Bu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1C04218BE
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770389179; cv=none; b=LC1uF0t9/YPgqMVgzjXeUdicvUEl+Z6m0Xmf2nl+dosPvzD3PKLLY11cvFj4t3DT28ICFY3kqcJy/9v8vH0CNcqdQiuMCnO2pLJ3nVr3XWgzhmLn0WVQ5Yz4/IL8YuoHWl4+85x9vEaBnO5L9JMiqHuItS7uGkhDT+oCHttZK4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770389179; c=relaxed/simple;
	bh=Z+6pMsVne8koEollpw2BnyiblSLa1jaNRfnGAaiwAJE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BNxdUlJiPWI78+uu06F57eP0FLNFkNLHmiE/JGsfFYKptEHyfh7kJcq4VQe1ClHBMKeiPOUB4MtzFM81FvRTbSl4lUjs+KX2yNIdL1hGWlYiEg3UK0W9U4KMyfEzB3QFCRUiEvB5GECMNSlniE1LEL7NUGLTUiKIZ1jLRubYD74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oizlH8Bu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352ec74a925so4231376a91.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 06:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770389178; x=1770993978; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fWVMjsX7lzriNU4H/gh4s77Y7csX7rcHx58QQQuHKyI=;
        b=oizlH8Bu/phQ5zbdddMz5k+Tz3wTh1gdZckdW+NLPCmRbX7hn2tJDywGSTI75TGxhT
         eety7SsmEyy92dkPzs4nUrz5+jn+6+E1Br4eBX2igyqL5AK2GLhTk/8stM7Zktg5ysOp
         YpeR6DntcinyR9RFiEE1GPjrioY4o0NTT6nXZj64U9SZgkMFsJzq4FxEnxDVGdrJRJsb
         AMkqGXF3h6b6W6EHPmjfFAm1np2w+MqCFwxNFC1w+Ik9Q4AUrdH4v3zCHjj48wMYYv4R
         9pd6bF6FaRKWpywyVvJaX5n0QA8KP4OHvteH1UUdGrobk8UAM6WBVNahX3Jr0sf/V1Cx
         XvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770389178; x=1770993978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fWVMjsX7lzriNU4H/gh4s77Y7csX7rcHx58QQQuHKyI=;
        b=W4Z0FLk4nc9CzeYOKdJYK/2uUuuERzD0D6yXKQMHzvaQWB9oSqcdHBxXSkU+giixjL
         KN5ucN2UHNu8d/w0QTGuG3URnGmLAZ2aUGZgCbb7xrzE4lAAJ9tOBAtT7Uojo/RB3NcB
         pbAKfHM14UVbpT3WlTUPnLfkLOqVRcTMEDlvdeo6z4V6oQQQZBrjJ5kTVGg6ZPbZ4qzu
         x89TBrfrusDelSLhoCnQU2HhfGDsrbuIAKZTdjlEzYGhRyxbcEK4xEEBu3exkDZgnqJQ
         Do9wYv+85jHHtQ2V6Lj/Fri2ksTXKgy8fHSEiL0FBMiB73VeuLhd5U7oSKxKeUCncf0j
         isAw==
X-Forwarded-Encrypted: i=1; AJvYcCXIsJbz1pwneLzyqc/UfwpJXn91jFyMO8CCnjR+9f6MWtIS8XUJy8sYMMRVK0KawqNfN7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDHnmKim9uAmeLSicLwlEq3oig9X21WoY2ZIfA2YGOxF4oWrg5
	D+TP3vkLsQ6o6N5usyppPlL1VKCGvD3zYUArsKKig26dVJSZwbWDWQDqawgVzCk1XYfsqWe+MKw
	R8SD3cw==
X-Received: from pgbcr4.prod.google.com ([2002:a05:6a02:4104:b0:c65:be00:c5c6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6e43:b0:38e:9e55:6dee
 with SMTP id adf61e73a8af0-393ad3a12c3mr3152790637.57.1770389178229; Fri, 06
 Feb 2026 06:46:18 -0800 (PST)
Date: Fri, 6 Feb 2026 06:46:16 -0800
In-Reply-To: <aYW+6WzOmCAvNRIH@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-45-seanjc@google.com>
 <aYW+6WzOmCAvNRIH@yzhao56-desk.sh.intel.com>
Message-ID: <aYX-RpxDYrI65XRC@google.com>
Subject: Re: [RFC PATCH v5 44/45] KVM: x86/mmu: Add support for splitting
 S-EPT hugepages on conversion
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70444-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2F44FFF287
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yan Zhao wrote:
> On Wed, Jan 28, 2026 at 05:15:16PM -0800, Sean Christopherson wrote:
> > Add support for splitting S-EPT hugepages in preparation for converting a
> > subset of a hugepage to be shared, as KVM must precisely zap/remove S-EPT
> > entries to avoid clobbering guest memory (the lifetime of guest private
> > memory is tied to the S-EPT).  I.e. KVM needs to first split a hugepage so
> > that only the to-be-converted small pages can be zapped.
> > 
> > To avoid unnecessary work, e.g. if only the tail/end page of massive region
> > isn't aligned to the conversion, explicitly detect unaligned head and tail
> > pages relative to the max page size support by KVM, i.e. head/tail pages
> > that will undergo partial conversion.
> > 
> > To support splitting an S-EPT hugepage without a vCPU, add a per-VM PAMT
> > cache, along with a mutex to guard the cache.  Using a mutex, e.g. versus
> > a spinlock, is important at it allows KVM to allocate memory *without*
> > dropping the lock, i.e. so that the PAMT cache can be topped-up as needed
> > without needed to juggle arch.tdp_mmu_external_cache_lock.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  8 +++-
> >  arch/x86/kvm/mmu/mmu.c          |  2 +-
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 72 +++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/vmx/tdx.c          | 34 +++++++++++++---
> >  arch/x86/kvm/vmx/tdx.h          |  2 +
> >  5 files changed, 107 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 385f1cf32d70..54dea90a53dc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1563,6 +1563,12 @@ struct kvm_arch {
> >  	 * the code to do so.
> >  	 */
> >  	spinlock_t tdp_mmu_pages_lock;
> > +
> > +	/*
> > +	 * Protect the per-VM cache of pre-allocate pages used to populate the
> > +	 * Dynamic PAMT when splitting S-EPT huge pages without a vCPU.
> > +	 */
> > +	struct mutex tdp_mmu_external_cache_lock;
> Missing "spin_lock_init(&kvm->arch.tdp_mmu_external_cache_lock);" in
> kvm_mmu_init_tdp_mmu().
> 
> Will check the patch you replied next week.

It has the same bug.  FWIW, I found and fixed the bug on our internal branch, but I
either missed the fixup when synchronizing back to the upstream branch, or I found
the issue after posting.

@@ -634,6 +642,7 @@ int tdx_vm_init(struct kvm *kvm)
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
        tdx_init_pamt_cache(&kvm_tdx->pamt_cache);
+       mutex_init(&kvm_tdx->pamt_cache_lock);
 
        kvm->arch.has_protected_state = true;
        /*

