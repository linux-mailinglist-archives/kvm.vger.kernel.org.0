Return-Path: <kvm+bounces-66195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0FF2CC9AA5
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 23:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E8F54300D025
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 22:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 470EC31062C;
	Wed, 17 Dec 2025 22:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="TiXpXxIM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mqWRTRGA"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DAB310624;
	Wed, 17 Dec 2025 22:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766009289; cv=none; b=cnQ5/M5jG/11kp2gDh1+yhOK7LP3sxqYE/ourXdGuz7N0cmLe729YME/usr6RxRULHLvEUIfRyP0HV0bvZdd4bDf09Jtg2Z6Q1hN8hAV5NYUM9hLkm6OEvyW3Gr2+CVEIb1HpZ+jXfz4LAOnlQrK8KMniEEoL/Ps2lh2zGhSPBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766009289; c=relaxed/simple;
	bh=81VOuZCEN7Dh4zK1j+i/yZFtaz82r5hdgOHH9luCgAo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xa4k9PSNsac0JwMhmssxsmj6q/aLh3RiVoleDN7xNN+Bxi8+2l91k59KTzo5SVW5oczfzH/nwBB+P+JgMHl9MKcM/CbA5gPbAW6Lz10poD9Qy3ks5z/dZ6HLeLxSKX9DzJNMnyHp1Hw/BdQZaEhKKyAFI8Z+XwKwysVexsEJs+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=TiXpXxIM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mqWRTRGA; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id ED7307A003F;
	Wed, 17 Dec 2025 17:08:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 17 Dec 2025 17:08:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1766009281;
	 x=1766095681; bh=9rWdXAFTyaCJXKyyFm+bRbV33yTESmH5JCp9fA9WXPU=; b=
	TiXpXxIMXgvY3LCw2WE/p+jWDFYdBFQBdswWIoVXXLM7ooDMx+kqwknGcWWCQ+7a
	qV79e83kzuYS28EF2LTu+Atq1XuA7dUjwhA0vGTDATQyd31jeOiF55+oLMfJtY9O
	zRaM3M8eu52UeTO4KRBwEJhe+BGUjVuN47JYBzxanGuofsMJHv9eFKzQ23W4M+Cc
	SOxu+DuT9Zkcrpm3BGhSXczhw/oHER5O9iBGp1VMAO9FykKAsoJPB7yZh+DZKaUK
	f74n8yK72j59jk5mH2EhJnKCPkcqdu4Rs/VaoZuvA3W7rIwVJhvkYHdG7/HjY32M
	5yLP0zP/y4wCtQkhz8DCkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1766009281; x=
	1766095681; bh=9rWdXAFTyaCJXKyyFm+bRbV33yTESmH5JCp9fA9WXPU=; b=m
	qWRTRGA8bUKLH4KANpZ+vjbyUelQlY0k+TKVE4wIKRd25DAG1muS0pvsq8h+OZcm
	YTTNFCfDw7ReF5ZgX3kR+yCrZ4fSWVNYWxKPbnCbrIQvDaK2NBlDHxNfyFkwMlyb
	u9MeaxqE7T34Ds5rrps6lsQSStuZULVLY7A4dxeHfhDzWHJWB+kz2bcNuVS+XhB+
	+Jx2+ylSLZZSockntXGJHcPYEjmubC6MthQaTzHS0mTpNQI7AW85nHsq3kZWgyBy
	93TklhRrkcuzJrKUHCelH/cPfTBo1WrlwEb/9vYBapb2vsm/CqHfPJs+HDdd0BRs
	Gs75U6XonAWaIxTxLboIA==
X-ME-Sender: <xms:wSlDaYbG-UDw1tKFCYFrz-biVAkl3Dc-_lyutvGqYMvm8_dzjYlyvQ>
    <xme:wSlDafS9IkEUXFkLb23JLVVOPoaXup5HY9iT55WC2a7eXsfRBPzc46KPNvNzMpdBH
    XmvdpzRdgMyVIVGvhOthlN0enZwA98ppTC8qP5d8gD2pBdLPJxIDw>
