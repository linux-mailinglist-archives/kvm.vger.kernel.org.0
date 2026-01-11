Return-Path: <kvm+bounces-67659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9D0D0E000
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 01:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 445153022836
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 00:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7754B2AF1B;
	Sun, 11 Jan 2026 00:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GWbu5R2O";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mu3W6dAU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1307C883F
	for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 00:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768090337; cv=none; b=KNEtp9In+9cgLz95Znne7ub/ln5stLcZ0PaTHk5scrKPA2LRAuQ6bBUaMB/XTnFnHgGLoIEcDDb4bl406L+lODOyRrwz7JAlAEoqn3SApLZx10GncKOxk83IULKpxbuME0SXTERJ0dtubTN/rbd85HkVtwhZpTYALbMafDT4O2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768090337; c=relaxed/simple;
	bh=mLWLZ8V/CeaK+tkNrj5VuZDldGSy5v1mTtg2DMNYb/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSmso1/wIJ0uA9nhGSneOQ9PV+DZRyDMkZJZXxlIW2gI77v2ziLdlajLXYtrG1Jin3x7wigaNZ7feVESQ4YKJ3Zp6LDnldTLEstxiZJ+6khU6L9HpoGmlIaoBx3y3N4a5TidiSNEjiEqrKVM3wxfZL4Zlj95ZXr+GcS1N0lm/c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GWbu5R2O; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mu3W6dAU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768090335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rJ92NuxJ/FhkA7sHAwthrAyvDj9go5GB1uGyDHAuqv0=;
	b=GWbu5R2OkHOW1Q6dRltZRMiANuPvs6IRjCQOxp4RvFkyYGj7UUa6g4XA9G3ls7impXskL1
	T0TPI/6Gn6oDC4+SFNTQeJo0iaskfFol2zJP4lXEa2droYI0NKd9m2xHcvsSYyoX1XA4At
	ZimHuwip6MvoYEBwR2MyNRz8FAIpTgQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-TY16nviXNGevuNIwwRZ_eQ-1; Sat, 10 Jan 2026 19:12:13 -0500
X-MC-Unique: TY16nviXNGevuNIwwRZ_eQ-1
X-Mimecast-MFC-AGG-ID: TY16nviXNGevuNIwwRZ_eQ_1768090333
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4776079ada3so52348955e9.1
        for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 16:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768090332; x=1768695132; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rJ92NuxJ/FhkA7sHAwthrAyvDj9go5GB1uGyDHAuqv0=;
        b=mu3W6dAUGHim0Hn7QT5H2ljZEnUp5X0zmSP/8oJdN38ucQYE9KHA7KLn9IZsUmj3z7
         gyqCy/qwhszVUTW7Ar5bhF5GUU/mQIU6URCfYm57MCuK3g4qAIwZx2LH7vW1alXDYAus
         vmM2ctz7a7wawMY/Pt3dCNnlFrmO9tDda+ibYAl7htBeh050CfYfeP/GuRAdaSQJ5IFp
         XTHc8LSqUJFtbSQrVV5dZNqx/9f+imMwIWsGnMmfrHQ2p383vyXu3VAaOc8JCNXPbr27
         8hzBkjw2+Zi+DZSfrhxlpod48bj7F6l6tH/5y8nw3PHClaFHmp9+3ObJdUpF3TRwEgik
         DmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768090332; x=1768695132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rJ92NuxJ/FhkA7sHAwthrAyvDj9go5GB1uGyDHAuqv0=;
        b=sEnD1Yfdwy8p7BVG/5Y9iP46evz1WJ27LQBwLxp/fmgP9nQ0S6Et8lTs+JMQ3pKemp
         gzqpv44f66aQOSN4vOmfMRrW0hPQGXTnlynh9U5wxBydIyTiP0GJq5/NePghZWbkQSAJ
         YR2nP4cEsa6HkbLubqkyYiAkGSJYOf0qI5O2FUwztgThLy5+QiYM8JLZAKBBWYs7ETiT
         r0d2gMY2ZZ6LkRJUV49wenQV/ftk7eIdcvdPRp0BQ35RS4jcTbFv1IY5oabS6QmpCNrM
         E6ygZLFJY2oIdJQNAjeztewqu/d2feXZRE4dnHOThYwHJfcwmPxMcnUiBIalh9ZDXXwU
         HHfg==
