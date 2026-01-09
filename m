Return-Path: <kvm+bounces-67554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D91CD089F2
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 11:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 630CE3019867
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 10:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880FA339B3B;
	Fri,  9 Jan 2026 10:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gw3fxfsh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E54C339855
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 10:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767955138; cv=none; b=mUiuYRwlKITP4y6UyFM5n/C9hhbU9u6rDPDuvgTSmEctzZ1zfO3LuxiWHAd1iyCZv/ZSEv01ggQbMriZG90/G35SwMAHDbdDsXWCtUtqTrC8NSwVV/MDqOJQQVCRvDND1B6YLsA5QI7faXxR9clYijbZIwwsqvdfFtnRldrwuss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767955138; c=relaxed/simple;
	bh=rJ/TCJiqutmjSH4kE9gxXzcCU0wzhUWcoo5fuWZNuZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNS7wSpwGqa1SsgyKY4RdGtQ46sv2oJGKO/VZQIDiQ1ZTcLB2gpjSowsNYrssrjLgeKwBJR0P6u9DVN3Amd8V2/v9QtDI9SqyaPyT06Hbk2UYqX1cywbAjKMZRrQTodVpOhYGm/QO//e3+jQ2Bx87l8AnudFYv5VEhNEzf6RXiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gw3fxfsh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767955136;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SV51RAZK6MTjztbwfLzbtKVAr1LE44UjUdFU21v/4JQ=;
	b=Gw3fxfshFxbOb1/cYlyJz7SAw25FaPjLhs8flFQNFOL5cncjX7l2rRaW0gO0kg2aqp9Thj
	Kkj6Cj/fNNI8+F6fYRAppDuizwyiQmfdUdhxyfMFMAPWlC8OMX3yC8fNNbvg1mMbI7Tzy6
	9repnxMryOXFtJcxiYjv+gV6+eSAHI4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-Qi4boIJENDqYt87tb-LUbg-1; Fri,
 09 Jan 2026 05:38:55 -0500
X-MC-Unique: Qi4boIJENDqYt87tb-LUbg-1
X-Mimecast-MFC-AGG-ID: Qi4boIJENDqYt87tb-LUbg_1767955134
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38D1118005B9;
	Fri,  9 Jan 2026 10:38:52 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.39])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 270F219560BA;
	Fri,  9 Jan 2026 10:38:49 +0000 (UTC)
Date: Fri, 9 Jan 2026 10:38:46 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: marcandre.lureau@redhat.com, qemu-devel@nongnu.org,
	Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH] Add query-tdx-capabilities
Message-ID: <aWDatqLQYBV9fznm@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
 <aV41CQP0JODTdRqy@redhat.com>
 <87qzrzku9z.fsf@pond.sub.org>
 <aWDMU7WOlGIdNush@redhat.com>
 <87jyxrksug.fsf@pond.sub.org>
 <aWDTXvXxPRj2fs2b@redhat.com>
 <87cy3jkrj8.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87cy3jkrj8.fsf@pond.sub.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Jan 09, 2026 at 11:29:47AM +0100, Markus Armbruster wrote:
> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
> > On Fri, Jan 09, 2026 at 11:01:27AM +0100, Markus Armbruster wrote:
> >> Daniel P. Berrangé <berrange@redhat.com> writes:
> >> 
> >> > On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrote:
> >> >> Daniel P. Berrangé <berrange@redhat.com> writes:
> >> >> 
> >> >> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@redhat.com wrote:
> >> >> >> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> >> >> >> 
> >> >> >> Return an empty TdxCapability struct, for extensibility and matching
> >> >> >> query-sev-capabilities return type.
> >> >> >> 
> >> >> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
> >> >> >> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> >> 
> >> [...]
> >> 
> >> >> > This matches the conceptual design used with query-sev-capabilities,
> >> >> > where the lack of SEV support has to be inferred from the command
> >> >> > returning "GenericError".
> >> >> 
> >> >> Such guesswork is brittle.  An interface requiring it is flawed, and
> >> >> should be improved.
> >> >> 
> >> >> Our SEV interface doesn't actually require it: query-sev tells you
> >> >> whether we have SEV.  Just run that first.
> >> >
> >> > Actually these commands are intended for different use cases.
> >> >
> >> > "query-sev" only returns info if you have launched qemu with
> >> >
> >> >   $QEMU -object sev-guest,id=cgs0  -machine confidential-guest-support=cgs0
> >> >
> >> > The goal of "query-sev-capabilities" is to allow you to determine
> >> > if the combination of host+kvm+qemu are capable of running a guest
> >> > with "sev-guest".
> >> >
> >> > IOW, query-sev-capabilities alone is what you want/need in order
> >> > to probe host features.
> >> >
> >> > query-sev is for examining running guest configuration
> >> 
> >> The doc comments fail to explain this.  Needs fixing.
> >> 
> >> Do management applications need to know more than "this combination of
> >> host + KVM + QEMU can do SEV, yes / no?
> >> 
> >> If yes, what do they need?  "No" split up into serval "No, because X"?
> >
> > When libvirt runs  query-sev-capabilities it does not care about the
> > reason for it being unsupported.   Any "GenericError" is considered
> > to mark the lack of host support, and no fine grained checks are
> > performed on the err msg.
> >
> > If query-sev-capabilities succeeds (indicating SEV is supported), then
> > all the returned info is exposed to mgmt apps in the libvirt domain
> > capabilities XML document.
> 
> So query-sev-capabilities is good enough as is?

IIUC, essentially all QEMU errors that could possibly be seen with
query-sev-capabilities are "GenericError" these days, except for
the small possibility of "CommandNotFound".

The two scenarios with lack of SEV support are covered by GenericError
but I'm concerned that other things that should be considered fatal
will also fall under GenericError.

eg take a look at qmp_dispatch() and see countless places where we can
return GenericError which ought to be treated as fatal by callers. 

IMHO  "SEV not supported" is not conceptually an error, it is an
expected informational result of query-sev-capabilities, and thus
shouldn't be using the QMP error object, it should have been a
boolean result field.

> If yes, then the proposed query-tdx-capabilities should also be good
> enough, shouldn't it?

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


