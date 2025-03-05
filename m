Return-Path: <kvm+bounces-40098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC01A4F216
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:06:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C7BB3A5B3B
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 00:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABD4746E;
	Wed,  5 Mar 2025 00:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVNm3Wcc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BCA163;
	Wed,  5 Mar 2025 00:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741133167; cv=none; b=sjVV0Na/4RntekVWVmyZGMmoXUuT601wyF45pf9XW83G9xdSKCOgjpkTnXaGa3yTNOLm5Oyad+vUV8jdS2+QCPrp4BzQ1g+hs0eTyEQJkx5ztrRRyxMELv+zqqGynMeDh4eaomou1V2HGRsC95jgRgtp0PEH8eFzy7zI3Vjqxpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741133167; c=relaxed/simple;
	bh=yumEBOrSKRVXTEceLp63BWKfaVOLc1xa6xzRclgxWJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uN+dUzi6SZ7kq8pb6k0E+2DpNqvK58i3xThQ8YDfj3BPbEC9JAcQrr4dP/RM6mv2xL33Spd/ZbjKLAaUL3YbaiZOBo5DwZfX86udxv6wYOuqya4W0TWIfCHCaY+cAG/YlttV8t4ZQs32V5X5fcG+hdWcHx6mohpuX1/6x0Ork3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jVNm3Wcc; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22385253e2bso85037285ad.1;
        Tue, 04 Mar 2025 16:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741133165; x=1741737965; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1bX8gifnWEanUXpwx5uYv2DpmwKxBi/IwZcv/puhYts=;
        b=jVNm3WccQR+f57U67i5Jm/VqljCbyurJ3p/THSi6Z1dYLAWjuBzy+Q5t1KOvUtq2R1
         k7FOY3T2X9dcxGL4NwSawO0gu25AlyZZpQys1aST0A2dszUEsbOGpXJdNCnw5cXYV3a3
         eR92iCKleQMvHa95C1Yvo/kwSw5C8j1x0VQHn7ycNuZEbGhf8gebEHZfBInuDJmN5vZv
         3aKIACTKtgSCWKtKdFFDKKOmEg+aC3/3xOkQqnz9pIgdPiXNSRYi5v5JImg5y20+sa8O
         IggXm28a6D/g+R8CHSSdJ7bcde1Ia7eh1JsLeuGsa8XivNXoj+hiwgodg+xm3sDGIB9O
         6JgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741133165; x=1741737965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bX8gifnWEanUXpwx5uYv2DpmwKxBi/IwZcv/puhYts=;
        b=CsWI1X8BQLQUNX51EIDpJWdgCqIgYGUH8IiO48xUhXwKR/pH22A9EXEVCHf91WWiv3
         cCER4DZgIbRfSdf16rxKoyC7CwRsrGq4iPZssb0d9V+H63fbuFWIBqSbkFNQuGJ4av8i
         XLRb1WqxdnbblcjBMeRULjH4y0l56z4Wm8tcwm15ZH7n2GzhSratrlmZ4y2yr3Wj/7r9
         23KClsmz248qJ+WdoZV8INR2cfAKidk8wvnZH9j6XmxFuqImjE/SU4SDz31Ruv6QgSvp
         Kya5PbgeccIWYSb5gIYBUR7Pjf+58cdijIOtZUaj+SASEfW5LrAiHPMnDTjjmc2le8mB
         YMKw==
X-Forwarded-Encrypted: i=1; AJvYcCV0gYEEwOw0vQB55o9+r1x+vFY1kOcznQZ2yQljLCYo9dsNvx+aiQlbPfB+kYtyZWVcjONdNQShkRN1I6A+@vger.kernel.org, AJvYcCV11Dgr859uouODDat5NVjo2Guhimy7DXLViw78+vrh87RrlT9+z1yJQUoF2VlHA8Of4Q0IxGDjJlLU2iFk@vger.kernel.org, AJvYcCWzxtd9AWmKzRwANTZ18mFUMGcEyC2rI5JDrzqlPGAPcElmCTDdx30CTh9BN+SfH9Ry71g=@vger.kernel.org, AJvYcCXq87OmiCJE7w1UHilnk30ScCEhaCKKLURfZYvTwpGHh89Q+htNiwX4VvMtCRxpYtaoE07TC+5R@vger.kernel.org
X-Gm-Message-State: AOJu0YxRVA1KqAOW6v0eqZkNLPlJ/HBcsONIcLURw6jC5n2XMXjD3keG
	LOfbylvk7mLTsjAeGYDpFPKASmjw31CGbABWXPJwHfMLoV0W3NOa
