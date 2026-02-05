Return-Path: <kvm+bounces-70379-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mGlxGacihWnM8wMAu9opvQ
	(envelope-from <kvm+bounces-70379-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 00:07:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BA3EBF8444
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 00:07:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCFF030160CF
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 23:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9291033BBC4;
	Thu,  5 Feb 2026 23:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QjhdXP3e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69A732A3FD
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 23:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770332816; cv=none; b=QINWJ2yr8J2HSv2qAdRo4AnOCoFqKtUKdO4QgqIC80E+tn0dXugX61bV7VsmObVsr+ksTHcRAPcFXQHcFb7TII8zZJNk9XqcEYRkKpekR2ACSAAbj7dLwwuMgKOYsp2R456+9/1aZeMMu/P+3bNRxi95btIuGqogjTR+YJeDkLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770332816; c=relaxed/simple;
	bh=aihXvScW7k3bgdhqYtkiUVksAxCiMXO+pCvT8/8TTSc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nkdlgq11zNdoE7HWZKgtp9g/XxtK6Hfslha9YJdnxnsQEoXFc7zCSZXjbaM9G+zSmMpg6Yd0Io3gd6cmVM720Y/Io61jnHR1BJCkBUaJ4Fh//7pOZ+nnmB35YALUEy7zXXSe2jfv0WPkwXRO4kzDhrlbpr/nPwB0nL7SLl/wgr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QjhdXP3e; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6310f81285so2589004a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 15:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770332816; x=1770937616; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L8LUQCh61biJeu6NLvqdju68dTm4Qnz97N7lSr/nZdA=;
        b=QjhdXP3eqe7sXo7u+Tusbom4FZ/EQ8Ht+NG9CJ6At8miGgHk86bPsUPZ5F2mYgZiuz
         pHZVs5ffKRdd9CkFkfYtk+bSzEC+AgIjrmoY2owT9Icpd6/s61ZUwSz6e2g42mz/kuaA
         ehT0Fiia4TF0K9W1WZoIVSD85XSGM/aOvQzJ/2TcKteDp/1jFwgkwscC0EQdOQ4EJ5H8
         L2XdTFloXe9wITiF2WTZA9aA2vbtXhOYWE5YPqZn09npCIybPXsx5L2saUFTNURRiFVg
         RHGAtL/2E0shXVihvCzLBBz3ujn6TxGglxGM3I6V/kW+IPyaISqYSS/pNYceqZGp/SAF
         0Mnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770332816; x=1770937616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L8LUQCh61biJeu6NLvqdju68dTm4Qnz97N7lSr/nZdA=;
        b=Kb2VtSI11K87yMX+8qdVX4UfMrsqhwbOQ4QXTs+Z/1Rf7I/qeQc/J/D139xJBDXz1N
         QwBCYn+LsUGLKMZWWeNWIqza5VYym9QacOS6RgDdsHiR0TPAjXwAu2yJSSDpGsY9X50O
         TTu5Kgi7WdIujeyWGmyu4wgSKbnaO8uWiuTwVzNYp5rpzOuTYZ2WkPPfNfopbI6kFoHI
         XJuhR/UmEW+W02vLIa7RbMpwGIJ/Uwj3NHWqPVgssGyTULBE77UafTbo47X0unli7oac
         bFsXWpKzVhwZ4JqznyLXal4NtD35dSGwsSt2TeqNU+gPNmgVA6pDO57lxPOFfFp4Rs0l
         3AIA==
X-Forwarded-Encrypted: i=1; AJvYcCUJU6r6fN9Ddbiog3JJYxflS5gVPLXfIQHBFuyS99n/kcf7pUD4T9OohnupJbNtDHU2AqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyablDzTy9LpxUyDWhZnUewZ6wAZjBG6KNAtBXnqoBImiXXN78S
	Kx/b+aBjrGetjuBtS8VtiaS+TA6OASCaq9HNoyqtG4sVUQQtkD0J/5X2BQ42o0EHfgpAsTlGXgr
	jhVHd9w==
X-Received: from pjok9.prod.google.com ([2002:a17:90a:9109:b0:353:e172:1e2c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:497:b0:38d:fde5:249e
 with SMTP id adf61e73a8af0-393ad3ae21amr850191637.68.1770332815986; Thu, 05
 Feb 2026 15:06:55 -0800 (PST)
Date: Thu, 5 Feb 2026 15:06:53 -0800
In-Reply-To: <aYL3izez+eZ34G/3@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-7-seanjc@google.com>
 <aYL3izez+eZ34G/3@yzhao56-desk.sh.intel.com>
Message-ID: <aYUijQwl2Q6Q81DL@google.com>
Subject: Re: [RFC PATCH v5 06/45] KVM: x86/mmu: Fold set_external_spte_present()
 into its sole caller
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
	TAGGED_FROM(0.00)[bounces-70379-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[19];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: BA3EBF8444
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Yan Zhao wrote:
> On Wed, Jan 28, 2026 at 05:14:38PM -0800, Sean Christopherson wrote:
> > @@ -626,6 +599,8 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
> >  							 struct tdp_iter *iter,
> >  							 u64 new_spte)
> >  {
> > +	u64 *raw_sptep = rcu_dereference(iter->sptep);
> > +
> >  	/*
> >  	 * The caller is responsible for ensuring the old SPTE is not a FROZEN
> >  	 * SPTE.  KVM should never attempt to zap or manipulate a FROZEN SPTE,
> > @@ -638,31 +613,46 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
> >  		int ret;
> >  
> >  		/*
> > -		 * Users of atomic zapping don't operate on mirror roots,
> > -		 * so don't handle it and bug the VM if it's seen.
> > +		 * KVM doesn't currently support zapping or splitting mirror
> > +		 * SPTEs while holding mmu_lock for read.
> >  		 */
> > -		if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
> > +		if (KVM_BUG_ON(is_shadow_present_pte(iter->old_spte), kvm) ||
> > +		    KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
> >  			return -EBUSY;
> Should this be -EIO instead?

Yeah, probably.

> Though -EBUSY was introduced by commit 94faba8999b9 ('KVM: x86/tdp_mmu:
> Propagate tearing down mirror page tables')
> 
> > -		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
> > -						&iter->old_spte, new_spte, iter->level);
> Add "lockdep_assert_held(&kvm->mmu_lock)" for this case?

No, because I don't want to unnecessarily bleed TDX details into common MMU.  Ah,
but there was a pre-existing lockdep in set_external_spte_present().  So I guess
that's arguably a functional change and should be called out in the changelog.

But I still want to drop the assertion (or maybe move it to TDX in a prep patch),
because ultimately the requirements around locking come from TDX, not from the
TDP MMU.

