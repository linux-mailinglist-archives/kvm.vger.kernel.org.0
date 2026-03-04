Return-Path: <kvm+bounces-72756-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEjXIb25qGngwgAAu9opvQ
	(envelope-from <kvm+bounces-72756-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:01:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C56208D33
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C476A3031B1B
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD3635FF6E;
	Wed,  4 Mar 2026 23:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="DzjmDGCP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="umhnjopa"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE221F0E29;
	Wed,  4 Mar 2026 23:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772665262; cv=none; b=oMAWltXoanI5B28kUPU37D1pYlh9iGtLEQDP0PQW66j+hj+8IZRVi6WhknoL5M7PWcUbYtVlTCaS03DS97PohrtMM4SMMP16bJvBDjtCbq2HLIV8DmU7Tag265tbyUsXJbfwxHjo8B3MXttxK2jUvAL5cpu9qsB7XzblS59Q+No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772665262; c=relaxed/simple;
	bh=GqLO3C6w0d+y0tfc9gEXEMJH0qO5GOLWl6dpJbsyIq0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eyQxK8kvWiUyar62TID+u7LNwS59W6hcjpCI+kdAFRQpvDk0GrOkv56X4g9gqUYgwbyvscentrbMTXJ2Cq71iQiKYrO9i8JAX76t3sEof/KhMiBFQu+qmiiuEngI1cbyNwWGbytA1CzFDM+HjGBUI74mV/ulFlWTSO22oNrCpO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=DzjmDGCP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=umhnjopa; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 659127A029C;
	Wed,  4 Mar 2026 18:00:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 04 Mar 2026 18:00:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772665258;
	 x=1772751658; bh=r/PRIHX4lIvWM+lBPCUYpSx6j4ei0cZLmnLn5ed6jto=; b=
	DzjmDGCPIxXO76iIf8fY9b4JIV1uwcrMkmKWGv98Y+jmx/ccc7BVU2wIFHovxx37
	ZN19T3pIDGfU2S9MyQsXbGlFmrHaUDO0xUXQa9RNqNCkptAS7+IO8d0ulRhKDSex
	frZUoNDJO2JlnJoo+VSOZP62v6GwXrewpUHp9gDrnL2N8owNvrkp/VGG8fzmLtd0
	SROYRmfBiLgUIpGxtl+vgYnMyMh3pAyiIlvuiVUjvhPXDLjW/DjGp8H1oQ4d4WYK
	slyYIzYwpTze+T1PoNck3pA8xy9ceyL0n81EB7IpuzxBRZKLarm9B/eMJdFXweNS
	BK5OUOpyUOVgM5q+BKHbJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772665258; x=
	1772751658; bh=r/PRIHX4lIvWM+lBPCUYpSx6j4ei0cZLmnLn5ed6jto=; b=u
	mhnjopatUSorO1+DVnQhbzEcgvoopn9hKJnf3ozWp2zdX2IEM1i3jefm+/PqSyK6
	qUMqqp1RA3MfxjSVZXIz51bTeriJ5d8AENhWcnlnxzXWgckse1jXSB834nsiq/jd
	cpghj/nkBJpN5qbR4J0L/4fvCj+8VuLBwawVNcZPYUYAtGbql/WtstRHItX0+5jz
	YWJDuPJFiP48s9FA5aYRKMwnpkeiGp2EOeoSKecaUEXdet3LGkii0DyNmPgxsC6k
	2/YUJ7Ui006W+ZTqx5rzIK8NPI7lJTC9v5umuAEtD2/1heoXIymDXPl9afXLaNfs
	aUnpHwDXS109YQsuZ8GuQ==
X-ME-Sender: <xms:qrmoaWmOisRUjA8AurXzxLp7fkd90GURJNb_M7FWeQhhn3nNWcWcBQ>
    <xme:qrmoaTBAPbKv0MC2SQEvhHrWJBDFE6PD9eWIyybXasG7MG6fFjA8B97wpEzTOqMig
    Fuyvq-54-Xnq_wqOKM63aapLlKfF1-pXmiPzTlbOxy5fODS6OFvVFc>
X-ME-Received: <xmr:qrmoaYD8adeNEZhjwQcLp-pT8GDzhv8yOPyxpwKmxTh8TvctwdcYyyVDvJY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvdekfeejkedvudfhudfhteekud
    fgudeiteetvdeukedvheetvdekgfdugeevueeunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsg
    gprhgtphhtthhopedugedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghnkhhi
    thgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepmhho
    tghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpd
    hrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphht
    thhopegtjhhirgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepiihhihifsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehkjhgrjhhusehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:qrmoaaHBGVXgQzo-QL6UJEy3dXBOy4fCNq4fwTBSV0QCBE4xvCkAAw>
    <xmx:qrmoaf6q1WAoywy_f_sRV_jwGYx9-dl1OfENWJkfnbqi63A5O9sLkA>
    <xmx:qrmoaRSColmS3ZL9ZJGVzp9kOC5B-aLn5jkMkVbxkiOZUgjDR4r67A>
    <xmx:qrmoaa7rOrAKFq6WIFu9hjWx3hZZ6Zx3GtWx6XqiyniOUMJI749RxA>
    <xmx:qrmoaZSXF71SX7MVD84lhsR8vHAOiFBPHN-DCnIa15GLXuhD9fRkCYiM>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 18:00:57 -0500 (EST)
Date: Wed, 4 Mar 2026 16:00:55 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 12/15] vfio/nvgrace-egm: Introduce ioctl to share
 retired pages
