Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D71054D19D
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 21:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346151AbiFOTaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 15:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239149AbiFOTaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 15:30:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB5D544E5;
        Wed, 15 Jun 2022 12:30:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiEVL2qbLC2SfXsh8BvF+jHMxtjyeJ5R0EYOHkTUyIxb7UjPjt60MG1i4fZJGSkq2YnCLFhWFZXdwlB8SDZo1YKX+b19nlyROX8WRRrYROV3tMKK+93SLwyy2yTiqPY7iSl1V/aLYUYqDFtwt9wS9WfXFIsvtnAtslH1V+QpvFV5DY6ATHUhi8DiHxs6M63WHcPY4VGW5K6LvFA8CYB1Gtqy67wtKevPkhFq6AeLB4DMVj1m+L1iQLeuTm2RiNvkOC1sIajMPV6PEhCchpvOkcHZG/wIk1vQBJveZmnUHPyI4jfN2bdByKGQGP+FqjddwO1uvUOJTuEWqZ3IZVOMJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0w5ZEWhiWbJpJUdX3D9XeaJTVDL2qWWrQLYLwD1cOg=;
 b=Q0q9UMWQE43lSQff575nrbfLDko/xtuNY66fFLAm3+M5XkRtj87MgpknoQAQ7KDiFwtZw3/zIcEa9j/yYahCw4i/qSBr2Xz2pAHxKXNBfp/vDNHdwtNYfXwOF343S1cm+4uAFRI1r18VjjYCLARshdsuJ+Z0nCXonxMxyfcVym6KgnQCeRYA3VsLGbNDy5LscaMRF88dgS5Vm7jxWYznJsmwuC8E8bqJOnaoHvm7GgG4/3OAHWhcNb5/w5wAlNnLv4hbyOGbJ55eYiekd/X4QkZg4Y+rHt2uUMbAw5fIR+kAJ/oqYCCjKFNDf8Io+W3FRMUTY3NZy1A1zZZPEh4O/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0w5ZEWhiWbJpJUdX3D9XeaJTVDL2qWWrQLYLwD1cOg=;
 b=d+a7FYL5HwjrW3oPkTMLG2ryo1lj6AIgM7EisY+wi2BcZe6CPOgdd84+KX0UD7afhX+byKTblRFfc91B2CRV1iRRTCrSej9EyHNBhuzmqVuKDJYdCIXZIy1JwO/1JFg/+Jnyc8TtV9uPBRaRWSmcesSjoRDyAgyT/k3XfOltSFJaweBdI2rkLxrXpxm+JUSAPB1W+0EhjV1Nymq+Y03cwasoXZ7QoD9O25SGwLNlY/795BR9jnwf8kXQI5kCKOpk8vBwil/Bj7XGLDTCeitmLlBy/WM6/zbUFLbgwwybt2NUptObbyhApoveKGamQHYkwGhPuO8TCgP96MW01ZMZIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by BYAPR12MB4696.namprd12.prod.outlook.com (2603:10b6:a03:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Wed, 15 Jun
 2022 19:30:00 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 19:30:00 +0000
Message-ID: <ab47e216-f027-2083-308b-89c6aaa2e806@nvidia.com>
Date:   Thu, 16 Jun 2022 00:59:47 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 02/13] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
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
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-3-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0070.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::32) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb4176b-f7f7-40cb-d4a1-08da4f057015
X-MS-TrafficTypeDiagnostic: BYAPR12MB4696:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB46962188DAB1A91529CBC944DCAD9@BYAPR12MB4696.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VdzKprm0XZKd3bAQtUaxlrTiyDdzN4x1xF8ehTWaNCKUWCY4faCUjgyyIL+AMHC2p8tmLxq3uwsNviX6eVXoys/tGP0MldQe6wCEkCaFxMVjr3NENw7ibN9cG14tdbiwMURpgCL0iV195wasY5fY5o1xDMJOt2o5hsrlkSzuygVQVjP7REApF1ZZsC40q3iNbdND/VxSZ0lBi5w1lE3cUH7jin++VFmdmSmyi23585cwpEimwmyzq8q11SMucga0ZdhcFdfHcLrJrlRPnt3G3eh0tQbwpeXppOyUUZrw2wsCAk8ruieQlwFmGt2EgT60rs0DHXh4sXNSrn8prAwTLTH0v1qmU1nVwQE8r7hMJCC48qFkBR++XWAnRXtkJPKCvbX+6Akx6tJUEs0T0jMu4+Fw739ZFq54yO9XQjVsITv4LbOjAFtFSD57icetnSA6FemfyEdn2g69s4O57G+CV/aJ8T1KpMqQaojoar2t2s0LmZ0an18KFqqZ1ngB74P7dtrScnrNkjD2uNU1aPVnJXEX0zYoH0mwJPylKdYXi4oz8f5TlbVO3L5S3i6XAVWGDrNX21ng0lXO5H50m0+SheNBx5QCIGUM36Qi4e8Cdh+pYnrfPayIRh2GVsUR63UpYZIhqexnZ71QQM5FKWAF/18UvHHO5OsZ6AMGGBFxRftQQsKP8uCDepksW/QU6ydGlFuwnhB+1OePJ1XhxpMgNe4hh+ExyZyFwneR1fE2ToI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(26005)(5660300002)(2906002)(2616005)(107886003)(7416002)(83380400001)(36756003)(110136005)(6512007)(6666004)(31686004)(508600001)(8936002)(186003)(38100700002)(316002)(6506007)(4326008)(6486002)(66946007)(66476007)(8676002)(55236004)(31696002)(86362001)(54906003)(53546011)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tk5udE4vTHN1VzE4VDllUmVzRCtHZ2NtRTA4eXYwdmxzVnBvYkJ0dEF5TStL?=
 =?utf-8?B?RzN0N1g3MVp2YW9oVlUrRHFtSlBWZmM3ZXhENmdyWm5CREFYR3lnOGxHelpC?=
 =?utf-8?B?OFlIQnF4OWFNc1JBZE1KVE5xR1poL0swd2xsR0IwbG5tY1F2bDczNktBc2x1?=
 =?utf-8?B?WnNmMnpFMTVjQzBRbUEvYnJ1MzJyUmpycDRNZWJsVnJlZW5ZTlFEdTg2VTFp?=
 =?utf-8?B?MXdkYjBJQ3dkenhpNnpNeWs2U2pkN2M4QTFvWS9kNzExYStwM3ZacFpOWEh4?=
 =?utf-8?B?T1BIV2RrMDVHTGM1Ym9DdTBkOXFBQ0hvNzBhcTVOaWJZeXB5VmxFQ1NobThB?=
 =?utf-8?B?ZjVFNGdrU2l0ZG5rSThNa1lzODFVNWd3WUlqRFg4WXI4bnN6c1NtTzd5Nllo?=
 =?utf-8?B?aHpUYmFpOUpsK0dHbkRlMjZYRXNUMUd5cXpRcGM5YzFDRU9ZRE5vcGlUZTBk?=
 =?utf-8?B?VmMxWW9QK3dnWXNNZkhHUjIwVFo3SlduMjd4T1VJQjlGTkp2OTY1UUYxT0My?=
 =?utf-8?B?R0NGNGxEWC95Wmp4RnBmK0JZbVNBejZFZFFNUjVnbE1xUFlsdGQ5UGZHT0RI?=
 =?utf-8?B?bitEWERiVHpCbmU1eG0xc3piVFlxMEdwNTdDaU43WHdLN3JnVTNEU0h2L1Vm?=
 =?utf-8?B?M0pvZnMzbjh3bHQ2VjNRL0tYQktnOHd0eE9yZHlPYWhEMEp3ZE5CUU9GU0dW?=
 =?utf-8?B?Q3FhTDNtNkJhTnc5bU1OSmVpcTEwd3FFdlpHWWducFRBam9TVE9KRDJ0Nkd3?=
 =?utf-8?B?eTdoeTA0aFBSZm9LMWVpRzgzWHp5MDNJa0VGZHJBYmJCRFQxSFg5YjBQUUlO?=
 =?utf-8?B?QUxxVUcrQW1rU0ZHNzJHU204N0xGSzlocWVlTm4xMktzcU14UkZMc2RsTVJy?=
 =?utf-8?B?OXd0eVFhYnkrWlJhSFQzdjNNbVdwTWcyVEJBdWZXcmdYSWRsbU1JbFdCVWky?=
 =?utf-8?B?b1cyQUI5Vm1NbkNDWjR5QWoxamIxVW1XQWw3MUxmV3JSSFR5MnhJelRSV0NF?=
 =?utf-8?B?YzIyVTI4YllDZUJoR0ZBdFRaTEQ2WXhJMjhLbE5Zeml5eXVQY0NQdStGY0x2?=
 =?utf-8?B?SktaSXY5bkx6V1dKWFB5V0hDTHBHallkR05kMnMyQmthVHNQR0h0Y1dqSWg5?=
 =?utf-8?B?U21IN3dsanlKSDZTbmtGZjRkUGNmYXEzMmpKT3lwOU8renF2OW9mLzAvL1Bo?=
 =?utf-8?B?WXFCNFQ4cUQ0RjNhaXRLcmJxVXNyeVQ2VnZnN3ZheTM2dXdLS0ZQZUFFbThC?=
 =?utf-8?B?Ny9yckFXMHlkbXhLalFEcmhpU1V6RHhWVHQydmVLdkZyZTlKQXZiekc0dXlu?=
 =?utf-8?B?K2dqK0lMLzlJelR5Q01XUU1sTU1VazVCQTdFRE10NkswY1RPOTFVN05uWi9B?=
 =?utf-8?B?a1hUUkxnTDIrUkI1Ung5M1JibG03YS9pK29meTJVaVhQK3A1SDlJUXh1cjNw?=
 =?utf-8?B?dXFrTnpTZEFSc1pjdjRYeDNFUHdpeE5GV3p6Tis0Mk41YlppOWdwVWg0OTkx?=
 =?utf-8?B?L3ZJR2pKLzkxaHRzYWVEc0dLZGQ1dEhmbkRMaGV0OUdmNUVXd085NEEzeU03?=
 =?utf-8?B?b0NrYjMrQmpWNE0xbU85bnRwbHRzV1duRVF2K29kOEkzT0RkcW5aVzlTcFdL?=
 =?utf-8?B?Q09uNTZVR0NWUFZWMkRnZnZVTVpzRE16L21jY3J6YmIrRlFkd2UvZVlBaE5C?=
 =?utf-8?B?M3czTStvMWdlOHQ4R1ZBQlFINkJoL0YwRDlyUHZlbWgzVmlsQjQ3dzcreG1E?=
 =?utf-8?B?aWNkUDBtV2wxdEZSYVJrQnZWZkwyRTkvSUhBMVhHb01PNHRSZTlvOUh6TUxJ?=
 =?utf-8?B?ZUhiMWNXaE5zcWxKSmhNWXcyMkFuYW51bWRKVG43U0JteWMxN1N3WXVFTytF?=
 =?utf-8?B?NmRnSzY0eDllVENYM25SZjNVWDJTZjFuTXNlWmJESmFRbi9yQVF4azNVQ09v?=
 =?utf-8?B?REc5L3lCOXpYeThINDh6K2l1Z1pYMTNEZ1Rpd09sWkdrazJPRjF5M0RYQ2Fo?=
 =?utf-8?B?d3ZvNDNCalhrWWRLNUVsNkJxWjhLb0NyRVVqbWtTMk1NNVhnWmtiMk44SjR0?=
 =?utf-8?B?ekRnVHZLOWp0bk52WjM1U3NaTTJPWkZxZ3ZIM2E5SDMzaXRVa3dxcUZhd0oy?=
 =?utf-8?B?V1IwdVZ2ZVNlSHM4K2JUYXRQQXl6TUxIVUVDbS96dDdUaXJHVHV4UU9RVzJT?=
 =?utf-8?B?NXVHVEVmT2ZmZFVldmxRVWZVNVU0NUhsN0VmWEs4bld6RlRmQ0dsY3pPeUVX?=
 =?utf-8?B?R0gzb0JQL0JIeDAyRW03RmN6bGd2S29wNmw0VUh0N0p2TjU1MlcwcGRYNkJ4?=
 =?utf-8?B?ZlhyVWRMdThyNEdrVlZDN2FNRmNlMm42cHcxN0UxZWxFZnZOY01KZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb4176b-f7f7-40cb-d4a1-08da4f057015
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 19:30:00.3380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDBz+n8Hl2fA9erKBiXNiTGgEYEbAh/oYwAN5kl6qp1CRmwn2HakyUcJ5aT0VvFQ0QxTQazOd+iCH69mK6y9+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4696
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


