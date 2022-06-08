Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BC6543AF1
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiFHR7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiFHR6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:58:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF93614FCB6;
        Wed,  8 Jun 2022 10:58:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgafVyofv3CgiS8DS+JEJ4pYwZidIN7ufu1UAuj3LjlkGh03KaUiO7h/M8b0MguLrpi8GNSA68sIj3meWf2BFz5gGp8qOgmCerO+pfu/oPuyGzXdOQLZNgY8fQtihFD5Jpjq9FOwPgA52IN8gkENP94d+kjuZjBFmCZ7h9eAvOqOi0/fV9OF0EymlwqrbMhtiw9axjfsCvw9rGHpHqGMoog8kMlQN5RphH/dkAuNfFwRs4vwgjaJsIUcLmcPQcIzjtpFQTPbfmWf+Bw9zI6i0QmNW/gQyxqs4AMvJtMNqPRlxD/gnQm9ib6Bhbw2pRTANJJ0uj06h6OTvAbdxgnCwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glibp1SlGH0y/e55Og2TLbDjDMepfg2RwqR+pigfeSI=;
 b=cYejzqe8WztV/s3kvIX8HHJKByFXeeyuXkMYeXuJpo/EebMTEtSVsoyktCuf7AzQXCqZyZRwh3/lv/aFhLXxRYApM51IXR376+VTBlCZPsTeLTizGTafX8PJA9s3PNXKL5ZgppCRAXIQ45Ys9/eDsYxh5W6ry0eK+sgjXAIoZEdBvYTo1fjxtZOz+uWagkT4zmMUmBnvQeFBYWuZD3Z5iC3bV0j4apy4wSQymc8mbKXrNcAF4Y1xBk/jn7QPG7AAXdrK3MA2mTj2WLaEzvIx0QMv7rSp8Yh89ZRLIVQhvGD1mekpc5bNl2kAISnoekbX08ufWI73PODI5feJLehZ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glibp1SlGH0y/e55Og2TLbDjDMepfg2RwqR+pigfeSI=;
 b=DG8oQZKJxav21xso0LEBcowGfLviKzypwh1PqoGrknI0EyTFF7/gjpGqOnRDt6vW1ExVSrts7x1e0mTRIGYGtqeHRd2Nju3UwPXq7Pyq3LPs5tVJwZJCDeQDsQdCVwR2VB0+/oKyzGO1JycWmysBoOS17eF5J7+HQsGgrga8m+61yjfAEhsFBUrTHY2eOLPgdAvY1LrNroc48UKkN2kiAC1dFoxCK46JhlFD51kcQJBH0hLVSSXKaaoXJqhe6jtsCwn5fyJiM93E6AEEnopH7RDxUr7GFh0mRiKPcyFAmVD6pJNkWA5j/g1pqGpnyrocHRi0gUA9Yj3GE4D1nP0sPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 17:58:27 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.013; Wed, 8 Jun 2022
 17:58:27 +0000
