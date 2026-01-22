Return-Path: <kvm+bounces-68887-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PVQGB4XcmksawAAu9opvQ
	(envelope-from <kvm+bounces-68887-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:25:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A958F66959
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 74B906C68BE
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9AF381710;
	Thu, 22 Jan 2026 11:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PAgGleAW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2949D3644B6
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 11:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769082057; cv=none; b=UVkppPVcZz6e4VKCrssqcbpW18MWfC0WKhycmbbM0MA+wZ5RKttZcPeDAPeVVXTfdUAAIEe209PysN0QqyfcFnJzrnKuWLkyPQWPRM83tWYav33CUD66opE+HsUGyrxUaOJJjcekN4v3qwgj6UrRjWHLlWHAbLcBYlnV0Am7gG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769082057; c=relaxed/simple;
	bh=/zdRymQH34oxbl15maoMWJwXy0/5cVI/nlD6Mmh2YiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hl2e59Kps5uJTRv2fussQGJ0/F2EwZmKBtUnCXcTxurcsGuCW205YLFeBjooM//Ik+mmAn45bvdniWn39b4fxpVFLeM03XD0zuOsK9NxwmPSqEY9yD9KTxk4TS8LEcsDm5BbG4scA25TfgF6nR+spGRmlE7qr2dleiR+LsRSbYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PAgGleAW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769082055;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=roXvgU1UIoaVctduRVEdG1PB3IOZIIwfmIIScyiFIcU=;
	b=PAgGleAWpkQZC/sVkLrh+7kHhgV+nvjB1wd6Pob5Lsr44IkSzNPxnAznEMBZsglJ3z1ZCJ
	ur1US09HXQY35agTERXYDU/Cl92E3QE4YH4/TJW/y6kzwNBHPesH0BEISOQ9C4Gnc3OYWm
	OJ9o7nxJLyFvCILYJftbDgluL2+zjG0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-vuGKawt_M2GB_JhHx6spZA-1; Thu,
 22 Jan 2026 06:40:50 -0500
X-MC-Unique: vuGKawt_M2GB_JhHx6spZA-1
X-Mimecast-MFC-AGG-ID: vuGKawt_M2GB_JhHx6spZA_1769082049
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 512ED18FF885;
	Thu, 22 Jan 2026 11:40:44 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.63])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD7B630002D8;
	Thu, 22 Jan 2026 11:40:36 +0000 (UTC)
Date: Thu, 22 Jan 2026 11:40:33 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Stefan Hajnoczi <stefanha@gmail.com>,
	Thomas Huth <thuth@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
	kvm <kvm@vger.kernel.org>, Helge Deller <deller@gmx.de>,
	Oliver Steffen <osteffen@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	German Maglione <gmaglione@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Alex Bennee <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	John Levon <john.levon@nutanix.com>,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <aXIMsdzqX33GBXh5@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
 <aXH4PpkC4AtccsOE@redhat.com>
 <CAMxuvaw04pDNzHyw5+Qcv_KfrhDTiyp+MNxpECp+HfTa5iLOGw@mail.gmail.com>
 <aXH-TlzxZ1gDvPH2@redhat.com>
 <CAFEAcA_u6QUhs+6-cyYm_qttsDiV2zHbsc-_FbTb8QzWXk6+tw@mail.gmail.com>
 <aXICpFZuNM9GG4Kv@redhat.com>
 <CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_CC(0.00)[linaro.org,gmail.com,redhat.com,nongnu.org,vger.kernel.org,gmx.de,ilande.co.uk,nutanix.com];
	TAGGED_FROM(0.00)[bounces-68887-lists,kvm=lfdr.de];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[instagram.com:url,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,berrange.com:url];
	HAS_REPLYTO(0.00)[berrange@redhat.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[berrange@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: A958F66959
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 03:28:24PM +0400, Marc-André Lureau wrote:
> Hi
> 
> On Thu, Jan 22, 2026 at 2:57 PM Daniel P. Berrangé <berrange@redhat.com> wrote:
> >
> > On Thu, Jan 22, 2026 at 10:54:42AM +0000, Peter Maydell wrote:
> > > On Thu, 22 Jan 2026 at 10:40, Daniel P. Berrangé <berrange@redhat.com> wrote:
> > > > Once we have written some scripts that can build gcc, binutils, linux,
> > > > busybox we've opened the door to be able to support every machine type
> > > > on every target, provided there has been a gcc/binutils/linux port at
> > > > some time (which covers practically everything). Adding new machines
> > > > becomes cheap then - just a matter of identifying the Linux Kconfig
> > > > settings, and everything else stays the same. Adding new targets means
> > > > adding a new binutils build target, which should again we relatively
> > > > cheap, and also infrequent. This has potential to be massively more
> > > > sustainable than a reliance on distros, and should put us on a pathway
> > > > that would let us cover almost everything we ship.
> > >
> > > Isn't that essentially reimplementing half of buildroot, or the
> > > system image builder that Rob Landley uses to produce toybox
> > > test images ?
> >
> > If we can use existing tools to achieve this, that's fine.
> >
> 
> Imho, both approaches are complementary. Building images from scratch,
> like toybox, to cover esoteric minimal systems. And more complete and
> common OSes with mkosi which allows you to have things like python,
> mesa, networking, systemd, tpm tools, etc for testing.. We don't want
> to build that from scratch, do we?

To some extent they are complementary, but in terms of what we're doing
with functional tests today, IMHO it could be almost entirely done
with buildroot images. Few of our current tests leverage significant
userspace functionality inside the guest. I'd see buildroot as being
able to provide common baseline that we could potentially even declare
to be a pre-requisite for introducing a new machine type to QEMU.

A handful of current things might need a full 3rd party distro image,
but not many, hence IMHO the bigger benefit to QEMU comes from investing
in a buildroot like approach rather than mkosi, at least at the current
time.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


