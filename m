Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C9640E850
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354117AbhIPRik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 13:38:40 -0400
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:36028
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348633AbhIPRgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 13:36:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKRDzvwW3EEpDRHAuTLQLK5YXue2N6Jhbnj07kgKm9NP+Xuth8iIyME3J5ebyoZnPbJbv9EbAoqc0ncW6Np3freYEYLe9fwQ/afQvzIBMLw9RqKdPF1ziPJymGFxJWFGpXdafIFSRUuA7hhnmNSMaOFLP7ejX0bUmKPr/6MIlQcGzmCzK0FdzG9aY523alGS/SZymMxzJHWYuqqJEKYTrXIe3e6ZVNKNDmRLxb+n6DDKQqobbU15/IQtbQr4FWRZY96B9Tvs9GInw0z9Sb35I92xapmEu/Vp5Z1ma0A43nhELyheHGHb8lsHog9gLLHF9APqlvYCZxBQXXYSZKuM0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KPtpCu7S+Iel4/sIz4JwxHcWtByU5Rl08AFX5CiwhXo=;
 b=OmplTHFhUbK1nVKJqbtK8XqK9E5i20yaU55HiHdT3jbMEq9/1tw6b+ERTL7sO6x9OcQ85I+E7EzRoP60/Ty6r7RpONVDEfxmnArqKk41FJC34tP79o56VlkcG0DPADbVckdn8JE+vGmsKeN11imGyB7P6ztiYr493YWS0WE8kZjI3oCHAY1WNLsMS6yLt2oUAYK4LSbuB8p+t8GJm1If/0q7MxdoNGKhipAu0OllDS0leT7kwy4WaA3DrHPet2xn2H7GsgchInqEpS3xCPBZtzsazcqtWTUpaeniOLZMJCwhOqHWDscoUKQG5rLtYQhPz0uhsI21BnhYrZU+NVcxeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPtpCu7S+Iel4/sIz4JwxHcWtByU5Rl08AFX5CiwhXo=;
 b=g+sC75gZQwVihqyRrXz05a3VVOxfZXIUnJ3bbcZ+SPVRUZl3OCCNF2eK4aYv6WaBLWCpPL8k3RFaIDuvQO9+WhkLP6jAyg0/HwNrSQOtVuS6mvqodIKNUK8ibRdYyS+0erz71QsTh5tHtLLF3T+D8yKaqI8o/NW9O9tPqpKvJMg=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2639.namprd12.prod.outlook.com (2603:10b6:805:75::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Thu, 16 Sep
 2021 17:35:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4500.020; Thu, 16 Sep 2021
 17:35:10 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 01/45] x86/cpufeatures: Add SEV-SNP CPU feature