Message-ID: <a542c244-a793-7889-db9f-610cf525e3b6@nvidia.com>
Date:   Wed, 8 Jun 2022 23:27:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/8] vfio/mdev: simplify mdev_type handling
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-4-hch@lst.de>
 <86df429e-9f01-7a91-c420-bb1130b4d343@nvidia.com>
 <20220607055050.GB8680@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220607055050.GB8680@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::20) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 169afd4c-bb88-41ef-3c73-08da49787ce0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB18832F2854DE91858892C6C8DCA49@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KKyCtb6fAJj7T2H5pzEajtu4aqGQ+W3pc6C/pg7Wja8BukS0TnbMr8Bg/u13s4sb8ch2g1oY7CjAgsCj+C84My9/Poi44mACluiMt36WxW3w3O5KKNTnnfkZKawanWIcJyj5AReHDZq2Zg4Ia4d8fj4qpuuaf4gw9tWmp0borqJakFn1NgHHZLk9mF4C8xFRS45TWBnkNksl6ThE3oNXicWK0T4Is4Xpn6mOQ8DTr/wfQlEMxCpMg0Xle0AFL6TGWBvojW/6aOqBljvFiVfbTcKhTkgd+pCCPJZ56qeAf1zSzXfPgIfAmUM9LbQ//7hYqYgwoXuLrK1tFQJ22yBZvZ1S0JtAHPoay9FdNLf1YIZHgKeVY3YN14+wmcJ9Dg9RkU4iACfGU+m/D90YzwRo6YLwWmO+8gMRIwTtW143b8ooL0aQp4OdERJxGCZ/orsjrWzJ45sa8PpIbP0XuhGPUxasP8hXPm5tKFcKM83k4UKXd1lHJmGgErSkWhHtZqF5KkoZcEA4q8sRaJr/oOG5RPiVEfM05ieeX4S62JTVQGaZEMsNau8CSZQN1ZNSXkmtxk13LjU9XH3l2Xp5nql4LncE2L23lWjz30FLsH9PFJi3nNMRTIZXH0nfF8N0Vr4/hX18SB4tqlNTRz/StTNzaubfQXdnmMOG61WDK+zzPOT+6K1OHEbew6Pg27yDmCz6yWrD4TlMkw1K2uiyLKO8EWnag5BHUvqLhhzc/egEvKE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(186003)(8936002)(5660300002)(54906003)(6916009)(66946007)(31686004)(8676002)(66556008)(66476007)(4326008)(508600001)(6486002)(316002)(7416002)(6666004)(6506007)(31696002)(36756003)(55236004)(53546011)(26005)(107886003)(2616005)(86362001)(2906002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NG9HWG0xbGI4ckkwbzhiMjBWQWdZeXp6V29hS1VWMUVpbUdWc1lKckQ0aGVL?=
 =?utf-8?B?REp5VGtyN2dYUnFaVnJwVEh0UytnWS9BM2cvWmU5cUtTUE1PdFNHSEh1Q3Fu?=
 =?utf-8?B?WnVQdXk0enhkenpmOFBBaGVpTFVyVHBnUHo1R25rbUJyTEd6bDZHaVpkTFl2?=
 =?utf-8?B?U1BwQm1IblQrVXo5U05YQ2Z5RTlIdm56ZjRESmtyRE9PTW9sMGlVbm43V0sy?=
 =?utf-8?B?S0FqYmhVbmE4V0EyeWNpSkp6MlJRRUp1R2ZIWWF4MFlERDFGcDJmUkprZDg3?=
 =?utf-8?B?VzhqSktBTzRQbVlUOEp1R1NxQnJ2WHJDSGVxZFFHSVJ3UHlYc05oZTJ0OHZp?=
 =?utf-8?B?SERZUmMvMzBlajYyVGVFNXgyaWhCU25lMngxbmhDL2EySXh3NldkcWVpcGNo?=
 =?utf-8?B?UEtmTkdTNFFHQ0tpNmtpNzd4UERGZEVSK2dOOGpMc1hlRXdHeDZWdTQrdzJH?=
 =?utf-8?B?ZUQ0WDRzRVVOZjQrSjdJcVk0WVh4cVcvN1d4QUVZb3ZETXQ4bzNCZk5lbEFz?=
 =?utf-8?B?dUVwZmQ1YmU3OGFDWEhTM2wwZEl6YjhxVUxadk5TUDN3MnBHZnNqaUU5S3ZH?=
 =?utf-8?B?MTMzMTZObkwzaUxWblJUaThuajRBa0Faa0JYVTZ1bzBGemREcExWRS9hOU1j?=
 =?utf-8?B?d0dGaEY5SDlGN25SZ3JHcFhEKzJlKzFiQ2JPK3QvbkhMeDhQVHd1S0JObEJk?=
 =?utf-8?B?L0JNOHF2azV0SHZWL0k0R3dSTWJDOVhLdmZaTU9ydi9neFVtMlFEQU9SV1hq?=
 =?utf-8?B?WFg1dXdlcy80Rm9NVXNTQVlZUUtEeHJuL0NNbnFvcEVlU2NjVDVHa3BjQm85?=
 =?utf-8?B?bk9BNVdYVG9tRGN2bWFMN0NoYVVjWVV1RURhYU1tbjIzZWFwR3dUd1Ricmpt?=
 =?utf-8?B?eDNiUEFDaFd5NERVYnNxYm5Fc3pRTElvYURpSDY0cHd6OU91VnQrN0lrNWJ3?=
 =?utf-8?B?U1F0SFNlUXZCOTMzMzd2ZmUxVnY1TTQ3Y0RFYjd1ZGlWUHdMeGZjSkwzTW4y?=
 =?utf-8?B?bWU0Rk5XTHBuWXJoYmJiUml4VjNIUDhieFZQVDRtZmZ2QWViRWJ2RStKTVZa?=
 =?utf-8?B?SjF5blprM2xNejRobVdLVjU3NWNVbmUvRmFLWFY0MDQzL2dJblc2N1FEZnBr?=
 =?utf-8?B?SWdtdG9nZmRGWWs4WjZldTBlMDEyd3FBQ1pFVS9mYmcvL2srZWUxbGFTTEFF?=
 =?utf-8?B?Q3lYclI4b2JKOTAzZGx6R3VMVHV1R0JjRXJrVTV2QVF0citkTDhJT0xQb2tL?=
 =?utf-8?B?WklWcGN6MVJKRS84YUQ5bnAzYnlQeUVWTEhtNTJZS2Fsc2c1MGJTSFZiTVdi?=
 =?utf-8?B?a2E1NXlXcmFselpTeVVJdVRPdnZ6Nld6bm05b3FJcDhuUGV4YUFKamVmOFM5?=
 =?utf-8?B?NTVMalVIUWlvVGxsNXZjL0EwdTI2M0o5NW9Bc0NtODRDbmFUWWQ2cUVhNkZr?=
 =?utf-8?B?LytyaURkMCtKR0ZTUUxsWm5mMkJxcXF0V3Q5ck0zTEVUKzNoVHpHTWlocXl6?=
 =?utf-8?B?MFIzSmZaL3NHdXRlNGRvMlFYRUxVOEh2L01XVFM1ZUZFRmNkczBmVzk5ZVd5?=
 =?utf-8?B?SjZ1NjhHWG02Kzg3SUVqUUdWcWtXdjJySTVPMTFPNnNlK0NEN0pPc2Q3OHlj?=
 =?utf-8?B?MlU4SmdwQ0dpY3F0OVRNaVJXc3BnTG4zeHdXVURZZ3NpdHpyUWFnS1ZIM2g4?=
 =?utf-8?B?QXFlU0tRTGZNSUFxYnBaaTBUUGdFNDlmRy9FTDU1RWNQbCtYU0ZHN2VSdGVX?=
 =?utf-8?B?NUhsM2ZvQjY2Zlh6cTdhRDgxK0V5SlpEVENLaEZtLy9WSkhoOXVMdkVRbnN5?=
 =?utf-8?B?VVRzUkI0elZCS3BudEw3UlNacWNkanQzUjI3Z2k0aW0ycDd0aXVVbkdzeC8x?=
 =?utf-8?B?RTRKRUpVMlRncVVQYnQ0NUZZZ1V3SHlhaHZTMVdXMExGSHJ1dHFQTzMxNTFq?=
 =?utf-8?B?UDIyc282bEYzY01pUHBvQjQwb09YTHJEOGJBOHlmL2JIZHBMN3JaWkVKRXEr?=
 =?utf-8?B?OVV2MVpqZEtXdElmdTFxL3ZrQlZmdnNzOStXZEN3aVc2T01yczVPeXFSdGZi?=
 =?utf-8?B?TytKT21IQUNTQUxCRVdqT0xxL2QvRTZjWkErdFVhWlhtT0hUNUVDcml3M0t2?=
 =?utf-8?B?SnBqZHZiS0NxR0NvbHNlZU9RVERDVEo2eThFZ1AxU2FiL0ZSNHYxWkw1L0I2?=
 =?utf-8?B?K08wc0VVbWE1eHpJWFZJVWpySGVKUFZxZHJGRlF6TjdsWTBQYjFleStpRWw5?=
 =?utf-8?B?YkdZL3k0alBIcXAwT2xuWXRNRVpjQjFHWWtqb0Nwc1hmZE43Qkd6TWJwM2FQ?=
 =?utf-8?B?VjNVTFp2aURPNUM2OENQU3lwM3o3TGZuQ0FVYUVZWWJEY3NQV2lCUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169afd4c-bb88-41ef-3c73-08da49787ce0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 17:58:27.0069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkVmajQ4p8sAKJuoIbr+qpDjEhL5Rt18bP1S0o8Z1ioVTkShbDS4wSJFEbYc36YDpzFHuYaBM5CrG9RmQfzCxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
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



