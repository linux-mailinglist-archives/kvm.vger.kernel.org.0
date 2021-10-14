Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709BF42DD8E
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 17:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhJNPJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 11:09:18 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:39168
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234095AbhJNPIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 11:08:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qgkum8G1jVN/3nN9mhyw1AtKjUDGHz1YKoni2f8QRLZJkEJUFxGKvIu5T7JtNgruRo7dklQrqasKzeLC+DjkbevVeAEz4jhsUebeMgc20yzzYbho5kYyIfLV+Z6/7+JTouXaDCT85sv1G13JvEw4QoQxiy2E2+aMA8TEOnx+oHbDsjvmTqKEVJQWz1E2WjWBboIPr6EzkgRnf4fA8Z1IVFkan+Gz678yfL1oTHHEgU4tHYkfun0cCV1DTJMaJMnCCNK1PL499aUK7c4XMnufN7Sks/6WkfFR/6JGwMAfADc5Le3cXnH5L60sNzvHam63Q1rnotaCudHwPWrshYoUfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uN/a7ZxDYZkFOG28knwcabOWpYq1E0/j850GpRkvnkg=;
 b=MWaa8YFj0J8bHWnD7My6TvQznyBhGK/mJU4s3vKfTjtaOXTMw+7oj2JbfXCVYdfis7Hk4ceMx6vJiN1QKiz1xyo7fH5Zmmp3syikGbpa0gMLtvVzyz/5JCaSw0NTuaMPhsU9qxrN1x3Z7p8nq9DsCvVwjRz2CM3Uq2rtGbGcxaCUJlBbtNFeZP9mp2vaxRhovzqVFfSyTXNQRNqbPKtIUExqY979SJDt8e37EgEWChiOMuBAYavfxRg2S+kEP3MZSxcXaoOL+t+cBV834+cB6sT108XaflyfwfKunTY5aLniCXcQxFhPgtBXgQ/uKEf0i8bEoA6GBC7m3W1SjF06Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN/a7ZxDYZkFOG28knwcabOWpYq1E0/j850GpRkvnkg=;
 b=HP5oVp5FiMB6ycvJLb0f72bqiXJICCdMo5M2/5EHDNmSnziVYWe0WKuxItNQf0KEkZsqp4r4aArEoeqAWJCE1WPeAcuhVAC/lRTtSPkQ9LfR6Z7TJqgbxaG+dQT0seLHceJEsUcWR65bw2zSY0gzP4si9866i3QsN1W6aN6QABtIXOsRFWaxRrYkjLX1SNOEyEAzOId3ZFVcGjwm8vEe5ha4/ZsmuQ5v+bv2poxT4P0m6YQoEHtdENT7guKJt7mGTPpxl5Ymogpg/eZ3Z9H9so0/iIf4+A6jOpJmk2wBUe5/EKD8bcw1ODd6aUHnhVlJFL7CfRvgIVl/LZWi7mgkXA==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 15:06:11 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Thu, 14 Oct 2021
 15:06:11 +0000
Date:   Thu, 14 Oct 2021 12:06:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
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
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <20211014150610.GS2744544@nvidia.com>
References: <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <YVaoamAaqayk1Hja@yekko>
 <20211001122505.GL964074@nvidia.com>
 <YVfeUkW7PWQeYFJQ@yekko>
 <20211002122542.GW964074@nvidia.com>
 <YWPNoknkNW55KQM4@yekko>
 <20211011171748.GA92207@nvidia.com>
 <YWezEY+CJBRY7uLj@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWezEY+CJBRY7uLj@yekko>
