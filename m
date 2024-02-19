Return-Path: <kvm+bounces-9080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8EDA85A3AF
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FF44281325
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18292E834;
	Mon, 19 Feb 2024 12:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IeuheNn9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474AF2D61A
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 12:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708346694; cv=none; b=V4kiEpEeqFmXATvylCwYxPfHCa9cWldaYavqDvmcKlUDpzIDM1EDIjagRNZK/6jshHm52iS1PHtaRkUcyzn3pwfFD8p25G/o0ljSQtOCQvfNyi9FYFtxMqusXH9U1YqmFsJbQmc3Suu6TL/YbiZ5X7bvwP0noTZXkAoBCGpOvBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708346694; c=relaxed/simple;
	bh=lIYtQP8YNnX+4N+TPQzfF8SRrpleCN7fphdQW7xgr0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YOWz9OugRg9Q4QT/KuQMcLwsg76sjHknHlI+K12kul8RygC97yxFVBodNx3cW/fX39AuQY24xIHLZLdfGARK+hM7ZgiaM9j1gdYrzAAxOApLPlJ3TEg0GHlj8fO50eK/SKQlZahO8KPq91bl3HBP9H748Eql1SZG5HwYYOPR+gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IeuheNn9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708346692;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=0aiChE9HTktmkdhdBbAto/Bv9YR1FTzeDtGFSngVeiA=;
	b=IeuheNn9PGaoF+JZxiIrAqrtR6lkpTGEuG6UjjFTpkp6rQLmSiFXUn3NHR7P3XLpBiuy6N
	A3R9X1++iJiGfjBP8c7fdssHCi7dZe7AXAQBgrwSoQ8oC6csyJFUFxPnqMUprw31V2A99q
	fOX1zLThv6/0KYpJjfGC4RlLUF24RkQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-182-YSqAubBYMJWs0LDeLz40wA-1; Mon,
 19 Feb 2024 07:44:48 -0500
X-MC-Unique: YSqAubBYMJWs0LDeLz40wA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8CAD3C025BE;
	Mon, 19 Feb 2024 12:44:47 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.30])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 515BE492BC6;
	Mon, 19 Feb 2024 12:44:44 +0000 (UTC)
Date: Mon, 19 Feb 2024 12:44:42 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v4 11/66] i386: Introduce tdx-guest object
Message-ID: <ZdNNOizuUx5uWULB@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-12-xiaoyao.li@intel.com>
 <87a5nwfx9e.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a5nwfx9e.fsf@pond.sub.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Mon, Feb 19, 2024 at 01:34:37PM +0100, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
> > Introduce tdx-guest object which implements the interface of
> > CONFIDENTIAL_GUEST_SUPPORT, and will be used to create TDX VMs (TDs) by
> >
> >   qemu -machine ...,confidential-guest-support=tdx0	\
> >        -object tdx-guest,id=tdx0
> >
> > It has only one member 'attributes' with fixed value 0 and not
> > configurable so far.
> 
> Really?  Can't see it.

The 'attributes' referred to is an internal struct field,
rather than a QAPI declared member.

> 
> Suggest to add something like "Configuration properties will be added
> later in this series."
> 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> > Acked-by: Markus Armbruster <armbru@redhat.com>
> 
> [...]
> 
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index 95516ba325e5..5b3c3146947f 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -895,6 +895,16 @@
> >              'reduced-phys-bits': 'uint32',
> >              '*kernel-hashes': 'bool' } }
> >  
> > +##
> > +# @TdxGuestProperties:
> > +#
> > +# Properties for tdx-guest objects.
> > +#
> > +# Since: 9.0
> > +##
> > +{ 'struct': 'TdxGuestProperties',
> > +  'data': { }}
> > +
> >  ##
> >  # @ThreadContextProperties:
> >  #
> > @@ -974,6 +984,7 @@
> >      'sev-guest',
> >      'thread-context',
> >      's390-pv-guest',
> > +    'tdx-guest',
> >      'throttle-group',
> >      'tls-creds-anon',
> >      'tls-creds-psk',
> > @@ -1041,6 +1052,7 @@
> >        'secret_keyring':             { 'type': 'SecretKeyringProperties',
> >                                        'if': 'CONFIG_SECRET_KEYRING' },
> >        'sev-guest':                  'SevGuestProperties',
> > +      'tdx-guest':                  'TdxGuestProperties',
> >        'thread-context':             'ThreadContextProperties',
> >        'throttle-group':             'ThrottleGroupProperties',
> >        'tls-creds-anon':             'TlsCredsAnonProperties',
> 
> [...]
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


