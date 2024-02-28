Return-Path: <kvm+bounces-10243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A91686AF42
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:36:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C3C41C24934
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4A26CDC4;
	Wed, 28 Feb 2024 12:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="bvKkZ+ZL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2240D145B29
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 12:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709123787; cv=none; b=MaWF4diyEIXEp9HGWN180AyKNhAOGGfM+ISop8cC/H/1LWxYm7tt0gOJ1xl76nMQu+k3HkMGIjo1j5B0+uZFdyTlpUqmkTq/84Ar6pBLRCHOqXO6X8ivSGX64fJZ5y8NbtTFyUozTfjOqZH1oxbTmGLw/V4nSPR5vU/KkUSo1gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709123787; c=relaxed/simple;
	bh=JV34Rsk9Ud6TAluSh/NNnx0sR4WyEiQcLsdy9DEB4qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cq2+QiTtn8bCfQNt3ljARJe9510waHmTVe2sz/g+h4rUPSvfCM8brbPYQtZ5v6Rq4d579rYVLGmarlcoPRiuAUAC7RNe+FiCzeXDc2VOQg2rPMcNmMxLmQ5WORzzTYmELp7yhJGMxtrSIyf19DlaE96pD0/qPvun0CIXW3lisXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=bvKkZ+ZL; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d28e465655so42835811fa.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 04:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1709123783; x=1709728583; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1r218cPQs+vQGXk5W8TMf0lKe2Qttm/rc570dURd+N8=;
        b=bvKkZ+ZLtHNPsb7dGhSPQXPayePNh+6Lmt/DHG7HRPB3V9c7Ppzh+a3Ho/q1fuQrVM
         t9J0NO+bVlMs4wQnKdeckyUIShPMuieGay2SK5BhALFXOyFFB2qQ4A6ArQRP/Xt4jY2u
         bPBxtTIIJDTofbyZjsmVqk05oVSgOVEALDrtGi2XQlrJl0r44lAE1x4hQ077h0Ojxkou
         pq8OeAjQZJkHFmU2x6PR/Ct0QTi8HA1aK4U8EPyPIx3h8sqOJuS2c1yyqPStDZtySXwT
         cf+6V3bevYEdhAzWW1i4nslTOm/IT9XJrPueyQmgOT4hIcW45KxL89D6SfJS2Vau3wZA
         T6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709123783; x=1709728583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1r218cPQs+vQGXk5W8TMf0lKe2Qttm/rc570dURd+N8=;
        b=uWcOS0QqJ76P86YqVYRRXviERLVJsXCfZ1YWT7wAntMFBxdBxCQzzz4Iy/RMbyqxi4
         xHX19jlqnqLDw7LupBxjb1kXvwJ37+T4u2SCQHPTw71pMQnzr10r6hR+4kfqyCQug/EN
         4PMu4q+1jg0qk7MJoQmUDv2/4j8GVbBf+mNs8HltjBQtDo5B5jcAxN+cmm0Y2+o3JY/d
         S1dBFHM7AVuA9mITqAZCCPUvSh6V9UT2QN48uV82GY3bTiCRhbXP4UPmi9IL8pnCl+fs
         VzS7XhmM072+qsl7FGdc4Dl89JT+ey/SdV7mOpTrilJ+hsbLcql8w4F9KM2uKmXv/bJl
         peRg==
X-Forwarded-Encrypted: i=1; AJvYcCXiQMsdKN0sJo97RcDOesZDOjPM2RCQ8i9ZY7SVcihSOXjAzbOs0F4ykTuADJkuZgUwuPZxW6ysxlsNvt9ZDoEq+OtS
X-Gm-Message-State: AOJu0YyQMNMBgR4OsXtg4K69NAWIS72zk5StYl918PXctVZcIL/n0Wxe
	gC6k8dOEpkFCz9POHdOIYf8U2LpX05fX5mABm0Yl2/6aU/MzR4Vzehbl+dzw3vs=
X-Google-Smtp-Source: AGHT+IFb88pLzc0mMMHFWr4GGKTyW9NIU1Fk+9L4Orhc7J610CrnBoBIDGq7iYcyyvZI2ScWuygMWw==
X-Received: by 2002:a2e:99d5:0:b0:2d0:b758:93a5 with SMTP id l21-20020a2e99d5000000b002d0b75893a5mr7831033ljj.18.1709123783116;
        Wed, 28 Feb 2024 04:36:23 -0800 (PST)
Received: from localhost ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id 9-20020a05600c230900b004129018510esm1949803wmo.22.2024.02.28.04.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 04:36:22 -0800 (PST)
Date: Wed, 28 Feb 2024 13:36:19 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Yunjian Wang <wangyunjian@huawei.com>
Cc: mst@redhat.com, willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	kuba@kernel.org, bjorn@kernel.org, magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
	davem@davemloft.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, xudingke@huawei.com,
	liwei395@huawei.com
Subject: Re: [PATCH net-next v2 0/3] tun: AF_XDP Tx zero-copy support
Message-ID: <Zd8ow_KkdzAfnX8l@nanopsycho>
References: <1709118281-125508-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1709118281-125508-1-git-send-email-wangyunjian@huawei.com>

Wed, Feb 28, 2024 at 12:04:41PM CET, wangyunjian@huawei.com wrote:
>Hi all:
>
>Now, some drivers support the zero-copy feature of AF_XDP sockets,
>which can significantly reduce CPU utilization for XDP programs.
>
>This patch set allows TUN to also support the AF_XDP Tx zero-copy
>feature. It is based on Linux 6.8.0+(openEuler 23.09) and has
>successfully passed Netperf and Netserver stress testing with
>multiple streams between VM A and VM B, using AF_XDP and OVS.
>
>The performance testing was performed on a Intel E5-2620 2.40GHz
>machine. Traffic were generated/send through TUN(testpmd txonly
>with AF_XDP) to VM (testpmd rxonly in guest).
>
>+------+---------+---------+---------+
>|      |   copy  |zero-copy| speedup |
>+------+---------+---------+---------+
>| UDP  |   Mpps  |   Mpps  |    %    |
>| 64   |   2.5   |   4.0   |   60%   |
>| 512  |   2.1   |   3.6   |   71%   |
>| 1024 |   1.9   |   3.3   |   73%   |
>+------+---------+---------+---------+
>
>Yunjian Wang (3):
>  xsk: Remove non-zero 'dma_page' check in xp_assign_dev
>  vhost_net: Call peek_len when using xdp
>  tun: AF_XDP Tx zero-copy support

Threading of the patchset seems to be broken. Did you by any chance send
this with "--nothread" git-send-email option?
pw seems to cope fine with this though.


>
> drivers/net/tun.c       | 177 ++++++++++++++++++++++++++++++++++++++--
> drivers/vhost/net.c     |  21 +++--
> include/linux/if_tun.h  |  32 ++++++++
> net/xdp/xsk_buff_pool.c |   7 --
> 4 files changed, 220 insertions(+), 17 deletions(-)
>
>-- 
>2.41.0
>
>