X-ClientProxiedBy: BL1PR13CA0369.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0369.namprd13.prod.outlook.com (2603:10b6:208:2c0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.7 via Frontend Transport; Thu, 14 Oct 2021 15:06:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mb2J8-00Ex4Q-1G; Thu, 14 Oct 2021 12:06:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3539ff5f-53bb-45a6-2ec0-08d98f2428a8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB528603C3D8CD5C4B77DC32DCC2B89@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z+3XkRKKQUULRIVmH8pny5JyJ9CJEqxcq+sbKjIkQOeYE7x+f+Cu4wzmtpRBC489S/YA3UEE2nAFOVH9qj77cO1outBGNyThj0rRrgCxAxUZSnPnrmrrPzqUXqHkX+/RhgiImIfa4FzNF0YQAYgrBLgL3xafSAAYEbKStAlItoCwYOU3rIZENnkxfPJPP8xw2IiMGmmzaZz9Mv1nHYgO5k5eD0XS+GC8eBo8w07IVPVD8ZioAohDdUU5b2N/w3LpuCpSW7uK1jHzq3P1/r6m+/av733/CfpbJbI1+Ma7cI904be4RnECwk6BFk4VhjLPE90+Pge+cQY0YIIuTni9lnsN5QJelm6ddrGcGwqtsQJJI0ut7otBn0W5xNCJgDlQ80z6kf0OaU7d2hfcXX2YPI22ooFMOihbdNMtoGAVp4siqwcj69TS2CqYb7hPIL36IiOZEPwnkbFimyHDmDJzpoACggr6C+1O3EwJ1POl7CZ9nbxtzWEA1Ldptg+LJBZ/v5Og6+ZDPP0siJoc+c1OtS0Il5sj4JUVafDVspSEDNfsRZ8Y4m5WRY3ilwBHw9opiMfA9HVGYm8F5hAFh+uraZmFBWsAVjQjgG3aaooiEhRJr6WBCvYAmUFaVn6h7mOMSu1/icoV3UvQTRaZr5BqqAn3obRHm6RGFk+A9RgzSudZc7N7JoLopT84s8+0dVeWeDyASQ5JiH1kgEQg5oCN9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(426003)(316002)(2906002)(7416002)(5660300002)(38100700002)(8936002)(83380400001)(508600001)(2616005)(1076003)(66946007)(9786002)(6916009)(86362001)(66476007)(66556008)(186003)(36756003)(4326008)(107886003)(8676002)(33656002)(9746002)(54906003)(26005)(84603001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uI5CnTu30fEyEe3vzb0hJJ9jNsRk3TEV2Ph/P0vjFLqiNF//kNNO2/s6N2+G?=
 =?us-ascii?Q?/fIxWkzdUSlobA/V9hHGsWNgEc0hooFga2qGm4nkxaHvin6B3YWpOLltoUf6?=
 =?us-ascii?Q?3rd1vVtqTEk7+pSNP8ikdz5aUiF+nGUpgq8nVT07DozzaNfmZy/lZG7Ss/1H?=
 =?us-ascii?Q?5Y2FJa8Vl/ryJUYaaiZvSH5/u+moYvRiiPxGnP1PxTfr2gkcRtPy893QZ9FI?=
 =?us-ascii?Q?DaSXk0vDeUBv1TC/5icjA10tU56wLyAbQhR2/oVocnlByLderSJjsd8GkscK?=
 =?us-ascii?Q?yAJGm4ekazG23U6iIJ5WIQmcE4Iji9p+8dfYDam40UKXveVUa6ctuXj5kLgp?=
 =?us-ascii?Q?QT+OpaUmksDxjPwZoj9iBWotLjXuv7yp7UT0D3TDicJ579SF5iLzJAac5feZ?=
 =?us-ascii?Q?GhJq00dimVoTjmXlKLM0H5VHQXJqswJaVWkUZtcvfoQK7FnSLEgJHQ4KZZkJ?=
 =?us-ascii?Q?auHI4p+kWu0PWOOQgvaHkiuieTsYFkG5U+rQ3knvHvrd7yrNkLJIYi0Cd/pO?=
 =?us-ascii?Q?huoJ50zZfn+MFdnncz+neNMkukcS4XZyxowYxq+qKLjep0YOi+QhaLoT/CoY?=
 =?us-ascii?Q?YsvzOSVbrkDW5k/4+/rkwdkFOHvd/3jfWGgo/DuTYH8iyD/RINr0YUQ21G5+?=
 =?us-ascii?Q?Bp2dmG3TgUxGttHougSGzipG4NDmF+Qnja8tSsM+JwttqyqSHknBCb9F4olz?=
 =?us-ascii?Q?mI9nyshVDNdfoLgr0hFIvwHluplT9MryJXm8O3UqiEflRg/giCvVwNt9a+f7?=
 =?us-ascii?Q?zWko7fP73TERrtzZ27s4KRxddzNW9JaEUW6A9PKEHIBWv1RSjgJfQSmJ8rDF?=
 =?us-ascii?Q?0MqPxmgUQR0PPbEQVVUnzIoWjcmE+3quGqp7LtaB1UUtZFlctgyqXWZpCBnu?=
 =?us-ascii?Q?5u0G2d2vsEq/tznTaJ81TZS1bXiZlZZqVA+j4BdczX0X6aSF4qJV6+ButTZR?=
 =?us-ascii?Q?/CxOlx7APWj98GK9NUORVQj9yJZl26bj9p+ylDyWcetngZx+ejwlLiKW7dk3?=
 =?us-ascii?Q?AGth2b+j6J9T7LdB0bGDO2KexPDNoCxPCHsJ4mrNOtq5QhbzVyf5+zfboH0K?=
 =?us-ascii?Q?Vab7zY5BgvMa9N/hdomabOZ9VUcEi/mF2bsiCDnsLtvhR+TbRqNh6VBPbQx2?=
 =?us-ascii?Q?/Z50XSL/UAkAJbSZbRJWYE63hlbWjVRzi0+bsxMAeIYFvcyJfgDzA6Y5JAHp?=
 =?us-ascii?Q?DmU3c0DVM5T+yprujizivKAKIrBBOoR26V2MeyhxFfvf6b7clnlgPphX8l3e?=
 =?us-ascii?Q?Dj77+uhs+PNiJnI0lphIYPsbs8oJt/yZERhE7PLpcWhSY2K+/9HVn9DlD2yZ?=
 =?us-ascii?Q?erjp/9XkuR6i1sRugs6miC+co6SI/IoRJGUMAms0uSa9Og=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3539ff5f-53bb-45a6-2ec0-08d98f2428a8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 15:06:11.4924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myak+zlqHBr6n9wGoRDwjTW/dvsAxDuJpIffRF+sVhBv1hzUWyIIID0G2rR2Dibh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14, 2021 at 03:33:21PM +1100, david@gibson.dropbear.id.au wrote:

> > If the HW can attach multiple non-overlapping IOAS's to the same
> > device then the HW is routing to the correct IOAS by using the address
> > bits. This is not much different from the prior discussion we had
> > where we were thinking of the PASID as an 80 bit address
> 
> Ah... that might be a workable approach.  And it even helps me get my
> head around multiple attachment which I was struggling with before.
> 
> So, the rule would be that you can attach multiple IOASes to a device,
> as long as none of them overlap.  The non-overlapping could be because
> each IOAS covers a disjoint address range, or it could be because
> there's some attached information - such as a PASID - to disambiguate.

Right exactly - it is very parallel to PASID

And obviously HW support is required to have multiple page table
pointers per RID - which sounds like PPC does (high/low pointer?)
 
> What remains a question is where the disambiguating information comes
> from in each case: does it come from properties of the IOAS,
> propertues of the device, or from extra parameters supplied at attach
> time.  IIUC, the current draft suggests it always comes at attach time
> for the PASID information.  Obviously the more consistency we can have
> here the better.

From a generic view point I'd say all are fair game. It is up to the
IOMMU driver to take the requested set of IOAS's, the "at attachment"
information (like PASID) and decide what to do, or fail.

> I can also see an additional problem in implementation, once we start
> looking at hot-adding devices to existing address spaces.  

I won't pretend to guess how to implement this :) Just from a modeling
perspective is something that works logically. If the kernel
implementation is too hard then PPC should do one of the other ideas.

Personally I'd probably try for a nice multi-domain attachment model
like PASID and not try to create/destroy domains.

As I said in my last email I think it is up to each IOMMU HW driver to
make these decisions, the iommufd framework just provides a
standardized API toward the attaching driver that the IOMMU HW must
fit into.

Jason
