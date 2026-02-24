Return-Path: <kvm+bounces-71664-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KCfsHg3+nWkETAQAu9opvQ
	(envelope-from <kvm+bounces-71664-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:37:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D838418C22B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56FA330BAD73
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE42330F7EA;
	Tue, 24 Feb 2026 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ose65Rib"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B0930F53C
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771961861; cv=none; b=FKNGyGFbBKTcgQt03yuGn8Zvhjmnc+xPurfMLlr66b/g9JuiL8o2Bcjg+B1v6h/rBO3Z+FQdZCqAirDj+z7sS7faeRboqyf9N5eOI3XY1vhzI19xxkFAYZqwPXFep0LM5rHW7WM5MH6Af2QF+HtgJ1oQV3Qit9lzPQRIYxAWQOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771961861; c=relaxed/simple;
	bh=TUjME4e4ee/WT/NlNRYr/K81TzZEWNbu4EqawuIqT9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q3mta7npRBtZ01w0FOUZ7ed3n+FnjnZcE0G7dS2pYquuGcdtVNTGh1FxmlRxV8QQ3ZwMySGNdOtWRYNAJqJj2oD+xidvZqBwfmzcv9lv0hOJQQ38dnhReDdDBsqWCSyui5IXwJgItW0HQW5b96d3NmPl1wo2K3YS5fZdrhLC90U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ose65Rib; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c0eb08ceso37622875a91.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 11:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771961860; x=1772566660; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y4OyuNHT7ap5XzoM1m50GD/I12ZIB1MFriXuxmmpl50=;
        b=Ose65Rib3jgeAF/H6S6ISu/jsPEYQMOPV7/UqGqud6ZEy/YTh+pGhILe5F518wZOKw
         OPscuy1pLFjZc/D+aItJrH9fFG2vf2xww1dMHl1R/qLuIPevTPI9cTFERKLvrh7LwAc5
         Hh+whtNp9swnF5ozbZ459dowfG0jMqperScX1nbS6MjVCtdyDU03YZZqIz1L0ZhtA709
         bFZS6KMPclHJrRQhfVjf3AUBtsiONe3E0NzcML2xaXRumpq/1epc7gjsjN2fUVNSk3xV
         U9NgB5KzQFzAAzpPgEl1S6ZOqu3dkz5vPMe84Y2D+V+wK5BgQdU0HWJBgPoH0YQTdqsC
         Xb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771961860; x=1772566660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4OyuNHT7ap5XzoM1m50GD/I12ZIB1MFriXuxmmpl50=;
        b=ZhoCDSQeC2kOLFeli/KrG12EWknysBiwqMk7PzLCKwJaaP+5bFhkqQWtWt8QL7yv3D
         1amW39zzliM0flvHdiimfIWh7JdfNj/d46ps4UTOuwGuzpLTTl+VRljz9GbSzRhhQvki
         FAcNjvWWcMLm3q+0L7Os6UHeuYOZ4w3tbQ5ZyY5od2zERAlaEu9Mnwl23HdnbniD6K5N
         SZ9/4IJygfXXDoB/09PF7HBAPvC1dVeAk3rfFX4m95uToFGeHg3Y9feFgt58I0GwNTWz
         31m1ReFqwG/cIlt5UKvXyGSFyBGl9k0NcjDwMXfIPPSC9jaUCu4x4UZWlvO8ylON5Q9C
         XOcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOU/FXYqU/BN2tV/G0csMlE/Rzgjas9FLVkVruxh04AGQfZZXT0IggMXvKS14EO7pobcw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy47Df6w3QSPqFMl1/BcA/sDjmCz6JkKn7HqaOodYqiEocEe006
	kZ/7s2qGdAsdNx2xekMWhiQtk9puJC7c4SMTriOC1Da+UVr9wPnG/OpNl2YBZh6hFeEVLZK9Wl1
	fR9h2wA==
X-Received: from pjqf14.prod.google.com ([2002:a17:90a:a78e:b0:354:9f74:37d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35c8:b0:353:5595:3246
 with SMTP id 98e67ed59e1d1-358ae8b6672mr10708334a91.21.1771961859876; Tue, 24
 Feb 2026 11:37:39 -0800 (PST)
Date: Tue, 24 Feb 2026 11:37:38 -0800
In-Reply-To: <CAO9r8zNrQGKM0N345+KG=W72FyV1pp2EqOLcTMUZkz6bCA3MgQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-4-chengkev@google.com>
 <aZ3gg2VsrWGKrX4l@google.com> <CAO9r8zNrQGKM0N345+KG=W72FyV1pp2EqOLcTMUZkz6bCA3MgQ@mail.gmail.com>
Message-ID: <aZ3-AqK3liE1XNGB@google.com>
Subject: Re: [PATCH V2 3/4] KVM: VMX: Don't consult original exit
 qualification for nested EPT violation injection
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev
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
	TAGGED_FROM(0.00)[bounces-71664-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D838418C22B
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Yosry Ahmed wrote:
> > > @@ -496,7 +510,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
> > >        * [2:0] - Derive from the access bits. The exit_qualification might be
> > >        *         out of date if it is serving an EPT misconfiguration.
> > >        * [5:3] - Calculated by the page walk of the guest EPT page tables
> > > -      * [7:8] - Derived from [7:8] of real exit_qualification
> > > +      * [7:8] - Set at the kvm_translate_gpa() call sites above
> > >        *
> > >        * The other bits are set to 0.
> > >        */
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 248635da67661..6a167b1d51595 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -444,9 +444,6 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
> > >                       exit_qualification = 0;
> > >               } else {
> > >                       exit_qualification = fault->exit_qualification;
> > > -                     exit_qualification |= vmx_get_exit_qual(vcpu) &
> > > -                                           (EPT_VIOLATION_GVA_IS_VALID |
> > > -                                            EPT_VIOLATION_GVA_TRANSLATED);
> >
> > Hmm, this isn't quite correct.  If KVM injects an EPT Violation (or a #NPF) when
> > handling an EPT Violation (or #NPF) from L2, then KVM _should_ follow hardware.
> >
> > Aha!  I think the easiest way to deal with that is to flag nested page faults
> > that were the result of walking L1's TDP when handling an L2 TDP page fault, and
> > then let vendor code extract the fault information out of hardaware.
> 
> Is it not possible that KVM gets an EPT Violation (or a #NPF) on an L2
> memory access while the CPU is walking L2's page tables, then KVM
> walks L1's TDP and finds mappings for the L2 page tables but not the
> final translation? Or will KVM always just fixup the immediate EPT
> Violation (or #NPF) by inserting a shadow mapping of L2's page tables
> and retry the instruction immediately?

The latter, assuming by "shadow mapping of L2's page tables" out meant "installing
a shadow mapping of the faulting L2 GPA according to L1's TDP page tables".

I.e. when servicing an L2 TDP fault, KVM is only resolving the fault for the reported
L2 GPA, _not_ the originating L2 GVA (if there is one).

