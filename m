Return-Path: <kvm+bounces-72235-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKhpDMcWomnqzAQAu9opvQ
	(envelope-from <kvm+bounces-72235-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:12:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C801BE917
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 52DBA3099500
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D881C47AF55;
	Fri, 27 Feb 2026 22:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="rN1wOGI7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KCt8eH9y"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4D836BCE7;
	Fri, 27 Feb 2026 22:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772230330; cv=none; b=ckUjS9QEMbq+oJ32uxU6wyvo8Wsjt4Opm4UuccmIr87p8NX6wDqULd/nTT8Zc4yR2DbzZOM1/pEusCF8DObq8HPLm8mHiZIkU7bKvhyyG2IfS2mk4c/kO5saATgYyF9NwjSJfXE9oNUv8ISnCF01wsjLVyg7F7YkNSB8QU4r4Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772230330; c=relaxed/simple;
	bh=dwi1oYcSG7oNWdR6HTqvj26S9/2sO0jCutzswDUYXQE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=idLT33uo0inqwCSvvphpbnBPSegi7o/1MNvvTtG9yNxxv9SZYNWSdh1Net5fzk1r7ff8w9Z1/Kvl21azsPW8SIeksXmUzDa6h9iTK6+EL7BwtlWQ0N0wRoMbI7m2BQir3bCmuOcH9a9pxNa+4NBO2TJCHX13FSTY0xLu+fEu9WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=rN1wOGI7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KCt8eH9y; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 5455B1D0000E;
	Fri, 27 Feb 2026 17:12:05 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 17:12:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772230325;
	 x=1772316725; bh=r+Xj36bmMJT5YeFG+hgTwlIyeySe3/X6/Z0Pd7OhyM8=; b=
	rN1wOGI7Ou+M1DpR83xaW6Z1iQwZgbmrmSsEpuG4wQnNpNdF2XIjYrPb2u3AjHEW
	E/pjjol/8A2MZrJRWRn9UyqGZM40vDF6qHgXSxlPf989r+qkJdEicH0L+yb3y2Uv
	DguaM0M9fqiOCW7Wf76Wwd3A9ChCjDWOv1b16BTw9nLO26N2LJan3rog8kEHWfCl
	CqUTPvlhDb5Amgwp0tNzXSQvJ4FOgyCAN006T1P3gFI5hjg8pndVWJIUdY+QeCBY
	wQAxBjMAcg8Fhr6GRB5xtvgw8sRZfPj3ecfmMxeEAJCqxGCJJjBwjB549MCa7SRF
	EbecCM/Qgg5ZXfvXqb2+0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772230325; x=
	1772316725; bh=r+Xj36bmMJT5YeFG+hgTwlIyeySe3/X6/Z0Pd7OhyM8=; b=K
	Ct8eH9y5T/eTD1PWdyqfm4OKlLz6NDsRISuTQLUCv8cRc5CO7PopXq9gtd3hY0iA
	QpR7pmr23CIsinOFPSpgvCZmi5hVmIXUrCrI5JzHf9UTNRJkkqxu+ZiUYQ9kYamf
	en54HHPDo9EwTYLuYXZzYM6lNQr5+AiU+E3Cm2RguWgvhPRtdXRdnpJNJoO4XJMD
	mJDQ5chcjvBhQF6EzJLUkwA8IVT0sidDgVgWooxmAv0QAPKZAT1EVw9xFqwPE3T5
	kSfG6mjpeMEom4Z1m5ysMesImfcYT/87TmmBj8LTSVof2P9W5hIMjBXiFqNU++7L
	aQlBRb4ACwTabuvFAqDbA==
X-ME-Sender: <xms:tBaiaWeXvQJTmBIMqb5Wd2UgBPNt0MNsTajovyBjC1RlTAZWsxRnxg>
    <xme:tBaiacUvVr4Y6MyeK7JKzsIrmUXMxDZLJiFZNE7ycxIFiekFNq2ZdQpMqrbKG3jsy
    S1pno2yevGQKR3LyiegKRYZU0en6UVU2dc0TnyDcsAbzLuIrsYszg>
X-ME-Received: <xmr:tBaiaTWhg4F1EtyKdB6TmLXHON-0K7pyX95sEz-nrOexA9NQl7wIS4_yeVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvhedtudejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepvddupdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjuhhlihgrnhhrsehlihhnuhigrdhisghmrdgtoh
    hmpdhrtghpthhtohepshgthhhnvghllhgvsehlihhnuhigrdhisghmrdgtohhmpdhrtghp
    thhtohepfihinhhtvghrrgeslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehtsh
    eslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehosggvrhhprghrsehlihhnuhig
    rdhisghmrdgtohhmpdhrtghpthhtohepghgsrgihvghrsehlihhnuhigrdhisghmrdgtoh
    hmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtghpthhtohephihishhhrghi
    hhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvh
    hiughirgdrtghomh
X-ME-Proxy: <xmx:tBaiadTcGY6d5A9FjeyG8garTPGlsDgU06Wn0AYZebBiEBkPZs2Egg>
    <xmx:tBaiaS0v2CWzVtkemazVAND1QVXooOjyTfAY__VcEFVx3t2LbfaXYQ>
    <xmx:tBaiaeJ5WTQYjWlodP2BTnzzpZ-6-QCXVUYEuHNXrPYo53s3_7ygjg>
    <xmx:tBaiaT9OXgqTs4v3FsECNj_mRnBbnjHKwrSPQhWs-nhEN4Udz0M0PQ>
    <xmx:tRaiaf7rNXjh9lQLlGXZhTWMM89nyAatertr6t06PatkvPQmkOP7Ekvz>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 17:12:03 -0500 (EST)
Date: Fri, 27 Feb 2026 15:12:01 -0700
From: Alex Williamson <alex@shazbot.org>
To: Julian Ruess <julianr@linux.ibm.com>
Cc: schnelle@linux.ibm.com, wintera@linux.ibm.com, ts@linux.ibm.com,
 oberpar@linux.ibm.com, gbayer@linux.ibm.com, Jason Gunthorpe
 <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
 hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-pci@vger.kernel.org, alex@shazbot.org
Subject: Re: [PATCH v2 2/3] vfio/ism: Implement vfio_pci driver for ISM
 devices
Message-ID: <20260227151201.61cdb696@shazbot.org>
In-Reply-To: <20260224-vfio_pci_ism-v2-2-f010945373fa@linux.ibm.com>
References: <20260224-vfio_pci_ism-v2-0-f010945373fa@linux.ibm.com>
	<20260224-vfio_pci_ism-v2-2-f010945373fa@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-72235-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,shazbot.org:mid,shazbot.org:dkim,messagingengine.com:dkim]
