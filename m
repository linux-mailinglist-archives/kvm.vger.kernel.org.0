Return-Path: <kvm+bounces-32222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A6E9D449E
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 00:42:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B474BB2272E
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 23:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A081C07D3;
	Wed, 20 Nov 2024 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y1t+4BwA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7792E13BAF1
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 23:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732146162; cv=none; b=XbFZZIYRtPe0UPwWDPsYXCem94TK4m1T+KEvBEARYfAqZXM5WbZ2qq8suIKsCikEGFOGL5IOob6GGq21mvP8KQN6Qu7IA8u4GnJgUvuRFwN0jpwMiiEM3T7n+YL6p77LYgT1AC78lUdD7fCye5h51edjL8cflvZiAkbtRMfZZjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732146162; c=relaxed/simple;
	bh=q1RjWMirwjnVex/7wsrNwGSSm/6VkNHTmr2wsZCH3XU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/jmF+TM3ZCCoXkKBklj3JGnvX7huFynHYdnoVaVQxJV+n13H6PwqUx7QYCFMYb5vwDYQaeL358XywecGUshD4DIftttgBQ849xmEidb8q6eAyjknUIwhvbgRzTaTHnmVSUavYB9YIhNHOUpggaO4VJ9FeiTJNfSeljj9NKLvZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y1t+4BwA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732146159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ffD8Yw0dQnL2bXSMHB92bNSOvVEpfv0CxEw6B2VUd44=;
	b=Y1t+4BwA6nm1SyocZZe1usCme4MgAM5JOljKVUtZerPlhxK8X6a5UaDAm578krf1RZvOVq
	955lK9VF8LkRwYXwDNhMr9O2k61z969SI3GTNXVHwx2v2h8QDJ+J64NHoBIu7W8/mIfsM4
	f6wYEo2CXbEC3HXtCb7iScR0S3d+Vww=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-WviwblH-Pdytj0rP4_mgtA-1; Wed, 20 Nov 2024 18:42:38 -0500
X-MC-Unique: WviwblH-Pdytj0rP4_mgtA-1
X-Mimecast-MFC-AGG-ID: WviwblH-Pdytj0rP4_mgtA
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3e65ee715eeso58332b6e.2
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 15:42:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732146157; x=1732750957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffD8Yw0dQnL2bXSMHB92bNSOvVEpfv0CxEw6B2VUd44=;
        b=wYi5Lx40MfJXlJgW/lZYdfxkC7odXzuL3UQ94gjvvG2OcouNZcAj8QVafy0/HF7TC/
         KLnPr9B6zFBj7ntpOwKPO93vCtQ4R252dDsnkKzr6vxGZj2CV2cQQ1+KBEW2ZeuNRhZb
         G5WEiwMzpS8qfGYk13kE+5ZYlA23m5LwPA/rsD3D5L6i/fkqEmjIZ8PMGxOZK8M0xUo6
         vI9Gg4sgCqi58INtHPYvoy4CrROMJo+NozaVEeJbSuTESHHWPT7cRmAfXPOtf43QFWOH
         j15tObe95VTHWUxqaJLTIERabmBPv8sjx8ofh/33IHO4axIApUwsGPMSOtU2bypKk/z9
         Rghg==
X-Gm-Message-State: AOJu0Yxg5ZtCJ1/FID4A1kZEB/Jp+17nbkWXnh1FXx9havyBX2RDP1UZ
	k6VWzeA9POrKYCYrpCx5DQPYv5oskTr16CXy51e5qslO7vy+1gvxfKlbUCY7tf7U/nDeEJxwwXG
	pBE21h5oOrrYP1LyZ7bA+WGVYzpUAyor3OwW6crvCXbXH8vlMSg==
X-Gm-Gg: ASbGncsbcX9cHXzuEmNlMehaxb7eg5+FUq64w3S8fNFHOeahOR52x95hDh2sl5gVlqg
	xWLTAFtsdmcSGjMjR2T3E+EbK1xO6sxE76+Ysq1mT4RQtplabd/+2IRDtvj3IKVdO9XgQQXyXfx
	NIw6siUr5gLuF7SaxkZRssiYzr8ynZ9lvTO/PKQxmqOzVwl4YoAvecfvkgz+d8LBDVD7u+2pIJH
	Ss5qjbd8WcyMDfMfPwsJKK606y6kauidXIQsjm0oC40qn5cxLNpog==
