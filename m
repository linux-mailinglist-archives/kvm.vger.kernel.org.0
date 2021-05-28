Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE53D394276
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 14:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbhE1MXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 08:23:30 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:16481
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236574AbhE1MX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 08:23:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Te64JIgvzqVthucF1JVQL+a0aSVwPqOZI16OACOykLT9zPyVjVDrX0N+Nb+8qafnQwpKm4qSE70WPwKrvoOXLMBVFqqu6BR6sVbaQd4X/gEsc86iF3T67aRfo8JUcZBI4viHguxpfraHsAONhf/XosbYglYzjnsS3j30vDOWzc9aKfIh/zSVlisSHRx0jSKnOSn6lIHHqL4k40wl2lZMOplIun0xgVDSR2u81uV8vLKOQaTFDjk0vLjZKFgGS9P5qrImyMqatG9cIRKXtyCRn/H9AJIhJvPM9XJO6Ai23Pecx5T4k90kTZgsGJ2JhAEEq4z4YQx44taAjZV9iW/OEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfyGvAHTi9HFWuUHBfM35gB4s+ma396GyEnIpko7hQk=;
 b=V4DfLpw9mDX6XTtNCLpMIN9ubapUzxyXwUwG145iIrU5V8tcdthl7WjOrX+OFkxzP7m07e6lNsZjm1sHsdtQK0PFrgZQh3kH8tsIcBiiA31Mg31t2TBEMWChd3C2UNd/kO/Jf7MXUI3VmXyL1Ka5e7lGFfPQ97i0ZW797ZLliMCNylxnPOY6pGUYO+P9K6bn326ZN9TEUdGp1a+mc9ldeVTm+g0TwwvYuYD6N8F12O34Qm+Ubrs0Lipbo8AGxTTmb28kXlAhz9Jp/Je8flPIJR87iB1XNrCKP6iZUzUV/i9+LtbMwr+6X2C2uzUAv6fTdgFhwfZe/iWXHCy+VxKRhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfyGvAHTi9HFWuUHBfM35gB4s+ma396GyEnIpko7hQk=;
 b=AsyhFMXSJq97QsBQ4l4AwBO9X4cfXYVwzos1bZ4cFkJq97jWjOuHyw6AbXmi7o5tlsraDVr398g5itvUbx9fJL6HKKe3ab1eBu5zxXY4dSoiAZ44BJdy59mnNt2E15Slb/8pKKzLKac/4pISenA1x3nxpltSaCcrlWO2aVNm3aucNct2tiYkvA7RvE7KzXM8ZIpRe6j/gsRhVfD0ifg1Xm9G5jYKJDX5L2fGUFyLQjNcNsTqySNqQFf1HjO3XrCNsMZGu4f7uYPvNKxIrTTCNXjkzdT9ZGC1xeUJ83oWoWcmo9IxS1VaZO0+t3Je84YIffyP0nLddk3cueMV7jupOw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5158.namprd12.prod.outlook.com (2603:10b6:208:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 12:21:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.023; Fri, 28 May 2021
 12:21:47 +0000
Date:   Fri, 28 May 2021 09:21:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up
 Interrupt Message Store
Message-ID: <20210528122145.GK1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
 <20210524000257.GN1002214@nvidia.com>
 <44ba4c5f-aa40-3149-85a5-3e382f9c2eae@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44ba4c5f-aa40-3149-85a5-3e382f9c2eae@intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR01CA0005.prod.exchangelabs.com (2603:10b6:208:71::18)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR01CA0005.prod.exchangelabs.com (2603:10b6:208:71::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 12:21:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lmbUn-00Fvgv-9G; Fri, 28 May 2021 09:21:45 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8e8d6d0-f68f-49e9-78d1-08d921d32960
X-MS-TrafficTypeDiagnostic: BL1PR12MB5158:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51581380500EF66310713060C2229@BL1PR12MB5158.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yFdkc6EuJd+3P3SWWOw+yOQR2Vd7kwujLIpOldY0z9vj1fsj2ENwO322jyXE81PNzda5KmU0bKjJQWBBdhrE/R0n2tsDwxXZ+dISuFtI1i95Sui6H8x4pCBMcGHh7AHk4+gJZ0E+fWA3MR0ZlmmKUEmW/dwZRD8NRJr71PAI6fNlsflraeCb4oYKSQy6YRZ4gyCSQaWOwszrMSeaC5Y78q2ikeN6CCdqsnc11uLSKQEoP43cboTTprqbm2DFZ0uWB8O3SMo01ZoGmTtgpl2w87LvWiKLjEy+8fJfptAGUATOlVNs0Pu79KkFgvdaRfNWiwdFJBCxDOvxxIuJhkzE7PapGBalOhtD0VCP6beWvtj12/176NMDUAib5PgUSWnjEbaLObh2S6cYQImWLOXe0sjMr7cTeDNH155Gw9ham5FpsWhfpwx5rQpmqDtqF2Q6n5/WATtpmqxSswZUK1N+8zqOQWVhxjUOoqw2/d25KxuAVugAm9alJcMs7ZYNFmCgZYg/2QErmWrwoCfUgH2JoRu+z1T+ePIJbuRPC4HEBfrfFHC8xmYlUfuWoXAtFHFE7/pUnItJdEJV3Zc1919vxHCETeGIkvQYT5OzUlYunVI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(4744005)(478600001)(7416002)(38100700002)(8936002)(8676002)(1076003)(426003)(5660300002)(33656002)(86362001)(6916009)(66946007)(66556008)(26005)(2906002)(66476007)(9746002)(9786002)(36756003)(316002)(2616005)(186003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jK8sIRKEUy8m1xy0Ag+FF/BXukXfnn86LomnSyhO6tBotXitkVKuvYwuob4j?=
 =?us-ascii?Q?4qz7n+gRQaFivFWIfRfTk1jbMvm0S+qsWWD4PbKIASCCKpbli5uguDXXJp60?=
 =?us-ascii?Q?2NkGceps8THcNcmLLcaFVdJCacJmhceBbSOgRSaX285yto4EggpxXDc08g6b?=
 =?us-ascii?Q?h7arxYW17VZX5Q/R8HFIkCVfgZPp+J8AiR6N4Ttc35c/2/IgdEX40wEJSDav?=
 =?us-ascii?Q?mn3ImW4kjHXmW4Zt1/2NSHPA3/+ELTlVKpyRi+h+7O396SSNZ2yp6RIgUbyL?=
 =?us-ascii?Q?UqykVEFt92sQlLHAljz9xujrxRbSaXlVmabFtwEVPJYXVwKZo10tEudrecuq?=
 =?us-ascii?Q?ML1RSdNvCKEHaQ4tGZzVm9RjLl3FEzn435VmipgtVlPAoOHOBUN4zoB8r1t6?=
 =?us-ascii?Q?h8WO0SR2CAx1MCZCQ0sjxwy3olRVKOm3NREF1WAvAtXlRr63kOaCLAAIpB2A?=
 =?us-ascii?Q?JzbdfbWqrlyRoW8MSWcVTNIAG0B50iFZQVkjwtf/N38TVFPAC0C8PBxEFuW8?=
 =?us-ascii?Q?LVdgMh3vF/7xUxYbgNdIDaa7XrhxqvbIVSWR/ylTeERDF1e1lg0AXLFh6zal?=
 =?us-ascii?Q?36s9wRLy6aM6oRVthGM8b/KAMlIHmzwAw0BQdhvscqzTtDEh/6Dcbp4MtaeG?=
 =?us-ascii?Q?OP1RmnN5qTPgTHOVfPTgOhFKGi44Vf/JxYnzpq1Cvvpv9AOspXtsWmvWeruG?=
 =?us-ascii?Q?Q2sJQy6YCHSKy9mUvYS30SmRB2los1t90+c5cuL9JEePw16DssYG5uDEG1Mt?=
 =?us-ascii?Q?X/A8jRKgwmBOZypr5R/VSoIYF/AW1oGb2K3ozy+Fb1yAubHebhYbkSwLgbUS?=
 =?us-ascii?Q?uWrPJ9iTeH/zS1gJ3ijBuPPHcR4ALQdFOMvCs/K6wuY4M3JRr3+D43VyNCis?=
 =?us-ascii?Q?vsrETjnuwxTGcHoXcsjWtioYcJBm/kJ5ZuPdHAhC0QK8pQfrzJZ4i5JYyk2Y?=
 =?us-ascii?Q?zR8ZW0L7FoFkLvCPS4OFUb6SVFLlfB9j8cqLo5JyGxHx2BrOxDhgU3y+bxYD?=
 =?us-ascii?Q?03dogX/RaE7bTbIEadIiQbd/w4bEwGywJzhFvX+np5xUkL+qJcPKPLSBXYCc?=
 =?us-ascii?Q?+tVD05l5+crg7V6+CyZ8tI/C/TQiIgXtGxr6iGyvtevL58tI4D6wEPU9Sdj4?=
 =?us-ascii?Q?CcFh9VWqsE0mkFfebiQHLqCIdEzeDi+xgv7PCoK1vbRVX7aFWvwKgGtr/bkU?=
 =?us-ascii?Q?RWRAhrBaVDlCnHV5e0NMJyhpdht+r25mbbc+uafx2vQ+gmo8RafCMl+H5gPi?=
 =?us-ascii?Q?9Aw1A9d0e4BNUU/sgyHXrvMY9uhHA/+zmXRgwP/nxI1r/LwilSdOcZ9QPmrS?=
 =?us-ascii?Q?xJikZZK7+igdwRiknKxiQry+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e8d6d0-f68f-49e9-78d1-08d921d32960
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 12:21:46.8537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rGJvkAi+RQ4oeoKqxuJfRGdzEIZRvqrp793uOFRdOS594DkVzzxAXRMjq6RSieOF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5158
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021 at 06:49:59PM -0700, Dave Jiang wrote:
> > > +static int mdev_msix_enable(struct mdev_irq *mdev_irq, int nvec)
> > > +{
> > > +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
> > > +	struct device *dev;
> > > +	int rc;
> > > +
> > > +	if (nvec != mdev_irq->num)
> > > +		return -EINVAL;
> > > +
> > > +	if (mdev_irq->ims_num) {
> > > +		dev = &mdev->dev;
> > > +		rc = msi_domain_alloc_irqs(dev_get_msi_domain(dev), dev, mdev_irq->ims_num);
> > Huh? The PCI device should be the only device touching IRQ stuff. I'm
> > nervous to see you mix in the mdev struct device into this function.
> 
> As we talked about in the other thread. We have a single IMS domain per
> device. The domain is set to the mdev 'struct device' and we allocate the
> vectors to each mdev 'struct device' so we can manage those IMS vectors
> specifically for that mdev.

That is not the point, I'm asking if you should be calling
dev_set_msi_domain(mdev) at all

Jason
