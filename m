Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9999F611437
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiJ1ONv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 10:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJ1ONt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 10:13:49 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6361E0999;
        Fri, 28 Oct 2022 07:13:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUi2yjlmGTgQCm95NLjdIsEN21BHhJiLLdEq/T2I82/dNZvr0KpihAQL1ur83HMUFoDPVuWOKuxUdkXVMRAo+mK+WOzm+RcroRixquoPWqtlAaqWnTmi7OJoOZ5qQFDwLgduhSIxhNxtcadFxn8aOVaI9Lm9COlVT7dkyru1nHah4tldVkA9rlhWCXxcQmZGLHxSaXIF8zVOhaHySDwgdyUpF1jbKiPsDxwt7LleX9MQKtJkM88BLFyBv0KUqIOgAUFTED2aHA/VyTUiRNx8lEEXZk9ku04zbaYeWCc1QtTDVl7lCz3zyzYodO5ma/x+Kbso96EOV+RJaMkmSz7Lxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1UwKxq4hYG6BeNz2fXbSY4D1klYb2ojwrJZJvRn1FU=;
 b=CgctuT8L69fbkMXkQnDk9PHTl1Hf42q4FCsu2pOhVqjFKyJDejmKTj+nTra9ZK+er4EyWxObvu1qbuoKYfzsc1k1GopCKv1wjqPdHMPXFEt66+v37ZC3jmyYjVYAohqXxq3wAMvVv1zt//GzXnQhsRe7UFb+Xq2PHiyNoSt42pfbmIkGTfSszdlEVtw/alzyuj41cG1Rf2Fz9tfimj4Gk5eVFM7wd/1omKOMxTDLDOMrraIHhy7VLlU77DipZlTxoyBKOx5MVrK2DNMwPx5tCtQAab7MC45tiEyezNx/9p2jXKMZksYG5EooWxoBlnQ2T8m1hqOElm6ZIWRK1RMzIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1UwKxq4hYG6BeNz2fXbSY4D1klYb2ojwrJZJvRn1FU=;
 b=GVpXTGtzzql+3PrEmrpPeMtVzTYo1tFHhBbGw74n26rl5ZBDRJZ7a02Rq0SOHZe85Bp2pIKsjfByoMuOrFEGkX80V9bdxYWj7RTUdL7CuihJK0SLQMtL5l/cc9+z3FHv9fFcpSnjU/reFc+W9M8K9EUke55QqldrkIiVUMfssfI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH8PR12MB7374.namprd12.prod.outlook.com (2603:10b6:510:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 14:13:44 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 14:13:43 +0000
Message-ID: <d1410850-56f9-f085-8889-8e5a12d5ed63@amd.com>
Date:   Fri, 28 Oct 2022 09:13:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH kernel] x86/swiotlb/amd: Half the size if allocation
 failed
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        Ashish Kalra <ashish.kalra@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>
References: <20221027052607.260234-1-aik@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221027052607.260234-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:5:40::40) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH8PR12MB7374:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bd76b8a-1684-4f2b-c500-08dab8ee9f1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AozXu4aTQ7URlkiI7JjH0vD25lhyDFASwg7L6WzgOFDaP6bPg5ogvG0WclydjBURuvxmxLe/PNW3VUESjn+kDo9MH3vcsVNvkqFUoO5GbtPu+c7SyEotzJSibOCJYT8PWw7cw+pHJrqfovnaBvPo/ZDkBHQkYYXqsrBYyV2ASGTNZE9jEwPp7rT7AO3GlGjUJj42iItn9uxt8RAV5L92cOjpJF0bGyf+4moPFxauNMpkqHMzGLtMO1u+fDjzTusS04JLnc5tuVUgEBwFqOPgP8pYPhJyjdlwFxV9DStVgsMoBljoKlvK0ztedULMJxLJnZT/FDYKDg3N6cg7zVoB42dxEFLRU8q4by9CWoIP25JC+R1WOJmU+Pzz1WIq7M6Qe7/KSuSun4/s9HwGDuBKmrCnLXpxiqrdKYwyNMjfBUyIXVX81fabRCENkkacGe45DLdTHl2avnua0RBZ2Ba+hwiRIYvm6FJTgzyuQGPWMb2nP3+wg74NO5dsLADdl/ftgRegSJAgJJroQTEdCZR9rsHSwwcC1OavzoX3d1No62OHvdlcgrxRB+aQUST1OfN+bLIodsudwWh/gHUjOxH24N3dAaH8uiCH63XiSU9XpVOOphSbJS/yqJUxoAhihgHY0DVY4HlrCEHuzp2a5bq5+qqz3B5I7xF1mURwEL3A7RmDrY1wryg+QrLv3O4eOPYjd2Vj87dmsSuwkFGJfnhlp8Z5exMLLHzFHEfNHkYz8ggqzZqrVC9KQlPdxDafwdQLPo8nbrpVSLpdMN0PI6SG3tTVn98n9AHxJArn2APcP38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(36756003)(31696002)(86362001)(31686004)(38100700002)(2906002)(83380400001)(478600001)(6506007)(6512007)(26005)(53546011)(2616005)(186003)(6486002)(54906003)(316002)(66946007)(66556008)(66476007)(8676002)(4326008)(5660300002)(41300700001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmtGb1VGUVRZdkNlQkQzK08zQzZtTXY3Y0IwUVVGNjBwdU1kUXFIaklJOEpC?=
 =?utf-8?B?MFJTQUc4S0tLU1RQa1R0QkFxTmNTc3pjY20vZHdMSG1DNVF3dTY5S1lMWldx?=
 =?utf-8?B?UFAvYWtWWEhOYmRNdEoxVGxueHQzRnh5Unk2VjU1UDlIb1huTEltMVp0am9p?=
 =?utf-8?B?dWQzL0dvT2JqVlhKOWNUTWNMTm5YLzlWQm82UHZRcmtIMU5IQ3NvNXVYU0Fh?=
 =?utf-8?B?UmFwRC9wQk9oaG9sOGZaZzZ5OWc3MUNNZ3pNZVdtYWVtVXdDbndTcDBzSERL?=
 =?utf-8?B?MDh0VFJndmdwOUVPOUFQQ1g0L1AvN3J4VHFEVFZWZ0ljUlhTVDJiN1hxemxh?=
 =?utf-8?B?bng0S0Z0alJ1Qis1SUVBSklyUFI2a2YvNTluQTkrREhTTUlCMWJWejRxaXlk?=
 =?utf-8?B?bC9rbUxNMyt4a3lrT0c5cmlhR3dTcHB5RVFzcHEvY0ltNXNEcDFtS0NWSDRr?=
 =?utf-8?B?NUdyQmo4SEc0cC9rRnhWRkxZeTZ0WjBuMHJvLy9adGNxcEhUM1R3UGxObWl2?=
 =?utf-8?B?bUdiRm5WNWRuMWNScHBURzdtMjg4b0Z0QXJvbjdLNjA5MXZTM0ZQaW5zNjU5?=
 =?utf-8?B?OTBFWlFaV2VGOS9zV3NsSENaV2tXYW9ZU3NrQnlpY3ZCWWlIVi95ekRzOHZH?=
 =?utf-8?B?MGFUOWpFSjNscStydXhwRWJoZzJ4SVdZbGE2TTN3dkNCd2RTellkZlZSaFhG?=
 =?utf-8?B?SEtMVktlaE5UN21tWWc2SHV2dkNmR0ZCYlp3dlVtTTVQcFpuejIyRVB4RmJZ?=
 =?utf-8?B?NFN4d3dWSHpZR1czNDRHN01oejk4VTA3eDJQTU1vYzkwZzJJOGtnaHBiWVBJ?=
 =?utf-8?B?Vmw0eUgvM0xyQ29GTythMGdlU2w0aTlLSFYreTVnbG1iK3ltNnRUL2xuQ256?=
 =?utf-8?B?dGJ6U0FmdXRBbHIwZFVJSUlYLzhGM2dTV3dJNEljM0M1dmVVYW82STVJdExs?=
 =?utf-8?B?MWFVc05GN0dNTDUzZTJ3ZThCZEJoV29ZZmxZZkc2WEkvZk5sSTlBT25QUzlF?=
 =?utf-8?B?SUVLOE5HT0ZvVWN6cktHa3daazNqWXBacmR2OVU3L3o3L1RLS2ZxNndNd1FD?=
 =?utf-8?B?YXh2dForQjNNaThiTzdLMHNRYmRMZjR4TE1RU0FJeldyNGhWdzhZUU5WdFow?=
 =?utf-8?B?SXBYSHlsZ0NIbGtmRW9BNmJFdy9oUDJlL05YUUFHODhiYjBrTzhHZWx4c0Jq?=
 =?utf-8?B?cWhieEpwTEJ6Wjd1TG0vSmtaVFl0blVuNGk3cytFclpqZnZ3eEVrWFVmQkZP?=
 =?utf-8?B?cVZsOTl1K2VJeWVkZW1ETmtJdE8vNnFQYmtnbUgxbWZpNjROQTZsQmh5bjlS?=
 =?utf-8?B?SnBmVUd2eWtwRTlqQURKbWhacFNLZnJDZjZEZFlPR2RVRDRxelVFc0Vpbm1S?=
 =?utf-8?B?TXB4SHpaQVE5RUd3WStoOXlYWFFUSXdWRzAwSG9GVjg0Y3ZyQm8xcG9sWWZ1?=
 =?utf-8?B?VzFKeDFVUUtVRmJmbFUzeGZjWUFJN1hMMzcyR3RtK0RaaGp6RDBZdXhQTS9x?=
 =?utf-8?B?NFpiSFlzSVhNemRLM1VUd29QM0ZYUHpxNDF0Z0kyN09hV1BjWkJuSnhGRGxE?=
 =?utf-8?B?MklrUzZjdjJCOWZ4aW9EZTRCN0w5ZHVYdm55K0ttTUY5aHpjZmh2MkIrZXFs?=
 =?utf-8?B?TFArWGFEOGhkSEh3dTNlWldLMXJlZ3VhWHk5ZzY1Q1cySk11d0NRZ0pLY0g0?=
 =?utf-8?B?dXNJdHEvVms5elRMeVUvdEF3YnVCK1JtY0NxTGkxaHBtVFl5K1BzMnlJT2w0?=
 =?utf-8?B?SUl0RG55SGNmM2xaMXB2dnRmREdGQ0FzZGNIQnJpdldZSGVCSXZGOWMwZ1pM?=
 =?utf-8?B?MDVuNERFUE5wYXRNa0Z0ZTQzOFhISjdOeFVRYWtya2drNDd3SGMwRk1zd3ZW?=
 =?utf-8?B?UENpbDJTRFFQWW1BdnlyQzlldThFRThEd3U2Ujg2QVNkejZkdm1OakswTSs3?=
 =?utf-8?B?azBHRjJQSzFKT1IyenE2K2tKZzlscS9XMU5QMUxoaGlCcnE0WWQ0M3o3YmJM?=
 =?utf-8?B?U3FrRkVDRjA3Wm10Wnp2TXZjTHRaMlhyaUJ3RFQ0aUxhdk5FZitjaWQwTEdq?=
 =?utf-8?B?eTUvK0VESml0VlhCTytXbElKTDNSNE9Cam9lcmtBMFlvNkdUTitCU2hURU9P?=
 =?utf-8?Q?eIHUPfJAYDWtQ6M+BW2VV+Clh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd76b8a-1684-4f2b-c500-08dab8ee9f1e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 14:13:43.8917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MqNOheUiGUa39WkRCFV+jy+rZUU4LBso19koATOFALYCuC562774FgnW6AZEyw4Sy9i/89cXj9Z3p7q3/DLnhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7374
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/22 00:26, Alexey Kardashevskiy wrote:
> At the moment the AMD encrypted platform reserves 6% of RAM for SWIOTLB
> or 1GB, whichever is less. However it is possible that there is no block
> big enough in the low memory which make SWIOTLB allocation fail and
> the kernel continues without DMA. In such case a VM hangs on DMA.
> 
> This divides the size in half and tries again reusing the existing
> remapping logic.
> 
> This updates default_nslabs on successful allocation which looks like
> an oversight as not doing so should have broken callers of
> swiotlb_size_or_default().
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> --
> 
> I hit the problem with
> QEMU's "-m 16819M" where SWIOTLB was adjusted to
> 0x7e200 == 1,058,013,184 (slightly less than 1GB) while
> 0x7e180 still worked.
> 
> With guest errors enabled, there are many unassigned accesses from
> virtio.
> 
> ---
>   kernel/dma/swiotlb.c | 20 +++++++++++++-------
>   1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 339a990554e7..d28c294320fd 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -338,21 +338,27 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
>   	else
>   		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
>   	if (!tlb) {
> -		pr_warn("%s: failed to allocate tlb structure\n", __func__);
> -		return;
> -	}
> -
> -	if (remap && remap(tlb, nslabs) < 0) {
> +		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
> +			__func__, bytes);
> +	} else if (remap && remap(tlb, nslabs) < 0) {
>   		memblock_free(tlb, PAGE_ALIGN(bytes));
> +		tlb = NULL;
> +		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
> +	}
>   
> +	if (!tlb) {
>   		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
>   		if (nslabs >= IO_TLB_MIN_SLABS)
>   			goto retry;
> -
> -		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
>   		return;
>   	}
>   
> +	if (default_nslabs != nslabs) {
> +		pr_info("SWIOTLB bounce buffer size adjusted %lu -> %lu slabs",
> +			default_nslabs, nslabs);
> +		default_nslabs = nslabs;
> +	}
> +
>   	alloc_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), nslabs));
>   	mem->slots = memblock_alloc(alloc_size, PAGE_SIZE);
>   	if (!mem->slots) {
