Return-Path: <kvm+bounces-69974-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICdtI8ydgWlwHwMAu9opvQ
	(envelope-from <kvm+bounces-69974-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 08:03:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E846AD586B
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 08:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3923D3043BDD
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 07:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D1F38F94D;
	Tue,  3 Feb 2026 07:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iPlhIMsr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476711E7C03
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 07:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770102210; cv=none; b=sD8kB9BYWtgfauK2mKHCh74hmxCbnhTDU7yRgLwqbabf++8MmC+yeEplv06Hb8ZYHdTycROXVW7Kn136lg1x7QvnIaC52kht0gZUW88Zb0Ga0extAL+VLq13/HGtovufLLFWvayAFHJtzhK7bwze93z7nzl3kbsOdo66TR9VBF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770102210; c=relaxed/simple;
	bh=kczN3zFVSzrE7bKpYSzAUPB9J3iO/g+9SFCRSp4oF4s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=l76Rr14+JS3OYSHw4zbNqbbsq49TnvfYrLwXbhIlpl6pvoi542zoLW+qeyMkoe8+8jrZC+fohL56HQbpz6+5agnz8FZ/4lBTTL81d1+nd2BwQgHotF/oUlIsukhHw/sMQUtQVrqLEp3u7O5E4ppL/4TYbpb1PlNDWauwOCyX5Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iPlhIMsr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770102208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JNV9xtlwyBIDkoyTjXrtJhXtllvrWI0sq7+WcuGQXaw=;
	b=iPlhIMsrW9c+r6rvRaYaS7Yfns0tqbZpqb9tTXWErv2qRnQS4O97fc2dXt36UHU1ZCSBRP
	5cy3jyfVLvvABguVwiTr8+OaoiuYtAbm784hSBpg4TdXF8FW/shVHku2PRm2YOvPpC9hqP
	BeRdAZHcsFH8V6c5l0taeXCGZTStAXQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-mZlohMmuOFaSj-MBD9DLKw-1; Tue,
 03 Feb 2026 02:03:23 -0500
X-MC-Unique: mZlohMmuOFaSj-MBD9DLKw-1
X-Mimecast-MFC-AGG-ID: mZlohMmuOFaSj-MBD9DLKw_1770102201
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74E371800447;
	Tue,  3 Feb 2026 07:03:21 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.22])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44BFB1956053;
	Tue,  3 Feb 2026 07:03:20 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DBA7021E692D; Tue, 03 Feb 2026 08:03:17 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@gmail.com>
Cc: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,
  qemu-devel@nongnu.org,  Eric
 Blake <eblake@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  "open list:X86 KVM CPUs"
 <kvm@vger.kernel.org>,
    Eduardo Habkost <eduardo@habkost.net>,
    Marcel Apfelbaum <marcel@redhat.com>,
    =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
    Yanan Wang <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH] Add query-tdx-capabilities
