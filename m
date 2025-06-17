Return-Path: <kvm+bounces-49722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F7FADD149
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBDB9179C29
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F2A2EBDD8;
	Tue, 17 Jun 2025 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aSZiIOGW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A512EB5A7
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 15:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750173891; cv=none; b=tOtN+mf+QX6Ps1C754GQ8v1cBwIUxJYNQzFvOewInlGNTGWRXmNk7lW++435YImoqMTx3t5Y4znrsp+bNfZahw7aosGAElc+0hcyItRxiorNoPYfXD5mMdudCRJoZ4Tt1aCPy1LG2od5Eub2zTJZHr2Z6oJLv+qN7iEzSLly4PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750173891; c=relaxed/simple;
	bh=Y8gxeEKFkYw0UIV/IY7FhDkAqzZ2xhiVyi4v6GxhZx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsaKUJtfaf439Ywr8NbC8nErcmMLPBNa2zxUbNcvbZGnbnFa0YLX8dadEG0cvcWFMCgSBnPIIUwOl4nFL3Qz7yn1XI3J75p2h8zhtceQVJaEgIZp13JVUm0ddhNJN/4y5vjCqrZl6EeTqWEt8j44YAaVxMjKP2kybECvXkaB2FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aSZiIOGW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750173888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7t/M+XkM4gCOEnwp8IXnN3sMzd4/YJo/8sq4GFgliY=;
	b=aSZiIOGWwYcXGZ1zK9ihIkDE/h8fofdl+a+ynYHMM9GOvLnWCikeKqFFxrkbc7Zg3bEiGe
	mXn/mfz0mHuEjzm7tGeB5bgVkN3r7MFVlYjP+ynEw9IU1YAKfZ9W2llp1eJclrLZakSR0T
	HozqA4LWB4hDXEdLwoFFWpL7v2vBp1M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-phUDoGELOnK-_EnD41cZgA-1; Tue, 17 Jun 2025 11:24:47 -0400
X-MC-Unique: phUDoGELOnK-_EnD41cZgA-1
X-Mimecast-MFC-AGG-ID: phUDoGELOnK-_EnD41cZgA_1750173886
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4530ec2c87cso30159005e9.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 08:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750173886; x=1750778686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H7t/M+XkM4gCOEnwp8IXnN3sMzd4/YJo/8sq4GFgliY=;
        b=dt084EVPbixh9KeR8/CaJUegwR6AG0scrVyGaCg+QQqcOncEvQJsvk9JUIt2JyxqFO
         iSXKt+L1bpnhrum06xJynVrCgyI6NlZbX5GXYWMITrBnr6JZznEhgvyj/dNIIkO4isKS
         6WVQpDbng/jvIWlP99lGhVtp3JEB0xacNotB1A+iPNoHrgv6TOkm0vE4uNxnzE6beCo7
         n0sIPGRtHmYPTE6dqKCJoxlL+0bgfvsdGdB81+gJOEHFMCc3HVN1cucT1T0Tvjq7NmNw
         qXNi/fiuiy+eugfHf2Vl4v4FCUewAjNVplr/56XVJILseQIBYJXgZ5gmqGfL41NpIhBc
         hCkw==
X-Forwarded-Encrypted: i=1; AJvYcCVcbg5gciWFt7h3enpROHW+9ihjaWgM1aYO0TijbpAgUeHTZasgDI0x+A6KMZNGEZfIg28=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCfvp/e7T/iEEQhNCyiq7gnsYdYKguoVD9J2UnbcCN57+ZiO4O
	KojWrgyNnRVgN4TLddUXhJ0t8HPro+XbbZKizHMfWO8jCmCdf5Q1Txo3lHyS0K7lnxmXl17GoNR
	frX0y0ieuYszimwjGQGrzHOhPpzduWF4BnYl2d65FFIG4IKFendhCnw==
X-Gm-Gg: ASbGncuYgyIfs4DL3MpEI777uCkZVpAyj8+P/y5fDt952bNMNZZmj4onXDWJeS97Kh1
	PKEAomvNmFB2xR3b2EIKpYkM4rRJxTBCBVv8a0kXZ9UgUFBhspr6QIKJhB9YBSo1pVjhWisTqYc
	lwNI43wFGzSxw7H7kylAxTbqDEK0HuWuxE+iH3C3TfA1x+Qyk2/aFYFY2vIyzALXzCUkX9VfVhD
	tkWrDZSlT2GME1QZdjsk6VQ84aaqU1+2BZkIi0mhJaZD3bNPoln9IBd9i/1CkIa4uJrNLCNEjlp
	BslqlhQF/cK+8hKJeTCeZWZfUvCv
