Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A39D782A01
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbjHUNKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 09:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjHUNKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 09:10:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A6FCD;
        Mon, 21 Aug 2023 06:10:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZZHEZaA+S3TUUokWPFI47AYgUbYtNJ6buJZTLwzkUL9ScA55HEwJdGbaGUe1ytntdo5LEO45gc+I+beXlVk8hPzg4j0uGFa6McG/vCru0xYPUleDmfHSp+2nCLu+vTmfPPg11+RjZypKvf26hQwqMtVUg46jpEivCjJ1Bn5Gd57lPwLbdQyPis0WDKRfpb4eKQyakeBXhsU9Jg4G7JGgC/vTbPxkvPR+rltWfhCn5ExFooeZ41CwGxN5lN24w9xwHX3j3ORnDPrNt6mN5R/VjzqD/7//OBy2DKCZEnmAtf2OMO3zAmYKkY+vzDWJSY967Zwmqk4VbAy732DD7Z3AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtSziLT2hvhUlfbqnTxnAxRMTqI5F6fR0SlK0tqQOW4=;
 b=KYaWQMg7o8/wUX4mM0ltqnRBP2YOeSMH9Lm2yPiLkF/isNiQTpj6FWRFBQj7DiB9GU1CBNFwUVQtEo1Oot3m3fjwqlJg5pDcqD5RRahuyqRnKhPj7AD1toCJDV8RJgo90WK7dEOqqVIvZQSVgySWi7rxDNyKbibmzdPL3sSFBDBSFzuehPx1DfNM8nWHd3PPAyx4yLnHYxBqczY2a078PJBTQrYPhDXN7AFivY7XkJdCFQT0QQfxoICE3G9udMuG9ClYwPcMZN+XI+1wRP+D1RkNA9H6W+LrDM5W0USpe0ju6aFSv8C7ZOSZJLK0xKoKhgweS5sBiIfW4ZZx6Pib4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtSziLT2hvhUlfbqnTxnAxRMTqI5F6fR0SlK0tqQOW4=;
 b=xT3jILX91XhONd1PPeM9vO+HiPqb2k0T+L07rBkmQvPuAtq/VQtR0ugPCRyL39EOjhHxu+w51Jxj77TeIU/EAXSp1O3DrEO05PdpRWvgWQS5z+Xky6+WqTQ+LqWoEhQmXCkjt2+vm4X0vlw/4lr798rv+rTMCqNVdnFK0zODtso=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BY5PR12MB4083.namprd12.prod.outlook.com (2603:10b6:a03:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 13:10:08 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 13:10:08 +0000
Message-ID: <08418fc0-839a-f2fb-1c2e-b4f077d2647b@amd.com>
Date:   Mon, 21 Aug 2023 08:10:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page
 aligned
To:     Steve Rutherford <srutherford@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
References: <20230818233451.3615464-1-srutherford@google.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230818233451.3615464-1-srutherford@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:805:f2::42) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BY5PR12MB4083:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cc8cb4d-9103-4072-2d30-08dba247f194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/GtOnhWVDmSriOWOLQ9oQ7J7KR7mVW6Hpwf4auU4k/RtIYwx7fN4YophEXnYSmHhqvLu44BBOBD9YmsoWwJbXRDwap0BbpFiwnL/oC48AU5Ls+ISQiC/p4rJ1BOlp4btxNSFkpSiNywjxUBMTR5vxW3nyEhtKOcQiTVDtm15/E4EMaljbzwVWZuIBH+vmLmqtuzR2BOZ/9BNPFCpSnWFettns3hv+FT3uV7JNqlBNeNtrSGk6J0DM3WuiFigMYgA6YJX4sXVuVCSZ48vyItHTcNsYcE3mZ2I4iQe28/Pp45NRubr/7M4tFQFLGYTqA0Wm6y6DYAaJLRWdF+zOVpM0IKJlFohx8Hyh4l0gaUMMz+AXEmMYbo+J+NT1H9sMr9OIbOVX2TTo4/IqIVKcuEKHNcOyRcG+fHUxaXKmyrY2QPJuU0Du1LkS8aTEATP8MGcxULhbopuT8SnrmDq6HRau1jZCnjpo2DajdlTFB0ZiW08wViHjIJ/8h9kJK5m7reJc4N89xPWu3MrLzoA28WSkhXd0t5ioKXOV4FI1usdmM8S2e/8vfuf9pLqVlQqT2rNlrMMo+c8NDaINQGZEXxGlAi9HGEL3rSoi+oRdO9Esu4o7imeqrIw3PuRDRW8kMqUqw/SkEWaOvhn5scz7SCBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199024)(186009)(1800799009)(2906002)(7416002)(53546011)(38100700002)(6506007)(6486002)(83380400001)(5660300002)(26005)(86362001)(31686004)(31696002)(8676002)(2616005)(8936002)(4326008)(316002)(66946007)(6512007)(54906003)(66556008)(66476007)(110136005)(478600001)(6666004)(36756003)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzdMNm5kSy8zWVBxM1dJcU1qelNwQmdITUNBYXZRVGphU2RqNnhKSlB5Umg4?=
 =?utf-8?B?eERSRU1mTWUzNzZaMm85bjlBcE5acEw3S1NMRG9Md3VLaU5lckNHb2xUMmJr?=
 =?utf-8?B?Njd4NzM1eHlGNlUvdXZrYjFFUHBSUzZnOXRaVjVyY2Z1REIzdDZRN2twTGRE?=
 =?utf-8?B?eW8wWW9TUmw1YjJnOGdEODBFZ2d1N2IwTmlaOWdBK0hLTkFYM25LMGdzNXNI?=
 =?utf-8?B?RFlxaVBwYTRreUM4R2MxeDRMUWxzcmxrNHBOUGhGbzZ1Z0I1QU5hMHlsb0xS?=
 =?utf-8?B?K21taU4zWGt6Y0xJTUVnUnl4NUk0RU00Q2RaL3NNRmdpQTMvSFNLdEZyYXo0?=
 =?utf-8?B?YWtxVkEvQXhYdEc2L0diZUZXS0RwTlppVU8rNkVCREpOQXJjT0x6QU9OMStR?=
 =?utf-8?B?UlpRZ2hHVE82NzB4MTdtOXR5ZVRTUERpSzJBNnJLT3IwZFVRSWFiS1pOSG1O?=
 =?utf-8?B?d3ZIdXFGRi8yRStnck1UL1hmRmtZUHdlMFM2RFpWQjhLV2Zrb2M1WTA1M0lN?=
 =?utf-8?B?ZnpXanlENWZwZ2VIOEdRSHdiUVZqT3pxRXNsWm81dy9BZWxzSnZka0hLRVNa?=
 =?utf-8?B?b0JZNTQ3OXh1VUdxVSt6WWFTRzBkQmxlc2o5S2JkVFU0M1JraWE0dW0wZCtG?=
 =?utf-8?B?dzgzOWlaaEZLRmdDMlYzcEJ3VjNqdDJMRFpNN0xCQnFXQnZzSXlLdGNTSUhX?=
 =?utf-8?B?MmtmUG0xM2F5MXE4ZGppeW0wdUhYZzZzNFpKQVhKazBIeHI4clFlYkpwaTRG?=
 =?utf-8?B?ajRXVysxdFRjTGpiVDhQUWYrc2hCajRDd3JBUmNRZU52RUUyMlRUSDZYUWd1?=
 =?utf-8?B?MGdtRzFKL3U2STVJTnQ1UWF0M1J3ZDM2UHNlZG5zZmFCaTBKZTRFSVl5dUFZ?=
 =?utf-8?B?c3VrdG5GK09iSktKMkFUM0kwVlFPTGxPcytFbWRVY0Iyc0w3dmU3dWppdEJs?=
 =?utf-8?B?RVJEalFsQWxCeE1TTDNJeERlcFMxdFZGSHk1MWZNdWRaVEtyK210Y2pGMlA1?=
 =?utf-8?B?U05IbE9YMm5vMVYzL2hJaWdtdlVJa2RsMGtNaWplWnR1WlZPeVVkOFNtMTRK?=
 =?utf-8?B?aHhSRFdzV1MrOWwwekZmekVMaUF3S25lRDdJMUdXQ2JiVUM2OEVKMXZzYVEr?=
 =?utf-8?B?eElhbjNBd1ZmUjB4U3hSeG8xd0lvbmhoei9vd2R1dlNhT0p5NDROdVBpTlF4?=
 =?utf-8?B?Rzh1ZzgyQ3hRSkdiZk11OFhkZk5reWVsdU9YeWtIY3RObHl5MEkydExwbkpv?=
 =?utf-8?B?TnFqNk9EV1BUa1dubS9iRjdCZ1JvaVdmdWIwb1EwZW54Qm1VbFFGR1UvRmpL?=
 =?utf-8?B?cHgxc2Q0QWZiR1RaZi9WdThvZXF3Snd1aS9GR20yZjBVOXhWcHhMV0F6Tk5E?=
 =?utf-8?B?Q21OSXNoVmQvYXY4UjVrWVgycWJYS1haamZBaDF1SEMwMkliT1I5WXRMSlNy?=
 =?utf-8?B?N3pFUC9hOHFXNXBrZGllNEN0SWp6YVBoK0o3U0ltT1lxdUwxYVZzTGtxeDNV?=
 =?utf-8?B?UmhzaDZOVVNFZGExRVRubEdUZG44RnFnM283NmtkTkZTazRvRXc0cUFML2Q5?=
 =?utf-8?B?Zzl0T2ZNWmMydFJTa25hZkpKYXBuT0t4MCtnSlFTTnFBUTBZd3gxYkZpQWli?=
 =?utf-8?B?dExrS25OOXB2T01qS0wzVXBoNnRIQXV6VmFOQ2xOMXByRFlCdWIyc1JsNTBy?=
 =?utf-8?B?OGpnUk9oTi84U3l1Yk5HNjFwMk55d2JpaS8wVFBrLzhteE8rRVNnZ0dLMWpB?=
 =?utf-8?B?dlpSTG53QXFzdkhJQ1ZFYUhQZk1oMTVPTXd0T1BiVjdUYnIrRDhwUi80Y29r?=
 =?utf-8?B?RWlTa0pDR3VQckZnT0ljRXRaZWNjbWdrOXBMYmoyWnBRSnlTVmkyU25zQkM3?=
 =?utf-8?B?eDlrVlBWWUgySzlRQmU2Mm9EcU5HWDAxZ1ltZktMS0ROdTYxdURWUmxXYzdo?=
 =?utf-8?B?eFJQOXZlSmJ5OGwwTkdVYmVZT1ZpRnEyYmlYYmRnZmFMb09RWXJXTUtnK2lx?=
 =?utf-8?B?WjkzS21BVnVab0diSVRmZUdRc0JRS0hiejVXazFkS2tSRzh4STFRT29ZdnFI?=
 =?utf-8?B?UzJwbTJQbDk3YmFQcHVIbzQxVjdPRmdpM3BNdkZJc1pXVFFGRGl1WndsOVhv?=
 =?utf-8?Q?IuN1sj6/PwkBPIT2WcyDTjWjZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc8cb4d-9103-4072-2d30-08dba247f194
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 13:10:08.3988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jrew+AczKnwnZaWCcUzdFyaDPfDVZzimqHS5u5HzCRyO0g8z+kmwfDvyl2rKYskSMTljhbAOVpXnjuQa2t7mQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4083
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/23 18:34, Steve Rutherford wrote:
> early_set_memory_decrypted() assumes its parameters are page aligned.
> Non-page aligned calls result in additional pages being marked as
> decrypted via the encryption status hypercall, which results in
> consistent corruption of pages during live migration. Live
> migration requires accurate encryption status information to avoid
> migrating pages from the wrong perspective.

