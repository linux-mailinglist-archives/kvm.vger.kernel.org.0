Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C5F337A05
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 17:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCKQwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 11:52:00 -0500
Received: from mail-dm6nam11on2070.outbound.protection.outlook.com ([40.107.223.70]:42080
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229519AbhCKQvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 11:51:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuyHw3HeekwEfphi8J1mdSq4D2gDB7RXH7z9I4VHu5Ubcf7xJS6Kppp1pKppekin1sAso4g/gNYRDobEL13aw+UhHCR1CfVz+jmDu/BdE4f/BYmkZWGI14qksQTn7iDlHn88e+ZqGX1gK6vjqN11RWS8UYa0+TzHI4gN1Bu1J1TPMKBpoELylj4lx296GBhgqLJu3r0gaQnvWRt/0fZsfM2wks7gTCD3hFYly+nZ55g4nk3IwOg1MomNfRE3l9QZZZFB3QEMiv2Li9QEgwA9VQi0+kaA8CX7mH3usXB9vFfD5NHXljK02ziIIjeoZeAlksDMTeR4nINPf3baky/08w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iyv6ysAL809UTnknXBjoIZq6OXspWfGt7SfZ9Bt/KIU=;
 b=E6P166mDcNwVQ802kQoEQ90vkeF1NEvIef+gJYx5D9kL3m+SwS0SrRG6sFZC5fHGtaaa4DsC8BmUkHTpD8gEhkJl6SghPFw2crU9P5HPp8HQsKxWQtRx1pqjPmi66v+Nxp9JiHcSt1cwEOcDH2rp4FWvJ6BXsMC5tL98ISfUZldSEf5BWsGy9iA5l4iaey382fkxXE7TfYqubKuEITH1fMZlEvY+cIv+wUDE4K0idcJDr/31NupScMrPfl6mGp8EAJxTw4uNLagSNr+DUGMW2ovwUIa9D7+x9/ZUKKw2xpaiLQ5c5Jm7VPxsfr1w6sskB90tvttF8JyFfEhJgSHP7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iyv6ysAL809UTnknXBjoIZq6OXspWfGt7SfZ9Bt/KIU=;
 b=I8Z2oWGU7/eIWPZL4NaHHt1VCT7vEfYoHSOKvi3bc2wKuSNIjwjCOKdUWaISSTNy56C5g/a6xc2Y3X9LBqnbrU+2lNQzzF2xbv9gLZMlhb8lPXUUM8+jL8A/4QNcs33f/jZDVuIi33aqMiabwFOwrG+FgYBnyc7nHzkuz4UjnYiS23vh4jAc9uCQXpg69r1Loqw+NDtDiAJs2FjPhHzdmb+yBxQ88i15LsQPVAP7cqsW9ogojUupV0OniWPo3BMTpEtQwaioozxFTiUVAxOYqWwwAlBXUwEEgdxoW5S7pgC3wBS4+DfdTfV46XMLkUJ0wPBI+llLgzRA69HchnxyNg==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2488.namprd12.prod.outlook.com (2603:10b6:3:e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Thu, 11 Mar
 2021 16:51:31 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 16:51:31 +0000
Date:   Thu, 11 Mar 2021 12:51:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210311165128.GL2356281@nvidia.com>
References: <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210310130246.GW2356281@nvidia.com>
 <3b772357-7448-5fa7-9ecc-c13c08df95c3@ozlabs.ru>
 <20210310194002.GD2356281@nvidia.com>
 <7f0310db-a8e3-4045-c83a-11111767a22f@ozlabs.ru>
 <20210311013443.GH2356281@nvidia.com>
 <d862adf9-6fe7-a99e-6c14-8413aae70cd4@ozlabs.ru>
 <20210311020056.GI2356281@nvidia.com>
 <73c99da0-6624-7aa2-2857-ef68092c0d07@ozlabs.ru>
 <d2c32828-3417-1872-6451-2450e6fa763d@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2c32828-3417-1872-6451-2450e6fa763d@nvidia.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0031.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::44) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0031.namprd15.prod.outlook.com (2603:10b6:208:1b4::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 16:51:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKOX2-00BLYb-46; Thu, 11 Mar 2021 12:51:28 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb28dd91-7084-4e2f-4f8c-08d8e4adeae5
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB248896F3E40318C304322DEAC2909@DM5PR1201MB2488.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eTYM8IcMRR7pihCHPzxPNRqflnXshCHCgD9Ln7VGmjthpHb2THJGWiYD2ZDIEqjXxydDqP9Zkf5ez9zN6ITBbMmEc4WL+ZnuB0VyVs0fW8ebMHVl2isQEbY6JqDgEWdZCShS05mCo1lZf2I02I1f2NQ+rDRBSUBlWxT0GJSEBksJRNkap4/oa81w2lcdeQGlD2LYiPGtaUBNayuVpdDtXIBEtGbpYZ2Oq21KiawNKQA1wakx8N0sOZaq6+ceraAg8DDrQzwZ2vZ0/zJwXkmmIBmhI7sCacYE1ThHKCgrmajlFERVm3LQieE8pwHWGKJw69sABuasSYVKIXsOguX1jc9Ub80bMuIOukndzHs1nq3hNQdsWPKODxAq4cF4HaRhV4WtzxAowxLJHQLu9wrwwtptEWfwRroGwq7031lsXiFACyR1I1d2MLfwODw6x7CMmtF/OWuBMG6sx21cGfSMTys/6NPP05FQWsnR/MDEQNJSe6YqQt47MRN4PcM5VZB2cXzBZy4BxS50Iz/Thc0i1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(6862004)(9746002)(9786002)(37006003)(8676002)(33656002)(26005)(66946007)(478600001)(8936002)(4326008)(2906002)(86362001)(6636002)(1076003)(186003)(5660300002)(66556008)(66476007)(36756003)(316002)(2616005)(53546011)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bjV0dTRwTTdsTVV2eWlvVnF4TEZNSkFZVWRFZThkVXZjbGJ6MlVqTmszeE1x?=
 =?utf-8?B?ZTZubEk3eUd3NzE3ajUvWnhtQzhseTJhODFJZXFFeWI0V2hsMm4zdG8rYnBw?=
 =?utf-8?B?c1dYTG1sQzhzaWp5b0hLZFJKRGN5MVpPM2lsbzc2bWFKT1JUbFNPcXpyUzNh?=
 =?utf-8?B?S2EvTlAxQkFGd3ZHRlBwTktiTUhDQ2xXTE5STitNdS90cGVoVUY2cCtsaFJw?=
 =?utf-8?B?ZjV6VWlDQmx2dVBoVjIyOHhsOTgvMzF3R2NXQ0RvYnhURjd0VmdlUndHa2cr?=
 =?utf-8?B?KzRWbTNjdVVLRlZGUGdscWpwYWNJYTloMnhNUGt1UjJBcGZuSDZHSGw1NjE2?=
 =?utf-8?B?TTNEMHJaUHhKRGdUVmRyZWxXeFgzb2lKbHlON3BlVFVDWEltbjRXbHgwaXYv?=
 =?utf-8?B?SHJteG5ZblJNcUhWVysrSG16UjB4NkdQbFdIeXMyQ3AvUGRpSGEreDBpbDFw?=
 =?utf-8?B?VXg3TU5HWXM4cENFWUxxcDl0elF1Snk5TTBVTHFFL1lUZjFiWm9SODlPT2hV?=
 =?utf-8?B?eFgzbXpnWU14cFdEY2xXa1FSdUdST1IwbDNuTUloZUI5WGNPWnE2TEVzSVcr?=
 =?utf-8?B?cy9MNG9rTTNnMm9KQkc5NWEzTHEwMmg5bTdkTSswOU1GUWtFVnlvUmpRZWZw?=
 =?utf-8?B?eldxK2I1dEcxODEwZHMvRlhuSXJSb1BidFFIalFWd2ZWcHVLZUNieEZuaXNn?=
 =?utf-8?B?VkxpcXJUdld6ME15QVZGMXFyQjdyMWNRTjMyRW9TcHQxWTYrYnVuOGREdnJa?=
 =?utf-8?B?ZTlvRUp1dnVpVC9YWTluSEpCL0s4NFI2MCtkZzNvSzlmclhVbkhCdVVVeS9Z?=
 =?utf-8?B?d0Y5VkN2WFJ3Y21abDZZcGs0YktXZDZBTzlGdGZ2VE5uZHVwaHVpT0lNeFhs?=
 =?utf-8?B?SnI5YTFFSjhMb1g0ZGNtSGNQZ1J6ZHY4NHc2V29GME12SmpETTBKckFFK3Jm?=
 =?utf-8?B?MURDTEx3eURCUVoxZzlCTXozZWdEb3pPL210RlNWRmNZOWUrRXRZNHFma21T?=
 =?utf-8?B?Z1N4MGdZZFhjZzNnVloyeEN1S3d5S3dXUUNBenQwUmxocnUvbzdDeHVyelNK?=
 =?utf-8?B?Y2tLejIvTW9HTWN4Vjh2UTZVRVZVZWVWVVU2a2dKVVFldDk4Y0tXM0FGVDM4?=
 =?utf-8?B?ZDdnSnhEOG11bXFMbkNybHErZm0yMmRYTkhrQzRGU3ErdGFEL29HN21DTVpl?=
 =?utf-8?B?WUg1N0lJeG02Q0xPMVlSamtvUHB3Q2NEajRBelFXNnR4SWdENG9TenBEUWp2?=
 =?utf-8?B?Q01GZmptR3dWOE9HMUdIWE9JemN1dnJGR0ZHQWRWQWxOUEowbGtlR0JHYm8z?=
 =?utf-8?B?WWVaR1BmOUQxTDc2NjFGelVKWGlDZGVMMWJGcTRpZzVJM29tWnpqQmNjRlIw?=
 =?utf-8?B?Yll5cXhzckRHZnhXVU52QTd1Ukt0dHU4SDFaT1E3d3JXMFFLVWZzNnJZVVQ2?=
 =?utf-8?B?SEZVdVlvMTI0WHg3SnBIRzNLQXhBanBkbGdaQVVwa3U2OG00QXRlL0ZiYUEx?=
 =?utf-8?B?Q0kzRVhVeTZKNHNiek1QcWZTZjh2YVJRb25wVDV4MGo4dnhvZ3lWNlhDancz?=
 =?utf-8?B?dm8wMHJuNFB4T2RVVmNyNHZXZ21BQnBZanYwS2c3TVJoT0NscG1ORmFlZTBM?=
 =?utf-8?B?TS81QkQ0SzRPaXJEeURRV3J0QXNCNE4zd3dXMVpiRndkMDM1cktGVFBQQm1v?=
 =?utf-8?B?WHpuY2RIUjNJUFROcUJ4dFFpYzBLR0VQS2F4VDlxQVROTjY2b1RuVDlZbEFT?=
 =?utf-8?B?TEtWcVZ2bHRWeno1L3NUekFGVkNPRzRIdW92bHdUdENYMVBlN3dHY3BZYzdw?=
 =?utf-8?B?UDR1bjNkMjY4Z3oxTm1mZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb28dd91-7084-4e2f-4f8c-08d8e4adeae5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 16:51:31.0257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MljiVLi7OU802Xtc9P5mC9764vlE3iAi7bDa0jx3bmttMX7avD8vBrwUisgXZfUw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2488
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 11:44:38AM +0200, Max Gurtovoy wrote:
> 
> On 3/11/2021 9:54 AM, Alexey Kardashevskiy wrote:
> > 
> > 
> > On 11/03/2021 13:00, Jason Gunthorpe wrote:
> > > On Thu, Mar 11, 2021 at 12:42:56PM +1100, Alexey Kardashevskiy wrote:
> > > > > > btw can the id list have only vendor ids and not have device ids?
> > > > > 
> > > > > The PCI matcher is quite flexable, see the other patch from Max for
> > > > > the igd
> > > >   ah cool, do this for NVIDIA GPUs then please, I just
> > > > discovered another P9
> > > > system sold with NVIDIA T4s which is not in your list.
> > > 
> > > I think it will make things easier down the road if you maintain an
> > > exact list <shrug>
> > 
> > 
> > Then why do not you do the exact list for Intel IGD? The commit log does
> > not explain this detail.
> 
> I expect Intel team to review this series and give a more precise list.
> 
> I did the best I could in finding a proper configuration for igd.

Right. Doing this retroactively is really hard.

Jason
