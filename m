Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB96B4ED2
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 18:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCJRhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 12:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjCJRhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 12:37:34 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B7312B7F0;
        Fri, 10 Mar 2023 09:36:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTL1kAFpleNRm1CJyotixKekLNuTXXxVDyoHZV11lDA4Bgewz419LWUEyO9i+US856AkMdJ1TJp0/ZmvyvMSwFFAk2R/M9em6CX1SlLAu3G7mSg+NPMQcbckLGknM9FSorFjCeB9q70by4WvL8CtVBRlpSTfHlSFsyLpZco41OUKqijiXmp0326UUcNhf3/PBJy1ZY0uYyPQ2RvlTmwvpfWzsiNDw2sfQN2Xq/SQgL30jhf7FfvrxkmpS6/5g0CJgjFuTjmOnDajPEIj0KA7dYJFTkaPXI8xhAt6aFFnkb/dxSKdlyaaVb30IOZfimr6stpfTRYMFaUwvHpTbEL4UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmQls6YfjG+90MMdGh0L/Y72YVkgxd9wiiKpmPwQBLM=;
 b=Wm9qGBkOPJLdsG+NjxOUhd/S5Pb58zW0VBAyEill80SAYikAvk1/C/z8O59qTPx+Rf1QhDMKIAhW8FAX9eQFokw87fUMSwYKaOSJ84fZQzrG8O/zSfFV8Ph3YRdctuXv3ifBqNaE7asVS3Wtw6JBea/q7xXnLTOmaCOaZ5KZs+kzb1NgJj688J5PSkoWkxWvcf7LjK4ho6CCY9BxvvXGMQMTr2f4qIpNPvTFf0uFnXFpecNQqG1/qaUNPsR0keuQ4DpnOnX+WDcVjan+XDZ4LpBwmGLgXvbvQStETj7obtJo4n6mexDfqhohmfu7AT4esxxNSybKjS6F7E3XKEKwhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmQls6YfjG+90MMdGh0L/Y72YVkgxd9wiiKpmPwQBLM=;
 b=pcotqcTU0ekEQC+XfX0Thvo4t7Jk7d3vAclBO+/+jp24Njo8SuOxy4IkqPqbZ5YliH0Ax0lJz6OmfjhKdE2wbG5Gbf1cdlKhhfGos897H0/jKxQ4eNgncdQ0zIaJCkuBAajEipGtGd81gnLPFc1ddWMQ66i4O5nfNCVfSe6lc1435g49ntdAud4Xfxc96ZI1Z1vPxOQQLZYsLlcVszIaoyJRn1NEiJJCKxsXtDzSSYzTfPPR2dYip9g+n4EX7QvXkDA5JmIfmaCo68jDnFPTButI1hGqjpdzc09hj9sEml2Gyt5aeOOTJsq0Cjc0XvpTDDR1ieCzR/V1oviU2oX4pA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6734.namprd12.prod.outlook.com (2603:10b6:a03:478::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 17:36:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 17:36:25 +0000
Date:   Fri, 10 Mar 2023 13:36:22 -0400
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
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZAtqlnCk7uccR5E7@nvidia.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308131340.459224-2-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:a03:338::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6734:EE_
X-MS-Office365-Filtering-Correlation-Id: d9a80d86-bb16-4685-c386-08db218df8cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: stZ7A6x2+AIuZ6vxHjlfFpQqdZDEklb5yThD8f8sDnFwoum+aQPviIOii+QUpVBpBidtOATGu+kiXRxm6YSMlfSsaRsNzztFgPgbiQk00y/b9Pm+CLL+z5SnXchF1ecRr2YBoZZCHYeTcyzMCdEnazRacjUsOkxDAwlxh4GQKC0KaaG0o8ZKg77zMVg4+pf94xQtpq9Ie3MJSyeIM5EY+zBB4/lPRd4MSBumSxuPtLM28zlZ5TlkO6YjFwUiJ7EOOiOqvckYh9pvcOG6W3afau6klNpKqZ97py3CTTpbediP0UBpbPx2CCDxdWy2xJ+jbN7s0eyW/oENvuywraL361kYAPTUERAcyqmaxgPbvIt22hVdYF3O6Ov2ZgCVpRXsqFY+UhXgrobakKpj2+bzRtdFY1Nh/dl6vaJaiPIuy/trA/6y9QcY64qQhqJhanNhpQG3dZQl9au72zyc7mANDnsIy9kDyKOBdtcMK3gjWfoyAmEjCZwga+gR9t/2I36CLBFQYN3ehV+e2fByFJYbGGWqJqD2G075iCpviPXLef6oliyQYa3kkEV5IpyZhTfmSBppPlYNf0LBXtGpotDYK0Av+ASxzlhfbKBCM0lFhu74rOIR6puh5MMKUBkSXQj6yAa7x/tDwJ7CNBYc6GYfyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199018)(316002)(36756003)(38100700002)(6512007)(86362001)(26005)(6666004)(83380400001)(186003)(2616005)(6506007)(5660300002)(7416002)(6486002)(478600001)(41300700001)(8936002)(2906002)(6916009)(66946007)(66556008)(8676002)(4326008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KHe13wVoA6plMqCCBYimpAIU1EFcwxKn9roCwmCFMS16wZ3R8C4+lpYdGgrk?=
 =?us-ascii?Q?jB0arIxFQ7Rpny5whJH49qvLLULKE/EbOjel0u5F1XAB9ncvcZP7ar6HihPv?=
 =?us-ascii?Q?GmlAwremr2rrGGpq5SJ7ZHBDeIC/5Fn2SpyFnbNkxo1WJCrqqgQ7mmD+fZ00?=
 =?us-ascii?Q?8hVapMe2Z9W1iONSUC5bnheAM1ecba01PVhjcV5XErriVsVDvEMH9w8LKccF?=
 =?us-ascii?Q?kNrLS/c4GuQy6b2NYSuZefVde4yGw9IzuNlbgNASm5HrMwhv1aeiFU99xzRm?=
 =?us-ascii?Q?/1YGUp2WAaQKuqbUKiJWO5Mi/GbUi0ta6lXvc3miEPXhLNpbj3Grvg8B0V8j?=
 =?us-ascii?Q?h8MS1uEduKai3/FQFKBk4rJIUSo/JJYbrQwS5fjJ7xT6GwP8rmoOUy0pkRVC?=
 =?us-ascii?Q?u1dGMIKsxQUp+jj4Nl+NpjikDBqHKLRbFioOhYsL/hcqgCJndHVNjnvdfyEx?=
 =?us-ascii?Q?WfAOqI7HuIOJfVnzGoBOFh52EBCV4Ok85GlOvMPt5FoRhxgaw7+h9qD5d67P?=
 =?us-ascii?Q?51zaM11lfAeK8orzUKgfWx9ofI8ZvAvLKheEZvbhOUV1mbdBeAq/JzhKp/a0?=
 =?us-ascii?Q?aG7ieAI08Wn4cDcFFZBA25vYOMmbFiNJ/N1YCi2r45OhDusZfHTpTlzDGfQm?=
 =?us-ascii?Q?o//yVsZp7AUjQsAX2J25b6EMG2YYXDJ6BeaLnJRUXQYg+LIiTMr1p/ilD78B?=
 =?us-ascii?Q?1lHJwwuduH+Zwq+ZXoSR1/aQZ27qaL5gPwuNzJIy4Z7/3qpjPJvLIldMe+4q?=
 =?us-ascii?Q?U8tFf+birep7pV7XV9p1wzXOLYP8G82zY+1QegUhpheDU20O0g1LLBD3HXKR?=
 =?us-ascii?Q?75Eor2n4vSioNjxKunvpQwXwdzyCNF1LBXC7tigOROs+YtSPTTA3F5sNdQ7d?=
 =?us-ascii?Q?bOT+QmCzXWq4t2Uw8r9rX/hsAk5SDlIStXaOQMG45yWj9t9E9I9WKeH0pLNW?=
 =?us-ascii?Q?FacKBmehGSBgIMELbjklpkAwdjsecsdwtgp0kVhB5JXHYJB+wJ75gtixxvgu?=
 =?us-ascii?Q?FGtYBd1oBHV896UNPInejifgOf2REKWge+0YHPZkJBzAs46fVe8d9xUgu8Jm?=
 =?us-ascii?Q?Sk+MjeE+BPpHIaNg7eQnQXzXBhls27G+1FrWVSA6W1qJY5ESVoudyjzwX3TV?=
 =?us-ascii?Q?UHuPyIJWlzf52Eb6OpVXT1SIpTNQGOCj6cjPrSW/wPIolZtH7FbPJJ1EmPqT?=
 =?us-ascii?Q?/uM56FaGVlGdHwc1ZN0rHv/e7AL+ha78PbeqLUeHoFt+IBmKe1A06xSlWTix?=
 =?us-ascii?Q?XqKwibhG5w3SEaFl0bim7yAhVwa0jy7EQ2/y8kyV3ApnmN/CTeqSdIr7aEMQ?=
 =?us-ascii?Q?igFUcS1mt+KjsbvfTBB2vq3Un6ddxwa6sEZ+9eUaDjktyTCr3oBHGBlFV+Mc?=
 =?us-ascii?Q?y6eykW8quVgEANlJJ45TFyZ7UUZgH5jxF3JTULyFm/y6CUEbQvEEc3bRrvxD?=
 =?us-ascii?Q?bh+09ATHJ0szghTGDvFoZO32UBJfzSrQ28LfjUBKILGgPx+2tuaq/x9R6/iY?=
 =?us-ascii?Q?CUFBIqLFp4Dt3HIu5f/i1BnDlQVpBYaXwNz4IyypfGQ90aYUh8kt1HCsWYZn?=
 =?us-ascii?Q?Y5BwM39POBz6CSqmCtB1NrLSAosyVw9Xx9J5P1mh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a80d86-bb16-4685-c386-08db218df8cb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:36:25.7358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KJEeBl01yxrj0h8zUrTM02Unu0pNlgGD4FkCIkO9ymCIioVqWlvOfEgAkBXg56L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6734
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023 at 05:13:36AM -0800, Yi Liu wrote:

> +int iommufd_access_set_ioas(struct iommufd_access *access, u32 ioas_id)
> +{
> +	struct iommufd_ioas *new_ioas = NULL, *cur_ioas;
> +	struct iommufd_ctx *ictx = access->ictx;
> +	struct iommufd_object *obj;
> +	int rc = 0;
> +
> +	if (ioas_id) {
> +		obj = iommufd_get_object(ictx, ioas_id, IOMMUFD_OBJ_IOAS);
> +		if (IS_ERR(obj))
> +			return PTR_ERR(obj);
> +		new_ioas = container_of(obj, struct iommufd_ioas, obj);
> +	}
> +
> +	mutex_lock(&access->ioas_lock);
> +	cur_ioas = access->ioas;
> +	if (cur_ioas == new_ioas)
> +		goto out_unlock;
> +
> +	if (new_ioas) {
> +		rc = iopt_add_access(&new_ioas->iopt, access);
> +		if (rc)
> +			goto out_unlock;
> +		iommufd_ref_to_users(obj);
> +	}
> +
> +	if (cur_ioas) {
> +		iopt_remove_access(&cur_ioas->iopt, access);
> +		refcount_dec(&cur_ioas->obj.users);
> +	}

This should match the physical side with an add/remove/replace
API. Especially since remove is implicit in destroy this series only
needs the add API

And the locking shouldn't come in another patch that brings the
replace/remove since with just split add we don't need it.

That will make this patch alot smaller

Jason
