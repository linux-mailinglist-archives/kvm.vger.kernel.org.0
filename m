Return-Path: <kvm+bounces-72066-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKIRHS2UoGl+kwQAu9opvQ
	(envelope-from <kvm+bounces-72066-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:42:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D3F51ADE25
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 551AF3075757
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0B63D4103;
	Thu, 26 Feb 2026 18:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NGri9AOn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667672D238F
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772130300; cv=none; b=UHS2Jd88xkCPYzsTp+MJ5fSu+mLOr9iodUrC52jpQah/sgjypKIcB3x01VGTtrErKdP+HUePBsm1NrRIdtdzVqCHcejQE1OZeuCv0JEni7vOFFuI4zx2oinD9HSminGfluXN29BRexteXUdaUL1VDQ/ce6kezEmmSqMeOHgICCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772130300; c=relaxed/simple;
	bh=k3soXQkk7YLuqSivAHD1V0eG6RUMSXYigk1r/BeTy8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qbkZI0aJDDMYq+yBeK1I826SKZMPqf7UwSarvD64zKEvLsojCbdUgNvlRumFEWpTCEfgWVx9BwCZFEQEAcztQd/N/TiO3c5eBOefOaYButjKWiber8buZdq7u0WzmEexC6oTVYbxm8YNnLpePaFRiEWbfEW/FNXUklG4gC6yx+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NGri9AOn; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad5fc5b2fso11851775ad.1
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 10:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772130298; x=1772735098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X3CnbC2LzEBnADf0H4jNpgSa/BKh2OZoa8tvpC3rGZ8=;
        b=NGri9AOnE3kuWDz43IjdMITNlyT/meOGX8wlNGKGPqTtFR+MxFkanXJoTwzBnpBsvC
         A9rHG1yPa8ZOn3oGZbLw0oL7zAhn+OBYXzM+ccRHNTVVTI2R0NXT+xmRpWUMlneyCEGA
         X+a5fevVuuTAdQtSZy+k+HWIqr1pZ/eoGyOStjThIbzgmFtOuHBnwUVkh3wfoNI8EWpJ
         bMy2GcRsF/qUN6ZOwyh1Rd3V+S+7uOJqRudqvT+J3/Rnz97XYsgyBqAF3UXF+yYCiQ5D
         Rxe3mVlMpUXFqfQxR/7GFTTGu5+nqerA0LbSLBwaclNyrpgTv5fYfVDGfrpU/6i03Bxf
         P+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772130298; x=1772735098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X3CnbC2LzEBnADf0H4jNpgSa/BKh2OZoa8tvpC3rGZ8=;
        b=Y97HXPIuUZQOyfY8Z6MhIIPVcZCpopO4KTpjHNDmpNTjeIhPNfNYSDrJvwn6dufDOT
         ODOdcSqk28Pte+kJ1Rz9DNMPLieckgpABlS15/g5T8lKRTAO9s+kyL+cjoQEHWJTVsy3
         99fY6pF5QL8tZkdyEXtRIdrdhrnSOVtoXv6+gh3yXrHeiKr5NOMbYD0mxAa8JlKlfP6y
         tLx2OqHMJCLWtLPXkzI99aDEf48aL3dqJn+kcc4Nh39g3yBks0nwXA97I1HoG2IkoW6b
         HEJVGgX07/0KtdWCtBkOXTI4asivuKKEPuNzqcdivtV/9u+bjJWgh2fHxunpx4Ar4W8L
         xfGg==
X-Forwarded-Encrypted: i=1; AJvYcCWL5KSSxz0ckOKVKwxMtFefsr4vlON2GAmukHeWCMvvkcHXpAoYQDR0one96mbE35c2K8s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxofbUbWS92zVFU3l1Sc3kqeSFVNMf11rWAJFGlP1eQxGJnf28w
	1fLvNHwniA78TylrSUxG6gIuZTH4TiEn9H77RHKBv58EZSn9R/Q9SlJxba7PrL8bO0UF48VLmp6
	LlvvChQ==
X-Received: from plau11.prod.google.com ([2002:a17:903:304b:b0:2aa:e682:e951])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e849:b0:2a7:d5c0:c659
 with SMTP id d9443c01a7336-2ae0305efc8mr36873085ad.5.1772130297522; Thu, 26
 Feb 2026 10:24:57 -0800 (PST)
Date: Thu, 26 Feb 2026 10:24:55 -0800
In-Reply-To: <e3cdcbfa-525d-4e0d-885a-8f7d69a7ee3d@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260202074557.16544-1-lance.yang@linux.dev> <20260202074557.16544-4-lance.yang@linux.dev>
 <aZ9Xcgxa0_ouGr31@google.com> <e3cdcbfa-525d-4e0d-885a-8f7d69a7ee3d@linux.dev>
Message-ID: <aaCP95l-m8ISXF78@google.com>
Subject: Re: [PATCH v4 3/3] x86/tlb: add architecture-specific TLB IPI
 optimization support
From: Sean Christopherson <seanjc@google.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com, 
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com, 
	pbonzini@redhat.com, boris.ostrovsky@oracle.com, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ioworker0@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72066-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,infradead.org,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8D3F51ADE25
X-Rspamd-Action: no action

On Thu, Feb 26, 2026, Lance Yang wrote:
> On 2026/2/26 04:11, Sean Christopherson wrote:
> > On Mon, Feb 02, 2026, Lance Yang wrote:
> > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > index 37dc8465e0f5..6a5e47ee4eb6 100644
> > > --- a/arch/x86/kernel/kvm.c
> > > +++ b/arch/x86/kernel/kvm.c
> > > @@ -856,6 +856,12 @@ static void __init kvm_guest_init(void)
> > >   #ifdef CONFIG_SMP
> > >   	if (pv_tlb_flush_supported()) {
> > >   		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
> > > +		/*
> > > +		 * KVM's flush implementation calls native_flush_tlb_multi(),
> > > +		 * which sends real IPIs when INVLPGB is not available.
> > 
> > Not on all (virtual) CPUs.  The entire point of KVM's PV TLB flush is to elide
> > the IPIs.  If a vCPU was scheduled out by the host, the guest sets a flag and
> > relies on the host to flush the TLB on behalf of the guest prior to the next
> > VM-Enter.
> 
> Ah, I see. Thanks for the correction!
> 
> KVM only sends IPIs to running vCPUs; preempted ones are left out of the mask
> and flushed on VM-Enter. So the old comment was wrong ...
> 
> IIUC, we still set the flag to true because only running vCPUs can be in a
> software/lockless walk, and they all get the IPI, so the flush is enough.
> 
> Does that match what you had in mind?

No, because from the guest kernel's perspective, the vCPU is running.  The kernel
can't make any assumptions about what code the vCPU was executing when the vCPU
was preempted by the host scheduler, i.e. it's entirely possible the vCPU is in
a software/lockless walk.

