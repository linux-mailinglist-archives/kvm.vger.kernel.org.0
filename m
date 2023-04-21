Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D106EA563
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjDUH5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjDUH4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:56:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591B4A273;
        Fri, 21 Apr 2023 00:56:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUKoQhlnN/DMs7X8wsVMRvizN0Njhq9H4vz66JpGAmHye8UUJRYutDffGECyXO8K+qDAG9/j4fPWDVnB54Q+EOi+MsDJJh2b9ZfRchF1003EH4VgtcL9Cxp8xcFum0nvkke+Ad0TPOatrmETnefQk6dWSAvKhJKkA0DsXKZErr6LbdMCm80/WOMUTBgdV7QWEj2TBxGPVOapYGEakloQPceRJ+PYcSaIkuv+VE7Zyr9bDvSeMDXMjDapXIjCBWgnnuWjTfWUkf3K8+UpszegqRC2o/ibxHWVz7h4AazyFcYCrxFAQ06UpklHM7OfSRgCFnyoRl7dPJJHGrPUGGuAew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcoqK+1uPvOKxbPqdmPzvqyeyfg1A6Qh6+26L00eAjU=;
 b=J09G7YYnhnz5EGWlpm3q3iQTcJbyRra96sjYg4tHTBce3L97VHl7mp9DGuPpOCztOy2/TIXL5J49D9FHkng0/3W6RrNToM6oWrFtKafLuUwot4gYZIKQ92s2zYfvh1msBfRZFDWV83wvpeY3MWJwTmpkyL79lSxkL7hoBWp/VluOMY4Q8mT0pWatM5Dia7ykvnqGnsDJFjLuun7dr7NXcz7v5JmH0BWmFhfFyLAmx8VGYgXzdGnoG9q+zGOoL6yMFWbJem8g7ZjbKVCs8mKu7zotEP8zmrJ/Lnrxyrwt9f+qw7nfrbVpTc0DkUuB1kd2AJwib07yWqsGAbsreE17HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcoqK+1uPvOKxbPqdmPzvqyeyfg1A6Qh6+26L00eAjU=;
 b=cLd/+jHdqbHyh8gLL7kMs8Tl79A0WY8VoEG99dp40oN05Go4OBHWOeIesL/INPQGA71Yzvg1oF31RgOLIxYOVQoobrRLSRbYFPV305rl7dtdYCAhV0U3WtZwgUvXrhxfnJpVLS0Nbf1iHY8hjwUwMFn1Kwjbrxe23rXNqANg8Sq4kiH8WRhcJ4T3jApXF/oXSLyxNhgz6spX6OuOp7uLfarJLaXP7xSwLyCRJCoWTgvIvDCr87uCbwNojqN5RA7V1lL9uu2O1g99oxKDA+tRWBDvWtuqnN2+j7xaavqKRyGYBLDKVgN7gzjfVyZ78f3JHEblawzANXp503CpLySYZw==
