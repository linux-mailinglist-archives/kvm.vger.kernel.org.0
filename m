Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EC7738727
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 16:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjFUOgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 10:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjFUOgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 10:36:21 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182631994;
        Wed, 21 Jun 2023 07:36:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I41cazlYuU50Ib2jU58KDE5v7DyX832FhxCq7mtd8awiYVUXUXGR6x1Zg7tWPw4iv2d1NMYp9qfOJ/sMTe/VsR2j0QB2CyAvaxamI9EaUcf5LZeA0b8Gacc46/KKZNKW/dYB0mzCsrOmIrI5VlOwzSMF1Qed7/6TN43h7inuUaOFar+PqgPh0bMdXifKYKpSq6W9m3uSAHgh88dH4uJV8sOrZWULikTZgNp91CHy6SYLrGB8ZUxBuJgSIy8q1x/xmEMO/zR8aK5eM2LVzDe2gGBbyCIo6dKusaANHwlvZilyXzD+KE/2sR371R/37Uxd2uBH/qGVCjUzJbojr7PUSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQv0YXfw+z9HJvxE0W+JkjKX+6iIZo+p2m3etf40AFM=;
 b=oGDNFJ6v18xjPm4wtA4Z4pjvtGieXO5Lh5Q0fe00cNe9wrEHlv/WsZ6mhz5VQD+6Ih9y9q3KTFC+xrjGKxU8NJpmzyx0A5qKhvePKYxXhG4W1M+yXhx80kMr3k6RX0XsthRqkWlfSx+B4AL/sV4xi/u//4a2qztgnp686Ub/pg9ZUkUUp9RYAW4lBeIXCS+nt81kedHQSu7p+5e87pypm4dnBMQqpMy6avtIl9YN+n/SS5FH6cN9J811X5VTpCGleteBOxvQtqYHMqCIRrAO+yrXuM/ui2PYa1vVM9FCjHcx2EmRWUGu2xOWdAdMVFhXd3LoEPQ46Wm22xoxKkY4dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQv0YXfw+z9HJvxE0W+JkjKX+6iIZo+p2m3etf40AFM=;
 b=rgleG0H7HSdv6a4yMRPf+lG3ZeP6SbuN63/yGAa2ji6psOHEPf4ziY8PMyQ8PxH8be8hM1KUjB5BVr6hinRa8WSX6tVOk26/mzoCNj8r14qmYeP1iQT+1Fv2rKPYaNOz4S4F5pPeRAM2gExHJWEEB0clVf2jkRInJvdseJXf1rw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY5PR12MB6035.namprd12.prod.outlook.com (2603:10b6:930:2d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 14:36:14 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1629:622f:93d0:f72f]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1629:622f:93d0:f72f%7]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 14:36:13 +0000
