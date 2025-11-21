Return-Path: <kvm+bounces-64072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AC7DBC778DF
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 07:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8CE994E7997
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7DF30E85D;
	Fri, 21 Nov 2025 06:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gY8XvawO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZzVotcWN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A284D30E0EA
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 06:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763706007; cv=none; b=DA5t1Wc8gBnV4BqGzWvAcr9JzbXqs52hF+JiNwvSi81qW+mLhVZ+FUeY6jIhkzBzV+6LTse2vhTIIvBAGh7RyY0yKHGyon0BrKU3SvUrjJgOJFT4YS/R9zUvO4OM+hM4vaLabFcE+cY8R5J3LgQ3eD+4bEuHuUWHRTTUWie5RMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763706007; c=relaxed/simple;
	bh=+sXfroQ9+Yeauo6qtLKIrEOaBpAUSForDBLtkR69j+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=asyDCTru9XJSvruIwalfRtKLvZ91MnRJtE2EW2fxvajokABH5P4L1wdcNMgDlZi37li7ozGSbQWmxHvvEqXFXqKw8TMXcAxDcGFlwbwjtTOefOXbWd1QwoY4SHB5gH0D+0z8DRcwhAKDO1K8Pf0sOCVAO6XhAbU9YfjXXEwGlrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gY8XvawO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZzVotcWN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763706002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ggRX1ZqBKGYN1jsO4rritRA352gi7SUTeQqpV7JnIS4=;
	b=gY8XvawOOB+uJOyIJmLSvm1Sn1haPQ59DVgipSEcVRlnriAIxxomcT2/ilZl1WYWnIoSHR
	BgWG18YwKORtCsLhYR32vOypdEQp0SEjm3oOk+7+24t8xQZu9s80fdixBN5lo6I1mHfIfM
	uUBowNItmW8UKcpO4ae/1QjRfNTk7j0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-6Sy7Y0VLO4-Efqyppc8_Pw-1; Fri, 21 Nov 2025 01:20:01 -0500
X-MC-Unique: 6Sy7Y0VLO4-Efqyppc8_Pw-1
X-Mimecast-MFC-AGG-ID: 6Sy7Y0VLO4-Efqyppc8_Pw_1763706000
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-297dde580c8so66892395ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 22:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763706000; x=1764310800; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggRX1ZqBKGYN1jsO4rritRA352gi7SUTeQqpV7JnIS4=;
        b=ZzVotcWNAFIY4wjUHcCDrcmEIFmDnqb6ncnyhk6MxdOM1LD4j8gMTMAg/h/zWUH16v
         AHAu5olHl7VHuJZwv8CqyYjRbmdp/qZHOaI7WPYoVp1/xzTIKrI1tgwRqYnFW4PgcAqU
         QfLipFMCX7dlF7+wyJASakwFOjBnZgNM/xGAAbD+s523wTCiyzn5t4Kt/zm1rxB9x4Ja
         hc/kGKfwHDtIG3Vvj2vVQNyiHuDZpIhfH7OUmL+tkAFqTh8+axsPRnb/ET2MKMvQElUd
         jBKdV6EYmFViVEw7bOtVu026NTZTAiQVav+ZmMNlxHtDBYxazLGrqTBMJrBF4tDIw5XA
         jIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763706000; x=1764310800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ggRX1ZqBKGYN1jsO4rritRA352gi7SUTeQqpV7JnIS4=;
        b=RYk5mD1sVcv1XHp+zziAGJ7MNDPyCuSSUpO6LhKQDAX+Ic9qGSc0IExOSs9R6GDDo7
         jnbZEfLPWOwk7Wrcjovu5eIg5mysNynEKJul2MeSW5YkB6F5MzqwZka3+FYob8ShrLtp
         Nu2l//k8LiZptCS/ttwmIzUhOVxDz9cYX5LRqSH6QHCuHWJ2rzrOgFKaZ7lkMY+Y8ipj
         o8wkSp8nZvrNQdMS2gIC30hvxdMHu84djBki9Je7eHk5CxWAhY40bK3XHOF/KIUlcE81
         cBjgUsq+1IAw3XeJgkk31LukrEE/uciI87NnCxXN+z8fXLDUDW0v4yNdcNe2mWHjoaOW
         G43w==
X-Forwarded-Encrypted: i=1; AJvYcCVg+qXne9h1Ym0jqCxbeEBX6cZKaolLftt+KxVpOugh/3X19bkBlcrjZmcqpZ/KVLolwSY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfAI7t9mud+9z1Y8pxgcESU1PM60U0j3jIBXA1rXYeYP9/HXLG
	8Ui31zuQhEE6wSADK+7lnGRaei1kL9L26d0x2Sn83K07E+U9RK2ePso+HxkEMFIK9UMIjOCa/yJ
	PRRbxKy3PjU/EVxMUT2wh5MlfPGncGuC9MyYy0dgTeTK/+HUrSxl37YU2LKZrzcSlDoHpCuGk07
	ZC+YSsmdCQqgpkgVVtu04R+VEf+qMP
