Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5543426AA
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 21:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCSUIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 16:08:16 -0400
Received: from mail-bn7nam10on2069.outbound.protection.outlook.com ([40.107.92.69]:2349
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230394AbhCSUHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 16:07:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBh3gi3mfBbK37bMBXyRVq8ki1SHmOEJOKIY0a0CZFQZBmoipIksG6NMLTIEO+MWwQwKoIcDtdtJ/NdXtGaGoI5/P+c1Uy6o74CvUWEJEWAmvi2cFI/gbayl49XV8pWSGdXq43IEo1KfXqhH6yszbnxh47KFV4Wr/Euk4enm+9xi2s3hHXACdfDzdqurMr8V23RpJzEIKP51EvODUK8lpA0nOWj7R56z+96pseapeAaiqrS8Jl9zw12OZPZiBcKXn4O0WKzKziyP1usC6ytgdo0CpOwX2laDyRHXuuv0jlSjyIJHZW0OpjJ7EzdipD7hm/gERn1L/0IXU0ZvLjtRAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCi23VhKXEmIpDqQDZrgM4rjo9IfeNW6iS9ZYeIoy8w=;
 b=j9SpP3NVvWBlI0TrOyEiS2mecTb55RHmnNj07nikt9gC9ghnIVvIFOBoyM4f7MR8XayM3Rf60PfH/H7YNiXDn7ljyixu42EzruTwlDFT0nKb7SNBdZopEadIhWF227Cl9wZEeIG6XpSwkNTRXhiMPoTQoGRfjUPZjITD9s80pZomBT6heSWsCEyDqzV9HbtQ6H0iCemRRAH6n/G4/laYOzevgmjRrgRuZ0y31j1c52AEnn4A5m9OiFlCX3pQ5g021FSuHtSCNdl9xu1I/6Tes7UBbnXPnP3TtawbpQpI838MRfKkugIu/8h6mmeIQmdL0voTcjo95F4w2SZ8GNeAGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCi23VhKXEmIpDqQDZrgM4rjo9IfeNW6iS9ZYeIoy8w=;
 b=FSXkKWsjgKmppIsBKjh4F78bqqojXriXBqOUN2rnkd3MesLDrsA65HOSJeuGPnuCf7/RlxC3ya/Xpm9HIma80rdqJl9nPtvF8obgQoAGTwClASnM6NTf99TxP5uqRofwDKYAtCpzwIpKGCqaRqc+g0UH28D03zcHIdt7CmIHtBg7jQ8uyX6eIA6bpQT/+WhAjMnKKuLgeRt73WU2nlQNHZpUCQTOuqLbxaHH4KHs1Da14MoUUGNJrOgZ9XI3LKIL7JTU0DygAFn1ylVF5JtCrid6oG00QYPlQdO7DkS6v9tfDtW3lcT2il2v7b2HlMYYUssN+hvIZyzwc7SYby+bTw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 19 Mar
 2021 20:07:51 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 20:07:51 +0000
Date:   Fri, 19 Mar 2021 17:07:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210319200749.GB2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210319092341.14bb179a@omen.home.shazbot.org>
 <20210319161722.GY2356281@nvidia.com>
 <20210319162033.GA18218@lst.de>
 <20210319162848.GZ2356281@nvidia.com>
 <20210319163449.GA19186@lst.de>
 <20210319113642.4a9b0be1@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319113642.4a9b0be1@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:208:32a::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0111.namprd03.prod.outlook.com (2603:10b6:208:32a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 20:07:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lNLPR-00HPTa-0v; Fri, 19 Mar 2021 17:07:49 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e74607bb-8ccb-4295-357f-08d8eb12ac06
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267B779E809ABB8C39AEB5AC2689@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xUF7zyE4PbxtRBbh5vlJ7fbvw8LBpJkYrDmKrnNqTph8AZTVGle3TbopC6e3CaeYEoRibxWC+nMsZdWMTC/BL8+3J+B8VXvIpjBLb+6W+dQL36IYeLB8LMvSSn0G6oriTB5ktz/YMJmkLfB/LQF3Rnc0i261dXLl2DJHo6OFighJjX8VMQVH9KFMgzEZQ6CdWQm1dpVS9ttyeEmv/zWQmz4KGni/f/lRqacbG7TiID5zH6f0JMtlR2os7m/2Puip6FJPGfCL3hesJWFtFsCRhFfirbYyVd5BfkMcNDZQ8Lb83aJlJHrl2Imgs247IMsdqtefRpzNeC60br4denYHhA6JaFG5ZMegtHXYiln0C20uL7PA0WJfWOOWrvCO8vjKTLMls63l1kiP60vs41QYS8MPRG6Ts+1P1y7W5YSONKjLhMMa+DA6q68YNHEXLfzsvrrhMm/2pn6LarLpp70bjFr1EI2rrzBz4JrdJAePfDZssNUPaffe4IPx9dTlpOKHLhLWkaOEwXNqsu80DIoRZEBdbo9glAlCTKapB5vwQbFWRnLD8aQYwrZ+3ZnNvVvaYt36lvoxpPzU2tuc69POJRsoDBY3j6ystqq1Desqia6M8Q0Uq+F+GBEFc2EPRivkGivXnDE7l4/iFuGs92gb7t031JttMDEswbdUI1xSF/mFRg8NZrDL5BH7MDXfLi2u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(426003)(38100700001)(6916009)(316002)(186003)(33656002)(478600001)(36756003)(8936002)(9786002)(54906003)(26005)(83380400001)(2616005)(8676002)(2906002)(4326008)(66556008)(1076003)(5660300002)(66946007)(66476007)(9746002)(86362001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cC+TiYeZYjB+mPHA3CvVzxiBtaT4WmyzZauoALVwDX8l6SJ4ZXycmUYeuzSA?=
 =?us-ascii?Q?C2O7GRaGmioz3+fiKUFvPRE9fjZWoKVnbZXjvdSXr3XAaMyenkArcAdok/u7?=
 =?us-ascii?Q?rR1vz3ZrmcXFnvY6MvZHcMdng20qsicxJRsMZDxyAvHZWDot3brvoPFhnbLU?=
 =?us-ascii?Q?RyDa9/V+8b7dHGt7OKoIAYubQamniE0ERljeR4gkhErv35X05aSTgSY5xnnx?=
 =?us-ascii?Q?aLfuh2nfAI9kmT2G1S18g4B9O1GA6RayzJ7Vn4QwF9lapkWHaj0HTkQ0xGf+?=
 =?us-ascii?Q?Y6Bo0Pst7B/m8vYrgHysllsu/dAoI9AQYdGGyfBfCx7Mf0onduWBXpWaK0nm?=
 =?us-ascii?Q?VMrQOVXQaFIQc0TohLE/x58ZAbS5z6RJh3fERHilzvdkBbPwHM5672XaClpY?=
 =?us-ascii?Q?giMAnumH1BdD9yIk3fNTOS+mj3Rncbok/w2C9iAxF54HUTLfNsHYAZ7LWeLz?=
 =?us-ascii?Q?00xvI/yCtgLbr8Dv47GJ2FmrE8xstsY4mBsfPOkj8Wdvo+9QPwDonwZ5LVUe?=
 =?us-ascii?Q?C/Sf3YQOv6GUoY4IgFR+cDWGIz34XyInm1QPwP7cCdnmPzV0M0Iz/flmMGPT?=
 =?us-ascii?Q?k+fOS3lbAPuAMRmTepb7tDj6tPTWJPp4qIuLsw4KmZWD89ymbQ85E2+kmuJC?=
 =?us-ascii?Q?OlZH1ezV1ljHQOTS6CLTUiaGs3N1Ej8SB9yk5eve0ro3T70sSZprhezbF36p?=
 =?us-ascii?Q?mCdcg5BSuXIVsURH9X6RDtLfDkrLwmWxc9Ud9yb2NlK199rnJ19BsJQ7qm1F?=
 =?us-ascii?Q?pqQrLSPgMidOT7oT8LSJ9JPMp9Klt40tOrJWanSeAfo7+/ZhFc3B7jUJHWoL?=
 =?us-ascii?Q?eaVDZ83yOuhEXPoHubLR/BjrAeDe5CRqtnhxylKkTG06lbaazyrJQZ8xJ7Zr?=
 =?us-ascii?Q?UkiQNwYjZ1XCLS2DKgGVgjicNlcaBIOJRTUFidVsmIW06Nyn01/VJTqmdJWk?=
 =?us-ascii?Q?Uk0QPY5mpe6+X5stJLUCUhbKqY9HULiv2NTXVgP576A1ADy2Tci9WfT+h9rH?=
 =?us-ascii?Q?dufcaU4alLxKlcXoKRwCltzRGYmCbiuHGJnkbsC8KGl8Bzfk2bcY4TqFopMN?=
 =?us-ascii?Q?9ovL+G6PSTwPcvcK5ye28Yw/KdKQWu6ztwvocPhW2oeU81r2oXByDUxHLlTB?=
 =?us-ascii?Q?LCCzd97JPb99zYCLv1gPe9QpvwOkX/5+MT1BxPCsa1qqSL6JowoJleqJA0vY?=
 =?us-ascii?Q?4sFRLdzuh0tp0k4VpBctXcE4d7DXA4ZBS05BVZlbYW5ze/w8QO4abRrlbgrY?=
 =?us-ascii?Q?tuQAp0BVy+C1LoKMgLK5LO7Ksv6UfrvvMWwIiI+hMWYjoYH/Ursh3qdApFTS?=
 =?us-ascii?Q?6GTgGbW2f2j1tA5nvo1faL7bj1vBdUdgRoMW6Cks/I1QVQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e74607bb-8ccb-4295-357f-08d8eb12ac06
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 20:07:50.8127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /yEMwIEOR642uhQQaWc6QoPzGLMV0DrVvGVETjUTpXH/pdSR0wPDzykXLww7AR25
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 11:36:42AM -0600, Alex Williamson wrote:
> On Fri, 19 Mar 2021 17:34:49 +0100
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Fri, Mar 19, 2021 at 01:28:48PM -0300, Jason Gunthorpe wrote:
> > > The wrinkle I don't yet have an easy answer to is how to load vfio_pci
> > > as a universal "default" within the driver core lazy bind scheme and
> > > still have working module autoloading... I'm hoping to get some
> > > research into this..  
> 
> What about using MODULE_SOFTDEP("pre: ...") in the vfio-pci base
> driver, which would load all the known variants in order to influence
> the match, and therefore probe ordering?

The way the driver core works is to first match against the already
loaded driver list, then trigger an event for module loading and when
new drivers are registered they bind to unbound devices.

So, the trouble is the event through userspace because the kernel
can't just go on to use vfio_pci until it knows userspace has failed
to satisfy the load request.

One answer is to have userspace udev have the "hook" here and when a
vfio flavour mod alias is requested on a PCI device it swaps in
vfio_pci if it can't find an alternative.

The dream would be a system with no vfio modules loaded could do some

 echo "vfio" > /sys/bus/pci/xxx/driver_flavour

And a module would be loaded and a struct vfio_device is created for
that device. Very easy for the user.

> If we coupled that with wildcard support in driver_override, ex.
> "vfio_pci*", and used consistent module naming, I think we'd only need
> to teach userspace about this wildcard and binding to a specific module
> would come for free.

What would the wildcard do?

> This assumes we drop the per-variant id_table and use the probe
> function to skip devices without the necessary requirements, either
> wrong device or missing the tables we expect to expose.

Without a module table how do we know which driver is which? 

Open coding a match table in probe() and returning failure feels hacky
to me.

> > Should we even load it by default?  One answer would be that the sysfs
> > file to switch to vfio mode goes into the core PCI layer, and that core
> > PCI code would contain a hack^H^H^H^Hhook to first load and bind vfio_pci
> > for that device.
> 
> Generally we don't want to be the default driver for anything (I think
> mdev devices are the exception).  Assignment to userspace or VM is a
> niche use case.  Thanks,

By "default" I mean if the user says device A is in "vfio" mode then
the kernel should
 - Search for a specific driver for this device and autoload it
 - If no specific driver is found then attach a default "universal"
   driver for it. vfio_pci is a universal driver.

vfio_platform is also a "universal" driver when in ACPI mode, in some
cases.

For OF cases platform it builts its own little subsystem complete with
autoloading:

                request_module("vfio-reset:%s", vdev->compat);
                vdev->of_reset = vfio_platform_lookup_reset(vdev->compat,
                                                        &vdev->reset_module);

And it is a good example of why I don't like this subsystem design
because vfio_platform doesn't do the driver loading for OF entirely
right, vdev->compat is a single string derived from the compatible
property:

        ret = device_property_read_string(dev, "compatible",
                                          &vdev->compat);
        if (ret)
                dev_err(dev, "Cannot retrieve compat for %s\n", vdev->name);

Unfortunately OF requires that compatible is a *list* of strings and a
correct driver is supposed to evaluate all of them. The driver core
does this all correctly, and this was lost when it was open coded
here.

We should NOT be avoiding the standard infrastructure for matching
drivers to devices by re-implementing it poorly.

Jason
