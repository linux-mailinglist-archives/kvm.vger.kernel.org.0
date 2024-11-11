Return-Path: <kvm+bounces-31526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 326569C461B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBFD6285D02
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9E81A726F;
	Mon, 11 Nov 2024 19:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XstHiunX"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBE7170A1A
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 19:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731354371; cv=none; b=i4W0bCAC7QJ78NEmIHMSGVOdezX5n1urNSEemHMy+xLm2lB4EgjW9mWK3Z0LnV7wexpnb6HnS4F+D+cPNBK4G6uHp+BdcPVfzr9KRXOcVFeivGqe5qplGfjdUydUwP2oLnT35Kmw/MA4gkLeVdHPHaRs/EJVoPQ+NV9HJjvqzso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731354371; c=relaxed/simple;
	bh=zzsh8xbAExzpTl7RmvKZVBJwdrA4bo0aOmm8ecSZV7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PU47nUTk4lEMlQBULWUFdYPR+BG4C2VN4BOeYB1OwQJOA0V44v2Q3mhD5q26SBTcZap/vN7dcsEAoWnW1AsdnY0Ta0O8e9TrPXD++3t5enpKGLKTld0yiGZ1TXbZboDz6kot0LPCrQJKVlWflpYSQ9E/1ViiAbWdNc+y9wsPzTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XstHiunX; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 19:46:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731354367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XUuDuupGQlT2PNCZA4fo4MUNDmEa7x9ZBSyXrNwdB0=;
	b=XstHiunXfX/kI93pTsClk1nInTezzpFM6T8o+mZVhjfCpTDGcFJFdHq75QEI0mFuCJD1B+
	Wwu+MleW5ke4SrQD2jrjnyPqusIvqQNX073R3YQBBEh78JVBUtOB+Ch1P21Oolv7IXVa8K
	j65VM0NX/HbCozPWZJK/Ex/ixldWUws=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
	broonie@kernel.org, maz@kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, joey.gouly@arm.com, shuah@kernel.org,
	pbonzini@redhat.com
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
Message-ID: <ZzJe-ju6pleqTfS8@linux.dev>
References: <20241107094000.70705-1-eric.auger@redhat.com>
 <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com>
 <Zy0QFhFsICeNt8kF@linux.dev>
 <Zy0bcM0m-N18gAZz@google.com>
 <Zy0fPgwymCdBwLd_@linux.dev>
 <Zy0ihQlkexIWc1fq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zy0ihQlkexIWc1fq@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 07, 2024 at 12:26:45PM -0800, Sean Christopherson wrote:
> On Thu, Nov 07, 2024, Oliver Upton wrote:
> > On Thu, Nov 07, 2024 at 11:56:32AM -0800, Sean Christopherson wrote:
> > > ---
> > > From: Sean Christopherson <seanjc@google.com>
> > > Date: Thu, 7 Nov 2024 11:39:59 -0800
> > > Subject: [PATCH] KVM: selftests: Don't bother deleting memslots in KVM when
> > >  freeing VMs
> > > 
> > > When freeing a VM, don't call into KVM to manually remove each memslot,
> > > simply cleanup and free any userspace assets associated with the memory
> > > region.  KVM is ultimately responsible for ensuring kernel resources are
> > > freed when the VM is destroyed, deleting memslots one-by-one is
> > > unnecessarily slow, and unless a test is already leaking the VM fd, the
> > > VM will be destroyed when kvm_vm_release() is called.
> > > 
> > > Not deleting KVM's memslot also allows cleaning up dead VMs without having
> > > to care whether or not the to-be-freed VM is dead or alive.
> > 
> > Can you add a comment to kvm_vm_free() about why we want to avoid ioctls
> > in that helper? It'd help discourage this situation from happening again
> > in the future in the unlikely case someone wants to park an ioctl there.
> > 
> > > Reported-by: Eric Auger <eric.auger@redhat.com>
> > > Reported-by: Mark Brown <broonie@kernel.org>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > I'm assuming you want to take this, happy to grab it otherwise.
> 
> You take it.  Unless my git foo is off the rails, this is needs to go into 6.12,
> along with a fix for the vGIC test.  That, and I already sent Paolo a pull request
> for rc7; I don't want to overwork myself ;-)

Fine -- I _guess_ I'll do it then :) It'll just go in the 6.13 pull
request.

https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=next&id=5afe18dfa47daead88517b095b6e0ce012f031f8

-- 
Thanks,
Oliver

