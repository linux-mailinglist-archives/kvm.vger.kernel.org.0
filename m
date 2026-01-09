Return-Path: <kvm+bounces-67560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 921C6D09AEA
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 13:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2CE6630894B6
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 12:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC69935B13F;
	Fri,  9 Jan 2026 12:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQnNUunq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B511531E8
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 12:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961591; cv=none; b=Fc8mKfzPO7IW3ZzQZAMN55ITwYTsDId5oy4OLj6qvsNZZ4F7BfDlRH9y0CQFX1GeV02yHOVfGRexGPYfUYisML14ouu16/52cLpqVw5y/UodpCeq3nTlK1fvRw5aLilNOEEd8MVsCeF+59w6KsKoO6jDS+1JDFOT25bCoi1wGUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961591; c=relaxed/simple;
	bh=fPEWauvnLsk8oAAdi8AFgCE3X4wfaKaeUwbZXQ3EsJ4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Hhm8WMzzvTWGx5E99EWjgosgp0CVJiZsZWZ7kq+IRjwGCr4ZYB86aT1H7zwxuFnibBJevAlB8SR8pleb/73A/FdIGLYH6pLywviF3MJIFTuBqqFRhp8/j0f+/IFGALuto/uAUf4lTVVuBjCG9HCgeEd5RVuh8yjF9Rj9ibc3oLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RQnNUunq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767961588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zDo1NUmvGczPAlknAHYPwQ/p6hGU4SN3wqxogeRjgVw=;
	b=RQnNUunqzQrzxV2LScc6GEsYSoqdFaEAjEiJPQuUWKwGwDZJABxiaJPm0rV/Ib9iePL/Yc
	L5tK4pYsiJ9ou/kZ7aZIiQcouGMn6RBs7/vP1txeTInxl9GyDoWXxwkcGoMeG41IxWQA6n
	DpQGpUPBhc4gqMQbA6Wqh8ez64O5GOg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-3PTERwRtP0iee_I6XxUn_A-1; Fri,
 09 Jan 2026 07:26:25 -0500
X-MC-Unique: 3PTERwRtP0iee_I6XxUn_A-1
X-Mimecast-MFC-AGG-ID: 3PTERwRtP0iee_I6XxUn_A_1767961584
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABEA2180047F;
	Fri,  9 Jan 2026 12:26:24 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.32])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C3391800240;
	Fri,  9 Jan 2026 12:26:23 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 9F0BA21E66C1; Fri, 09 Jan 2026 13:26:21 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: marcandre.lureau@redhat.com,  qemu-devel@nongnu.org,  Eric Blake
 <eblake@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  "open list:X86 KVM CPUs"
 <kvm@vger.kernel.org>
Subject: Re: [PATCH] Add query-tdx-capabilities
In-Reply-To: <aWDatqLQYBV9fznm@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Fri, 9 Jan 2026 10:38:46 +0000")
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
	<aV41CQP0JODTdRqy@redhat.com> <87qzrzku9z.fsf@pond.sub.org>
	<aWDMU7WOlGIdNush@redhat.com> <87jyxrksug.fsf@pond.sub.org>
	<aWDTXvXxPRj2fs2b@redhat.com> <87cy3jkrj8.fsf@pond.sub.org>
	<aWDatqLQYBV9fznm@redhat.com>
Date: Fri, 09 Jan 2026 13:26:21 +0100
Message-ID: <871pjzkm4y.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Fri, Jan 09, 2026 at 11:29:47AM +0100, Markus Armbruster wrote:
>> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>>=20
>> > On Fri, Jan 09, 2026 at 11:01:27AM +0100, Markus Armbruster wrote:
>> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>> >>=20
>> >> > On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrote:
>> >> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>> >> >>=20
>> >> >> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@redha=
t.com wrote:
>> >> >> >> From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>> >> >> >>=20
>> >> >> >> Return an empty TdxCapability struct, for extensibility and mat=
ching
>> >> >> >> query-sev-capabilities return type.
>> >> >> >>=20
>> >> >> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
>> >> >> >> Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.=
com>
>> >>=20
>> >> [...]
>> >>=20
>> >> >> > This matches the conceptual design used with query-sev-capabilit=
ies,
>> >> >> > where the lack of SEV support has to be inferred from the command
>> >> >> > returning "GenericError".
>> >> >>=20
>> >> >> Such guesswork is brittle.  An interface requiring it is flawed, a=
nd
>> >> >> should be improved.
>> >> >>=20
>> >> >> Our SEV interface doesn't actually require it: query-sev tells you
>> >> >> whether we have SEV.  Just run that first.
>> >> >
>> >> > Actually these commands are intended for different use cases.
>> >> >
>> >> > "query-sev" only returns info if you have launched qemu with
>> >> >
>> >> >   $QEMU -object sev-guest,id=3Dcgs0  -machine confidential-guest-su=
pport=3Dcgs0
>> >> >
>> >> > The goal of "query-sev-capabilities" is to allow you to determine
>> >> > if the combination of host+kvm+qemu are capable of running a guest
>> >> > with "sev-guest".
>> >> >
>> >> > IOW, query-sev-capabilities alone is what you want/need in order
>> >> > to probe host features.
>> >> >
>> >> > query-sev is for examining running guest configuration
>> >>=20
>> >> The doc comments fail to explain this.  Needs fixing.
>> >>=20
>> >> Do management applications need to know more than "this combination of
>> >> host + KVM + QEMU can do SEV, yes / no?
>> >>=20
>> >> If yes, what do they need?  "No" split up into serval "No, because X"?
>> >
>> > When libvirt runs  query-sev-capabilities it does not care about the
>> > reason for it being unsupported.   Any "GenericError" is considered
>> > to mark the lack of host support, and no fine grained checks are
>> > performed on the err msg.
>> >
>> > If query-sev-capabilities succeeds (indicating SEV is supported), then
>> > all the returned info is exposed to mgmt apps in the libvirt domain
>> > capabilities XML document.
>>=20
>> So query-sev-capabilities is good enough as is?
>
> IIUC, essentially all QEMU errors that could possibly be seen with
> query-sev-capabilities are "GenericError" these days, except for
> the small possibility of "CommandNotFound".
>
> The two scenarios with lack of SEV support are covered by GenericError
> but I'm concerned that other things that should be considered fatal
> will also fall under GenericError.
>
> eg take a look at qmp_dispatch() and see countless places where we can
> return GenericError which ought to be treated as fatal by callers.=20
>
> IMHO  "SEV not supported" is not conceptually an error, it is an
> expected informational result of query-sev-capabilities, and thus
> shouldn't be using the QMP error object, it should have been a
> boolean result field.

I agree that errors should be used only for "abnormal" outcomes, not for
the "no" answer to a simple question like "is SEV available, and if yes,
what are its capabilities?"

I further agree that encoding "no" as GenericError runs the risk of
conflating "no" with other errors.  Since query-sev itself can fail just
one way, these can only come from the QMP core.  For the core's syntax
and type errors, the risk is only theoretical: just don't do that.
Errors triggered by state, like the one in qmp_command_available(), are
a bit more worrying.  I think they're easy enough to avoid if you're
aware, but "if you're aware" is admittedly rittle.

Anyway, that's what we have.  Badly designed, but it seems to be
workable.

Is the bad enough to justify revising the interface?  I can't see how to
do that compatibly.

Is it bad enough to justify new interfaces for similar things to be
dissimilar?

>> If yes, then the proposed query-tdx-capabilities should also be good
>> enough, shouldn't it?
>
> With regards,
> Daniel


