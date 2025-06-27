Return-Path: <kvm+bounces-50959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B21AEB1C2
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 353A7171D33
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 08:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39A027F011;
	Fri, 27 Jun 2025 08:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NSqynEiO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74E326B2A9;
	Fri, 27 Jun 2025 08:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751014526; cv=none; b=WCVHABLMtPHl25cCJpjZisjvHE3MzPnQpaGqwOFZMa0TbJFMusJJgNy8t1MMLquLPwuZzYaSTZsIOxyLUrTh93HGRcA5X5iWfgeKwy7+huC15vQFX/RBGxRex+/k0Vn/y5r4XSASCx+gGQ6U787ly3p1bCj60/4aq28pA7kq4Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751014526; c=relaxed/simple;
	bh=z+tpwjWBjnR0vETOhJx8rBu966vEEey3sKuCSDd+jvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u8opd1awqrMlAPT3/gVifdkJw+cm92Ls8KjtR7kpSecQl8UTjCTIBUJN8HB8XriKufctD9oS8WZF3M4+XEUdLliLe/Estb2HvAsbXTxuxOOZcwF1KSmbQKVeka57hO6qeBwqHGqBTaLeZFZkPg79hWQZ0rb/7GnJg/EmR+wYxzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NSqynEiO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21A5C4CEE3;
	Fri, 27 Jun 2025 08:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751014526;
	bh=z+tpwjWBjnR0vETOhJx8rBu966vEEey3sKuCSDd+jvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NSqynEiO4z/hGE+4PNsPRMBOUqJcpG+Wp9qIT7MXKkFpPf4B+j/JnZapFo6x7q8R4
	 PZqLPPv+7dij67bid1Po7dyBPG6KDp6oqKWDMAb8XgxUvA0GHdXzCdt7ugae2EsSLW
	 nyvhdxKu+/d/UAk/JfulwmXOiqtssrlfoIvOx7EKoMQ43UgfHre5Ut6ewqukZpVUHB
	 Cu4ZQionjKLU8+L5DwU+nyaZufrvkLuauL+EFoyf7d99d9MgoDIaljCvOPjOxbwoXH
	 feclRwz8wMafmWorbQuSsS6Wkkkz1Imn7d9dMczvDC9/bI3fUcclN4iJcAtseClQmp
	 IGwvCC+Zk9dvA==
Date: Fri, 27 Jun 2025 13:55:53 +0530
From: Naveen N Rao <naveen@kernel.org>
To: mlevitsk@redhat.com
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [EARLY RFC] KVM: SVM: Enable AVIC by default from Zen 4
Message-ID: <bp7gjrbq2xzgirehv6emtst2kywjgmcee5ktvpiooffhl36stx@bemru6qqrnsf>
References: <20250626145122.2228258-1-naveen@kernel.org>
 <66bab47847aa378216c39f46e072d1b2039c3e0e.camel@redhat.com>
 <aF2VCQyeXULVEl7b@google.com>
 <4ae9c25e0ef8ce3fdd993a9b396183f3953c3de7.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ae9c25e0ef8ce3fdd993a9b396183f3953c3de7.camel@redhat.com>

Hi Maxim, Sean,
Thanks for the feedback!

On Thu, Jun 26, 2025 at 03:14:42PM -0400, mlevitsk@redhat.com wrote:
> On Thu, 2025-06-26 at 11:44 -0700, Sean Christopherson wrote:
> > On Thu, Jun 26, 2025, mlevitsk@redhat.com wrote:
> > > On Thu, 2025-06-26 at 20:21 +0530, Naveen N Rao (AMD) wrote:
> > > IMHO the cleanest way is probably:
> > > 
> > > On Zen2 - enable_apicv off by default, when forced to 1, activate
> > > the workaround for it. AFAIK with my workaround, there really should
> > > not be any issues, but since hardware is quite old, I am OK to keep it disabled.
> > > 
> > > On Zen3, AFAIK the errata #1235 is not present, so its likely that AVIC is
> > > fully functional as well, except that it is also disabled in IOMMU,
> > > and that one AFAIK can't be force-enabled.
> > > 
> > > I won't object if we remove force_avic altogether and just let the user also explicitly 
> > > enable avic with enable_apicv=1 on Zen3 as well.
> > 
> > I'm not comfortable ignoring lack of enumerated support without tainting the
> > kernel.
> 
> The kernel can still be tainted in this case, just that it is technically possible to drop 
> force_avic, and instead just allow user to pass avic=1 instead, since it is
> not on by default and KVM can still print the same warning and taint the kernel
> when user passes avic=1 on Zen3.

This will be a problem in scenarios where it is desirable to enable AVIC 
only if it is enabled on the system, but not otherwise. As an example, 
there are deployments where the 'avic' kernel module parameter is 
enabled fleet-wide (across Zen3/Zen4/Zen5), and it is expected that it 
be only enabled when supported on the system.

> 
> Back when I implemented this, I just wanted to be a bit safer, a bit more explicit that
> this uses an undocumented feature.
> 
> It doesn't matter much though.
> 
> > 
> > I don't see any reason to do major surgery, just give "avic" auto -1/0/1 behavior:

I am wary of breaking existing users/deployments on Zen4/Zen5 enabling 
AVIC by specifying avic=on, or avic=true today. That's primarily the 
reason I chose not to change 'avic' into an integer. Also, post module 
load, sysfs reports the value for 'avic' as a 'Y' or 'N' today. So if 
there are scripts relying on that, those will break if we change 'avic' 
into an integer.

For Zen1/Zen2, as I mentioned, it is unlikely that anyone today is 
enabling AVIC and expecting it to work since the workaround is only just 
hitting upstream. So, I'm hoping requiring force_avic=1 should be ok 
with the taint removed.

Longer term, once we get wider testing with the workaround on Zen1/Zen2, 
we can consider relaxing the need for force_avic, at which point AVIC 
can be default enabled and force_avic can be limited to scenarios where 
AVIC support is not advertised.


Thanks,
Naveen


