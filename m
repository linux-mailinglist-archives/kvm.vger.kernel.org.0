Return-Path: <kvm+bounces-63679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F97BC6CFD9
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CAF994F0D3E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE897320A05;
	Wed, 19 Nov 2025 06:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GZjw09kD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FRDiWheJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D6531CA4C
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 06:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763535319; cv=none; b=a1SL0s7FH9/xw7UbSpUQDPgcy3kwMW2Eji+jAvGd2TI8uo8XAgaSngmNBd3+QAFDBSxD0TMBW+bEzIsC4JNS1JNxkcJagbwpm0sqP66WiDkOKvq7GF5dA5ZXZOaD7KCa6AueUXXe3wxvcWjIxXgu26lPxYYiwkn6jyCxB3Wa3Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763535319; c=relaxed/simple;
	bh=k1goUGFLRnYWiOHlY1f8YG693FK+4R3wtZttzUxNEyk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RLvqGBKBwM9GBnh4ie/JSjRQJwlyKbkd4V4+sxHXeYSvD7inqezHFDeyz0CDHB5AVyTgPFUr77s/mNQ2Ss61XUGnGh3I7x4wTHow6AC1ilbmYLBzP3ikuyovFoMEGYV4WeYdpeUvph5XwWxWI+qnzlorBAihXmZaFd0RFKy3xsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GZjw09kD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FRDiWheJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763535315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=AmF8UtmERypN0SmhorEC/T0EDvndPupXo98es8iiJ+s=;
	b=GZjw09kD9FZXLZXrknYVwW8DqnS58Fx//iJ8xSLQY0rVzEfD4Z1e9BA638upYGtMPkJvtv
	TvlG2vZr6WZY/5JYXxvLZEskP0GeKxo4bwAWdgkLsuitBsUqO4VU/9T23snMieFjb/6Mnx
	K6UvJqvW655jo6pvt7lhPFeHuqyzjFs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-GUkdUfDFMteOiUsuBNEyIA-1; Wed, 19 Nov 2025 01:55:13 -0500
X-MC-Unique: GUkdUfDFMteOiUsuBNEyIA-1
X-Mimecast-MFC-AGG-ID: GUkdUfDFMteOiUsuBNEyIA_1763535312
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-429c5c8ae3bso4261166f8f.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763535312; x=1764140112; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AmF8UtmERypN0SmhorEC/T0EDvndPupXo98es8iiJ+s=;
        b=FRDiWheJQCUef38VkhETmXbjfVs6kaMTDzj+LtnNZV86QlgmgjfrGYzJK4702zjp+C
         RlQBoRW6OWZzwYvkNBqRbv/0I2lRrLwp0btvacufxc17+5hr1tjtQ/S9RY5U4qjC01xI
         GKTxVb+0FgDVkts/rOXEy8wnWV1u7eFiu2jhWTgilYVBLzhH9InlTwJmFznjliRAJUPY
         dRqySYWjUbVqhVVfQnOTDhdwBklaJtHcmnef3u93ZX4TRTOqY72vRKb8YurEqSqPwVYw
         d/HSyYE3m7VobfTd4Leun19NsWCK5ggi22SSrJwN5Rq5aFUFRkR/8TeDbboZwj8wDjrc
         zajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763535312; x=1764140112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AmF8UtmERypN0SmhorEC/T0EDvndPupXo98es8iiJ+s=;
        b=ssCdxI+BtwqfZQh0G+2T3dp/kOHygjLvlM79gxn1sAEO4mJN7igyuStXxSHm1YEpyW
         IAkSPfrIrEW6aGpDPjLPN/UavqInFYG7328lNouOVJyH+kPngWDru6u4GQIL1T/YOymY
         pcesIyqc1p15WdtJHByjfeVm1D4cNVB1FQJUvjBvzKzFZckOGfhpxNpTFh5xBK1jECRJ
         FdCnVRO1qIqWmK4MsNBK4ysozwiYXA7bNWH3O0Fhn7keswvibuA5db3//HXBhsBKD8qs
         vGf6z9Ut+s0V1ykEHih5q+0sKEQHOoYR4nUE3ByBfHY+lxxUMtqt3Qx1pzPlcxqq/j87
         gKCA==