On 6/7/2022 11:20 AM, Christoph Hellwig wrote:
> On Tue, Jun 07, 2022 at 12:52:49AM +0530, Kirti Wankhede wrote:
>>>    	void (*remove)(struct mdev_device *dev);
>>> -	struct attribute_group **supported_type_groups;
>>>    	struct device_driver driver;
>>>    };
>>
>> mdev_type should be part of mdev_parent, separating it from mdev_parent
>> could result in more errors while using mdev framework.
> 
> Why?
> 
>> Similarly it should
>> be added as part of mdev_register_device. Below adding types is separated
>> from mdev_register_device which is more error prone.
> 
> How so?
> 

Jason has already pointed that about udev event.

>> What if driver
>> registering to mdev doesn't add mdev_types? - mdev framework is un-usable
>> in that case.
> 
> Yes, so it is if you don't add it to the supported_type_groups field
> in the current kernel.  Basic programmer error, and trivially caught.
> 

Current kernel version mandate supported_type_groups, otherwise mdev 
registration fails. But this behavior is being changed with this patch.


>> We had kept it together with mdev registration so that
>> mdev_types should be mandatory to be defined by driver during registration.
>> How would you mandate mdev_type by such separation?
> 
> I would not.  Registering a parent without types is perfectly valid from
> the code correctness perspective.  It just isn't very useful.  Just
> like say creating a kobject without attributes in the device model.

Creating kobject without kobj_type is not allowed in the kernel, 
similarly mdev registration should not be allowed without its type.

Instead of exporting mdev_type_add/mdev_type_remove, these functions 
might be called internally from registration function.

Thanks,
Kirti