X-Received: by 2002:a05:6871:586:b0:278:2698:7721 with SMTP id 586e51a60fabf-296d9bfeec2mr1097443fac.8.1732146157069;
        Wed, 20 Nov 2024 15:42:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHtg9M5RmBuM5RhY6AQ8CuaKS6J+uopCcnvsTd+ApmxULBDDf5mnMGTq8/EtQju1kp4yU+StQ==
X-Received: by 2002:a05:6871:586:b0:278:2698:7721 with SMTP id 586e51a60fabf-296d9bfeec2mr1097435fac.8.1732146156621;
        Wed, 20 Nov 2024 15:42:36 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29651b43415sm4532020fac.49.2024.11.20.15.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:42:36 -0800 (PST)
Date: Wed, 20 Nov 2024 16:42:32 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Avihai Horon <avihaih@nvidia.com>
Cc: <kvm@vger.kernel.org>, Yishai Hadas <yishaih@nvidia.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH] vfio/pci: Properly hide first-in-list PCIe extended
 capability
Message-ID: <20241120164232.6b34596a.alex.williamson@redhat.com>
In-Reply-To: <20241120143826.17856-1-avihaih@nvidia.com>
References: <20241120143826.17856-1-avihaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Nov 2024 16:38:26 +0200
Avihai Horon <avihaih@nvidia.com> wrote:

> There are cases where a PCIe extended capability should be hidden from
> the user. For example, an unknown capability (i.e., capability with ID
> greater than PCI_EXT_CAP_ID_MAX) or a capability that is intentionally
> chosen to be hidden from the user.
> 
> Hiding a capability is done by virtualizing and modifying the 'Next
> Capability Offset' field of the previous capability so it points to the
> capability after the one that should be hidden.
> 
> The special case where the first capability in the list should be hidden
> is handled differently because there is no previous capability that can
> be modified. In this case, the capability ID and version are zeroed
> while leaving the next pointer intact. This hides the capability and
> leaves an anchor for the rest of the capability list.
> 
> However, today, hiding the first capability in the list is not done
> properly, as struct vfio_pci_core_device->pci_config_map is still set to
> the capability ID. If the first capability in the list is unknown, the
> following warning [1] is triggered and an out-of-bounds access to
> ecap_perms array occurs when vfio_config_do_rw() later uses
> pci_config_map to pick the right permissions.
> 
> Fix it by defining a new special capability PCI_CAP_ID_FIRST_HIDDEN,
> that represents a hidden extended capability that is located first in
> the extended capability list, and set pci_config_map to it in the above
> case.
> 
> [1]
> 
> WARNING: CPU: 118 PID: 5329 at drivers/vfio/pci/vfio_pci_config.c:1900 vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
> CPU: 118 UID: 0 PID: 5329 Comm: simx-qemu-syste Not tainted 6.12.0+ #1
> (snip)
> Call Trace:
>  <TASK>
>  ? show_regs+0x69/0x80
>  ? __warn+0x8d/0x140
>  ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>  ? report_bug+0x18f/0x1a0
>  ? handle_bug+0x63/0xa0
>  ? exc_invalid_op+0x19/0x70
>  ? asm_exc_invalid_op+0x1b/0x20
>  ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>  ? vfio_pci_config_rw+0x244/0x430 [vfio_pci_core]
>  vfio_pci_rw+0x101/0x1b0 [vfio_pci_core]
>  vfio_pci_core_read+0x1d/0x30 [vfio_pci_core]
>  vfio_device_fops_read+0x27/0x40 [vfio]
>  vfs_read+0xbd/0x340
>  ? vfio_device_fops_unl_ioctl+0xbb/0x740 [vfio]
>  ? __rseq_handle_notify_resume+0xa4/0x4b0
>  __x64_sys_pread64+0x96/0xc0
>  x64_sys_call+0x1c3d/0x20d0
>  do_syscall_64+0x4d/0x120
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_priv.h   |  1 +
>  drivers/vfio/pci/vfio_pci_config.c | 18 +++++++++++++-----
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index 5e4fa69aee16..4728b8069c52 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -7,6 +7,7 @@
>  /* Special capability IDs predefined access */
>  #define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
>  #define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
> +#define PCI_CAP_ID_FIRST_HIDDEN		0xFD	/* default direct access */

Thanks for catching this!  I wonder if the explicit tracking of this
via another dummy capability ID is really necessary though.  I think
the only way we can get a value in the pci_config_map greater than
PCI_EXT_CAP_ID_MAX is this scenario where it appears at the base of the
extended capability chain.  Therefore couldn't we just do something
like (compile tested only):

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 97422aafaa7b..beea05020888 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -313,12 +313,16 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
 	return count;
 }
 
