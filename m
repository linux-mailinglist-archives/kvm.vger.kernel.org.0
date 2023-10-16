Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A947CB235
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 20:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbjJPSU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 14:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjJPSUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 14:20:54 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A35ED
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 11:20:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bukZ1UlPqM5psvPXkAkyhIwoGZJZcbPj9rUu0SMX+a5lFWxRbJo2nVtoDC4ZjErnVCt1O0H5WM/k104fiTvEWcEgHQ04wUMXrNOq+TE+eRF1rkZiZeI5TLR8hveA0/PC2YGjwDb2jj/ajF+GSrABkH7b8FIOyGR0SfdpSxURqdaBXsBC4zDb4bEKevtE4QcPWhbQy8QBnlUh5exWaBndq8nWb+QX/BzJOGIjftAEcwexjA24lwS+fV4WL7++4vt1CExDbGyjpF+folL0rfdNTzlbYORdY6VSdnKW+T6gqLw/Jd7mDE7AHXa3I7pqQ8ZmHtJ94CesAjSQ0mH4ycVWaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRGOq0T54ne6P1Vss+NxJT4BtQyrqXf+R5kRrlyQMpY=;
 b=UM4DbWTFW8dwWpDE02b0wic86Oh7P3EVWV95165pd231QsiJ3k7ixTK2TdCei93cxIhYjGLUHtFf+2jHUmmefj1cKY6gWJmyoo83UxRbUeUwTBZioZdI0ddglm0Mu4LDXA3ko0UA99y+JOq2RiJzmRr3i9bjYOGPkk2hybW7HtWHXqeBc0esW6+q7AvBTsrSAuroym6cr0+APhPp+rFZP5kilbNLAPRKPrHbrZn97hBOrGRFxhbViVn6xCmLG6byQNVUdJWj/Eiue1VjE3o4RRnELVC6HpL6WpyhzDKyJpzHgtbAkxSevd7o9XRuEq9g7zorNECv4DVydJksdyDw2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRGOq0T54ne6P1Vss+NxJT4BtQyrqXf+R5kRrlyQMpY=;
 b=kCn1VPUgflKKp2A5MRa/QYDxxIQSH/e7xv2E2ZOWxfKtzK/0kh4Minkjutler14p3HbvMA4foiT1oEeIkMnl71Wqj6kDzNk41v6ZmK2nG9i+eTiH9lFD413tqeh/scQbNAK+3vusKDrTJTg4dQuW93l7LjAxE/qSX1kiZZTYSKeEY1jO1EYdzpLZ1mShTByiqb8iMIxKS5Q5qJ2pU9OHSEAM+mLRW1OLyZKVymOvIesUEBTklIL4TizEb11RqKoil5G+4TXoPFy9YpTzTQQnUHEk700FXb844m1Ab6lfWIyW0kElZ7oERLXWXUqgNSvZEZgQEi0/dfdf6BVZHPYt5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6865.namprd12.prod.outlook.com (2603:10b6:510:1c8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 18:20:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Mon, 16 Oct 2023
 18:20:50 +0000
Date:   Mon, 16 Oct 2023 15:20:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231016182049.GX3952@nvidia.com>
References: <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <97718661-c892-4cbf-b998-cadd393bdf47@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97718661-c892-4cbf-b998-cadd393bdf47@oracle.com>
X-ClientProxiedBy: BL1P223CA0006.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6865:EE_
X-MS-Office365-Filtering-Correlation-Id: a1c8bf8b-c914-4d5b-d00a-08dbce74a066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kwtc8+rdZUyzkLkfd7MZH7n7dCFNnO30v80RZtcDwck+x25iAXr+PhEjh6A9kLrHiBa3b5jfztW/LomNg/GJjanCSHTpN1j7mAChKTBZzd2qJ3mEYNlkzS/YPx+79JtHGQ7OHv5fZz0sLN3G0GlaPoDbHckQAUFh//Ou7spoXx45KofCUvnzJfZnuT7U1Sc/DXltAPrcgSjjhdXJupe0Jt4PY8rsri25Lqwgoth6549DHc7P1hwxc2DIK3ye2Gib0lh+2rv9AcVsjiPsBjSW59XGdwElvr7aJUYb1AY2RHIqrXtPnpPa4WJeTm2X9O+gE3gASR/mXibIbtxY57oBOs7ZhHitBHtxSRrVsgjdgNpR2AbsHUum0s2wfkSwt36GUQORgGNUBErHzhkrcLuJzp/spw9qhVB6cMHqTDtAfcRNSbKWwJeK4rLalmMjLUJVK0vNEo3gXzEuzbRjmqsxizX3yvp2Uo6zAGL0h//Y26bafIGLgVLtNbfjIfzr1hge4frE82bnpNcfwTeXvtffpH+xJ6CUE0Xj3KmynqAoz4o2Htl3HmoQ/xfhnswHgDJ/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(396003)(366004)(376002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(6916009)(54906003)(316002)(66476007)(66556008)(66946007)(86362001)(41300700001)(5660300002)(4744005)(38100700002)(7416002)(36756003)(2906002)(4326008)(8676002)(8936002)(6512007)(2616005)(6506007)(33656002)(83380400001)(26005)(1076003)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I0YPUxdmpjnxrc5SH5bJXMLWyzPlQ5UJt5V+vTYjFLJXX9+rY0WY9RNTmqz7?=
 =?us-ascii?Q?XN9JaBO17dCPkajfOLyY5UiZzhE5I1LfQkMxpvuKKzuQ0xFl6Y5oQITYdgb2?=
 =?us-ascii?Q?vc7QBL+y53Gj/IgTWqrCqcc/7CuXgFfLTkUttUHSldkTRvV9B1KfMjrMoHuD?=
 =?us-ascii?Q?42IaxVHrW9fJXfkKQlqd0bLl8oqeq93ywaTdENrYZG3KbukfK0U2ATh3UvMw?=
 =?us-ascii?Q?qTWxA2PYVUoi+0IRpcFsZ70Gk6D9J8TUopvgcIU5MtFWqk5uosWyvEnPI0+4?=
 =?us-ascii?Q?tUn+kr7YG7RM5+vlKFaSuax3j+E5nB3K87EvzOqQc+RfCRb6kawiZqvpIlq1?=
 =?us-ascii?Q?mlfvQe4cr6PhYCMlDm5dTg5BY7dx5yI4795LgCn9tnJIv1MfpCmazIVGUhaQ?=
 =?us-ascii?Q?92/aWhBaIaNrc0h6cJnP8p4eCj/CjCkO6j5dZbFI6i0s+jbKZ/QkBwC4PqCz?=
 =?us-ascii?Q?rRoEkSiP/6MG1Jyi76BMPh/lWmkwQd8Yf+cIGg0cOX/mM1FgYrBsWXrTz0kU?=
 =?us-ascii?Q?1fa1f/mkzLtWYDj4vdTeHqR0k9ycoi/ZZSQGYruTtlLYn7xCglZ9eJcif+E7?=
 =?us-ascii?Q?AWwIvWVEvvlFJYn8c9YSWuNqziojd4NTwD1jlyMSwbNDP///OgNLFeT3HmMv?=
 =?us-ascii?Q?X6JzAt3Gd/Yd6skG6CT5K0GMXgHZ8Y270MToVLd+wMD+gQz977Xj4udztRTn?=
 =?us-ascii?Q?zmcmCcLCMnMYetsfOW08j5ja1kM1cqAVJFmu9EmORS6G7b4Jix6jaMJHJDh9?=
 =?us-ascii?Q?Rc8iKb6FrXWlpBB/mViINRN28DulSCXYEh7jvoGsHsqs0oXOnfjz0rzfYbaH?=
 =?us-ascii?Q?HXY7lXVHG5z5HuQ7XQl3Jq6WSRc4pcPiBRk4mQ/rSicIVLx2px0LHCGXatoq?=
 =?us-ascii?Q?oGQwpw0OMM+6gE1pncfcS3nP3iKdlGZTaL4J6phDAp8YYzu9Ye0AWmlpRPLz?=
 =?us-ascii?Q?jpD8Ka3+EsHgFtbFbSLaM8KmmCEVB+5JrM+FZoty0exklCz9yzB7fQq0DABN?=
 =?us-ascii?Q?Hek5lNHLcwdvCY7ilW/X3Svn4ElXTRgryCZMT5idYXlEFnvM5j3LOSfIaSMR?=
 =?us-ascii?Q?z1f8ZttLf14/Dp6SXC4AoX2dFvJsHcvzvQwn8zjUIZP7qmkao/ZVhtGxuaHD?=
 =?us-ascii?Q?ue/ZCQuK78NWnw5RY+/YmEbYSCRoyCdbgV+UiPDexl3O2TJot6XCpmkEmxnk?=
 =?us-ascii?Q?xnkpiKz3AMlKfpKEP+eE3G8456HPoG4YyEaraOU49YxLzTukULPP2v1r7HYe?=
 =?us-ascii?Q?mRekQTGw6kZbe3S7fwoWMAcU9YgQlepFQM+A4wXu+hlgmeKTtSs0eRcdUAvS?=
 =?us-ascii?Q?KsV8leIx4MmzzKrLWB8WAqy0NqCLSjOVNSM9klowC2p/EWfcFRIofbNzUl1v?=
 =?us-ascii?Q?7Ybkz4x5UeUOMgtwS9Is6w1IyrmxU0WQByBMQSVVVB4p3JkQpz2ezaEbQKU5?=
 =?us-ascii?Q?BoyzdcvP2ycBlTK0dLM+BiidkDroO3hElakSffo6P3FkopW+WaglOpnnti++?=
 =?us-ascii?Q?t07rDg0YCK3ptBi6OnXN3Y0ARCQi8xI7izjd4W8G9I2DU85QUO2ncseb4wiD?=
 =?us-ascii?Q?HQ7NaBLhMVLXZ4ahdegcBPNRZx6r+gqsASYw/Y4g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c8bf8b-c914-4d5b-d00a-08dbce74a066
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 18:20:50.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IiSG4X5vM/GYcJbq0f1H6rRWZxrt66LpAPOLaC7NmttUpUo54ISF3SRwMfsemJBU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6865
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 07:15:10PM +0100, Joao Martins wrote:

> Here's a diff, naturally AMD/Intel kconfigs would get a select IOMMUFD_DRIVER as
> well later in the series

It looks OK, the IS_ENABLES are probably overkill once you have
changed the .h file, just saves a few code bytes, not sure we care?

Jason
