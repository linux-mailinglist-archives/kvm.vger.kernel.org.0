Return-Path: <kvm+bounces-64238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 373E7C7B6F9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:05:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A882234E402
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BCB2F1FDF;
	Fri, 21 Nov 2025 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNhioqTn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3B2DC34F
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751836; cv=none; b=EJmUw86OVghgsnoPOIvsR92PjB6O4NDv1WLEWBJ9GdcKi7dNvH7Wa0pt14yKlFqev+rPLLcfmIYAp6566N/biYAiQ7FqQ5IK/SCxuuZrd8tUbbGv7TobAQ5fbwuOieeoNYEVG6z9BqdtbQkgW3AMkCLWUUGKFX6vBo1idQvKywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751836; c=relaxed/simple;
	bh=JdSLpTVX2iWVVnKDVSvfFjbJUtvnuhLaoTLA6sfPhAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cer9MRTeyAuncN+nfzUbm5sfaZok4CmaCV69Rlc3yxXRXubLwGuHC3hn+FwCtngnGggzM9IlmNgp7xGCCc9voI2hOsctjwNpGbow2OWlYi1pxyfD9DenNqxPDjO1hYY/59dFSz4MphLBXqzVNvzQaudNM9Upnov2YpmI2OGDSr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CNhioqTn; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-786943affbaso18064327b3.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 11:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763751833; x=1764356633; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsyeuDVu3rFEqJRnWBFG2+MFZuPnp6VpaIUJkyp+gQI=;
        b=CNhioqTna98ViNEPLEESoGMiSL4ryVjexSc1boJ5OPdZl+flEzc7tfmP0lwFD/5ApB
         VHXuhZs5JqWIzTY+pWAep3W3jhNYJ4yWcjNLozw5fwjVtMdPNunqYJUBRlE3De0Q5WDo
         Y2F+zoPCPuavUrjsVU0z1s/UivaUR2FtahPQncqoATjwFBZ1g5+nx0CN2yQrT/jrGmp8
         4TCVRv0DKv4cD2tZR/3odHlTcf+4Py8JhecgmLxu4X3C5+llgnd+5Ed+oPwprBMcabnt
         hkote8jCYhKvcnHFCRT7j6O+pWMpeL4gZbLvT4cGAF9Cd9B61eMgV+8vr9N92By/IT4X
         iodA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751833; x=1764356633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZsyeuDVu3rFEqJRnWBFG2+MFZuPnp6VpaIUJkyp+gQI=;
        b=ZI8dMtRc0PcAG6tjr3at8Sb/m108BOSgNs74muZjhFcJ8ppq746ckPnC2Tcn4Ud+Bg
         jqLMlWljGuvvVKzI5mUyeO+titJSOULiPLZYKJ4bejBGWDAK/EAWhU3uMhkzA9SZlI6Y
         7mIyOg9keT8kEOS8g83LdMNgP5mOI0ZJ4ouy/MDTUfMdDpoi2+xmBipVyqBomA9id+kf
         mHgRifqE/scw39SlFdHyDm+ECny6VOQbinNV28rke58eLPrPvjL9KYwP8rNoSH9ST5Fa
         B1gKqfTAC5ztiLAzWKyDL5adbpCSsvcsQrV3UU87PF/wZJB9AwSEvrVS2ns+X6FRZs9A
         eXRg==
X-Forwarded-Encrypted: i=1; AJvYcCUAET48dFZxcbfK+5UEdF3CiX4xaY6bGw0CP5v8EKCa10dMBsfAhIrZPCF8t3S7gFy5xOA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+Sxt9X0rGt8ctDhc9s521CKVR4+nFBg/nUZIj5nC7j10WiTLs
	J6ssL+jGXP++ZUbv5hOTtwW8jjrsPc1VnT9nXCChbaeig4ZdKmR6TR0w
