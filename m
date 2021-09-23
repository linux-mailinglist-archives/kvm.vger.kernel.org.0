Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB89E415CE4
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 13:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240647AbhIWLhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 07:37:37 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:1121
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240567AbhIWLhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 07:37:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKuf1RyhiSFAr254woQT8PkPWY3sdENxRqtXkWbycvmy76NOtfOUy7Ci4pnlYtbDQTC9K46oIA5BfJz0Ez6wq/Z4ctpItJ9Q0LQWt7yelESUb+Z7zcQoEIffI9ofhda5Zpx8TCxzxbPkq0DHFZoy34+jTk/RRbCCUDawJ2whJUnVTAihfqMMXgRe7hKMqkcovguTcClk1v/suDQQcJch4jwjR0hNkIclm2bAfoOnrj+RZ+Tn4B9h+16pfBD0FlHnlLEocMEZNpp3dcL3Aku+dLK2ISgk0Jip1L73IjYmebYEExincvdpkIvqOzNIy+eW/pkenA5es+oPSs+lewSPWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kEhNweG+2rb0XCTGkVOR76u9OpQi+HWVIaM1AwLVqRY=;
 b=nEq/KluAOyrIaavMLpW/gLNtyR/PUtjAwgNM6I+vs6Liiq52QsLwxz6mykcGkAfhIxPKjcwc8KcNGZdXsqYw0rtY0Lq8K8bNYrSE9aEQEc8L54wXNfO22aIsQQvVgMn3HbZB6laAB3XYb9vBvi68mUggUh5Po56VumhpmHP1T+p/4h0hoGa5eXlQ7CjEDwHkDwZ03IQp1ySA1i13L1eyYVcZFM/GgFnaP418DfnXzC7ICQ3teS0xajht/0TWV7SC576D+z0QCY8lwKrCzUqWQCGCTw90FNyjb+4kjOMAmhQMF9D6+7YdWsVUJ+G41RAWStmEByX7EtHprXQP8EpNLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEhNweG+2rb0XCTGkVOR76u9OpQi+HWVIaM1AwLVqRY=;
 b=f2faKEfOjcCCV7QeEmd83YgTDc6sV6be0XapmTsb0E1PPT+DAW8mJLttrPimXpXSJQfmg6w3itXv5nMu9Q+UyfGrOEtoazaOMZSQK2WM1TnhvSGEqDa2EfCEQtX/UfmZVh0TFWVDCXjgHpzMyQMLetnu69VPm0Nm6YREwuuDVWBcXFmx3Ow0vaLgsK+lh9f/mII2OfJlZ0yIShlKOoVVuSWpsH+ohs9kRnrAjwwzmMHiUeWvahapDsA+9jOHBsX8G4x5tD/uZZ9NonAN1NqeiHsqCpPnM/mAy+ubZbeyzn26b2EM79OA4f7eZwwZcxlJ0s2JArwFzcUagKg3HBdJRw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5160.namprd12.prod.outlook.com (2603:10b6:208:311::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 11:36:02 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 11:36:02 +0000
Date:   Thu, 23 Sep 2021 08:36:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20210923113601.GF964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:2d::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR03CA0002.namprd03.prod.outlook.com (2603:10b6:208:2d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Thu, 23 Sep 2021 11:36:02 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTN1F-004OI7-JG; Thu, 23 Sep 2021 08:36:01 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1a9049b-219b-4180-7b9a-08d97e865263
X-MS-TrafficTypeDiagnostic: BL1PR12MB5160:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5160E0692D5D184E7F27D56DC2A39@BL1PR12MB5160.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H23AJgynycVbhia4AByy9Rxwfo+PF+CEXOL5zT+xiQSZY4lM5GiVNz6JUylr0lepiqRK/usG1mhJ2QpnFPegwf6USVtPCFePhvXzu+HlNPzRLgD8wBrqLM5h/8yZU0SJu6nZj8XhkWuik+TX+HGm5+W9rqqhhD0yaSCtWa4yjm0BCdUN0O4NV16zl+8okP4uRAKBGEWST6eziS8RcrUosCm+WW8MpWOVG3gbrGSaKvocD4VRWg+gX5LOotMY/ZdVfoyyt620fqB0jAwkVl+u14zkBRQ/Tx8r+bH2YlTCq7L2DGHfnNy5amtXY9OSgHycfCu9Cf/UBf1RSkknSWgQsaQtfjurjXEhSq2nsvmy8ygfpVZVE3v6UNg7oLflAA7wmEDqlGen5TBwr9KRAZCOUD0pKBjJQ+Kb06gMJdpceRQe8W7r/3oIQJqIthjmZdIc75kR8cC3qjtj+SMYQiWlcLcab7X5guLkjEY/XZ3rcIS7EyYCN49QhhOSvK1RfbNyA1LChx9QXpm5AwefMVIt2358MfrRJJVu/mm3WNg2iQ0I1IRX0q3Q/HZoqAX2ApRtJh7tgdh6HUVQmJ0OFWjxhnJFyadF6aCaUhtG1+6sb6byjsCBvqOwqdC5QoexGPwzW+mMC3H3itk5sfeOSVCdzHgDsx/9KajxlMoeeUcwxotPZkLABWyxlLbrgLvlL/Nx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(186003)(8936002)(5660300002)(86362001)(33656002)(36756003)(1076003)(26005)(38100700002)(4326008)(4744005)(6916009)(107886003)(2906002)(508600001)(7416002)(66946007)(9746002)(2616005)(9786002)(426003)(66556008)(66476007)(316002)(83380400001)(8676002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J/xhyjLs32z6UM36q51AYOmsUFKXgBt553AZihg1Fdk65fqahuA2mT+wrP8G?=
 =?us-ascii?Q?jmzrGcIeEMNLgIxSFNKqmnSABsLHe1NUTFugSUs+JFejgl4YcMPmxPmqbp/m?=
 =?us-ascii?Q?PKb3DMZsZvsHG8xbd3hx6M3YF5l8Kfr5UnyDU0WJ6uzJ2cQGhuoqlulIZbE2?=
 =?us-ascii?Q?TNugVKsbXfact53VCcBMaYTljhkxTWFxHmQA6xu/tLPWsHor7lS/0z/U02/7?=
 =?us-ascii?Q?Wg3pHPyTzbsKpPbuOk967WnxQVZo+FWEULND2fOHvGqfdjZaGb/TX8X3w+hQ?=
 =?us-ascii?Q?iV8G//8RgArJK0umIfg8K/vTPply1Jxp3FjUP1/LqeSZbw0lQMCn4gUGye5b?=
 =?us-ascii?Q?+vWmU5nKye5OcOiB2kvbl52KyjCXZTHdrY2LnPcLy6E/Zb4rp/W5nNI/rxWV?=
 =?us-ascii?Q?8+6W4wp4Gqc+NnrGhW1b8yaSBUXT/fhJz8tBg8/Va4Su2r86CjkyQMFjCVy9?=
 =?us-ascii?Q?kHb7MmH+/3Uj4YECgHO2VQlHo8Qur29c/MYgQ0oYB7xYkoIKu0O+S2jvBfyK?=
 =?us-ascii?Q?2N9hI6TzYuPky4sVJ51ck6JNS3WtiChBjtlaRWptHTvsYrYYV8XV0H/eEBzn?=
 =?us-ascii?Q?zRh9SB7mFetkF9zCACqyNZbm9neMhSsOPL1vIi/3n0rbUOstZ1FfjM1eYDix?=
 =?us-ascii?Q?FV/chLlmzAO0fqNeUVf7YH9vbrkp3ot4ztJK5UQ5wc28CSOEYNqHkSr3Llkx?=
 =?us-ascii?Q?WNovmB3BmFU9ztOnkPETwWITE+HBeuu2VZ79Yn10klfQZwB/YA+N8v5z1DbZ?=
 =?us-ascii?Q?3mZMLvF93asGrC2UM5/R1jxRaOTcFHgbuFmUT4IDPbXgaWv/3k528PaqLIle?=
 =?us-ascii?Q?c3aRRNz23sW+VnMozWJU0CbaVQ5eeV+o3RiOPh9kkQdzbUTPoSR++kQtFjTp?=
 =?us-ascii?Q?u0jSqP3FoAvlqJ/c0odd4+aFwwExxLQ4jAJ4qsAi0UlybLgEyB/tyC1VVv39?=
 =?us-ascii?Q?ytz8Xmc46qp5UYvpzwxFPIofr9LyWlwYZqBTBRzEaOhtgegOvgHjLcRDCDII?=
 =?us-ascii?Q?ChWPCKQ67eKJgc9Wgxj9o1qHz9GjqIVfFyIVs0t4yJcBclBdHP24dYqpMq9P?=
 =?us-ascii?Q?4HP0o696zVt0hei0oRnPVIuf36gwDPBCiEq3w50dASWgzXVrSI2anDqL9oaF?=
 =?us-ascii?Q?1oDRze+v/0x5HdcnQ1zZg8wB42A9yFMqfoYWqHd/e0dUekSvFrfPeco1LyFA?=
 =?us-ascii?Q?OD8FMRPa8y/49m/WkMsHnMW2aUf61ih3KI3+td4RdinY/6HQFmYQ7QxEs9Rw?=
 =?us-ascii?Q?nwBu4jmoQik7KkyL5DuNwxXXksagolAKsiob9XHOCS5G4R/WHUh4YD5y7OFU?=
 =?us-ascii?Q?0md5PLY9A1v990XzqcZsRgke?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a9049b-219b-4180-7b9a-08d97e865263
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 11:36:02.4755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xq7olsuS3cpWd3WsEAJjopj1b0qNuCNAKn9jWhxW6gXMQxOHwCFqaALgi6zUX+SA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5160
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 03:10:47AM +0000, Tian, Kevin wrote:

> Disabling wbinvd is one purpose. imo the more important intention
> is that iommu vendor uses different PTE formats between snoop and
> !snoop. 

The PTE format for userspace is communicated through the format input,
not through random flags. If Intel has two different PTE formats then
userspace must negotiate which to use via the format input.

If the kernel controls the PTE then the format doesn't matter and the
kernel should configure things to match the requested behavior

> When creating an ioas there could be three snoop modes:
> 
> 1) snoop for all attached devices;
> 2) non-snoop for all attached devices;
> 3) device-selected snoop;

I'd express the three cases like this:

 0 
    ARM can avoid cache shooping, must use arch cache flush helpers
 IOMMU_CACHE
     Normal DMAs get cache coherence, do not need arch cache flush helpers
 IOMMU_CACHE | IOMMU_BLOCK_NO_SNOOP 
     All DMAs get cache coherence, not supported on ARM

Jason