>   /*
> - * mdev_register_device : Register a device
> + * mdev_register_parent: Register a device as parent for mdevs
> + * @parent: parent structure registered
>    * @dev: device structure representing parent device.
>    * @mdev_driver: Device driver to bind to the newly created mdev
>    *
> - * Add device to list of registered parent devices.
>    * Returns a negative value on error, otherwise 0.
>    */
> -int mdev_register_device(struct device *dev, struct mdev_driver *mdev_driver)
> +int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> +		struct mdev_driver *mdev_driver)
>   {
> -	int ret;
> -	struct mdev_parent *parent;
>   	char *env_string = "MDEV_STATE=registered";
>   	char *envp[] = { env_string, NULL };
> +	int ret;
>   
>   	/* check for mandatory ops */
>   	if (!mdev_driver->supported_type_groups)
>   		return -EINVAL;
>   
> -	dev = get_device(dev);
> -	if (!dev)
> -		return -EINVAL;
> -

Hold the reference for device here once rather than helding multiple 
times while adding sysfs for each mdev_types below. See more below

> -	mutex_lock(&parent_list_lock);
> -
> -	/* Check for duplicate */
> -	parent = __find_parent_device(dev);
> -	if (parent) {
> -		parent = NULL;
> -		ret = -EEXIST;
> -		goto add_dev_err;
> -	}
> -
> -	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> -	if (!parent) {
> -		ret = -ENOMEM;
> -		goto add_dev_err;
> -	}
> -
> -	kref_init(&parent->ref);
> +	memset(parent, 0, sizeof(*parent));
>   	init_rwsem(&parent->unreg_sem);
> -
>   	parent->dev = dev;
>   	parent->mdev_driver = mdev_driver;
>   
>   	if (!mdev_bus_compat_class) {
>   		mdev_bus_compat_class = class_compat_register("mdev_bus");
> -		if (!mdev_bus_compat_class) {
> -			ret = -ENOMEM;
> -			goto add_dev_err;
> -		}
> +		if (!mdev_bus_compat_class)
> +			return -ENOMEM;
>   	}
>   
>   	ret = parent_create_sysfs_files(parent);
>   	if (ret)
> -		goto add_dev_err;
> +		return ret;
>   
>   	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
>   	if (ret)
>   		dev_warn(dev, "Failed to create compatibility class link\n");
>   
> -	list_add(&parent->next, &parent_list);
> -	mutex_unlock(&parent_list_lock);
> -
>   	dev_info(dev, "MDEV: Registered\n");
>   	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> -
>   	return 0;
> -
> -add_dev_err:
> -	mutex_unlock(&parent_list_lock);
> -	if (parent)
> -		mdev_put_parent(parent);
> -	else
> -		put_device(dev);
> -	return ret;
>   }
> -EXPORT_SYMBOL(mdev_register_device);
> +EXPORT_SYMBOL(mdev_register_parent);
>   
>   /*
> - * mdev_unregister_device : Unregister a parent device
> - * @dev: device structure representing parent device.
> - *
> - * Remove device from list of registered parent devices. Give a chance to free
> - * existing mediated devices for given device.
> + * mdev_unregister_parent : Unregister a parent device
> + * @parent: parent structure to unregister
>    */
> -
> -void mdev_unregister_device(struct device *dev)
> +void mdev_unregister_parent(struct mdev_parent *parent)
>   {
> -	struct mdev_parent *parent;
>   	char *env_string = "MDEV_STATE=unregistered";
>   	char *envp[] = { env_string, NULL };
>   
> -	mutex_lock(&parent_list_lock);
> -	parent = __find_parent_device(dev);
> -
> -	if (!parent) {
> -		mutex_unlock(&parent_list_lock);
> -		return;
> -	}
> -	dev_info(dev, "MDEV: Unregistering\n");
> -
> -	list_del(&parent->next);
> -	mutex_unlock(&parent_list_lock);
> +	dev_info(parent->dev, "MDEV: Unregistering\n");
>   
>   	down_write(&parent->unreg_sem);
> -
> -	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> -
> -	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> -
> +	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
> +	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
>   	parent_remove_sysfs_files(parent);
>   	up_write(&parent->unreg_sem);
>   
> -	mdev_put_parent(parent);
> -
> -	/* We still have the caller's reference to use for the uevent */
> -	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> +	kobject_uevent_env(&parent->dev->kobj, KOBJ_CHANGE, envp);
>   }
> -EXPORT_SYMBOL(mdev_unregister_device);
> +EXPORT_SYMBOL(mdev_unregister_parent);
>   
>   static void mdev_device_release(struct device *dev)
>   {
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 7c9fc79f3d838..297f911fdc890 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -13,17 +13,6 @@
>   int  mdev_bus_register(void);
>   void mdev_bus_unregister(void);
>   
> -struct mdev_parent {
> -	struct device *dev;
> -	struct mdev_driver *mdev_driver;
> -	struct kref ref;
> -	struct list_head next;
> -	struct kset *mdev_types_kset;
> -	struct list_head type_list;
> -	/* Synchronize device creation/removal with parent unregistration */
> -	struct rw_semaphore unreg_sem;
> -};
> -
>   struct mdev_type {
>   	struct kobject kobj;
>   	struct kobject *devices_kobj;
> @@ -48,16 +37,4 @@ void mdev_remove_sysfs_files(struct mdev_device *mdev);
>   int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
>   int  mdev_device_remove(struct mdev_device *dev);
>   
> -void mdev_release_parent(struct kref *kref);
> -
> -static inline void mdev_get_parent(struct mdev_parent *parent)
> -{
> -	kref_get(&parent->ref);
> -}
> -
> -static inline void mdev_put_parent(struct mdev_parent *parent)
> -{
> -	kref_put(&parent->ref, mdev_release_parent);
> -}
> -
>   #endif /* MDEV_PRIVATE_H */
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 4bfbf49aaa66a..b71ffc5594870 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)
>   
>   	pr_debug("Releasing group %s\n", kobj->name);
>   	/* Pairs with the get in add_mdev_supported_type() */
> -	mdev_put_parent(type->parent);
> +	put_device(type->parent->dev);
>   	kfree(type);
>   }
>   
> @@ -110,7 +110,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   	type->kobj.kset = parent->mdev_types_kset;
>   	type->parent = parent;
>   	/* Pairs with the put in mdev_type_release() */
> -	mdev_get_parent(parent);
> +	get_device(parent->dev);
>   	type->type_group_id = type_group_id;
>

Here device reference is held and release multiple times for each 
mdev_type. It should be held once from mdev_register_parent() and 
released from mdev_unregister_parent().

Thanks,
Kirti
