Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714C9478028
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 23:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbhLPWwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 17:52:42 -0500
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:44641
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231652AbhLPWwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 17:52:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqXgXcj46qqVm+vg6gFbfJL1V73QXKtfl8zMtWsSiReoMiGgXUu2IexcnbjLGKhMAFde1uW48oeEFg0uea67z9BU3PM1f/7RYL+nKTlMBsHNf558gYw37DDQfCphfMcNPvVwvJDk2y2P2jiXzITuA8kiLmNMasOOzfbwdaOqwFkazh+cja57ZFxKmnvETTfDMbAk7Y81VYpSd84OBVAFtKbVoYIjKIfwg1kPC2/4IwBIGgKM/4aN6FcMPPWsphSupRh/zljhDGkoKZg74KDMa+PFKei81eTF5ZpzwR0EZCSz2Xv/zbuAZbUK8jPcq3nAUf+HkcO3mG2dLoY4I8WcCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyzXxyzLksW0UQJyY4fCdeNh5+beTnO0ygBp5l4QftE=;
 b=PwG2oXCA0ofHijFUwZNEkUotRSlfrLKiWbCg1UIjJfy+Hhns5wkXaRo5Z2PdPBc+ZIE7uh2Qi+nfn0P6WOSQ8UgOu53YCTShxzZwPBGOvZ6esnFHSamlm3ySwGJVHVuSPQ1wfgqM0//cRdq/O2y8Cr7qANjOrmHt9tqD6Zrx+Vhj3jpeK7LoqonPX2mlNwrOdCSy2dzP6az8wWynT9skO73DiyQa5qAukewUgVxht5fKExBnFuUrKdwKhJY710jv4HNagjaDh/xhDbE7f7rKK32qNjRWKC+vvMjGLo0ojb4nE3HxQytIbK1OrqeAJ3xfrh4ikUShoxBdWqxyU+UFJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyzXxyzLksW0UQJyY4fCdeNh5+beTnO0ygBp5l4QftE=;
 b=gBdqfsAfLK0tsSVAnVZPJgZVs8AjIpK550ehdv+J3HpTmbZCnME086Aiq0RI7ktYTRMOO89cpfel7XmNT4WeXkHbUR/obfqEhQmc+p4Xclc8PQmFYjMUc17n/jVElVNyOYFhqd4wNhdk/0a6QKKLAc+xLOb14KJdb6l8Yh9GY9g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5567.namprd12.prod.outlook.com (2603:10b6:5:1ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Thu, 16 Dec
 2021 22:52:39 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Thu, 16 Dec 2021
 22:52:39 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
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
Message-ID: <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com>
Date:   Thu, 16 Dec 2021 16:52:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0143.namprd11.prod.outlook.com
 (2603:10b6:806:131::28) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA0PR11CA0143.namprd11.prod.outlook.com (2603:10b6:806:131::28) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 16 Dec 2021 22:52:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8b8cdc0-c179-47df-ef10-08d9c0e6c2b8
X-MS-TrafficTypeDiagnostic: DM6PR12MB5567:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55670FB3DE64F735680896BBEC779@DM6PR12MB5567.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AtFaivfoknwFVBnocKvWK3wozBHg641Zj/JhIBL4SejBCwWEcfXZTDMEJdNguwz0KiDEIzv2dyNU7sAR8pc4TJJs4OuocT7Zb9OiCu6PVnQ9p/ZMxBT6K3XBdt5RIfUhawImRlhyBYR9lX/LpzyXWfFmfruvBIQ4Ae+CbdsgEPSXW2YMUJXxxYcax/dffI6hx0APdlyEV+IampyuVlCwq7GWoIFvIcFiGEPCsIsvCSP68sopfEWO98OTLsSu4A/pXMrOyNrj5DCtvldJwey0ZC0dZtqo/gPCkwI8l0v3JkRcgQaVEMUb1EWAJF0+tnp8A9U7VyA8D66VDhplND46ijVYoQ+Nb19WvufVZ+71RtUnVTQ0toTLayk7s6cXGWPQDKUgBN9DlgHPGpFbgENEQtKAXJdO4LBzbn/D4CbSCqTTNIMKjOmyqLfvJKrakoysoNm444vphCcA8zdUsBaJgTE6mzfm0ztz5P3XUj6xyzlBp+f3OoWrmjmV9xc6PP9qOuIFa/Bs1SuXVwY70uw3KLhXLrwj0xB4PEAwtiohy8J2JeNRVtrIQSuIShDfRDHy0FprFUUDCmuqRBoMEUhohjrMz04yECCfBrOHRSRgj42W+RbJkPGDxmn1BUnt+Db2AvMso6nIeimKB6QYwmOzuYYVBniydxlGRf+E0NNy0JW38EI7mhq+xE0wFbSGu08uHLxuP8HzPKuiW5f795EYRV6StIjO/Ouv6rCluktAm4WLDT+XKH+63Cj+foKtOd7p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(36756003)(66476007)(66946007)(38100700002)(508600001)(66556008)(54906003)(316002)(8936002)(110136005)(4001150100001)(86362001)(4326008)(53546011)(2616005)(186003)(6506007)(6512007)(31686004)(31696002)(26005)(8676002)(5660300002)(2906002)(7416002)(956004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjlRbEt3WTVSNmNZZDkrR2RETlA1aFBiT3o2NTk0N28wK0c0UFVqaWZSalNj?=
 =?utf-8?B?TEZ3UGs2aWNxR1dvVTNNWVI3bzFEOTFsSDExdGtHUHBBRXcxME9hRHoyMHM3?=
 =?utf-8?B?SnI1YmRzV0hiVFFlcVlvN1lrZk5wK3BBQjFtNG9xWGhJcWJMU0psN2JOZHkx?=
 =?utf-8?B?RkVoM2dQWUtZQjY3aDB2NWsvTXZURmF1K1p6bU9IbFh3MXFPRDlScHRHNC9I?=
 =?utf-8?B?Mm1VTXhYRWZlRVk0cFBJd1VlSVdWcWhBcVRybk02V201Q1FBN0xWT20yWERq?=
 =?utf-8?B?alFFTXBsUVp2ZStHUjBDRHk1M1RaeDRLZURURGhDMDUrelkzVTgzV2t4TGRT?=
 =?utf-8?B?VkNycGkyWklOWTlNMXI5UlNncGJkSy82L2VyVDNmQlNCV0krQWhkaTZKbyt4?=
 =?utf-8?B?WGVzUVB4bnhQNkJ6U2JTeUlDSTcxTURXYmlERGRrQ3R0NVp2d0RYa05wY0t3?=
 =?utf-8?B?K0E4NzllZkQwdHNkaVlwcm4rOGVTTjg3NmI0dytVQkcrWi9vL1RselpsRVpI?=
 =?utf-8?B?SzIzOFVjQ29rNWc3M01xZ0FNQXJxWW1LU2xiTndmSHR1THVpbElCclMwaW5I?=
 =?utf-8?B?SkdlYSthK2ZnbC9PMk5vN1ZtWjQxM2h3ejl4ZDltcDhmdmhtNWY0eXRoYTRt?=
 =?utf-8?B?VnVhRUNadmc4UmZPaFEvTng4Z3J5VTBpYUdQQkdnTHJxMWVVaktiYzFyZWhP?=
 =?utf-8?B?VkJIRHhvWlVQL0ZhZit6R2pieUJXNzM0cFNJditXa21MQVliU2ZpZXdSd2ha?=
 =?utf-8?B?cndXT1NxVnlTNDR6NW5qWG8vQ2NSakswdDJLc0dNaWJhSElQeVh2WGpiR0NX?=
 =?utf-8?B?WnI2OUNJaHBta09UdGtKbHp2ZlBBN0RaRFVCekxNYW9SQzRjdm1yWE50Z2Vj?=
 =?utf-8?B?UDNQL3dTVUpnS0VneWhOanloVDJMaWZiZWVvS1dHYi9HWitnamFCMmFkN2Zq?=
 =?utf-8?B?clRtb1FheS9DSHJTK3NkcncyWjhxWUgvbWJyYXNLWlI0blF2cUNScXRYRzRD?=
 =?utf-8?B?QWdTaGQxbWZ0RjROTlZGRmxiUlJlbmpRYjgvZk0rVTZRNHRPTDdMSGtTbHg2?=
 =?utf-8?B?UFRHRGZmZzF2ZDNNc01WZE1UTmhLUml2UXVDVHZ6Y0ozem8yUTZBMVI1dUFj?=
 =?utf-8?B?SVI2d2doRDZvaUhqWTl0dkswdEpkaWlsNU82eUJkMWwyQ0N4c002SHppNmNJ?=
 =?utf-8?B?RFRlZzdpemlPWlZSNEpYMGJzRnp4dmh3RnFMeHJ1c3IxWjJPZ1pBK1VCc2g4?=
 =?utf-8?B?SGtqSU1LdnBFMEcwNmtwZkhJYzhYRUZJZGdMSjVxMkhpWjBXc0dsWmFaMFNV?=
 =?utf-8?B?T2p4Y3hIdENXMlFXdVNYWUlPYUtlTlZZcVNTT0xLVFZRbnJmOUdiSHZwS1Fo?=
 =?utf-8?B?TWNpRVczamVjSllWU0VQNFhXVC9lbWNlcXVxQzdxODB1d1RyUVFIQ0xVWUZZ?=
 =?utf-8?B?czBucVV2U1hURk9TUjhzTitPWVo4TDA5LzhETDB5RzF1K0MrTTZEK1VNaita?=
 =?utf-8?B?bnlDZnpNd2twaWhYRWdqWXZvODFTazZYRFFjVHBDT1Q5dC9mUFlhVVZCQWRG?=
 =?utf-8?B?dzVlbEltelNzNzhLYmEydWlvWUVyY2xZS1VzZ1N3d29DK1dNUE1hV2F3VVpI?=
 =?utf-8?B?WWtnMmpjemNWbzh6NDZwenliYmQ0L1lIZW1CcUkzKzZJcDRZTFJkZml2WnRZ?=
 =?utf-8?B?NzlWYmI5dWJmRmc5UVNTbkI1UDByeDJaRFZWWmdmWFBBaHpMSkFUMkFMdEcz?=
 =?utf-8?B?RjNrejU1cmlkUkRHQnhTdTliNGNwNXVNVHI0cFVET1haY2puWThtN0VqOHVK?=
 =?utf-8?B?a0NUT2txbkxSWHo0elNGTGpCejhFV29PdWFibUdTalQrMWFYVG1JcjFEL3kr?=
 =?utf-8?B?aHM4MWlKNllJR0dnRFNJZ0h1K3pSdE9vbFk0ZFJjTWxadThyNzJsZ1VxOE4r?=
 =?utf-8?B?VzRWL2hxeTBqaTRQNVJHUTdDUFlXTFNXQ1A5MGIweUVzZm1xbFN2TkZSNVRG?=
 =?utf-8?B?cjlTdk5FQzBqbWY2N0YrK2xQd1A2QTBaYkhOd29UVXRWK2xFRzl0cFlqT0NT?=
 =?utf-8?B?L25iTTBDSDdQWUxYcEQ4RUVMM3FPZlpCVm9NMFphR1daZ1E2VzU2MlZKSmdV?=
 =?utf-8?B?NHUvR2ExdDZrZklwRlBkZkhYMmZ0VHlvdG5VS05OYm93UXRCU0NUcDh1V3cv?=
 =?utf-8?Q?gbKSXUWabIQzh4leUZLa1uI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b8cdc0-c179-47df-ef10-08d9c0e6c2b8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 22:52:39.3488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1JVWUlRAPUga+Vk+/kUrEDXKMpjZv3MPF3HzTmyr1Ac9vq0thBfqvaRMpOHzzkMOHRM6MsFN9xXw4ZxtFg1Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5567
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 1:24 PM, David Woodhouse wrote:
> On Thu, 2021-12-16 at 10:27 -0600, Tom Lendacky wrote:
>> On 12/15/21 8:56 AM, David Woodhouse wrote:
>>> Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting for
>>> them shaves about 80% off the AP bringup time on a 96-thread socket
>>> Skylake box (EC2 c5.metal) — from about 500ms to 100ms.
>>>
>>> There are more wins to be had with further parallelisation, but this is
>>> the simple part.
>>
>> I applied this series and began booting a regular non-SEV guest and hit a
>> failure at 39 vCPUs. No panic or warning, just a reset and OVMF was
>> executing again. I'll try to debug what's going, but not sure how quickly
>> I'll arrive at anything.
> 
> Thanks for testing. This is working for me with BIOS and EFI boots in
> qemu and real hardware but it's mostly been Intel so far. I'll try
> harder on an AMD box.

On baremetal, I haven't seen an issue. This only seems to have a problem 
with Qemu/KVM.

With 191f08997577 I could boot without issues with and without the 
no_parallel_bringup. Only after I applied e78fa57dd642 did the failure happen.

With e78fa57dd642 I could boot 64 vCPUs pretty consistently, but when I 
jumped to 128 vCPUs it failed again. When I moved the series to 
df9726cb7178, then 64 vCPUs also failed pretty consistently.

Strange thing is it is random. Sometimes (rarely) it works on the first 
boot and then sometimes it doesn't, at which point it will reset and 
reboot 3 or 4 times and then make it past the failure and fully boot.

> 
> Anything else special about your setup, kernel config or qemu
> invocation that might help me reproduce?

Shouldn't be anything special that I'm aware of:
  - EPYC 3rd Gen (Milan)
  - Qemu 6.1.0
  - OVMF edk2-stable202111

The qemu command line is:
qemu-system-x86_64 -enable-kvm -cpu EPYC,host-phys-bits=true -smp 128 -m 
1G -machine type=q35 -drive 
if=pflash,format=raw,unit=0,file=/root/kernels/qemu-install/OVMF_CODE.fd,readonly=on 
-drive if=pflash,format=raw,unit=1,file=./diskless.fd -nographic -kernel 
/root/kernels/linux-build-x86_64/arch/x86/boot/bzImage -append 
"console=ttyS0,115200n8" -monitor pty -monitor unix:monitor,server,nowait

I can send the kernel config to you offlist if you're unable to repro with 
yours.

> 
> If it can repro without KVM, 'qemu -d in_asm' can be extremely useful
> for this kind of thing btw.

I didn't repro the failure without KVM.

Thanks,
Tom

> 
