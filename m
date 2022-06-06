Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067E153EE87
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 21:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiFFTXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 15:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiFFTXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 15:23:09 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2047.outbound.protection.outlook.com [40.107.100.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20622A43A;
        Mon,  6 Jun 2022 12:23:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guh9O6X7YyU3n3FrqKieoTjj/ne1azo+5yiaNX2dKlkXFCq0Sni9IoAmqJhyzS7u8gIL4TdDWDsIKF97LdNzqzEiyFmmQGz73ysB6WAFnwuXJRj04Yf0Ibuv8U5kJA1MVflBhVY7+oBtCZHQGD9ygNc9Z+wPU3rZOuwamsDBameJMKSSWZW0gpxhTH/6MXYJRu8RdDraGK0MV4g3QaSymE7IDWIBmednJU+iuxnrBkx/cBbav0+h7Iu1K/G0cEW6qh42KyF5fHJtyIZb/8fMuwIO1ADuxqFRCuD21aaxSTwMClPyaY8NNmaxEPkZQeTo5u8gQTGppZMide87RxF4Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WuehLuSIzv1IKiuH0dgMSz2OTTQZj0pl2HOVTxklgOk=;
 b=hd91MZdrmQ4xYjqS+6Nu2VB6JoCwg+aNDBoh1p770Cc8oKms9tRATeI0qYuxBQnSSVTYnHGo/FG13Q3MjVFbDsUO9Zrm+M2req2WUcKqXK3kcGT5bxSOhBk9x98u07OS+hsvxBEuVJbEMe7Mpj8aQCmyFSuvzxmjlGWD23ZiHBO7rGFclxpO5p05TB7OCSzIdnw22rtQ7IhRl8FJ5/sV56k2M66k0Akble8L9AhW6NYBbaCAFtx/Pz7EqUGKWVUq1NTDw36/cUVgqQkkpVqS42B8k7+ciYWik+WgI+EyZLcleMERKCy6QlvlXzf6yEOfpNgJ5RNX8qaeGkyzRUjDzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuehLuSIzv1IKiuH0dgMSz2OTTQZj0pl2HOVTxklgOk=;
 b=obpCcP1IFarClXX8IJ/52PbZR1O3NVVZA8ysnDnKlt4IPBnlLSqTIsn5adoguBUiRT0cZEhVickypxUR+CbNbPN8ioNoTKEcsUKQdoR8klrtSDI7hoA5mmFu56bvRdayPMLwJV22cFOpYUu5npIAb7+mYTII1LVM7FPd4PlnwBABOfk2LHn7gWHiKMU9xx1Qz0RIeR88/Jj33LfYVID/n1m08WnTAZ9YSIoeAc8zmbi3uFGR4ZyxGnJvliqpd6rj+Fp4FEadiUHncbgnwp9JcQKRscNILYJBJ50aoABWXN9PB2Ncxx05X00sg7HZOWkipUZdtGewjACV1esOOnx1Kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 19:23:03 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%6]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 19:23:03 +0000
