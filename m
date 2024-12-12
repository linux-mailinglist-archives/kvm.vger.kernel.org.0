Return-Path: <kvm+bounces-33644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F659EFAC5
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:23:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6E90164EC9
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 18:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D203E221D9F;
	Thu, 12 Dec 2024 18:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbdistm4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E809B18785D
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 18:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734027699; cv=none; b=j6jVNXBwZ/i1zLThOr+oB7KN5RWvRUPCIDwA+jv5xa3w+ttXjKaPth+Rc43MHxx1Ne2dVcJUqoNGNsbkRlUyRQEMRkReC4Grr4nDLvpbs6ZJECzF8YqyeZ/sJ3R8YTczoumhasH4CBrepxX+AS5d1ndJ10MjDmUNybgYgk5jqeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734027699; c=relaxed/simple;
	bh=Hq6OjLlJYMAN2Gf30+m3NZ4eM2GB5i2CVDMhVxQY6U8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEjMsIuwT/UCv5iSq0WuFf72jwJ/N6GScNiO0GCd+zUiREBApciCxpRl4ijCxB/KFZOgqZqqDEeucnDcedqSFwZdwx7cadvbqn9vM7vhD2JATitYGoPoyYyVKBptIqTSgEe8TxQu0bKXH0g9VFL8U+v/EzbwUv1b1p6Cm0c9aCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbdistm4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56E1C4CECE;
	Thu, 12 Dec 2024 18:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734027698;
	bh=Hq6OjLlJYMAN2Gf30+m3NZ4eM2GB5i2CVDMhVxQY6U8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hbdistm4Ku4EW8V+aSzJmlx79Pkib7kA0AVAbrplpw3yy2UJAfxez2jfokClNLvJB
	 JGv0kcDgJxXbR2VXOuKMdlK+/z7MvnLO/wfVz4HFXbQqk4waIFCdaSzQO7o7Rup9LL
	 57uUK8wTaz6PnGk0Vi9cDtk6EFEaRDz5hrW1W2e8=
Date: Thu, 12 Dec 2024 19:21:34 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <2024121256-goon-ashamed-2339@gregkh>
References: <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
 <2024120410-promoter-blandness-efa1@gregkh>
 <20241204123040.7e3483a4.alex.williamson@redhat.com>
 <9015ce52-e4f3-459c-bd74-b8707cf8fd88@gmail.com>
 <2024120617-icon-bagel-86b3@gregkh>
 <20241206093733.1d887dfc.alex.williamson@redhat.com>
 <2024120721-parasite-thespian-84e0@gregkh>
 <4b9781d5-5cbc-4254-9753-014cf5a8438d@gmail.com>
 <Z1ppnnRV4aN4mZGy@infradead.org>
 <20241212111200.79b565e1.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212111200.79b565e1.alex.williamson@redhat.com>

On Thu, Dec 12, 2024 at 11:12:00AM -0700, Alex Williamson wrote:
> On Wed, 11 Dec 2024 20:42:06 -0800
> Christoph Hellwig <hch@infradead.org> wrote:
> > On Sat, Dec 07, 2024 at 11:06:15AM +0100, Heiner Kallweit wrote:
> > > Issue with this approach is that these "mdev parent" devices are partially
> > > class devices belonging to other classes. See for example mtty_dev_init(),
> > > there the device passed to us belongs to class mtty.  
> > 
> > The samples don't matter and can be fixed any time.  Or even better
> > deleted.
> 
> There is value to these.  In particular mtty exposes a dummy PCI serial
> device with two different flavors (single/dual port) that's useful for
> not only testing the mdev lifecycle behavior, but also implements the
> vfio migration API.  Otherwise testing any of this requires specific
> hardware.  I'd agree that breaking userspace API for a sample device is
> less of a blocking issue, but then we have these...
> 
> > The real question is if the i915, ccw and ap devices are
> > class devices.  From a quick unscientific grep they appear not to,
> > but we'd need to double check that.
> 
> And I'd expect that these are all linking bus devices under the
> mdev_bus class.  I understand the issue now, that from the start we
> should have been creating class devices, but it seems that resolving
> that is going to introduce a level of indirection between the new class
> device and the bus device which is likely going to have dependencies in
> the existing userspace tools.  We'll need to work through the primary
> ones and figure out contingencies for the others to avoid breaking
> userspace.  The "just remove it anyway" stance seems to be in conflict
> with the "don't break userspace" policy and I don't think we can
> instantly fix this.  Thanks,

But samples are not "real" and are not actually used.  If they were,
then shouldn't they be in the real part of the kernel?

So what are we "breaking" here?

confused,

greg k-h

