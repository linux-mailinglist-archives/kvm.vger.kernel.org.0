Return-Path: <kvm+bounces-10295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD1C86B738
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 19:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2937F1C2592A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 18:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9E571ED8;
	Wed, 28 Feb 2024 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQYoFSpz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB49371EA4
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709145073; cv=none; b=UwnMnfcobtmcIrv99rA6PT9Y4ge2bTVmTNqPI3HIVnDbfLVzHPhIS+AJY1lQhg6y1eWWR+HqaPBoVI9ddV67fHSOL65HVtzHx+RCCgMJn689/28fVMA+cKlm9amOPzTZGgIJcTp6N04jBVkXA2CLjiwNu4A89I79SfSnXPmEZTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709145073; c=relaxed/simple;
	bh=s/2MSjG8UyaUs97mrM1q6zQgCW0Xk0or22c3BdoaHmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TSg5ZagsWKiJRWIhGM6JgPxWrV4xqtTtagr0aEXKmZAZNC66zS860AEcXptBtRE5ls9D0kFEAAGW9d/lRA72BfP44lJ1vRAfyVxM0iE/RnHQQroHTwmSB25n5CJSoD8Mut/nNmcITJPgwA3R5RuvpdBEqtueN47CgVJbAeF1ge8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQYoFSpz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709145070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=weArB08m8SQ4hme6AVbC9RsZWLdEnvH6fsjtADsJEm8=;
	b=EQYoFSpzGoyn70NWVdo+JJF2Iw1nLgMDcEjLJQz9G44/z5KAmrj/goM3y1hTUlqcRSjJcA
	O8aO6BydedIR78Rje2OY2knNitwlXJsxoQbFu2o4yV22LqbPb1+CBa68bTJAbKAH3xyjh5
	woYC/Lal1uB0JE/Vj1Ti9UT14HN/yYs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-2IPtiIplO5GamBK9EOIb6Q-1; Wed, 28 Feb 2024 13:31:07 -0500
X-MC-Unique: 2IPtiIplO5GamBK9EOIb6Q-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d0d313b81so33529f8f.3
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 10:31:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709145066; x=1709749866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weArB08m8SQ4hme6AVbC9RsZWLdEnvH6fsjtADsJEm8=;
        b=o4nMAzaKHf20fgJpiUlyW21GOgNc3ynG5OzzT8sUp2CAvUNlr0jEzDNxyQ+1byYxZL
         5Z4wJWYFJ7wMkbZX3bHgPfnj+5GBDQe34dQpb7UWRmeKLwcLOhVkk7xH4SjN2RgNASrC
         3HknO17W2ySue0KX2HqyEGvZtDN5Jj3cO0t5IvIgfL/ZG0OuAFBPioWNGOPrZDBqMdeT
         TJo8NK3AEB+ulehIYa+h/LOpS4hy/EjezfoubDj6rz+gNM0JArZfWXHLT0p5aPgJC9V9
         GYnlZS8Q4HcfP4kdFin4d7vbP9xeslZ/3KNKUQdCl8Khrd/VkU1AYjCwPBEc94ZXIq3m
         N+bA==
X-Forwarded-Encrypted: i=1; AJvYcCXQOUOnjOzwKfnaiWetlSXfUNwJGhGTF8NXZ4OmSZtS+QkJa0SxY1wEy234Piw+IsplEBx6FRmIHauuO3iM7CexciTD
X-Gm-Message-State: AOJu0YzTr/F6tnuWoCRaxID6LVGlVvUpoLl5TUkLq8W2wXKlxGrwYFX1
	+hLSBIIW4p0SqMVVAkf1/dbtn4Lp5Hbf5gFq4g+a24ZmZLIdW+khYVMAKDjGiQJBkQm2KAZriUJ
	1oxnSpL1snTX4s9bPDYbAcI4ZzD4PSX3l0N1xmj9p4TKGIWy/cQ==
X-Received: by 2002:adf:9bdc:0:b0:33d:50cd:4672 with SMTP id e28-20020adf9bdc000000b0033d50cd4672mr256181wrc.21.1709145066129;
        Wed, 28 Feb 2024 10:31:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbucOOcYdc5E7w1hWPrlSDUK3hHwk9fJn5afQ97oLMcIn3c+BDLdxi5c2NUzfMbk+v1xT5yw==
X-Received: by 2002:adf:9bdc:0:b0:33d:50cd:4672 with SMTP id e28-20020adf9bdc000000b0033d50cd4672mr256168wrc.21.1709145065820;
        Wed, 28 Feb 2024 10:31:05 -0800 (PST)
Received: from redhat.com ([2a02:14f:178:d6b0:a21c:61c4:2098:5db])
        by smtp.gmail.com with ESMTPSA id bx10-20020a5d5b0a000000b0033b2799815csm15646500wrb.86.2024.02.28.10.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 10:31:05 -0800 (PST)
Date: Wed, 28 Feb 2024 13:31:00 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yunjian Wang <wangyunjian@huawei.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, kuba@kernel.org,
	bjorn@kernel.org, magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
	davem@davemloft.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, xudingke@huawei.com,
	liwei395@huawei.com
Subject: Re: [PATCH net-next v2 0/3] tun: AF_XDP Tx zero-copy support
Message-ID: <20240228133035-mutt-send-email-mst@kernel.org>
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

On Wed, Feb 28, 2024 at 07:04:41PM +0800, Yunjian Wang wrote:
> Hi all:
> 
> Now, some drivers support the zero-copy feature of AF_XDP sockets,
> which can significantly reduce CPU utilization for XDP programs.
> 
> This patch set allows TUN to also support the AF_XDP Tx zero-copy
> feature. It is based on Linux 6.8.0+(openEuler 23.09) and has
> successfully passed Netperf and Netserver stress testing with
> multiple streams between VM A and VM B, using AF_XDP and OVS.
> 
> The performance testing was performed on a Intel E5-2620 2.40GHz
> machine. Traffic were generated/send through TUN(testpmd txonly
> with AF_XDP) to VM (testpmd rxonly in guest).
> 
> +------+---------+---------+---------+
> |      |   copy  |zero-copy| speedup |
> +------+---------+---------+---------+
> | UDP  |   Mpps  |   Mpps  |    %    |
> | 64   |   2.5   |   4.0   |   60%   |
> | 512  |   2.1   |   3.6   |   71%   |
> | 1024 |   1.9   |   3.3   |   73%   |
> +------+---------+---------+---------+
> 
> Yunjian Wang (3):
>   xsk: Remove non-zero 'dma_page' check in xp_assign_dev
>   vhost_net: Call peek_len when using xdp
>   tun: AF_XDP Tx zero-copy support


threading broken pls repost.

vhost bits look ok though:

Acked-by: Michael S. Tsirkin <mst@redhat.com>


>  drivers/net/tun.c       | 177 ++++++++++++++++++++++++++++++++++++++--
>  drivers/vhost/net.c     |  21 +++--
>  include/linux/if_tun.h  |  32 ++++++++
>  net/xdp/xsk_buff_pool.c |   7 --
>  4 files changed, 220 insertions(+), 17 deletions(-)
> 
> -- 
> 2.41.0


