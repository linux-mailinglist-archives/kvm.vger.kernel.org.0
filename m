Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E067E47950A
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 20:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240074AbhLQTqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 14:46:32 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:13729
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240014AbhLQTq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 14:46:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJOzIzUW7vdOFaVKRb0MVmxQ1isK2jcY19XggP1uw5/Va5MywXKXyn1wlpsBbH5cPOCyPlSAzDqFezQOoyYia0KO79QqUkrJIfmdMOlw98SGD74azIk7wTNV2rZh7uOm+Dz/PuDU7yrb+TaseBVzJZB5tBld1OgBk3hkoIaYgX31piQaWKXAA5RJyHhtaQLb/755yxh/KTb8WeVSooDQ7/Hy3wipFoTStO9qe4oYb3LoLjME3F/A4bUDVyYCMpwKHrOeHdisqI/nBNiXJyUvig7PSZPYRrN9OswqkYfxizZwynR2tZu57ChoG8V38x6K9yfJFPiVCGCyJdRzt3criA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsNiSHUNQrVjrQRrBclzbE0387uFpKCsbg4VFqDXSHU=;
 b=ef6CQXFSSBEuXPZjW/GOTKnM9Gm6CsRor+bRyHE+S7+O+4sfdNoJPn6T5nKjVRDMTR6mTkOkNfyqLJlFbaBWTjNqB1pqZAFzmxYPVAZFHOR1HADW0ycULQJAoQqYpX6yYND5fRnCP1CL1oxcKisVl/Q8zrrM9/KcLjvRa+0dMV5fV4Rx+M0hmBwHYxzKJMM/wzPDW2ZlMtBgPpbkkxF3RvfKGBdiY+0O6bP47xls70d4G6f7QsLPp5rW9x/12FXLYm4pWrC6JdChtde7/d08ufHczivomdqKFzj9qqe9EJG8e9RZSktxW32hBdBqH5YsEqAHDWHde6mW6lC3/aJkUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsNiSHUNQrVjrQRrBclzbE0387uFpKCsbg4VFqDXSHU=;
 b=KwqlZnEq9vd7uOug+LM5G8dmb5wfBiec8GQ4PFnTd6RR9aNwGwnvf7llZZNLs9hNXE/Y3sDiQ/cGeo9hS0Br8uo7okC79fcghaODWj+yPr13yzcjfili7xZA6h0i7p8expp97uWWrLhYrdCpOHGxYC7mLIxqt5vq7Y6dJFUMiZw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5533.namprd12.prod.outlook.com (2603:10b6:5:1bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 17 Dec
 2021 19:46:25 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 17 Dec 2021
 19:46:25 +0000
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
 <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org>
 <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com>
 <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org>
 <1401c5a1-c8a2-cca1-e548-cab143f59d8f@amd.com>
 <2bfb13ed5d565ab09bd794f69a6ef2b1b75e507a.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b798bcef-d750-ce42-986c-0d11d0bb47b0@amd.com>
Date:   Fri, 17 Dec 2021 13:46:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <2bfb13ed5d565ab09bd794f69a6ef2b1b75e507a.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::9) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN7P222CA0028.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::9) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 17 Dec 2021 19:46:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7782832e-a671-49bc-1a15-08d9c195e8a6
X-MS-TrafficTypeDiagnostic: DM6PR12MB5533:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55332CFC2422E12C3A7522F7EC789@DM6PR12MB5533.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bo6+0RlRDfqvaaC30g2xFuMLLX+uSwe/V2FKa8LS9QjN6R1e/37YN1d8wiRylkxWZ+HdQiASyL1745ojnq/PQKeShnLOP7VzfloDDyEyzTf4ljLcAlX5igstFuo+OXeOe+KKQX4Xxj5azErxk0AjiZ75gtBDh2DCNLdcvBi53MJi+M15zWP4s+rX/VxuMWqaPVF0JrXe/CqlxblFVorvPf/waXebG/tCiPLBrXo+LzYFAiXx0La7m9zBt4lZoAI/mq5FQZ8sBT3WjvXmRr9HKs/Sfmjm+k8boILP+lryT6DofwQ8B3Qg9tB6zWPCQAdtMtMiBiJ72+aJ4aOHW4cAEm1JKnbO07h4hFzthWl5wcU7/haI6D5uchSE8FplEys9cv1jwK8rf4av9ZWtYquE+IM5KV6dHsT8QsvfajxHxW8LstM7BIlJkv+xuclOp7dbQdXE6Ljz2snz4E0msjkDAtZULtHMeTSiyD12lJCaOEMpapLQkm36PXI36iqOYbXccL+wsoweUvJ1qdINotL5SaboV6WW49YnCA/v7yXal4O6uPjCDqAw+q8D/FDjA5XsAj21BEOB4CDn3QzfPtfHxrD6HZJznocR2/Nsa32x0fWGqbMb+QEgoNnm4Zg85frMeXXkqv/blUtTsafOVR6J6lRnnW5IlIcvWi3CTg4bv0t5/AF64in1SUkrT4ctfOecgSteOx7ghXUQKTsh8YsuUp9OgU602H09xJ6GumghJoikffdmrgyNolMXQbPQHAYS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(4001150100001)(31686004)(53546011)(6506007)(66556008)(8676002)(2616005)(38100700002)(956004)(316002)(7416002)(6512007)(186003)(6486002)(36756003)(54906003)(66476007)(8936002)(83380400001)(110136005)(26005)(86362001)(31696002)(5660300002)(2906002)(508600001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0pKNWRWYnBBMGtDc0J4U0h3Y1h0TlJwQmllUzEwdmRCSStncFc1S2l4Nzhy?=
 =?utf-8?B?WVVDdTBYaWgzak03c3R6ZkZtRUNxa3pYd1VNa2puRDBzUlRqS1psT1RkMjdH?=
 =?utf-8?B?QTJGRStCOHdFaTdpN3hiNlQyN2tBRTRxTUtnZVVVay9KekwxOFpVNWJRVjJT?=
 =?utf-8?B?aStRM25ISE8xUWZxZXcvbVZ3dk85WXowNXd2R09hQ2JSR0YzRVpEdFhGMG9U?=
 =?utf-8?B?MTBBcXo4aU53bUcySndVaUpid09mOTVmL29PUSsyTWdjQXhpbEJJcVg5MXFE?=
 =?utf-8?B?L3I4Nm5oVGJRL1dONkVSQU45T2kxSFIxOFJRUHk4blhSeEl4bmFwRjdIOE1G?=
 =?utf-8?B?cDJQcVE1Tnc5d2VkT1JMWm5NSGpwWWdrdTZESUY2Z2Fva1dRaG5LRGxJeCtM?=
 =?utf-8?B?N3FraTNBcVZWbk5hUWlaSTJBMkNvT0Z4ZklSanpoZjVtVmxTVGR2MWRsQTEw?=
 =?utf-8?B?YithNFpnWnlZZ21FYkpmUWs0YlRlTXcyWFRrOHI3YVNGSjYzNmVDZXBKZnc3?=
 =?utf-8?B?OXFOMW1KNDIzT0xXL1lWWkdKQ0J4c3NSNkNoeXYremJmMCtqM1NiVHQ5VHRo?=
 =?utf-8?B?elgyZCtrc1dsbmc1T2tLeTNUYkhSU2FXSXIyYTFRaDVmaDRheXljWGtPTmdS?=
 =?utf-8?B?T3pVY21xZENmVklITWxETjVubnFRNldoZFFORlIzRUk2OTlpRGlJWEliQ2Jk?=
 =?utf-8?B?K1NNNGdLQ2VtT3FtQ3JwQ2hhUmZNYW15WG1TenV4MXZDd3J0YXQvUkwxZnJQ?=
 =?utf-8?B?US9FWWZIblFhSXd6VG1rNkRJdEhTeGJ6a28xa09FYUM3dG9vd01UTWVLSE15?=
 =?utf-8?B?RDkxdDArb2V2NGh1a1F6WGs1S3BUQW5VYkdtdWtQdWxnTFJGTmhYeUJsZVdK?=
 =?utf-8?B?V1VjOUxJM291R08rZGplbm94RkpnQlRwWG1GUFRqWEh6azAwZ2pWNlkvcGZF?=
 =?utf-8?B?TlBvRThzUldXZEpCVXlqNVpmdk5DQ2xaT0tzQXhyQ2daZlowZ0RvNE1pZTBB?=
 =?utf-8?B?TzNuSi8vUndoeXlIdUxxbFFDKzBaRzlrdVlTL3F5S1ZWemU0b0NmaVZBc3cx?=
 =?utf-8?B?VFdpemhBS20zUmFxYzRyY0RkcGwreTdWS1dGci8vRmhpYi9WRlNKb2lZeDVG?=
 =?utf-8?B?dDdTQ1dncVZpYkhRNzczR0lWeGwxb2dqTmNBbUZhMFpSNXQ1c09DaUluRW9x?=
 =?utf-8?B?WWk3ZUxhTVU1NlRZN3JEL1l2QUp3U1IrRDVuVWdxdFk0WndLYmdmSjJUblAr?=
 =?utf-8?B?WitBNVdmR0RMSzVMU2RoQTQxRm9NRmFER3ZmZGJqUjFFMkJTTWZyMllIRjZn?=
 =?utf-8?B?eDlNQlJERlRJcm9PZ1dYZlo3V2dvUmdHRTJWTCtCVXNwcXVZWlZqZ0hWWFBQ?=
 =?utf-8?B?VE9zOWI5bnpXRDhsek41NE01U3plcWl1d1pQMERnVHd5VUlsdFlIRW1MWGsr?=
 =?utf-8?B?dTBoYmhtTEZLWThvYUtxdGdZZnZydnJKVGd4MEg4d1ExZ2dhdVU5T3RqYXZQ?=
 =?utf-8?B?clBrU3NwZVg0Skdwb3IvRjVFeUJpUE16T0x4SFBDWFpCZnlEaWh3Z0tJMVh3?=
 =?utf-8?B?U1NTTWNtS0NBT244TXE0SS8zVGYwL2ZGQ2xPNkMrM1Bkc3hHSU9hMXU3VExD?=
 =?utf-8?B?Q2JCN1JtRG9vQk1zTFBGUEVSOVB0MFAxcW1CU2I1TVR4a2pUSlpEZHV4MXc2?=
 =?utf-8?B?Ym9CR2RkWjVzNG9Kczh2dm1VNTZuSG9MZytPR21Sb2RXdjJwNG5Hc0IxT0hF?=
 =?utf-8?B?YWtzQUZQWVlIQVdhMnZBQVVDODNwMUdaUzVwS3V4eXJuQ0lPM3R2WmFLeVlP?=
 =?utf-8?B?cklPS2dDVjBtVE4ybjQwbnpkM2szMHQ2R01JL0dLYlZTdkFHcjdHSmFtdzRC?=
 =?utf-8?B?bnVQTVF0L05hcWFtQXh4V2ZLOTFYOEtLVlM4NTBxL1R4bWF2cnlubGN1dkRI?=
 =?utf-8?B?TzR5Sk9WcG41THpaVk4wTE5hNmpvZ21sUnp6Z2x3MGQza3NMNVZRVDhPNnY2?=
 =?utf-8?B?UnNvUjU2RlI3d0hyVDhlMHlaQm9kZWdtMHBBN1lOeFdpU2hVbGNCZDVtZzda?=
 =?utf-8?B?ZGlrdEhQamNwMjV6N0U4eTRQT0JxZzRJWk5zWFNkb3pYT3c4WTVzRU93ZWxM?=
 =?utf-8?B?dzNFRysrRXd1a2NnMlpFTkxlYmppQ2xHZFIzMFBIa1NzbUZBZGZqd1lwUFNu?=
 =?utf-8?Q?4AETg3tT55A8dWsqP4r5nhQ=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7782832e-a671-49bc-1a15-08d9c195e8a6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 19:46:24.9801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cyxoma7rWk3RKo1H5hRBfL2ffjdkn1BXs9oYV1dd4XIVnYArr3aHrp2x4TftaYPPaHWDU4zR01HNX1lsdFFbfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5533
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 1:11 PM, David Woodhouse wrote:
> On Fri, 2021-12-17 at 11:48 -0600, Tom Lendacky wrote:
>> On 12/16/21 6:13 PM, David Woodhouse wrote:
>>> On Thu, 2021-12-16 at 16:52 -0600, Tom Lendacky wrote:
>>>> On baremetal, I haven't seen an issue. This only seems to have a problem
>>>> with Qemu/KVM.
>>>>
>>>> With 191f08997577 I could boot without issues with and without the
>>>> no_parallel_bringup. Only after I applied e78fa57dd642 did the failure happen.
>>>>
>>>> With e78fa57dd642 I could boot 64 vCPUs pretty consistently, but when I
>>>> jumped to 128 vCPUs it failed again. When I moved the series to
>>>> df9726cb7178, then 64 vCPUs also failed pretty consistently.
>>>>
>>>> Strange thing is it is random. Sometimes (rarely) it works on the first
>>>> boot and then sometimes it doesn't, at which point it will reset and
>>>> reboot 3 or 4 times and then make it past the failure and fully boot.
>>>
>>> Hm, some of that is just artifacts of timing, I'm sure. But now I'm
>>> staring at the way that early_setup_idt() can run in parallel on all
>>> CPUs, rewriting bringup_idt_descr and loading it.
>>>
>>> To start with, let's try unlocking the trampoline_lock much later,
>>> after cpu_init_exception_handling() has loaded the real IDT.
>>>
>>> I think we can probably make secondaries load the real IDT early and
>>> never use bringup_idt_descr at all, can't we? But let's see if this
>>> makes it go away, to start with...
>>>
>>
>> This still fails. I ran with -d cpu_reset on the command line and will
>> forward the full log to you. I ran "grep "[ER]IP=" stderr.log | uniq -c"
>> and got:
>>
>>       128 EIP=00000000 EFL=00000000 [-------] CPL=0 II=0 A20=0 SMM=0 HLT=0
>>       128 EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> These are before running any of the vCPUs.
>>
>>         1 RIP=ffffffff810705c6 RFL=00000206 [-----P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> This is where vCPU0 is at the time of the reset. This address tends to
>> be different all the time and so I think it is just where it happens to
>> be when the reset occurs and isn't contributing to the reset.
> 
> I note that one is in native_write_msr() though. I wonder what it's writing?
> 
> Do you have console output (perhaps with earlyprintk=ttyS0) to go with this?

Yes, but it's not really much help...

[    0.146318] Freeing SMP alternatives memory: 36K
[    0.249121] smpboot: CPU0: AMD EPYC Processor (family: 0x17, model: 0x1, stepping: 0x2)
[    0.249291] Performance Events: AMD PMU driver.
[    0.249771] ... version:                0
[    0.250170] ... bit width:              48
[    0.250258] ... generic registers:      4
[    0.250662] ... value mask:             0000ffffffffffff
[    0.251258] ... max period:             00007fffffffffff
[    0.251790] ... fixed-purpose events:   0
[    0.252258] ... event mask:             000000000000000f
[    0.252972] rcu: Hierarchical SRCU implementation.
[    0.255797] smp: Bringing up secondary CPUs ...
[    0.256372] x86: Booting SMP configuration:
SecCoreStartupWithStack(0xFFFCC000, 0x820000)
Register PPI Notify: DCD0BE23-9586-40F4-B643-06522CED4EDE
Install PPI: 8C8CE578-8A3D-4F1C-9935-896185C32DD3
Install PPI: 5473C07A-3DCB-4DCA-BD6F-1E9689E7349A
The 0th FV start address is 0x00000820000, size is 0x000E0000, handle is 0x820000

There's no WARN or PANIC, just a reset. I can look to try and capture some
KVM trace data if that would help. If so, let me know what events you'd
like captured.

> 

>> CPU Reset (CPU 23)
>> EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> 
> This one we suspect. Is this what a triple-fault would look like? Not
> if it's *already* at f000:fff0, surely?

Good question. The APM doesn't really document it. I'll see if I can find
some h/w folks to check with.

Thanks,
Tom

> 
> CPU Reset (CPU 23)
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00800f12
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 ffff0000 0000ffff 00009a00
> SS =0000 00000000 0000ffff 00009200
> DS =0000 00000000 0000ffff 00009300
> FS =0000 00000000 0000ffff 00009300
> GS =0000 00000000 0000ffff 00009300
> LDT=0000 00000000 0000ffff 00008200
> TR =0000 00000000 0000ffff 00008300
> GDT=     00000000 0000ffff
> IDT=     00000000 0000ffff
> CR0=00000010 CR2=00000000 CR3=00000000 CR4=00000000
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> CCS=00000000 CCD=00000000 CCO=DYNAMIC
> EFER=0000000000000000
> FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
> FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
> FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
> FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
> FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
> XMM00=0000000000000000 0000000000000000 XMM01=0000000000000000 0000000000000000
> XMM02=0000000000000000 0000000000000000 XMM03=0000000000000000 0000000000000000
> XMM04=0000000000000000 0000000000000000 XMM05=0000000000000000 0000000000000000
> XMM06=0000000000000000 0000000000000000 XMM07=0000000000000000 0000000000000000
> 
