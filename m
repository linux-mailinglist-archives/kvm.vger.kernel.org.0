Return-Path: <kvm+bounces-71443-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLUNMdl2mWnFUAMAu9opvQ
	(envelope-from <kvm+bounces-71443-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 10:11:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 462ED16C7A9
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 10:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 82722301C8A8
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 09:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6129A33D4F2;
	Sat, 21 Feb 2026 09:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B484qGFM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92846226CFD;
	Sat, 21 Feb 2026 09:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771665086; cv=none; b=UNwKbljun39pMvz29b4oMfcLBGHsEBiTnemvnfdTe3bd9ROdZK8N6VHNiSzKicERb3Sc7atRkz85lXvSY1Sax2BAhd0GfZSFo8GlJY81sjEQWVZV5RK/OwDX7HynmPYuLtmgFUQhB3eC62bJ7mkPknqmyQJG2U8V0IGamvNHRkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771665086; c=relaxed/simple;
	bh=3atme856tcFtMGnOkc+k3LBOsWgOC1SuSf9+OVmixeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQn1uaaIOy6NeBDA16/+Sc3vo+j5O0K4YjDWQ7gBvB6V3M65LFBTA1TlAJZe10jrxE0QYCMYJGsvGsOUaaUtC2PJcS0R4OaEUd7ARdD1ODYarvmo/wmvAD51J/xUSTiSzFi7WO7OMrTjnmcHZAlyVu1APjS1tmOgzRuCcmg4bUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B484qGFM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01E6C4CEF7;
	Sat, 21 Feb 2026 09:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771665086;
	bh=3atme856tcFtMGnOkc+k3LBOsWgOC1SuSf9+OVmixeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B484qGFMadZ4IxhAXdEv3UDChiwp5caFvAHun8TSvcCOrjVEHVpOfqXeBHh2QLWLK
	 hRg7wIzNITcT5ZTOseGfybT+vbko2fiXUv1TLvhvMIu065tGsIOnCsxqE45OQ5mmyT
	 Oq0aME6Fpec/EW9RB1qgLmVvFRMdkeygTNLn5BH1TreKm7dpxPi11jC5qqCcGJok7z
	 d1MkVx5pm8P+BGBhzYUEgXmhDW2Lm+Qw6l+M45NRYGR63lWujLI3pWmuFws6kZbnJN
	 rHwr2I+hbvoSUssDQu27iCracDV80ceX/9QLk0uwyA/N1pGOZFA/Ldzv3hDgZCx3xV
	 9/j2eu6Z8crnw==
Date: Sat, 21 Feb 2026 09:11:24 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: nSVM: Sync next_rip to cached vmcb12 after
 VMRUN of L2
Message-ID: <ftjb625b4wsz5vdty3fcxqanuxriiqcewqkzp2ml2hc4eojuoc@ewhboiiqmcd4>
References: <20260210005449.3125133-2-yosry.ahmed@linux.dev>
 <aYqOkvHs3L-AX-CG@google.com>
 <4g25s35ty23lx2je4aknn6dg4ohviqhkbvvel4wkc4chhgp6af@kbqz3lnezo3j>
 <aYuE8xQdE5pQrmUs@google.com>
 <ck57mmdt5phh64cadoqxylw5q2b72ffmabmlzmpphaf27lbtxw@4kscovf6ahve>
 <aYvIpwjsJ50Ns4ho@google.com>
 <mxn6y6og34ejncnsvdapcoep4ewcnwnheszhwkp2undkqcu5zv@bpmseexuug5z>
 <aYvPwH8JcRItaQRI@google.com>
 <smsla7jgdncodh57uh7dihumnteu5sgxyzby2jc6lcp3moayzf@ixqj4ivmlgb2>
 <aZj2V9-noq10b5CM@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZj2V9-noq10b5CM@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71443-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 462ED16C7A9
X-Rspamd-Action: no action

[..]
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index de90b104a0dd..0a73dd8f9163 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1343,10 +1343,17 @@ static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
> >         nested_svm_simple_vmexit(to_svm(vcpu), SVM_EXIT_SHUTDOWN);
> >  }
> > 
> > +static const struct vmcb_ctrl_area_cached *svm_cached_vmcb12_control(struct vcpu_svm *svm) {
> > +       return &svm->nested.ctl;
> > +}
> 
> ...
> 
> > Is this sufficient?
> 
> It's certainly better, but unless a sea of helpers is orders of magnitude worse,
> I would prefer to make it even harder to put hole in our foot.
> 
> E.g. unless we're hyper diligent about constifying everything, it's not _that_
> hard to imagine a chain of events where we end up with a "live" pointer to the
> cache.
> 
>   1. A helper like __nested_vmcb_check_controls() isn't const, so we cast to strip
>      the const.

I would argue that casting to strip the const is a red flag and this
scenario should have stopped here :P

That being said, as you said, it depends on how many helpers we'll
actually need.

> 
>   2. Someone "improves" the code by grabbing the non-const variable to pass it
>      into other helpers.
> 
>   3. The non-const variable is used to update the cache for whatever reason, and
>      it works 99.9% of the time, until it doesn't.
> 
> Now, I don't think that's at all likely to happen, but as the years pile on and
> developers come and go, the probability of introducing a goof goes up, bit by bit.
> 
> > > > > > I think this will be annoying when new fields are added, like
> > > > > > insn_bytes. Perhaps at some point we move to just serializing the entire
> > > > > > combined vmcb02/vmcb12 control area and add a flag for that.
> > > > > 
> > > > > If we do it now, can we avoid the flag?
> > > > 
> > > > I don't think so. Fields like insn_bytes are not currently serialized at
> > > > all. The moment we need them, we'll probably need to add a flag, at
> > > > which point serializing everything under the flag would probably be the
> > > > sane thing to do.
> > > > 
> > > > That being said, I don't really know how a KVM that uses insn_bytes
> > > > should handle restoring from an older KVM that doesn't serialize it :/
> > > > 
> > > > Problem for the future, I guess :)
> > > 
> > > Oh, good point.  In that case, I think it makes sense to add the flag asap, so
> > > that _if_ it turns out that KVM needs to consume a field that isn't currently
> > > saved/restored, we'll at least have a better story for KVM's that save/restore
> > > everything.
> > 
> > Not sure I follow. Do you mean start serializing everything and setting
> > the flag ASAP (which IIUC would be after the rework we discussed), 
> 
> Yep.

I don't think it matters that much when we start doing this. In all
cases:

1. KVM will need to be backward-compatible.

2. Any new features that depend on save+restore of those fields will be
a in a new KVM that does the 'full' save+restore (assuming we don't let
people add per-field flags).

The only scenario that I can think of is if a feature can be enabled at
runtime, and we want to be able to enable it for a running VM after
migrating from an old KVM to a new KVM. Not sure how likely this is.

