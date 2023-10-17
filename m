Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83087CC759
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344122AbjJQPXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344029AbjJQPXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:23:12 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13F8BA
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:23:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0hixf1R0d5fYP25q8lCR7YEctPofrRSqsuvCs9lsm6sT7dDRE2+TBhQP1zJWVKt+QwtWhkmkt2pXdlRPy7P8wboebYcFh8EmwSaKPszBfaHJk0oN6Y78zp6nPjEnkmnx0PuFvTaG9ThrW3WvE7LpdWdpMKaCQ332rPyItm4Qeh+jtq8YyOKewXJUyOonGxx0C/F9KHeXA9SEu1brlaO/jL6Y0khdA2fGnbRDgIftGHrvUQ3uwJoRG1XsPx6NBLrAVdn/ofgZAeEfhIS+bc1Ulx8kSjhR1cGCD98pm0vNfWwZRN35G7Q8/rLU/1BA0Tgrp7WopvsONnCJdUMxMxzhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2pLXmsE3/aysjxcfe8yxPKqG2gpmMaH5jr/XIgK2fg=;
 b=hjDJTMdgBF60hPdrPhaNNDJrEpwGUh07UAuUUrI9ecbnUMXnmq/aDWldiuFPGsejWV0vmus9lQXJ3cBSliKbsJjDWNhjDX7IFGpt9BWMbEANj4NKBH9iGVvdUSXvwqvbH6EYgPniHXjpp0XmiABYf6zz8EiFbIEoB+q3Eg4+w5QMTu1INjPEcURQe8BN48+EfXHAIi3vOQqb+Ug9VLm1sBSUSI7KuFe+sbq+0GXObKxS0llFWktSAjlIHVt1RB4cBBH9FwxppmSVTzUDGStx60Th4WaN6VpArvN90p2z5I+qrHRtwp8QmyCjz6xVvUgeoMIT53ycAE1s4aRdRX+y9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2pLXmsE3/aysjxcfe8yxPKqG2gpmMaH5jr/XIgK2fg=;
 b=svEQBLREgHy9BidqkbH/xNyo9loU1WmOc4UPGjXuof9bEVERd6j2QQ1oGCrOM6CuH8dzuMoVLVq3tMg4DARRT3Hxn7FCAdi5NMbs5fq/Udh/oHP6OBN8ZzL/SkmDBaqkze/5Q2ituDZyNfnOE5vTIMkFr1979PnvULAnr2QvCy0t+ndYCxnkHZ0liCaElWx51HiwEvdAgQ6F4hn1/0aPQiKUPCdgKl0dS+g2NZWBYwPDBNHWkKFAtnjM899ggTOWxrzME3BM2y9bJGUtyxXcHFfKrLlLgQwGinyxFlsL/eTTrUm6wytGMVxvDI/NaZEkIPqgo/se81BJHHvJhnrABQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5065.namprd12.prod.outlook.com (2603:10b6:408:132::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Tue, 17 Oct
 2023 15:23:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 15:23:08 +0000
Date:   Tue, 17 Oct 2023 12:23:08 -0300
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
Message-ID: <20231017152308.GB3952@nvidia.com>
References: <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <97718661-c892-4cbf-b998-cadd393bdf47@oracle.com>
 <20231016182049.GX3952@nvidia.com>
 <6cd99e9b-46d9-47ce-a5d2-d5808b38d946@oracle.com>
 <8b1ff738-6b0d-4095-82a8-206dcaba9ea4@oracle.com>
 <20231017125841.GY3952@nvidia.com>
 <ee2fcf1d-3ab6-426d-a824-7547a98dd1a7@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee2fcf1d-3ab6-426d-a824-7547a98dd1a7@oracle.com>
X-ClientProxiedBy: BL0PR02CA0142.namprd02.prod.outlook.com
 (2603:10b6:208:35::47) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5065:EE_
X-MS-Office365-Filtering-Correlation-Id: fc43016c-b43c-4999-b360-08dbcf24f7bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbStn+66H7KuA1E/690lY/CSwB5+n06oct8wAYcWUtiDcw9+D0YE+vrMtQaNhgshunPvePbQtJylWoD5kAm1ni+pab21eE89TXV7n7BtE2MrVofkXXl1QybJsGjkntcOJeI7mKL0sLO6CMRdAmP0Bj1qZN0cE2HDKtohbzWUWx8kW79+jSdOkqo9TovFsTDEudOatN0Y/qA0PljMOWmWe7TEviddBylHsdhsa5N4XnumdJzIvJ6KXfVVf6bPS/ux+YhuB80PG5iBbPK4BQJVugKWcEuyqf7zsvEo5wecE/TBOhppglRf2dLwkdXiXCFfd4DWVfDW+Xhnl33pRTvKuCj7c/XmvbvSL9fbEAxbppB1dtkIBYYWAvW9xWSoGUlY1s0oKV8MwpovMQgo0uG/sjfXNF+riJqm/7ryZ+d30H0qtpeVYBrDctHnHBED4Uidn9GsodYqI4pQFB+h9NNPK6edP9OuQYtxCy2h43R/Cce9NU6/euvo3iH1L53CUefwPPVYE1wZVDv04KC5QG3XDwOZK4vDbzsUndbPuapjI3mFN7vipVAR9qylZ1DmNpfk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(39860400002)(366004)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(478600001)(6486002)(66476007)(66556008)(316002)(6916009)(54906003)(66946007)(1076003)(26005)(2616005)(86362001)(33656002)(83380400001)(36756003)(38100700002)(6506007)(53546011)(7416002)(6512007)(2906002)(41300700001)(5660300002)(8936002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?56TkQhOMAmGxP42aWCdX8xSjiYk8bUf11IS9zIwi1ZP2E8q2sZ7rNjA4/oUM?=
 =?us-ascii?Q?zdVyPacYSActerLoG6VYh3hKEY7QNLMc08JsWsnkRJshBLSk5BRg6o1er7Z5?=
 =?us-ascii?Q?4BBA7vBv9so+crlN0NJd6iLhgq+g1Y68Re5/NPaYZRvMYS3KfEZM37PAv/78?=
 =?us-ascii?Q?e7dgKmE+Mi1RChnH97tQfRiQg9Sw6ezuGVMCXeiyZVUPhqo9l2JijTvXlllj?=
 =?us-ascii?Q?78+snsvV6GqqVla5IiWmec+ZC/IplbgmLqFpzSOdEACRBMnJBaGbRsmevfEl?=
 =?us-ascii?Q?TFzXIj5Zdxr/flAR2+KUi+iqIoLrcEClWmlD4wGU8z2yzBDbyXF4Du2F3IdZ?=
 =?us-ascii?Q?PLJR3OXJsdff8Kze6sAvKTwODyeLfyPL+10sjke3h+caWGkUp+qp5qZsm3jk?=
 =?us-ascii?Q?+WJpYhoPHD6KT31QKXEcxac7sez9pUwlXM1a5p8CsNXh/9us6l/ajUhEv97a?=
 =?us-ascii?Q?9nmqb4iLrsiryZ46qdgzKUrOZH7uy45LHQO7FNqxRaDtou3elqOLTRWbEA16?=
 =?us-ascii?Q?6+uAxn5GCFW6L6SI8SylM95IEX7sWB+YzaY3aItgMrOBpvnTenaRkBccDBkA?=
 =?us-ascii?Q?SzQeGePdKgyuNdTz1hnTDoDgL7CgVEJzF9hhCo8kb9JmmIxa9+x379rwstO4?=
 =?us-ascii?Q?guQIVsEGjx5ve5r2OA8Zg+LHbPqgpS/pG7ozKYCU7yYKaFgrYmNQKES+T2Yd?=
 =?us-ascii?Q?FIJjWUEzpSAp5K1ST3I6HTLayS4LAtt4Q9eAjTtrk1C7nlw/MEyU6AQn51J5?=
 =?us-ascii?Q?uD9CEjNJ9TyZlI39ajdeBszGwH5kM3FCoT5usW071+sokZ/3u5CVAeOqHHjz?=
 =?us-ascii?Q?WIt30Q7cs8lC0T9DzvuK7ZSgUAWfOrGOCRrHvs6cMUK2sLTjvdAj610WyJdH?=
 =?us-ascii?Q?WTOkS1cbedtNISLgfP2rJiWpAZLTTxRfnsjkcj5ghixdpZbDpGIbQwYO7Vpa?=
 =?us-ascii?Q?RFxyc29bolkpdju9/u6cn9Em850d4HglhZQ0AS8rhfr2yH1b2vvWHUtf5Xi6?=
 =?us-ascii?Q?933mayHxy2mDfpuuygXG+qGCHjMeSa4+v3gphN4StqpYaN02KDICAxoDo4yk?=
 =?us-ascii?Q?ZIFHgHcwAZZm3dt95tbJpQ1F+WPSM3TSAjPXnDNI9fadpx96ShBgr/w7fqSz?=
 =?us-ascii?Q?wZGKhaKoFydhjudJ4pDJU7w7USqCJddShmuSA2SfpogueMc35JiHYmml+RwF?=
 =?us-ascii?Q?DWlcT+fWpGFaLMCPqkP6IXBZQy4Gqj54BafRFO9B73GgsMJf9vpIxVxAbqz6?=
 =?us-ascii?Q?3VsmNtO6NyNG6+5YCJfVM8f3jIdi2OPOgDznIHUbMr1kZlR8TrSvRMyiJz8D?=
 =?us-ascii?Q?/4/UC2FC2rm2Wu1/zWyLULjlSG3UOUrz+RAxKk/wCLgBqWt6MkY5V29LAQaP?=
 =?us-ascii?Q?pNrR96/srvA4YBiNpsF9oahe0/otLcILR0n6V+3cQ/tAKv1xBhaAAEHaV7hz?=
 =?us-ascii?Q?x4TvFEDwRae2bA/a/ORSZDDeFdt2EqK+dSUJe4j/ofQV+6n/3NJnrHS4pYIv?=
 =?us-ascii?Q?kZ6kdQJlJo8cdBw27DLxLXqO9WBZak/36X/7Iu63ItW67EK1Q4K+obcHHfmf?=
 =?us-ascii?Q?T9pPpLJ+2O2g69GbuLC4f70Fw9zWhXAHrlcj2vnW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc43016c-b43c-4999-b360-08dbcf24f7bc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 15:23:08.6358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkK7yW63qQl4MSkEEv5cpHjcHAf8D3TcvzjLZkC4fqaCKmAQoqqx8o4sCtsY1fcy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5065
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 04:20:22PM +0100, Joao Martins wrote:
> On 17/10/2023 13:58, Jason Gunthorpe wrote:
> > On Mon, Oct 16, 2023 at 07:50:25PM +0100, Joao Martins wrote:
> >> On 16/10/2023 19:37, Joao Martins wrote:
> >>> On 16/10/2023 19:20, Jason Gunthorpe wrote:
> >>>> On Mon, Oct 16, 2023 at 07:15:10PM +0100, Joao Martins wrote:
> >>>>
> >>>>> Here's a diff, naturally AMD/Intel kconfigs would get a select IOMMUFD_DRIVER as
> >>>>> well later in the series
> >>>>
> >>>> It looks OK, the IS_ENABLES are probably overkill once you have
> >>>> changed the .h file, just saves a few code bytes, not sure we care?
> >>>
> >>> I can remove them
> >>
> >> Additionally, I don't think I can use the symbol namespace for IOMMUFD, as
> >> iova-bitmap can be build builtin with a module iommufd, otherwise we get into
> >> errors like this:
> >>
> >> ERROR: modpost: module iommufd uses symbol iova_bitmap_for_each from namespace
> >> IOMMUFD, but does not import it.
> >> ERROR: modpost: module iommufd uses symbol iova_bitmap_free from namespace
> >> IOMMUFD, but does not import it.
> >> ERROR: modpost: module iommufd uses symbol iova_bitmap_alloc from namespace
> >> IOMMUFD, but does not import it.
> > 
> > You cannot self-import the namespace? I'm not that familiar with this stuff
> 
> Neither do I. But self-importing looks to work. An alternative is to have an
> alternative namespace (e.g. IOMMUFD_DRIVER) in similar fashion to IOMMUFD_INTERNAL.
> 
> But I fear this patch is already doing too much at the late stage. Are you keen
> on getting this moved with namespaces right now, or it can be a post-merge cleanup?

It is our standard, if you want to make two patches in this series that is OK too

Jason
