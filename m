Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0895A55DD2B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243024AbiF1CRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 22:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbiF1CRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 22:17:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E2823159;
        Mon, 27 Jun 2022 19:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHtSyD5+oP47K56sTjhBxu8kOfZvKLg+v0QwCOGLPd0lWbG8Lboq/DBqOxgwKp/suPuhCkxA3FHjEeTfOBlqE1RoXVJ6J4dpUEjshZT8cULnG5vxtI6Yh72Ih7vOOd8Xjg79f5Z2oASQF4eI3dEHq3geNT3OKr6TArWRRQ808hF1FemgSXKTMI+hh7Yq5uO8JkpgtfgiEiXrx74maSz7FBJiOmAHnW9GU984yfeksPzChEFa5D+unbD1h6O3Q7kFZOmlP0ugMRtov32XLwTXN3kLjFjQLsbjYjd6wzlc03ZprgHfolZje1xSr2qyM6jvKeLKh275YNuMvJMQMM6KdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdFDDWzsyGI3s4TWLbUFgST2hKZ02clfTR9qyIv0ihs=;
 b=THHwb0E43jiIcd46dQzNip0z6Cc+GoAfNtOrW4vzMdw9BbL70FIxMBvGLJxcD7kDNzCIAhspbs8VFKwUsUTKIFXXvACq90BUkO0+z2sfbRRtjjAe/3KSoOCxlm08QYHSQskWCjAnDlpNSzNkyjf5WBRzrDwFmkZHjEr0xoxK0ESHuihvofl0uxpwYaAkFb2P/7KOLlXu2tx/kqeUxr5YewR5wIrP1WNbr2WSTt6F5LZMrUmipG57d6brS5Lo7G5L4+Q34FzXG7LYsR2B8vWpUu86w32O6ZycKgOoU0iso0/tXEe+6MOi3IfI6h/7CT8wooG/hhG2vQh7wit6VkS6Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdFDDWzsyGI3s4TWLbUFgST2hKZ02clfTR9qyIv0ihs=;
 b=Rx0wpYaBBK2565ix9VzOgVFRxAS4EJAAXljW+2CfisPvXVbciJVfmndhrq2pQAmEwTh0e1bloqMg0eSd6haUpkx7+qKMMo3nW4dbS1VsZ/oFMVgbWnXKk8BgmIdejDTXSrSZhyprUZ0YZZHOp9KOdCzktdlh/xs7Rjh8pmVsoD4ElqAetn50mycdPmQAoN+8DkEDdno4BvgAuVwCIZ8tgkUWo9RShVjyITQNIdxwUUz2DMuBivxpRokmmkWA+FnNTLHRqtyDvxQFhh/Ty49EXDjpmtwOUF+BvXZxXaMtJBO3zRhAFfsXlfyNjDyW2dQVE3wKK5ANJqakrSyRgyrSFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by MN0PR12MB6031.namprd12.prod.outlook.com (2603:10b6:208:3cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 02:17:11 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910%4]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:17:11 +0000
