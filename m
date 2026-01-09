Return-Path: <kvm+bounces-67549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FAA7D08634
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 11:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 393BF3014D4B
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 10:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87641330D27;
	Fri,  9 Jan 2026 10:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R8TS40cf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA30B314B6D
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 10:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767952895; cv=none; b=V/oDWR2BM8VGYArhF87l18PADNUwHY+wzUYv59qIE1bAZ4KcJGNOh8Gsz0RHTQKEp4uvBx8d04gfIXrvgFqeXjWS9Ul6fRGe7rVY+p4fslnmhRyR7eMNv3prnAicVeB7vO0WBSZGhiVNxw3A95Jtr1y5zTee6Z/b1IG5OddkpPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767952895; c=relaxed/simple;
	bh=Mr3IeOZJuNkycQTpRv0SY12XyT0VdkHLYIbt3xPJpU4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ckYvcG6g/l6Qa1AomcILv/9pz7TKxLgVcxtepQqlm8hPH5YF7ugDdCEtWYKBlPigNAEc5yT79hjFEb8uOJvgSqeWFm20kTI62HY2KegR7s5Ttu5MC0xYeXIHJ+kQ98dZ1hcps4GB5s9K8MdVssKZ0g5PxvcUPtcV6oGsxIU9k44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R8TS40cf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767952892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=84d4YsFA2cNReHzg7em2iA9ufLD7lbftNYZh55vE+9w=;
	b=R8TS40cfqSvBh4++CUX7aIgMvqwrjmY2JTxiuGUMo0BMjhig0heipA8W2Yrw3a4skTI/id
	7KwbIs2MFWtKXiS0Bh5jxJuG+IDWXdDzf50ppb29b3NM4C9+HnocJe1zckAo9nNSpO2Lby
	XxokJkS3F+GIq2qTASXmdSt+SxysTrw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-237-bbbYZ2KNNc63E60PRYaKcQ-1; Fri,
 09 Jan 2026 05:01:31 -0500
X-MC-Unique: bbbYZ2KNNc63E60PRYaKcQ-1
X-Mimecast-MFC-AGG-ID: bbbYZ2KNNc63E60PRYaKcQ_1767952890
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BAA518005A7;
	Fri,  9 Jan 2026 10:01:30 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.32])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 187231956048;
	Fri,  9 Jan 2026 10:01:29 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 89F7021E6934; Fri, 09 Jan 2026 11:01:27 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: marcandre.lureau@redhat.com,  qemu-devel@nongnu.org,  Eric Blake
 <eblake@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  "open list:X86 KVM CPUs"
 <kvm@vger.kernel.org>
Subject: Re: [PATCH] Add query-tdx-capabilities
In-Reply-To: <aWDMU7WOlGIdNush@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Fri, 9 Jan 2026 09:37:23 +0000")
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
	<aV41CQP0JODTdRqy@redhat.com> <87qzrzku9z.fsf@pond.sub.org>
	<aWDMU7WOlGIdNush@redhat.com>
Date: Fri, 09 Jan 2026 11:01:27 +0100
Message-ID: <87jyxrksug.fsf@pond.sub.org>
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

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrote:
>> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>>=20
>> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@redhat.com =
wrote:
>> >> From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>> >>=20
>> >> Return an empty TdxCapability struct, for extensibility and matching
>> >> query-sev-capabilities return type.
>> >>=20
>> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
>> >> Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>

[...]

>> > This matches the conceptual design used with query-sev-capabilities,
>> > where the lack of SEV support has to be inferred from the command
>> > returning "GenericError".
>>=20
>> Such guesswork is brittle.  An interface requiring it is flawed, and
>> should be improved.
>>=20
>> Our SEV interface doesn't actually require it: query-sev tells you
>> whether we have SEV.  Just run that first.
>
> Actually these commands are intended for different use cases.
>
> "query-sev" only returns info if you have launched qemu with
>
>   $QEMU -object sev-guest,id=3Dcgs0  -machine confidential-guest-support=
=3Dcgs0
>
> The goal of "query-sev-capabilities" is to allow you to determine
> if the combination of host+kvm+qemu are capable of running a guest
> with "sev-guest".
>
> IOW, query-sev-capabilities alone is what you want/need in order
> to probe host features.
>
> query-sev is for examining running guest configuration

The doc comments fail to explain this.  Needs fixing.

Do management applications need to know more than "this combination of
host + KVM + QEMU can do SEV, yes / no?

If yes, what do they need?  "No" split up into serval "No, because X"?

I'd like to propose that "human user of management application needs to
know more to debug things" does not count.  The error's @desc should
tell them all they need.

>> This patch adds query-tdx-capabilities without query-tdx.  This results
>> in a flawed interface.
>>=20
>> Should we add a query-tdx instead?
>
> No, per the above explanation of the differences.

Got it.

[...]