X-Rspamd-Queue-Id: D9C801BE917
X-Rspamd-Action: no action

On Tue, 24 Feb 2026 13:34:33 +0100
Julian Ruess <julianr@linux.ibm.com> wrote:

> Add a vfio_pci variant driver for the s390-specific Internal Shared
> Memory (ISM) devices used for inter-VM communication.
> 
> This enables the development of vfio-pci-based user space drivers for
> ISM devices.
> 
> On s390, kernel primitives such as ioread() and iowrite() are switched
> over from function handle based PCI load/stores instructions to PCI
> memory-I/O (MIO) loads/stores when these are available and not
> explicitly disabled. Since these instructions cannot be used with ISM
> devices, ensure that classic function handle-based PCI instructions are
> used instead.
> 
> The driver is still required even when MIO instructions are disabled, as
> the ISM device relies on the PCI store block (PCISTB) instruction to
> perform write operations.
> 
> Stores are not fragmented, therefore one ioctl corresponds to exactly
> one PCISTB instruction. User space must ensure to not write more than
> 4096 bytes at once to an ISM BAR which is the maximum payload of the
> PCISTB instruction.
> 
> Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
> ---
>  drivers/vfio/pci/Kconfig      |   2 +
>  drivers/vfio/pci/Makefile     |   2 +
>  drivers/vfio/pci/ism/Kconfig  |  11 ++
>  drivers/vfio/pci/ism/Makefile |   3 +
>  drivers/vfio/pci/ism/main.c   | 297 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 315 insertions(+)
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 1e82b44bda1a0a544e1add7f4b06edecf35aaf81..296bf01e185ecacc388ebc69e92706c99e47c814 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -60,6 +60,8 @@ config VFIO_PCI_DMABUF
>  
>  source "drivers/vfio/pci/mlx5/Kconfig"
>  
> +source "drivers/vfio/pci/ism/Kconfig"
> +
>  source "drivers/vfio/pci/hisilicon/Kconfig"
>  
>  source "drivers/vfio/pci/pds/Kconfig"
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index e0a0757dd1d2b0bc69b7e4d79441d5cacf4e1cd8..6138f1bf241df04e7419f196b404abdf9b194050 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -11,6 +11,8 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>  
>  obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  
> +obj-$(CONFIG_ISM_VFIO_PCI)           += ism/
> +
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>  
>  obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> diff --git a/drivers/vfio/pci/ism/Kconfig b/drivers/vfio/pci/ism/Kconfig
> new file mode 100644
> index 0000000000000000000000000000000000000000..072b41099601b84e8d3b4a915ebdb3eebdf10488
> --- /dev/null
> +++ b/drivers/vfio/pci/ism/Kconfig
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0
> +config ISM_VFIO_PCI
> +	tristate "VFIO support for ISM devices"
> +	depends on S390
> +	select VFIO_PCI_CORE
> +	help
> +	  This provides user space support for
> +	  IBM Internal Shared Memory (ISM) Adapter devices
> +	  using the VFIO framework.

