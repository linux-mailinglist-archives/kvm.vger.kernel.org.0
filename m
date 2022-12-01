Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738F763EE66
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 11:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiLAKuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 05:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiLAKtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 05:49:19 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567FB303DB
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 02:49:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c15iVj9EW+UYqpV/BBIzMmI2qX+SacuhpYzJPSgsvDn4VXVzhAkOJkOeV/806GzOCXFY7sfaVRxT9O5EHHAStO04MFYTdY88gDA3YSq1xkNgFfL8lHrQ4CcEQtNBMdhnFe19Nx5qLtqgT7GmpulOeBIYffN0gis7BHedc1q04+WWMd5fDpdxVjx057p8mCMOHC8ULu2P9ik61g8qD4LA2NbbGU5nn37YXO9t/d7CJD4qBNpok2KpWiCeThyxgTYy32kMZswCN86T03bElE6Mq+nMu1Z4jsiTgWt9ldBvJRniHC5nZGgODtvrD54sYPCc00BqsqZ2oJvPUI2qZP4Jgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRJHHiIZhvSnVd/hPe4jw6N4mTDLVLnPP0U7mBOeJrk=;
 b=Sjhr32Xwb5r+/JkPpzIg1REfXfXmRF/MZbSAWu/ITxmDOSg32qzYPYnzalJkr/KKdePvCzpKzS2f1Q9KyqE14++CFkn8uNi6ghM1jpZTYKb5QJ0Q0V8fECWBat0P6jfMK+bhZxCkzE5I8MqC1CwAub6p3w2epHIYicO3mIlFawWjMfsaze3kKf8n3dn6lMb2R35cgnJ0tdOqPoi3PqwZNPgnx2TQ5J9CclWuooGac1YTP8hwnohjCTX0hkh+LbCFMqkqiwNUZflJyEUCa70acxBMQk9icjda8qjxacqVvMXt8koCHJ8W1NxTUzgPhtSTIlPqQmj4rqFg/bJF2dAxMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRJHHiIZhvSnVd/hPe4jw6N4mTDLVLnPP0U7mBOeJrk=;
 b=b2OIYxDXPFVXeNskoVDfQGhFMJHQkb/ll6Bf+BQWLfs/+LbSHkbJv/O0wlHA7iC3q+kSCDQxlpQfJj1+DtBQ0789JihDYidvsaplzEFYEZVPC3SSpWmq/ke4hoFaD9SlDb0pta9fBU5IMgDkbVUqLZvJStkEOqvB0Zz3rtV47K55/g7PtzPRQx1pI2PTuKUnI5tvESl+nLqWujyb4VZsp8RHXhU8I4+5zB0eS/OPG000ovWHdozGhcsRee17LZc4I2KPzJlC+cF2PddPwyHD88oWIyjZ5LO+z6tR/mR2qDPy1+p2A76AXhehbLwjp2Y6Bdbxo4yIJ2gg+IigXz0W8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13)
 by CY8PR12MB7609.namprd12.prod.outlook.com (2603:10b6:930:99::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 10:49:13 +0000
Received: from DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::820f:1fa0:9353:bece]) by DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::820f:1fa0:9353:bece%9]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 10:49:13 +0000
Message-ID: <68c2a830-7d82-6fce-f6e5-b3c8c292e120@nvidia.com>
Date:   Thu, 1 Dec 2022 12:49:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] vfio/iova_bitmap: refactor iova_bitmap_set() to better
 handle page boundaries
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20221129131235.38880-1-joao.m.martins@oracle.com>
From:   Avihai Horon <avihaih@nvidia.com>
In-Reply-To: <20221129131235.38880-1-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0547.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::16) To DM6PR12MB5549.namprd12.prod.outlook.com
 (2603:10b6:5:209::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:EE_|CY8PR12MB7609:EE_
X-MS-Office365-Filtering-Correlation-Id: bd7372e1-3852-4313-3cce-08dad389af64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F98VbbMDAP8stjszo+/GpKH4wZG9UmoA59D7jC0die+ZptXF+fIVuCNw+6zOoT0+0gBdgYK7URY4a6V7ueNfRMD/0elIhiIwLjTp17/uwkSvHdSCeJgnxrrQ2tG7M2dZxqBE3M0phcCab0qdQ/tjnQhR8B2SIp/cSYQbRObEytJUhzCJLlONd28ey7VJZDdiC0ehVo2GBeMFiTKFAK39drKjJGFiv/dpV5PmU5OiYBEcTiuiDtcHY2eRyRNZXCLz89qigunDCEk21NgRGP+J45ADwVxkp9MLXxbR3LYKGOFaIP/C8Ly9H0rL8Wg7bL5hV3uzrDOJGgWE49reYBxd7a0hxTwLu9TY2ZO3W/ogzWooQmCddz6Zl2FpeGd0906E7PQZLTqCcamSC03ZKEO1R4tvuJ0U1xIzXzfsUrNB97gakTB6TMqPbXo1as3zvCAL1V0mSliBVxwk1cfKJE5srqSLD8xj+NUmKxnC09RSs7CuiFz+xA6i80Fqjna7A6zYQl7NqcqhjqSaS5kPj9lpPBdcSi20JPe365p26vxDOBYYpqq+UaC3khY9EBtEAtr5+w2EGLaRJFoRTVGsSLmYTNB2A9S69rXpj1Vt4KJ38OaUeKdBQVvjPxzfsmhyGxnv1NwB7NfPJwNDrsbeM1nVt5uVBv4Yxe9HPOKrA+v2dNj3ipUBYQXUzHr4cLgCIRHt/baaK+M9qFjmd2x2k6qvUqeb9muJZtvzWtcFp1V4dEI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5549.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(451199015)(31686004)(2616005)(186003)(6486002)(54906003)(316002)(86362001)(31696002)(36756003)(26005)(6666004)(38100700002)(53546011)(107886003)(6512007)(6506007)(66476007)(41300700001)(8676002)(5660300002)(83380400001)(2906002)(8936002)(66556008)(4326008)(66946007)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnlwSkVIMFNnNmpzdC9hWFBicGJBbDU2WWtJTkRtU0hwaGFIYzVRQklCdjF3?=
 =?utf-8?B?S3pCOUNSRDl3MlBOcVhlUFpWelIxVFJ0b0xmUDU2bFBMbzJzQWNxTVdSMm05?=
 =?utf-8?B?c294VGRWRHYwUkFIRm8zc25JQmNSVE9VWktObEcyaXBZbFRxbDdPQzYzOUtV?=
 =?utf-8?B?dzVLWkR6SnloVkNrUnNzUTF6LzhTTTJsVm5ib3pSSTl1WW9EbmVSRWV2MXRn?=
 =?utf-8?B?NHBucVRycWRQODU0TmsvL3dYVGpDaWtuK3lTL2JYMzFmbmEvbDFWMnVwazA3?=
 =?utf-8?B?dXdVTXE0Y1ZwL0lpQzFqaVlWdXpQQ3FDNmJIL00yOWRIVWptSWVXbTBReTRE?=
 =?utf-8?B?N1FWeU9jRmdqRzhuUnlLUGp6R3dGajJNRTNMUCtkL0NKNU53bXFKdHNjMWVa?=
 =?utf-8?B?cWtkVXNTMXpKRzNyaWViVG1VSUlPOEEyeXZpVE9NOC9sdm5KZy8vMS9ZUWdF?=
 =?utf-8?B?eStJcGF2MGhMdXIyL1Izd0lJRTVmQWJNSUZOaDNWV0w2UXNYRUtiaVE1YUZ2?=
 =?utf-8?B?Q0hhNGFHZkpRQmxETFVySUhrUkZ2RDh3M1ZPbjc1Q2VPLzRxQ0pxYXA4ZkJ6?=
 =?utf-8?B?MDhJVGJ5Q0c3S1lpckVpQkEzNWFpeFRTdWpWT3VwamNib2tTbVhtbi9Ea0JN?=
 =?utf-8?B?NnV1eS82dnUyOUdlT0dNbm9QQk42S2FoVTRlam5EVW1hYWhYMWgwYUdPZlF4?=
 =?utf-8?B?Z0JqQ3JDY1ZPVThObWtydng5SmdXekplbWR6bVBzbWRSQTZzVUJjWmdVYnd4?=
 =?utf-8?B?MnUraXZZV3grbnducjBXK0o2SHpTRm5EaS9vcWZIWG9oU1Q3TFI4d3RsZHNQ?=
 =?utf-8?B?eGFsRnRDbE1jTldORkdoYWRQL0tqMnZ5RnRiaWUzeFJ5dUtwUHQvWVRlZTlj?=
 =?utf-8?B?MkE2YVhMVlhuOGZpbSs3YUt6My9NejNjdXJ0ZnRDaVVEZC9yWlRJaEdkNGhq?=
 =?utf-8?B?M1ZCWGp1YnlYQSthYWR4TGhxU1ZUWW1pWkVyTTlUS2RtZ1lSV0JxdTZUS0dT?=
 =?utf-8?B?WUhWalJTalljVDlVbGpPRHorcXY2dFE2dWV3eENTWmZpUWNKV3g4UFR1M3Zw?=
 =?utf-8?B?U2tHQVl3MCtHcTd1MFlMektFdHY0cGF0ZXZjQ3QwTjhzZ0lIRlhzWVlwbkN4?=
 =?utf-8?B?bG15bGJsUVBWQXNaaW5mbmNGeVNGeFNvQlpnOXU4RHZ4OHJJNThpcU1ZRSs3?=
 =?utf-8?B?SjAxODFKaGtZY0EzaWlPR2VOY1FGRHJnNE04emlPcERWZ1RZa2NFcmk2b2NM?=
 =?utf-8?B?RUVZLzRVaXJNUE9UWjJqeHZyakRtZjdKMDFqTFVOUFFEZlVlSERYb0ZmUmNO?=
 =?utf-8?B?bW1ETm5OL25rVEtXVGdGaEQrdXNKUGIxRzlTZmk4QWV4cGpGTk5VRlZNcXBr?=
 =?utf-8?B?d0VBU1djVW1vUnBEUlJNK1VSd1JyOTdFcG9Hd2RhUUh4M1RXWGI4LzR5UStS?=
 =?utf-8?B?QzdyQkpoTTkrS0FjTjdZSDB3Y01LVzVVU0pqdVhDa1VKZFVjRlgxbGdzbXhG?=
 =?utf-8?B?RDNmUUczVld6cjlkVm1ZRG13NFJZazdMblhVVkdBbnQ2ei9CTlJpVmE3Nzlx?=
 =?utf-8?B?ZDJwMjJuaGJ4OW9UN25YR1lvQzNqNFlXYzE4QWN1M1dTUVZqdC9PbGs5eXFl?=
 =?utf-8?B?a1JZbVFHOW1iOG1pMkVzTG5Pc2JzbEdtV3ZQRG5yZjhLM0VhYUZ3UUtQbnl5?=
 =?utf-8?B?ei84cHl6cEk1WWloaytEb2huKzVXYXRZK2JYWnVPVDQ3SHA1RU5uNUcyUCt2?=
 =?utf-8?B?T3JPNFVjNC91aUd3bEdNKzd2eHI5RzJ5Nk9NYVBPbWlTSWZWYkg0M3grcksy?=
 =?utf-8?B?T2xndlNoSDlyeHZvVHJDUEJMbXJkcWdBU2NkZXMxdzM0OHd3by9TbjR6Nk1o?=
 =?utf-8?B?RUp1U0hFeVVMdlZwRVRXSW8xV01odkZUbzNyWWJwR0MwL21XM3JiRmtncDFU?=
 =?utf-8?B?UTBPOUxCNlBIbnFCN1hDWTc2ZjdsRGlvMlcrdHJEcnZYT1dodXoyTC9yK0Qx?=
 =?utf-8?B?bHM1Q0NPNlBneGtITkhIUjRFVlRDZU5TSjJrNExuS1lZbWJDbnN6K0tpcUNF?=
 =?utf-8?B?RkRobEtMVTZDNmhsaExvY3VPUm9zVkZWbmgxYnVQTDZxQXFZSjJwSkg0bFVs?=
 =?utf-8?Q?vx2CoqxJARyuoblTBuKKPdh7s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7372e1-3852-4313-3cce-08dad389af64
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5549.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 10:49:13.5095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAGqZP3HbKiqNRYB6904b83Ah5pOb5BVt9Z0vEn/UkqB/aK6ztdxFOxfB3S+WyVHDx4wGfYqLSuYww21v8UK0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7609
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 29/11/2022 15:12, Joao Martins wrote:
> External email: Use caution opening links or attachments
>
>
> Commit f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
> had fixed the unaligned bitmaps by capping the remaining iterable set at
> the start of the bitmap. Although, that mistakenly worked around
> iova_bitmap_set() incorrectly setting bits across page boundary.
>
> Fix this by reworking the loop inside iova_bitmap_set() to iterate over a
> range of bits to set (cur_bit .. last_bit) which may span different pinned
> pages, thus updating @page_idx and @offset as it sets the bits. The
> previous cap to the first page is now adjusted to be always accounted
> rather than when there's only a non-zero pgoff.
>
> While at it, make @page_idx , @offset and @nbits to be unsigned int given
> that it won't be more than 512 and 4096 respectively (even a bigger
> PAGE_SIZE or a smaller struct page size won't make this bigger than the
> above 32-bit max). Also, delete the stale kdoc on Return type.
>
> Cc: Avihai Horon <avihaih@nvidia.com>
> Fixes: f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
> Changes since v1:
>   * Add Reviewed-by by Jason Gunthorpe
>   * Add Fixes tag (Alex Williamson)
>
> It passes my tests but to be extra sure: Avihai could you take this
> patch a spin in your rig/tests as well? Thanks!

