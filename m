Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE7A4AE3CD
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 23:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348007AbiBHWXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 17:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386251AbiBHTvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 14:51:21 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6803AC0613CB;
        Tue,  8 Feb 2022 11:51:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPVH71REf99rl9X2pQJc967JWTl/ne6BWBmxXBtbuOnku4TaieJE8ft8ShpysBsZw43eYrM8D4qrEPzeRNI8tjERJsbL+mPcYRWepnw8TvIqV68fr3DVtyzG9dbDAviDOLrWgPDB/ICIEuR9kEVhvUvW7rk6YyZmdO/+YAvVk9/AtyG0nGNQ1FryWtsCFi8F3C4DSKcUmTaz80zlopcNwMuE3omJgsSt+/sGMZIdlwCbbD6hMt/PHuBQFQVfx6EUtjgtC+se8DEEuG5r5speLLr7ZsedTvhX7sevbbAQMgK8tPF99zFE1gu8DhkV/BzhSrYanMpGop03ySvGqAhJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8ElwflWsZKwDSqqusy6exWKURZo+iCocJedRM5M0pM=;
 b=KS7B0lBYRHd4rLaLkYtsAh1LAAv5NIgtzwIDKfHZq4DpeC5mEXsGiIQQ0QXBrS+XfCv21+DjmmEHXGH0tSSHC3Kr7Il/t8V0jVAzxSdAhtgnEy4ED9cWELP0W58Qs5XAdlQ3iX20uEsygwUWpQ3YQPG5EEN7FcMmB8JEgpANPQwJhmPoZ8UUoGPYyQuvf4LHG3lD95yW7s95zsA8HSFtPiNDRNavhezv1NY3ZQJwopVWDO06yoWZMFhAU8b9yXzSoNrkO2rUnUxMqjz51RFM+eYIeGIdvdW97bpAyO2j/8HiQDku2umu8yjUpWSLZuiuwiVDlv5cbjM+fbiVkqVPww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8ElwflWsZKwDSqqusy6exWKURZo+iCocJedRM5M0pM=;
 b=LRUv9KqehnEmc1Wq6QuqsDr9Z0LlH2FSexTCoDuf8f0nAOokmiuWr+SxwSHO29MZGOiPWz5rXaWMxdK+WS3zQuvTU4DKGkIT2GjiYZSOI62D3/ozMJ50c/d74uZ32aEqsJGLp8cNDHRNRfeT7czHMat5r6t8DclOZbpUylfIbuhS/eidHrUuJlzhjfS7bGqy/uztYjbdbxJtF3zof0WdksFrA8+PPtMDXRmpgf3G2zt8lUYICYVVLw3LwE56tZl3t1MoE7+EvcGAO/U06nVkuHum6fkhkNe35Qhpw2paSSIjPXo+hFC+56P/g9kVAVu8TcN414SzGoW82L7JISMRdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB5535.namprd12.prod.outlook.com (2603:10b6:5:20a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 19:51:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 19:51:18 +0000
Date:   Tue, 8 Feb 2022 15:51:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
Message-ID: <20220208195117.GI4160@nvidia.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-25-mjrosato@linux.ibm.com>
 <20220208104319.4861fb22.alex.williamson@redhat.com>
 <20220208185141.GH4160@nvidia.com>
 <20220208122624.43ad52ef.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208122624.43ad52ef.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0209.namprd13.prod.outlook.com
 (2603:10b6:208:2be::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d3c63f9-1a68-438a-dd5d-08d9eb3c5f7b
X-MS-TrafficTypeDiagnostic: DM6PR12MB5535:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB553596549259A31FA0559283C22D9@DM6PR12MB5535.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MfJy9Oas5QhQW2r+gfua7xR+f/vVODf0U1BNY/b5fpjfKK2QaEhR3E3M1RFVD4MJQ8OmsMECVPdjykHr2ZqF6Jr0W0eocvtaMIuRZCXLUbhQn5DoyJa6cACykfP338wtcF3u8bkR8qvajQhEA8RKEI53HI8cw+Qpg3F1j+aVTpfR6339q3PwwXEcjjkPqInxtXVxYVjPjt3nsfk8FCZyScZHod+Xnp0SKbnEzZ1rfU9RTLO3BrY/Mffrm2jVrnOGG85E4CPV1Fl8KyM0S+0AmZE7Gd8kCmFZqFNCqc4bbcIBEOm6sFdOvVakK6LhR8tEwDIdEDxk1d7z74NXbfJJPuOME2yG3uHKZEdI8iu4muurrZ4FqdoxDwlhTyOXhOMzjRudJoshOim7y4IwQMjAv7sy7INmJC67EpVFLFpN1jtLKy3vfLxFLuYtPDbNuUXIrAzbfrRVL93nUPW+O0PpFvnLF5YBC5Sjh+WbPo41sIDBMY/ungCkLwuFCDJtEAe3wTxiY9EL32xVsXVZOzUPokq+hYDoawK17yVok31INRQTUMRfU74Ssdum4ANn0+Pyr+QHu8q19t+1hRYUBoB4NQZoP2wvLThI+1N8Xcb+QOrSxc5xu51ZEBui7UKhOeVK4UL8GNDOR3shahokmDyHLm6Vu5oaKchlCvl7A/N4bmMyDjCznQDZ0cCiK4ev3RYdSY+AX5jrBLAx2L7GiYV1V8p8Vlcl4Ng+ITpy7/c95x4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(66946007)(5660300002)(66476007)(33656002)(4326008)(8676002)(6506007)(66556008)(6512007)(508600001)(966005)(36756003)(7416002)(83380400001)(1076003)(316002)(26005)(2616005)(2906002)(38100700002)(186003)(6486002)(6916009)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qdJ5F9A9sqhkAvGqYYr8gmshYfYFq2woaLlz4FouCfdfA6Xi1/JT3i+mmUlA?=
 =?us-ascii?Q?aiEycRH3jv7QP8R2kRSwfAPDzOsHB58XNLaeyTKXb5TTdNcsb+JXhnqvoPB1?=
 =?us-ascii?Q?zY9mtJgb3BFXRCmEQ7xRLYSQYPkOZc0j6CoStazDmNHiQYoIZAYyc4n6k7xI?=
 =?us-ascii?Q?omLX52uhZoAB58JP2/TY8ju8MQ+3u2pWYZoH6FYk2KDdc+96mpdjdzKExXRH?=
 =?us-ascii?Q?L9V2U1ienWCOIgb784Lp6WqbKiQPdtdegTtlWHLWcNF4tnPlk5mj1CXAsFHg?=
 =?us-ascii?Q?dFKrBCmJw9eeTozi189kiZGBw04B+hUeBp/PnK72tHe5GRLKeVvmIZDrJn3o?=
 =?us-ascii?Q?y8ebnOjYWU1jrRN3vGHZ351M08WBPYTJRFa6+sJnwm5T5R7lx89Kom29b7+9?=
 =?us-ascii?Q?+AZet0dsmcaYLbHsyNU+6dMMmGbmWTgsaTcpuedxrVIva69mWDYnxL7ML2CY?=
 =?us-ascii?Q?8hfOxBKHgTmTDdrnyqfGT1vc6cqHPazUofvCssKNSi2rJxkerqv6YAscQoz2?=
 =?us-ascii?Q?4M4U44n76Am3Ep2RH+EycuYgsaUapHuHGwNlrJOLRlxORR+4+eiQilLVhAL7?=
 =?us-ascii?Q?emOCtVr6WbY/cSxPAo1ZvgUwFTOYJ/Nf4kzV/leG4bZ/B2sV1o+qr7y/GSws?=
 =?us-ascii?Q?LbWiY1fJq20+xc46sfnyn533RhkSr8Gn5yOJEglCjfTuKEViVptVtkMB3uAC?=
 =?us-ascii?Q?NRO9RG4bs4pE9FJqUxt5nPrSp0fiTNl7LN95yMbjYhHVukcDHACQGWij9oiQ?=
 =?us-ascii?Q?QvFaXB9HmUISYoAyz49HRoAHD33Ueja6JFGtb0mffLuGqfAPjs9/pqECjIAm?=
 =?us-ascii?Q?D1OYaUET17EToYB5S+difL31TdkhbnxZoJCmoSNE9T9FYsUNzyvX6jSeTf/O?=
 =?us-ascii?Q?bW6NwmDhbS6lZK9F7+SKUcYJ4WRkcpfvAT0215tMq/Klf3uDHWRequgo2U7z?=
 =?us-ascii?Q?splRay6V1g4kJFuE9HgYO8f2nKE+Bt8S7QdmtfsOGA+D9EfvHgaUrAQu0/kY?=
 =?us-ascii?Q?lVd4zmDDXSYkqWQLVKEGcvRO9Rpr/BJgWw398tfXQ3e6W1jb5NDeEf5Hlr6S?=
 =?us-ascii?Q?Mv3JKM15vfllU93BgpOL/LtfD1keQ+WM5D7FAvERep5PK+BwKjm+YaKZcSsB?=
 =?us-ascii?Q?XLjpWex0S2EA4mP15WqeOqn+LKgYch+8Q1T/Mw59wxWeVWKpASS32DPd5UuD?=
 =?us-ascii?Q?iVj0w3lGzmIIyGhrD97j5sn32Jn2wS9ZrDsjKREMGorWnc8OOu3O0JnvpvJs?=
 =?us-ascii?Q?jvwQIuuqi1wJAzCl4g5i/jCM1r7YdPa0N3XGEf0AGlDuXQPGSzzItSd+CQ1/?=
 =?us-ascii?Q?B2i6YOKwXtiAKDrMUHxJCdSisLjKa4JjAIJEbSCBPikxv9XJxU9y2LUgvluP?=
 =?us-ascii?Q?uM+IPEtHptc8525kM0Ov2V/EinWW125hlbaXjNXvWTHPSuTHCrAmKrkS5d1w?=
 =?us-ascii?Q?iApq2qNIRm7iNv0YptTzqz4TJf57iKg8rGfTnCktMyhM5q0NFLH4Fa48oWkO?=
 =?us-ascii?Q?1yfb4NPwzOm/LXVHL6jXjTSn6SCb5DxuOc6IStJJ82lk/PvqAixGhFxGlWsD?=
 =?us-ascii?Q?+dppUqokv7JuJNf31jc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3c63f9-1a68-438a-dd5d-08d9eb3c5f7b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 19:51:18.5135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BcUrYIvv60e49tyu7pNjqWzHGo2ZLj1u35JgfDxlKXRRZBBq+WzuQxu8kUTuuV55
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5535
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 12:26:24PM -0700, Alex Williamson wrote:

> > Personally, I think it is wrong layering for VFIO to be aware of KVM
> > like this. This marks the first time that VFIO core code itself is
> > being made aware of the KVM linkage.
> 
> I agree, but I've resigned that I've lost that battle.  Both mdev vGPU
> vendors make specific assumptions about running on a VM. 

The vGPU's are not as egregious though, are they?

> > Or, at the very least, everything needs to be described in some way
> > that makes it clear what is happening to userspace, without kvm,
> > through these ioctls.
> 
> As I understand the discussion here:
> 
> https://lore.kernel.org/all/20220204211536.321475-15-mjrosato@linux.ibm.com/
> 
> The assumption is that there is no non-KVM userspace currently.  This
> seems like a regression to me.

Indeed, I definitely don't like it either. This is not VFIO if is
just driving KVM.

I would prefer they add a function to get the 'struct device *' from a
VFIO device fd and drive more of this from kvm, as appropriate.

> > > this is meant to extend vfio-pci proper for the whole arch.  Is there a
> > > compromise in using #ifdefs in vfio_pci_ops to call into zpci specific
> > > code that implements these arch specific hooks and the core for
> > > everything else?  SPAPR code could probably converted similarly, it
> > > exists here for legacy reasons. [Cc Jason]  
> > 
> > I'm not sure I get what you are suggesting? Where would these ifdefs
> > be?
> 
> Essentially just:
> 
> static const struct vfio_device_ops vfio_pci_ops = {
>         .name           = "vfio-pci",
> #ifdef CONFIG_S390
>         .open_device    = vfio_zpci_open_device,
>         .close_device   = vfio_zpci_close_device,
>         .ioctl          = vfio_zpci_ioctl,
> #else
>         .open_device    = vfio_pci_open_device,
>         .close_device   = vfio_pci_core_close_device,
>         .ioctl          = vfio_pci_core_ioctl,
> #endif
>         .read           = vfio_pci_core_read,
>         .write          = vfio_pci_core_write,
>         .mmap           = vfio_pci_core_mmap,
>         .request        = vfio_pci_core_request,
>         .match          = vfio_pci_core_match,
> };
> 
> It would at least provide more validation/exercise of the core/vendor
> split.  Thanks,

This would have to be in every pci driver - this is not just code the
universal vfio-pci has to enable, but every migration driver/etc too.

And we will need it again in vfio-cxl for s390 in 10 years too..

So, I think this approach is the right one, asided from the
philosophical question of being so tightly linking s390 vfio to KVM.

Jason
