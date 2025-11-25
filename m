Return-Path: <kvm+bounces-64567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A68C872B5
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 688703B4DC4
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C162E7F29;
	Tue, 25 Nov 2025 20:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="W4fGyGe1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="yAemT48p"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1976B2E6CC4;
	Tue, 25 Nov 2025 20:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764103988; cv=none; b=SmxW65e4QFBXDX8iUIrNqkVsCXp47CkY06xrMBTd9ZgbzgnOQwJolTKWFHwaiFZFf2iuRRR5bc3V/Yu0ZwnBHYMdRlTJpnMmIGCV+XyW91EAa1NPktyVgKiqC+h4v5yjbslMreEDz47CCSgJoCW71GnZMjvUWsP9bM/XGogGt68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764103988; c=relaxed/simple;
	bh=5VLl5sV2NRuahC3Iar+Q6BQIEdIGYN2HWZwbgDTWbgE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P1fCw0dx6t0MVcB3xcZIGz/zjf8C2xXUt7VYpXTYytZu+DXjLVUDPD2l28/2ExioMZpb/11aVp1fCrgRN8xrV1LrVVmYcJeuQ9UZChUyouJM+OE0gg4+E+C2PcOA1K+x2EkmUdeJYeOFhCMuYS3CpZLJyiXgC5v94OD6A54k2X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=W4fGyGe1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=yAemT48p; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id C91D61D00118;
	Tue, 25 Nov 2025 15:53:04 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Tue, 25 Nov 2025 15:53:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764103984;
	 x=1764190384; bh=X6SW7dFWnp/2zihbLGkyXRQfwOJ5Ou5E7fAEU6J0xU0=; b=
	W4fGyGe1wShf0oFnSPJYQLpWR9nNM31XqDsHaOpIquyi0T/g491N5ktTr3FlyIJ1
	QvUbw1jKU3NuleUYFfYi82HQ4cHot8SGMHRaJrVIJyN7bduxTfIw97LZk5nCMQUT
	sO9+O4bJO8nG2vf5NxA1Sc6ZxrRcqi0DOdN2aapdwvl/Y9b6dmDw+uBW7KQtOuq/
	nFAorVSUIrPMiw+/Hc2n+aggxb2miyhPwWwd8X4tvAQQ9W32EJXg5j57aEla+bDS
	3ucAp17+stTwWHolmd75/AFTI4tqpJOdsasGhV3xeU+6SAUeR1AOK/bbZ5Bjtt0O
	oLKlWHE5U9BaDANGEYZI/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764103984; x=
	1764190384; bh=X6SW7dFWnp/2zihbLGkyXRQfwOJ5Ou5E7fAEU6J0xU0=; b=y
	AemT48pUZ5B35vROf7Ce3UEF2upkRZvU5XEtUCVXEV+pMafJjZ6SELSk4/K6Sg7e
	0E7z6n8E7RN5289YL1KVS8AYcSdSs6HY738pplCbmArB5xscXp/Fww83zrnC+Ob0
	O4lQVdLyFSjFUX5KQKYTYyuAdtJnz+2vy5WiUUrInRtRvjIwi/NOGAmpSiAvysLQ
	4fQt86TMVwEXePTWOBJ3tL0W/onTC886bcqVRuGP9Y5HqYykslSW6DTljSpQmPu5
	jL4t2LtEMUi/5Bm12JTQrjzLa45sHrDsxbKVwHqoI5v11/1sQK1xg6oMfFisBeRc
	LCgPRQ+B8WyXR74ZNFT3Q==
X-ME-Sender: <xms:MBcmaXYRhYRTxwBc8TakRlM1dh2SnMj9mdPUeKDUlQw9Bg-WixbWnQ>
    <xme:MBcmaRaE_NiparljrNGpbziYlrpekw0QnD6oiYvuPIy-oXeYWB3YfuT80jMFc1JDH
    K9l962_LaUZkYUmCAqAgGCFa7v0XfPqBwXahPoYtu8m-NlOASAtwA>