Message-ID: <c047c213-252b-4a0b-9720-070307962d23@nvidia.com>
Date:   Mon, 27 Jun 2022 19:17:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20220622213656.81546-3-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:254::8) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03c2736e-a358-467d-b075-08da58ac4f37
X-MS-TrafficTypeDiagnostic: MN0PR12MB6031:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y3enYE9aVJd6WTAauxWxZT0bZth0tgUj0QubnNdIxmTkxAPuylDO/BIyjDDj0teAmUAyZP5R922HsdPUBYHEvLXNrv709iNbR9sbMpkOTzNMYVFl9akya084tKKbsu5XKGZ/lJnyzagL5GTyEQj5Yii62fYaIciZChg6yDRnyycvz2JXHfIHxRYroEp2VB1afQkbF24MXXcKM+L4/qKG425Hy/0isot5avxB1GNZn6w+MC6PKpWWebKIwOpdaAXhEKxcfaTbE1krp0JtWnO3AE/KXNvkJy+HAhptyQPo26mXTM3q0btazgK8uwj3mP5XQwHDlpZ188u0Hdn3T5351DfCCdVS7kOmRThHYpkKVIkE5toekPVximbic6Lx8+AjLtZo2b3Ff/XeXxdrLvUvrNN5vO/XLJOF4Ji3txZ7A1GY1MQf031D2WcsdXz/gBjbJGpulHG+fNQDcSNLUL6FEzB0seicNgs7az2foomHzDkfoB1oCjN53Vrq/QTGr6t4ETRQP1TNOqCYtnZRdg/BT8GiXc1uFRzE7kA6az61zv2KZzJOoGmhesK3772bntTVJW+q7ZM3JcHH7m56CY+bWR5ba4JKoCkN1UJXy+P1T31RSvtYM3yHpThlSDSurUO4XeOIc8ZiX0nMozht0J+n7rKV2M2/9BV+ljjvFd4QW28U2QXrw5BFRh1T1pUfcLq0gDWscmSUnsWVZKcX+/7uJhqGoThWAq2/HbtsIa8GQAH2hG6eQ2NTLUOdl8hu6bEfrABRh3vQW6OV6eNQNqRawhUMnBXl82VNJDyR2PUvBDUzC6YYY/cWTo/e5x4JUdfJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(6486002)(41300700001)(2906002)(5660300002)(186003)(7416002)(66476007)(2616005)(8676002)(31696002)(8936002)(4326008)(6512007)(26005)(30864003)(66556008)(478600001)(316002)(54906003)(83380400001)(31686004)(66946007)(53546011)(38100700002)(6506007)(36756003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L20raGo2ejVxeTJzN3crOWVKcWhFaGozLzdCUWZNZFVyTFZoWW8yOTZBODB1?=
 =?utf-8?B?cWYvMDN3b3lvVWRxdnhiUjE0cmdQRXU4R3BEMmdTeVFhRXZ5ZjZlRGFiNTNs?=
 =?utf-8?B?OVgvaVFtR1ovRm4wbCtLY0JTeEFyMlByengrenNhM214aFhIZ1FnY1pTc3d6?=
 =?utf-8?B?VUovUDNad0tWN0dKamttVmVUQVNWSGxvcnhRbm0wWkV0TUhjWGpQNkdCN0th?=
 =?utf-8?B?RnJyRXNOM3VhejJjKzZhckt6OTA1R2g1MnNXaUFVUW9kWFpGMFUvOUxzN2FT?=
 =?utf-8?B?bSs4Nnprd1A0cGJnRkIyeXNVdlVmNmpNNFhRUFhQSlR0cW5UaVJXS3hXK0lt?=
 =?utf-8?B?MGRzN3NwRGtZZEh6dU5PajdkbXFXT2Q4UVJaSG5yemxQbnVpRUxUaG1VQWFh?=
 =?utf-8?B?RDloTk9EenpaQkh5STJ3bjdvNzBlZ0tjL3hwQjF6R05OMUVZTDlYOFNHKzNl?=
 =?utf-8?B?ZThZVEt2bEdDVC9RNjV0Witwa2NxUktvKzd2bmdHZG0xb3JlaThrdWRrOVIv?=
 =?utf-8?B?TUdIRTRYYldvV3c3U3BJWmpqZDlqSEVvSUdXNmJ5UWo0Z0RUWUQzWlJSV2xz?=
 =?utf-8?B?RlZyZTNOZC9HK1NBMGhIWWZvUWZYeGV5VVl4WnNZbytmR0RmU2ovM0k0YlZ6?=
 =?utf-8?B?UUFLZGEyNTdHTzkvdzI0N2JyN0t1bitHdmtxZlZvMmRTSDU4bkN6elUyS2Vz?=
 =?utf-8?B?aEpKVkJzaWUweEpzYW1JSG41ZFhnTnlhcXpLVFZJblN5SVIwOHAwYXZBUEdW?=
 =?utf-8?B?emg4cE5hRXI1MVJyU0pENDNoQkZHUUVZYWFOQkNvdVZrYW5lK3duSlNvMEl0?=
 =?utf-8?B?SHcwbGNXeVpLUW9jTVF3RGNzajRQM0RoUW1hZDZpakxQc1luVVREMTNBWjFD?=
 =?utf-8?B?TUZYT1hMTCtOUkEvN0t4ZmZYcitDSVdvQURzYjdXcG9USGx2Ui9CdGlHb0Zs?=
 =?utf-8?B?STdWR1pzRHdZQURKTVBMWmpGQVNZejNlYU5tL3RxQzVOa2ZkU29aUjdvN01I?=
 =?utf-8?B?NDNmUHBtSDdkVlA5STU0eENWNzhCS245NVFWWVNxWmliNTVhK1ZyOWhuRWFV?=
 =?utf-8?B?bnJsRnBqeEZPQXVCMlFjU1Z4VHlMVHhxZnhxZzVpdlFxM2RSaWxyMVhqOEJS?=
 =?utf-8?B?RUQxbkV0RjlLckxVNXUzUFpXekhoYi9HbURPT0U2VW5iVWVyTmh3UTdrN2Vy?=
 =?utf-8?B?bjV0WFFHV3hSMW15emtvcC9Xa1R3Ny9IcjJPSS8vaXVkK0JjTERKOEE3Qmp5?=
 =?utf-8?B?RUkxU3NoSmtxMThIbC9wRm1GMEtXdndyZGxqS2QrR1NqUS9XcHFaSDh5aVIw?=
 =?utf-8?B?c3JpQ0N1RmdyZjByTE56bTlQdVlWSmVCbWdkcHE3ZkhybFlHQ1dOMWVxOFRL?=
 =?utf-8?B?K1dUNGxuR05XU2ZPKzhGSXBWaS9XTHdzYkRFSGN3cjlCT2hTc3p5SUN3elNR?=
 =?utf-8?B?NlZYdjhyTE0vak51OXRjNUdkeXhsUjFpUWU4UWZ4Y0RJMVoxYmM4dlJmMHpV?=
 =?utf-8?B?OGV4Q2U0dDZVa1lMV1VtRnBVcHVQMi9ZUlVGM01sMG04akhzZ0NzSTQ3TmQr?=
 =?utf-8?B?OVZQVTI1UFlWeHBJLzYrTG5YblZMNWU1Sm8yRXRYanc0TVZjN0hXWGo5c1ow?=
 =?utf-8?B?U01zKzVBQWd2TVVTcCsxYTNWK0dLc3owdHlUQ0pwTkxQb203WDJJNmdzOWw4?=
 =?utf-8?B?WVdMUkRRQTdMWms4aG1mY1UzMTlML0o1M3JBdXZtZUxqbVlLTWVUM1UwendG?=
 =?utf-8?B?a3dJREkydE54MnBhK3d2ZlZpSytyL1Y3NW50M204U2FaSzM0QUFPT2U5NThC?=
 =?utf-8?B?bENrVFdadHp1TTlyS1g4LytuUmV1Rk92d0o0bElNOG1wamRwTVFRY2wyRWdk?=
 =?utf-8?B?OXhpSmh6U0hUQ2t5ZWFSNGNESkJLZ3lIUWhONVVZQVhaOWJmRXF4T1M3Z0xN?=
 =?utf-8?B?SktrbE1RZWVsZlNlaDg3SFArVzFIQmg1Vi9pc2tvWTlTeWVTcnRLU1pqNjI3?=
 =?utf-8?B?cGJ3L3ExcFRoS1hCSFBrOHVoOHIxaDdjWnd1ZW1yblFadnRrMjVuTnh2bkpy?=
 =?utf-8?B?bFlqK0E0VFJJVGVxZHlTREo5RXFFamFSbE9PNld5Z0ZpeEg1ZXI3ZmRLa3Zs?=
 =?utf-8?Q?dc0NXrzgRyE06zho/jEgD0A0Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03c2736e-a358-467d-b075-08da58ac4f37
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:17:11.3952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yo4C+X9cszM3nCRGDS35eqExiJrdKEJfjVHl0oHv1g37IdcqcQ7vtlWqsufnyu13HnoBndx887Yo0NrfFfYoIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6031
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 14:36, Peter Xu wrote:
> Merge two boolean parameters into a bitmask flag called kvm_gtp_flag_t for
> __gfn_to_pfn_memslot().  This cleans the parameter lists, and also prepare
> for new boolean to be added to __gfn_to_pfn_memslot().
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   arch/arm64/kvm/mmu.c                   |  5 ++--
>   arch/powerpc/kvm/book3s_64_mmu_hv.c    |  5 ++--
>   arch/powerpc/kvm/book3s_64_mmu_radix.c |  5 ++--
>   arch/x86/kvm/mmu/mmu.c                 | 10 +++----
>   include/linux/kvm_host.h               |  9 ++++++-
>   virt/kvm/kvm_main.c                    | 37 +++++++++++++++-----------
>   virt/kvm/kvm_mm.h                      |  6 +++--
>   virt/kvm/pfncache.c                    |  2 +-
>   8 files changed, 49 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f5651a05b6a8..ce1edb512b4e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1204,8 +1204,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 */
>   	smp_rmb();
>   
> -	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
> -				   write_fault, &writable, NULL);
> +	pfn = __gfn_to_pfn_memslot(memslot, gfn,
> +				   write_fault ? KVM_GTP_WRITE : 0,
> +				   NULL, &writable, NULL);
>   	if (pfn == KVM_PFN_ERR_HWPOISON) {
>   		kvm_send_hwpoison_signal(hva, vma_shift);
>   		return 0;
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index 514fd45c1994..e2769d58dd87 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -598,8 +598,9 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
>   		write_ok = true;
>   	} else {
>   		/* Call KVM generic code to do the slow-path check */
> -		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
> -					   writing, &write_ok, NULL);
> +		pfn = __gfn_to_pfn_memslot(memslot, gfn,
> +					   writing ? KVM_GTP_WRITE : 0,
> +					   NULL, &write_ok, NULL);
>   		if (is_error_noslot_pfn(pfn))
>   			return -EFAULT;
>   		page = NULL;
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> index 42851c32ff3b..232b17c75b83 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -845,8 +845,9 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
>   		unsigned long pfn;
>   
>   		/* Call KVM generic code to do the slow-path check */
> -		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
> -					   writing, upgrade_p, NULL);
> +		pfn = __gfn_to_pfn_memslot(memslot, gfn,
> +					   writing ? KVM_GTP_WRITE : 0,
> +					   NULL, upgrade_p, NULL);
>   		if (is_error_noslot_pfn(pfn))
>   			return -EFAULT;
>   		page = NULL;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f4653688fa6d..e92f1ab63d6a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3968,6 +3968,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>   
>   static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   {
> +	kvm_gtp_flag_t flags = fault->write ? KVM_GTP_WRITE : 0;
>   	struct kvm_memory_slot *slot = fault->slot;
>   	bool async;
>   
> @@ -3999,8 +4000,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	}
>   
>   	async = false;
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
> -					  fault->write, &fault->map_writable,
> +	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, flags,
> +					  &async, &fault->map_writable,
>   					  &fault->hva);
>   	if (!async)
>   		return RET_PF_CONTINUE; /* *pfn has correct page already */
> @@ -4016,9 +4017,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   		}
>   	}
>   
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> +	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, flags, NULL,
> +					  &fault->map_writable, &fault->hva);

