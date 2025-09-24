Return-Path: <kvm+bounces-58611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2FA2B985AC
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D15F517A83C
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 06:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9469E2405F8;
	Wed, 24 Sep 2025 06:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="InNExGvC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0367B20DD75
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 06:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758694340; cv=none; b=ZN2NAAZw2RiXuybMm6ctNqxLwJ2yXQkDZoEJ6KQ8zz5T1vso7msV6wwtkIvoy0TAulJy+N7uTHQfZvSNkFLuWNRYaFuBDzy8npRR5fh5u5UU3uhFaafFfukHc1Uhg4UIf2TwIX+B2q/iefAUbRFyjxarag/Ri8be2J/yVd5ZlYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758694340; c=relaxed/simple;
	bh=tIcasXDl46eE1lOkzHTMDyroUWBMIep3XH8fWV0+2/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmFienjuni9Zy8TTVj2r05akNfptlY5o8ZwyXfVfc9y/5+qYQVtM3tcgY+ugpUFM/VI7s142bWnLSN0e6eJT138kYkgaC4Wb17PqgWHFmG5WNfTP3k0j7QQHItTPjyeMH2DueyAKencA/DbhY2IeaSotqxIHra3XDxIcDAdrXZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=InNExGvC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758694338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=obyq5KB9uhio1ASM5ols63AORGaXYSesuJnW+grgIYU=;
	b=InNExGvC9Cae1GGFrXXr0yGGOJprsUV/89JF3heS8oLAN4Z4mBlmZJ/RpVU1Izmji9qJ/v
	UfnJ8sTJ9fTmRyM/COf4q6lQisnhim1kcPInzDrqP8fEQW30Z/ItXO/MPTwQKconNZT+S1
	27YMlUwQq/eD9ccTVUwMSJc6xCW/ytw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-SW_EOb6KPySkOeIyzcD85A-1; Wed, 24 Sep 2025 02:12:09 -0400
X-MC-Unique: SW_EOb6KPySkOeIyzcD85A-1
X-Mimecast-MFC-AGG-ID: SW_EOb6KPySkOeIyzcD85A_1758694328
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so2628921f8f.2
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 23:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758694328; x=1759299128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obyq5KB9uhio1ASM5ols63AORGaXYSesuJnW+grgIYU=;
        b=QuraUKapzcY76LHq/MSkvNp8hCWKcawUZW5/uqHeOlkXg+6za122rhZkTSsNN6exrD
         amm77KuVtJpk8YKbtcWUmIoY5EoMPlX94CdHH0l+Vi9rKPvaxMl80YYUpOK4fP3X9k26
         tH7bCvqOomt4MWQvARgT/v3XR/ZT5K4b2/FOMC/rbalGAEQAYPBejOc/RVRoe77cVSLf
         hJLGIPcpSbHJ7RgtRU+Dkkz4gwPSB3GHNlTJ4m/jA7T5Z8BHWrZGp+5K8BXQKcaR+PvA
         F5TW5x+67OP3ij/KswNhxtKaLA2XPmcVybDnvhiWJgSDHQrq8M7dTkDQJ2TzOS4X0c6A
         joNg==
X-Forwarded-Encrypted: i=1; AJvYcCWdtsAg2A+B7AGaGWuVBrqA8ZQLWs8iQeG940rqUdnTBSPdzmZ/0hJwo58LdOIER6FQTTw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKI5G9kve3VKwVpTZkZVjc3RxrxNy5usEywHHgZAmYSjgOj0Ru
	UhpHU0v1yl2Lp6jdZaWI6qZRMG0Yk3kVojk01QYvHMkVyuROHYCLOwZFSObDnsgxZ5DELAsmjD9
	MavHHo7V4MOWG7JRHNYyoPlrT5voLGbmu7c3Mej8+Qh+CadDC0hpS3w==
