Return-Path: <kvm+bounces-68866-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JRbEzHycWmvZwAAu9opvQ
	(envelope-from <kvm+bounces-68866-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:47:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E658864C3B
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 47539624A9F
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 09:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBCC33B945;
	Thu, 22 Jan 2026 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KyXi2LPm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA51E261B92
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 09:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769074718; cv=none; b=qf8BZ3OOB1IT9ViorFFGdLPnO4Ryf1P27OWJGrC7tg/KPv4LwF2yOHB23L64b7AzF1dAHz4G6Qx4h9UXUXdrZ94omHM2oet5fSt4iq2ldDzk5+70IvVU9fXss8/ykBn1jZFyZj65TMDVnq5ob36CI/I0UUFTYzg8VXqaKuU/DcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769074718; c=relaxed/simple;
	bh=uJybKukpOTmQRiU4cdOaPPCFhqg+gBwbMYOngoBTf7E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Fk+/CfIRyJbofp0Qjsdn5sUBIO7ci8C30WcLnGoP5heHmFEO5d2M1jz8AgHy2dqmUiFmlFNwX/V+iWO7PJUKF7JoM+v94NN1+/fyE5CDLVWogjw+mpOGSBYGoKEGlo+mCzPReqvUapgKVp9Sr7Wz5m3L9t9kljDaqJ7rSANCIiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KyXi2LPm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769074715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zs6Z8rSNgSgnG+3hlWFT61YkymMBUCGMxxUkBeZ07Tw=;
	b=KyXi2LPmwMrO5hSXv9NuJuwhaqxu3V1hm0K1xpcvfKEPD5MqrpDcK3Qb+YZDZ4P61x0+X7
	DidXEh8ohdccnfisFDVmnVNsL4HSJlsdNRez+ojgErmVsAyswFzrw7aGoN0YBZ1BAITi9c
	0nRf8dpCq6Nlek1efnEctCbNE98465g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-32rA7KV3NGeSfh_sHGFwvA-1; Thu,
 22 Jan 2026 04:38:32 -0500
X-MC-Unique: 32rA7KV3NGeSfh_sHGFwvA-1
X-Mimecast-MFC-AGG-ID: 32rA7KV3NGeSfh_sHGFwvA_1769074711
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F7E41944DF2;
	Thu, 22 Jan 2026 09:38:31 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C50E1956095;
	Thu, 22 Jan 2026 09:38:30 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 160E121E692D; Thu, 22 Jan 2026 10:38:28 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,  qemu-devel
 <qemu-devel@nongnu.org>,  kvm <kvm@vger.kernel.org>,  Helge Deller
 <deller@gmx.de>,  Oliver Steffen <osteffen@redhat.com>,  Stefano
 Garzarella <sgarzare@redhat.com>,  Matias Ezequiel Vara Larsen
 <mvaralar@redhat.com>,  Kevin Wolf <kwolf@redhat.com>,  German Maglione
 <gmaglione@redhat.com>,  Hanna Reitz <hreitz@redhat.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Thomas Huth <thuth@redhat.com>,  danpb@redhat.com,  Mark Cave-Ayland
 <mark.cave-ayland@ilande.co.uk>,  Alex Bennee <alex.bennee@linaro.org>,
  Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Modern HMP (was: Call for GSoC internship project ideas)
In-Reply-To: <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
	(=?utf-8?Q?=22Marc-Andr=C3=A9?= Lureau"'s message of "Wed, 14 Jan 2026
 22:00:57 +0400")
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
	<CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
Date: Thu, 22 Jan 2026 10:38:28 +0100
Message-ID: <871pjigf6z.fsf_-_@pond.sub.org>
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
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68866-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,nongnu.org,vger.kernel.org,gmx.de,redhat.com,linaro.org,ilande.co.uk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pond.sub.org:mid,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,qemu.org:url];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[armbru@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E658864C3B
X-Rspamd-Action: no action

Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com> writes:

> Hi
>
> On Tue, Jan 6, 2026 at 1:47=E2=80=AFAM Stefan Hajnoczi <stefanha@gmail.co=
m> wrote:
>
>> Dear QEMU and KVM communities,
>> QEMU will apply for the Google Summer of Code internship
>> program again this year. Regular contributors can submit project
>> ideas that they'd like to mentor by replying to this email by
>> January 30th.

[...]

>> How to propose your idea
>> ------------------------------
>> Reply to this email with the following project idea template filled in:
>>
>
> Rather than replying to this mail, I sketched some ideas of things I have
> in mind on the wiki directly:

[...]

> https://wiki.qemu.org/Internships/ProjectIdeas/ModernHMP

[...]

Let's start the discussion with your nicely written Wiki page:

    =3D=3D=3D External HMP Implementation via QMP =3D=3D=3D

    '''Summary:''' Implement a standalone HMP-compatible monitor as an
    external binary (Python or Rust) that communicates with QEMU
    exclusively through QMP, enabling future decoupling of the built-in
    HMP from QEMU core.

    QEMU provides two monitor interfaces:
    * '''QMP''' (QEMU Machine Protocol): A JSON-based machine-readable
      protocol for programmatic control
    * '''HMP''' (Human Monitor Protocol): A text-based interactive
      interface for human operators

    Currently, HMP is tightly integrated into QEMU, with commands
    defined in `hmp-commands.hx` and `hmp-commands-info.hx`. Most HMP
    commands already delegate to QMP internally (e.g., `hmp_quit()`
    calls `qmp_quit()`), but HMP parsing, formatting, and command
    dispatch are compiled into the QEMU binary.

Also line editing and completion.

Most HMP commands cleanly wrap around QMP command handlers such as
qmp_quit().  Wrapping them around QMP commands instead is a
straightforward problem.  I'm more concerned about HMP stuff that uses
other internal interfaces.  Replacing them may require new QMP
interfaces, or maybe a careful culling of inessential HMP features.
Known such stuff: completion does not wrap around QMP command handlers.
It is provided by the HMP core.

Risk: this can easily become the 10% that take the other 90% of the
time, or even the 5% that sink the project.

Risk: serious code duplication until we can get rid of built-in HMP.
Fine if the goal is to explore and learn by building a prototype, and we
simply throw away the prototype afterwards.

    This project aims to externalize HMP functionality, providing a
    standalone tool that offers the same user experience while
    communicating with QEMU purely through QMP.

Potential for a better editing experience, because our readline
reimplementation is lacking compared to the real thing.

    '''Add `CONFIG_HMP` build option''':
    * Create a new Meson configuration option to disable built-in HMP
    * Allow QEMU to be built without HMP
    * Facilitate testing of external HMP as a replacement

    '''Create an external HMP implementation''' in Python or Rust that:
    * Connects to QEMU via QMP socket
    * Parses HMP command syntax and translates to QMP calls
    * Formats QMP responses as human-readable HMP output
    * Supports command completion and help text

    '''Use `hmp-commands.hx` for code generation''':
    * Parse the existing `.hx` files to extract command definitions
    * Generate boilerplate code (command tables, argument parsing, help
      text)
    * Produce a report of implemented vs. unimplemented commands
    * Enable tracking of HMP/QMP parity

.hx is C source code with ReST snippets.  scripts/hxtool strips out the
ReST.  docs/sphinx/hxtool.py ignores the C source code, and processes
the ReST.  It works.  Not a fan.

If we succeed in replacing built-in HMP by an external one, and the
external one isn't written in C, then having C source code in .hx no
longer makes sense.  Parsing it will be wasted effort.  It may still
make sense initially.

    '''Identify and address QMP gaps''':
    * Audit all HMP commands for QMP equivalents

Also audit the HMP core.  Known problem: completion.

    * For critical missing commands, propose QAPI schema additions
    * Document commands that cannot be externalized
    * Provide patches or RFCs for missing QMP functionality

    '''Future Work''' (out of scope):

    * Seamless replacement of built-in HMP

    '''Links:'''
    * https://wiki.qemu.org/Documentation/QMP - QMP documentation
    * https://wiki.qemu.org/Features/QAPI - QAPI schema system
    * https://www.qemu.org/docs/master/interop/qemu-qmp-ref.html - QMP
      reference
    * https://www.qemu.org/docs/master/system/monitor.html - HMP
      documentation

    '''Details:'''
    * Skill level: intermediate
    * Language: Python or Rust (student choice), with C for QMP gap
      patches
=20=20=20=20
    * Mentor: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com> (elmarco
      on IRC)
    * Markus?

Makes sense.

    * Suggested by: Marc-Andr=C3=A9 Lureau


