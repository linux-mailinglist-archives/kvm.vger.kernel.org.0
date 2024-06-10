Return-Path: <kvm+bounces-19244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E83C79026C5
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 18:32:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72C1E1F225F4
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B221474DA;
	Mon, 10 Jun 2024 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Cmozzbsw";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Xc3cTz4m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D89F839E4;
	Mon, 10 Jun 2024 16:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037116; cv=none; b=Dtlh4L9PRhxNAK8aQ8TONGEgPWnFXHirm2Nd7Z2lGNi1LBppVq026x4t4NJDl/sSAo8w9jYikOK4FvnHJuH7HP6Jai2jVF/T1qNU05AI5OXxJwOQz7Eil3yyGNuSvKg/BEm8Mz2MxaoHPn6/u/0+tAb82T/X0/CNHHAVNfLn2a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037116; c=relaxed/simple;
	bh=N3di2r23JypfAl5MTEhPDveOqgwx+6z3BLi27InIyAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGyCXurktb9g4PDtnHeHnyHKsApplA+Fd/TfHnT4f7ymZlb9JJYTHhtGDE/qDp8xQdlxKHkMHOF1gj7tntca97VbvV86tAPDTpaNGHOro92PT6hwmS9pjSvO2VNVgJLjhg+Iug/Eap5EbnQxiZ4PIlilYFw8Y0PNrR7i5iwyr9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Cmozzbsw; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Xc3cTz4m; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 18AFE21E75;
	Mon, 10 Jun 2024 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1718037112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3di2r23JypfAl5MTEhPDveOqgwx+6z3BLi27InIyAA=;
	b=Cmozzbsw8dV1XhI5Ks/8pK8BSluXi+OZg8CcCAE7eORnAlnB7JhWkbTp79fwDr6w3+BLPn
	oekUCJhU3Hgu3N/YohopicxhsF9XcLGSgjPkYwe666OKoYOz008LUhCvBLAex4n0+i00v3
	QO10vUIpdXip9VjYnrNhk8rHjHW0kxY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1718037111; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3di2r23JypfAl5MTEhPDveOqgwx+6z3BLi27InIyAA=;
	b=Xc3cTz4m+/u/dVB+/E49W0F3wsFj/S4HLX2u49jTj887YXt9dInjbC0l/Hjsns4kQZ2IjY
	nz8u26uZyFDM42ruVw4YPoL2RSp6oCDgIW8wuAtiukqaTeJYkplr5/uC0YW3LLQjb8htVt
	CQqXRSQnzTQi7icrg/cpYdzTdgYAufQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFFA713A7F;
	Mon, 10 Jun 2024 16:31:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YDxpOnYqZ2bqaQAAD6G6ig
	(envelope-from <mkoutny@suse.com>); Mon, 10 Jun 2024 16:31:50 +0000
Date: Mon, 10 Jun 2024 18:31:49 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Fred Griffoul <fgriffo@amazon.co.uk>
Cc: griffoul@gmail.com, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mark Rutland <mark.rutland@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mark Brown <broonie@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Jeremy Linton <jeremy.linton@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, 
	Kevin Tian <kevin.tian@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Christian Brauner <brauner@kernel.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ye Bin <yebin10@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v5 0/2] vfio/pci: add msi interrupt affinity support
Message-ID: <k4r7ngm7cyctnyjcwbbscvprhj3oid6wv3cqobkwt4p4j4ibfy@pvmb35lmvdlz>
References: <20240610125713.86750-1-fgriffo@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rbxiec5rtsu2tqmi"
Content-Disposition: inline
In-Reply-To: <20240610125713.86750-1-fgriffo@amazon.co.uk>
X-Spam-Level: 
X-Spamd-Result: default: False [-5.87 / 50.00];
	BAYES_HAM(-2.97)[99.89%];
	SIGNED_PGP(-2.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[30];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,arm.com,kernel.org,redhat.com,bytedance.com,cmpxchg.org,linux.dev,ziepe.ca,intel.com,nvidia.com,huawei.com,lists.infradead.org,vger.kernel.org];
	R_RATELIMIT(0.00)[to_ip_from(RLs4bg81ntywruwbpnkcfhozwy)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amazon.co.uk:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -5.87
X-Spam-Flag: NO


--rbxiec5rtsu2tqmi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Fred.

On Mon, Jun 10, 2024 at 12:57:06PM GMT, Fred Griffoul <fgriffo@amazon.co.uk> wrote:
> The usual way to configure a device interrupt from userland is to write
> the /proc/irq/<irq>/smp_affinity or smp_affinity_list files. When using
> vfio to implement a device driver or a virtual machine monitor, this may
> not be ideal: the process managing the vfio device interrupts may not be
> granted root privilege, for security reasons. Thus it cannot directly
> control the interrupt affinity and has to rely on an external command.

External commands something privileged? (I'm curious of an example how
this is setup.)

> The affinity argument must be a subset of the process cpuset, otherwise
> an error -EPERM is returned.

I'm not sure you want to look at task's cpuset mask for this purposes.

Consider setups without cpuset or a change of (cpuset) mask anytime
during lifetime of the task...

Michal

--rbxiec5rtsu2tqmi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZmcqcwAKCRAGvrMr/1gc
jmkBAQCja3OL36wbZrX33f/BCxgTsGyEe2Buh2DsgnbWTikxCAEAguitmv3gNJZj
PWDNgoj9nHp+v218OHZhAu8PFmSWXAA=
=9DxI
-----END PGP SIGNATURE-----

--rbxiec5rtsu2tqmi--