In-Reply-To: <CAJ+F1CLR4wt-bA+V+oV6N4iKTK_=Hn8TSD0pP7Uwj=jWHWvZRA@mail.gmail.com>
	(=?utf-8?Q?=22Marc-Andr=C3=A9?= Lureau"'s message of "Mon, 26 Jan 2026
 19:20:29 +0400")
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
	<aV41CQP0JODTdRqy@redhat.com> <87qzrzku9z.fsf@pond.sub.org>
	<aWDMU7WOlGIdNush@redhat.com> <87jyxrksug.fsf@pond.sub.org>
	<aWDTXvXxPRj2fs2b@redhat.com> <87cy3jkrj8.fsf@pond.sub.org>
	<aWDatqLQYBV9fznm@redhat.com> <871pjzkm4y.fsf@pond.sub.org>
	<CAJ+F1CLR4wt-bA+V+oV6N4iKTK_=Hn8TSD0pP7Uwj=jWHWvZRA@mail.gmail.com>
Date: Tue, 03 Feb 2026 08:03:17 +0100
Message-ID: <87343i71hm.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69974-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[armbru@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E846AD586B
X-Rspamd-Action: no action

Cc: machine core maintainers for an opinion on query-machines.

Marc-Andr=C3=A9 Lureau <marcandre.lureau@gmail.com> writes:

> Hi
>
> On Fri, Jan 9, 2026 at 4:27=E2=80=AFPM Markus Armbruster <armbru@redhat.c=
om> wrote:
>>
>> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>>
>> > On Fri, Jan 09, 2026 at 11:29:47AM +0100, Markus Armbruster wrote:
>> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>> >>
>> >> > On Fri, Jan 09, 2026 at 11:01:27AM +0100, Markus Armbruster wrote:
>> >> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>> >> >>
>> >> >> > On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrot=
e:
>> >> >> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>> >> >> >>
>> >> >> >> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@re=
dhat.com wrote:
>> >> >> >> >> From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>> >> >> >> >>
>> >> >> >> >> Return an empty TdxCapability struct, for extensibility and =
matching
>> >> >> >> >> query-sev-capabilities return type.
>> >> >> >> >>
>> >> >> >> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
>> >> >> >> >> Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redh=
at.com>

[...]

>> >> >> Do management applications need to know more than "this combinatio=
n of
>> >> >> host + KVM + QEMU can do SEV, yes / no?
>> >> >>
>> >> >> If yes, what do they need?  "No" split up into serval "No, because=
 X"?
>> >> >
>> >> > When libvirt runs  query-sev-capabilities it does not care about the
>> >> > reason for it being unsupported.   Any "GenericError" is considered
>> >> > to mark the lack of host support, and no fine grained checks are
>> >> > performed on the err msg.
>> >> >
>> >> > If query-sev-capabilities succeeds (indicating SEV is supported), t=
hen
>> >> > all the returned info is exposed to mgmt apps in the libvirt domain
>> >> > capabilities XML document.
>> >>
>> >> So query-sev-capabilities is good enough as is?
>> >
>> > IIUC, essentially all QEMU errors that could possibly be seen with
>> > query-sev-capabilities are "GenericError" these days, except for
>> > the small possibility of "CommandNotFound".
>> >
>> > The two scenarios with lack of SEV support are covered by GenericError
>> > but I'm concerned that other things that should be considered fatal
>> > will also fall under GenericError.
>> >
>> > eg take a look at qmp_dispatch() and see countless places where we can
>> > return GenericError which ought to be treated as fatal by callers.
>> >
>> > IMHO  "SEV not supported" is not conceptually an error, it is an
>> > expected informational result of query-sev-capabilities, and thus
>> > shouldn't be using the QMP error object, it should have been a
>> > boolean result field.
>>
>> I agree that errors should be used only for "abnormal" outcomes, not for
>> the "no" answer to a simple question like "is SEV available, and if yes,
>> what are its capabilities?"
>>
>> I further agree that encoding "no" as GenericError runs the risk of
>> conflating "no" with other errors.  Since query-sev itself can fail just
>> one way, these can only come from the QMP core.  For the core's syntax
>> and type errors, the risk is only theoretical: just don't do that.
>> Errors triggered by state, like the one in qmp_command_available(), are
>> a bit more worrying.  I think they're easy enough to avoid if you're
>> aware, but "if you're aware" is admittedly rittle.
>>
>> Anyway, that's what we have.  Badly designed, but it seems to be
>> workable.
>>
>> Is the bad enough to justify revising the interface?  I can't see how to
>> do that compatibly.
>>
>> Is it bad enough to justify new interfaces for similar things to be
>> dissimilar?
>>
>
> Maybe query-{sev,tdx,*}-capabilities should only be called when the
> host is actually capable, thus throwing an Error is fine.
>
> What about a new "query-confidential-guest-supports" command that
> checks the host capability and returns ["sev", "tdx", "pef"...] then ?

Some similarity to query-accelerators.  Feels reasonable.

> Or maybe this should be provided at the MachineInfo level instead
> (query-machines).

Also reasonable, I think.  Machine core maintainers, got an opinion?


