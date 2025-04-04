Return-Path: <kvm+bounces-42648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BCCA7BD2C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 15:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7DCB179B33
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 13:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625EC1EB5F1;
	Fri,  4 Apr 2025 13:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UQxXagFN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADAF131E49
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 13:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743771952; cv=none; b=dP+j2MrCwRyGyx51SlXs6Agq95rK29bcuO12m36EQ7tIQ1mWjZmNmwIK4K5wVr9C5acH+O3dVyb61CBGtMEPdIenBG9uFNTIPlWWu0XIlIWkJilSKvMxi8eyg6cKUS3Lulw5fnu+b850e0++y9d37PgtAuJJN/H0lAEYykOK5A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743771952; c=relaxed/simple;
	bh=8gq07IhcigH5njXtZLzuj3dWp1qqGBSub6ToQ9wD4+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CyhAV+7KijrFMUzwj7PWtIv9hL/20m0i4Jf2Od08l6I26c79Sfit0DDwu5HPKZuPAunu0HNTQzB06FCZPwPaglcmbMyeBX5G8dbLONQHdUbov8FB70kn24fyhgrJwchOhluagjgrz4jhSHokgSamdXS0kSdYqtLKNE/2q/cN5DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UQxXagFN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743771949;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQXuYQhluzR2Vd5RZiNnapdK22yrUW4+Zg4CW9YDc3c=;
	b=UQxXagFNoB9hw9HfQw0gmGv5TfzR6WiR2f4VKDBqDT+ZMs3CLMmpheb+7/Qr5F/RpsZ7GH
	j2HuB62hkYNbis55DP8Yvivs8BmAaspqOtW9CmPUKtOhS311WmyKkrDV1IZ/O6MB8uGyXK
	7TyGXZN8KcTHc2D0QKwxxdATu34inYU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-FD9FT7NENR2d6eHmrsw9cQ-1; Fri,
 04 Apr 2025 09:05:46 -0400
X-MC-Unique: FD9FT7NENR2d6eHmrsw9cQ-1
X-Mimecast-MFC-AGG-ID: FD9FT7NENR2d6eHmrsw9cQ_1743771944
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC455195605E;
	Fri,  4 Apr 2025 13:05:43 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.193])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5CD619792DC;
	Fri,  4 Apr 2025 13:05:35 +0000 (UTC)
Date: Fri, 4 Apr 2025 14:05:32 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
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
Message-ID: <Z-_ZHIqDsCtQ1zf6@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>
 <Z-w47H3qUXZe4seQ@redhat.com>
 <Z+yDCKt7GpubbTKJ@devvm6277.cco0.facebook.com>
 <CAGxU2F7=64HHaAD+mYKYLqQD8rHg1CiF1YMDUULgSFw0WSY-Aw@mail.gmail.com>
 <Z-0BoF4vkC2IS1W4@redhat.com>
 <Z+23pbK9t5ckSmLl@devvm6277.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z+23pbK9t5ckSmLl@devvm6277.cco0.facebook.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Apr 02, 2025 at 03:18:13PM -0700, Bobby Eshleman wrote:
