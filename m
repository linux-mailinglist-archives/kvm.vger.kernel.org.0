Return-Path: <kvm+bounces-47087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F0F1ABD24A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA0A61B65B95
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55884264637;
	Tue, 20 May 2025 08:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ad+UN3aS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF8D266B4B
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 08:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747730902; cv=none; b=SqtjfNRUnvzflT6Dp1f88LgvDflHvaduB/0J1dSzz7hV4cT3hCkw7QqGvWyn504HKRXFmtfEKLJmKkFPtLNniyshMTwHDz+0WgMDfy+AqOTfMESEstYTbq+4lqXtMtk2ZEZ/QX9av165fHSw94EE/6+E9rEOEbhJliKF49jQIEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747730902; c=relaxed/simple;
	bh=nr7R7Fg4ot8hKPSC611voSLfEni8RCjYfnpL6ZiLWEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l7dYBT0Gh2+qLdk/HUi1pcj5v6Rv8MLUMKjebVreJrdIHykalIYYk+fRT0h4vkHw4Y/R8IS4yiP9PPz5H8nwa6LO/x3czyXg9KoLyQI+bfI1wG2vsDor6ST/PsB5XcfksCgYZ2rxFGKSlWb7SyGVNypcwp8zhhGfB3zChxbykXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ad+UN3aS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747730898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9Jdw+1ZYszJBt4wLErRESKCGA4uJXq+gclnU2fYPdK0=;
	b=ad+UN3aSJgGIU+GyTHcqbwSosk9YnsWYOQt3Cjn106Uel9seaN4nOg5Fsx2AYDXBlgCXsX
	ZqLOe/c29Fc/wxXk13/9SGkB3QWICiAKjt7Iazp8KtxPDySiQZZd6qWUbpQUJJrTt7TEe9
	x3vpcTtKfANqK7nLCRDEiOWhAZs3GXU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-X5S9TYSCMgqj5HfAM3uJBA-1; Tue, 20 May 2025 04:48:16 -0400
X-MC-Unique: X5S9TYSCMgqj5HfAM3uJBA-1
X-Mimecast-MFC-AGG-ID: X5S9TYSCMgqj5HfAM3uJBA_1747730896
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-acbbb000796so386964366b.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 01:48:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747730896; x=1748335696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Jdw+1ZYszJBt4wLErRESKCGA4uJXq+gclnU2fYPdK0=;
        b=jxZSrAAFvyIindboPTzqRyvcTr4z/I43AyhisAAbvpEgkEx2TcNr09ADL+8SmYX2AP
         BmrGLZpPYXVbiKO4xveTNXZ2foyJtwcKdtU3oS7crbvBEX5lJ86vo54o9vIr2GlY5xOO
         SL2IUMBt7T+eAHIFt5OCww9qGsezgZZZHskOnX2/WH6ybOCewumXJVS6b4yttnb8Hnth
         KFH0+w1TZha4A53yPjkDGIaLe1EXHMI9I3HzphZVJEt2X267l5MRNPxlzNad1vWE1GST
         2jkIHRJ+Z7IkHvanU+uOuvFpLbQK+XJHib2Cfsk5UMrjOi9bDOfFpRSxfEz67II8CwBd
         4olg==
X-Forwarded-Encrypted: i=1; AJvYcCVzU7AJcAN+A4wMpHHHVz6/5WMQzTtEeHZhhrsDIvbgFDmcuza0UoaASeUgXuzhUvxAVgE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmyMWncvEzuEWXJJd17yPxu1VouPFDOoupnpTe6JyK2yR1tD2l
	QxPO+fHtQVg9Ynfd/IcyNdqwTYPJJ1Lc1qLfYG9Gjy1EfG31MRLU/21If8n+S9e1cLjjbJ0RZv7
	OBoGwA3T+87JaPC28F+CGTWYxPMorvvaDhhK/DaQpSztb3XRslgxpcA==
X-Gm-Gg: ASbGnctJGTS/fcgWmt4TDDO3HI3mX+K1QGhJlc29vB5ZK73EJjSgBxwvB3PTI0OKcxb
	IPZ1lE1YVcQzSCZxjaU05Z+yCZOsLBrT6IhCWCo7UKVPmQI/oAeNYGDFYz1Vl7PsJPPg98Kacde
	F+35PID08OW/9gOKS8R15PkM76bXwOouu6fmkrW7PBJrK165ZUGXmk9Xim51CXDLcfJoKYtKEU7
	sJLR6pJJeoHjiQSVYcxpKQO71wpdBYVesEx0rpAhDZKegogj8EMsfyigICG/NTkTkdo+M4i27LQ
	+bjqjs7Dg4bj7JzPoyEnpJ+UmNa8zhHmx4AbGSsbaG/7lrecLNAHFxkeTSlC
X-Received: by 2002:a17:907:7b97:b0:ad2:50ef:4933 with SMTP id a640c23a62f3a-ad536bca532mr1376484866b.31.1747730895748;
        Tue, 20 May 2025 01:48:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2BHWScPxNpfhTKIVE/UH/c9qw0sXakELnUkTcCcer3v4L/X1iHFZvbAf5Qer6tD/v8Uho5Q==
X-Received: by 2002:a17:907:7b97:b0:ad2:50ef:4933 with SMTP id a640c23a62f3a-ad536bca532mr1376482466b.31.1747730895174;
        Tue, 20 May 2025 01:48:15 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005ac327d5sm6862353a12.63.2025.05.20.01.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 01:48:14 -0700 (PDT)
Date: Tue, 20 May 2025 10:48:10 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, fupan.lfp@antgroup.com, pabeni@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, davem@davemloft.net, 
	stefanha@redhat.com, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH 0/3] vsock: Introduce SIOCINQ ioctl support
Message-ID: <27pwterjsrrvgzcdwgkrfkthbqdaqptj6lj75gzfmhuouilexp@jg4t54gsnw2h>
References: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>

On Mon, May 19, 2025 at 03:06:46PM +0800, Xuewei Niu wrote:
>This patchset introduces SIOCINQ ioctl support for vsock, indicating the
>number of unread bytes.

Thanks for this work, but please use net-next tree since this is a new 
feature: 
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev

Thanks,
Stefano

>
>Similar to SIOCOUTQ ioctl, the information is transport-dependent. The
>first patch introduces a new callback, unread_bytes, in vsock transport,
>and adds ioctl support in AF_VSOCK.
>
>The second patch implements the SIOCINQ ioctl for all virtio-based transports.
>
>The last one adds two test cases to check the functionality. The changes
>have been tested, and the results are as expected.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>
>Xuewei Niu (3):
>  vsock: Add support for SIOCINQ ioctl
>  vsock/virtio: Add SIOCINQ support for all virtio based transports
>  test/vsock: Add ioctl SIOCINQ tests
>
> drivers/vhost/vsock.c                   |   1 +
> include/linux/virtio_vsock.h            |   2 +
> include/net/af_vsock.h                  |   2 +
> net/vmw_vsock/af_vsock.c                |  22 +++++
> net/vmw_vsock/virtio_transport.c        |   1 +
> net/vmw_vsock/virtio_transport_common.c |  17 ++++
> net/vmw_vsock/vsock_loopback.c          |   1 +
> tools/testing/vsock/vsock_test.c        | 102 ++++++++++++++++++++++++
> 8 files changed, 148 insertions(+)
>
>-- 
>2.34.1
>


