Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12326DF658
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 15:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjDLNBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 09:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjDLNBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 09:01:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF5D1731;
        Wed, 12 Apr 2023 06:01:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRjjhedzZ5c/ozP5tuZj9A6DWtDY+nd+k3bY5ki1fPjSuPPYPNGmfjXz33FHynuGNc7POrFvF7HTeByKkxOJhVeUppVNL98aCGHrCOo/CgiBRbB+aiaJjmlT1Rtu/YCEdz3EiPYXL9q4aYNHjt6mhn0TDDOo69kHyDfXgu0LfXzJA5wml9ebEGvbyBvRB5BwWu9ftXi/5Se7D1VnSFVLqAil9kDRW3GMYsqJLC9qoxByV/aC8YTc5Sc5MvIciDCzMgkf3FvcFgr/EXhKqNDUvrFFrWlwdTvERv9OSBBDXKuae0k5qUc5U0sPy16oB4UDfy2ez9fnTz61BnDbz6Apvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=On7YhGB5wUuDonglbWwjk27jjBEeMEjXjAFWJafsxlA=;
 b=Snc2gzUN5W10ocWhvCh5CNAsd3Ck3gCN7Nw9TegRnAvc3D/tLPxUFu+tDfIfgiEpL28fPfqHjv18y7gqCqrO2nKi1YQvckIbeD5DJ3HU6u7xmpKNwrGfCNigTGuxxjfy4QaxdJC2/g1YiWVYQv9SNLlUi4oNsf3BW73VpNV6y4gQUpeFJeZx9zgoS5YN2gRplwi+VZZmjkRYFpdg55c4B9GmUTXj3f0Ssi18Z8RPpbS9UbjjXsOmRat2UDQPp5mu2UluacuJ9FEn0J5ZqeOvPIJPkFEDMN7NaKTXH6zPOcHQEM3XQlg1mfAPx75Z+B1fdjQQL9t0ohWQb+RpzH2UTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=On7YhGB5wUuDonglbWwjk27jjBEeMEjXjAFWJafsxlA=;
 b=qqzEz73cSrmrXUBTOvMgTDKeTaHWEX9h/O0zh+sI5TVSDrk1Oi3MNsTbULIn16GjAxIyQ+ODydyNnV6Zi7KDDMyR8xq99AG2hoAR2hr9I8h/r5Owcj1h9wSHJToHkyFsnlGg7E0+qUYV6UMJLwOhNU5OXZ58HPoJJtNkh9v/P6AoVmmfTTEiCUiKldwbCanUXEN4BKNSbJ1HKKGiHOm69dsEfRZqpyJd6Pyn79gbrQfL24MJWYoxQAtVkD922UkoogkRSj1LOiODPR4u6fud+puorSpXAuk6wSYBaaPTuot4H/0xAWAf6mzV1gPNUgWKYKupUWo7akEkIU9YMjJTAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8906.namprd12.prod.outlook.com (2603:10b6:208:481::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Wed, 12 Apr
 2023 13:01:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 13:01:36 +0000
Date:   Wed, 12 Apr 2023 10:01:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     ankita@nvidia.com, alex.williamson@redhat.com,
        naoya.horiguchi@nec.com, oliver.upton@linux.dev,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 1/6] kvm: determine memory type from VMA
Message-ID: <ZDarrZmLWlA+BHQG@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
 <20230405180134.16932-2-ankita@nvidia.com>
 <86r0spl18x.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r0spl18x.wl-maz@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0387.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8906:EE_
