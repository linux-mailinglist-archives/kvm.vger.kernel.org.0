Return-Path: <kvm+bounces-50436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A50AE58DF
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 02:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F3A17A101C
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 00:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0798185E4A;
	Tue, 24 Jun 2025 00:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d+ajUn66"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5933C2F2A
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 00:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750726708; cv=none; b=u1ar9sePIzSPDrDbLv5HaMaMTjunTkA9+YkpNPx/cczUdRNAwXGg8rtz+GpGV/LNgvTcqphul1dIke2VCGFMptHAUrFI4d6FfFdiinXAVVK0qPOeVg3uURqD+WxT0XjAUX33ukv6q0xZLIDT1TIXD/6IcKXyzBdAa0qQMeLnCl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750726708; c=relaxed/simple;
	bh=crI2KdpBxTyiOor4cigyt5k0bB0F42uVbGkqQawR4mQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a0d1UGbVNfWBFLnudywbcGacwxKnS/7DoKmmYD0PZ/51ywpv6TRc4a2pd8TSOLCmB8OP23zg1V888yE28TS/U1B4ChuWhtr0xJIxT8247s8v24yF/ALssRM4mDtphkKu0m4vMGfty/yiAMdVmE8h3O2eVbpaoSjWAqyzH0lHnrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d+ajUn66; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750726706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=crI2KdpBxTyiOor4cigyt5k0bB0F42uVbGkqQawR4mQ=;
	b=d+ajUn66D343BoeRSmK0rVb1EXLzfd7j9iC2ZEOONROWgL5LMgfMTcVHbziM6odMwsezSH
	y91iV7VUaqWTlMu6dNGzqNFDLNVy3c2saoOl7wPBOPmFad0lMCX+5uBEfGdNnBP4C0BwKH
	I/1V2A1+InrKjQiT0NQKmB+3bD69Dxk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-RtDUnIrKPyazpKc7dWlXaw-1; Mon, 23 Jun 2025 20:58:19 -0400
X-MC-Unique: RtDUnIrKPyazpKc7dWlXaw-1
X-Mimecast-MFC-AGG-ID: RtDUnIrKPyazpKc7dWlXaw_1750726698
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-315af08594fso2479274a91.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 17:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750726698; x=1751331498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crI2KdpBxTyiOor4cigyt5k0bB0F42uVbGkqQawR4mQ=;
        b=GtOVbdYbkjn7hpjYCuqtJiWtNr0ZeWd9uODJQdmiJorUX6u3XgA3/6onl5yD3yFiG+
         G5TF/d2ZEqCf0c7YCMkCDEAAcdkrcjslxEfnuTJy/po+At7d3Fg86w1kiXIxiP3701+H
         pL799xjZBTeDQFxRstSOBosJr/TnsMaNHA5PkFwwd9m7MPS6wyW0aWw5viYOwfKqNOeH
         +eRUeWid6NZYpMipxmQogZDK1bpVtYM9C1djxMneR99IwNTaM+w/tNm3bhGVIEmTPH1F
         EO0V+/u0rSpwB9uO5GE84txS+q1gxAibsJBShCZSewaAMfYCD01s4xGW9leIvyYsjoTr
         Y9+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWzzeHdZu7R5rh2/S0oV2AILezDC3EFUGHjLO23P01lMSPK6WhlljLzwDZfT1MMJf6IcA8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo/RkF6Digz9Y58URIFyygOWhF63xI93QirlcaRza8VzyonwzL
	fFVC/BzOrqyC4x6C/ICgB2KlGMmfdV0M67OWYsJrPCcIm4Hgnn0+9z5hnitaCSPOUxeOtVOFNeh
	Uj+SBPmy4Fn8n5nKFJ7dysd50e4E4jdW/oi29OanjOAnaojhLJGnS2hfqRdXAa1Iyu7x4Gqdv8g
	cfJmFT/VNRWtFYRJonDggSMetg2sSa
X-Gm-Gg: ASbGncsymLQuXAkYi0vT1IHCXaA2qZ3C+8vwiVMKWKn7oDCW72ilPSlP7CwtWFHSF9b
	9ffZfF1ZXecnq6/4v146acfclYTUL9JwK6oFeSklokSDOiGTpH/BC1SqBGZz61RyREoTgRUsEBq
	cpp9F6
X-Received: by 2002:a17:90b:4cc2:b0:311:abba:53c0 with SMTP id 98e67ed59e1d1-3159d64288cmr23065994a91.9.1750726698209;
        Mon, 23 Jun 2025 17:58:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0TL53ZDwgeSV+DD2GcU3jEI4r/eDHq4FmfUZ/GvS4kXkq5suNbkCfKDj/NwxqjwgnsrCmWvLCvjsuEvH74OU=
X-Received: by 2002:a17:90b:4cc2:b0:311:abba:53c0 with SMTP id
 98e67ed59e1d1-3159d64288cmr23065951a91.9.1750726697619; Mon, 23 Jun 2025
 17:58:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612083213.2704-1-jasowang@redhat.com>
In-Reply-To: <20250612083213.2704-1-jasowang@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 24 Jun 2025 08:58:05 +0800
X-Gm-Features: AX0GCFtX40pdquUIKQa4dMm29AUMnV2mY-tckRUEDH3MEDY23niQa4wXLvV7Jxg
Message-ID: <CACGkMEsphawodd-9XTg8KfYotdLri-3cuSV67F23AOscAHQs6g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] tun: remove unnecessary tun_xdp_hdr structure
To: mst@redhat.com, kuba@kernel.org, pabeni@redhat.com
Cc: eperezma@redhat.com, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com, jasowang@redhat.com, 
	andrew+netdev@lunn.ch, edumazet@google.com, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 4:32=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> With f95f0f95cfb7("net, xdp: Introduce xdp_init_buff utility routine"),
> buffer length could be stored as frame size so there's no need to have
> a dedicated tun_xdp_hdr structure. We can simply store virtio net
> header instead.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---

Hello maintainers:

Are we ok with this series?

Thanks


