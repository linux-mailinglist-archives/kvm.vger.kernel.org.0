Return-Path: <kvm+bounces-54220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D06ADB1D3FF
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 10:07:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF2B47ACA7B
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 08:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453E025392C;
	Thu,  7 Aug 2025 08:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fg1Fplfl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9FE242D8C
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 08:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754554017; cv=none; b=dEpCzTJVpwLxOPViMzIPunPLIgsc3hAOZDqB7q1gf9M46gJvOCXmbpa2VZ77Cq8mdO7UYwPalS/DuvjvhRBU8d2fzPWAJjM7mpbnyYXS8gKJJ9sOOmBe3DtFCYQWRkR366WneT3G0Zw4XHx2nzpu3qQZ+D/3gVmrl4NxXqajInQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754554017; c=relaxed/simple;
	bh=u2Il4zcXlbBWcOa6mv3Dqk2LkCaGUlZ1IGfaEMSMzMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FpMqzpPqWGdfraXXqzHhUlqUvaPqEQcMwUdmxC8INnhEiyftuERFU+pklnSfzHUxmYvP/6v7+8qCAcMLAMaE1Yk5p8MhaOZFvkpMynZAcT0Cc88nx1SLXwE/NefpK7VdttxLqHPAGKyAt1IRf2DF7cPr+xDZAg4vPQ4vlaD+wtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fg1Fplfl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754554014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7F/nfJfc6zfGggUKAtMQtDXDSwk2D4R5Dz6fv6UQzEk=;
	b=Fg1FplflcZtNXEjYmw7oWR1vzv5DRNWfqnCBrP2ECR2aWSGoPQgRX0p/py8g44sj6PFX+P
	n/GT8hHhA8T5QyEe0eJiqm6LxVzY7jnHAca9nUptZp5qYGoNp3+oEOkLdoMSn9a3MtHT4Y
	k7QgDuL24c3WItksK5V/3LRQHjJHO0s=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-fHwIxRvfPHqRtKtBQURXvA-1; Thu, 07 Aug 2025 04:06:53 -0400
X-MC-Unique: fHwIxRvfPHqRtKtBQURXvA-1
X-Mimecast-MFC-AGG-ID: fHwIxRvfPHqRtKtBQURXvA_1754554013
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-70e72e81fafso9386077b3.2
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 01:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754554010; x=1755158810;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7F/nfJfc6zfGggUKAtMQtDXDSwk2D4R5Dz6fv6UQzEk=;
        b=A9jurgpcWccldnPCp21GrJB5hwyJUYQmvSt0ojXs0Q96e6FtqubGSJuJq+OxqM62gH
         V9mulyXYUkd1Gx+VP+CVPSZTyojX68DHjea2KKoRe9hA99+ROWfA0tWC0FoZG3EvFxNh
         k1wajME8zvvXLHHk+4psXDRTAFoio5UOPeY/LuR44rZlOug+asUshfgR0ntI9yW+Z+h0
         P6wNiO9nHGNNRM4xIjghlyuYqWrNu60CC/glRusA0lo2XTmBtQ4uR6k5wDbE4dWbiQon
         LUmatttg3UTsfFkZkYe0Hw1cta//U/z+9EIK4npw6JLjG8DpXeKwrhPxO0mYsEBBaq5S
         +p2w==
X-Forwarded-Encrypted: i=1; AJvYcCUHuFe96DCn6sdeRhSUsJ3nzPt8pbirHLG7IsIarkPoBfjLCn8sYOJ0dT135a9jKtlu3vA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbHSLrWdrsS2dDBvBhd0Gho8D6s+xV2IJ/aKU7iMjeEM9zwqhQ
	dGboclp0GAdyNTwRaAyd3/09UcrYwhVdhX1HlsdMUyQ1CAtIzrTPO1MUNcBRNOFTetnNDiCixSd
	LDq3gP8RNH9yJ5ESh2zWLCD8LuwfU43oXat+m5bv63ak75STW3GUQsw==