X-ME-Received: <xmr:wSlDaf8zL3dqANPfpt7fjmwL6JYC9CFGbEabkBS9PADFlFMk-Vj3FqrU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegfeejvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfgjfhggtgfgsehtjeertddttddvnecuhfhrohhmpeetlhgvgicuhghi
    lhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehvddtueevjeduffejfeduhfeufeejvdetgffftdeiieduhfejjefhhfefueev
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhn
    sggprhgtphhtthhopeduuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgvvh
    hinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghpthhtoheprghnkhhithgrsehnvhhi
    ughirgdrtghomhdprhgtphhtthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhope
    ihihhshhgrihhhsehnvhhiughirgdrtghomhdprhgtphhtthhopehskhholhhothhhuhhm
    thhhohesnhhvihguihgrrdgtohhmpdhrtghpthhtoheprhgrmhgvshhhrdhthhhomhgrsh
    esihhnthgvlhdrtghomhdprhgtphhtthhopeihuhhngihirghnghdrlhhisegrmhgurdgt
    ohhmpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:wSlDaXioFfYbBVNtsJFO1cwy26dNx-r-qBYHFfHeDO2V6yqBuPA2Zg>
    <xmx:wSlDaYbEhWOTPO6floNBUz9FMbrLha4ZQnFr4NN6ih2grxodfYrlhQ>
    <xmx:wSlDaU9OuyBqKs4QpayXODQwzzNOb0Euy00mlhYMW7x6NbXdj-XaTg>
    <xmx:wSlDaSPoeTHcsMB-wI7M8l-c0YdtAZntGtlAHgFfFhHvsfIpw9Fqzw>
    <xmx:wSlDafxIY1HFM7VPOv1pVF0LbAz4KHAi9zGNyFXnOmkgJ70QmPSbfSyR>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Dec 2025 17:08:00 -0500 (EST)
Date: Wed, 17 Dec 2025 15:07:55 -0700
From: Alex Williamson <alex@shazbot.org>
To: Kevin Tian <kevin.tian@intel.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Ramesh Thomas <ramesh.thomas@intel.com>,
 Yunxiang Li <Yunxiang.Li@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Disable qword access to the PCI ROM bar
Message-ID: <20251217150755.10d88a04.alex@shazbot.org>
In-Reply-To: <20251212020941.338355-1-kevin.tian@intel.com>
References: <20251212020941.338355-1-kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Dec 2025 02:09:41 +0000
Kevin Tian <kevin.tian@intel.com> wrote:

> Commit 2b938e3db335 ("vfio/pci: Enable iowrite64 and ioread64 for vfio
> pci") enables qword access to the PCI bar resources. However certain
> devices (e.g. Intel X710) are observed with problem upon qword accesses
> to the rom bar, e.g. triggering PCI aer errors.
> 
> Instead of trying to identify all broken devices, universally disable
> qword access to the rom bar i.e. going back to the old way which worked
> reliably for years.

Thanks for finding the root cause of this, Kevin.  I think it would add
useful context in the commit log here to describe that the ROM is
somewhat unique in this respect because it's cached by QEMU which
simply does a pread() of the remaining size until it gets the full
contents.  The other BARs would only perform operations at the same
access width as their guest drivers.

> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220740
> Fixes: 2b938e3db335 ("vfio/pci: Enable iowrite64 and ioread64 for vfio pci")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c |  4 ++--
>  drivers/vfio/pci/vfio_pci_rdwr.c    | 19 +++++++++++++++----
>  include/linux/vfio_pci_core.h       |  2 +-
>  3 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index e346392b72f6..9b39184f76b7 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -491,7 +491,7 @@ nvgrace_gpu_map_and_read(struct nvgrace_gpu_pci_core_device *nvdev,
>  		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
>  					     nvdev->resmem.ioaddr,
>  					     buf, offset, mem_count,
> -					     0, 0, false);
> +					     0, 0, false, true);
>  	}
>  
>  	return ret;
> @@ -609,7 +609,7 @@ nvgrace_gpu_map_and_write(struct nvgrace_gpu_pci_core_device *nvdev,
>  		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
>  					     nvdev->resmem.ioaddr,
>  					     (char __user *)buf, pos, mem_count,
> -					     0, 0, true);
> +					     0, 0, true, true);
>  	}
>  
>  	return ret;
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 6192788c8ba3..95dc7e04cb08 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -135,7 +135,7 @@ VFIO_IORDWR(64)
>  ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  			       void __iomem *io, char __user *buf,
>  			       loff_t off, size_t count, size_t x_start,
> -			       size_t x_end, bool iswrite)
> +			       size_t x_end, bool iswrite, bool allow_qword)

