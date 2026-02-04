Return-Path: <kvm+bounces-70156-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id J5njCKb+gmmagQMAu9opvQ
	(envelope-from <kvm+bounces-70156-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 09:09:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F4F9E2EBF
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 09:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C9E07302B38E
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 08:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7056238B7B1;
	Wed,  4 Feb 2026 08:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZPdmeITQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A3220DD75
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 08:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770192540; cv=none; b=vALPUzB4+EYkJt3A4qgna1u4lGYqTGaowVx+yFVBFCe5/AscOEfp7/Ya4XSxmvKGiXOOPPG3jGtYRaUjL/oH2bi2dZu/hF94c/XoP0pxUOWrahdY9TYEx69HiS8fMHK8fEGX6RloWsifbTfOlsWfWNgMcEAor3yP4kNN7GotmBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770192540; c=relaxed/simple;
	bh=B9SwCh9y2gTvjS1kb5IFPfiPhNIzMcHz7dNu13hU/ls=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EXLAswOTd33Qa2rg/c4fbyOl+uZ08JZI615P9zGr2hcwANTVWS6bfLzJJ7bkm5XdbXylLYKU+eHZ4tpmkW3xTW8pEfE3Td9kHNhdBfpi9yZCt6yF8QhyNEgI2rJAdoSStDvCiVG9kyKBfD0BehqsCoYvIQqEwEBIljgidrYhdsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZPdmeITQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770192539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GQYc7vzJ+vLiqRcVbL9Fy4WFqd+/9YmBpyNDssdXXt0=;
	b=ZPdmeITQVzBiukMMyRHOhh96Jvb8RP6hPoo4Tr8JDfhSEyPlfM/1ERjyptRuVUAB3C2ACN
	VXyr5VypU+KDN3J0/WowxBA7f62RmMmZ6O17Ez9b3YgB/QcYI2XqHpGyDzmMCbjuOu0ssY
	EchtiNFYLId16d4yQf0UA2rjrsuQsmY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-PC0MjxkQOJK99x-KRUBCzg-1; Wed,
 04 Feb 2026 03:08:55 -0500
X-MC-Unique: PC0MjxkQOJK99x-KRUBCzg-1
X-Mimecast-MFC-AGG-ID: PC0MjxkQOJK99x-KRUBCzg_1770192534
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E88F1800349;
	Wed,  4 Feb 2026 08:08:53 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.22])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BD2730001A5;
	Wed,  4 Feb 2026 08:08:52 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DE3BE21E692D; Wed, 04 Feb 2026 09:08:49 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Fabiano
 Rosas
 <farosas@suse.de>,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  Stefan Hajnoczi <stefanha@gmail.com>,  qemu-devel
 <qemu-devel@nongnu.org>,  kvm <kvm@vger.kernel.org>,  Helge Deller
 <deller@gmx.de>,  Oliver Steffen <osteffen@redhat.com>,  Stefano
 Garzarella <sgarzare@redhat.com>,  Matias Ezequiel Vara Larsen
 <mvaralar@redhat.com>,  Kevin Wolf <kwolf@redhat.com>,  German Maglione
 <gmaglione@redhat.com>,  Hanna Reitz <hreitz@redhat.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Thomas Huth <thuth@redhat.com>,  Mark Cave-Ayland
 <mark.cave-ayland@ilande.co.uk>,  Alex Bennee <alex.bennee@linaro.org>,
  Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Re: Modern HMP
In-Reply-To: <aX-boauFX2Ju7x8Z@gallifrey> (David Alan Gilbert's message of
	"Sun, 1 Feb 2026 18:29:53 +0000")
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
	<CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
	<871pjigf6z.fsf_-_@pond.sub.org> <aXH1ECZ1Nchui9ED@redhat.com>
	<87ikctg8a8.fsf@pond.sub.org> <aXIWLi656H8VbrPE@redhat.com>
	<87ikctk5ss.fsf@suse.de> <aXJJkd8g0AGZ3EVv@redhat.com>
	<aX-boauFX2Ju7x8Z@gallifrey>
