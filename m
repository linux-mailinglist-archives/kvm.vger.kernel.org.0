Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5B3E3C13
	for <lists+kvm@lfdr.de>; Sun,  8 Aug 2021 19:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhHHRty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 13:49:54 -0400
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:61472
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230201AbhHHRtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 13:49:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGXsqCCALNGuB2TRXOVOI8NKPZgC727rE/ADkaulXBBLpmDgzP9MBttTJKW/cz4kh1D/3itMwMl/tsVLAp8z7eZAH68YBKoYGbwZph5uCADeFxWRZK0jJlvRwOLQqERhvIbijv77G1QDzh2jOfSMqV8ObrU7v9T4pAnm8bUj3+i3euhyxx7OtgT7S0GA3nmqjFjAaML8lRCvxhtuIHzgAGaAuXTfbWbHo1EyVD+6ePy2CfvMFEIRpifxxZS5DeFcVgZ/lMnP8CYAFpp/5wHJ9APbWWadu7NGfuVCJ0UcpXF2MlY4TwvLmc0uPaILiZ428GWpWF/Nade2gJIV4u5m/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cTMtJaBhX7icUOCqoBdUJ0qQVM7rpqRYJgEaIC05Yk=;
 b=XzKoWcdCqIT0E+S8BZGuBaJMcIK6RS5XQzzUjlMUwXVktbRkjY6VuG5/eV7egEfQnY+A4r7Mq8vv+8qoTEydJOdclkx02bRcHqRquv0SHMGGQIUASTSYJ3fDstgYxOSVBxzSb+AtaYnSrQ3yfCS+B3O4Yi3Bq6Teh07G1ppftrZEw12/z0dCdnsIF6lfwaUzWG5802pFmvEeAvA46OMrt4SBNi5Zw7AskrhU98zkp1Yl9O5OReZ/nNoglIfFJN/rmwR6n4T5ykOdlTwkOVeHgsitIhfYIM8POqF9x9KOjg5xV0r8ufxc88Xq7EgW/6/YRbE+peZ0K6i0l5IoLAfuVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cTMtJaBhX7icUOCqoBdUJ0qQVM7rpqRYJgEaIC05Yk=;
 b=rldereBx8hhFbXI9iPHc1C6O+UyhWVd+BVqtakuNemMywafm8cPN2hTXayGn9Kqy36hG6XWH1J7Y+uvldK2uG3ITFQf5Af4I7tYIfFLakq08RAOJ3ZR3gfPelyT3Co/7fUCFHe2gBTBBoq/iG6OntExKWJEh/HgxI+0GeOc0qDY=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM6PR12MB3306.namprd12.prod.outlook.com (2603:10b6:5:186::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Sun, 8 Aug
 2021 17:49:30 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 17:49:30 +0000
Subject: Re: [PATCH v1 2/3] KVM: x86: Handle the case of 5-level shadow page
 table
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <20210805205504.2647362-1-wei.huang2@amd.com>
 <20210805205504.2647362-3-wei.huang2@amd.com> <YQ14RmuYxlAydmOu@google.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <60fe6735-9e0b-cd35-0660-a2bcafef2191@amd.com>
Date:   Sun, 8 Aug 2021 12:49:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YQ14RmuYxlAydmOu@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::29) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.10.87] (165.204.77.11) by SA9P223CA0024.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 17:49:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49cadd92-c101-4030-c7e8-08d95a94df94
X-MS-TrafficTypeDiagnostic: DM6PR12MB3306:
X-Microsoft-Antispam-PRVS: <DM6PR12MB330662D600616C979CCDD1A2CFF59@DM6PR12MB3306.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKc6DfJKBBzE/IPjf01tE2/z/lWcyj2clgQaejmLnbMrYj7yinZQVl3uy/XqoyRsvL7piDFPRW5ER+F9SEDd1TIKYMB86lv1rqjoLkYWioeWhTID2VJifUn7n2dbJj4/AzUTJFZr6FRWstC/9JMvzhb2tdhXpWf2P4UJFZ/tb0KBfootdDUwokb+e46+8fpnkbi3UneGmuIw86l6tr1us5HyTLzyPRJu3Y/LsZbNSR6wLDdvhz8obWuE1e9MJjl/46h/F8GK2ahMzVQN/M1rWzpvYldCbNbljP1uVyTJQcCfWr1YGzK+2NKhTXGQ976cerLawLMvNN8tk55cTTd1LfewijxQNHSg9KqTEEeqnJakuny4I4LlCm7mpzrqng4q0p3slH6xnDC7ViIEJV4YTA9yONOtGMH7Qv4nFFl99bGukLwKPduuGZt19oE4rBGgg9ptj9WdeBL0UmxcY//cpiNKCwbys4XWxeiO0ClAr971h4l9tbQszsYqaNU+S5a6nFz/mU1ba2JJOBBGfdqphe3nallM5Tqo+GhxPuWzm8nyLqrbuXwIdSD1XgVzWxNfx+7bCvuYKv+KDXzyf8u2Ku6KPykQEO1Q+YkX1G+WUHcFtbVse9YnRjy2EzPaT7POMgX9WXV4mJDaEIbLUshHvISvQeuDLWHGcF0Y6mcAsgs1tL/QfOhzI3VP7j7jAgZ+9x+ewlLV+E/J8m5e3udIb2fCfjbGrXKecJPr2FoEkwL3rUr+ojzpV+C3iP/sZ0CC+B82sm2MB/ZTbKVO63eh6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(53546011)(31686004)(186003)(5660300002)(316002)(8676002)(52116002)(8936002)(478600001)(26005)(6916009)(16576012)(83380400001)(2616005)(956004)(31696002)(86362001)(38100700002)(6486002)(38350700002)(36756003)(7416002)(66556008)(2906002)(66476007)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjFQbG12OE41ditWdWsyZm5aeHlTL05zbkJ5VGxiT2kxeFU3NzEycE03Nmlx?=
 =?utf-8?B?WkVpZVZHeGs3NnloaThzQzBqSTk3TWE3YkxRYUM3b2lzTVpjVjFVTDJOaUZT?=
 =?utf-8?B?c1hEbDl6RTZtNysrb00rRy8yTVc4WTgyS1RTNFRsZ2UzeC92MXhZVWF3bnJ2?=
 =?utf-8?B?dUtpdVh3Zkpxa3JUZG5vQWQrd3kzdXlXaHFWWi91eG40Y1ZtT2FnQStkSmpJ?=
 =?utf-8?B?bXk1Y1ZndDdxaDI5MVQ0Rm5HbGY2QURRRG9INmY5V2srYlk3NEpLWnljYTZl?=
 =?utf-8?B?RmtQTkc2bFpmSklYMzZzaXNPOW05dzcvOHpvUDhaZW40S0o4dHFuby9VWkp2?=
 =?utf-8?B?emhYN0lIOHNvcE9aOER6QmgwOFpId2dRWlV0S3V0dUxraVdkV2xGT0VQYmhk?=
 =?utf-8?B?aUZzd2tVaXhTbGhkSEV2RFMyUlY2QVR2TDQ0a1hjNFZSbmNuTGNjdUg4WHRN?=
 =?utf-8?B?dmkrS3NZdWNpc1dqU2FFQks4YjFBWHcvZGhIWDZNSlJLQXVxWEZBMHlFSGFS?=
 =?utf-8?B?RFpTRklkRUU2RzNwWmdaVFd2MFZIUkY1c0RoU0RPSlVYcGJNWVl3VGpxQ2xB?=
 =?utf-8?B?TlZjbVlzdXh0emUzMjhBUVNHTWQ4SlVaelpxeDB2dGt1VXBMV3J2WG9HY2JZ?=
 =?utf-8?B?UTU5UUNldWlTc25kbG03Z3A2WEltNGRvQlYxdUJXT05HYjNRSlF1djNmSFZl?=
 =?utf-8?B?NDBrZFpqbUZyU25OVHo0TFE2b1BrQmEwd3hjYmw0cmRhM1B1K1JtTDZSOGhQ?=
 =?utf-8?B?NTgyQWdwTG1jMTEvNjl2TmZ5TE5XUFhIQ2dQZW1tWjdPYmdZNldIdkFNSVZl?=
 =?utf-8?B?R3NYd3ZoTDc1MXp0dFNCUkpSZ2pxTEo4WFI0TWVkMlZRb1FYRnNWSEUxb0VN?=
 =?utf-8?B?UW1taFRVLzNaQnc1L05UMjhpNmE0ek1hb0h2NG0xcTZ1ZDgyb1pJQmszL3hB?=
 =?utf-8?B?eWpHY0VHeHlrZG93eXprVm9nS3B6UjI5RGZKWXVXdFB4Q0V2V0s1OUZ6cjI4?=
 =?utf-8?B?YVo4MnI5emVMWjFobitERkR6U1JzczAyRm5qMVlrQXQwOThJMCtzd2htWG5x?=
 =?utf-8?B?eW9tbFBmdUNhS2l2Z1VTY1NsNVNPeE41NVY4UnhjSW0yYlBZakVIRlRIcmNU?=
 =?utf-8?B?S2JUcDFWOUpnUW9TN21tNC9rZ1RLakExM2tTTzRtZlhBSk5HUjN3eVdDWVV0?=
 =?utf-8?B?aDNxdythT29jaGo1cldsb2ZscTZxekhYZ2R1VUhPYUcxSGRHR3dGNU1sdDE5?=
 =?utf-8?B?SjVtcU9uZ1E1VHBxT2dqOXNzenlXMUdBcG9kaEY4TGdOMWkwcFdRZnZZU0Ft?=
 =?utf-8?B?RGhHakN4ZmNMZUttODlkSzFPVTZreWhlVUhKZU5SSUV6T3ZPeVhGUE04VExx?=
 =?utf-8?B?dVovMVJ2M0lJRitKaUZzb256SVN0LzNnNG1vWW94QXJncmhXQjNxZlR2ckpF?=
 =?utf-8?B?V3BhM1FiQzdrL0lYTG0xRS8yMzMwYjd1bGU1NG9hY1k0OWNJa3o0K3ZxZWFP?=
 =?utf-8?B?V0Q1VUIxVm10ZlRwVDlZTFczVXdobDFFYVNDYkNlcDYrazRMa0NTY1BjajUw?=
 =?utf-8?B?ZGRzZXVHV3NiTEJ0NmtkSnJNMitUOVBIL2RSMGZlejFRTW9QYlgxT3l6Y0RP?=
 =?utf-8?B?L1VhazhaczRlN1FaNjlXMmlyNlVXd1Z5bGZRWHhFTTRJK1VqNk5VekRuVW5p?=
 =?utf-8?B?cUdWYVpaU3NJMU9oYWQ2MkVVQnJBNU1CdjZ5YVVLemdqTDAxYXViYndOM3M0?=
 =?utf-8?Q?5czbS29p48y31LWlYt3KucmkG0QvXLx+Mgq96J+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49cadd92-c101-4030-c7e8-08d95a94df94
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 17:49:30.5103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ntnCMbQLQMYfAlC1Er3WgDse4j7i8JD9sctjjSQKRIpOW2eA4N8qVbTcgJCrZHuj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3306
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/6/21 12:58 PM, Sean Christopherson wrote:
> On Thu, Aug 05, 2021, Wei Huang wrote:
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 44e4561e41f5..b162c3e530aa 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3428,7 +3428,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>>   	 * the shadow page table may be a PAE or a long mode page table.
>>   	 */
>>   	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
>> -	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
>> +	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
>>   		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
>>   
>>   		if (WARN_ON_ONCE(!mmu->pml4_root)) {
>> @@ -3454,11 +3454,17 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>>   				      PT32_ROOT_LEVEL, false);
>>   		mmu->pae_root[i] = root | pm_mask;
>>   	}
>> +	mmu->root_hpa = __pa(mmu->pae_root);
>>   
>> -	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
>> +	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
>> +		mmu->pml4_root[0] = mmu->root_hpa | pm_mask;
>>   		mmu->root_hpa = __pa(mmu->pml4_root);
>> -	else
>> -		mmu->root_hpa = __pa(mmu->pae_root);
>> +	}
>> +
>> +	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
>> +		mmu->pml5_root[0] = mmu->root_hpa | pm_mask;
>> +		mmu->root_hpa = __pa(mmu->pml5_root);
>> +	}
> 
> Ouch, the root_hpa chaining is subtle.  That's my fault :-)  I think it would be
> better to explicitly chain pae->pml4->pml5?  E.g.
> 
> 	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
> 		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
> 
> 		if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
> 			mmu->pml5_root[0] = __pa(mmu->pml4_root) | pm_mask;
> 			mmu->root_hpa = __pa(mmu->pml5_root);
> 		} else {
> 			mmu->root_hpa = __pa(mmu->pml4_root);
> 		}
> 	} else {
> 		mmu->root_hpa = __pa(mmu->pae_root);
> 	}
> 
> It'd require more churn if we get to 6-level paging, but that's a risk I'm willing
> to take ;-)
> 

