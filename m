Return-Path: <kvm+bounces-67547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 454D0D08464
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 10:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 193B930A158A
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 09:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD62358D38;
	Fri,  9 Jan 2026 09:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wd/VQoZS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4803B3590AB
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 09:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767951455; cv=none; b=RfiLLsZ1KyEkT4ovdqe7+z+lzKEYVkNZ8w1+wLIpj2CHel/OEwoztwatKj4T+HmVR8ADD3XiCRxrdVC1mpZJs/AUH2NAj6doI5tOZvEg2X5sbo2TA1jck2HX8djh+YuTvAWyaMPgGNUF5kdJEZFExNdIV3Dy7VTO5FVnnkHijY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767951455; c=relaxed/simple;
	bh=phRpDK916iYCWPHmlNzSbVfQ8YOMIQDXNMupQWvkM84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nN4eGsh+ht7+eRgoNDT2idJqb2A+PwNr+7akcW4NjI7q0u2oiwyN39OdRxQwjOme1b5xPPoc1eVdiFlnxHrZOCVsXZzrB5Z41gfnOY7AoCceTx99J/JMUCA6gI7Gvewlok+L1bmx8RuSqKCHbSOZASOXCwM53QdpcNS5X57LwI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wd/VQoZS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767951453;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mKYX7ug5gEpnJE1QF8VFcR2VN9+MofZKrGjRh7vTSVs=;
	b=Wd/VQoZSmT7J2a3XQLdfiOkfDn0vub2KZ0gwzVdvCelaIYfU763RzI5+bKDpKLTpoWs3lV
	5YEWp8ojjBETIbmSsyjAQrx6h2838kmGWoTRe247bY06ONyJ6fCR3pHVYtRE2hMmTLvZFn
	nFrYqOAh01nPl28ehBBJJIpKaeFqQG8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-dnXCdXsgN-6FHM1N-HK8kg-1; Fri,
 09 Jan 2026 04:37:29 -0500
X-MC-Unique: dnXCdXsgN-6FHM1N-HK8kg-1
X-Mimecast-MFC-AGG-ID: dnXCdXsgN-6FHM1N-HK8kg_1767951449
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A5FB180034F;
	Fri,  9 Jan 2026 09:37:29 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.39])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5D8A30002D1;
	Fri,  9 Jan 2026 09:37:26 +0000 (UTC)
Date: Fri, 9 Jan 2026 09:37:23 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: marcandre.lureau@redhat.com, qemu-devel@nongnu.org,
	Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH] Add query-tdx-capabilities
Message-ID: <aWDMU7WOlGIdNush@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
 <aV41CQP0JODTdRqy@redhat.com>
 <87qzrzku9z.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87qzrzku9z.fsf@pond.sub.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrote:
> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@redhat.com wrote:
> >> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> >> 
> >> Return an empty TdxCapability struct, for extensibility and matching
> >> query-sev-capabilities return type.
> >> 
> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
> >> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> >> ---
> >>  qapi/misc-i386.json        | 30 ++++++++++++++++++++++++++++++
> >>  target/i386/kvm/kvm_i386.h |  1 +
> >>  target/i386/kvm/kvm.c      |  5 +++++
> >>  target/i386/kvm/tdx-stub.c |  8 ++++++++
> >>  target/i386/kvm/tdx.c      | 21 +++++++++++++++++++++
> >>  5 files changed, 65 insertions(+)
> >> 
> >> diff --git a/qapi/misc-i386.json b/qapi/misc-i386.json
> >> index 05a94d6c416..f10e4338b48 100644
> >> --- a/qapi/misc-i386.json
> >> +++ b/qapi/misc-i386.json
> >> @@ -225,6 +225,36 @@
> >>  ##
> >>  { 'command': 'query-sev-capabilities', 'returns': 'SevCapability' }
> >>  
> >> +##
> >> +# @TdxCapability:
> >> +#
> >> +# The struct describes capability for Intel Trust Domain Extensions
> >> +# (TDX) feature.
> >> +#
> >> +# Since: 11.0
> >> +##
> >> +{ 'struct': 'TdxCapability',
> >> +  'data': { } }
> >> +
> >> +##
> >> +# @query-tdx-capabilities:
> >> +#
> >> +# Get TDX capabilities.
> >> +#
> >> +# This is only supported on Intel X86 platforms with KVM enabled.
> >> +#
> >> +# Errors:
> >> +#     - If TDX is not available on the platform, GenericError
> >> +#
> >> +# Since: 11.0
> >> +#
> >> +# .. qmp-example::
> >> +#
> >> +#     -> { "execute": "query-tdx-capabilities" }
> >> +#     <- { "return": {} }
> >> +##
> >> +{ 'command': 'query-tdx-capabilities', 'returns': 'TdxCapability' }
> >
> > This matches the conceptual design used with query-sev-capabilities,
> > where the lack of SEV support has to be inferred from the command
> > returning "GenericError".
> 
> Such guesswork is brittle.  An interface requiring it is flawed, and
> should be improved.
> 
> Our SEV interface doesn't actually require it: query-sev tells you
> whether we have SEV.  Just run that first.

Actually these commands are intended for different use cases.

"query-sev" only returns info if you have launched qemu with

  $QEMU -object sev-guest,id=cgs0  -machine confidential-guest-support=cgs0

The goal of "query-sev-capabilities" is to allow you to determine
if the combination of host+kvm+qemu are capable of running a guest
with "sev-guest".

IOW, query-sev-capabilities alone is what you want/need in order
to probe host features.

query-sev is for examining running guest configuration

> This patch adds query-tdx-capabilities without query-tdx.  This results
> in a flawed interface.
> 
> Should we add a query-tdx instead?

No, per the above explanation of the differences.

> 
> >                           On the one hand this allows the caller to
> > distinguish different scenarios - unsupported due to lack of HW
> > support, vs unsupported due to lack of KVM support. On the other
> > hand 'GenericError' might reflect other things that should be
> > considered fatal errors, rather than indicitive of lack of support
> > in the host.
> >
> > With the other 'query-sev' command, we have "enabled: bool" field,
> > and when enabled == false, the other fields are documented to have
> > undefined values.
> 
> Clunky, but works.
> 
> The doc comment calls them "unspecified", which is more precise.
> 
> > I tend towards suggesting that 'query-sev-capabilities' (and thus
> > also this new query-tdx-capabilities) should have been more like
> > query-sev,  and had a a "supported: bool" field to denote the lack
> > of support in the host.
> 
> Maybe.  What we have there is workable, though.
> 
> > This would not have allowed callers to disinguish the reason why
> > SEV/TDX is not supported (hardware vs KVM), but I'm not sure that
> > reason matters for callers - lack of KVM support is more of an
> > OS integration problem.
> 
> Let's not complicate interfaces without an actual use case :)
> 
> [...]
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


