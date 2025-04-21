Return-Path: <kvm+bounces-43711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEB9A94B54
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 05:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02E0B3AB181
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 03:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A802571DC;
	Mon, 21 Apr 2025 03:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YT8f8E6q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470B2BA42
	for <kvm@vger.kernel.org>; Mon, 21 Apr 2025 03:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745204908; cv=none; b=ovqvs5F0frnG3vutum7ZaiXa+xa6yuA9p9TvPObXS3zzSl/qpOlRzifP8xS6XNAUTN548uQ7FMD4Fl0/b6JYXRkxjpc8GFy2lXQWsYeGpd23+FbiDfvbRPSOIZchZswym0WU9/ptd66j3Ef/vx0bjocA6pjXeVwFvpzEnUwBSkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745204908; c=relaxed/simple;
	bh=8hivAmNLcvTNx0c/bREHx35jQBHl8GSDmzWxh1wjb3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l5Jtu5uPKt0lRwrxSZZl9S9NOaAOxGZkseW1dA/J7bGiQhey3d6nlXuwIZlpSWOfEy5vX0FSIqGRUfCHosjQ5gFRkXJXq3SZT84bVPe+kbOqbimJKi7Y8ETy/mcwlyy27o9tGnVh1F6a7+plWXxgUOi7D7boNIjPY4la9LpUnmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YT8f8E6q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745204905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8hivAmNLcvTNx0c/bREHx35jQBHl8GSDmzWxh1wjb3U=;
	b=YT8f8E6qZwMh3xSTLCPq4AvWpGUyXxTwEULnxpFUQjvHrcC608BJJ7vmuIDlMDXLdXrC39
	D4Ow+AHjCRimbHQDOx+za+dtMV1bRevXd5F+0InKj1tog4ypcJ4lz2GndjBBiLmwfmFNtX
	GVqk0rnU+bBaFfCU0q/1ylHygINiupg=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-V_DDEzMXN76YRs0zxYt5NA-1; Sun, 20 Apr 2025 23:08:24 -0400
X-MC-Unique: V_DDEzMXN76YRs0zxYt5NA-1
X-Mimecast-MFC-AGG-ID: V_DDEzMXN76YRs0zxYt5NA_1745204903
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3055f2e1486so5317755a91.0
        for <kvm@vger.kernel.org>; Sun, 20 Apr 2025 20:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745204903; x=1745809703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8hivAmNLcvTNx0c/bREHx35jQBHl8GSDmzWxh1wjb3U=;
        b=hzYxrKIOSkNLNiDtP0EbsWXkccMaFh+jZnmG5vR96RYoraf+TKAJVYHXpklVjvNFZD
         mtVXfELHr1BJSuyM16iOCgCNWHW3KsLwvOdhpIFdFmRhE50chJyuKYE41Tr8aaT4gOOZ
         ZFX7M1DRbuxgMmke0tqTeFAf11M31YcHhrqNMLMGvBITIvSjd5OesHipDY6zjStxzAmu
         s7A6+/ZBlbC+927ELNn6i1uaA4eU2SlA08Ba39s4EuuyIHHabINdCR4AZaknBYDG0dLh
         0DBaeF/m8tgl38QxS6sWCdlcNGIgKAktnQpyyZN1op7v/hMgpBj0ppdXKXGZ/Auq3bEk
         jfbw==
X-Forwarded-Encrypted: i=1; AJvYcCU8Xg/x6r9oEQ12CCMM9Wb9Vu8No0kbJ0zRmEpDaQcTge24pIxYoTBYigBLgcQU6GBgt14=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2csHW9Jdp4qDkEP5xS3RfmSwIDeQOm8tJsEzFd0c/Y5KosaPJ
	Xlcfxd61V89jIqAej+0rndgFTfcYr9JEGKJHC6W8OIwddw9g/yRTFUDidHxAssFRUAK4CsiooHA
	ybppv3KgYBW1u4AMAz31tPfLuQm/qfiORIjL13FlC8mbKF8Uu3Za4rakeO4tFvZjlW/Qrdww/dw
	VgtLNZSKSBI0JremKYToNIkZE0
X-Gm-Gg: ASbGncuF8QfOiGbRrnTE/2dAGi0mOPdZbATec5RdRctCFg2cyqculcLU3R2Atlggtne
	SoqtsI2rVutEnpIy5hgdYOaCp9wCjSD739pXR5pjhPCUZ4gGUNVJFOl9oPjIXBdGCU13t3Q==
X-Received: by 2002:a17:90b:2ec3:b0:2ff:4f04:4261 with SMTP id 98e67ed59e1d1-3087bbc9485mr12662287a91.34.1745204902902;
        Sun, 20 Apr 2025 20:08:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsGZidodHER7DPx6AJsb5qX7z5X9GlyzJiQZloe3T04D2Jm+L8lzs+jE/AE1c2bmOaTmkFYJEYHB7563A5Hac=
X-Received: by 2002:a17:90b:2ec3:b0:2ff:4f04:4261 with SMTP id
 98e67ed59e1d1-3087bbc9485mr12662267a91.34.1745204902583; Sun, 20 Apr 2025
 20:08:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403063028.16045-1-dongli.zhang@oracle.com> <20250403063028.16045-5-dongli.zhang@oracle.com>
In-Reply-To: <20250403063028.16045-5-dongli.zhang@oracle.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 21 Apr 2025 11:08:10 +0800
X-Gm-Features: ATxdqUFK2T-i_sGgdtK1QZ96gsa3IRjAzlkSfDUbg2Xu7DWrfBlUunqWMett7BA
Message-ID: <CACGkMEsU2nnTD7akj8im+UBYMjbyyUSAq7U9+uVS8_USAK81eQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] vhost: modify vhost_log_write() for broader users
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, mst@redhat.com, michael.christie@oracle.com, 
	pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com, 
	joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 3, 2025 at 2:32=E2=80=AFPM Dongli Zhang <dongli.zhang@oracle.co=
m> wrote:
>
> Currently, the only user of vhost_log_write() is vhost-net. The 'len'
> argument prevents logging of pages that are not tainted by the RX path.
>
> Adjustments are needed since more drivers (i.e. vhost-scsi) begin using
> vhost_log_write(). So far vhost-net RX path may only partially use pages
> shared via the last vring descriptor. Unlike vhost-net, vhost-scsi always
> logs all pages shared via vring descriptors. To accommodate this,
> use (len =3D=3D U64_MAX) to indicate whether the driver would log all pag=
es of
> vring descriptors, or only pages that are tainted by the driver.
>
> In addition, removes BUG().
>
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


