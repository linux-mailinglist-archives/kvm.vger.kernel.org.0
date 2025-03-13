Return-Path: <kvm+bounces-40865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33423A5E9F4
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 03:28:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D62EB1882C6A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 02:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB177135A63;
	Thu, 13 Mar 2025 02:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bh+3iKV1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62613179BD;
	Thu, 13 Mar 2025 02:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741832919; cv=none; b=pAldwIKmikz4pVpmfhl6eTKtjJ4BIaKH2NETOlr5EAkNLDc6ouLf2+FuRbS7yoAI+PJkqRnVoqhqDvbtTLQFrlxJs8jHiq696N+Vg8brt44dYsFbShikGzZb6ygYZ6qkoJ5NInSChFKgScnpq38M6xlXdYlUskPS/B0sdMAHxAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741832919; c=relaxed/simple;
	bh=VovwtesJv9Sb1xbTUhCBIIiCY95KkpZxe6VkXX0igs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TSjH+TO4+w+3ymAv5mQ/eS4Fljqjcud8sUXneZ6M1HrcF0jZcc8gsND523lraCQ+LgpXaaMHXDqYgBOJy0bbjq/d154DaXsSOrc0pUlKskSf8/PS+Gwn2H2r2ZDUGQIR74zIcGhOuW87gVyzYNcUOT7+z5K++CVStuykwXsWDy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bh+3iKV1; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22548a28d0cso12912075ad.3;
        Wed, 12 Mar 2025 19:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741832916; x=1742437716; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KoDUTDm8Gdk20+Tf3509gImhzxirBKWUcOSksBRe5Oc=;
        b=bh+3iKV1AJKuyOKCb8D3pLOXaELEl9hyaOCsGVv4YCvE0eU6GBYjqV5ASt+P1sYMTw
         Wolm8335WOKrqmcqrzv907kkPVMQKOrcyANlPxboF2SPFaFV5mHNWzUS2/aOK3jp+xM9
         DTF2tsTo0gel29zq1Pu0NWMGpix909LyhcW1+CRGHAwfqd8ognv2BUrIjY4hM2nh6gZS
         pIahxRWeC39yUtCmMpx2ydUajbJR4pYqa4LtfX82oFZHrKLziuf0lCUQgRohQCKVrkpg
         wHwSEnwPLdJq+Xc57zObSCubmBkFaYKz5oTkV72isXg6EJ3PtQVYv6Q2vmV79imjOCdO
         TiIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741832916; x=1742437716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KoDUTDm8Gdk20+Tf3509gImhzxirBKWUcOSksBRe5Oc=;
        b=aYBUWrRfVMUg637xT1sEj5OTLE1JUc+iDVzaEIYL2Uhylr0uD0PA6WkdcFRv2qUVbr
         3ez/3AuciFxJwsvPq9jHkIz1RAi57MIe0T79472LhYlZAnKwnzGx1s+XTGTnbnf5atp7
         lJopj+OKxGbJV7I+gGIUKS+NW7Xt2+YUaDq3qYnHqdViIa4UKnokyYaadqjTBQQIvX1l
         P493/uQg6DB8BAjwvr6j8895xcHxeEsMnPZ61tzJ5JLFmgMDTCtBicW49wM/HRpBS1Bx
         6MLdZDc/ZjP0UAM1KEVPvVClDw6BmQYJVWExc47PhDJ/9FGF2qOcYIu/TSTsRZSCUy6Q
         gLBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbDtNpMB7BzvntKs8Lg8H9miCV3+Y9sWh0lbXYAqOmsR3LjhE+X3F3idAomZemVeC/sDQ=@vger.kernel.org, AJvYcCVsucn/zUbbBflbXBfiQc5YhwCkyS98W9dyuSCm4HXKtEIRcxXIW+0Rf3FzHWRjrrtcopt8ONN8f7NGsUWP@vger.kernel.org, AJvYcCVyvRVSfHnrKQdpjX/34y7f4HRcJlQu4ABVYEIZPM42P35Q5g5m/54vh/mLdP90Q5OXEX9ZShus@vger.kernel.org, AJvYcCWCCdfOIAIjqP5EvGtVo4VmFAV7tBOD2SH5RwXSyliQ6ke7rheiD4oHlDSsQAd5ev8EPM+xhioyaafA+/AN@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjjs3tedIOrrCusRxr46ZatBy2KjNKDap2a3Ddgcove1ayxLL3
	hnwAY9i/8YfSQFILbEGsIOw+RExwZMwNFL8Jma+uA3r+F7L4tuNQ
