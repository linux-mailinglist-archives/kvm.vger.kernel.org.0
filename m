Return-Path: <kvm+bounces-68896-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPm2Nps9cmnpfAAAu9opvQ
	(envelope-from <kvm+bounces-68896-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:09:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 701ED68676
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A8C528EB5A4
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 14:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30703375C5;
	Thu, 22 Jan 2026 14:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a7y4B1mr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E49328B77
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769090615; cv=none; b=K6/tSsMKQIU+dOiR88BfrObmgcaC8TAc8wXjLj7smhDvL6bL6fBgEz8yw4MSsX7+FnczfiHfcW2lEKN2FvLYlsbqKIVzEyycHGlYipSt4KRJfSdWetsiPJIme+qqyZ8+kzSqGvUgu7f8p26InN/aQ/RHr6J81iBa8s4xLr3PM58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769090615; c=relaxed/simple;
	bh=P49x7mRLDJdWMtytHUEI5iAVkz27dkvaOPV4gHVzlww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSRdKOmw35wDxs1xQgABw5SeLTT2n727aqqG/qgwpHzavjBFXeFUhua4whaxGR+i4xmTS+O8HKcJWBL7pIfmokJhsRm8HPP2TxKt0bw6FHdnr2kZWnqkbJrzsXTYTu5ijvJMsg/IrqSliTv2hGsfDTGOZBWqdWcgNFwIDTiX2w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a7y4B1mr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769090612;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L/bbK9NHZ3/kLc4d6N5yR+dpW0QJwh6SZPuZRK4Yq3I=;
	b=a7y4B1mr8lDEKnoeTeH3jYr6xGjEgSCxZycd/8ntoobHqbNyUXfrsXy4Xy5SK1+ucu+q4a
	7MRNZVgHFtiF1n0BjA87yevxwb5y9vYzKC6sGKx9B+dxBISSx1lHXzaCCTIbIe/+y5g84u
	HcpNbP3D/wULWndO2Gm1fe6LpnKZdsg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-D05U24p3NkSPVCKr2oBHgQ-1; Thu,
 22 Jan 2026 09:03:29 -0500
X-MC-Unique: D05U24p3NkSPVCKr2oBHgQ-1
X-Mimecast-MFC-AGG-ID: D05U24p3NkSPVCKr2oBHgQ_1769090608
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C273D1886244;
	Thu, 22 Jan 2026 14:03:19 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.63])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8781B1958DC5;
	Thu, 22 Jan 2026 14:03:14 +0000 (UTC)
Date: Thu, 22 Jan 2026 14:03:11 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
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
Message-ID: <aXIuH1J5A0IJ1-5M@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <871pjigf6z.fsf_-_@pond.sub.org>
 <aXH1ECZ1Nchui9ED@redhat.com>
 <87ikctg8a8.fsf@pond.sub.org>
 <aXIWLi656H8VbrPE@redhat.com>
 <875x8teqxj.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875x8teqxj.fsf@pond.sub.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.25 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-68896-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	DBL_BLOCKED_OPENRESOLVER(0.00)[instagram.com:url,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,entangle-photo.org:url];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	HAS_REPLYTO(0.00)[berrange@redhat.com];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[berrange@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 701ED68676
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 02:07:52PM +0100, Markus Armbruster wrote:
> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
> > On Thu, Jan 22, 2026 at 01:07:43PM +0100, Markus Armbruster wrote:
> 
> [...]
> 
> >> Marc-André proposed Python or Rust.  Anyone got a preference backed by
> >> reasons?
> >
> > My suggestion would be Rust, as it allows the possibility to embed
> > that Rust impl inside the current QEMU binaries, to fully replace
> > the C code and retain broadly the same functionality.
> >
> > We might never do it, but it feels like a good idea to keep the
> > door option.  Python rules that out entirely meaning we keep the
> > current C code forever, unless we do a full break with command
> > line compatibility at some point.
> 
> qemu-system-FOO could conceivably spawn the standalone HMP program
> connected to a dedicated QMP monitor.

Certainly a technical option, but I would consider it undesirable
to impose the python runtime on all current usage of QEMU that wants
HMP.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


