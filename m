Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F25B7CC783
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344398AbjJQPcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJQPcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:32:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5B6F1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:32:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JsuU/EzhQMYfpJ4EscBbDSM64UueBNkDSlUXDDgVGjnSWtChiGsziv8dlRHhlwOe+YqZ4yNwZA/K4iJpYPMIHxhHp6udUHr429gwEzqiDPnV03YzzchJ1G53G5sOfWhMkSlT5VBTtrhAO3q1tk8anm7v74o10EPOTcGLiwZgFLdWUB99giofgEQ72BLbMePjfPXtVOUPUaJ725B5rYpEIO7LtXC8OSzHtkCw6N7zafQ97mPhBXY5UBCHaVxwtS6Iy7HZQxkcFBm4SW8J0kBLaRHJ4XH+HQtajTCotQIivIgM+CJZIoVKMkFXCFYbcKwYD0BBclLmjYsxp1auVKznbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EA91aYwM/iHLCLdfKWs7Ja1Auh536uWfkshBHuu9BCE=;
 b=e/A3z/94smvbpi2qfWbHkNhmOj8lMZAYB5zFG8B3OTvYxbsU1fmWYFO9LuKwoSquh9nNb8NcNKGv4IUjKluf+R3595Ps3SycCftUGYfFwj/DFmqRtwHh6GSXLtVj1ffrUqmWgs//xngRVufdf+9dMexWTKWdpmxjIlUGXBMtWzlzmLGcd/NqdMD3+6QeHi3JaE/AV2yJzRtfdNreBfCMTio883yl++N/+8iIb6DGYhy01RKFs153R5cyBWbUnQXNL42Iep8m6tOkzPXfpGwj+lfGO44B+DYG/I7JrQ5B8wcmzXpr53MHjRp5EcEFGgwknqTh5v5OwgOs5aiEXgDcTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA91aYwM/iHLCLdfKWs7Ja1Auh536uWfkshBHuu9BCE=;
 b=lO9N3kL7Scc0d29dWmTzh1UZnCikA2iXGhtcauLxk42rV51xcGyuFv6+aDz38Wm0l1MGg8LMeZ2SVBhGDLxnlWSseD1PnTYBHz4BakRHwZmC9x1g7VwAoKAoTCn+C9g/RFlQEuJ8gO0pbZ08JBHozJ1CnIo/yWYrHG7nZi+Mi/me9ESHisF80wVDVvvhLYqR7mNcBBRiLAepXkNzs3VPry65BVe6MblO/yIdELunRwnmYHqefWeRbonr2ZcauNm0cXzR5WWAcIAi5MeNZ6n1FgeLGy7I5ZVA9I2wlgFbd5hrnbrc9PGzpVCjxVYOn7LYnRS9nlArI+qn4qbM02GLnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8876.namprd12.prod.outlook.com (2603:10b6:a03:539::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 15:32:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 15:32:10 +0000
Date:   Tue, 17 Oct 2023 12:32:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 16/19] iommu/amd: Add domain_alloc_user based domain
 allocation
Message-ID: <20231017153210.GF3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-17-joao.m.martins@oracle.com>
 <6c1a0f25-f701-8448-d46c-15c9848f90a3@amd.com>
 <401bae66-b1b4-4d02-b50b-ab2e4e2f4e2d@oracle.com>
 <20231017131045.GA3952@nvidia.com>
 <8f34e144-0ec1-4ca0-9e41-29da90aa7aef@oracle.com>
 <b9e0a47c-b860-48dd-b6d4-b59838046c9e@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9e0a47c-b860-48dd-b6d4-b59838046c9e@oracle.com>