X-Gm-Gg: ASbGncuTIv+7WjzXK77eMchT6q/3HaqDoANhQnLQT0gi0Q+iBSbNcBi9HPmf/4h3j1g
	EbrB5Ykaw5thrSRrv0MajnEmF3uzzqrec3b8HXIFEchtwk4h/uuNLO2x9rNuLqb87cS3eexCslM
	jtl0Rqc3EetGfxuKgDL1aueie+dYoX4Kuq+kFTGCeH4uy4uHfU/9++gbE70bstc51h4IAyMhgY2
	qLI8mvSwF4DtXwawBeippsZztLg6pENmdztdbRu4dQiTy4aFcpnWnyrWcaR1VYaI3IhXTcNPGiv
	W6QrMTqsLuuDAFfdMK/cAthLgWpAv6IdtnK/St2SN22X/1XW/t9ZIZN6fl/dVk6XShbvYMmLm2r
	pr3rb9XEMXPLP/lU=
X-Received: by 2002:a05:690c:6203:b0:71a:a9c:30dd with SMTP id 00721157ae682-71bcc6d6851mr85321037b3.2.1754554009645;
        Thu, 07 Aug 2025 01:06:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkk4jVdfxkNS66lXJnELQ1c8i2y7wkD6dlYIhb6ZnK84/IDwj2JHOFZ/v+UaqBfCV8rwA6qA==
X-Received: by 2002:a05:690c:6203:b0:71a:a9c:30dd with SMTP id 00721157ae682-71bcc6d6851mr85319947b3.2.1754554008050;
        Thu, 07 Aug 2025 01:06:48 -0700 (PDT)
Received: from sgarzare-redhat (host-79-45-205-118.retail.telecomitalia.it. [79.45.205.118])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a3a9110sm44916537b3.4.2025.08.07.01.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 01:06:47 -0700 (PDT)
Date: Thu, 7 Aug 2025 10:06:35 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH RFC net-next v4 00/12] vsock: add namespace support to
 vhost-vsock
Message-ID: <27a6zuc6wwuixgozhkxxd2bmpiegiat4bkwghvjz6y3wugtjqm@az7j7et7hzpq>
References: <20250805-vsock-vmtest-v4-0-059ec51ab111@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250805-vsock-vmtest-v4-0-059ec51ab111@meta.com>

Hi Bobby,

On Tue, Aug 05, 2025 at 02:49:08PM -0700, Bobby Eshleman wrote:
>This series adds namespace support to vhost-vsock. It does not add
>namespaces to any of the guest transports (virtio-vsock, hyperv, or
>vmci).
>
>The current revision only supports two modes: local or global. Local
>mode is complete isolation of namespaces, while global mode is complete
>sharing between namespaces of CIDs (the original behavior).
>
>Future may include supporting a mixed mode, which I expect to be more
>complicated because socket lookups will have to include new logic and
>API changes to behave differently based on if the lookup is part of a
>mixed mode CID allocation, a global CID allocation, a mixed-to-global
>connection (allowed), or a global-to-mixed connection (not allowed).
>
>Modes are per-netns and write-once. This allows a system to configure
>namespaces independently (some may share CIDs, others are completely
>isolated). This also supports future mixed use cases, where there may 
>be
>namespaces in global mode spinning up VMs while there are
>mixed mode namespaces that provide services to the VMs, but are not
>allowed to allocate from the global CID pool.
>
>Thanks again for everyone's help and reviews!

Thanks for your work!

As I mentioned to you, I'll be off for the next 2 weeks, so I'll take a 
look when I'm back, but feel free to send new versions if you receive 
enough comments on this.

Thanks,
Stefano

