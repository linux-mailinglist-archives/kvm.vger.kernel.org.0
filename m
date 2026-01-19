Return-Path: <kvm+bounces-68472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CB5FD39E3A
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 07:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA970303752C
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2C2261B80;
	Mon, 19 Jan 2026 06:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CuRYGPr7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FC32367D3;
	Mon, 19 Jan 2026 06:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768802751; cv=none; b=YMeWyIZlMtqyy6Sy55Qeoq90ZYIBM9rStNAuXgMh+HqxWzDxTmhErsNRAKdA6LED9M3HpHVrjoaAElD09zS3wOymqlQGJHBDddyo1KSq0SFnjtLKzQlZutczn8AoDENKxe+va/6KoTKdneiEmarfinZ+dmeRgA0WsoUveeH23Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768802751; c=relaxed/simple;
	bh=KF0g6CHmfmERbfVIxwq63SZYa6Rer2UpccORI6pdfF0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlLleQuWdND0ZD07Dgbthlk4PClhtWjV7V0fVbnDwfTCVjI6JkFERjbXfOap4E17HY4lvUPRbOCmPEmJvxQWmvdbv1Pc4jalODvpVG/TIGWtrhh1PdgIb+HJdu1F7UosQVm0P3+ssxK/rMXt6cjrwJrTntqxTflb9rlLw82BCyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=CuRYGPr7; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60ILdO1R1256085;
	Sun, 18 Jan 2026 22:05:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=rp273GIKufFn1mAUwJh3uCQU7
	ZMnIM3nSE0nl5ZS3B8=; b=CuRYGPr7wpNPohUGCWTrIssEvzL52Xj59xGQv5ukD
	6vNl1CdpewsJElsUm15klMI6YC83oZHmbC4E7CHPKhqtKyehsDuUqoLqubddG6qo
	6ojekWZl5/QAkuTCJblKZJFEf2d+dugCR+hajzanbrpqywtqCQzhr2xYSU8OuO8L
	ihOI/y+Pgw1wJpQdXP+YjJ7XJhem7l11HZWoEvo7LdEh/eKc8s+ph3duBuVRWzqh
	9n/D46qFbdLz5WAP0X8bZ48eNnAQfEV9/CdSWyLhNQvVDssqgvrqB0SPYjiIr7zn
	0Jbu7crbFdVpGJcd1grYJS/WeC7bqnxxcCEjUk2mv9EWQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4bryjc94sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 18 Jan 2026 22:05:43 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 18 Jan 2026 22:05:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Sun, 18 Jan 2026 22:05:42 -0800
Received: from test-OptiPlex-Tower-Plus-7010 (unknown [10.29.37.157])
	by maili.marvell.com (Postfix) with SMTP id EAECA3F707B;
	Sun, 18 Jan 2026 22:05:39 -0800 (PST)
Date: Mon, 19 Jan 2026 11:35:38 +0530
From: Hariprasad Kelam <hkelam@marvell.com>
To: Cindy Lu <lulu@redhat.com>
CC: <dtatulea@nvidia.com>, <mst@redhat.com>, <jasowang@redhat.com>,
        <netdev@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] vdpa/mlx5: reuse common function for MAC address
 updates
Message-ID: <aW3JstEHDXjj80OL@test-OptiPlex-Tower-Plus-7010>
References: <20260119055447.229772-1-lulu@redhat.com>
 <20260119055447.229772-3-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260119055447.229772-3-lulu@redhat.com>
