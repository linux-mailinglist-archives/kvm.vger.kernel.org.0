Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0577C8B50
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjJMQSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjJMQSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:18:38 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D068A76A4
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:16:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P31oKG5Chevb0pqWg/kcJolEy0GAduAqZED22tkpn0jxTmeyE5xVD72ySfj2Le/OTjN8HqHfFwlIKWaMgQTikBAu7TTQDgZeZIdeDP/mGbhIMxYp2Dk2BVc1AsEoQCzSgKvFu1JkKpkxvq5FeYwQY8z//qFEGZOh0+Vvvq+/jWjXxxX9IFsqC0Hk3SJ+qtQyilDGMkYK2ED3wy+LpQoyeLHbAaZJmmQec/5kSkWh2HjoPsFVXsxH8jiUuFMJvFWEwOjwjtrHKgnxEVwSrFphISWDTv6EEFt33fPPnBHau8xlldVXk0Y0xLkQsABeOG2oOALw5V5Xt6IFJQO/A9AjCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7E+j48fMIvlIIA3PZ5wg7jq8uLRAMAtZ4lceoDzkxwk=;
 b=RUpb5DXhQEZIolfo1U2dbt/NG6ig0V+d4+SFrxDzso4QTAHR76ZU9pM05w3tgFwWFfY3No519I4fXGq18etOpYYqlFgg1U/MPKeX0fMtfQhBaDirS+A2bPN1BV9S5ItoWKC1CoSaTvYQzKraItK3LKrYt4gdjF1T2tEH8Or6JPT1dASrhbGqDX4U2BuMb3bg9zSHe1j+Ws5vcuihJT0k8b6cjUa5HFvQhpxUnGUZvbNhBWtXhJY3VtqRZmQS7Pg94WhMl8J9ROKj2HlSpQNsuuenWJmsqtXYvhBmRp4aUxoS2XvEmJqifYDDiMxfwvHho1W3WPnXEO0OVPcQn1SIaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7E+j48fMIvlIIA3PZ5wg7jq8uLRAMAtZ4lceoDzkxwk=;
 b=LwlH9g4w2xTojthktPVoUNQTGZDgP3mqHaTC3BL0G2cMKDHegFRJG9wNRjWXgb/DEIJPS7oXOgaMm/9fxxKKAkMHVGwzvC5wgETmrWsoaApmFesb+sMnZ/Rq3LZdgv3XWWVPU2kY3i0FAdpyPqvxC+aiThhCoammAOGEcWHht7gJzc1UY4Y7OCrX0+6z2GMd0dcQksrIZeRc3vJE1rP+xUJwl2ZHDZC0QCm51HbGQT5D4NEY8Q0AG0MSHvX3BwC/RUuMin6+SvgU6lDW2KEsoyT+Yj0ViOg+WBPAWcNfEY5F8SbkNvvK6fDVtTbmmoH34KF+RKRTmLWaH8RzCdIQOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7561.namprd12.prod.outlook.com (2603:10b6:930:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Fri, 13 Oct
 2023 16:16:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 16:16:52 +0000
Date:   Fri, 13 Oct 2023 13:16:51 -0300
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
Subject: Re: [PATCH v3 04/19] iommufd: Add a flag to enforce dirty tracking
 on attach
Message-ID: <20231013161651.GE3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-5-joao.m.martins@oracle.com>
 <20231013155208.GY3952@nvidia.com>
 <fb94b003-f810-4192-8101-beef9fafc842@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb94b003-f810-4192-8101-beef9fafc842@oracle.com>
X-ClientProxiedBy: BL1PR13CA0312.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7561:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a778642-f45e-4996-4e34-08dbcc07cf75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aPpZ0g+4ijZ9N3EZJNN75EFPizVcKT+ZA6aIoNCCqL6M/XSsugbiXTn6t3tdNNTUv/PaqqoawhoVZ6U29gMV9Phwxibhk9HTnu5PU+9zL1+WuJo0+9GQ/zTFIwPD1R8AO7pwO1+DrA3PDsVv8DEDnEZngg3AcyVcg/etZAdk9UTQJtStMiLJUbhsdnuBmpxvF1iYJUj4Rf09F6SHpAh4m6HESLh+v0ffoGtLzP66Ak6a22d1osaCMP0rgPnwM8gsvPev7E+IYwPPMAhmWBvpDZIxd+kHRYyZixaE8NPtVFuvePXLb4Bsv8Evf1zSSYcogEtUSCx2eDeQhnC653bhzgRjnnn+RG6h0au9AOfOk/5LG/ERPxbND+2eWdG1J+bmOvzpwb4vT0n5hLPYw5i7wbAyytyrnFUNFP1AqPyPUrFvGq/Ns5IuC96bm0eFEjMdoRi9eMiCaBCTL1XS095mI4sLEWky6eyLy0XiZM/PYWHRn88fsfewFjJ5UBGYkogDI6ww9awQl7+0fsffTqd4uOfZKmyOisUvga2W5zNHLSAQW37jxgUxdIENesLODn29gz3ybY1uuRLL25dXy7BngnrcP0pfEqmLsNwSbcCvlTM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(136003)(346002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(54906003)(66476007)(66556008)(66946007)(316002)(6916009)(4326008)(8936002)(36756003)(41300700001)(8676002)(5660300002)(38100700002)(7416002)(6512007)(4744005)(33656002)(2906002)(6486002)(2616005)(26005)(478600001)(1076003)(6506007)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bRw+xDUYb7k/52lbXyKQTyUE72kuggc2I1zYcbV4ZLgLeb6eRmfX8fA+9BwM?=
 =?us-ascii?Q?ZH6EpK2jbQFz9OcLMcmmP2H3MfLvxSO6zcnqvhxuv0ROC2mIrJvdqPxK/7ZW?=
 =?us-ascii?Q?Iwzg89kxb7pRSh7lMagd01Md7cozJOWiX2PnQdAak2ICabHlIuJ08RPNpuDZ?=
 =?us-ascii?Q?9Q/L938WK7n8/GyVA9xV8qdGQ/VDCh8VKPFBgzP43tjq1OYI6QUjMg5tCVCs?=
 =?us-ascii?Q?vT1R5TyC/bSDvoa6dnwIMPnZDcLMex5aDZko67FIjqHeVrMG1LwP1rUgqfza?=
 =?us-ascii?Q?PZ2OwpGbLIONWqjH9yqtsnKzUzlgyb8WEz4E6aGt5qPc0pQ5zQvUSe1bIfzl?=
 =?us-ascii?Q?lzvKPDDY8g38PXVnqIyH13HUB2IHegQwIX2HQAUQ44ZOeddrplVdT9nmEKNf?=
 =?us-ascii?Q?v9wW9RsEglWbeBv/Oga2/VvjYwf3CcNiMPeqS7FCpMK1X+RYoNGpJvoSQ39k?=
 =?us-ascii?Q?PthPEzAneOv91ctYerciZh+M563/Y5K8KKNjOVDA/OYnpi+21q8hJulUv0uF?=
 =?us-ascii?Q?e8cjfWnGPfsU5wpBo89EeQiqcn8OqZdX00jV9Hy//hFaqmk5HBzMeX2Shro0?=
 =?us-ascii?Q?zhiWog+M4FB7IkYp7Zlg5n3Ust4bYnmA66XW4ipkMJNSD/AR5uQ3OkyZXeVA?=
 =?us-ascii?Q?6GPxn2Z5j/By4CSALm9UUtrEney8qAGiWwv6QOzyrLxjtHHAjevGLJyPaJ7j?=
 =?us-ascii?Q?3KIfxII6jU+I1g8KdlgWPU/dCnP9qwrBJ+TiPIuIvlyyO6l2qblm4glX/y5Z?=
 =?us-ascii?Q?s9un38N1bK3doCGc4EIlmFLC17/pNHrJfRaK+VjQIFKmwUsx76sFGt3IQWKi?=
 =?us-ascii?Q?z7zzp0yS8CguSNkcQv18uVmCs5XWlDhcjsbyQX6tpPPH1At6+Qzw3qT0yb1G?=
 =?us-ascii?Q?sAnUEud88kqCe1o4CtKmgux2jidhCfxYmPVEe6ROdiEw8ti+M1TUWJR9ea6k?=
 =?us-ascii?Q?vCD1oJkpyiSJKrtir1RsyAuARiQfLXD3P9RuqHJ4T3RM1RdGmtj5POuYNkWh?=
 =?us-ascii?Q?3AN9T1+ifYoszPvZ1mNYZGLAjs51mwMCaQYE/TPEKJ6ITUOPyFONWNfuRCfh?=
 =?us-ascii?Q?CKG2bw8pHjn2I0grpCswCKye97U9rWAJmV8N3aa6o7vP7Yrd+la1kuvzEEiN?=
 =?us-ascii?Q?J142niGnLflsmUsYIiQXv6iR1WjyG/KyZ5Uy9yopU0kV1TJSRxMJ7dGdaZ2v?=
 =?us-ascii?Q?YF/DtVFxZ7XSfqziHQBf3zfRWClf+C9KFFfFWeh/uHOS92yDxy6RXX4tmR1D?=
 =?us-ascii?Q?VfETCLhMZpqhD6d/N38E+7M2eEQcE6U56G0dPW7whQ/1yw47yIphV+JNnEsd?=
 =?us-ascii?Q?aBftvG/oh3EpmvqndJ/aJKiqCHhr/LfO9+PIIYmWa34HJctzIzsXX+2OD7FS?=
 =?us-ascii?Q?XNi+MI2guQEeWRZw745fK5gm7Ywj4Nbne73CVq+9ZOtKY5TbXFU9SFtY5jHU?=
 =?us-ascii?Q?N98XXGw8i+CmwARfR5eTHqwM7RpR0iGFW0qSLtPn5jFHTR/bcOEyUFauaNBV?=
 =?us-ascii?Q?qqpYvF5uzzXMisaZne0umC0tmalW8JfAAinrDUQmy+CY0y7Fbxnja5vEmGRP?=
 =?us-ascii?Q?cbZpqM0Mz5iCzH6+MWDXJ3jowhfopDMCHKio3uw4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a778642-f45e-4996-4e34-08dbcc07cf75
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:16:52.1828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLMzi0WlN3hO8eSLb7SRBBWT8WUZu22Euu1PdZNofGExzWV6PeN9TY1lrOdZXt5a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7561
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 05:14:26PM +0100, Joao Martins wrote:
> >>  	hwpt = iommufd_object_alloc(ictx, hwpt, IOMMUFD_OBJ_HW_PAGETABLE);
> >> @@ -157,7 +159,9 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
> >>  	struct iommufd_ioas *ioas;
> >>  	int rc;
> >>  
> >> -	if (cmd->flags & ~IOMMU_HWPT_ALLOC_NEST_PARENT || cmd->__reserved)
> >> +	if ((cmd->flags &
> >> +	    ~(IOMMU_HWPT_ALLOC_NEST_PARENT|IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) ||
> >> +	    cmd->__reserved)
> >>  		return -EOPNOTSUPP;
> > 
> > Please checkpatch your stuff, 
> 
> I always do this, and there was no issues reported on this patch.

Really? The missing spaces around ' | ' are not kernel style..

Jason