X-Received: by 2002:a05:600c:8b01:b0:441:d437:e3b8 with SMTP id 5b1f17b1804b1-4533cac9179mr118929015e9.23.1750173885822;
        Tue, 17 Jun 2025 08:24:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsm6jVbEl2m7WR2NEEu2J8dhq+GSg2FL6XFR2OWFKAilrHXhJdlDK5TX0Ng08O9R8MuoDrjg==
X-Received: by 2002:a05:600c:8b01:b0:441:d437:e3b8 with SMTP id 5b1f17b1804b1-4533cac9179mr118928105e9.23.1750173884572;
        Tue, 17 Jun 2025 08:24:44 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.200.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b089b5sm14100994f8f.48.2025.06.17.08.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 08:24:43 -0700 (PDT)
Date: Tue, 17 Jun 2025 17:24:36 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>, berrange@redhat.com
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH RFC net-next v4 00/11] vsock: add namespace support to
 vhost-vsock
Message-ID: <bgntskdmtb3usi6izcxywuhpvyldnoaxnomub4t7vfclv3xqhx@gjcs5ay4mkyt>
References: <20250616-vsock-vmtest-v4-0-bdd1659c33fb@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250616-vsock-vmtest-v4-0-bdd1659c33fb@meta.com>

CCing Daniel who commented v2.

On Mon, Jun 16, 2025 at 09:32:49PM -0700, Bobby Eshleman wrote:
>This series adds namespace support to vhost-vsock. It does not add
>namespaces to any of the guest transports (virtio-vsock, hyperv, or
>vmci).
>
>The current revision only supports two modes: local or global. Local
>mode is complete isolation of namespaces, while global mode is complete
>sharing between namespaces of CIDs (the original behavior).
>
>If it is deemed necessary to add mixed mode up front, it is doable but
>at the cost of more complexity than local and global modes. Mixed will
>require adding the notion of allocation to the socket lookup functions
>(like vhost_vsock_get()) and also more logic will be necessary for
>controlling or using lookups differently based on mixed-to-global or
>global-to-mixed scenarios.
>
>The current implementation takes into consideration the future need for mixed
>mode and makes sure it is possible by making vsock_ns_mode per-namespace, as for
>mixed mode we need at least one "global" namespace and one "mixed"
>namespace for it to work. Is it feasible to support local and global
>modes only initially?
>
>I've demoted this series to RFC, as I haven't been able to re-run the
>tests after rebasing onto the upstreamed vmtest.sh, some of the code is
>still pretty messy, there are still some TODOs, stale comments, and
>other work to do. I thought reviewers might want to see the current
>state even though unfinished, since I'll be OoO until the second week of
>July and that just feels like a long time of silence given we've already
>all done work on this together.
>
>Thanks again for everyone's help and reviews!
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
>---
>Changes in v3:
>- add notion of "modes"
>- add procfs /proc/net/vsock_ns_mode
>- local and global modes only
>- no /dev/vhost-vsock-netns
>- vmtest.sh already merged, so new patch just adds new tests for NS
>- Link to v2:
>  https://lore.kernel.org/kvm/20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com

Thanks for this!
FYI I'll be off for the next days, I hope to comment next week.

Thanks,
Stefano

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
>Bobby Eshleman (11):
>      selftests/vsock: add NS tests to vmtest.sh
>      vsock: a per-net vsock NS mode state
>      vsock: add vsock net ns helpers
>      vsock: add net to vsock skb cb
>      vsock: add common code for vsock NS support
>      virtio-vsock: add netns to common code
>      vhost/vsock: add netns support
>      vsock/virtio: add netns hooks
>      hv_sock: add netns hooks
>      vsock/vmci: add netns hooks
>      vsock/loopback: add netns support
>
> MAINTAINERS                             |   1 +
> drivers/vhost/vsock.c                   |  48 ++-
> include/linux/virtio_vsock.h            |  12 +
> include/net/af_vsock.h                  |  53 ++-
> include/net/net_namespace.h             |   4 +
> include/net/netns/vsock.h               |  19 ++
> net/vmw_vsock/af_vsock.c                | 203 +++++++++++-
> net/vmw_vsock/hyperv_transport.c        |   2 +-
> net/vmw_vsock/virtio_transport.c        |   5 +-
> net/vmw_vsock/virtio_transport_common.c |  14 +-
> net/vmw_vsock/vmci_transport.c          |   4 +-
> net/vmw_vsock/vsock_loopback.c          |   4 +-
> tools/testing/selftests/vsock/vmtest.sh | 555 +++++++++++++++++++++++++++++---
> 13 files changed, 843 insertions(+), 81 deletions(-)
>---
>base-commit: 8909f5f4ecd551c2299b28e05254b77424c8c7dc
>change-id: 20250325-vsock-vmtest-b3a21d2102c2
>
>Best regards,
>-- 
>Bobby Eshleman <bobbyeshleman@meta.com>
>
>