Nit, strange wrapping.

> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/ism/Makefile b/drivers/vfio/pci/ism/Makefile
> new file mode 100644
> index 0000000000000000000000000000000000000000..32cc3c66dd11395da85a2b6f05b3d97036ed8a35
> --- /dev/null
> +++ b/drivers/vfio/pci/ism/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0
> +obj-$(CONFIG_ISM_VFIO_PCI) += ism-vfio-pci.o
> +ism-vfio-pci-y := main.o
> diff --git a/drivers/vfio/pci/ism/main.c b/drivers/vfio/pci/ism/main.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..5f9674f6dd1d44888c4e1e416d05edfd89fd09fe
> --- /dev/null
> +++ b/drivers/vfio/pci/ism/main.c
> @@ -0,0 +1,297 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * vfio-ISM driver for s390
> + *
> + * Copyright IBM Corp.
> + */
> +
> +#include "../vfio_pci_priv.h"
> +
> +#define ISM_VFIO_PCI_OFFSET_SHIFT   48
> +#define ISM_VFIO_PCI_OFFSET_TO_INDEX(off) (off >> ISM_VFIO_PCI_OFFSET_SHIFT)
> +#define ISM_VFIO_PCI_INDEX_TO_OFFSET(index) ((u64)(index) << ISM_VFIO_PCI_OFFSET_SHIFT)
> +#define ISM_VFIO_PCI_OFFSET_MASK (((u64)(1) << ISM_VFIO_PCI_OFFSET_SHIFT) - 1)
> +
> +struct ism_vfio_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +};
> +
> +static int ism_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct ism_vfio_pci_core_device *ivdev;
> +	struct vfio_pci_core_device *vdev;
> +	int ret;
> +
> +	ivdev = container_of(core_vdev, struct ism_vfio_pci_core_device,
> +			     core_device.vdev);
> +	vdev = &ivdev->core_device;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +	return 0;
> +}
> +
> +static ssize_t ism_vfio_pci_do_io_r(struct vfio_pci_core_device *vdev,
> +				    char __user *buf, loff_t off, size_t count,
> +				    int bar)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	ssize_t ret, done = 0;
> +	u64 req, length, tmp;
> +
> +	while (count) {
> +		if (count >= 8 && IS_ALIGNED(off, 8))
> +			length = 8;
> +		else if (count >= 4 && IS_ALIGNED(off, 4))
> +			length = 4;
> +		else if (count >= 2 && IS_ALIGNED(off, 2))
> +			length = 2;
> +		else
> +			length = 1;
> +		req = ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, length);
> +		/* use pcilg to prevent using MIO instructions */
> +		ret = __zpci_load(&tmp, req, off);
> +		if (ret)
> +			return ret;
> +		if (copy_to_user(buf, &tmp, length))
> +			return -EFAULT;
> +		count -= length;
> +		done += length;
> +		off += length;
> +		buf += length;
> +	}
> +	return done;
> +}
> +
> +static ssize_t ism_vfio_pci_do_io_w(struct vfio_pci_core_device *vdev,
> +				    char __user *buf, loff_t off, size_t count,
> +				    int bar)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	void *data __free(kfree) = NULL;
> +	ssize_t ret;
> +	u64 req;
> +
> +	if (count > zdev->maxstbl)
> +		return -EINVAL;
> +	data = kzalloc(count, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +	if (copy_from_user(data, buf, count))
> +		return -EFAULT;
> +	req = ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, count);
> +	ret = __zpci_store_block(data, req, off);
> +	if (ret)
> +		return ret;
> +	return count;
> +}

