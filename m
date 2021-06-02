Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915683993FC
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 21:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFBTzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 15:55:52 -0400
Received: from mail-bn8nam08on2074.outbound.protection.outlook.com ([40.107.100.74]:58368
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229611AbhFBTzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 15:55:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QljPB4HeR9cGwW0S04eM4WdCSN3zaR86Q+Dp8T4R5TqU20J8a5Pm+Kcu2UFiYqiFCjdCYLysaRMc5iklQvKwKGVbwgvDVCZzz8bjQk0C1Zx3lvj8OW3JeM+8u9oG/32N6g6XGoHJb/aBmJDuVWOIatG+ADQBCu7aSPyr2jOf5SLGcks+QClwWvOXl9q+leqqm28DuUiO6KspXb2g4+NWCqr26u5Nwako67cv8p/zSQ6UQlWLwUXMbJhbgtmwg9DhN+SUKYN6kd0Ax7AAxUdCBJGR9mcTHNWRwDdw9Z+KjOW7oVc/201rln01wn7jgXRdfBQmAgawFxJw1DVEH+KHUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzZjN/r4AgZoYXPwCXDhw6WNier7JV1F0ftY6IwkhNg=;
 b=GaiQritQ+bsrLyXhJqhf+hzoBxP8l8Sb07ientSufz5KZeO9ubZYEKD6gMU31yepfru/r9NAIUfQu0L7pS1E0mMDvXOgr/J3caPfBCU3fAeqS67+IXnceBIPTJ5jkIrknkjb+cKy0gny7gIy6W5/HVdR8vExte9hajlbjLe34ZbbotJ0ywt8MTzc/V1A2WjXN2Uc4abYd1798fYPuheeFpQRPpA+GdMuuKfaz4Z0D3H9iDtOgb+4NeGkYioha8lLzvhdazbXkAhobqTITtix7sy5+9HR2wf4mAL4o9b7QzcPLowE0l4gF2N1YyrVqL4EPJ/b/EKStm4VuZLyQxQ8dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzZjN/r4AgZoYXPwCXDhw6WNier7JV1F0ftY6IwkhNg=;
 b=j3e7hLn7fXCirfXA791Vx9n2jksymIyx6Qvqzs4KdoJO14O5tmuNv2KIR338e3Y2pYpkuh+XBgiLfr7cBTif40dy0PEAEQ+6hMeFTIAQdlmgCHCodkFXrrMOmATkjY3boMpt5fzuq/hk1PWmA3IyZWwi+Pn/6qW1KTc3F2CBDkjQOUwMQ6igdsC1a8MLUfZo6Rq1GlPcCEg/c9mq351bqsiwxE59vzSHrs9YlA7pqSju++AHF+vpiK+2alR7t+VNi1NpQmcvrG0aGlJ6Z3lSZUNG/atr/Yk1OvImMIke4hC/m/uWUqOGB97bj9lcWi4PyOFUQpz5TO+6U50+DXo2bQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 19:54:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 19:54:05 +0000
Date:   Wed, 2 Jun 2021 16:54:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602195404.GI1002214@nvidia.com>
References: <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601162225.259923bc.alex.williamson@redhat.com>
 <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160140.GV1002214@nvidia.com>
 <20210602111117.026d4a26.alex.williamson@redhat.com>
 <20210602173510.GE1002214@nvidia.com>
 <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602130053.615db578.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR07CA0020.namprd07.prod.outlook.com (2603:10b6:208:1a0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Wed, 2 Jun 2021 19:54:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loWwG-000bT0-92; Wed, 02 Jun 2021 16:54:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 552e75c8-97cb-4fec-f6d8-08d926002d62
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5304638B1B8427FB1BD32775C23D9@BL1PR12MB5304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dbh7b+dq0KXjEpLg1iot2Awdsa4/GHF+Xtv7IETApeFb+5Nx9oIUB5PhSgP4lT8hB6NlU+t9YOGWXptOJKWbFfIxUZIW7DY5LE77afDxVZ4Yr25we5DpjE5CdcBUgvvY8vVAXS0FLLeotWPmKdtqgsjvL3Kmsa38qF91uhAnv5woheacfoPG3WeybOE8n2Gql7FWpfmlUY0VsKSfSbogjN4VAeF7zcaFMth4dKkUUUGrMzdJra6BsfdqPvtcnTk+RmdEF7dOiv7s50lIXAzmpm9udpYNPwn3vXB5Ddz30S5evcSf843wVUviSczf6e4tOxfqDOboRQyfP0PfcYwuSI7KLRIkDBNUlIYXWzT0DLLLCRtsw2BOOzWvg0L9oQTbToDAEH+eo2g42YMzztmCYmMuEfar3wjw/w//qF68fj/7hpKNT9oD5Ymjuur0A9Dd7rCjRDCCaxbpiITvLYibaGLua7H/fDEh09hYahjH94jYO/W2DPJnsmBsUIr/GhKnzA1W+mZQDMyvGs0KAyhuH1b2ReHD6GHix86J6f53npQBv2mzYnVSht8yL/U1PiuCMPLVZ37Tk/yA/VvegZsz1q2P2sqm3xIi7BQqOZN/CAw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(6916009)(83380400001)(9786002)(9746002)(478600001)(186003)(4326008)(2906002)(1076003)(8936002)(66476007)(7416002)(54906003)(316002)(86362001)(66946007)(426003)(26005)(5660300002)(36756003)(2616005)(8676002)(38100700002)(66556008)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qTX5WE0yiuikDFfEOXQssa/brSs879LIjKw3+nUMPlOGVWoiSlls3SlRiHAN?=
 =?us-ascii?Q?GqS61uRnc96krsY1E+3zmebT46rnx3Ik/JxYAtxHEHmpDdQFqOjQBsZCc27i?=
 =?us-ascii?Q?dVuGL+zYjp6SiIjAYVfrL8NXH1JI6LCwYxPkjffUQSef79xQp8SZvoRaIwXO?=
 =?us-ascii?Q?GvDO4gxW13hTXPXOzVPsupJ+nPQW6Qn3FX4seJxGrojcsdLbKHkOSepS0XmG?=
 =?us-ascii?Q?pMFXtESoUERxCGlNMHaxOiwq/ZlIMP7AT08Gyzqx3NG1u4Duwvqo2X7BtwIx?=
 =?us-ascii?Q?HXR++0xhli+sM2/iP87Q47T4P8eF9U7VBeANkc2fxUKFpg2eKxCDPIBZ4P3T?=
 =?us-ascii?Q?CTWirxl9BtFlBZeawWTYysxI07KRbTHbbQKoQb8Ad2NhrBHSiGP7h4C4Rr8n?=
 =?us-ascii?Q?nmcdY1luCUbkCaROd8rqmjrqEQqYApHfC0q06ACMv262PUlZHNCRlkofYuhR?=
 =?us-ascii?Q?CaDxkpBh+IUVNDti7erf86kR7JhGJ6dleoyWdQC81J5eEsdqidhWTZKUI7Qe?=
 =?us-ascii?Q?zc2bEwd2dHEKwAR0BgG7vBP2TNq9onNfCX1NY1naW74ufUfP4XIp28dWPrY3?=
 =?us-ascii?Q?H+84xFyr+/XDwmR1PxgWygv7AwYM7tR1uchElJj3K/TyHBNW3W+2gokUeWAw?=
 =?us-ascii?Q?d1HOK8f//h1ltEN/URRx+0HD5LbOUCXLg9F0EdnES9yIUJ0FkLRKJ/kd6O8h?=
 =?us-ascii?Q?Vp9OE0B8PPrkpsjKPzp373YH7zWpPt5l8z4Lik1zLQp1UviNtfWJSdLNmYaM?=
 =?us-ascii?Q?FLdr0V228v0ZqZRVROOlQhzPPZRWTbQTDN/x0reKn7uXCh6M1sg51b9J1L2j?=
 =?us-ascii?Q?14rExUcvncNNZVnHYBNspNQprAKTMRpMpLpL5HLGsex0ipTzk6MT8UUaNBeE?=
 =?us-ascii?Q?DnFAJ/+lhe/bN5tkjMlqVyCw+Zu4OvmAmSby35m211vOTmvOWhh33nA3nx4y?=
 =?us-ascii?Q?l34cO+3JpXk4bel2MNc2OK50Ry87770FVwSr8kBdgW4Cy0bGKTIPP6X6CgWF?=
 =?us-ascii?Q?qoI/UOp/U3jGOWw72L49PlooH0GjLG3Hq2/cE4SNdeY9FGadhQGZgVlipKed?=
 =?us-ascii?Q?opijavbbQuxWrO0PCkY+zimPKHMc5iQfjHANdPFLqlKOccCXanYi5tAB+h3b?=
 =?us-ascii?Q?HNwMou2ikFf7ybBtagFZWIMwwZogm8cwPRMtKq4ovum1g08L9zV9mAzHPNZh?=
 =?us-ascii?Q?fA7wbFOrt/ZNSg7EOE/c9w+7seKST1RJiGx7J6UguObSDIMePYrc/3wtFGFF?=
 =?us-ascii?Q?61NLbb4TZkgSq3xAFnaYCrpOLopGoIUPc6JkWcwKvu4yGYVM5Uw9rGE1DIZz?=
 =?us-ascii?Q?5+O7ocJlMIfnuZt1mh/9oGRr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 552e75c8-97cb-4fec-f6d8-08d926002d62
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 19:54:05.4524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6EFlMj8V76YVV0IDYGV8w0Xv4cfHWblPSnR9fJNJu5IzwAcbSwvgFEh353fZrYm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 01:00:53PM -0600, Alex Williamson wrote:
> On Wed, 2 Jun 2021 15:09:25 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Jun 02, 2021 at 12:01:11PM -0600, Alex Williamson wrote:
> > > On Wed, 2 Jun 2021 14:35:10 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Wed, Jun 02, 2021 at 11:11:17AM -0600, Alex Williamson wrote:
> > > >   
> > > > > > > > present and be able to test if DMA for that device is cache
> > > > > > > > coherent.      
> > > > > > 
> > > > > > Why is this such a strong linkage to VFIO and not just a 'hey kvm
> > > > > > emulate wbinvd' flag from qemu?    
> > > > > 
> > > > > IIRC, wbinvd has host implications, a malicious user could tell KVM to
> > > > > emulate wbinvd then run the op in a loop and induce a disproportionate
> > > > > load on the system.  We therefore wanted a way that it would only be
> > > > > enabled when required.    
> > > > 
> > > > I think the non-coherentness is vfio_device specific? eg a specific
> > > > device will decide if it is coherent or not?  
> > > 
> > > No, this is specifically whether DMA is cache coherent to the
> > > processor, ie. in the case of wbinvd whether the processor needs to
> > > invalidate its cache in order to see data from DMA.  
> > 
> > I'm confused. This is x86, all DMA is cache coherent unless the device
> > is doing something special.
> > 
> > > > If yes I'd recast this to call kvm_arch_register_noncoherent_dma()
> > > > from the VFIO_GROUP_NOTIFY_SET_KVM in the struct vfio_device
> > > > implementation and not link it through the IOMMU.  
> > > 
> > > The IOMMU tells us if DMA is cache coherent, VFIO_DMA_CC_IOMMU maps to
> > > IOMMU_CAP_CACHE_COHERENCY for all domains within a container.  
> > 
> > And this special IOMMU mode is basically requested by the device
> > driver, right? Because if you use this mode you have to also use
> > special programming techniques.
> > 
> > This smells like all the "snoop bypass" stuff from PCIE (for GPUs
> > even) in a different guise - it is device triggered, not platform
> > triggered behavior.
> 
> Right, the device can generate the no-snoop transactions, but it's the
> IOMMU that essentially determines whether those transactions are
> actually still cache coherent, AIUI.

Wow, this is really confusing stuff in the code.

At the PCI level there is a TLP bit called no-snoop that is platform
specific. The general intention is to allow devices to selectively
bypass the CPU caching for DMAs. GPUs like to use this feature for
performance.

I assume there is some exciting security issues here. Looks like
allowing cache bypass does something bad inside VMs? Looks like
allowing the VM to use the cache clear instruction that is mandatory
with cache bypass DMA causes some QOS issues? OK.

So how does it work?

What I see in the intel/iommu.c is that some domains support "snoop
control" or not, based on some HW flag. This indicates if the
DMA_PTE_SNP bit is supported on a page by page basis or not.

Since x86 always leans toward "DMA cache coherent" I'm reading some
tea leaves here:

	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
					   transactions */

And guessing that IOMMUs that implement DMA_PTE_SNP will ignore the
snoop bit in TLPs for IOVA's that have DMA_PTE_SNP set?

Further, I guess IOMMUs that don't support PTE_SNP, or have
DMA_PTE_SNP clear will always honour the snoop bit. (backwards compat
and all)

So, IOMMU_CAP_CACHE_COHERENCY does not mean the IOMMU is DMA
incoherent with the CPU caches, it just means that that snoop bit in
the TLP cannot be enforced. ie the device *could* do no-shoop DMA
if it wants. Devices that never do no-snoop remain DMA coherent on
x86, as they always have been.

IOMMU_CACHE does not mean the IOMMU is DMA cache coherent, it means
the PCI device is blocked from using no-snoop in its TLPs.

I wonder if ARM implemented this consistently? I see VDPA is
confused.. I was confused. What a terrible set of names.

In VFIO generic code I see it always sets IOMMU_CACHE:

        if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
                domain->prot |= IOMMU_CACHE;

And thus also always provides IOMMU_CACHE to iommu_map:

                ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
                                npage << PAGE_SHIFT, prot | d->prot);

So when the IOMMU supports the no-snoop blocking security feature VFIO
turns it on and blocks no-snoop to all pages? Ok..

But I must be missing something big because *something* in the IOVA
map should work with no-snoopable DMA, right? Otherwise what is the
point of exposing the invalidate instruction to the guest?

I would think userspace should be relaying the DMA_PTE_SNP bit from
the guest's page tables up to here??

The KVM hookup is driven by IOMMU_CACHE which is driven by
IOMMU_CAP_CACHE_COHERENCY. So we turn on the special KVM support only
if the IOMMU can block the SNP bit? And then we map all the pages to
block the snoop bit? Huh?

Your explanation makes perfect sense: Block guests from using the
dangerous cache invalidate instruction unless a device that uses
no-snoop is plugged in. Block devices from using no-snoop because
something about it is insecure. Ok.

But the conditions I'm looking for "device that uses no-snoop" is:
 - The device will issue no-snoop TLPs at all
 - The IOMMU will let no-snoop through
 - The platform will honor no-snoop

Only if all three are met we should allow the dangerous instruction in
KVM, right?

Which brings me back to my original point - this is at least partially
a device specific behavior. It depends on the content of the IOMMU
page table, it depends if the device even supports no-snoop at all.

My guess is this works correctly for the mdev Intel kvmgt which
probably somehow allows no-snoop DMA throught the mdev SW iommu
mappings. (assuming I didn't miss a tricky iommu_map without
IOMMU_CACHe set in the type1 code?)

But why is vfio-pci using it? Hmm?

Confused,
Jason