Message-ID: <20260304160055.38ea91be@shazbot.org>
In-Reply-To: <20260223155514.152435-13-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-13-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 45C56208D33
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72756-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,shazbot.org:dkim,shazbot.org:mid,messagingengine.com:dkim]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:11 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> nvgrace-egm module stores the list of retired page offsets to be made
> available for usermode processes. Introduce an ioctl to share the
> information with the userspace.
> 
> The ioctl is called by usermode apps such as QEMU to get the retired
> page offsets. The usermode apps are expected to take appropriate action
> to communicate the list to the VM.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                        |  1 +
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 67 ++++++++++++++++++++++++++++++
>  include/uapi/linux/egm.h           | 28 +++++++++++++
>  3 files changed, 96 insertions(+)
>  create mode 100644 include/uapi/linux/egm.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1fc551d7d667..94cf15a1e82c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27389,6 +27389,7 @@ M:	Ankit Agrawal <ankita@nvidia.com>
>  L:	kvm@vger.kernel.org
>  S:	Supported
>  F:	drivers/vfio/pci/nvgrace-gpu/egm.c
> +F:	include/uapi/linux/egm.h
>  
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> index 077de3833046..918979d8fcd4 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -5,6 +5,7 @@
>  
>  #include <linux/vfio_pci_core.h>
>  #include <linux/nvgrace-egm.h>
> +#include <linux/egm.h>
>  
>  #define MAX_EGM_NODES 4
>  
> @@ -119,11 +120,77 @@ static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
>  			       vma->vm_page_prot);
>  }
>  
> +static long nvgrace_egm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	unsigned long minsz = offsetofend(struct egm_retired_pages_list, count);
> +	struct egm_retired_pages_list info;
> +	void __user *uarg = (void __user *)arg;
> +	struct chardev *egm_chardev = file->private_data;
> +
> +	if (copy_from_user(&info, uarg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz || !egm_chardev)
> +		return -EINVAL;

How could we get here with !egm_chardev?

> +
> +	switch (cmd) {
> +	case EGM_RETIRED_PAGES_LIST:
> +		int ret;
> +		unsigned long retired_page_struct_size = sizeof(struct egm_retired_pages_info);
> +		struct egm_retired_pages_info tmp;
> +		struct h_node *cur_page;
> +		struct hlist_node *tmp_node;
> +		unsigned long bkt;
> +		int count = 0, index = 0;

No brackets for inline declarations.  Ordering could be improved.

> +
> +		hash_for_each_safe(egm_chardev->htbl, bkt, tmp_node, cur_page, node)
> +			count++;

Why not keep track of the count as they're added?

Neither loop here needs the _safe variant here since we're not removing
entries.

> +
> +		if (info.argsz < (minsz + count * retired_page_struct_size)) {
> +			info.argsz = minsz + count * retired_page_struct_size;
> +			info.count = 0;

vfio returns success when there's not enough space for compatibility
for new capabilities.  For a new ioctl just set argsz and count and
return -ENOSPC.

> +			goto done;
> +		} else {

We don't need an else if the previous branch unconditionally goes
somewhere else.

> +			hash_for_each_safe(egm_chardev->htbl, bkt, tmp_node, cur_page, node) {
> +				/*
> +				 * This check fails if there was an ECC error
> +				 * after the usermode app read the count of
> +				 * bad pages through this ioctl.
> +				 */
> +				if (minsz + index * retired_page_struct_size >= info.argsz) {
> +					info.argsz = minsz + index * retired_page_struct_size;
> +					info.count = index;

If only we had locking to prevent such races...

> +					goto done;
> +				}
> +
> +				tmp.offset = cur_page->mem_offset;
> +				tmp.size = PAGE_SIZE;

Is firmware recording 4K or 64K pages in this table?

The above comment alludes runtime ECC faults, are those a different
page size from the granularity firmware reports in the table?

> +
> +				ret = copy_to_user(uarg + minsz +
> +						   index * retired_page_struct_size,
> +						   &tmp, retired_page_struct_size);
> +				if (ret)
> +					return -EFAULT;
> +				index++;
> +			}
> +
> +			info.count = index;
> +		}
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +done:
> +	return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
> +}
> +
>  static const struct file_operations file_ops = {
>  	.owner = THIS_MODULE,
>  	.open = nvgrace_egm_open,
>  	.release = nvgrace_egm_release,
>  	.mmap = nvgrace_egm_mmap,
> +	.unlocked_ioctl = nvgrace_egm_ioctl,
>  };
>  
>  static void egm_chardev_release(struct device *dev)
> diff --git a/include/uapi/linux/egm.h b/include/uapi/linux/egm.h
> new file mode 100644
> index 000000000000..4d3a2304d4f0
> --- /dev/null
> +++ b/include/uapi/linux/egm.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved

2026

> + */
> +
> +#ifndef _UAPI_LINUX_EGM_H
> +#define _UAPI_LINUX_EGM_H
> +
> +#include <linux/types.h>
> +
> +#define EGM_TYPE ('E')

Arbitrarily chosen?  Update ioctl-number.rst?

> +
> +struct egm_retired_pages_info {
> +	__aligned_u64 offset;
> +	__aligned_u64 size;
> +};
> +
> +struct egm_retired_pages_list {
> +	__u32 argsz;
> +	/* out */
> +	__u32 count;
> +	/* out */
> +	struct egm_retired_pages_info retired_pages[];
> +};

I imagine you want some uapi description of this ioctl.  Thanks,

Alex

> +
> +#define EGM_RETIRED_PAGES_LIST     _IO(EGM_TYPE, 100)
> +
> +#endif /* _UAPI_LINUX_EGM_H */