> On Wed, Apr 02, 2025 at 10:21:36AM +0100, Daniel P. Berrangé wrote:
> > It occured to me that the problem we face with the CID space usage is
> > somewhat similar to the UID/GID space usage for user namespaces.
> > 
> > In the latter case, userns has exposed /proc/$PID/uid_map & gid_map, to
> > allow IDs in the namespace to be arbitrarily mapped onto IDs in the host.
> > 
> > At the risk of being overkill, is it worth trying a similar kind of
> > approach for the vsock CID space ?
> > 
> > A simple variant would be a /proc/net/vsock_cid_outside specifying a set
> > of CIDs which are exclusively referencing /dev/vhost-vsock associations
> > created outside the namespace. Anything not listed would be exclusively
> > referencing associations created inside the namespace.
> > 
> > A more complex variant would be to allow a full remapping of CIDs as is
> > done with userns, via a /proc/net/vsock_cid_map, which the same three
> > parameters, so that CID=15 association outside the namespace could be
> > remapped to CID=9015 inside the namespace, allow the inside namespace
> > to define its out association for CID=15 without clashing.
> > 
> > IOW, mapped CIDs would be exclusively referencing /dev/vhost-vsock
> > associations created outside namespace, while unmapped CIDs would be
> > exclusively referencing /dev/vhost-vsock associations inside the
> > namespace. 
> > 
> > A likely benefit of relying on a kernel defined mapping/partition of
> > the CID space is that apps like QEMU don't need changing, as there's
> > no need to invent a new /dev/vhost-vsock-netns device node.
> > 
> > Both approaches give the desirable security protection whereby the
> > inside namespace can be prevented from accessing certain CIDs that
> > were associated outside the namespace.
> > 
> > Some rule would need to be defined for updating the /proc/net/vsock_cid_map
> > file as it is the security control mechanism. If it is write-once then
> > if the container mgmt app initializes it, nothing later could change
> > it.
> > 
> > A key question is do we need the "first come, first served" behaviour
> > for CIDs where a CID can be arbitrarily used by outside or inside namespace
> > according to whatever tries to associate a CID first ?
> 
> I think with /proc/net/vsock_cid_outside, instead of disallowing the CID
> from being used, this could be solved by disallowing remapping the CID
> while in use?
> 
> The thing I like about this is that users can check
> /proc/net/vsock_cid_outside to figure out what might be going on,
> instead of trying to check lsof or ps to figure out if the VMM processes
> have used /dev/vhost-vsock vs /dev/vhost-vsock-netns.
> 
> Just to check I am following... I suppose we would have a few typical
> configurations for /proc/net/vsock_cid_outside. Following uid_map file
> format of:
> 	"<local cid start>		<global cid start>		<range size>"
> 
> 	1. Identity mapping, current namespace CID is global CID (default
> 	setting for new namespaces):
> 
> 		# empty file
> 
> 				OR
> 
> 		0    0    4294967295
> 
> 	2. Complete isolation from global space (initialized, but no mappings):
> 
> 		0    0    0
> 
> 	3. Mapping in ranges of global CIDs
> 
> 	For example, global CID space starts at 7000, up to 32-bit max:
> 
> 		7000    0    4294960295
> 	
> 	Or for multiple mappings (0-100 map to 7000-7100, 1000-1100 map to
> 	8000-8100) :
> 
> 		7000    0       100
> 		8000    1000    100
> 
> 
> One thing I don't love is that option 3 seems to not be addressing a
> known use case. It doesn't necessarily hurt to have, but it will add
> complexity to CID handling that might never get used?

Yeah, I have the same feeling that full remapping of CIDs is probably
adding complexity without clear benefit, unless it somehow helps us
with the nested-virt scenario to disambiguate L0/L1/L2 CID ranges ?
I've not thought the latter through to any great level of detail
though

> Since options 1/2 could also be represented by a boolean (yes/no
> "current ns shares CID with global"), I wonder if we could either A)
> only support the first two options at first, or B) add just
> /proc/net/vsock_ns_mode at first, which supports only "global" and
> "local", and later add a "mapped" mode plus /proc/net/vsock_cid_outside
> or the full mapping if the need arises?

Two options is sufficient if you want to control AF_VSOCK usage
and /dev/vhost-vsock usage as a pair. If you want to separately
control them though, it would push for three options - global,
local, and mixed. By mixed I mean AF_VSOCK in the NS can access
the global CID from the NS, but the NS can't associate the global
CID with a guest.

IOW, this breaks down like:

 * CID=N local - aka fully private

     Outside NS: Can associate outside CID=N with a guest.
                 AF_VSOCK permitted to access outside CID=N

     Inside NS: Can NOT associate outside CID=N with a guest
                Can associate inside CID=N with a guest
                AF_VSOCK forbidden to access outside CID=N
                AF_VSOCK permitted to access inside CID=N


 * CID=N mixed - aka partially shared

     Outside NS: Can associate outside CID=N with a guest.
                 AF_VSOCK permitted to access outside CID=N

     Inside NS: Can NOT associate outside CID=N with a guest
                AF_VSOCK permitted to access outside CID=N
                No inside CID=N concept


 * CID=N global - aka current historic behaviour

     Outside NS: Can associate outside CID=N with a guest.
                 AF_VSOCK permitted to access outside CID=N

     Inside NS: Can associate outside CID=N with a guest
                AF_VSOCK permitted to access outside CID=N
                No inside CID=N concept


I was thinking the 'mixed' mode might be useful if the outside NS wants
to retain control over setting up the association, but delegate to
processes in the inside NS for providing individual services to that
guest.  This means if the outside NS needs to restart the VM, there is
no race window in which the inside NS can grab the assocaition with the
CID

As for whether we need to control this per-CID, or a single setting
applying to all CID.

Consider that the host OS can be running one or more "service VMs" on
well known CIDs that can be leveraged from other NS, while those other
NS also run some  "end user VMs" that should be private to the NS.

IOW, the CIDs for the service VMs would need to be using "mixed"
policy, while the CIDs for the end user VMs would be "local".

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


