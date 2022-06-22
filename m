Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F58554F5D
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357852AbiFVPdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 11:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiFVPdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 11:33:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20629.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D4E13F12
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 08:33:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjvXX6uiv7t1q4aAYdeFTsNwD1hJzRtUXxX9/34b78DU9gHRKGuBGlFfCqXvV7fp75yhV+ynA4zdI0FQdInHrXnajVrwsvjvJQ5fsMxSl0HxdT9SmjFhDXRWaRzNXGkf/zXcr9/kCSDWyphOfydMDCCV4FCqDmjI730coHCAt9lSB7ZJ1Htxgd7lemN0ZGwG2qJgcHfX4e79Od2Tn03vRkBo2RdHb+xLcB7Leja8Xm0UaGhLfTdsT2aNhwZhqXxQjC9ty6CdYGkBkHWxov2eVm7/2+bfS3DYbksWtMjpbo164ev/00Lt9dWg8X2lOqr3MRB58jY7pGPIOwSWGqmkDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWWBebFlbCh0YOPLzjXytTElBl+URwN19n2TcEtP8uI=;
 b=PNuTpg8znJea0T19j2hyQj8Mrhn73akIFRtJ1P5g4C6kv9fCF53d/DRxc5Z6F6NWqINqYK7cep6zVvz1AG9rI1pMxp8CKYUcXsufrxqxpIB0zmDL28pY96m6imqH3lj0mH4EWMSx/EEvsEzpvnv/I2pv9dPwXPyAG9GG8fkKPE53TTMRoUTNZI5Kxnxdg3xff5X1rjLLgWW26gWptZvXw/CyWsPMtKwcZfftJMBlGQhfgKEPx769e0T6osqayRPiwqe9B3fprU1kfIlWIW08wWQyVpHk+9ivNAkt8Dhe8m+7XQBlkX6Z0BhSnbP/aZirrjYPMBRwdo82g7p66AuPdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWWBebFlbCh0YOPLzjXytTElBl+URwN19n2TcEtP8uI=;
 b=BLd77Wbd7TPhQRJuqKIsE987T34hdweAzdhUv68z2undqyN9wQd+Y5RXpvPi36h0i4yY9T92PJiZsEPOErUTAyLHHQynlOY6QA3kbFh0aB/2FvMad566Or9ZJudZCBWH07b+M4E2nXppENLLGYA3o+jC+btyCxFdWDV86Xl/ODE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 DM6PR12MB2841.namprd12.prod.outlook.com (2603:10b6:5:49::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.18; Wed, 22 Jun 2022 15:32:59 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::bdcc:775:f274:7f12]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::bdcc:775:f274:7f12%4]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 15:32:59 +0000
Message-ID: <aed29a6c-5e59-d924-f3ed-a3cef91aac79@amd.com>
Date:   Wed, 22 Jun 2022 21:02:50 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH v4 4/8] x86: Improve set_mmu_range() to
 implement npt
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <20220428070851.21985-5-manali.shukla@amd.com> <YqpyC1HmsFBSXedh@google.com>
 <YqpzjMY+w5MZfb81@google.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <YqpzjMY+w5MZfb81@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::18) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1788fdf-9cc9-42da-1b59-08da54647cc8
