Return-Path: <kvm+bounces-70162-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKJaHVwMg2k+hAMAu9opvQ
	(envelope-from <kvm+bounces-70162-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:07:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C10E391B
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CC93D301A16A
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 09:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6742E3A1A40;
	Wed,  4 Feb 2026 09:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D1o5Q4sV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB4E3A0EB0
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 09:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770196055; cv=none; b=JKjh/PzY4opgqQdp+CyJtUFixtAMtyM/hPXjMAx3TAQXDwm44TDf19gt2toNiYIIXaSWhStlHcTmQndOJNFTaGZXJVZu56KwhBcVjs1tnfbdJnF99JZfb3Wf6dFvvRQN5T4ECNM5pmV6i6nr+lOF1ELQTEzOe9b9w6MMySJ+U8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770196055; c=relaxed/simple;
	bh=RRMWsAKISPFxrJ+EzBQvFBK+2Vpe1SCzn5nrHScwZV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfsVvDcfS3xEH0mzmUyPkkQzqDS6zQzv0YnK0WHDzF65DRA6NjuDU+8OAgXIh6EB50676xofkbc16mV7hDQH1hApQZVjnTPTgg11IwqKYAuVUhRrEq+nafDhDPExhPWrWv28RROwVETdHVgkHQdWMfyFCg6gSVmuklDoWH03KpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D1o5Q4sV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770196054;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VAtUhEcCKZZszsfB8dyIiFJl10MlToo1zx3SL/WPXHo=;
	b=D1o5Q4sV0i2+qLbioMGkiHAUhHO/08UebGFMzGsNz9AwZEGBF4RdDSn0HpKG5KN62d3n2r
	uKAlIjgxmNB7VcRSeaRxCeKNjxEHyAPWvDmoveL7lMFngnDXi2q3oK1gAMh5MfbH9PdTu7
	pyf/A9yWJpfiTOaOB7HZdHu47oyV98Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-pUijXyVPNTSryFLK57qKog-1; Wed,
 04 Feb 2026 04:07:31 -0500
X-MC-Unique: pUijXyVPNTSryFLK57qKog-1
X-Mimecast-MFC-AGG-ID: pUijXyVPNTSryFLK57qKog_1770196049
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4682F1956064;
	Wed,  4 Feb 2026 09:07:29 +0000 (UTC)
Received: from redhat.com (unknown [10.44.33.80])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 084BB1955D85;
	Wed,  4 Feb 2026 09:07:21 +0000 (UTC)
Date: Wed, 4 Feb 2026 09:07:18 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: "Dr. David Alan Gilbert" <dave@treblig.org>,
	Fabiano Rosas <farosas@suse.de>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
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
Message-ID: <aYMMRuWGYe96rpZZ@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875x8d0w32.fsf@pond.sub.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.45 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FREEMAIL_CC(0.00)[treblig.org,suse.de,redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70162-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[instagram.com:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,berrange.com:url,libvirt.org:url,entangle-photo.org:url];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[berrange@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	HAS_REPLYTO(0.00)[berrange@redhat.com];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: E5C10E391B
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 09:08:49AM +0100, Markus Armbruster wrote:
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

Surely the isolated HMP monitor code can just keep track of its view
of a "default" CPU, and then pass an explicit CPU to the QMP commands
it runs ?


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


