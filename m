Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2D747D619
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 18:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344459AbhLVRwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 12:52:13 -0500
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:18688
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344462AbhLVRwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 12:52:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VP+NLdzx3RGsdxwM6VuX2bMd4c2xEX+yXoIAA1QBY4B2ZAr1YVWklcnqBuYkTEODcXfGjKYAX6uBrsRcTOclZkVL9awotyNOyYT6ouvM1TcfZ7S1DLUxctvvv99gLbYvWzaM7/PXgwu+IIEzvMDg7WTEOsFY4fBuajsbZyJvIDVSix6tYKLrW2dhnO6Pj9tP3jLBm0nmLs3QxZNCIPCHyfBHeDo4SraRKLjRpjmWv4A2fsKNMjG9nvDbgSGOzyZ/biDXnLGzBdMf4kD8FSZsFGo2QnruPehPo7dQ9YMAT3mJBFGGDv4+lTmIeZ0RBq4G5owo0SJ9jZnrOimIucd44Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZhpsDmmXVHBis31nXjeXXEsp6+x6ZM/nkS2KwjvaDc=;
 b=nl27CSjdLACFnMz3UktqHKUarRmHccOVlpPgcOG0wBxTDFrd55VNwSqMYJ3jOPWCIakO5ukAxq4+LkyEKqzxJsb4NjYS4uQhXbwiDxUmMAV31WZwF2AEtRbGc5klYxzZE7WC/zycYLWv///Oa5EqyqkVEOvw52XEnKT2zW3tJ9nm/1alB9EH34LStxSirrfj8FTMCzdSZ1SSHwEQsmEq6KZzYWRGtJNK8dZZ5vnf/E2e4AoawiwMKvvJFttB95tLOKZE+vNcAe+8D+fepDrht8GxcTmj0fUP8MHYEy736t4bropQxmUEYk15fkHzeITx+DcwU/U/S7o72BngAWYjrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZhpsDmmXVHBis31nXjeXXEsp6+x6ZM/nkS2KwjvaDc=;
 b=FQB6XEL3h6H8BNCM4TcceSo+AGHuBMTBJkobjkYvSXZLj9yW1lqqfKQy5VgNB6o/UA4nUDuplBIEthSxj14c8CnyWq75xwfPyyvcSwDipqrRNGSexXKiy8OOCnPTXwVsyU//OdEViMetiLQtTwbHbdvCoE8sCPw3MqqijlyjLugttVJtYPvUWxT/4m1whVPz5bsS7w1QDT5gnefIDtAgbNxBnvPoWeoIoqXv4o6ndRfk2J57I6rHfLp5kOUTxCo5Ow5nJ0MldokWyzON+hE5pqP/kula5ad3Zf/DZmZ6H1vj4XbVVOgCKYlm29jX9EJSfnVe/YgwPA7rIFKQxdhe/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5224.namprd12.prod.outlook.com (2603:10b6:208:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 22 Dec
 2021 17:52:07 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4823.019; Wed, 22 Dec 2021
 17:52:07 +0000
Date:   Wed, 22 Dec 2021 13:52:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
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
Subject: Re: [PATCH v4 02/13] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <20211222175205.GL1432915@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-3-baolu.lu@linux.intel.com>
 <YcMeZlN3798noycN@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcMeZlN3798noycN@kroah.com>
