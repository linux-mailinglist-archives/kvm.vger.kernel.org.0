Return-Path: <kvm+bounces-43674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E5DA93C77
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 19:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67BCA4680F5
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 17:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10BB921D3D1;
	Fri, 18 Apr 2025 17:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AW8Puweb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F90221C18A;
	Fri, 18 Apr 2025 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744999085; cv=none; b=rimCCYvVNoK2VuWGI+r0hZAg366bKvuzeQgwMs2jVfaVPgX2tIaOluMuzxH5dIRUA4oxpbtJlJAg9zSOFlYaFutO+lU243s2uet+xcbWltMtHqQiB+QaNMyGblaulKBrdL/FS2P037xkjobaeRzynRjZZ8zcn+9Gd+Ur2ThNwD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744999085; c=relaxed/simple;
	bh=+iuicaO2ZLC9As16m3h2Zjp/ZCP3hJ0WL048subJKIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcTB6+8YbbQBZBACtJxhmzVc+QLZxz8RGbXHtC9pgSwsZyoiv4WUzZ2FNa4duk1tQa0LgP9BJpbQ0oNir/6ejW8hpVb/ILqodNbsCdxjzPX28guA5ueAQEuyBNTfx8FCb+fm9MelsJVCMnbd6uOI/bGBWbSDBiQjdjO6gJHxQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AW8Puweb; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-736c062b1f5so1756664b3a.0;
        Fri, 18 Apr 2025 10:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744999083; x=1745603883; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SW+tjIRc0AX+aTZhnNtpBaCEsRQ7numGTe8SeYWYC6s=;
        b=AW8Puweba+P0BsFHYdiG256ZSd5XjK3ojG9O/+sM75KXEkfq/zO9WRyeS0sSzCujiX
         HIRx3NAalFwn9cKZJj/42fUW7BKmlX5C17K2IhiYcqXfMyNj7g9RPEvKcV1tEIkCm9GX
         sLbvjAFMFJeOVSj2ZG76PnsGvFJt2Zd7Wc+8lRHXwT0qPBfkZXy6VqSJZOxMeyjB7HA3
         BJZ1SmAeIErNikLVXnS1dkX0Q9qo+Fxkl5MtvRVnRtgtOOw8riO69fuX/PiUc7nRdynx
         +3g3lvJfhUZtFXUEpu+W2kESPMHi+izyeCFooyKYFvZnNQg4AQn/huFqlMmHanHsDnzh
         Ix/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744999083; x=1745603883;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SW+tjIRc0AX+aTZhnNtpBaCEsRQ7numGTe8SeYWYC6s=;
        b=BnMROvqtXLa1P+eZanvELdDBWwZc2kecNy7YUlbQJqEyqKup9PpVLwxEFbx2D+DCP+
         iuVng3v3vYFYIanMqV06oA62TPQ9ppkNY/tV9pFNWnMcooEJw4jfSw2WdpuwhtQcAUuP
         hn8L1lfE6JNiK21XJx25hq/RTN9I1v4l+62hQow3IDVVCZDGC6/y89qgk0urQC7JfdPS
         pZ28BuvO4um57ArPJA9cdTsOfUgcnTby+nBK9Ov0H/Bo5o1t0EOoi90MF/O1DygLjQZ/
         77R1xX6AM6TpJXArssSjlKz2yWMZ4hE4BKzMnCgK/fsqgLa131brffgTETiemXNTDpTU
         OKUg==
X-Forwarded-Encrypted: i=1; AJvYcCVT/h+Mh2kmv4K3nHBNaDA4ZByqNdyxiEWji5wuUuRYilDjn4tn+2x7SV1XMfpkpFY5AYcMU0nS@vger.kernel.org, AJvYcCW6r+xszLW+D7mV0U/8bmc3J3ClJsCRWCXofDNhxHoigRsTuMeR1cbY2x+hbDkMdhzvYlj6MeLPVQ6q/kqx@vger.kernel.org, AJvYcCX2ZuRfvrUqavzTmT4QMIjZgXxctV4O/WsTnJrM0C9Tkp+Ss6uKkdjq5I0HoZmyzYZqvx5EvY4Rvu9Gu9mX@vger.kernel.org, AJvYcCXR4H/6DXWhLnuJldIikS+D4w/rFFjmO3U76RcWiIkcZSCyIEogOx8zSqZRY6VB9xoQLiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtZrS/5rMrjHtfzNFD7dyVH+kRYdvxi/5ZGSvm4unq30qoICzG
	Bj5bX0av8igWoF+24pbCP8Rg8jnbqfsfG6Xd0e1K6Qz81WslAq/v