Message-ID: <86df429e-9f01-7a91-c420-bb1130b4d343@nvidia.com>
Date:   Tue, 7 Jun 2022 00:52:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/8] vfio/mdev: simplify mdev_type handling
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
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-4-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220603063328.3715-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::8) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78b52d75-0c08-47e8-5296-08da47f1f9e9
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2381D74C04FBA1DA91828CE4DCA29@SN1PR12MB2381.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZORSSzi/aOA5tTEjzqIey39Rw+dJZL00WHUU/uReUoL//lVHqyWH4ZZC6p217HuIEoiddaDFw3MRU2jIDr+VLAxenY87HH5IWRUcU3ucu+RDTMT9n62pb+DCgRm/wkJzUPjoL1erGsjb1/aMJwP2veP9lOvFmg81E/mo6T/airjaOdsyrEwDcvFn8OtNOh1jNmUhpaiZ8MCH3WhO3GDnr+y/yYexhiL30SCml8LltglLaawdG0Fb9Kik4Wcnw4FUKJ+2GeK0ZNzxP037C/G/egk6bIICQty8j9Q/9TpUX2iHe2kel28wND4r9B9yO/XtbHH2yZyS8HPVwE2k4LsgmSO2r2kbr9tOy6DWfIR4LhiqE91FvUH7y1iXK1XrWf2pD6BYQqvVnO3i1Ul+yhmAWZJxA3POljNSen1Ma+2HnY33xKXMBOSoD2jHO8rlONsVfL3JpbBrLyd7zjzhkF0bkfh0R1Egwwz5Z9JcWBq2P5dBGonQ04eyc+q1ZBnPp9ijIcU7sX1LzQqmPNmyiFpgV5wHDHt+eDh4iEIEUX2/k973UwA/ykBQnGp6EfpF9vz1lUe8vxTtVqCSTzmwuMXPz8wok50TF2/ejMTuB52RBBtLCRXb2QqfdfvkC4m0DAlKKrhGQbh1ZyKiWkPpsOMBpEHIbjPph3kRVCAqMEx84DSpeJPjD3KkhyPKZdbMvqpUn0OStSk8rQcohAlLxln1ILvvBGk+xjkidgxBRA9/bY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(38100700002)(316002)(6666004)(26005)(8676002)(2616005)(107886003)(7416002)(5660300002)(31696002)(86362001)(55236004)(4326008)(186003)(8936002)(6512007)(66476007)(66946007)(66556008)(6486002)(83380400001)(30864003)(2906002)(31686004)(54906003)(36756003)(110136005)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVhHVjdyQ0d2b1RSWjZkOG1NVXRLZWtINGwyeGs0VnF1UmcyOHR1WlFPSWNa?=
 =?utf-8?B?ZGg0RzE2cGFoaFo2VFZTZ0hGc1JLSGN6ODlQdDhsa3BLWG1NNG80TDl0bDhv?=
 =?utf-8?B?TVl1VmdrNzFnajhnWWtZdGJuWVEybXYrRTZOaFNLNjNZL1FqMHJVU3AwNkxw?=
 =?utf-8?B?Tm9kekVOWUJKTk9zc241NDF0MExPdnJRdWlnMUZESS9hMitaLzNIR2Y3K01X?=
 =?utf-8?B?UDdLb2JaYk5pMEFSdnQxbDdYdHhwVmtuUkx2OTZZcEZ3NW1EQ0hqREI3cFQr?=
 =?utf-8?B?TmNWSndJL1I1RmduQ1R1Z1pteU4yZTZXSXJXNkFSbk9oN0xkYUYzeStHQU5i?=
 =?utf-8?B?QVRlN3MvMmJKT0grQXlnNndqcm4xUERFb1FPbjgxSmoraHRZUFlZeWNWbUFK?=
 =?utf-8?B?TCtVMFEzeFh1bnJic3VjMHp0VnA4clh4QTdCaVlvVFprWFBEenk0YWUySnE3?=
 =?utf-8?B?N0lNTzB0dTBtRnBMaTVXVFo0K3Y5M2hiQ2IxZEZQSFQyTmRtdDFOTm9pcGxj?=
 =?utf-8?B?WGZmSERLbGN5WVZZTTBJQm1zSi95WFh3bitjRktmUE9QaWUxbnNMNVEzRHFm?=
 =?utf-8?B?cml1RE1pWTIwL3BJTTRiRVBnVjdoNGY0d2JKbEhGSEtRRGR3bTlVcEZGSFpM?=
 =?utf-8?B?MGxKTE9oUi96dGNQY3RWNlVoZ1M3UGxGdTdEa2pHdldiS0NWN2NoUDBKWjRa?=
 =?utf-8?B?YmRoWHBOOVV0YUVLWVgwUTZWd0NXVlk2YzR1T1FydDdwSk9wZlMyaFcrM0NV?=
 =?utf-8?B?VEVVL1pyWGNrYURiazhISk50TEQ4OTBNQU9QemlRVWdTM2E0U0w4VXpZZFBh?=
 =?utf-8?B?dHA5Tk9PRHdwUDM3NG96c0JCKzZpa0h0UlVHNEQ5M2ZnZ0piWVlCL3I4N3JQ?=
 =?utf-8?B?MHo4MGpYQloyTjBGbjF4eFRFMGhRajVjZGxoa3Z1Y3dGeWZCMFg3UFpKMndk?=
 =?utf-8?B?d08waU56QkNaSFhld3pYallPWVl0ZEJWNnBXTmdnaVdHSzBmKy90S1puOFNm?=
 =?utf-8?B?WjNzbVV6WGJrVGl5LzBjMU9yM2tZNkNVeDB4Q0lVTkpjYit2OGJRcVN2MGVX?=
 =?utf-8?B?VjlBZjdyVlNmd3lpWTdFNS9VSS9mVVRqRVNTNXgzcE8wSGtnUGliNWVzOEdh?=
 =?utf-8?B?cjhYcHR1NXNGR2V2QVZIbkR6VTM1a2ZmNXhCR1J1ZWlwK1hJNGNBV3VCa1RG?=
 =?utf-8?B?bnV6SkoxcHdVa0VhUXpFVDhWdm1PK2U4dVVzMGVRWEFZeXhsYUV2MUgrR0JX?=
 =?utf-8?B?RDhRYzB0RnNFM0NFOURiU2w0Q3dWYjJVaUpHa2hib0FDN05ydGROeWJpMW9O?=
 =?utf-8?B?djdnamdRL1BqYU1jd1R3UEZrczFzdWNhdlNjTHo1RnE4a3dDejF5bW1KVnNh?=
 =?utf-8?B?bDdDWGsyRFZPeUw5VHdvYWNJaWlPTmN2dUl0eEN3SnBNTUlXSVdTRnZwa29m?=
 =?utf-8?B?MnJHOUtMNXJLb1JWZnBqMG9PdzR5RGFKNmxjR2VONXNOcnFKRmxVdGI1cHdz?=
 =?utf-8?B?TDkzTC9mbGhYb24wdFBFc1BPWHpKMjNlVWU1Z1hjN0VvNXVEYnF6angzeit6?=
 =?utf-8?B?UWptMXJSODB3WUJqNHNmcGRidXdpaDhuelVSdmFkSjF5VHJya0tTa2FHV2lY?=
 =?utf-8?B?K3FXaEFvMlJHemZJTjVMSVMzT2RQczErbzd6UWk4ZnQ4UTQrOXliTlBJdS92?=
 =?utf-8?B?U2VhUjdKbjBFR251dFA5ZStlTHZib2hsNTF3c2ZRRzkzN29oTWQ2aWFZMXo3?=
 =?utf-8?B?RWI3dmo3elovMGxoeEU4V21jWWZkY1dXWlhaUlJlZXdZMWNQeGhJTkZCZkhw?=
 =?utf-8?B?R2RWMHd0K0hBcVJWSDRMT3JOWHlYZWhwRmRKSEZMMDRQeGxTZ0ZqRWxTeFph?=
 =?utf-8?B?Qi9HVkUyeFpIVmg2TjFGVzBIVnFJSlZxNVdDZjRnNVlqY0w0cFJyd2NIeENm?=
 =?utf-8?B?MUdJdkt4UlYwYVg4YmFwdjIvMWprWXI3YXBBMVpCZk9Zckpta0pvNW5iYXBJ?=
 =?utf-8?B?c2ppUlc0VjczUndaMFFsNWRFdjFHUDFwS3JHSnZqVEthTlpCUFlkY2ViZFFy?=
 =?utf-8?B?TjdVU05ndmVWbTZLa2VLdnNNUWhzVWd1ckR5TElONlBGampRYTlWamxIb25u?=
 =?utf-8?B?TXFBTGpNYloya0srK0xjRGtZTm1oQ3NtMzViWVlyakVvbVZZWHErRHJkdGg2?=
 =?utf-8?B?OURRem5acGMxN1VSdWhIZ0V3aFAwdHZPWUk5WENpTGNlZkNOK0tVVTc2U0RX?=
 =?utf-8?B?aDd2eHBkN0F5U3I5RDFJcE1lZmFoTDlHMW5wbUQwNjNQK2Jqb0JtbTNXaGF6?=
 =?utf-8?B?dnlOVUNBMmlKdFNpUXhwTWxhQmZrMjBXREtEVm9yeVpEUWVYTjNhUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b52d75-0c08-47e8-5296-08da47f1f9e9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 19:23:03.3095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YS/UKygOA2FvK7LF+KNppXo0nc8Oiez1E078oqlhhJ/OMHW/lGzaio2cRgJuXiaGLru9PzneOsHJc8j5va/Q4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2381
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

