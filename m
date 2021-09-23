Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C1D415CCD
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 13:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240574AbhIWL2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 07:28:52 -0400
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:10780
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240493AbhIWL2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 07:28:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVsAPxu4cb+ak56UrN2i+8UOSyP+iNjoxWBPz883znrbfz5/q/ypy2cmrRFQOj3QBsYmuMtzLaAkoPgQuilHnIPEkpF2JKF0r6YlGQ/EFDuJa64VYJbRVpTDv4hBtOdRaCYauD+L9xjIwi7HbqSFQHe/cEqwAhFjI1FUZszvaQz8EPJZziIm4jNqhQTEjTZcec45ZRnJeC/Mxa+6Owq1awmNTDoB1sWRLToa8PU9+FAu+8OQnP5zwt9wJYBvSQEwL9Dn//DX4Hi3/dCzN+H1GHBpGnF17qgTMSWlySsClJNEImNbHnXPj+qE/ffirChEZMqokIjsgpokxSW66RLAyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3p2LR8qxnj4vuE95BhZjDAlBYig4f9Bo93FLg5b9Ukc=;
 b=eww+CJWc6rFzplNQf8iwrCyuLHzeySJe5WzSYVT78KzESTaz3+Pdv9Ps1qZ/tZD1w5fi6Su6NKjcufyETrWJYieda/YtIrrLRzRgnmVDedHmKnk7EnIwfG+51ui05ilS0FhH/xXtD4uCwf5T1h2lVqBGfJ0re+ElYyyHWC1mlX2YUMOW/meMZtfpDv+C0VlJ49flRFPnOUSSmF5K+KrhyeWqPEtIPAVVsqFg6Vs2WhCOx4Jp/rFGUjghvi+wXNMy6IYqc4Hcrpufwu8GqYcSTiDGFLJXfp8PepywaRm2oMmEID3cZdeWfpgSUUGCCxobU4xUiAxvMtStgEtymYJd6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3p2LR8qxnj4vuE95BhZjDAlBYig4f9Bo93FLg5b9Ukc=;
 b=nfmqVVZj1EgxvDplMgQTDAn9qB4+rHB60+WDKYDsChuauhWza6zGpnJz8KlTxVeJ+cO3RCVZTdkCGA43ZMRYqXZGmajTnatecCRorvxIE5/5fbHjAsTrfQHlY0DcxzeWTliKZ/MtB9P4uNljXGaovrJFOyryuhHbWaqWauhgY/PLQfiSpy3RntxqrjZSkRoLOurknnH9/omowG9ueV3Ff5nS4/4P3dHKnfIbqxWFKhTMYuFOBpU5fueSQ0YvUAi2qGlK8rAJqRujOmEXAVLYsBMT4bzifp9JpfmxgB9hLtpx5vDcnprJrUR5GdZ1CMphttEMCa4RoS2zWlm+E1OCHA==
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5556.namprd12.prod.outlook.com (2603:10b6:208:1cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 11:27:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 11:27:18 +0000
Date:   Thu, 23 Sep 2021 08:27:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Message-ID: <20210923112716.GE964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUxTvCt1mYDntO8z@myrica>
X-ClientProxiedBy: BL0PR02CA0115.namprd02.prod.outlook.com
 (2603:10b6:208:35::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0115.namprd02.prod.outlook.com (2603:10b6:208:35::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Thu, 23 Sep 2021 11:27:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTMsm-004O9R-O2; Thu, 23 Sep 2021 08:27:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd1e458e-e515-4132-f645-08d97e8519ee
X-MS-TrafficTypeDiagnostic: BL0PR12MB5556:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55562D567A706E37B244F0FBC2A39@BL0PR12MB5556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DnNLm6Cs4y7cgkKM+xq1cA7K/jtoz6TZ0cEehy0CE261Jr+sx6hxTHJSjN4PKpBPlOEJg/JFxgMjgRFNYrNcrU47/XnXV5Pap4peiaO6T1NSaLyjxewTifGfvA+S5zqrALESdzHWiJ9bt9aLaznaYe2xMLTIaWLTrgCA5xkAjx771FK02ZyCvON/bPIPhALsK2ouKMPVq09qlDvGsDm3wjn8kebqXTgMBtf2yhNxz36d4ZR/bp4zVbVlLgAnSUHZI6xcAyDsny0XUGMzyqNmeUy1LKYaZMVhwI3EXjg7ADkAIoKQUy2dqKC72Si9ORKozIGwozzIqvWfpecx9W1+JzBvM+WHxp2APrvQQJWhdJh1xLb0L2blOspHDTm+K6zE50h0OqrG+/2E/avHtEuLTmF4viXudza+I1++RuN2zac1zAwyqgHdVAiZLuM1WOdb1Jy+JYRWulPIgWGVdkBgxgiiSSAdgj4SJ5J2A6A9jXaCFwl7O/ChNtkr8F3Qxvf21LraBPZH3pOVbwsck5kg/uJqtTB6G9AKx+L6Wb0yS7ep0DbkDI5nd7eWw6QGV3Ctn4vpcM68ei90JDx2Ea06f36tQYiONCbcBpG+SFm9yoNu1e/6muWSDfqDutvMUDm5PaoxvWrDfq43wUfhtvGTstqLoXy1n+BxcG3DQei0JqWLQYkGQC+O2bipfvvcRGKf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6916009)(66476007)(66556008)(54906003)(66946007)(26005)(36756003)(5660300002)(4326008)(83380400001)(8676002)(508600001)(33656002)(426003)(107886003)(8936002)(2906002)(2616005)(7416002)(86362001)(9746002)(9786002)(1076003)(38100700002)(186003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pC9gAMM6iD8O6S5wmHn8+gSBP+HXIcvO5TxISG0ZOypTaNPDn1FYmyJZHXgb?=
 =?us-ascii?Q?P3BZ49nYz8SDxso10KIoRuz3nEuESsjO8v9fgJKNz52x+RT70NyQ2lXzUqMP?=
 =?us-ascii?Q?+XNxsQcVeYMcHCmO5t7yOZA6PoqNPWwQRSe2zykZ3Fl+YQtycjQoAAd8n+VD?=
 =?us-ascii?Q?7UZgKW/q5nSG94YbcDJGIoRAMxOYoqB+QXqOA6qeNuaphx7IktZbJi76Wb3k?=
 =?us-ascii?Q?b/o0EFZDeJLLX8ctHZn3laU7C2J3vB3Ns9F6azsMw3YKeNChuhDzXhPISS95?=
 =?us-ascii?Q?P5pabjfY2D6xT5lEsl0bSsVwqIMFg+TI+03asOIw0j77zIcokLg70s+sAmUu?=
 =?us-ascii?Q?3hfYkIkEFeniEUKNSkgf8g4YdRjBUkEb2KYuOIRKKlEHdYGlUoscWPogtoKz?=
 =?us-ascii?Q?4fXrO7+8zvSXad+hhEhkXaNZP+P7GXop3voILWUUwrPkxAjfH/rSr89+z8n4?=
 =?us-ascii?Q?13AZhHIG5CkRFIwj1nY2Iu6MR60rtmv6f9YqUerSmw5yw7D4wBiX3gEKOjsk?=
 =?us-ascii?Q?LOnVux47qDGEWuTOqaeoCTUj9WhHJx7q9ytS4JoYK5esBAS6lmoYxgfJkMOt?=
 =?us-ascii?Q?plnYPDJ9RNtPMUwc4YQzc0hOh1h15qfWfkWwu6YmAKDTzlgzHzywqzVHpJsy?=
 =?us-ascii?Q?l6WNjTVyKOB4TcO3mUrd/sZkKI9cVYlutOCv8t1a1ijk6i2q25Y5gC+y5MOT?=
 =?us-ascii?Q?Fed4JrtCpYfUqeJpDfnXJfq1sIsKOgKxEMQ237klrj20PX12QBnUNUL3hpiv?=
 =?us-ascii?Q?llPopHCTYuLp7v8e7oo2wjSoYFMYbkJZ+Q4MAkzk9JdNd9y0QGAaf7h5XnA4?=
 =?us-ascii?Q?CoCfys4q2cq+tD5ngfwNKe7R6GGPF2WgIZWiP2hkZCvlbuURFSyc/OJ8n+DR?=
 =?us-ascii?Q?Y+YVjB2+7gFz2O+62iFmpnCugXA+FDJzdnVtGrTjTsifPm6xg9DfVOeDPRsJ?=
 =?us-ascii?Q?JjN0Rbb+hpcl6VPA9GIDEKL2HrYctsMYLwrQa8UI4gjpDU3cgDAP8NfcX1IZ?=
 =?us-ascii?Q?/Nk4vgBBPle7kn/6u/L0wCYhqU72pHzCTwGIV4dJfAQGlkjzg+5HgjqoWikw?=
 =?us-ascii?Q?5QnIbndJRlkSGhaXZIOBBPiAHl3WcYJ79gxaoIjpNkDsiwvEvPAIFvYGFohk?=
 =?us-ascii?Q?X36HfCefmWTCbwNAxugT+74SDQ9DpcGoRKVyHGzTvsozj7aKsCI4eCweU+f+?=
 =?us-ascii?Q?zJ7g+ROYVcQ9PfIyQ93MB1/RZuQS9IgL0Dzx05ACo7zjCtcpTFGCuqSXusCI?=
 =?us-ascii?Q?zL6hUlu1W47aowDjPnGRP/jWGdKQh8GVHqfxipTZVZ/YARMsLO7NOrWN1hKP?=
 =?us-ascii?Q?L1lciYfR87NyOmwh0TeLGJ+2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd1e458e-e515-4132-f645-08d97e8519ee
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 11:27:18.3882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fr1VvfeT5xYexIRk00zT6CQ8A6LRbnpze5Pkftj0lCVgXmsIcnBASPztpTi2QABM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5556
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 11:15:24AM +0100, Jean-Philippe Brucker wrote:

> So we can only tell userspace "No_snoop is not supported" (provided we
> even want to allow them to enable No_snoop). Users in control of stage-1
> tables can create non-cacheable mappings through MAIR attributes.

My point is that ARM is using IOMMU_CACHE to control the overall
cachability of the DMA 

ie not specifying IOMMU_CACHE requires using the arch specific DMA
cache flushers. 

Intel never uses arch specifc DMA cache flushers, and instead is
abusing IOMMU_CACHE to mean IOMMU_BLOCK_NO_SNOOP on DMA that is always
cachable.

These are different things and need different bits. Since the ARM path
has a lot more code supporting it, I'd suggest Intel should change
their code to use IOMMU_BLOCK_NO_SNOOP and abandon IOMMU_CACHE.

Which clarifies what to do here as uAPI - these things need to have
different bits and Intel's should still have NO SNOOP in the
name. What the no-snoop bit is called on other busses can be clarified
in comments if that case ever arises.

Jason
