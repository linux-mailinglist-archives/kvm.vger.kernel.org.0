Return-Path: <kvm+bounces-52868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72DADB09DB6
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 10:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0058189595D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B7B221F00;
	Fri, 18 Jul 2025 08:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbgwDoye"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077261CA84;
	Fri, 18 Jul 2025 08:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752826807; cv=none; b=O2y+Khj8vZXV5Hg9TRryDSX+fs/qWknJf0HT07AMsHor5pEJV9OFLqKxP6gfd8MYS7+m9u6o7rH4xzfM6woJpb81ImLRk+Xu4NIY9WvVB0yKDUo9Q3SoeNARXWEmGiBcrpQJ5/eF6m850/QsunIKVeNmnjy+gaH51MBTpSD9A4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752826807; c=relaxed/simple;
	bh=qAd8ycMee6hRlVYzCSY9mkp/JvxOmUrSY+m6h+PqfWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqXvr56UhkOi2Qjl4Vx/+B98geWYIDnIKygxhEEbxL2ryE9FOo2f/WbUKaRdHs5mTyeDoaf98kxNc2SLkMtUgkJygp9Pp1GNKlNlRGFdXJGy8MCeOEys6di/TCoSSDs95vBrUwEQxmH2HvYFdHh7hb21pW28MQw6+acd610aviU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbgwDoye; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDD6C4CEEB;
	Fri, 18 Jul 2025 08:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752826806;
	bh=qAd8ycMee6hRlVYzCSY9mkp/JvxOmUrSY+m6h+PqfWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gbgwDoye8TT//6qusPYwaUNopxEwBE+zptzh6ApWcWFDXYwAYLvV11xaHil2tpvRL
	 Xk+Z1A1fSc5vtUFvn7efYpmxYvhhkbNXUOoTcNHqBOpGDxNCEqJpEq2ho+chQmtEH2
	 ZSOaI7FFLiVxqov0VypsHbclg5Awdmzn5O7+qhXj1hmho7RydueCp76X2tp4fKqjhA
	 ld7K9T9DWFICKZrSFIG0/ZTPfhC7/jqdLiREvDK3QSUTPajAMjhQAq+VTDSR9HG2Bw
	 078/gZPndBG2rKtmW3rIhSxy7b5WTsC/hQXdzQf+gfDzvinn42f/ZvnDLOOsY3BREo
	 F6n2dX1W6yx7g==
Date: Fri, 18 Jul 2025 13:49:45 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: mlevitsk@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [EARLY RFC] KVM: SVM: Enable AVIC by default from Zen 4
Message-ID: <3xpfs5m5q6o74z5lx3aujdqub6ref2yypwcbz55ec5iefyqoy7@42g5nbgom637>
References: <20250626145122.2228258-1-naveen@kernel.org>
 <66bab47847aa378216c39f46e072d1b2039c3e0e.camel@redhat.com>
 <aF2VCQyeXULVEl7b@google.com>
 <4ae9c25e0ef8ce3fdd993a9b396183f3953c3de7.camel@redhat.com>
 <bp7gjrbq2xzgirehv6emtst2kywjgmcee5ktvpiooffhl36stx@bemru6qqrnsf>
 <aGxWkVu5qnWkZxqz@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGxWkVu5qnWkZxqz@google.com>

On Mon, Jul 07, 2025 at 04:21:53PM -0700, Sean Christopherson wrote:
> On Fri, Jun 27, 2025, Naveen N Rao wrote:
> > > Back when I implemented this, I just wanted to be a bit safer, a bit more explicit that
> > > this uses an undocumented feature.
> > > 
> > > It doesn't matter much though.
> > > 
> > > > 
> > > > I don't see any reason to do major surgery, just give "avic" auto -1/0/1 behavior:
> > 
> > I am wary of breaking existing users/deployments on Zen4/Zen5 enabling 
> > AVIC by specifying avic=on, or avic=true today. That's primarily the 
> > reason I chose not to change 'avic' into an integer. Also, post module 
> > load, sysfs reports the value for 'avic' as a 'Y' or 'N' today. So if 
> > there are scripts relying on that, those will break if we change 'avic' 
> > into an integer.
> 
> That's easy enough to handle, e.g. see nx_huge_pages_ops for a very similar case
> where KVM has "auto" behavior (and a "never" case too), but otherwise treats the
> param like a bool.

Nice! Looks like I can re-use existing callbacks for this too:
    static const struct kernel_param_ops avic_ops = {
	    .flags = KERNEL_PARAM_OPS_FL_NOARG,
	    .set = param_set_bint,
	    .get = param_get_bool,
    };

    /* enable/disable AVIC (-1 = auto) */
    int avic = -1;
    module_param_cb(avic, &avic_ops, &avic, 0444);
    __MODULE_PARM_TYPE(avic, "bool");

> 
> > For Zen1/Zen2, as I mentioned, it is unlikely that anyone today is 
> > enabling AVIC and expecting it to work since the workaround is only just 
> > hitting upstream. So, I'm hoping requiring force_avic=1 should be ok 
> > with the taint removed.
> 
> But if that's the motivation, changing the semantics of force_avic doesn't make
> any sense.  Once the workaround lands, the only reason for force_avic to exist
> is to allow forcing KVM to enable AVIC even when it's not supported.

Indeed.

> 
> > Longer term, once we get wider testing with the workaround on Zen1/Zen2, 
> > we can consider relaxing the need for force_avic, at which point AVIC 
> > can be default enabled
> 
> I don't see why the default value for "avic" needs to be tied to force_avic.
> If we're not confident that AVIC is 100% functional and a net positive for the
> vast majority of setups/workloads on Zen1/Zen2, then simply leave "avic" off by
> default for those CPUs.  If we ever want to enable AVIC by default across the
> board, we can simply change the default value of "avic".
> 
> But to be honest, I don't see any reason to bother trying to enable AVIC by default
> for Zen1/Zen2.  There's a very real risk that doing so would regress existing users
> that have been running setups for ~6 years, and we can't fudge around AVIC being
> hidden on Zen3 (and the IOMMU not supporting it at all), i.e. enabling AVIC by
> default only for Zen4+ provides a cleaner story for end users.

Works for me. I completely agree with that.


Thanks,
Naveen


