Return-Path: <kvm+bounces-9083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A50585A3EF
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DEED1C23277
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E42A2EB1D;
	Mon, 19 Feb 2024 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZSZYG7W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03B2E834
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347313; cv=none; b=qILczbLLDRZ3APipPVrSLt1MGTsxN2D2Rny5svZSLntPr70bl2dIYnHCcALkfpNI+WD2crWZWn68JGjV/stWk+G5pp+7MGXV3c0pD8+1CJuuqUXVqVANRYbdH+RyPshex/A95KZP4jVq1wSnXaQoBzIiqHKXH9Qjz3GRNxkPepQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347313; c=relaxed/simple;
	bh=MFsunUc4ee6tUOfWnJUdLXwFk6+Y0FG429ZRDPbfADI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dIfIJOHojKTdoQJtHM2G3zy8NocCJjb4oRE6GZk+4VJpiwU9NzH95FbD/BHiFvn8bp/o7i8PTnKIQ02EM7P1sv+nwmCLy8fUEgzt9DG6VKmYHCofMeqWNDCtPC2d3lnRC9tnk8yAjaxkZe6KZf6BnMBDHiwMgCrHAOQJPM2agp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JZSZYG7W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708347310;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=NwBOODxztdKsDqisIvyM9IhBF6k7LC35g6FHGcv17KM=;
	b=JZSZYG7WU/nM55VXctQHZ6PC3eKcLEKp+byQbOYLUsGpmo/jghQSYU/5KVyLS/Ak23tKfF
	IYWRYu/EK89GGsiOskrOpRiTSsqPfdkgb6IckH0llyRuFD1Exd/KvYcbzcqMPdiFucFkI+
	7DPwc71TZyCvEDYhzMZ/ph0EJHRtxgI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-GgTd6otXOJ-z2DtBEFjfsA-1; Mon, 19 Feb 2024 07:55:07 -0500
X-MC-Unique: GgTd6otXOJ-z2DtBEFjfsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E508587B2A4;
	Mon, 19 Feb 2024 12:55:06 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.30])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CD6E2166B34;
	Mon, 19 Feb 2024 12:55:03 +0000 (UTC)
Date: Mon, 19 Feb 2024 12:55:01 +0000
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
Subject: Re: [PATCH v4 50/66] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <ZdNPpcNiGcY4Jefi@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-51-xiaoyao.li@intel.com>
 <87zfvwehyz.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87zfvwehyz.fsf@pond.sub.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Mon, Feb 19, 2024 at 01:50:12PM +0100, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Add property "quote-generation-socket" to tdx-guest, which is a property
> > of type SocketAddress to specify Quote Generation Service(QGS).
> >
> > On request of GetQuote, it connects to the QGS socket, read request
> > data from shared guest memory, send the request data to the QGS,
> > and store the response into shared guest memory, at last notify
> > TD guest by interrupt.
> >
> > command line example:
> >   qemu-system-x86_64 \
> >     -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
> >     -machine confidential-guest-support=tdx0
> >
> > Note, above example uses vsock type socket because the QGS we used
> > implements the vsock socket. It can be other types, like UNIX socket,
> > which depends on the implementation of QGS.
> >
> > To avoid no response from QGS server, setup a timer for the transaction.
> > If timeout, make it an error and interrupt guest. Define the threshold of
> > time to 30s at present, maybe change to other value if not appropriate.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > ---
> > Changes in v4:
> > - merge next patch "i386/tdx: setup a timer for the qio channel";
> >
> > Changes in v3:
> > - rename property "quote-generation-service" to "quote-generation-socket";
> > - change the type of "quote-generation-socket" from str to
> >   SocketAddress;
> > - squash next patch into this one;
> > ---
> >  qapi/qom.json                         |   6 +-
> >  target/i386/kvm/meson.build           |   2 +-
> >  target/i386/kvm/tdx-quote-generator.c | 170 ++++++++++++++++++++
> >  target/i386/kvm/tdx-quote-generator.h |  95 +++++++++++
> >  target/i386/kvm/tdx.c                 | 216 ++++++++++++++++++++++++++
> >  target/i386/kvm/tdx.h                 |   6 +
> >  6 files changed, 493 insertions(+), 2 deletions(-)
> >  create mode 100644 target/i386/kvm/tdx-quote-generator.c
> >  create mode 100644 target/i386/kvm/tdx-quote-generator.h
> >
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index 15445f9e41fc..c60fb5710961 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -914,13 +914,17 @@
> >  #     e.g., specific to the workload rather than the run-time or OS.
> >  #     base64 encoded SHA384 digest.
> >  #
> > +# @quote-generation-socket: socket address for Quote Generation
> > +#     Service(QGS)
> 
> Space between "Service" and "(QGS)", please.
> 
> The description feels too terse.  What is the "Quote Generation
> Service", and why should I care?

The "Quote Generation Service" is a daemon running on the host.
The reference implementation is at

  https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/QuoteGeneration/quote_wrapper/qgs

If you don't provide this, then quests won't bet able to generate
quotes needed for attestation. So although this is technically
optional, in practice for a sane deployment, an admin should always
provide this

> 
> > +#
> >  # Since: 9.0
> >  ##
> >  { 'struct': 'TdxGuestProperties',
> >    'data': { '*sept-ve-disable': 'bool',
> >              '*mrconfigid': 'str',
> >              '*mrowner': 'str',
> > -            '*mrownerconfig': 'str' } }
> > +            '*mrownerconfig': 'str',
> > +            '*quote-generation-socket': 'SocketAddress' } }
> >  
> >  ##
> >  # @ThreadContextProperties:
> 
> [...]
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


