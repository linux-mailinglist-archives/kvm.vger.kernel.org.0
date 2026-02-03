Return-Path: <kvm+bounces-70078-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oM6HOwJVgmntSQMAu9opvQ
	(envelope-from <kvm+bounces-70078-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:05:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDEBDE582
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:05:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F350D300BEB1
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 20:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C60B369235;
	Tue,  3 Feb 2026 20:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BYNhFPLR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE46325497
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 20:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770149109; cv=none; b=hJ0aIQcP2E8qJKVmURWJ3uEthCrFnSLN9hd5WafQiSAp66ttzoxfNXPBz4HeCsXaSw2eNmlPaOQYiRiRpAA5o4q7fA66HF2IpRNwHkhIeYpm+6TVeaH971M7diuO62rGdwT5I9CIbWU0qCjd6mrDQWjJBR7+lB/5e/7lkszFnaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770149109; c=relaxed/simple;
	bh=27o1wKuHEcNlANVMdC7x0Trddiu/F8hRGySQRl5se5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TlQPH+XrpLAZtyJMs2AYk8Q/thUxVGkQ52g202UsuBgKFWihNNOXMPQ1gQeVhF11JmsF+W0uIErznh1TJTgZ1lVOxAjEUX1GmK40kHumDfKXHfYIFyP5MiCvHsJgCV3JZHAfNG8du/MYDBEu42K2h2s+XIDtLw0Od9QUDExzEGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BYNhFPLR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35301003062so14472298a91.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 12:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770149106; x=1770753906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MTkxDSMkaltlyd44nQIL0k0Ugq+OLZ5pVW5UzVf+elM=;
        b=BYNhFPLRM5K3OMYT8t1iSSW2KcfUKLI88Wo2nn2QcB+EiJMkWB9VoF6Q0OXOVrMwot
         RfA5XM6zPYEPJgU4WOeT2cDOPwkFiKa3hGIglXdt64qAjs6y/kyKmH9o3vT0dljreIit
         Iw+0+XHbTqcrRSbD2fzrFd509Z+Ox+ZPOhDbDpTFrzUUteRKjdIEKEju7nNiCJaH2XZH
         8vF1WRWujIchbqS/VeOhRRoQlWAhQO0wA8uQ8zlDOQT9o87mhj1PhVh7qO2l3LcWSpBl
         WKcvQwx7dvVo2I30kRSY0wP3Cw0t9/hRCmqE+TdRgeGGx7gSMhl1tuLmGUq8wzvHjw7j
         avhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770149106; x=1770753906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MTkxDSMkaltlyd44nQIL0k0Ugq+OLZ5pVW5UzVf+elM=;
        b=S+RaJJBTAm7agjaJM4BgcTBCXZTMkRyIi7mItxaQRP0lx5DUZbTaiQ9zbJarBwNrVf
         cBwi3cqpkQ8bVuotMIJeK9nk0RIgECNny9k0RFztBh0fXjpIsPnfFPhCsxBj5KPcPQoR
         8n/APgnoMvgYguso5uCwXAw5V6Qb6z49lo6QkjVduUNX4LINrgNbrbd912N3UtqTNMxW
         NGzumIevPIVxA5oWMCOcdY38srioipooVPF4FFpa8kSRRhGiqKs8G6lZiKrbrCgrs3wK
         5/PVKUQnXt4VOI0trbFUIKyPz2GZ/PkI/YA8hlbhspmw7X0U9ahQ13tWAUZpP2qx1/+o
         JaAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRMKz8yYOikyhPB8j27EJ7j084LIdiN2WOgEQRnGJ99ysNT15JSqyHDBqjk39D2D8OoXA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNUUy8h71qH4eGOmoIB+Zk+qwzA8IpDLkPaA7rSQKz0f2FOvly
	qOOELAc3lQ3NBgS72Cir5Rmi5QU/vXDcy9p2lfQmHx+HFXNXFFU9fBvT1zMLu0+75IVRK4b+Tua
	tSt0xaQ==
X-Received: from pjsg5.prod.google.com ([2002:a17:90a:7145:b0:352:d19a:6739])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2242:b0:338:3d07:5174
 with SMTP id 98e67ed59e1d1-354870aad4dmr367163a91.5.1770149106374; Tue, 03
 Feb 2026 12:05:06 -0800 (PST)
Date: Tue, 3 Feb 2026 20:05:05 +0000
In-Reply-To: <aYHLlTPeo2fzh02y@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-6-seanjc@google.com>
 <aYHLlTPeo2fzh02y@yzhao56-desk.sh.intel.com>
Message-ID: <aYJU8Som706YkIEO@google.com>
Subject: Re: [RFC PATCH v5 05/45] KVM: TDX: Drop kvm_x86_ops.link_external_spt(),
 use .set_external_spte() for all
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70078-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1EDEBDE582
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Yan Zhao wrote:
> On Wed, Jan 28, 2026 at 05:14:37PM -0800, Sean Christopherson wrote:
> >  static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
> >  						 gfn_t gfn, u64 *old_spte,
> >  						 u64 new_spte, int level)
> >  {
> > -	bool was_present = is_shadow_present_pte(*old_spte);
> > -	bool is_present = is_shadow_present_pte(new_spte);
> > -	bool is_leaf = is_present && is_last_spte(new_spte, level);
> > -	int ret = 0;
> > -
> > -	KVM_BUG_ON(was_present, kvm);
> > +	int ret;
> >  
> >  	lockdep_assert_held(&kvm->mmu_lock);
> > +
> > +	if (KVM_BUG_ON(is_shadow_present_pte(*old_spte), kvm))
> > +		return -EIO;
> Why not move this check of is_shadow_present_pte() to tdx_sept_set_private_spte()
> as well? 

The series gets there eventually, but as of this commit, @old_spte isn't plumbed
into tdx_sept_set_private_spte().

> Or also check !is_shadow_present_pte(new_spte) in TDP MMU?

Not sure I understand this suggestion.
   	
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 5688c77616e3..30494f9ceb31 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1664,18 +1664,58 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> >  	return 0;
> >  }
> >  
> > +static struct page *tdx_spte_to_external_spt(struct kvm *kvm, gfn_t gfn,
> > +					     u64 new_spte, enum pg_level level)
> > +{
> > +	struct kvm_mmu_page *sp = spte_to_child_sp(new_spte);
> > +
> > +	if (KVM_BUG_ON(!sp->external_spt, kvm) ||
> > +	    KVM_BUG_ON(sp->role.level + 1 != level, kvm) ||
> > +	    KVM_BUG_ON(sp->gfn != gfn, kvm))
> > +		return NULL;
> Could we remove the KVM_BUG_ON()s, and ...
> 
> > +	return virt_to_page(sp->external_spt);
> > +}
> > +
> > +static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> > +				     enum pg_level level, u64 mirror_spte)
> > +{
> > +	gpa_t gpa = gfn_to_gpa(gfn);
> > +	u64 err, entry, level_state;
> > +	struct page *external_spt;
> > +
> > +	external_spt = tdx_spte_to_external_spt(kvm, gfn, mirror_spte, level);
> > +	if (!external_spt)
> add a KVM_BUG_ON() here?
> It could save KVM_BUG_ON()s and have KVM_BUG_ON() match -EIO :)

We could, but I don't want to, because if we're going to bother with sanity checks,
I want the resulting WARNs to be precise.  I.e. I want the WARN to capture *why*
tdx_spte_to_external_spt() failed, to make debug/triage easier.

> And as Rick also mentioned, better to remove external in external_spt, e.g.
> something like pt_page.

Yeah, maybe sept_spt?

> And mirror_spte --> new_spte?

Hmm, ya, I made that change later, but it can probably be shifted here.

> > -	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
> > -		     (mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
> > +	WARN_ON_ONCE((mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
> Also check this for tdx_sept_link_private_spt()?

Eh, we could, but I don't think it's necessary.  make_nonleaf_spte() is hardcoded
to set full permissions (and I don't see that changing any time soon), whereas
leaf SPTE protections are much more dynamic.

