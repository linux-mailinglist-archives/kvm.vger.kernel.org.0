Return-Path: <kvm+bounces-42400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5855EA78292
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 21:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 877B0188B870
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642DE2101AE;
	Tue,  1 Apr 2025 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T4W9/7Im"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322E51DA62E
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 19:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743534336; cv=none; b=nkQEVPhnVdWL47G+3gvd2DDOOa5F8d+rjKnhA72fJRJZWwQMDvvMJ7OQR2GOEFhwlMjh9l4JeTo/YjUhUnHBj9iF0mgDIqux1g9ODZKmj29UbQDeQxqIb42DGGCT/Fq6cWMDYVVsk7jlQLekxBO1NMzCIp0G5Jyf/+ZcjXq//YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743534336; c=relaxed/simple;
	bh=6QxxwWjZmGXIgrvNHOurXFoqpCArFTr6tFFAISwoTM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5W9GCu9Odh517bNvS60cBDt31v4e2mAWQZS5AN0LM4zfjh9umg6IY5aIjNbffWPkS32Ixq8aScUz33i2pDQpcRbHXoN16q4cyO1fOew0yFAkIgCfzHnJb+dLl+T8HExolnoPQg49BgdUo+AxVvrk2zHAzn6ofcPjC/uti/LnNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T4W9/7Im; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743534333;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=BwM5j+WnOf6r0xXn94ePbvLEZ5RCtpNMiobqF7N96Xw=;
	b=T4W9/7ImzlfdDEoTa09dmLlNNIO3QY8XvtjOMy8+myWp+qBEg1CzlavhPVwwASYLSrZIQ4
	QfpFlIg2MX+vITL+rJauQO9TnYyHS6zYbKFBHKDC21rFPgSeYV/ttNAuBcCcRidMwjkShe
	U91x9yLRaXSWOFOpEFFz8PyltGmzpcI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-m84dYd0cPxKoFU_gq7DY4A-1; Tue,
 01 Apr 2025 15:05:29 -0400
X-MC-Unique: m84dYd0cPxKoFU_gq7DY4A-1
X-Mimecast-MFC-AGG-ID: m84dYd0cPxKoFU_gq7DY4A_1743534327
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0A7F195422C;
	Tue,  1 Apr 2025 19:05:26 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.51])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED03B1956094;
	Tue,  1 Apr 2025 19:05:19 +0000 (UTC)
Date: Tue, 1 Apr 2025 20:05:16 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Bobby Eshleman <bobbyeshleman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Message-ID: <Z-w47H3qUXZe4seQ@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Mar 28, 2025 at 06:03:19PM +0100, Stefano Garzarella wrote:
> CCing Daniel
> 
> On Wed, Mar 12, 2025 at 01:59:34PM -0700, Bobby Eshleman wrote:
> > Picking up Stefano's v1 [1], this series adds netns support to
> > vhost-vsock. Unlike v1, this series does not address guest-to-host (g2h)
> > namespaces, defering that for future implementation and discussion.
> > 
> > Any vsock created with /dev/vhost-vsock is a global vsock, accessible
> > from any namespace. Any vsock created with /dev/vhost-vsock-netns is a
> > "scoped" vsock, accessible only to sockets in its namespace. If a global
> > vsock or scoped vsock share the same CID, the scoped vsock takes
> > precedence.
> > 
> > If a socket in a namespace connects with a global vsock, the CID becomes
> > unavailable to any VMM in that namespace when creating new vsocks. If
> > disconnected, the CID becomes available again.
> 
> I was talking about this feature with Daniel and he pointed out something
> interesting (Daniel please feel free to correct me):
> 
>     If we have a process in the host that does a listen(AF_VSOCK) in a
> namespace, can this receive connections from guests connected to
> /dev/vhost-vsock in any namespace?
> 
>     Should we provide something (e.g. sysctl/sysfs entry) to disable
> this behaviour, preventing a process in a namespace from receiving
> connections from the global vsock address space (i.e.      /dev/vhost-vsock
> VMs)?

I think my concern goes a bit beyond that, to the general conceptual
idea of sharing the CID space between the global vsocks and namespace
vsocks. So I'm not sure a sysctl would be sufficient...details later
below..

> I understand that by default maybe we should allow this behaviour in order
> to not break current applications, but in some cases the user may want to
> isolate sockets in a namespace also from being accessed by VMs running in
> the global vsock address space.
> 
> Indeed in this series we have talked mostly about the host -> guest path (as
> the direction of the connection), but little about the guest -> host path,
> maybe we should explain it better in the cover/commit
> descriptions/documentation.

