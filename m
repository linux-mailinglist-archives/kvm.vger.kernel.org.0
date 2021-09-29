Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C729F41C48E
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 14:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343771AbhI2MRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 08:17:38 -0400
Received: from mail-bn8nam08on2073.outbound.protection.outlook.com ([40.107.100.73]:60961
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343675AbhI2MQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 08:16:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWyXWHyqkuIXmkZFx70Fz4WOFKRPkgsrLUPurhEwGZ/PkbZWaQinUJQhtaUsWhZSGuO3w1i7QLCzbcI7JG0HQ1M38QghoQ7PnXwLDUi4sVWt2RmvyEL9DZRkR1K7uWw1hSfVQ15hDI8KKSorTTNTnEGC1OkFbuXqAAtHZGGJ448Y2zR/8R5y1nfJuhYR9ADGHotDFNif/8+MynU2DyAWIVQMNYG4Pm1FVjmn/UQ/fp5khC/PYikmn6egw+70uG6wruFFhURMEGolf72FY49iZM8gM5iFkuxxegmAwfvO68Fwq/q7eLLspHVxyiYkiS4nUAw8u4wBDEEry6YecCS0YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=M9ci2mDogamEBptGuYbYNBcAL2Pfd9fjPMMMnqowemE=;
 b=b6na8DA9y3VHr4isxrSpuaPzpPn+YrKknaZ3J37Lv1DaCygZAM8YbJGvHhKjoEsz8oO4Ic6UllT8go/vcx3tGYL07SItwmKBcPKlyLQ9sfw0fyqrC1oJdwEOHjCz0G2Rr64HXAqajXtJ+sqPxGhDoyFbce7le1cDjXHrtnDojhLVYaew9+2KevWWEkMc7NY4tPX2Wy0bdrRx4VZzFtqORlUwkOU5mK2nKOxNvxm8cHW5ldhycGoKNf7IAJA4NGQyX0pLm3QDHrJu3GqPM6Un+sT9fPDsF6QLjFqZSxrtKrhB3HbYXHT8DFZf/ehz9Zf+FrvkuKMjbofXEsCBEZVPKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9ci2mDogamEBptGuYbYNBcAL2Pfd9fjPMMMnqowemE=;
 b=dV6WCmCOquBGz+O6XSWNmgk6fPxT390MCgk/id4uPlrTkmjtt0JU3bbXWO6xHRsEKWcciWR9tpo3k1yrocrcmQSyJfW1NMkcBoPOJIWToHuazct1kpM615PGw/7dRhNLGy4H9dxFAp6CWaMwSWfGDGRREoa17/tARLPHME1kU7oqgj9FhNgy5KrRR31M7yizA/fRXZtmONV+RL72A8XJYIw95FY3RSz6431+CkDDEY57YXWL5wxRgFzFDhWa0jViVZAWuuQE3emql79vUDDqanHTwAslvJGnZquPMxGJI6c1Rh2UISZRYynO1NRQRCA4990hYAXlana+hjlFe74uOg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 12:15:17 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 12:15:17 +0000
Date:   Wed, 29 Sep 2021 09:15:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        David Gibson <david@gibson.dropbear.id.au>,
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
Subject: Re: [RFC 03/20] vfio: Add vfio_[un]register_device()
Message-ID: <20210929121515.GN964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <YVPS43bNjvzdxdiM@yekko>
 <BN9PR11MB543356CD7AD9F45793D1ED118CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <871r576eqe.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871r576eqe.fsf@redhat.com>
X-ClientProxiedBy: MN2PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:208:23a::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR03CA0027.namprd03.prod.outlook.com (2603:10b6:208:23a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 12:15:16 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVYUV-007YUZ-Oi; Wed, 29 Sep 2021 09:15:15 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29cdbf0e-eace-4f8d-53a7-08d98342cc21
X-MS-TrafficTypeDiagnostic: BL1PR12MB5175:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51750B2E0195FC973BB0C58DC2A99@BL1PR12MB5175.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: stltqf/tyTENBn48sI1RjToh2XcQz2P6uZJn6deRZrzwFcvA1U+7qpVnot4j10LkPHL7WBsHLw+jauWQYEi6AO8hN/39wAeysTYjvQPQxQS2TTHR/GpX3ZG6DPSsNWQiNJIqlVdA2xCTTkp9nhMQ+EWHhznmpQRuGeaAj1hnjPNcPWDmkdoPQSI3byDnhysqBq/jCyKy3KVuH5kCheGICb7vBG3msy+6Qhl+WFtWdVdZBnHaB+TWpszlwqurb/wdH0cLwAZvURNaJXS99tei7Uf40EfEvPX7mWgiybjnv1CNSEsMiMXE9UK314csZUtfWxB3cH8iM7t4aJNDCttkpdrQrSkNMffdeQWGJBMaxrwpo7im/jy4fj5fsj9Y1GR3fuOgbX8Xdi+qEhDygGYDOlfSWFCkaQ6GsMhwGOVeyDbWbPXxNelbUYOG5eLQI1OiUWggXhNL9jW5y0b7eZBSCEt4JoRK02MhoBBqNU5gJX011RRk034oJzeLQabsM+uaFFfWay3aL/07IlCFDz3AcISdjDVXem9LJ2/i0ZCVZT4JWKYpRtuLgikqmfv6bXyDy0sn3ohy3WFDCMI9c5Xw7XusoayZttPF8Pu+nfNos//ehTWJ8rcoEmXs97xOZxx77B5IkW2xa5ibFPSUhVyf4riFrhpPM/n0qh9qj5u8i/G5u5nJlMIC8gaRZJ1l9x03
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(426003)(66946007)(66476007)(316002)(4326008)(508600001)(186003)(107886003)(26005)(38100700002)(36756003)(7416002)(9786002)(9746002)(5660300002)(86362001)(33656002)(54906003)(6916009)(2906002)(8936002)(83380400001)(8676002)(2616005)(1076003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ncATi2Y/2ikXDFPo4IvgpZj+NcwV54K4e3WtKY94PpZHVEJI3zFjITcaaXSv?=
 =?us-ascii?Q?KJoz7N0cbU8BBKyhnFSkAfLUNAlJ77R4DUVZ0khIAlC+uyV1d68iiaUpwpw8?=
 =?us-ascii?Q?duXzQAoLecarMeNu0j1W7ZtVSUfmMKgNdqhIxF7AkzG95oZPWiDrWOOk1ys6?=
 =?us-ascii?Q?m3rvSzAFOpQCFIlLyMQ1YO7LeetyD0j5AxIAUuchMkcaJ80MXkedpkZT/Cbq?=
 =?us-ascii?Q?GKkv0jrUnhDHh6z71lzMhPWFayUjxs0VhKu6G5H85RBX9cxfqNnOfe5uobX+?=
 =?us-ascii?Q?JaaAUI8At/1Alt3vn1cD9S3H3y/AzKL+DyZc9ipQ9t3rlhidKTRP8bD0PNCH?=
 =?us-ascii?Q?42mAlhyOVMNRzaUKDxhVaP1p+MD6WH1m65Cy73Az8Lw5Qua662q/TgIhtoVC?=
 =?us-ascii?Q?aUEDPaDfUot+NvT/zGdNSRnrDmLgeeg3NWVX6hYssN9TJuEFxpYJINLY3VYa?=
 =?us-ascii?Q?aTXM6eYcftD43ssJHQnKTQmpRBVAFXMUNAdYlaRofRKVPfuiadAS45UC4lWm?=
 =?us-ascii?Q?rlFGHaNzRBTKvG1fgLD63D5WN7WimRrryBTf2WqCWBtz10aPPpDN6YjMKVHD?=
 =?us-ascii?Q?uQ8Dx//czBCMYUmQyckls4S0AhcahaULF9F5oe0SETN8wDdMrRDfIm3DSLDN?=
 =?us-ascii?Q?qICECsqWFWqrPBNxPyE8mP+U6tV67yKuiQaDWpcGHCVMRutjerugrOoifr1/?=
 =?us-ascii?Q?pCjyC8HWzytoU0cq6iaPAaApy9+jHj4+2LzGiss5ul368Y6jZHsyZBs/FFhZ?=
 =?us-ascii?Q?heBlkUEuPhlh/0Lhs0dNodTpsUsD+6dA+s9tJ7tGhjIMyEOyh3CQvflYrl02?=
 =?us-ascii?Q?iUdJVtr0MOi1ZPYauwfvCVl4HAUfnvUKTTn8HeF/2IFw21qXTh4ZYtkylbgu?=
 =?us-ascii?Q?jFBgI6Mjw81+bt+o34Do9aQVR6TQXE+SW3zh5CGb/Fl+kidhiIBeKkKgipMW?=
 =?us-ascii?Q?r1GVIglalD7y8m3h4RXC8mCH8KA1OW33MCUY1K0H3hOxEvq1qKp8U6L4+CE7?=
 =?us-ascii?Q?6QhDcuLdxNVno99pXkJKbFEXB/SNmSB5rtYQKzzeLXJIPxdiRe6Dw2+VU9ot?=
 =?us-ascii?Q?GPo1V/rLE2QyutcraFaFlMETnDQYJ4BKgyYp9QrhZtTh3idfIWHA/xNWgCaz?=
 =?us-ascii?Q?RLf7S7hm4z3uHOg1LcfgNy+e9PCNa7LvIe2aY6HbfuKIqf52eDBqw749LNpU?=
 =?us-ascii?Q?70LV/TmkC0K+gssvmesl65ADz04z1iwqSXYGHMIN4oH7c2RunxUCo3YECFdy?=
 =?us-ascii?Q?1nabYcKR+KwfkwLJSondd7NQ/2l0Pf/rONaBhx0uvLLnr63zdS8AvCOLxfCP?=
 =?us-ascii?Q?3GVC4Y/wcPZ+xi091qsa9wJF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29cdbf0e-eace-4f8d-53a7-08d98342cc21
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 12:15:16.9484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+D2hjJsEzrvg3Cs2J66n8cQB/8tQvblYQWeyOFxFtFlmyt76Ru0RSc0mxfmItGY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 09:08:25AM +0200, Cornelia Huck wrote:
> On Wed, Sep 29 2021, "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> >> From: David Gibson <david@gibson.dropbear.id.au>
> >> Sent: Wednesday, September 29, 2021 10:44 AM
> >> 
> >> > One alternative option is to arrange device nodes in sub-directories based
> >> > on the device type. But doing so also adds one trouble to userspace. The
> >> > current vfio uAPI is designed to have the user query device type via
> >> > VFIO_DEVICE_GET_INFO after opening the device. With this option the user
> >> > instead needs to figure out the device type before opening the device, to
> >> > identify the sub-directory.
> >> 
> >> Wouldn't this be up to the operator / configuration, rather than the
> >> actual software though?  I would assume that typically the VFIO
> >> program would be pointed at a specific vfio device node file to use,
> >> e.g.
> >> 	my-vfio-prog -d /dev/vfio/pci/0000:0a:03.1
> >> 
> >> Or more generally, if you're expecting userspace to know a name in a
> >> uniqu pattern, they can equally well know a "type/name" pair.
> >> 
> >
> > You are correct. Currently:
> >
> > -device, vfio-pci,host=DDDD:BB:DD.F
> > -device, vfio-pci,sysfdev=/sys/bus/pci/devices/ DDDD:BB:DD.F
> > -device, vfio-platform,sysdev=/sys/bus/platform/devices/PNP0103:00
> >
> > above is definitely type/name information to find the related node. 
> >
> > Actually even for Jason's proposal we still need such information to
> > identify the sysfs path.
> >
> > Then I feel type-based sub-directory does work. Adding another link
> > to sysfs sounds unnecessary now. But I'm not sure whether we still
> > want to create /dev/vfio/devices/vfio0 thing and related udev rule
> > thing that you pointed out in another mail.
> 
> Still reading through this whole thread, but type-based subdirectories
> also make the most sense to me. I don't really see userspace wanting to
> grab just any device and then figure out whether it is the device it was
> looking for, but rather immediately go to a specific device or at least
> a device of a specific type.

Even so the kernel should not be creating this, that is a job for
udev and some symlinks

> Sequentially-numbered devices tend to become really unwieldy in my
> experience if you are working on a system with loads of devices.

If the user experiance is always to refer to the sysfs node as Kevin
shows above then the user never sees the integer.

It is very much like how the group number works already, programs
always start at the sysfs, do the readlink thing on iommu_group and
then get the group number to go to /dev/vfio/X

So it is already the case that every piece of software can construct a
sysfs path to the device, we are just changing from
readlink(iommu_group) to readdir(vfio/vfio_device_XX)

Jason
