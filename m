Return-Path: <kvm+bounces-42526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E83A79841
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 00:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 259DD7A3C44
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 22:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFAB1F583A;
	Wed,  2 Apr 2025 22:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPlgUkpf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C171F3D56;
	Wed,  2 Apr 2025 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743632907; cv=none; b=R/S++DCCJ61r07WkSoBGhMFtguqi7n6Am65rq+0GzGfXI3Q787Qfw+W0HZFeTkQJO29ihh2+OTmB41yzZiG1bj61dxoJcJOSIYI5NZs+AsOZX9tz+S8PiwBpBMFzJmmtGYpPEt/LYLoX/A1bKdgPZpdY+m6wGzXK0l65n6aRFL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743632907; c=relaxed/simple;
	bh=0OpwP0nOVkqFr1A9xs6Ac/M4Q6N13WihMhL0PnP1Z6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgyub1TaRQdAOv6KkuNW8qdaUEjnauxfOXoXKol4DBCshcMNuW3filSfoe92p4EdbIEyj87m4kPV27LARLiL1JWNHYhxxIx+66IWzBszmHWRHKNVXqhyFGIsoSDAITj3ni72dw394WTFZVzbEriyDgrLNHzsvjqKJ5zTfNaqVos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kPlgUkpf; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225477548e1so3429735ad.0;
        Wed, 02 Apr 2025 15:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743632905; x=1744237705; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yXllTqI4s65vesFZcUdhMkK73ncFDlJDEPi3mG19ehk=;
        b=kPlgUkpf5s0KmjHRRuSeFy0mhRs7HYSXyRi1oyKyaX2CRUi9WezTifltpbW99FRHMU
         PaqV0aqTIJk7fLqhsaq52gd5VqToqcHZOTjPjI7ZeIRm84j/17pAbure1w8qobVPr1zS
         uigeKa8NRP6mGZG/nf4Utlvd7NuHlJIMzpHngplNyuSZvgnwQhtNG/ClxSSP16tgbovg
         5VTTDo7qAPgWstnPNNACYUdu08V0qsZtxPbD6hwMngrRygOeifXxuDdzaKfE0PSuWt2W
         ip7t84WrEz4IjiEWksYt2EEQIm97F1YQJmeP1zk8XjfVOeKZS1V3AqXTcABbY2qxMmMS
         /DjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743632905; x=1744237705;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yXllTqI4s65vesFZcUdhMkK73ncFDlJDEPi3mG19ehk=;
        b=PQjIiCLRxEPoa0u64csTin32cYjeHynLfFC+eC848mUbLVX+tir2sg8yVjqzDfZQdV
         NmuuoBoiVeQwQcWcWjipuDU3/ibPmy9N7INk1iwqwb/mGo1SwrZYx20NFfT+jmWBrZfa
         NSl2yUA2rh5Bb9PtFAG93oafzS/1s2Ol0S56vEHRlM7SeYxbiUAn7eI9OmO2XNBkb6yq
         FzpcfPxw/Ab2lXgNSZ7v0E/YBJSeoz9PHZwMMElSp0/TQNOHP2b7KW1HnnQpR6Wj1vdM
         nNBX8yxWh4sPmI3D5A0gw03hT664zWe8zRUfaBsvFj67/IbUpNnpTpUr9mHpBNNfmVpf
         QY4w==
X-Forwarded-Encrypted: i=1; AJvYcCVBep/nlFYXOaAH2C94bI0g4RCZXH9GUA5bE80ToFHoXzCWZGuZw2XrMCb2bIEtwmkjrthasjhnrt2qAS2N@vger.kernel.org, AJvYcCVju1RELelkYqVk+yt/4sDhcjwp7FT4OTmEg/ybR/ovw+MeP3BS14n+26PscmAqXHSYQ2s=@vger.kernel.org, AJvYcCW4QWw379HoFU1COl+npe56JEBWa5HxgIPkAi/OJA4q905rq2k3jt7Sti+Vk2G7ak9Od4/lkDFL@vger.kernel.org, AJvYcCXlG5jPVj6jYRDcpgrbd649IRUtpMLfMAlKCUIIrAShiiJabbGmaBQub3lOjX3mruqo0KokWtVXF8bksSg5@vger.kernel.org
X-Gm-Message-State: AOJu0YxnE7RmNNL2lsUSU7aoi9wfVAPKrB5lgRr8G5bZwd3Mwj2Feo3X
	YFnBFtfBzmn6wID0hJCc23gvZ9dCc0Cs/99Me83g5YlqEpmS7wfi