X-Gm-Gg: ASbGncuCLiezIHaGyNph6PdOUGOJi6WT51F0KE+XFuGnLj7EAS1Pxao0lEW0leIsQqR
	knyj8AOWUkdHAqzm5tdDrDKDX52U7yLlrf/ci/nhBgyI2Ob/ai/SV3imZ/mpG27sGQJMZNAPUFK
	uY1pGRxj9OZixba+8BlY7RICS9T/mhkUBaxuYHH6aanMVfJDOmyccRLiMQN2Fp6NmRNSMXOsl4X
	ZXFwxPmKkWTMaqAUj4iMuRW624J0UyHTpn8/lleerM03flh0Ua2GOp+7owtsmVW7Pj2L1wt+1T/
	mIf5Eprub3TZwAJ1eFjlHR/H1ydyb7GtKBVtBn/kXgMf1h3/3kbwqHq2seUlFFxLonSNT8NH
X-Google-Smtp-Source: AGHT+IEbgq3jwmjK4u9tvaN1T1FGkQcruTs8eW7QiNt2zXcFuImLwX/xWrVRPy+awAKrid+LehwadA==
X-Received: by 2002:a05:6a00:a91:b0:737:6d4b:f5f8 with SMTP id d2e1a72fcca58-73dc1568775mr4422634b3a.17.1744999082560;
        Fri, 18 Apr 2025 10:58:02 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:1::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf8e46e3sm1954817b3a.59.2025.04.18.10.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 10:58:01 -0700 (PDT)
Date: Fri, 18 Apr 2025 10:57:52 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Message-ID: <aAKSoHQuycz24J5l@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>
 <Z-w47H3qUXZe4seQ@redhat.com>
 <Z+yDCKt7GpubbTKJ@devvm6277.cco0.facebook.com>
 <CAGxU2F7=64HHaAD+mYKYLqQD8rHg1CiF1YMDUULgSFw0WSY-Aw@mail.gmail.com>
 <Z-0BoF4vkC2IS1W4@redhat.com>
 <Z+23pbK9t5ckSmLl@devvm6277.cco0.facebook.com>
 <Z-_ZHIqDsCtQ1zf6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z-_ZHIqDsCtQ1zf6@redhat.com>