The flags arg does improve the situation, yes.

>   	return RET_PF_CONTINUE;
>   }
>   
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c20f2d55840c..b646b6fcaec6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1146,8 +1146,15 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>   		      bool *writable);
>   kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
>   kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
> +
> +/* gfn_to_pfn (gtp) flags */
> +typedef unsigned int __bitwise kvm_gtp_flag_t;

A minor naming problem: GTP and especially gtp_flags is way too close
to gfp_flags. It will make people either wonder if it's a typo, or
worse, *assume* that it's a typo. :)

Yes, "read the code", but if you can come up with a better TLA than GTP
here, let's consider using it.

Overall, the change looks like an improvement, even though

     write_fault ? KVM_GTP_WRITE : 0

is not wonderful. But improving *that* leads to a a big pile of diffs
that are rather beyond the scope here.


thanks,
-- 
John Hubbard
NVIDIA


> +
> +#define  KVM_GTP_WRITE          ((__force kvm_gtp_flag_t) BIT(0))
> +#define  KVM_GTP_ATOMIC         ((__force kvm_gtp_flag_t) BIT(1))
> +
>   kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> -			       bool atomic, bool *async, bool write_fault,
> +			       kvm_gtp_flag_t gtp_flags, bool *async,
>   			       bool *writable, hva_t *hva);
>   
>   void kvm_release_pfn_clean(kvm_pfn_t pfn);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 64ec2222a196..952400b42ee9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2444,9 +2444,11 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
>    * The slow path to get the pfn of the specified host virtual address,
>    * 1 indicates success, -errno is returned if error is detected.
>    */
> -static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
> +static int hva_to_pfn_slow(unsigned long addr, bool *async,
> +			   kvm_gtp_flag_t gtp_flags,
>   			   bool *writable, kvm_pfn_t *pfn)
>   {
> +	bool write_fault = gtp_flags & KVM_GTP_WRITE;
>   	unsigned int flags = FOLL_HWPOISON;
>   	struct page *page;
>   	int npages = 0;
> @@ -2565,20 +2567,22 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   /*
>    * Pin guest page in memory and return its pfn.
>    * @addr: host virtual address which maps memory to the guest
> - * @atomic: whether this function can sleep
> + * @gtp_flags: kvm_gtp_flag_t flags (atomic, write, ..)
>    * @async: whether this function need to wait IO complete if the
>    *         host page is not in the memory
> - * @write_fault: whether we should get a writable host page
>    * @writable: whether it allows to map a writable host page for !@write_fault
>    *
> - * The function will map a writable host page for these two cases:
> + * The function will map a writable (KVM_GTP_WRITE set) host page for these
> + * two cases:
>    * 1): @write_fault = true
>    * 2): @write_fault = false && @writable, @writable will tell the caller
>    *     whether the mapping is writable.
>    */
> -kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
> -		     bool write_fault, bool *writable)
> +kvm_pfn_t hva_to_pfn(unsigned long addr, kvm_gtp_flag_t gtp_flags, bool *async,
> +		     bool *writable)
>   {
> +	bool write_fault = gtp_flags & KVM_GTP_WRITE;
> +	bool atomic = gtp_flags & KVM_GTP_ATOMIC;
>   	struct vm_area_struct *vma;
>   	kvm_pfn_t pfn = 0;
>   	int npages, r;
> @@ -2592,7 +2596,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
>   	if (atomic)
>   		return KVM_PFN_ERR_FAULT;
>   
> -	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
> +	npages = hva_to_pfn_slow(addr, async, gtp_flags, writable, &pfn);
>   	if (npages == 1)
>   		return pfn;
>   
> @@ -2625,10 +2629,11 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
>   }
>   
>   kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> -			       bool atomic, bool *async, bool write_fault,
> +			       kvm_gtp_flag_t gtp_flags, bool *async,
>   			       bool *writable, hva_t *hva)
>   {
> -	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
> +	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL,
> +					       gtp_flags & KVM_GTP_WRITE);
>   
>   	if (hva)
>   		*hva = addr;
> @@ -2651,28 +2656,30 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>   		writable = NULL;
>   	}
>   
> -	return hva_to_pfn(addr, atomic, async, write_fault,
> -			  writable);
> +	return hva_to_pfn(addr, gtp_flags, async, writable);
>   }
>   EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
>   
>   kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>   		      bool *writable)
>   {
> -	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
> -				    write_fault, writable, NULL);
> +	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn,
> +				    write_fault ? KVM_GTP_WRITE : 0,
> +				    NULL, writable, NULL);
>   }
>   EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
>   
>   kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
>   {
> -	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
> +	return __gfn_to_pfn_memslot(slot, gfn, KVM_GTP_WRITE,
> +				    NULL, NULL, NULL);
>   }
>   EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
>   
>   kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
>   {
> -	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
> +	return __gfn_to_pfn_memslot(slot, gfn, KVM_GTP_WRITE | KVM_GTP_ATOMIC,
> +				    NULL, NULL, NULL);
>   }
>   EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
>   
> diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
> index 41da467d99c9..1c870911eb48 100644
> --- a/virt/kvm/kvm_mm.h
> +++ b/virt/kvm/kvm_mm.h
> @@ -3,6 +3,8 @@
>   #ifndef __KVM_MM_H__
>   #define __KVM_MM_H__ 1
>   
> +#include <linux/kvm_host.h>
> +
>   /*
>    * Architectures can choose whether to use an rwlock or spinlock
>    * for the mmu_lock.  These macros, for use in common code
> @@ -24,8 +26,8 @@
>   #define KVM_MMU_READ_UNLOCK(kvm)	spin_unlock(&(kvm)->mmu_lock)
>   #endif /* KVM_HAVE_MMU_RWLOCK */
>   
> -kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
> -		     bool write_fault, bool *writable);
> +kvm_pfn_t hva_to_pfn(unsigned long addr, kvm_gtp_flag_t gtp_flags, bool *async,
> +		     bool *writable);
>   
>   #ifdef CONFIG_HAVE_KVM_PFNCACHE
>   void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index dd84676615f1..0f9f6b5d2fbb 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -123,7 +123,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva)
>   		smp_rmb();
>   
>   		/* We always request a writeable mapping */
> -		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
> +		new_pfn = hva_to_pfn(uhva, KVM_GTP_WRITE, NULL, NULL);
>   		if (is_error_noslot_pfn(new_pfn))
>   			break;
>   

