Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D7426B5D4
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 01:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgIOXvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 19:51:47 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18962 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbgIOXve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 19:51:34 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f6152f70000>; Tue, 15 Sep 2020 16:49:11 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 16:51:32 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 15 Sep 2020 16:51:32 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 23:51:29 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.57) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 15 Sep 2020 23:51:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9CBFnwMWKEkFQOUJ+a8TZyHlaTfUKaSLjmgU0hDfkuBC9tWwL8HUfxjKIcBCu5pWL0a7qB0G4OhMB4/gEfISay+ox032qZMJO8uDoEcJEKrRgAGJ9H8SqdAP797VDnmOCEb4T64BLObokc9CvRZcOZB0CbwNwado0sGmV/kHs4ObRwdYp7scPMFMzL9raNDMIXacnKx06c2SQVsUBFrmtdGXJdCKwQy6G7iRpaQ06OtulQaWCReEwN+RLTmgt8lPBMmjPIJLlfNIyCznn2nIcNoXuJZQrCB1oXh6zCC6digVJXnvN6+QIXVHxIqf2bNqbhOhbXvhtNM0K/4BEFv2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxvWNy/DDwUk8ziyWv8dqcmfApz5MRhSmLKBZQWIQEc=;
 b=LxFljlkrPDnSP5zX88QFy0r7Z+eO3PEIHPTitE7RSkmJvuPgchtibTgXAYtZ0xEgVPfGW+lrMbRgBnjZ7wAdzjB4+h1V86vGCwMiGXZ948u1GOidBxZnxhOwxut2anajo80Bx9M7tH2eDXoe0ownmxeVfi3sjFr5s0qYVXs/5mUfANQmSD13tG0RLdWdrNqjohwa0sQNfQkVyWTYXZTcjZ4E+zQtdr7ab5WIp6elbk5x8dDnxvgpYr13TT21/GgEDYILDLWwTo/bLjallgnQAAI/53AncA2lj9YxPNwbFenvvlxuutQ/U7BeCzuDRRmkPAxnYOErG71zrkyf2XaM+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 23:51:28 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 23:51:28 +0000
Date:   Tue, 15 Sep 2020 20:51:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jun.j.tian@intel.com>,
        <yi.y.sun@intel.com>, <peterx@redhat.com>, <hao.wu@intel.com>,
        <stefanha@gmail.com>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jacon Jun Pan <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200915235126.GK1573713@nvidia.com>
References: <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home> <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home> <20200914190057.GM904879@nvidia.com>
 <20200914224438.GA65940@otc-nc-03> <20200915113341.GW904879@nvidia.com>
 <20200915181154.GA70770@otc-nc-03> <20200915184510.GB1573713@nvidia.com>
 <20200915150851.76436ca1@jacob-builder>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200915150851.76436ca1@jacob-builder>
