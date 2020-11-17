Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0972B6B19
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgKQRHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:07:49 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12532 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgKQRHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:07:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb4035b0000>; Tue, 17 Nov 2020 09:07:39 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 17:07:44 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 17 Nov 2020 17:07:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5LeFfgGP74zBqVlSwi4thGGXGIQVlNJLBLDdHXjbQ+wWDBNYEbJ7c/u9R6TbI96ERmNfal5FUtn75+oR6kZXYGKXuBJjsCBNzyRK8qwtY5HhlJhnShKID+XvtLaA0vED+DGOQgvAL0mXpcPxJhNPy3QYiailY6t/w7tZZkmwdT19he/y2dGBbvAU2ehXH5+4PHns+zrCMswezfkgaqF24jMPEWOeuHpT04exleixjoy5nzvwRx5XVGdvdiWvNAPhqR6rpY4V+emopDvYYyE7x2nI6fHlGeN7QJe3oF/CNzTo8lu4cO2083zDD2LYSpIsS/E/g+cs9rCSLale6sX9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SAqHhwD39onIb35rBMOeOh/n951qNvpBmPOI2yi72I=;
 b=gNrZO8wbKk2YN2WI53bAJ9OjhSiG7MdBub2N+lbBOUkHDiC7twQ2mXd9k4rPHVPhqljBA1XtRaQT6ClYNGvnjRjWv4fvW0JJRS55tTUkGLpgMaORHyJEdMxURxToWv1ePAlSTI5WUxt8oziOgkHvhrbAtINpMQ5XYZW/xH/Qa9ggGRNr2V5ePH79MMczwI61NGsgvhL+nGiOLr2bRCO18cXHXKqTAmQV6MbT5vscKRG89wNvFh9azsajgNZakiSFyzxTWzbI9mnPJUbFdUofgViXL/caI9WpMJqUY/FBj/bhL7Hjm2K1SpeikF18MW6+BQ/qjA1YPlKcqZ1TRAlLBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3401.namprd12.prod.outlook.com (2603:10b6:5:39::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Tue, 17 Nov
 2020 17:07:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 17:07:43 +0000
Date:   Tue, 17 Nov 2020 13:07:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Message-ID: <20201117170741.GU917484@nvidia.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1> <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
 <20201116232033.GR917484@nvidia.com>
 <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
 <20201117085443.2c183078@w520.home>
 <b6bd90c5-69e0-4e73-4f1a-8bc000aab941@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b6bd90c5-69e0-4e73-4f1a-8bc000aab941@amd.com>
X-ClientProxiedBy: MN2PR14CA0001.namprd14.prod.outlook.com
 (2603:10b6:208:23e::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR14CA0001.namprd14.prod.outlook.com (2603:10b6:208:23e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:07:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kf4SD-0078iG-Nd; Tue, 17 Nov 2020 13:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605632859; bh=2SAqHhwD39onIb35rBMOeOh/n951qNvpBmPOI2yi72I=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=QKc5CornQ0XUyAVCuaaso8i01mlJ4gg4KQ/VcR6qnGaBFr2vNK4CsWifGALCBOb3Q
         kfEYtJZ8MdW+M04GgrtmkhMWOkiqDxKH/S3uZ5ApRkKQzErf608cBDIVPbarDe2pKk
         Mixs6YxpmCCBJ+jQwD/qQ8CNSutKv9BPCAz6MYu4lQyGjib15x/vDrYFm/LKlfZnl7
         mfJERPeFaUgGOtZQ/VvFzafyMv9EyQ5Q79Tkj0wBTYo403Oty9CnUSLTjamy+8Y96A
         D4Y1nc2vU6U1fbxchbIe3bx6HbyjPY1L+S1r5jHW2IOGs6cz2ym3qCMHUOexhxffke
         z6Y1F31iKxNLQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 17, 2020 at 10:37:18AM -0600, Tom Lendacky wrote:

> > Ideally it won't, but trapping through QEMU is a common debugging
> > technique and required if we implement virtualization quirks for a
> > device in QEMU.  So I believe what you're saying is that device
> > assignment on SEV probably works only when we're using direct mapping
> > of the mmap into the VM and tracing or quirks would currently see
> > encrypted data.  Has anyone had the opportunity to check that we don't
> > break device assignment to VMs with this patch?  Thanks,
> 
> I have not been able to test device assignment with this patch, yet. Jason?

I don't have SME systems, we have a customer that reported RDMA didn't
work and confirmed the similar RDMA patch worked.

I know VFIO is basically identical, so it should be applicable here
too.

Jasnon