I've been trying to think about how we avoid yet another bool arg here.
What do you think about creating an enum:

enum vfio_pci_io_width {
	VFIO_PCI_IO_WIDTH_1 = 1,
	VFIO_PCI_IO_WIDTH_2 = 2,
	VFIO_PCI_IO_WIDTH_4 = 4,
	VFIO_PCI_IO_WIDTH_8 = 8,
};

The arg here would then be enum vfio_pci_io_width max_width, and for
each test we'd add a condition && max_width >= 8 (4, 2), where we can
assume byte access as the minimum regardless of the arg.  It's a little
more than we need, but it follows a simple pattern and I think makes
the call sites a bit more intuitive.

>  {
>  	ssize_t done = 0;
>  	int ret;
> @@ -150,7 +150,7 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  		else
>  			fillable = 0;
>  
> -		if (fillable >= 8 && !(off % 8)) {
> +		if (allow_qword && fillable >= 8 && !(off % 8)) {
>  			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
>  						io, buf, off, &filled);
>  			if (ret)
> @@ -234,6 +234,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  	void __iomem *io;
>  	struct resource *res = &vdev->pdev->resource[bar];
>  	ssize_t done;
> +	bool allow_qword = true;
>  
>  	if (pci_resource_start(pdev, bar))
>  		end = pci_resource_len(pdev, bar);
> @@ -262,6 +263,16 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  		if (!io)
>  			return -ENOMEM;
>  		x_end = end;
> +
> +		/*
> +		 * Certain devices (e.g. Intel X710) don't support qword
> +		 * access to the ROM bar. Otherwise PCI AER errors might be
> +		 * triggered.
> +		 *
> +		 * Disable qword access to the ROM bar universally, which
> +		 * worked reliably for years before qword access is enabled.
> +		 */
> +		allow_qword = false;
>  	} else {
>  		int ret = vfio_pci_core_setup_barmap(vdev, bar);
>  		if (ret) {
> @@ -278,7 +289,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  	}
>  
>  	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
> -				      count, x_start, x_end, iswrite);
> +				      count, x_start, x_end, iswrite, allow_qword);
>  
>  	if (done >= 0)
>  		*ppos += done;
> @@ -352,7 +363,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  	 * to the memory enable bit in the command register.
>  	 */
>  	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
> -				      0, 0, iswrite);
> +				      0, 0, iswrite, true);

I have no basis other than paranoia and "VGA is old and a 64-bit access
to it seem wrong", but I'm tempted to restrict this to dword access as
well.  I don't want to take your fix off track from it's specific goal
though.  Thanks,

Alex

>  
>  	vga_put(vdev->pdev, rsrc);
>  
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index f541044e42a2..3a75b76eaed3 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -133,7 +133,7 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
>  ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  			       void __iomem *io, char __user *buf,
>  			       loff_t off, size_t count, size_t x_start,
> -			       size_t x_end, bool iswrite);
> +			       size_t x_end, bool iswrite, bool allow_qword);
>  bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
>  					 loff_t reg_start, size_t reg_cnt,
>  					 loff_t *buf_offset,