On Fri, Apr 04, 2025 at 02:05:32PM +0100, Daniel P. Berrangé wrote:
> On Wed, Apr 02, 2025 at 03:18:13PM -0700, Bobby Eshleman wrote:
> > On Wed, Apr 02, 2025 at 10:21:36AM +0100, Daniel P. Berrangé wrote:
> > > It occured to me that the problem we face with the CID space usage is
> > > somewhat similar to the UID/GID space usage for user namespaces.
> > > 
> > > In the latter case, userns has exposed /proc/$PID/uid_map & gid_map, to
> > > allow IDs in the namespace to be arbitrarily mapped onto IDs in the host.
> > > 
> > > At the risk of being overkill, is it worth trying a similar kind of
> > > approach for the vsock CID space ?
> > > 
> > > A simple variant would be a /proc/net/vsock_cid_outside specifying a set
> > > of CIDs which are exclusively referencing /dev/vhost-vsock associations
> > > created outside the namespace. Anything not listed would be exclusively
> > > referencing associations created inside the namespace.
> > > 
> > > A more complex variant would be to allow a full remapping of CIDs as is
> > > done with userns, via a /proc/net/vsock_cid_map, which the same three
> > > parameters, so that CID=15 association outside the namespace could be
> > > remapped to CID=9015 inside the namespace, allow the inside namespace
> > > to define its out association for CID=15 without clashing.
> > > 
> > > IOW, mapped CIDs would be exclusively referencing /dev/vhost-vsock
> > > associations created outside namespace, while unmapped CIDs would be
> > > exclusively referencing /dev/vhost-vsock associations inside the
> > > namespace. 
> > > 
> > > A likely benefit of relying on a kernel defined mapping/partition of
> > > the CID space is that apps like QEMU don't need changing, as there's
> > > no need to invent a new /dev/vhost-vsock-netns device node.
> > > 
> > > Both approaches give the desirable security protection whereby the
> > > inside namespace can be prevented from accessing certain CIDs that
> > > were associated outside the namespace.
> > > 
> > > Some rule would need to be defined for updating the /proc/net/vsock_cid_map
> > > file as it is the security control mechanism. If it is write-once then
> > > if the container mgmt app initializes it, nothing later could change
> > > it.
> > > 
> > > A key question is do we need the "first come, first served" behaviour
> > > for CIDs where a CID can be arbitrarily used by outside or inside namespace
> > > according to whatever tries to associate a CID first ?
> > 
> > I think with /proc/net/vsock_cid_outside, instead of disallowing the CID
> > from being used, this could be solved by disallowing remapping the CID
> > while in use?
> > 
> > The thing I like about this is that users can check
> > /proc/net/vsock_cid_outside to figure out what might be going on,
> > instead of trying to check lsof or ps to figure out if the VMM processes
> > have used /dev/vhost-vsock vs /dev/vhost-vsock-netns.
> > 
> > Just to check I am following... I suppose we would have a few typical
> > configurations for /proc/net/vsock_cid_outside. Following uid_map file
> > format of:
> > 	"<local cid start>		<global cid start>		<range size>"
> > 
> > 	1. Identity mapping, current namespace CID is global CID (default
> > 	setting for new namespaces):
> > 
> > 		# empty file
> > 
> > 				OR
> > 
> > 		0    0    4294967295
> > 
> > 	2. Complete isolation from global space (initialized, but no mappings):
> > 
> > 		0    0    0
> > 
> > 	3. Mapping in ranges of global CIDs
> > 
> > 	For example, global CID space starts at 7000, up to 32-bit max:
> > 
> > 		7000    0    4294960295
> > 	
> > 	Or for multiple mappings (0-100 map to 7000-7100, 1000-1100 map to
> > 	8000-8100) :
> > 
> > 		7000    0       100
> > 		8000    1000    100
> > 
> > 
> > One thing I don't love is that option 3 seems to not be addressing a
> > known use case. It doesn't necessarily hurt to have, but it will add
> > complexity to CID handling that might never get used?
> 
> Yeah, I have the same feeling that full remapping of CIDs is probably
> adding complexity without clear benefit, unless it somehow helps us
> with the nested-virt scenario to disambiguate L0/L1/L2 CID ranges ?
> I've not thought the latter through to any great level of detail
> though
> 
> > Since options 1/2 could also be represented by a boolean (yes/no
> > "current ns shares CID with global"), I wonder if we could either A)
> > only support the first two options at first, or B) add just
> > /proc/net/vsock_ns_mode at first, which supports only "global" and
> > "local", and later add a "mapped" mode plus /proc/net/vsock_cid_outside
> > or the full mapping if the need arises?
> 
> Two options is sufficient if you want to control AF_VSOCK usage
> and /dev/vhost-vsock usage as a pair. If you want to separately
> control them though, it would push for three options - global,
> local, and mixed. By mixed I mean AF_VSOCK in the NS can access
> the global CID from the NS, but the NS can't associate the global
> CID with a guest.
> 
> IOW, this breaks down like:
> 
>  * CID=N local - aka fully private
> 
>      Outside NS: Can associate outside CID=N with a guest.
>                  AF_VSOCK permitted to access outside CID=N
> 
>      Inside NS: Can NOT associate outside CID=N with a guest
>                 Can associate inside CID=N with a guest
>                 AF_VSOCK forbidden to access outside CID=N
>                 AF_VSOCK permitted to access inside CID=N
> 
> 
>  * CID=N mixed - aka partially shared
> 
>      Outside NS: Can associate outside CID=N with a guest.
>                  AF_VSOCK permitted to access outside CID=N
> 
>      Inside NS: Can NOT associate outside CID=N with a guest
>                 AF_VSOCK permitted to access outside CID=N
>                 No inside CID=N concept
> 
> 
>  * CID=N global - aka current historic behaviour
> 
>      Outside NS: Can associate outside CID=N with a guest.
>                  AF_VSOCK permitted to access outside CID=N
> 
>      Inside NS: Can associate outside CID=N with a guest
>                 AF_VSOCK permitted to access outside CID=N
>                 No inside CID=N concept
> 
> 
> I was thinking the 'mixed' mode might be useful if the outside NS wants
> to retain control over setting up the association, but delegate to
> processes in the inside NS for providing individual services to that
> guest.  This means if the outside NS needs to restart the VM, there is
> no race window in which the inside NS can grab the assocaition with the
> CID
> 
> As for whether we need to control this per-CID, or a single setting
> applying to all CID.
> 
> Consider that the host OS can be running one or more "service VMs" on
> well known CIDs that can be leveraged from other NS, while those other
> NS also run some  "end user VMs" that should be private to the NS.
> 
> IOW, the CIDs for the service VMs would need to be using "mixed"
> policy, while the CIDs for the end user VMs would be "local".
> 

I think this sounds pretty flexible, and IMO adding the third mode
doesn't add much more additional complexity.

Going this route, we have:
- three modes: local, global, mixed
- at first, no vsock_cid_map (local has no outside CIDs, global and mixed have no inside
	CIDs, so no cross-mapping needed)
- only later add a full mapped mode and vsock_cid_map if necessary.

Stefano, any preferences on this vs starting with the restricted
vsock_cid_map (only supporting "0 0 0" and "0 0 <size>")?

I'm leaning towards the modes because it covers more use cases and seems
like a clearer user interface?

To clarify another aspect... child namespaces must inherit the parent's
local. So if namespace P sets the mode to local, and then creates a
child process that then creates namespace C... then C's global and mixed
modes are implicitly restricted to P's local space?

Thanks,
Bobby