X-ClientProxiedBy: MN2PR08CA0025.namprd08.prod.outlook.com
 (2603:10b6:208:239::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af56339f-7652-4542-8538-08d9c573c512
X-MS-TrafficTypeDiagnostic: BL1PR12MB5224:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB52240322F78DAC41C5EEB809C27D9@BL1PR12MB5224.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W1oSqoLAl4e78Skj2iYDTmvhGjr5XBUQwrwEPrgWfWu44tIIneYnPbj4At5G4ds963hNFnickVAlnoC3HuBN70kvcWibxOK9uGsJixTRZYwA7KcwU9qRaq9iI78GqnsGFu+KuhuK5yc7sdi1VVGMQdWfDLzwQ2A1mizdiS/7D1haZjFCzskt+vpK+bCiezm4bQiIuXC3mkXUMMdTnKSMQbAAqtt0PMbngZG2Nn7sdyjltIBON1mf1QlTjiJ086CxKycdRyLXujFes+zRziWg+g0zxEhrp5MPwU+fL78esHb3YGGNysCnnhZ2OFV8L/yzLZBd3Hn89qcEn2BGYNEDedhVdIW4kMvRvtNdqc8/uQwpPDD9ZOobyoYvVDAdeqMsTBJD12A7JmM1g/pr1QiDM+iFMch5lUVEkOhwD0WTj0hXfU2xiOwKzGu1tnODn2hkiTu55cp4+tQa7Vzu+AewxIUfpiL06LbUkg0a1TnMGB6uPVdUIXZzgXAdkBpEB9bAl7LrYkx2W3d4BH2fo3HkN/Ng1VOmuCvXT0lvDEhU0JTC7OKx6LyIkeReHh3U0pKyPSivQ862gvSIBZBvh7DejWs5vdcHhOqhhXa8zSm5mZ6fTdYJ4KDEiqH+toYM4iXI9c4NUbaYKwUVLswP6Obh60kwGg5vjfy1MWJePen1YwkHvWIQTj7RAod9toKdY1jA8WQXv60bTdrwV3ccD8FjhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(8676002)(66556008)(36756003)(316002)(33656002)(8936002)(6486002)(38100700002)(5660300002)(508600001)(186003)(54906003)(6506007)(6916009)(66476007)(6512007)(1076003)(26005)(66946007)(7416002)(2906002)(2616005)(86362001)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LNUD/IgNmlKnrRo+pbsrJkjafl0UVOTlgto7/Njz8Al+ivNtDElw/moGbmhT?=
 =?us-ascii?Q?mH4P9wQykdwwB5v/JtZ7A2MjNdsezfGYOwnOHkEy++Jqmt7hmKysfoApgwuj?=
 =?us-ascii?Q?fV3qX4ZZLn3nqQIEHQiVwT2ErreTxZVDZgSnu5HoGq/D2S6mjKBJVqfKv2Ao?=
 =?us-ascii?Q?uw/eaL1CK8u/igrUo2hwO5WO1FzCEt2OxOTGXysmewIgGjOjTNDIP3d15ZhJ?=
 =?us-ascii?Q?sdzMggaLHkVdpIh0O2X7RiA5uq+m8d2ML2tj1kO+aLxTIbZPMAfriyKI/w/w?=
 =?us-ascii?Q?v7iUYH067m25Xs0ksU8m0r1EIKKuVfbYVwIzIV7WpnyNH4GOQGeuWdT6txeq?=
 =?us-ascii?Q?rwZukXBYXzASjBZcTjKrBiORTlnZf/j20fotFzHT/lWaoJlQJ9mkY1MaU1Ap?=
 =?us-ascii?Q?BoMiP7YCquD3DptVVHrl1+Q/FARJuswBQ8ZQg/2DkIIB0G8eCtgLPEqDbR0a?=
 =?us-ascii?Q?m9x9JwX9iVuXCPKVmSSNB9iybi6bo49eROjMmc0mt/n3Eexw3EVn/RyDMZHx?=
 =?us-ascii?Q?L2xOvot+092gTiePWRF6WJdolhi3sP6ar7TQ/xiDvTfUQjHqtfQpPU20+xZs?=
 =?us-ascii?Q?ggVbfYpTtLqj81LtNWrq+HNbDsdMELhMRBhX73qfWwWJG9ROLh0NnsM1fggA?=
 =?us-ascii?Q?PhcNKbg2cY/Dmsdpz3khcLBiyDNEHdwCIu+ov8dy1p3peNBLxPjqyIIf+vkY?=
 =?us-ascii?Q?/mkaHqr6ohAJyguhVNNZDKDxailvrhFFwSSfwIlF50UgW7Wrh5eAemcjhA6M?=
 =?us-ascii?Q?oAcXntPuaFL5RS8kj0K8lYaRGHfe83yaC+US2FeIf63RLT7RWk1fs88SeQFP?=
 =?us-ascii?Q?b8vt4CRr3ukCYhnjcx4zM0CD1bqMFW65ZzS0uMvNOi6WS4G0HwJUi5oIig6f?=
 =?us-ascii?Q?5rZ3QyBJvEnwesGpCAPJgAm5GxNSmIOtRM9J/akrWqrM9AE8X1s0vdLblEU2?=
 =?us-ascii?Q?D1+yWAbDKkU6pQ8M/svlBiKI+yUae92DpD17Aa/uSY40YcFSx+RUvdRqDOSZ?=
 =?us-ascii?Q?CKpaoi/yhW5NwR1CTyap6B1j1/AFwwCbtCR5owJsA6I7X7XZeeadfR1PI9GZ?=
 =?us-ascii?Q?PawKzlt2PAu5OMaCAPQr8Yex8blnCW8MfPmgTOZG4zUgC2dHa66Ew8IF1aoc?=
 =?us-ascii?Q?4sHgFxWeainN58T/4+pBQA1ZCoqBn4Up/C59QGeAfUF3k+n/WSpL+5XzPra8?=
 =?us-ascii?Q?EhGbKnzwF22Dn7Dv16HLRv9TRomKEGJOrS0o7KloDz0yeakIkntmfhVtfRlG?=
 =?us-ascii?Q?2R+msV/59tl2/68u0QCumOT7q0/dpTjSEJrxK1qKHsrvgWw6vPZzaKfj5vr/?=
 =?us-ascii?Q?2zaJ5ZOVc012N8wK8qIiJTd0phndFfCGsJvsNGDTFVyMzj3zyJcmI8uKYj/Z?=
 =?us-ascii?Q?nWPmv/ykSFqqfOeQTrcVMpFyG8Kf5iuAMnaEFzjfsaFnjIzhWWVm/Jda+3rO?=
 =?us-ascii?Q?6Q45/8tlVLtjOdzyNw/ixM6BkAaghx/2YHVy3qTIBJd/wwu1FI+MQ1eD8TqT?=
 =?us-ascii?Q?ViV4JI30Q4iFlbrAFxkp7N/l1Lqkn85QSUuNqK4mX6q/XVpJO/Zw17oQqtfd?=
 =?us-ascii?Q?M5e6O2PhJc7XVRDEq30=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af56339f-7652-4542-8538-08d9c573c512
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 17:52:06.9746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0jr7NMtj5q5slxr7okhtLMqU+3/UoPzj2iumZqCV89O5M9vqo1GqZ0pZWcQf/6r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5224
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 22, 2021 at 01:47:34PM +0100, Greg Kroah-Hartman wrote:

> Right now we only have 4 different "busses" that care about this.  Out
> of the following callbacks:
> 	fsl_mc_dma_configure
> 	host1x_dma_configure
> 	pci_dma_configure
> 	platform_dma_configure
> 
> Which one will actually care about the iommu_device_set_dma_owner()
> call?  All of them?  None of them?  Some of them?

You asked this already, and it was answered - all but host1x require
it, and it is harmless for host1x to do it.

> Again, why can't this just happen in the (very few) bus callbacks that
> care about this?  

Because it is not 'very few', it is all but one. This is why HCH and I
both prefer this arrangement.

Especially since host1x is pretty odd. I wasn't able to find where a
host1x driver is doing DMA using the host1x device.. The places I
looked at already doing DMA used a platform device. So I'm not sure
what its host1x_dma_configure is for, or why host1x calls
of_dma_configure() twice..

> In following patches in this series, you turn off this
> for the pci_dma_configure users, so what is left?  

??? Where do you see this?

> I know others told you to put this in the driver core, but I fail to see
> how adding this call to the 3 busses that care about it is a lot more
> work than this driver core functionality that we all will have to
> maintain for forever?

It is 4, you forgot AMBA's re-use of platform_dma_configure.

Why are you asking to duplicate code that has no reason to be
different based on bus type? That seems like bad practice.

No matter where we put this we have to maintain it "forever" not sure
what you are trying to say.

Jason