X-MS-TrafficTypeDiagnostic: DM6PR12MB2841:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2841E95E44121FAFBED115BEFDB29@DM6PR12MB2841.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHN9Hk6jeF1wjSZM0KBko/GpEZqVSDhc5cehzerRisHm/OFNuA8APKhPoap25bYMl1k1+5B7IPTfY45/r0xOFhF8sD2uxbnPuCRFYCrLIA+RXfbYEM3b4EH/pBj03j1Ids3SEQvrztkYj9R8nx/SYlGQ5M+iPxdTA3lpCPNil1yaYFSmSmog7ueMmBj0ssLqS9Jlzo9yM3SHu84MoDBlMqFtxbC/rfsiDwcagKj+1LQwl/b2OKkz8SGqTjYmU3fNvS3EbqSvETunDL1kwX0US+Rfi45S/O1O3QlLXHxPfyWcY3GubYj5nYYCmZez0hTtCFzY0KWA8P9hOz6DR3mhfKtbLPWJWAWq1MWSg45py0GNPezQwE8wK4NqS7kVMGE6gD8ZkUjJQsVbQVsdV5eXnvL7zb9LFX5CZUw5X0sn0avuQQDW75c+0h9KiZWQVWstYSgTz8Dc5ayenv80uRMj0Rt56vRXnv6rBo5m+RX0MPkJWEyyX4V7zFTyOOnnE/PMCEDj1zhGBW0ddTV8umvezpn7nGZkkF/AvgA/JQHZW/meT1j+3g+0G/RXgNfQyVasfDFNBAh4vjV4l3A6JCi9YmFqp4kkjYAeQ8LruIbpvnBETASu4EX7Bh3kVSzfCCaf3+wLsUBdavKSIJn4nCcmdtmBiGPtvZgkIPHDS9SnvReLDOgAUbr+u93ASRPvq2VrOlApXOFoViCoJovlfeXA7r28xfOYGrnNfK77tyuN+nH39Pz/z/G6KMbIqVK3Bpg1SvrXUaxSWPBqEjXmC16z48n3kGbN2EVPRkO+2GcCo20=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(5660300002)(478600001)(36756003)(6486002)(8936002)(41300700001)(83380400001)(186003)(38100700002)(2616005)(66476007)(6916009)(4326008)(53546011)(26005)(6506007)(31696002)(2906002)(316002)(6512007)(31686004)(6666004)(66556008)(8676002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWFrNnJyRTZaWXlBZ1VIWG5ya0VpN3NpanlON0N4blc5dEVzRThhYUFBWTE2?=
 =?utf-8?B?SDJyQmFtbjZ4cFV2M1BYcVJMQnB5N1A4TXpSbEtSWC9JMzBiR2lTYndkY1pR?=
 =?utf-8?B?WjdwV3hzMG5lRGlzWXlYSFlXaTRYWnduWkNhbU1XQm5RWDhBeDRSV3ZaQ2dq?=
 =?utf-8?B?V2tHdzJEVG04V2lUT3g3WC9ZQVFJejczMGhaY2lnQWszTEJMbkdLQUhxRTl0?=
 =?utf-8?B?dWlnaUcremprV01JbUliem9hMzRrdXh1dGFtK0dWMHRwVFJOTmFybUcvajNq?=
 =?utf-8?B?dGoxSEV5U09uYjcxZFZ1eW9tVTY1V1ZaR3JMSC9VWFNpNStpcGlHUndoZ1Y1?=
 =?utf-8?B?SjJFR21XdmtuK2RxWGZySjFvaGpnY3pvVmRMbXB2bUhENW1QR05yZWVEejNW?=
 =?utf-8?B?ZkVvZTEyaHB1RkxETk0xc0MwYmllTVJ0YktqaUNMM1ZULy9QUnJqdDU3dUdY?=
 =?utf-8?B?dUZSOW5OWEpLMmxJYm93bksweVp0ZHlablo0WFptVUxyY0RiWVFLYUIzWnEv?=
 =?utf-8?B?RW1wcE9xekRJbkplRW9kaTVTcmw0STNDejdnWndwUTVwcHFGTDBxbWZDL1F5?=
 =?utf-8?B?dFhZdmwyVm5GZWhwdnNDcldsd2lwR3MrcGVhOE5TQVp3alM4dWFYaU5UUVd2?=
 =?utf-8?B?Qkl1RlpXQ3EyeUlIcjBUNjg5cTRhcFN1cFVXbngxSzlKYlUyTXFpaTZhN09a?=
 =?utf-8?B?aVl3R3VkaFRCVTgrbm82Yi9VVWo3aXg1UVZ1bU9JSHNCOURVS29uQm1jTGpt?=
 =?utf-8?B?TnEwMnBxMGFINlVHQVhTbGVIdkhyMFNydzNCN2Ric2NPWXc4dEF5MFRZdGdl?=
 =?utf-8?B?MnlySkV5UHRKb296ZWMxZ2RxK0hKbjRScG1ubkpPeFVDck53OFZTS1pGTmxF?=
 =?utf-8?B?WXhHN3pQSmgzS1pkemxGYnI5NVZCc25xQ2p2czltMzNTamp6R04vZDNiWGdh?=
 =?utf-8?B?c2pnMk9iNHdLL20rQ3I3b2o4UDBQQVR5OVkwZjNRRUlnVUF6Z3dQWU5lNlNQ?=
 =?utf-8?B?cTZabzBVZjBDSjRWQ3B0ZkJmUUpyK0kwai9saE1pbGQya3lCdHhxdTlpR0pw?=
 =?utf-8?B?QVcyU0ZaMW9pY21RM1JWVVVReW9DdTFZRHZaWVl2YXBtemdyd2lNMnA2azRr?=
 =?utf-8?B?dVdXa3RFTGp5QmpOdkFFaXJKc2xxcDIyenJ5OW5hbzhzc0lNRytVK2h4cjNW?=
 =?utf-8?B?TlpNMlpKcGtwWEFLSnNsNkZhZ0hPbDNLd1RqQy9PT1ZNN3drekxra2E4c0xR?=
 =?utf-8?B?a2tMYVQ2WmtyUVVmVkw2bHoxSXRPdFgyTzFIU2FiU3lMWWpkL2x0SE1abVB1?=
 =?utf-8?B?Umt6eE5WQkpUTC9ja0NEa2dBa3ZhajRTRTBaV1VUclBlYU52SzJFNTFUNjBo?=
 =?utf-8?B?azRHamduQ01lZXlRWHZqaXBld2lwMjVEUGc4d01LalJFeUNkS3J5Q0U0TW9z?=
 =?utf-8?B?a3pNZXBnVmwvQVlGTHZkMy9WUExORlFDN2k4ZllzT21NQVdzcmtYcngzeHRU?=
 =?utf-8?B?V2RyeFppNzdZTVR2UjlKcnhNU2x5SzV4RDV3UHlVRVhXTTgxdDJQMHdiSzZj?=
 =?utf-8?B?VkpBZVh6N1B2dkw0bTFtYkprQWlSV3NqR1QrV01SUVZFVUNkcndjcTBMVVh5?=
 =?utf-8?B?ZXJpVDlJbi9kVFhzZ0M2bVRKMnY4R3R1Q3V4blNsRUY1QnBNU3JVUjFoVTEz?=
 =?utf-8?B?M2hEbnIybVloSGgzem5KeXFwQXFUbDRmWTV6SUpJMXFQRkpyQjcyWXF4RDZ0?=
 =?utf-8?B?endTeEt4K3JKZVdoNERGK1BtVlNzSmt6Ri9CVzgwbm5aRTVjempiZ0JTRk9N?=
 =?utf-8?B?ZkRkMW9BVXV6cG9aaHNWbDk5Z2E5VE84cGdUSGpwa2IyK3cwTHdVNndzVDht?=
 =?utf-8?B?MUxsekN4bExUbTNsQnJsT3FWeDdPZXU3RjNUZ0FqU0NxenR2cnVqbkFLcmoy?=
 =?utf-8?B?K25hYzE3aFo2dVlEYUNuK01nWjQ4VGszRnpka0hycUlZbFlSNEUrYU51bUtG?=
 =?utf-8?B?b2Z2OXR0ZkJrUjhqck1QU3NUeGdWSWNqZ3RQNit0eDdZSGFTZngxUm5hd0VC?=
 =?utf-8?B?Z1J3STJ5bExRMEhPRmRHZDl6MzAzZ0dNWVZjKzhzT3ZKN3dzY3hBaEkxUG5k?=
 =?utf-8?B?cjBlTzJMWVZuNU01SkVJUEJBeWYwb25wZzVoeGV2eHpiREttMkhacEthSkxo?=
 =?utf-8?B?YXFJamxPcFYrUnBFQ0JLNVlRdUhCVXM0bXhkRHFCeWhNK2toYzR0b1hzcjBn?=
 =?utf-8?B?cXVmMkd1aFo2aGorUURDR3h3eXNtaFhlblY2a2JJQm92MUcyNkp4blNjQzFE?=
 =?utf-8?B?UmpjMWE2UW1hUVEwMGgvVzRjRmhSWjU3ODV1M3cvcDd1TmQwbnJWdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1788fdf-9cc9-42da-1b59-08da54647cc8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 15:32:59.6578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BUV3uGmnUkkEBdTIbH6OaGeiXw3epTNTGgjOQ5wQZYkckFLr6f6IyumxMTzDz6IZDrj5XJIQ7he0tmAcdIUjng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2841
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/16/2022 5:34 AM, Sean Christopherson wrote:
> On Wed, Jun 15, 2022, Sean Christopherson wrote:
>> On Thu, Apr 28, 2022, Manali Shukla wrote:
>>> +void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool nested_mmu)
>>>  {
>>>  	u64 max = (u64)len + (u64)start;
>>>  	u64 phys = start;
>>>  
>>> -	while (phys + LARGE_PAGE_SIZE <= max) {
>>> -		install_large_page(cr3, phys, (void *)(ulong)phys);
>>> -		phys += LARGE_PAGE_SIZE;
>>> -	}
>>> -	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
>>> +        if (nested_mmu == false) {
>>> +                while (phys + LARGE_PAGE_SIZE <= max) {
>>> +                        install_large_page(cr3, phys, (void *)(ulong)phys);
>>> +		        phys += LARGE_PAGE_SIZE;
>>> +	        }
>>> +	        install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
>>> +        } else {
>>> +                set_pte_opt_mask();
>>> +                install_pages(cr3, phys, len, (void *)(ulong)phys);
>>> +                reset_pte_opt_mask();
>>> +        }
>>
>> Why can't a nested_mmu use large pages?
> 
> Oh, duh, you're just preserving the existing functionality.
> 
> I dislike bool params, but I also don't see a better option at this time.  To make
> it slightly less evil, add a wrapper so that the use and bool are closer together.
> And then the callers don't need to be updated.
> 
> void __setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool use_hugepages);
> 
> static inline void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len)
> {
> 	__setup_mmu_range(cr3, start, len, true);
> }
> 
> 
> And if you name it use_hugepages, then you can do:
> 
> void __setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool nested_mmu)
> {
>         u64 orig_opt_mask = pte_opt_mask;
> 	u64 max = (u64)len + (u64)start;
> 	u64 phys = start;
> 
> 	/* comment goes here. */
> 	pte_opt_mask |= PT_USER_MASK;
> 
>         if (use_hugepages) {
>                 while (phys + LARGE_PAGE_SIZE <= max) {
>                         install_large_page(cr3, phys, (void *)(ulong)phys);
> 		        phys += LARGE_PAGE_SIZE;
> 	        }
> 	}
> 	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
> 
> 	pte_opt_mask = orig_opt_mask;
> }

