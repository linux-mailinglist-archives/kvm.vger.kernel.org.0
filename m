Return-Path: <kvm+bounces-67553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD558D088EF
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 11:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5A0F3028D8B
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 10:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015B83382D5;
	Fri,  9 Jan 2026 10:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ARVrkDlB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF34223DDF
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 10:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767954596; cv=none; b=nP01Uf7FGLr6VBMiKb00Qad8qI1bYQnn+SjYaNei3FQhXZZcrC/Ldd2FmMLDyx+3T3746/Pk3HgjKcv02Fx2hHkMKdXK14juPVwP8iKSXG0Q1Ti+ZSECET13rQsTyU4az9M/25edTUQAQ7HfiO0lUvkO0VBbC/lQzQLMPyFlG8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767954596; c=relaxed/simple;
	bh=RcVegzJtlBj5aw5DqCXqAg/YdTpfBd0wH+Fl0qwcY3s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tY1oqcJ4IXPPr5SyOHWd4iAwPhCFZtQUDJzN0hCt0AnVtQwDJ9PCBEiw3tIbKuXsZxhtIA1RADw08YvJbA5Z0iwgnhJfUa5/twYKonDTTUNqboOofDhgtLoQMrG6eRNdPWylGDkfl4ceZd9lHGAfOXGAKe3tF2USfQ94gtEUISs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ARVrkDlB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767954593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WtatC6RyZvwEsbDBtsHjktdlgxF4UwnAlbrB8s8B8g=;
	b=ARVrkDlBNPwENjKEEqTbPoEsJiprdwDv3g7qsRz+0lMYDOUdZP86iyhcR02CLMmOXcgn6K
	CTGtU9yhi5w+s2vzIlgRxR11L06bxtskEOBfcBU0DoeX/7S7jfV5qv0yxzavVubgbdLeuN
	dDfjeTBmFhBPCZZU7/Be6ie77gG9kp4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-QTETx7t1PGW4Avsynv7Lkg-1; Fri,
 09 Jan 2026 05:29:50 -0500
X-MC-Unique: QTETx7t1PGW4Avsynv7Lkg-1
X-Mimecast-MFC-AGG-ID: QTETx7t1PGW4Avsynv7Lkg_1767954589
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5CBA19560A3;
	Fri,  9 Jan 2026 10:29:49 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.32])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6856319560B4;
	Fri,  9 Jan 2026 10:29:49 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 1AA1821E6934; Fri, 09 Jan 2026 11:29:47 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: marcandre.lureau@redhat.com,  qemu-devel@nongnu.org,  Eric Blake
 <eblake@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  "open list:X86 KVM CPUs"
 <kvm@vger.kernel.org>
Subject: Re: [PATCH] Add query-tdx-capabilities
In-Reply-To: <aWDTXvXxPRj2fs2b@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Fri, 9 Jan 2026 10:07:26 +0000")
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
	<aV41CQP0JODTdRqy@redhat.com> <87qzrzku9z.fsf@pond.sub.org>
	<aWDMU7WOlGIdNush@redhat.com> <87jyxrksug.fsf@pond.sub.org>
	<aWDTXvXxPRj2fs2b@redhat.com>
Date: Fri, 09 Jan 2026 11:29:47 +0100
Message-ID: <87cy3jkrj8.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Fri, Jan 09, 2026 at 11:01:27AM +0100, Markus Armbruster wrote:
>> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>>=20
>> > On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrote:
>> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>> >>=20
>> >> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@redhat.c=
om wrote:
>> >> >> From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>> >> >>=20
>> >> >> Return an empty TdxCapability struct, for extensibility and matchi=
ng
>> >> >> query-sev-capabilities return type.
>> >> >>=20
>> >> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
>> >> >> Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>>=20
>> [...]
>>=20
>> >> > This matches the conceptual design used with query-sev-capabilities,
>> >> > where the lack of SEV support has to be inferred from the command
>> >> > returning "GenericError".
>> >>=20
>> >> Such guesswork is brittle.  An interface requiring it is flawed, and
>> >> should be improved.
>> >>=20
>> >> Our SEV interface doesn't actually require it: query-sev tells you
>> >> whether we have SEV.  Just run that first.
>> >
>> > Actually these commands are intended for different use cases.
>> >
>> > "query-sev" only returns info if you have launched qemu with
>> >
>> >   $QEMU -object sev-guest,id=3Dcgs0  -machine confidential-guest-suppo=
rt=3Dcgs0
>> >
>> > The goal of "query-sev-capabilities" is to allow you to determine
>> > if the combination of host+kvm+qemu are capable of running a guest
>> > with "sev-guest".
>> >
>> > IOW, query-sev-capabilities alone is what you want/need in order
>> > to probe host features.
>> >
>> > query-sev is for examining running guest configuration
>>=20
>> The doc comments fail to explain this.  Needs fixing.
>>=20
>> Do management applications need to know more than "this combination of
>> host + KVM + QEMU can do SEV, yes / no?
>>=20
>> If yes, what do they need?  "No" split up into serval "No, because X"?
>
> When libvirt runs  query-sev-capabilities it does not care about the
> reason for it being unsupported.   Any "GenericError" is considered
> to mark the lack of host support, and no fine grained checks are
> performed on the err msg.
>
> If query-sev-capabilities succeeds (indicating SEV is supported), then
> all the returned info is exposed to mgmt apps in the libvirt domain
> capabilities XML document.

So query-sev-capabilities is good enough as is?

If yes, then the proposed query-tdx-capabilities should also be good
enough, shouldn't it?