X-Gm-Gg: ASbGncsXhUoWRI24t8thKY4WZNpe15c9i0uaJ14nFX2eiJVtB4hGzzxaCg1tw8gl0Iu
	EKvlgyLzct+5CuIwvn2dH3t/HAhAYdbjHjrciEFIzu99/reVuKxReR+Ea2T5TI/+D041634H9gT
	Oo4YBWcAs8aPi1b8Vz1ltZ1PfTUvBASwnmYjUT8ao9vcUgjyOpT9UXtvAzGFgi0lCNHF7o/Syll
	FZjVscLdLC8ugh26jEsW9OVoJNnwQp/Aucro88DHtWrcETd09umvorehzcwKQ+3G9RCOYgb+Af6
	Scelz/oAE4RaD5A4paByx77YJQyy3XGBnpTmrKy0l1JOO4TbpBh19iPFTX//2oMQG/Y=
X-Google-Smtp-Source: AGHT+IEi3/Az0kN6/qk5PEcOPsRQRcT8R3qSFIbNneHvLBHXZk97kL5tuRnk3IdLpKHf2gczG5Szfw==
X-Received: by 2002:a17:902:ecc3:b0:224:826:277f with SMTP id d9443c01a7336-2292f9db08fmr272480865ad.33.1743632904725;
        Wed, 02 Apr 2025 15:28:24 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:70::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-229785c015fsm932655ad.56.2025.04.02.15.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 15:28:22 -0700 (PDT)
Date: Wed, 2 Apr 2025 15:28:19 -0700
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
Message-ID: <Z+26A3sslT+w+wOI@devvm6277.cco0.facebook.com>
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
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z+23pbK9t5ckSmLl@devvm6277.cco0.facebook.com>

On Wed, Apr 02, 2025 at 03:18:13PM -0700, Bobby Eshleman wrote:
> On Wed, Apr 02, 2025 at 10:21:36AM +0100, Daniel P. Berrangé wrote:
> > On Wed, Apr 02, 2025 at 10:13:43AM +0200, Stefano Garzarella wrote:
> > > On Wed, 2 Apr 2025 at 02:21, Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> > > >
> > > > I do like Stefano's suggestion to add a sysctl for a "strict" mode,
> > > > Since it offers the best of both worlds, and still tends conservative in
> > > > protecting existing applications... but I agree, the non-strict mode
> > > > vsock would be unique WRT the usual concept of namespaces.
> > > 
> > > Maybe we could do the opposite, enable strict mode by default (I think 
> > > it was similar to what I had tried to do with the kernel module in v1, I 
> > > was young I know xD)
> > > And provide a way to disable it for those use cases where the user wants 
> > > backward compatibility, while paying the cost of less isolation.
> > 
> > I think backwards compatible has to be the default behaviour, otherwise
> > the change has too high risk of breaking existing deployments that are
> > already using netns and relying on VSOCK being global. Breakage has to
> > be opt in.
> > 
> > > I was thinking two options (not sure if the second one can be done):
> > > 
> > >   1. provide a global sysfs/sysctl that disables strict mode, but this
> > >   then applies to all namespaces
> > > 
> > >   2. provide something that allows disabling strict mode by namespace.
> > >   Maybe when it is created there are options, or something that can be
> > >   set later.
> > > 
> > > 2 would be ideal, but that might be too much, so 1 might be enough. In 
> > > any case, 2 could also be a next step.
> > > 
> > > WDYT?
> > 
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
> 
> Since options 1/2 could also be represented by a boolean (yes/no
> "current ns shares CID with global"), I wonder if we could either A)
> only support the first two options at first, or B) add just
> /proc/net/vsock_ns_mode at first, which supports only "global" and
> "local", and later add a "mapped" mode plus /proc/net/vsock_cid_outside
> or the full mapping if the need arises?
> 
> This could also be how we support Option 2 from Stefano's last email of
> supporting per-namespace opt-in/opt-out.
> 
> Any thoughts on this?
> 

Stefano,

Would only supporting 1/2 still support the Kata use case?

Thanks,
Bobby

