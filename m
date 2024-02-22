Return-Path: <kvm+bounces-9424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE5685FE17
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70A4A1C213B7
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9AE14901A;
	Thu, 22 Feb 2024 16:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RBba+5+C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B434C1E522
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708619438; cv=none; b=MEOsTV3HSHX9nJKYw1nsebmcBmFTIJxVcvV9+YzXOBRcZ9bjdIlYXjN+GSSfDbJKmghBQGo/oX17XsDfgO3isMjAp0cXSHSp5pNYxY60JMemjO1j9n/fEjQrV9YCZYH7hmqhzQO7ffmGUsQubvsWNbAmCywwEbU9D7r/G6C3gLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708619438; c=relaxed/simple;
	bh=VTomngQKjpjtcByhLkt+bsZDNHeQ1SAaaTCzhSD/7LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDzChJMk40lIawKkaqSPFlGjgd9z0qT5z9lxlOCZ/dlQbQhhkkvm2aSPHcB1x8ePIo14rtPVYDbx5a8mibr2dWSLhZA0b7tUljypBuB36kuk3RV2cK5aRk4uiJ3JDY7vlvdXIupB4xxUJPkQC+F0QIDoljTB0lzOBSVqQjlU0+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RBba+5+C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708619435;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=z8rC1LqoNkicePhZz9xzu4X/hqhqdSwcsu80yXABdyY=;
	b=RBba+5+CCcvTCinmJQTIqjw1rmpjM0tAhuFe3GD1YylUShQkr+h6+YPyiB0rcqkKEr+0yD
	mLLaTU3VcpEtFZ65FqN55iwYcWuDFad7GuovRsl9S7By806VXIZVGeabsCzZRf2BSffhF6
	08O947C55Y6V6b+rSVWglGK9FMCu+4M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-A7dlertyPhSyMddUQbzr3Q-1; Thu, 22 Feb 2024 11:30:32 -0500
X-MC-Unique: A7dlertyPhSyMddUQbzr3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A0F0811E81;
	Thu, 22 Feb 2024 16:30:31 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.48])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 454D01121337;
	Thu, 22 Feb 2024 16:30:27 +0000 (UTC)
Date: Thu, 22 Feb 2024 16:30:25 +0000
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
Subject: Re: [PATCH v4 50/66] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <Zdd2oSFOiIparDIe@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-51-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240125032328.2522472-51-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Wed, Jan 24, 2024 at 10:23:12PM -0500, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add property "quote-generation-socket" to tdx-guest, which is a property
> of type SocketAddress to specify Quote Generation Service(QGS).
> 
> On request of GetQuote, it connects to the QGS socket, read request
> data from shared guest memory, send the request data to the QGS,
> and store the response into shared guest memory, at last notify
> TD guest by interrupt.
> 
> command line example:
>   qemu-system-x86_64 \
>     -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>     -machine confidential-guest-support=tdx0
> 
> Note, above example uses vsock type socket because the QGS we used
> implements the vsock socket. It can be other types, like UNIX socket,
> which depends on the implementation of QGS.

Can you confirm again exactly what QGS impl you are testing against ?

I've tried the impl at

   https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/QuoteGeneration/quote_wrapper/qgs

which supports UNIX sockets and VSOCK. In both cases, however, it
appears to be speaking a different protocol than your QEMU impl
below uses.

Specifically here:

  https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/master/QuoteGeneration/quote_wrapper/qgs/qgs_server.cpp#L143

it is reading 4 bytes of header, which are interpreted as the length
of the payload which will then be read off the wire. IIUC the payload
it expects is the TDREPORT struct.

Your QEMU patches here meanwhile are just sending the payload from
the GetQuote hypercall which is the TDREPORT struct.

IOW, QEMU is not sending the 4 byte length header the QGS expects.
and whole thing fails.

> 
> To avoid no response from QGS server, setup a timer for the transaction.
> If timeout, make it an error and interrupt guest. Define the threshold of
> time to 30s at present, maybe change to other value if not appropriate.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


