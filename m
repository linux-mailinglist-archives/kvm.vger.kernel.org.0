Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B023945F7
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 18:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbhE1Qks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 12:40:48 -0400
Received: from mail-dm6nam12on2085.outbound.protection.outlook.com ([40.107.243.85]:26881
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236075AbhE1Qkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 12:40:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxZnV5B9errnbfPsgkhbU7tGrjUP8HOwo2qouiQHyjMhiC1kQ5F231XVOevW0Cimvae3of1tJ8lcvq+UNMgwwMWnrAH/IkqnebjhwbJJVU2PMIlFrFm1n/NdgngGuRgsn+lzBaY8w/4wLYTw46+sS61oR0XYZlB7kmVn4yD9JL4+q72zPISdwiitzuZJJV55GOUjNkAuv7LhCaEQtMn+wkAV6SjCt5tsmuUqQLkxzobF790powmsgk/VBv411IyHxwxhccBoTdhnoK2tJ343/fHz9UsUk1frDTVHlMUQlvR2iWmWEbZ4eoD6LIXjcBwlMdZ4zDIm69i+eSgLVoFfVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Akr0HKB1vSePn03V27ldh8KhcfgygzUeQbOZD5qqaw=;
 b=HkqdcIJlJhFmRB/uNBFSRGTOWb+zOrdCoGfIyt0bpsfM1H1TvP7gdJW6vhGBISsvI7C8PxCSvNWWS24+AGxA+jwVMKF5P9h30mJ15Tgj6Us2jqlLON0grmJzatGQlf5Nv/cK1DhNddedfphWCNzIsmjlWzeQL1CjgKKneDmw+baJd/zbR9aiv04/HBG88hqVSoHmTjKAbSI414fCpBvb7ct8LAsTo1aOSgpG76LDiXxqGW1bIU1VqcmmSV31vd5hz76wW8Qc6wxY+JDVlXmxomXlfWdN4boyqLcaoq7CwdHDHa9CRvSfyqyC8dYBuAGCGYhgfG4FBCKZ1FsszInqcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Akr0HKB1vSePn03V27ldh8KhcfgygzUeQbOZD5qqaw=;
 b=Sh0fB+AlbwM3nNHLwfjqHZyLCGDdOzNfUfaG2Y5WVSELWSbI8S16ppSxCQ4adMdfNEyaDSTNA+oSSkPQF2iUkQHjtstrKBMJA9lDtyIJfNtGbzse013I6UH+TzKVoy8ub0BcCFDPotNQHRxngmdZQ22bSBe1PIA0cBEDeizNv+tZKbFqHlP+gKOURE7BX1HtjctJ3+/H252C4HA6TMbNAZlFG8iPihwTPA2YZtUBDund7+e0i99gA3N6joGnnha9ZceopPoPL/mOtsSNMEwMXndDYhd/LqB8jZgbx8/8dQ2qH2Ngf+W7Lr2OdPw5Wrb8oubaQCn4NOFSvslWKKv7IQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5191.namprd12.prod.outlook.com (2603:10b6:208:318::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 16:39:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.023; Fri, 28 May 2021
 16:39:08 +0000
Date:   Fri, 28 May 2021 13:39:06 -0300
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
Message-ID: <20210528163906.GN1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
 <20210524000257.GN1002214@nvidia.com>
 <44ba4c5f-aa40-3149-85a5-3e382f9c2eae@intel.com>
 <20210528122145.GK1002214@nvidia.com>
 <b0932f3a-4337-cb69-242d-b91e8aba9196@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0932f3a-4337-cb69-242d-b91e8aba9196@intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:208:32d::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0054.namprd03.prod.outlook.com (2603:10b6:208:32d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 16:39:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lmfVq-00G0KI-QS; Fri, 28 May 2021 13:39:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 401a8353-04ed-45e6-a6a9-08d921f71d56
X-MS-TrafficTypeDiagnostic: BL1PR12MB5191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5191C820023D9E5F6539242BC2229@BL1PR12MB5191.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nSt9S9fPuZ+sCAMmM232SjJ1eXYvPYKG3BYyrncR8cgPtCxJ0ZNnYBQ0Yk4tgVqBE3ekn89IIbttjE3flg+VSNf1imrnV7w4ghyEt5zaqwhOhy4/I2zFklX7B23KGwxRzD2Yc3irJbGYRdMyJnC9G9P2glLGCgcuPCLRvY+VpdN5rzoRKThKwieiYAlGsjDtE5a33tRW+i2+0izTgS0ybVnBp721GUWNAElLAlOcfCFASPjV4lDd7AphFZe/QwfaC1CPNOD4PNnvZbhSyo1Pbzks/z+AOgNWWlzpai8F4EANy7tCI95xBGgvHxbXFcEos/2EwlTZK3LcR8omgeMObi/iZwASOVLkX+8GmLeqAtWr8/oPk1KdGc9qhGbKix9nvN2Y+3OZtAIckaNhES3KNX0cK7E2TBNkAIXqujXfaaR2vxlAuCltLxACGu8ld0GIMYAdD7kzGvChSU3zeqH/wFi+JvZXdKRD0hZ3wmROl474ElrugngeJMIV4Ev5XI71E+UYaUabKg9F+dISg12cGBNVRq0Vj2avIx8HSMHoJqF3lBXs97tv5WSso/6EQHFSjWp429ppx27fEiogpVGRfTRidov0a1SW6X7MAOGPnc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(478600001)(426003)(53546011)(186003)(9746002)(9786002)(1076003)(33656002)(26005)(36756003)(316002)(7416002)(4326008)(2906002)(6916009)(2616005)(8676002)(38100700002)(8936002)(66556008)(66476007)(66946007)(83380400001)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qNBgXyQ5qgDemlqi7rUgoWPHxDUnVsmwmAYRKAwBEEYB/zDzY+X6e43NAQLj?=
 =?us-ascii?Q?x9qGtUkVqhmPAZ4SYQV6hyZPKjcA10XukGxf3Txa+cUILlfaOIX0dV0LmBQ0?=
 =?us-ascii?Q?bR0wvBkgBcDueTf3zf0PPGXXzJ5Fg/ydltziSXx/VuCwhnIIAKWt6gikMmbq?=
 =?us-ascii?Q?q7nUY63zTo00sIapoxk+c0AwLced4V7DL/IEFKcoBubhvCBw88vnssxBVlE5?=
 =?us-ascii?Q?+/+JiDQk0/28h+Sp+nWNbvW9dZsx+Twlb7USYfdoWwlcEy5LhOKh5TIw1W+l?=
 =?us-ascii?Q?FZy2ade/lW4YVb0uftdwv8MzrYiAfGunjjtPvchleaNV44C0/fOabxhTds23?=
 =?us-ascii?Q?e9JBxx3KvVv3E/HWQfb9NQqRv53kH/P7uxKuu0wkNJZn0JfvjsB1XA12wne9?=
 =?us-ascii?Q?K+VwW3ibmZ6D/wYAq4ijJdStd328vHpQsscYb4GoFepymHRHNqB1x4BeVWAM?=
 =?us-ascii?Q?KieAhqGgxmyLxzwqLV5G6j/eLpJ83bcspcNZqw4+sjXGqtm/ytfrGwq13MTg?=
 =?us-ascii?Q?YLKI10cxk5Vgb+RMGyN0enmVqMDt7ZnZKVpwp6Kxe74xCojUtOXcqNPgO3zL?=
 =?us-ascii?Q?30m53NWrcPcb2R+YBmu6+iwpcc5FWryCDjiM+W4uqCnC4caqAz4NbLtCYAXX?=
 =?us-ascii?Q?UiLBhCwTobeSZYoPVG8sRPGZL9VdTT2hr8rtm91sk/+pl2aLnrC/K+CyI/tn?=
 =?us-ascii?Q?+k2+2q4Hqlad67hbSMJpVQOcipMPAhXw0kIL+qfYPDRGdLUlxHUoYhdxGp1X?=
 =?us-ascii?Q?IzRUmLrSonG4zAigAQ6Kcwx6BISpRioR1pPaBFwbx87K97Aeh1oKBp0wJHxZ?=
 =?us-ascii?Q?r8aIgakPJHYKKR3qpkHGG5lC6zTszrZy5KwRmz/gJUAcaZ1IJQlLnf0P8KZT?=
 =?us-ascii?Q?sSl/l3X/MoshWYikX2KmWOxnMs8dD5X/pWPj1ksd1z6afsYCIUZevOhDkXNK?=
 =?us-ascii?Q?VSiv98/cy24yThKc75YtmlHf9kAEpHsIAGrdmZ6uWR65SNbHhpmOXREr1taF?=
 =?us-ascii?Q?Z5UDnNCjO0yM8XQJY/rzD5BZxi3zvOusNEaovHXgyl82M6a1VDl/e6iUjlkn?=
 =?us-ascii?Q?osCO0jLXtiefIVpLmvkZDmrsGXjNVCl67JfeRiso5nQlku3fEfaTLYEsoV1A?=
 =?us-ascii?Q?gMHKyoEy1lfdc/GjZ7p6OMXRxskMo0t3+sKi2+pCp8dKLj3YnE8YgrDlGrcm?=
 =?us-ascii?Q?HUR5lwPxQIcMcVP2ZTlq+qxU1QEWXsGicnNllXuKZCNyn4tluFPR05a5l1FJ?=
 =?us-ascii?Q?XIFYdUVS4i2XYF/VSzL3rIQz81aMk4OpueLwzfe7BtOJSlS9ExD0bnPfX7k3?=
 =?us-ascii?Q?nKiOUFlUEZaFvNjGhyjK95Ie?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 401a8353-04ed-45e6-a6a9-08d921f71d56
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 16:39:08.4483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMb74dtJ/lKGuBeKjGInvAvM54q3NRZ1UJN2nrPi4SMOYluRAfRRuywn1O/izUKx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5191
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 28, 2021 at 09:37:56AM -0700, Dave Jiang wrote:
> 
> On 5/28/2021 5:21 AM, Jason Gunthorpe wrote:
> > On Thu, May 27, 2021 at 06:49:59PM -0700, Dave Jiang wrote:
> > > > > +static int mdev_msix_enable(struct mdev_irq *mdev_irq, int nvec)
> > > > > +{
> > > > > +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
> > > > > +	struct device *dev;
> > > > > +	int rc;
> > > > > +
> > > > > +	if (nvec != mdev_irq->num)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (mdev_irq->ims_num) {
> > > > > +		dev = &mdev->dev;
> > > > > +		rc = msi_domain_alloc_irqs(dev_get_msi_domain(dev), dev, mdev_irq->ims_num);
> > > > Huh? The PCI device should be the only device touching IRQ stuff. I'm
> > > > nervous to see you mix in the mdev struct device into this function.
> > > As we talked about in the other thread. We have a single IMS domain per
> > > device. The domain is set to the mdev 'struct device' and we allocate the
> > > vectors to each mdev 'struct device' so we can manage those IMS vectors
> > > specifically for that mdev.
> > That is not the point, I'm asking if you should be calling
> > dev_set_msi_domain(mdev) at all
> 
> I'm not familiar with the standard way of doing this. Should I not set the
> domain to the mdev 'struct device' because I can have multiple mdev using
> the same domain? With the domain set, I am able to retrieve it and call the
> msi_domain_alloc_irqs() in common code. Alternatively we can pass in the
> domain during init and not rely on dev->msi_

Honestly, I don't know. I would prefer Thomas confirm what is the
correct way to use the msi_domain as IDXD is going to be the reference
everyone copies.

Jason