> > Testing
> > 
> > QEMU with /dev/vhost-vsock-netns support:
> > 	https://github.com/beshleman/qemu/tree/vsock-netns
> > 
> > Test: Scoped vsocks isolated by namespace
> > 
> >  host# ip netns add ns1
> >  host# ip netns add ns2
> >  host# ip netns exec ns1 \
> > 				  qemu-system-x86_64 \
> > 					  -m 8G -smp 4 -cpu host -enable-kvm \
> > 					  -serial mon:stdio \
> > 					  -drive if=virtio,file=${IMAGE1} \
> > 					  -device vhost-vsock-pci,netns=on,guest-cid=15
> >  host# ip netns exec ns2 \
> > 				  qemu-system-x86_64 \
> > 					  -m 8G -smp 4 -cpu host -enable-kvm \
> > 					  -serial mon:stdio \
> > 					  -drive if=virtio,file=${IMAGE2} \
> > 					  -device vhost-vsock-pci,netns=on,guest-cid=15
> > 
> >  host# socat - VSOCK-CONNECT:15:1234
> >  2025/03/10 17:09:40 socat[255741] E connect(5, AF=40 cid:15 port:1234, 16): No such device
> > 
> >  host# echo foobar1 | sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
> >  host# echo foobar2 | sudo ip netns exec ns2 socat - VSOCK-CONNECT:15:1234
> > 
> >  vm1# socat - VSOCK-LISTEN:1234
> >  foobar1
> >  vm2# socat - VSOCK-LISTEN:1234
> >  foobar2
> > 
> > Test: Global vsocks accessible to any namespace
> > 
> >  host# qemu-system-x86_64 \
> > 	  -m 8G -smp 4 -cpu host -enable-kvm \
> > 	  -serial mon:stdio \
> > 	  -drive if=virtio,file=${IMAGE2} \
> > 	  -device vhost-vsock-pci,guest-cid=15,netns=off
> > 
> >  host# echo foobar | sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
> > 
> >  vm# socat - VSOCK-LISTEN:1234
> >  foobar
> > 
> > Test: Connecting to global vsock makes CID unavailble to namespace
> > 
> >  host# qemu-system-x86_64 \
> > 	  -m 8G -smp 4 -cpu host -enable-kvm \
> > 	  -serial mon:stdio \
> > 	  -drive if=virtio,file=${IMAGE2} \
> > 	  -device vhost-vsock-pci,guest-cid=15,netns=off
> > 
> >  vm# socat - VSOCK-LISTEN:1234
> > 
> >  host# sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
> >  host# ip netns exec ns1 \
> > 				  qemu-system-x86_64 \
> > 					  -m 8G -smp 4 -cpu host -enable-kvm \
> > 					  -serial mon:stdio \
> > 					  -drive if=virtio,file=${IMAGE1} \
> > 					  -device vhost-vsock-pci,netns=on,guest-cid=15
> > 
> >  qemu-system-x86_64: -device vhost-vsock-pci,netns=on,guest-cid=15: vhost-vsock: unable to set guest cid: Address already in use

I find it conceptually quite unsettling that the VSOCK CID address
space for AF_VSOCK is shared between the host and the namespace.
That feels contrary to how namespaces are more commonly used for
deterministically isolating resources between the namespace and the
host.

Naively I would expect that in a namespace, all VSOCK CIDs are
free for use, without having to concern yourself with what CIDs
are in use in the host now, or in future.

What happens if we reverse the QEMU order above, to get the
following scenario

   # Launch VM1 inside the NS
   host# ip netns exec ns1 \
  				  qemu-system-x86_64 \
  					  -m 8G -smp 4 -cpu host -enable-kvm \
  					  -serial mon:stdio \
  					  -drive if=virtio,file=${IMAGE1} \
  					  -device vhost-vsock-pci,netns=on,guest-cid=15
   # Launch VM2
   host# qemu-system-x86_64 \
  	  -m 8G -smp 4 -cpu host -enable-kvm \
  	  -serial mon:stdio \
  	  -drive if=virtio,file=${IMAGE2} \
  	  -device vhost-vsock-pci,guest-cid=15,netns=off
  
   vm1# socat - VSOCK-LISTEN:1234
   vm2# socat - VSOCK-LISTEN:1234

   host# socat - VSOCK-CONNECT:15:1234
     => Presume this connects to "VM2" running outside the NS

   host# sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234

     => Does this connect to "VM1" inside the NS, or "VM2"
        outside the NS ?



With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


