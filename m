Return-Path: <kvm+bounces-32512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6039D955D
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25145285D92
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2791C1C4A13;
	Tue, 26 Nov 2024 10:20:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A450192B96
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 10:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616432; cv=none; b=LYish7Xmb/OusXE98VnkbHY7b9wK1YTCfp1HjCnGQv3q9h5RIhn8i9N6yXPs+0bvDAOkLgoyerdyOBaYH03iRThoY9bPe7nznjsta+21KQbWdnSCWPA0l21LAm3G57yL9Yrom0oTBb2n0unhgsspPOLuZ05Hzw90eo/uP65HVqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616432; c=relaxed/simple;
	bh=fXAX0GmMtdzhr+NtXTfZkMwGICQXDl0+6sBU4NQnUSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KfzTVMRIfzzdHzV64dU6b4CUDpoDyr/S56upHiddNzp5ThTFqdzKwdM6NLreO/JEfMTlWoljZ3tztFrPrYWLQriQEZ+V0ysvY7PZTKL+XA8antdI0V8LgGyd18iSAv7JTnsftl8HR+v4VeszbU9hYrlv9bcOAFvV7VK5XO03gx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=pass smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1tFsfq-0072LC-13;
	Tue, 26 Nov 2024 11:20:02 +0100
Date: Tue, 26 Nov 2024 11:20:02 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Marc Zyngier <maz@kernel.org>
Cc: Bernhard Kauer <bk@alpico.io>, Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: make uevents configurable
Message-ID: <Z0Wg0jQLRuAQrl0j@mias.mediconcil.de>
References: <20241122095806.4034415-1-bk@alpico.io>
 <86h67vusnf.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h67vusnf.wl-maz@kernel.org>

On Mon, Nov 25, 2024 at 05:31:32PM +0000, Marc Zyngier wrote:
> On Fri, 22 Nov 2024 09:58:02 +0000, Bernhard Kauer <bk@alpico.io> wrote:
> > Handling of uevents in userlevel is a bottleneck for tiny VMs.
> > 
> > Running 10_000 VMs keeps one and a half cores busy for 5.4 seconds to let
> > systemd-udevd handle all messages.  That is roughly 27x longer than
> > the 0.2 seconds needed for running the VMs without them.
> > 
> > We choose a read-only module parameter here due to its simplicity and
> > ease of maintenance.
> Thanks for this. It was on my list of things to investigate, as this
> is a bottleneck when running a lot of concurrent syzkaller tests which
> create and destroy VMs repeatedly.

That is interesting.  How many tests do you have?


> I'm not overly keen on the command-line flag though, as this is the
> sort of things you'd like to be able to control more finely. Or at
> least without having to trigger a reboot.

I compile KVM as module, so I can reload it with different parameters
easily.


> How about something such as a sysctl? with the kvm namespace?

I have not seen a sysctl in KVM yet. I would probably not introduce
another config method here.  

But I can make the module parameter read-write so that it is modifiable
during runtime via /sys/module/kvm/parameters/ even when KVM is compiled
into the kernel.


	Bernhard

