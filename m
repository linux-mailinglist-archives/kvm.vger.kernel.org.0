Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5273E321E1E
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhBVRaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:30:02 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17815 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhBVR36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 12:29:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6033e9ed0002>; Mon, 22 Feb 2021 09:29:17 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 17:29:17 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 22 Feb 2021 17:29:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfWApWPGM0mOHxxzb5RUvDWbG3lDdpE+iq8dsS1ANag0CGJL0VX+LBlDPC8LesOpblfkmceRZz7c0ztuVl681i1VHJrQR33hccovtz0GKHpTD8B5pNIA3G/ccpV/xOupFLyVtIOchGIBjzlBBbdCeVNCV6/4g+wbTPs9h7slo54FyDYOMt4bdMMXQfDOYzPVOlo5rNHV0A6VCmiWY9yZrXqY3xlJGVFrzuFgm5qBF2CRKoQloKHBCZmcYLvqgo0QZYr5uDQUDJH2Dhf2y9QJ2q0g54Tw5hATN+FRPQ5YWUbW3k0zXyoGDJxxGVGFq2Oqo8wpDNt21Wf4AEKTN/9SRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtL52Fdqmqph0ZAbU2bpeQE2JEOOj4ovMHMVaae9XBE=;
 b=gSGBGm7GJuA+4/ZOKRuHH7QVpI7k7WnU5dkuI8jRPGf1iH7XHdRGErLzFfiYXu+/hc4NLT5BcxkPoviZ+MnNQ3B8Y5DrD4uadwGhWsYPlKx21jTgezGYGfj6cClv0dwVC43oK3ZPW+Bpp9YMw4KQfsQIZGTWDiOVrGYeDe2kPoljjYbk0JaY1y+DD6sN2O0CFcoFRlAAlxi4PdZHkKaF+mF54/XtEhxzBvC36obBTAGHEpxb6lA7pC23jMNb3mnxkeSk7P/jkZ8M9ycUpNzayQYe8Hv5oosYoXUPpr5DsHoW1yyOD8lzL9lchXVLlMotDmqqbvdrFXhVHvtXNYD8Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2439.namprd12.prod.outlook.com (2603:10b6:4:b4::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Mon, 22 Feb
 2021 17:29:16 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.045; Mon, 22 Feb 2021
 17:29:15 +0000
Date:   Mon, 22 Feb 2021 13:29:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
Message-ID: <20210222172913.GP4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401268537.16443.2329805617992345365.stgit@gimli.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161401268537.16443.2329805617992345365.stgit@gimli.home>
X-ClientProxiedBy: BL1PR13CA0408.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0408.namprd13.prod.outlook.com (2603:10b6:208:2c2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.11 via Frontend Transport; Mon, 22 Feb 2021 17:29:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEF1F-00ESnJ-LB; Mon, 22 Feb 2021 13:29:13 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614014957; bh=LtL52Fdqmqph0ZAbU2bpeQE2JEOOj4ovMHMVaae9XBE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=aGDpp3tDaE4ZelC+iU+xATL2X7u+T7GQMkmuPtQmz+gJIKJMMls40qm90028sa9AW
         ep3xCAXdtk/wrkcvc6dLrq7AnuI/Pl2h1DS/Ve/5j/dBXqJTLFHm5cT2xGl0DaindF
         LwOJouOYqqgZMDcvmpbrDh8zDGmyhBu8jvtC5sZMBFeZmhvi2LtDsELo0lgnYHaAQd
         puhgUbaZf+0gi7Fk8XA6WD7u+La/RUksUVGm2F7SJ1dvFSvb+lw8vpUdO5arvTqOu8
         sJjM3duvuWlqHWmy03SunmOk5ZntmXWJ1tj2rdZZNvEy3q4zNwmy6X3yXomt0i/O3i
         Js3Di3ZR0E+MA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 09:51:25AM -0700, Alex Williamson wrote:

> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index da212425ab30..399c42b77fbb 100644
> +++ b/drivers/vfio/vfio.c
> @@ -572,6 +572,15 @@ void vfio_device_unmap_mapping_range(struct vfio_device *device,
>  }
>  EXPORT_SYMBOL_GPL(vfio_device_unmap_mapping_range);
>  
> +/*
> + * A VFIO bus driver using this open callback will provide a
> + * struct vfio_device pointer in the vm_private_data field.

The vfio_device pointer should be stored in the struct file

> +struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma)
> +{
> +	struct vfio_device *device;
> +
> +	if (vma->vm_ops->open != vfio_device_vma_open)
> +		return ERR_PTR(-ENODEV);
> +

Having looked at VFIO alot more closely last week, this is even more
trivial - VFIO only creates mmaps of memory we want to invalidate, so
this is just very simple:

struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma)
{
       if (!vma->vm_file ||vma->vm_file->f_op != &vfio_device_fops)
	   return ERR_PTR(-ENODEV);
       return vma->vm_file->f_private;
}

The only use of the special ops would be if there are multiple types
of mmap's going on, but for this narrow use case those would be safely
distinguished by the vm_pgoff instead

> +extern void vfio_device_vma_open(struct vm_area_struct *vma);
> +extern struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma);

No externs on function prototypes in new code please, we've been
slowly deleting them..

Jason
