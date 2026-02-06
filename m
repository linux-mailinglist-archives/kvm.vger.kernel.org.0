Return-Path: <kvm+bounces-70456-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eOrhC7IRhmk1JgQAu9opvQ
	(envelope-from <kvm+bounces-70456-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 17:07:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C1827100076
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 17:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DAEFF3082DB0
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 16:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB6029E113;
	Fri,  6 Feb 2026 16:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fwISnHxL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFA12DC772
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770393840; cv=none; b=ANGLoXqBq5qJ6WswWvFoI5Bg7bwqJLgywE1fFeLHUlFT94/INkbMjxGS9c1O0DCfIglJ9wa2f0Dm0P0fuRbRCUwp2UAZyxdFvHdIXCtMJuweEAcd1D7LhzfpveDrrHcGmvNB8ohQp14w9vac40zVWVSN/T5rg+KJ2crGtzZOeNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770393840; c=relaxed/simple;
	bh=3raR9XQBcm6pX1dp9l802LPULeByXkutMSrcWOv542Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RroaUwuK+mpbAxAnD8DzYibhvJR1rhJWC8qAhkz8eLSJBYlt7BJcJee0REbPFatNrRNne/biVOGw9TKKTCWaHVUelmx7vUUX7RK0avcvqdhMBhXSdMyTdie+yqr+p8MRWJ2qvw+W02HxJurhOzxfreurUN4KlJpiU2sx54LWa7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fwISnHxL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6097ca315bso4621095a12.3
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 08:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770393839; x=1770998639; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6W5ywYYSvCRSPwqFTbeco0aLvB9nOdCSyf5b4W1ZEGc=;
        b=fwISnHxLUHvTJxXPPImFixXw/KAxi7FQo0otgOhlgSXwvyd9QUn0x81chIcWRTHC1z
         im6Jr8ulBYBMS6Gs3cBBMjhqSxL0RMXN11CijNs13K1rKvJZQXbnpS+ylcsjkyFYfnqg
         i+rcK+n/nsPvKE9TUG908/DhEo/VfC52Dk7AlTuMYwrT0pdkd1DsmEkePzP/KJC+tSfw
         4YfJAgd9xboRoOSOd05FVpB+1JI+yU+fKn3BAgXoKS4UY8dAUQ0mjwvLUzfZYI//Ruqg
         r39v9Jpim1VdwuDQVgaRhWCaO8/D45Du3ozhLL1jznY13SsNStKNsXzarkGgVPRyroAk
         ruNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770393839; x=1770998639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6W5ywYYSvCRSPwqFTbeco0aLvB9nOdCSyf5b4W1ZEGc=;
        b=Ghl89PZSgxsN3itaBLsnJS7r326Dk7lOb4Vvniy66IJjovwqVHckydWmuIA3mw5Gg5
         WqYTxFAfbxYA9Enfknj3EsLNWbqOuDBynicxn2KMiZKYsrYYJhbMH1bli1N/AZY3JNYQ
         0C4X8bQEWbECf9Qks+eBP5zTdqB5TSS2KlYY3TS5IVG4MvmlhnwwS7djzyS8876Xx8vP
         tULekdyksT+lfFWb6MpIbf96J9gnKb3Bslxw4CnNyrwgwpIszoWHNAiMvLFDgeyT45rE
         pxVH/gFxYgtboqx9SIChjPJs8k1v4vU5rBNVyBvPfoVOzlWen9KS9+NUqRjbWdzG/GMF
         Z6rA==
X-Forwarded-Encrypted: i=1; AJvYcCWyOm+npoxb+6cH94N2BEpQ/7dTRGxJFj7D2riiQzyS6FAeqd0ZVOYPtlE/IPBk9is9weM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY2bfgdDrs8Bf986AsjKzBrMAvRcfbb1wa0ztQiTUcpQZXm//x
	OPMCgbBwOn3b71y9/ieYRQfNg6ZmjrFhWXGZ0egtH82BaIgkxWADvBKFNqNyDcUeH05N/S5Qyqg
	bQMg/bQ==
X-Received: from pjbss7.prod.google.com ([2002:a17:90b:2ec7:b0:34c:37db:8f1b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3290:b0:393:8afb:3559
 with SMTP id adf61e73a8af0-393ad0265a9mr3268415637.32.1770393839552; Fri, 06
 Feb 2026 08:03:59 -0800 (PST)
Date: Fri, 6 Feb 2026 08:03:57 -0800
In-Reply-To: <aYXAdJV8rvWn4EQf@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-23-seanjc@google.com>
 <aYXAdJV8rvWn4EQf@yzhao56-desk.sh.intel.com>
Message-ID: <aYYQ7Vx95ZrsqwCv@google.com>
Subject: Re: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70456-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C1827100076
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yan Zhao wrote:
> On Wed, Jan 28, 2026 at 05:14:54PM -0800, Sean Christopherson wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 6e84dbc89e79..a6e4ab76b1b2 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1863,6 +1863,7 @@ struct kvm_x86_ops {
> >  				    struct kvm_mmu_page *sp);
> >  	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> >  				     u64 mirror_spte);
> > +	int (*topup_external_cache)(struct kvm_vcpu *vcpu, int min);
> >  
> >  
> >  	bool (*has_wbinvd_exit)(void);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 9b5a6861e2a4..4ecbf216d96f 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -605,6 +605,10 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> >  					       PT64_ROOT_MAX_LEVEL);
> >  		if (r)
> >  			return r;
> > +
> > +		r = kvm_x86_call(topup_external_cache)(vcpu, PT64_ROOT_MAX_LEVEL);
> If this external cache is for PAMT pages allocation for guest pages only, here
> the min count should be 1 instead of PT64_ROOT_MAX_LEVEL?

Oh!  Right.  Hmm, with that in mind, it seems like topup_external_cache() isn't
quite the right interace.  It's not at all clear that, unlike the other caches,
the DPAMT cache isn't tied to the page tables, it's tied to the physical memory
being mapped into the guest.

At the very least, it seems like we should drop the @min parameter?

	int (*topup_external_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu);

Though if someone has a name that better captures what the cache is used for,
without bleeding too many details into common x86...