Hmmm... I'm not sure this is the proper fix. The code is actually doing 
the right thing from a encyrption/decryption point of view by checking the 
c-bit for the PTE associated with the virtual address and the size 
(possibly crossing page boundaries).

I think the problem is on the call to early_set_mem_enc_dec_hypercall() 
where it doesn't take into account the possible crossing of page 
boundaries and so can under-count the number of pages, right?

Thanks,
Tom

> 
> Fixes: 4716276184ec ("X86/KVM: Decrypt shared per-cpu variables when SEV is active")
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> ---
>   arch/x86/kernel/kvm.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6a36db4f79fd..a0c072d3103c 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -419,7 +419,14 @@ static u64 kvm_steal_clock(int cpu)
>   
>   static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
>   {
> -	early_set_memory_decrypted((unsigned long) ptr, size);
> +	/*
> +	 * early_set_memory_decrypted() requires page aligned parameters, but
> +	 * this function needs to handle ptrs offset into a page.
> +	 */
> +	unsigned long start = PAGE_ALIGN_DOWN((unsigned long) ptr);
> +	unsigned long end = (unsigned long) ptr + size;
> +
> +	early_set_memory_decrypted(start, end - start);
>   }
>   
>   /*
> @@ -438,6 +445,11 @@ static void __init sev_map_percpu_data(void)
>   		return;
>   
>   	for_each_possible_cpu(cpu) {
> +		/*
> +		 * Calling __set_percpu_decrypted() for each per-cpu variable is
> +		 * inefficent, since it may decrypt the same page multiple times.
> +		 * That said, it avoids the need for more complicated logic.
> +		 */
>   		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
>   		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
>   		__set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeof(kvm_apic_eoi));
