Return-Path: <kvm+bounces-71438-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4ERHORUBmWnROwMAu9opvQ
	(envelope-from <kvm+bounces-71438-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:49:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F47316B997
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EAE34303A861
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C1231A555;
	Sat, 21 Feb 2026 00:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hBbLJYj9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FCFC8E6
	for <kvm@vger.kernel.org>; Sat, 21 Feb 2026 00:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771634954; cv=none; b=FPOuUS1GbKR0olCKNTDRrES8pZECkYobowWtn5PnmBtitS6SVlPpC9UbCWX3r0KqlKZ3a5FORhq+hzArE1BorAFdYAm8UrZqaSviTlu8W3Yf/0+ehrblU15V2204X3s41hZPaIJ96NMaskq9ubeYQVDDmOtKA6uwbiSS1tiEvjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771634954; c=relaxed/simple;
	bh=T7zTvaIxgBfhy5lDDPQ1TN1ZokP0oSGzQHGYLXZ6Qac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uOZBQC3o/aYZkGdPBfYw+xh9jrREtcVafC51a3HRGVfvTPogQ/bTNURP7nLnDwFDbS6AOeUhiAjI5Qk3LQDlBuzBUCf7du8f32wM63kSRPw5e+mWtXbMxWrsofmRGLeRFaiAoT45uMbkeW3mmD03ud7JtATT8Ly2OpVyBb14QqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hBbLJYj9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3562370038dso2209514a91.3
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 16:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771634952; x=1772239752; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CWr0HuJWiATaTNOSdTyLvXYll6+nwgjSWjXAo4M2MD4=;
        b=hBbLJYj9kNOP80gZpkZRKO+9CjodSRfdlu0m3octLGCbArzU0xZ0Ed9ajL0G6jdT28
         yjUOOItYHQLjqh/2X3Xn3xWHSl/5C9MOgS9ysLndUdLNNRhsMhnMzPjXdqfHUqhA1mt7
         ekKnbiWW64+wNOhzJrY4OmeoVlbV/v4NtaE4fugUq55OTEtcnOPOxSYihixow3W9A3hh
         POKWO6cBqmSakZEd3nb0RPRCN5OQKx8i4WQi0RSeO1zZPDFF0DwQOX0N2HlGKY7LX1JF
         AettkAHM2r4zqMC8Bbf37Ia0fHiQqjTyZl7q2Gkl0ioy0cD9Ch/a8xuVamdO0ij6a9/D
         8ygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771634952; x=1772239752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CWr0HuJWiATaTNOSdTyLvXYll6+nwgjSWjXAo4M2MD4=;
        b=CL41hdIezTSuTadNzFIjiMmf/iMnCrxVUEZ4MkkLF1d6TuR2z7qlWj0E8UxZwBolp7
         yxav6NTVD8k1Lba+Hrt5V9oWIs8c/59vtIiS9oj9CCIRWNqdHg0g2zsOxTzwA+rlTGyd
         1zPpNJU0GxrrSjFEix1onIlnWlGVnGkba4DF2WOLBWRCfznTK2ZGQ+42kW+VnwJQUz/V
         0zrg9XvnXTouqDhN1Ypfjkel6KYlNjcstPYdUoF2rmIpIsdoMMEeg0+q9HQ6RUXIv1Sf
         g+C9CzhW/Dvemed/PJkgR74a2bvlcvErvDYLexiMpbtHWBzKLDZRtyGj1wNNhl9Ir8Mq
         YWLA==
X-Forwarded-Encrypted: i=1; AJvYcCW0f8Ot/RtNtX16C/RP0NrfymDC6zheskWiEymT2PXXG2Xfje7yEOCXovguXqYphHC1Qqw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyNTCWyFPTYbgkoZz2sio1OtZ49FQ7krWBmApzwjoYubyDErtq
	NaHkcXDwxd8zlYooQLYuocKHRBNoGP6eXUe4iKe05SID+2iL+96I5KKCCFv5EZbrCseBtCvDldn
	FdEdHgA==
X-Received: from pjbnc3.prod.google.com ([2002:a17:90b:37c3:b0:354:c63c:5ed6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17c3:b0:354:e86a:3066
 with SMTP id 98e67ed59e1d1-358ae6b4f77mr1024277a91.0.1771634952017; Fri, 20
 Feb 2026 16:49:12 -0800 (PST)
Date: Fri, 20 Feb 2026 16:49:10 -0800
In-Reply-To: <7986057373abcb20585c916804422a13f51d5e55.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260219002241.2908563-1-seanjc@google.com> <7986057373abcb20585c916804422a13f51d5e55.camel@intel.com>
Message-ID: <aZkBBlrMd2-P-kKK@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71438-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6F47316B997
X-Rspamd-Action: no action

On Sat, Feb 21, 2026, Rick P Edgecombe wrote:
> On Wed, 2026-02-18 at 16:22 -0800, Sean Christopherson wrote:
> > +static void reset_tdp_unmappable_mask(struct kvm_mmu *mmu)
> > +{
> > +	int max_addr_bit;
> > +
> > +	switch (mmu->root_role.level) {
> > +	case PT64_ROOT_5LEVEL:
> > +		max_addr_bit = 52;
> > +		break;
> > +	case PT64_ROOT_4LEVEL:
> > +		max_addr_bit = 48;
> > +		break;
> > +	case PT32E_ROOT_LEVEL:
> > +		max_addr_bit = 32;
> > +		break;
> > +	default:
> > +		WARN_ONCE(1, "Unhandled root level %u\n", mmu->root_role.level);
> > +		mmu->unmappable_mask = 0;
> 
> Would it be better to set max_addr_bit to 0 and let rsvd_bits() set it below?
> Then the unknown case is safer about rejecting things.

No, because speaking from experience, rejecting isn't safer (I had a brain fart
and thought legacy shadow paging was also affected).  There's no danger to the
host (other than the WARN itself), and so safety here is all about the guest.

Setting unmappable_mask to -1ull is all but guaranteed to kill the guest, because
KVM will reject all faults.  Setting unmappable_mask to 0 is only problematic if
the guest and/or userspace is misbehaving, and even then, the worst case scenario
isn't horrific, all things considered.

> > +		return;
> > +	}
> > +
> > +	mmu->unmappable_mask = rsvd_bits(max_addr_bit, 63);
> > +}
> > +
> 
> Gosh, this forced me to expand my understanding of how the guest and host page
> levels get glued together. Hopefully this is not too far off...
> 
> In the patch this function is passed both guest_mmu and root_mmu. So sometimes
> it's going to be L1 GPA address, and sometimes (for AMD nested?) it's going to
> be an L2 GVA. For the GVA case I don't see how PT32_ROOT_LEVEL can be omitted.
> It would hit the warning?

No, it's always a GPA.  root_mmu translates L1 GPA => L0 GPA and L1 GVA => GPA*;
guest_mmu translates L2 GPA => L0 GPA; nested_mmu translates L2 GVA => L2 GPA.

Note!  The asterisk is that root_mmu is also used when L2 is active if L1 is NOT
using TDP, either because KVM isn't using TDP, or because the L1 hypervisor
decided not to.  In those cases, L2 GPA == L1 GPA from KVM's perspective, because
the L1 hypervisor is responsible for shadowing L2 GVA => L1 GPA.  And root_mmu
can also translate L2 GPA => L0 GPA and L2 GVA => L2 GPA (again, L1 GPA == L2 GPA).

> But also the '5' case is weird because as a GVA the max addresse bits should be
> 57 and a GPA is should be 54.

52, i.e. the architectural max MAXPHYADDR.

> And that the TDP side uses 4 and 5 specifically, so the PT64_ just happens to
> match.

No, it's not a coincidence.  The "truncation" to 52 bits is an architectural
quirk.  Long ago, people decided 52 bits of PA were enough for anyone, and so
repurposed bits 63:52 for e.g. NX, SUPPRESS_VE, and software-available bits.

I.e. conceptually, 5-level paging allows for 57 bits of addressing, but EPT and
NPT and NPT define bits 63:52 to be other things.

> So I'd think this needs a version for GVA and one for GPA.

No, see the last paragraph in the changelog.

Side topic, if you have _any_ idea for better names than guest_mmu vs. nested_mmu,
speak up.  This is like the fifth? time I've had a discussion about how awful
those names are, but we've yet to come up with names that suck less.

