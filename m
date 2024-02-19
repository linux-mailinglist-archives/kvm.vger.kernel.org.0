Return-Path: <kvm+bounces-9089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3CC85A510
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 14:46:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 766F21F235F8
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B442D364B8;
	Mon, 19 Feb 2024 13:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mn+/HxrM"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248942C848
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708350404; cv=none; b=u9Zk9D7lpjk8PV5KVitn5DE+ZgwZEjD5kkaHEhNIVIa28Qubmc2dkbhBXE8AtZDpIfXvQLjtprVzkcHRe3476FvsMkMBnzmhP+qKxj1y6C/lIbRdkaRegTvxb5ynHitAXP2NRvLaf6uWHr12f0vJPfXmnWouExHqD1hmFiv4XSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708350404; c=relaxed/simple;
	bh=Lk/oC5oP07ZNJ/mLNpiDEjqhux7oTIEG0THOOve3IxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNz5L68qnrm78ykVbRmM5WjIx7Ps0l5b4cT8cBmd58/BsSTAl6Y8xjgM6Ws8ZyEfFwO8cK+wSiBCUSL3rDcvAFZVSGJG3Xav/nvc4K8dE6SMujkZM90ZV76KkQBA6qcO10t3R/bfLhiOZ0s88UyMte59ZtRzFBU+YLoALK3c5Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mn+/HxrM; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 19 Feb 2024 14:46:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708350400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UP8/SXCmAV0YyHjsCYx2BQgoElRAtaK+Ws980WhjGiw=;
	b=mn+/HxrMFxAAQ8w4up+qyuL6biFFvkJs2MAE5QOURl5EEJQ1yy/4wAw2zPGoMEg77DpvQi
	b1IPf8S6DbUlgBy35kh2tvyGkgXxucUPiRD5+2SrO4szq+v3ddHhx+Y98S+Qw/3tzfPMJL
	/s4NDy1+evhRN6o3w8/Zz8HmnGGPHrk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
Message-ID: <20240219-282169045454ea6d91119c2a@orel>
References: <20240216140210.70280-1-thuth@redhat.com>
 <CZ7AJ4JK5805.2N5QS85IP42QZ@wheely>
 <4986756f-6230-421b-9601-054c6c2969e8@redhat.com>
 <CZ91DDIGOAMM.3RLL24M34FXGK@wheely>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CZ91DDIGOAMM.3RLL24M34FXGK@wheely>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 19, 2024 at 09:58:20PM +1000, Nicholas Piggin wrote:
> On Mon Feb 19, 2024 at 4:59 PM AEST, Thomas Huth wrote:
> > On 17/02/2024 11.43, Nicholas Piggin wrote:
> > > On Sat Feb 17, 2024 at 12:02 AM AEST, Thomas Huth wrote:
> > >> getchar() can currently only be called once on arm since the implementation
> > >> is a little bit too  naïve: After the first character has arrived, the
> > >> data register never gets set to zero again. To properly check whether a
> > >> byte is available, we need to check the "RX fifo empty" on the pl011 UART
> > >> or the "RX data ready" bit on the ns16550a UART instead.
> > >>
> > >> With this proper check in place, we can finally also get rid of the
> > >> ugly assert(count < 16) statement here.
> > >>
> > >> Signed-off-by: Thomas Huth <thuth@redhat.com>
> > > 
> > > Nice, thanks for fixing this up.
> > > 
> > > I see what you mean about multi-migration not waiting. It seems
> > > to be an arm issue, ppc works properly.
> >
> > Yes, it's an arm issue. s390x also works fine.
> >
> > > This patch changed things
> > > so it works a bit better (or at least differently) now, but
> > > still has some bugs. Maybe buggy uart migration?
> >
> > I'm also seeing hangs when running the arm migration-test multiple times, 
> > but also without my UART patch here - so I assume the problem is not really 
> > related to the UART?
> 
> Yeah, I ended up figuring it out. A 11 year old TCG migration memory
> corruption bug!
> 
> https://lists.gnu.org/archive/html/qemu-devel/2024-02/msg03486.html

Nice! And thanks for bringing this multi-migration test support to
kvm-unit-tests!

drew

> 
> All the weirdness was just symptoms of that. The hang that arm usually
> got was target machine trying to lock the uart spinlock that is already
> locked (because the unlock store got lost in migration).
> 
> powerpc and s390x were just luckier in avoiding the race, maybe the way
> their translation blocks around getchar code were constructed made the
> problem not show up easily or at all. I did end up causing problems
> for them by rearranging the code (test case is linked in that msg).
> 
> Thanks,
> Nick