X-Gm-Gg: ASbGncvgzgk4DkE7o2i3gRhEbgwAd8XoJe3fG4KYKlK7nn91e8u06BSNCDPPcpd81FP
	a2U0JxcRRNnfkKRsjeaauBEE/QXNpjgbsKF7Fiso421fAYfGjB/v43x9zMaguMikkCga8gSDFdv
	AsLFIBvJEtePAgVTSDx7YoQR/4LSZNyEXCLIGWUvC/iTKIOb7jk3FkhyHwkZe8DszJpC8Ob7A94
	Qr6NmusVZPdYO0xJ7cnBmlw8UFb1ZuJULnszwZg64rjMYLuKcYHhPlQczofW518/Nos8lY7lDA7
	YFIVuTezr9MIlxT6W9Yk6XKrhr5eto5jxa18HdPCM+2F0ZQLWCm8YAOr8KnW8MhOcdO1J6PsXqW
	MTg==
X-Google-Smtp-Source: AGHT+IElXCWU2ZTEBcj7ESTCH4hLQqV9BYJSYITdjZw2xjnf7NpJNUxUzR1Spw/U1Dc6tCNyB628Iw==
X-Received: by 2002:a17:903:2405:b0:21f:6bda:e492 with SMTP id d9443c01a7336-22428bdee0emr427968615ad.35.1741832916397;
        Wed, 12 Mar 2025 19:28:36 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:74::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c68884ccsm2791885ad.27.2025.03.12.19.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 19:28:35 -0700 (PDT)
Date: Wed, 12 Mar 2025 19:28:33 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>,
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
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Message-ID: <Z9JC0VoMwAHKjqEX@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>

Hey all,

Apologies for forgetting the 'net-next' prefix on this one. Should I
resend or no?

Best,
Bobby

