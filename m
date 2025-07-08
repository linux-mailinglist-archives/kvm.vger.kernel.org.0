Return-Path: <kvm+bounces-51781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68BBAAFCE7D
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A16B717F09C
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E122DFA3E;
	Tue,  8 Jul 2025 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fW68dvyS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19542E3708
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 15:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751986902; cv=none; b=r9EdgKF4hR1XBOBKUFfl4opWgIHPtB63ubqEQAUPQHwOenZd1K7R0ABiOcNdlfXewjFzCUIBCoFdcTs3DCiKAKhqNo7e3CeSUGPpYlo5QRptMTWDnDRlJ7DmuPo02vk5vs70aP8u2HDlnu9zy+KAH/7zTli00FEU6+u8xd0OI1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751986902; c=relaxed/simple;
	bh=C6ZZomLbi/zOPxZHt0dlelhB1jqalIFhjULGiIqUaXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u4AhygLxIcceEi8Vt5TYx313tx1WMsRQyj/rLaTMR1uPGabK/2IFlbegvKj3zIDfkETqxHt6mcXhbZvLl1VW137iNUf4DhWGm5kT+ubO1feHddd+N0oC8wQ5gfjo9ML+bhNWd/ncUOgwgsdQ+8xIypPWHtqUh+Pm1RZTQzlNznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fW68dvyS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751986899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rNCOAezgrJfdzw+4fMxXtTnmKKIBw8LaqwRGLVMi54=;
	b=fW68dvySEghsHr7YQE5c9bF+0qIaV8imuI43JCJf8Xc+mwEPjkocq6KGhbqVeF5btLop9j
	HKXBZ74rDvUDZr48Q57j0+JnvCoan8Cz6A7ysw2Xo5pqIesNveTjS4d9nhIqW44gXsGueE
	v87Q7D9BVcBGHe/jtRuReqqHqzyIvWs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-7xgCyWNvNOOVhrLbVIyR5g-1; Tue, 08 Jul 2025 11:01:38 -0400
X-MC-Unique: 7xgCyWNvNOOVhrLbVIyR5g-1
X-Mimecast-MFC-AGG-ID: 7xgCyWNvNOOVhrLbVIyR5g_1751986897
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-454c2c08d36so21080955e9.2
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 08:01:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751986897; x=1752591697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rNCOAezgrJfdzw+4fMxXtTnmKKIBw8LaqwRGLVMi54=;
        b=dkLBEg0/Vfv/vuoPVSWVWZU92EyjGOCldb7oVkeShLQMJ1OBwy+QaHNTcYMXtwLLJf
         o/yxLY9Yq2hEU+M2HA6arp/HGShvtFSkmq96ZIW/vq+msQ7EhVbwxRjb5u3UzoSSaUvj
         v3L0QpfIMkhVPTxOunHe7iLKsqu9zgXPbEPw49BR7iNid9g7fddzxnW+Bzf1YmD9j79z
         y7oD1gfl4zLPp9jdCv1aJtTZt6JMhg8YTRSwKE/3F95WfJdJSqvEYC1MVLZWVLk9tKPi
         mZtvjGkC8TM/HS+0y9Uz7NxfoHHwZcXVNlXCmwBMYBk5ajV3YurJZYgYdV1StKH7lv9D
         hjGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSNPP4IRoC5fFUVZ1c4ZM87Z6vbtmaB7NKILIxrpkM0pKUnVQk/x3gV71LIqf+eoErYdQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVJvYFeIxwuroUksR9hNponIPVpaf3HfHa03dEiL8GAZKKa5tz
	EF3wzArFyqQ/MY4PDjy2UhCc/mAFesePavveIsueQa6cyq8gIkQWfkiIfZWuAOchLY0Wge7I+cw
	ZUybnb7u2s1uoSmu/6N5xb1VMuOmlRa5gkZ3e/iFHH2QcKjWdeawOwQ==