+static const struct perm_bits direct_ro_perms = {
+	.readfn = vfio_direct_config_read
+};
+
 /* Default capability regions to read-only, no-virtualization */
 static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
-	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
+	[0 ... PCI_CAP_ID_MAX] = direct_ro_perms
 };
 static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
-	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
+	[0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
 };
 /*
  * Default unassigned regions to raw read-write access.  Some devices
@@ -1897,9 +1901,17 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
 		cap_start = *ppos;
 	} else {
 		if (*ppos >= PCI_CFG_SPACE_SIZE) {
-			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
+			/*
+			 * We can get a cap_id that exceeds PCI_EXT_CAP_ID_MAX
+			 * if we're hiding an unknown capability at the start
+			 * of the extended capability chain.  Use default, ro
+			 * access, which will virtualize the id and next values.
+			 */
+			if (cap_id > PCI_EXT_CAP_ID_MAX)
+				perm = (struct perm_bits *)&direct_ro_perms;
+			else
+				perm = &ecap_perms[cap_id];
 
-			perm = &ecap_perms[cap_id];
 			cap_start = vfio_find_cap_start(vdev, *ppos);
 		} else {
 			WARN_ON(cap_id > PCI_CAP_ID_MAX);


>  
>  /* Cap maximum number of ioeventfds per device (arbitrary) */
>  #define VFIO_PCI_IOEVENTFD_MAX		1000
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 97422aafaa7b..95f8a6a10166 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -320,6 +320,10 @@ static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
>  static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
>  	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
>  };
> +/* Perms for a first-in-list hidden extended capability */
> +static struct perm_bits hidden_ecap_perm = {
> +	.readfn = vfio_direct_config_read,
> +};
>  /*
>   * Default unassigned regions to raw read-write access.  Some devices
>   * require this to function as they hide registers between the gaps in
> @@ -1582,7 +1586,7 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
>  				 __func__, pos + i, map[pos + i], cap);
>  		}
>  
> -		BUILD_BUG_ON(PCI_CAP_ID_MAX >= PCI_CAP_ID_INVALID_VIRT);
> +		BUILD_BUG_ON(PCI_CAP_ID_MAX >= PCI_CAP_ID_FIRST_HIDDEN);
>  
>  		memset(map + pos, cap, len);
>  		ret = vfio_fill_vconfig_bytes(vdev, pos, len);
> @@ -1673,9 +1677,9 @@ static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
>  		/*
>  		 * Even though ecap is 2 bytes, we're currently a long way
>  		 * from exceeding 1 byte capabilities.  If we ever make it
> -		 * up to 0xFE we'll need to up this to a two-byte, byte map.
> +		 * up to 0xFD we'll need to up this to a two-byte, byte map.
>  		 */
> -		BUILD_BUG_ON(PCI_EXT_CAP_ID_MAX >= PCI_CAP_ID_INVALID_VIRT);
> +		BUILD_BUG_ON(PCI_EXT_CAP_ID_MAX >= PCI_CAP_ID_FIRST_HIDDEN);
>  
>  		memset(map + epos, ecap, len);
>  		ret = vfio_fill_vconfig_bytes(vdev, epos, len);
> @@ -1688,10 +1692,11 @@ static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
>  		 * indicates to use cap id = 0, version = 0, next = 0 if
>  		 * ecaps are absent, hope users check all the way to next.
>  		 */
> -		if (hidden)
> +		if (hidden) {
>  			*(__le32 *)&vdev->vconfig[epos] &=
>  				cpu_to_le32((0xffcU << 20));
> -		else
> +			memset(map + epos, PCI_CAP_ID_FIRST_HIDDEN, len);
> +		} else
>  			ecaps++;

We need to add braces on the else branch as well, per our coding style
standard.  Alternatively we might overwrite the ecap value where we
previously set hidden to true.  Thanks,

Alex

>  
>  		prev = (__le32 *)&vdev->vconfig[epos];
> @@ -1895,6 +1900,9 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>  	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT) {
>  		perm = &virt_perms;
>  		cap_start = *ppos;
> +	} else if (cap_id == PCI_CAP_ID_FIRST_HIDDEN) {
> +		perm = &hidden_ecap_perm;
> +		cap_start = PCI_CFG_SPACE_SIZE;
>  	} else {
>  		if (*ppos >= PCI_CFG_SPACE_SIZE) {
>  			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);


