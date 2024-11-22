Return-Path: <kvm+bounces-32373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D2B9D6287
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 17:48:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E111281D3B
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 16:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4363513B797;
	Fri, 22 Nov 2024 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fGY5ji+W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FD460890
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 16:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294119; cv=none; b=uowdGYYDuTtA3sx1fn8xF5SAcmEzKoxieoL0xyk60lK2cufPqZjXLXHcqG0dX1f21OJMbakJg74J7OoQpO1ujnDm0nXP2+RwSmFy2t6unXaRhIzHFMP7ycw8HmkVJCM7hcE3fxZ30I5Yg0PYpZXEkpDzgXqD08f6S46PeqpDMcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294119; c=relaxed/simple;
	bh=D0ZoNb4AGm2sVITtfXgH8IoHdKx0Ian+mInrIdUUVIg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ssHTu/KLoEkognxVIoekOi+AGID/Y+BVstHsgz/nRJtxdjcjme1FV3mTtej//6N6IznM1etZ9SE9aKlVoh4oDGGoKEaJYnqgzFm+XTH6RKLUZTIr0ip8VQX8pUQ9KLvnufv4ktQQ2tmwqjGltnhQ08L8ITLOU/ut55qh3L8LhYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fGY5ji+W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732294116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zVCDFXaNMsuGWcQ78ZTx+x+51IuTZpYbcUeipG7O7qM=;
	b=fGY5ji+WfV8a+d3wEKPVW0jQCVuuVZJL9ufF2NJKwj6SunJ0CsaEOnCiPZn+Cmkpm2kcZE
	oqXX0j6KLcJkiucCT32FnVdherUH15qX6ncz3Dv/gcUZRDmpKzT9/Go8+BqU88gKRovtJE
	T6Fy43DVGEPvtM2ixPO+CAf7ThIPveg=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-ekAiCqf8MEqiViVFWDG_KA-1; Fri, 22 Nov 2024 11:48:35 -0500
X-MC-Unique: ekAiCqf8MEqiViVFWDG_KA-1
X-Mimecast-MFC-AGG-ID: ekAiCqf8MEqiViVFWDG_KA
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7180d9a3693so214353a34.1
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 08:48:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732294114; x=1732898914;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zVCDFXaNMsuGWcQ78ZTx+x+51IuTZpYbcUeipG7O7qM=;
        b=nlRfOT8SvIlXzTFDYafIreLF3aKeQ2vAEBohe7Mu9kwNqhR3yZonPSXq7d4hcc4zsi
         3PthTXwoBJi4ruaI48Okk0EMtLntfpXB9oHreYRgK14m//vHc/zD8X1ikDdggzGHtgzO
         FDgOkyWY+UKftPNLOuKDPIXyHHmr2TMQIWVkY4zwAXUx4Focm3/8p9HBCUK2p3CC6a6E
         Gz/ywMUxX0GAffGByhCdElqA9xg9X/bBCk+LVokmJ/EypuLLgu85eYs/McqNGlcpAC/I
         Vb3i9uvfVwokiSTQ7jFYBMaVDxmm11KqoXm+Ul2iKNHBIFP++RgJZLzsAls4kRWT+6sS
         ladA==
X-Forwarded-Encrypted: i=1; AJvYcCW4HiSFpJa/0nCL+20c+wghdCSjAqHINMAHJX+zl6CRfGMD0ULRDdzZo5O2QRDEWjXd2IU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3W1rIZ264znRUjP5tC8nPImRnUbqTlTalR1v1SC4QF2KbuuKk
	97Qx2pGdhxRv5bnAE0AOPABdi2FLGLRZpzFKeu3OlYUNb1Vn+y4qKahEAuS4g4SJ8w8d3in1JSl
	bdNaTvCyEqKJbnZgJf3L2ZK+bwfg7btvK2y4Czc2AFu9Us8qKCg==
X-Gm-Gg: ASbGnctsMNiiZJLvE4wIUTmlvor+yKBgVQq8RPLDUPzrx6vtPJmWswcrhOnTON14ac8
	qq6HaVwLmSdORR+6160E/FGXKw6lfeheBvh5Kc8laqzEbFT03cWDB5zyUGXSo6vIQVnVGyNWJzP
	fwQJCMctGd53LX7Js9PuwInpYO31cYtngJBFXvZQCkIxk7VnS/6kzO0MRn8ZnkDlSSJt0zE2hQ1
	3QmNenAkfi/VTq/bZP1w0G6q4NxRCR8Lg77kwDli9wZNNVlCyTA0g==
X-Received: by 2002:a05:6808:1688:b0:3e6:3c95:833a with SMTP id 5614622812f47-3e915a5650fmr1089797b6e.5.1732294114189;
        Fri, 22 Nov 2024 08:48:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3Av3rPnef7b1nFePTLpQ+b74HDm9lqwrf1VG8fxLrQwWOnILmiDQGIDJbxt3KQ+3cCmahtQ==
