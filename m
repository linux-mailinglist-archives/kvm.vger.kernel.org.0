Return-Path: <kvm+bounces-68868-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AEU9KDL6cWmvZwAAu9opvQ
	(envelope-from <kvm+bounces-68868-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:21:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECAC6528D
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 97658667D9A
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC575387572;
	Thu, 22 Jan 2026 10:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GM9e0Jjt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BFF3559F8
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769076866; cv=none; b=pXjmQhxzvUAgrBJZoWZM9MORObxvQf4M18JF7sHyfNw3mJPe5Vh1+rG5+f55+VX36Uo0zYs6lkBkhzo/d5zkYk+PRzLPH61oQoBFJWC0iy78N8RmgxTLRTthlxs/8tUqiKmt/5NF96MHpW/bG0tDudu77R2je+ZhrOY/5noc5Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769076866; c=relaxed/simple;
	bh=spO5pNCRq+zZbGZ9jRumd9r3xFl97cK4XNm1rEWzzHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4X53tZt0LRoa1r8wLwB7jHzuu/ktQUs94Wdthnone/z176/42cgiXVKBOAWEidpzE1+CeLb8Ocfw+Bzl5fY5BePE0WnUXR6iHEG62Y8kwMVFrtvjomH7jAPxtHAWw9wvNcSbJZ6qopCscP7BHhw8Bc3o2eMU5m1m1pP3Wpvrdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GM9e0Jjt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769076864;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OKR/A796DKj9EUeuDxgzN6wcJ3X4vqvcmKuu7eA6ogk=;
	b=GM9e0JjtQ+WaQL1sErrjLNqoqLoVTFZ7WT13b1UvC3KVjR6cub0zo0u8hEbWTvzWfEDAo1
	6Wfd2WlJwd93lfH/kAZt7EjmDTyVi63Q5CPZy6NTg5cdG+Cv4fKkdKI/qmu4Y+tc5DBR4k
	uISd4U0vwp8Mmzxor0i7fY2H6EURW5Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-59-IydFDCbeO1mj_eUQ8X7_zw-1; Thu,
 22 Jan 2026 05:14:20 -0500
X-MC-Unique: IydFDCbeO1mj_eUQ8X7_zw-1
X-Mimecast-MFC-AGG-ID: IydFDCbeO1mj_eUQ8X7_zw_1769076858
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBF5818005B7;
	Thu, 22 Jan 2026 10:14:17 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.63])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0BF518004D8;
	Thu, 22 Jan 2026 10:14:12 +0000 (UTC)
Date: Thu, 22 Jan 2026 10:14:09 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
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
Message-ID: <aXH4PpkC4AtccsOE@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68868-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,libvirt.org:url,instagram.com:url,berrange.com:url];
	HAS_REPLYTO(0.00)[berrange@redhat.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[berrange@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 5ECAC6528D
X-Rspamd-Action: no action

On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
> Hi Marc-André,
> I haven't seen discussion about the project ideas you posted, so I'll
> try to kick it off here for the mkosi idea here.
> 
> Thomas: Would you like to co-mentor the following project with
> Marc-André? Also, do you have any concerns about the project idea from
> the maintainer perspective?
> 
> === Reproducible Test Image Building with mkosi ===

> This project proposes using mkosi to build minimal, reproducible test
> images directly from distribution packages. mkosi is a tool for
> building clean OS images from distribution packages, with excellent
> support for Fedora and other distributions. It should be able to
> produces deterministic outputs.

Aside from what I mentioned already, the other issue I anticipate
with mkosi is the mismatch between what hardware QEMU needs to be
able to cover, vs what hardware the distros actually support.

Fedora in particular is pretty narrow in its coverage. Debian is
considerably broader.

Neither will support all the QEMU targets, let alone all the
machine types within the target.


While there is value in testing a full blown OS image, IMHO,
for most of what we need it is considerable overkill, and
thus makes functional tests slower than they would otherwise
need to be.

IMHO, our baseline for functional testing images ought to be
a Linux Kconfig recipe used to build a dedicate kernel, plus
a busybox build for the target.

This would let us create either a self contained initrd, or
a tiny root disk, both of which would reliably boot in a
barely more than a second or two, even under TCG.

This would have a number of other benefits

 * Not dependent on distros supporting the given QEMU
   target and machine type. As long as a Linux port
   exists and busybox compiles, we can test it
 
 * Identical test image functionality for every single
   target and machine type. No hodge-podge of different
   3rd party guest OS.

 * Stable forever, with all changes entirely under
   our own control. No distro changes that arbitrarily
   break our CI.

 * Easier to debug when it breaks, since there would
   be a small well defined set of logic running in
   the guest userspace

 * Fairly easy for QEMU to provide the complete and
   corresponding source for any binary images, since
   we've built it all from scratch

 * Tiny & fast downloads of pre-built images.


This would not eliminate the need for testing real OS images,
but would significantly downgrade their importance.

Functional tests could be in three groups - 'quick', as today,
'slow' the smoke tests with our miny kernel+busybox, 'thorough'
the full OS images.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