Message-ID: <7e798ffa-da63-764f-0527-5226a3d8400b@amd.com>
Date:   Wed, 21 Jun 2023 09:36:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 07/51] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        liam.merwick@oracle.com, zhi.a.wang@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-8-michael.roth@amd.com>
 <20230621094236.GZZJLGDAicp1guNPvD@fat_crate.local>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230621094236.GZZJLGDAicp1guNPvD@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS0PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:8:191::25) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CY5PR12MB6035:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c605a2c-26d9-4d4a-f755-08db7264dd37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSrKRiisQ22vL5Q8gRGvYz3pRoltpDbm2skQGJo2yLVV2pryQvh3kRJzsTwTRYlF+O+LMWAXhsNnmumzkdTUsre5A1Y4aDm8e/vkGnm465TX/05tNV8lTMDrttGBlKcrzNHv3CJ1NupA+syF+9J/zXBhO+KPgytWAAQ7qy6eEN5dmaau327OUj7avYpko2l2lhJdzmc9F2kWaQq2JqeQr2oBvCCVoYePfzFlu3VyKMdgfXC0/srqWXggL3TXvCHEcvi2L+vTIy57sugU/2J+u/XNQyw0kfVMr44nyMVZxcoaKkhzuO0OWDOdq/rW9xn10vA2dJ/95iZ9ynf42SZ2CQNh1hRGebF5cpWNG53wA+jgMchkDShugdH3JFjfrBKAAeuvHJF2l50J8WHtH33hNu3iuG3sEeX8aeTlz6vk5TPVkE5DoI7qy4VQZCsiCc6xgHuWdseliQfZUVRngFAovR7uuDSGgTmmQza6c6onjzVnXapDsdoBx4toZHM+o1/PcgOmb4VvLUsniUhrB66HTF61Xb9yiRleJeqLGfrCYrqT00wCjqD0WDNu7YQ9KSIUK329VUD8n0+vMFJHd0JXeGYJwx7Ohgy16j2Nk3wL0+4w/kZkNJAg+N4T2Nzujhl7n2N0fEIFHrL8il6rUtQi5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199021)(83380400001)(7406005)(7416002)(110136005)(316002)(6636002)(41300700001)(8936002)(5660300002)(86362001)(31696002)(66476007)(66556008)(38100700002)(4326008)(66946007)(36756003)(2906002)(478600001)(6486002)(186003)(31686004)(26005)(6512007)(53546011)(6506007)(8676002)(66899021)(2616005)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2tzcmFTUk16NTg1akFUVnhuSkQrRXdkSkhGbmR2dFpNaEk4enpsNjdHLy9j?=
 =?utf-8?B?UUFlTzRrZzZtYmJzaHdaL25UUG96elRmZmZYU1pXeXVNTDNlQVE2YWprUkti?=
 =?utf-8?B?Sk5UZTNpM0JiZ3NNOVFmcm1sU2VoTjFBT2kxZFZhZk5tQi9wYkFiQnMyT2xL?=
 =?utf-8?B?eVhGWXJPRldCcnl2L0tCODIxbmtmZndhZXhCSWYxbHJSRHQ4UHozWmJCVzJH?=
 =?utf-8?B?NVZRQlpJK01UNWpTbHgyNnl0a3pFSzVnSUFDcUNaOFh6eWhtb2JTTWltQjJr?=
 =?utf-8?B?c0VkUjRjcnVvU01DNkVCa01HRnBiYlFOS3E2VStjQkZpak9pQ1czdjZmK011?=
 =?utf-8?B?U2tHV0JVc1Z6aFY3VllyL1JPSTBrOWZTa1RDTG0zTDNlVWdlVHJHL0Nvc0JY?=
 =?utf-8?B?TUl3dkZCUGJCVmhWYjNPYTQ0K3NaT0N1YzlvdW4vcVEwQmw3WUE4YWdabklG?=
 =?utf-8?B?cFo3SHMzM2ViYjJQUjB0dEhIaUhYZjZ3dGxpWGRLWVdtaW9YVGI0eFhHYy9v?=
 =?utf-8?B?VCtyZkk2dEdEZndici9CVzRrQU0zenVzUzdRd1I0UzRKQUdlMTJNeTRlcU1i?=
 =?utf-8?B?TjRvS3JQYTBMZUw4a2ZhYWpEVmt5TVVzc3ZrL0NaRkVndFk0cmdOTzBvWlJK?=
 =?utf-8?B?VVllMTNnZUx2RkhkQzRYSWt3Q3ljRFJTQ3ZSVnkzOGFKVTBFMTNOQVVLK3Zj?=
 =?utf-8?B?bCsvUnAyZ0RBcU9MK0pyaXZudzZmMi83TUVYM0JLYXZYZTJ2ZktXalpVdnpz?=
 =?utf-8?B?K01GU1hUQktDeTVEMngrY3VjUGZ1d2draHBSVXJGUTlFR0VSL1Y5YWdQUjZi?=
 =?utf-8?B?QnRIT1plS0xIWXQ0OU94cEp1enZhdVhaM1hUa0RhRVRvbFJ1VzNBU1p4Y252?=
 =?utf-8?B?R04zeTVMbkQrSjkwWUtFRjBjTWxxZGw4Rms1OC8zWXJpckNlY21NeUhBT1Rs?=
 =?utf-8?B?dGsvUEpRWG9UUHI3Z05nNG94TkRIQ1dOZVRCejlxTTY5Zm5QSCtxbFA4djBm?=
 =?utf-8?B?a3pjclVwcU9qTHM2Vno4NXpFVFRtWXJHRjVRZXp4c0RKcXlCUUNBRUJKcUtK?=
 =?utf-8?B?L2dNZUVmOXlkTXBEK2dtUTNtdGVJT2E1K1dEUEZFTm01akFJUktFMlE3SURz?=
 =?utf-8?B?SkZVeE5CbnBBMnJES0pqaHl5bTdVTmVpTG0yVWxmTFR1TTl4Yy8wQjdDaFll?=
 =?utf-8?B?YSs1c0FCdGI2aHdyL2xLbzUvdzhaWnZ0dUtiQkd5WERiR2hMVUlXUytYbFJv?=
 =?utf-8?B?dk9xbm5WZHBXclJGLzlNOHllaHljSTRCNVRZRmJMbXFCYlkrLytneDdmSnZl?=
 =?utf-8?B?YlBaaWUwZ1B6LzRUQzNwTXhGMEVnVGo1MnEvRThTSDUvYU9GVjluYXRKcWU5?=
 =?utf-8?B?M3l0eEtzQUIzakRNL3p0MnRYbFk3YkcrTHMrVlZkUFFQb0JRZENFTTJGejdG?=
 =?utf-8?B?MU54YnR5YTAvaWtjd0JLaTF6NC9UdU9BdmdOUEp6ZDVLUGhuNW5KYlZ3RW01?=
 =?utf-8?B?b2kvR0tvWnVFNmM2cDQ1OTdzbitvaFp2di9nZVBvc3dOYWFkUWRRMFlvR2s3?=
 =?utf-8?B?WUc2T0xzbDZVcnNiRW1aRElSb0dHcTdqUHBjZmJ4Z1NYNExOY21EWVZrUm5C?=
 =?utf-8?B?L3hvZmdZT09ZWGJsMnZNQVV3SGV0eDhZaDZQd0pUQlBCYXhFNlI1VTMrTStm?=
 =?utf-8?B?dFNtODZPZkZ3TjlSVFZqbFZFdFRZZm95a0RSZjRXSmhxQWQ3cGZHMWhMenR5?=
 =?utf-8?B?OXRiUWJLb2dEb0wwSlZCYUJBNUpJQ1hIcGNmMkltWFpsKzVFcDJZd3lUaW5J?=
 =?utf-8?B?Zlk3TWEzOUhkd0FWSFJ0N2hJbDJreWFuQjlpK0RHaWYrYlZQcWhkSHdxUU9E?=
 =?utf-8?B?UFk0UUdPMml1S29lZGltckcrcXdtTG1ZaVpIU2Y2aS9iTHNZdVh1dHF3ZVho?=
 =?utf-8?B?M25ZTWpJNEFuYWg2U3VLek1PUTl4OUM4WlAyVWpiSWQ4N1EvT3FlUWhFU2VL?=
 =?utf-8?B?dFZ6V05uNWhZcjIwTUJXQm9qR0syTElKNld1RzJpczVwYlZzTUprNjJiR3FY?=
 =?utf-8?B?MG5sZzlPSGdiYnloOEhKN0V5aURhcWxUbW1ucnlhK29XdmsvNG1MN3BYRGFu?=
 =?utf-8?Q?vzIK72xywMUWsHSA/iGO1AzCe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c605a2c-26d9-4d4a-f755-08db7264dd37
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 14:36:13.8644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tdi4NY9GyLYs/HoP6qfqUW4A7RcI0tO5dikASDlTH/WL4nam1iR+AkH55myyBk16liHq2feti/Q5ytOr8JGvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6035
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/23 04:42, Borislav Petkov wrote:
> On Sun, Jun 11, 2023 at 11:25:15PM -0500, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> The memory integrity guarantees of SEV-SNP are enforced through a new
>> structure called the Reverse Map Table (RMP). The RMP is a single data
>> structure shared across the system that contains one entry for every 4K
>> page of DRAM that may be used by SEV-SNP VMs. APM2 section 15.36 details
> 
> Rather say 'APM v2, section "Secure Nested Paging (SEV-SNP)"' because
> the numbering is more likely to change than the name in the future. With
> the name, people can find it faster.
> 
>> a number of steps needed to detect/enable SEV-SNP and RMP table support
>> on the host:
>>
>>   - Detect SEV-SNP support based on CPUID bit
>>   - Initialize the RMP table memory reported by the RMP base/end MSR
>>     registers and configure IOMMU to be compatible with RMP access
>>     restrictions
>>   - Set the MtrrFixDramModEn bit in SYSCFG MSR
>>   - Set the SecureNestedPagingEn and VMPLEn bits in the SYSCFG MSR
>>   - Configure IOMMU
>>
>> RMP table entry format is non-architectural and it can vary by
>> processor. It is defined by the PPR. Restrict SNP support to CPU
>> models/families which are compatible with the current RMP table entry
>> format to guard against any undefined behavior when running on other
>> system types. Future models/support will handle this through an
>> architectural mechanism to allow for broader compatibility.
> 
> I'm guessing this is all for live migration between SNP hosts. If so,
> then there will have to be a guest API to handle the differences.
> 
>> SNP host code depends on CONFIG_KVM_AMD_SEV config flag, which may be
>> enabled even when CONFIG_AMD_MEM_ENCRYPT isn't set, so update the
>> SNP-specific IOMMU helpers used here to rely on CONFIG_KVM_AMD_SEV
>> instead of CONFIG_AMD_MEM_ENCRYPT.
> 
> Does that mean that even on CONFIG_AMD_MEM_ENCRYPT=n kernels, host SNP
> can function?