<snip...>

>   static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
>   			    const char *buf, size_t count)
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 327ce3e5c6b5f..cbb53dcd20d9d 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -23,12 +23,17 @@ struct mdev_device {
>   	bool active;
>   };
>   
> +struct mdev_type {
> +	struct kobject kobj;
> +	struct kobject *devices_kobj;
> +	struct mdev_parent *parent;
> +};
> +
>   /* embedded into the struct device that the mdev devices hang off */
>   struct mdev_parent {
>   	struct device *dev;
>   	struct mdev_driver *mdev_driver;
>   	struct kset *mdev_types_kset;
> -	struct list_head type_list;
>   	/* Synchronize device creation/removal with parent unregistration */
>   	struct rw_semaphore unreg_sem;
>   };
> @@ -38,8 +43,11 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
>   	return container_of(dev, struct mdev_device, dev);
>   }
>   
> -unsigned int mdev_get_type_group_id(struct mdev_device *mdev);
> -unsigned int mtype_get_type_group_id(struct mdev_type *mtype);
> +int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type,
> +		const char *name, const struct attribute * const *attrs);
> +void mdev_type_remove(struct mdev_type *type,
> +		const struct attribute * const *attrs);
> +
>   struct device *mtype_get_parent_dev(struct mdev_type *mtype);
>   
>   /* interface for exporting mdev supported type attributes */
> @@ -66,15 +74,12 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
>    * struct mdev_driver - Mediated device driver
>    * @probe: called when new device created
>    * @remove: called when device removed
> - * @supported_type_groups: Attributes to define supported types. It is mandatory
> - *			to provide supported types.
>    * @driver: device driver structure
>    *
>    **/
>   struct mdev_driver {
>   	int (*probe)(struct mdev_device *dev);
>   	void (*remove)(struct mdev_device *dev);
> -	struct attribute_group **supported_type_groups;
>   	struct device_driver driver;
>   };

