Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410BA5103C1
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353080AbiDZQp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 12:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbiDZQp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 12:45:27 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BA23BA5D
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:42:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oarHK2yDAHQGvMPQyuFpyVJ+2OkdHuCbkU/jWpqZXzM6vh4SGSMnAYha/hls0u852fAugArrVj4Us2FHbwZmkd+/s4GydvN2Heu3x+9tJmkhcrnHDLFX/tBXoTIbOxsiBSH/5Y+iqdBoZCWyYdXc166Z2oNImLcPCj3wCANCXiT07Bt6ur5NowgaXrBM3OAG6WvWr/s/XJsGa7eZ3DkozuWSB1b3DHmjSUjfbt8whfR51ALuD82btawuo3+saOw+7Iw7T4PsQ6urs15gKaORpkLdgMGowLvUyU2nsD8gdfHySgaAcqDGSEP1ty1PuMv9FvhHWl0bIXC5JRY+92aeYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSCo+dClSz/G5EQBt750NI/yeFEWpV9B94pol+YxTU4=;
 b=Ska+FQbE/BnpzzkldnsDW55HXahQlxUWLdc29Ff9k6hTMJz66QHLIo0ich/laNnV7CZ00lQaZtWfTleXgiSV6eayH5go6c2THmpPEffkL4gojnBkD5nMHFvn45qVqVg+Tq4f+3E5P2ntKp0miJHpeUQ3y+I/PDk2oIYuJf3mw4xLu1lpvDk4Cw833REri1YGd8BSwV8DC0rQJYcf0O6GHh9eajs57/9Wic7y0RHZRx8UnoXO2ipA+9x1Cdm31zPIYxvqLuBQjahxN01PJa1GjiwraAv7IVZaAmlG75HxPg+6AZYqQpkhaHQ3INS8xWnh6z72K5shOnyjT+9wiSME4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSCo+dClSz/G5EQBt750NI/yeFEWpV9B94pol+YxTU4=;
 b=WZftvvHk9n/64I7UHvIhFsLRkRocG8BWLIq551agvY+EadqOIhZuASF3R65Qt5knvvJotQQlJf6iVBBxA0nJ3arU0zttEXk91LGg+nSSTuHYLwkJZgS1l+TRFL1BOjCwnylSqleuJ8HblqOys705Us67Jf/I3T4NYKYYAi4ZihJvWcCe8l2biTLJNxyeROvjDrDvF6/KIbPfB0SH0DOQdkNYSJjUXlEJmp5YW/lD9iNxGmzdnv/L+NTVvFLyB+3KKWjzFMA4/GktZWjdqKuc1/Y22GF+s1ZjpmLrnSGgxvLhRH+fP1vtzg6a8BCOKvyLzir7UY1fAueguhgvlc5bbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6229.namprd12.prod.outlook.com (2603:10b6:8:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 26 Apr
 2022 16:42:18 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 16:42:18 +0000
Date:   Tue, 26 Apr 2022 13:42:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Laine Stump <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220426164217.GR2125828@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220422160943.6ff4f330.alex.williamson@redhat.com>
 <YmZzhohO81z1PVKS@redhat.com>
 <20220425083748.3465c50f.alex.williamson@redhat.com>
 <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220426102159.5ece8c1f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426102159.5ece8c1f.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0058.prod.exchangelabs.com (2603:10b6:208:23f::27)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e737f4be-9d29-4680-0665-08da27a3ba35
X-MS-TrafficTypeDiagnostic: DM4PR12MB6229:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB6229DD47EF6ACC4B2B365496C2FB9@DM4PR12MB6229.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ixyZSJQ/4jARku68cP+N33CNVh34RhkprkHcxNGGRv5gdgDXbK+L4vhxyR2XABW56wsBIKuYIOxJDTy1jf7LkgeI4YeGIGV4LTSs0alAAGBLr8CX+b74QIS8gydnmOILS7IAWl1lo/32wZDKSL6uGqGS+qs7AcexcKsPOdmKAjb9r4CiyR1jfHKzzipzhowq8HKyt+wDaDUhMmUCjAmxvaUpXefIlLh9Bau0D1absQQoNnJAmsPPkKrt1oCxCR8AKqn1q79PZNCwwWLyJEoc0i4LTeTyw6ZsYVRo9EzPnd76LbztVOhMdua6FFRnOHpdWcu2byor/j0AZ2vQScXKaJ7wWOKcRAyIVNT1jkmewhBagL7f3DV03+okiGKAuBUwFYuaUWSJ29xv8Hji0RfsPDd9UfBX8ueFK2RAfFOnVnpkoyW/UH9v3bCo8DJo1kbVaQRVRGiMQGz5A1HY2K1oXLY4z6/EkRbC0qNcNso0uX56D8yJWuIJvdidTPLOQUdCXtkkDAvZWAeNp0K+vJhpT5P9/Ni5kIbZqYNO/xUYvcmQchQe9fe1QqI8/of6twMKSB3QQwkgkXBawEYTZsDvBD/uTeZyYYUTStQbLYUmRmvPGNaX0JjI/28bdJePe0B/sMgUCcz48JwaBcXuFdgkfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(2906002)(5660300002)(1076003)(186003)(2616005)(8936002)(36756003)(6512007)(26005)(7416002)(83380400001)(6486002)(508600001)(4326008)(33656002)(316002)(54906003)(6916009)(38100700002)(66946007)(66556008)(66476007)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KqVGKfYmTk8DnI+gYCmEnNefse127PEDtwJfb2LbTApNUawgKjMDyWeuasS5?=
 =?us-ascii?Q?TmACWQ/S6UdHVYeNPz2VtKj384wLpssM4PC/Q1coSY/FOEgqpl/3dZEnHbb/?=
 =?us-ascii?Q?DkxJX0famT01BelACFj3Jqvh+r6O2C1DvUKQKhw4yFrpEYxFrLOEF35QZYXc?=
 =?us-ascii?Q?lbvZfuwc511s60vJ6CC4Q1kSOp98QnG8tpYoGeMM+nBDqnx14aUXAq8088CB?=
 =?us-ascii?Q?43AyT+7g8HoFdIKGZD0YYHq2meVp4vqnmUuX0YzFVmIELCS+gn6rZGYNqUJF?=
 =?us-ascii?Q?tcSDh6IN8i/9AtRvniFchEhPVhEIokxH+HIt/Q0Gh7CpxPP1eJmCzKku0exK?=
 =?us-ascii?Q?FbQ1DZbBJkpYoje3PylQx+tsY05gEQf4ll7I7hgQRsUVDAqDQ9/Jn06YX6Vy?=
 =?us-ascii?Q?KLYthriKl52xnEfE11gcCYlH3+fa5+aeNKFjY1bWQs4uBBBEW770ixJXvj1x?=
 =?us-ascii?Q?tj8gmjmCZfXCanVjnju6hmC5LCRthPygquBtZWdvoBXEpVBKolK6ZSt7qSPA?=
 =?us-ascii?Q?jIdljwAjBfvJZeKVD7mSMvxhQOHr7A2Y39JKJAiF4JSFFee5P1iJPTa12/Sz?=
 =?us-ascii?Q?qlrBvKzmf3K3ubczYikqQaD0O3FPhwnynILF9R1FZv5UzAvRg/0lxqC+goaI?=
 =?us-ascii?Q?XwM29euDPp5BXMWZUfL7sPOtXJOk4X82+wxsYt88+8TJHM7+ErD1STVqQaY4?=
 =?us-ascii?Q?eHX8RcHMARqqLn8obqIzHMJhHw74AdMHwBMgaKqnpmyFjFt1noRCfjNFbAxN?=
 =?us-ascii?Q?zgthaat91iAiBSmOWWNOZZ0FEDIOnmAP1XUoxKWkiI61hnPG5OwTTV/qE1qI?=
 =?us-ascii?Q?enbXv05HeXZI5bAXqthygCsRZof/7egzVmIUYZ1T4BDUVTzsSkIm0+0RoU2p?=
 =?us-ascii?Q?C0+UYsdf/Yyx9RQuAY3S6fmtAAhR/UJ4Tu7zoJdoKJnCP7kZBcIOqNYGAxoa?=
 =?us-ascii?Q?c8mWMDwwry2yVr6eFV4iJ+yHfNdZP2LVEBZLmHMSFsxv9S3XKkA+O/oXWCx0?=
 =?us-ascii?Q?jkqPPQwTJohM23udOOrJFUpF+q2ogh0Silr6DAfNhMoiG2rUiXY0nz18VwUL?=
 =?us-ascii?Q?CcptCrzb4jXTs/4CIe4U9oivsUgPLY0v7S5ie3L0hsIdtbyuRvAdi6+132Zj?=
 =?us-ascii?Q?Oxn/E6a+pVdbgKcABEFxDeafwrvGzfx0Ee0q0T9A7MVZYS1sUEcNwBoYvqe4?=
 =?us-ascii?Q?akOJoC1cgXdUCTTHUIS78UD6CJk6SrPWXKJmZ5u8uhZP/E6BCbKOXdmaP+cO?=
 =?us-ascii?Q?lZXJahDfV6x4Qj9gehU6xiYCpPLOysj1ajAon1rMkve3+f+G+G1bHeOuxCWl?=
 =?us-ascii?Q?gg0bXYCNV3AAGDB+GArW9vFjDxc5nhsJVP/hL4QyZ3B1RvmwClIp2hv/I1ax?=
 =?us-ascii?Q?yxvbNFXAkGmy3TSxk4rgmzE/empXGsh1jZB9p8pITXOOHORqAUQyPbpcjk6z?=
 =?us-ascii?Q?zhxdJoFFKZ0K1SnI2ujb69zEFGmqLMgkoqqup8/iz4xu/j6X/tLom6EYeuBK?=
 =?us-ascii?Q?LKYRB0lLnFfGWpVLUJeuns9AohMCJNo0V9xGLf524w1j4sXndIb+mdAo+R4B?=
 =?us-ascii?Q?l6uf9rhy3XdgmEDQSFusKdXmTBtQQkkd50q1z27r9fwEIowi3sHQ6it9gsH+?=
 =?us-ascii?Q?TcLQLOdZalD2GAMixZ3wCyez7OVdrsW9auDYnzB/uJpz7aEm+2V1CJmuqzfC?=
 =?us-ascii?Q?1hnew/Rpzyo6AavXHySrCOOR0FCb+kkX2i6Q85YcO19BXvRMDIsFpiM8XHla?=
 =?us-ascii?Q?urSw36RJRw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e737f4be-9d29-4680-0665-08da27a3ba35
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 16:42:18.5098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPt2jFOzBtJjvUDmwCtvEvHnawg5SXfKuT3iF7ysXCEXYsKFpAAmOJiwHk4rHPb6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6229
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 10:21:59AM -0600, Alex Williamson wrote:
> We also need to be able to advise libvirt as to how each iommufd object
> or user of that object factors into the VM locked memory requirement.
> When used by vfio-pci, we're only mapping VM RAM, so we'd ask libvirt
> to set the locked memory limit to the size of VM RAM per iommufd,
> regardless of the number of devices using a given iommufd.  However, I
> don't know if all users of iommufd will be exclusively mapping VM RAM.
> Combinations of devices where some map VM RAM and others map QEMU
> buffer space could still require some incremental increase per device
> (I'm not sure if vfio-nvme is such a device).  It seems like heuristics
> will still be involved even after iommufd solves the per-device
> vfio-pci locked memory limit issue.  Thanks,

If the model is to pass the FD, how about we put a limit on the FD
itself instead of abusing the locked memory limit?

We could have a no-way-out ioctl that directly limits the # of PFNs
covered by iopt_pages inside an iommufd.

Jason
