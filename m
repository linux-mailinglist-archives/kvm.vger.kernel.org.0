Return-Path: <kvm+bounces-67550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6EFD0874B
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 11:12:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5327B303F654
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 10:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5DE42A80;
	Fri,  9 Jan 2026 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dNqldvQP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0532F6928
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 10:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767953256; cv=none; b=TGYMT/Q4ZiOdrqP7WG9owryXmHEYSZ/ngjhCBuC7e2cnhLNzI2VjE9SBQZpBCFOkBLajyLql32rXz2v7aqt11hxISO8j2oyIg22lY/sqPJRveVl6SLaImR5pyAdB098zQPTGq6eON8t/ii/iQ8kC16U16m0b8r5SUExJRaxNUW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767953256; c=relaxed/simple;
	bh=REVzig4MjHHgYwYSO4zljJ1rWWVvrg8CHBNjRprdGkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPSo3fZ1UG6dcOxs9dgH21GWYoxPlaMz7JeZBsjDWjXU48MFzbb9zXuTN1DqnJosj6b6rVUCuvmBgYO553RaYXDHriycdlcGx+NHyu8+aFhQq+nCv5k9jZBQ1gZ9P0pN2dczV3EStHNzRUYSVB8F7fIq0Q4m3TPmmgsBiNMVHgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dNqldvQP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767953253;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2kqXqa/z20xXzqGwszoGQHOQvZhM3/sF3LS96EOsBmE=;
	b=dNqldvQPZ8HrdKb44q60+mgB6rDilhXfdzKcBGtKcOxlW9HvMbBx5ZXCgRx1Lp8/Qh25sR
	6jZV75x4Ndd7HMSpWSRxdrvDtByqk3ABUfpgnXA0vvygin2pIoezr/ASxHnH4Vji4s89V8
	wrrrwHN6btXDVKl7iMjmdSY3QQI2Dgk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-T-U1g9hDNSSq0BRCIqAthg-1; Fri,
 09 Jan 2026 05:07:32 -0500
X-MC-Unique: T-U1g9hDNSSq0BRCIqAthg-1
X-Mimecast-MFC-AGG-ID: T-U1g9hDNSSq0BRCIqAthg_1767953251
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5914419560B2;
	Fri,  9 Jan 2026 10:07:31 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.39])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 437F830002D1;
	Fri,  9 Jan 2026 10:07:29 +0000 (UTC)
Date: Fri, 9 Jan 2026 10:07:26 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: marcandre.lureau@redhat.com, qemu-devel@nongnu.org,
	Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH] Add query-tdx-capabilities
Message-ID: <aWDTXvXxPRj2fs2b@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
 <aV41CQP0JODTdRqy@redhat.com>
 <87qzrzku9z.fsf@pond.sub.org>
 <aWDMU7WOlGIdNush@redhat.com>
 <87jyxrksug.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87jyxrksug.fsf@pond.sub.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Jan 09, 2026 at 11:01:27AM +0100, Markus Armbruster wrote:
> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
> > On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrote:
> >> Daniel P. Berrangé <berrange@redhat.com> writes:
> >> 
> >> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@redhat.com wrote:
> >> >> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> >> >> 
> >> >> Return an empty TdxCapability struct, for extensibility and matching
> >> >> query-sev-capabilities return type.
> >> >> 
> >> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
> >> >> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> [...]
> 
> >> > This matches the conceptual design used with query-sev-capabilities,
> >> > where the lack of SEV support has to be inferred from the command
> >> > returning "GenericError".
> >> 
> >> Such guesswork is brittle.  An interface requiring it is flawed, and
> >> should be improved.
> >> 
> >> Our SEV interface doesn't actually require it: query-sev tells you
> >> whether we have SEV.  Just run that first.
> >
> > Actually these commands are intended for different use cases.
> >
> > "query-sev" only returns info if you have launched qemu with
> >
> >   $QEMU -object sev-guest,id=cgs0  -machine confidential-guest-support=cgs0
> >
> > The goal of "query-sev-capabilities" is to allow you to determine
> > if the combination of host+kvm+qemu are capable of running a guest
> > with "sev-guest".
> >
> > IOW, query-sev-capabilities alone is what you want/need in order
> > to probe host features.
> >
> > query-sev is for examining running guest configuration
> 
> The doc comments fail to explain this.  Needs fixing.
> 
> Do management applications need to know more than "this combination of
> host + KVM + QEMU can do SEV, yes / no?
> 
> If yes, what do they need?  "No" split up into serval "No, because X"?

When libvirt runs  query-sev-capabilities it does not care about the
reason for it being unsupported.   Any "GenericError" is considered
to mark the lack of host support, and no fine grained checks are
performed on the err msg.

If query-sev-capabilities succeeds (indicating SEV is supported), then
all the returned info is exposed to mgmt apps in the libvirt domain
capabilities XML document.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