Thanks for the review. This part of code is indeed subtle. The chaining 
trick will be easier to understand with a proper explanation. My 
proposal is to keep the original approach, but add more comments to this 
group of code.

       /* 
 

        * Depending on the shadow_root_level, build the root_hpa table 
by 

        * chaining either pml5->pml4->pae or pml4->pae. 
 

        */
       mmu->root_hpa = __pa(mmu->pae_root);
       if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
               mmu->pml4_root[0] = mmu->root_hpa | pm_mask;
               mmu->root_hpa = __pa(mmu->pml4_root);
       }
       if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
               mmu->pml5_root[0] = mmu->root_hpa | pm_mask;
               mmu->root_hpa = __pa(mmu->pml5_root);
       }

This code will be easy to extend for 6-level page table (if needed) in 
the future.

>>   
>>   set_root_pgd:
>>   	mmu->root_pgd = root_pgd;
>> @@ -3471,7 +3477,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>>   static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>>   {
>>   	struct kvm_mmu *mmu = vcpu->arch.mmu;
>> -	u64 *pml4_root, *pae_root;
>> +	u64 *pml5_root, *pml4_root, *pae_root;
>>   
>>   	/*
>>   	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
>> @@ -3487,17 +3493,18 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>>   	 * This mess only works with 4-level paging and needs to be updated to
>>   	 * work with 5-level paging.
>>   	 */
>> -	if (WARN_ON_ONCE(mmu->shadow_root_level != PT64_ROOT_4LEVEL))
>> +	if (WARN_ON_ONCE(mmu->shadow_root_level < PT64_ROOT_4LEVEL)) {
> 
> This is amusingly wrong.  The check above this is:
> 
> 	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
> 	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)  <--------
> 		return 0;
> 
> meaning this is dead code.  It should simply deleted.  If we reaaaaaly wanted to
> future proof the code, we could do:
> 
> 	if (WARN_ON_ONCE(mmu->shadow_root_level > PT64_ROOT_5LEVEL)
> 		return -EIO;
> 
> but at that point we're looking at a completely different architecture, so I don't
> think we need to be that paranoid :-)

You are right that this can be removed.

> 
>>   		return -EIO;
>> +	}
>>   
>> -	if (mmu->pae_root && mmu->pml4_root)
>> +	if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
>>   		return 0;
>>   
>>   	/*
>>   	 * The special roots should always be allocated in concert.  Yell and
>>   	 * bail if KVM ends up in a state where only one of the roots is valid.
>>   	 */
>> -	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root))
>> +	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root || mmu->pml5_root))
>>   		return -EIO;
>>   
>>   	/*
>> @@ -3506,18 +3513,30 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>>   	 */
>>   	pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>>   	if (!pae_root)
>> -		return -ENOMEM;
>> +		goto err_out;
> 
> Branching to the error handling here is silly, it's the first allocation.
> 
>>   
>>   	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>> -	if (!pml4_root) {
>> -		free_page((unsigned long)pae_root);
>> -		return -ENOMEM;
>> -	}
>> +	if (!pml4_root)
>> +		goto err_out;
>> +
>> +	pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> 
> This should be guarded by "mmu->shadow_root_level > PT64_ROOT_4LEVEL", there's no
> need to waste a page on PML5 if it can't exist.

