Return-Path: <kvm+bounces-21149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A563F92AF35
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 06:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1B86282DD4
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 04:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD4D12D76F;
	Tue,  9 Jul 2024 04:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cWa23xQh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E52D29CEA;
	Tue,  9 Jul 2024 04:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720500988; cv=none; b=PSsrCqys6Hz5TDmi0bO1CQ6a6wRdK322xvFWezzO6Had214+SGOjGdMWinRptTgqJLEz3JJGD5z9+1ZGOLzqfYR3JUpqa3kEhgF2BuZ1HfuRaWiojA3Ma1NrP+o25FJogEiwfVt0wyqXHvX4FdN00/Wwkdl6F5Tx14Bt+44+07M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720500988; c=relaxed/simple;
	bh=fE40NuZ4fShMCttqfdKrcE7vS4Ge14AIJu721WFgBlw=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LBNYc4YAwYamsOQJrfp+ozHdY9VmZvDwkXRfFQWVtEPi88tlqd/9UdN5KRZcAtoFoj3DevSj7CGanbt+TcaHdkVHeg8ze9D1YI+ZyLtNSXMYeuRB2Jnartaeg+e6IfKYSvyBSSvS2iwyxd6mr0quIv943UD67trrtZvXpi56wH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=cWa23xQh; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 468HSdBN018575;
	Mon, 8 Jul 2024 21:56:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	pfpt0220; bh=TMKLR/0PKelWoujxJYU+fiWjMTu5eV4CiT1fo2IfKSM=; b=cWa
	23xQh70DYfsJN7ciSqYOnwK8u0RpONdJmpvM1ng6BUCA1fK0w8N4D3C6INV5Uumd
	ZMWfg4JTwgVAi0IBR+ghTtQbk+z883U0lK5yQnZ4BsnpXvfzxpxDf8y+kLXNcfwp
	8ui8SBHFSaaz9Q0uZMeNYDYp67Ww0/Q63BzgdTKhI9Wv5eXo9omTOWaZuAElgq6q
	50I2EW3QUcCjfM/bh9FcSJtqfr+TOrGvQHDM5elTACZ8yFHYYPMvyOw8JRZbxl6c
	KLKACddxRA3CqvMKYJeSt0+dmHT/iPq0NYkgcDgP3QWOyoiUj3tVfqjOgnJxzAJh
	S3bqIj/8C2s5ZXm2bQg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 408mhj9t05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jul 2024 21:56:14 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 8 Jul 2024 21:56:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 8 Jul 2024 21:56:13 -0700
Received: from maili.marvell.com (unknown [10.28.36.165])
	by maili.marvell.com (Postfix) with SMTP id 659963F708C;
	Mon,  8 Jul 2024 21:56:10 -0700 (PDT)
Date: Tue, 9 Jul 2024 10:26:09 +0530
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: Cindy Lu <lulu@redhat.com>
CC: <dtatulea@nvidia.com>, <mst@redhat.com>, <jasowang@redhat.com>,
        <parav@nvidia.com>, <sgarzare@redhat.com>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: Add the support of set mac address
Message-ID: <20240709045609.GA3082655@maili.marvell.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Proofpoint-GUID: 6kD9ztUZzetUgUO0QDgZjLX08ELTRIsx
X-Proofpoint-ORIG-GUID: 6kD9ztUZzetUgUO0QDgZjLX08ELTRIsx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-08_15,2024-07-08_01,2024-05-17_01

On 2024-07-08 at 12:25:49, Cindy Lu (lulu@redhat.com) wrote:
> +static int mlx5_vdpa_set_attr_mac(struct vdpa_mgmt_dev *v_mdev,
> +				  struct vdpa_device *dev,
> +				  const struct vdpa_dev_set_config *add_config)
> +{
> +	struct mlx5_vdpa_dev *mvdev = to_mvdev(dev);
> +	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> +	struct mlx5_core_dev *mdev = mvdev->mdev;
> +	struct virtio_net_config *config = &ndev->config;
> +	int err;
> +	struct mlx5_core_dev *pfmdev;
nit: reverse xmas tree; may be, split assigment and definition.

>

