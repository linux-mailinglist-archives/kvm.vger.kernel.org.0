Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFAE5689FF
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 15:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbiGFNtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 09:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbiGFNtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 09:49:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A9822508;
        Wed,  6 Jul 2022 06:49:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMrlnCRmt9TUAEx05TQqJWcEUiLcl8g712gXS2+WxIvlbZFhqzYs1fzWSSHf6nrJ/k09vPcdQh78fYQSOWPwPKxZAy/E4rAp27K7dpmVghCvNz55dWDJ/tqjLQKRyfWRF9mGPnQvHRCz8cuAryUkwPf+QWPqMIcgNItefaK6GiKbd5N5qKpnQKjrgIZYK4Ie/L19GOXXgX1JiuGobpqnrCiSdoSnzkQyndXXSIHf0NYxtja2pxyxU6idXrS6wnif6OBZFOBDU7q9BuISWQsIklF/Shase4F5rN7a0c3NSR8ssyptByrVV8WJRrTigewhcAI95B6uTO5d/Bv+lytt1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ip08PXs03yzvRPtg3aB6LDIOZ/YlNKrJdZbpk1WXu+k=;
 b=OjbCG9x6z8bdchzUuIxsPg5PH+wrVXInkGCcic9sP5Z9lbM4uVb2qbpfSAQRHhLg691KUdUR7e96u2+EvqhODBrTD2ASKuXGObizEfd93T/7Gu3uEHc6LU2s2DdWs17cmrZ7AzMd13fv3dH3ti4vbNg/b2wABtDrXAVQlaaGRQp2ucdL/OCEKUSlLsrJZTg4QfEKS+MpdCyiISOIb1vUh225XcNPAW76yTuVR4/Z9L6Q1B4a/1Fy5tvYdndQ/jZc0b/U3pOF0kS/K4JtZn4tjH8YLWZe7TNW8+U9506pJkhzniPEd8ZaQlhxVAq3uojbwfmJr1b6tKMuVykOws/5Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ip08PXs03yzvRPtg3aB6LDIOZ/YlNKrJdZbpk1WXu+k=;
 b=jxbUArmZ7j//NbACCchji47LYutaMhXCq+XcqOzemHhm30tFfOhJ8Yz/MfsUuOSALlgekjVSzlzuhJZQuntx/7FxNNyYaj8UhUThP0WeNCABQqXhxGbop8cf3aUtS8jjPw4dIFJES3UMKSPkKM41v79BnF/0b+C6LAtaR+reKPlVxGbQm4V6PhYETYjBkcOUZe8Pmow441BG4Ba7CHCCuWqvgfTVW6j43hNcfO9JGdwvWnCiHNq1SO2OrQ9jg8YHrSrw8qynFj1CRZ2DZQ0gZhwkrIW0oSQLxWlRGxFn+IgJ2d4WuR1Z8iM9+x6q0mbptAGoXdx+SeRPHcVjqRCvaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by SN1PR12MB2576.namprd12.prod.outlook.com (2603:10b6:802:22::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Wed, 6 Jul
 2022 13:49:02 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::e16c:261d:891d:676c]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::e16c:261d:891d:676c%3]) with mapi id 15.20.5395.022; Wed, 6 Jul 2022
 13:49:01 +0000
Message-ID: <c967d315-755c-a7ef-569e-9aa25c65d261@nvidia.com>
Date:   Wed, 6 Jul 2022 19:18:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 15/15] vfio/mdev: remove an extra parent kobject reference
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
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Tarun Gupta <targupta@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Shounak Deshpande <shdeshpande@nvidia.com>
References: <20220706074219.3614-1-hch@lst.de>
 <20220706074219.3614-16-hch@lst.de>
