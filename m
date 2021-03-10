Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F643333D2E
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 13:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhCJM6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 07:58:47 -0500
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:24257
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232286AbhCJM6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 07:58:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsElc5ERqo372AoVs7yXpmQHAN3i/XchZVdUfgznwuMUaR2B3/fVdYMlbr80qhmSiWVWJIqWsYgyQe6bWViWsk2o/YiZVNRkWgnLpx4ziBXnVN7MszxHyMeZJ/mI40yR0aXYw7xJKdlOFOvFC7ngEHesfTfwNijQHxuWU3xk67w+ZvyAcXQu5l60xiC/KRyichJjL1ql5pkqmMNwHVAesO7uQJk2sPow8M7t59sIDLURaZc5C260tWGtrbObmy67+sJIqv4GYEgFSinyAbI+v6/v6wqSpfgfeQkR70MNE5laRwOr22rUPuVqvK6rpigNW+gcymrCTdxWQJbxTEiJOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAQvigf4QxSlF7Y71JAn+CVTCo2frsPc+kBadweeyuE=;
 b=IbEmhiA/CQ5638s+1khxJavifDasXjZkLfcoy9J2OKuulZxAEevKJiCSfHHrG92ii+IEpBLXB8O/ABlvqYRZz1bXtjMJRhofLmf75p1GxSSN61jWGDfqWX8emXtaOgIxOG1gz9XNPZPeWmAfV+IgvjeWjUi7p5j4FO3sWWur0Vog4JQ1LPThTddm5c29kwM4cmmAb1nKDuBYSZHAVXTSphVxz6spbnjGZ1FM4Ta4974tslN9htlA381VLqMKDGNNPYGJW43GaOp4u6u9rs994qvo9iY/LRSdKmp4FopprmtpmuXuzCjXmrQeeF0E5L5FIo2mUD9ayN3ot0ysLqrTBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAQvigf4QxSlF7Y71JAn+CVTCo2frsPc+kBadweeyuE=;
 b=Y7EWc8AK1K1VENgw/iPDoqHpPrPp98ADJvnfNJPcRMw3jwM3AUBwaPPP1EeNzl3s+h5JD9G+YtU2YtZNlGFal/fuEBIZGYj33wwxNDF7ffT8Oxq9rAjbHdNPWVYD0+WyxtxLhhwDllRGofwjpJ/eg2sQ0m0ohlbIdkS3KuCCNjCGBhiidhez/vAzLTaFPLobphrv1CSh7WBRlJQtHQTsKZrKQulY7UONSkMrodHWJUI7xP4/V+23qdKwbIVC1U8CNuY9/4mrgvdbtmuq3sO3LZuVOcI3A5fVBNdCSkAOZ3DW6jifrZIfEicZ5y14TuNX2WRvJooA6pMIBlJIef299A==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3115.namprd12.prod.outlook.com (2603:10b6:5:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 12:58:28 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 12:58:28 +0000
Date:   Wed, 10 Mar 2021 08:58:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 08/10] vfio: Make vfio_device_ops pass a 'struct
 vfio_device *' instead of 'void *'
