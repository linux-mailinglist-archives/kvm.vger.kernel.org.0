Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7829B2F6D08
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbhANVSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:18:53 -0500
Received: from mail-bn8nam12on2040.outbound.protection.outlook.com ([40.107.237.40]:28577
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726744AbhANVSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:18:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKfnpSpR3ZMZolYeNcldyV+STRwouQsJJ9WmHgxe9Kln0Zq8KRa9xEm163w5MJ5Bv5rnoHnEIFkcc/wQGHiRo09K+VMDW4R7WRMJIjumM7tTF1xJR7GD3mHNWA/LWVxTltjQ9IVwpDRxhnAxbAH7LLaf9bjhXGjKfjVRuwy802N0M0IrrTpDbj6TjWTrMdvdjzykIG3warG9XCFCe6k1z2kjwh7ECSVDagJQN5xXPX9FqQ7yeRJuYx5zmkwiBbtO+YMGGWUyBscMlfzm9LTeLmBOY7lf0okcvtNgXAb6wbHhwMK58+CcECP+FyBh0VaIWqXftiFyAuaWDuFMtNFSIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bO6jRe5Aup+HJRRpV3Fn2bu2zT6MpdaVr8+fcmxNPrY=;
 b=QxVCQAqex04IxqRni5gC53lSynZnzN2jeuWcK0DTLY6U7Z/fbrlp8kbnr1cDZtyUGtfrOn8mTVcHd8gLn7lCAWdqxM9ulYXmOss8TE1kopvXb40jXks+vPUzsAWARd5/coEIgT1ffVm1exQMDw8kOczZCp+LcEpbPwYLtMTWUbs5A/xrpbC3Bf59c+qEXUAhJ/3CmQFmINKFKq09qH5QhWyz7Q6gUMk8ENqMtPpsh4FxT3VnvmKox2G+KfKhbZgZjKDh5Y4La5v4kFbiGT25JPwLCLJStgRWxKL9APVSWXQQTZlSThCn673+CuTb0TplMOYhLsh5XpwulVe1xawLJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bO6jRe5Aup+HJRRpV3Fn2bu2zT6MpdaVr8+fcmxNPrY=;
 b=EGe4lOcUBNZb9CcwmnScIGg4Juh3aZI3CWapFs9CaZR6wd/Ij1fqLLzrob68IEF2recgSUQlX/lzp7wFLbLu4alhsHd4bDIZxZ6EIqZkfNZ+523nNAPfgGXQ6rB8dkPpsOF7vskyAOTUs5auBi7Fo7OcWLBR98Os5cS3/X8rRGw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2768.namprd12.prod.outlook.com (2603:10b6:805:72::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 14 Jan
 2021 21:18:20 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:18:20 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 05/14] KVM: x86: Override reported SME/SEV feature
 flags with host mask
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-6-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <041ccaf2-d7b4-dd5a-9e63-e4443fe97583@amd.com>
Date:   Thu, 14 Jan 2021 15:18:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0073.namprd13.prod.outlook.com
 (2603:10b6:806:23::18) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0073.namprd13.prod.outlook.com (2603:10b6:806:23::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.6 via Frontend Transport; Thu, 14 Jan 2021 21:18:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ec2c1ad-569f-4e03-3fc4-08d8b8d1eb39
X-MS-TrafficTypeDiagnostic: SN6PR12MB2768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27681C44785AD756C715D067E5A80@SN6PR12MB2768.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DNkBH+inmakga8vfahm9nPAKEjZEG0PaJzZUcISQTDU/9pYOiRX4uPM/356jf8TMaAhWrJbYSr6XAiFI5FHptqLHSLrHIoYaeeVp5gawUJttRHGFC3Esn4FQ3P5Qut70Y9xgg3CDm9+9AnvWl6jlHOyxS6BxFhvMaU3zzKIEssNbvM/2d+2j59V/s2yy2xggPj/mee/r1LlBX2u3S7S17uSMtR8HXYXXdDnNMKT6hkn9UReRn2tVRtKBbFUd93O895EPd9VkB33sVPStpWIxt4HQJiL8A6WTLQ/TYqpYk8or1p4Xvy9IKjb3/cNUv7kXvIOwH7IdydTWQO0ePYfTbbTNcw4eUmWbZ94hI//XU1atvxgC9Uezil4TtBxj4vDkYHb93s5LKsXO74Tvm5KovoIufmiDbonfk4Afx/eaxeDHctzRzP+/H1Zo8clKj2rg9XFOTXvn7gE376lf/goQex71Avkq/DW3QLx/AZp4P+s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(2906002)(8936002)(66556008)(6486002)(53546011)(16526019)(186003)(5660300002)(66946007)(52116002)(110136005)(8676002)(6512007)(6506007)(31686004)(956004)(478600001)(2616005)(4326008)(36756003)(7416002)(86362001)(26005)(316002)(44832011)(54906003)(31696002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Sk8zQ2Y1bFJPbDZSRlVGdW9ZRXYwSnhaVHpHa1dldVN6VWVzVnhQeEtQU3JX?=
 =?utf-8?B?aTc5TVF5aHY5bzRkd3E0dGlZNjRLdm10bXhKNEkwUnpZalRJNDdEdVRPNHpx?=
 =?utf-8?B?ZWx0SmNpRHhpNlU3N0RDOG9HenJKRDVUcG1FcHpkTHNjTCs0WWNvMG94dzds?=
 =?utf-8?B?S0IzT1RBMjF0V1JsZTMyaS9vUGZ5azNBRVNVcVBmVEV6M1gzWjk2bmpOUCty?=
 =?utf-8?B?aVhrWU5aRG5UVE5LcTBVU0VtL0lvVzBpNUFteC9WZGVmNzZseGVkS0plVDdH?=
 =?utf-8?B?UFhtME1CVXcvM1FBVXdVYStITzBvYzlQcDhSQzRpT01UWUY0NWIzbGQybGtY?=
 =?utf-8?B?OGtYUkRtTUxxTkFXT3hSTmR0enpXZm9hZDJGYVZVMXNaRnM1cjNpQnpoR21p?=
 =?utf-8?B?WDJKVjdkVGZFbWpUL205RnAzS0xDcXQ4OEJzTnovNFQyemllZ01TRCttT29I?=
 =?utf-8?B?RzNBRmFCV2J4WlFneEtmRVBUTlRmamNIakVKL3hUWHI0VGpOZXRXKzJKa3M0?=
 =?utf-8?B?dWJLZStJRm5pTCtsR0pDdFRBdmR2SkpsVTdDbjNDcWcvYUlWY3RZUEdBRFFi?=
 =?utf-8?B?RVpHM3dYWVVQaHY0RW9EOU1tVmZaVnVzUXk5Z3dHWUhPaEViMGE1K2JIaEpD?=
 =?utf-8?B?MVFOS3JLMVhLcVFuMWdpdTJIY1hFT3Baa09EVDNNVnEwcDg3dHFpTGxzK2dU?=
 =?utf-8?B?SGVkM1FRcmp1V3NweW5iZUptanZxRVpiMUtGdUN2aDh5RXRGanhZRXNFS0Vq?=
 =?utf-8?B?TytxcGJ3cmhuSG9mUE1uWUt5UWJ5N3JWczBlV1poQXl5b3cxczYzZWtnbitl?=
 =?utf-8?B?cDdpU3hTVytkbnV3MUtmUXdmR1Y5VjVrNmNLclNJczdOekY3ZGF0bHpTaWEz?=
 =?utf-8?B?WWRlZ0tBYTBLL1VHSnlQUWVMN3d2TG5oMEgvVUZtT3lLb3NGWVlWMUhFa2o5?=
 =?utf-8?B?c0E5N1lHZFg5Z2h5S1lBTit2NFRvUFc3eXI4aDRINWQ1WU5QZmhrTm0rN29l?=
 =?utf-8?B?THpqOWRmTU1uNnlWelZ4NmRmeGhmSVZQT1ZNTEhTSklGTFZ5SFoxWFRyM2pi?=
 =?utf-8?B?dlkwZHhmWmw1L0daR0xMR1N6eDVQRzAyTlNoTGZHSXRyTzVNQzNyWnVyQ01L?=
 =?utf-8?B?UWREQy8zWXZ2aCsySDdiSkF3dm8yN29MTngrOFJGSlo0emhoeTVFaGVjSDRu?=
 =?utf-8?B?MVVUVEFPcThVYUNUYkxIakZRWno4NloraThjYVJ1MFUyUkNoV0hBVlpOSUpL?=
 =?utf-8?B?Y3d3QUxkMGZiazU3M0tkaGhmRlorRE9uNitiUUp4Zjc2VHQza0NEMDIzemI0?=
 =?utf-8?Q?t4u+tnOZrDMH3/D5ibSVsqyQ+2G9jC76Io?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:18:20.5709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec2c1ad-569f-4e03-3fc4-08d8b8d1eb39
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyj/gmrZ4luxHiiBr6c2Lo/HUi85Om4V7Pe5oH/IXiozOEF9wKTrIOV59e7mVJs8FGch2VNNV60XS5QTk5ffkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2768
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:36 PM, Sean Christopherson wrote:
> Add a reverse-CPUID entry for the memory encryption word, 0x8000001F.EAX,
> and use it to override the supported CPUID flags reported to userspace.
> Masking the reported CPUID flags avoids over-reporting KVM support, e.g.
> without the mask a SEV-SNP capable CPU may incorrectly advertise SNP
> support to userspace.
>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 ++
>  arch/x86/kvm/cpuid.h | 1 +
>  2 files changed, 3 insertions(+)

thanks

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 13036cf0b912..b7618cdd06b5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -855,6 +855,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	case 0x8000001F:
>  		if (!boot_cpu_has(X86_FEATURE_SEV))
>  			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +		else
> +			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
>  		break;
>  	/*Add support for Centaur's CPUID instruction*/
>  	case 0xC0000000:
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index dc921d76e42e..8b6fc9bde248 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -63,6 +63,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
>  	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
>  	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
>  	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
> +	[CPUID_8000_001F_EAX] = {0x8000001f, 1, CPUID_EAX},
>  };
>  
>  /*
