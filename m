Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7769641B56
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 08:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiLDHiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 02:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiLDHiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 02:38:21 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2086.outbound.protection.outlook.com [40.107.100.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7D4DF62
        for <kvm@vger.kernel.org>; Sat,  3 Dec 2022 23:38:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqnHieMqG/pqi00UJlR1xWCh8JXbIAhgLuveKboKLq2KjlgaXclej1FpEzvq3ZDdNaH13exVJm8alyHGMxcxNkWFlBUk9FmVGATI5t73H+l3kpBxJATKeZ/XC0Y4uyGGdEaXefqsN8Xz+nde0+bUpehJhdRFUftpzBL99ypu5w/6BEoWSBEzZgNA0DFKy5wloIoevdCDmRm4XrbRxw6eI2hPpaT/JHGHWKtSS8cRTk0VPMW3G1trRLc4FgCkHdyXurwZ+mFlPlLA3jV4ejwEcyy83+Ti2JwGTuKJsjtilUZ83MAr7Mp4tvmAXyOgHK4xASEhWpRMY7Ynargj/ykSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWIsIB7LOPrAlNBlLMiFFaRpg2AJo/5h/pOFkHODUgQ=;
 b=CfTnISiudMMoorqFZWAXWUr+nElYYiQsIAxx5AQpTbnz/BDJmkO5t3dpUCN/hrt/UI8iQQY2/RwqihFaBwAj0vHkB0khofRQqJ97hHfp+ifOB5Eft4emM/o5JwpSO6Sv6Ofc0gbJuW+FxjqVG3DhCHkeI7ybVd3sb0rXdOdenB+0OjSOr2QzMQB9v4/HKeNiKv2XYGbqke7sLX4D0FTgYeMoix/TUZzQ95x/XJIpAtv+I1Q5g9bjS7GMzqOWF0UEVqJufDKAv2DjkRTKm2RPyU1LqgN/SkQ+WB//yeFnARz26OLlMl7iBxGW7xVk1b3njm2o07i0bYi3HLkIGZCOXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWIsIB7LOPrAlNBlLMiFFaRpg2AJo/5h/pOFkHODUgQ=;
 b=DAjSu0g5If4E3HlXoBhwdW5fOmRUKDQfjiSAdlMHRaPAahsx6pO1SJC5Vm0wWTk0OLT8kdvdIGA5mR7PHdDkkX5IRPPi3oXMqeIvARK5klCqSD2xy4m42qFP4y+fzU0hmRN0q8Qlz9QswrpAV65KINQrRaEwkBqwLAKOiXchjJD3aW0EKCPEFGbaoBJlGlb3eyx6/4MfZNkljBpHIMnFMWfADdRiWxu0Wv1wgFIgPJt0dCCMo8wiTY2dK7/nL7xYXdiyih3cLijPCZM1MohAsI4GfA/5wJEVHGhczTdu2O0x6hSwxILsZtRmm+FQ2rZgAICCrqOvZgzLzqbXqKvVFA==
Received: from BN7PR06CA0060.namprd06.prod.outlook.com (2603:10b6:408:34::37)
 by DS0PR12MB7899.namprd12.prod.outlook.com (2603:10b6:8:149::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 07:38:18 +0000
Received: from BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::4a) by BN7PR06CA0060.outlook.office365.com
 (2603:10b6:408:34::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 07:38:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT071.mail.protection.outlook.com (10.13.177.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 07:38:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 3 Dec 2022
 23:38:16 -0800
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 3 Dec 2022
 23:38:15 -0800
Date:   Sun, 4 Dec 2022 09:38:12 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <shayd@nvidia.com>,
        <maorg@nvidia.com>, <avihaih@nvidia.com>, <cohuck@redhat.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V2 vfio 02/14] vfio: Extend the device migration protocol
 with PRE_COPY
Message-ID: <Y4xOZG8HaRWyp+nL@unreal>
References: <20221201152931.47913-1-yishaih@nvidia.com>
 <20221201152931.47913-3-yishaih@nvidia.com>
 <20221201154346.58e49361.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221201154346.58e49361.alex.williamson@redhat.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT071:EE_|DS0PR12MB7899:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e00732d-d7d8-4371-b00e-08dad5ca82b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sZK6zfUa+SX+o1HRLUY+yzQntkzheypJ4VBCr4OUP2A6cDpuDFF2J7t0qo7/xH85IjLpgeYhOC2jzQjlpKkK05UTk+cfYLMWvRbbVQYNstIyNod5BBdy2UjaMD/2j87PGCkzakQ0/rSyO0L3B5FsS/dwqoINYgICMoPbkr7YFS+oG/52GDhCS1M/H5ul2wlBhN9RRMiRQWWiXcwQVSxFBoSQGokQYnCZKC/KxmhuDW4/WW1HqCUsz/M5lDd5RF4A+ObFoS4n1lgl+U0XF4RWzVeR+40slF4Dp9hL3D2GhpcIOUDHHiQ1M+folU1FQqPmoQ/1dSVncPAhMsciXQcyG7HUDIyUeixInEPl5W2qziIVXKjNfzEMLfOMScp/WQT+avBvjpSzqihF32A/o79vg+ACxicWHyG8t7C/LfJiHFBP7OjgNivNFVD0u8dK5S8wUqcbO7kQeK70C7pajr+SFvCFYBOGxvXwQpiuqm+28CdAcT7gl3d3e2g809sk7f3Y8fMGM/2mcgEnN3HqB/7mNuW/ClDH6karfoiECGEtdVdoWrtFrPQ+FuIsMaMAkm/TrIjBHSB+ceXrGekFMFQ7zGnFExkABD6qOn3oJ/Q5Db8SBe7J965bk9+yTHkK0oW7uw12X2zLSt0Pghd2Dtl+WdWCAD7xrPTXtqvujE7EppgPUMjALNjpfw6tO5W+LsnMfGTwjeG97MRJOLh4IgxeD91GKpYU2pGc8wKm0A2bFpI=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(33716001)(82310400005)(40480700001)(336012)(47076005)(426003)(316002)(86362001)(9686003)(6666004)(26005)(6916009)(54906003)(2906002)(186003)(83380400001)(8676002)(70586007)(70206006)(36860700001)(4326008)(41300700001)(356005)(7636003)(40460700003)(82740400003)(16526019)(478600001)(8936002)(4744005)(5660300002)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 07:38:17.7657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e00732d-d7d8-4371-b00e-08dad5ca82b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7899
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 03:43:46PM -0700, Alex Williamson wrote:
> On Thu, 1 Dec 2022 17:29:19 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>

<...>

> >  drivers/vfio/vfio_main.c  |  74 ++++++++++++++++++++++-
> >  include/uapi/linux/vfio.h | 122 ++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 190 insertions(+), 6 deletions(-)
> 
> This looks ok to me, so if you want to provide a branch for the first
> patch we can move forward with the rest through the vfio tree as was
> mentioned.

Alex, feel free to take first patch too.
We are in -rc8 tomorrow and I don't expect any merge conflicts.

Thanks
