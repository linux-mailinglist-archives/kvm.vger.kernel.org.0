Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC383B446E
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 15:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhFYN3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 09:29:21 -0400
Received: from mail-sn1anam02on2046.outbound.protection.outlook.com ([40.107.96.46]:10179
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229782AbhFYN3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 09:29:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9lTcQKzCpeJnZaJ9aX+uK9bikqBgSCbNZSegkcrTg6iX2W61uALh0lM0aVoyINdjGbnclVGH2SYa6SOKUP2tB06OBMF+64U8k+NyDNKNLe73xfnW6bmcJMTsaf5pvRTQpg5mB5B3zY7q5ar4bP2VMapPbAjOE7Ay1TZkFPB7Z6X4EkEEnl5EeolZ3fZAh1jeDqcnoSsCCcclSIyI4yLs1fJj5K0Y5aIa1xRJcGkDHE2rx3NU8dCdZZpDYtjZR/OnMVsk+RdEH1pywiZ77qdvnBgfa4W2QqTAe+wwDi/6+sviksbl3df3qE/Ud/8BUhetcO5wRTCC5CVGYtg2yd+6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBvCjYxxCE0t4w7PkgGi6tjvov+JqnycOY9LPkPCN0g=;
 b=F26pl37n5iImiTMjPBKP5nrA8tqFU2lIDtvOaGUfWBWosVwRstA3dDlRP5P19X740cv7RnDO3HSvjuNCtxeBdGbdcomQYXkmT27HckmiZ2ohl36FQxuIRdwisG8xBEk9usqvfePfOSPHVeso352bBJL5ZRcdH4D8VQEVeaEzLBMt6MihBLlsFeZh27dyrUQKEWMw30zXOSR5X2FLQq2cDWrRh14xw2AoNq3Z9OwLHhuw4ZVzYhTBLriAr5U+msa6rRuKNIq11O8BqFpWAPELRwWU2yzxYAezcKz4vBHogaOwT/NrmaQzwm0HB8XZ9G54KrSZ/EOTQ+GGM9UVhyBHqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBvCjYxxCE0t4w7PkgGi6tjvov+JqnycOY9LPkPCN0g=;
 b=1v87HUUmpTbGr3hshM8wdyk2ARRHnSuVCtCJ53xDq4ab2RsNFFwVCNyAR3aWE3qGHl6QGlnP59dEb9tbQIeILr0GOatzreSpMTRM05dIYxNA5Z8I549qhMBPOv9QhGHZ1KGh4j48hlqmOIVIDplBQfXk5dTRhdfMHgEwvCiOa0Y=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2985.namprd12.prod.outlook.com (2603:10b6:5:116::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.18; Fri, 25 Jun 2021 13:26:57 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4264.023; Fri, 25 Jun
 2021 13:26:57 +0000
Subject: Re: [PATCH 2/2] KVM: SVM: Revert clearing of C-bit on GPA in #NPF
 handler
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210625020354.431829-1-seanjc@google.com>
 <20210625020354.431829-3-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <5343d7c5-4cc7-91a1-d92c-2cf88855b104@amd.com>
Date:   Fri, 25 Jun 2021 08:26:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210625020354.431829-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0074.namprd13.prod.outlook.com
 (2603:10b6:806:23::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR13CA0074.namprd13.prod.outlook.com (2603:10b6:806:23::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.13 via Frontend Transport; Fri, 25 Jun 2021 13:26:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2b2b071-a5a0-42fc-1048-08d937dce7e3
X-MS-TrafficTypeDiagnostic: DM6PR12MB2985:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29857CEE1E53922B53E09357EC069@DM6PR12MB2985.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/2Hj8kFPoIJg3WgZjWQZ1HpLQ9vLLIbfaR5m2CXzWAOtwLOKvfDKEeKcRfUEAajOs+Gep7uBPIaJqFwFjbvsaUdJOikvlG572hDho3JrgPhORBVk97R+A3KuBxLVJi/8I+OHRa7bZfiOqfU5sfIxGfFDOBjdHl5MLc84c7kRqIuxSfJaS9igtPY7Khh5BK+bD8d0WEdU4zSVSnJpZ0K1m40A2m8NG48wn0p75bPCGnx0tgqRgU50ajKRLrNnFgrkv40DHeRWCeYT5a5QVV7kEm/OksPnMCQ/v+DHA0po1IlHnqvZqED+zYNkblSVKmHa/ZzcdoeIHtWwiZ9lWtVT0UBIjok0Q4lfbiaeDzXm9j5mRxT7Kq7Gr0TKuQsmJs1w7liBRhmee/0SYEPWoag+/CSMJIXcHt7haCPMKfpG5hb0oWKHyLZuHXgYzbXamsAMyuY45muD6UwZw7yxI/Lc8Ei5z8CO2y49VBTkucddWxYwBjL9Py4Kh4GrWn7FTBeLb4USjyp7ZUQTPY2mQbvf21Tgqm14JnNB66FcWQWefe6jacPUQC3fQKfNA2E8crrTuNTfJ9IC8PX9owYXK3xrXs4GK5AzQgmBAUUVnEOyo3crWVHo/DWVrZReG90Jan50UkFue5m6cRpYPWqVF7GomNao8Gh+oVgvaNKtxa3/t6ykx8psoUvltHG4Fy6U5lE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(36756003)(86362001)(66946007)(66476007)(66556008)(5660300002)(31696002)(38100700002)(6486002)(6512007)(54906003)(2906002)(26005)(8676002)(16526019)(6506007)(186003)(8936002)(110136005)(4326008)(478600001)(956004)(83380400001)(316002)(2616005)(53546011)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OCs4YTUxRnhOL1h4ZEgwYzYxbTMrMGZPcGdPcWtRQnlpYXpxQlU3QnZ5RzVo?=
 =?utf-8?B?Sm1mTGRaSks2UG1FSWdJTUV4YlN3RXlpa1JzMlpYcGt6N2VVdDY3QjZ3SnJC?=
 =?utf-8?B?VmxVWUJId24vdjViMmdUL3J1MFNic1FKbTREMzRlNDVHb2tuWlZyRW16OTNx?=
 =?utf-8?B?K0FYZ0k5RE94aE5oWHhZWENIRlg0WVQxQkFLVHNjYWorazloQUwwTDlYQnFz?=
 =?utf-8?B?UTU2R1JiQ3ByMy83T205K3Q1L3J3N2hqSlZhazZQWWp2TU1VSitiU3JFcE5i?=
 =?utf-8?B?R0FEWDgxYUc5L1pzT2c2WmFzUFBhM0tiMTA5UjU0MkhPQ2pkVktjZkRKTEhE?=
 =?utf-8?B?UThFK29oclJ1L2t1NGVJbUxtbmxtSjdaSXhxR3FneWZLeFRJeW5FQnFNY3Vv?=
 =?utf-8?B?MGpYY0JhbjkrUTBFR2FYWmlmcEVQczNVZGZKWXhuK1hPc1c2aGswWVB2aXgz?=
 =?utf-8?B?MkNvTW5xQ2hHY1Bud3dsTStRV3EzV21HWHNxendvUWdGWnkzM3orUmxwbHZY?=
 =?utf-8?B?UmlDWUxVcFFYVWZKVk9NSDlNR0dtOFk1cllaZWVOd1FzQk9KVnBmaFdBT3Vp?=
 =?utf-8?B?VklJa1dtV1g0bWYvUk5qeDY5d2l2YlBGeFB5MkpOUzVaS09PVEJjWGthQklM?=
 =?utf-8?B?UjI4Zkw1TGhrWTQxUi9lYkxENy90MGl4M0laeStjWDlKUVg1RWtBSUlmUFJw?=
 =?utf-8?B?b2FWWTBLRUtFd2JGQVhraytCM1FrdDlEcnFRT1NtMHY4azFxMTRhVkNOaitl?=
 =?utf-8?B?V1d2cWIySW5tcXFrOHlzRGRjd0JSU1lKVVEvVkNMeEhmaHo5dmxNM242NW9i?=
 =?utf-8?B?cXp0cFQxV3JpVDlDaUxjcE5RaHNVcnFuQUEyaU9nK3hTOWRjQVZJQkpUOUI1?=
 =?utf-8?B?dWFNWjdxZzZBTlhLQkhGeTNwcHBUL1FRUWhzYXdqZHE4K2l0bUxHYit0S01L?=
 =?utf-8?B?OFhjM1pweWxjcnNzMDB1aGs2aDBzSjdsc05zVHhDbzlrL3V6S2ltRHJBZll5?=
 =?utf-8?B?RHJHVFdRQTlFRkpMcGsvd29kVjZXK2czTkdiSmY3QStmSUprSUNQb0dzcUF6?=
 =?utf-8?B?cVdVMWxyVHJjY1JSZ21QQXRhNWljYXpwT2NCazNlV1ppbExVKzRuM0p4bGww?=
 =?utf-8?B?U3pXa2xJeXVKclk0RUt4MlNEclM4WUJjUEQwMWswKzJORnpFWnhUTFp6MFU5?=
 =?utf-8?B?L3JFRlRhNFdDMmFjSEppS1libkRYc01NZkE5NmlaN1ZBQlFmQS9iWkR6cytN?=
 =?utf-8?B?QUxzK29xT1NRRnBlTzBKRi9VeGMzVjhhSy9HQ2xkRi9nNlVpdGZSWnZjZ1pz?=
 =?utf-8?B?U0tYVXZlQnBXR245WGZZMUNZMUdmYm90d2w3TU1qK1k1b2MrTG9jZyszY2RX?=
 =?utf-8?B?RjJYbjlMb3NXRkRyVnk1Vm1aQVBOMUxJTGNJUmVITDBnVU1sVzZqQjBldXZI?=
 =?utf-8?B?U1pGdXV0cm9EMUJtUk1mcmxXeGZtQzdHa3U4ZDZsWnFyWGRVYmVGNnNGaW9Q?=
 =?utf-8?B?TXhKdDZ0UVo5cWdOQmRGNXVGKzY0RDZKTDNmWlBIWkhxbVQrTGRCem5YdVVG?=
 =?utf-8?B?OTZVdzdIcFZtcTdvb1NlVUpUOFoyV1cvSTZ3WXl0YW9aa2ZFUnBkQTUydHBy?=
 =?utf-8?B?M2RVR3RXMEMwd2xkRGdBM2xRUWN5TjR5aEdtNzEvRFdiMG1XK2VyY1FBeExW?=
 =?utf-8?B?RGs1Z3U4UStCVk1TMit3Z3pGQzlyelVFV3JFWDFNaFpPeEtObjRFZXQ2UU5O?=
 =?utf-8?Q?f9s3PvflyM4PEOqZ8Br4AB4lNChSZbpfVCy0Viv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b2b071-a5a0-42fc-1048-08d937dce7e3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 13:26:57.4385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AxME1STsomNf/jQd5rqiK4pHH17vj+QR4SeykyOjEB6C2486bDG0vs5yoon+TyJjJQi7ap3zkSj3FsjhwerK9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2985
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/21 9:03 PM, Sean Christopherson wrote:
> Don't clear the C-bit in the #NPF handler, as it is a legal GPA bit for
> non-SEV guests, and for SEV guests the C-bit is dropped before the GPA
> hits the NPT in hardware.  Clearing the bit for non-SEV guests causes KVM
> to mishandle #NPFs with that collide with the host's C-bit.
> 
> Although the APM doesn't explicitly state that the C-bit is not reserved
> for non-SEV, Tom Lendacky confirmed that the following snippet about the
> effective reduction due to the C-bit does indeed apply only to SEV guests.
> 
>   Note that because guest physical addresses are always translated
>   through the nested page tables, the size of the guest physical address
>   space is not impacted by any physical address space reduction indicated
>   in CPUID 8000_001F[EBX]. If the C-bit is a physical address bit however,
>   the guest physical address space is effectively reduced by 1 bit.
> 
> And for SEV guests, the APM clearly states that the bit is dropped before
> walking the nested page tables.
> 
>   If the C-bit is an address bit, this bit is masked from the guest
>   physical address when it is translated through the nested page tables.
>   Consequently, the hypervisor does not need to be aware of which pages
>   the guest has chosen to mark private.
> 
> Note, the bogus C-bit clearing was removed from legacy #PF handler in
> commit 6d1b867d0456 ("KVM: SVM: Don't strip the C-bit from CR2 on #PF
> interception").
> 
> Fixes: 0ede79e13224 ("KVM: SVM: Clear C-bit from the page fault address")
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Yep, definitely wasn't correct to be using an SME based macro on a guest
address. And as the APM states, the encryption bit is stripped for SEV
guests, so looks correct to me.

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8834822c00cd..ca5614a48b21 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1923,7 +1923,7 @@ static int npf_interception(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
> +	u64 fault_address = svm->vmcb->control.exit_info_2;
>  	u64 error_code = svm->vmcb->control.exit_info_1;
>  
>  	trace_kvm_page_fault(fault_address, error_code);
> 
