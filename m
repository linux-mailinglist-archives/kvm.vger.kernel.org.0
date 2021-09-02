Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C6F3FEFA3
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 16:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345601AbhIBOqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 10:46:31 -0400
Received: from mail-mw2nam08on2047.outbound.protection.outlook.com ([40.107.101.47]:32839
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238334AbhIBOqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 10:46:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrxTc6e5Sr2AoMy3DYQ3Ul231PiMtHtaIEW4osTbXNagjapxomOBiTSUVbdwcN9BlgPg9hVfFCaJeBPn7mj7HZekP8Ax5Tpx4pwXWfuPzbYxBfg6TptT1MmoWiRolHpJMXIzKoizxLOYFZ3pBIEudI1rf2tV9N88C+qobB3rU+L9G07X3cdy9bw8Kw6LbjBedxjQFkn9ys77kcatIAmwE1PuP+DkmuaWCkUf2KgTPnlr3PvKG6JHMB8kvHR1w1oZJdnsscJ0BdQq/pnB5HTIsH0rYm57mB0mK5Ck2o6dbie2Cw/C0Uo2V5m/XU9hnMC+Pz0vlNPjIQ2oyZH3BuqlIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=REc16lldlAUz2MpbSrNHEqKzNEaFnGFyrCtAp5CtkmQ=;
 b=lT0vsc4gUa6Gz3yFA4TD9eSaI5MQKQJwkTf2xGPBfX7UGX0i8ASkSH9BnChfg+pcbEm7QUouQLO7fGBBX0c0NVkBQ+LToKxDRY24euhdJMmZv6Pjt7EaYG4KCq/opRzzV/gnVAGLysfT4j1nnT4Gqc7PF8C8rG4snMgEXUrvCBEDkJpfYjzw/lZjVwI9fitZ0Uls9TV7MweEtLXopveePOmRSIOn3PVC2Fa+9Y4eFFfKtfhypjwO9T3Nsko4UgNw1W8qhZLcEc1yxNOanIRgaXiFRpAEQHahIoHGQajIs53soxrcnWH/COiVUUzBarESlC5C/KaQwlIA5eF4R40k0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REc16lldlAUz2MpbSrNHEqKzNEaFnGFyrCtAp5CtkmQ=;
 b=I3h+L5dFOqDukFQBxoCtLEI0MXCu7aDZSKS+KiOwb3TjseS67UHWLacHU+osBwbHW5IYhHBlW96qJpwz8f4SEVLNYLKnWp6VYjV+JGEYkxcdsgu1JQCqtLR2SNn/EimlBRmPvVSHkOs+DEA2ceuxMLyfYDBTOI/4BMrQCHH6dGTaWumiaEVy1AOXkLjq1XhRKPGaeiQiIhixNmAWe73JJFAhsk8pfOLMCGaw7itmHOzLcNeVPduH06X2NzannRH7p5/QHXAUi7VrkAjDBLazrYP4r+MV3qgUtoTcBXRKh5CBPiltlQQEzAuMvSRptfRF6LTa7cUYMqIuQLE1xCZPjg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5206.namprd12.prod.outlook.com (2603:10b6:208:31c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Thu, 2 Sep
 2021 14:45:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4478.020; Thu, 2 Sep 2021
 14:45:25 +0000
Date:   Thu, 2 Sep 2021 11:45:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [RFC][PATCH v2 00/13] iommu/arm-smmu-v3: Add NVIDIA
 implementation
Message-ID: <20210902144524.GU1721383@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
 <20210831101549.237151fa.alex.williamson@redhat.com>
 <BN9PR11MB5433E064405A1AFEC50C1C9F8CCD9@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433E064405A1AFEC50C1C9F8CCD9@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR0102CA0042.prod.exchangelabs.com
 (2603:10b6:208:25::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR0102CA0042.prod.exchangelabs.com (2603:10b6:208:25::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Thu, 2 Sep 2021 14:45:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mLny0-00ALYJ-Ax; Thu, 02 Sep 2021 11:45:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 982289d1-e956-45c3-0584-08d96e204c89
X-MS-TrafficTypeDiagnostic: BL1PR12MB5206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52067A798C48DB8EFFC48058C2CE9@BL1PR12MB5206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 45WSgBJotA8Q/DPFSQKsZa9OQeWXBn+lDSMqRI0M1GMLU65ftgDqNguKUKu5dg3nfTbrPrHTl8ZdprDxOgRofKmjrxONBKLyHFGLitwOJ6ZKGuYAxemASgzZtegPor0nIEF674G+UEsmmDpMlBqG07o50VyeE48qZdmsqjYmWCYRJoq+BxCxye27uwYhQz3NlmFOruK+suPqeRkXJfOjQAJ2WnkLuI+C6g6kLgpQRynURX3Un3F3WPsbBrIK8MvX6xsI8C2RBGI1HSz9aeWiUd+taRvEyFopBKSbBPNZ2y4DjP90b6ZyrQQNic4xgYENJB2XW94G7tmncfn16Te76/l0zwFYl1ngpQ8IYHdGTLwdqSWgMcH83P0RyOdpS4KfVcKxuKcR0CO09KPdJ63apFqUcZx/6yDO7CM4eZOqs72c+3iqcq6wtrbc5RqWgOJmwJznP3+uE4SVD4H4ZsP94WT6TUlkCNYKMBlKvaPByJgUJKacvYm65rjMsCZgJ8zMsbntIQBIaXw1wNL1s666JU29aHsLq2SB7IlAUtjI4xRyaz1y5BtWwTsw9TcrYq7CH1i0rvz2YKrYL9zlV4lSIZ91yvbmGMVoLoxlSNYYtB1kJcBiyEJnZ86sfJVOTWK9EsEmfq9YzaYdCR1cmOV5Aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(426003)(2906002)(8676002)(1076003)(38100700002)(7416002)(86362001)(4326008)(6916009)(508600001)(8936002)(316002)(66476007)(54906003)(66946007)(66556008)(83380400001)(26005)(9746002)(36756003)(9786002)(33656002)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gpFuhGTa6y2KZFFu654L9RIURRmWd4Xty0vQV4gWD8dsv9VzXecwdX5pfLN7?=
 =?us-ascii?Q?mwLoyWzKBEFDcjwsIgIrKip2ESGh1XiLVoyNyOBkh3XIDCjU9MmSibn6nmGM?=
 =?us-ascii?Q?nCIg4d6nQTfiAe9B+NbnlGJ9Xme3TKuYrc7cNI7rMBYOUXDBWG5n2PTC9Aje?=
 =?us-ascii?Q?/fliKmTTINKxDv67zNc+WXAj7WhmUHHjSkeUjcNDeoxXq5/HyBJicfs0mwHp?=
 =?us-ascii?Q?uQIPd+2ep2bUlHijUWM7ZaBvVyhkmui3EXwdPQiJ2tniJ9+lY5uqMU3jtaxw?=
 =?us-ascii?Q?FmSNYQR1yqwpdtCqopVEMTNSNAowHC38m+cDO7qHLTzG8yOduSiqixFd40DO?=
 =?us-ascii?Q?rO+dAzb+VzQAlJsXpSzNObmnbOekoOzFnyl0J6OIByrpWRUe42HdtdNhkN9c?=
 =?us-ascii?Q?3JywAHUprpYYxoXH2EVK3mtRv3xUKpnCUilfHAOPpJsxJtW92PxopaGACa3l?=
 =?us-ascii?Q?NFHFDijihXNncDloocpYFcZH4nZ377YUEqsxWHsApv0ARDc+WNNO7okZJPa0?=
 =?us-ascii?Q?3vowM7NrVGPGZwCZOsaS+bFwUybZZdwxvEJm/HEth4gl23J8jFO9+oltVKUy?=
 =?us-ascii?Q?rfPYVQ7usxelXZ/8qfE3vOjitlyCe2pBPc+wDUzC+u+YKzLQ1weNSx8iopXr?=
 =?us-ascii?Q?d3ZiC9lITJkuAyy9NnznpSHleU8lteM/7feWTnQEPJEvSZ4jXTAAJ7n8LFL/?=
 =?us-ascii?Q?96Vi95HJIQOovacX9Js5lY2/oe6dZALuIWDOc6Dk/CkY29SLMEeQ1jc2r50/?=
 =?us-ascii?Q?Kfzodfigp+HWvBYTqwJQqmZ9q0/I9y6ozBUCDD9tA8wNz/YeHZl61a44Rwmp?=
 =?us-ascii?Q?qFOtGJuNuVFHjW7ae28SwpOzo0WJ0EcQFJjtVTGbL8D2Jo/8MPPxMPAllCAn?=
 =?us-ascii?Q?kxn9keWp85ESdm/m2sCZyxZhA9dYdg8DHhi2nzsnGUulRfazlOzRzTpqQgs2?=
 =?us-ascii?Q?D/1pTwAM+XM1vxbNkmlvb2fGKnUDuiG0oq37pE5ino9Z28qS++sB4t5ZcYh2?=
 =?us-ascii?Q?K68Mloc3ofO8Muc2Jf+0SJYwKFhCTxVXrmq0Sw9dFzJHU5yCGioMiZvkZYam?=
 =?us-ascii?Q?i9FxodPn7K7Vps8DYrslrzJ7VWyNs52ktm4zhUyClOMW2PVaQj6YOCYvcf8E?=
 =?us-ascii?Q?IB5NEloErhU1XtvFqozFKtKTEpqDeTTNwmiGcY2CvpsswoADBFWdNsSzktJy?=
 =?us-ascii?Q?YMIE3VZopQieHCBrV8EyPaPNKIn/lg9KqCNrunPk7TeK2VceNSVngi9C9ES2?=
 =?us-ascii?Q?WnC2wNYFoY6Yvxh/2WLW6wO+IBYHEWAv+dS6wg3nxfKiyKvtT79xVXuucepL?=
 =?us-ascii?Q?rcQh8+xWAVIWWjyhNojSDWFc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 982289d1-e956-45c3-0584-08d96e204c89
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 14:45:25.4600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rn6fqNrVairgE2MS69VkZuPpg82xzEzikRVSMUbcWTHGHapOWMN9jbNNmaQv+j7+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5206
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 06:55:55AM +0000, Tian, Kevin wrote:
> > From: Alex Williamson
> > Sent: Wednesday, September 1, 2021 12:16 AM
> > 
> > On Mon, 30 Aug 2021 19:59:10 -0700
> > Nicolin Chen <nicolinc@nvidia.com> wrote:
> > 
> > > The SMMUv3 devices implemented in the Grace SoC support NVIDIA's
> > custom
> > > CMDQ-Virtualization (CMDQV) hardware. Like the new ECMDQ feature first
> > > introduced in the ARM SMMUv3.3 specification, CMDQV adds multiple
> > VCMDQ
> > > interfaces to supplement the single architected SMMU_CMDQ in an effort
> > > to reduce contention.
> > >
> > > This series of patches add CMDQV support with its preparational changes:
> > >
> > > * PATCH-1 to PATCH-8 are related to shared VMID feature: they are used
> > >   first to improve TLB utilization, second to bind a shared VMID with a
> > >   VCMDQ interface for hardware configuring requirement.
> > 
> > The vfio changes would need to be implemented in alignment with the
> > /dev/iommu proposals[1].  AIUI, the VMID is essentially binding
> > multiple containers together for TLB invalidation, which I expect in
> > the proposal below is largely already taken care of in that a single
> > iommu-fd can support multiple I/O address spaces and it's largely
> > expected that a hypervisor would use a single iommu-fd so this explicit
> > connection by userspace across containers wouldn't be necessary.
> 
> Agree. VMID is equivalent to DID (domain id) in other vendor iommus.
> with /dev/iommu multiple I/O address spaces can share the same VMID
> via nesting. No need of exposing VMID to userspace to build the 
> connection.

Indeed, this looks like a flavour of the accelerated invalidation
stuff we've talked about already.

I would see it probably exposed as some HW specific IOCTL on the iommu
fd to get access to the accelerated invalidation for IOASID's in the
FD.

Indeed, this seems like a further example of why /dev/iommu is looking
like a good idea as this RFC is very complicated to do something
fairly simple.

Where are thing on the /dev/iommu work these days?

Thanks,
Jason