Hi Sean,

Thank you so much for reviewing my changes.

RSVD bit test case will start failing with above implementation as we will be setting PT_USER_MASK bit for all host PTEs (in order to toggle CR4.SMEP) which will defeat one of the purpose of this patch. 

Right now, pte_opt_mask value which is set from setup_vm(), is overwritten in setup_mmu_range() for all the conditions.
How about setting PT_USER_MASK only for nested mmu in setup_mmu_range()?  It will retain the same value of pte_opt_mask which is set from setup_vm() in all the other cases.


#define IS_NESTED_MMU 1ULL
#define USE_HUGEPAGES 2ULL

void __setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, unsigned long mmu_flags) {
        u64 orig_opt_mask = pte_opt_mask;
        u64 max = (u64)len + (u64)start;
        u64 phys = start;

        /* Allocate 4k pages only for nested page table, PT_USER_MASK needs to
         * be enabled for nested page.
         */
        if (mmu_flags & IS_NESTED_MMU)
                pte_opt_mask |= PT_USER_MASK;

        if (mmu_flags & USE_HUGEPAGES) {
                while (phys + LARGE_PAGE_SIZE <= max) {
                        install_large_page(cr3, phys, (void *)(ulong)phys);
                        phys += LARGE_PAGE_SIZE;
                }
        }
        install_pages(cr3, phys, max - phys, (void *)(ulong)phys);

        pte_opt_mask = orig_opt_mask;
}

static inline void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len) {
        __setup_mmu_range(cr3, start, len, USE_HUGEPAGES);
}

Thank you,
Manali
