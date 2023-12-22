Return-Path: <kvm+bounces-5142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69FC581CA90
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C4D01C2158B
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972E919465;
	Fri, 22 Dec 2023 13:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LXPeHUeO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C71A18B09
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 13:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703250854;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZjb2qW2npfjBnPlgRmIf+pcDEINjvPrppaJrUN95YI=;
	b=LXPeHUeOky7C3jmJcfddcB+mSdSimlEnuJjwvmWy9XVRlaal8rlkGcF4B7RvO//e+4/qEL
	HOLqE9p+fRBlfTSuh3Qg+EIzGslUKwab4pV9PH86nZnJJ8MSsGsIDr2qE8hionysQUR6/+
	Rf71do5egfMP0iJnmne/W+5bMvZSOM0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-4-ofHTMuODCd_ofaOB-S8A-1; Fri,
 22 Dec 2023 08:14:10 -0500
X-MC-Unique: 4-ofHTMuODCd_ofaOB-S8A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6749D29ABA19;
	Fri, 22 Dec 2023 13:14:09 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.76])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFDD5C159B0;
	Fri, 22 Dec 2023 13:14:06 +0000 (UTC)
Date: Fri, 22 Dec 2023 13:14:04 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 52/70] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <ZYWLnIfXac_K7EZM@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-53-xiaoyao.li@intel.com>
 <ZYQb_P6eHokUz9Hh@redhat.com>
 <5314df8a-4173-46cb-bc7e-984c6b543555@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5314df8a-4173-46cb-bc7e-984c6b543555@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Fri, Dec 22, 2023 at 11:14:12AM +0800, Xiaoyao Li wrote:
> On 12/21/2023 7:05 PM, Daniel P. Berrangé wrote:
> > On Wed, Nov 15, 2023 at 02:15:01AM -0500, Xiaoyao Li wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > For GetQuote, delegate a request to Quote Generation Service.
> > > Add property "quote-generation-socket" to tdx-guest, whihc is a property
> > > of type SocketAddress to specify Quote Generation Service(QGS).
> > > 
> > > On request, connect to the QGS, read request buffer from shared guest
> > > memory, send the request buffer to the server and store the response
> > > into shared guest memory and notify TD guest by interrupt.
> > > 
> > > command line example:
> > >    qemu-system-x86_64 \
> > >      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \
> > 
> > Here you're illustrating a VSOCK address.  IIUC, both the 'qgs'
> > daemon and QEMU will be running in the host. Why would they need
> > to be using VSOCK, as opposed to a regular UNIX socket connection ?
> > 
> 
> We use vsock here because the QGS server we used for testing exposes the
> vsock socket.

Is this is the server impl you test with:

  https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/QuoteGeneration/quote_wrapper/qgs

or is there another impl ?

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