X-Gm-Gg: ASbGncvKyix/IDKxLfhCr2t6T5GMVj3NkemSKAIkfN7eDisYLBx67388JtxX0QWGc24
	9eA7JaNzvioClaXA+FzOh0GlxqzahG+AKh0/+po/OOHgveDGh5WEv74X+RlY8nuO650EGzZI+8V
	P0e6bndprg6JTS9Jww6P0npxjtwKHqmjw0UKAwt9O9WZpEJKGq6C+iHTlwbAHDyuVGsJM7YJ25T
	i7eDtk2NmwHZaSF25Pis0oburAfo5yzLOBWX3DIo5hzNm4JkpPYIwEohwDE58qRWaouiTUUhmE9
	2zYbW7DZGS7PckGMQzc4df4b1CuX8w9Dfps=
X-Received: by 2002:a5d:5f55:0:b0:3ec:dc7e:70fa with SMTP id ffacd0b85a97d-405ba7d6567mr4766536f8f.0.1758694327779;
        Tue, 23 Sep 2025 23:12:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFca+XaxCw9iqPFFTMP7I//RvLhGYWDWxxA+SGx262mLacNJmAVtIf5acFtemYSr0M8g8O0pA==
X-Received: by 2002:a5d:5f55:0:b0:3ec:dc7e:70fa with SMTP id ffacd0b85a97d-405ba7d6567mr4766504f8f.0.1758694327222;
        Tue, 23 Sep 2025 23:12:07 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0740841dsm26641949f8f.23.2025.09.23.23.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 23:12:06 -0700 (PDT)
Date: Wed, 24 Sep 2025 02:12:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
Message-ID: <20250924021145-mutt-send-email-mst@kernel.org>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250923105531-mutt-send-email-mst@kernel.org>
 <96058e18-bb1e-46d1-99aa-9fdffb965e44@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96058e18-bb1e-46d1-99aa-9fdffb965e44@tu-dortmund.de>

On Wed, Sep 24, 2025 at 07:59:46AM +0200, Simon Schippers wrote:
> On 23.09.25 16:55, Michael S. Tsirkin wrote:
> > On Tue, Sep 23, 2025 at 12:15:45AM +0200, Simon Schippers wrote:
> >> This patch series deals with TUN, TAP and vhost_net which drop incoming 
> >> SKBs whenever their internal ptr_ring buffer is full. Instead, with this 
> >> patch series, the associated netdev queue is stopped before this happens. 
> >> This allows the connected qdisc to function correctly as reported by [1] 
> >> and improves application-layer performance, see our paper [2]. Meanwhile 
> >> the theoretical performance differs only slightly:
> >>
> >> +------------------------+----------+----------+
> >> | pktgen benchmarks      | Stock    | Patched  |
> >> | i5 6300HQ, 20M packets |          |          |
> >> +------------------------+----------+----------+
> >> | TAP                    | 2.10Mpps | 1.99Mpps |
> >> +------------------------+----------+----------+
> >> | TAP+vhost_net          | 6.05Mpps | 6.14Mpps |
> >> +------------------------+----------+----------+
> >> | Note: Patched had no TX drops at all,        |
> >> | while stock suffered numerous drops.         |
> >> +----------------------------------------------+
> >>
> >> This patch series includes TUN, TAP, and vhost_net because they share 
> >> logic. Adjusting only one of them would break the others. Therefore, the 
> >> patch series is structured as follows:
> >> 1+2: New ptr_ring helpers for 3 & 4
> >> 3: TUN & TAP: Stop netdev queue upon reaching a full ptr_ring
> > 
> > 
> > so what happens if you only apply patches 1-3?
> > 
> 
> The netdev queue of vhost_net would be stopped by tun_net_xmit but will
> never be woken again.

So this breaks bisect. Don't split patches like this please.


