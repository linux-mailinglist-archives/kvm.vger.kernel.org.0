Return-Path: <kvm+bounces-68907-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KMWcIC9ZcmkpiwAAu9opvQ
	(envelope-from <kvm+bounces-68907-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:06:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A2D6AC74
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1B2113055665
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E295A3D649A;
	Thu, 22 Jan 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hD1TXWNG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7881E3D647A
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097638; cv=none; b=pmN09+EC+mNJjGayf0dHgwRHGAi4h7bNMQT9ZZzOvysdXhu5S+nezb9mxFMjS/ox7CkqvWSe2HRQ6/Q6TQhVEonkyebw3RH9hTn9st5n9u5rCE32RBqghtUcUCkiYCQQFWSWiR6DuoTPt/w32APkqXCED7m2TbEUpBoZP282IEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097638; c=relaxed/simple;
	bh=XnKAwO0yUTasmFWNWowWhkvsk3AGb+0t6qJNdQnFUe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wx6IlbSMIpSmGeAruxf8IUGIPMnJNFZJhQx9LX3mu1wJrWM5P+J2hwxnn6QgXcTAoVWwCpdi2pG6FUOb0Bl1FJDGmELk+V6njW+2moxFwBgbYRpW2oo6f7qzMGo/O4UBWGxus8nYlSrEA4D6sQZ6XCHmISzqxavtEV6Zll1BlG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hD1TXWNG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769097630;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=jHh0MFWSMKz2Mm8GLTGEiKUH5WEgc8+dxDyDtFMoWFE=;
	b=hD1TXWNGkWXHw4v3i6iTRO+q5kgbmnAjZ47sg79jYk/dM621MjOxky3eZust4kApWdrOJX
	TwioGOiXdCfexOD8w29B+vikIgsLNjqr72gjphVH7eYjY6xeTO7GhR0/8kQTUgqI+qyFiw
	K4kmg1njsfFV4sBtQIJk2qOwy1COu3g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-CWeYt54yN8yqA20RDrVH-w-1; Thu,
 22 Jan 2026 11:00:27 -0500
X-MC-Unique: CWeYt54yN8yqA20RDrVH-w-1
X-Mimecast-MFC-AGG-ID: CWeYt54yN8yqA20RDrVH-w_1769097626
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B39F118002CC;
	Thu, 22 Jan 2026 16:00:25 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.63])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B339918004D8;
	Thu, 22 Jan 2026 16:00:20 +0000 (UTC)
Date: Thu, 22 Jan 2026 16:00:17 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Fabiano Rosas <farosas@suse.de>
Cc: Markus Armbruster <armbru@redhat.com>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	Stefan Hajnoczi <stefanha@gmail.com>,
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	German Maglione <gmaglione@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Alex Bennee <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Re: Modern HMP
Message-ID: <aXJJkd8g0AGZ3EVv@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <871pjigf6z.fsf_-_@pond.sub.org>
 <aXH1ECZ1Nchui9ED@redhat.com>
 <87ikctg8a8.fsf@pond.sub.org>
 <aXIWLi656H8VbrPE@redhat.com>
 <87ikctk5ss.fsf@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ikctk5ss.fsf@suse.de>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.45 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_FROM(0.00)[bounces-68907-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[instagram.com:url,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,libvirt.org:url,berrange.com:url];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[berrange@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	HAS_REPLYTO(0.00)[berrange@redhat.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 24A2D6AC74
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 12:47:47PM -0300, Fabiano Rosas wrote:
> One question I have is what exactly gets (eventually) removed from QEMU
> and what benefits we expect from it. Is it the entire "manual"
> interaction that's undesirable? Or just that to maintain HMP there is a
> certain amount of duplication? Or even the less-than-perfect
> readline/completion aspects?

Over time we've been gradually separating our human targetted code from
our machine targetted code, whether that's command line argument parsing,
or monitor parsing. Maintaining two ways todo the same thing is always
going to be a maint burden, and in QEMU it has been especially burdensome
as they were parallel impls in many cases, rather than one being exclusively
built on top of the other.

Even today we still get contributors sending patches which only impl
HMP code and not QMP code. Separating HMP fully from QMP so that it
was mandatory to create QMP first gets contributors going down the
right path, and should reduce the burden on maint.

At some point we are likely to introduce a new non-backwards compatible
QEMU binary. Perhaps when Philippe completes his "all targets/machines
in one binary" work. That would be an opportunity to carve HMP off
into a separate out of process facade talking over QMP.

That's only possible though if we get existing HMP into being a layer
over QMP with no backdoor parallel impls. So anything we can do today
to better separate QMP/HMP will give us more flexibility when the time
arrives to create a new QEMU binary without backwards compat cruft.

NB, introducing a new binary does not imply that the old binaries
go away. They would probably stick around for legacy compat for a
good while. For anything using libvirt though, we would be able to
switch to the new binaries pretty fast without, as libvirt can
translate app XML config to either the new or old QEMU dynamically.

> Does the new program becomes basically an external project unrelated to
> QEMU, that simply talks to QMP like libvirt does?

It could be a separate project under QEMU on github, or it could just be
binary in qemu.git. What matters is that it is out of the main QEMU process
eventually.

> I wonder how close to tools like qmp-shell, qmp-tui, etc that would
> become and whether we might actually be looking at a substitute of
> qemu.qmp.

qmp-shell is rather too crude in terms of its data input/output - have
to switch to JSON way too much, and there's no mechanism for formatting
complex QMP replies into pretty human friendly data.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


