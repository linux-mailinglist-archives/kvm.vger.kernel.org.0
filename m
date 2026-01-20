Return-Path: <kvm+bounces-68657-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UAqMFAUFcGmUUgAAu9opvQ
	(envelope-from <kvm+bounces-68657-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:43:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A684D274
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E60F3ACD7B0
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D2F28136C;
	Tue, 20 Jan 2026 21:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X67plD/K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102503A89DB
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 21:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768945875; cv=none; b=JjjBhHD6nKBi03SPTwczpBfCAS6RyQOrADazMaifFXuOoOb9LBOh18UUd3nmf+0IMiPFKcDCmTuZEIkaTKk8ikPd7uYIJtBnwEM+4UED/A/ja5NagNEkA+e77OmACONoBRO4xGqOcnwC/ZXzYZQPklrWFhf6GG/kq+I9tkJOQaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768945875; c=relaxed/simple;
	bh=fSDj5TpNzNfxbNiBZ8L1IrjwlU7TOqx/MtV6NS0Pbds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1/7G2HxC5krh77WH4ADdEXTzPrumWIcTpIsUNDMJA/ZtWdhgTpWlesTbBTOBRr1UBD0rJzHkGI6vKU2ZUWADmcFTcIE1XC7/Iqgm110GhJkgV6UXcUTjhMxT3flmVL5OHH+KvtMg/d//FUC+ETR+FB1g438WxCkJIYscNo4TeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X67plD/K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768945870;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KBRUx4dw97YmqsXJNJgFtntmv+3fXVnqpHqrl3KuW4g=;
	b=X67plD/KpM6543apNQhmJwrzrda+Q6IC0GsbDqBDq+9xp4nHJ45aXPRKEAnrYuE7wWiYpq
	ONBRccvzOZD1WPqnD5cdwknMuTPlPaj7xQHT+fCDKTTDc7as1zhpUe+49yaqkcnHN9Y3Tv
	CX69sCjAXh+FwMG0KhT1ml8Mrxq42Es=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-f3THEO9YOKeWJhRRRGSdeQ-1; Tue,
 20 Jan 2026 16:51:04 -0500
X-MC-Unique: f3THEO9YOKeWJhRRRGSdeQ-1
X-Mimecast-MFC-AGG-ID: f3THEO9YOKeWJhRRRGSdeQ_1768945863
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0533F195609D;
	Tue, 20 Jan 2026 21:51:03 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.89])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A411930001A2;
	Tue, 20 Jan 2026 21:50:57 +0000 (UTC)
Date: Tue, 20 Jan 2026 21:50:54 +0000
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
Message-ID: <aW_4p65WIEuQO4UQ@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68657-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[libvirt.org:url,gitlab.com:url,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,instagram.com:url,qemu.org:url,systemd.io:url,berrange.com:url];
	HAS_REPLYTO(0.00)[berrange@redhat.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[berrange@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: C2A684D274
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
> Hi Marc-André,
> I haven't seen discussion about the project ideas you posted, so I'll
> try to kick it off here for the mkosi idea here.
> 
> Thomas: Would you like to co-mentor the following project with
> Marc-André? Also, do you have any concerns about the project idea from
> the maintainer perspective?

The idea of being able to build test images is very attractive,
however, actual deployment of any impl will run into the same
constraint we've always had. If we host disk images, then we
have the responsibility to host the complete & corresponding
source. This is a significant undertaking that we've never been
wished to take on. IMHO publishing images in GitLab CI won't
satisfy the license requireemnts.


> === Reproducible Test Image Building with mkosi ===
> 
> '''Summary:''' Build minimal, reproducible test images for QEMU
> functional tests using mkosi, replacing ad-hoc pre-built assets with a
> standardized, maintainable build system.
> 
> QEMU's functional test suite (`tests/functional/`) relies on pre-built
> images fetched from various external sources including Debian
> archives, Fedora repositories, GitHub repositories (e.g.,
> qemu-ppc-boot, linux-build-test), Linaro artifacts, and others. While
> this approach works, it has several drawbacks:
> 
> * '''Reproducibility issues''': External sources may change,
> disappear, or serve different content over time
> * '''Opacity''': The exact build configuration of these images is
> often undocumented or unknown
> * '''Maintenance burden''': When images need updates (fixes, new
> features), there's no standardized process
> * '''Inconsistency''': Images come from different sources with varying
> quality, size, and configuration
> 
> This project proposes using mkosi to build minimal, reproducible test
> images directly from distribution packages. mkosi is a tool for
> building clean OS images from distribution packages, with excellent
> support for Fedora and other distributions. It should be able to
> produces deterministic outputs.
> 
> The Ouroboros has finally caught its tail: QEMU adopts mkosi for
> testing, while mkosi continues using QEMU to exist.
> 
> '''Project Goals:'''
> 
> # Create mkosi configurations for building minimal bootable images for
> x86_64 and aarch64 architectures using Fedora packages
> # Integrate with the existing Asset framework in
> `tests/functional/qemu_test/asset.py` to seamlessly use mkosi-built
> images alongside existing assets
> # Set up GitLab CI pipelines to automatically build, hash, and publish
> images when configurations change
> # Document the image building process including comparison with
> existing tuxrun/tuxboot assets (which remain out of scope for
> replacement)
> # Migrate selected tests from external pre-built images to mkosi-built
> equivalents
> 
> '''Links:'''
> * [https://wiki.qemu.org/Testing/Functional QEMU Functional Testing
> documentation]
> * [https://github.com/systemd/mkosi mkosi project]
> * [https://gitlab.com/qemu-project/qemu QEMU GitLab repository]
> * [https://www.qemu.org/docs/master/devel/testing.html QEMU Testing
> documentation]
> * [https://mkosi.systemd.io/ mkosi documentation]
> 
> '''Details:'''
> * Skill level: intermediate
> * Language: Python (test framework), Shell/mkosi configuration
> * Mentor: Marc-André Lureau <marcandre.lureau@redhat.com> (elmarco)
> * Thomas Huth ?
> * Suggested by: Marc-André Lureau
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