X-ClientProxiedBy: MN2PR19CA0018.namprd19.prod.outlook.com
 (2603:10b6:208:178::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8876:EE_
X-MS-Office365-Filtering-Correlation-Id: 27fe1bd8-74ad-4fc1-99c0-08dbcf263aed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqFiK/Tq88sUCN2RM9PFHkTF59cNyB9pj8aNYux/6XitTB9eL06+PnVdjVcl9lDqxdSy6L3IOrX+QFYVxMLgagWpYQlEJqGGwdofKS7kKjOAIbBG75sjLH+XtbqwhLjA8wAEDYieWFyvKqrb8MTV8xLKgL6pjoCdu9vdjyhb+ytGxf4riRjn5xaW92BW7EF5NHPCWBbCFXIMTJVw9EuTy2xoph+IZu/aJXAvFJA4a+ZE/ZMJe0R+fgSgTTVLUz6RKhJyBg6n4BzFRbv/ywc/+2s105E286F4vsEw13f02NMw75QfxVDSnQ/PP62lk2Mvf/t/glN9cXGFX1clj3WWxS2H6N4Cr99ySkhCE191EotvV9yI1xbwpm9ZxvNIjSzcX3e5P3nHpCfuY3MDixCF7hEYIYP7+vhe17WndkypBsmZR62phxCDMKzzM6/tY0cnQ6yyHmu34LDVpkpPrv38AcEOpbUjeUEey7nWId8DMpUTxHkIW+FjUq6RqY/i8quiHgI/Xe6Ffe1n21eNtLGkoKlCZDrUVL1w5bfpMONQkfIUzV2Eo/MIvJdDe3yUaAQKwLNZgDCaOQkSDu55Vjuo6I8EljzCyEaP26Xz5CHJN5U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(39860400002)(136003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(53546011)(66556008)(26005)(1076003)(8676002)(5660300002)(4326008)(8936002)(2616005)(36756003)(86362001)(41300700001)(966005)(2906002)(4744005)(6486002)(66946007)(66476007)(316002)(7416002)(54906003)(6916009)(6506007)(6512007)(478600001)(33656002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lk88QPfMd9inoHHqQoMMaq+m76J1OqHkc6nP6/O6FnF4yeizx95YBfkgqkLh?=
 =?us-ascii?Q?vEjEsLhifNoRaFAP34g+D/pvi+BIhjB86admAqhfRo7DIqEMk7Beby7MxiFs?=
 =?us-ascii?Q?MHIgZnanm8oXn/N7d2zYF9iz2xEbSmsLW4hvqCe5WPrT07Mtk3/D2qwD1KeL?=
 =?us-ascii?Q?uGVXPke1HmQZBh7kW1oSxb5d32wkmCmEfJVY3+J5rgInH1Vgpb+zGMWL8kHo?=
 =?us-ascii?Q?BuB13Fl1U78Cgrnvey00/S4dSxaBjqUPpdCZVgh3NqQJ8mnljETkjfxBfpZ9?=
 =?us-ascii?Q?4H0aIi8alvRzdYlaBWQ2duumXd9ZN5fqdXk7vgZdSj3Jwn7WbhenVbAU+Vva?=
 =?us-ascii?Q?MFW0cTXpOwNiJz0JSXdd+QpPWbg+hqjW4oEMvNEPssQNthwL3LmpmbFQTV6b?=
 =?us-ascii?Q?DLWdbzHTdGPUg7funKZrruCg4V+4lvfpdPSrVeZRAZvu4/2eCrv/5yHueMCR?=
 =?us-ascii?Q?5LwCJmK3mn0VQAerDVy+LzJBt+4ODsdp22h7KPXGNc2+srFGURvy0uZmx4Wm?=
 =?us-ascii?Q?u4e6tSYEkyizUjhKVBwuAmlnHLwZsfnGW+GmZe6Gmw8JssN4ui01Kbdii9RX?=
 =?us-ascii?Q?kwPFCtiuk1Q2B32V++qfHWCc4Q3l7aL2HqBq3LnKptsaCoCZ1K6/lHGBNng8?=
 =?us-ascii?Q?9sdT61IfCR4CtrCurKhp9qJH0NAVudiD07/fX8xE7JV3oJr5Jh/mJGPCLN2u?=
 =?us-ascii?Q?uL0ELQ6gIuFMpmjxP1MYn8txpAd1SPKsmIb5yE9kJkEQfSYef3Ij2BtNqlco?=
 =?us-ascii?Q?zdEFtC+wDG+qTg1aIWBPsBgIm5Wkhrvew33mupVggbawUVT5yv7GvBaAh8va?=
 =?us-ascii?Q?GgKdsoYa0N3sOs4IGvQzSd6VF12UViZMZ+qXwHs+l3VoV4ZO9C0azyESuWeK?=
 =?us-ascii?Q?bk7zFV3w2QSCUVZKF9VIYg3VuWZf4wSCtqdRvaG1GV3UqQJhVCtoorZkV6el?=
 =?us-ascii?Q?C1s+aWDk5SqBeVDBgUDr/pHSpCMs82XV4fMGT9iZpeteEaY/VhyuF3LpV0in?=
 =?us-ascii?Q?pSOiqK9ucO91Hbz5n631ixjmyhDimcjxDOHojZV1iiD+S/JENmdR/VjR/uka?=
 =?us-ascii?Q?KVN6BO6eIcjyTHe2aq96Lwk0TKhspt1qwaaRkGYY2Bfozi08CIoicMyVu1rZ?=
 =?us-ascii?Q?TGPh9hPDQNEoBatclluEuNEBWDjWZx8fLLnA95r/30qi4Q2hanzLXbV4D8XG?=
 =?us-ascii?Q?YdhUnqKpbFcljYmEAzOFEbLtxGDBdItwv9mYjJvjN36IBERl35DM3MojI1Mf?=
 =?us-ascii?Q?ysEelGiF7iVxVh0Blg8Yc+697Obt57tLtQUVUC0OaIwKRLFneJDC/Hzw5eya?=
 =?us-ascii?Q?YZPTzFq2hYhpKBy1Sz9X8TjerEF44OQS2VWpY9At0BsKXzcxYVR4EAhgBgee?=
 =?us-ascii?Q?XaYCHfRM3GIF0KncZ5kAlWYv6/1/FVONyLma+zsmeTje9aucAZKzLeeBGI+/?=
 =?us-ascii?Q?otxdBMdnVpJOQNlyyUNiiIrOyxnKK3hzXjjyfvMllJ33CuxqsdguPasO++O4?=
 =?us-ascii?Q?quyqNHdbUcRLs5+HcvWz8glUCF+WPFR4hHoxl7D+3Ew8L5dnuHfuMSs0qBMg?=
 =?us-ascii?Q?OWS14EFIIbJ5l84YFA0RCei3guSzMGBAzxI1g6Ow?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27fe1bd8-74ad-4fc1-99c0-08dbcf263aed
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 15:32:10.8890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: np9VLNRI+zmNTaPXEO5Moy74F8wQKQ1wsOQdwiPBaWAZC8rmUMPsNa4Z/BmmXKJJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8876
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 03:37:47PM +0100, Joao Martins wrote:
> On 17/10/2023 15:14, Joao Martins wrote:
> > On 17/10/2023 14:10, Jason Gunthorpe wrote:
> >> On Tue, Oct 17, 2023 at 10:07:11AM +0100, Joao Martins wrote:
> >>>
> >>>  static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
> >>> -                                                 struct amd_iommu *iommu,
> >>>                                                   struct device *dev,
> >>>                                                   u32 flags)
> >>>  {
> >>>         struct protection_domain *domain;
> >>> +       struct amd_iommu *iommu = NULL;
> >>> +
> >>> +       if (dev) {
> >>> +               iommu = rlookup_amd_iommu(dev);
> >>> +               if (!iommu)
> >>
> >> This really shouldn't be rlookup_amd_iommu, didn't the series fixing
> >> this get merged?
> > 
> > From the latest linux-next, it's still there.
> > 
> I'm assuming you refer to this new helper:
> 
> https://lore.kernel.org/linux-iommu/20231013151652.6008-3-vasant.hegde@amd.com/
> 
> But it's part 3 out of a 4-part multi-series; and only the first part has been
> merged.

Okay, then nothing to do here :\

Jason
