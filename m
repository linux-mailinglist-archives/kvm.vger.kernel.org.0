Return-Path: <kvm+bounces-29696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F809AFCD3
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 10:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3C11B203B0
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 08:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B061D2B03;
	Fri, 25 Oct 2024 08:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IMN9a6Ls"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D4E1D270D
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 08:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729845774; cv=none; b=AsMmIZZPGo8wMm0tYDZ8BI9MzVNhJfHpvrCI1lIkHjEf9diDbkPDUhGXpbsN9lrAmZSLuuwLfaIP0EYUalzoK4FEZazKchzCNQBC5HyUYOVaLjTBb83zd1YfLJ6lBtnQNNKSF619C2Vje4xbb1Pdv39z9FP9j0dDe+O5we9sT2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729845774; c=relaxed/simple;
	bh=ESF8HNfQuBgJctBd8Wbfrf3fbvtN7SVW+NouVhQec20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y5zgxbqcXW8KLKY/qiETDnCA9RncEc9e3Fmg1yvY8GklJflicqTmrtSutxQLoFqGHuXH/SLtXNgRzQ2DkmyJJ0nVDdwL4/iks16V8u0OAUdFIgCGU2+k/Xl1BdMOKVip7Fm5mcYUTxTanpna+IcS3LP9oKAd+CnPlAxcfW+s6s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IMN9a6Ls; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729845772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ESF8HNfQuBgJctBd8Wbfrf3fbvtN7SVW+NouVhQec20=;
	b=IMN9a6LsffDGU7U58imUHnqwSPCy8yzP/UshRqLijn026KO81bHmLfhmB71lzqFZZjmu2i
	f9GUwGcboxwCmM0ihB2LNcRfKHmrqIKwTxCRy1cYLfc51KH4Mr/LHHj6SI1xiWL58GkS73
	Uulu2tzosm/dJSNqD8cLIbH7Tse0TA8=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-tmmBYPNVNyOlcDRtTZvkxw-1; Fri, 25 Oct 2024 04:42:50 -0400
X-MC-Unique: tmmBYPNVNyOlcDRtTZvkxw-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-71e51a31988so2876684b3a.1
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 01:42:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729845769; x=1730450569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ESF8HNfQuBgJctBd8Wbfrf3fbvtN7SVW+NouVhQec20=;
        b=S+oHnIL1VbLEiFpCiHFg3LfvBH4ePsR8XGHcg5aFqHPGNGpjqXVkMdq48FLEIcvLmE
         UqfgbfKTeBrbEBshGYQLVvf9E4JYRVK3wuwnWwWS+EMBnqluPsv2XgKtKSEe3Zd6opc4
         LKr4omm5GfKIsUsF0CuQy9jetw8ndMzBY3HA1WB84iDYG66MV2JrrD5zMbg/wZPzhZBA
         1x41NgeZwxfGtqR37QP8oS1jfirEUA5+qQLfQqRPmOflpDE2uUtBebY284BxqcpH+kEh
         BY9vQJArOa7914xNv53V7covc7MClJeosmTyt1Vyo8WDT8v/Vh5kS6rf4wejCxbumPF+
         99Eg==
X-Forwarded-Encrypted: i=1; AJvYcCXGfrerQW8HX9irPdxbSFRJ6mer3d0tScoCS+NrtCPOSkvre1vALWVtoCm5OdovYPiYyFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuByaXvsvpLf3Bf0GIT5cC4uJPcH5XvAlhQJ/BtGaZPNbZ3j7u
	03Hrr/RjePrfoH/Pu8brYcrj+UgTpPXhlgDlzfl357jOCF234N2oaZ7VX6b0a9AnQW8QU2k85vR
	0e9RiIGc4ArILo6lVUJjCEuuiCP0Qumcw6XPt5FEHF3vkuu6MCajev6+paXjUVRu8CTp5B2vlRr
	Ffj9mLio+MTtCmhneHrvNLhkTt
X-Received: by 2002:a05:6a21:1698:b0:1d9:9b2:8c2a with SMTP id adf61e73a8af0-1d978bae307mr12136717637.34.1729845769459;
        Fri, 25 Oct 2024 01:42:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqWP1hxccUA1MVos/H7lZp0gFmu6rQMfRQw9i+PiAUNz6qgFFpbHPa8aaG7pIBJG1XwjsjvD0LL1HzXXPt6VY=
X-Received: by 2002:a05:6a21:1698:b0:1d9:9b2:8c2a with SMTP id
 adf61e73a8af0-1d978bae307mr12136687637.34.1729845769020; Fri, 25 Oct 2024
 01:42:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241021134040.975221-1-dtatulea@nvidia.com> <20241021134040.975221-3-dtatulea@nvidia.com>
In-Reply-To: <20241021134040.975221-3-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 25 Oct 2024 16:42:37 +0800
Message-ID: <CACGkMEsOpz1S4Dhx2PPb1kdYc4f2SxX-55QT6px2TF1g9R_A+g@mail.gmail.com>
Subject: Re: [PATCH vhost 2/2] vdpa/mlx5: Fix suboptimal range on iotlb iteration
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Eugenio Perez Martin <eperezma@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 9:41=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> From: Si-Wei Liu <si-wei.liu@oracle.com>
>
> The starting iova address to iterate iotlb map entry within a range
> was set to an irrelevant value when passing to the itree_next()
> iterator, although luckily it doesn't affect the outcome of finding
> out the granule of the smallest iotlb map size. Fix the code to make
> it consistent with the following for-loop.
>
> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