X-Gm-Gg: ASbGncvTrv/vmJnOHkmPxgaeqqK30Ds3AFj2+l7/gL8IwDN3BrhWUFFl2XqED20CE2x
	xSqPWOsePuoBLsG7JPCO8xRBp8Lu7pNwUIHBpbUMjRuwIDzEJ/xKOjYZF+dAei5CWRA7Y6ooFh3
	TDRgPYzEionL/BDWWADfFEHz4QK2v18OASQ8xjp5XifYrHX7vDsep6xG0HcNDAerNx7/iedCxh7
	jKOTzn4u+gzWunB/WYHtZrF7WloTLRgcyYKZsX93hTN6D4XpExVgk1T+uLNmGBHp8dZEQbDVPFh
	2mg8UTPi/U38afM=
X-Received: by 2002:a05:600c:6383:b0:453:8ab5:17f3 with SMTP id 5b1f17b1804b1-454b4ead145mr122676265e9.22.1751986896189;
        Tue, 08 Jul 2025 08:01:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH11Di0CyvGlev4/a65feEHdNV/ENPEJm11VdcvI7y7M2fvSKYNq+cP94W4DlaA+5SIMpmc9A==
X-Received: by 2002:a05:600c:6383:b0:453:8ab5:17f3 with SMTP id 5b1f17b1804b1-454b4ead145mr122674135e9.22.1751986893844;
        Tue, 08 Jul 2025 08:01:33 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:150d:fc00:de3:4725:47c6:6809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47030b9desm13389956f8f.19.2025.07.08.08.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 08:01:33 -0700 (PDT)
Date: Tue, 8 Jul 2025 11:01:30 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 net-next 0/9] virtio: introduce GSO over UDP tunnel
Message-ID: <20250708105816-mutt-send-email-mst@kernel.org>
References: <cover.1751874094.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1751874094.git.pabeni@redhat.com>

On Tue, Jul 08, 2025 at 09:08:56AM +0200, Paolo Abeni wrote:
> Some virtualized deployments use UDP tunnel pervasively and are impacted
> negatively by the lack of GSO support for such kind of traffic in the
> virtual NIC driver.
> 
> The virtio_net specification recently introduced support for GSO over
> UDP tunnel, this series updates the virtio implementation to support
> such a feature.
> 
> Currently the kernel virtio support limits the feature space to 64,
> while the virtio specification allows for a larger number of features.
> Specifically the GSO-over-UDP-tunnel-related virtio features use bits
> 65-69.
> 
> The first four patches in this series rework the virtio and vhost
> feature support to cope with up to 128 bits. The limit is set by
> a define and could be easily raised in future, as needed.
> 
> This implementation choice is aimed at keeping the code churn as
> limited as possible. For the same reason, only the virtio_net driver is
> reworked to leverage the extended feature space; all other
> virtio/vhost drivers are unaffected, but could be upgraded to support
> the extended features space in a later time.
> 
> The last four patches bring in the actual GSO over UDP tunnel support.
> As per specification, some additional fields are introduced into the
> virtio net header to support the new offload. The presence of such
> fields depends on the negotiated features.
> 
> New helpers are introduced to convert the UDP-tunneled skb metadata to
> an extended virtio net header and vice versa. Such helpers are used by
> the tun and virtio_net driver to cope with the newly supported offloads.
> 
> Tested with basic stream transfer with all the possible permutations of
> host kernel/qemu/guest kernel with/without GSO over UDP tunnel support.
> ---
> WRT the merge plan, this is also are available in the Git repository at
> [1]:
> 
> git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_07_07_2025
> 
> The first 5 patches in this series, that is, the virtio features
> extension bits are also available at [2]:
> 
> git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
> 
> Ideally the virtio features extension bit should go via the virtio tree
> and the virtio_net/tun patches via the net-next tree. The latter have
> a dependency in the first and will cause conflicts if merged via the
> virtio tree, both when applied and at merge window time - inside Linus
> tree.
> 
> To avoid such conflicts and duplicate commits I think the net-next
> could pull from [1], while the virtio tree could pull from [2].