X-MS-Office365-Filtering-Correlation-Id: 890c33a8-c11b-46d7-2a95-08db3b560c40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2HrxIYfNDhXq+z1v/A945Z38U/M7RUvMvVNH2D6dOR8GVag2LJ9w30UaUW1tS1O/KkinAZtUnCT22t+2xvWxT0NyjFUaYSePuHQRV6WVA+RD/s1jXNXml2kHmdzp15U7QHPvs+aimW47Znq6a8N0RFScbOUch+UH1pf7/zhdCWjlAEISJ9+lDDwcdOOFXrg/nb9aTRhktP11WQwfqdU073yPdpeYRSviS1b25C9LFDZ5wLa/80jWyixfqJf4nsoLAH0VDkMU1HoVDBJb0kOjUjcg5NTBMbr6MqpNu8b33/qNUgmA/L/Yu5e6Qg6BkG5RIzKhS/cMMp9bd+T8odkMK5q6EbpHiNQwTdnzSPPmFwI+F4qqhl0iPUqqEtexfNwjdcvjLo/8q5pSNmUOYwb09KPk90OUtV2i+jmVR0ByYVIuWIegB66RZYzsiVmEdZmd3VAicGuSDXFiU3xV7tuu5L3B96wLyVE+zUS9JJ3z/3EtCtZBtd5U8EnptIOhKv6NJBpRck+pqSolPTdOEsIyXiaBux2YW++2cf5Iz6oInnWJaVodtyhnOdcuMf3xrgetSSQNDn/zzpC8k6+TFzkR0cKChFwAfZcHis+/uayyzw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(84040400005)(451199021)(6506007)(6512007)(4326008)(6916009)(6486002)(86362001)(6666004)(5660300002)(8676002)(36756003)(8936002)(41300700001)(316002)(4744005)(478600001)(66476007)(66556008)(66946007)(2906002)(38100700002)(26005)(186003)(2616005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kyBSMxjfGEXSPEPMNnOvL1tko02uEcnpL8wxccB0M4ZuLdJtAZJuvTrJdPp6?=
 =?us-ascii?Q?d79l6SMhtsIhMsgqCpr8MI2K/QMesda1dcOpn85254gl8hK5x4Dh5MTRB6Sh?=
 =?us-ascii?Q?mjArov4XjM6PXqVUUe9Jd/WSszv8G9b22Rrmjm7yhj39yehxlGzNsu/ReiBD?=
 =?us-ascii?Q?ac2vd04/fM3NutfW2o1tNHIalRIOV7cjIK0c30goS2Pdf1D1R3VPoLWu9GP6?=
 =?us-ascii?Q?/A03A93Hnd+YQctYfd6H3dRq1hRVrzC511Qsa6Sf6ExCAu+rs7NEMx0IwoMn?=
 =?us-ascii?Q?m2c7v8lqtSLrkOb+xZGx7ltWDlF03kMMesHnjP/phQ1f2e8b43zeSFahIu6M?=
 =?us-ascii?Q?wkSROUYZjH+GHyOrTNwyOO+Cnwxfeg1HPCz85DALKtZo/ARM+RmOvou4nVAk?=
 =?us-ascii?Q?d9s2m1/nm0Kc/YTuGPuEbGF2RlLgH5ZopzknWz1dKlkPx3wPDMHWWeslwtVF?=
 =?us-ascii?Q?ahfK4I2OMCd1XkowW+QF5nPbVIQQCv+MD6CZ3cWnjPf0FqzP4DQX0Y2Y3Hdi?=
 =?us-ascii?Q?41muX1pMseZ9irdtsEjDZMPjzeNrNBeBGqNJ6Lh32RdvmuImHo5xOP+uxz0E?=
 =?us-ascii?Q?5vqJL2vIcbRxoFicNU390n3Ph3/Lrm5l15cmw6PB8pC0rSTBS1kSJ7OiIflW?=
 =?us-ascii?Q?2sRyon0TSqU/c/gSbMwvV0J5+bB7HIeiOKyAZSlbJKB77kfyQMU3fwsytgR2?=
 =?us-ascii?Q?BWp6fIxDwlwYh6qBvq1Wl4godPebj/ykeX4799ZVRQON3mEeXNYZh3qyqKcr?=
 =?us-ascii?Q?Yo7xiNhzJornCwNPtRP93TWpC6wz0SHNBJxwfmuIMPIpkg1rqgUEyp/Q1ZGO?=
 =?us-ascii?Q?33KytGtEvRrq2hApAqEQI7VdCAeT+2vmF4F0dCeIq4ahRuMDiHe9zkPtbdAm?=
 =?us-ascii?Q?74RCQ1ayE6giMxipRxYe9e0o5uvcS7jXFFHFo3Pc4cyQpdX/OWbzs3aSn2CT?=
 =?us-ascii?Q?o953Y3kviZ6zhMHPQGRSviT2F0qm8rbbU0pBWJ9W6MBO4XzxvnOlAHgE5MQH?=
 =?us-ascii?Q?nn/WFU72Rjh/TSon7mUfOWGnEN4xE7bQwFpYnT8G74yxPTKBf/J8KGUWad0j?=
 =?us-ascii?Q?HMRcDJpGhFpmLia9ZdYsu+dAwvhAUw2lMTxobB/f5K2GEu09B/6L3r7yqwNA?=
 =?us-ascii?Q?A9+dB0nXJRi54EXqs6FEXEYrNbie3ltxw6L5AjhyVAWnWJ1tlrAmod97GNNg?=
 =?us-ascii?Q?GKuXWY8qd5IjjKq6Z74ofnwYGvFri/l98A9tjsqea0jNgF1BG23sGnwIbEiS?=
 =?us-ascii?Q?8YGsszTjzZLexyKnYhwExN3qv9NJ2tEVezvRYV9fe9DBYcopvhrUxaIXZmUo?=
 =?us-ascii?Q?i06MqehQWRUDu4dBYASIqZe06jZkECz6XGr7GV3K1RmPSRjmnM1NkJfZdcfM?=
 =?us-ascii?Q?eZ37ZYkZhqag/oxxmLll7Ucd9PuDFILCELrMHKU3ilG1uwoQSGpr+0V61+IZ?=
 =?us-ascii?Q?ezmKnpVNJgpPgwVPhfzGBYM33rBoz6PJzD9KLwljo+PKXCgcnmZ6RL499kXV?=
 =?us-ascii?Q?m2N0dlAIxqQECbzVQFlr2ytfhzgPKWo8RaydP5/qhmaDhEZN8YIXhwH/DB8H?=
 =?us-ascii?Q?jDhth6/+llgoBuf/n4ZQEbIP6FtoT0CObtkGd+Xv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 890c33a8-c11b-46d7-2a95-08db3b560c40
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 13:01:36.3795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npvKj0LiFF9gj3v6v8W5upWbfCd3fi3EkZPS8Ch2Et0xDvhhcebx+dWAcrED1OeQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8906
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 01:43:26PM +0100, Marc Zyngier wrote:

> What makes it safe? How does VFIO ensures that the memory type used is
> correct in all circumstances? This has to hold for *ANY* device, not
> just your favourite toy of the day. Nothing in this patch is horribly
> wrong, but the above question must be answered before we can consider
> any of this.

In VFIO we now have the concept of "variant drivers" which work with
specific PCI IDs. The variant drivers can inject device specific
knowledge into VFIO. In this series the driver injects the cachable
pgprot when it creates some of the VMAs because it knows the PCI IDs
it supports, parses the ACPI description, and knows for sure that the
memory it puts in the cachable VMA is linked with a cache coherent
interconnect.

The generic vfio-pci path is not changed, so 'any device' is not
relevant here.

Jason
