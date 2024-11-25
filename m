Return-Path: <kvm+bounces-32402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0C109D7A4D
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 04:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2348281A64
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 03:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0121182D9;
	Mon, 25 Nov 2024 03:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UfLOQU0j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79662500CE
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 03:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732504847; cv=none; b=Pd+4atb7EgS2ckArJLTCWmTBUBMMjcSxwKUTELYIVpg0Dc/S89cxlkdNfld0naj1Kllf7CnfPbduzoKorx2KxMO4Af8tpxDe+1NND1Byv4ejjEAm2dgZ799mBg7N6wl7Pf2l8EENff0TY0PL5g4gAPtbrgvjF5fth/nZhtE+CLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732504847; c=relaxed/simple;
	bh=5dEj2QA6HAmvO7Z/WlMsSpuf/9aWl2J6Gc8q1HiR4DQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MCy19NC7u95+hVMy9QzJPu/WmMctUtWF+Lo85cNUXJCTsC4m8sD/JKBqFmSj78CntQNPyfHWwIrhSMyP7l5OXUZPCkagC4jV2FRrQI8HPopkgudUoIsbWVImDfBfcmr0hoDPGdYP+/aUxBpspzPzxkhmtpKFzXbn7aVpfJFHi2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UfLOQU0j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732504844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQC7z+y5DNQuMhdh54pUxEDWFnkO7kvdaZi28hnEtxE=;
	b=UfLOQU0jRk0f05/C1aGwxIRSiiGybQo6E6mvi8kkwcHNo/4TViY/K7lFje4tul+YN4RfVq
	DQk+kQOMjpyOyliN0o9lolVe9IJaaYPYjatxjDoPB3YBel61aXe14tX7vu4TsNspsQ91YG
	vblm3S6OeHxBJVlE0voeRtw2Vx6TcVM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-4IzV4zPNMBC7WSukWDj-Hg-1; Sun, 24 Nov 2024 22:20:42 -0500
X-MC-Unique: 4IzV4zPNMBC7WSukWDj-Hg-1
X-Mimecast-MFC-AGG-ID: 4IzV4zPNMBC7WSukWDj-Hg
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a7583a7433so5318185ab.2
        for <kvm@vger.kernel.org>; Sun, 24 Nov 2024 19:20:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732504842; x=1733109642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rQC7z+y5DNQuMhdh54pUxEDWFnkO7kvdaZi28hnEtxE=;
        b=KfYCFJy6H5Z0LYChjrv/EQVOtBZvnw/lvHv4aYSDFoZydjJZYZM3HRixkU3Y4g/Qoi
         4VvbArz3kbJ0hcADKZJ1xg0LqcguSVLbmIwFxVzMdhZZ9YFT4Xyy6/XU+Mg1+BGnln+S
         xPbIHOalFJ/zvbpTwcDosCrIJdE2B+smkJr3Vq/iIRHxRzE1E45ZwJJk44IsWZrjPSq7
         ZKhSUALuHXaP3YZZOKmuuouYK13W0bImiCgN+jDm+1yG4AZ/jAteeBDj4nmUBWoWsMmX
         yMDMJYVpihS9faoLSGE/XKTD3WekOCka/U7EhvE5W0ZFm6qvV0bfAkX+m861Ew+JlIZx
         KQig==
X-Forwarded-Encrypted: i=1; AJvYcCWY5SAK9sc0/2D+qJ2Vt9eXhJAPn32bt+xjK7fLpb7QrY1zu55QjGdKevtI27hFjiJXrLU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrkShWyeL3Ed+ZDEbkgrUxM2kBE5AZvByf38gHMRgxY644+Y1m
	LO/FZp+ndWSfc44EboX+7yRbl9vMTrcydaU0iEg6mp3wizHqHdPvICKlgoNymG94Jp8nqeJoEgW
	6Emyzy5uzqXHGG5DqDc+zypVE1NIskl51I1bumVOqCIlD+kflyA==
X-Gm-Gg: ASbGncuH996gN1FNg0xMN7DlEGn3kUyPVxVUyX432QWkqQP40dQQ6buehyUMOa5DkTu
	ii6GTPdJ9n1lkNHapUrLP+nzXWr6+Ybn8Stjn809d0uytQ22XiPGTcKWbqMRi8UjXGuxlvJFjio
	Id4mnUwJ6N3EjcgNtvDqerdBv/157+q6C7AUBo3OZiRtOKYU7mnIbEnk6zjlj1rcrXLJUyewvwo
	o87Up4LT5jPH1KAYnVD/kGjL/NYX25jJsMkF/Bn9XvMIZ24Kco5Ww==
X-Received: by 2002:a05:6602:1683:b0:82a:a4f0:f271 with SMTP id ca18e2360f4ac-83ecdd362f8mr321812339f.4.1732504842145;
        Sun, 24 Nov 2024 19:20:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEH5NwQOkTrq7w/vtUXVom/j9riH8vHyJPwyKdY1R249pkM41BTx2RSQDNcvsgHlDC4dziZAw==
