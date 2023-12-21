Return-Path: <kvm+bounces-5062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E9A081B4A5
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 12:06:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD87CB223BA
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B136AB8F;
	Thu, 21 Dec 2023 11:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FoJnAE/G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFFF6AB9A
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 11:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703156761;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=GhxMPf0YIpNsSN1O9mE12xQ5EPfuMhnQRlayrW4uFLI=;
	b=FoJnAE/GowQYm+75LFlaN1OqiwqBX53XswasEh7Kj78RVHpp9H2aj0YuV3N9k07Ik3Sr4l
	35DPBqKRTD7oieRX078MkiRBYj177g1XC3nlRXlTc/nacQSXLx4Qn1zUEjOpgbmdKDHS0i
	iK9Q1kErza+YkJFZc8rDi40qkPB2K54=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-GJb7GJu5MUa3ma8jRmwO_A-1; Thu,
 21 Dec 2023 06:05:57 -0500
X-MC-Unique: GJb7GJu5MUa3ma8jRmwO_A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E61B23C025C2;
	Thu, 21 Dec 2023 11:05:56 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.106])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40FC5492BE6;
	Thu, 21 Dec 2023 11:05:54 +0000 (UTC)
Date: Thu, 21 Dec 2023 11:05:52 +0000
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
Message-ID: <ZYQb_P6eHokUz9Hh@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-53-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115071519.2864957-53-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Wed, Nov 15, 2023 at 02:15:01AM -0500, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> For GetQuote, delegate a request to Quote Generation Service.
> Add property "quote-generation-socket" to tdx-guest, whihc is a property
> of type SocketAddress to specify Quote Generation Service(QGS).
> 
> On request, connect to the QGS, read request buffer from shared guest
> memory, send the request buffer to the server and store the response
> into shared guest memory and notify TD guest by interrupt.
> 
> command line example:
>   qemu-system-x86_64 \
>     -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \

Here you're illustrating a VSOCK address.  IIUC, both the 'qgs'
daemon and QEMU will be running in the host. Why would they need
to be using VSOCK, as opposed to a regular UNIX socket connection ?

>     -machine confidential-guest-support=tdx0
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v3:
> - rename property "quote-generation-service" to "quote-generation-socket";
> - change the type of "quote-generation-socket" from str to
>   SocketAddress;

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