X-ME-Received: <xmr:MBcmaQlUQOnbL1q7DpyNM_PuZ7gSQLY6KqPhB1C6m2a7iy6riWmgjNC_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgedvgeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeetteduleegkeeigedugeeluedvff
    egheeliedvtdefkedtkeekheffhedutefhhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspg
    hrtghpthhtohepvdehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrnhhkihht
    rgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtg
    hpthhtohephihishhhrghihhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhl
    ohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehkvghvihhnrdhtih
    grnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrnhhikhgvthgrsehnvhhiughirgdr
    tghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrdgtohhmpdhrtghpthhtoh
    epmhhotghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohephihunhigihgrnhhgrdhl
    ihesrghmugdrtghomh
X-ME-Proxy: <xmx:MBcmabTveGHw1Tc3sfT5JEKsscxaYCyB-q0WNpPKxSLGwK_giO4T9w>
    <xmx:MBcmadXtuolsIG3vTh-YJhglngvAoMEFPYQOWCFGFyY3jDp6quB_yg>
    <xmx:MBcmaZvQQuWyIYOac8o7BIS2jMKgXCTZJphnYXyR5GgtFGsK29UtaA>
    <xmx:MBcmaVNgDIZ5ItuqJWo_zTLAJWgYkhXxrs5pc3DMI-mE0iKxh61mPg>
    <xmx:MBcmaXuRYOo1vDiy61Z1gsVpPZ-m6vhRvTkUsiO0V-hJpcPX8bM-8Z8h>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Nov 2025 15:53:02 -0500 (EST)
Date: Tue, 25 Nov 2025 13:52:40 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <skolothumtho@nvidia.com>,
 <kevin.tian@intel.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
 <mochs@nvidia.com>, <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
 <zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
 <bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
 <apopple@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <zhiw@nvidia.com>, <danw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: Re: [PATCH v6 4/6] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Message-ID: <20251125135240.00f7faa6.alex@shazbot.org>
In-Reply-To: <20251125173013.39511-5-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-5-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Nov 2025 17:30:11 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Split the function that check for the GPU device being ready on
> the probe.
> 
> Move the code to wait for the GPU to be ready through BAR0 register
> reads to a separate function. This would help reuse the code.
> 
> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

As noted last round:

Fixes: ...

And note the fix in the commit log.

> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 8a982310b188..2b736cb82f38 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,6 +130,20 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> +static int nvgrace_gpu_wait_device_ready(void __iomem *io)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
> +
> +	do {
> +		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
> +		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY))
> +			return 0;
> +		msleep(POLL_QUANTUM_MS);
> +	} while (!time_after(jiffies, timeout));
> +
> +	return -ETIME;
> +}
> +
>  static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
>  				   unsigned long addr)
>  {
> @@ -933,9 +947,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
>   * Ensure that the BAR0 region is enabled before accessing the
>   * registers.
>   */
> -static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
> +static int nvgrace_gpu_probe_check_device_ready(struct pci_dev *pdev)
>  {
> -	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
>  	void __iomem *io;
>  	int ret = -ETIME;

And this initialization is unnecessary.  Thanks,

Alex

>  
> @@ -953,16 +966,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
>  		goto iomap_exit;
>  	}
>  
> -	do {
> -		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
> -		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
> -			ret = 0;
> -			goto reg_check_exit;
> -		}
> -		msleep(POLL_QUANTUM_MS);
> -	} while (!time_after(jiffies, timeout));
> +	ret = nvgrace_gpu_wait_device_ready(io);
>  
> -reg_check_exit:
>  	pci_iounmap(pdev, io);
>  iomap_exit:
>  	pci_release_selected_regions(pdev, 1 << 0);
> @@ -979,7 +984,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  	u64 memphys, memlength;
>  	int ret;
>  
> -	ret = nvgrace_gpu_wait_device_ready(pdev);
> +	ret = nvgrace_gpu_probe_check_device_ready(pdev);
>  	if (ret)
>  		return ret;
>  