X-Received: by 2002:a05:6808:1688:b0:3e6:3c95:833a with SMTP id 5614622812f47-3e915a5650fmr1089737b6e.5.1732294112356;
        Fri, 22 Nov 2024 08:48:32 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71c03772b01sm481000a34.20.2024.11.22.08.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 08:48:30 -0800 (PST)
Date: Fri, 22 Nov 2024 09:48:26 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Avihai Horon <avihaih@nvidia.com>, <kvm@vger.kernel.org>, Yishai Hadas
 <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Maor Gottlieb
 <maorg@nvidia.com>
Subject: Re: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended
 capability
Message-ID: <20241122094826.142a5d54.alex.williamson@redhat.com>
In-Reply-To: <14709dcf-d7fe-4579-81b9-28065ce15f3e@intel.com>
References: <20241121140057.25157-1-avihaih@nvidia.com>
	<14709dcf-d7fe-4579-81b9-28065ce15f3e@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 22 Nov 2024 20:45:08 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2024/11/21 22:00, Avihai Horon wrote:
> > There are cases where a PCIe extended capability should be hidden from
> > the user. For example, an unknown capability (i.e., capability with ID
> > greater than PCI_EXT_CAP_ID_MAX) or a capability that is intentionally
> > chosen to be hidden from the user.
> > 
> > Hiding a capability is done by virtualizing and modifying the 'Next
> > Capability Offset' field of the previous capability so it points to the
> > capability after the one that should be hidden.
> > 
> > The special case where the first capability in the list should be hidden
> > is handled differently because there is no previous capability that can
> > be modified. In this case, the capability ID and version are zeroed
> > while leaving the next pointer intact. This hides the capability and
> > leaves an anchor for the rest of the capability list.
> > 
> > However, today, hiding the first capability in the list is not done
> > properly if the capability is unknown, as struct
> > vfio_pci_core_device->pci_config_map is set to the capability ID during
> > initialization but the capability ID is not properly checked later when
> > used in vfio_config_do_rw(). This leads to the following warning [1] and
> > to an out-of-bounds access to ecap_perms array.
> > 
> > Fix it by checking cap_id in vfio_config_do_rw(), and if it is greater
> > than PCI_EXT_CAP_ID_MAX, use an alternative struct perm_bits for direct
> > read only access instead of the ecap_perms array.
> > 
> > Note that this is safe since the above is the only case where cap_id can
> > exceed PCI_EXT_CAP_ID_MAX (except for the special capabilities, which
> > are already checked before).
> > 
> > [1]
> > 
> > WARNING: CPU: 118 PID: 5329 at drivers/vfio/pci/vfio_pci_config.c:1900 vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]  
> 
> strange, it is not in the vfio_config_do_rw(). But never mind.
> 
> > CPU: 118 UID: 0 PID: 5329 Comm: simx-qemu-syste Not tainted 6.12.0+ #1
> > (snip)
> > Call Trace:
> >   <TASK>
> >   ? show_regs+0x69/0x80
> >   ? __warn+0x8d/0x140
> >   ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
> >   ? report_bug+0x18f/0x1a0
> >   ? handle_bug+0x63/0xa0
> >   ? exc_invalid_op+0x19/0x70
> >   ? asm_exc_invalid_op+0x1b/0x20
> >   ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
> >   ? vfio_pci_config_rw+0x244/0x430 [vfio_pci_core]
> >   vfio_pci_rw+0x101/0x1b0 [vfio_pci_core]
> >   vfio_pci_core_read+0x1d/0x30 [vfio_pci_core]
> >   vfio_device_fops_read+0x27/0x40 [vfio]
> >   vfs_read+0xbd/0x340
> >   ? vfio_device_fops_unl_ioctl+0xbb/0x740 [vfio]
> >   ? __rseq_handle_notify_resume+0xa4/0x4b0
> >   __x64_sys_pread64+0x96/0xc0
> >   x64_sys_call+0x1c3d/0x20d0
> >   do_syscall_64+0x4d/0x120
> >   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > 
> > Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> > Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> > ---
> > Changes from v1:
> > * Use Alex's suggestion to fix the bug and adapt the commit message.
> > ---
> >   drivers/vfio/pci/vfio_pci_config.c | 20 ++++++++++++++++----
> >   1 file changed, 16 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > index 97422aafaa7b..b2a1ba66e5f1 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -313,12 +313,16 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
> >   	return count;
> >   }
> >   
> > +static const struct perm_bits direct_ro_perms = {
> > +	.readfn = vfio_direct_config_read,
> > +};
> > +
> >   /* Default capability regions to read-only, no-virtualization */
> >   static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
> > -	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
> > +	[0 ... PCI_CAP_ID_MAX] = direct_ro_perms
> >   };
> >   static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
> > -	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
> > +	[0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
> >   };
> >   /*
> >    * Default unassigned regions to raw read-write access.  Some devices
> > @@ -1897,9 +1901,17 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
> >   		cap_start = *ppos;
> >   	} else {
> >   		if (*ppos >= PCI_CFG_SPACE_SIZE) {
> > -			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
> > +			/*
> > +			 * We can get a cap_id that exceeds PCI_EXT_CAP_ID_MAX
> > +			 * if we're hiding an unknown capability at the start
> > +			 * of the extended capability list.  Use default, ro
> > +			 * access, which will virtualize the id and next values.
> > +			 */
> > +			if (cap_id > PCI_EXT_CAP_ID_MAX)
> > +				perm = (struct perm_bits *)&direct_ro_perms;
> > +			else
> > +				perm = &ecap_perms[cap_id];
> >   
> > -			perm = &ecap_perms[cap_id];
> >   			cap_start = vfio_find_cap_start(vdev, *ppos);
> >   		} else {
> >   			WARN_ON(cap_id > PCI_CAP_ID_MAX);  
> 
> Looks good to me. :) I'm able to trigger this warning by hide the first 
> ecap on my system with the below hack.
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c 
> b/drivers/vfio/pci/vfio_pci_config.c
> index b2a1ba66e5f1..db91e19a48b3 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1617,6 +1617,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device 
> *vdev)
>   	u16 epos;
>   	__le32 *prev = NULL;
>   	int loops, ret, ecaps = 0;
> +	int iii =0;
> 
>   	if (!vdev->extended_caps)
>   		return 0;
> @@ -1635,7 +1636,11 @@ static int vfio_ecap_init(struct 
> vfio_pci_core_device *vdev)
>   		if (ret)
>   			return ret;
> 
> -		ecap = PCI_EXT_CAP_ID(header);
> +		if (iii == 0) {
> +			ecap = 0x61;
> +			iii++;
> +		} else
> +			ecap = PCI_EXT_CAP_ID(header);
> 
>   		if (ecap <= PCI_EXT_CAP_ID_MAX) {
>   			len = pci_ext_cap_length[ecap];
> @@ -1664,6 +1669,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device 
> *vdev)
>   			 */
>   			len = PCI_CAP_SIZEOF;
>   			hidden = true;
> +			printk("%s set hide\n", __func__);
>   		}
> 
>   		for (i = 0; i < len; i++) {
> @@ -1893,6 +1899,7 @@ static ssize_t vfio_config_do_rw(struct 
> vfio_pci_core_device *vdev, char __user
> 
>   	cap_id = vdev->pci_config_map[*ppos];
> 
> +	printk("%s cap_id: %x\n", __func__, cap_id);
>   	if (cap_id == PCI_CAP_ID_INVALID) {
>   		perm = &unassigned_perms;
>   		cap_start = *ppos;
> 
> And then this warning is gone after applying this patch. Hence,
> 
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Yi Liu <yi.l.liu@intel.com>

Thanks, good testing!
 
> But I can still see a valid next pointer. Like the below log, I hide
> the first ecap at offset 0x100, its ID is zeroed. The second ecap locates
> at offset==0x150, its cap_id is 0x0018. I can see the next pointer in the
> guest. Is it expected?

This is what makes hiding the first ecap unique, the ecap chain always
starts at 0x100, the next pointer must be valid for the rest of the
chain to remain.  For standard capabilities we can change the register
pointing at the head of the list.  This therefore looks like expected
behavior, unless I'm missing something more subtle in your example.
 
> Guest:
> 100: 00 00 00 15 00 00 00 00 00 00 10 00 00 00 04 00
> 110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 140: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 150: 18 00 01 16 00 00 00 00 00 00 00 00 00 00 00 00
> 160: 17 00 01 17 05 02 01 00 00 00 00 00 00 00 00 00
> 
> Host:
> 100: 01 00 02 15 00 00 00 00 00 00 10 00 00 00 04 00
> 110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 140: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 150: 18 00 01 16 00 00 00 00 00 00 00 00 00 00 00 00
> 160: 17 00 01 17 05 02 01 00 00 00 00 00 00 00 00 00
> 
> 
> BTW. If the first PCI cap is a unknown cap, will it have a problem? The
> vfio_pci_core_device->pci_config_map is kept to be PCI_CAP_ID_INVALID,
> hence it would use the unassigned_perms. But it makes more sense to use the
> direct_ro_perms introduced here. is it?

Once we've masked the capability ID, if the guest driver is still
touching the remaining body of the capability, we're really in the
space of undefined behavior, imo.  We've already taken the stance that
inter-capability space is accessible as a necessity for certain
devices.  It's certainly been suggested that we might want to take a
more guarded approach, even so far as readjusting the capability layout
for compatibility.  We might head in that direction but I don't think
we should start with this bug fix.  Thanks,

Alex