Date: Wed, 04 Feb 2026 09:08:49 +0100
Message-ID: <875x8d0w32.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70156-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,suse.de,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[armbru@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6F4F9E2EBF
X-Rspamd-Action: no action

"Dr. David Alan Gilbert" <dave@treblig.org> writes:

> * Daniel P. Berrang=C3=A9 (berrange@redhat.com) wrote:
>> On Thu, Jan 22, 2026 at 12:47:47PM -0300, Fabiano Rosas wrote:
>> > One question I have is what exactly gets (eventually) removed from QEMU
>> > and what benefits we expect from it. Is it the entire "manual"
>> > interaction that's undesirable? Or just that to maintain HMP there is a
>> > certain amount of duplication? Or even the less-than-perfect
>> > readline/completion aspects?
>>=20
>> Over time we've been gradually separating our human targetted code from
>> our machine targetted code, whether that's command line argument parsing,
>> or monitor parsing. Maintaining two ways todo the same thing is always
>> going to be a maint burden, and in QEMU it has been especially burdensome
>> as they were parallel impls in many cases, rather than one being exclusi=
vely
>> built on top of the other.
>>=20
>> Even today we still get contributors sending patches which only impl
>> HMP code and not QMP code. Separating HMP fully from QMP so that it
>> was mandatory to create QMP first gets contributors going down the
>> right path, and should reduce the burden on maint.
>
> Having a separate HMP isn't a bad idea - but it does need some idea of
> how to make it easy for contributors to add stuff that's just for debug
> or for the dev.   For HMP the bar is very low; if it's useful to the
> dev, why not (unless it's copying something that's already in the QMP int=
erface
> in a different way);  but although the x- stuff in theory lets
> you add something via QMP, in practice it's quite hard to get it through
> review without a lot of QMP design bikeshedding.

I think this description has become less accurate than it used to be :)

A long time ago, we started with "QMP is a stable, structured interface
for machines, HMP is a plain text interface for humans, and layered on
top of QMP."  Layered on top means HMP commands wrap around QMP
commands.  Ensures that QMP is obviously complete.  Without such a
layering, we'd have to verify completeness by inspection.  Impractical
given the size and complexity of the interfaces involved.

Trouble is there are things in HMP that make no sense in QMP.  For
instance, HMP command 'cpu' sets the monitor's default CPU, which
certain HMP commands use.  To wrap 'cpu' around a QMP command, we'd have
to drag the concept "default CPU" into QMP where it's not wanted.

So we retreated from "all", and permitted exceptions for commands that
make no sense in QMP.

We then found out the hard & expensive way that designing a QMP command
with its stable, structured interface is often a lot harder than
cobbling together an HMP command.  It's not just avoidable social
problems ("bikeshedding"); designing stable interfaces is just hard.
Sometimes the extra effort is worthwhile.  Sometimes it's not, e.g. when
all we really want is print something to aid a human with debugging.

So we retreated from "all" some more, and permitted exceptions for
commands meant exclusively for human use, typically debugging and
development aids.

This effectifely redefined the meaning of "complete": instead of "QMP
can do everything HMP can do and more", it's now "... except for certain
development and debugging aids and maybe other stuff".

To keep "maybe other stuff" under control, we required (and still
require) an *argument* for adding functionality just to HMP.

This turned out to be differently bothersome.  Having to review HMP
changes for QMP bypasses is bothersome, and bound to miss things at
least occasionally.  Having to ask for an argument is bothersome.
Constructing one is bothersome.

To reduce the bother, we retreated from another QMP ideal: the
structured interface.  Permit QMP commands to return just text when the
command is meant just for humans.  Such commands must be unstable.
Possible because we had retreated from "all of QMP is stable" meanwhile.

How does this work?  Instead of adding an HMP-only command, add a QMP
command that returns QAPI type HumanReadableText, and a trivial HMP
command that wraps around it.  Slightly more work, but no interface
design.

The QMP command addition is much more visible to the QAPI/QMP
maintainers than an HMP-only command would be.  This helps avoid missing
things.

We still want an argument why a structured interface isn't needed.  But
we can be much more lenient there: if it turns out to be needed, we can
just add it, and drop the unstructured interface.  Remember, it's
unstable.

Hope this helps.