Will do

> 
>> +	if (!pml5_root)
>> +		goto err_out;
>>   
>>   	mmu->pae_root = pae_root;
>>   	mmu->pml4_root = pml4_root;
>> +	mmu->pml5_root = pml5_root;
>>   
>>   	return 0;
>> +err_out:
>> +	if (pae_root)
>> +		free_page((unsigned long)pae_root);
>> +	if (pml4_root)
>> +		free_page((unsigned long)pml4_root);
>> +	if (pml5_root)
>> +		free_page((unsigned long)pml5_root);
> 
> This is flawed as failure to allocate pml4_root will consume an uninitialized
> pml5_root.  There's also no need to check for non-NULL values as free_page plays
> nice with NULL pointers.
> 
> If you drop the unnecessary goto for pae_root allocation failure, than this can
> become:
> 
> err_out:
> 	free_page((unsigned long)pml4_root);
> 	free_page((unsigned long)pae_root);
> 
> since pml4_root will be NULL if pml4_root allocation failures.  IMO that's
> unnecessarily clever though, and a more standard:
> 
> err_pml5:
> 	free_page((unsigned long)pml4_root);
> err_pml4:
> 	free_page((unsigned long)pae_root);
> 	return -ENOMEM;
> 
> would be far easier to read/maintain.
> 

I will take the advice for this part of code.

>> +
>> +	return -ENOMEM;
>>   }
>>   
>>   void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>> @@ -5320,6 +5339,7 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
>>   		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
>>   	free_page((unsigned long)mmu->pae_root);
>>   	free_page((unsigned long)mmu->pml4_root);
>> +	free_page((unsigned long)mmu->pml5_root);
>>   }
>>   
>>   static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>> -- 
>> 2.31.1
>>
