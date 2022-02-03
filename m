Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26B84A8780
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 16:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244351AbiBCPTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 10:19:02 -0500
Received: from mail-dm3nam07on2048.outbound.protection.outlook.com ([40.107.95.48]:42145
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229948AbiBCPTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 10:19:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jU1ok3rrkj0dZiKfu1sdUMxDX4mCf79nWEbWBLwLP/EQCIFFCPNw7hdsJ1UNQHECNLJf4f0vJoe1TpdkPVlaEsCgu4ZHkrPE672F73bvRCb2JuOOyETUM/ciKuQd88OJIaf79LcHvshMct9zm+ZZQE3pQQBOyEOaQA6VML94920hLxEZ8AxYJrvENrcEckKAVNZkUMxbcCjkhZyRcpYOVLi3z5YDBEHvzdyG2RAAqfFmxbew+BsOLB5SHxEJI0BetsR7DQqq1qazPDMHkmDjnYkXD4jMN5Zb7eg3u0pAvBBAzLRadD/ub0iWjDcFbPZC4GCSN4sR7Bnpj8q3S6Axog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgAsSjIwspMZED4RYTuf0ezFT67Ds9QryDNIUdT+X0o=;
 b=DZOOXqo4S3uZV3pGBD1bsh+8opT1De+XM+ZatmEv1gwHR+KZju6j4wqcUpq8YdQlwDEgm6+s/NQtiXQMV489zHKnvs6qccHEWljZO4yl8/LBX52n2kJlOpK98hqORN1Eqz/5g6+ydqRWr8MyQx9EdjhBhjko9fyk+CGQ/smibGSfeNjqKYVV4Bfym+JWMz88w430iIyDshUJgO00Np817/Hf4NdWGorXw7CxvmCeq5XfahUTU0r9i85rw2egfyjTE9R6gYF4Su5poy/uF3Vh/ZSZdbPlctCpSyiL6Wx14oAHubxczlqPLSXMRhqtwCJyN6NQsHaAiQIhznlwZZ9/pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgAsSjIwspMZED4RYTuf0ezFT67Ds9QryDNIUdT+X0o=;
 b=Xfs1Z4tXx8GIpBp8nM/TDJNxoatWf0uzlrbd5PNkJyfnzoF70ms2wZph0JkhpqTGjNOycDpJTQhGQBxyrtiOuzBqgtSJ1ThbxW/bjdgDCmI6EWuajFJGjHhwZFsF1TuRNBP4A0aGD0wbiMPXqnVfxAmd/Ojai+DygDmapenNED7jyZda/+ktSTvgxWaXg1KcMP1zjA33TQLMAaYlp/YdgCNScyxOGcXiqgperQfYHlvEuOM7GXTF9jLfRupNtVtnQRrAMoGGTa7yy9axp/Dnv1LFAMnWbXAVWBs2YnbyUKAgdcPCLr/FKChkSimqyHVNh8OoR/7vR9RLN+k6wLe/sg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB3889.namprd12.prod.outlook.com (2603:10b6:a03:1ad::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Thu, 3 Feb
 2022 15:18:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 15:18:57 +0000
Date:   Thu, 3 Feb 2022 11:18:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220203151856.GD1786498@nvidia.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
 <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
X-ClientProxiedBy: BL1PR13CA0184.namprd13.prod.outlook.com
 (2603:10b6:208:2be::9) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 720799e3-bca2-4352-e44c-08d9e7287f73
X-MS-TrafficTypeDiagnostic: BY5PR12MB3889:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB388962997A42764114DC16EFC2289@BY5PR12MB3889.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BjRwLx4cAWy5sKb37qbI/kiHmGlImZZANVmbFcdc/zkJJ2qccQFE13TNVpplA1AVJwonuonY2IPI0/2JAcSF4oqzros475Lncc6SGZ7iCJiMoaBrb2LJy16KB3e+jIwYIWUfjM5jlmQzGViCWOyE3zh25FnL0e8Z10t0+8dfgh28Gum6q8C/U5durY3OjE5pBRfh13B5gIrUSo5KtgLA9+BLra7n0jGY477khmtS7HQ48FNUtYqaxw3/dV2gSso7jy+h/k/noEg7LyUYq3ksI56fec+G+TdMqPXf70EzH63dpH/1TUrArXQJgjJ06Dr4T95zUAQ5NgH3/nTFQRnE9HVjNvash0NKR+KDgvjxtxbVcay6+uPie09DDdqvLfVusYogx6GojYATH422yCXk39nyi4OgkesAg9A1VEMOkh6RLg/cwHPXhfbJ2wiybaaaKlN1odPEK+hiX8boSZkbx87x1KEPzWAkHc1C1o+kiqghMkeUnFE7xYJdqXWJp2Afp7bAeimbZ+Ifw74OyDPbz5nSreudDiuZC31zXjwkPJCWi5vKSFwXiWwWKktnT1yg2O6lX8WEC+6WvV3l07RxQNlInoexK7NiynQKle0e/f+/y3iN4DVlSWlLu3OoxLNkdaXb3HP46Qa2d89qVIFZlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(316002)(26005)(6916009)(2616005)(186003)(7416002)(508600001)(2906002)(6486002)(1076003)(5660300002)(4326008)(66946007)(86362001)(8676002)(6506007)(6512007)(8936002)(66476007)(53546011)(33656002)(36756003)(38100700002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4lTvf9C4T8MMmu57PB2aK9c9zDkwUxMiHL3z73v9cPssd2mwBurYshj7Mv8G?=
 =?us-ascii?Q?VGR1y+d4Wjm2MA/XA1lPN7Zi3omeeeN0nOXFHqbEfBK8rwZhmA5ZhZL6V9Tc?=
 =?us-ascii?Q?wFS4fUD7FPe0pAjHJCz94yWnWU3iQDugVem0zf7V2VOHaAVA2DP///0W79eD?=
 =?us-ascii?Q?BxhI9RiWWzgEYm1XlNvV3jUKTIdHx0iE5bFT0iPbvSSuaicbbbm4XZEyBumX?=
 =?us-ascii?Q?cmwK5KNNPeJ9rhr6XdmSHUbdfGOpaxilWpMyCwMgjlK+mbsk1gT87XklCO24?=
 =?us-ascii?Q?KulWLuaLbnmYh7yQ+so4ih1oZWmxMhNP00sHE1lawgMe+zuFKhZvaNjFNRHG?=
 =?us-ascii?Q?tQECVVfM9gIOXECIRYaoSkEO3LKLmLvmKJOFw1cZYajOdMDbUlWmoSMY9QMy?=
 =?us-ascii?Q?gUkxK0GY7JHi+Bu76/Uc56CPuefLrtNNKv9WcHQlUFGt1PQWuGFbTvgDb5YF?=
 =?us-ascii?Q?Bd5IpkHBREO34t+cLu3eI1QqwgpnMnjYQSmYzmaE2VZ4eVrnFE8m1CZx7qr4?=
 =?us-ascii?Q?+mMzv3agANpz8Zlo6r2XGIKC4/MH9cSZV895r51aPPN/du9MjqWioFQ9VKoJ?=
 =?us-ascii?Q?vOfb+XxD2bM5DJRzxRPIbrQ0K/pDrtJRgF++jciLDCRFC5+EcSFd/uaFWohG?=
 =?us-ascii?Q?iYTjVNcGMhrftmNA3UDSfeGy+BWLWfqvYgb4REcno96RyxDGjp+t4CEWRgF4?=
 =?us-ascii?Q?EwYik5C9E5lWnWt0y0QBJdtzwoQDfFmYMeCaYJHZfzk0HZY+zR8MdG0UoCEz?=
 =?us-ascii?Q?MPGurklLRYDCdv4wy9iQEt2F+RooaoWErvrDNcJG8XpPdc2hu9aS47/8PGZk?=
 =?us-ascii?Q?+Y46jkh8TuPp60yW0I5wwGqPTIR4p6S5pi/7C/MsPmPRwuz0+9GT3w4rhGk1?=
 =?us-ascii?Q?Ov0fKRJu7AklN2zO3fNhWZ0JET0RzbTNttevjCafFtP9Jw+lfyZ9HVSEMP5d?=
 =?us-ascii?Q?WtEjiAnAzP6hFp0bxrOM3CPB+volbl1ebHkE/iIHjzVHhI+W/r9BoSEwmVnB?=
 =?us-ascii?Q?rY/DDsYljAT84jp4OnghFC+cAr7Ul3fsNbzsbXKHUGloCGn8+08oR4/V38SO?=
 =?us-ascii?Q?Gk0v8Z6z8MYGEesxZt9oMJjU/Bk9U6QZwfATTH6HtaNKh0dI1WELAZjdrbZc?=
 =?us-ascii?Q?y96Dft6X7LZj7x6Ot73ovwv+BeV/9W4usEjFnQqSqT70Dfk9CSzMcJl9NFfr?=
 =?us-ascii?Q?ayVK3nAs+XW9CRVJpRF/k+1pZILgObCjnx6bUyprtgWr362REDrNDuKdGukI?=
 =?us-ascii?Q?zT4fwL76XcXO++WizBomvIny/jrOtA3+HA/0VUalcHtAKKpbb/TCUXCkhuA5?=
 =?us-ascii?Q?1P+wXvnPk1+4FzzJ2UHlXvkt+Tc6sqDZSzBZRY0CKStoVYhKUn0tnjMhMiOQ?=
 =?us-ascii?Q?4itIsGlfmLAy/hCLoZ00K5lhZfHlxCgjFlCDqlA12iQQcLGTOVY73FPClBE6?=
 =?us-ascii?Q?s2L7QJsH1TmWkxNU303jtWVVBzV93GHw1EnNF3KQcUQ7ba3786jY/fV3+tFM?=
 =?us-ascii?Q?geGTm/NUgph9IfddLipKLbv1/pyIndlPjwcAi+mPSyYWReHJeWeqlkHRJXde?=
 =?us-ascii?Q?F9jj2KVm9TPpDBh3SSk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 720799e3-bca2-4352-e44c-08d9e7287f73
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 15:18:57.5926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IaGYu/QZuUqtyvbpnD4W5wfbM0bdPVlC5hUhvgwgxlzCCOBbCzzYGk9i1KLUekLD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3889
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022 at 07:05:02PM +0000, Joao Martins wrote:
> On 2/2/22 17:03, Jason Gunthorpe wrote:

> > how to integrate that with the iommufd work, which I hope will allow
> > that series, and the other IOMMU drivers that can support this to be
> > merged..
> 
> The iommu-fd thread wasn't particularly obvious on how dirty tracking is done
> there, but TBH I am not up to speed on iommu-fd yet so I missed something
> obvious for sure. When you say 'integrate that with the iommufd' can you
> expand on that?

The general idea is that iommufd is the place to put all the iommu
driver uAPI for consumption by userspace. The IOMMU feature of dirty
tracking would belong there.

So, some kind of API needs to be designed to meet the needs of the
IOMMU drivers.

> Did you meant to use interface in the link, or perhaps VFIO would use an iommufd
> /internally/ but still export the same UAPI as VFIO dirty tracking ioctls() (even if it's
> not that efficient with a lot of bitmap copying). And optionally give a iommu_fd for the
> VMM to scan iommu pagetables itself and see what was marked dirty or
> not?

iommufd and VFIO container's don't co-exist, either iommufd is
providing the IOMMU interface, or the current type 1 code - not both
together.

iommfd current approach presents the same ABI as the type1 container
as compatability, and it is a possible direction to provide the
iommu_domain stored dirty bits through that compat API.

But, as you say, it looks unnatural and inefficient when the domain
itself is storing the dirty bits inside the IOPTE.

It need some study I haven't got into yet :)

> My over-simplistic/naive view was that the proposal in the link
> above sounded a lot simpler. While iommu-fd had more longevity for
> many other usecases outside dirty tracking, no?

I'd prefer we don't continue to hack on the type1 code if iommufd is
expected to take over in this role - especially for a multi-vendor
feature like dirty tracking.

It is actually a pretty complicated topic because migration capable
PCI devices are also include their own dirty tracking HW, all this
needs to be harmonized somehow. VFIO proposed to squash everything
into the container code, but I've been mulling about having iommufd
only do system iommu and push the PCI device internal tracking over to
VFIO.

> I have a PoC-ish using the interface in the link, with AMD IOMMU
> dirty bit supported (including Qemu emulated amd-iommu for folks
> lacking the hardware). Albeit the eager-spliting + collapsing of
> IOMMU hugepages is not yet done there, and I wanted to play around
> the emulated intel-iommu SLADS from specs looks quite similar. Happy
> to join existing effort anyways.

This sounds great, I would love to bring the AMD IOMMU along with a
dirty tracking implementation! Can you share some patches so we can
see what the HW implementation looks like?

Jason
