Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1066D127A
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 00:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjC3WqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 18:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjC3Wpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 18:45:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35A910ABB;
        Thu, 30 Mar 2023 15:45:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYbk/No38XbXqQSOcLW1cgdfIFjIxitsyotQTpjuW4+yI1dBMosTZuX7f0rZvw1q0J/x5UZxCm4inO5wUMmtP08SvDuAaI+2YThJbJqmMz7eLUKXcWZD4ILhLnE9ugizDGUa87Y+YgC+RBYVE0OY0ESfG0B0VqDOdBdfSYily4UWS0a3X8a8EK42T7ZJZ3hkZbBJuFeMr8weh8YTQon8/2fmYb9LVeAIeKHIJuGrsv83ptt4dtqKjxGPyIDtR7R3yndmYuGKKIUjxacDyIFixdIrJM4bJDyNOs07MAOWr2KwhT7496ojKulQFm8U5WhWPn04mRa1PfK9+7GM/paTYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0cx97Hcuah6BVSk+M+wLTLqe06bgmOETZq0V328K5U=;
 b=aBi3RWXUNeYQ4LYOpR1J73BIvuaAwSdN3/3tGk0Td0RFglwnVOnpNzGCQc0R5Luodn4zkFDChn+1bitzSQi5eHE19jp5g34CyG4TFldM4skfwBPmwNMd+Hkc+nsvmI/uEIJRd1MyW5k2jHhTlkhxEWWIsf3wBqsp/FkBDcD+ls5+jmCxIECwZ597i1/tikAZ95UlQEC4YcauVRCGFuh17WU6eEw8iXAcPUTunvjk/wVY4X2UyTBLsuOr6ioG4GEoJbrO3FUUvVS9rQRberuyIBDeH6Qux2t6PdiHtSKn4Pk2lOQC1783HtETTZTk1Tthukq4OkGgtdf6+8Szhhp+7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0cx97Hcuah6BVSk+M+wLTLqe06bgmOETZq0V328K5U=;
 b=nAMCt7PgE8NrpgeToVNFM9HzBXrDXrUXliF9Dd5GFSe7cvpH1526EwDjOZx7LbWSR8y1XaQs3yZhgaKlDrnlfGQyoYJNCYq1cyMK6tgpro7uQXHoBtWgF2JLw0KoL6wkUABaaBHmk9ElilRQo1vOmKoPAMRVIegqWN1Hx0ab3RCojkNJt2O/tNPjMIUb4mT/tz+2KZYOcgbirOS4vYoxNjIKIPyeu9GSXb602unsmVB3bAjKqIPkutNx2g2Wd7bvtpPCeWfsVUhWDgQwd0Gw7fyDCAyG5UT1fRg/IeoegvKMShz4YDZJibLXkpILEWKEvGpVLi9+aPOstTAWU0oHsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7212.namprd12.prod.outlook.com (2603:10b6:510:207::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 22:44:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 22:44:56 +0000
Date:   Thu, 30 Mar 2023 19:44:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <ZCYQ5zhmjg/xQmTZ@nvidia.com>
References: <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328084616.3361a293.alex.williamson@redhat.com>
 <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
 <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328100027.3b843b91.alex.williamson@redhat.com>
 <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230329094944.50abde4e.alex.williamson@redhat.com>
 <DS0PR11MB75298AF9A9ACAEBDD5D445ECC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75298AF9A9ACAEBDD5D445ECC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:208:15e::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: 525f4082-7653-4543-27b7-08db3170624f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCJ2NZ9d9yMfOMTzeHZTXBXODRPkM5cZsu7qeJ0SQhiEjZ25fkDpm+N9cEm2y7QOyljovKr38RKgfbgcXVgV+E2J05B8S+j7Z0UhP0Afpb9wifCC3mZA/mP3oDdoP3mfD96qdHWFoqJfTlGPdSFc6WjeEGBv1goAdR34Y5raH8HJ6e1eYcBe4gMLi+1lRguykSmQodkiJDztZAxjTuPnpubUc9/hSuhOCsy5pchqe8NCDcTyLi7IQyfBmXOqFffT1QJjWLHJblaB/Hxvzh9tqnwT73gEnGDqktwzXurLpI8ysaXFzB9GORtXGyb4WEPC1NiKamW8DuT6XPt0maZv/rYo6dlnVhXKkS+HfeFm617VsyEs2s3W9P45G61oiSre8p+rtjtRrNbQlMx4DD2KbBhH6dkWVIgv3gxEEjS4hxRRrY4gbZgx6C0A6/LJ6lCtYKKftS540ypMd6Wv67bEN4QGTD/4/AGASNQA+FLOQ+tzb3EuquJi5W37gvzTbx94H0CaAjivmT/tu0KWQWq+w/4VBP2hxPP51Rfow+R85XYHoIhuvdIFflRbB8FxvK8i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199021)(2906002)(8936002)(38100700002)(41300700001)(7416002)(4744005)(5660300002)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(66946007)(66556008)(66476007)(26005)(4326008)(8676002)(6916009)(83380400001)(2616005)(186003)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Eqa+a5jRE5dQZcGSE5qvpiTDk9IKc9ZzVIYh9FBHZsOyd7OmtwuWCZLQay9S?=
 =?us-ascii?Q?nCbbIcGnP5ZX55Y17B3j/7w/vXdc9tIPCyK35OJqiZBRkhTGCiABsmL3oL3Q?=
 =?us-ascii?Q?UqAer4xcweRutR0mXFc1tC/CrwZD8CrVD+1FpM/m3w4ZIkSqWkY7IE8/RsCs?=
 =?us-ascii?Q?QkEaOL04GHFwJ+l7AlEyYY/NcmCZpWVZLUYRPTCugFJ6zHm15v9hFAItGai+?=
 =?us-ascii?Q?2n9+UEYsQAIxgQ8tFkXi/rD2Rzs4H74JH/oBYFII36ntzeWaa/OL1SPgoWhQ?=
 =?us-ascii?Q?F7KJwk9v8jPY+QqsxLoYGNFAqWv5n1QGz1zVVfxBQdn9gPjdo9NLOm8mPTzo?=
 =?us-ascii?Q?Y9IHh3B8NtTjbFKVnG1D7mLxzLjQoCVIDsssutp2jP9ePolzaz3QD9BzSjUf?=
 =?us-ascii?Q?UB9ps2j6+vKOpNjn6bE3R9N/qwXdwhr6+8OPWoUKd6RZjQ9YF6CAMFza3G+8?=
 =?us-ascii?Q?zUpB0FJ7qQI7rAooi15YQbPuxFoUOAkSdNHZ8Y0jriVPHOYSwezJOCSSKCPZ?=
 =?us-ascii?Q?IHDO1iwt3poZ9LEaCEFwlYeOe3WCJV+KvZ5FZQx/Kc09j9VlaI5kWeIsslTt?=
 =?us-ascii?Q?aImhP5GwBlvCXAvB76iX9VWHHlT9woKCaKzCO/YZ13xpp8NufE/HkkCkl5R7?=
 =?us-ascii?Q?OfBGuzdE+N6gIVgjc04xQ9O24NpTuQvLM4DW5eqPSu/Zj2E0jTYJwWJ3skM0?=
 =?us-ascii?Q?obqiq4eN5OlrrMMcOV42IP25PUQO5gXo7EASheevIIPs2+s5Nvt0BBuFs4Ry?=
 =?us-ascii?Q?XR4Wy6GhytBCD3GMe3duxClSHwa2D1LG05nQ4P+IWQ9l6j1B5WaYJbrCHr44?=
 =?us-ascii?Q?AfZFF0taXGrRoA0kPKcplrdy+QHjNLuJ4A2JNm/NkDdEwkBs84V/LNc3FYC4?=
 =?us-ascii?Q?1F/qU+1r3BdeseI8k911XSGMakMfBinBWyRR5GHNtzj6T/rxksP32K2qOTDm?=
 =?us-ascii?Q?EP92lNsRrz2J99nWUAfp12SQUF2P1ilNes0By/FChJ/N2vd6c8Xr3fjX1mcS?=
 =?us-ascii?Q?wtpY9MJUWs6YkW8BgiHgzi4b+OkkarN30ud7HlWfHuyHHIpG1KH7x3v6rXyP?=
 =?us-ascii?Q?xW6Y4Pr8l6LovZmIWyVfoVaHZiWLTg5wStNGztUd5PXn8M6InPYVZWkV9Nrw?=
 =?us-ascii?Q?Zx7DvIal24abO4zMioryhjtxnuP6CyXMGB30rpDkC6EOJTmjWrg4o/1XMr81?=
 =?us-ascii?Q?9bAKgTqaWFdaun0lCKdoHhV62hsYaGw5MpfUZPQ5u+KscHTzQrHjSHC/ZJV0?=
 =?us-ascii?Q?C9UZ+fYQ8+gd7KMf1E9hpyUM7Nrc1X0VjvqA6WK0P45Y3b50ZpTeAS4O0ed0?=
 =?us-ascii?Q?PVxMkS4uO+Yyoepsx9nkwVSyJpJY9qi+F69uvKht8xx/dqWJnLp9EOU45Qdt?=
 =?us-ascii?Q?69xWWITjh9s03mFzlRsPN5s+XOlMnuqUZOuiv56VX9JsDqHF6I5Pa8YJiQqs?=
 =?us-ascii?Q?tGKLZr3w1osDEPLf40bymg012w0g3Q4FTFhOdRmAM7xRYRXx+VxUDMzElnM2?=
 =?us-ascii?Q?a9X4qYtFo0InyjM8PyIt/mS79/IMmjLVeGW+LoiHs+7F8EaMwCYqPJpJgEBa?=
 =?us-ascii?Q?DZMFZnC+AEHXTtg2uS4dCQwGUaprrfwXraQZGMEy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525f4082-7653-4543-27b7-08db3170624f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 22:44:56.0906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDWMSVO3Pchuyi+s68+H/Zjq3D9/338fxTg6JlLjTUVrLA6Aco9zUPI274AQcjF/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7212
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 12:48:03PM +0000, Liu, Yi L wrote:
> +	/*
> +	 * If dev_id is needed, fill in the dev_id field, otherwise
> +	 * fill in group_id.
> +	 */
> +	if (fill->require_devid) {
> +		/*
> +		 * Report the devices that are opened as cdev and have
> +		 * the same iommufd with the fill->iommufd.  Otherwise,
> +		 * just fill in an IOMMUFD_INVALID_ID.
> +		 */
> +		vdev = vfio_pci_find_device_in_devset(dev_set, pdev);
> +		if (vdev && !vfio_device_cdev_opened(vdev) &&
> +		    fill->iommufd == vfio_iommufd_physical_ictx(vdev))
> +			vfio_iommufd_physical_devid(vdev, &fill->devices[fill->cur].dev_id);
> +		fill->devices[fill->cur].dev_id = IOMMUFD_INVALID_ID;

This needs an else?

I suggest to check for VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID on input
as well. I know the old kernels don't enforce this but at least we
could start enforcing it going forward so that the group path would
reject it to catch userspace bugs.

May as well fix it up to fully validate the flags

Jason
