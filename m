Return-Path: <kvm+bounces-68894-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gK1NOWMqcmmadwAAu9opvQ
	(envelope-from <kvm+bounces-68894-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 14:47:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D4C677D9
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 14:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6858F72BAE2
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FD52F12AB;
	Thu, 22 Jan 2026 13:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uh3PUk0U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAF6299949
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 13:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769087283; cv=none; b=CR370FZBo4oqArL0TPwG2CrI52noTzNHhG3GRUU5HwcIhKg89JM2qjQthMzsLfy4871zDWeXSnyqmkzYMnUwttf0FI5idx5bpQajVflbxdULV3Izyifpf+gxDkp3apj6mfnvQ66/457Qgkc5j3RSck7VOLdwwyARQVL5CHHq9CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769087283; c=relaxed/simple;
	bh=q8vJzvFFxxDLcSEat8GmerefyDd6v+hhnYpnC5U9JO8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=a+1xcaWXz9ayIa3rQrPUSkLD2c/fUYYPCGkxo8rWAAIAOyFu6wEW6Yu+ZEzT2tRjVLm4Y7IRsOKOKpnXgwQ/z3oD5fI1iHv5F0kouoVS+spJa5uuWANBhoe0mRwIKr8X8vyTkPq2bhwTuHddESbjke2rvPZ4GMvGlfwgtrKPpFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uh3PUk0U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769087281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y1EIoFHHeJZuJl2UYkcRHiIobvkIXokPiJUvVd8BY0s=;
	b=Uh3PUk0UpMSF6i0FHkwYd22k876x05+TYKJaT9o6HytH6ZLUBZ1ZMk8ts8jbuCdGzO2NSL
	x236y4yjVTZgouc7Y4E41LTAHcAqzUXbUqmhhVXBKuyh/D/nwJ0Jvdt6lcVAdUcvapKZ0u
	mqHyxI7+AssMbfikf9vHm0kDy91jEKM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-zJVEz-mTO92IjjIRfRLmng-1; Thu,
 22 Jan 2026 08:07:57 -0500
X-MC-Unique: zJVEz-mTO92IjjIRfRLmng-1
X-Mimecast-MFC-AGG-ID: zJVEz-mTO92IjjIRfRLmng_1769087276
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF1071954B23;
	Thu, 22 Jan 2026 13:07:55 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BCE41958DC0;
	Thu, 22 Jan 2026 13:07:55 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id EAF4A21E692D; Thu, 22 Jan 2026 14:07:52 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
  Stefan Hajnoczi
 <stefanha@gmail.com>,  qemu-devel <qemu-devel@nongnu.org>,  kvm
 <kvm@vger.kernel.org>,  Helge Deller <deller@gmx.de>,  Oliver Steffen
 <osteffen@redhat.com>,  Stefano Garzarella <sgarzare@redhat.com>,  Matias
 Ezequiel Vara Larsen <mvaralar@redhat.com>,  Kevin Wolf
 <kwolf@redhat.com>,  German Maglione <gmaglione@redhat.com>,  Hanna Reitz
 <hreitz@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,  Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Thomas Huth
 <thuth@redhat.com>,  Mark
 Cave-Ayland <mark.cave-ayland@ilande.co.uk>,  Alex Bennee
 <alex.bennee@linaro.org>,  Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Re: Modern HMP
In-Reply-To: <aXIWLi656H8VbrPE@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Thu, 22 Jan 2026 12:21:02 +0000")
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
	<CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
	<871pjigf6z.fsf_-_@pond.sub.org> <aXH1ECZ1Nchui9ED@redhat.com>
	<87ikctg8a8.fsf@pond.sub.org> <aXIWLi656H8VbrPE@redhat.com>
Date: Thu, 22 Jan 2026 14:07:52 +0100
Message-ID: <875x8teqxj.fsf@pond.sub.org>
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
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[18];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[armbru@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_FROM(0.00)[bounces-68894-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 82D4C677D9
X-Rspamd-Action: no action

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Thu, Jan 22, 2026 at 01:07:43PM +0100, Markus Armbruster wrote:

[...]

>> Marc-Andr=C3=A9 proposed Python or Rust.  Anyone got a preference backed=
 by
>> reasons?
>
> My suggestion would be Rust, as it allows the possibility to embed
> that Rust impl inside the current QEMU binaries, to fully replace
> the C code and retain broadly the same functionality.
>
> We might never do it, but it feels like a good idea to keep the
> door option.  Python rules that out entirely meaning we keep the
> current C code forever, unless we do a full break with command
> line compatibility at some point.

qemu-system-FOO could conceivably spawn the standalone HMP program
connected to a dedicated QMP monitor.