X-ClientProxiedBy: CH2PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:610:57::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR12CA0003.namprd12.prod.outlook.com (2603:10b6:610:57::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 15 Sep 2020 23:51:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIKjO-006jNp-P3; Tue, 15 Sep 2020 20:51:26 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6e76f74-541d-4d41-856b-08d859d2433c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4402:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4402FF8D5C976C2E1FD6B8DDC2200@DM6PR12MB4402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HLxkLj5LIKYQfDK7zW+/crehvuQqmbDyX/Inva5UYH4yyZFIA4C0HThBohe9vBTy4JkHnWjBM1+p4CaL1BFQXDk9Hohy4al2XYa3B1ItIQ0Ula5t+2t2L3kQDUouCof70AvPBI+4tRqGtBzXjJAohJRN8GZ/fgAkYHVkXbbSDYj5HtEN3OQ2MYuD+ldHvP4KlRMDGaNck6o6qjdJCjN+xmbn0WEd80/2HdfYSmd5sSNKbp+399SBxn5syeoAwLfftPh0uO3t/VltD1PR2pSwS0YeuYCmZ3D08Ch18N760n+MYTQSK+QjjwSKqior83suj4rmXcO+skupS4KU7MGDMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(8676002)(86362001)(478600001)(5660300002)(7416002)(26005)(316002)(6916009)(186003)(36756003)(54906003)(66556008)(66476007)(426003)(9786002)(9746002)(2616005)(4326008)(2906002)(1076003)(66946007)(33656002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NmPVn+iE7coaX9lotEDIcvg3hXvx3Vf75e3vAFGN7i8cRwT3z7RlzMh5TtsKUmiO8PS66SkkdEIrw2GhyiXWU5FqQaVSAinu3ILeR5ud+hAjnoVZoY1LeDLD8tE5MoU83vtcc1wcXoqKgMLNgbGAFpv1HCDODR6kbakyjj5ZF0F6T2E0JPqwXfpzvzaxexMhuJoFnZti+J3BNWwzie1HE0tzF/CnxPO+pzLGHKs33Fusy8vGLT9Te3NGTaIxiiuDsGkix4xV4Rg4qi3YG+Smkl2JPFv3n+/c7SR8KhubShUiH3VAOcbxNewSNbX5hZsDPgcqsl2PRJpcoTdcpc1hrr2Yp5Op+It798So3buTghbjlwOzMG2w/9lUUVsiHBq8Q+iPuVLJ7vqTbOAO234a/lcJP4CaJRku6yV48d4PH1qC/Mho0xBHS7IOlOCwSvpyIc24iht/cJh1MvHLWkTm9y9CtSZ/LdjKNVjREpBTXiu8wnEjYhOt5MABBUUb+f8NZty+GjFvDoZV4wT9N8wDv5uq0JaQ+kkUVYMBSQC92T4gVDMpa0Fy4xAI+B91LMQzvLe+ihyZFO9yTbyGjrAyM3mp/0keK7ldfrJSWr4Xl5KKk+qMw5KW1pAkRX2oKPxOhz7kWN56npBNHstbS/wmxg==
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e76f74-541d-4d41-856b-08d859d2433c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 23:51:28.0718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +TqA7BNH6STEjUcTRIn4Z7gc6s3/SdKc+ATleZdPxUTYMcNEJEvqpuX/Vr12f8+g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4402
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600213751; bh=NxvWNy/DDwUk8ziyWv8dqcmfApz5MRhSmLKBZQWIQEc=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=b2a5TP+y/OYDlZUI+mJCS6GNlmv3iXhE2HKcPR3ot3ZlI8g3ZxYjfn9TuROLMpyYV
         dPj6DaUWM3xBJ78JLOI269S1v5mnaQi5cjxsiRkmfYVzlUFiiZHm0MI6JM9DVDNI51
         5pRRebUqZHU4lB5oIVbBS76iMpmLVyt4yiZJgDXqpaX1pOKJDSAvUiN8JLFRbvXFr9
         x0zcZKdtWB+4tIxpGNh3kbPr34oXPv+7twEo2QwnlzkoNyr84QC6iZMxzik24lQQCO
         Q29W1K51oEbonwUlw/ZFz5IW9sjow8gFX6bzKP9mKo80xyFxKqujTS1YQkYKspydo8
         KkVkjWujQrkhw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 03:08:51PM -0700, Jacob Pan wrote:
> > A PASID vIOMMU solution sharable with VDPA and VFIO, based on a PASID
> > control char dev (eg /dev/sva, or maybe /dev/iommu) seems like a
> > reasonable starting point for discussion.
> 
> I am not sure what can really be consolidated in /dev/sva. 

More or less, everything in this patch. All the manipulations of PASID
that are required for vIOMMU use case/etc. Basically all PASID control
that is not just a 1:1 mapping of the mm_struct.

> will have their own kerne-user interfaces anyway for their usage models.
> They are just providing the specific transport while sharing generic IOMMU
> UAPIs and IOASID management.

> As I mentioned PASID management is already consolidated in the IOASID layer,
> so for VDPA or other users, it just matter of create its own ioasid_set,
> doing allocation.

Creating the PASID is not the problem, managing what the PASID maps to
is the issue. That is all uAPI that we don't really have today.

> IOASID is also available to the in-kernel users which does not
> need /dev/sva AFAICT. For bare metal SVA, I don't see a need to create this
> 'floating' state of the PASID when created by /dev/sva. PASID allocation
> could happen behind the scene when users need to bind page tables to a
> device DMA stream.

My point is I would like to see one set of uAPI ioctls to bind page
tables. I don't want to have VFIO, VDPA, etc, etc uAPIs to do the exact
same things only slightly differently.

If user space wants to bind page tables, create the PASID with
/dev/sva, use ioctls there to setup the page table the way it wants,
then pass the now configured PASID to a driver that can use it. 

Driver does not do page table binding. Do not duplicate all the
control plane uAPI in every driver.

PASID managment and binding is seperated from the driver(s) that are
using the PASID.

Jason
