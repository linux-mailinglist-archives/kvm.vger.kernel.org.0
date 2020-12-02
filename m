Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998802CC612
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgLBS6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:58:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbgLBS6y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 13:58:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606935448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iW9Y+FK67QlpiMgzFvAg8dTUxB+fwY2PmZJLE/xIKww=;
        b=e7ZOK7u3VcLYXhq9y1h4i6VSs9TMIeSC7q5tEmES+/OKiwV9mePxnH8THdA/SF2MsA6K53
        y8hIW+i3P/nRiNIUpTSSfBO+a8lP0Hz3uhM2crj04xflQ/07hmOwrM7FvnT4UdwI7ITCEo
        dUFlq2ji7jL7m7RUdd/uTf9lPA97tvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-UrWc0JhgNjGsYrIpgq6Gkg-1; Wed, 02 Dec 2020 13:57:25 -0500
X-MC-Unique: UrWc0JhgNjGsYrIpgq6Gkg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EEDB858187;
        Wed,  2 Dec 2020 18:57:24 +0000 (UTC)
Received: from w520.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A15C5C22B;
        Wed,  2 Dec 2020 18:57:24 +0000 (UTC)
Date:   Wed, 2 Dec 2020 11:57:23 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Fred Gao <fred.gao@intel.com>
Cc:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Swee Yee Fonn <swee.yee.fonn@intel.com>
Subject: Re: [PATCH v1] vfio/pci: Add support for opregion v2.0+
Message-ID: <20201202115723.27df527b@w520.home>
In-Reply-To: <20201202171249.17083-1-fred.gao@intel.com>
References: <20201202171249.17083-1-fred.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Dec 2020 01:12:49 +0800
Fred Gao <fred.gao@intel.com> wrote:

> When VBT data exceeds 6KB size and cannot be within mailbox #4 starting
> from opregion v2.0+, Extended VBT region, next to opregion, is used to
> hold the VBT data, so the total size will be opregion size plus
> extended VBT region size.
> 
> For opregion 2.1+: since rvda is relative offset from opregion base,
> rvda as extended VBT start offset should be same as opregion size.
> 
> For opregion 2.0: the only difference between opregion 2.0 and 2.1 is
> rvda addressing mode besides the version. since rvda is physical host
> VBT address and cannot be directly used in guest, it is faked into
> opregion 2.1's relative offset.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Signed-off-by: Swee Yee Fonn <swee.yee.fonn@intel.com>
> Signed-off-by: Fred Gao <fred.gao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 44 +++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index 53d97f459252..78919a289914 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -21,6 +21,17 @@
>  #define OPREGION_SIZE		(8 * 1024)
>  #define OPREGION_PCI_ADDR	0xfc
>  
> +/*
> + * opregion 2.0: rvda is the physical VBT address.

What's rvda?  What's VBT?

> + *
> + * opregion 2.1+: rvda is unsigned, relative offset from
> + * opregion base, and should never point within opregion.
> + */
> +#define OPREGION_RDVA		0x3ba
> +#define OPREGION_RDVS		0x3c2
> +#define OPREGION_VERSION	22

Why is this specified as decimal and the others in hex?  This makes it
seem like the actual version rather than the offset of a version
register.

> +
> +
>  static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>  			      size_t count, loff_t *ppos, bool iswrite)
>  {
> @@ -58,6 +69,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>  	u32 addr, size;
>  	void *base;
>  	int ret;
> +	u16 version;
>  
>  	ret = pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR, &addr);
>  	if (ret)
> @@ -83,6 +95,38 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>  
>  	size *= 1024; /* In KB */
>  
> +	/* Support opregion v2.0+ */
> +	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
> +	if (version >= 0x0200) {
> +		u64 rvda;
> +		u32 rvds;
> +
> +		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RDVA));
> +		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RDVS));
> +		if (rvda && rvds) {
> +			u32 offset;
> +
> +			if (version == 0x0200)
> +				offset = (rvda - (u64)addr);

Unnecessary outer ()

> +			else
> +				offset = rvda;
> +
> +			pci_WARN(vdev->pdev, offset != size,
> +				"Extended VBT does not follow opregion !\n"
> +				"opregion version 0x%x:offset 0x%x\n", version, offset);
> +
> +			if (version == 0x0200) {
> +				/* opregion version v2.0 faked to v2.1 */
> +				*(__le16 *)(base + OPREGION_VERSION) =
> +					cpu_to_le16(0x0201);
> +				/* rvda faked to relative offset */
> +				(*(__le64 *)(base + OPREGION_RDVA)) =
> +					cpu_to_le64((rvda - (u64)addr));

We're writing to the OpRegion and affecting all future use of it, seems
dangerous.


> +			}
> +			size = offset + rvds;


We warn about VBT (whatever that is) not immediately following the
OpRegion, but then we go ahead and size the thing that we expose to
userspace to allow read access to everything between the OpRegion and
VBT??

> +		}
> +	}
> +
>  	if (size != OPREGION_SIZE) {
>  		memunmap(base);
>  		base = memremap(addr, size, MEMREMAP_WB);

