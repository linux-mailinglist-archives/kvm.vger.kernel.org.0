Return-Path: <kvm+bounces-68905-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBuIAK1ZcmkpiwAAu9opvQ
	(envelope-from <kvm+bounces-68905-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:09:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B4A556AD32
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:09:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C636E300832C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9C94C9013;
	Thu, 22 Jan 2026 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1exX3P/m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LC5deoz6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1exX3P/m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LC5deoz6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C39A4C043A
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 15:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769096881; cv=none; b=loQTI73RCNtJbmJv6YYr/ykB5Ztnyv/MSI+XolipaLZqmZ6yEsBPhLF6kucXmoLg2US3z9BonI5xGwq6ecWNrlK99KTiq/NGBBv45RIq0i0THkWHA35Ndh1/kT04Zn6VZk6BPG+CGSrip/ZL7kGCwowhp07MdNLGZhpnN+bi3jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769096881; c=relaxed/simple;
	bh=fl8ZoqQARI6Y28bGy/JJNEaaLgVMjWUOzv1nnM0OGo4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Qo74uBB/tMhP8cBzv95VWudEPDOELswX9+ppxiUwso0qIhEwhbNn/uy+6A0hS8wT45SnmdTCGxaAlw83OqhCE+B0LgvDHh/fKbWF32Y3d6TtuSvOV67ibXe3+FJvGVpBLicPSnGhKMNtNGSVq0X9zrkvhZzPJK/WW4dd2mxgkuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1exX3P/m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LC5deoz6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1exX3P/m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LC5deoz6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BB37F5BCD3;
	Thu, 22 Jan 2026 15:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769096870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BpxyDjvnhTGZD1UGyN78pEBg0d5ITPh/BmizeskZCjk=;
	b=1exX3P/m3ycRcu6n3K6QZU9e+5Hz1bypUNwV2VqC8A2mnjVMHtkL7ydqxd8CjZ0Usbt3lI
	blB6KnG4HWrhAUZAVZAsWviw9lT4iPOINSGg1eefuueoJF89Expaya0aD7/dasmJLhN+b9
	aKFdnZopMV9JirF3mC26CCW/8SaR824=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769096870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BpxyDjvnhTGZD1UGyN78pEBg0d5ITPh/BmizeskZCjk=;
	b=LC5deoz6GgCNBUp3TEQwj+bs0CtJg65GfVs0I2epXxj/hcANGzsH/0j7Y9qYFgf2nHP0mO
	vsSIgL6e4VNzQeBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="1exX3P/m";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LC5deoz6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769096870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BpxyDjvnhTGZD1UGyN78pEBg0d5ITPh/BmizeskZCjk=;
	b=1exX3P/m3ycRcu6n3K6QZU9e+5Hz1bypUNwV2VqC8A2mnjVMHtkL7ydqxd8CjZ0Usbt3lI
	blB6KnG4HWrhAUZAVZAsWviw9lT4iPOINSGg1eefuueoJF89Expaya0aD7/dasmJLhN+b9
	aKFdnZopMV9JirF3mC26CCW/8SaR824=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769096870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BpxyDjvnhTGZD1UGyN78pEBg0d5ITPh/BmizeskZCjk=;
	b=LC5deoz6GgCNBUp3TEQwj+bs0CtJg65GfVs0I2epXxj/hcANGzsH/0j7Y9qYFgf2nHP0mO
	vsSIgL6e4VNzQeBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2120F13533;
	Thu, 22 Jan 2026 15:47:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2jrINKVGcmk5dAAAD6G6ig
	(envelope-from <farosas@suse.de>); Thu, 22 Jan 2026 15:47:49 +0000
From: Fabiano Rosas <farosas@suse.de>
To: =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, Markus
 Armbruster
 <armbru@redhat.com>
Cc: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Stefan
 Hajnoczi
 <stefanha@gmail.com>, qemu-devel <qemu-devel@nongnu.org>, kvm
 <kvm@vger.kernel.org>, Helge Deller <deller@gmx.de>, Oliver Steffen
 <osteffen@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Matias
 Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
 German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Philippe =?utf-8?Q?Mathieu-Daud?=
 =?utf-8?Q?=C3=A9?=
 <philmd@linaro.org>, Thomas Huth <thuth@redhat.com>, Mark Cave-Ayland
 <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Re: Modern HMP
In-Reply-To: <aXIWLi656H8VbrPE@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <871pjigf6z.fsf_-_@pond.sub.org> <aXH1ECZ1Nchui9ED@redhat.com>
 <87ikctg8a8.fsf@pond.sub.org> <aXIWLi656H8VbrPE@redhat.com>
Date: Thu, 22 Jan 2026 12:47:47 -0300
Message-ID: <87ikctk5ss.fsf@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	TAGGED_FROM(0.00)[bounces-68905-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[farosas@suse.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[19];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B4A556AD32
X-Rspamd-Action: no action

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Thu, Jan 22, 2026 at 01:07:43PM +0100, Markus Armbruster wrote:
>> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>>=20
>> > On Thu, Jan 22, 2026 at 10:38:28AM +0100, Markus Armbruster wrote:
>> >> Let's start the discussion with your nicely written Wiki page:
>> >>=20
>> >>     =3D=3D=3D External HMP Implementation via QMP =3D=3D=3D
>> >>=20
>> >>     '''Summary:''' Implement a standalone HMP-compatible monitor as an
>> >>     external binary (Python or Rust) that communicates with QEMU
>> >>     exclusively through QMP, enabling future decoupling of the built-=
in
>> >>     HMP from QEMU core.
>> >>=20
>> >>     QEMU provides two monitor interfaces:
>> >>     * '''QMP''' (QEMU Machine Protocol): A JSON-based machine-readable
>> >>       protocol for programmatic control
>> >>     * '''HMP''' (Human Monitor Protocol): A text-based interactive
>> >>       interface for human operators
>> >>=20
>> >>     Currently, HMP is tightly integrated into QEMU, with commands
>> >>     defined in `hmp-commands.hx` and `hmp-commands-info.hx`. Most HMP
>> >>     commands already delegate to QMP internally (e.g., `hmp_quit()`
>> >>     calls `qmp_quit()`), but HMP parsing, formatting, and command
>> >>     dispatch are compiled into the QEMU binary.
>> >
>> > First of all, I love the idea. An external HMP impl that consumes
>> > QMP from outside QEMU so a concept I've suggested many times over
>> > 10+ years hoping someone would take the bait and impl it :-)
>> >
>> >> Also line editing and completion.
>> >>=20
>> >> Most HMP commands cleanly wrap around QMP command handlers such as
>> >> qmp_quit().  Wrapping them around QMP commands instead is a
>> >> straightforward problem.  I'm more concerned about HMP stuff that uses
>> >> other internal interfaces.  Replacing them may require new QMP
>> >> interfaces, or maybe a careful culling of inessential HMP features.
>> >> Known such stuff: completion does not wrap around QMP command handler=
s.
>> >> It is provided by the HMP core.
>> >>=20
>> >> Risk: this can easily become the 10% that take the other 90% of the
>> >> time, or even the 5% that sink the project.
>> >
>> > IMHO this is essentially guaranteed.
>> >
>> > 4 years ago I tried to move us closer to this world by introducing
>> > "HumanReadableText" and documenting that all remaining & future
>> > "info xxx" commands should be backed by a QMP command that just
>> > returns human formatted text. The intent was to eliminate the
>> > roadblock of having to define formal QAPI types for all the
>> > complex data.
>> >
>> > I converted a bunch of commands, but that indeed became do 90%
>> > of the work, leave the other 90% of the work for later victim^H^H^H
>> > contributor.
>> >
>> > None of this means that the GSoc project idea is invalid. We just
>> > have to figure out a credible end goal is for the project, ideally
>> > with staged delivery.
>>=20
>> Makes sense.
>>=20
>> If we see the GSoC project as a first step towards replacing the
>> built-in HMP by an standalone program talking QMP ("Modern HMP"), we
>> better scope it carefully, so it (1) has achievable success criteria,
>> and (2) makes real progress towards the actual finish line.
>>=20
>> >> Risk: serious code duplication until we can get rid of built-in HMP.
>> >> Fine if the goal is to explore and learn by building a prototype, and=
 we
>> >> simply throw away the prototype afterwards.
>> >
>> > IMHO that isn't a risk, that's a guarantee. I can't imagine converting
>> > all remaining HMP commands to have a QMP backing, AND doing an external
>> > HMP impl all within the GSoc timeline.  That's two largely independent
>> > projects, each of which are probably longer than the GSoC time wnidow.
>> >
>> > Again that doesn't mean the idea is invalid for GSoc, just that we must
>> > be honest about likely deliverables, and how follow up work will happen
>> > after GSoc to maximise benefit for QEMU.
>> >
>> > What I would not want to see is a bunch of work done that is then
>> > abandoned because it couldn't get used as it wasn't feature complete.
>> > Whatever subset is achieved ought to be intended as a stepping stone
>> > we can integrate and carry on working with.
>>=20
>> Does the GSoC project make sense without a firm commitment to followup
>> work to finish the job?
>>=20
>> Specifically, commitment by whom to do what?
>>=20
>> >>     '''Add `CONFIG_HMP` build option''':
>> >>     * Create a new Meson configuration option to disable built-in HMP
>> >>     * Allow QEMU to be built without HMP
>> >>     * Facilitate testing of external HMP as a replacement
>> >>=20
>> >>     '''Create an external HMP implementation''' in Python or Rust tha=
t:
>> >>     * Connects to QEMU via QMP socket
>> >>     * Parses HMP command syntax and translates to QMP calls
>> >>     * Formats QMP responses as human-readable HMP output
>> >>     * Supports command completion and help text
>> >>=20
>> >>     '''Use `hmp-commands.hx` for code generation''':
>> >>     * Parse the existing `.hx` files to extract command definitions
>> >>     * Generate boilerplate code (command tables, argument parsing, he=
lp
>> >>       text)
>> >>     * Produce a report of implemented vs. unimplemented commands
>> >>     * Enable tracking of HMP/QMP parity
>> >>=20
>> >> .hx is C source code with ReST snippets.  scripts/hxtool strips out t=
he
>> >> ReST.  docs/sphinx/hxtool.py ignores the C source code, and processes
>> >> the ReST.  It works.  Not a fan.
>> >>=20
>> >> If we succeed in replacing built-in HMP by an external one, and the
>> >> external one isn't written in C, then having C source code in .hx no
>> >> longer makes sense.  Parsing it will be wasted effort.  It may still
>> >> make sense initially.
>> >
>> > Indeed, we should clarify language intended as it would influence
>> > the approach for the project.  If it is a clean room Rust impl,
>> > then it would be completely independent of existing HMP C code.
>> > More work initially to ensure we retain the same data formatting
>> > of each command, but likely nicer long term, and saying Rust will
>> > probably attract more candidates to the idea.
>>=20
>> In theory, we could make the same HMP code work in both contexts,
>> built-in HMP and standaline HMP.  I doubt this is feasible, at least not
>> at reasonable cost.  Too much disentangling.  I could be wrong.
>>=20
>> If we use separate HMP code, i.e. accept code duplication until we
>> retire built-in HMP, then picking a different language for the new copy
>> won't add all that much to the bother of having to maintain two copies.
>>=20
>> HMP is not a stable interface.  We make reasonable efforts not to change
>> the output without a good reason.  I don't think identical data
>> formatting is a requirement.  Just make a reasonable effort.
>>=20
>> Marc-Andr=C3=A9 proposed Python or Rust.  Anyone got a preference backed=
 by
>> reasons?
>
> My suggestion would be Rust, as it allows the possibility to embed
> that Rust impl inside the current QEMU binaries, to fully replace
> the C code and retain broadly the same functionality.
>

One question I have is what exactly gets (eventually) removed from QEMU
and what benefits we expect from it. Is it the entire "manual"
interaction that's undesirable? Or just that to maintain HMP there is a
certain amount of duplication? Or even the less-than-perfect
readline/completion aspects?

Does the new program becomes basically an external project unrelated to
QEMU, that simply talks to QMP like libvirt does?

I wonder how close to tools like qmp-shell, qmp-tui, etc that would
become and whether we might actually be looking at a substitute of
qemu.qmp.

