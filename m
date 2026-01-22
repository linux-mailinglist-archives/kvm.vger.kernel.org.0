Return-Path: <kvm+bounces-68893-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2DcDOGUccmnrbwAAu9opvQ
	(envelope-from <kvm+bounces-68893-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:47:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D5066CEC
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8162592C242
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914AA37E2FE;
	Thu, 22 Jan 2026 12:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XX0k1/T8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F08329C49
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 12:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769084479; cv=none; b=WCPPY78nRfnSLXys+sBF0updUWTJW8duKX81Er1n9xyweGll6pmGAwFyTKEMDz/B+8dne8+g9gdoUp9FwJ6RcYWrW64ipUePfAPnET2vLwDQ3FgMUmhi9ff5O1UrInT2jo9O6YSP8FEQRIqllSPOctDG3pCPSenG0ZelLwno9EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769084479; c=relaxed/simple;
	bh=3rqvqjI8XKG23nRc1LFUmaXRPOmWE6+b+gCxSnYNG18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GadCfFttcjoPKIDma9G7zoMxmk1iNuqujMfQMNOPPB6uhN6tSox09H1kYvp4K/rRUWUC7W6CkOjUDOeI/X/GTX7m2cMmKMACPPy9qteNd6E4dB6+NB3WqZuRqBfJh69/2ahRntiUiTXgg5jR0pTVD4jgq0Ye/RRCdhCi27IbaYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XX0k1/T8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769084475;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BpiBtLOdWVTpWByhDHQeX1GcKZ4QfO/E5LS4cIHPAdU=;
	b=XX0k1/T8eD/vY2OTIkLLJxsqNvsLdH+KCVtuWkBSPEmwCJxmH/sXh1l4iz2V+N0tLzAt84
	EpdotHNBWk2BB0rMkvbXxws3FBhy4zjwLmA/GTfYbWdAFDmIdDn4a6Cbff6G3YJdL9jQ43
	vdafDW4RSK9LY/ojfzy9JzOgWPUEMfY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-194-pzs1tc67P7etDYwxpUwpiA-1; Thu,
 22 Jan 2026 07:21:12 -0500
X-MC-Unique: pzs1tc67P7etDYwxpUwpiA-1
X-Mimecast-MFC-AGG-ID: pzs1tc67P7etDYwxpUwpiA_1769084470
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 796931955D97;
	Thu, 22 Jan 2026 12:21:10 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.63])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F43A30002D1;
	Thu, 22 Jan 2026 12:21:05 +0000 (UTC)
