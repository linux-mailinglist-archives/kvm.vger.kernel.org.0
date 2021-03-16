Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB9633E207
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 00:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhCPXUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 19:20:48 -0400
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:16897
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229792AbhCPXUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 19:20:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CO21ReV79z5psDFdLqENSBDz8jTzdyBPOvH49C0ex7XWft2Z9F1lJsd2gjM+RE6jCGq2QUAbEeOmgknCE7AR7+TyF9s69g7z0l5NVHzwDorKj8Ls4zJhAZONyQXuKwv6ZOIDh4svxv6Rht2a06TBS/6KE6rbO0b6bwHdPXXM/Ao1W2kEiXZytBbveqqYkUATgJQyKDba3WskSF8HHpsqftG3mIIwlWX0ohLW000XwJOOmQm/Gf46gecfyzeodDWmRQTDwRj95Sm0f1N2i5TL/gBaoz/H7aPVtpKArZxfMPALqYa1VY1rCDtwVcETWBeJD6P1FDCQLRW0vnjsEQFnwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8qVF6LVjaGXLHv76QQySjx+POwYRjQMaGIETYvljZs=;
 b=J0PERlttpidoOkM/eVBiVmDxP39kMPPSlt22SxgX61gxBx3ypxG6kuSLiIQJ2UIG8fhwBEV2UAH22M9OM1dh3lGkXZWqN1gA9Zotb2oIEmgOf4pMe3qI/E9aSwJcA06VVt9WBccpYIO//jzaNZS2QY7pXMRiwIcSKjT21iJo8JGSyZqlXXPisFGiZaXFsFDOubt8k8RXnhLU57ClRA9h04KO0AvAD/UnNinhvs/QyoANoBVedZDJhsMVvGPaeDFFXz5lqDPj6TpcUoEtedmJ/sNO2KHrCi1RSVDZ1edFS3drLK5eOgRLtgw87GupnN7to791fiIcMi0LXSyGvZaj6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8qVF6LVjaGXLHv76QQySjx+POwYRjQMaGIETYvljZs=;
 b=LJvPcwlTylMoYz8VtWb6VMu9KK+qLlX6IV3/AbOSExHV73f8UZBrLoxXhZfx0M6pNJUMhzlI5Tcyi8GrUheIhV2UL0tF18ivUy6vCcoCTF1q3D2VM2jDQi+tjlTEYyhaT1QAEkUuzNFptqv/CP7vGvt6/JyOYfjeyPykRX3qv/VokONuU5ULRazDa/Lg0bOxOC1OYcrUU2TfGX0E5hNQpHr6vM9AVpCJAHp8w9zZGq5+u4lbDdhApa9B5FTa0ac0Da7SVdtoo/oIOLHyFFg9Dc0kgSOC7uLVUXqtgGrvknvlwVuTzyCXOwSimbfAlbWLgYUOlIveDi0cQ73iuzc9aQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 16 Mar
 2021 23:20:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 23:20:21 +0000
Date:   Tue, 16 Mar 2021 20:20:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 11/14] vfio/mdev: Make to_mdev_device() into a static
 inline
