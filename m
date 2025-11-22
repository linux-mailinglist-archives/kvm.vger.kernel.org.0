Return-Path: <kvm+bounces-64287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 664ABC7D1F7
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 14:59:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0655C3482FD
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 13:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FF5222156C;
	Sat, 22 Nov 2025 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="boN+E0WV"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7545125A321
	for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763819940; cv=none; b=eNdP/GV/Bfi0q1PXt579k6AYIsJhJkLFCZEgUhZqQspB66KPaVXjzB0/x/xA2NQ3xm3WK1zoHvWr6Okomd9SdUh72vHty6ZXzSSkOUNK5K6ArdumOatOijHpguDuHs8hxLFuhM5P4n9O+8rqRYtIfHpt6slzCZkjNLtwS8h5EbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763819940; c=relaxed/simple;
	bh=73A2jJ3qDknzfJGHj6IYcBh3403pCBHBU43jtKW6tvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3t6l5kQEewEiyeAbeeOXrrOMPPCGQrg1XPOYSDuTGCnVbvk/rqe9W4asQojtMAhhmBYaavN3K9RSznY8wXzEyePTM4wSQMGAYuvAGIvghgzUNQZW9TiraR35KoTiIBnbEdwygJah1N0TAjIN1rEiCmC5de6D6nePZnTsmDKyEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=boN+E0WV; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=AEXZEuTJIE85z2nUo6vGRF6C9CDHEnZEtlKMj8CbeT4=; b=boN+E0WV5PWDs4yp
	E5QiNikBwzcKxOr9y3ErKBosKi8VqQlyUK8FcpSwKZRZIklWGivPv0b8RSW0Md0mlLqwACbhBB1vJ
	2xtO1APz5QqCPj2IB1son8z6yI2JWKjc/YisVf8Akz0AYURhVUPEbxbNHOCoqog6ksbOEZ8nbt3AA
	M8nUp+/I6opgxD3kBK/3L9z07BOWIsUllEtVyMmhMVILtJ3RsJeXEUUUC+EDFUwvaSRJ+Fe7/WWD/
	ixd0MwL2lJiyApfAIlZlIVvw0uVu6nd+S9a1CmPOP6ZRlcoooeZB+4RWIRymF57ys85smCTeDjJKH
	Z3Kd2MYnSTr6//8Edg==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vMo83-00000005wUV-2FTG;
	Sat, 22 Nov 2025 13:58:19 +0000
Date: Sat, 22 Nov 2025 13:58:19 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: BALATON Zoltan <balaton@eik.bme.hu>
Cc: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org,
	arei.gonglei@huawei.com, pizhenwei@bytedance.com,
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
Message-ID: <aSHBez6kYRagEL1K@gallifrey>
References: <20251120191339.756429-1-armbru@redhat.com>
 <20251120191339.756429-10-armbru@redhat.com>
 <aR-q2YeegIEPmk2R@gallifrey>
 <87see8q6qm.fsf@pond.sub.org>
 <aSClUIvI2W-PVv6B@gallifrey>
 <87ecpqtt6f.fsf@pond.sub.org>
 <05ef43e5-cc42-8e1c-2619-eb1dea12b02b@eik.bme.hu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <05ef43e5-cc42-8e1c-2619-eb1dea12b02b@eik.bme.hu>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 13:56:00 up 26 days, 13:32,  2 users,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* BALATON Zoltan (balaton@eik.bme.hu) wrote:
> On Sat, 22 Nov 2025, Markus Armbruster wrote:
> > "Dr. David Alan Gilbert" <dave@treblig.org> writes:
> > 
> > > * Markus Armbruster (armbru@redhat.com) wrote:
> > > > "Dr. David Alan Gilbert" <dave@treblig.org> writes:
> > > > 
> > > > > * Markus Armbruster (armbru@redhat.com) wrote:
> > > > > > Replace
> > > > > > 
> > > > > >     error_setg_errno(errp, errno, MSG, FNAME);
> > > > > > 
> > > > > > by
> > > > > > 
> > > > > >     error_setg_file_open(errp, errno, FNAME);
> > > > > > 
> > > > > > where MSG is "Could not open '%s'" or similar.
> > > > > > 
> > > > > > Also replace equivalent uses of error_setg().
> > > > > > 
> > > > > > A few messages lose prefixes ("net dump: ", "SEV: ", __func__ ": ").
> > > > > > We could put them back with error_prepend().  Not worth the bother.
> > > > > 
> > > > > Yeh, I guess you could just do it with another macro using
> > > > > the same internal function just with string concatenation.
> > > > 
> > > > I'm no fan of such prefixes.  A sign of developers not caring enough to
> > > > craft a good error message for *users*.  *Especially* in the case of
> > > > __func__.
> > > > 
> > > > The error messages changes in question are:
> > > > 
> > > >     net dump: can't open DUMP-FILE: REASON
> > > >     Could not open 'DUMP-FILE': REASON
> > > > 
> > > >     SEV: Failed to open SEV-DEVICE: REASON
> > > >     Could not open 'SEV-DEVICE': REASON
> > > > 
> > > >     sev_common_kvm_init: Failed to open SEV_DEVICE 'REASON'
> > > >     Could not open 'SEV-DEVICE': REASON
> > > > 
> > > > I think these are all improvements, and the loss of the prefix is fine.
> > > 
> > > Yeh, although I find the error messages aren't just for users;
> > > they're often for the first dev to see it to guess which other
> > > dev to pass the problem to, so a hint about where it's coming
> > > from can be useful.
> > 
> > I agree!  But I think an error message must be make sense to users
> > *first* and help developers second, and once they make sense to users,
> > they're often good enough for developers.
> > 
> > The common failures I see happen when developers remain caught in the
> > developer's perspective, and write something that makes sense to *them*.
> > Strawman form:
> > 
> >    prefix: failed op[: reason]
> > 
> > where "prefix" is a subsystem tag, or even __func__, and "reason" is
> > strerror() or similar.
> > 
> > To users, this tends to read as
> > 
> >    gobbledygook: techbabble[: reason]
> > 
> > When we care to replace "failed op" (developer's perspective) by
> > something that actually makes sense to users, "prefix" often becomes
> > redundant.
> > 
> > The error messages shown above aren't bad to begin with.  "failed to
> > open FILE", where FILE is something the user specified, should make
> > sense to the user.  It should also be good enough for developers even
> > without a prefix: connecting trouble with the DUMP-FILE to dump /
> > trouble with the SEV-DEVICE to SEV should be straightforward.
> > 
> > [...]
> 
> I think that
> 
> net dump: can't open random-filename: because of some error
> 
> shows better where to look for the problem than just
> 
> Could not open 'random-filename': because of some error
> 
> as the latter does not tell where the file name comes from or what is it. It
> could be added by a management application or added by the users randomly
> without really knowing what they are doing so repeating the option or part
> in the message that the error comes from can help to find out where to
> correct it. Otherwise it might be difficult to guess what random-filename is
> related to if it's not named something you'd expect.

Yeh agreed.  It very much depends if you think of a 'user' as the person
who typed a qemu command line, or pressed a button on a GUI that triggered
15 levels of abstraction that eventually ran a qemu.

Or for the support person who has a customer saying 'help I've got this error',
and now needs to route it to the network person rather than something else.

Dave

> Regards,
> BALATON Zoltan
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

