Return-Path: <kvm+bounces-70281-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Mm1OVHvg2mtvwMAu9opvQ
	(envelope-from <kvm+bounces-70281-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:16:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 26BFEED99F
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7827D301D4F5
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 01:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FF228371;
	Thu,  5 Feb 2026 01:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="jV0AcD2R"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC482673B7
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 01:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770254143; cv=none; b=Pq0HOcWQTG0ChrSe8/9NLioaIC5nx7JvZLHkNwXyEOZ25g9akIqRjiDtOyxIJe+c7s1WH6oYfc2KR49kRhfCg5elUNGM4BaQusvLmbt5zJQ0Fbu50xBajLep+tFZlp4Qjyzaf55SHDAF8bfdfSPOOdyC9SsfLc6TFHaxVVRIJ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770254143; c=relaxed/simple;
	bh=1drKgF4ajzya9XhP/CvXuOd9zfTrVrBmZxUCb55OE48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlHv57qHuaOcNOyfo8zUkUJU4YStuUXMMYEXbWQBbKhj/AqaXOaro07Pwb6thvpYFUGNdnZy17mjDSdLp3Qbn0xNgmcy1wLtBSH1RWu44JgPW9seZsqg8Yascj7NwfgwFh/ciDGYqUDsQYJjBAC5Jdy6MxZSGcPoO4Mz8rieKUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=jV0AcD2R; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=WE4JzyZWLqvyCLbos5SjtMuecIp4MuU+rHKP0bYJTis=; b=jV0AcD2RHJWVcMGL
	4GU+iQDl4TXR5N148QPTuAPk5qi8edo6V6uB4t2f3Tf77UVYWsZTIuK4bx1ycw6aET0ajk1am7A4l
	UcFGmHI1qG4owgoAVS1yacs69Oc+D3Hzzsj1fdFTmhqL9wbY7cSSuas6wawzcmBGl+mErVu9rH4kY
	hKbZiKAzKkdkyEQ1rZPTwVuixCxjHNzFx4TZiqeQ40LSdFQmQ/OKRQO3UR8tkmdo0WCEEtWXRkT16
	4NiZBkpp7Ru8Xp4RUTdZm4fWLLJB31yV/5aDsEqI4euyQIdIp5whcoua/wrosIlut1wrvSQctKgnO
	Pvdx9JbOoxQAKbETxw==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vnny3-00000001qop-1LjW;
	Thu, 05 Feb 2026 01:15:35 +0000
Date: Thu, 5 Feb 2026 01:15:35 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Stefan Hajnoczi <stefanha@gmail.com>,
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	German Maglione <gmaglione@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Alex Bennee <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Re: Modern HMP
Message-ID: <aYPvN5fphSObsvGR@gallifrey>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <871pjigf6z.fsf_-_@pond.sub.org>
 <aXH1ECZ1Nchui9ED@redhat.com>
 <87ikctg8a8.fsf@pond.sub.org>
 <aXIWLi656H8VbrPE@redhat.com>
 <87ikctk5ss.fsf@suse.de>
 <aXJJkd8g0AGZ3EVv@redhat.com>
 <aX-boauFX2Ju7x8Z@gallifrey>
 <875x8d0w32.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875x8d0w32.fsf@pond.sub.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 00:28:17 up 101 days, 4 min,  3 users,  load average: 0.04, 0.01,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	FROM_NAME_HAS_TITLE(1.00)[dr];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[treblig.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[treblig.org:s=bytemarkmx];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70281-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[treblig.org:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave@treblig.org,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[redhat.com,suse.de,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 26BFEED99F
X-Rspamd-Action: no action

* Markus Armbruster (armbru@redhat.com) wrote:
> "Dr. David Alan Gilbert" <dave@treblig.org> writes:
> 
> > * Daniel P. Berrangé (berrange@redhat.com) wrote:
> >> On Thu, Jan 22, 2026 at 12:47:47PM -0300, Fabiano Rosas wrote:
> >> > One question I have is what exactly gets (eventually) removed from QEMU
> >> > and what benefits we expect from it. Is it the entire "manual"
> >> > interaction that's undesirable? Or just that to maintain HMP there is a
> >> > certain amount of duplication? Or even the less-than-perfect
> >> > readline/completion aspects?
> >> 
> >> Over time we've been gradually separating our human targetted code from
> >> our machine targetted code, whether that's command line argument parsing,
> >> or monitor parsing. Maintaining two ways todo the same thing is always
> >> going to be a maint burden, and in QEMU it has been especially burdensome
> >> as they were parallel impls in many cases, rather than one being exclusively
> >> built on top of the other.
> >> 
> >> Even today we still get contributors sending patches which only impl
> >> HMP code and not QMP code. Separating HMP fully from QMP so that it
> >> was mandatory to create QMP first gets contributors going down the
> >> right path, and should reduce the burden on maint.
> >
> > Having a separate HMP isn't a bad idea - but it does need some idea of
> > how to make it easy for contributors to add stuff that's just for debug
> > or for the dev.   For HMP the bar is very low; if it's useful to the
> > dev, why not (unless it's copying something that's already in the QMP interface
> > in a different way);  but although the x- stuff in theory lets
> > you add something via QMP, in practice it's quite hard to get it through
> > review without a lot of QMP design bikeshedding.
> 
> I think this description has become less accurate than it used to be :)
> 
> A long time ago, we started with "QMP is a stable, structured interface
> for machines, HMP is a plain text interface for humans, and layered on
> top of QMP."  Layered on top means HMP commands wrap around QMP
> commands.  Ensures that QMP is obviously complete.  Without such a
> layering, we'd have to verify completeness by inspection.  Impractical
> given the size and complexity of the interfaces involved.
> 
> Trouble is there are things in HMP that make no sense in QMP.  For
> instance, HMP command 'cpu' sets the monitor's default CPU, which
> certain HMP commands use.  To wrap 'cpu' around a QMP command, we'd have
> to drag the concept "default CPU" into QMP where it's not wanted.

That's just state; that's easy!

> So we retreated from "all", and permitted exceptions for commands that
> make no sense in QMP.
> 
> We then found out the hard & expensive way that designing a QMP command
> with its stable, structured interface is often a lot harder than
> cobbling together an HMP command.  It's not just avoidable social
> problems ("bikeshedding"); designing stable interfaces is just hard.
> Sometimes the extra effort is worthwhile.  Sometimes it's not, e.g. when
> all we really want is print something to aid a human with debugging.

Right.

> So we retreated from "all" some more, and permitted exceptions for
> commands meant exclusively for human use, typically debugging and
> development aids.
> 
> This effectifely redefined the meaning of "complete": instead of "QMP
> can do everything HMP can do and more", it's now "... except for certain
> development and debugging aids and maybe other stuff".
> 
> To keep "maybe other stuff" under control, we required (and still
> require) an *argument* for adding functionality just to HMP.
> 
> This turned out to be differently bothersome.  Having to review HMP
> changes for QMP bypasses is bothersome, and bound to miss things at
> least occasionally.  Having to ask for an argument is bothersome.
> Constructing one is bothersome.

Well, it's not too bad as long as the arguments are only asked to be
reasonable rather than bulletproof.

> To reduce the bother, we retreated from another QMP ideal: the
> structured interface.  Permit QMP commands to return just text when the
> command is meant just for humans.  Such commands must be unstable.
> Possible because we had retreated from "all of QMP is stable" meanwhile.
> 
> How does this work?  Instead of adding an HMP-only command, add a QMP
> command that returns QAPI type HumanReadableText, and a trivial HMP
> command that wraps around it.  Slightly more work, but no interface
> design.

Yes, I've seen that - and as long as that continues it's OK;
although it does feel weird in a few ways; it seems more work
to implement than just being able to print, but I do worry
what happens with commands with a lot of output.   It also gets
weirder when you have to parameterise it, because you get the parameter
parsing in one place influencing the separate formatting.

> The QMP command addition is much more visible to the QAPI/QMP
> maintainers than an HMP-only command would be.  This helps avoid missing
> things.
> 
> We still want an argument why a structured interface isn't needed.  But
> we can be much more lenient there: if it turns out to be needed, we can
> just add it, and drop the unstructured interface.  Remember, it's
> unstable.
> 
> Hope this helps.

Yeh, it's just something to be watchful of.

I did see you suggesting for Rust for it; which would work - although
given it wouldn't be performance sensitive, Python would seem reasonable.

Dave

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

