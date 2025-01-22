Return-Path: <kvm+bounces-36252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E1EA19471
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5596F3ABB6D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 14:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE7D214234;
	Wed, 22 Jan 2025 14:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWKuKHK0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF971213E99;
	Wed, 22 Jan 2025 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737557812; cv=none; b=Ep1IhZ4M6kiDQdFqGB64xdbWZqTaNBjBF9K+/momL8cy7JGI5kB6yVUb5RfQ61z+2DM6XNuiPzsiF4Lr5+0e8Whna9KvGJED2rGhfwiBeh3zjQZIxEFoDFQDMxuZKM9uNV3VHIaaLwLGCw9gnRsgNt6iP3QSZFkbJ7vQnVDazsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737557812; c=relaxed/simple;
	bh=55PFLsFoEltYFgfsyNLmyyR53/uMhwaNH9mEvYQPIsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LolN3qNDWZjmSgl6JBavIUPjDV0d5vNaW9wIMQpgPEy//rgpfQvNJ2nM7BKZ2dKnx6F1hRBTG09DbJs8HQfuGXuXQuywKOhBpWO68gvRA+0cfxPQ43hfIR4s2esd+AZ8lXKcvksb2zZIeI1H+MLdxMeiL5H4u1nDmWe/IBT3pJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWKuKHK0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D84C4CED2;
	Wed, 22 Jan 2025 14:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737557812;
	bh=55PFLsFoEltYFgfsyNLmyyR53/uMhwaNH9mEvYQPIsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uWKuKHK0PvVE5y3AJTA18/x7biF1Uy7ZiyPpcq+NsuJjNI/DvFrQ4ZSXyN6mZsf8Y
	 Ao4Sy2/qoq45n3mWdAFhqpptawODaPWnucBpIEgbw0t05HOHNzKPGCfPTPjwtwQ2D6
	 erET/S+VHDDoxZA4EsqwTfKQDTc8WI61GWapkCpdf3kynsW39kG75MkAHysxSC6Rcq
	 w0LOsB5c7TYdT+BMez4l/slRavXYaXCFIm7aBMYVIuB0y4b0uQ9KzdMAJuWe97HDvB
	 /T/nw6i2vVyXGZ/OgKgpdgU/lC5yefAhyFh940CCkPv/tJhPwHCWtacncIMg2GlPEE
	 UWc+5EUnH7iOA==
Date: Wed, 22 Jan 2025 07:56:49 -0700
From: Keith Busch <kbusch@kernel.org>
To: Alyssa Ross <hi@alyssa.is>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>,
	Luca Boccassi <bluca@debian.org>, stable@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <Z5EHMbv8uezcRM3l@kbusch-mbp>
References: <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z4Uy1beVh78KoBqN@kbusch-mbp>
 <0862979d-cb85-44a8-904b-7318a5be0460@redhat.com>
 <Z4cmLAu4kdb3cCKo@google.com>
 <Z4fnkL5-clssIKc-@kbusch-mbp>
 <CABgObfZWdwsmfT-Y5pzcOKwhjkAdy99KB9OUiMCKDe7UPybkUQ@mail.gmail.com>
 <Z4gGf5SAJwnGEFK0@kbusch-mbp>
 <twoqrb4bdyujvnf432lqvm3eqzvhqsbotag3q3snecgqwm7lzw@izuns3gun2a6>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <twoqrb4bdyujvnf432lqvm3eqzvhqsbotag3q3snecgqwm7lzw@izuns3gun2a6>

On Wed, Jan 22, 2025 at 12:38:25PM +0100, Alyssa Ross wrote:
> On Wed, Jan 15, 2025 at 12:03:27PM -0700, Keith Busch wrote:
> > On Wed, Jan 15, 2025 at 06:10:05PM +0100, Paolo Bonzini wrote:
> > > You can implement something like pthread_once():
> >
> > ...
> >
> > > Where to put it I don't know.  It doesn't belong in
> > > include/linux/once.h.  I'm okay with arch/x86/kvm/call_once.h and just
> > > pull it with #include "call_once.h".
> >
> > Thanks for the suggestion, I can work with that. As to where to put it,
> > I think the new 'struct once' needs to be a member of struct kvm_arch,
> > so I've put it in arch/x86/include/asm/.
> >
> > Here's the result with that folded in. If this is okay, I'll send a v2,
> > and can split out the call_once as a prep patch with your attribution if
> > you like.
> 
> Has there been any progress here?  I'm also affected by the crosvm
> regression, and it's been backported to the LTS stable kernel.

Would you be able to try the proposed patch here and reply with a
Tested-by if it's successful for you? I'd also like to unblock this,
whether this patch is in the right direction or try something else.