Message-ID: <20210316232020.GF3799225@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <11-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <20210316165527.22323c24@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316165527.22323c24@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR18CA0023.namprd18.prod.outlook.com
 (2603:10b6:208:23c::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR18CA0023.namprd18.prod.outlook.com (2603:10b6:208:23c::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 16 Mar 2021 23:20:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lMIz6-00FySM-7F; Tue, 16 Mar 2021 20:20:20 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c639bc6-5bcc-4ff8-dcd8-08d8e8d211ed
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB13408E1DF74CD40B173FD62FC26B9@DM5PR12MB1340.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OGvtEvqxes2UudnaDHUbefhbOSdIZWLuhoTHwAt7qzEm6hGoyVR0FLFlYs/LQeeNT5iuM5FAKx/MjIe8OLc/9AO6LS6xxjfdxUukT4pQpuUicYLAwrOXbU0KVMvfSxsOpfT/fY///g1Ia6TSYwgZfZCuMhNKTdcg9G6hPguTQs5g05SDBneYfZmkr7XUiX99zL3/XQ1HyueXFFpIRwXKVrAbNBLzMHMCfWqDM1EEoa4K9O+397Bsx3gbmOV814BWv46w4tiMulIe03HRPV9OrDgeAzsm3UO/65LNkhn5jzRfDnlKibhE0WXzKXltJDJ5wJRG0gZZK3P1YFd215keJvhS5v/HO9CwllJk16X0CT6MEJpePcoOuIUbRk9LEfeFMMH3Bn4Iny5PsKzg8PQVITxM/15GOt+ITfmTRD7NtH3MO5yd+hY42ofzhkEZHLQeFRsJ70LjQArjIgSJVlnxGPDmSLCAHNFhVlg4+ibZK/1nEN9P5mEPD2nwCslSNGMzjxL4WJEpMmtgewFigT4sWK1ZNcK6es7OQGqgPUVT5LIiK0nC1EbDGROYmZHERFa9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(36756003)(33656002)(1076003)(6916009)(8676002)(2906002)(8936002)(426003)(86362001)(2616005)(186003)(83380400001)(26005)(9746002)(54906003)(9786002)(107886003)(316002)(66476007)(66946007)(4326008)(66556008)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UetleVBS1Qd+Cz1H7tkONskkf+hfI34k3H22/6SpwVAEzR9O3vT+7YWK+eAm?=
 =?us-ascii?Q?F2mknOI1MWnElNgnSGD+vczxUFT2INwADneIlaw+DEP/9RVqaCvWCytho7qi?=
 =?us-ascii?Q?iktnA63QlUX3DF6lclZRWDCsuYeJ//JM7xCikisGsrsvdPdKZnXOU9ms3Itq?=
 =?us-ascii?Q?vU6VzYAw6Mj4ncaTw/+ABuq/qLv/42e+S005bxN/6YKshJf1NrIwNOQRVbK6?=
 =?us-ascii?Q?kfDcLAFliz9WwgCo7Rg3W7RoAwdNvWduVsGlCKIR9xl33muFXWWslIj4dv4Q?=
 =?us-ascii?Q?1weQitNeJOvywyfakandg+nSZL+oFlFcer1D7ROKq+2NvuQPe0wXOYJBKZyO?=
 =?us-ascii?Q?B6jKKcfyWej8h/6D+CS7FpzxL6FsfpBlQh/wLWf8eZFbkmkXmbZR7fTh7iEb?=
 =?us-ascii?Q?cnP92GHMODLLzfb+1VUk1NfxGdDc9cNGzQJvKfUgyvk5eey9o/p58sghqlsy?=
 =?us-ascii?Q?XXDEVNEvqusjGVvLkqvWfAqOYByxb6i1C/SuqG3VIOALom3owSRewHO5TgjO?=
 =?us-ascii?Q?/ZPfN90OYJlIfGbus4yu6lE+ZAcUvdmYNkXS9+VjsXdQkTggDgGrn1fN/HwH?=
 =?us-ascii?Q?FqoQ3vcajmPM4GZPGoYyCn+02xlTHHis/Apw0++TLGyWu/cRcSqh30rQULFE?=
 =?us-ascii?Q?fsn/1HlBj80RTUtQiqvoyuK8vXcr3Mr5hsSX5oogB7OW3DE46cfewAxXuMhc?=
 =?us-ascii?Q?jX/WNa0xBxFzKu04doU6b7x/ZgbF24UXbDbGE9RW22fXkZTG0aRltdCAztV9?=
 =?us-ascii?Q?4ejjNFOixFCJdKMwwifwYjF0Zo8b0UoJ5Z2ZkNtEKqUa9Ats4urbX3txYaO7?=
 =?us-ascii?Q?lion/awXPsbwrYhCrYYUxoxkEHrNw8w4a1IT0jHf6/vgDpehU9OJQX7JIY8i?=
 =?us-ascii?Q?e/+rSE3gZ1cuTLL+j3eQJo8PzlSsEVdm2xtdWu0iPsDKgfDHdQIcsZNhEhcU?=
 =?us-ascii?Q?cZSenhhVxWbUWd8xcetuKgunGELodPUoYa4T79VF840wUPI/bTUGI5+IEYR/?=
 =?us-ascii?Q?hmFEXmHQEdemhzlAiTiUMaP73CLDQTLtiaMcrtN0jozowKfnx5ugO225DXef?=
 =?us-ascii?Q?9Tcn/aRnHYOVMj/i+INATzsEm6jtElLiRqP2C5wORJ04dVuJK8IxUaE18oVO?=
 =?us-ascii?Q?Vxk5uiV/wceyfmBoQpzrYnoVi32h1CjjEMLr2BUrifj/hOm6z4aDthbImGmt?=
 =?us-ascii?Q?0uqr8OL7Tw9JfbqvwFWfRtXGgOkTwDgUkyQVrXvpbe3WeRvE2+qVSXNQKP9x?=
 =?us-ascii?Q?r6tUhyrZBN3tN/AR5pBydxpsv4HKnM8g/EL0uPf/3lnGRqeTLEU034oPIAyz?=
 =?us-ascii?Q?DLLznzGBoLmpcWuBsqlB0+kubmY408JT4H2XhXIyOb/A5g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c639bc6-5bcc-4ff8-dcd8-08d8e8d211ed
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 23:20:21.7450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UQmnmhVkRBrnANSgLfBnUXgqOCAPcuTn0c8N1z3Wh0jrk2QVMqEEstW/jj7iqbo+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1340
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 04:55:27PM -0600, Alex Williamson wrote:
> On Fri, 12 Mar 2021 20:56:03 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > The macro wrongly uses 'dev' as both the macro argument and the member
> > name, which means it fails compilation if any caller uses a word other
> > than 'dev' as the single argument. Fix this defect by making it into
> > proper static inline, which is more clear and typesafe anyhow.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/mdev/mdev_private.h | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> > index 7d922950caaf3c..74c2e541146999 100644
> > +++ b/drivers/vfio/mdev/mdev_private.h
> > @@ -35,7 +35,10 @@ struct mdev_device {
> >  	bool active;
> >  };
> >  
> > -#define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
> > +static inline struct mdev_device *to_mdev_device(struct device *dev)
> > +{
> > +	return container_of(dev, struct mdev_device, dev);
> > +}
> >  #define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
> >  
> >  struct mdev_type {
> 
> Fixes: 99e3123e3d72 ("vfio-mdev: Make mdev_device private and abstract interfaces")

Ok, but it isn't a bug until the next patch that adds new callers for
to_mdev_device()

Jason
