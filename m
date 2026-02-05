Return-Path: <kvm+bounces-70305-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2JbsElE+hGk71wMAu9opvQ
	(envelope-from <kvm+bounces-70305-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:53:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71635EF286
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 07:53:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F224A300404C
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 06:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266CD34F47D;
	Thu,  5 Feb 2026 06:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WMRmUodV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2266221CFEF
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 06:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770274377; cv=none; b=paweG4tTvHPGSh2jkR9IAedsSRu+CRdy+ht2D52akV7eb/zytuGfBz6Agkk9Mt/pVUSgz+i1N63ZbzqtoYHOWqWOVs6GOZwbs2chMBlu8YlYckWEzEBlsbYXAQ5Y2tV6be6Co4YU/dROkn2gaoxK0tR1lV3BYshhLSYzT7uhr0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770274377; c=relaxed/simple;
	bh=lWQd6QSFUfpNl3GDcFOR4CivMR1BYTZ0sfNA32/j+ww=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mrlN5+78+KsvXOn/MgIDGqGvUE0kudo8EWLFd1KANbATOfNo/flUbuA8qqWRPTmAwZJd+dINnGN9J2dzuczCHJF5Qyls6O77yUWhVJ7gbNtu+o3gd7vHO3UorUoriF83LHauTOgcswpDRDcXkZCT5nC7WvPGtzysyB97Pm0ECLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WMRmUodV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770274376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWQd6QSFUfpNl3GDcFOR4CivMR1BYTZ0sfNA32/j+ww=;
	b=WMRmUodVcJF14QqxCLNP5YWhbFUkgJO0m6fLbKwd0xctmRE/tllXUQbTGKueLl1IPH8gu9
	TGAakAOlQWre3g5+81qqnGS1m7tVTYma4DNI+cfoECOICMr8PFLyzEN8sZtk6tofRaktLt
	owBRIuaV2IFzBz+o6iWwgt84vCcfXDo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-YTIde_t7M6SL1heNcYoUzQ-1; Thu,
 05 Feb 2026 01:52:53 -0500
X-MC-Unique: YTIde_t7M6SL1heNcYoUzQ-1
X-Mimecast-MFC-AGG-ID: YTIde_t7M6SL1heNcYoUzQ_1770274371
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23CE31955F21;
	Thu,  5 Feb 2026 06:52:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.22])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B85F19560B0;
	Thu,  5 Feb 2026 06:52:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 0FE8321E692D; Thu, 05 Feb 2026 07:52:48 +0100 (CET)
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
In-Reply-To: <aYPvN5fphSObsvGR@gallifrey> (David Alan Gilbert's message of
	"Thu, 5 Feb 2026 01:15:35 +0000")
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
	<CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
	<871pjigf6z.fsf_-_@pond.sub.org> <aXH1ECZ1Nchui9ED@redhat.com>
	<87ikctg8a8.fsf@pond.sub.org> <aXIWLi656H8VbrPE@redhat.com>
	<87ikctk5ss.fsf@suse.de> <aXJJkd8g0AGZ3EVv@redhat.com>
	<aX-boauFX2Ju7x8Z@gallifrey> <875x8d0w32.fsf@pond.sub.org>
	<aYPvN5fphSObsvGR@gallifrey>
Date: Thu, 05 Feb 2026 07:52:48 +0100
Message-ID: <87ms1nu1fj.fsf@pond.sub.org>
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
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70305-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,suse.de,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,pond.sub.org:mid];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[armbru@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 71635EF286
X-Rspamd-Action: no action

"Dr. David Alan Gilbert" <dave@treblig.org> writes:

[...]

> I did see you suggesting for Rust for it; which would work - although
> given it wouldn't be performance sensitive, Python would seem reasonable.

Marc-Andr=C3=A9 suggested "Python or Rust (student choice)".

Daniel argued for Rust "as it allows the possibility to embed that Rust
impl inside the current QEMU binaries, to fully replace the C code and
retain broadly the same functionality."

If we're not interested in such embedding, then Python feels preferable
to me, because I'd expect it to get us to the finish line faster.