Some comments mirroring the commit log wrt this different read vs write
behavior would likely be useful.  We could also note the requirement
for the 48bit region address space above.  Thanks,

Alex


> +
> +static ssize_t ism_vfio_pci_bar_rw(struct vfio_pci_core_device *vdev,
> +				   char __user *buf, size_t count, loff_t *ppos,
> +				   bool iswrite)
> +{
> +	int bar = ISM_VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & ISM_VFIO_PCI_OFFSET_MASK;
> +	resource_size_t end;
> +	ssize_t done = 0;
> +
> +	if (pci_resource_start(vdev->pdev, bar))
> +		end = pci_resource_len(vdev->pdev, bar);
> +	else
> +		return -EINVAL;
> +
> +	if (pos >= end)
> +		return -EINVAL;
> +
> +	count = min(count, (size_t)(end - pos));
> +
> +	if (iswrite)
> +		done = ism_vfio_pci_do_io_w(vdev, buf, pos, count, bar);
> +	else
> +		done = ism_vfio_pci_do_io_r(vdev, buf, pos, count, bar);
> +
> +	if (done >= 0)
> +		*ppos += done;
> +
> +	return done;
> +}
> +
> +static ssize_t ism_vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
> +				      char __user *buf, size_t count,
> +				      loff_t *ppos, bool iswrite)
> +{
> +	loff_t pos = *ppos;
> +	size_t done = 0;
> +	int ret = 0;
> +
> +	pos &= ISM_VFIO_PCI_OFFSET_MASK;
> +
> +	while (count) {
> +		/*
> +		 * zPCI must not use MIO instructions for config space access,
> +		 * so we can use common code path here.
> +		 */
> +		ret = vfio_pci_config_rw_single(vdev, buf, count, &pos, iswrite);
> +		if (ret < 0)
> +			return ret;
> +
> +		count -= ret;
> +		done += ret;
> +		buf += ret;
> +		pos += ret;
> +	}
> +
> +	*ppos += done;
> +
> +	return done;
> +}
> +
> +static ssize_t ism_vfio_pci_rw(struct vfio_device *core_vdev, char __user *buf,
> +			       size_t count, loff_t *ppos, bool iswrite)
> +{
> +	unsigned int index = ISM_VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct vfio_pci_core_device *vdev;
> +	int ret;
> +
> +	vdev = container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +
> +	if (!count)
> +		return 0;
> +
> +	switch (index) {
> +	case VFIO_PCI_CONFIG_REGION_INDEX:
> +		ret = ism_vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
> +		break;
> +
> +	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
> +		ret = ism_vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static ssize_t ism_vfio_pci_read(struct vfio_device *core_vdev,
> +				 char __user *buf, size_t count, loff_t *ppos)
> +{
> +	return ism_vfio_pci_rw(core_vdev, buf, count, ppos, false);
> +}
> +
> +static ssize_t ism_vfio_pci_write(struct vfio_device *core_vdev,
> +				  const char __user *buf, size_t count,
> +				  loff_t *ppos)
> +{
> +	return ism_vfio_pci_rw(core_vdev, (char __user *)buf, count, ppos,
> +			       true);
> +}
> +
> +static int ism_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
> +					      struct vfio_region_info *info,
> +					      struct vfio_info_cap *caps)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct pci_dev *pdev = vdev->pdev;
> +
> +	switch (info->index) {
> +	case VFIO_PCI_CONFIG_REGION_INDEX:
> +		info->offset = ISM_VFIO_PCI_INDEX_TO_OFFSET(info->index);
> +		info->size = pdev->cfg_size;
> +		info->flags = VFIO_REGION_INFO_FLAG_READ |
> +			      VFIO_REGION_INFO_FLAG_WRITE;
> +		break;
> +	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
> +		info->offset = ISM_VFIO_PCI_INDEX_TO_OFFSET(info->index);
> +		info->size = pci_resource_len(pdev, info->index);
> +		if (!info->size) {
> +			info->flags = 0;
> +			break;
> +		}
> +		info->flags = VFIO_REGION_INFO_FLAG_READ |
> +			      VFIO_REGION_INFO_FLAG_WRITE;
> +		break;
> +	default:
> +		info->offset = 0;
> +		info->size = 0;
> +		info->flags = 0;
> +	}
> +	return 0;
> +}
> +
> +static const struct vfio_device_ops ism_pci_ops = {
> +	.name = "ism-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = ism_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.get_region_info_caps = ism_vfio_pci_ioctl_get_region_info,
> +	.device_feature = vfio_pci_core_ioctl_feature,
> +	.read = ism_vfio_pci_read,
> +	.write = ism_vfio_pci_write,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas = vfio_iommufd_physical_detach_ioas,
> +};
> +
> +static int ism_vfio_pci_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	struct ism_vfio_pci_core_device *ivpcd;
> +	int ret;
> +
> +	ivpcd = vfio_alloc_device(ism_vfio_pci_core_device, core_device.vdev,
> +				  &pdev->dev, &ism_pci_ops);
> +	if (IS_ERR(ivpcd))
> +		return PTR_ERR(ivpcd);
> +
> +	dev_set_drvdata(&pdev->dev, &ivpcd->core_device);
> +	ret = vfio_pci_core_register_device(&ivpcd->core_device);
> +	if (ret)
> +		vfio_put_device(&ivpcd->core_device.vdev);
> +	return ret;
> +}
> +
> +static void ism_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device;
> +	struct ism_vfio_pci_core_device *ivpcd;
> +
> +	core_device = dev_get_drvdata(&pdev->dev);
> +	ivpcd = container_of(core_device, struct ism_vfio_pci_core_device,
> +			     core_device);
> +
> +	vfio_pci_core_unregister_device(&ivpcd->core_device);
> +	vfio_put_device(&ivpcd->core_device.vdev);
> +}
> +
> +static const struct pci_device_id ism_device_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_IBM,
> +					  PCI_DEVICE_ID_IBM_ISM) },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(pci, ism_device_table);
> +
> +static struct pci_driver ism_vfio_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = ism_device_table,
> +	.probe = ism_vfio_pci_probe,
> +	.remove = ism_vfio_pci_remove,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(ism_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("vfio-pci variant driver for the IBM Internal Shared Memory (ISM) device");
> +MODULE_AUTHOR("IBM Corporation");
> 