> >> 4: TUN & TAP: Wake netdev queue after consuming an entry
> >> 5+6+7: TUN & TAP: ptr_ring wrappers and other helpers to be called by 
> >> vhost_net
> >> 8: vhost_net: Call the wrappers & helpers
> >>
> >> Possible future work:
> >> - Introduction of Byte Queue Limits as suggested by Stephen Hemminger
> >> - Adaption of the netdev queue flow control for ipvtap & macvtap
> >>
> >> [1] Link: 
> >> https://unix.stackexchange.com/questions/762935/traffic-shaping-ineffective-on-tun-device
> >> [2] Link: 
> >> https://cni.etit.tu-dortmund.de/storages/cni-etit/r/Research/Publications/2025/Gebauer_2025_VTCFall/Gebauer_VTCFall2025_AuthorsVersion.pdf
> >>
> >> Links to previous versions:
> >> V4: 
> >> https://lore.kernel.org/netdev/20250902080957.47265-1-simon.schippers@tu-dortmund.de/T/#u
> >> V3: 
> >> https://lore.kernel.org/netdev/20250825211832.84901-1-simon.schippers@tu-dortmund.de/T/#u
> >> V2: 
> >> https://lore.kernel.org/netdev/20250811220430.14063-1-simon.schippers@tu-dortmund.de/T/#u
> >> V1: 
> >> https://lore.kernel.org/netdev/20250808153721.261334-1-simon.schippers@tu-dortmund.de/T/#u
> >>
> >> Changelog:
> >> V4 -> V5:
> >> - Stop the netdev queue prior to producing the final fitting ptr_ring entry
> >> -> Ensures the consumer has the latest netdev queue state, making it safe 
> >> to wake the queue
> >> -> Resolves an issue in vhost_net where the netdev queue could remain 
> >> stopped despite being empty
> >> -> For TUN/TAP, the netdev queue no longer needs to be woken in the 
> >> blocking loop
> >> -> Introduces new helpers __ptr_ring_full_next and 
> >> __ptr_ring_will_invalidate for this purpose
> >>
> >> - vhost_net now uses wrappers of TUN/TAP for ptr_ring consumption rather 
> >> than maintaining its own rx_ring pointer
> >>
> >> V3 -> V4:
> >> - Target net-next instead of net
> >> - Changed to patch series instead of single patch
> >> - Changed to new title from old title
> >> "TUN/TAP: Improving throughput and latency by avoiding SKB drops"
> >> - Wake netdev queue with new helpers wake_netdev_queue when there is any 
> >> spare capacity in the ptr_ring instead of waiting for it to be empty
> >> - Use tun_file instead of tun_struct in tun_ring_recv as a more consistent 
> >> logic
> >> - Use smp_wmb() and smp_rmb() barrier pair, which avoids any packet drops 
> >> that happened rarely before
> >> - Use safer logic for vhost_net using RCU read locks to access TUN/TAP data
> >>
> >> V2 -> V3: Added support for TAP and TAP+vhost_net.
> >>
> >> V1 -> V2: Removed NETDEV_TX_BUSY return case in tun_net_xmit and removed 
> >> unnecessary netif_tx_wake_queue in tun_ring_recv.
> >>
> >> Thanks,
> >> Simon :)
> >>
> >> Simon Schippers (8):
> >>   __ptr_ring_full_next: Returns if ring will be full after next
> >>     insertion
> >>   Move the decision of invalidation out of __ptr_ring_discard_one
> >>   TUN, TAP & vhost_net: Stop netdev queue before reaching a full
> >>     ptr_ring
> >>   TUN & TAP: Wake netdev queue after consuming an entry
> >>   TUN & TAP: Provide ptr_ring_consume_batched wrappers for vhost_net
> >>   TUN & TAP: Provide ptr_ring_unconsume wrappers for vhost_net
> >>   TUN & TAP: Methods to determine whether file is TUN/TAP for vhost_net
> >>   vhost_net: Replace rx_ring with calls of TUN/TAP wrappers
> >>
> >>  drivers/net/tap.c        | 115 +++++++++++++++++++++++++++++++--
> >>  drivers/net/tun.c        | 136 +++++++++++++++++++++++++++++++++++----
> >>  drivers/vhost/net.c      |  90 +++++++++++++++++---------
> >>  include/linux/if_tap.h   |  15 +++++
> >>  include/linux/if_tun.h   |  18 ++++++
> >>  include/linux/ptr_ring.h |  54 +++++++++++++---
> >>  6 files changed, 367 insertions(+), 61 deletions(-)
> >>
> >> -- 
> >> 2.43.0
> > 