X-Gm-Gg: ASbGncvK12qBjmaRLM2b7HBvS1dxRr0HPOiH2joCvu2MsJSO4xc3zvPZDdrWIpQmi/S
	WGwxu4UJ1/jJdV4uy05YcBXa+Xu7zbc2d5+4d1ZLlt4KQlOOYYgTTxFxTMEo2L8S5qHPejqCK99
	xyNX4WmpgL13437FVMPkUlDgwwx64DM2f+vl2E/W/Ra8VauNP0AssKziQ+l9lgZzQVOQ==
X-Received: by 2002:a17:902:d2c8:b0:295:8da5:c634 with SMTP id d9443c01a7336-29b6be7891fmr14962975ad.9.1763706000111;
        Thu, 20 Nov 2025 22:20:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUmADglGq6E7uEJIg62yJdZRoNMyJghNrkeN6DUBkf5vF0UyhiAgyRbE/RfDCtL+AZds6YfvoKcPhuQ6RYwco=
X-Received: by 2002:a17:902:d2c8:b0:295:8da5:c634 with SMTP id
 d9443c01a7336-29b6be7891fmr14962735ad.9.1763705999682; Thu, 20 Nov 2025
 22:19:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
In-Reply-To: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 21 Nov 2025 14:19:48 +0800
X-Gm-Features: AWmQ_blptZAZY5T5Gzybc2BRw6WU6w0JP6uqFpewdXiABFkFXapZqQDd1Zn3LSk
Message-ID: <CACGkMEuboys8sCJFUTGxHUeouPFnVqVLGQBefvmxYDe4ooLfLg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 0/8] tun/tap & vhost-net: netdev queue flow
 control to avoid ptr_ring tail drop
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mst@redhat.com, eperezma@redhat.com, jon@nutanix.com, 
	tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2025 at 11:30=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> This patch series deals with tun/tap and vhost-net which drop incoming
> SKBs whenever their internal ptr_ring buffer is full. Instead, with this
> patch series, the associated netdev queue is stopped before this happens.
> This allows the connected qdisc to function correctly as reported by [1]
> and improves application-layer performance, see our paper [2]. Meanwhile
> the theoretical performance differs only slightly:
>
> +--------------------------------+-----------+----------+
> | pktgen benchmarks to Debian VM | Stock     | Patched  |
> | i5 6300HQ, 20M packets         |           |          |
> +-----------------+--------------+-----------+----------+
> | TAP             | Transmitted  | 195 Kpps  | 183 Kpps |
> |                 +--------------+-----------+----------+
> |                 | Lost         | 1615 Kpps | 0 pps    |
> +-----------------+--------------+-----------+----------+
> | TAP+vhost_net   | Transmitted  | 589 Kpps  | 588 Kpps |
> |                 +--------------+-----------+----------+
> |                 | Lost         | 1164 Kpps | 0 pps    |
> +-----------------+--------------+-----------+----------+

PPS drops somehow for TAP, any reason for that?

Btw, I had some questions:

1) most of the patches in this series would introduce non-trivial
impact on the performance, we probably need to benchmark each or split
the series. What's more we need to run TCP benchmark
(throughput/latency) as well as pktgen see the real impact

2) I see this:

        if (unlikely(tun_ring_produce(&tfile->tx_ring, queue, skb))) {
                drop_reason =3D SKB_DROP_REASON_FULL_RING;
                goto drop;
        }

So there could still be packet drop? Or is this related to the XDP path?

3) The LLTX change would have performance implications, but the
benmark doesn't cover the case where multiple transmission is done in
parallel

4) After the LLTX change, it seems we've lost the synchronization with
the XDP_TX and XDP_REDIRECT path?

5) The series introduces various ptr_ring helpers with lots of
ordering stuff which is complicated, I wonder if we first have a
simple patch to implement the zero packet loss

>
> This patch series includes tun/tap, and vhost-net because they share
> logic. Adjusting only one of them would break the others. Therefore, the
> patch series is structured as follows:
> 1+2: new ptr_ring helpers for 3
> 3: tun/tap: tun/tap: add synchronized ring produce/consume with queue
> management
> 4+5+6: tun/tap: ptr_ring wrappers and other helpers to be called by
> vhost-net
> 7: tun/tap & vhost-net: only now use the previous implemented functions t=
o
> not break git bisect
> 8: tun/tap: drop get ring exports (not used anymore)
>
> Possible future work:
> - Introduction of Byte Queue Limits as suggested by Stephen Hemminger

This seems to be not easy. The tx completion depends on the userspace behav=
iour.

> - Adaption of the netdev queue flow control for ipvtap & macvtap
>
> [1] Link: https://unix.stackexchange.com/questions/762935/traffic-shaping=
-ineffective-on-tun-device
> [2] Link: https://cni.etit.tu-dortmund.de/storages/cni-etit/r/Research/Pu=
blications/2025/Gebauer_2025_VTCFall/Gebauer_VTCFall2025_AuthorsVersion.pdf
>

Thanks


