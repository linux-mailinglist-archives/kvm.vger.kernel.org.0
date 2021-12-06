Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B394695D5
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 13:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243251AbhLFMoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 07:44:07 -0500
Received: from mail-mw2nam12on2050.outbound.protection.outlook.com ([40.107.244.50]:31617
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242186AbhLFMoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 07:44:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3PllvZyaRoTKh4Lk7xbtJhHgMdDM2MPWBbNySP+ushBlEqWw96wykPHHOlTnRkn24pbowf04+jMm6DzjK7AkM8h3/Ed0Gvt74n0GQA33bmdM+u/lsme3QLGN1RTdgPu8Ia/DePXXrOYeAPC5/RdoRRgVvfYsF/OFxokvB41b97p8vZgGFGqF26iTJoZUVlKqRG+zzIX9xi5iXOzXqi0rsm4NZ/BYcCoksBD3+VhNHZF+E40JG7CdioaUvZnEtX8SfQuinyJl8gi828W1xV5yP/NrgohEGVyNP3ncSHGiiAs7vAWVlJM4krTEiJrLJYEXuPRvwjoYo3MLUoMgfU4gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xU7WBA+hRQB+iaFVgUAfHs0scPiN1XnKEo8uMk4PcA=;
 b=k8V4W9I2q6xOIT4DqryZrkOtwnZ3tUiagclo6x1gY7hszgvEYOxt2EOZMNQiNXwdiy99ruqGxbavmEVmDrRBHfFX4wnjXKaXESAiT/hyY2q52ztJi7zMWoLT/9D6N/7OXCTnzLWam8h4hxYbE8TYDvvAUFxd3BcDTZeQZfYQm2VYNHVUW+EQWYM8w+jN753jzM083GYQfx+l0bYssrsyNFRl0EYu1/7jRZxo0d7B2YFdnS+RgWLpf63HqaLSg9Lk5p4dSMmDFAsPPQHeXA+hbBbYYtbE5jWU4bRG7HnSyR2PeLDhlQ+GxRopCgV9/RZAhOKiIcUQCQ4HnEfDutkmrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xU7WBA+hRQB+iaFVgUAfHs0scPiN1XnKEo8uMk4PcA=;
 b=j2NPRlVpwioi1Ur4Q+q1AzvHaoaelVJiYfQenwwXtW132Iy2EPc9zf81qr9Y4DnLDq4DusnZYWaQAH9QxSDa+JeegAw9gwUcTstpXFOzRFvP6m8xVolOOd6NumODEprBJhPyC/8lrYTz37U+ZgdW9PQjmMiHLK6z1h2Pne9o0CSfT8sRX6wabGty57XCfFWkUWDPfvV1gzgjEELug6HbFhZ7Akcxj08rq9SZ1IdXVMgDvVgagpueh/JWTzsn5+uXMvD3PKUXm8dKvCLgTH2XaVT6Ojb7562mUwutC/EmY/IdMQPqViokMLZ6h9wMYrn/LvKNUpSrdTGy3+MISgsvCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5253.namprd12.prod.outlook.com (2603:10b6:208:30b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Mon, 6 Dec
 2021 12:40:35 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 12:40:35 +0000
Date:   Mon, 6 Dec 2021 08:40:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 18/18] drm/tegra: Use the iommu dma_owner mechanism
Message-ID: <20211206124033.GY4670@nvidia.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-19-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206015903.88687-19-baolu.lu@linux.intel.com>
X-ClientProxiedBy: MN2PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:208:c0::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0012.namprd05.prod.outlook.com (2603:10b6:208:c0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 6 Dec 2021 12:40:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1muDIH-008uVp-Po; Mon, 06 Dec 2021 08:40:33 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b83efe14-9e30-4d8e-3948-08d9b8b59952
X-MS-TrafficTypeDiagnostic: BL1PR12MB5253:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5253B1B18B640EF8383AB392C26D9@BL1PR12MB5253.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C2Dc1CruVMQ3S+sakxr5j0K3G1GBbXGmSCgOBUUd/PZ3zDQpBe9D9zsxRvptu7kR8pv88qsIMCuBUJ0SJR1GaoGkOFxi7PXJCpdCduKp36cMUgT7b4rn29wbiroM4pfxaXZjc36IKCSoHNjzoJlsWk9OBrzu9MfL2mB8GMuAqtpeFV3g7hFk3Rgi3vBeuB4f3lRKYAoY2jnIAGyIUSavx5x/lPAmqZp1HtHkcytHVpveyvxnDl15zjTaAzuToODOzgmjXIqjd13xcA/cr8gGFu1n0kDCCwY6Q2+UtN6kuTeqJguWWixBbnCYULHd8ymqZzTOqzkq4QKNfmjd3T2d5RKJ1AmRgbCe72z84FSv2M4g5xCRzVtK9hyMKVJlUR7WIBtznJMw1JVS1l6590K51eGEVlYHEfntUeLPlDJdO8by5bhWW4VwOhACpe5Y4rbWvvQ3FX5wRCg14GKgRhE0BRj4hjMjKKorEqQO3Mvk9XclBpEzbBWybkb64Xzdc3CG1SYWT4afDP9xPgfh+0vyyOQpT53kueCfAWVtAG7LCmB7LFvyRK5bMCvOiTYecppunpz0UJPpRU6CTYxHYGNNCdyzZSGe0DGzLUcGT95u7q+wVyBHKpnInprU1YiNMo8jMVmNuWst1fk3yYW0ya/Qzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66946007)(9746002)(9786002)(4744005)(1076003)(66556008)(8676002)(426003)(7416002)(2616005)(2906002)(6916009)(86362001)(36756003)(4326008)(316002)(54906003)(26005)(186003)(33656002)(5660300002)(508600001)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xtf88+u64J9uwBCLMNyLPICnPyQZz2MYd9YGlP2LClP8vVabAyCDKWwryLES?=
 =?us-ascii?Q?Zar3FDT+OmbmUuckTZl96JskFKaSkeNuELVsY6qf/e1nx/CefQ4ipdapd9t5?=
 =?us-ascii?Q?x0h+zaWyyVSqi8wrMS20oY//XsyR+H9LZ6z5eDmLt0uz5e3C9xCQ4VhBExm2?=
 =?us-ascii?Q?fMRVLxiP2IUHnOilfp1zaACGTp5mgdw9LTCczl9Y9DuYPpkQ20XS7ktPbb49?=
 =?us-ascii?Q?IWJpFe/cRIl2P/x3yj9OJqG52uNJPvPqZ/I2vvqs+s+bWRYgdZd6RCB5NVOz?=
 =?us-ascii?Q?PCPQROa5He4hlNk0SvcsmYDygs9jYkJTgXmObI0xtvv85PBs8CD0cIasQI2q?=
 =?us-ascii?Q?SlRuBABWijenvrGMgTIhW51P5Jw7M1N5jkSWvTj4qxS7vdAx0eRT2M5ua+Vi?=
 =?us-ascii?Q?q0vnugpWOdOQrOpmsG8rMeDRpqhb9ESv0hrrMYPqmXIs+nC+uz113RmeExmW?=
 =?us-ascii?Q?irwE0hDEDscvyRonOFUrbrixmdXrCWnEDBPO5fMVFJv+amCeY8i8+2Wmut07?=
 =?us-ascii?Q?aVQ749U3jyyVNjA2UfcQNKGat5xfpIUpx7j100yZHcq6AWlfpjO0TPmI/dED?=
 =?us-ascii?Q?jufF2QISWijQuS2Ksj59viVG1ZuhXwP4r92TXKrcVvqou2hOFcBEmVuWvxq0?=
 =?us-ascii?Q?WAZBsfBuDhBgguMHOMfkLyPdNJ0+22RTPiwE3o14E9rHCq30Dbm65H9eqekv?=
 =?us-ascii?Q?f2e0x2Q9Wt3ekUiD0V9i1+WY/TAxVJv8vl1vvuuQ74mcXi9cHrE6BbPCeGl9?=
 =?us-ascii?Q?+BR6ASuJE4vJRCCCo0QwqsvUTc0rwqmcIZtx1YPIW+OZwRwU5gIuklpSoC14?=
 =?us-ascii?Q?7NB/nb8M7grf5k5Xv3sm3ddWJkqkV3JIDUlav+/rI2UUmKkfp/JsHutaBTV2?=
 =?us-ascii?Q?UTRJFp19lVzHzbk8y9/HQRgJ7daoPfnasM9Y+TqavaXuCqlifYPwAJphH5mI?=
 =?us-ascii?Q?8pmiZdWqDutwFZZDROrG51hCP6kCIaZUgcYSjlbBOfbh9Z0suzVIkqTK08eN?=
 =?us-ascii?Q?Vg3mLr+jd256qLRjFHqNI1WK6wobqLbnyu0IJ6+/rjUrn/8697tvvAsvHLf9?=
 =?us-ascii?Q?ntHqA/0krbztHbJQ5jK+9iliFSw3EC2YJ+sdM8MHSLtvN638cOruova7HE0o?=
 =?us-ascii?Q?rMicjoPqyk1n84rdXHpK96DOKI7mXDSCjNqRVk9C3SoZDZspsZ1QScYRQbo1?=
 =?us-ascii?Q?jUw5Gb009K7fcefHFevlhSSpSK7oSV1ZTrPVT14W+h8z/veA7C+UNJ6nC3QP?=
 =?us-ascii?Q?8Xn21GsunGEMHRYdMwHK6jJdnDVtulRnSQlF7qoXkpkNPm9olfbbzO05JVba?=
 =?us-ascii?Q?8ADvvy8BCezxcggRFQX0dhhCZQ1ohj1K5hed4l2ZX3bvTxxczAjKUOf4wuX2?=
 =?us-ascii?Q?w9aQO3Cm+lcBA7dZkxSqGDZXcZNiI36bQ2KfHERazJ4T0eHH4ISRNhWOrD/r?=
 =?us-ascii?Q?QFIS9KPNTGy9utBqnbJYD6OGsAX1eSAc3Oty1piA+CZRcAFUW1IHa0FVklS+?=
 =?us-ascii?Q?FZrceF4fjUcyip/Oyfs7pCqxvmzZOet7xtVC8asOqdUeQPfdTrDO8uDbtBqJ?=
 =?us-ascii?Q?aT3F/P1XJRso5/bevsA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b83efe14-9e30-4d8e-3948-08d9b8b59952
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 12:40:35.4747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQdfiAiojas7K0sEEZLFVaH4niwMHP4PeU4P1I2Ds2nkjnmkWx+JDEPJdiuKfULC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5253
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 09:59:03AM +0800, Lu Baolu wrote:

> @@ -941,48 +944,44 @@ int host1x_client_iommu_attach(struct host1x_client *client)
>  	 * not the shared IOMMU domain, don't try to attach it to a different
>  	 * domain. This allows using the IOMMU-backed DMA API.
>  	 */
> -	if (domain && domain != tegra->domain)
> +	client->group = NULL;
> +	if (!client->dev->iommu_group || (domain && domain != tegra->domain))
> +		return iommu_device_set_dma_owner(client->dev,
> +						  DMA_OWNER_DMA_API, NULL);
> +
> +	if (!tegra->domain)
>  		return 0;

This if should be removed completely now

Jason
