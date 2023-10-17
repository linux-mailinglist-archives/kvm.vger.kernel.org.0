Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D9D7CC779
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344336AbjJQP3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJQP33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:29:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D1B92
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:29:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuIT6pD7uFnH90KLB+hTByOdlbGLpHRPxAnMwmhSO49hX8iCc2wNElO1FHsYhzapZ7rjtqzvf+GafCLYAPTAVbq02L229y8jKMyB0i+KC4RnpbOOJTqyJLOHvB/u6dHFI64StMf1zj63NAcAbwG9NE6X2bCxF/SRtMaEoa6EiRr/tjiAGAtaQplRT83nwrvHRSLDUce0TrLASAE2peWRLJzSHPkN056Y8VlBjr9VbZYs1IwQnokkpxcXylHwgeKEPRfHGoSNz9DlbChbr2YqooHZRDEMzTwwnlALBFgroq6tLoaCp4aKTrxZ6hZpgTZxJOg6npI+k2sbAN32laLJ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BB9dDDCKKBrkfNC+feLXhjxDVulecFX4sQGG7ilkAFc=;
 b=Wn8uFifJbXkaI6g7EI+if/dcEFY9libQLkZXpAm5qp/MYrb899rOAYqUnQlO70kUcx3E1P6xsdKHsDF5/WkIEOn0+hdErJrG6WpCamlKQrW6X8OoCzALQKjDCkwgxOdffPcq/Qk0E5fLVFXGfkIIfE0tGVVvkPhRkMvU4qb662KcZTsorLGXsCgT9d0D+LRoni9dLlAi2+b8XdsN1bbptMxiM+L9lkgHu74trjZ42fal/nPbERKZ+DRnHXLtaNEUbPiz+Vc8cfImmmUQW+iAYHbiri+49TlzRi9jHk72f6sYNHa+lmI5bMa8nFc1Csk++prkwWxRGzQRvhk8lYQYAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BB9dDDCKKBrkfNC+feLXhjxDVulecFX4sQGG7ilkAFc=;
 b=NKs3RaJokX+/HjmWAOg0AECcZvRzg9A+zAS69OmwHMLYMG1fSWIAn0qj7TjDKiQj2HsQdl4oRf+tE53PbFYasSnQl8UtXtPELcpYxQ0HoDdSFNmkQNKwE8RSR4iaXJPuh/EqkM93ZnOMz8wTH/2tNwfdb5uccZyl0rv61R51XQtOjiKFN0qvZvybCO0+yybQS/V+1o2w8AimlwPejE1NOp68BQBV5yBxDAZyAJgQ+4a1wmlKM8pXYT/NV6vABA2X1AIIgSwx3NqGYIOIuACMH8wuoh8/TZ7bbDEnO6TmrszSh6wzKihoQjogvrkEnRkK63ta042ut+BuQp55Hbi6Yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6724.namprd12.prod.outlook.com (2603:10b6:510:1cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Tue, 17 Oct
 2023 15:29:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 15:29:25 +0000
Date:   Tue, 17 Oct 2023 12:29:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 07/19] iommufd: Dirty tracking data support
Message-ID: <20231017152924.GD3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-8-joao.m.martins@oracle.com>
 <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
 <8688b543-6214-4c55-a0c6-6ecab06179c6@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8688b543-6214-4c55-a0c6-6ecab06179c6@oracle.com>