Yes, because CONFIG_AMD_MEM_ENCRYPT is mainly for dealing with the 
encryption bit.

> 
> Do we even want that?

We support that today with SEV and SEV-ES guests. The host/hypervisor 
kernel does not need CONFIG_AMD_MEM_ENCRYPT=y in order to run SEV guests.

> 
> I'd expect that a host SNP kernel should have SME enabled too even
> though it is not absolutely necessary.

I recommend using TSME over SME.

Thanks,
Tom

> 
>> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> [mdr: rework commit message to be clearer about what patch does, squash
>>        in early_rmptable_check() handling from Tom]
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   arch/x86/coco/Makefile                   |   1 +
>>   arch/x86/coco/sev/Makefile               |   3 +
>>   arch/x86/coco/sev/host.c                 | 212 +++++++++++++++++++++++
>>   arch/x86/include/asm/disabled-features.h |   8 +-
>>   arch/x86/include/asm/msr-index.h         |  11 +-
>>   arch/x86/include/asm/sev.h               |   2 +
>>   arch/x86/kernel/cpu/amd.c                |  19 ++
>>   drivers/iommu/amd/init.c                 |   2 +-
>>   include/linux/amd-iommu.h                |   2 +-
>>   9 files changed, 256 insertions(+), 4 deletions(-)
>>   create mode 100644 arch/x86/coco/sev/Makefile
>>   create mode 100644 arch/x86/coco/sev/host.c
> 
> Ignored review comments here:
> 
> https://lore.kernel.org/r/Y9ubi0i4Z750gdMm@zn.tnic
> 
> Ignoring this one for now too.
> 
