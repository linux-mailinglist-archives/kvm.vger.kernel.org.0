Return-Path: <kvm+bounces-70380-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCJxKGYkhWlV9AMAu9opvQ
	(envelope-from <kvm+bounces-70380-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 00:14:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E0BF849A
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 00:14:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92C32301572D
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 23:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9331E33C19E;
	Thu,  5 Feb 2026 23:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fyn09gfv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D5233B6CC
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 23:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770333271; cv=none; b=FxXpE+9u4D/5mWUNO1+Z9mYyH1ojTgGfAbiPAsjZdcfO3vQL2TrE8Gw0h7hfM5Bzuy0B3Mze57QIwYg5Psw1iue3ZHt/P4Z/4NSshPmcNbBTjvsybD2rIPD/y8x4lNL3CaBNlNG0Hj0yS+qXYaiXrji9lmhsiLgtc4QlHTtWc3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770333271; c=relaxed/simple;
	bh=MB9cFztH4tXwlZPY6Vm1wb8szVNgUXQWKPfhBfZqWcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WD0qO+HBfeCrG/SQAS5oxpiffvKrN+gj5e9uPf2b4ZyjmN6yeky77jZvMvYA8mQzTjjfmR0BiWZnKW1sbWe1qM/Up04K9mhTO577AK9EfnTSZuikKgX3YBJ79xGPyvv0JHVgQCT1W4rWr0Q5fqYTU57mMXzANSmlnwAGLNRBxXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fyn09gfv; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c337cde7e40so889428a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 15:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770333271; x=1770938071; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cz1wGDR7P66u5Gzy7fs495/TW9uNtgSB7cp6FfFekc4=;
        b=fyn09gfvA4kFfRrEHlYntmXM9C02og/A+dT8p+t7Zq1O0p8sO1x4hsTp48RCyIs1ES
         tZcfIidmZAHX33rLGqss21YB7tvVvj8694FNFHAVoJxmZML8gDU4Mw3efwg0sCk0EYHs
         k0W/z+ylDShsSMQ5SFWh5daD9x/9Mtv7J0mnSi6OGcMbBlD+4zTMAV88v1ncAAedqxwV
         rVaNpu25OjHzvuHUnJtQAQa6qkqwhhvQUNQuB9Q2U8NLOJ+C3qhYfJ+Li/npZMnHB0b6
         RnILw23IGvo2WksRNwOWDh91oCnY+MuY4Y/EeWAt60OJqrN6uzYgGJwz8T3KeZMQD3/5
         tWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770333271; x=1770938071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cz1wGDR7P66u5Gzy7fs495/TW9uNtgSB7cp6FfFekc4=;
        b=QMeMPa018AhnLSyVP3gNP6HNgP/Cc7Nx4YSB6jEO22F5em6Bz23VV0IcaUPeRS4ftN
         7/HQS10BUXlXoHSRha4EZihiFQTuna7GUYH9biMsEb+k2JiwnEHe1jvf4gYwVX3pvSbv
         PLwJDNkIjiulCJLg8jpCdc4mDEMWCmJASr9V0jP0LyXwWl5XiItWizORpZJQ6fOnT3Gy
         8JGtAUuQbTezqFPfl/0aXeWleYMSrz/HnJtvhFjoXZ/OGcLvLFFLQujnmYQj7AsG71G0
         cgZJJTYB1eruNnD4whXXRJaP1Ruc0YTAfcDd9UaKbEN8n9b8s1ieWTRoZBsQPXh/Cl6Y
         F/pQ==
X-Forwarded-Encrypted: i=1; AJvYcCViKIVNHLV+7b5hU59q2bbumcw0+fSRL46hj5BzSKNAwBPQERtOi2L8uivsYDQkWKmppn8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzms1pD7uclH8j4z60QhJ72AZV1ZrSlJPJZ9iJZjYHRvgyMC3NO
	1r0e7XBlymFP48rKv4b6kEEjVAMXuZ1DT47k0+494Fy8AlX1gs4EvkuquT2/V1LAgziReLafH+R
	LQeC1dQ==
X-Received: from pgbcr9.prod.google.com ([2002:a05:6a02:4109:b0:c08:3dd8:1e39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d12f:b0:38b:d95e:69a9
 with SMTP id adf61e73a8af0-393acf898b1mr720567637.16.1770333270970; Thu, 05
 Feb 2026 15:14:30 -0800 (PST)
Date: Thu, 5 Feb 2026 15:14:29 -0800
In-Reply-To: <aYLqESiqkADxMGf9@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-6-seanjc@google.com>
 <aYHLlTPeo2fzh02y@yzhao56-desk.sh.intel.com> <aYJU8Som706YkIEO@google.com> <aYLqESiqkADxMGf9@yzhao56-desk.sh.intel.com>
Message-ID: <aYUkVRedz9ngwu_1@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70380-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[19];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 06E0BF849A
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Yan Zhao wrote:
> On Tue, Feb 03, 2026 at 08:05:05PM +0000, Sean Christopherson wrote:
> > On Tue, Feb 03, 2026, Yan Zhao wrote:
> > > On Wed, Jan 28, 2026 at 05:14:37PM -0800, Sean Christopherson wrote:
> > > >  static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
> > > >  						 gfn_t gfn, u64 *old_spte,
> > > >  						 u64 new_spte, int level)
> > > >  {
> > > > -	bool was_present = is_shadow_present_pte(*old_spte);
> > > > -	bool is_present = is_shadow_present_pte(new_spte);
> > > > -	bool is_leaf = is_present && is_last_spte(new_spte, level);
> > > > -	int ret = 0;
> > > > -
> > > > -	KVM_BUG_ON(was_present, kvm);
> > > > +	int ret;
> > > >  
> > > >  	lockdep_assert_held(&kvm->mmu_lock);
> > > > +
> > > > +	if (KVM_BUG_ON(is_shadow_present_pte(*old_spte), kvm))
> > > > +		return -EIO;
> > > Why not move this check of is_shadow_present_pte() to tdx_sept_set_private_spte()
> > > as well? 
> > 
> > The series gets there eventually, but as of this commit, @old_spte isn't plumbed
> > into tdx_sept_set_private_spte().
> > 
> > > Or also check !is_shadow_present_pte(new_spte) in TDP MMU?
> > 
> > Not sure I understand this suggestion.
> Sorry. The accurate expression should be 
> "what about moving !is_shadow_present_pte(new_spte) to TDP MMU as well?".

It's already there, in __tdp_mmu_set_spte_atomic():

		/*
		 * KVM doesn't currently support zapping or splitting mirror
		 * SPTEs while holding mmu_lock for read.
		 */
		if (KVM_BUG_ON(is_shadow_present_pte(iter->old_spte), kvm) ||
		    KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
			return -EBUSY;


> > > And as Rick also mentioned, better to remove external in external_spt, e.g.
> > > something like pt_page.
> > 
> > Yeah, maybe sept_spt?
> Hmm, here sept_spt is of type struct page, while sp->spt and sp->external_spt
> represents VA. Not sure if it will cause confusion.

How about sept_pt?

