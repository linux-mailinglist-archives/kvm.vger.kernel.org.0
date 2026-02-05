Return-Path: <kvm+bounces-70323-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFDLIwqThGk43gMAu9opvQ
	(envelope-from <kvm+bounces-70323-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 13:54:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2F2F2D91
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 13:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97E5C303A6FC
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 12:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F78B3D410E;
	Thu,  5 Feb 2026 12:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="hpqzacrM"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59003BFE25
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 12:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770295833; cv=none; b=u0jdFvHgybE7CsQXhbg7+ugM5Yx91Y1S5Bd4YCg7Gh4oQE1ZjSAuEMCiMNpwBgKNxBKHj0iQuDmvVfoawJs4LA4v33wsRVepki9avk3Aw7GxYemSxepxiN2OQCJeTHlW64tjxmlIFVPX7SrXhKSfjRqsYKqmKjU7cMij2MscRFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770295833; c=relaxed/simple;
	bh=wL7N6uM0kgXAyrDv2iJAkiw8WJ46qc3mA2HG43vhL90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W+1c65K1pUHYu838Du7ug2G6KE/nF588g5PhfhobNN4rtl0ZiRaEi0xCYORGxsI7E+FK+E+dJIliEO+Ulq6LawKFSoiX2/7hZKEkSkF7kFMz91wyanbj2g3seatmGMNUXdheMnb2VZUsOsfccROux5GLkqu1A0MdhX+4iX5PCvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=hpqzacrM; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=o0OFaDPZVokASYXb24gtt2efhu04PBppuKZMNoPGxBo=; b=hpqzacrMKpr9eVtp
	RpHFPHp1SoITbQfB9oSXKlro02KQt5dTJE5jUHlFMUSwGzGJ1xL61YCD8NE0CnmuIS6rzJZBjv1Pv
	2/pKG5y49Lx9qeE86VYhZO4yRm807Jfi1l6d4rDVg01Kw/MbI5W+4owwJvvD8BH9Y0GIBwatCfhVs
	njaNgKQn1xORZrNEtvoa2tvYuPxLrlnEJYyNSuJIe6BjcSk6pByfRd+qqSL0n/PZFPzSRN4NLuG6y
	zOIGVJdYI/ub1ydT7phsMxZGKfDTXPZKMTfDM7+VqHnGq2+rjArLAEfe1bS1Ova/5fVXRRErbr8iH
	TjkE5Nn+X0we3b461w==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vnyoY-00000001xE0-3gRR;
	Thu, 05 Feb 2026 12:50:30 +0000
Date: Thu, 5 Feb 2026 12:50:30 +0000
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
Message-ID: <aYSSFo_HV6S0LQQS@gallifrey>
References: <871pjigf6z.fsf_-_@pond.sub.org>
 <aXH1ECZ1Nchui9ED@redhat.com>
 <87ikctg8a8.fsf@pond.sub.org>
 <aXIWLi656H8VbrPE@redhat.com>
 <87ikctk5ss.fsf@suse.de>
 <aXJJkd8g0AGZ3EVv@redhat.com>
 <aX-boauFX2Ju7x8Z@gallifrey>
 <875x8d0w32.fsf@pond.sub.org>
 <aYPvN5fphSObsvGR@gallifrey>
 <87ms1nu1fj.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ms1nu1fj.fsf@pond.sub.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 12:49:56 up 101 days, 12:26,  2 users,  load average: 0.04, 0.01,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	FROM_NAME_HAS_TITLE(1.00)[dr];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[treblig.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[treblig.org:s=bytemarkmx];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70323-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[treblig.org:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave@treblig.org,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[redhat.com,suse.de,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EB2F2F2D91
X-Rspamd-Action: no action

* Markus Armbruster (armbru@redhat.com) wrote:
> "Dr. David Alan Gilbert" <dave@treblig.org> writes:
> 
> [...]
> 
> > I did see you suggesting for Rust for it; which would work - although
> > given it wouldn't be performance sensitive, Python would seem reasonable.
> 
> Marc-André suggested "Python or Rust (student choice)".
> 
> Daniel argued for Rust "as it allows the possibility to embed that Rust
> impl inside the current QEMU binaries, to fully replace the C code and
> retain broadly the same functionality."
> 
> If we're not interested in such embedding, then Python feels preferable
> to me, because I'd expect it to get us to the finish line faster.

Ah ok, the either-or embedding thing sounds neat; but does sound like
it would complicate stuff.

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

