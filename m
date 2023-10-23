Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF17D3C34
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbjJWQUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjJWQUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:20:51 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C8FD79
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:20:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTNDni7QM6GMGdw6WEyuAHzgGhro+Pm/l8T9gtJZJD78d41fltyheB8zsGsKEGWmvSwGjToejo+OwaX1D7FebPQQGWACLFFA7bFjw8tiQvevsr0S1Ui2/cID9zyM8tfJgOlz5QR/iHV+Ncrpfau0vhq4dNtxz1/SxLSlE61ILnvsEZHR3GH49b8ysxmcMYTcl2VgEOikVTHTzr4M2YbBJc05BJ7GrUzxj8yDBMUNHNrxACR4qSEfKug+3W//Z7i9Gi2MPFhTlxldnvRg4P3NimGibgALeLw7an3KyojMDL3hBItedbNTVJekmriCTMZ433Maadd4QktAiUqyBYwBqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0BCUkWNh/dRjv6Ktkd4m8Vcq97Z49pjLZvvPo++qc28=;
 b=HOAobl+zDxfOCLnlT/kJgU4xsMhAb4C/KO3MZ9QENHrrM9u3kePtrrwfe4xJL/WiHf2PBiwJcADzoEtSdcjmKKYhe9uhN37LZJBX/UM2qG7uq7upI/zr07cSMQ2b1l7f+nDmcZLnE08ddnyKEHk7y5aSRNE3Dshu2hwtK3TOo9smLu0PIwkGGHiu6D+9UiQvGpbxpGnr9qzv/lymngeXoPNEJCmxfKSdj+T20Gf9Cy0AONbyxDyDJLSwMdLS1Hx0huyW9J3fh+Tyg9SoAVNmFbjl828SQ4mQELNCQr4pqkXCJC8yTmCjH33Q1ie2uqTTwqnDJwWVPNoQGXvFJrKfqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BCUkWNh/dRjv6Ktkd4m8Vcq97Z49pjLZvvPo++qc28=;
 b=TPi6RLTz+bchr/YnSktbcK3fKTPNs1sLl/c6vNGiRuCLsS7MTs7D6CyobffJ+4ag75YIdwOGU2m/Rf7oHno4ki+cb6CDOJgAmnvFVYcrkp9r5gKipSmnqjDML9GUFaF1g+jJbXLBN+pWiuZwoZ240JwpchcDABvtarfZIMjGfHuhQqdoSjqTUIFtNXfD1jvyZjV1/bguuHdcir2GUMgp1/ic2Hgne6B9/1qzZxvTikMLXU7vLhEGRJ+9XXTqDAZmW18DGXZw2tEC/BXo7p0+gfq+C4IlefkzldYqprIFgc78vWPxR1ki5BVTuw4R7KfHRvavKrTWjJAXfr6lxJWPPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB7447.namprd12.prod.outlook.com (2603:10b6:510:215::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 16:20:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 16:20:45 +0000
Date:   Mon, 23 Oct 2023 13:20:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com,
        si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com,
        jasowang@redhat.com
Subject: Re: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231023162043.GB3952@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
 <20231023093323.2a20b67c.alex.williamson@redhat.com>
 <20231023154257.GZ3952@nvidia.com>
 <20231023100913.39dcefba.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023100913.39dcefba.alex.williamson@redhat.com>
X-ClientProxiedBy: SA9PR13CA0044.namprd13.prod.outlook.com
 (2603:10b6:806:22::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB7447:EE_
X-MS-Office365-Filtering-Correlation-Id: 267c0ba8-fae6-4535-2bdf-08dbd3e40273
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ZJhJSrFLZ5TBsjMRlVBMHwo9USKNl41YUNkpmD2nNLBtq5Ng9RGjddVAzMnuU/avIt3bwhwFG2gLJvZ+iNLi6IsOaYNWk5gjo5LqfyTjlFUus2rMkElTBJzJ33f4vVzLq+BgpChLGSUc6/6l2rdgPeo1TCgP7Xl+N8bdozdNtSp/RVSw/1/U1Hj+mRz/S42sYG4fnoUywVkLEaZT6c+4LY+IGw4R99ndN/cAATH4BGGjP5VaOTHC6zxXsGsTTzfiFPV2A0y8aeP/30twFIfD3SC+8J4cS2qdMAmr5fILJ3OKK7fi8QGUssBnNsP3AlF3bnv1qRIzFZ/mUP9cBTprtgW/rGOOlL7OgbQL6jCUWPees+iD57D90XS9bZlWO0BZect33Uhy4Lmj2pvSoEC8zhfS+pZN6sFk6QbOHIYW7DmJnXbyZfZOd4a5aWNIKywMsG9DyI9SUAJVPyPj99PcqLlfub9bBiBl3hq94KG7U/h6qZ3dUwrowdj9I6b8Gt+4bF0T98jTBRUUcDsh5O4H8ZyfSLgvyjrQHk5uV/ExEaqW81Jxx9SWzqALrAycmlL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(39860400002)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(26005)(38100700002)(2906002)(41300700001)(36756003)(86362001)(5660300002)(4326008)(8676002)(8936002)(33656002)(2616005)(1076003)(478600001)(6506007)(66476007)(316002)(66556008)(66946007)(6916009)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wJ/w2BrafAjTo3Qf4r6kEK2YRrw9XF7cIk9hxEejJCfBDAGp2MPJZREEzllh?=
 =?us-ascii?Q?PDGWbWk3fmScf5fA2rOVOnIgNjYsVeq5ry5FKaoQlcP6McOs7T3+03AtMyxm?=
 =?us-ascii?Q?fW8NuFiw2qxM8p8NiXnH//jRBeq8T4O1rx7RinP4GGi3/IahBb3EqCb0zA5T?=
 =?us-ascii?Q?hfZL15ghLqMswz/o+6N+gfyR/QfzC/Fko/nYv7YEtMzyyaXsUGWmOAGKsD7Y?=
 =?us-ascii?Q?l227eMlAQizOKID7KWdb19WcBzMM6vK3Yw/ivQ1gdBNnCZwuWR6sIQMRcajB?=
 =?us-ascii?Q?0eaKaVODpG7aGYa8Y76wq4KYcs0f/x6mP1bbySFsbtcw3+kSMYVJwbGwuun6?=
 =?us-ascii?Q?NxXyt/SMwpayXiAEKue+X6lwlwW/L5YRm/t78SQ7TFWZtMG4o+/chLlpqGVt?=
 =?us-ascii?Q?jWd2t3bSUzbYsx8gilWCzZObUhTs3ZvaNuzh81+99zUW3Svb9VcYKiCY+Bjd?=
 =?us-ascii?Q?MF4seP8gmnyfEXSBUQvWxbR3kD1FmOsyul6EnRw+lvdr5hjNhyzumX48POH4?=
 =?us-ascii?Q?s0G66EKLRgubr+jsxxi147YET9WkHZZZef7cErCh8KgFGWwT7UnQPaKOmoIP?=
 =?us-ascii?Q?m8nt7TgnkpsUs82bqhbkIVdQElTcTxMsfMGq7ATtuDGQKi+lDmFuNEyY05N5?=
 =?us-ascii?Q?oEk+MIY9rDgCZ6kSsIM1TolR9Xrt+30ARD4HXM4/RF71rhyeTI4c7OUfGC7/?=
 =?us-ascii?Q?G7wd8v6c2Ggtre5Y0LeRZVpPpcc7Yjs2jY6+cQOeXzWhdoe8Yb0CF9p7xpMr?=
 =?us-ascii?Q?x/ONAdf0rFvmPJxTV8l9LSCBGaHTkwqy1SgZrmm/mEq6KRckQNkqfKnjmYb5?=
 =?us-ascii?Q?aIegxd0GvQAwsmIi+rvSFH0/rWtGugxrOEdTQ3U4zDJbT6TXkwqk+az4+s4N?=
 =?us-ascii?Q?Y3kZxsKP6O1lwEvsc93x/lWbNjR21oHYIgxilcWPZcFCktqK6yIV1R2tTG6s?=
 =?us-ascii?Q?7u+ANMAitlOot7MCwpTDzB/nLupy957fYPqKQ6M6ZfLAdWOOkW9cxClkyXe4?=
 =?us-ascii?Q?FsQ5mzGklrFPzf1jcpZr0+4PFU3BC8y/nqIe/mXb4/RFiO9MYj4i1yFsJLp9?=
 =?us-ascii?Q?rDjm2FxuftRy6VIieYPBdzML44d4/IrSXFLQuO06APAIoN5qLsghYzr29oTo?=
 =?us-ascii?Q?4lhf0XbqhVCbKmun7YgBxZNQSDrCQqxWrps6q+ZfptrGSDiGt/tIE0NE03RX?=
 =?us-ascii?Q?pTf2kcj4Yhhq5MbcH/FiU8/CvvAYYZ0qtj3G+9LWlZLfqR9am6I1OHfcxCgl?=
 =?us-ascii?Q?OP2yXjokPH2wlwi0e70VDoshG+VPj0wNqzEq4Vbuh69goRz+vWolHHCHyFx5?=
 =?us-ascii?Q?LBgc2nalT0C5AMFucAQcUo8xBbi2ZTDGcDRSXESDaLUAIo1js3R1VO6dhBcb?=
 =?us-ascii?Q?Ls9+b9hmPY0Uo2yzuvbH4R7f1g0E/mtRcLHr3pAN36tfFA22zMwDLZKIognr?=
 =?us-ascii?Q?Aag3Y73wmWzfTgGXcEhWZAh66eT3rBMjm+H4pq389Vb7oU+yf59EXyJO9Z6m?=
 =?us-ascii?Q?fIhBriwyzevjMlWH12Smw4geOD7U09VVu0E18WfTHotIHgZUYLjyAglAZ//h?=
 =?us-ascii?Q?HkeVSAE0YF6nqJ6B7vY8mOZJWAJVHmC+Dnv7BwcJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 267c0ba8-fae6-4535-2bdf-08dbd3e40273
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 16:20:45.1658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qkgqol3yysut/qd2GF1Qq3IeW4nK/axS8LXgeNIi1uOKn+kFlDIBkOMOdEgTJtXH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7447
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 10:09:13AM -0600, Alex Williamson wrote:
> On Mon, 23 Oct 2023 12:42:57 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Oct 23, 2023 at 09:33:23AM -0600, Alex Williamson wrote:
> > 
> > > > Alex,
> > > > Are you fine to leave the provisioning of the VF including the control 
> > > > of its transitional capability in the device hands as was suggested by 
> > > > Jason ?  
> > > 
> > > If this is the standard we're going to follow, ie. profiling of a
> > > device is expected to occur prior to the probe of the vfio-pci variant
> > > driver, then we should get the out-of-tree NVIDIA vGPU driver on board
> > > with this too.  
> > 
> > Those GPU drivers are using mdev not vfio-pci..
> 
> The SR-IOV mdev vGPUs rely on the IOMMU backing device support which
> was removed from upstream.  

It wasn't, but it changed forms.

mdev is a sysfs framework for managing lifecycle with GUIDs only.

The thing using mdev can call vfio_register_emulated_iommu_dev() or
vfio_register_group_dev(). 

It doesn't matter to the mdev stuff.

The thing using mdev is responsible to get the struct device to pass
to vfio_register_group_dev()

Jason