X-Gm-Gg: ASbGncuo9TLJMIdQT+oqOrGZUd+QZWB5RE7YPJJlmdEM+mgSmKe1j2DLKesQfnV95aC
	2XYUQiq2VJhtlK306vGDTOtN/Sy6HJL/+HmYg2Cs8KTyChKW5dkC2HoZF8RiqRdaNnec35qdq+u
	SjMgTUFyczwqmKG4r5fAmsmqTSrli3ZTa3ET9nLGAQrNrJvDldc6ZHnVg2Yr6flfXVBGRxZpSnu
	A28AJs1lIIudAj7PaS2U+S8B8baeffl+6L5/28DK8MFLWdU05oMnYNxE1EvlxoZVWwNQilXpaXh
	XXCN2owJ3MSBEUp9ku9VrOsMpJ9yyFfw6pwc6UvFtLV2DT5K+j3dOgCLd4KOFNQZq2ZBZh/Jhd6
	IriylJ0MmqiiI5dvLal4/B8zj4r7b6+sNZA/o2YQfOqipJ+cMTie9SkSeLhdIGehM4mgQuTpldU
	JYNEvZf8PSzSTec+c4guCSkbkgUJos6EReTjxzqlYmc/MW8xQ=
X-Google-Smtp-Source: AGHT+IHqdQfTU4t/9nnncQ179liEt9vBvpItMsnoh0ykni1C+JgYJBg/+9EgA2A1pACRXR1G1tNPMQ==
X-Received: by 2002:a05:690e:4298:10b0:63f:aadb:397a with SMTP id 956f58d0204a3-64302ab1807mr1907945d50.55.1763751833308;
        Fri, 21 Nov 2025 11:03:53 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:41::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a7993e2d6sm18040287b3.39.2025.11.21.11.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 11:03:53 -0800 (PST)
Date: Fri, 21 Nov 2025 11:03:51 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kselftest@vger.kernel.org, berrange@redhat.com,
	Sargun Dhillon <sargun@sargun.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v11 05/13] vsock: add netns support to virtio
 transports
Message-ID: <aSC3lwPvj0G6L8Sh@devvm11784.nha0.facebook.com>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
 <20251120-vsock-vmtest-v11-5-55cbc80249a7@meta.com>
 <v6dpp4j4pjnrsa5amw7uubbqtpnxb4odpjhyjksr4mqes2qbzg@3bsjx5ofbwl4>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v6dpp4j4pjnrsa5amw7uubbqtpnxb4odpjhyjksr4mqes2qbzg@3bsjx5ofbwl4>

On Fri, Nov 21, 2025 at 03:39:25PM +0100, Stefano Garzarella wrote:
> On Thu, Nov 20, 2025 at 09:44:37PM -0800, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > Add netns support to loopback and vhost. Keep netns disabled for
> > virtio-vsock, but add necessary changes to comply with common API
> > updates.
> > 
> > This is the patch in the series when vhost-vsock namespaces actually
> > come online.  Hence, vhost_transport_supports_local_mode() is switched
> > to return true.
> > 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > ---
> > Changes in v11:
> > - reorder with the skb ownership patch for loopback (Stefano)
> > - toggle vhost_transport_supports_local_mode() to true
> > 
> > Changes in v10:
> > - Splitting patches complicates the series with meaningless placeholder
> >  values that eventually get replaced anyway, so to avoid that this
> >  patch combines into one. Links to previous patches here:
> >  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-3-852787a37bed@meta.com/
> >  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-6-852787a37bed@meta.com/
> >  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-7-852787a37bed@meta.com/
> > - remove placeholder values (Stefano)
> > - update comment describe net/net_mode for
> >  virtio_transport_reset_no_sock()
> > ---
> > drivers/vhost/vsock.c                   | 47 ++++++++++++++++++------
> > include/linux/virtio_vsock.h            |  8 +++--
> > net/vmw_vsock/virtio_transport.c        | 10 ++++--
> > net/vmw_vsock/virtio_transport_common.c | 63 ++++++++++++++++++++++++---------
> > net/vmw_vsock/vsock_loopback.c          |  8 +++--
> > 5 files changed, 103 insertions(+), 33 deletions(-)
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

If we move the supports_local_mode() changes into this patch (for virtio
and loopback, as I bring up in other discussion), should I drop this
trailer or carry it forward?

Thanks,
Bobby

