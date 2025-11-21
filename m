Return-Path: <kvm+bounces-64183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0E7C7B1E1
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CF4D34E7E89
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 17:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 575E334FF64;
	Fri, 21 Nov 2025 17:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="hlMINAee"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43962C158E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 17:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763747182; cv=none; b=mlGPvqT4aRH95Pl1jX3R3g0I5+SAGYXVBt30OVbjpaY+kzJQ7vp+IYNGq1Lz068qkxrCjOTmpHW/ybBIcouFuF8KewUB3EpHb13i17ut4ytfoz6nSuXXZezapSaSVvcvKVKlKRdRITY4fkI5m6QDb4hQbM2xrxIP+LDyyqQHSR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763747182; c=relaxed/simple;
	bh=9EcfhU/trJ5fSGGq60exRWbQV+h2OeJnXnFo5xCUz0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcBisjFyAcoHlhQgBO1rwc8QVnjG5J2Azf6AO2wbrpC1/na67pvkRqb5+ocIPhg2G8Obi/mTyzMY0tJXr0ZdWE9nzMYMlUa9ZrVudnRmE6xOr+U/uI9PX/zBvbkFSCF9239mO0PdmmP0Nxk7n2EPhgj5IUA1yuErXzyBcVU6IXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=hlMINAee; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=xZBmjOGSZoa+2aL5x4woIrYjfLg3sU220QEFMHUTJpM=; b=hlMINAeetPLPFGP9
	DCXVzhiePadQthcnxsCXyVmnW6VwsN1f99YyTIMGXBLFzlLAwQCCfRhohhA8JHQw9WopgvmlZSNe9
	ChraoHtEO7/JtJnq3fVoHZSpK0yD4PJlxvZ3fXI/CMaLqwdygqlojLOxzQicqgvH6rEKIaYV5q+dC
	9fF4budUObNUXPneqDI13Oa2zg4oAEkUQwrwYAbtWiuXFycihblAtcYwuw9rIQQxGhcvtCahj4M19
	h+hB/OQXLls/7hLaOzXx6U9CGb2mAaDDOK7VGfvA3Pz2jzo1yj5RRGthzOR1lOLnIa/nKutnvrU+1
	aFYpkjxx4ViSutOaLw==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vMVCi-00000005pJs-2dXP;
	Fri, 21 Nov 2025 17:45:52 +0000
Date: Fri, 21 Nov 2025 17:45:52 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, arei.gonglei@huawei.com, pizhenwei@bytedance.com,
	alistair.francis@wdc.com, stefanb@linux.vnet.ibm.com,
	kwolf@redhat.com, hreitz@redhat.com, sw@weilnetz.de,
	qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
	imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
	shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
	sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
	edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com,
	jag.raman@oracle.com, sgarzare@redhat.com, pbonzini@redhat.com,
	fam@euphon.net, philmd@linaro.org, alex@shazbot.org, clg@redhat.com,
	peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
	jasowang@redhat.com, samuel.thibault@ens-lyon.org,
	michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
	mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
	liwei1518@gmail.com, dbarboza@ventanamicro.com,
	zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
	qemu-block@nongnu.org, qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
	qemu-riscv@nongnu.org
Subject: Re: [PATCH 09/14] error: Use error_setg_file_open() for simplicity
 and consistency
Message-ID: <aSClUIvI2W-PVv6B@gallifrey>
References: <20251120191339.756429-1-armbru@redhat.com>
 <20251120191339.756429-10-armbru@redhat.com>
 <aR-q2YeegIEPmk2R@gallifrey>
 <87see8q6qm.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87see8q6qm.fsf@pond.sub.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 17:44:26 up 25 days, 17:20,  2 users,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Markus Armbruster (armbru@redhat.com) wrote:
> "Dr. David Alan Gilbert" <dave@treblig.org> writes:
>=20
> > * Markus Armbruster (armbru@redhat.com) wrote:
> >> Replace
> >>=20
> >>     error_setg_errno(errp, errno, MSG, FNAME);
> >>=20
> >> by
> >>=20
> >>     error_setg_file_open(errp, errno, FNAME);
> >>=20
> >> where MSG is "Could not open '%s'" or similar.
> >>=20
> >> Also replace equivalent uses of error_setg().
> >>=20
> >> A few messages lose prefixes ("net dump: ", "SEV: ", __func__ ": ").
> >> We could put them back with error_prepend().  Not worth the bother.
> >
> > Yeh, I guess you could just do it with another macro using
> > the same internal function just with string concatenation.
>=20
> I'm no fan of such prefixes.  A sign of developers not caring enough to
> craft a good error message for *users*.  *Especially* in the case of
> __func__.
>=20
> The error messages changes in question are:
>=20
>     net dump: can't open DUMP-FILE: REASON
>     Could not open 'DUMP-FILE': REASON
>=20
>     SEV: Failed to open SEV-DEVICE: REASON
>     Could not open 'SEV-DEVICE': REASON
>=20
>     sev_common_kvm_init: Failed to open SEV_DEVICE 'REASON'
>     Could not open 'SEV-DEVICE': REASON
>=20
> I think these are all improvements, and the loss of the prefix is fine.

Yeh, although I find the error messages aren't just for users;
they're often for the first dev to see it to guess which other
dev to pass the problem to, so a hint about where it's coming
=66rom can be useful.

Dave

> >> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> >
> > Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>
>=20
> Thanks!
>=20
--=20
 -----Open up your eyes, open up your mind, open up your code -------  =20
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \=20
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

