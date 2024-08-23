Return-Path: <kvm+bounces-24927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 213E495D3CC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 18:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C22901F23EB0
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 16:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7017818FC85;
	Fri, 23 Aug 2024 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="CTh6LX8v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D949A18C929
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724432059; cv=none; b=iI3i79s68F2MDcsnnoAG1DiM5+iPzPE78ZzxX8llrbf8iFXvf0tBYU9BOy8dgpL7N6Nqu06vTey5aIW50+PVqYc6w24WDyKzQNQk1Ai2BJ0LQTMFIunUe12GM6yyTrW5y2C0FiQrPBMgXBIRkM30G1y1omRvdOsKUG/I0lBkKDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724432059; c=relaxed/simple;
	bh=yLM8J7H2DsgRDxPVtS0CcqhN2nJId985NbMPevWwKAk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=NzBMoZlVBjmy2CPI97XZgVJGlSJfFP/pOs3Oa4xjFfAhAd08qo40pOolAOoSPjVnLFxErrlnzHq5lWl1JyLlI+9nZmk2t1HizlQKrox/CzEWG50Vcx1nyqcMyBAH+Opyjea9LhPoFuE4Di62zvET4hJGQG2qxGgxR28yfCxaQhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com; spf=pass smtp.mailfrom=digitalocean.com; dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b=CTh6LX8v; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digitalocean.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e179c28f990so1510802276.0
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 09:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google; t=1724432057; x=1725036857; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLM8J7H2DsgRDxPVtS0CcqhN2nJId985NbMPevWwKAk=;
        b=CTh6LX8vfmq70xS2bf5iF08XblWbEXQl1P/S89D6K28fHKuGHn3tYHVHfxW+Y0Vqu3
         zgyxaPXJTRDPhEm0I6gaBqjhUOYzCR8u3sdAbnK2d9C2lYwTan+Ng1iHyGUUJZR6+0Tl
         QAP8nck6XZ2DHbb1R2UaSf7GlTkr8DNpa0qvQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724432057; x=1725036857;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yLM8J7H2DsgRDxPVtS0CcqhN2nJId985NbMPevWwKAk=;
        b=VtFrp+m/7+zfwpPGIAzQvS50BTyyY2EZE88HElwo9NwR3ko1X20XzgwVbxKhM4/Qlt
         h8jezhInEGvbGRZQktjPPtovPfQuczboq8VFazouCZN7OGbTzOgxZjfd/FGKDGRiHv6W
         aju6bqHhoQPuOJFWo3hfofbOx07CXG18X6Yuxek5Kc77k7EsxvaU8oRKAcBs2Ocuixf8
         6R366qbgc+mWCOtwvUXqHUynw29Nr55FTGBufhALdQyHttwWe85T12pdPLAbUzy92K/C
         Z9f3YhBEpja7jG8TEjxW+bU8yuVxmTVKXOUcZWCJsCS4j9P7DJjNyNFsTECHOm04/3lS
         d02A==
X-Forwarded-Encrypted: i=1; AJvYcCU4RztVLM9Ld6Ldcdt3WtbAI/txwKFZpUpk94zzFmRnQDsUrDYauGDafjkpOP+R5Rs2/Hg=@vger.kernel.org
X-Gm-Message-State: AOJu0YznRynrlgWb/8n8ZYcoU1KRoRMMzN64bV2oE5xQmu21jvBe9AXH
	NGCNDiGeBqVDD4zI0gJIMrkgI9h0Q0nbr/mK0ph+MOrIalzgylM64zjFQDUC3gE=
X-Google-Smtp-Source: AGHT+IH+lZIalG0ZppdDUStKyMfxmA2xRM0YnXPLiu2xPW0X1PX57ufunWwRCXTvVh1qWh0OpYdpBw==
X-Received: by 2002:a05:6902:2383:b0:e0b:e4ce:9047 with SMTP id 3f1490d57ef6-e17a83de244mr3495755276.18.1724432055984;
        Fri, 23 Aug 2024 09:54:15 -0700 (PDT)
Received: from ?IPV6:2603:8080:7400:36da:45f:f211:3a7c:9377? ([2603:8080:7400:36da:45f:f211:3a7c:9377])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e178e4406b0sm720032276.12.2024.08.23.09.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 09:54:15 -0700 (PDT)
Message-ID: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
Date: Fri, 23 Aug 2024 11:54:13 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: eli@mellanox.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, dtatulea@nvidia.com
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, mst@redhat.com, kvm@vger.kernel.org,
 eperezma@redhat.com, sashal@kernel.org, yuehaibing@huawei.com,
 steven.sistare@oracle.com
From: Carlos Bilbao <cbilbao@digitalocean.com>
Subject: [RFC] Why is set_config not supported in mlx5_vnet?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

I'm debugging my vDPA setup, and when using ioctl to retrieve the
configuration, I noticed that it's running in half duplex mode:

Configuration data (24 bytes):
  MAC address: (Mac address)
  Status: 0x0001
  Max virtqueue pairs: 8
  MTU: 1500
  Speed: 0 Mb
  Duplex: Half Duplex
  RSS max key size: 0
  RSS max indirection table length: 0
  Supported hash types: 0x00000000

I believe this might be contributing to the underperformance of vDPA. While
looking into how to change this option for Mellanox, I read the following
kernel code in mlx5_vnet.c:

static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
                 unsigned int len)
{
    /* not supported */
}

I was wondering why this is the case. Is there another way for me to change
these configuration settings?

Thank you in advance,
Carlos


