Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAD82B54DD
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 00:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgKPXUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 18:20:41 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5533 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKPXUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 18:20:41 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb3093f0000>; Mon, 16 Nov 2020 15:20:31 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Nov
 2020 23:20:36 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 16 Nov 2020 23:20:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOtI+twjC5xg1F5s7fSa9e9fnekYd96y6cEclsHKOcWZT9gLrtpNa3YmNzu6+C8szVErQ3eRLFdiMQVlpOxVj9I87yOZM9bg4pRSWVECI1M80oF5T/bZIwofjo+FrvKOeQ54DA/VaI1/+F9JCCFzu+8EFLZzHX4WB6CrW0CuR7WqasrTUVXCwJr5esYxTp2VUd8CQSH4rIr2VTxPXjE5eJTOtkcFQyhJzFSb5Ck6kspCIv3/bo6gK4TytsrvIDg/tv7dLrha+g6RTo+NAXO577GvpkzQa4Pjezhb7fvBbQs++MQwZSaWlyVG0CL3EB131rCySbTohLtFSlbrOKW3uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbZkbSkBvVltO1ih5mSjvVfS8U+i6/bpge7+4XQ9UmY=;
 b=GXMZ+rBiFSlZLImNSx1WK0hI8Jesd7ETyCFfbUIP6ZdPGbeSPFu6Ociq5zCknRnhMNjxEjtW++0GhB2PXRk5oJXY6NS72CONoaaL8teve4u4X3x5mNyLVbRmobzNdV0KTriFEHAJUWefn+pDZQu5QnLRrYQ48N3q9X0v8n6stew9DQfrnjnGBNwX/yG8xIRQqzKufGegm94SEdAXVU1+mYE4yX27Lzrr5bO8GGLVgVR71MQ0ilOYOktxHXu+/um/tJ6yY2PVnAN2vkXTGuDBhEwZwBs5hsRN+QUnQYAselNdbuQGAViO3w7xKy1ZeDxcK3tiB9abzEKTn6I0xgTwJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4619.namprd12.prod.outlook.com (2603:10b6:5:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Mon, 16 Nov
 2020 23:20:35 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 23:20:35 +0000
Date:   Mon, 16 Nov 2020 19:20:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
CC:     Peter Xu <peterx@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Message-ID: <20201116232033.GR917484@nvidia.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1> <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
X-ClientProxiedBy: MN2PR16CA0053.namprd16.prod.outlook.com
 (2603:10b6:208:234::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR16CA0053.namprd16.prod.outlook.com (2603:10b6:208:234::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 23:20:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kennV-006rEL-DG; Mon, 16 Nov 2020 19:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605568832; bh=UbZkbSkBvVltO1ih5mSjvVfS8U+i6/bpge7+4XQ9UmY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=Kl92bdgTPfulsToybXAYnjnwmIGvG0j9z18rwZBcQRTBtSx0Y6QK51vslVgTO3uXH
         2NVJ+89ZPlhV3tWX95XXtCNH3OaZmmLl7Do+LXhabKMzt394xRuxQUngPIiZ/FmSIN
         AjBL6EANQ5eBMAIeRgA3DXFhiXH/nuuVzZ8ELN2q5jP6h9TUvjiEeE39tYiTGdOmlk
         7cGjAkMbCn1vwFiNWF81NQQVyFRepZ+gRU8AR03cqjpW1oyQ59mlKEKoQM2bAVjIrh
         giVHhAe5REWELEbxbNcYAJ/L1UwelYPb8s4WZx2YtuzUzplFGcFOuY3cg7scJSCVSa
         tZrlWSlOwz8CA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16, 2020 at 03:43:53PM -0600, Tom Lendacky wrote:
> On 11/16/20 9:53 AM, Jason Gunthorpe wrote:
> > On Thu, Nov 05, 2020 at 06:39:49PM -0500, Peter Xu wrote:
> >> On Thu, Nov 05, 2020 at 12:34:58PM -0400, Jason Gunthorpe wrote:
> >>> Tom says VFIO device assignment works OK with KVM, so I expect only things
> >>> like DPDK to be broken.
> >>
> >> Is there more information on why the difference?  Thanks,
> > 
> > I have nothing, maybe Tom can explain how it works?
> 
> IIUC, the main differences would be along the lines of what is performing
> the mappings or who is performing the MMIO.
> 
> For device passthrough using VFIO, the guest kernel is the one that ends
> up performing the MMIO in kernel space with the proper encryption mask
> (unencrypted).

The question here is why does VF assignment work if the MMIO mapping
in the hypervisor is being marked encrypted.

It sounds like this means the page table in the hypervisor is ignored,
and it works because the VM's kernel marks the guest's page table as
non-encrypted?

> I'm not familiar with how DPDK really works other than it is userspace
> based and uses polling drivers, etc. So it all depends on how everything
> gets mapped and by whom. For example, using mmap() to get a mapping to
> something that should be mapped unencrypted will be an issue since the
> userspace mappings are created encrypted. 

It is the same as the rdma stuff, DPDK calls mmap against VFIO which
calls remap_pfn and creates encrypted mappings

> Extending mmap() to be able to specify a new flag, maybe
> MAP_UNENCRYPTED, might be something to consider.
 
Not sure how this makes sense here, the kernel knows the should not be
encrypted..

Jason
