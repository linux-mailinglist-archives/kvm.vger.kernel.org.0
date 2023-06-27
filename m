Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B33740004
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjF0Prx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 11:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjF0Prv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 11:47:51 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A98FC;
        Tue, 27 Jun 2023 08:47:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDBpKl3qPRhmA97hRwhJQFOEfYyNilhS0aXzYIqy8919UV0sPy6YQwhcZJjpXBvgJtMjeWSfnQS8itzD5Fp7DHNl+9HOl+VFdjowdTT9m5wsU5ciFP79PflE/tAit0bE/EhfR6zH8XEy5MFCkpt9D3MM9PUYix1PqXe5uf2cjKLsNYVPx9OUYnhRMW4SpEshxDrvqtRFTKXQ55hmjLXelufXW64NKX30CXGuKweMykVCboGJXOZdwnnDZKJ2qNBG9OlQv4jLgh+EUID3Qj0Z+CD1T5gJsIPT2pygJ00dQ2fDy3cYRxiTB97bo/Wy+ruv1icEqiDAThiC+eoVcRzgDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FXwJD2KTbPQnkXbMiRLWfl616tsNWAX3DTKT23GsLI=;
 b=MddQlnKvywEXSpBC7ZzgOIB3kTNj0ifXS83AwBMfxUzaJVAIcuzMVocPGqScx7giiguA/DNVsMSJ4S9nRlf9zs4+V3QcTsRdaW+qPQ2gtjhS6COHE2jNGBEedvomfH51B1IWfZo6cBEIdMYjWGzSbTmjtHHr8m4Vi+Ct88aId2UxBhb8OlMwPgX+5K9pcY3HFF4/l8NnQRHdX97IrpPkv6veY2YZtd1qyLjJ7AQcrdghgFgzUKIxIZypI3Dvtx4V277hJgT6rJP8wgqZoeVS1NejQGYMqMhqEqoEuqLmjb2AMYGZ8U6XwGwrsawRmxulNGYGa0lgtUCsqnTlVmWo+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FXwJD2KTbPQnkXbMiRLWfl616tsNWAX3DTKT23GsLI=;
 b=NMv17ALbqPZE18e1BstXSQ0E5qr9D3fsC/6Vwi2iSfnNk27SF50lXqUYdpHcVDWeeWJYdIEbo610oWoLiZrexrC0Yq6c3JrKYECXUSyRisKz3m9oIZrgDLu0sfJqKMeGS1L5YNzxR3Y/GWlMiNzmy+vVCHrLH3xpacezzEpDbICjGOWrou/u14/TfJczDZlMYPZEHdQUJgIOtz2xVYxKAfhUPTeAtACk2AmBzIMwu7qxmqc74D2n8FclvW7BCDWgxsTvSDvY/WwXtPv8E1udcOstCQnT94TUyRhX7PvjGdX4pw/tj5V3jcOM+S4Cip0GoLT3CV3OfdHBIpVWmhQTPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5922.namprd12.prod.outlook.com (2603:10b6:208:399::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 15:47:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Tue, 27 Jun 2023
 15:47:48 +0000
Date:   Tue, 27 Jun 2023 12:47:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Message-ID: <ZJsEo2eqDdV0Mska@nvidia.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <8cc1d69e-f86d-fd04-7737-914d967dc0f5@intel.com>
 <69f50ced-e806-717a-0c74-a4cfa58600fa@linux.intel.com>
 <BN9PR11MB52768ACA721898D5C43CBE9B8C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f1b2e7fa-7be3-9e4b-1eba-5dba01b88c19@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1b2e7fa-7be3-9e4b-1eba-5dba01b88c19@linux.intel.com>
X-ClientProxiedBy: MN2PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:208:23b::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5922:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a6f34fe-be7d-43f7-0d0a-08db7725db7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YqmHot1xL2PcHGcfPQxUCWdyTqCJHdE4BHcDByP8x7ZQYHuun0mRqIm4/5U1GWdCRN2fY2WAL00Hg34zm1YHUpcwBvRNjoAwsJLzZC5YwsFQA7Ea4g6kLf+Vjs2W2F6Cc11HYNUzY6ZZmKKt8pa7JQ5WkQEbFwRgU30PbrFvK9IkfAst/nGEwOxX0NzirPty+PTYjM66ouoAEdipCFc3D4eiG1XvcZUGk2AEMs+i1mOMuWHJKnytURNOyECxx93NzQAtOvHw1o5Sc7VG4NciiBcNPLQZxjHD64oVXgnl1tA67jBwRLeqsgCamD6btZ7Wy57QpeFxOW0QPWey7k1IK2HrkEx9JfqLrC08uhLCZ2CEl8v8dSdshtW7QZTTm6I83xQHcAGQmJ8h5RpYGLsrVzHgahDDXt28qiVxrgcNe5syhHavA6HKfEacGPNKETjLsd3VkLL4y8h5pp8svWgqmt2wb5NN0rm3twGPLBKJ1fo7iuzcyWaT7OGhnCsiakVCbw4Y1FN7P1xzfX3ErxwXG065C6T7CLFT56X047NYD8lIx3f5eMllXmHxAkjt8cnL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199021)(36756003)(6506007)(66476007)(5660300002)(86362001)(7416002)(316002)(4326008)(6916009)(41300700001)(8936002)(8676002)(66556008)(38100700002)(66946007)(6486002)(26005)(6512007)(2906002)(4744005)(186003)(478600001)(2616005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6K+xNobNZgSmkSwg23rV5+ifCfp5wfC+lls2Sa1lPgcJoSZcP4PXDkDNWh6U?=
 =?us-ascii?Q?88yVrRdRsiAVYbY9NmF/8hpMK5UXt9rUOaixUGvIpsrWG4vEDlMOwjcmhNWn?=
 =?us-ascii?Q?B5P4a4s3/x8PGsQYCK2FN6vfa9DZf8ciGfouKEA4lvrXMg5nr8fuM8cItAQt?=
 =?us-ascii?Q?BKI2uPuySJQjmJSVmjlnEzA5h/NnKUQBmfc36vTQ4XwiVCMRLf4UfWUncdyT?=
 =?us-ascii?Q?rX5Wjfnwr+jx4kx/+fk/07sE9owa1Mpd9CUjSvMzdYVMHJXg8Da0Q4w2hAvY?=
 =?us-ascii?Q?GzESQHZVgyy1kkuB643usjiOEhp3VDiCsJPZd98jiAIK8I9SfYvw8mHfXH7h?=
 =?us-ascii?Q?TiBnf1jaHBvyZZ7XBznbb2AsaloFKOiSVuJDDoYbMZuVbiR8qBkLX4iOrsO6?=
 =?us-ascii?Q?TjJ/Vum48zwHI5r7+ZS/nc+Aap4pkNwJSgTh2hznt9gQ9K1h9AQZtg7l/1ZB?=
 =?us-ascii?Q?03C7H5/9Fljw0vAebzIytRY+wwjbQNh7o7+XLwojHJVVSM7ZosLeKCwob0IR?=
 =?us-ascii?Q?28qtjjYgYSdFoJhcTmNGlxMxO4MNKxMHHenxJ+zvMDG2+XrOAylqIBex9gI0?=
 =?us-ascii?Q?tfAdFCOYnRuPwenqaQplcThwiv0uPo1R4f2Q/7RS5nmB+bsngYj5zFBQ718s?=
 =?us-ascii?Q?pXYSiUBOY2Ef2K4lykwB4WxTs+ar69YrHzXwRIM9iFiz6iuDEyuOjO9bP1xa?=
 =?us-ascii?Q?Sq1+nV2PvYDFGZOw4ET31g+u39IyYomjNgPL5KCGuF1qOOgk+A883u2NMtuI?=
 =?us-ascii?Q?LH2q6TvjPI+GEX1aluWw2O3hh+yqF/yocEOyqsvy58cKvi/9yZUXMy5zSDcV?=
 =?us-ascii?Q?y3+AJSripxgE094sSiRyWHoUxm9+8oSt+/J9LNi0GHGWoBhRUa9l6mpQ6EpO?=
 =?us-ascii?Q?F2/VKj8zROYVFWlVB3FWsbfyKm85WknaeA82luggVDfQcvEZIfBnelaYw+HS?=
 =?us-ascii?Q?mU7dOL0y0S0/siVRjKLjrQ2qOz0/dCZYRdXWsE7Z+QW7BSMUA4Gh5Ns+EbOn?=
 =?us-ascii?Q?hJsBvExBuMRG39SehCbqiCh7n3JkwfJ/2hZNqN0GPULW4cIibEfJIPcMfB5F?=
 =?us-ascii?Q?3lEDpWEJUTp89R4WkwAIGglA9HB++5zWKBqYD6elKi5Y//jrnV446AqdZ5jq?=
 =?us-ascii?Q?I/WWCwg6+iM+ASW1botWJWzAbp5/SQnBL513Mvvbd+bGRtxVHNvcx+ztf8xj?=
 =?us-ascii?Q?4U8ZJB4ySiHJfu5b8v+MM/njNA5hyoa1eq8RddcXNmrgTj9DBSfAE69OAs0Z?=
 =?us-ascii?Q?y9PQvb8QnSaiNRUN6MKGiCVdPKQuPPPa2/gpa0NrYGYs9XlKeFQ4R9T40kXk?=
 =?us-ascii?Q?Mh+TjFsGicFRjNYVSnHlsIzAMbpgWxmcM4LDElRtmKKTVB/F6vtRT5JInJNS?=
 =?us-ascii?Q?GUIwwWc2TJCxQ30COEsweE0W8/da/uegwVUWhhOCY39O41AFfEh/WS9u38+Q?=
 =?us-ascii?Q?+Q5saqI/+mX1hQVnBf5KrkxWpIohXy2Uc7MAgRd7YGegBa4EcTP3fx3kTk38?=
 =?us-ascii?Q?bAD7WsEDJUKNbrpwfp5GxAMAzyQhIpJGTwY7vHhzSuFuRwPSlVcgtGiq2EVu?=
 =?us-ascii?Q?D5X2E0rMCFKNRVmRfKeCouUfvche2xY9U0NebdjY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6f34fe-be7d-43f7-0d0a-08db7725db7d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 15:47:48.5268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qu+zWJzrPFjR6ARTEyrFqXG1YBFP9POIoP8u/CrpplsKjGyNFPn+VTtmgaQNoppq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5922
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 04:01:01PM +0800, Baolu Lu wrote:

> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index e59de7852067..3be88b5f36bb 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -962,6 +962,9 @@ static int iommu_create_device_direct_mappings(struct
> iommu_domain *domain,
>         pg_size = domain->pgsize_bitmap ? 1UL <<
> __ffs(domain->pgsize_bitmap) : 0;
>         INIT_LIST_HEAD(&mappings);
> 
> +       if (WARN_ON_ONCE((domain->type & __IOMMU_DOMAIN_PAGING) &&
> !pg_size))
> +               return -EINVAL;

Calling this function with an identity domain is expected, it must
return 0.

Jason