Date: Thu, 22 Jan 2026 12:21:02 +0000
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
Message-ID: <aXIWLi656H8VbrPE@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <871pjigf6z.fsf_-_@pond.sub.org>
 <aXH1ECZ1Nchui9ED@redhat.com>
 <87ikctg8a8.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ikctg8a8.fsf@pond.sub.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
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
	TAGGED_FROM(0.00)[bounces-68893-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	DBL_BLOCKED_OPENRESOLVER(0.00)[instagram.com:url,berrange.com:url,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,entangle-photo.org:url];
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
X-Rspamd-Queue-Id: 59D5066CEC
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 01:07:43PM +0100, Markus Armbruster wrote:
> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
> > On Thu, Jan 22, 2026 at 10:38:28AM +0100, Markus Armbruster wrote:
> >> Let's start the discussion with your nicely written Wiki page:
> >> 
> >>     === External HMP Implementation via QMP ===
> >> 
> >>     '''Summary:''' Implement a standalone HMP-compatible monitor as an
> >>     external binary (Python or Rust) that communicates with QEMU
> >>     exclusively through QMP, enabling future decoupling of the built-in
> >>     HMP from QEMU core.
> >> 
> >>     QEMU provides two monitor interfaces:
> >>     * '''QMP''' (QEMU Machine Protocol): A JSON-based machine-readable
> >>       protocol for programmatic control
> >>     * '''HMP''' (Human Monitor Protocol): A text-based interactive
> >>       interface for human operators
> >> 
> >>     Currently, HMP is tightly integrated into QEMU, with commands
> >>     defined in `hmp-commands.hx` and `hmp-commands-info.hx`. Most HMP
> >>     commands already delegate to QMP internally (e.g., `hmp_quit()`
> >>     calls `qmp_quit()`), but HMP parsing, formatting, and command
> >>     dispatch are compiled into the QEMU binary.
> >
> > First of all, I love the idea. An external HMP impl that consumes
> > QMP from outside QEMU so a concept I've suggested many times over
> > 10+ years hoping someone would take the bait and impl it :-)
> >
> >> Also line editing and completion.
> >> 
> >> Most HMP commands cleanly wrap around QMP command handlers such as
> >> qmp_quit().  Wrapping them around QMP commands instead is a
> >> straightforward problem.  I'm more concerned about HMP stuff that uses
> >> other internal interfaces.  Replacing them may require new QMP
> >> interfaces, or maybe a careful culling of inessential HMP features.
> >> Known such stuff: completion does not wrap around QMP command handlers.
> >> It is provided by the HMP core.
> >> 
> >> Risk: this can easily become the 10% that take the other 90% of the
> >> time, or even the 5% that sink the project.
> >
> > IMHO this is essentially guaranteed.
> >
> > 4 years ago I tried to move us closer to this world by introducing
> > "HumanReadableText" and documenting that all remaining & future
> > "info xxx" commands should be backed by a QMP command that just
> > returns human formatted text. The intent was to eliminate the
> > roadblock of having to define formal QAPI types for all the
> > complex data.
> >
> > I converted a bunch of commands, but that indeed became do 90%
> > of the work, leave the other 90% of the work for later victim^H^H^H
> > contributor.
> >
> > None of this means that the GSoc project idea is invalid. We just
> > have to figure out a credible end goal is for the project, ideally
> > with staged delivery.
> 
> Makes sense.
> 
> If we see the GSoC project as a first step towards replacing the
> built-in HMP by an standalone program talking QMP ("Modern HMP"), we
> better scope it carefully, so it (1) has achievable success criteria,
> and (2) makes real progress towards the actual finish line.
> 
> >> Risk: serious code duplication until we can get rid of built-in HMP.
> >> Fine if the goal is to explore and learn by building a prototype, and we
> >> simply throw away the prototype afterwards.
> >
> > IMHO that isn't a risk, that's a guarantee. I can't imagine converting
> > all remaining HMP commands to have a QMP backing, AND doing an external
> > HMP impl all within the GSoc timeline.  That's two largely independent
> > projects, each of which are probably longer than the GSoC time wnidow.
> >
> > Again that doesn't mean the idea is invalid for GSoc, just that we must
> > be honest about likely deliverables, and how follow up work will happen
> > after GSoc to maximise benefit for QEMU.
> >
> > What I would not want to see is a bunch of work done that is then
> > abandoned because it couldn't get used as it wasn't feature complete.
> > Whatever subset is achieved ought to be intended as a stepping stone
> > we can integrate and carry on working with.
> 
> Does the GSoC project make sense without a firm commitment to followup
> work to finish the job?
> 
> Specifically, commitment by whom to do what?
> 
> >>     '''Add `CONFIG_HMP` build option''':
> >>     * Create a new Meson configuration option to disable built-in HMP
> >>     * Allow QEMU to be built without HMP
> >>     * Facilitate testing of external HMP as a replacement
> >> 
> >>     '''Create an external HMP implementation''' in Python or Rust that:
> >>     * Connects to QEMU via QMP socket
> >>     * Parses HMP command syntax and translates to QMP calls
> >>     * Formats QMP responses as human-readable HMP output
> >>     * Supports command completion and help text
> >> 
> >>     '''Use `hmp-commands.hx` for code generation''':
> >>     * Parse the existing `.hx` files to extract command definitions
> >>     * Generate boilerplate code (command tables, argument parsing, help
> >>       text)
> >>     * Produce a report of implemented vs. unimplemented commands
> >>     * Enable tracking of HMP/QMP parity
> >> 
> >> .hx is C source code with ReST snippets.  scripts/hxtool strips out the
> >> ReST.  docs/sphinx/hxtool.py ignores the C source code, and processes
> >> the ReST.  It works.  Not a fan.
> >> 
> >> If we succeed in replacing built-in HMP by an external one, and the
> >> external one isn't written in C, then having C source code in .hx no
> >> longer makes sense.  Parsing it will be wasted effort.  It may still
> >> make sense initially.
> >
> > Indeed, we should clarify language intended as it would influence
> > the approach for the project.  If it is a clean room Rust impl,
> > then it would be completely independent of existing HMP C code.
> > More work initially to ensure we retain the same data formatting
> > of each command, but likely nicer long term, and saying Rust will
> > probably attract more candidates to the idea.
> 
> In theory, we could make the same HMP code work in both contexts,
> built-in HMP and standaline HMP.  I doubt this is feasible, at least not
> at reasonable cost.  Too much disentangling.  I could be wrong.
> 
> If we use separate HMP code, i.e. accept code duplication until we
> retire built-in HMP, then picking a different language for the new copy
> won't add all that much to the bother of having to maintain two copies.
> 
> HMP is not a stable interface.  We make reasonable efforts not to change
> the output without a good reason.  I don't think identical data
> formatting is a requirement.  Just make a reasonable effort.
> 
> Marc-André proposed Python or Rust.  Anyone got a preference backed by
> reasons?

My suggestion would be Rust, as it allows the possibility to embed
that Rust impl inside the current QEMU binaries, to fully replace
the C code and retain broadly the same functionality.

We might never do it, but it feels like a good idea to keep the
door option.  Python rules that out entirely meaning we keep the
current C code forever, unless we do a full break with command
line compatibility at some point.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


