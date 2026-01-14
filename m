Return-Path: <kvm+bounces-68079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A3ED20FDF
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 20:17:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B754A303E414
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 19:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8BD3451C8;
	Wed, 14 Jan 2026 19:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXJ/vuEC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034024502A
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 19:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768418268; cv=none; b=g8NejWQ1Ngc8un+GAaYuFbt/UGweC4P78fOMxQ7UW/g4qR0YtoAqCnyDFj4slXKrMweVLUfC4b1Mh3z6/RspxsK9kyKyEXzpynBTJVJpSezrPBrfI94W+UaihYtYvnYeP6is/y6eR2nNOi7lWoJGkFE5GHVMCSphR+9AGpglZQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768418268; c=relaxed/simple;
	bh=QKRezXrA3bG4ArDBbT58+S8c1CtyAn6iBKaQozySKZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMOh1FMmWdgmaG2BonYuo4ytBcKHJqSQfV6le9UzSTbZum2w/GhIUVJTd0Syl1M0oH5xUsfEZ+EvmOQ5ZDRwmzey86qtY3aJX1zfFgqD6qx7pMWUpHYrvaHVE1Ii/rLUplu03r6h4C0PSjExJYCm1OwqlWsopdeZhZhIyCyF1ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UXJ/vuEC; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-56373f07265so129207e0c.0
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768418266; x=1769023066; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jUpDNPxjIqi9ICJXtc+mfMuxEexyo061EqFw5Nyb8q0=;
        b=UXJ/vuECUYxEuYvgiFN/HfwmivX0Pk2Q3tehWfQKPkDHrEUkmvwexfVavEoT4w5Xkh
         HuPRemHWfYk3wwMTBG6iabYQG++O3kWI9AxSB/8R58H3yHcskjWzf1cQ9MS6+KXKgQAy
         eGkxLXORldulva+ugiiPZDN+/HY2ge5AN77ek9Ax81W1gdd1IUC2AgBF+Zk9edQGnOgV
         15PB7otgec9XyAOP5ilOG3BCpXel/4YPZNWAWSXz86Rolx4Qmbo+lYLu8CQ2kvcod3Ht
         VGYCzScJi3VM0cX1uYQe0sisXm1hk7pAu2LQ/hWUW0OjDsFKTF31LUkE99JyyFp3TWyC
         ZaEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768418266; x=1769023066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUpDNPxjIqi9ICJXtc+mfMuxEexyo061EqFw5Nyb8q0=;
        b=iQbV8gsR0utpJwzhrkWVBEAI0fgd5drEOv8gCA1oklym3QAZcHdodwdGchlvXjVEqB
         ReTcWYhREPLYenjcpvuHS3RXBEFxFRSH9j7VPMmDCQBJmC6Eere5ubh1txT0Qwt/2E4B
         Ri2MowWggHqmDxCWE7mG4o1Ba244PeOHMqd+4qxJnPaCw7OA9H7oOrnMax7tIjac3/C4
         LO7ytdffz59l9EK6RXmGnD1OUmszzk0VEzSfv0iuXhnyEx2cYr7QhevWJORqepU7RLXX
         krar0RCMZzbT5a9d7XZyWl+m6eTrZbE44sU0zIOibsLJPx6Z8JJIXsXJArKM2y8lQgfh
         wNfw==
X-Forwarded-Encrypted: i=1; AJvYcCWdKVtS41IjfwLQ87uEZK4eGHQj30Szmhq8w8F6RWsnZf6OdLM2s8JCIIHy0buJLkHXImU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3E4dtCH/Qqdn5+bdpcimROBcLqMli1mR5wjy4RXD1Wrox4gXK
	S7Il6i7mNkx+uobmD8U2R5qPwpWKb3vL+H49ZPLRH3RPr+aSlwNr4fAbyjoiJA==
X-Gm-Gg: AY/fxX7n3jxXrxbD1EcmLpSYpsh7VyQQ5Ad0ZnCqi3o5vUGC9Sv+tHtENS1aDWuLO/b
	mR9wUYpU6e+G4I9vToL2pjTTrJwPv0TVl/v4pv0ar/PmAqJSwwHSlIhMehGgobGvF5U6gjySQuo
	HJ+pU1aYSAXpb3oxZZ3vXqinyRajDgTGcaBB/ufZHk/7JGDDxcqjbzEtsyrzBUODyx+OUVURkuk
	Q0sS5ftjQVSOxNR5JEZ/diSM9SziPm0X/P0OqAHongKywaUNx4zEqvGIMVqZP/J34NTmWOSsRrY
	vlrbpcd18C2e8OU8P4xMY+H4IIB5usxHw5+74iJ8keBDutXZO3iuDZdUSlhcal6F/JdWENPQfAp
	g/fMauMezHk4HsC0aIamTRl2zgbQQG4uNcdlm/ef4aKFemqafHtgM/CMndBYiStE9g+btsZKUHG
	4NB38l5or0tYN6YkwLnlMjAKTRMiorkFJimw==
X-Received: by 2002:a05:690e:1c06:b0:646:eb06:f2e2 with SMTP id 956f58d0204a3-64903b513d2mr1973243d50.73.1768411311135;
        Wed, 14 Jan 2026 09:21:51 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:5::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790aa6e12ffsm92418037b3.53.2026.01.14.09.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:21:50 -0800 (PST)
Date: Wed, 14 Jan 2026 09:21:49 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: kernel test robot <lkp@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Long Li <longli@microsoft.com>, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org,
	berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH net-next v14 01/12] vsock: add netns to vsock core
Message-ID: <aWfQrS1oNcXwcXu3@devvm11784.nha0.facebook.com>
References: <20260112-vsock-vmtest-v14-1-a5c332db3e2b@meta.com>
 <202601140749.5TXm5gpl-lkp@intel.com>
 <CAGxU2F45q7CWy3O_QhYj0Y2Bt84vA=eaTeBTu+TvEmFm0_E7Jw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F45q7CWy3O_QhYj0Y2Bt84vA=eaTeBTu+TvEmFm0_E7Jw@mail.gmail.com>

On Wed, Jan 14, 2026 at 04:54:15PM +0100, Stefano Garzarella wrote:
> On Wed, 14 Jan 2026 at 00:13, kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Bobby,
> >
> > kernel test robot noticed the following build warnings:
> >
> > [auto build test WARNING on net-next/main]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Bobby-Eshleman/virtio-set-skb-owner-of-virtio_transport_reset_no_sock-reply/20260113-125559
> > base:   net-next/main
> > patch link:    https://lore.kernel.org/r/20260112-vsock-vmtest-v14-1-a5c332db3e2b%40meta.com
> > patch subject: [PATCH net-next v14 01/12] vsock: add netns to vsock core
> > config: x86_64-buildonly-randconfig-004-20260113 (https://download.01.org/0day-ci/archive/20260114/202601140749.5TXm5gpl-lkp@intel.com/config)
> > compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140749.5TXm5gpl-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601140749.5TXm5gpl-lkp@intel.com/
> >
> > All warnings (new ones prefixed by >>, old ones prefixed by <<):
> >
> > >> WARNING: modpost: net/vmw_vsock/vsock: section mismatch in reference: vsock_exit+0x25 (section: .exit.text) -> vsock_sysctl_ops (section: .init.data)
> 
> Bobby can you check this report?
> 
> Could be related to `__net_initdata` annotation of `vsock_sysctl_ops` ?
> Why we need that?
> 
> Thanks,
> Stefano
> 

Yep, no problem.

Best,
Bobby

