Return-Path: <kvm+bounces-38655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2435EA3D38B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 09:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B52D27A9AA7
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31EDF1EE039;
	Thu, 20 Feb 2025 08:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a4XvJ+kb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7E31E9B1D
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 08:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740041123; cv=none; b=pT2XTR/1VEk7/c0eQ2e6VxDqorP/ko6hUSHi+rwAhUpBSCItma/2M9TwAsx2qA8xI4F+9SafxT9allhKHyfDYtRkZYTJKOMTdy7B8dWA/oBPPotJHpda6dA0UG7YIaExD/KahES5QGIjw3elxBxZHNCqDUx6EFJ+wBEKZv44a9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740041123; c=relaxed/simple;
	bh=0SHhfqD/vA4cGXP3SZz7IhYLrGj9qnR4GeFeMVjfvsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ck2kQe7pq1Kt/YO7c46rPyj19Ba3Y+rBQzVD+0RyXjVEk/7+eAgNXoj/iw4ntcncRWn7FvO5h86OH4dfx5tpIe7JjC0qg3zKpLNW58Dp4V7Cv9h6YO4QuwdI/h7JsUeLhgqBg/X3HoVEnBC0/8tAAhBgVUqBcN5sajoQz6oWA10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a4XvJ+kb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740041120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QowQNzpCtCsCtxr+X2Hdu42nsXJZ78IqGs75xqGcCm4=;
	b=a4XvJ+kbuJe2XWBnByoD0iGYZC5IKY14yZKE9hNO0wdJ7GiYca6Imh1PBvbhbAi3jlj9oO
	2a1xbvjQBWtm7EZNC9tgM7M5Bg2mcIZVzsG/357xYLGGQAEZ4k2U1eTgZCAbxk3gvbgciX
	XPs/0In0ERdyLm/mU5+02Oif6MrLe4Q=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-11YbWPxcO8aRohWLicQzfw-1; Thu, 20 Feb 2025 03:45:19 -0500
X-MC-Unique: 11YbWPxcO8aRohWLicQzfw-1
X-Mimecast-MFC-AGG-ID: 11YbWPxcO8aRohWLicQzfw_1740041117
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-abb87e3a3c9so73937766b.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 00:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740041117; x=1740645917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QowQNzpCtCsCtxr+X2Hdu42nsXJZ78IqGs75xqGcCm4=;
        b=gKI2JCbEVFTlqC/EiKwoCrlUSOT2LFDhf8/UCuKZMqyKrxeb9NsWojJNHpbsOkVeos
         nsghC+CroSKzSvAqU7dyCUrdQ0NKhvD14QgC1RWuKEOgAHCYSbLyyNODEAgRUqggK08R
         xzSw8uaGr/P2/uG1/zvP2Qo4I7wyJSL0XhCEvxhkiOyplQJXKTzcjanDPT7UwODYYhCc
         zGZiysBu0yVc4qpZez9OZ7pUnQ+TLzqngnEgHlYW7xGYBlQPFzsrWuDPsnds9eZcemsN
         mUiqyr7LtvAg6amz8kBA/RZoTeY3OeClf00nh4iN7ks93A6QPXrnuH1ehB05iWyzc3k2
         i2dQ==
X-Forwarded-Encrypted: i=1; AJvYcCVg56CL5tXgqtqh4gqQK0OlYZ9t7aSBaCaVZ1KTrOv9CcQFITGY+FJ+UTQI4L8NbC50VxU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJdpNv+poSEdSEKgzCydFQ/a8oFSFIDVf3BACXVh16AKy1XkH3
	4tT+lAOa1x2HN/zk6QoIoOWC6dCZvw4atx+Aj3tu9AwDlYkMaE/7OyUwpdr/couZj4nenhBzb8v
	n1t+lwHcT3u8q0ioNPUfDkIPoSSVd3/Ypijk0PZi1ZDiBeVF0/g==
X-Gm-Gg: ASbGncv2RHHGeG4SSmAhDNkgEkfKDvUCli6rSdH0ZeqOSBTresl+6a29VIvSAvEcarq
	Q4v87NzorbHzFqLEDpm5Wira1CjUJoZvgQn/rTb2/3/UgHmbIQFO8aDJrcH+jH2stWvtj3Saqw9
	/mUxOwSvqihCjnfuVjLVTE875I7WJobMeXYm1jYGFIJRUBgw4UJn+inyqoESTW8Pc8ou/VCshNu
	uAYG80K3enypB5iyI1YqTuUgHiC0ZKC4AMZdxSEMcw160LaNuigrrHKBLaXHgWONByZ5w==
