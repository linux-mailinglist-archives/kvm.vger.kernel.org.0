Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA09355ABF
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 19:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244470AbhDFRwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 13:52:25 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:13473
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233394AbhDFRwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 13:52:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gu5MazYBeBDMY1Gg6g3UGkXZJ+v9cbLaNosennKNcNZhQN8ceuPSg76BDX4AvX2CByHGDuMinQeUlpFey0sUGBFy/cQfYKTe5QTWxoZVQmClxxKuN3dP2BfKjRbRJAQqlvSdsDZO9wdScNWgdukqoPyfy1yuGU9hSFYbOe4pdPnlEoksk8VVgjZedQ4gmpkMenmrLwkIrA/yejSJIPLNeGo0VbVO9B7uCU5diXH0CFYoHXQxnJDTBExyThu24JdKKzidGND5cDULURw3Ag9YJKOleRSnech4yVQXwFpG6xXdWPCPTAPaTkGPQGIb+D7rrnHWxqZPq/erP0/aZyFxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J07O/g1WXwuutY5olApjQnSH9Kp/3+z3epHSYkz2tI8=;
 b=JxYnlzJ2fo22UFzgKt1k5ownEPnHMAsN8MD32ZjOS0ncPlYuIq6sOax2Qf4qN3u0u3gkAoPGlqgg0ev416KQAOY/YEcI6wrt87bE4pbYTYrcAjz0zs6Pj+rTuXHpekuulGWdfAnpbM2Sxp2BZono/IY7YRgVbMcqF+tv2jra0QIURd0chi9nWxHT5Oyn8QjU0Hq9QhouWhfeIlIKB0I9uvlj7/DumjbUdboa2GBTCdUtapxlrIg5CF6gcFtv9VzDdtcM0SAi7ES+h4Wc1lnRnM+WxvdDwYryKTag1kSvUjKgXhq6FpC9UWUTl+DB4csPAvyJ+hi9b5OipIwLHsJQ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J07O/g1WXwuutY5olApjQnSH9Kp/3+z3epHSYkz2tI8=;
 b=ZcApLYsURpIWJ7JIRHGn4E5J1gdTuROfjOtDxIWaSjNsuz4yOKz2hQgaRsuBNpL5hjgd+ljkNgvbyJUnRoW32Eyi7RJIiLEjutuZcDXqi/tdVDFIGDwvGzGPcxGnsCE0rfJTpH9YdC8WHSdMq8NaTM11SQ2+BaP9T7YHrJrrPB0=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3577.namprd12.prod.outlook.com (2603:10b6:5:3a::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Tue, 6 Apr 2021 17:52:13 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 17:52:13 +0000
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
To:     Dave Hansen <dave.hansen@intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
 <c5f2580d-0733-4523-d1e8-c43b487f0aaf@redhat.com>
 <52518f09-7350-ebe9-7ddb-29095cd3a4d9@intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d69b4eae-870c-efcc-4d76-a625018b9c9b@amd.com>
Date:   Tue, 6 Apr 2021 12:52:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <52518f09-7350-ebe9-7ddb-29095cd3a4d9@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0701CA0018.namprd07.prod.outlook.com
 (2603:10b6:803:28::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0701CA0018.namprd07.prod.outlook.com (2603:10b6:803:28::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 17:52:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 371bc81f-10c8-4d13-548e-08d8f924b5ba
X-MS-TrafficTypeDiagnostic: DM6PR12MB3577:
X-Microsoft-Antispam-PRVS: <DM6PR12MB35775EABE365CAD9C3843DAFEC769@DM6PR12MB3577.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZMO933UiSk9Q4YGE9a2xcTnulEoyf6QaqYWdYyLX444iUBOwEHl/GG0InmfSyFW7TdFCaNb1h66Ur/YthxieXSSnrJbOsUvOugn38zKaHJBLw9Jwi8e9Q/QSfwazmPKEpQMZp9wMgKEJ3Be11mzC2gxKvTUmb2ABXt8Q/mje2nifPEYhtzPWWqhQdnKjy2Y0ozh1tipas2LaFG4tTIhUIIPcFVxqJJksKjfkKKvfbXSNjzaGysaQbYnWMbbSrOVP4z25j16acmYeKh0veVO31gNKAJAvLOLFVRdvFlKeYZPtN7GQ8sy1YZt9RLZbpEkjjv0+waFhbV2GpHfZ3ewSfciGuJ2uZ7cr68TV9Jpo+mM64IGvJtiyeEVJ73pqXuu7pIp8pdAyVjjT5R7zhtXUz0HqSxUc3WU5ITFgL4EHPmhfgBAHvXrEWysYP5MUEIftejBTDatMW8aP9VjA6sdGDwO8E4EirWBi/yH0vhBpHIseJGEjOjl5UR3eeICWa9m7qkCFrA3y9ePIgGwQOtefl1xtfb6MK3NA/g9Sdvf1iEcw8r95uCyuu7zK1fdURj0jwyxdL7BtPXZ4dpBVD90nv0+RdFO8tkXkuZu+fM6/MiJIcF3d+SmYubOOQFnKJVlADxrq6F6dWu/TY5Y98KzTMOgjHKSq9ua1N3kCPK81ZkCcrTVfDIBmSPw97HexOccri/IsDTI+NFLoPohsxULTeAqNlJWa/R4FYVMq1/g2qk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(478600001)(36756003)(16526019)(86362001)(31686004)(2616005)(66556008)(8676002)(83380400001)(6486002)(110136005)(31696002)(6512007)(26005)(186003)(53546011)(316002)(54906003)(956004)(38100700001)(7416002)(5660300002)(66946007)(6506007)(2906002)(4326008)(8936002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q1pyZGRjYWt5OHFqQ3FyUVZkd2RXSWN5Zml0bVVnekxPa1lNUDJHM1JGTUZ1?=
 =?utf-8?B?NUdYc0Y2cnNGeFp1L3NnOU0vaGNKMnBPRy9aUWtTWDJMOGpWais2dVZJV1RI?=
 =?utf-8?B?WFd1bTVEKysxSGFzV2hMcCsyNlVFdWlzRzFIcThyWW80RllpRzVyS0NySjNx?=
 =?utf-8?B?bEJBdzVyYnN2VFhVL3J2WFFrOXFzMnZuWHRzWDNwWDR4NFBycjM1OFh5Y1JP?=
 =?utf-8?B?TmhYQ09obzV0ekZBZHpYWEFGTGdDMW5NODdiU2NWZXd3c3JuRWJMSmlKeTRX?=
 =?utf-8?B?M21GYU1aMldPaENMZHhMYW1salFRR25Ka3FsVmwreEhpaC91MnpNMEJ3VDlZ?=
 =?utf-8?B?RTR0bXRSMEorOUZJNm44WmxKTkxzais4Zi84Y2lZdCtUeG1uOFUwaFlNaXNI?=
 =?utf-8?B?bThlTGE4UW11T1ZRcGE0N01FTldJVXFoRWdwTmEwSFBJazFHWklDSjNGenlS?=
 =?utf-8?B?S09sS1pFWm5IaEpKWFU2T1ZXTGVoT1FQMHp5N0ZSNkllWk4yUTgrNXJ0VFNr?=
 =?utf-8?B?NzBZeWQwMG9wY20zc3VGUkdvYmM3aFgrM1l1MjB3L3ArbDI5VGR2V0tzS0RD?=
 =?utf-8?B?N3hZTjJZTWlkb25jTDh0OTFOK2RLNEpaV0ZiWHdjVVhtaEUvQ1RiSU1hYXhB?=
 =?utf-8?B?ODFrNktIcllSQ21MMnRzZTdDaWlMM3VhZFpvaG96Yk5tOWMrQzdrbW1wQkh3?=
 =?utf-8?B?VGI3OHBMYVppNmVsaHN2MGEycTZ2QzVVVmo4c1VJQzRSa1B6RHBRZTVKTGZw?=
 =?utf-8?B?V0tvRzZvYktlNWlqaEM5ZERrM3piQ29IZENjK2s5VUVXL096RG5jRHN1YVk2?=
 =?utf-8?B?b01jb3ErUGpiYXIrUzJRWmFHejh4L3Y0LzEwcXAzZmVQd0YrVUZtZ0tXZ1JS?=
 =?utf-8?B?OUpNM2VjRndsRGx6Zkg3LzQ0VjE0ZXVhMkF6SWorcmprUXpCdWgrQnlnREZm?=
 =?utf-8?B?clc2WXlUK2tMRjBYcFNjKzQwRko5NnFlalNNQ1dIcDVWbDZ4OUlmWXZqRUho?=
 =?utf-8?B?OVdkejVITFc3OUtHT21BS0grUnVYMkxTVzBxZDlWVzVGaUtjQ3kxSWtobkFQ?=
 =?utf-8?B?Zmt1MTFzUTBwZDg1ZUJmRTl1ZXVsWkI4Zk5vYTJ3cDY1WG1JRGZBdU1XME0v?=
 =?utf-8?B?dnpwcm9hNlJ0cjFSbGlYRU5oai94NkxVWU16Umd4L0JqVVlxMjJ2TjVhZVFB?=
 =?utf-8?B?Nko4dmYxaUhCNEpJdVBTOEM4Ui9iRFlYbVBMS2FQSzRjQWdXZDRjTmhQakxq?=
 =?utf-8?B?VEd0VVZzcUhGdE9SYU5Ednk3K0hpNFlCbUhxekhkajcyekhFUS9nWG1vVzJv?=
 =?utf-8?B?ZVZLOUhvN0xLZWlEV0RuYmRmRzZCS1NWK0gvMFA2Tk00dngxcnJweFVYNnAy?=
 =?utf-8?B?dU5wQnRmT1I4d2IrRXlEK0FOSDlIc0lOd0NtdWxndnFYQnR1MkZieG4zVDlK?=
 =?utf-8?B?eTYzUlUrVzcxbmNUR3M0SFdIK2dUamZ1VFQwYWN2MjdFMmtqeXo3bjVYQ2lW?=
 =?utf-8?B?aDlISmgyWVRUN1Z6K3RXRHNnejcvRVJGeGFxRUpQd3dFNlNFQk5FKzJvRDNW?=
 =?utf-8?B?M3VGN2UyQTlFcUpLanhGM0lYVFhRaEszSjMwKzBLdmwrcnEzcGxyeUpVekho?=
 =?utf-8?B?RTVkZFdLcVpvVStWRytlR0Z3MVJGODJ4RVFmQTAxbEppSUt1RmRtRmhsWFZ1?=
 =?utf-8?B?N2h4dzRwRGtueGZhVTBjRkZyRUZiUlZvNlZjeFZZSHVjRG1wU0FON3lmYkxi?=
 =?utf-8?Q?lU3SmsA9O22K/BgShUuudkHRnDveaWJby56/7GV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371bc81f-10c8-4d13-548e-08d8f924b5ba
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 17:52:13.7230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zq5qH56GrtFw5F7++vfJmE1Vyh0dKIzmLXukOnxKGVkwH/GIFX3rxlFCSveiTQ3qkI13AYsKRGQqAdKdkBoxBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3577
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/21 9:33 AM, Dave Hansen wrote:
> On 4/6/21 12:44 AM, David Hildenbrand wrote:
>> On 02.04.21 17:26, Kirill A. Shutemov wrote:
>>> TDX architecture aims to provide resiliency against confidentiality and
>>> integrity attacks. Towards this goal, the TDX architecture helps enforce
>>> the enabling of memory integrity for all TD-private memory.
>>>
>>> The CPU memory controller computes the integrity check value (MAC) for
>>> the data (cache line) during writes, and it stores the MAC with the
>>> memory as meta-data. A 28-bit MAC is stored in the ECC bits.
>>>
>>> Checking of memory integrity is performed during memory reads. If
>>> integrity check fails, CPU poisones cache line.
>>>
>>> On a subsequent consumption (read) of the poisoned data by software,
>>> there are two possible scenarios:
>>>
>>>   - Core determines that the execution can continue and it treats
>>>     poison with exception semantics signaled as a #MCE
>>>
>>>   - Core determines execution cannot continue,and it does an unbreakable
>>>     shutdown
>>>
>>> For more details, see Chapter 14 of Intel TDX Module EAS[1]
>>>
>>> As some of integrity check failures may lead to system shutdown host
>>> kernel must not allow any writes to TD-private memory. This requirment
>>> clashes with KVM design: KVM expects the guest memory to be mapped into
>>> host userspace (e.g. QEMU).
>>
>> So what you are saying is that if QEMU would write to such memory, it
>> could crash the kernel? What a broken design.
> 
> IMNHO, the broken design is mapping the memory to userspace in the first
> place.  Why the heck would you actually expose something with the MMU to
> a context that can't possibly meaningfully access or safely write to it?
> 
> This started with SEV.  QEMU creates normal memory mappings with the SEV
> C-bit (encryption) disabled.  The kernel plumbs those into NPT, but when
> those are instantiated, they have the C-bit set.  So, we have mismatched
> mappings.  Where does that lead?  The two mappings not only differ in
> the encryption bit, causing one side to read gibberish if the other
> writes: they're not even cache coherent.

QEMU is running on the hypervisor side, so even if the C-bit is set for
its memory mappings, it would use the hypervisor key to access the memory,
not the guest key. So it doesn't matter from a QEMU perspective whether it
creates mappings with or without the C-bit. The C-bit in the NPT is only
used if the guest is accessing the memory as shared/un-encrypted, in which
case the the hypervisor key is then used.

The latest EPYC hardware provides cache coherency for encrypted /
non-encrypted accesses (X86_FEATURE_SME_COHERENT).

> 
> That's the situation *TODAY*, even ignoring TDX.
> 
> BTW, I'm pretty sure I know the answer to the "why would you expose this
> to userspace" question: it's what QEMU/KVM did alreadhy for
> non-encrypted memory, so this was the quickest way to get SEV working.
> 
> So, I don't like the #MC either.  But, this series is a step in the
> right direction for TDX *AND* SEV.

So, yes, this is a step in the right direction.

Thanks,
Tom

> 
