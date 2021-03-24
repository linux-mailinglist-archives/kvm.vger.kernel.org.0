Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FE83482FA
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 21:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238179AbhCXUfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 16:35:34 -0400
Received: from mail-dm3nam07on2065.outbound.protection.outlook.com ([40.107.95.65]:2145
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238128AbhCXUf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 16:35:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZmhpBCKP9+UZ4X/NQWswXGvtBCvU9I2M1gEgUKzF5Jr+Br/JwIyiIPT6oOv9RzYvIZ/uJpyOJvg/0gxv+a+18rgZocjK3X0CYprkSZpEvGV7GiqwpcOabqK1FaeK8IcT9LpkVHUYNYtMCrY5EgBR1bstvTVq6aruCKCUgBJi+JKIUKyGiUHKHbN90m0XlYWS9x/ge+xPDNAQcuHMoL3Fa867a+GwZddyOmN2heNeWEECFCh3qi7uKbxPXEdMDsdKgV99oNDhOiUpHH1UfM+T6uZJnRVSW5F3dEM5GVKA50b3uERjTMVloVjqQXPwfqwsdULyLPmzr96qECVvAUDcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2wUj88OvbhRalxEeqL0O4smzOrZ3xStGCfjSwzUaek=;
 b=YEp+jtnAdpfT9sKoyYcuKRwp8IX4XUyTPJYZ4ogN4gXSScU1X/ezXWB8ykxPSMtwl8hkRboemGTZte+jZVM7FGWF+HVOlNJ6BRhHsztGL2UphfD+7EQ/8wzW8eh0ZarnspVNe+0JEBjJBgevYOjutZd/awwaH2xtLu2g8Ry3uxIpmqSMsd+wVKQW6RoWUY2TUlV5l0uGEZX7y/ajZZTzIfHS/hAJi85nj38Iw/If300M7jJamXfBhyGTZhylF9FzRZIUp8HU/pXjBSynOXZ+nEBHx8id01EPku0ztJaeMYX99fRlJnJjHJQO78jQatZ8bZDZOyvVJRAX3VJsHVQc2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2wUj88OvbhRalxEeqL0O4smzOrZ3xStGCfjSwzUaek=;
 b=05UqEbEfKKfjJKlEiQgSxo8dbcCtzlIriY2cywRnSpkCWeiUKn3IClnGcqDpnEDy2hXp5A81yLduXpOJblPKV1SnbO4XDc+QAyFT9DOtVfVMvVjQTCTfFaT062PGchZLNaZFCwxIMgdSKvsymUtSErb95B5ElK5YZcyDRDPbjG0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 20:35:23 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 20:35:23 +0000
Cc:     brijesh.singh@amd.com, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 06/30] x86/fault: dump the RMP entry on #PF
To:     Andy Lutomirski <luto@amacapital.net>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-7-brijesh.singh@amd.com>
 <CALCETrWH4uPUQHSwgwz5PS8XngJyvjxgWZ85EV5s7VGJX=aa_Q@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <1802222c-fb6e-3c71-13f0-691b91b83f5d@amd.com>