X-Received: by 2002:a17:906:f5a2:b0:ab7:e3cb:ca81 with SMTP id a640c23a62f3a-abbcce2dce7mr658328766b.30.1740041116659;
        Thu, 20 Feb 2025 00:45:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3dogKAU3XJfB97xx6QDkV7Yj2gPqLTO6qgUQYyB3pQmxLIK3jEJkScPsnctuvKKAeoojJDg==
X-Received: by 2002:a17:906:f5a2:b0:ab7:e3cb:ca81 with SMTP id a640c23a62f3a-abbcce2dce7mr658325866b.30.1740041116195;
        Thu, 20 Feb 2025 00:45:16 -0800 (PST)
Received: from redhat.com ([2.55.163.174])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb9bc1c667sm731938266b.131.2025.02.20.00.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 00:45:15 -0800 (PST)
Date: Thu, 20 Feb 2025 03:45:10 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Andrew Melnychenko <andrew@daynix.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	gur.stavi@huawei.com, devel@daynix.com
Subject: Re: [PATCH net-next v2] tun: Pad virtio headers
Message-ID: <20250220034042-mutt-send-email-mst@kernel.org>
References: <20250215-buffers-v2-1-1fbc6aaf8ad6@daynix.com>
 <d4b7f8a0-db50-4b48-b5a3-f60eab76e96b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4b7f8a0-db50-4b48-b5a3-f60eab76e96b@redhat.com>

On Thu, Feb 20, 2025 at 08:58:38AM +0100, Paolo Abeni wrote:
> Hi,
> 
> On 2/15/25 7:04 AM, Akihiko Odaki wrote:
> > tun simply advances iov_iter when it needs to pad virtio header,
> > which leaves the garbage in the buffer as is. This will become
> > especially problematic when tun starts to allow enabling the hash
> > reporting feature; even if the feature is enabled, the packet may lack a
> > hash value and may contain a hole in the virtio header because the
> > packet arrived before the feature gets enabled or does not contain the
> > header fields to be hashed. If the hole is not filled with zero, it is
> > impossible to tell if the packet lacks a hash value.
> 
> Should virtio starting sending packets only after feature negotiation?
> In other words, can the above happen without another bug somewhere else?


Not if this is connected with a guest with the standard virtio driver, no.
The issue is that tun has no concept of feature negotiation,
and we don't know who uses the vnet header feature, or why.

> I guess the following question is mostly for Jason and Michael: could be
> possible (/would it make any sense) to use a virtio_net_hdr `flags` bit
> to explicitly signal the hash fields presence? i.e. making the actual
> virtio_net_hdr size 'dynamic'.

But it is dynamic - that is why we have TUNSETVNETHDRSZ.



> > In theory, a user of tun can fill the buffer with zero before calling
> > read() to avoid such a problem, but leaving the garbage in the buffer is
> > awkward anyway so replace advancing the iterator with writing zeros.
> > 
> > A user might have initialized the buffer to some non-zero value,
> > expecting tun to skip writing it. As this was never a documented
> > feature, this seems unlikely.
> > 
> > The overhead of filling the hole in the header is negligible when the
> > header size is specified according to the specification as doing so will
> > not make another cache line dirty under a reasonable assumption. Below
> > is a proof of this statement:
> > 
> > The first 10 bytes of the header is always written and tun also writes
> > the packet itself immediately after the 
> > packet unless the packet is
> 
>  ^^^^^ this possibly should be 'virtio header'. Otherwise the sentence
> is hard to follow for me.
> 
> > empty. This makes a hole between these writes whose size is: sz - 10
> > where sz is the specified header size.
> > 
> > Therefore, we will never make another cache line dirty when:
> > sz < L1_CACHE_BYTES + 10
> > where L1_CACHE_BYTES is the cache line size. Assuming
> > L1_CACHE_BYTES >= 16, this inequation holds when: sz < 26.
> > 
> > sz <= 20 according to the current specification so we even have a
> > margin of 5 bytes in case that the header size grows in a future version
> > of the specification.
> 
> FTR, the upcoming GSO over UDP tunnel support will add other 4 bytes to
> the header. but that will still fit the given boundary.
> 
> /P


