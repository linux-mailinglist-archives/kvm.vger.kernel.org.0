Return-Path: <kvm+bounces-70377-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sHuKMA4chWkO8gMAu9opvQ
	(envelope-from <kvm+bounces-70377-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 23:39:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 322EDF828F
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 23:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B87E30252B5
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 22:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C54C933A028;
	Thu,  5 Feb 2026 22:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZjUeSYzm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BF83358B0
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770331091; cv=none; b=mIUJeKcZR/Io10AlPreKnyEcoQTsndGdewt79/FKnbYs2U6bKb04OGcoHwqy3xcfCaWSGE5cFwf9VGmil1JQACxstCuIxPCxdc/20wa8BiHVtVPSgAA0LzaPzw5LCkwwHgD70zWfSl4X8553+0wechVco3f/xwlDBD+CPgtS+4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770331091; c=relaxed/simple;
	bh=YHuWLI7vqpaFUVgA48uLnmqh4lvi/ESzazpPvwDrPfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WBk6VOK/8wom4NOmgAZfCA4fpFK9FuL3r2be1wlQ4DQd3hP6geKvuiHX0nNbVz5n2QOOf59/1H1QG3QF+QQjucMGmYC9GyV/f1c4KMqGFb8pdWYAoql0/6GF0hL2416SBdvbK62ctTe7da1P9FxtN1JHJa8Rmx8dbtmjatLmLMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZjUeSYzm; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a94369653aso12719635ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 14:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770331090; x=1770935890; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l7Cxq1heXUBi49e9Wexr9Rtb/4PcjxqgXg/oc/Il7q8=;
        b=ZjUeSYzmm9CY+jC2xOAP4Wk0gtbYmcqA9iWt5foTDR+MUS5ejzrON0tMFv2IR1FUbT
         pHtXYWcm8Ko3IX7KjfuhVtHw5Lx5UGnUrrV62BmkzgIfmEnvIVCSJP2tRVHWE87UWoEi
         xSQWoINfyOb6GNI5KK7u8bQZRFTLiVA57vxK9OPAYss7kws6sg8BOonXgREm4oENKVj/
         J1DZJH4uL3XW2nraGq7QiXerF9tNltp2SYnS0byN0neScNResCUdr0ZCaMWSAY81izRK
         MPjmqBt8ef3KsUDSNMVMGPKjK2IW2dQ/2ZSdhpjqu26S8VS/8Lx4Hz6qpJ7mgsQIYDsR
         pjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770331090; x=1770935890;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l7Cxq1heXUBi49e9Wexr9Rtb/4PcjxqgXg/oc/Il7q8=;
        b=XWjUdNeClEaCwj8jxQ+1/8r3ZVjbU369wERmgeZDBtL+i/jE7O5Fbv04XvrsW1EWrd
         sFRPikKEv7cbYL9vlDOZcvBtW3AgrLFH0iyd8oBrI1PkSke7F63s57wRwR902GkNzFgM
         eM94tmwbbdl9DQlk2VCdbLT9WX37oEzsXfG968NJHqxBR8StyjDikMvGnMOK+NiLptos
         hyDTYlMLAWTgK3eyscbIiVtTDzqfUS1efu4AgcOPHUJuMHqs+RoiKaxvQc5s1oftvQaX
         qPhEGaTSh3VWdj4/tLhHwFyn9s6vLT/YE44Bl5hvCnSbPJcsZwFfwOFdMDQZ4rSvQfIi
         4B8g==
X-Forwarded-Encrypted: i=1; AJvYcCXqdk8RP3FODWvt2gCP+0RHYfhKz20XP7vh9AA1yTjGUh7tVzXUioqi9c3/sQaam+cmAyw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7/tFawnZfI2TqtSBLBmVv7UXCMsjxUMxWMi0ba9icKKmyUkft
	BSyeUlaXSaNf/0psNDRkErekzOUq6+/TmX6fECIp9PiOvflF+2XHSUVTwSz0ETK1Vt3YFwMuMgG
	HPzy+AQ==
X-Received: from plkn1.prod.google.com ([2002:a17:902:6a81:b0:2a9:2ce4:2399])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f08:b0:29b:e512:752e
 with SMTP id d9443c01a7336-2a952232dc0mr6704095ad.47.1770331090264; Thu, 05
 Feb 2026 14:38:10 -0800 (PST)
Date: Thu, 5 Feb 2026 14:38:08 -0800
In-Reply-To: <aYRBE1tICOiQ/RL0@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-10-seanjc@google.com>
 <aYMVEX5OO22/Y72/@yzhao56-desk.sh.intel.com> <aYRBE1tICOiQ/RL0@yzhao56-desk.sh.intel.com>
Message-ID: <aYUb0KvJynvYjr3h@google.com>
Subject: Re: [RFC PATCH v5 09/45] KVM: x86: Rework .free_external_spt() into .reclaim_external_sp()
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
	TAGGED_FROM(0.00)[bounces-70377-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 322EDF828F
X-Rspamd-Action: no action

On Thu, Feb 05, 2026, Yan Zhao wrote:
> On Wed, Feb 04, 2026 at 05:45:39PM +0800, Yan Zhao wrote:
> > On Wed, Jan 28, 2026 at 05:14:41PM -0800, Sean Christopherson wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index d12ca0f8a348..b35a07ed11fb 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1858,8 +1858,8 @@ struct kvm_x86_ops {
> > >  				 u64 mirror_spte);
> > >  
> > >  	/* Update external page tables for page table about to be freed. */
> > > -	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > > -				 void *external_spt);
> > > +	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
> > > +				    struct kvm_mmu_page *sp);
> > Do you think "free" is still better than "reclaim" though TDX actually
> > invokes tdx_reclaim_page() to reclaim it on the TDX side?
> > 
> > Naming it free_external_sp can be interpreted as freeing the sp->external_spt
> > externally (vs freeing it in tdp_mmu_free_sp_rcu_callback(). This naming also
> > allows for the future possibility of freeing sp->external_spt before the HKID is
> > freed (though this is unlikely).
> Oh. I found there's a free_external_sp() in patch 20.
> 
> So, maybe reclaim_external_sp() --> remove_external_spt() ?
> 
> Still think "sp" is not good :)

I think my vote would be for reclaim_external_spt().  I don't like "remove", because
similar to "free", I think most readers will assume success is guaranteed.

