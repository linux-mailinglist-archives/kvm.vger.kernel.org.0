Return-Path: <kvm+bounces-37466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0407A2A4DD
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCBBF188799D
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1267376;
	Thu,  6 Feb 2025 09:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cFt1AhDX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3A0225793
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 09:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738834999; cv=none; b=c3BX/0K7+sNF7F8w5RqOuMGBZw5I//uBNP6WA6/gItT36yAVEabUhPsuSFTNUcpILQSBX3uNfB/rhjwPZlVRREQmMuJsU76LjJTpUpt07mgqUqYsz1EGA1E+mXCQPAffig3Yp2tM4QW3enQqxNfeIGmhhHBe6gcCCm4EBbeXfYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738834999; c=relaxed/simple;
	bh=XBYVSQ+rvdYjfngSC1qo+YGDIODm7MuDP6bj4wlq/go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGyepsSlrbaXp+Ml53/Q90Hig0pq8dF8rA8aRMYlwciLZDlH3xyNFoThmW9AmcFNACGKUOtEQFbtt6D2G++ByNccl4Zr56+aWrfhI3lpKGFuC2ufsNNSFoE8pz+G7axPV2a78UrNuesOFvL11n5E3pownSilWmYN0JXfjUBj+wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cFt1AhDX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738834994;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=n0D41HcxzuIuMF3Ilv9lg4Eg79loAfwsZ77xrh64FxA=;
	b=cFt1AhDXXBCSfF8H5tPig0t7Xg6b7oDt3lB0mkQf/QRcXVPy+j9ijXuL8HZIpxZpOSq75O
	Kb5awmVRMexn/W36pLsUta9Vup9nsMh6HtxA8hcdV6wshjPIJF0DGz0e2oh8dCZAmP2vT8
	qSf6IgpZmlLB0YxxzSQEyElPiA+QKXk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-0FhaY-lBNee7YywCtJKvEg-1; Thu,
 06 Feb 2025 04:43:11 -0500
X-MC-Unique: 0FhaY-lBNee7YywCtJKvEg-1
X-Mimecast-MFC-AGG-ID: 0FhaY-lBNee7YywCtJKvEg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FE0B1800871;
	Thu,  6 Feb 2025 09:43:09 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.33])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F2BE19560A3;
	Thu,  6 Feb 2025 09:43:02 +0000 (UTC)
Date: Thu, 6 Feb 2025 09:42:58 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Markus Armbruster <armbru@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
Message-ID: <Z6SEIqhJEWrMWTU1@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <20250122090517.294083-4-zhao1.liu@intel.com>
 <87zfj01z8x.fsf@pond.sub.org>
 <Z6SG2NLxxhz4adlV@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z6SG2NLxxhz4adlV@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Feb 06, 2025 at 05:54:32PM +0800, Zhao Liu wrote:
> On Wed, Feb 05, 2025 at 11:07:10AM +0100, Markus Armbruster wrote:
> > Date: Wed, 05 Feb 2025 11:07:10 +0100
> > From: Markus Armbruster <armbru@redhat.com>
> > Subject: Re: [RFC v2 3/5] i386/kvm: Support event with select & umask
> >  format in KVM PMU filter
> > 
> > Zhao Liu <zhao1.liu@intel.com> writes:
> > 
> > > The select&umask is the common way for x86 to identify the PMU event,
> > > so support this way as the "x86-default" format in kvm-pmu-filter
> > > object.
> > 
> > So, format 'raw' lets you specify the PMU event code as a number, wheras
> > 'x86-default' lets you specify it as select and umask, correct?
> 
> Yes!
> 
> > Why do we want both?
> 
> This 2 formats are both wildly used in x86(for example, in perf tool).
> 
> x86 documents usually specify the umask and select fields.
> 
> But raw format could also be applied for ARM since ARM just uses a number
> to encode event.
> 
> > > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > 
> > [...]
> > 
> > > diff --git a/qapi/kvm.json b/qapi/kvm.json
> > > index d51aeeba7cd8..93b869e3f90c 100644
> > > --- a/qapi/kvm.json
> > > +++ b/qapi/kvm.json
> > > @@ -27,11 +27,13 @@
> > >  #
> > >  # @raw: the encoded event code that KVM can directly consume.
> > >  #
> > > +# @x86-default: standard x86 encoding format with select and umask.
> > 
> > Why is this named -default?
> 
> Intel and AMD both use umask+select to encode events, but this format
> doesn't have a name... so I call it `default`, or what about
> "x86-umask-select"?
> 
> > > +#
> > >  # Since 10.0
> > >  ##
> > >  { 'enum': 'KVMPMUEventEncodeFmt',
> > >    'prefix': 'KVM_PMU_EVENT_FMT',
> > > -  'data': ['raw'] }
> > > +  'data': ['raw', 'x86-default'] }
> > >  
> > >  ##
> > >  # @KVMPMURawEvent:
> > > @@ -46,6 +48,25 @@
> > >  { 'struct': 'KVMPMURawEvent',
> > >    'data': { 'code': 'uint64' } }
> > >  
> > > +##
> > > +# @KVMPMUX86DefalutEvent:
> > 
> > Default, I suppose.
> 
> Thanks!
> 
> > > +#
> > > +# x86 PMU event encoding with select and umask.
> > > +# raw_event = ((select & 0xf00UL) << 24) | \
> > > +#              (select) & 0xff) | \
> > > +#              ((umask) & 0xff) << 8)
> > 
> > Sphinx rejects this with "Unexpected indentation."
> > 
> > Is the formula needed here?
> 
> I tried to explain the relationship between raw format and umask+select.
> 
> Emm, where do you think is the right place to put the document like
> this?
> 
> ...
> 
> > > +##
> > > +# @KVMPMUX86DefalutEventVariant:

Typo   s/Defalut/Default/ - repeated many times in this patch.

> > > +#
> > > +# The variant of KVMPMUX86DefalutEvent with the string, rather than
> > > +# the numeric value.
> > > +#
> > > +# @select: x86 PMU event select field.  This field is a 12-bit
> > > +#     unsigned number string.
> > > +#
> > > +# @umask: x86 PMU event umask field. This field is a uint8 string.
> > 
> > Why are these strings?  How are they parsed into numbers?
> 
> In practice, the values associated with PMU events (code for arm, select&
> umask for x86) are often expressed in hexadecimal. Further, from linux
> perf related information (tools/perf/pmu-events/arch/*/*/*.json), x86/
> arm64/riscv/nds32/powerpc all prefer the hexadecimal numbers and only
> s390 uses decimal value.
> 
> Therefore, it is necessary to support hexadecimal in order to honor PMU
> conventions.

IMHO having a data format that matches an arbitrary external tool is not
a goal for QMP. It should be neutral and exclusively use the normal JSON
encoding, ie base-10 decimal. Yes, this means a user/client may have to
convert from hex to dec before sending data over QMP. This is true of
many areas of QMP/QEMU config though and thus normal/expected behaviour.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


