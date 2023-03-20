Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947756C1E41
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 18:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbjCTRjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 13:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjCTRjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 13:39:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702452B9E6;
        Mon, 20 Mar 2023 10:35:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGwS9HNRwBFmOIZS8REuhiDjrfujLNa/q+2cSoz+xwFVQxdwzQCsUV50Kk0+oZtyxr7SIE7yXrs/Z9rhveOKHofkybhxXbQm7eQOZEQAtxfVHyWBXHOG0s8N/vbnYjpULzzQwS1TaypcBrLRKmIGyDFMN4NBUD+5WL7Z/PG2QuF9eOvRG+RRcvVBM79RnXJgIj4FIFTG/411iKUu/eH3NuloZcacmewtbFXQ1B/MeKOjjp+dSvCSEp4W2Eq8kKR12Zc1r0Jq6UhoYKO+OIXrq1osDQF/dyXzNgkOXSWfa8+yWC68oO4sXglWeD6eynqaL9jwFSxESKtkuvWph77O1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o+qAN/g9AXuwZGYfCOa9nM6TVRCV4wJ+m0RHudO6ptI=;
 b=eJyHEU00/Yc66ouqZJUoznEYt9l/pQbfAOADekxOD3rfudJZKy1UdIr/xl0zvBUi5ywQKBYiaPRtFGqTlUbBwL1gWHozONV71X3TL5DjbLeshxB8pLKP24lYfoCi2eMmYwtEED8EVPFycFKo+8cENLD6kmENSso/m7GPgk7HpTlD+CUVT4b7yHBt3Bs22ZwxC1gF5AvbeqvQD93tw5MQs6QHp5amvXK/QUOW1/CBIlv/+kW5Lj+XAvL/FPf3khhhPWH0FC/mGDWcKU17YwqUFxxN9QDsTYiEp8OexAkQrSBpSLbgTZ0BofsmLsU0N75ZZrQMzoHlukI0pD+/9EdenQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+qAN/g9AXuwZGYfCOa9nM6TVRCV4wJ+m0RHudO6ptI=;
 b=TJEpbUgTc0iAcxgG3VlJVEnfWhqjwadmjgZX0JBYol2ZyXS/yfWMMFHluH5/SdOjhl1TS4B7pyv/K+Tv2a4jEgaKXQuM2SrpsGJpi7cjZIL8K46vWtUEl3TsFff/tvd8lljLn2GgagtxG/gnI8wI180EEuDs3iRWe7Oel4ckhRPvM/UA1SkUTM4oWm8OAPTyjHGoC7STTwAGOrFy1hZ10pl4oQpbSe5FOso9bW55D3AxtwWWqm0kCRk2bO9iyvhP1aUgKeZjCB7YnFm+7BWBTHraE4ylPru2g11cGpW2FsPgHzLTeiId3n4+EXo6WgNdH+ZgPkNWe4SO4HXHNEbrUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB7304.namprd12.prod.outlook.com (2603:10b6:510:217::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:34:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:34:30 +0000
Date:   Mon, 20 Mar 2023 14:34:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v2 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBiZJDo+vD7uJTfP@nvidia.com>
References: <20230316121526.5644-1-yi.l.liu@intel.com>
 <20230316121526.5644-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316121526.5644-2-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAPR03CA0151.namprd03.prod.outlook.com
 (2603:10b6:208:32f::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB7304:EE_
X-MS-Office365-Filtering-Correlation-Id: c1798c42-4e66-4f67-aa46-08db29695c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TEgW66tHDosTeQMigxWJA4t4YutNIKtcY669HmTwC01Kg++0La+QexeOK11SOLGl/m/8iBPaER9Kzt+/8CHDeLvQDs5hPxG+ElyKja05iAaZK3o7Mc9c6MS3FxgjVPvG/W7bru5YMl4Fl12UZqnd0ObXMpBoYc0MXLi3Xk0b5KBDY/7dB9UTnih1B7giHkL4rY0GeRWumTda76v94HunD+n/+y1kyiI2noNJTQfP0qT5pDIGLjHJfR12eu7/q5tl49Z9dvq6A2HrEt0byGh05jbOr9Zf8RDDcUo0TR98MYCkM7cj/N93T3Byvk73gaTh+G62kdITqCnfCp+EktJkT4V7bG6QJi5FXXeIIDwRpu2zoW/QNHMh28+RF9yeV+0IHX2fWys6Uo3T20f2VSwi1mlAmylNpM84Lf9QKKj4mRMnjg06oQb8NKTpd+jhXAPdb0GRlbpThNrJUUwydmvSX+YHlantgmY5R4vUT79kSJWsKLr1p8Jg+G7YZCsyPO9grxkVX7qjyF8dDr2jgduotSc0QlUyyMxRO83rMWO9Vxb53bK/nXW0VtJFmDMH6+mNB1H6l2FtlesfvifNPMJH8dFoJXKO1myLnRuk0euZUNfT6jfdQlLRVHiFhKwpJSn2xqTwqe2816FzA5RgA5YugvAl4/S/8k8nEqkxW0c3p8o6GHtWjGP+UjNshsX34hEj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199018)(316002)(478600001)(26005)(6512007)(6506007)(2906002)(6916009)(8676002)(6486002)(66946007)(4326008)(66556008)(66476007)(7416002)(36756003)(5660300002)(86362001)(38100700002)(2616005)(41300700001)(8936002)(186003)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F8ggpbat+GHcY+xUFRLNYK3rRncn2VWqSiO7TsNL/rzG3WEGfwBRW/+ytZOo?=
 =?us-ascii?Q?+taxBlhEY16weO+smpU2vtdYfcEYREzuN2Fu1txoh5jfVjrwxcH1zHJYs2Z4?=
 =?us-ascii?Q?E0t8L+TkOC6KHcIZ7+p+EEN5EhuK8FIw4i9Jerm8egJz/4fELHNbsmtMGmM5?=
 =?us-ascii?Q?IiUKxh1drMGpMsr3mOE265hT4xsQ8KXQn4NMNJ6iYpjppqBQRDxVK4Ms7Exv?=
 =?us-ascii?Q?3qwsuRF3fiuKaARIpGRLJBCDsZ6ooNTP0oPpavIjFECdhzc3f6SQN2rqPbhY?=
 =?us-ascii?Q?bzZwGkNnHwvLzUD2iAXhtL9q2dcSBSuZfcUwa1h9CCx+pO6cSbzKUVROK2FU?=
 =?us-ascii?Q?SRKryL4spszeKCEiH6olCGswqnVNWe9oWEhxEQ2YDrcZXROBDFpTizexIc2c?=
 =?us-ascii?Q?6aEODvY82KiNgUbFMtqHX9K4TAfAD++r4QSo2NQ5pwQaFa6maprhQ4aio1xm?=
 =?us-ascii?Q?Ny3+m/D53kXnvZ6+Jmbcsf7p1yiOhRXZ/Ugi6uBU8QuqeAdO8zmrunXXsV58?=
 =?us-ascii?Q?48f9V5jAsEBVNg8NrWOPua9ms6rTa0XFatG5GvegMTR3CwabY1BXoUbtr8yW?=
 =?us-ascii?Q?25moZW9mhzzYxFi4jOTeRAnalm9hdbxYvPk9P058G1+hDa7O1VTfsbn9daSo?=
 =?us-ascii?Q?Hr4TQxWdgswWP8KHOH/DLg/oY9R5YU13etkPMptd3ZZ8NdiVsBTVZhF9s50q?=
 =?us-ascii?Q?kNFFqUY7UR4eVqBxj0t3LtviZHxu8P07zOnFwFFrZlwEKnxsmPKzCQ2WWVJv?=
 =?us-ascii?Q?kzuMyIUG6rg5sm6GnusZCywIKXGQUJZoeckJtuzb+2Mf1G7GcLmXM/wRLBlg?=
 =?us-ascii?Q?XesysNcVeJtMHwOMwhvkuaqfi/dCDCwYLnHWOREtO8a50HPw46q9FMEOKadf?=
 =?us-ascii?Q?GsIsXEj8uJYGyabOTDBULJC4ZT5qaooVj/3ow8XUx+8nz5cS7FWGFr7R5EL3?=
 =?us-ascii?Q?0GPxLCEW737PMMBbOXgyQuglMwfW6EL8GlLdCkNzXPBNxaK0ClSS9mqFEIyW?=
 =?us-ascii?Q?jmNxYiYicc+/1hd9Rz21j1U7uOPnfualgvr4eV5GQJUnFCILWLTCMQWXpGuU?=
 =?us-ascii?Q?/thqLulPPwD9w+DNdu03BnzJReItPKVvkKMFzDQfo98ot1vO/apkqAM77zXF?=
 =?us-ascii?Q?p9KShdiihuEmltlz2/VrK7N+WzdBSsHfEkfRhcAYwbM0frbL+GOvfRG05QCn?=
 =?us-ascii?Q?zjRqnzi8XDWV9V1XqR6Rqamy7fq/3dQ7MS6V9tFEIBq+4vdHyF9zlhNVqbCm?=
 =?us-ascii?Q?2HnWzaKto8A340/j6E6s82/KyZ037w4MQ1dL92NDnmy5q9NEsb2ivfJOKFqg?=
 =?us-ascii?Q?TdEWqFifhSANX8DKoOpLGzaE0UNuXsP/iaPCUwJHupueOzzcJVPHTeZ0LCKK?=
 =?us-ascii?Q?tzjdgkHP4K+DS5uAavnvc38H/1ZURU7sgcEZsIiijYnAQCs7GuqMlyFJklB/?=
 =?us-ascii?Q?kDh8RBGPXliNU8OuOuOEyI5a5ghwkLJcXKkzyZNFXrndU9JzQ1OkMfiBYTQe?=
 =?us-ascii?Q?084f7kaFeGxKOZ97venWtdkcD5heXI1ldiWen4zOVaCjTaXCFfTqnrGlXjSt?=
 =?us-ascii?Q?bp/voKGukP9JnwrQ/WYRSXfzwgbdBRurfxWuiYAa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1798c42-4e66-4f67-aa46-08db29695c6d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 17:34:30.3927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PVDc/gwMKfYdipdvRjRh/Z+WNfzzoym5CqcjEDegXNPV95TDnK22bM17OkfFZOC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 05:15:22AM -0700, Yi Liu wrote:

> +int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
> +{
> +	struct iommufd_ioas *new_ioas;
> +	struct iommufd_object *obj;
> +	int rc = 0;
> +
> +	if (access->ioas != NULL && access->ioas->obj.id != ioas_id)
> +		return -EINVAL;
> +
> +	obj = iommufd_get_object(access->ictx, ioas_id, IOMMUFD_OBJ_IOAS);
> +	if (IS_ERR(obj))
> +		return PTR_ERR(obj);
> +	new_ioas = container_of(obj, struct iommufd_ioas, obj);

This is

iommufd_get_ioas()

> @@ -161,15 +170,20 @@ EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_unbind);
>  
>  int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
>  {
> -	struct iommufd_access *user;
> +	int rc;
>  
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> -	user = iommufd_access_create(vdev->iommufd_ictx, *pt_id, &vfio_user_ops,
> -				     vdev);
> -	if (IS_ERR(user))
> -		return PTR_ERR(user);
> -	vdev->iommufd_access = user;
> +	if (WARN_ON(!vdev->iommufd_ictx))
> +		return -EINVAL;

If you are going to delete these lines in the next patch don't add
them here.

> +	if (WARN_ON(!vdev->iommufd_access))
> +		return -ENOENT;

Just let it NULL pointer deref crash on this impossible case.

Looks OK otherwise

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