X-Forwarded-Encrypted: i=1; AJvYcCXHLJ9OiSSSNzg6ipc+Bj3aEe0YoX8iElvkpgfLa+vu3WcD6FSRN/jdNdg0/TsPCHlBaLc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyw1kQCCTQjA+eVSDgNjE4BLYawaX91AiyNGhztgw5Ma0lIG0a
	94cehNcibb254J+pucV24JlxUZ05F8OOZZBa9PVvxvB48VAhbLhucWXDrF9dAplv2r4sGAmVOIq
	LPgw/M72gd6cUeOyI6Veg61N9YDqGXvAN/HjnEGcTqf8O350GPNda6Q==
X-Gm-Gg: AY/fxX40AKgS7lqzzsycmQTXu5/Odjnu1UmYvhXPLUh121nVYQenGA8fds8xUxeWz8I
	EB3hNNduNdkVSknZCDJHCZPH5BKc0rJK4xeUCnhjd5cpDFPWINd+wk0bOHfE8s7JmZaQHogasTV
	IcEQGAtAMTuRC99mAEju0laSDmW/alcsWelRGrQMqW4mtBDoYrJk+FBcmUvkCgvItwZv12ucHaH
	tas/ARRcEfVRXFjaKZ86B1Kkr8OMF+AnTRDowl79Kn25pZSeJn0zK64l07awYXALND5RTD57FkE
	95YO4x5OkRfzi/h1cvBw9d3aJKsXkH4YmgTvl7EeV5yEsY1QRkViY0OPgKGkHa7g7lpGao8kTv8
	/8EQfhkxePz9EjKrfanXml3MFfZFXgGM=
X-Received: by 2002:a05:600c:4fd0:b0:477:5c58:3d42 with SMTP id 5b1f17b1804b1-47d84b1f7efmr165064645e9.10.1768090332627;
        Sat, 10 Jan 2026 16:12:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnuDsqC9m+l3yDfJUMvz3utaUAG5Ge2RfD+SugU7SA1yuuWtgjR7DEiLIEaKlXtpa9H3hyeA==
X-Received: by 2002:a05:600c:4fd0:b0:477:5c58:3d42 with SMTP id 5b1f17b1804b1-47d84b1f7efmr165064445e9.10.1768090332218;
        Sat, 10 Jan 2026 16:12:12 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f41f5e0sm272650555e9.8.2026.01.10.16.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jan 2026 16:12:11 -0800 (PST)
Date: Sat, 10 Jan 2026 19:12:07 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org,
	berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH RFC net-next v13 00/13] vsock: add namespace support to
 vhost-vsock and loopback
Message-ID: <20260110191107-mutt-send-email-mst@kernel.org>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
 <aWGZILlNWzIbRNuO@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWGZILlNWzIbRNuO@devvm11784.nha0.facebook.com>

On Fri, Jan 09, 2026 at 04:11:12PM -0800, Bobby Eshleman wrote:
> On Tue, Dec 23, 2025 at 04:28:34PM -0800, Bobby Eshleman wrote:
> > This series adds namespace support to vhost-vsock and loopback. It does
> > not add namespaces to any of the other guest transports (virtio-vsock,
> > hyperv, or vmci).
> > 
> > The current revision supports two modes: local and global. Local
> > mode is complete isolation of namespaces, while global mode is complete
> > sharing between namespaces of CIDs (the original behavior).
> > 
> > The mode is set using the parent namespace's
> > /proc/sys/net/vsock/child_ns_mode and inherited when a new namespace is
> > created. The mode of the current namespace can be queried by reading
> > /proc/sys/net/vsock/ns_mode. The mode can not change after the namespace
> > has been created.
> > 
> > Modes are per-netns. This allows a system to configure namespaces
> > independently (some may share CIDs, others are completely isolated).
> > This also supports future possible mixed use cases, where there may be
> > namespaces in global mode spinning up VMs while there are mixed mode
> > namespaces that provide services to the VMs, but are not allowed to
> > allocate from the global CID pool (this mode is not implemented in this
> > series).
> 
> Stefano, would like me to resend this without the RFC tag, or should I
> just leave as is for review? I don't have any planned changes at the
> moment.
> 
> Best,
> Bobby

i couldn't apply it on top of net-next so pls do.