Date:   Wed, 24 Mar 2021 15:35:20 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <CALCETrWH4uPUQHSwgwz5PS8XngJyvjxgWZ85EV5s7VGJX=aa_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0501CA0050.namprd05.prod.outlook.com
 (2603:10b6:803:41::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0050.namprd05.prod.outlook.com (2603:10b6:803:41::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Wed, 24 Mar 2021 20:35:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80d430d2-b434-4b6b-e87f-08d8ef045924
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2512FF4936A0DCEE0967228BE5639@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jG+xUl2ohqhzBoJrTSJRcAgmtDS9wgh9LH5UpjeRkF/bvI6OY5ElbmeDmiLn4PPblvzGxC2fKu4CZfo/XSEF+JUZ1muIBjZB+Ynk4FUr0w/fOS6RZJqpW8Msmtdx6MeO5dXY/tloRjtkR2310mIZ+C/xW6ET54ApHkTIjOzq7Jx2ib2eH/t2gguXu8LbMH5AF1w+yRvRFT3fOVswoqztmQEvWecY1VbEYR66cdEmpxDKYCPUb0bq+LvYUKfsv7RdtI7sVArb1K4MxbqV09rl/Z1I7wWUd1tS4HuN0CYkSsGxHM3+XDNkRXPyap6tW6PERctt+KD+i+joN650Q7TfTGHQVYHOfhekEPfUAgff45zKpLenYL8RlfX8p3+AY8REAktj6/kaVheAg2HYVKhWbP4J2tWbTODq3SLeW0hD8+A/S+n5vYz6vAdwhvTJC7bE9JGxmUUtUyoe/DhvOBp9+Uvf8kl7X5hVCXNfPPnWDMHyFzz1S+5oM3T/lzATM+lm1hRPFOIH1PhSqfDXbzLzkj843E/9CYt38HG00XQyaBuQaGs6me9VLSTr7X2CyDlGDnHgIuDpbsZZzrtq0rEOyk4CMaH9Bktne9/V2C12dYbevZR0yqViCxxFVr1euIEeapGgF9Yrv4yErupBi5mmxHf1OxZ3TsBz0A0UWmj9bebH+owLw4vpaerRGzcKhrRE2xLjBqqHJynFXYHlWfbitGlYFf2Y/XBygGFNq1x5OUY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(66556008)(66476007)(86362001)(31686004)(38100700001)(2616005)(36756003)(956004)(8936002)(8676002)(83380400001)(66946007)(5660300002)(31696002)(53546011)(6506007)(6486002)(4326008)(478600001)(52116002)(2906002)(316002)(16526019)(6916009)(6512007)(26005)(44832011)(54906003)(7416002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N0MwTDB2UFBWMFdhd3NxVEtVVmluMy9wdGZwN2FObDAxcEdWUjluZWJZbVBq?=
 =?utf-8?B?ZFE0L05iaXZ2MVZDQnlaQk5qMWFwVUJPb041RzFrWG8yQzRBU3RvcUpLdnJI?=
 =?utf-8?B?MEsxL3lBWW01UEpralJRK0JKdTI0dThXM3BoMG4zY1J2L3h5WVJGdE1XUXJo?=
 =?utf-8?B?R2xMUmdDWXowMGk5bDRDSDVxZWQ0K1BMZGxDdXVxUVNoZ2J1L2hadW50cGVY?=
 =?utf-8?B?WXVEb2pEMnh2b2lqaDhNZXBaZFhpSlY5S1dybTBGaVJpNkxMRUUyYWtxMDh0?=
 =?utf-8?B?dEJTeitrM2E5bDV2TURQUmtSZERNVmQ3dlhYMTVtTHZncWJMbDZzdXNvREhj?=
 =?utf-8?B?MGJaQ3lkMUxoanVtVTFhdThuS3BqZlBkS01WdHpDL1Q2ZnZQcXpKdjI2ek0v?=
 =?utf-8?B?eWNvdXcrVEY1UDdEN1J6MERydVdrcmlrUkRTLytsOXhwamxWMk9oS0hwaVpO?=
 =?utf-8?B?T0Z4b2RBc1B3Sjg1R3lnWnRkc25EQWwwLzZyaTcvV0VFNW1Od0hVaDVVdURx?=
 =?utf-8?B?YWhBQXBSbGM2NVF6MElJK0JiZWJyWTNyNWpydG5vQitId013T3V0SkhYaXRE?=
 =?utf-8?B?Q3BjaktmOEJJcmRuRzdLdU5mQmp1c256ZE5RejFtd3RCc1NKUXYzb0JubU5s?=
 =?utf-8?B?Y2diVExVM1pqQ00vQjFyd25oVEo4R2VXbnZWdmdpcEh4TTIvNVg1Umo1RkU4?=
 =?utf-8?B?ZkNZakZUTW5yTWdFay9RVlFocXNUbWlHRUM2QTlMa21Oalg5OGRBL3VEVnVX?=
 =?utf-8?B?Y2ZuRVhCVWV0aWJpZkxhQWJtVFROUVRMS1lrU3lCZk12SjRZTzR3YjNuRTFS?=
 =?utf-8?B?OVlUK2lVNTdwbktQZm9OVStlN0NWU0lYTVh2MU1zRGJqVXBzMU1kb0Z5am5x?=
 =?utf-8?B?RmIrZmdZS1FtK0V3cXZ0blBrUzZGSHlXZEdqUURiMDd6VzhLK0xQbDhWazZs?=
 =?utf-8?B?ZWFUcjFUc3dpUWFqRDc4bmhoR2R1d3ovK2ZrUlRONXRVVlV1d0hLOVdseXk3?=
 =?utf-8?B?Und0bjJrWHcrVjFKYS82UExEMFozU0trSEszSFVUMENIdEliUzdRdWJSNk04?=
 =?utf-8?B?a0dJbGhmYW54MnlNNUZ0bW1hR0pVQUs3WEQvWE43b2cwM2MrYzZ3ZzRWa3p4?=
 =?utf-8?B?V0pxNXpSWHN3ZHhnTUlIQjZ2aEhwNFc4VllLNGs5RWVnWjYvUWJZVFZ4cFI3?=
 =?utf-8?B?RW00eWxqZ1ZvaTgzV01DM20xM2NSQVRmRlNrVnJ3N1R3UlB0MmZHdW0wVWhp?=
 =?utf-8?B?ek5FbDdnQ2lMa2xtT25GUWJvVDhGQnV6MDEwam9DYkRJNVluTG1MNGk5YXFU?=
 =?utf-8?B?S0orYjRYZENkQU53RzVIbkxnSUJKd0dYRFQvMEFVTnlDUkEvSUlFNVZCWVZ2?=
 =?utf-8?B?elkvejlId2JGVGw0NjBBNE0yMkZqWC9WazZTMm0xdlpxS1ZuYllpYXdOWFNM?=
 =?utf-8?B?b2VRVCtjZVNpc1dod3RiNzRySWZCbDNlMGY5Wm5QU0pSczVBMVRZN3ZDVUZq?=
 =?utf-8?B?V2RyRW9hWDJ2NGN3VkJGMStINkN4S05EbExXbjhIRlJYd0RTS1J1SXQ1aENi?=
 =?utf-8?B?NEtETkZEOVlPWCtOZG9KZjVLY1B5emlBeEw5Y0VOdWlIcWRaUDRTU2t5QUh5?=
 =?utf-8?B?ZmQ3QVlDUnU3VDRVbzFxcGZxZ2cxS1pJQmdBSU1CR0pIWDZFWklja3BLSEZo?=
 =?utf-8?B?Z2d5OWJBdmcvdktVcXIwTmlYeEJSNkg2UXpwVkdUSzJpTVNmcS9VNit3Ym5L?=
 =?utf-8?Q?VaMXULJe4HeispPr39QAcHYqnd4Lq3YKl0j16qX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80d430d2-b434-4b6b-e87f-08d8ef045924
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 20:35:23.1251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ccwr/GEcLKOou/U/wN3GjwYuy7/lLNYatEsgOnv5+Ut+/WCIAEFekJyw4qMmDiTo4jtlrYkj4tklqw1iVUEF0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/24/21 12:47 PM, Andy Lutomirski wrote:
> On Wed, Mar 24, 2021 at 10:04 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>> If hardware detects an RMP violation, it will raise a page-fault exception
>> with the RMP bit set. To help the debug, dump the RMP entry of the faulting
>> address.
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Joerg Roedel <jroedel@suse.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: Dave Hansen <dave.hansen@intel.com>
>> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: x86@kernel.org
>> Cc: kvm@vger.kernel.org
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/mm/fault.c | 75 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 75 insertions(+)
>>
>> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
>> index f39b551f89a6..7605e06a6dd9 100644
>> --- a/arch/x86/mm/fault.c
>> +++ b/arch/x86/mm/fault.c
>> @@ -31,6 +31,7 @@
>>  #include <asm/pgtable_areas.h>         /* VMALLOC_START, ...           */
>>  #include <asm/kvm_para.h>              /* kvm_handle_async_pf          */
>>  #include <asm/vdso.h>                  /* fixup_vdso_exception()       */
>> +#include <asm/sev-snp.h>               /* lookup_rmpentry ...          */
>>
>>  #define CREATE_TRACE_POINTS
>>  #include <asm/trace/exceptions.h>
>> @@ -147,6 +148,76 @@ is_prefetch(struct pt_regs *regs, unsigned long error_code, unsigned long addr)
>>  DEFINE_SPINLOCK(pgd_lock);
>>  LIST_HEAD(pgd_list);
>>
>> +static void dump_rmpentry(struct page *page, rmpentry_t *e)
>> +{
>> +       unsigned long paddr = page_to_pfn(page) << PAGE_SHIFT;
>> +
>> +       pr_alert("RMPEntry paddr 0x%lx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx asid=%d "
>> +               "vmsa=%d validated=%d]\n", paddr, rmpentry_assigned(e), rmpentry_immutable(e),
>> +               rmpentry_pagesize(e), rmpentry_gpa(e), rmpentry_asid(e), rmpentry_vmsa(e),
>> +               rmpentry_validated(e));
>> +       pr_alert("RMPEntry paddr 0x%lx %016llx %016llx\n", paddr, e->high, e->low);
>> +}
>> +
>> +static void show_rmpentry(unsigned long address)
>> +{
>> +       struct page *page = virt_to_page(address);
> This is an error path, and I don't think you have any particular
> guarantee that virt_to_page(address) is valid.  Please add appropriate
> validation or use one of the slow lookup helpers.


Noted, thanks for the quick feedback.