mdev_type should be part of mdev_parent, separating it from mdev_parent 
could result in more errors while using mdev framework. Similarly it 
should be added as part of mdev_register_device. Below adding types is 
separated from mdev_register_device which is more error prone. What if 
driver registering to mdev doesn't add mdev_types? - mdev framework is 
un-usable in that case. We had kept it together with mdev registration 
so that mdev_types should be mandatory to be defined by driver during 
registration. How would you mandate mdev_type by such separation?

Thanks,
Kirti


>   
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index f0967a81eabe7..32fd6f385fafd 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -100,23 +100,28 @@ MODULE_PARM_DESC(mem, "megabytes available to " MBOCHS_NAME " devices");
>   #define MBOCHS_TYPE_2 "medium"
>   #define MBOCHS_TYPE_3 "large"
>   
> -static const struct mbochs_type {
> +static struct mbochs_type {
> +	struct mdev_type type;
> +	const char *fname;
>   	const char *name;
>   	u32 mbytes;
>   	u32 max_x;
>   	u32 max_y;
>   } mbochs_types[] = {
>   	{
> +		.fname	= MBOCHS_TYPE_1,
>   		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
>   		.mbytes = 4,
>   		.max_x  = 800,
>   		.max_y  = 600,
>   	}, {
> +		.fname	= MBOCHS_TYPE_2,
>   		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
>   		.mbytes = 16,
>   		.max_x  = 1920,
>   		.max_y  = 1440,
>   	}, {
> +		.fname	= MBOCHS_TYPE_3,
>   		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
>   		.mbytes = 64,
>   		.max_x  = 0,
> @@ -509,8 +514,8 @@ static int mbochs_reset(struct mdev_state *mdev_state)
>   static int mbochs_probe(struct mdev_device *mdev)
>   {
>   	int avail_mbytes = atomic_read(&mbochs_avail_mbytes);
> -	const struct mbochs_type *type =
> -		&mbochs_types[mdev_get_type_group_id(mdev)];
> +	struct mbochs_type *type =
> +		container_of(mdev->type, struct mbochs_type, type);
>   	struct device *dev = mdev_dev(mdev);
>   	struct mdev_state *mdev_state;
>   	int ret = -ENOMEM;
> @@ -1329,8 +1334,8 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   static ssize_t name_show(struct mdev_type *mtype,
>   			 struct mdev_type_attribute *attr, char *buf)
>   {
> -	const struct mbochs_type *type =
> -		&mbochs_types[mtype_get_type_group_id(mtype)];
> +	struct mbochs_type *type =
> +		container_of(mtype, struct mbochs_type, type);
>   
>   	return sprintf(buf, "%s\n", type->name);
>   }
> @@ -1339,8 +1344,8 @@ static MDEV_TYPE_ATTR_RO(name);
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> -	const struct mbochs_type *type =
> -		&mbochs_types[mtype_get_type_group_id(mtype)];
> +	struct mbochs_type *type =
> +		container_of(mtype, struct mbochs_type, type);
>   
>   	return sprintf(buf, "virtual display, %d MB video memory\n",
>   		       type ? type->mbytes  : 0);
> @@ -1351,8 +1356,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
>   {
> -	const struct mbochs_type *type =
> -		&mbochs_types[mtype_get_type_group_id(mtype)];
> +	struct mbochs_type *type =
> +		container_of(mtype, struct mbochs_type, type);
>   	int count = atomic_read(&mbochs_avail_mbytes) / type->mbytes;
>   
>   	return sprintf(buf, "%d\n", count);
> @@ -1366,7 +1371,7 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(device_api);
>   
> -static struct attribute *mdev_types_attrs[] = {
> +static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_device_api.attr,
> @@ -1374,28 +1379,6 @@ static struct attribute *mdev_types_attrs[] = {
>   	NULL,
>   };
>   
> -static struct attribute_group mdev_type_group1 = {
> -	.name  = MBOCHS_TYPE_1,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group2 = {
> -	.name  = MBOCHS_TYPE_2,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group3 = {
> -	.name  = MBOCHS_TYPE_3,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group *mdev_type_groups[] = {
> -	&mdev_type_group1,
> -	&mdev_type_group2,
> -	&mdev_type_group3,
> -	NULL,
> -};
> -
>   static const struct vfio_device_ops mbochs_dev_ops = {
>   	.close_device = mbochs_close_device,
>   	.read = mbochs_read,
> @@ -1413,7 +1396,6 @@ static struct mdev_driver mbochs_driver = {
>   	},
>   	.probe = mbochs_probe,
>   	.remove	= mbochs_remove,
> -	.supported_type_groups = mdev_type_groups,
>   };
>   
>   static const struct file_operations vd_fops = {
> @@ -1427,7 +1409,7 @@ static void mbochs_device_release(struct device *dev)
>   
>   static int __init mbochs_dev_init(void)
>   {
> -	int ret = 0;
> +	int i, ret = 0;
>   
>   	atomic_set(&mbochs_avail_mbytes, max_mbytes);
>   
> @@ -1461,9 +1443,19 @@ static int __init mbochs_dev_init(void)
>   	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver);
>   	if (ret)
>   		goto err_device;
> +	for (i = 0; i < ARRAY_SIZE(mbochs_types); i++) {
> +		ret = mdev_type_add(&mbochs_parent, &mbochs_types[i].type,
> +				    mbochs_types[i].fname, mdev_types_attrs);
> +		if (ret)
> +			goto err_types;
> +	}
>   
>   	return 0;
>   
> +err_types:
> +	while (--i >= 0)
> +		mdev_type_remove(&mbochs_types[i].type, mdev_types_attrs);
> +	mdev_unregister_parent(&mbochs_parent);
>   err_device:
>   	device_unregister(&mbochs_dev);
>   err_class:
> @@ -1478,7 +1470,11 @@ static int __init mbochs_dev_init(void)
>   
>   static void __exit mbochs_dev_exit(void)
>   {
> +	int i;
> +
>   	mbochs_dev.bus = NULL;
> +	for (i = 0; i < ARRAY_SIZE(mbochs_types); i++)
> +		mdev_type_remove(&mbochs_types[i].type, mdev_types_attrs);
>   	mdev_unregister_parent(&mbochs_parent);
>   
>   	device_unregister(&mbochs_dev);
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 8ab88a1d149cb..a6aa7f6f97095 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -52,7 +52,9 @@ MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
>   #define MDPY_TYPE_2 "xga"
>   #define MDPY_TYPE_3 "hd"
>   
> -static const struct mdpy_type {
> +static struct mdpy_type {
> +	struct mdev_type type;
> +	const char *fname;
>   	const char *name;
>   	u32 format;
>   	u32 bytepp;
> @@ -60,18 +62,21 @@ static const struct mdpy_type {
>   	u32 height;
>   } mdpy_types[] = {
>   	{
> +		.fname 	= MDPY_TYPE_1,
>   		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 640,
>   		.height = 480,
>   	}, {
> +		.fname 	= MDPY_TYPE_2,
>   		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 1024,
>   		.height = 768,
>   	}, {
> +		.fname 	= MDPY_TYPE_3,
>   		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
> @@ -220,7 +225,7 @@ static int mdpy_reset(struct mdev_state *mdev_state)
>   static int mdpy_probe(struct mdev_device *mdev)
>   {
>   	const struct mdpy_type *type =
> -		&mdpy_types[mdev_get_type_group_id(mdev)];
> +		container_of(mdev->type, struct mdpy_type, type);
>   	struct device *dev = mdev_dev(mdev);
>   	struct mdev_state *mdev_state;
>   	u32 fbsize;
> @@ -645,8 +650,7 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   static ssize_t name_show(struct mdev_type *mtype,
>   			 struct mdev_type_attribute *attr, char *buf)
>   {
> -	const struct mdpy_type *type =
> -		&mdpy_types[mtype_get_type_group_id(mtype)];
> +	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
>   
>   	return sprintf(buf, "%s\n", type->name);
>   }
> @@ -655,8 +659,7 @@ static MDEV_TYPE_ATTR_RO(name);
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> -	const struct mdpy_type *type =
> -		&mdpy_types[mtype_get_type_group_id(mtype)];
> +	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
>   
>   	return sprintf(buf, "virtual display, %dx%d framebuffer\n",
>   		       type->width, type->height);
> @@ -678,7 +681,7 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(device_api);
>   
> -static struct attribute *mdev_types_attrs[] = {
> +static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_device_api.attr,
> @@ -686,28 +689,6 @@ static struct attribute *mdev_types_attrs[] = {
>   	NULL,
>   };
>   
> -static struct attribute_group mdev_type_group1 = {
> -	.name  = MDPY_TYPE_1,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group2 = {
> -	.name  = MDPY_TYPE_2,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group3 = {
> -	.name  = MDPY_TYPE_3,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group *mdev_type_groups[] = {
> -	&mdev_type_group1,
> -	&mdev_type_group2,
> -	&mdev_type_group3,
> -	NULL,
> -};
> -
>   static const struct vfio_device_ops mdpy_dev_ops = {
>   	.read = mdpy_read,
>   	.write = mdpy_write,
> @@ -724,7 +705,6 @@ static struct mdev_driver mdpy_driver = {
>   	},
>   	.probe = mdpy_probe,
>   	.remove	= mdpy_remove,
> -	.supported_type_groups = mdev_type_groups,
>   };
>   
>   static const struct file_operations vd_fops = {
> @@ -738,7 +718,7 @@ static void mdpy_device_release(struct device *dev)
>   
>   static int __init mdpy_dev_init(void)
>   {
> -	int ret = 0;
> +	int i, ret = 0;
>   
>   	ret = alloc_chrdev_region(&mdpy_devt, 0, MINORMASK + 1, MDPY_NAME);
>   	if (ret < 0) {
> @@ -770,9 +750,19 @@ static int __init mdpy_dev_init(void)
>   	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver);
>   	if (ret)
>   		goto err_device;
> +	for (i = 0; i < ARRAY_SIZE(mdpy_types); i++) {
> +		ret = mdev_type_add(&mdpy_parent, &mdpy_types[i].type,
> +				    mdpy_types[i].fname, mdev_types_attrs);
> +		if (ret)
> +			goto err_types;
> +	}
>   
>   	return 0;
>   
> +err_types:
> +	while (--i >= 0)
> +		mdev_type_remove(&mdpy_types[i].type, mdev_types_attrs);
> +	mdev_unregister_parent(&mdpy_parent);
>   err_device:
>   	device_unregister(&mdpy_dev);
>   err_class:
> @@ -787,7 +777,11 @@ static int __init mdpy_dev_init(void)
>   
>   static void __exit mdpy_dev_exit(void)
>   {
> +	int i;
> +
>   	mdpy_dev.bus = NULL;
> +	for (i = 0; i < ARRAY_SIZE(mdpy_types); i++)
> +		mdev_type_remove(&mdpy_types[i].type, mdev_types_attrs);
>   	mdev_unregister_parent(&mdpy_parent);
>   
>   	device_unregister(&mdpy_dev);
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 20136def93fdb..28c0811cf2312 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -145,6 +145,16 @@ struct mdev_state {
>   	int nr_ports;
>   };
>   
> +static struct mtty_type {
> +	struct mdev_type type;
> +	int nr_ports;
> +	const char *fname;
> +	const char *name;
> +} mtty_types[2] = {
> +	{ .nr_ports = 1, .fname = "1", .name = "Single port serial" },
> +	{ .nr_ports = 2, .fname = "2", .name = "Dual port serial" },
> +};
> +
>   static atomic_t mdev_avail_ports = ATOMIC_INIT(MAX_MTTYS);
>   
>   static const struct file_operations vd_fops = {
> @@ -706,16 +716,18 @@ static ssize_t mdev_access(struct mdev_state *mdev_state, u8 *buf, size_t count,
>   
>   static int mtty_probe(struct mdev_device *mdev)
>   {
> +	struct mtty_type *type =
> +		container_of(mdev->type, struct mtty_type, type);
>   	struct mdev_state *mdev_state;
> -	int nr_ports = mdev_get_type_group_id(mdev) + 1;
>   	int avail_ports = atomic_read(&mdev_avail_ports);
>   	int ret;
>   
>   	do {
> -		if (avail_ports < nr_ports)
> +		if (avail_ports < type->nr_ports)
>   			return -ENOSPC;
>   	} while (!atomic_try_cmpxchg(&mdev_avail_ports,
> -				     &avail_ports, avail_ports - nr_ports));
> +				     &avail_ports,
> +				     avail_ports - type->nr_ports));
>   
>   	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
>   	if (mdev_state == NULL) {
> @@ -725,13 +737,13 @@ static int mtty_probe(struct mdev_device *mdev)
>   
>   	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
>   
> -	mdev_state->nr_ports = nr_ports;
> +	mdev_state->nr_ports = type->nr_ports;
>   	mdev_state->irq_index = -1;
>   	mdev_state->s[0].max_fifo_size = MAX_FIFO_SIZE;
>   	mdev_state->s[1].max_fifo_size = MAX_FIFO_SIZE;
>   	mutex_init(&mdev_state->rxtx_lock);
> -	mdev_state->vconfig = kzalloc(MTTY_CONFIG_SPACE_SIZE, GFP_KERNEL);
>   
> +	mdev_state->vconfig = kzalloc(MTTY_CONFIG_SPACE_SIZE, GFP_KERNEL);
>   	if (mdev_state->vconfig == NULL) {
>   		ret = -ENOMEM;
>   		goto err_state;
> @@ -754,7 +766,7 @@ static int mtty_probe(struct mdev_device *mdev)
>   	vfio_uninit_group_dev(&mdev_state->vdev);
>   	kfree(mdev_state);
>   err_nr_ports:
> -	atomic_add(nr_ports, &mdev_avail_ports);
> +	atomic_add(type->nr_ports, &mdev_avail_ports);
>   	return ret;
>   }
>   
> @@ -1235,11 +1247,9 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   static ssize_t name_show(struct mdev_type *mtype,
>   			 struct mdev_type_attribute *attr, char *buf)
>   {
> -	static const char *name_str[2] = { "Single port serial",
> -					   "Dual port serial" };
> +	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
>   
> -	return sysfs_emit(buf, "%s\n",
> -			  name_str[mtype_get_type_group_id(mtype)]);
> +	return sysfs_emit(buf, "%s\n", type->name);
>   }
>   
>   static MDEV_TYPE_ATTR_RO(name);
> @@ -1248,9 +1258,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
>   {
> -	unsigned int ports = mtype_get_type_group_id(mtype) + 1;
> +	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
>   
> -	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) / ports);
> +	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) /
> +			type->nr_ports);
>   }
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
> @@ -1263,29 +1274,13 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(device_api);
>   
> -static struct attribute *mdev_types_attrs[] = {
> +static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
>   
> -static struct attribute_group mdev_type_group1 = {
> -	.name  = "1",
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group2 = {
> -	.name  = "2",
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group *mdev_type_groups[] = {
> -	&mdev_type_group1,
> -	&mdev_type_group2,
> -	NULL,
> -};
> -
>   static const struct vfio_device_ops mtty_dev_ops = {
>   	.name = "vfio-mtty",
>   	.read = mtty_read,
> @@ -1302,7 +1297,6 @@ static struct mdev_driver mtty_driver = {
>   	},
>   	.probe = mtty_probe,
>   	.remove	= mtty_remove,
> -	.supported_type_groups = mdev_type_groups,
>   };
>   
>   static void mtty_device_release(struct device *dev)
> @@ -1312,7 +1306,7 @@ static void mtty_device_release(struct device *dev)
>   
>   static int __init mtty_dev_init(void)
>   {
> -	int ret = 0;
> +	int i, ret = 0;
>   
>   	pr_info("mtty_dev: %s\n", __func__);
>   
> @@ -1357,8 +1351,19 @@ static int __init mtty_dev_init(void)
>   				   &mtty_driver);
>   	if (ret)
>   		goto err_device;
> +	for (i = 0; i < ARRAY_SIZE(mtty_types); i++) {
> +		ret = mdev_type_add(&mtty_dev.parent, &mtty_types[i].type,
> +				    mtty_types[i].fname, mdev_types_attrs);
> +		if (ret)
> +			goto err_types;
> +	}
> +
>   	return 0;
>   
> +err_types:
> +	while (--i >= 0)
> +		mdev_type_remove(&mtty_types[i].type, mdev_types_attrs);
> +	mdev_unregister_parent(&mtty_dev.parent);
>   err_device:
>   	device_unregister(&mtty_dev.dev);
>   err_class:
> @@ -1373,7 +1378,11 @@ static int __init mtty_dev_init(void)
>   
>   static void __exit mtty_dev_exit(void)
>   {
> +	int i;
> +
>   	mtty_dev.dev.bus = NULL;
> +	for (i = 0; i < ARRAY_SIZE(mtty_types); i++)
> +		mdev_type_remove(&mtty_types[i].type, mdev_types_attrs);
>   	mdev_unregister_parent(&mtty_dev.parent);
>   
>   	device_unregister(&mtty_dev.dev);