On Wed, Mar 12, 2025 at 01:59:34PM -0700, Bobby Eshleman wrote:
> Picking up Stefano's v1 [1], this series adds netns support to
> vhost-vsock. Unlike v1, this series does not address guest-to-host (g2h)
> namespaces, defering that for future implementation and discussion.
> 
> Any vsock created with /dev/vhost-vsock is a global vsock, accessible
> from any namespace. Any vsock created with /dev/vhost-vsock-netns is a
> "scoped" vsock, accessible only to sockets in its namespace. If a global
> vsock or scoped vsock share the same CID, the scoped vsock takes
> precedence.
> 
> If a socket in a namespace connects with a global vsock, the CID becomes
> unavailable to any VMM in that namespace when creating new vsocks. If
> disconnected, the CID becomes available again.
> 
> Testing
> 
> QEMU with /dev/vhost-vsock-netns support:
> 	https://github.com/beshleman/qemu/tree/vsock-netns
> 
> Test: Scoped vsocks isolated by namespace
> 
>   host# ip netns add ns1
>   host# ip netns add ns2
>   host# ip netns exec ns1 \
> 				  qemu-system-x86_64 \
> 					  -m 8G -smp 4 -cpu host -enable-kvm \
> 					  -serial mon:stdio \
> 					  -drive if=virtio,file=${IMAGE1} \
> 					  -device vhost-vsock-pci,netns=on,guest-cid=15
>   host# ip netns exec ns2 \
> 				  qemu-system-x86_64 \
> 					  -m 8G -smp 4 -cpu host -enable-kvm \
> 					  -serial mon:stdio \
> 					  -drive if=virtio,file=${IMAGE2} \
> 					  -device vhost-vsock-pci,netns=on,guest-cid=15
> 
>   host# socat - VSOCK-CONNECT:15:1234
>   2025/03/10 17:09:40 socat[255741] E connect(5, AF=40 cid:15 port:1234, 16): No such device
> 
>   host# echo foobar1 | sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
>   host# echo foobar2 | sudo ip netns exec ns2 socat - VSOCK-CONNECT:15:1234
> 
>   vm1# socat - VSOCK-LISTEN:1234
>   foobar1
>   vm2# socat - VSOCK-LISTEN:1234
>   foobar2
> 
> Test: Global vsocks accessible to any namespace
> 
>   host# qemu-system-x86_64 \
> 	  -m 8G -smp 4 -cpu host -enable-kvm \
> 	  -serial mon:stdio \
> 	  -drive if=virtio,file=${IMAGE2} \
> 	  -device vhost-vsock-pci,guest-cid=15,netns=off
> 
>   host# echo foobar | sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
> 
>   vm# socat - VSOCK-LISTEN:1234
>   foobar
> 
> Test: Connecting to global vsock makes CID unavailble to namespace
> 
>   host# qemu-system-x86_64 \
> 	  -m 8G -smp 4 -cpu host -enable-kvm \
> 	  -serial mon:stdio \
> 	  -drive if=virtio,file=${IMAGE2} \
> 	  -device vhost-vsock-pci,guest-cid=15,netns=off
> 
>   vm# socat - VSOCK-LISTEN:1234
> 
>   host# sudo ip netns exec ns1 socat - VSOCK-CONNECT:15:1234
>   host# ip netns exec ns1 \
> 				  qemu-system-x86_64 \
> 					  -m 8G -smp 4 -cpu host -enable-kvm \
> 					  -serial mon:stdio \
> 					  -drive if=virtio,file=${IMAGE1} \
> 					  -device vhost-vsock-pci,netns=on,guest-cid=15
> 
>   qemu-system-x86_64: -device vhost-vsock-pci,netns=on,guest-cid=15: vhost-vsock: unable to set guest cid: Address already in use
> 
> Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
> ---
> Changes in v2:
> - only support vhost-vsock namespaces
> - all g2h namespaces retain old behavior, only common API changes
>   impacted by vhost-vsock changes
> - add /dev/vhost-vsock-netns for "opt-in"
> - leave /dev/vhost-vsock to old behavior
> - removed netns module param
> - Link to v1: https://lore.kernel.org/r/20200116172428.311437-1-sgarzare@redhat.com
> 
> Changes in v1:
> - added 'netns' module param to vsock.ko to enable the
>   network namespace support (disabled by default)
> - added 'vsock_net_eq()' to check the "net" assigned to a socket
>   only when 'netns' support is enabled
> - Link to RFC: https://patchwork.ozlabs.org/cover/1202235/
> 
> ---
> Stefano Garzarella (3):
>       vsock: add network namespace support
>       vsock/virtio_transport_common: handle netns of received packets
>       vhost/vsock: use netns of process that opens the vhost-vsock-netns device
> 
>  drivers/vhost/vsock.c                   | 96 +++++++++++++++++++++++++++------
>  include/linux/miscdevice.h              |  1 +
>  include/linux/virtio_vsock.h            |  2 +
>  include/net/af_vsock.h                  | 10 ++--
>  net/vmw_vsock/af_vsock.c                | 85 +++++++++++++++++++++++------
>  net/vmw_vsock/hyperv_transport.c        |  2 +-
>  net/vmw_vsock/virtio_transport.c        |  5 +-
>  net/vmw_vsock/virtio_transport_common.c | 14 ++++-
>  net/vmw_vsock/vmci_transport.c          |  4 +-
>  net/vmw_vsock/vsock_loopback.c          |  4 +-
>  10 files changed, 180 insertions(+), 43 deletions(-)
> ---
> base-commit: 0ea09cbf8350b70ad44d67a1dcb379008a356034
> change-id: 20250312-vsock-netns-45da9424f726
> 
> Best regards,
> -- 
> Bobby Eshleman <bobbyeshleman@gmail.com>
> 