X-Forwarded-Encrypted: i=1; AJvYcCUDzUPVqa+c1OvjOUI1MZ9sz99idYZfvK7qZGEBE9nsKDZlGNSjoIRVoNmGRopG3lIg7U8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0kYW8oehItJD/RS1dwelDnb92qSirdgQZku83zMdtR+RycrTv
	0z3EehXg/ClLRFmiggQrKvhVtDZvaxeau4abSrgk0dVVhVG3n3sUGoPTV14ZKO0aG659b9vmrDS
	NXQnMLJpFB7HluD9lqgePJIJYfGizlhODoPoLaoSX4XFfpTpcUIyvOw==
X-Gm-Gg: ASbGncvuqHaP9umAx+CvlojHY2JL/q7Kwmy2zY05aJV8Hhs7oK3lbhjIrP96QxSsx0g
	zFVD/N3/9aEFQJt5oxG5r+4NzxkfCQ4KV0U0IBcNYGUw0/fvEk6sDXxcbayAVqws0Lm7curWVHG
	2g+xA2fuZJfMBfa23YrEUf0JssVMVooUNLpsVn94+PtpltHC62mm6rfU1lgppVPRbkX6ZSmrFOt
	3swXw1bZO5z42LGVc2Ebzgw7glRQTH/bX1c2P5F0Ykcld3MJH13d86fz6zK3o4h0W0Jm4coiBl6
	L0jjJgl6VJUxu/hfX1Q6poaKONtMzn2b2POkMWMcyoUU10sdOMKbawVdfVdbDP6LejK+4bnjpte
	YAp7vEdkFwYQc6ZWbtNKOfJEfTrtwIw==
X-Received: by 2002:a5d:64e3:0:b0:429:ccd7:9d94 with SMTP id ffacd0b85a97d-42b593954a1mr18869481f8f.51.1763535311783;
        Tue, 18 Nov 2025 22:55:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFfj+W4rZkCy+pTT7CJvO3zJ+eyBS0O5AvHoo22fcnNNP1yE8aTkZfwKuiofxYmEYEMCNpYUQ==
X-Received: by 2002:a5d:64e3:0:b0:429:ccd7:9d94 with SMTP id ffacd0b85a97d-42b593954a1mr18869443f8f.51.1763535311322;
        Tue, 18 Nov 2025 22:55:11 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f0b617sm35673024f8f.31.2025.11.18.22.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 22:55:10 -0800 (PST)
Date: Wed, 19 Nov 2025 01:55:09 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v5 0/2] virtio: feature related cleanups
Message-ID: <cover.1763535083.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent


Cleanup around handling of feature bits:
- address word/dword/qword confusion
- simplify interfaces so callers do not need to
  remember in which 64 bit chunk each bit belongs

changes from v4: address comments by Jason
  move features variable to beginning of block
  unsigned long -> u64 - they are not the same
changes from v3:
  drop an out of date unnecessary kdoc parser change

changes from v2:
- drop unnecessary casts
- rework the interface to use array of bits not


Michael S. Tsirkin (2):
  virtio: clean up features qword/dword terms
  vhost: switch to arrays of feature bits

 drivers/vhost/net.c                    | 39 ++++++++++++------------
 drivers/vhost/scsi.c                   |  9 ++++--
 drivers/vhost/test.c                   | 10 ++++--
 drivers/vhost/vhost.h                  | 42 +++++++++++++++++++++-----
 drivers/vhost/vsock.c                  | 10 +++---
 drivers/virtio/virtio.c                | 12 ++++----
 drivers/virtio/virtio_debug.c          | 10 +++---
 drivers/virtio/virtio_pci_modern_dev.c |  6 ++--
 include/linux/virtio.h                 |  2 +-
 include/linux/virtio_config.h          |  2 +-
 include/linux/virtio_features.h        | 29 +++++++++---------
 include/linux/virtio_pci_modern.h      |  8 ++---
 12 files changed, 109 insertions(+), 70 deletions(-)

-- 
MST