From:   Kirti Wankhede <kwankhede@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <20220706074219.3614-16-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0170.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::20) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7eb7417-e185-4231-cb45-08da5f56488a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2576:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8MW/PlTU8vyBI/3q6RJ5azFGDLzChu5LREYwmjBRjuQ0iZPhd+G24M0RsArgUpjuXXWSrT6ug3mCe1AQ2FR8ICPqAA7Hba5QYMFV+Nkeh0A4ZP0N3v1UeiRbBrwPCHgI6SXYBuDFO5qkRC6by5ND4m0XiIkYTIJMIkGJbLQ6eM3Zr+ddjXHBe88QMJI4ZXFb013RDXExFV6UpP3+0GtbwL63KVGc1Gnp9aYUwiuf5SnHLe43ggD7JP9u+zEnt5jLU9/8S/WPbAEhL94ndy0/NXhRgdzUIEShwCvJercnL7J2/3Ia5Ey0NB6CiupYfKFP1IgKI7LShQIY8iEawW/F4BmpHiCzE752wCMvsUOtC87CzsIjKM9tBR4Xfl7obDWAomSrVlmAsQX1u9K+WfFcQspDt/o55mi1eJ3LqN/fPACqG+43HceL962I2YjBhdnAkMk0VweUgMyGP64kcYWA9XjRQDItDV5FEu+5qJ6UAMN1m5wvkDBVkNsjgx1vYSsJj4dQ1WYUzJiC9gXhBQTRr6G9xsXN+eOae6RWZSCGT6Ale9kTAZ1+g4bpdymlwXkuuiraIjMQNtXo/FEU/p+GUYby9a3qmeOAOT/YAaa16lHWkGoohD0m42oq3DE3r/wJW/GcDRxjiSQ/byeXgrOgE57bOQp1WNjjA9vbg8bGXnzq3tnzLXJSTA6ysb1l/FiKW8VdL7YSG9q92Rm38lT+pe8dh1nLeQf/7s5ZDn6LYtm/mWrqb+qOgkWFP+II/Is1hKtpYVJ48DzCQhuxaWdcoAZb7iNWFnlxqjwR3dxlptXjzetunBPT7sOHxbJWpk4Cd6mAIe/Sw4Gx6qaLKaQGsV3zGaiSDFC2bPRZio/8NU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(7416002)(478600001)(5660300002)(8936002)(6486002)(53546011)(55236004)(6506007)(31696002)(86362001)(41300700001)(2906002)(26005)(6512007)(6666004)(38100700002)(107886003)(2616005)(186003)(83380400001)(66946007)(110136005)(66476007)(66556008)(54906003)(31686004)(316002)(36756003)(8676002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHBUUXhKTUxRVHpBY2pUQ0FPSEZSWitVdndDN2NLWGpUM21nbEVCOTRoVUFV?=
 =?utf-8?B?azIzQjdldUhvOHFFTXBGK3V3Y1M5NFFySnN5bkRibzFQbWs0c2lqTWhCZG9x?=
 =?utf-8?B?K1pyNnNrQVh4WTFQVXFUZ2dBSkIvNFcrbnJxNUFqR2trUnhSeTJZYTAwTzl2?=
 =?utf-8?B?VmRYeFlUWW81STg5MDJtZHQ3MnA0MjN2YVBFNnArUGduUGhwMjc2QUdVQk50?=
 =?utf-8?B?WWRJa01scWFkT0dnbUxEUllGUUpsRmZzcWE3QjBLQ1Zab29yakVxY0V5c05n?=
 =?utf-8?B?TjAra3hoVHRiNUl5Zll6anJ6ZzBmVG10dFlSWEJRK1I0VlNsOTJUcnNjcERC?=
 =?utf-8?B?ZHZMOWxFOEs2KzFuWWdsNUdHd3huRkJpaFZVV1h6ZUU0Z1NFL25ZZEVpbTlx?=
 =?utf-8?B?VkVGd3d1RjUvMzF6UDlkL0JzL2dCSnU4a0JoblhhUUF1MjNERWtFM2dIaldD?=
 =?utf-8?B?b3E3MGNNYnlCUURzNThjVEx2a29EMlFYbHRPZytpNHlXSU1CNXFnN2haaUF0?=
 =?utf-8?B?L0Y0VVB1WGIzUm82OWIvWjQvL25JR3JGRDdTanBrZ1BFVGRqTkp4dzZKSHlh?=
 =?utf-8?B?UWJvaXpZQjNUQ3o3cytZamFqdnNkcnkzM2l2TWlpakNLOE1mQ0VHYUhUUmJR?=
 =?utf-8?B?bmlxcW5NcnAxMUgrd3BZUTZZSkp3eXpYVkJmbHkxQWo0b29vNFEyaWVyRWRx?=
 =?utf-8?B?U3lxSTE0MkMvNWhnVFJrNzlYZHhvQ2VnQW4zTUJzM3g5QjJMVERqN3BUY3Ar?=
 =?utf-8?B?OGFQR01hQkF5c0lJK1Rxa2JhUXJMdUdhMldDWHRCT2FKK2psTHo1Q1lLelZX?=
 =?utf-8?B?Zit2ajBUb3RhaUgvcWt3WWFzMjJQODV5Q1B0dTFPM2tyL1MrQ1NZNi9wMlEz?=
 =?utf-8?B?Y1UvR3ZXM1J2ZExrOW43YVZySWZETTB6WXFrb2J1bWRWdnlLVnk4VmNXZi9k?=
 =?utf-8?B?YUNDRUx6bXUzSEVpMzBPR0N2TjJ1Q0RFaGdHelYxV1dpdHowbXhvdWxoWERj?=
 =?utf-8?B?NnFKVVNISGtEdlNFUEp3SFptL1N2UWo3WnJLemdxL3R1cW5EaFNSczFtaDJY?=
 =?utf-8?B?ZjdTL0NsMUZpd3lkai9YaGx6ak1TcmpaYTZ4bE5LZENsZ3FWL2pzSUZtMlZz?=
 =?utf-8?B?MHl0SjZ5dlpnR0t6WlRnWlQzVmE0c280Smh0Q2g1SWpvYXRZVDJTczFZbHFH?=
 =?utf-8?B?VTIzK09FRjdmYnZUTW5zeDQ1VXlHYUlob1AwZmhSbklXODVqZkVmcWliVGI5?=
 =?utf-8?B?NWh5YzhvN2lKNDFNSml6OFFjcG1BSFErTEJac0NwODBWTElPaHJidWViT3Nj?=
 =?utf-8?B?UFM2S29pYU96MDh4THFzZE1wVVZsYWlLUzRHVWdLOVpWY01uUDVkbW9mcERu?=
 =?utf-8?B?eUlKQUZZQlNVZHNlN3RlZkhnRlJMcVVJaC91K0t0VnQ4S1hudExkWmdGcXI4?=
 =?utf-8?B?WDlJQTlZMTlaUCtkS1EreEt0NS8vR00rWlZWSTV5L3lrUmJIL0VmUnphWVpo?=
 =?utf-8?B?OEsrN0tTMENXdEY4bFYrNjNoandPcTczM3ZsVCtoRUxJMVhDMWx0d1BpVVc3?=
 =?utf-8?B?eTdoK2FzWWpJOVpSSHV1cnNSSkl0blNLWFZSc1JxaTNTYXRLdWJNK2VsZ0d5?=
 =?utf-8?B?UTJ1QU1IaWFnYlA3bXdFYjhqcURUSmhHNjd1SWhXL0FPMnFwNTRTeENoMytJ?=
 =?utf-8?B?a1FkZmxUSVhFcGlsV2Q5Y3hlSWgwZEd5RmRaMll1UWpGWGovNGMydFZZalpP?=
 =?utf-8?B?T2t3NFgrNTZjZm9Za0xEc3BzMUZwdk5wRU5nazA2Wi9wZlVNbDVuTUhXaGRK?=
 =?utf-8?B?NTFob3hKVWwwSXRkTVZvM2VSK0tUMnlzTnQ2NFNLdld4czQ1K3g2OFhiV3pq?=
 =?utf-8?B?TzZYT1lpbnlSdUN5RUtuREhSWG1EbnY5M2xLY25TWWRoazJsUERQRi9ZbTBk?=
 =?utf-8?B?dXB0c2VoTVRuOG5pLzFPay9xTkJKRktCVlNuc0lWMlNEL01UdytnQkorenBS?=
 =?utf-8?B?ZHNJcFFuaDJEd1VmeHYwSHdEU1BDT0RqQmpDdnZ6Qy9JWkwxb29XUVRnR1FK?=
 =?utf-8?B?OEJMdGdpVTBmZU5IOFNXZHBTenNsYm9jWXJ2aEdpSmc2S2YxTHY2TzcvYWp5?=
 =?utf-8?Q?g2dSSqVM3TyHxQlieLnPrsZh1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7eb7417-e185-4231-cb45-08da5f56488a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 13:49:01.8508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJasIO+jaix1oUSt+3c/vwiB6WP7mhMaAb5GFLl0VV5u3BUc0QlVmZIwKDsi3ChxortdRhz/RNgSIxh0KFA9UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2576
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/6/2022 1:12 PM, Christoph Hellwig wrote:
> The mdev_type already holds a reference to the parent through
> mdev_types_kset, so drop the extra reference.
> 
> Suggested-by: Kirti Wankhede <kwankhede@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/vfio/mdev/mdev_sysfs.c | 9 +--------
>   1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index c5cd035d591d0..e2087cac1c859 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -153,8 +153,6 @@ static void mdev_type_release(struct kobject *kobj)
>   	struct mdev_type *type = to_mdev_type(kobj);
>   
>   	pr_debug("Releasing group %s\n", kobj->name);
> -	/* Pairs with the get in add_mdev_supported_type() */
> -	put_device(type->parent->dev);
>   	kfree(type);
>   }
>   
> @@ -170,16 +168,12 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
>   
>   	type->kobj.kset = parent->mdev_types_kset;
>   	type->parent = parent;
> -	/* Pairs with the put in mdev_type_release() */
> -	get_device(parent->dev);
>   
>   	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
>   				   "%s-%s", dev_driver_string(parent->dev),
>   				   type->sysfs_name);
> -	if (ret) {
> -		kobject_put(&type->kobj);

This kobject_put is required here in error case, see description above 
kobject_init_and_add().

> +	if (ret)
>   		return ret;
> -	}
>   
>   	type->devices_kobj = kobject_create_and_add("devices", &type->kobj);
>   	if (!type->devices_kobj) {
> @@ -191,7 +185,6 @@ static int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
>   
>   attr_devices_failed:
>   	kobject_del(&type->kobj);
> -	kobject_put(&type->kobj);

Same as above.

Thanks,
Kirti
