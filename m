Return-Path: <kvm+bounces-70599-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iC7SOk3piWlnEAAAu9opvQ
	(envelope-from <kvm+bounces-70599-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 15:03:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 48627110027
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 15:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0CA68302C6E0
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 14:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856113783A9;
	Mon,  9 Feb 2026 14:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FjGUTD6b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9258E1BC2A
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770645700; cv=none; b=DyavY+igwdnUZRVuCGk4QuqpgvukfuUJta6mbor30fvl/3qTq4s5m9DLmBCjuZR/J91BMinl+4oA5BGXBX05GPImTu+EKNm339zO6c0NuU1HgfbJoC47g1WgBmBL5RgpNQW10ofdlLzHkJP83ghRyXJdAyR5B/LG+DLgssq9CoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770645700; c=relaxed/simple;
	bh=H7SHg/HIQVCFd5+yTlv/QbGyurju2rQwRMv6s9OaPUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/Ce4K1/3RKk6oGcdcUmGjPQ6rPq9DIV8wc6I6gUfOPSpgwguAzebaeaXoxUW/Y8czfAogNNBO/lmDAZzfySYmKJnrRQW6CpnEtlUw1ca5kNPMrFkmeesMbxOI+5TFXQViHjtmlQKrTVrYQxRWjiv6pYe7UKrRtgG0sSYZeTDow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FjGUTD6b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770645699;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b8omTL/Q2D7P0BE2Jd0peC7Yv2e28e01vw3FhakdFHA=;
	b=FjGUTD6bihD1Ijx2205GUf4K4Ht9Py6dmZF3NF8HYe+tohc8BUSy7XBp0JS2Z/iOuSAHt2
	KtnxNQGc9XysiKD+0PGcieswhpPLrvChWHcwGAperWDiaT0sB5t+xgs97O843r8zOQ9uFI
	oiLu469+xjdfFhZ1BzJA1rF46hCmU08=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-DxBAMHtFNQOX0A3LFgxYKQ-1; Mon,
 09 Feb 2026 09:01:35 -0500
X-MC-Unique: DxBAMHtFNQOX0A3LFgxYKQ-1
X-Mimecast-MFC-AGG-ID: DxBAMHtFNQOX0A3LFgxYKQ_1770645693
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 003D5195608F;
	Mon,  9 Feb 2026 14:01:33 +0000 (UTC)
Received: from redhat.com (unknown [10.45.225.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E00618003F6;
	Mon,  9 Feb 2026 14:01:28 +0000 (UTC)
Date: Mon, 9 Feb 2026 14:01:24 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@gmail.com>,
	qemu-devel@nongnu.org, Eric Blake <eblake@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"open list:X86 KVM CPUs" <kvm@vger.kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH] Add query-tdx-capabilities
Message-ID: <aYnotPEv3aJAClPm@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <aV41CQP0JODTdRqy@redhat.com>
 <87qzrzku9z.fsf@pond.sub.org>
 <aWDMU7WOlGIdNush@redhat.com>
 <87jyxrksug.fsf@pond.sub.org>
 <aWDTXvXxPRj2fs2b@redhat.com>
 <87cy3jkrj8.fsf@pond.sub.org>
 <aWDatqLQYBV9fznm@redhat.com>
 <871pjzkm4y.fsf@pond.sub.org>
 <CAJ+F1CLR4wt-bA+V+oV6N4iKTK_=Hn8TSD0pP7Uwj=jWHWvZRA@mail.gmail.com>
 <87343i71hm.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87343i71hm.fsf@pond.sub.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70599-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,nongnu.org,redhat.com,vger.kernel.org,habkost.net,linaro.org,huawei.com,intel.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[libvirt.org:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,instagram.com:url,entangle-photo.org:url];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[berrange@redhat.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[berrange@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 48627110027
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 08:03:17AM +0100, Markus Armbruster wrote:
> Cc: machine core maintainers for an opinion on query-machines.
> 
> Marc-André Lureau <marcandre.lureau@gmail.com> writes:
> 
> > Hi
> >
> > On Fri, Jan 9, 2026 at 4:27 PM Markus Armbruster <armbru@redhat.com> wrote:
> >>
> >> Daniel P. Berrangé <berrange@redhat.com> writes:
> >>
> >> > On Fri, Jan 09, 2026 at 11:29:47AM +0100, Markus Armbruster wrote:
> >> >> Daniel P. Berrangé <berrange@redhat.com> writes:
> >> >>
> >> >> > On Fri, Jan 09, 2026 at 11:01:27AM +0100, Markus Armbruster wrote:
> >> >> >> Daniel P. Berrangé <berrange@redhat.com> writes:
> >> >> >>
> >> >> >> > On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrote:
> >> >> >> >> Daniel P. Berrangé <berrange@redhat.com> writes:
> >> >> >> >>
> >> >> >> >> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@redhat.com wrote:
> >> >> >> >> >> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> >> >> >> >> >>
> >> >> >> >> >> Return an empty TdxCapability struct, for extensibility and matching
> >> >> >> >> >> query-sev-capabilities return type.
> >> >> >> >> >>
> >> >> >> >> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
> >> >> >> >> >> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> [...]
> 
> >> >> >> Do management applications need to know more than "this combination of
> >> >> >> host + KVM + QEMU can do SEV, yes / no?
> >> >> >>
> >> >> >> If yes, what do they need?  "No" split up into serval "No, because X"?
> >> >> >
> >> >> > When libvirt runs  query-sev-capabilities it does not care about the
> >> >> > reason for it being unsupported.   Any "GenericError" is considered
> >> >> > to mark the lack of host support, and no fine grained checks are
> >> >> > performed on the err msg.
> >> >> >
> >> >> > If query-sev-capabilities succeeds (indicating SEV is supported), then
> >> >> > all the returned info is exposed to mgmt apps in the libvirt domain
> >> >> > capabilities XML document.
> >> >>
> >> >> So query-sev-capabilities is good enough as is?
> >> >
> >> > IIUC, essentially all QEMU errors that could possibly be seen with
> >> > query-sev-capabilities are "GenericError" these days, except for
> >> > the small possibility of "CommandNotFound".
> >> >
> >> > The two scenarios with lack of SEV support are covered by GenericError
> >> > but I'm concerned that other things that should be considered fatal
> >> > will also fall under GenericError.
> >> >
> >> > eg take a look at qmp_dispatch() and see countless places where we can
> >> > return GenericError which ought to be treated as fatal by callers.
> >> >
> >> > IMHO  "SEV not supported" is not conceptually an error, it is an
> >> > expected informational result of query-sev-capabilities, and thus
> >> > shouldn't be using the QMP error object, it should have been a
> >> > boolean result field.
> >>
> >> I agree that errors should be used only for "abnormal" outcomes, not for
> >> the "no" answer to a simple question like "is SEV available, and if yes,
> >> what are its capabilities?"
> >>
> >> I further agree that encoding "no" as GenericError runs the risk of
> >> conflating "no" with other errors.  Since query-sev itself can fail just
> >> one way, these can only come from the QMP core.  For the core's syntax
> >> and type errors, the risk is only theoretical: just don't do that.
> >> Errors triggered by state, like the one in qmp_command_available(), are
> >> a bit more worrying.  I think they're easy enough to avoid if you're
> >> aware, but "if you're aware" is admittedly rittle.
> >>
> >> Anyway, that's what we have.  Badly designed, but it seems to be
> >> workable.
> >>
> >> Is the bad enough to justify revising the interface?  I can't see how to
> >> do that compatibly.
> >>
> >> Is it bad enough to justify new interfaces for similar things to be
> >> dissimilar?
> >>
> >
> > Maybe query-{sev,tdx,*}-capabilities should only be called when the
> > host is actually capable, thus throwing an Error is fine.
> >
> > What about a new "query-confidential-guest-supports" command that
> > checks the host capability and returns ["sev", "tdx", "pef"...] then ?
> 
> Some similarity to query-accelerators.  Feels reasonable.

It feels like if we do that, then we would fold the -capbilities into
this command too:

{ 'enum': 'ConfidentialGuestType',
  'data': ['sev', 'sev-snp', 'tdx', .. ] }

{ 'union': 'ConfidentialGuestSupport',
  'base': { 'type': 'ConfidentialGuestType' },
  'discriminator': { 'type' },
  'data': { 'sev': 'SevCapabilities',
            'sev-snp': 'SevCapabilities' } }

{ 'command': 'query-confidential-guest-capabilities',
  'returns': 'ConfidentialGuestCapability' }



> > Or maybe this should be provided at the MachineInfo level instead
> > (query-machines).
> 
> Also reasonable, I think.  Machine core maintainers, got an opinion?

MachineInfo level seems interesting because of the 'confidential-guest-support'
property against the machine classes.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


