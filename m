Return-Path: <kvm+bounces-34977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D839DA085F3
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 04:28:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A27481884B46
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 03:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F30F2054F9;
	Fri, 10 Jan 2025 03:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PC20kvAB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC7E19DF6A
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736479673; cv=none; b=tUoXjp4SxxYzu5Mo6MgKdJWb9VXAgwSMfhdZqB2tTZx1B/FUWoB2fu4JY7qdOe91nYFFoUIXS3dkN3lMyqVGwBGqM0SRDtUaxhdsqLj1umBSNrrItP5Hud/VHEOqfC/cfTdCViEan8NOieDzjA66BlcalXTOnFrCIMmjj2q8Dbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736479673; c=relaxed/simple;
	bh=bvWTIT+RRjRSbxQiao2G4A++ngFStBHKJpnvXhynHk0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dsdb9rGZSRAC8rKeej2h/EBDdDnIUaIYabDZTYJ8HyDyVfZ9nj5Nje+IxoS7P7/0HbMSg1MU0B+tpMyEx3AdM86q+GCSAbrd/7pRNVDeaL5vxRVDElVPy/j9AZXvBBfyxmT9ROj3SYWtDUbVLBXbGv5nhJUmcQnKP3lHg+7rcNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PC20kvAB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736479671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iajL1yDgIUIr5hibojx7mafI5SxR1wepNTMSNzOVtuU=;
	b=PC20kvABsfvfy6Z/+muDX++E9b5N9/eSCbhahHRjoP9miPSAKLG4GFtkR57RMk43jNfWWT
	GmYvdo51Hj7YPd/Ya5SvNMrNJlnohyESVcOzL9rgibiLZMReJKqoiz5R0wA83FQyxciYE3
	MUF+0TDS2mgByOh8EW/5A45JP/fkpCg=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-H2ZVMfmZMT-dL3EHRnqOJw-1; Thu, 09 Jan 2025 22:27:49 -0500
X-MC-Unique: H2ZVMfmZMT-dL3EHRnqOJw-1
X-Mimecast-MFC-AGG-ID: H2ZVMfmZMT-dL3EHRnqOJw
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso3033944a91.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 19:27:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736479668; x=1737084468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iajL1yDgIUIr5hibojx7mafI5SxR1wepNTMSNzOVtuU=;
        b=dIEHT5X5Fcupu8HP74o0LVeyQ676vcTbDoRKLArdriBKeLnL/QdKk4SjBAzW8LFY2N
         UmCgBghtk7j3QyWLoZAMoYhjylCa5r6zmv4U5Rb6GIyaKeVquU/eMs+Qdya+Dd/q1Ogf
         dHDMIylTh1mJyUuruDZ0S7IIqV3/P0PPdPWNl5m4pB8euxxpDJLAoFf43XSiQ79/klA1
         2Y54Pfltx8HsTyY4TEO9+8HBvhWcCF/3ugqD9LYQq8NRiezJL3aQ6e9TzJViqUxEH+pP
         /1inPn4RM/10lkVGfc7K+rUYWQqk9oxv+4uSi4qkPTRVlVeHrdtfgWucfjpUNNtZPZp/
         Muug==
X-Forwarded-Encrypted: i=1; AJvYcCUmiNjoKdF6Wjg0mueAGaGQC60ZFCbc6LCCCIejlH/dk7dm77LGiwEk9HFQrHrL6KebpJg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy1r92oC+j+EamKN3JA418f9dO6nBkK2aK5Ble0FG6Yjl/sx5e
	7B5+Uwxjm0UnXITuW7Zc3hXOVQpn6vr4hEPnER4PP5kgSTRGiJvv1wuA+JmHaaCSf0FMrPjrPLJ
	TQUYATI1HxrGnZsHN/zyGAWVQnoAY5M7sgibJzt2UYrkiCbcUoPS3A7xnTyuRenJRhDKGL3hF2A
	pud0fGSooeLA5Ikeg5z+pD+2Bu
X-Gm-Gg: ASbGncsXJWwYAG4sb6tsMC0rOTe4ep/FT29TSq103au/mHL2jfHCvnpze5OQhKl+ZXR
	PZgnjQKcAn3SiNM1I1hdZG+6N/Qq2Ry5QTMcpAug=
X-Received: by 2002:a17:90b:2f4e:b0:2ee:f550:3848 with SMTP id 98e67ed59e1d1-2f548e98ea9mr13264772a91.5.1736479668662;
        Thu, 09 Jan 2025 19:27:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEM0zVlBA7j66fikaniieFtidBDy2a+ngdaxzHXHvpNz92dgP0y0YBOPXi63aR37F36fwt1W0RporavDwFYaFI=
X-Received: by 2002:a17:90b:2f4e:b0:2ee:f550:3848 with SMTP id
 98e67ed59e1d1-2f548e98ea9mr13264741a91.5.1736479668256; Thu, 09 Jan 2025
 19:27:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com> <20250109-tun-v2-2-388d7d5a287a@daynix.com>
In-Reply-To: <20250109-tun-v2-2-388d7d5a287a@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 10 Jan 2025 11:27:23 +0800
X-Gm-Features: AbW1kvblvM77hJwOCPbcZnQaLsOAKege2X0nqRs93PNDqFsP8xaZKCI_l-JSk84
Message-ID: <CACGkMEs73Pms5FB3ouzrLsDjAsQ4OhMMDVD2LnO6kVHCsN0A0w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] tun: Pad virtio header with zero
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, devel@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 2:59=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix.=
com> wrote:
>
> tun used to simply advance iov_iter when it needs to pad virtio header,
> which leaves the garbage in the buffer as is. This is especially
> problematic when tun starts to allow enabling the hash reporting
> feature; even if the feature is enabled, the packet may lack a hash
> value and may contain a hole in the virtio header because the packet
> arrived before the feature gets enabled or does not contain the
> header fields to be hashed. If the hole is not filled with zero, it is
> impossible to tell if the packet lacks a hash value.

I'm not sure I will get here, could we do this in the series of hash report=
ing?

>
> In theory, a user of tun can fill the buffer with zero before calling
> read() to avoid such a problem, but leaving the garbage in the buffer is
> awkward anyway so fill the buffer in tun.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  drivers/net/tun_vnet.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/tun_vnet.c b/drivers/net/tun_vnet.c
> index fe842df9e9ef..ffb2186facd3 100644
> --- a/drivers/net/tun_vnet.c
> +++ b/drivers/net/tun_vnet.c
> @@ -138,7 +138,8 @@ int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
>         if (copy_to_iter(hdr, sizeof(*hdr), iter) !=3D sizeof(*hdr))
>                 return -EFAULT;
>
> -       iov_iter_advance(iter, sz - sizeof(*hdr));
> +       if (iov_iter_zero(sz - sizeof(*hdr), iter) !=3D sz - sizeof(*hdr)=
)
> +               return -EFAULT;
>
>         return 0;

There're various callers of iov_iter_advance(), do we need to fix them all?

Thanks

>  }

>
> --
> 2.47.1
>