Received: from BN9PR03CA0678.namprd03.prod.outlook.com (2603:10b6:408:10e::23)
 by MN0PR12MB5978.namprd12.prod.outlook.com (2603:10b6:208:37d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 07:56:24 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::44) by BN9PR03CA0678.outlook.office365.com
 (2603:10b6:408:10e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.27 via Frontend
 Transport; Fri, 21 Apr 2023 07:56:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.23 via Frontend Transport; Fri, 21 Apr 2023 07:56:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 00:56:07 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 21 Apr
 2023 00:56:07 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 00:56:06 -0700
Date:   Fri, 21 Apr 2023 00:56:05 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Message-ID: <ZEJBldGXBNGEy9tV@Asurada-Nvidia>
References: <cover.1681976394.git.nicolinc@nvidia.com>
 <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
 <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT042:EE_|MN0PR12MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: 73b31e83-b77a-46fb-38ba-08db423de6e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0QuvBCLZAIR05oMkV2kHYTfuSGUEYGHWYb9g/Uy4UzkyGXJ4XHPHuXaaztcjxxeambxRsae14q0vUxH3EE6Z99EDDGVfPGaw1MpsK7/ZUqtmIbbyAc1oRl3ylLoRnr7JQAZs0p+iuP6hKMmz/N6gQYY2zzjC72+34UGICIxJtqqOvzhRN+N763ZPzMRmpoU+S/aJc5IX1ahTh4w/wRPYJfKd73Lixk//wmD3Q3hPDIOuTkthNclOHrZHWK2nZGNolUJwr0QJy6IyXw+TE9gSAeSsHNmN9EhoFQ92Qw62U6cSRZ8x+K3ffj5JfsFEVR+a8LQyUOb8LMiNCCcQGbVhSMgM941XLqtl+Op9Vb3uPKF6u2nYw/NoYN1XkUURp9TLupdgZSuu5mVq+vp9zMDor6ktSGM4tdMLEV7yIciG6NhXK0RGqO5rMqdMkjt7+6ZtM8eNSyC1Dat9BcHcOA/tzHJZcWt3UIpdyjWMXPoFnHRzzLyY2nGsLDokQVAOJJOY1eK+XWYY9n0jTksEOpzQADKhuSyCWQQzbfKyizvKMCs1krMOvtbxIKrysrbmtlxiSStQOIiGb4z6XcgfavhpOjOqqa/FupZ/4CkRKDsNdZLerISxeJpqPaaTqWaDMpR+Rj0QPNa+rSEo1sqvlTKoq9mq93wS+ZZIvdoh8u5MROg4O8/yu7SY5Rn41PjrXAnpok2j4mXw36Z44RIVdrl+XMOh0Mocr1HWkuKkG4TqTGuQJYcZA56EUaeZ6a1+x3LWo27A8lq4OAyyNtSbiIDoMTKzkS3sECf6nz09QOybpimqier9/2knbUjapYp3t+QLQNBz44I62itztgsHBC6rC5bqG7qK5qrRaZCE5SQgMg=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199021)(40470700004)(46966006)(36840700001)(36860700001)(83380400001)(47076005)(40480700001)(426003)(336012)(40460700003)(186003)(55016003)(26005)(9686003)(70206006)(70586007)(82740400003)(6916009)(86362001)(41300700001)(8936002)(7416002)(2906002)(8676002)(316002)(7636003)(356005)(478600001)(966005)(33716001)(54906003)(5660300002)(4326008)(82310400005)(34020700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 07:56:23.5533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b31e83-b77a-46fb-38ba-08db423de6e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5978
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 07:47:13AM +0000, Tian, Kevin wrote:

> > It is in the commit message of the cover-letter though:
> > https://github.com/nicolinc/iommufd/commit/5e17d270bfca2a5e3e7401d4b
> > f58ae53eb7a8a55
> > --------------------------------------------------------
> > Changelog
> > v2:
> >  * Integrated the uAPI into VFIO_DEVICE_BIND_IOMMUFD call
> >  * Renamed the previous set_rid_user to set_dev_data, to decouple from
> >    the PCI regime.
> > v1:
> >  https://lore.kernel.org/all/cover.1680762112.git.nicolinc@nvidia.com/
> > --------------------------------------------------------
> >
> > > Could you add some words why changing from passing the information
> > > in an iommufd ioctl to bind_iommufd? My gut-feeling leans toward
> > > the latter option...
> >
> > Yea. Jason told me to decouple it from PCI. And merge it into
> > a general uAPI. So I picked the BIND ioctl.
> >
> 
> 'decouple it from PCI' is kind of covered by renaming set_rid
> to set_data. but I didn't get why this has to be merged with another
> uAPI. Once iommufd_device is created we could have separate
> ioctls to poke its attributes individually. What'd be broken if this
> is not done at BIND time?

Oh, sorry. He didn't literally told me to merge, but commented
"make sense" at my proposal of reusing BIND. So, I don't think
adding to the BIND is a must here.

The BIND is done in vfio_realize() where the RID (dev_data) is
available also. And the new uAPI in my v1 actually gets called
near the BIND. So, I feel we may just do it once? I am open to
a better idea.

Thanks
Nic
