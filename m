Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D3F39923B
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 20:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFBSLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 14:11:13 -0400
Received: from mail-mw2nam12on2059.outbound.protection.outlook.com ([40.107.244.59]:61792
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229662AbhFBSLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 14:11:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYJCdRvXAuZDa6maxerhTN1u3WBy3RqRLx8ZUqhrerA4wzBwAsDpDiQ1sNo0ce2+YAydlU1qAisYrJnAbKw1Yny7IMm7kKj+BT7oftspXCTPo5602GEwVV2nI8719ty5vJojI1zARGZlfUkO360C+LYxANu3zEtFoJ3ueL57qLHZ9ry7bS/RDfIMoBnMmNXbwDOsIGkPznduNe6Cq12yD53KyXFdAuCPfIpx9uQ20tGYuoX9jn8o6IWraaUKHrsAeK+97OxljOq4Rxh0K7dCWLoNr0nShnEIx+PUGm8R9Fgib1DzhTANiDohsPPsEvaL2TDMgNAmozOpRGVO5B2vlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3dalfO5Zk0gfjeCpPpFzHRmwm68ntATfY7FMG/c54o=;
 b=Tl4dL8ToW/GyHCPe5dyroYBS2IqtTuos4ZEZGN7Srry7aKdeRXYKjD/UIcLsJd45CSlEYmDJ6E2x9t8CeQlnoaYeM6vKQg5Ml0xyQ3dsdEglj3GMXAKsZEAzJ6kIqSCleIhpk44VNBKRYyxA9fgN4j1iPqPkPjyJ8XCLmd+hFL5j28r9aTmZVg8Ui0yBU5dhQS5y9WyShVgZAtjPUiK+DXcvk7/adaaPtvxt6YdZgGVxpvxEgX1A0fGYaEMAidujrJckWL0lrhLyXXcYAgcJjjQ6gUahIaogSZhDZpYNE0FDzmJjjQg3pIPPEsxboUJFYSKpYteIaEVyXmwjjv/taw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3dalfO5Zk0gfjeCpPpFzHRmwm68ntATfY7FMG/c54o=;
 b=LleGHzulBlXG5HbJFzikxqAxzIvLAJz2PDWl5/ChHzU7bFORH0dmMmeXyeZfWkI+ej8J9ilZEGUBOiPF4XTnfa/FN+1dTHtLIbOnvTI0mvjaVHI4l7jPWBBCwb98oYdRQN6NKaCRiZO3WGroj+kOFBlFS4Hay07/Gn40uIX3sdCJ7JjQ8XatP06GsUaVAs8orYMqtHPXrFKt4RO3/Ikljw3JeUoL9DncW0aI32GWPSBUK/BORqJ6951pk9ef7XN7FHP78QesvbdSuejUpvX12JsFU2WeBVUFVYE9wxvYDBY7or+L3jW4f5fcy5obZjtve+bOT4jH+Sbmrz5uvg9dpQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5272.namprd12.prod.outlook.com (2603:10b6:208:319::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 18:09:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 18:09:26 +0000
Date:   Wed, 2 Jun 2021 15:09:25 -0300
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
Message-ID: <20210602180925.GH1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601162225.259923bc.alex.williamson@redhat.com>
 <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160140.GV1002214@nvidia.com>
 <20210602111117.026d4a26.alex.williamson@redhat.com>
 <20210602173510.GE1002214@nvidia.com>
 <20210602120111.5e5bcf93.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602120111.5e5bcf93.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0222.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0222.namprd13.prod.outlook.com (2603:10b6:208:2bf::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Wed, 2 Jun 2021 18:09:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loVIz-000JWP-3L; Wed, 02 Jun 2021 15:09:25 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8666174-6536-4539-9033-08d925f18e97
X-MS-TrafficTypeDiagnostic: BL1PR12MB5272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB527293FB5CE58FC7A1A403F3C23D9@BL1PR12MB5272.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:397;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HdBQzsj5KxHF81CJeKOHfi8H8hd/C9JDMUmxf0d1EpUolH5dukBXh0WcbZJwYi9KgBXAOTnlTloXjHz6rxAW0iHl1aw2Fa80MX/XRdPYF9mbU2bVOr7aVH5uqQEAl+sXKeCTwaGaqCQ+VFYi9Mry4FackXUwuOFowsRnhFpfeFhiGuk0kN2lA/JCStNNxt7hCJntYGrQyrVq/DNcI1QjQOMflhhTbgcbv9oSiugRrT7CN/x1wbLbS4JsHhJEZfJm2TgQuN1f32F9uf0Egw3w9TKD8oVEZR+kGDrq9nGaBKivcZrjsCGGdSvD6i/U+xrtey8tbn5HqMFfhdx3mySUDZXsmRnLEYsVqEbtnsWYi02Hiik/ipzzflpAaufRSfOzfml0g32sl8AJz7tYR2PFZqfdO75ZefZ2jSGP8p4p+vk+hNkm3Xa8SOi4YTgdOrc5TJM/AjinrOK5XNceAXmEtY/ss7Rc10yucIylRDl2JXxh2Lss2OU6ptSPyHHNUEiJd6Ef33NLDfL3rXT4noHyh6Z0fyXxr5nrYaXamjh92OJM3+kVaslew5qFXkj0DQYEqnylFJsW6AwIa2tGUuddkFTeMm7H3BKf/sZhmjk3wMo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(1076003)(9786002)(5660300002)(9746002)(4326008)(6916009)(38100700002)(33656002)(8676002)(8936002)(36756003)(86362001)(7416002)(478600001)(66476007)(66556008)(186003)(2906002)(26005)(2616005)(426003)(54906003)(316002)(83380400001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g6+IxBia++5CpL/tSFEKYzPQuaBBv9cw9JfWdVZzKwBomqHmthKy4TGQTsmz?=
 =?us-ascii?Q?hKNvxaoYHEUmFTccE9ZXcNNXEw+GSw3QFUfLCPzsni9rQGwmCX285CewG7IZ?=
 =?us-ascii?Q?Jmzq1PFZ1nZl9wwv9Kopr1LE8CPs2LmV6RLdfbSQhwmstJuhL6vDIu4DLHjL?=
 =?us-ascii?Q?5PsAe49+8CDpd/Rt3hNWdrSlKqEW/lELbNijZ/3y754sROQ3EOg4UYp2Ll1r?=
 =?us-ascii?Q?R8og2+fykLjLptbmFG71jttRXJ4Yc73FfsfVC3OnbRYTxyDkgClYLgE6BfwC?=
 =?us-ascii?Q?al35DvIXJuLyCH4ZCJu+MRz4zJVtD4iCU2h1F8d42tnGMQCCel6TghlLMs89?=
 =?us-ascii?Q?h9An5JQr6dKDe+CJycSi+tC8TwrtPjsNqMpmBdhvbY4FvEDUwkA+3Mr5vcv1?=
 =?us-ascii?Q?M+CUurM69v1SNSfWEt1VpaqCuQpmtE15K79xwTWZEILQZrbl/Gp9mER639au?=
 =?us-ascii?Q?MhdhFUca1TpVYlJqZCSLSwcLsuBuw8wjdkbnCiZLsZPQnDNU+ClQQkSDfkD6?=
 =?us-ascii?Q?znC7Cweas6FjXury9DaOZHDL+m91F/QFNzJoOuXh+CSLdJePyHqUqRdVNtUX?=
 =?us-ascii?Q?9PwCaMeVVLz48xnQF2qeTix2HlKWRcVEsncLcdrvTEitOD0kZWtJrI1R5XAS?=
 =?us-ascii?Q?br9EX7QXegJDDMuWDC88wAimPhZgldJT6WLurEYE31KoXrzknTEsjtzF/Npq?=
 =?us-ascii?Q?t+uujKyckfUk4AbJhmSSIJdYfpctnMWMYEi/SlXlPgFVolgdkmAFzuhTRaIB?=
 =?us-ascii?Q?lbSLcpFCTeP1t6ubefjjibhK9nUHIJcK2GVLGCqOgTwxnhgRzXBcdJxOaGPx?=
 =?us-ascii?Q?5nBHFmRXmmxsyujyhb0RbCyCvvbKQ0RAKp/ieFLLaNDUyb7+6HfYxHslZo5V?=
 =?us-ascii?Q?mk4yka6ocfYSgGL7UQBna8LkjFe6hx8CH2C7DpF6xwLdS8illbl0x58dueHI?=
 =?us-ascii?Q?IYPGkgVeXzx+DnIdx8M3svpEp3BYHOC6g4VTj2CZFVkrFgt5TfYjxJDH6onn?=
 =?us-ascii?Q?2s/bKEBRcYx+K9RXyvQogqSmrObAqw9jrIaD3339C/2t6JLB4e7o8g0dd6A4?=
 =?us-ascii?Q?c8wptS0FqxObUD8JKCdsNP3JrhTmGPfax9wVp7ByB4TMpGscPqWI8+KoWwg6?=
 =?us-ascii?Q?shGCaqEfom+7WQU4Ym4olybKTe2Fdde6A40KWuK3zTJSFOLZttzVm/Vy16Xw?=
 =?us-ascii?Q?wAGtugqm2gmmX6u1R5iS2viDwklHOui7rhLuhlYna8AtIrg+03uBmnnoLA1Q?=
 =?us-ascii?Q?RZA7mkYt05d/dV2OFcWa7Tgk9Le2dxITvfoIgFeWXdExBpYzz155e44s+KfJ?=
 =?us-ascii?Q?WOGVaFu3dHAtDTaXLrTcKGJ2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8666174-6536-4539-9033-08d925f18e97
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 18:09:26.0314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFZpXywWizMlXmPCZgwMcfwiqtBjyd0lO4XTOxDVp2Xrt7ZdmIxGP3XtWpq2o6PR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5272
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 12:01:11PM -0600, Alex Williamson wrote:
> On Wed, 2 Jun 2021 14:35:10 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Jun 02, 2021 at 11:11:17AM -0600, Alex Williamson wrote:
> > 
> > > > > > present and be able to test if DMA for that device is cache
> > > > > > coherent.    
> > > > 
> > > > Why is this such a strong linkage to VFIO and not just a 'hey kvm
> > > > emulate wbinvd' flag from qemu?  
> > > 
> > > IIRC, wbinvd has host implications, a malicious user could tell KVM to
> > > emulate wbinvd then run the op in a loop and induce a disproportionate
> > > load on the system.  We therefore wanted a way that it would only be
> > > enabled when required.  
> > 
> > I think the non-coherentness is vfio_device specific? eg a specific
> > device will decide if it is coherent or not?
> 
> No, this is specifically whether DMA is cache coherent to the
> processor, ie. in the case of wbinvd whether the processor needs to
> invalidate its cache in order to see data from DMA.

I'm confused. This is x86, all DMA is cache coherent unless the device
is doing something special.

> > If yes I'd recast this to call kvm_arch_register_noncoherent_dma()
> > from the VFIO_GROUP_NOTIFY_SET_KVM in the struct vfio_device
> > implementation and not link it through the IOMMU.
> 
> The IOMMU tells us if DMA is cache coherent, VFIO_DMA_CC_IOMMU maps to
> IOMMU_CAP_CACHE_COHERENCY for all domains within a container.

And this special IOMMU mode is basically requested by the device
driver, right? Because if you use this mode you have to also use
special programming techniques.

This smells like all the "snoop bypass" stuff from PCIE (for GPUs
even) in a different guise - it is device triggered, not platform
triggered behavior.

Jason
