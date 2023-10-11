Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F00C7C5794
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 16:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbjJKO6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 10:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjJKO6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 10:58:15 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA82894
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 07:58:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/FKujtYZW8mQ3MsgovNjFq3nNq1s6XROAU3Mg+fJSoWaXnRWPHrMcIe9jGAOacGpcDZaHnlrei9EZqG7lAeb3RQi3j+1XheSh8lolO/FtIbx/zJf5C/wY5NLy+enx1ING2lutALONa9ynoOqNSJmq9AZvkU9qzpOt2i41jdM7gHpkVfKejflUvR8saSXw0Pv8vFURV57OQw9HD6D5a2x7sItN8RwCMdJ4/nVfcf1bEbux8h6S0ttd4nV/B0aEIPjmqrBPlh7khuBPTkR0zR0aEAYhkZ6pdP/rA9rr4ermQj3jQIkIb4BCZnaTWwf/0hdV7yr9dIfXhzF+CcCdTThQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0e3aeUwoKvwrhRpeNrSrpR4l6h1Y/alorYmCnuXZ3A=;
 b=Rw8XDO0FFpucWlBjYyfj6mIs4BhftVAemuIMCfrXQn7OTTCN1zLuhlFVTTTqkz12TdQSDN9G8p7SWoaxrShMutN8sZFlaq50hzmUr4iCh2iyedvdRuIhJH2FrBjXyDKw3lqofIyOBYwKX2LC7jA5QazBDihj24tWXSsQ7r/gqd08xsvbeCjflTJSYAVFkhfvPvUMCduf0YDh6xL9QMs2NgI2aITShs9iMpk1IHw6ab2jd9/Uyig5z1QesaDIez/6YxxZyRpp2nhnVanuQZ2x0zWLyEaEeRruKObmVGDmE8MNglxBmaezo04aliPAqo1AcyfcnnsqGMKcFXtmeVNVIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0e3aeUwoKvwrhRpeNrSrpR4l6h1Y/alorYmCnuXZ3A=;
 b=qMRIC+1w3RfB1w4bSf14oRL37QtLO3HMW/LqkUFxpEPn2ltqbR5MjtWWutNsGAAkq9fCqTurPVuH9qCTcrGagbhfPsjNO/8TmcWvwe/cy3z6BWLXEVi2DEuJcREZHQigyapwqEZ5NcIX28xQvc1mLbiq0Hn0WX/0Dvms1P7teaDvCrsMiOyrU4ezo7jyQRTQzf3FIoO/UBB1BhY/kNDhrOQYW0psfUdpEQ7H6gMyEU6ttQe8pbaWHBkXRPIWiMDfRQ/mn/x1GGRzsdWNEwqMTwzBU7NmzKKFMZjfd4BLEc1+55GjPhUaQ1SnouqjVYf6yNML3EpNab2hKwyL17LYCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8240.namprd12.prod.outlook.com (2603:10b6:208:3f2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Wed, 11 Oct
 2023 14:58:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 14:58:11 +0000
Date:   Wed, 11 Oct 2023 11:58:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011145810.GZ3952@nvidia.com>
References: <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <ZSZAIl06akEvdExM@infradead.org>
 <20231011135709.GW3952@nvidia.com>
 <ZSaudclSEHDEsyDP@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSaudclSEHDEsyDP@infradead.org>
X-ClientProxiedBy: DS7PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8240:EE_
X-MS-Office365-Filtering-Correlation-Id: 75b838ff-17d5-4f7a-ba7b-08dbca6a7d06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6lUZ4WK5tXMrVTCF5SyUAniWT85bUHt/K0ILS9yLCT+7sJ/nXTvnbpF5eQnb3ZMr+yZX7p5aMPqxl0zCozedgJB7tTFYgiRNNWc0MqVAFm1Ipz1VN9zB2f+wye5lXxuxWX4HgXg1XABgHXWGEArKGelnMn9kuz4bO3zL4fefYpXpwFQuBz/NiZ1tuEpIgxyynE1ouAc9MlmbAq+xbOLTNBpDFXk/MpV6RWxLVF/SIKPB46mdUrPiclsOmsK3c/2kkZoY5DA2hgVSpqn28KKWDd+g3IKPEYB6cGYUJwwJTplcxh3Pe5RDlLuPuAy10dzYte90G75Z5u8PlYnxthOoMZbv0uB7rOFAfppCAK7sha9GBwFIhzFr+0/OdF7Cphyj2t6LGTGe+faLHLaDapOu5n56+p6OvUkazEbx7xLb+JDKDyV0+tI5gAjJsi8qF/kP34WtZ3CSED1reKB+H7m4+AKcQPYMUXRHEKGqOQXwuJnPS89BdPXI1s/qICLOdLSSUNlgo6rpCUCUd09ci/DWPoGv6st9v2dPjWJKzi9q909y+H7fK1sRi6ZxkN6+eog
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(136003)(346002)(396003)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(83380400001)(33656002)(6506007)(86362001)(36756003)(6512007)(2906002)(6486002)(41300700001)(5660300002)(38100700002)(478600001)(26005)(2616005)(66899024)(8936002)(8676002)(4326008)(66946007)(54906003)(66556008)(66476007)(6916009)(316002)(107886003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OUGDSKCa4/hAz1Fuh7ic9KOzjItqFGvsGEag4W09inwsv2S2CCAHEQ3HqK5I?=
 =?us-ascii?Q?/3bRirZk75yKTCMIu69PFUIxBvj2iDngc4tz6c/XoOtm2KXnoNjPN4lDCgpH?=
 =?us-ascii?Q?/z4YUG8LMVt3UHlpG0D8qXZkpI9DydFDofKAdUCdBWJfNWOuJiP8AEOwohVx?=
 =?us-ascii?Q?H1C5v86nqG1aiU1p4N3faw+rUapxY9x9j2eTcryPGYOMxLGnxRKOgRUyAjPy?=
 =?us-ascii?Q?RoCLM73uBbu/tjTYEnuGmSg5qseq07/PVBCZlObRzUazw8XVSI/5l11ZYIkA?=
 =?us-ascii?Q?jP3ghNJF3D80RJXVEQmIXBUzO4jJ8FgCRqDn2HzV1gDHeL8QtmthLLR8ffVN?=
 =?us-ascii?Q?Tvm7IAqqZAMPTXYpd0ryOFDmAG2n2qIwrN9LYCfxcVrN2b9NLmb02qom4VlH?=
 =?us-ascii?Q?wZtdfj4QI9RGmIsFfT/r3K7HEFVFqTfhKwt5q6PftHLHAY1rsedI4qep5iO0?=
 =?us-ascii?Q?t9bRvzHXXPiqYc856ve/F2qI2VVLLoru6duKVYHUTsxeFJUxh0Bkwpyrl1Iz?=
 =?us-ascii?Q?97ar1zrgEHR7F4BrHWV8htKMGTp8ygqwrIhWMDc+mIfKSOIy4scQHf6FL6M+?=
 =?us-ascii?Q?juIPrctsicvQj/3orop8I4CtTlAQYXO50NGkgjZSUQvm8npu5nhtYvoaEQmU?=
 =?us-ascii?Q?qtyOzJnXtZsDhSPlf83axOOXHJBSYUNcymw5IVBcMSYiTQ9W8G6Hi/mYFM4E?=
 =?us-ascii?Q?MimWVhBXHn/rZe7VsZHiddLo6mIAyKDXOimrXmf8D95yglA+g1p/fUeoiRL+?=
 =?us-ascii?Q?EMZPnAtW+H0YzS3JHjZ7ST+uP1ZetbliQFd1t4eRjCn1E5I3wBANr+ReiyFz?=
 =?us-ascii?Q?uPPwefORIJfpHLgq1qB60catH27dKyUHiPuYn75Hx/miyv7s6Cjr77iIw6kN?=
 =?us-ascii?Q?ovKI0EHau/yinQe50XmUHoRARZIk34PRVZRl/WbFYbMUWML+9esXj5Ro2yXp?=
 =?us-ascii?Q?UM+OmLk6gBD0azybaBF4NdKtjcSsdd8FfyA9CJgblWcfvFEjJJ7DiAs1BYxu?=
 =?us-ascii?Q?xCpy5qs6mQquADxXRbGNEIKqqa8v8EATFDvlnvFBlgHKaFxMI5Hed5E0AiMY?=
 =?us-ascii?Q?ZXUbMHjX5Atfefv/2e4TBBYLINomv0ZqsPhpYsAEEx6cW4PNePn6+jdowAhl?=
 =?us-ascii?Q?86j6hpseU8nTsqkFY7YBQz0mhNZiix1Q0Ch6W9nTw5mvBFGyA7Nut0CaKEGn?=
 =?us-ascii?Q?QYRHaV3mXVn8TgQaoZfPzVbEwMFXnS8e7Myz3xf2VWY2xsb09J+T1dzI/ChK?=
 =?us-ascii?Q?vu/eW77LEhiWjeh32PZMkTb1hp5FaM5XNIlyvU1Cui10UiGCODhCSuvb4ETc?=
 =?us-ascii?Q?lPfm1OJS96M5MBZDhgMLJQ4iMKzR8PzTxpm5ftVY3EKk7VET0js7vJS30xai?=
 =?us-ascii?Q?wIVPHr+PI/ZwAGRZZpnNqfpbhY94u5jFqJB6ANFOQLNMOJpSjoaO0jGUsJ44?=
 =?us-ascii?Q?tEeVrirNTCkEEN3cb72dpqChje5hwu4OivgAvzMGcENbhV2Tvx2eHWKdYuZf?=
 =?us-ascii?Q?OkE/4InI2DUyeA8nXrQGLIT7h1aSIujTBQiUzks5cijeJuBMo4xFw6KmdGbM?=
 =?us-ascii?Q?T83VI0W1+q//gAlg0/MfJpJUWMXEUE0wKf9wnFQS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75b838ff-17d5-4f7a-ba7b-08dbca6a7d06
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 14:58:11.7547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wx3cwPj8E7WkShKQblLpPunJEfDmEHHzcc0lvgbUrbkqGZOyieyemcNiSgfrTVqk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8240
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 07:17:25AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 10:57:09AM -0300, Jason Gunthorpe wrote:
> > > Independent of my above points on the doubts on VF-controlled live
> > > migration for PCe device I absolutely agree with your that the Linux
> > > abstraction and user interface should be VF based.  Which further
> > > reinforeces my point that the VFIO driver for the controlled function
> > > (PF or VF) and the Linux driver for the controlling function (better
> > > be a PF in practice) must be very tightly integrated.  And the best
> > > way to do that is to export the vfio nodes from the Linux driver
> > > that knowns the hardware and not split out into a separate one.
> > 
> > I'm not sure how we get to "very tightly integrated". We have many
> > examples of live migration vfio drivers now and they do not seem to
> > require tight integration. The PF driver only has to provide a way to
> > execute a small number of proxied operations.
> 
> Yes.  And for that I need to know what VF it actually is dealing
> with.  Which is tight integration in my book.

Well, I see two modalities here

Simple devices with a fixed PF/VF relationship use a VF pci_device for
VFIO and pci_iov_get_pf_drvdata()/related APIs to assemble their
parts. This is very limited (and kind of hacky).

Complex devices can use an auxiliary_device for VFIO and assemble
their parts however they like.

After probe is done the VFIO code operates effectively identically
regardless of how the components were found.

Intel is going to submit their IDXD SIOV driver "soon" and I'd like to
pause there and have a real discussion about how to manage VFIO
lifecycle and dynamic "function" creation in this brave new world.

Ideally we can get a lifecycle API that works uniformly for PCI VFs
too. Then maybe this gets more resolved.

In my mind at least, definately no mdevs and that sysfs GUID junk. :(

> I really don't care about where the code lives (in the directory tree)
> either.  But as you see with virtio trying to split it out into
> an arbitrary module causes all kinds of pain.

Trying to put VFIO-only code in virtio is what causes all the
issues. If you mis-design the API boundary everything will be painful,
no matter where you put the code.

Jason
