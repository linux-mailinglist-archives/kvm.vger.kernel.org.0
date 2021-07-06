Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9FE3BDDB9
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 21:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhGFTHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 15:07:01 -0400
Received: from mail-mw2nam08on2071.outbound.protection.outlook.com ([40.107.101.71]:9729
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230071AbhGFTG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 15:06:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMzxSqjQoBO7yybT9tlNrMUwHXqMXRKxPBGidQthFkeGkrLzY8b1+LGiyq+jkZpRPYMgHRhW06DM/ZH5rYNDHT4y3ZxPjXmG8pFUHFVD4XWtYCDBPztiXTzW419SuZXH214YvU27XUpgcDTvJKWEDecByxuaYMV3erjqx+CDc+G1YJsurLSXFws3rdwBLB3P8YXuwev7kr5K97Jd80Lcp2u4Xroo8BmeWluGcmC8lUHfYJl5vsO+xgSwIW5v4S5D9UMlwbXKArzFDlLxD0DXtsNHotB3kjH8LG745gcp2iXqc5tSrkfWuQspltgjkwafE41n6TtcOdy52SB2yp/BxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TsbAg6ylntVDmu1M5ogc3uw24A55ou5WueLXuQ8CIpQ=;
 b=OWGOZHVMFBl8pnUSXFObWEAh9qW1696wXg44swaMgIk6mwhlpx8o+KiiRfeegksPRw2pWipvGMVAWBrlQHGVUGgZlK0dTLxLYRTmxmZlfuruHUzJ+qxOMTd4RKvDrxs1yFKI+P7ux8FoEfUe9T6eX6IEAGKO4tmd6uTjRGvUXyhi7GJBtfVge3u/A17MjWqqM9R5tX8bRy5nkZWzC1a+tGrL7PWEFyI5K83SO9b0vrNa8131k9e983xP/Zydy37pO04Mbg1Q1CHCExPU6GjHD2evuRb6HHX29FShLJCud1hg23noBFPXzcIQdW0/xbhnBA2fhkXKwB8DIlHEGuTnZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TsbAg6ylntVDmu1M5ogc3uw24A55ou5WueLXuQ8CIpQ=;
 b=GPRwRx7rDMt2bLTe4raE4kaMaEk+gGwGJW770CONOvlwANU3T+80x1EtS7WvBupoDaCPsYsEgOZQ2ifeKgQt7BzegMJY2DzBJGRrGb8ybOn7S9Pf8PDovbbi2JxFkLxIemgz7meUKrBe0/tJLCf/UqarIx79tVOf4EPdKg99Xmc=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB2711.namprd12.prod.outlook.com (2603:10b6:a03:63::10)
 by BY5PR12MB4083.namprd12.prod.outlook.com (2603:10b6:a03:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.33; Tue, 6 Jul
 2021 19:04:18 +0000
Received: from BYAPR12MB2711.namprd12.prod.outlook.com
 ([fe80::40e3:aade:9549:4bed]) by BYAPR12MB2711.namprd12.prod.outlook.com
 ([fe80::40e3:aade:9549:4bed%7]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 19:04:18 +0000
Cc:     brijesh.singh@amd.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 28/69] KVM: Add per-VM flag to mark read-only
 memory as unsupported
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <1eb584469b41775380ab0a5a5d31a64e344b1b95.1625186503.git.isaku.yamahata@intel.com>
 <8c57204e-385e-1f54-cb15-760e174d122e@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <1a8bfc55-e0f2-dbba-c5a7-48e648c376ef@amd.com>
Date:   Tue, 6 Jul 2021 14:04:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <8c57204e-385e-1f54-cb15-760e174d122e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0014.namprd08.prod.outlook.com
 (2603:10b6:803:29::24) To BYAPR12MB2711.namprd12.prod.outlook.com
 (2603:10b6:a03:63::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Tue, 6 Jul 2021 19:04:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40514d15-01d2-411d-e1cb-08d940b0db35
X-MS-TrafficTypeDiagnostic: BY5PR12MB4083:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB40834ECBC2EB3BEEB823F63FE51B9@BY5PR12MB4083.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujbFuuMV27OPaMEZAphDdgj1YvSNz37LcWtuMJZAMdrLnBv4AwFjLsbfjTr3Ic7AabI2oCsazkorNxN/Ij3LBmhZnuFad6NTbsVy47bHNP9+Dl0wT9HsXNK5LaTVxjEMXNxzxws7aIeJkLno/aN4T+CiqY+dnr1wmwNa440EKiN93DzNUfwndgNnVUm76AKxJivIMUxpMFQUdYkdfpzqQ6fm7jTYtbC+X1RCKmgfXBilUppsuO8E2iFpKDDMTIhjmgnwkBqtEfuxUfoSTsHIe7z2YHUfIuqPtjz0Uh5Iqd2r4Qpqvh0o0vTq8CTw+3geKZtlYEpGVpEs4mGUFLfnsiW0h1DzCzCf6xtMEElG/cfMOnWdZP8QquiKZFDcp+dk/Rwz6WH+bbEiATD+dcHrXuGIOMvmvNQcm2fspJ+9hnUH1+7hzSdFN+nT6xqHXC9pJxN99PPeG3Ru3r3pR3zTfcIqtmd6SYH+Cqa1bjlU/arQaQr7heBBambEspDS+EhyMWcigPOsIlA4oYYdAMaDfHtilbx8vzkJRcsOYNtV0lLyAPtsNL+XNZWlVqOob9AP1cQD74hZ29fq/NrfRCXQpolrGTe40Yf4WqGigzgsxYBojW1PqdMCQD1SIDXwpbvz+HEkwKL2C3/9ipIibDdVBXxuiqk888Qn+betSPz2V+h8XKQT0DpNNNNJZmR4KhdbykJjjWiZY/uCHK30uurbxJZDamkRuGk9ULic/tu5AS8tPE42D7Jx+RZjPaoSgNft60t2q0CYT3VdvUbmPT9L08n0o6doeYtUOIBpnSDZP3Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2711.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(8936002)(478600001)(38100700002)(6666004)(83380400001)(5660300002)(4326008)(316002)(38350700002)(26005)(186003)(2616005)(956004)(31696002)(66556008)(7416002)(44832011)(53546011)(66946007)(36756003)(6486002)(86362001)(31686004)(110136005)(921005)(52116002)(2906002)(66476007)(8676002)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2FsQ3B4cUVDQmxiTzRlSDMvelovYTRhTHVKV0RacWVYaHlwZE1QUHlqTmxv?=
 =?utf-8?B?c0ZCV1QwWXFEU2I1WFVTZUNFNmhFZzk0RDVtOXB0cnVkUnhWdHk4dFRnVGFU?=
 =?utf-8?B?ay9sWmVBMFRWTmpkT2RZaThYZ2g2UWdlMEorTkNmNWZGb0E1Wk9kSHowQUw3?=
 =?utf-8?B?eFg2ZTdQTVZENjNMelMvSUVreWlBUVJDMm5FajF2eDlUem4yRjFWR0VrejhE?=
 =?utf-8?B?QzFPRHAyNVpxSUdaRGlrNGtmOW9XMFljZXo1QTd6VFJ1bjhEUTY3am8reVN6?=
 =?utf-8?B?RitYclVya0JLQXEyQ1RlZEVGOUlPZEkzMW13QkF2TnFaNWtBcDllczlPZTdG?=
 =?utf-8?B?V0xBSFVJL1NtcHhWMUJZZXlyNGtnVlZqN0VPMVY0Mi85YUpvN3ZDdzYzQ0lR?=
 =?utf-8?B?TmFNQjBwa1hFY1RQV0RNSm1HVmxMeVVqZUZVK2M0TWVxY0oxejdPVVRSREtk?=
 =?utf-8?B?d0VzcTNrVW9ENjIybHM3bmZNK09idEtVSWVBSmlySVZzUUJPcnFnb2g5NUth?=
 =?utf-8?B?WFBQY2hsRWpoUUxTL3dxcW9Ib0ZOODQ0RnFzYnRSa0o1MXRYUnJwUU40QXFO?=
 =?utf-8?B?OEpaZlp1aXdSYmgwTFdydmplRzFEYlZ5dlFnMEloK25rcmxUN3UvY0MvOGdS?=
 =?utf-8?B?S3V6UUZyb3cyUUJZMUprZWdLOWR4aExhOS92VzlmVU5MdmZOdHNNMzR5UFJo?=
 =?utf-8?B?NGdsZWpuc0N3N3cyaFh1b2E5UERpZEJJekZNdG9kMW4wY3BKdXdHTTNYbXVN?=
 =?utf-8?B?RUpFNXFTYVdJbW9uSFJ5OFB0TEJkUWF2dkN0YnZ5UXpNckZWb3kyaHdWTGZt?=
 =?utf-8?B?eUdrZFZvYklsdE9ZM0NFV0lZbzRvOXRyTk9KWFIzcUZOVE5JTW55UEFiWC9y?=
 =?utf-8?B?TG5pWnJQV0RXOFo2WC8waEJPQWNNOG1Md2hwZ2NaK0lTZWczQVdBc1MzaUlt?=
 =?utf-8?B?aG5IL05mQzRLdlEvSEVQOEUvYVFScithKzdja2p3bGVzYjAxckNxenU5MFI5?=
 =?utf-8?B?YkN0U0RITWdpeGI4VjRkYU9wdEs4UWF2blE1bVJvZUdZTHFzNGs4aXhvU3dN?=
 =?utf-8?B?ZmpNdSttZ0p4YnM3NFVXYXBiaU5aNlArZ3owUlBGQmsrL0VtY0ZsTlZndlp1?=
 =?utf-8?B?V1AzQXJYdGE1SkVIMjl3SzRQeXo4Q1pZWStrK3BIalBYRENmSmFBajlzcVo3?=
 =?utf-8?B?ZTgwMi90cHdpN0dEOTk3bzJEeEIwVU00ZS9Fbk1SV3FGNFZNbERBa2hHVzRa?=
 =?utf-8?B?TVUwbk54aFMvUWVPREVYeStYQTdSSTBRNHpHVFl0OTNRRHg5eVhMMUtkV3RN?=
 =?utf-8?B?SU5aYnFocmN2eEhhWTg3WFFiYlYwSjhLbW9VY29YdmlYMGZMcEhXTjBCZi9n?=
 =?utf-8?B?aFkzRDh1Sm01Z09tQzVqN1g0ckhFMFEwSUIwRThVL0dJV3ZvdXFpR0hQWEpY?=
 =?utf-8?B?NWFCcWpDZ3Z3VGxSMkRNWXBnV2RjRzk3SWtJVWVCWXdmNFo3c25ib3g0Mm43?=
 =?utf-8?B?NWxRdnNqbUU5Uk5qM1ZQN3Ira3lFTEIzYWJMK2pYcXpDaVJsTyt5amxEQU5G?=
 =?utf-8?B?Z0JrMklnU2Vka05ieGtqOWMrN283VCthdHlVVGdWeXVIYVRPdmdsUWVuYitH?=
 =?utf-8?B?S1FNcDBSZlcwa21NRjl3a2h2ZU8yWnZWTDVzeFIwemViNmx4SWtRdTd4YWJp?=
 =?utf-8?B?ZkFDaUovOTlRbWhtQUFRR05YdWhjQTNrVGVjQmZsQjV2d2xKVjExU3VzZlY2?=
 =?utf-8?Q?9jClhEV7InFZrpS2um8jLCQNe9F90thUu9zGG+2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40514d15-01d2-411d-e1cb-08d940b0db35
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2711.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 19:04:18.8027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: As3vrJsecNp3t3Y78sTgp6RLrck7P/WUFK2e4pkv4E4RPpyvtP05OQwTGiwwU+bHjD9HKwW4njMSrBBTyFjBgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/6/21 9:03 AM, Paolo Bonzini wrote:
> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Add a flag for TDX to flag RO memory as unsupported and propagate it to
>> KVM_MEM_READONLY to allow reporting RO memory as unsupported on a per-VM
>> basis.  TDX1 doesn't expose permission bits to the VMM in the SEPT
>> tables, i.e. doesn't support read-only private memory.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>   arch/x86/kvm/x86.c       | 4 +++-
>>   include/linux/kvm_host.h | 4 ++++
>>   virt/kvm/kvm_main.c      | 8 +++++---
>>   3 files changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index cd9407982366..87212d7563ae 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3897,7 +3897,6 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>> *kvm, long ext)
>>       case KVM_CAP_ASYNC_PF_INT:
>>       case KVM_CAP_GET_TSC_KHZ:
>>       case KVM_CAP_KVMCLOCK_CTRL:
>> -    case KVM_CAP_READONLY_MEM:
>>       case KVM_CAP_HYPERV_TIME:
>>       case KVM_CAP_IOAPIC_POLARITY_IGNORED:
>>       case KVM_CAP_TSC_DEADLINE_TIMER:
>> @@ -4009,6 +4008,9 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>> *kvm, long ext)
>>           if (static_call(kvm_x86_is_vm_type_supported)(KVM_X86_TDX_VM))
>>               r |= BIT(KVM_X86_TDX_VM);
>>           break;
>> +    case KVM_CAP_READONLY_MEM:
>> +        r = kvm && kvm->readonly_mem_unsupported ? 0 : 1;
>> +        break;
>>       default:
>>           break;
>>       }
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index ddd4d0f68cdf..7ee7104b4b59 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -597,6 +597,10 @@ struct kvm {
>>       unsigned int max_halt_poll_ns;
>>       u32 dirty_ring_size;
>> +#ifdef __KVM_HAVE_READONLY_MEM
>> +    bool readonly_mem_unsupported;
>> +#endif
>> +
>>       bool vm_bugged;
>>   };
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 52d40ea75749..63d0c2833913 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1258,12 +1258,14 @@ static void update_memslots(struct 
>> kvm_memslots *slots,
>>       }
>>   }
>> -static int check_memory_region_flags(const struct 
>> kvm_userspace_memory_region *mem)
>> +static int check_memory_region_flags(struct kvm *kvm,
>> +                     const struct kvm_userspace_memory_region *mem)
>>   {
>>       u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
>>   #ifdef __KVM_HAVE_READONLY_MEM
>> -    valid_flags |= KVM_MEM_READONLY;
>> +    if (!kvm->readonly_mem_unsupported)
>> +        valid_flags |= KVM_MEM_READONLY;
>>   #endif
>>       if (mem->flags & ~valid_flags)
>> @@ -1436,7 +1438,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>>       int as_id, id;
>>       int r;
>> -    r = check_memory_region_flags(mem);
>> +    r = check_memory_region_flags(kvm, mem);
>>       if (r)
>>           return r;
>>
> 
> For all these flags, which of these limitations will be common to SEV-ES 
> and SEV-SNP (ExtINT injection, MCE injection, changing TSC, read-only 
> memory, dirty logging)?  Would it make sense to use vm_type instead of 
> all of them?  I guess this also guides the choice of whether to use a 
> single vm-type for TDX and SEV-SNP or two.  Probably two is better, and 
> there can be static inline bool functions to derive the support flags 
> from the vm-type.
> 

The SEV-ES does not need any of these flags. However, with SEV-SNP, we 
may able use the ExtINT injection.

-Brijesh