To:     Borislav Petkov <bp@alien8.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-2-brijesh.singh@amd.com> <YUN3Nquhsn4OD9S8@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <2071cff2-9e1c-d4c0-5163-c39132f68d7f@amd.com>
Date:   Thu, 16 Sep 2021 12:35:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YUN3Nquhsn4OD9S8@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0086.namprd05.prod.outlook.com
 (2603:10b6:803:22::24) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0501CA0086.namprd05.prod.outlook.com (2603:10b6:803:22::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.5 via Frontend Transport; Thu, 16 Sep 2021 17:35:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48f78c24-3a3e-4a48-00f4-08d9793854e8
X-MS-TrafficTypeDiagnostic: SN6PR12MB2639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2639F97A7FA8763ACCBD7D7BE5DC9@SN6PR12MB2639.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: za0zIMf8k+FrGtda4IrwL/e75nNDo0fbIJnL2mWnc1AkVRmcOuDRXUMVspI+SCgNm0QR8HuqM/oSYKCUPiTJo6Llj1/fTjwmSKvw5pCv5ZPGLoNtgNIBMvT1mC/qOV5LSmCRxtvmQKVC6dHeBHdZA0/4ses15XaO45oyD5hi6JaYL+a7nzNW+51jsw4mFywXHubi/y0hKi+AuNLNr4zdxd9pmT7R0xvUU20wh7nR7uTxYp5D7mIYbBDbZVUYiQ8lroos2I5+E14L8oE+moSFg0saJg04VwM0v4jdFFGj4bHY9fbep769U4VU2YSpw69vKK59TTwyi22Ezt+pO9WBrxo7h+c0espBG0lUVfCtPqyt+P2/Kyf5s2+1KYqU5WXog1GBJEiWxN+K/Cl099NMye50Fo/suz1baLuZwBFFLMyjz+Ukioz0X1ODPJEH5EDyonyzXL1CAyVG9R/wSICGjiVONlXepIZGAnwCDUcx4ZPhYeIdOvHIcBfaRg9BQXjG9JsoFYTX9sv8fDH7uIJlRjuHtNGS4f16qsJEHX+Ifd0Oq00siPkshiQlv6l79wY1z8IU9M0OWvpRDGp/wqakGrT2KYABQsTjGi06cCCe/qpzQ9KQS2S3HR5Z2rqYzoXF/Fe+BpDRjaPaVPZv1v2+IOFivVeJFqswp6Jyj8Y1FpbpFUf/4mxJr3b6uqygdqOgkf2M0qcXS5KEK45A6EDNSSrBO3lkZFWgCzxCXpZtmcYowPtPAWa05DJ1WAHAnYltX/yhNX4hIxFi7l7gRdcVKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(36756003)(16576012)(31686004)(52116002)(44832011)(6916009)(53546011)(956004)(2616005)(26005)(2906002)(8676002)(4326008)(31696002)(66476007)(66556008)(83380400001)(66946007)(8936002)(7416002)(5660300002)(186003)(6486002)(54906003)(7406005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1hQbGlUMVBCTFgwQW5SYzhMd2NXV0Vvc1dlZ2ZDK0F2VWRqeXVLZHdIWEhK?=
 =?utf-8?B?NzVjR3E2R0gzWk9tUlk1N0p0Qlg1Vy9EUTl5OUMvQmZ3OHJXK2dhSTJFd05j?=
 =?utf-8?B?UXpqR3FaRDRydWc5ejhNSDB0aGlDOG1BdVJLN2hVeWttT3BlSmtYNDEwaURG?=
 =?utf-8?B?NFd0YlkxaDZzVE1aOEowd1NpWkNXRVZoOVZoYlB3WWEwWDRRRFFCVVBwRGQz?=
 =?utf-8?B?ZVhjVEdBTHd3V1YzL0pBbzN4K09PTFAvWUJ3cEszc0lyQmZuWWxScnlmb1BY?=
 =?utf-8?B?OW5OZVg5c0xVUEh4ZkJ1L05HSG5FVjcxRWx4TlFvNXdHR3VlSWNXSDFIODEy?=
 =?utf-8?B?Rmlyd1gxUUpjZS8zc3lJNHpNb2xlbTNOcjczN2VsUGQrZjE0NzdiYkpzdmdQ?=
 =?utf-8?B?VUswUEljbFZYYUxrdzAxb1BXWk0ySmRpYzN5eFVQMFBZZGZHd0lUaVZ3aEJC?=
 =?utf-8?B?U00ybElTNEZiUndBOFl5Yi9ialNEbkg1Vng3cnhYMHgzRm9sTmxOT25pMmQ1?=
 =?utf-8?B?ekpvYVhoUk55MmFyTTlocmE3TVBsdnFmbFhQWmJNSzB4M0J3cW1CWC9ENjB2?=
 =?utf-8?B?YUhkYWNsMnJOQnoxcWtlTXN1cXowcDNxMlpLeGs1Tlc0QlpBcE95aDV3K3Fh?=
 =?utf-8?B?R1luVmE3YUtoQ3pkdEY5SjFEdFc1N1RYSUxRWkQ4S3Bqd1VKbGlsVmhJSE5R?=
 =?utf-8?B?VDdzOFVvT2txK3BnV1dqWUI2TVRSWXRmdm1xVFRrUC90V29sSmtrcXFMZWZJ?=
 =?utf-8?B?UDh6ei9YSHJFUE5PSEk2bGpyRS81OWFxSzQxVGpGUkFobjFKbElzOG5LZXJk?=
 =?utf-8?B?b0x6enVuUHpMVXY3Zm5YR1lIMlRnR1l2SUlrRnNDc0daVmdsQXNkemlDUUdB?=
 =?utf-8?B?bkdTem14V2JCTXcxcDcvTElmWW9pTjg1TnpXY3FXYzEyVXhRVWd1TytDeE1i?=
 =?utf-8?B?VCs3WVpBNGREa01iMmh1YmJrWXdtY3gwSFMzUkFTNnhRNk96M05qMXhlRGMv?=
 =?utf-8?B?R1JmN00rUSs4SThrV3ZXWWdLajZlZWFVKyt3QkU5ZEJrSmNOUVhMaHR2NE5i?=
 =?utf-8?B?UUlKMzlaYkNCYWdxOTBhZ0JjNmhTNUpLcXFUYlc1WjVUcGhKNkZOR21ZQ0V0?=
 =?utf-8?B?bWlQTzIyS1I0dHNnL0lXbDFUYW5iYkFqMHlGN2VTZUlJMHJoMWJJdXE5NFdD?=
 =?utf-8?B?MGtxazh4QkhKSlQ2SjVMYkN4M1ZUVTdzbkxlUUc4SHcvaWpTTnBrRkFWYStJ?=
 =?utf-8?B?UVZ4cDNjT0VLQjI5dzNTM3h3ZDNiTTVyUVlqeG04OXhJTXV5Zk5VdjN6UDJt?=
 =?utf-8?B?dE9GVWpZN1hWOFUzK2Q5Y2xwVG54d3JLZXgxZWlHV0QxNDRnTThId05tK2lW?=
 =?utf-8?B?cHdjZ2dOcVhrcVpXenpnU3lzWmNoZGlhdEpNSjFwQkl0czdKaVpvTHdjYWxj?=
 =?utf-8?B?ay94ditZMXZ1OUFGZythR1hQZEdDSU4vUTZZZFJKcURXWTlGcmhUNFJWV3lR?=
 =?utf-8?B?di8zajVxdUdTbzlBWUhLWUtYWWVkQzRlMHlnYzJYRHF4cWZFejEvUkdod0F6?=
 =?utf-8?B?MUVtTDhwclV4SHNrRG1ESVJ5KzAxKy9jS1hydGEzemJ6UC90SDV3NnFJa0VL?=
 =?utf-8?B?T1FTdXVvamVHY3hLbE9TaTh1THoxV1VlWDRMZXpRQURvNWN4cXVjUGg0K3Zj?=
 =?utf-8?B?MTlSUzkvcWh0WkFYQTRnamJuUWdCUHIvQzdQVzkzWHdvdnF4OWV5QUVqRjVI?=
 =?utf-8?Q?XOtp3VoHqVe/CQMX/FMyV4q6JqOwf8kbYasMAe1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f78c24-3a3e-4a48-00f4-08d9793854e8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 17:35:10.1095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vCj4Zvg/v+v9pOq3JVretEvyabYe7kenIyB6sRhcdejuBU3xUwjv/lItyBpPvT8B3lJqrw2hck0Toeoe6Ubbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2639
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/16/21 11:56 AM, Borislav Petkov wrote:
> On Fri, Aug 20, 2021 at 10:58:34AM -0500, Brijesh Singh wrote:
>> Add CPU feature detection for Secure Encrypted Virtualization with
>> Secure Nested Paging. This feature adds a strong memory integrity
>> protection to help prevent malicious hypervisor-based attacks like
>> data replay, memory re-mapping, and more.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/include/asm/cpufeatures.h       | 1 +
>>   arch/x86/kernel/cpu/amd.c                | 3 ++-
>>   tools/arch/x86/include/asm/cpufeatures.h | 1 +
>>   3 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index d0ce5cfd3ac1..62f458680772 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -398,6 +398,7 @@
>>   #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>>   #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>>   #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
>> +#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
> 
> s/AMD Secure Encrypted Virtualization/AMD SEV/g
> 
> Bit 1 above already has that string - no need for repeating it
> everywhere.
> 
> Also, note the vertical alignment (space after the '+'):
> 
> 					(19*32+ 4)
> 

Noted. I will fix in next rev. thanks
