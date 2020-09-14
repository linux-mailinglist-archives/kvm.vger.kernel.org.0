Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CBB268CF1
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 16:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgINOJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 10:09:19 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1748 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgINNsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 09:48:24 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5f73f60000>; Mon, 14 Sep 2020 06:45:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 06:47:46 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 14 Sep 2020 06:47:46 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 13:47:41 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Sep 2020 13:47:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJ1v1GhktUHXfLu91qFdYkUDgw325uaPdNzHd1ahoiWu9n0cZe3Tkmf1fGcoKnzrIguzJKGmzbEarXwYb+cG6x2dKWygtKBJJvlTEFtiTqIvkA16wc/BbhKuRRouygXUknKOZ84Vd74ZnY6xYwBp/FeNnpVNpz9wMGMAEx0xTbOj9A9sUofldwwYYwLUl0uECqArUzHBqDVR/kLD15SKvYsBX5obmD6YDWXf2n4ielTs00y/MhjaHla5LNfhNnvRczxhj2mFA66leoIm0AtHbfiTZrxEhAxqbpFkIZ18xcG8+TEqKdxEUSmIrHOaVeyPqvaGNzjb+WyfIzJzftzGZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhyVQISk7e5i0zqdB9g5FWxXdZsdNsKuPFd2V6xi7Sc=;
 b=kyrrCsrpj0LR98PxcXabF8dJRWGtaPKxkASvkF7+St2bAtzYmCeqwrDuLR2YmMoe5oSxNDbi28uDadipUnXB97TAGz7r1sVvyLrOFlH9FtYrcBAhOT0ZElzr3LJYlP4T0ql+xqsHCdfG9+4qOtYQ17L1IIkM3vcdvd3HXvXDckuZYI2Gjg+qGyTUwzVlKmzr5gDF/NqpXdaZc5MNseeveG82+1PAeTOP056pJGlirDUF8IDDujGdRTUOg1Tqc+3vSQ6oCAfXB3b8mVW6lbmUihzk3f395yzXU9QZECvEvAeFXNtZDK/5VeszdOBUG2JmGf2f5oSoiXwlJjP5K5xfpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4041.namprd12.prod.outlook.com (2603:10b6:5:210::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 13:47:41 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 13:47:40 +0000
Date:   Mon, 14 Sep 2020 10:47:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Jason Wang <jasowang@redhat.com>, Liu Yi L <yi.l.liu@intel.com>,
        <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jacob.jun.pan@linux.intel.com>,
        <ashok.raj@intel.com>, <jun.j.tian@intel.com>,
        <yi.y.sun@intel.com>, <peterx@redhat.com>, <hao.wu@intel.com>,
        <stefanha@gmail.com>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200914134738.GX904879@nvidia.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
 <20200914133113.GB1375106@myrica>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200914133113.GB1375106@myrica>
X-ClientProxiedBy: YQBPR01CA0108.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::44) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YQBPR01CA0108.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:3::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 13:47:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kHopW-005x52-OB; Mon, 14 Sep 2020 10:47:38 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64c61df1-f200-49ee-cd91-08d858b4bfae
X-MS-TrafficTypeDiagnostic: DM6PR12MB4041:
X-Microsoft-Antispam-PRVS: <DM6PR12MB40419BEA8837FE1EE457C30DC2230@DM6PR12MB4041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ueLhKsz8L7WqIcPtlBHx/AkeIcbV0/L5uY0ihDPMT1Ycu3B+Ex9m1c29wOT9eIwKaFDnYPokbEG3AEhKT8TvKfYz281Q0soCjGDo03YmLD8Qutn9gukATvhIH2WoCfKi9kLbc4No6A+jEJuz6hpCaO7qzy1vvjIQ/NuE78AstrdFftJ3n+/8nU1InvusFrTdaibTEiuQb5JhArSl43NHNlyaz9PmysCAHsc4sA7bhxGc7Za79BQcDpNlUi0zBUYyVPvtiwl75SMBHC1vS6IchDQoJz1J25VIRiVguhDQYk4ATsfFZemOzZcEwDhp9bdS0gvblhoy62Pnzt+9U/fnm8QMHgTxfpNRwyu4ZS5bj3nsQT/WLkIALRfJirN6RZ5e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(9746002)(9786002)(26005)(1076003)(426003)(186003)(83380400001)(5660300002)(8936002)(33656002)(8676002)(54906003)(2616005)(478600001)(4326008)(316002)(2906002)(66556008)(66946007)(66476007)(7416002)(86362001)(6916009)(36756003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kvZYXc0SmC9XYbQanQc2WcnSFrqq8j2FMdJunBYjvn5Z5HNKs1Y9MqAFY+3FfM//u1O5neXAAuuic70QtBIvKjc8/fddg7XFHGkzQJpEeSUusMY5Md1pWAlgjjCkodIHGWYWD83T5D4VcldMmK4xbiss+8aLEhReLxvxWEVt/pc+ZR0vrhwm1J1OqHm4f8gg5cGYffiX9+scTWfUT3Kdr4ReNh9N2NMqtoBw/OLkZ7C0hfIrqEmzQeOMpUiEwsBa2fQWR66kz1N33M7byfTD2oTpPkeVMs/JjFk5EPjuv0oVFcTDlYBatI1fw+79ou5VoKht/WEXg37ZHHsLrKH3XKUkl6+zt9kgah7oabWDaQZWCTbCS148cRltI92OmGhIDNNyDecVj3rhuAQkBk42dAoKEhS7z2NrNMJwgeOZO8/tsze2jqsKodAlolilbFTm4eeHnJBSNZ3NRGIMLN/tW3sp23nXK3alyrPAWjTjolgDmqX/iRd27/L1qDJ2h3IRlL/gPcr+O+HOc0jowxI+jlJVByCnmW58rwzAkkYNhCeANkmIiFi6xkxcAowQyq0lnr2fwUuksp9P0tyyrPZxmv9oOLyYcS5v33K2dlgz/UUaMi1IFOAKoMWZPDHycbp1LqcXq3P9SeYEzAnFESf4GQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 64c61df1-f200-49ee-cd91-08d858b4bfae
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 13:47:40.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xnb12CA7vrzscPQhYhCWIKlYjW7XK/OYKQ9VFhO68Ji6EynYbvMqbECUs3gSuUZ3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4041
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600091127; bh=EhyVQISk7e5i0zqdB9g5FWxXdZsdNsKuPFd2V6xi7Sc=;
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
        b=PiurEF62RPH/VPMwlRiR91R+qtndXW1TZES6sYh8n3Tf4cJHJXBYLvxx3C3X/nvAW
         WvNs+iVVsAZhBnvHZOZG8YemkmwmAutlU7PJCSc55QXRbkpsKJbw4/NfiBj4tPE6Dc
         6XeF4SlelaWkisXFDpHNmI3JyE4xGkzKvI6/sa0A2xFl7l7zGcud8kpu9lV27vjI/h
         OvNI+Im4mol2KWpSAilbjR2EMH6+X3B7he0rupU5jOxxwG4VRlOOtZSq0ETGXPVlXZ
         DwVjeXvnDSFRBGcf3bRUQ4/M5jnrnmmt3BCKK7LG6DSUm9mZBEXw0mFjYaNQnVRMei
         NlhjTVKJ2/wdg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:31:13PM +0200, Jean-Philippe Brucker wrote:

> > Jason suggest something like /dev/sva. There will be a lot of other
> > subsystems that could benefit from this (e.g vDPA).
> 
> Do you have a more precise idea of the interface /dev/sva would provide,
> how it would interact with VFIO and others?  vDPA could transport the
> generic iommu.h structures via its own uAPI, and call the IOMMU API
> directly without going through an intermediate /dev/sva handle.

Prior to PASID IOMMU really only makes sense as part of vfio-pci
because the iommu can only key on the BDF. That can't work unless the
whole PCI function can be assigned. It is hard to see how a shared PCI
device can work with IOMMU like this, so may as well use vfio.

SVA and various vIOMMU models change this, a shared PCI driver can
absoultely work with a PASID that is assigned to a VM safely, and
actually don't need to know if their PASID maps a mm_struct or
something else.

So, some /dev/sva is another way to allocate a PASID that is not 1:1
with mm_struct, as the existing SVA stuff enforces. ie it is a way to
program the DMA address map of the PASID.

This new PASID allocator would match the guest memory layout and
support the IOMMU nesting stuff needed for vPASID.

This is the common code for the complex cases of virtualization with
PASID, shared by all user DMA drivers, including VFIO.

It doesn't make a lot of sense to build a uAPI exclusive to VFIO just
for PASID and vPASID. We already know everything doing user DMA will
eventually need this stuff.

Jason
