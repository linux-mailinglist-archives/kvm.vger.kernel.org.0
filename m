Return-Path: <kvm+bounces-34183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98DE79F87CB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 23:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E2CD18973D5
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 22:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3581D0143;
	Thu, 19 Dec 2024 22:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsLwiee8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711E31A0BE1;
	Thu, 19 Dec 2024 22:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734646984; cv=none; b=eThXcahIqw1ZNzssQz+yRTZXzAOFkjuI91OHVtfqjQqyyibtJuG1fnnycIeqcUCBurOKwz4CUYSXQdImyHCqHIwBxBEgLkeWvCFnreEIYIN6Z7PLKckhm1/Mrf1DoI83M2kg948jL12wNgPL+NtkdTCeToYy2eYBbah/eMZEGGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734646984; c=relaxed/simple;
	bh=FR9d2kllmQ9Mez3gDiL65x20y0/w7WEwMnIGAyezedU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFqN640f/TU/couiZ5DA8Le9OGRmauFeqFkgzrb0DjTveMAvmoVmaKgVybeJMeDfCe8mGn1RSzEyJRHOYtUgW8FlUKw5jUmDWnpMVA3oEqUHHYJcTjskibs6BGV+30yQbzb4SFSy04QI89tymw1x6HFhbelH7qlEEbdXwJZpcF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsLwiee8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7315FC4CECE;
	Thu, 19 Dec 2024 22:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734646983;
	bh=FR9d2kllmQ9Mez3gDiL65x20y0/w7WEwMnIGAyezedU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JsLwiee8YBHOzTkCQtxA9vdLmN2IYZe5cnfDzsYhCl8er716Y45ppPnOe0wOCOht5
	 nQbDCYs0mLmVWA3YfJUGgzyMC20bkXIw5NHX6p70C1V3UVD9rs3z2CSE5L6y25+0Vq
	 3wBZfMECo9LIjVXRRIqFe7at087TN/2iXQm8Fsfit9CS2BrK1e62ITM9/URkBXplgN
	 0pmfMjovEPaOQCK+3az4dbr2Ulsg5p5hon5y4H91TUycrwOeCAN0bp7N6K74zEpt2m
	 UYucNGKqwfPG7sV4UyWunf5e9Mavv97DsoA7UT/+2Br5xsY+4O34Ebf5G+eSxSdRtQ
	 IOl97OzarLigw==
Date: Thu, 19 Dec 2024 15:23:01 -0700
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>,
	Luca Boccassi <bluca@debian.org>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <Z2Scxe34IR5jRfdd@kbusch-mbp.dhcp.thefacebook.com>
References: <20241108130737.126567-1-pbonzini@redhat.com>
 <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>

On Thu, Dec 19, 2024 at 09:30:16PM +0100, Paolo Bonzini wrote:
> On Thu, Dec 19, 2024 at 7:09 PM Keith Busch <kbusch@kernel.org> wrote:
> > > Is crosvm trying to do anything but exec?  If not, it should probably use the
> > > flag.
> >
> > Good point, and I'm not sure right now. I don't think I know any crosvm
> > developer experts but I'm working on that to get a better explanation of
> > what's happening,
> 
> Ok, I found the code and it doesn't exec (e.g.
> https://github.com/google/crosvm/blob/b339d3d7/src/crosvm/sys/linux/jail_warden.rs#L122),
> so that's not an option. 

Thanks, I was slowly getting there too. It's been a while since I had to
work with the languange, so I'm a bit rusty (no pun intended) at
navigating.

> Well, if I understand correctly from a
> cursory look at the code, crosvm is creating a jailed child process
> early, and then spawns further jails through it; so it's just this
> first process that has to cheat.
> 
> One possibility on the KVM side is to delay creating the vhost_task
> until the first KVM_RUN. I don't like it but...
> 
> I think we should nevertheless add something to the status file in
> procfs, that makes it easy to detect kernel tasks (PF_KTHREAD |
> PF_IO_WORKER | PF_USER_WORKER).

I currently think excluding kernel tasks from this check probably aligns
with what it's trying to do, so anything to make that easier is a good
step, IMO.

