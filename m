Return-Path: <kvm+bounces-19648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B091908090
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 03:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 023A71F22C7D
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 01:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB7A16A360;
	Fri, 14 Jun 2024 01:16:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D480216939D;
	Fri, 14 Jun 2024 01:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718327801; cv=none; b=jnwubPGple2V8gaxEPxYGOsINbppyvV/8VV7zVrJBzRBQ2yW0PBFbGMZ1R1SZArGVAIBvixzJiL8vJr6wytYZV0ixTPlURukEh89IO7JTlIu242YnD7l7f1zHXpoWYWP6jwFUMC3+jvpMehZB70sjFh5icDA5nIeuAODOWgPolo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718327801; c=relaxed/simple;
	bh=7Retf0v8z9os8KrbHDiWjchdnzz8mCBkIDS9qi4WQb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0FbSfebQhtAkTNrD2bPuPKBW6aj7y0methMQNIVNB3/Jtu0NuHrE2yWifgebkVVkRhGQn7YI9aAe+WaeKI/hgiTB7rD3MYKrQKDV3zh6DRsXWKTyHZh/26R0UB/KI36VvPkNRnrH/9plh3IxSz4K3tyvSVR+7ff7n8BqArogCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 45E18v5Y029218;
	Thu, 13 Jun 2024 20:08:57 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 45E18uJY029217;
	Thu, 13 Jun 2024 20:08:56 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Thu, 13 Jun 2024 20:08:56 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm-riscv@lists.infradead.org,
        kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o targets
Message-ID: <20240614010856.GK19790@gate.crashing.org>
References: <20240612044234.212156-1-npiggin@gmail.com> <20240612082847.GG19790@gate.crashing.org> <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
User-Agent: Mutt/1.4.2.3i

On Fri, Jun 14, 2024 at 10:43:39AM +1000, Nicholas Piggin wrote:
> On Wed Jun 12, 2024 at 6:28 PM AEST, Segher Boessenkool wrote:
> > On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
> > > arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
> > > in dependency chains that cause them to be made as intermediate files,
> > > which get removed when make finishes. This results in unnecessary
> > > partial rebuilds. If make is run again, this time the .aux.o targets
> > > are not intermediate, possibly due to being made via different
> > > dependencies.
> > > 
> > > Adding .aux.o files to .PRECIOUS prevents them being removed and solves
> > > the rebuild problem.
> > > 
> > > s390x does not have the problem because .SECONDARY prevents dependancies
> > > from being built as intermediate. However the same change is made for
> > > s390x, for consistency.
> >
> > This is exactly what .SECONDARY is for, as its documentation says,
> > even.  Wouldn't it be better to just add a .SECONDARY to the other
> > targets as well?
> 
> Yeah we were debating that and agreed .PRECIOUS may not be the
> cleanest fix but since we already use that it's okay for a
> minimal fix.

But why add it to s390x then?  It is not a fix there at all!


Segher

