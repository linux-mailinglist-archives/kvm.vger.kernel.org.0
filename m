Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8318E54D248
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiFOUGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiFOUGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:06:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087B8369DD;
        Wed, 15 Jun 2022 13:06:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8PVoMR5mZKvEP5XaE/VfZuiL7e81U46uw+l5OZDEHCtwJAZAyhfW/BWel84eIV/MPwaKJe+JQrWSPxBS/B3x8hlw6N+rCaYyJh/gUsmySZKpAnYirBHD5Dd/IJoUzW6d9MtALLMgC73kUnA3Zk45PdKzOk6Vr/jkhBrCRm8CT/60CYhyzfzfDTOxQ+VS/s8UP0qa0qE7d15Oj/dZbbyq4+aGNpV/u5d62L6mQa51O/QTi4QV0EiaNB37Mjgzz9Xwtt0sujjcH1vSz4VAsbu9PNdeDjDLHq5QszD3vJHxvX6cwOUe4DOdO0cOjVG5z7GHiRyObKB6by9+DAlMMk4ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7FaTSRxnG/YMiKEOVQu/20TZzZD4Na4bhUne3Ew6Io=;
 b=UsRnR9euE7nG+BrCtiA0sVFsSw5hYw7bCBXkyF5jti/+B33N4kPLeX4lWM8Cuv8m9AhkBQ4ooew6I54sQeDyJdPgecO0knIL3KM9sKZyBKAiVsLmhCXIK8YhqfdgjWc7ObyqJgQahGHeOrRgTVwgbSdhpnBNrxU3WnUgI4Yhbz2FtJv+co7vWMAg4OeqHfIaH53vHsV0biPK90N7VOtXEsp6oxjc41VTgrUup2FlS2Bi3zgKKZtWIqcB/QdjOyDe//vc8WsaKnxxDHyU/bf3aLZS2FGqVEixH/WTecGMx/cfuYe0gPB6xRHqg+zrXsxuTEAuBIMCq5C4HnJnNcfTfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7FaTSRxnG/YMiKEOVQu/20TZzZD4Na4bhUne3Ew6Io=;
 b=kl0J87ONW8SL6wfz6/aina64JOqc0Mfrhi22GTaPTkJhjr9p1NZ0PmDmppI2of9c0fl8J6MqL4Lb4k8CLuze6YBAYvE0VKnlgWXino8Fj5pH9sL2YecBaCZrxX1FbxvZ2RYKZo4mi2scWo/2SKqgnGJJqqF5VoVkcTFoWnkLeXLdDT/6oht9olbazOhRPEADxtGIn1KT03Zc05klx+WW3bKC4StPiCYDZnJ4IQcPqfNjWma/hK69gZL9ztzJ5jakuY5ygUKkwi87jATJtMVE1O+FLPZ8Dz4eQhB8pdKRz6q6AaY7ejZlICh2+47oQIu02WyhrrpmKqqBXdXb80/jPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by CO6PR12MB5396.namprd12.prod.outlook.com (2603:10b6:303:139::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.13; Wed, 15 Jun
 2022 20:06:41 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:06:41 +0000
Message-ID: <2688e081-741f-0acc-8323-84849d9d01ee@nvidia.com>
Date:   Thu, 16 Jun 2022 01:36:27 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 05/13] vfio/mdev: remove mdev_from_dev
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
        intel-gvt-dev@lists.freedesktop.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-6-hch@lst.de>
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0080.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::10) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49ee1b27-5128-4bec-f473-08da4f0a900f
X-MS-TrafficTypeDiagnostic: CO6PR12MB5396:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB539655A7E3972130587202ADDCAD9@CO6PR12MB5396.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UB+a0iWFhxUbDhsQuYZDEM7otqQomZZnBCxSP+iQ8y0ldc2gCfrOZ0Yb8s5ostbEE/xrzpnWzMHp5ohy8IQcaMS3YRzJehu4Q8dW6yrR77OtS3xsqnp3AQBh1v96RJLrbFYX88QhuVNvin5+vUVFY0UBkmim+LYq3OmqCevQ8dN/LkslgT6TxAPugJKYAnXHpDiffGeiMYolwlf8e6pwbr9DVsYA4j2StAZYvIoUIwSntR3OAbgb2Z0Edveebynw8LPWHb+wED+wV3UUt3AV8XTZxhR+6/DhPgQEOWU2p8MX2Xj4jTj5tnCyoOPmefeiWcLUZlIbaOUXyK6MaB5ClVeRGIYgawTAoK3U586DCRN6a4DNGMinuVGPIbCb7rYZZb/snqHpTxuwBtSNbQurfjYTqc2OwcbICwNcrEg+jetNqjNDzO/RVyFyxK3MaZr7MBMZr7BaRT6LYUKlUkX6xukrokpNH0kwOKEg3g3JNWFVZRl70hW6YZkWYdK04auQwdMpYlwN8Fy70bUXyH41nK1E+FkQEkFSkyq71OFKt1960yihF2tV+XE+EzUGwpeblNWJ3Gu/BWk+L+q3J7Gj2F+HByFoqZc1jOskdsmB6lByBUP5DggHuMfdGK8TJFzunR2JIXmHGwit1ko83Jn0cxCGyOxsLSTv7bN8jQSKl38Q5geBNKgdrZtm81nWC4eLyZGaaB73ug6hvGCdFSgT/AsrxNMuOsWgTeqsM2zX62w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(7416002)(8936002)(6486002)(5660300002)(186003)(107886003)(83380400001)(6512007)(6666004)(86362001)(508600001)(31696002)(26005)(55236004)(53546011)(66946007)(2616005)(66556008)(66476007)(6506007)(4326008)(316002)(38100700002)(110136005)(54906003)(36756003)(8676002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEJ0WXA4R3JjRWpPbVJLQTJ6VHErZ29aZDRGeFdSV2JBdlhEaW9CaEdvQ2N6?=
 =?utf-8?B?cjc2akJHdHF0Zk9mamVUYUtIZzZyaVVCQzllbTdIcXdMZDZ6UGtsRUxNSkJD?=
 =?utf-8?B?N3NMNEtDcklSMklWaURDeW44Zk1taElRbUR1U0Z4T0J0TTgzcGx2VEI1STQr?=
 =?utf-8?B?MzhvT2lNMmp3dDJGeDE0b0gvVFBwUjdMVGJSeFk1Qnc0ZFJGQVhBN1BFRHR4?=
 =?utf-8?B?SVNUNnhyODVTeXBHVk5ycHhGdHc3ekZtLzRaWWN0ak5YRzFDU01NQjkwcHp6?=
 =?utf-8?B?YUs0YndnbFZLNXNNM2F4azJkekNhZ1FaM3A2WXRyNmR1Rk1ka0lrcWRZaWxW?=
 =?utf-8?B?QmRaSjF3alQrUWZ3NEQ0MEpGN0VNQ3Nzdk5tQU80V0NMWWhqZ01USnpRU1dx?=
 =?utf-8?B?Y1M2ajhCcXpkM1JqVzUrL1ltQk1aaU9zRmxybWxHZXlMblVrV3JrRmRnSjlz?=
 =?utf-8?B?eU11UnlRcExCZjlXbFpoWnExNDJGSmhlTnIwSnNVRVVXOEp1SnRIMktqRXpJ?=
 =?utf-8?B?RDZnUFNmbmJaaVJhOHE4M2U0WUhmS09QZldZOCtpUFQ2eGV3bVVqUkgvY0tn?=
 =?utf-8?B?aEwydVhsU1F1cTljOGJadW1maVBxL3ZJYXUxcy9CZ3lCSHZubmVZTmtiWUNF?=
 =?utf-8?B?S2ozaVVnanpDU28vRGRmVzBkRFV3dWwwV1ZCejJzcFhIc2pucFJ3b1EvK0xK?=
 =?utf-8?B?a2FwcVVhaDdZNG1ENGRZVXhnTWRZbG10dnlyWEluZHRxTXRVZnRjb25vRmVH?=
 =?utf-8?B?KzJlOUdLV0Q3RjBhZTNCUEtxRU95YjVIOCt3VWVueXR0d2ZxZkxGK05BT0lt?=
 =?utf-8?B?RTdob2Rtd3NWUzRrYjg5bU9JUjJkckNzNU1pRW94a0IxK3hweWZrVzBaTE0z?=
 =?utf-8?B?UnFPMlZFdUxMOXU3c3l6WDU0TFpZTERYSjY1TXA0WGZRVDB6d082RG84Z0V2?=
 =?utf-8?B?eDVpQmlQT1JPOC9MWVdpakh3NEhCM0NQb0d5RWQ3ZGNaUjFJSTIvakNaUS9t?=
 =?utf-8?B?STZxckZyU3h3N2pEYlQ1a3hGaWZIcUNhQnhqNVN5UmgvdldaVC9sUk5lQkJW?=
 =?utf-8?B?MTRRZ0NzSVZSdXhJWUxXQ01tWGJPaGJtTWZwbFBYeXJHdW5qRzVQbzBaQVpk?=
 =?utf-8?B?VXd1bXlacENQZUh2NEpPTmh5RGpwSllvWHQ1WVNxeCtHaDVIdmF1ZHE3TjNp?=
 =?utf-8?B?Mnp4NmVMZC9rU1VzcjNMdDBzbG43bmJYblQvZXNoWGdpbVpMV3N3WWFuU2RJ?=
 =?utf-8?B?V2tON2dHUHFNM1MrNUI4aHBkK3haVVVVVzFXbzE1OEpQcHZpVXBraExaZXNN?=
 =?utf-8?B?UTdManhYbGdGRFFJbm5HNmQ3SHFHKzdET1F0MmVTcTNDanRoQ3lGelNsazNW?=
 =?utf-8?B?dytZREU5VjBGazVkVzRvR2lIVm4rZEhBazZFT0hkcmp0aEhZSkRUNXVBeGlH?=
 =?utf-8?B?azZMUWM1Zy80K3VLQm5GUE9kNEtLUWp0NG01N1A1cUMrOGJhSFUwMmdSbG9O?=
 =?utf-8?B?WmFSQmtVbG5BYjFrbzdQR0hFdnhJK3h5ZjBielp0dWdweTRUb2NaYzFmN1E0?=
 =?utf-8?B?SXFTaGpKSS9rSGlGNzUzNUtXZGhoQ0N4WDF4V2R0ODllc2piNkUza0NGWGNN?=
 =?utf-8?B?VkhKMFBvMVlkMko2Y3MzcWpmV1gwTjdmQ0k1V2VySzhBcUltb2MzN0F6RFli?=
 =?utf-8?B?djl5ZUphQVFYcWxZS25yWHV5K2JLK1U4eitURVNtNGEyRTZPMDVSWU9iRTVu?=
 =?utf-8?B?dHZscERKNFBYaDdyYi9DWWhuNlhOa3JrUmtXQ0VtY1ZlcjdKTUhBNzdvaThs?=
 =?utf-8?B?TWNHRENqcFRvOFp3cDkweVZpamx3SHpRZlFGUHFZSWlDYUNqTXduVWhBTUxp?=
 =?utf-8?B?VzkyZ2F0OERkbFpacjhlRUVuWEl0Rlk0aTE5S3hPNUpCS09tb2UyTEltMk5u?=
 =?utf-8?B?bjR5dENoaVJwUnFXVGs0eTI3QnZXL2xsZEVmeTNBZkpzQ0xVa1dLV083R1ky?=
 =?utf-8?B?VUtqWTMzeXRzeitPMUwrMWVhSkpsT3hORWZQOVBoUllBcjRaVHpUby94VUJo?=
 =?utf-8?B?VGUwU2VZZ29GWXhHRmFUamZoS2hWKzYrQkFRa0FHYWtCTDVIVWYvaExMQ0F0?=
 =?utf-8?B?Z05nL1Q0T1dDR2QrT1Z4b2p1T3M3UDhtSmNCTWNPbU93dXdhdG5ZeG9rNzJD?=
 =?utf-8?B?cXJrUlEvM1QxYmovSnhUZlNrVm9Nby9ZKzdaYXVDdHE3alFMTEV3b0o1SURn?=
 =?utf-8?B?dVY0UEl0RVFHYmZKTHU1T2RIQ1JEdXkrMXJVejNiSUQ3aDdtdDNtOHdsbUt4?=
 =?utf-8?B?aUU0OEtIbTBDM2Z6bHhEU0JyTmhENGprL3hVU0NCc1hlWWplZVZYdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ee1b27-5128-4bec-f473-08da4f0a900f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:06:41.4859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXDWSBgC0qI7Dz1BecjEYWIDJb5DgvOQPSxK10JfhSoJtZeMtpCMXWoJLESE0IK37KCGOYHrweWiP56tMj0SXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5396
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
> Just open code it in the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>

> ---
>   drivers/vfio/mdev/mdev_core.c | 6 ++----
>   include/linux/mdev.h          | 4 ----
>   2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index fe4230b21993d..49a4a26787ce6 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -54,10 +54,8 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
>   
>   static int mdev_device_remove_cb(struct device *dev, void *data)
>   {
> -	struct mdev_device *mdev = mdev_from_dev(dev);
> -
> -	if (mdev)
> -		mdev_device_remove_common(mdev);
> +	if (dev->bus == &mdev_bus_type)
> +		mdev_device_remove_common(to_mdev_device(dev));
>   	return 0;
>   }
>   
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index d28ddf0f561a0..409e86d343a05 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -107,9 +107,5 @@ static inline struct device *mdev_dev(struct mdev_device *mdev)
>   {
>   	return &mdev->dev;
>   }
> -static inline struct mdev_device *mdev_from_dev(struct device *dev)
> -{
> -	return dev->bus == &mdev_bus_type ? to_mdev_device(dev) : NULL;
> -}
>   
>   #endif /* MDEV_H */