X-Gm-Gg: ASbGncsxBbFupKsWOXMDk+ch2sPEEkCUO9v0Z6tXwnpZcbOVS9ogy2B2qJywlbd7PTL
	dZO5JAEei639/qRNGUlQyGPvML0VDdul2xG+ZCryPJB5aQw4rcKca6CFBrbsPKQb+Gx/FxLnGoT
	HQBz5TQZnK1bDF7BWjKVF9diXXrjRP5qYAGemqRz7gCLZmZdU9AxvrgdFGAxMQAw/eVzKGa2VkU
	xDVj4jzXJuTXgMDxGQ+e67k3JxPyKzuuhM/2DjFeo0Vtv6/uSzkNQqZWFlLkZ4z2hSRKxUVSvmh
	eXXxC/OUS5iJtZQDnpnMxaGLCTUL6VfYuE58o8lhtZBY+Pc8PU3tt3TNBnank15gRw==
X-Google-Smtp-Source: AGHT+IH4ftklKoOo2W4okOysYcXlnHpssR8tMCp5JJW1u2ezJYFalFzx+cpxzztCmDjNwc5X5W1I0w==
X-Received: by 2002:a05:6a00:2311:b0:736:728b:5f1f with SMTP id d2e1a72fcca58-73682c89fb9mr1219777b3a.19.1741133164866;
        Tue, 04 Mar 2025 16:06:04 -0800 (PST)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:2::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7365bb4090csm4251725b3a.35.2025.03.04.16.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 16:06:04 -0800 (PST)
Date: Tue, 4 Mar 2025 16:06:02 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
	Dexuan Cui <decui@microsoft.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <Z8eVanBR7r90FK7m@devvm6277.cco0.facebook.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116172428.311437-1-sgarzare@redhat.com>

On Thu, Jan 16, 2020 at 06:24:25PM +0100, Stefano Garzarella wrote:
> RFC -> v1:
>  * added 'netns' module param to vsock.ko to enable the
>    network namespace support (disabled by default)
>  * added 'vsock_net_eq()' to check the "net" assigned to a socket
>    only when 'netns' support is enabled
> 
> RFC: https://patchwork.ozlabs.org/cover/1202235/
> 
> Now that we have multi-transport upstream, I started to take a look to
> support network namespace in vsock.
> 
> As we partially discussed in the multi-transport proposal [1], it could
> be nice to support network namespace in vsock to reach the following
> goals:
> - isolate host applications from guest applications using the same ports
>   with CID_ANY
> - assign the same CID of VMs running in different network namespaces
> - partition VMs between VMMs or at finer granularity
> 
> This new feature is disabled by default, because it changes vsock's
> behavior with network namespaces and could break existing applications.
> It can be enabled with the new 'netns' module parameter of vsock.ko.
> 
> This implementation provides the following behavior:
> - packets received from the host (received by G2H transports) are
>   assigned to the default netns (init_net)
> - packets received from the guest (received by H2G - vhost-vsock) are
>   assigned to the netns of the process that opens /dev/vhost-vsock
>   (usually the VMM, qemu in my tests, opens the /dev/vhost-vsock)
>     - for vmci I need some suggestions, because I don't know how to do
>       and test the same in the vmci driver, for now vmci uses the
>       init_net
> - loopback packets are exchanged only in the same netns


Hey Stefano,

I recently picked up this series and am hoping to help update it / get
it merged to address a known use case. I have some questions and
thoughts (in other parts of this thread) and would love some
suggestions!

I already have a local branch with this updated with skbs and using
/dev/vhost-vsock-netns to opt-in the VM as per the discussion in this
thread.

One question: what is the behavior we expect from guest namespaces?  In
v2, you mentioned prototyping a /dev/vsock ioctl() to define the
namespace for the virtio-vsock device. This would mean only one
namespace could use vsock in the guest? Do we want to make sure that our
design makes it possible to support multiple namespaces in the future if
the use case arrives?

More questions/comments in other parts of this thread.

Thanks!

- Bobby


