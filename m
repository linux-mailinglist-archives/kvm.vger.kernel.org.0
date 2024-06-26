Return-Path: <kvm+bounces-20545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2612D918028
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A85FD1F2148A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 11:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01121802C1;
	Wed, 26 Jun 2024 11:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="cEQI5aUl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WxL5D7Jh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1BC139D04;
	Wed, 26 Jun 2024 11:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402584; cv=none; b=p+GtCuaZJyR07iM9CnEonP+cODWIG5cAlW5aP+izOlyZPp3Pm+c4ZNJ8+HnVGWjYRjxX4dcBCw/8IpvqY508J5BMhM6fXBrn6249eQrByAa+sc0yAwweOjb0QjCpQahbeKkRE27SIdCgBvmtgUqZpD3R3nJYxu0c0gsPzx6HjYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402584; c=relaxed/simple;
	bh=5Lh37O2jhiCVEaOJh/sZBLPNDudG+Lwj5d/JZWTN6RE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axV5Vbd00rVE7HsivkA7ditfmU0KzslFrlXz4YP9ULO3vU/NvhcXslXa76hdgW5ljTntfw55pOzKbhs+QFy0taqGL0RJl95rGHLilRT2fUf8UCuTRept3ZatWrK5u7QjR6+CR8/Ft/aciTHVoInBmBo7Kaafl8PFVtv15is7faU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=cEQI5aUl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WxL5D7Jh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 699D921A16;
	Wed, 26 Jun 2024 11:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1719402580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Lh37O2jhiCVEaOJh/sZBLPNDudG+Lwj5d/JZWTN6RE=;
	b=cEQI5aUl8Osxwtn4yY2CwRSUyXVENuHCxJ1UlBpXAt4IIqTqS4RbdfmQkgNs9oM9f7g4ql
	taDIUE+asznBB2jhc12HjzRAL+SM4FeetIpUtenU6N66W11cJhEYhOSJ2dDlgCYM+GEa8B
	YBouU/7/9LTJv7Dz3rdWbYJ0eXqplY8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=WxL5D7Jh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1719402579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Lh37O2jhiCVEaOJh/sZBLPNDudG+Lwj5d/JZWTN6RE=;
	b=WxL5D7JhVJ8x674qP2k4SIUARuCB/3nCkKyWW172/Nvxxh/OM17mTU0nVEv3jrTCPa6yV4
	lrNu+eZN1e+R/RgQXRZQxPyNccdKps5sE37CQmky5wO+D0X+wAXqrRKsA/oLcLckPD+oWY
	CpDUjUG4cWQzhQLh+pprhygc682yDsc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BFB413AAD;
	Wed, 26 Jun 2024 11:49:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aa15DlMAfGapIAAAD6G6ig
	(envelope-from <mkoutny@suse.com>); Wed, 26 Jun 2024 11:49:39 +0000
Date: Wed, 26 Jun 2024 13:49:38 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Frederic Griffoul <griffoul@gmail.com>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Waiman Long <longman@redhat.com>, 
	Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mark Brown <broonie@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v5 0/2] vfio/pci: add msi interrupt affinity support
Message-ID: <rjkb6eqsagejwnmdhsxfvu3rjrmplbe6unvqmerquepd7qm2nu@ggez7xtxmgtm>
References: <20240610125713.86750-1-fgriffo@amazon.co.uk>
 <k4r7ngm7cyctnyjcwbbscvprhj3oid6wv3cqobkwt4p4j4ibfy@pvmb35lmvdlz>
 <CAF2vKzP0C1nEYTWRdWeAFKVUcuu3BkPD0FVA7yAS1rc-c=gs5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r74rwaco3a2x2q4m"
Content-Disposition: inline
In-Reply-To: <CAF2vKzP0C1nEYTWRdWeAFKVUcuu3BkPD0FVA7yAS1rc-c=gs5A@mail.gmail.com>
X-Spamd-Result: default: False [-6.11 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	RCPT_COUNT_TWELVE(0.00)[30];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLdbs4abguf4x6atqn9fu113td)];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 699D921A16
X-Spam-Flag: NO
X-Spam-Score: -6.11
X-Spam-Level: 


--r74rwaco3a2x2q4m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024 at 03:45:48PM GMT, Frederic Griffoul <griffoul@gmail.c=
om> wrote:
> To be honest my initial idea was to store an affinity mask per vfio group=
, which
> can be done in the privileged process setting the vfio group/device owner=
, and
> later apply the mask to each interrupt of each device in the group.
>=20
> It would still require to fix the affinity of all the interrupts if
> the vfio group affinity is
> changed (or deliberately ignore this case). And it did not match
> exactly my use case
> where I need the process handling the interrupts to sometimes be able
> to change them
> but always within the cpuset. So I would still need the current patch,
> in addition to
> a new ioctl() to set the affinity mask of a vfio group.

It's not clear to me what is the relation between the process A calling
that ioctl() (and whose cpuset is used to check affinity for)
and a process B that ends up handling the IRQ.
At which place would process B be scheduled on IRQ's affinity CPUs?
(I'm not familiar with VFIO.)

Thanks,
Michal

--r74rwaco3a2x2q4m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTd6mfF2PbEZnpdoAkt3Wney77BSQUCZnwAUAAKCRAt3Wney77B
SUYHAP9E4KiCr8neoUcGLa9bfsAswF2rgXTMfwxM4uRgu39xiwD/Snob+Tz8WCak
OFObvu+CpXRmtFHIcDDvsvocrEG+7wY=
=otng
-----END PGP SIGNATURE-----

--r74rwaco3a2x2q4m--