Looks good on my side:

Tested-by: Avihai Horon <avihaih@nvidia.com>

> ---
>   drivers/vfio/iova_bitmap.c | 30 +++++++++++++-----------------
>   1 file changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
> index de6d6ea5c496..0848f920efb7 100644
> --- a/drivers/vfio/iova_bitmap.c
> +++ b/drivers/vfio/iova_bitmap.c
> @@ -298,9 +298,7 @@ static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
>   {
>          unsigned long remaining, bytes;
>
> -       /* Cap to one page in the first iteration, if PAGE_SIZE unaligned. */
> -       bytes = !bitmap->mapped.pgoff ? bitmap->mapped.npages << PAGE_SHIFT :
> -                                       PAGE_SIZE - bitmap->mapped.pgoff;
> +       bytes = (bitmap->mapped.npages << PAGE_SHIFT) - bitmap->mapped.pgoff;
>
>          remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
>          remaining = min_t(unsigned long, remaining,
> @@ -399,29 +397,27 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
>    * Set the bits corresponding to the range [iova .. iova+length-1] in
>    * the user bitmap.
>    *
> - * Return: The number of bits set.
>    */
>   void iova_bitmap_set(struct iova_bitmap *bitmap,
>                       unsigned long iova, size_t length)
>   {
>          struct iova_bitmap_map *mapped = &bitmap->mapped;
> -       unsigned long offset = (iova - mapped->iova) >> mapped->pgshift;
> -       unsigned long nbits = max_t(unsigned long, 1, length >> mapped->pgshift);
> -       unsigned long page_idx = offset / BITS_PER_PAGE;
> -       unsigned long page_offset = mapped->pgoff;
> -       void *kaddr;
> -
> -       offset = offset % BITS_PER_PAGE;
> +       unsigned long cur_bit = ((iova - mapped->iova) >>
> +                       mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
> +       unsigned long last_bit = (((iova + length - 1) - mapped->iova) >>
> +                       mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
>
>          do {
> -               unsigned long size = min(BITS_PER_PAGE - offset, nbits);
> +               unsigned int page_idx = cur_bit / BITS_PER_PAGE;
> +               unsigned int offset = cur_bit % BITS_PER_PAGE;
> +               unsigned int nbits = min(BITS_PER_PAGE - offset,
> +                                        last_bit - cur_bit + 1);
> +               void *kaddr;
>
>                  kaddr = kmap_local_page(mapped->pages[page_idx]);
> -               bitmap_set(kaddr + page_offset, offset, size);
> +               bitmap_set(kaddr, offset, nbits);
>                  kunmap_local(kaddr);
> -               page_offset = offset = 0;
> -               nbits -= size;
> -               page_idx++;
> -       } while (nbits > 0);
> +               cur_bit += nbits;
> +       } while (cur_bit <= last_bit);
>   }
>   EXPORT_SYMBOL_GPL(iova_bitmap_set);
> --
> 2.17.2
>