>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
>To: Stefano Garzarella <sgarzare@redhat.com>
>To: Shuah Khan <shuah@kernel.org>
>To: David S. Miller <davem@davemloft.net>
>To: Eric Dumazet <edumazet@google.com>
>To: Jakub Kicinski <kuba@kernel.org>
>To: Paolo Abeni <pabeni@redhat.com>
>To: Simon Horman <horms@kernel.org>
>To: Stefan Hajnoczi <stefanha@redhat.com>
>To: Michael S. Tsirkin <mst@redhat.com>
>To: Jason Wang <jasowang@redhat.com>
>To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>To: Eugenio Pérez <eperezma@redhat.com>
>To: K. Y. Srinivasan <kys@microsoft.com>
>To: Haiyang Zhang <haiyangz@microsoft.com>
>To: Wei Liu <wei.liu@kernel.org>
>To: Dexuan Cui <decui@microsoft.com>
>To: Bryan Tan <bryan-bt.tan@broadcom.com>
>To: Vishnu Dasa <vishnu.dasa@broadcom.com>
>To: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
>Cc: virtualization@lists.linux.dev
>Cc: netdev@vger.kernel.org
>Cc: linux-kselftest@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org
>Cc: kvm@vger.kernel.org
>Cc: linux-hyperv@vger.kernel.org
>Cc: berrange@redhat.com
>
>Changes in v4:
>- removed RFC tag
>- implemented loopback support
>- renamed new tests to better reflect behavior
>- completed suite of tests with permutations of ns modes and vsock_test
>  as guest/host
>- simplified socat bridging with unix socket instead of tcp + veth
>- only use vsock_test for success case, socat for failure case (context
>  in commit message)
>- lots of cleanup
>
>Changes in v3:
>- add notion of "modes"
>- add procfs /proc/net/vsock_ns_mode
>- local and global modes only
>- no /dev/vhost-vsock-netns
>- vmtest.sh already merged, so new patch just adds new tests for NS
>- Link to v2:
>  https://lore.kernel.org/kvm/20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com
>
>Changes in v2:
>- only support vhost-vsock namespaces
>- all g2h namespaces retain old behavior, only common API changes
>  impacted by vhost-vsock changes
>- add /dev/vhost-vsock-netns for "opt-in"
>- leave /dev/vhost-vsock to old behavior
>- removed netns module param
>- Link to v1:
>  https://lore.kernel.org/r/20200116172428.311437-1-sgarzare@redhat.com
>
>Changes in v1:
>- added 'netns' module param to vsock.ko to enable the
>  network namespace support (disabled by default)
>- added 'vsock_net_eq()' to check the "net" assigned to a socket
>  only when 'netns' support is enabled
>- Link to RFC: https://patchwork.ozlabs.org/cover/1202235/
>
>---
>Bobby Eshleman (12):
>      vsock: a per-net vsock NS mode state
>      vsock: add net to vsock skb cb
>      vsock: add netns to af_vsock core
>      vsock/virtio: add netns to virtio transport common
>      vhost/vsock: add netns support
>      vsock/virtio: use the global netns
>      hv_sock: add netns hooks
>      vsock/vmci: add netns hooks
>      vsock/loopback: add netns support
>      selftests/vsock: improve logging in vmtest.sh
>      selftests/vsock: invoke vsock_test through helpers
>      selftests/vsock: add namespace tests
>
> MAINTAINERS                             |    1 +
> drivers/vhost/vsock.c                   |   48 +-
> include/linux/virtio_vsock.h            |   12 +
> include/net/af_vsock.h                  |   59 +-
> include/net/net_namespace.h             |    4 +
> include/net/netns/vsock.h               |   21 +
> net/vmw_vsock/af_vsock.c                |  204 +++++-
> net/vmw_vsock/hyperv_transport.c        |    2 +-
> net/vmw_vsock/virtio_transport.c        |    5 +-
> net/vmw_vsock/virtio_transport_common.c |   14 +-
> net/vmw_vsock/vmci_transport.c          |    4 +-
> net/vmw_vsock/vsock_loopback.c          |   59 +-
> tools/testing/selftests/vsock/vmtest.sh | 1088 ++++++++++++++++++++++++++-----
> 13 files changed, 1330 insertions(+), 191 deletions(-)
>---
>base-commit: dd500e4aecf25e48e874ca7628697969df679493
>change-id: 20250325-vsock-vmtest-b3a21d2102c2
>
>Best regards,
>-- 
>Bobby Eshleman <bobbyeshleman@meta.com>
>


