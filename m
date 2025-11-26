Return-Path: <kvm+bounces-64652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C7FC8990E
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 12:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E0A854E7A49
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 11:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621D6322C88;
	Wed, 26 Nov 2025 11:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="figlf+6+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7323726F28D;
	Wed, 26 Nov 2025 11:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764157183; cv=none; b=UtJcrrttlZj+v9PgI6/FrLf5a+gtFYllGukteKvzun50XC+Ooy4q1xsDqv8//YQeIuJY6i4i0FejgFGsnpwrtoj8pKjQzVTkFAccElcX4ctuc8lvLniYx0m4mDdpDsnQfV5M2rPz7vhzdNIdE3P2YEu8sv3MiVAGlKEMpWC8Vbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764157183; c=relaxed/simple;
	bh=JLe5APvz+evuFEy3wjsLvK0Hbz/XcpRv+H+6jR3KGXY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mc9UbnNemTmtHHwfKisswy9Q3lzPoYETR0aoD9OJJWsWxEFLJ25pwW91XeJRbvqYv1qg5bjcgwKqPbZijJV6rTGACgdybp7G/jpt07EByO857VwhPsQmLKs+qx6jM8nxOuWhs79VvC69rQj8sjf09+eO6zv3250wBOl3KJMChoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=figlf+6+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764157182; x=1795693182;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=JLe5APvz+evuFEy3wjsLvK0Hbz/XcpRv+H+6jR3KGXY=;
  b=figlf+6+4sglnSYS3dtHh35D9ynmQMEwIyDSI2YUJfBaxzAFioEAIEwC
   TFJGGu8Bhsq8PwfYADSWcHleRuwmZSlF6ca+qDJw5kDW7DniGmwA18Pvu
   TXCgtmS2Mu8VdU3NM6B6CmGz26n/JIRb2Dj11mj8yDG2zhPgFhP0ed54b
   J/fB9NOukjcmMkxMeZ7plbRFsMNJjPsnPMlZ3YEXjB59dMLl+l+5NRto6
   Radj941pT8riXV9N68LQWDHcoef5gzou+EQmc0FC/6TEu+n8Werw2+AbP
   tPo6pr/+dZrR2N7IIaso5bMi9K5F7RvVMe0O09MvV3kPIYbHXC4GcXXT0
   w==;
X-CSE-ConnectionGUID: pOS18Kz2R4qTn0uCGbbTsQ==
X-CSE-MsgGUID: PKNJurXdRJSlHSuAd+y2GA==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66139271"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="66139271"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:39:41 -0800
X-CSE-ConnectionGUID: /uDktke5SmqHYYSFiF6NmQ==
X-CSE-MsgGUID: Zn55xgyiTfWsw5cJenD7bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="223879744"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.245.127]) ([10.245.245.127])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:39:36 -0800
Message-ID: <4ebdc75ce1052735eb90b4cb062be98efc6ca5ce.camel@linux.intel.com>
Subject: Re: [PATCH v6 0/4] vfio/xe: Add driver variant for Xe VF migration
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>, Alex Williamson
 <alex@shazbot.org>
Cc: =?UTF-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Lucas De
 Marchi <lucas.demarchi@intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Jason Gunthorpe	 <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin
 Tian	 <kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>, 
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Michal Wajdeczko <michal.wajdeczko@intel.com>, 
	dri-devel@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
  Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie	 <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Lukasz Laguna	 <lukasz.laguna@intel.com>, Christoph
 Hellwig <hch@infradead.org>
Date: Wed, 26 Nov 2025 12:39:34 +0100
In-Reply-To: <c5f1344daeec43e5b5d9e6536c8c8b8a13323f7a.camel@linux.intel.com>
References: <20251124230841.613894-1-michal.winiarski@intel.com>
		 <20251125131315.60aa0614.alex@shazbot.org>
		 <aSZVybx3cgPw6HQh@lstrano-desk.jf.intel.com>
	 <c5f1344daeec43e5b5d9e6536c8c8b8a13323f7a.camel@linux.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-11-26 at 12:38 +0100, Thomas Hellstr=C3=B6m wrote:
> On Tue, 2025-11-25 at 17:20 -0800, Matthew Brost wrote:
> > On Tue, Nov 25, 2025 at 01:13:15PM -0700, Alex Williamson wrote:
> > > On Tue, 25 Nov 2025 00:08:37 +0100
> > > Micha=C5=82 Winiarski <michal.winiarski@intel.com> wrote:
> > >=20
> > > > Hi,
> > > >=20
> > > > We're now at v6, thanks for all the review feedback.
> > > >=20
> > > > First 24 patches are now already merged through drm-tip tree,
> > > > and
> > > > I hope
> > > > we can get the remaining ones through the VFIO tree.
> > >=20
> > > Are all those dependencies in a topic branch somewhere?=C2=A0
> > > Otherwise
> > > to
> > > go in through vfio would mean we need to rebase our next branch
> > > after
> > > drm is merged.=C2=A0 LPC is happening during this merge window, so we
> > > may
> > > not be able to achieve that leniency in ordering.=C2=A0 Is the better
> > > approach to get acks on the variant driver and funnel the whole
> > > thing
> > > through the drm tree?=C2=A0 Thanks,
> >=20
> > +1 on merging through drm if VFIO maintainers are ok with this.
> > I've
> > done this for various drm external changes in the past with
> > maintainers
> > acks.
> >=20
> > Matt
>=20
> @Michal Winiarski
>=20
> Are these patches depending on any other VFIO changes that are queued
> for 6.19?=20
>=20
> If not and with proper VFIO acks, I could ask Dave / Sima to allow
> this
> for drm-xe-next-fixes pull. Then I also would need a strong
> justification for it being in 6.19 rather in 7.0.
>=20
> Otherwise we'd need to have the VFIO changes it depends on in a topic
> branch, or target this for 7.0 and hold off the merge until we can
> backmerge 6.9-rc1.

6.19-rc1

/Thomas


>=20
> Thanks,
> Thomas
>=20
>=20
> >=20
> > >=20
> > > Alex
>=20


