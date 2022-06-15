Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD2754D21A
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 21:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350244AbiFOTzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 15:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350213AbiFOTzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 15:55:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98E229345;
        Wed, 15 Jun 2022 12:55:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIXf23gG8hZ5SnffCMtyG5myk7GLNfesHn7qlYO+33mn54dPLqp9B84HSd7dtjkkA3NlOZRPZwK1HBouVHUlbqKoVfuRv1ZLsxQCfql9fOacA1ahkWd9JYvGcHTFDgUDYjUsYKINcDwuNOwDpjamLRQzmFSBHJ7rZg5CRXixk8A6rgd6Y7i56Ho+WNu2QaZl7RSRiyJK64SiZgczmfVudavtKmCA9A9aibEEz2HM2/nvSYnMzwP5tL95r7lZ371Je714njMzpgKolQuj7tWfU1lfTHQHtFDEHNl9EXxXV5xu1eEEAE7MrKIHBxqzcufO365RuavwxJuOwv2Cu+SmWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgeu4vJqyOpj/zEViSQRaMn/F+TAYSoSDXdMYlrMl3k=;
 b=AhocZYFslVrjdQpHDDYygqDM6mUj0EXT/JkY1z4vRC3BN2+AhZ2YLdUhKFcUv8QJYnK8GzR+5ilpfoLvEOMCh8Ja0Nw0xI2qBwWok5mVwvHur/V02WV3sbR80rE/r0OsSybgiE2spOb8VsHptrh4JK5PUXxQnRun9lzR7rdrmYXPcWaHjJgGlzdhBXHoztYGg83wuVFe24YnVLzH8elNFRIYAHP0iBgXupH+9awci3epmNSKRU3tVzmOtw571cBi9Y8V0xYcG5ZVco3+XucVoH9VO2pXsKskXkS07p0mTrL6Hmf//1Yv5gBztiI/hohZ283DDi9fIWGFaMZB2VHpTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgeu4vJqyOpj/zEViSQRaMn/F+TAYSoSDXdMYlrMl3k=;
 b=Zk+leH1KRlL9Dh5FXzSbNfUl1Uwi77dMHPG1ueIxfLgBQ2ISjO7KybsjukLKKacG8hTO7do8L7cMINyovoTr/lcsS1tE0ODpmr1FVQckq76vJ+Fr9E1/NLWbKla/X8/bOUoLSxq94aUpeX7T8Z9uYlIYxQqRXXflZZEdR6vunhjv2qfu7Gpfl1mHc3/Fxp0rlj2BBlmgZJvyndCfEeF+eN1dpYpL6Dhli2keKv1f8GKSFHEJrEHwbntHbLwMmw85oGA+zLlATkMriXjuqm4MWhxzQiMSmpdozpOifSE+p2YydM+cBwiin2/9iE+JZtUGnM/sFshGLieOO64ULHepCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by DM4PR12MB5039.namprd12.prod.outlook.com (2603:10b6:5:38a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 15 Jun
 2022 19:55:39 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 19:55:39 +0000
Message-ID: <6900fbd9-5f12-e53d-1a57-d9671491372b@nvidia.com>
Date:   Thu, 16 Jun 2022 01:25:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 03/13] vfio/mdev: simplify mdev_type handling
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-4-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0004.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::14) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c94b8fd9-2eed-4770-bc2d-08da4f09053f
X-MS-TrafficTypeDiagnostic: DM4PR12MB5039:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB50397EEDBC3A00E77AE187AADCAD9@DM4PR12MB5039.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 19pbHtoyaoK2D6oNWJElxMXKiJ4ooMIkJc9FkiHzHNhkn6/1ktiuPfNvotH+qtQsY8ftYPd09SwabBvqsvTu7//OCmj+IAzVLBZVfbFssX9abieYA3ihpSFVQmK0jdquzdVhIFplYX6tBvUvXsXoyVxC44oMrEyomHjwPCiWkSwZNQLWOEQrmgchW09n6AWWSHX0CK1Ii9f+6KB6dUVrVNv0wv6fW4kvCWLDbULCxUyEoLjAyBgIrMh25StJsRhH2DgiPO8tKa2kssVoK1xZDSUr/R/EDOsa1AZ+DCrlepSoZ1m8jYgT+1oBhx6NJGNPx3PNdvdOdgYpOhhc7C9kJ8tMQGyEnX8OC2nR4jislYxms2fqaWOd5C6oQAu5d7ILiYgba/7+ERIiBeEuyjF2yjVtWkEhnNMSa89F4VNpmc1pT+tZ0zAICh1ymVa+r/L8+gto0/74LU/b2QZUfcfNJQZk0I0HUkZoGEx+8CVqH4hFifIbMBsVMC7NA418NXa4NEO61DshwqHlE54o+WFQwBkl5OjE+QoA3Nw0A9Oyqbn5bC2YT78Hl4Itpqzh/7yrsmAEwepl5Z6Wrf5KiYgtu7+EKvsEfsQ50enfWxWbAsdS48k1dgXJ2nc0bW2EapkHW2V+kOi/PbjSVAuQA1WdVWAlifDrzrybLs6PVYCv7UfsAL5Qi9uqeb8u46VJjhGca0V2sfW9B6+DBsPfPky6ibyl2lxn1HxVykhLhRj4wdI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(2906002)(6666004)(66946007)(66556008)(316002)(8676002)(8936002)(110136005)(7416002)(4326008)(5660300002)(31696002)(53546011)(6486002)(86362001)(6512007)(6506007)(55236004)(508600001)(26005)(54906003)(31686004)(66476007)(186003)(2616005)(38100700002)(83380400001)(36756003)(107886003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDk5WVd5R2gvMkZyeU1OL3FONFJvY21RQktqSEp4YTJ5SWhSMU9COFZUQ1hF?=
 =?utf-8?B?ZkZQdTlWTlU2NzBtL2l3TWx5M0FQclpHc3NyWk14enR2d0VCOG1zWVliaitJ?=
 =?utf-8?B?MHlhTVFQZnYxUTM2dVB1ZitORldoN1NnZ1RWeUdUNXpjbTk5eVZFRDVOWGp2?=
 =?utf-8?B?elF3aVVVcE4rYmFRZ0dQbFdDU1d5V3Y0akhGYkd6SzM3WG81aENRS1FaSXdV?=
 =?utf-8?B?bDNhL2kxcTgvcjJmN0x2VDZTNUVad0phWDZ2cVFWWnowc2VMa3RqUnorU0N2?=
 =?utf-8?B?bFYzNExBZFl4eVBUWEVZSllId29wK1diVStpU2lyeFBwTC9BK2FEOE5YR2VL?=
 =?utf-8?B?bW8wTXRHeE8rYkxEZnhibmw3VEU1VXEwbmZ4b0hnekVmZ0NCMGR4NXpIaitk?=
 =?utf-8?B?Ni93RTV0WHZPVnhGUTIyNVRzM2MwRnhodzVIaitOaFgxTk0wR0F4NTlUNWdj?=
 =?utf-8?B?dVdMa294enJ1d1pUakplS1drQk90Y1FWZXpKUDBJUWNsbVdqemZYYnAxNGQ4?=
 =?utf-8?B?OXhYem5PenRmZ3l1NEhaVk92TGxnREdWNFhtVExRaG9laHJyRzFpM3F2d243?=
 =?utf-8?B?QTJNKzNPQVhsMlZBejhvT3JiQnFMMkduTFpjOWltTDR3dWpQOWFqRVJjOGhq?=
 =?utf-8?B?SW1RVkhhYTV5UnM0MVN5cnA3a0VnUnRXNnRYWUY4dzlJMElOdGNnSFk5RW5V?=
 =?utf-8?B?bXh5T0hURmRqSjFSWUQ0L3lkR3B0Ulh2V1FWY0hYRTJkSG9RUkMvcmIydEU1?=
 =?utf-8?B?S2p5dlBXQ3NDeHZNSXlaaXRvZkFRc3BBUDlyS1hxbkg4TzAvcjlRTnBoOVJm?=
 =?utf-8?B?c2VXbTNVMHdhRUwyanU3eUVHQkJONnlkd1ZhSlo5Zi9mcGpraTFaWGxOMGRK?=
 =?utf-8?B?b2ZDM1JtaXpZbnl6SnBYZjhPSnRpQmNNdFVpOGE0Q1NJRXVXUmlnVTI2MWov?=
 =?utf-8?B?bG5JeEc3MXYxaXhkQXI5bjkydVIwWGNBQXJFdDF1Mit4eTVwZUFZRGV1bmZF?=
 =?utf-8?B?eGZETkJGQ0V4SWkzNDlXOFpuZ3FjQmZSVFovNy9UNFJGalplZHNXaGFuTzZw?=
 =?utf-8?B?dHh4TGNzSGVtZjFRSjVScmxxblRIUzFobHFYTWNLNXo4RlNHZkR3cWJGaTZH?=
 =?utf-8?B?TUI5Sk5QdkhNbEJ2UnhhQThoZVc2NlhIYjhhRHR5WnhGVzhWeURSZTJNcE1I?=
 =?utf-8?B?NzJueFgvc0pwcWFhUE93NVRrbVNKckJPOTRhdDUwK0xUWXhsN2ZpR2ZNSEta?=
 =?utf-8?B?YllSeHREUkx6Y2ZnL25hUzJZcEFVYkY3UzE5M1NHdlhreW5YV3I2bjQyYk1z?=
 =?utf-8?B?d0JQQ3gxdDFWbGNlVFludm41Z1hFbTI2SGdxQ2E2c0JHbEtEUmZiUFJHcEh5?=
 =?utf-8?B?VmkzRVFvREtRaVVNY1ZXV1hOanhhSjBiMkk0VDB1dkF0clNWaWIvTDJiTWlK?=
 =?utf-8?B?Mi8rQnFsanFHaXRITm5FWW5pVWtBM21zenpGNlZYQ1o3bDArbU5LVHhPMWc4?=
 =?utf-8?B?cThadVVHVHgvaUtWR0wxSTNUYXFuK1hJUWlnUzhEWFV4dGVKVGdtWTBhYnNo?=
 =?utf-8?B?bWpwbUZRZ0NNM21vYWtHMUJlNk92MGM4MFBHcFhMM0VQZ3p1RzA2azduR2d3?=
 =?utf-8?B?a253a1ZWL3hHdmh3cDNocG4ydFNxWHl6UEQrR0xMclRxa2VuSHNvQ3R4L0Fl?=
 =?utf-8?B?aXBJNm5qdjkwOXR6ZjZMdHloSFk1bW5XS3o5cHJHTDdNSkUwMnpFRWJMMVMy?=
 =?utf-8?B?RHl6UE1TSUdtbXNvRmdLaWdCSnZwSS9PdUtJR2dGL01iNGJjd0dHbGpwUG81?=
 =?utf-8?B?RDB1TWh4TW13Rit5T0xNNFFpZUZMNXhVckEzWGtncWtGN2JSMTg1aDlZazFV?=
 =?utf-8?B?OXppVU8yZGRLWkJkOHowaDV0T1JFcWlHdU51YnFWVzhqbEduczZDVnh0SUN2?=
 =?utf-8?B?QjJ2ZHFORDJsOVNqc005RlhrTVRlVGlXM0RHWmhjbUI4ekNpcmlUSjFvSUxv?=
 =?utf-8?B?RTVMQUpHbWRJV25GaCtxWFFYMnp2MnV3ZVJrTW1pcmlVbHdLdG03TzRpdnhz?=
 =?utf-8?B?QXlrNnRqTnd2L2pIVllHZUh1a0FwMytEMWo4VXBJeEMvWXVwVWJwSzJnZ3Ra?=
 =?utf-8?B?bmd1eUp3VXZ6N0NQNDNrUk93WXdQbUpsbW5JdFNhbHhEeEVSalpPbHBBK2ZO?=
 =?utf-8?B?bk5yRlQ2RlV1S2loZGRoWEViRXNDR0Jlb1dkdkJBYjFzNWpRV2kyc3BPL2xv?=
 =?utf-8?B?U3h4bDQ2dTh3VW0rZ0ZXckJEZUt1R29qQnd5bUhUeFdyd2hNY20vbEJiVy9p?=
 =?utf-8?B?NTFPY25vRFgwc0ZTY0ZiemxEN3lBemRmUll3a1RaNTBjRWZqNVJSQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c94b8fd9-2eed-4770-bc2d-08da4f09053f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 19:55:39.0677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9xk8pfY+eUYY0Dghv7ArkY2ztLkw1yO91uAXn+Xm7LcrPDEpIaP106EYYdx8UpadU+9oA6t24k/jr66rbGbCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5039
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/14/2022 10:24 AM, Christoph Hellwig wrote:
<snip>

    /*
>    * Used in mdev_type_attribute sysfs functions to return the parent struct
>    * device
> @@ -85,19 +65,19 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
>    * @parent: parent structure registered
>    * @dev: device structure representing parent device.
>    * @mdev_driver: Device driver to bind to the newly created mdev
> + * @types: Array of supported mdev types
> + * @nr_types: Number of entries in @types
>    *
>    * Returns a negative value on error, otherwise 0.
>    */
>   int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> -		struct mdev_driver *mdev_driver)
> +		struct mdev_driver *mdev_driver, struct mdev_type **types,
> +		unsigned int nr_types)
>   {
>   	char *env_string = "MDEV_STATE=registered";
>   	char *envp[] = { env_string, NULL };
>   	int ret;
> -
> -	/* check for mandatory ops */
> -	if (!mdev_driver->supported_type_groups)
> -		return -EINVAL;
> +	int i;
>   
>   	memset(parent, 0, sizeof(*parent));
>   	init_rwsem(&parent->unreg_sem);
> @@ -110,9 +90,23 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>   			return -ENOMEM;
>   	}
>   
> -	ret = parent_create_sysfs_files(parent);
> -	if (ret)
> +	parent->mdev_types_kset = kset_create_and_add("mdev_supported_types",
> +					       NULL, &parent->dev->kobj);
> +	if (!parent->mdev_types_kset)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nr_types; i++) {
> +		ret = mdev_type_add(parent, types[i]);
> +		if (ret)
> +			break;
> +	}

Above code should be in parent_create_sysfs_files(), all sysfs related 
stuff should be placed in mdev_sysfs.c

> +	parent->types = types;
> +	parent->nr_types = i;
> +
> +	if (ret) {
> +		mdev_unregister_parent(parent);
>   		return ret;
> +	}
>   
>   	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
>   	if (ret)
> @@ -132,13 +126,17 @@ void mdev_unregister_parent(struct mdev_parent *parent)
>   {
>   	char *env_string = "MDEV_STATE=unregistered";
>   	char *envp[] = { env_string, NULL };
> +	int i;
>   
>   	dev_info(parent->dev, "MDEV: Unregistering\n");
>   
> +	for (i = 0; i < parent->nr_types; i++)
> +		mdev_type_remove(parent->types[i]);
> +									
>   	down_write(&parent->unreg_sem);
>   	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
>   	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
> -	parent_remove_sysfs_files(parent);
> +	kset_unregister(parent->mdev_types_kset);
>   	up_write(&parent->unreg_sem);
>

Same as above, parent_remove_sysfs_files() can be updated accordingly 
instead of moving it here.

Rest looks fine to me.

Thanks,
Kirti