Or I could just merge all of this in my tree, if that's ok
with others?

Willem/Jason ok with you?





> ---
> v6 -> v7:
>   - avoid warning in csky build
>   - rebased
> v6: https://lore.kernel.org/netdev/cover.1750753211.git.pabeni@redhat.com/
> 
> v5 -> v6:
>   - fix integer overflow in patch 4/9
> v5: https://lore.kernel.org/netdev/cover.1750436464.git.pabeni@redhat.com/
> 
> v4 -> v5:
>   - added new patch 1/9 to avoid kdoc issues
>   - encapsulate guest features guessing in new tap helper
>   - cleaned-up SET_FEATURES_ARRAY
>   - a few checkpatch fixes
> v4: https://lore.kernel.org/netdev/cover.1750176076.git.pabeni@redhat.com/
> 
> v3 -> v4:
>   - vnet sockopt cleanup
>   - fixed offset for UDP-tunnel related field
>   - use dev->features instead of flags
> v3: https://lore.kernel.org/netdev/cover.1749210083.git.pabeni@redhat.com/
> 
> v2 -> v3:
>   - uint128_t -> u64[2]
>   - dropped related ifdef
>   - define and use vnet_hdr with tunnel layouts
> v2: https://lore.kernel.org/netdev/cover.1748614223.git.pabeni@redhat.com/
> 
> v1 -> v2:
>   - fix build failures
>   - many comment clarification
>   - changed the vhost_net ioctl API
>   - fixed some hdr <> skb helper bugs
> v1: https://lore.kernel.org/netdev/cover.1747822866.git.pabeni@redhat.com/
> 
> Paolo Abeni (9):
>   scripts/kernel_doc.py: properly handle VIRTIO_DECLARE_FEATURES
>   virtio: introduce extended features
>   virtio_pci_modern: allow configuring extended features
>   vhost-net: allow configuring extended features
>   virtio_net: add supports for extended offloads
>   net: implement virtio helpers to handle UDP GSO tunneling.
>   virtio_net: enable gso over UDP tunnel support.
>   tun: enable gso over UDP tunnel support.
>   vhost/net: enable gso over UDP tunnel support.
> 
>  drivers/net/tun.c                      |  58 ++++++--
>  drivers/net/tun_vnet.h                 | 101 +++++++++++--
>  drivers/net/virtio_net.c               | 110 +++++++++++---
>  drivers/vhost/net.c                    |  95 +++++++++---
>  drivers/vhost/vhost.c                  |   2 +-
>  drivers/vhost/vhost.h                  |   4 +-
>  drivers/virtio/virtio.c                |  43 +++---
>  drivers/virtio/virtio_debug.c          |  27 ++--
>  drivers/virtio/virtio_pci_modern.c     |  10 +-
>  drivers/virtio/virtio_pci_modern_dev.c |  69 +++++----
>  include/linux/virtio.h                 |   9 +-
>  include/linux/virtio_config.h          |  43 +++---
>  include/linux/virtio_features.h        |  88 +++++++++++
>  include/linux/virtio_net.h             | 197 ++++++++++++++++++++++++-
>  include/linux/virtio_pci_modern.h      |  43 +++++-
>  include/uapi/linux/if_tun.h            |   9 ++
>  include/uapi/linux/vhost.h             |   7 +
>  include/uapi/linux/vhost_types.h       |   5 +
>  include/uapi/linux/virtio_net.h        |  33 +++++
>  scripts/lib/kdoc/kdoc_parser.py        |   1 +
>  20 files changed, 790 insertions(+), 164 deletions(-)
>  create mode 100644 include/linux/virtio_features.h
> 
> -- 
> 2.49.0