X-Received: by 2002:a05:6602:1683:b0:82a:a4f0:f271 with SMTP id ca18e2360f4ac-83ecdd362f8mr321811839f.4.1732504841571;
        Sun, 24 Nov 2024 19:20:41 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e1ebbbe159sm1132877173.161.2024.11.24.19.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 19:20:40 -0800 (PST)
Date: Sun, 24 Nov 2024 20:20:39 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Avihai Horon <avihaih@nvidia.com>, <kvm@vger.kernel.org>, Yishai Hadas
 <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Maor Gottlieb
 <maorg@nvidia.com>
Subject: Re: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended
 capability
Message-ID: <20241124202039.77b787d3.alex.williamson@redhat.com>
In-Reply-To: <4e02975b-0121-4267-81f5-fb41f4371d81@intel.com>
References: <20241121140057.25157-1-avihaih@nvidia.com>
	<14709dcf-d7fe-4579-81b9-28065ce15f3e@intel.com>
	<20241122094826.142a5d54.alex.williamson@redhat.com>
	<4e02975b-0121-4267-81f5-fb41f4371d81@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 Nov 2024 10:31:38 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2024/11/23 00:48, Alex Williamson wrote:
> > On Fri, 22 Nov 2024 20:45:08 +0800
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> >> On 2024/11/21 22:00, Avihai Horon wrote:  
> >>> There are cases where a PCIe extended capability should be hidden from
> >>> the user. For example, an unknown capability (i.e., capability with ID
> >>> greater than PCI_EXT_CAP_ID_MAX) or a capability that is intentionally
> >>> chosen to be hidden from the user.
> >>>
> >>> Hiding a capability is done by virtualizing and modifying the 'Next
> >>> Capability Offset' field of the previous capability so it points to the
> >>> capability after the one that should be hidden.
> >>>
> >>> The special case where the first capability in the list should be hidden
> >>> is handled differently because there is no previous capability that can
> >>> be modified. In this case, the capability ID and version are zeroed
> >>> while leaving the next pointer intact. This hides the capability and
> >>> leaves an anchor for the rest of the capability list.
> >>>
> >>> However, today, hiding the first capability in the list is not done
> >>> properly if the capability is unknown, as struct
> >>> vfio_pci_core_device->pci_config_map is set to the capability ID during
> >>> initialization but the capability ID is not properly checked later when
> >>> used in vfio_config_do_rw(). This leads to the following warning [1] and
> >>> to an out-of-bounds access to ecap_perms array.
> >>>
> >>> Fix it by checking cap_id in vfio_config_do_rw(), and if it is greater
> >>> than PCI_EXT_CAP_ID_MAX, use an alternative struct perm_bits for direct
> >>> read only access instead of the ecap_perms array.
> >>>
> >>> Note that this is safe since the above is the only case where cap_id can
> >>> exceed PCI_EXT_CAP_ID_MAX (except for the special capabilities, which
> >>> are already checked before).
> >>>
> >>> [1]
> >>>
> >>> WARNING: CPU: 118 PID: 5329 at drivers/vfio/pci/vfio_pci_config.c:1900 vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]  
> >>
> >> strange, it is not in the vfio_config_do_rw(). But never mind.
> >>  
> >>> CPU: 118 UID: 0 PID: 5329 Comm: simx-qemu-syste Not tainted 6.12.0+ #1
> >>> (snip)
> >>> Call Trace:
> >>>    <TASK>
> >>>    ? show_regs+0x69/0x80
> >>>    ? __warn+0x8d/0x140
> >>>    ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
> >>>    ? report_bug+0x18f/0x1a0
> >>>    ? handle_bug+0x63/0xa0
> >>>    ? exc_invalid_op+0x19/0x70
> >>>    ? asm_exc_invalid_op+0x1b/0x20
> >>>    ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
> >>>    ? vfio_pci_config_rw+0x244/0x430 [vfio_pci_core]
> >>>    vfio_pci_rw+0x101/0x1b0 [vfio_pci_core]
> >>>    vfio_pci_core_read+0x1d/0x30 [vfio_pci_core]
> >>>    vfio_device_fops_read+0x27/0x40 [vfio]
> >>>    vfs_read+0xbd/0x340
> >>>    ? vfio_device_fops_unl_ioctl+0xbb/0x740 [vfio]
> >>>    ? __rseq_handle_notify_resume+0xa4/0x4b0
> >>>    __x64_sys_pread64+0x96/0xc0
> >>>    x64_sys_call+0x1c3d/0x20d0
> >>>    do_syscall_64+0x4d/0x120
> >>>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >>>
> >>> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> >>> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> >>> ---
> >>> Changes from v1:
> >>> * Use Alex's suggestion to fix the bug and adapt the commit message.
> >>> ---
> >>>    drivers/vfio/pci/vfio_pci_config.c | 20 ++++++++++++++++----
> >>>    1 file changed, 16 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> >>> index 97422aafaa7b..b2a1ba66e5f1 100644
> >>> --- a/drivers/vfio/pci/vfio_pci_config.c
> >>> +++ b/drivers/vfio/pci/vfio_pci_config.c
> >>> @@ -313,12 +313,16 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
> >>>    	return count;
> >>>    }
> >>>    
> >>> +static const struct perm_bits direct_ro_perms = {
> >>> +	.readfn = vfio_direct_config_read,
> >>> +};
> >>> +
> >>>    /* Default capability regions to read-only, no-virtualization */
> >>>    static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
> >>> -	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
> >>> +	[0 ... PCI_CAP_ID_MAX] = direct_ro_perms
> >>>    };
> >>>    static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
> >>> -	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
> >>> +	[0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
> >>>    };
> >>>    /*
> >>>     * Default unassigned regions to raw read-write access.  Some devices
> >>> @@ -1897,9 +1901,17 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
> >>>    		cap_start = *ppos;
> >>>    	} else {
> >>>    		if (*ppos >= PCI_CFG_SPACE_SIZE) {
> >>> -			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
> >>> +			/*
> >>> +			 * We can get a cap_id that exceeds PCI_EXT_CAP_ID_MAX
> >>> +			 * if we're hiding an unknown capability at the start
> >>> +			 * of the extended capability list.  Use default, ro
> >>> +			 * access, which will virtualize the id and next values.
> >>> +			 */
> >>> +			if (cap_id > PCI_EXT_CAP_ID_MAX)
> >>> +				perm = (struct perm_bits *)&direct_ro_perms;
> >>> +			else
> >>> +				perm = &ecap_perms[cap_id];
> >>>    
> >>> -			perm = &ecap_perms[cap_id];
> >>>    			cap_start = vfio_find_cap_start(vdev, *ppos);
> >>>    		} else {
> >>>    			WARN_ON(cap_id > PCI_CAP_ID_MAX);  
> >>
> >> Looks good to me. :) I'm able to trigger this warning by hide the first
> >> ecap on my system with the below hack.
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci_config.c
> >> b/drivers/vfio/pci/vfio_pci_config.c
> >> index b2a1ba66e5f1..db91e19a48b3 100644
> >> --- a/drivers/vfio/pci/vfio_pci_config.c
> >> +++ b/drivers/vfio/pci/vfio_pci_config.c
> >> @@ -1617,6 +1617,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device
> >> *vdev)
> >>    	u16 epos;
> >>    	__le32 *prev = NULL;
> >>    	int loops, ret, ecaps = 0;
> >> +	int iii =0;
> >>
> >>    	if (!vdev->extended_caps)
> >>    		return 0;
> >> @@ -1635,7 +1636,11 @@ static int vfio_ecap_init(struct
> >> vfio_pci_core_device *vdev)
> >>    		if (ret)
> >>    			return ret;
> >>
> >> -		ecap = PCI_EXT_CAP_ID(header);
> >> +		if (iii == 0) {
> >> +			ecap = 0x61;
> >> +			iii++;
> >> +		} else
> >> +			ecap = PCI_EXT_CAP_ID(header);
> >>
> >>    		if (ecap <= PCI_EXT_CAP_ID_MAX) {
> >>    			len = pci_ext_cap_length[ecap];
> >> @@ -1664,6 +1669,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device
> >> *vdev)
> >>    			 */
> >>    			len = PCI_CAP_SIZEOF;
> >>    			hidden = true;
> >> +			printk("%s set hide\n", __func__);
> >>    		}
> >>
> >>    		for (i = 0; i < len; i++) {
> >> @@ -1893,6 +1899,7 @@ static ssize_t vfio_config_do_rw(struct
> >> vfio_pci_core_device *vdev, char __user
> >>
> >>    	cap_id = vdev->pci_config_map[*ppos];
> >>
> >> +	printk("%s cap_id: %x\n", __func__, cap_id);
> >>    	if (cap_id == PCI_CAP_ID_INVALID) {
> >>    		perm = &unassigned_perms;
> >>    		cap_start = *ppos;
> >>
> >> And then this warning is gone after applying this patch. Hence,
> >>
> >> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> >> Tested-by: Yi Liu <yi.l.liu@intel.com>  
> > 
> > Thanks, good testing!
> >     
> >> But I can still see a valid next pointer. Like the below log, I hide
> >> the first ecap at offset 0x100, its ID is zeroed. The second ecap locates
> >> at offset==0x150, its cap_id is 0x0018. I can see the next pointer in the
> >> guest. Is it expected?  
> > 
> > This is what makes hiding the first ecap unique, the ecap chain always
> > starts at 0x100, the next pointer must be valid for the rest of the
> > chain to remain.  For standard capabilities we can change the register
> > pointing at the head of the list.  This therefore looks like expected
> > behavior, unless I'm missing something more subtle in your example.  
> 
> Got you. I was a little bit misled by the below comment. I thought the
> cap_id, version and next would be zeroed. But the code actually only zeros
> the cap_id and version. :)
> 
> 		/*
> 		 * If we're just using this capability to anchor the list,
> 		 * hide the real ID.  Only count real ecaps.  XXX PCI spec
> 		 * indicates to use cap id = 0, version = 0, next = 0 if
> 		 * ecaps are absent, hope users check all the way to next.
> 		 */

This is just expressing concern that a sloppy guest might decide the
list ends at the zero capability ID w/o strictly following the spec.
We've never seen evidence of such a guest.  Thanks,

Alex


