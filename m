Return-Path: <kvm+bounces-21507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8C592FB49
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:26:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4157D1F236B5
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 13:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6E016F854;
	Fri, 12 Jul 2024 13:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1kEq6mb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564431607B2
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720790796; cv=none; b=uhLKf3MBkrzGw3r7hYUXH7jD4L0wgQ5FiBnQKYx8L10snS7979FchQxkOiOE+rU5zAtSDLoYCNfKM5JotBd1/cfRB78iVlUseTNdF7HWAQH5U4VeCsNwX0lEBGzVQ7WxEWpTTUd2Tgks/GcoHpBEF+70TYbGOyxw5Xh9ANhqoaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720790796; c=relaxed/simple;
	bh=yP+gikirY68y1mP4tbKsERt4GV0Ngzxx930DNfOnETM=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=BTJ7nZyz0uiwpDBRxLNVli/InB71yZubUd1z4CAfJpy/1sGtRYXy763IzQ99B+ZOC72CNpvjRdZe9+ZJZntb5TnS2yQWECjgJ5b5gvwnVEnyji7f7NxSn7eI/AGysSUk8gEXczW8n58Y1KrIWNpD9jj3VM6u8NJGvQ2un61u4XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y1kEq6mb; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4266edee10cso12520275e9.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 06:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720790794; x=1721395594; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WRaxXJtqVkP2b8HLkqdchK/gjIX5CJaUYeUCjWBwrdo=;
        b=Y1kEq6mbOIMoxSoIcGG6vLFqJAtQhdEQl/0sK72a4LuyBQxx0JGuEf+hBGPHhjwxox
         RdDfTsKYPbdsW+Sxh/4saE8mgtddTjDSS/3LjIPrGdx0Q/W0cHwYoDE2c4BEYAa8BL2/
         9JHkN11m8qTgJ7ilhDfy9rhglfHLW0C0HtF6idQ6A45l37poLPkyvBFaujTGllQzX7mo
         SvasnHM5balro/e2hZFAnUEHtrkR5D0Fc9UCJHa6nmu+p+pnJ4Wmm8PR0sckMOs+TBQT
         0wqpabVK4joVjQBb6ly1FislZcY+TUBY035e6lOX56+D1i23Vgdib3YW0YUtXzaHbx0U
         x7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720790794; x=1721395594;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRaxXJtqVkP2b8HLkqdchK/gjIX5CJaUYeUCjWBwrdo=;
        b=rTzFz0m6dBQS0TwGZ9RcqdfwSLln3QEE4nyOyEZ6Qy3+jaiVJyGyrazWc0QtxxYro1
         u5rJ+ME++M8hlCUGlOGZ7uQ/AYt6ihlqjGw5vuxTHUPS/O1Ut+2NHKyR7QGhrXooJmGX
         td7d4kwR/fQ9l0s8XRU7BxYpaDIGY1Jk1L5XRU0cjSZQcumxAbGN4EPq5tfgJwC70E7o
         L0uqMwP6/qXpVTuAJ1vNE/TVy5H00DOYM4iELx0Dzp1M5BoB9Qkt9P20y/LrymMAWDtt
         wb/EUfGGCAzf4wROLUAaFfTZA+KohM6DGRWxqcLzW7BfbbxtA+R+IxEWmUPAc4TTDPJ+
         hbGA==
X-Forwarded-Encrypted: i=1; AJvYcCV90XSwj6vfbeh9/3tR5XCRRD5swbAT6vpBElkeyk+Gu+61Rb3jKjMPXTIV9zgKz34fuFtKCCglFXseebkzGT/DZs/g
X-Gm-Message-State: AOJu0YxRSFlto4lMhvBJOW1XiK0qbSAHDuHGsPRPN70ZtwwYr0et2afF
	bJoW/P+e6Mp+6FOKMwxR7vv8fpX5Di3bqAGhTF5vgE2CTSqHb/e9I0rbeW7MTWY=
X-Google-Smtp-Source: AGHT+IHLA3QDS1vQJgYjXS+QBQ7Pe94aD1CyRp2hu200Cs7Kc74DGJDJZxppaTAlO8bki6VDe/PUZQ==
X-Received: by 2002:a05:600c:3042:b0:426:6eb9:2643 with SMTP id 5b1f17b1804b1-426707d890amr74774575e9.11.1720790793445;
        Fri, 12 Jul 2024 06:26:33 -0700 (PDT)
Received: from [192.168.9.51] (54-240-197-232.amazon.com. [54.240.197.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f266067sm23730955e9.13.2024.07.12.06.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 06:26:33 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <2f8e6511-db00-4868-97de-63daa904d83f@xen.org>
Date: Fri, 12 Jul 2024 15:26:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] KVM: Support poll() on coalesced mmio buffer fds
To: Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com
Cc: pdurrant@amazon.co.uk, dwmw@amazon.co.uk, Laurent.Vivier@bull.net,
 ghaskins@novell.com, avi@redhat.com, mst@redhat.com,
 levinsasha928@gmail.com, peng.hao2@zte.com.cn, nh-open-source@amazon.com
References: <20240710085259.2125131-1-ilstam@amazon.com>
 <20240710085259.2125131-4-ilstam@amazon.com>
Content-Language: en-US
Reply-To: paul@xen.org
Organization: Xen Project
In-Reply-To: <20240710085259.2125131-4-ilstam@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/07/2024 10:52, Ilias Stamatis wrote:
> There is no direct way for userspace to be notified about coalesced MMIO
> writes when using KVM_REGISTER_COALESCED_MMIO. If the next MMIO exit is
> when the ring buffer has filled then a substantial (and unbounded)
> amount of time may have passed since the first coalesced MMIO.
> 
> To improve this, make it possible for userspace to use poll() and
> select() on the fd returned by the KVM_CREATE_COALESCED_MMIO_BUFFER
> ioctl. This way a userspace VMM could have dedicated threads that deal
> with writes to specific MMIO zones.
> 
> For example, a common use of MMIO, particularly in the realm of network
> devices, is as a doorbell. A write to a doorbell register will trigger
> the device to initiate a DMA transfer.
> 
> When a network device is emulated by userspace a write to a doorbell
> register would typically result in an MMIO exit so that userspace can
> emulate the DMA transfer in a timely manner. No further processing can
> be done until userspace performs the necessary emulation and re-invokes
> KVM_RUN. Even if userspace makes use of another thread to emulate the
> DMA transfer such MMIO exits are disruptive to the vCPU and they may
> also be quite frequent if, for example, the vCPU is sending a sequence
> of short packets to the network device.
> 
> By supporting poll() on coalesced buffer fds, userspace can have
> dedicated threads wait for new doorbell writes and avoid the performance
> hit of userspace exits on the main vCPU threads.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>   virt/kvm/coalesced_mmio.c | 20 ++++++++++++++++++++
>   virt/kvm/coalesced_mmio.h |  1 +
>   2 files changed, 21 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