X-ClientProxiedBy: MN2PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:208:d4::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 76dabb6c-b712-4fa4-b645-08dbcf25d845
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVrkg0s0iq3CGwEk/FFQsETuMIT7wqIuLhPxxExcmwNUxk/5478vvdP5+WnSkPMcL71nUI2NlY0RBtk3m26DBV7vWoLDt9tl7OAqjVue7YQWUV4FHHJqH0JFbdJ8kesWpj1frRrvnGFb2fdE8mLCELXxRF/DhTWopr0T+9YRJ/sVVwMmoHW7muUiQXnF3niaYHlXPDArOa5spNrwXoSvyHjPgYsINoSPByZHfYwiuWRT+qRLki5HHCuOqVYEL/1n+A3PymWJUCgU1IZkKqzhSokLG8axfTIyHYgAyp1CnYlEfU7LZdqfi0hE7N1UjWSG9pAXGRw65ieClyWqRGEsTVl4e0IzGtFN9PBWtJ6H2XuX7JLlMr36/ZolnwtVy8CfWEaYjHWsn0/hwzHfl8B+sPsR10SdIDgruC+R7mp1wIbDleKN8M4SlMjQYMiP6/RSI4sMj7XanPLbf1NqR+8F/EQ3WQHG9+M99QoSHtS8lI0L+Xy9by7tPGEwlmFUuazg3e3IB5lSHBHb0lG6S5LtkWIDFoWsMbSSnPpjc+PYwSltlYtLCZ7E0AjITiYI2lMAeQ/q6deztyYdoUN7Ku8RnWD///oVVgORD13UyNm8R9w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(376002)(366004)(346002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6916009)(66946007)(316002)(1076003)(54906003)(66556008)(36756003)(53546011)(83380400001)(6512007)(38100700002)(86362001)(33656002)(2616005)(478600001)(6486002)(6506007)(66476007)(41300700001)(5660300002)(26005)(2906002)(7416002)(8676002)(4326008)(8936002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XGsMvZHbjy8ehyDBVfI7aKNrJyJVUDFdy9R5gyPbN7ypNdfa/G/w/SqhSAef?=
 =?us-ascii?Q?aVmlJhfOEz2CVmzq31HXSnpEmnRw/Nzx22Vptx0LfWxmYdgWVU3RmIAPMVhg?=
 =?us-ascii?Q?C/itb3e8UEUg47Sio7J/DrQQyn8cwlJ9cqRPLXnLv5oWmAq7m2YT0Kgt97hN?=
 =?us-ascii?Q?I4sDv4leRLXAX6leADV/WiW3I9J8ah4ZNPuKM+B79UfOm5TEMNq6OVlaeiQL?=
 =?us-ascii?Q?zMLCvFTOxRmWk2E3LAanUBzI5cDWDUGYU14bLi4s4W+x33AQa2ByCYc70p3P?=
 =?us-ascii?Q?DoJF6n4rfhCb1J5jaq7s+T9HEkX49lmF+wslxMAjqC/yKC6KC4bF9pIYCyWW?=
 =?us-ascii?Q?C/zjp/H4EnLs11rQI8VCR/pBvfcclad3AVgAelZqYm/tCKGJ4iMZRdzO0tPJ?=
 =?us-ascii?Q?QMO5ozM+a9Wx/WfhWmdJ0H3f7vS6qjTKJXH5qMh+4GyBuOA8nJ7kMwVQzk/O?=
 =?us-ascii?Q?cE1YxSQ7P4brS+qUUs7Ul+2vH2D6a5RrRWPPz2/7vsnj8bLOwQ8SBnTMgy/l?=
 =?us-ascii?Q?cE0OI4xpcty3s+M3PNlSU+1Cz873EfZ73c5I+ZlyW2/g65mRA6E/QLajMSFh?=
 =?us-ascii?Q?FZ/T5fI/Znggr9Q+Gf546CaI9+IUc12OwaiAnhstgFPyaBqopfZUIt4p/bGp?=
 =?us-ascii?Q?zd2smuTJZdj9eWx5r7gBZVuU6Swm+x1L388Dd1emmkZ49TpwJhmnORBj69dq?=
 =?us-ascii?Q?Z/tbuZnBOmPeLsjEwf0A/vjAP/mkhINyOjvraS8JRGuCKDNVyoXmIZqgimES?=
 =?us-ascii?Q?hdhymg1AE3lK3idqESb0rTpdCZ0BUs7kHG5N99C//lzf7ChMUP5m2bBwcFke?=
 =?us-ascii?Q?HqcTtjeJhjrNzYzWT1o5MZ33WfX7zQ0ktssN44siSAlB88ALTJ8ZL8UAYHeW?=
 =?us-ascii?Q?3G53Z/uPVY93VWi6DG6xsgdCFGHUzcHq+4wi2qaQkqAzBFxts/GDizz3UkW2?=
 =?us-ascii?Q?YHSOeesuIR+7ou3r/Bfqo2TxU4UuUnsVVpKPRlIlf0SCtiMWlDVt8z4PW6RR?=
 =?us-ascii?Q?rmxvIX6G1Ys2TU0KkyOdcAJ7h2ktAIsVr/pRUEx9OfCNdcENVoqsOWMXmP+A?=
 =?us-ascii?Q?uQw4ASl1PYQl0pBcfyXirgk4HdGoQ6chLwmQJ7rrt57jBpJAYWSIipThDBB1?=
 =?us-ascii?Q?DZwRXpQKkMzsayQs4MPfPSIKf9nI+uSBYTGa3lZUMCucKlp+3d3nenYMzSSo?=
 =?us-ascii?Q?96E78fxxbp7/mZO89+/er1XbcpqV/V1VorNzZCTdky5ovuhktDjpHabozYLv?=
 =?us-ascii?Q?xM2wDRPTyQDbccdXuTR8+XtjZ0OPgr31IGgLIgkMJtUlrP3/6fnY027nJtSe?=
 =?us-ascii?Q?BuRtZS4UFElqHZyFF3QHTxn1EWfJzvCgvtpFztgljcqCp5hmt/E98OlPpT4W?=
 =?us-ascii?Q?RtTrk/o9/nHX/zRZcwdztlgdTMgmSSjQamORDWgQYuR8jGcuVhlmBbMLqkw6?=
 =?us-ascii?Q?OL3gLP3y2RkpJoooA+TqWGUurlqii3Cb5XGUpKcBAUvfCUw8q3z0Tc/9aHlv?=
 =?us-ascii?Q?+p1Xn+sy83fr+I1Vgwm0DH2vNzoErbnyZcJOT4UwkwIrprNRKoXzJBjJJCut?=
 =?us-ascii?Q?OMfp9mZq34/XuJsUaKE6WZCFqXjyB50B81uHAp/M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76dabb6c-b712-4fa4-b645-08dbcf25d845
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 15:29:25.3405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJ/2f3Bx3diVZgrL5zpe7w9p8z3jox0NEMtviSQwFHNFGXAgSsee8jAPgOQ6WKGT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 01:06:12PM +0100, Joao Martins wrote:
> On 23/09/2023 02:40, Joao Martins wrote:
> > On 23/09/2023 02:24, Joao Martins wrote:
> >> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
> >> +				   struct iommu_domain *domain,
> >> +				   unsigned long flags,
> >> +				   struct iommufd_dirty_data *bitmap)
> >> +{
> >> +	unsigned long last_iova, iova = bitmap->iova;
> >> +	unsigned long length = bitmap->length;
> >> +	int ret = -EOPNOTSUPP;
> >> +
> >> +	if ((iova & (iopt->iova_alignment - 1)))
> >> +		return -EINVAL;
> >> +
> >> +	if (check_add_overflow(iova, length - 1, &last_iova))
> >> +		return -EOVERFLOW;
> >> +
> >> +	down_read(&iopt->iova_rwsem);
> >> +	ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
> >> +	up_read(&iopt->iova_rwsem);
> >> +	return ret;
> >> +}
> > 
> > I need to call out that a mistake I made, noticed while submitting. I should be
> > walk over iopt_areas here (or in iommu_read_and_clear_dirty()) to check
> > area::pages. So this is a comment I have to fix for next version. 
> 
> Below is how I fixed it.
> 
> Essentially the thinking being that the user passes either an mapped IOVA area
> it mapped *or* a subset of a mapped IOVA area. This should also allow the
> possibility of having multiple threads read dirties from huge IOVA area splitted
> in different chunks (in the case it gets splitted into lowest level).

What happens if the iommu_read_and_clear_dirty is done on unmapped
PTEs? It fails?

Jason