Message-ID: <20210310125826.GV2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <8-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <CAPcyv4hqALoBpH-yir4WNPj4+z1n-zj4o_6bfOMBRmd5sOCMNw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hqALoBpH-yir4WNPj4+z1n-zj4o_6bfOMBRmd5sOCMNw@mail.gmail.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0022.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::35) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0022.namprd15.prod.outlook.com (2603:10b6:208:1b4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 12:58:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJyPy-00AiHE-Up; Wed, 10 Mar 2021 08:58:26 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 865549a3-8fa8-4aa4-18f7-08d8e3c43301
X-MS-TrafficTypeDiagnostic: DM6PR12MB3115:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB311505393A71D958D610FFB6C2919@DM6PR12MB3115.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ytkpYZ0n/JBuK3lcd/RLBh7Tshj9H0M95Mf51kVBAuPB59zId9kp3b94Qs1otGP5gFRebwDxiu1uoZkJf2vApnUIwZkim7gqHG6Jvt8RWhsrVewCCe5eA6r06TMUtAJVX6Ex/VzOVuA3RF4CQWtXyRtG32o9RtjYxbDn5SpPAFeXIv7g77lXF6E/7J5X32tQLX2b9cPAc3IiinEHQwfNpUo3e3lilCS0EaBTnYBTter5kVaHCCmdX6fl8AH9zKhnP96xas2YTmgMXHV90ewBqEt9EJQz0ehYaQQOA7LvU2R9J2kucPMa4JjvD5lsChvgvqPcfNcbmr9UIn14KRCLpuQ0vvq2lKoUzMxfJn7GCpGAtxqPoxMmQtqpFdw9edsDDAaB+V8Pm+7m4H2y29RxeHJgEn8yVOHCjf2SdgoFz4/5kcYrRV4TEfeaQGIAKQLAnlsvvvGvv3c40/AVa60AuhCGSd8bxsjf6sqkhSOZvIjv8iGMDljhfI3ThYzzMfyyeFX5JC0IEg0jwHD6zVowzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(26005)(66946007)(86362001)(7416002)(2906002)(83380400001)(107886003)(36756003)(2616005)(426003)(4326008)(9746002)(9786002)(53546011)(33656002)(8676002)(1076003)(5660300002)(186003)(54906003)(316002)(478600001)(66556008)(6916009)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rwmGKlrL9XxAuvVZCixsTMwAAZ8ejYlY2S8DU0D377uQxzQV64rDJBK0794K?=
 =?us-ascii?Q?8izv064PhiJfqxNr9hySnR1VU/W4S8BnlTS7WynMYsQ8e9htRhe4g17toFTk?=
 =?us-ascii?Q?EHAQ/FhbJoPJh/JXAn/m9HrBZkZ9i2MJDRHtCh+l0/a54Jq3zlS+ReX9r5+/?=
 =?us-ascii?Q?3r06Lm3oAHWW1X7OtJ7Y0qmnAjFUV2QSqKrdF86TRj+Fbm+z2waf/UQZ0bU4?=
 =?us-ascii?Q?KpYoFTrNAWF7vJGodjPQT4Zi+CuuCnpq0Opan1rBzQh/FiYmT/Ee88PYZwiM?=
 =?us-ascii?Q?72Glirkm7gFha0KhSrrYFQOLIN6K0TmgXc0iKBppMnL5Rn9Y/M4GdZlbeN+Z?=
 =?us-ascii?Q?CErwhvmOagxEYZ/Q5VOj1AJhtnBTTEZPdODijnQnW1VDnfB12scBlFHueVqc?=
 =?us-ascii?Q?pRGvc8QoqsvK00MQMoQf8NBRgz8SKF2B3MAS75Uy8XoD9H88Epzge65qcXM2?=
 =?us-ascii?Q?oQeLp3mkPrRzgnmmJHDvpLPxhgnodKk2AQv3W7JwY3cAf4XiMFwnrzSf9MFc?=
 =?us-ascii?Q?9GZKdUuT89LRT2NohegqUh0xuIaTCS9f+7nQRzea1OPoO1OzTJ/MXngNtEBu?=
 =?us-ascii?Q?k0dai6AtlK/JCPA/kXOrMDfdzvdEk0Iec1iFb8zKzp+glj7qUF506G7S1aho?=
 =?us-ascii?Q?KcF/7mRlXjzFoBnMYairWOlbMOKQTwoUfnkzkUdP9OFTaU178J+G7tc99QsC?=
 =?us-ascii?Q?pU3c79t6zSoNhBt0o9Z0pjTVg//gE0ulLINmjJ5f4nz4HVgfNp/W0Dx1+SIX?=
 =?us-ascii?Q?6zfADTlyGb/UBZY9/fXxIIpUduud4qym5zf9guuYun4chxx/ZrD2fHLsmMpQ?=
 =?us-ascii?Q?/fPAGjQzemeEIB6Wqb0d+srJuE2t8fNJb+O0TJK0N6A5+SrkJCW01nBC1FZv?=
 =?us-ascii?Q?pjOTyUuIMEQ33POo3vgwamOIJcwDREwNtRoA3TfGqAgnpnmCaGOB/MfoUmOA?=
 =?us-ascii?Q?SiUbz7ndjSBHeBLJgEJ3dPjTowTFbkUh1KiaqaHP/b8RG/KC2y3MUkQIwY3U?=
 =?us-ascii?Q?nMFQqySNc3aAKefIZXsXVGAAKs2TueMfLdbZP4E8FMsE57527eJUjGr5/XD7?=
 =?us-ascii?Q?d4AdefH9ixjV1MTkMhZ9xyeBB83xwVzYv+K1LpIPfaHAvZVMuwpGAiUI9U7Y?=
 =?us-ascii?Q?fZLoVxtUfE00/n1IH6cw5EluyViGr+gZYb7ZjW06HIApTjZxfFU3prghSiGF?=
 =?us-ascii?Q?KNf4uktU2KlLZ34HpM0JhewLFtz2oNtAaJzKrTEdU39jlzapsQy6VoLGSINL?=
 =?us-ascii?Q?fTHmrYFSINdsHTJDku/qEt7KoNH5GEcPniAYFfIepkW+d4Wdt8owNDrve5Yx?=
 =?us-ascii?Q?q367WkHrTRaCHXn5bZFh/z+TcQOWK5fAA8DK9d97Tn+i2g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 865549a3-8fa8-4aa4-18f7-08d8e3c43301
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 12:58:28.3379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McfD0hfB6XkALbHUHS3YNqj0JhyefViZdjELI/UqoBd3FoPOhRxqDErdhFmds9PE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 09:52:30PM -0800, Dan Williams wrote:
> On Tue, Mar 9, 2021 at 1:39 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > This is the standard kernel pattern, the ops associated with a struct get
> > the struct pointer in for typesafety. The expected design is to use
> > container_of to cleanly go from the subsystem level type to the driver
> > level type without having any type erasure in a void *.
> 
> This patch alone is worth the price of admission.

Right, this is how I got here as I was going to do the mdev stuff and
we end up doing transformations like this:

-static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
+static long mtty_ioctl(struct vfio_device *vdev, unsigned int cmd,
 			unsigned long arg)

And if the 'struct vfio_device *vdev' was left a 'void *' then the
compiler doesn't get to help any more :(

> Seems like it would be worth adding
> to_vfio_{pci,platform,fsl_mc}_device() helpers in this patch as well.

I have mixed feelings on these one-liners. If people feel they are
worthwhile I'll add them

> I've sometimes added runtime type safety to to_* helpers for early
> warning of mistakes that happen when refactoring...
> 
> static inline struct vfio_pci_device *
> to_vfio_pci_device(struct vfio_device *core_dev)
> {
>         if (dev_WARN_ONCE(core_dev->dev, core_dev->ops != &vfio_pci_ops,
>                           "not a vfio_pci_device!\n"))
>                 return NULL;
>         return container_of(core_vdev, struct vfio_pci_device, vdev);

In this case I don't think we need to worry as everything is tidy in a
single module such that the compilation units can't see other
container_of options anyhow and vfio core isn't going to accidently
call an ops with the wrong type.

Jason