X-Proofpoint-GUID: CDwML-LI4tNZFIK_HwHMS2-qs9frUmkv
X-Proofpoint-ORIG-GUID: CDwML-LI4tNZFIK_HwHMS2-qs9frUmkv
X-Authority-Analysis: v=2.4 cv=RuDI7SmK c=1 sm=1 tr=0 ts=696dc9b7 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8 a=nN6_Z0fRexQVMCHuv28A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDA0NSBTYWx0ZWRfXz+jyjxIxDx/k
 +uLypZtIl2KCR+VQmcQ6nQdEQ60vjUJjnjmJBOQ+K1k2EW4HkpsLPHQWAAQnE/rIJUVgBn1sJgX
 wzcJ0hifGw6X5qiSE/sFWjODW2cJkBkaow6S3sN1K1OBZRh/2bdHR9jolb73C1mya1NoqrhDIbL
 oFDcnIYc09VDTDtqN2S3FvBp+o/OEqW2V0hpdEhJZYEUlFqEf1DD+AQCNgU4ikbHGtcls3vZCm0
 s+KbZ4teK298Dw3i+Izxx8Ec3FYdz61qosg267WpNeI+m1EudC7P+Q+yOf+V5jAIknRkKG0khnD
 50hVBxRxHvn9cH4CdB9OuYlmKQ+cQ/cpkQ1zN5OZ+EEmII9k/JPU8yxeHPQV3mUdzxQNEXBBRoA
 Ibvc3RJKsSIM2ZDHHVOm+NS/24HWZNr1XLxfw171W2ztl4FlTSHON65C02R0KiI9QWQNQX4C6OC
 3INu+BJW/Ifac4Xgn4w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_01,2026-01-18_02,2025-10-01_01

On 2026-01-19 at 11:23:52, Cindy Lu (lulu@redhat.com) wrote:
> Factor out MAC address update logic and reuse it from handle_ctrl_mac().
> 
> This ensures that old MAC entries are removed from the MPFS table
> before adding a new one and that the forwarding rules are updated
> accordingly. If updating the flow table fails, the original MAC and
> rules are restored as much as possible to keep the software and
> hardware state consistent.
> 
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> 
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 131 ++++++++++++++++--------------
>  1 file changed, 71 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 6e42bae7c9a1..7a39843de243 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2125,86 +2125,97 @@ static void teardown_steering(struct mlx5_vdpa_net *ndev)
>  	mlx5_destroy_flow_table(ndev->rxft);
>  }
>  
> -static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
> +static int mlx5_vdpa_change_mac(struct mlx5_vdpa_net *ndev,
> +				struct mlx5_core_dev *pfmdev,
> +				const u8 *new_mac)
>  {
> -	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> -	struct mlx5_control_vq *cvq = &mvdev->cvq;
> -	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
> -	struct mlx5_core_dev *pfmdev;
> -	size_t read;
> -	u8 mac[ETH_ALEN], mac_back[ETH_ALEN];
> +	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
> +	u8 old_mac[ETH_ALEN];
>  
> -	pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
> -	switch (cmd) {
> -	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
> -		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, (void *)mac, ETH_ALEN);
> -		if (read != ETH_ALEN)
> -			break;
> +	if (is_zero_ether_addr(new_mac))
> +		return -EINVAL;
>  
> -		if (!memcmp(ndev->config.mac, mac, 6)) {
> -			status = VIRTIO_NET_OK;
> -			break;
> +	if (!is_zero_ether_addr(ndev->config.mac)) {
> +		if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
> +			mlx5_vdpa_warn(mvdev, "failed to delete old MAC %pM from MPFS table\n",
> +				       ndev->config.mac);
> +			return -EIO;
>  		}
> +	}
>  
> -		if (is_zero_ether_addr(mac))
> -			break;
> +	if (mlx5_mpfs_add_mac(pfmdev, (u8 *)new_mac)) {
> +		mlx5_vdpa_warn(mvdev, "failed to insert new MAC %pM into MPFS table\n",
> +			       new_mac);
> +		return -EIO;
> +	}
>  
> -		if (!is_zero_ether_addr(ndev->config.mac)) {
> -			if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
> -				mlx5_vdpa_warn(mvdev, "failed to delete old MAC %pM from MPFS table\n",
> -					       ndev->config.mac);
> -				break;
> -			}
> -		}
> +	/* backup the original mac address so that if failed to add the forward rules
> +	 * we could restore it
> +	 */
> +	memcpy(old_mac, ndev->config.mac, ETH_ALEN);
        can we use "ether_addr_copy" instead of memcpy?
Thanks,
Hariprasad k	

