Return-Path: <kvm+bounces-41719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C32DBA6C3BC
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24A7F482D32
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E2EA230BE4;
	Fri, 21 Mar 2025 19:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O4BoVJ00"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C904F1EE007
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 19:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742586592; cv=none; b=uqxlJa/pHMa+tgC7tQKnzCzW/Npow0Ck+tx+El2R61Q9gFKlgZdJMoA2S1UAaqUKM7O6amOTsDnrsyoXsdRT8y3LKVAeKyzQCKjh95MjGBNQgEg+rP5Nwn4b4NQiKDyFzm9sy5X69VAvvIfNl3HuYfLRsKvKClFFmeAvDOYPjxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742586592; c=relaxed/simple;
	bh=UFdqBVJRDVk8Hlcf3jTu50jsbpG+mU166GYiFitWazE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rAlDpHJTbAx4PNQ6nboLm1JVvHHn+GPyi7jtNoPFCM+NrvsCNILdUGmoweiVBXojvPXG4aJJpX8KjC3DmMwYEUSyS3sivlJjRM0Sl8o2DLi4kEUttTgbbf4geFGKPSp9unusSYdljXTLhCEZzGpeGZFBX5jkm68+rLc1wv5cO4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O4BoVJ00; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742586589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ReERJAqHieSO06A2On5uvAOfqLYlr/FeJgCmLUNx8kQ=;
	b=O4BoVJ00Fs+0i/3ynJVBoLhMsI11msoBxLm3IbfwjsUTnZtjkOXXutG0ymCJlEFaNRlPcp
	Vv/8FqDoFUOeW+MH90yfyXsnPgwPSt6PixYC38JSNMhq8Dxdfp3IIXTgP2i7kOWlYk1Pic
	yBXOQYJVM+uTM2NrE1heehvz8Txp2zM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-UMU2C4kKOaqTrYdpp8ah0g-1; Fri, 21 Mar 2025 15:49:48 -0400
X-MC-Unique: UMU2C4kKOaqTrYdpp8ah0g-1
X-Mimecast-MFC-AGG-ID: UMU2C4kKOaqTrYdpp8ah0g_1742586587
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2ff7f9a0b9bso4182277a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 12:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742586587; x=1743191387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ReERJAqHieSO06A2On5uvAOfqLYlr/FeJgCmLUNx8kQ=;
        b=u+PH265yoeqU0Lc3r9YKY4jqrOVsqhvy1mbIVgNPc0QIGLcsP23gLtSqfr6W040y5A
         +ORMjnt46O/SJStdGBCJD18ZSKAHK9IxVblOJ9vIv85AtFCwkNXDlqrGyHpplpoIsHVA
         zX88gDmeNyNgpoG1Jqa9pdRzLQFBwj/XpVbnUhcqc4SAZ71N+4IOMreA4FrDD2Mksc0k
         1dSKETL4VT+lUrQFSHrmUbLzs2ztX8XwiKwAO5lMvgE/wzvKcGavsnMApC4p5I6uZchh
         5zETD+OWTIeiGI8jjl8/WZ7xzabWPly4Bz1fv0ZfN+lvUPosAKhxaVmg8SDd3++bRYl4
         3RnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9Hy+57T7GQdiiItYU4JrjMU9NM40LCSy2sfkbqtFxKZMS8sB+BSOiKOsZeZUG2eAmRCg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBkdbgXtfna3Dq5u0pVhpTiDkQBXROYQr1obpCFgpAU1Yk7cao
	5gVSvk49E7TJkuwLVmY7fFVHj+SS5tmDRuCZuPQW/gKSlpSnhx47/5GiBpLblQW/dSt32ZhPT5u
	Og++wvUHYM/VrNk0fw8Pp5bh7FUkphvCjJRdEsTxLej7mFnEy7A==
X-Gm-Gg: ASbGnctv9T7l0pOQBRVdRzSorAeH3/uzgqmdrMD06oCXMSzuoEVGEOtrM1PdOcrzoUt
	1H7ZBtEBckez/aC4H96F9csawtw+ZT0qKQje9HtpGeEPkibMYkSbEzNiSoptqrwF2dOH0sm/3DO
	bH1HU+ijhGgwolu+77AYX98PA7IDV7l+HHfTLVpUcKW88Fdh+PGw/+iIfQEHtQOxdjfG7LREoVv
	2GOIzuxDNo3zC4pf4kfcRnuu66SmIfjt1fZChF6mHLOhbkBTTdQv8y31LCHtNf1fsgqlOh9C2vJ
	8l/V7YEh
X-Received: by 2002:a05:6a21:6182:b0:1f5:55b7:1bb4 with SMTP id adf61e73a8af0-1fe42f2ca16mr8343014637.11.1742586586908;
        Fri, 21 Mar 2025 12:49:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgaPER9WdLR23YdQNltOTaAZ+YfxNnRQHaimB6OsbRkGfsA5VnV3pJYV1//O3S4oQcK/34rw==
X-Received: by 2002:a05:6a21:6182:b0:1f5:55b7:1bb4 with SMTP id adf61e73a8af0-1fe42f2ca16mr8342982637.11.1742586586558;
        Fri, 21 Mar 2025 12:49:46 -0700 (PDT)
Received: from redhat.com ([195.133.138.172])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a2841c02sm1900123a12.39.2025.03.21.12.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 12:49:46 -0700 (PDT)
Date: Fri, 21 Mar 2025 15:49:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
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
Message-ID: <20250321154922-mutt-send-email-mst@kernel.org>
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


yea that's a sane way to do it.
Thanks!

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


