Return-Path: <kvm+bounces-11747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC37E87AA74
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 16:32:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78245B23F96
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B2D47773;
	Wed, 13 Mar 2024 15:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G9Kve0Jy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB906FCC
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 15:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710343918; cv=none; b=eHnSkh0gvV2DugZeNpQhs70rHSUYMaokW87L29Vf6nzw+l9Qvhj+aANuVOlt53/VvQ9DNGdOq7NE72bwmQWeFks6sJRzTzKJxaGFcLFJ/BN7wFKYCqenN7EvQFSm5tpgxgqxGM4g3OFWvtwAFwVfpXkiZO1k3Lt1WEDm5MxCuVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710343918; c=relaxed/simple;
	bh=8k4XRxeEeUFzks0oqLF2nkQgczOhu68aYm2cAA6bQ4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rE9pQo4QLjsHCmnpGhZoUaf3V+Zt3i4VNPK4BIt9uL3daSp6CkSJK0k52uowimj5VgGQqZipSXMK2OWmRXZYLZBbkruD/BXlvjDS9vxDgiEWcKvbGLdpRE2naNVJCBVegsVVt2XyP56eHr4nIaxqvEM0LOE2dg6hGaaRWCDqKVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G9Kve0Jy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710343915;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=au0OWjWNaokB43YBD2j+M+et/AQDW8g5T4BuX7AN+yo=;
	b=G9Kve0JyfBKc9CeOt0W9HKeWWpQLSVHSJ2tGMGXJZLs59TrSv8iStXDtH1haJcIPgTRoaT
	JRvJk+uwdjW5M5Wf06nmdp1J1PinSOs/+zXpsZk4EzkE+nvmGZeqIHw6FwhNeWBPZMXcjY
	srnph8cPf9Na1WAcTP7fUzrI73E26hQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-Mjx8gAxQPiabJp0QGzZ0Rw-1; Wed, 13 Mar 2024 11:31:49 -0400
X-MC-Unique: Mjx8gAxQPiabJp0QGzZ0Rw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A9FA8FA22B;
	Wed, 13 Mar 2024 15:31:48 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.47])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63109492BD0;
	Wed, 13 Mar 2024 15:31:38 +0000 (UTC)
Date: Wed, 13 Mar 2024 15:31:36 +0000
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
Message-ID: <ZfHG2DHqf_cnq5tk@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com>
 <Ze7Ojzty99AbShE3@redhat.com>
 <0f5e1559-bd65-4f3b-bd7a-b166f53dce38@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f5e1559-bd65-4f3b-bd7a-b166f53dce38@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Tue, Mar 12, 2024 at 03:44:32PM +0800, Xiaoyao Li wrote:
> On 3/11/2024 5:27 PM, Daniel P. Berrangé wrote:
> > On Thu, Feb 29, 2024 at 01:37:10AM -0500, Xiaoyao Li wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > Add property "quote-generation-socket" to tdx-guest, which is a property
> > > of type SocketAddress to specify Quote Generation Service(QGS).
> > > 
> > > On request of GetQuote, it connects to the QGS socket, read request
> > > data from shared guest memory, send the request data to the QGS,
> > > and store the response into shared guest memory, at last notify
> > > TD guest by interrupt.
> > > 
> > > command line example:
> > >    qemu-system-x86_64 \
> > >      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
> > 
> > Can you illustrate this with 'unix' sockets, not 'vsock'.
> 
> Are you suggesting only updating the commit message to an example of unix
> socket? Or you want the code to test with some unix socket QGS?
> 
> (It seems the QGS I got for testing, only supports vsock socket. Because at
> the time when it got developed, it was supposed to communicate with drivers
> inside TD guest directly not via VMM (KVM+QEMU). Anyway, I will talk to
> internal folks to see if any plan to support unix socket.)

The QGS provided as part of DCAP supports running with both
UNIX sockets and VSOCK, and I would expect QEMU to be made
to work with this, since its is Intel's OSS reference impl.

Exposing QGS to the guest when we only intend for it to be
used by the host QEMU is needlessly expanding the attack
surface.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


