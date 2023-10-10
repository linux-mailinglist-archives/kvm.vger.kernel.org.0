Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFF87C0215
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbjJJQ6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbjJJQ6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:58:51 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2059.outbound.protection.outlook.com [40.107.212.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7CCAF
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:58:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QC3Bb3auVs17hwguuIVez1y4yea+JXkEUGk4kbb0TOh4JCoZoX/UH47HZ++4vLceM6JXIsjWjQORtTil66RPVlo5gdCug8aNgnSEwJ4/upFwNIg3C2b7E7x0zuBZgTSlB3tP0A1qoGAPfbgdoxnLE8+fnGARkryo27j8ZJ0LAyGEMv7NoaeljREcAp45wfw/iJ4rk/Rq+PitNuLiPUKrihQ5y40zwwGQ2rWs+rq7OUxEHF9EAq5k/XgGU6NJFSzQnGG716EBE0+aV3g0KZh7ORlTvLMWEbbObE83Aw8iW+yPPXiDSr+5qL7gt9IHzPOjpP6N1vq+ARH4rQW52MwMfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnMOg4+4nnDBbVWOUOCD8dD1tIrbCfW6ORtABwWKxY0=;
 b=dzvaF7qmmpIUHG+gSd2yr0ZVBLnBnaQ/4vCGIQS1rRtxpujWeNx08Px1/HfckaaLSinsXnRIpkuCCMOZ+oxrBwuN0JuqxhLubIbi6rsspEordLfgDTPM1GhpNCztxpb/IVF3mgV3k8HiWtIFj0Z74x9fjAsPOxGTtt9GGHZmZMwDAyla7iZ/vkr08ByaZWjPmgrFuRlYsSaCYRzyPev72GEeQ7W+AXMia2o2M/eL32/QSx/THSqoTGxqJ12vQ16nmKGAJfKiIJf9n6VTVHqlqCX3iuWZP73N1PbiOMiBeMAW0ExfRhCUAuP5B5TyrVtNNXbUAad2k4Vpl0GfU9zRzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnMOg4+4nnDBbVWOUOCD8dD1tIrbCfW6ORtABwWKxY0=;
 b=Ew5BjMZNf9b2G62Hfaz7rIqc+YIvKT/UH+bkb3+b+GoWqsrKYnZ42GSgM9pHTA5w+qMc1KGY+Uuj99g2YBqxrGmuDsz0Hl2/AideC1wkflzDLSaLuTxsVQfu7Xx5cX7cMNQH0ONA9CRn9M2Uvsa387lUlFC/AR8X/JGlOG/nzM+Vaw0v32N9IUvGUhTsx0uOmCXysBg8ZUZemtqpQGuZSImyQFitHC2HAczk7Tdzlhm4a6jGGY0shaintYfN8MWBhlJJhFXZWpna5Vc/BF0CDJCWvj8RGiXcaznUfSVatemGDew9DIi9X6JLPpnhZXTf9EojnsJ/u3Y4Z8r5p435/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 16:58:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 16:58:46 +0000
Date:   Tue, 10 Oct 2023 13:58:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     joro@8bytes.org, alex.williamson@redhat.com, kevin.tian@intel.com,
        robin.murphy@arm.com, baolu.lu@linux.intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        zhenzhong.duan@intel.com, joao.m.martins@oracle.com
Subject: Re: [PATCH v4 01/17] iommu: Add hwpt_type with user_data for
 domain_alloc_user op
Message-ID: <20231010165844.GQ3952@nvidia.com>
References: <20230921075138.124099-1-yi.l.liu@intel.com>
 <20230921075138.124099-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921075138.124099-2-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0175.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB8800:EE_
X-MS-Office365-Filtering-Correlation-Id: a2515bc3-a72e-45eb-5174-08dbc9b22ac2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i1QS7d4lWn1T3GmxxQahWzAWBWBsuKq6+IdNhqiHwHtqwgHTMOWrcc9dZounnphnnNLJ8LWYt0ifCsqc+DJBgjTEHtyHpFAN8h7kpbw2eQTGTbN5NzolRCG510wkqZt7qJJU8SpWL4WRgLVfLtj+56XD+nNheGtqpaT6ytspg0rs24VGBF5PUBwGJ6fqFBD9KsfE/4Xh4aaHLGF09tBEaqfP7W7RcBqPQHbw7kfom/mNt3LmOStdAjgXESiTqCjyTgCNkf1BSrpBC+Du36X9bIjWXJ1KMszhb4GOLbNV4n3nXby1/+/rnIEffsMJB0kMgtynhLjdCn0yBPmJkUYB1/iezwtTjmnYsgt9Le3DQP9PqMfAf0SXDluH+Pk2cSOFUX+sQ+b++hOy/RkUBWvAOy8VfGwRJ93GZjoFaT2mVBs3tGNJ1M+OWe0wUxWU9IrUTm28d0eace0ToaJYuMJh+e5GC5Ngt5GLKh+7PF7Jx6qI8fLb2dtuxNJf8Myd+ctc7gvRRdlpNRLTTbz5Rc6g7BDB2mITPF4KMj52CPlUaUrD/rDQhDyTRnLbIhN6tSsc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(136003)(366004)(346002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(1076003)(26005)(2616005)(6512007)(8676002)(107886003)(7416002)(8936002)(2906002)(478600001)(4326008)(6506007)(66946007)(66556008)(66476007)(6916009)(5660300002)(6486002)(41300700001)(316002)(38100700002)(86362001)(36756003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aWzBF1JB4QxW8VRMJE43mjGvq7s1qg5uyu7+mjEaAWdyCRQDjFwpGeLHbNuP?=
 =?us-ascii?Q?jOzJFZEMrwWoCIvZYDoj9HaXeJ12QRzWsCv+mQ2/fcFQhI4sA+++5NfXkwUg?=
 =?us-ascii?Q?DKDCy8nGU0ofY4q2QObzUNDYWwXydGkFUIFm6IhdjNm5m9vvTY5Q3TUh7XQD?=
 =?us-ascii?Q?LQQ+YfBA2NPi7/JSje6Zmeg0G/DT4+fz9yV95GHrxB4Q4O5kCgc5hvJPZaZO?=
 =?us-ascii?Q?PU8m1h6qq3oMYcovp74H47M/k44V+ehCHzbBjdUtQyjW2+1vjS4NJ12GE5rZ?=
 =?us-ascii?Q?lFm0TsfRpfyrKSUZsEezmpGOd//BqWx91UHaUuVcok7AWMGAtzS/6Bdg4pjw?=
 =?us-ascii?Q?oyxG2FG4g1oLBDn390qCSR9yhyewjiEycnA1p90/ks0NQ2OiKzAaLBRCFFcK?=
 =?us-ascii?Q?PfAbp9/dfPOlQbUU0zz7+2sjETJXGpY5qHlnh4yMmecEJevC6E9Pkj+eGmaq?=
 =?us-ascii?Q?lbx+QDVIVEVQlZ1tYVXXuOFFSTzFUzgXPIJFQ35s0SwC8R/qeaLL/aeTICQp?=
 =?us-ascii?Q?+EHaFSCVjmEi28WWxpy8PUSavDdD6XQ1k9mR1giUWg6kkVMW5hXrAleK4AD8?=
 =?us-ascii?Q?xN1ems3EDumISLclpWB6JC+o3MWJRR8T4w88iEkQR9aU4IH2KvUWsjhIEYXa?=
 =?us-ascii?Q?C9XliAF2so5CbtyzZ1uBnqQZKjbNmpTz1n3Axou4/xANf6FSwZkJJWmJOMRi?=
 =?us-ascii?Q?t5EA7Idb9XEskgRZfudVvp3vyOPVolpYFmHtnMjOMbuzHYkU6/r6O47G+5m5?=
 =?us-ascii?Q?I+kMWY8ZBAthC9Dw0Pt891V2WPDP5cvV+qIZjje+eie0ZOGqTzXFEMWf8GLF?=
 =?us-ascii?Q?08LnD3FLDe2Ad8CKQQJv2po6uAV1MViGrDPsE5duVd6XOZ/njXcvGFlrnWdf?=
 =?us-ascii?Q?25NG3wljtdau2IU5wzrLt/+fcOQUsFgEw5jeeEuNc9hLYFETcIF79wIsls9Z?=
 =?us-ascii?Q?ICHTSyWOw2L0gv0ChNjs76hQ6Qz4cuamH1SHwOokKrwuQQC3PYuxCFHXTF5g?=
 =?us-ascii?Q?OvZQjV9Zr418IDF7whqjPwZWVDf+6PkHbTrYacRLHDc/VF6ubsgJxaV1H7zz?=
 =?us-ascii?Q?82VSjyMix921g7HRjfZTXyuE1VxhMMuD2ypoWLdOir3HPKGpPbHCIud5NqOn?=
 =?us-ascii?Q?y86c1uVdSJUNNLzhHVNibsNT/vaKnO6vZbZTQeT9v54nhgFH7HbS4TdMDIc2?=
 =?us-ascii?Q?NRzyqfw1ijAgFTKb5UOnDzto/KDqvKd32F6uU/+L0+oBh7rIjNocB6+paMLN?=
 =?us-ascii?Q?jPjazw4WbBJS9hA5IN1Ae+qGhuOcEjsiYOdSQH5sXjfv8b++del+hRnjCgXp?=
 =?us-ascii?Q?WEbELediHJZ46ogTIrfpFyVa6D8SsTnRrWajeyRXez0AsrW9Aovg5AZ9WjIU?=
 =?us-ascii?Q?QfmifCk5KKIP5U3GCcApsOAg2SOS+3ADcV3h82C/0396wMojVqo2s0wlsYAY?=
 =?us-ascii?Q?JNGM+g2E3SlsxTdprRo8ELcNj6wJh3LsxQzRg6321/P2kwtzw+ctZVV0Awnu?=
 =?us-ascii?Q?MWFKd29diYh3MsesBnbWnCNC3jkimVBm6LPlkOZvXOhqwvx8HRyc136VmJDp?=
 =?us-ascii?Q?fyb6yVGl4e1p0dGq5VthxTjLKqkQRn2jyHD58Zqg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2515bc3-a72e-45eb-5174-08dbc9b22ac2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 16:58:46.2899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ItdqWzFFj5M8eHSIBTKOVRVCLJAyWj78hAmWcyL4snCkcYU9VUH4zKi4bobV1uKs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8800
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 12:51:22AM -0700, Yi Liu wrote:
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 660dc1931dc9..12e12e5563e6 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -14,6 +14,7 @@
>  #include <linux/err.h>
>  #include <linux/of.h>
>  #include <uapi/linux/iommu.h>
> +#include <uapi/linux/iommufd.h>

Oh we should definately avoid doing that!
  
Maybe this is a good moment to start a new header file exclusively for
iommu drivers and core subsystem to include?

 include/linux/iommu-driver.h

?

Put iommu_copy_user_data() and  struct iommu_user_data in there

Avoid this include in this file.

>  #define IOMMU_READ	(1 << 0)
>  #define IOMMU_WRITE	(1 << 1)
> @@ -227,6 +228,41 @@ struct iommu_iotlb_gather {
>  	bool			queued;
>  };
>  
> +/**
> + * struct iommu_user_data - iommu driver specific user space data info
> + * @uptr: Pointer to the user buffer for copy_from_user()
> + * @len: The length of the user buffer in bytes
> + *
> + * A user space data is an uAPI that is defined in include/uapi/linux/iommufd.h
> + * Both @uptr and @len should be just copied from an iommufd core uAPI structure
> + */
> +struct iommu_user_data {
> +	void __user *uptr;
> +	size_t len;
> +};

Put the "hwpt_type" in here and just call it type

Jason
