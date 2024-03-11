Return-Path: <kvm+bounces-11521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D1E877CB0
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:28:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A706A1C20E7A
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854BD1757D;
	Mon, 11 Mar 2024 09:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d9xaaDF8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2985717557
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710149278; cv=none; b=R30vV8nHz0yAySJfzohvXu3Kp/JZ0EOhGPqUKYga7ziJMRaAI71RSnpCdsakEKJKJuIdHWA9F9dkxj+/p5odVWktZKCOjTZoCc3EOzJ567y7GHsKvHSN2Rg6EjPDh/S+RIkfTyJFhmrcsn0UdOexq/sQzoBvEmCpOs0+3Zqw2jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710149278; c=relaxed/simple;
	bh=/NBxsFAshNC50vCQBN+kGPJvwvRe6Q6pGJbeQTQjQV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AqycF+y2CEtlvfNknlmvgRBwBnXDnimfoGwOknqI6C1+RLhgiWh8+rFPHqgMFlalH0izyg0KIZW8B6japwNnUN5OBcJ8BS5LQ7YcNAtIOtVQQSCBFN2pNnHcW8wpLKZ8tIexFy3jIeWJszaTwRCQAD0slE+JyFo/hSl03YVwybo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d9xaaDF8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710149276;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=c8PVOjUyGNvqP2OYE1xXBvUQoWkyxGri3R4aBFhiM/o=;
	b=d9xaaDF8mEuJ76AQXZudPy3QirruLAxRKpGs9kD0nG9Gk1MZwe5wIdubYl32zaG2j26FlZ
	ceIrwt5ZFA55BzdaDD+XIm5p16Wfw2qZXBsBwmeSe0OxIDBp00Uwe0ziEVut6/ujMN8UEX
	S7QjIIGGXaOr8aUsr+eJkGAmsH2uBLo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-Vx0xTL-FNvOkqL535xrD-w-1; Mon, 11 Mar 2024 05:27:52 -0400
X-MC-Unique: Vx0xTL-FNvOkqL535xrD-w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68FC4186E1C2;
	Mon, 11 Mar 2024 09:27:51 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.132])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7130F2024517;
	Mon, 11 Mar 2024 09:27:45 +0000 (UTC)
Date: Mon, 11 Mar 2024 09:27:43 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <Ze7Ojzty99AbShE3@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240229063726.610065-50-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Thu, Feb 29, 2024 at 01:37:10AM -0500, Xiaoyao Li wrote:
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

Can you illustrate this with 'unix' sockets, not 'vsock'.

It makes no conceptual sense to be using vsock for two
processes on the host to be using vsock to talk to
each other. vsock is only needed for the guest to talk
to the host.

>     -machine confidential-guest-support=tdx0
> 
> Note, above example uses vsock type socket because the QGS we used
> implements the vsock socket. It can be other types, like UNIX socket,
> which depends on the implementation of QGS.
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
> Changes in v5:
> - add more decription of quote-generation-socket property;
> 
> Changes in v4:
> - merge next patch "i386/tdx: setup a timer for the qio channel";
> 
> Changes in v3:
> - rename property "quote-generation-service" to "quote-generation-socket";
> - change the type of "quote-generation-socket" from str to
>   SocketAddress;
> - squash next patch into this one;
> ---
>  qapi/qom.json                         |   8 +-
>  target/i386/kvm/meson.build           |   2 +-
>  target/i386/kvm/tdx-quote-generator.c | 170 ++++++++++++++++++++
>  target/i386/kvm/tdx-quote-generator.h |  95 +++++++++++
>  target/i386/kvm/tdx.c                 | 216 ++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h                 |   6 +
>  6 files changed, 495 insertions(+), 2 deletions(-)
>  create mode 100644 target/i386/kvm/tdx-quote-generator.c
>  create mode 100644 target/i386/kvm/tdx-quote-generator.h


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


