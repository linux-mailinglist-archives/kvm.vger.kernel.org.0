Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F192A3316A9
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 19:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhCHSxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 13:53:06 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:44416
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230173AbhCHSxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 13:53:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOg5qWXbwPiJtzZ/2I4ir1HLX4Tyonqlpa3eokxh97dGOuH+wMeck+wr5cECSCiElTp6zBtwsTLzcGO/G6Ev6zXhYS4WHJy8dQEetAkVBikF7kBYcswc5nPTjBGVHaOlfwfiKwksVEpAE/rP9sRQjTiLyC/utT9cV86thYNzFDKaiXwM/YMzadreFpAGeros3djtm/Or1npsipE0cq0eB9Q02L52BJ51PsBy6UZzNRZ2ycpky8j4WT7bib6zfZQoNgfwblDc4vVHbQMVz1vXf7Y93BxLMnfvlkMwtwtdftZalz4LmjzJ+DbL+/hmSAm+wMYscLqJdP3iKLofZZzO4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKYqsiXhipVRp/7P3TUE88tuf0+gqxNRI7wYeVYVpc8=;
 b=nPdqP0STkdvgRM74po0bjx1s7cRTwyY+nvHRPw2TdCt3twROTri2q8c/KV02S8eS4HQNKG7EfiUkVBAkBSVPhVOYHluEuBNUqOSGE91CHTadZuOkytfO+aPY3Ca0KiKXpG+CTer+0yGj/T8l2AcF4jW6zTKOp5X6zAqn6DkKt9UoT6PUCIuFYnGkeS44YHwYHWARJm2pn0eQhf5mW3/t+RNm6k/CEfIbTzwn2BftaRPpiNmyWNY76eNZ1OWOKFNzpAhQ5mko152ZT8GdzpxOuWR869EopJXDOOvj8IFAsgcCjSYk6yYLc39CGR201DUYH+ROlejtU7QDl9M8VDXl2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKYqsiXhipVRp/7P3TUE88tuf0+gqxNRI7wYeVYVpc8=;
 b=WZ7xc6l9pMmXi4dcp4Uk96pypeDhSIVCLCB9Te0sU2B6jySITlHBtk26b4i3I/FYWsLxU5/H/uADoPmcPTbXGvLJHvj4uAeRkNg3TP/LyXmFYuUYcPZIR+ri8oibr1GJB5mti2UAtmpwjr3Rvxch+kxPnG9hUIbx2Zrpnah13Rc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3275.namprd12.prod.outlook.com (2603:10b6:5:185::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Mon, 8 Mar 2021 18:53:01 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 18:53:01 +0000
Subject: Re: [PATCH 20/24] KVM: x86/mmu: Use a dedicated bit to track
 shadow/MMU-present SPTEs
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20210225204749.1512652-1-seanjc@google.com>
 <20210225204749.1512652-21-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <42917119-b43a-062b-6c09-13b988f7194b@amd.com>
Date:   Mon, 8 Mar 2021 12:52:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210225204749.1512652-21-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:806:122::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0097.namprd04.prod.outlook.com (2603:10b6:806:122::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 18:53:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca1566d9-d18e-4e7e-f086-08d8e26365ca
X-MS-TrafficTypeDiagnostic: DM6PR12MB3275:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3275032C9B34C1270424B995EC939@DM6PR12MB3275.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WTBojjYWPQDi2Yp9e/xvqtB0/yTfK3NBOrVDlikAEI03yw2woWYJ3cvFjmLz5Y+yvh4JfdAd0aVGE7N/EJVrjRME/Kxt6wwTuPe0zwyD5BX2uRX5BCBW+HEudA9euZ7mOMXw533gfgj4/8Rgcac1rI4dh003F3q4Rb/0Cjdb8KjOBufYRvc3U2vBwPOnZyc4XuBhROl0XbPJVuMwlC0/UGLuI+IvP1a0x/xKcilhJ65sDNz//5UEisSzkcoBin/EiiCovlLKyIZsPYHh/mplhTA7xOpqNfa2t1SrnoAlGSvR3n6yTdxRqJAugbfbobe/DEHn5AlGGvVR8tD6lkmXu71utFEcjh0Ei01DdRo1eEdoMpgMyMDzpzzOewqut3foWEgvt16cdGYBeBMEHjqerSp9Dt1sbj4ytxZ2Vp3uR1Rc/bEq8N/NZXWzK4VLS3wE1X5Uf3BqjfAnS8gToE6rH4dOF7g4JUGz2d7MIguiW/oqWPPY8ml8ugM5hj7IfymKIPpBK8YK+xmnJo4PmssCQpxkbUBu+BDYzRCWiq3N6QKJug6jevnP2ZuDUzYh4AtM0hKxFuyQKkDtNI8UFHLRJUXwx9f2T3ymIT2D3rO7kRQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(6506007)(31686004)(5660300002)(6486002)(52116002)(36756003)(31696002)(2616005)(956004)(53546011)(86362001)(66556008)(4326008)(54906003)(8676002)(110136005)(66476007)(186003)(16526019)(478600001)(8936002)(45080400002)(2906002)(83380400001)(6512007)(26005)(316002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dUY0aEN4UVVXNTRGc1V5ZkNRanlieitEYXlNTUhsODVPamt3SXdWb2pIWWd1?=
 =?utf-8?B?ZHhFUE1GelhYcWVzQXEvcU5YdE0xK0xZV0YwaVhuK1dkTjV2Y0ExMlZxOTFC?=
 =?utf-8?B?cGwwcm8wSHplY0VVK0NsR3FOOVR4U0w2YlNPWlpzQ08vdTB3and6dXVwNW5P?=
 =?utf-8?B?Y2J3WEdQak5FdExnbXZ5ODlyeSt5aTNINU54WnFDVGlHWktJUzc2TWdGN0Q0?=
 =?utf-8?B?WFdGNXk1M2JvSFQvcDRiaG1vaTErVHIrNGZwelk3a21LMTRBcUU2c2cremZU?=
 =?utf-8?B?UHlQM20xSGlJaUNiY1BHa0QwMHBiSVJIVTBicnRJbC9uUUtZVTNBM3NOVERE?=
 =?utf-8?B?MzVVMmlKNnVjLzBpZlRydVhHMXI2Vk91TTFuNTc5OEs2OU9hcmlkL20yR0dO?=
 =?utf-8?B?dTZZeUhhUGVWaHYrd29oZ05sTWtnbGdzaFljUGRKRjROc2NEK1kzbGppbEdN?=
 =?utf-8?B?MW1XYnEvM1psYms3c3cyRlU5U2oreHVkL2NKMjQ5TmI3djgwZUJaS2NVU3RO?=
 =?utf-8?B?c0V3WEpqR1I0dGpwUTg1V2NxQVhXb1ptZ0xqV1ZGMHBqRVp2TUM5Q0p2eTFS?=
 =?utf-8?B?WXdxc1N0ayt1RUswQjBTRnRyOTQ1V2JiV05NdDdrSXNtWTZKTSswa3k1WC8y?=
 =?utf-8?B?OE41SG41TitzRERVT2ZvK0o0dmhSNHRnRUt0QzVleXRyZ0FpY01jNW9oc0M1?=
 =?utf-8?B?ZytYbFVkMW1DYnN4VnAxQTJtdmdSOXhCeVdLakFUaUJISmpGNUJOSUJJNEd6?=
 =?utf-8?B?T290QXdjbVJ2eThWb2pLR1pCbDNXK256T2hrZm5PcTBzQ0VkRVE0TUlZVVM1?=
 =?utf-8?B?RElGaHFiUFMwTi9odHczenV5YXNwUlM4OHRVbUU0V21hYnkxMEZhZ2RBekhh?=
 =?utf-8?B?U3MwQ3VYYUQxSlhOZjltYXBDbW5UZEZjaDhZYXlFWGpmNGhwN0t5WVZXdHlL?=
 =?utf-8?B?UGU5MTFFSk5sOGdxWjJ6MmNqaGNVcnNlOW12dDdudDBqUnhmRTRDT05HT2lv?=
 =?utf-8?B?a2hoN1NRTXpIVEs3Z3A0ODRzVU9HMnRKNURkbjMzdTkvRFpMQk1WTU8wQ2Jz?=
 =?utf-8?B?eDNrekxTdTZLWTd1K2ZvRTNnMlJIaHZTQnU4Z1BCVUZudU9BbDFKVHdya1Va?=
 =?utf-8?B?eHR0NllYbm9ZVktlbGhxNDhjUGhua0hlKzJOM3NzVlZSMklpUTg4NXhaaGFH?=
 =?utf-8?B?TVJWeW1XZkdSN05RMnZvazFJcEVselRuWWV4ZXVvM2NLYysyUFBqWmdCbU95?=
 =?utf-8?B?UmJxbWN3cU8yS0d4S2tCbGExckN0TGduNzEyQ2FlczNjVjFrR1lzdTQwYnd6?=
 =?utf-8?B?UVhaaDRXditKbGJJcEkxelZ5cEVMeFdDSlY4OGIvaWd6eURmZzR5b0hlSUlL?=
 =?utf-8?B?ckhGSWRzL2s1aGhFMmFOWFhFU2M3VjJIMVBFQUN1YzlMNWdhYWxkM3VCKzQx?=
 =?utf-8?B?ZW5kaHNqYzR3T1NscXI5N0VrWElEREhLdDBnWEZvd2tSMUhGbS9ZOTJpbTN3?=
 =?utf-8?B?SHpSVWFPNjlacmFaTnlMZ2NSclB4TXdJR3Z3Nm9PQitwYThMZ01QT1FsU3Nm?=
 =?utf-8?B?WDRvcGdBb0k5aStIMVZuSnI1N2hra2hkbVhFVVZDQlNLWXdMKzk1aGtLSnIr?=
 =?utf-8?B?V3IwVlc5dnpkeU1yMHc1RkF4Uzd1OGFFdHRMM0lETHRMbGZIWVhoS05XSWE1?=
 =?utf-8?B?Zld2N3liU1djU005RmlLK2g2RU5uNG5yQnRVUnlaRzZxa0RjYTFBN0FZNHE1?=
 =?utf-8?Q?shep0wr02g0ePF1M1VLqN0fgGcktzvx4a07mQdS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca1566d9-d18e-4e7e-f086-08d8e26365ca
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 18:53:01.3202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yNkYxwMCewQIs2QacAeEBC554Idbczg51ivicnMJ6yG8dVCND6liwXXzmX8yDjtMoagTOutoATfxiKa/F2OmFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3275
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/21 2:47 PM, Sean Christopherson wrote:
> Introduce MMU_PRESENT to explicitly track which SPTEs are "present" from
> the MMU's perspective.  Checking for shadow-present SPTEs is a very
> common operation for the MMU, particularly in hot paths such as page
> faults.  With the addition of "removed" SPTEs for the TDP MMU,
> identifying shadow-present SPTEs is quite costly especially since it
> requires checking multiple 64-bit values.
> 
> On 64-bit KVM, this reduces the footprint of kvm.ko's .text by ~2k bytes.
> On 32-bit KVM, this increases the footprint by ~200 bytes, but only
> because gcc now inlines several more MMU helpers, e.g. drop_parent_pte().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/spte.c |  8 ++++----
>   arch/x86/kvm/mmu/spte.h | 11 ++++++++++-
>   2 files changed, 14 insertions(+), 5 deletions(-)

I'm trying to run a guest on my Rome system using the queue branch, but
I'm encountering an error that I bisected to this commit. In the guest
(during OVMF boot) I see:

error: kvm run failed Invalid argument
RAX=0000000000000000 RBX=00000000ffc12792 RCX=000000007f58401a RDX=000000007faaf808
RSI=0000000000000010 RDI=00000000ffc12792 RBP=00000000ffc12792 RSP=000000007faaf740
R8 =0000000000000792 R9 =000000007faaf808 R10=00000000ffc12793 R11=00000000000003f8
R12=0000000000000010 R13=0000000000000000 R14=000000007faaf808 R15=0000000000000012
RIP=000000007f6e9a90 RFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
CS =0038 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
FS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
GS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
LDT=0000 0000000000000000 0000ffff 00008200 DPL=0 LDT
TR =0000 0000000000000000 0000ffff 00008b00 DPL=0 TSS64-busy
GDT=     000000007f5ee698 00000047
IDT=     000000007f186018 00000fff
CR0=80010033 CR2=0000000000000000 CR3=000000007f801000 CR4=00000668
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000d00
Code=22 00 00 e8 c0 e6 ff ff 48 83 c4 20 45 84 ed 74 07 fb eb 04 <44> 88 65 00 58 5b 5d 41 5c 41 5d c3 55 48 0f af 3d 1b 37 00 00 be 20 00 00 00 48 03 3d 17

On the hypervisor, I see the following:

[   55.886136] get_mmio_spte: detect reserved bits on spte, addr 0xffc12792, dump hierarchy:
[   55.895284] ------ spte 0x1344a0827 level 4.
[   55.900059] ------ spte 0x134499827 level 3.
[   55.904877] ------ spte 0x165bf0827 level 2.
[   55.909651] ------ spte 0xff800ffc12817 level 1.

When I kill the guest, I get a kernel panic:

[   95.539683] __pte_list_remove: 0000000040567a6a 0->BUG
[   95.545481] kernel BUG at arch/x86/kvm/mmu/mmu.c:896!
[   95.551133] invalid opcode: 0000 [#1] SMP NOPTI
[   95.556192] CPU: 142 PID: 5054 Comm: qemu-system-x86 Tainted: G        W         5.11.0-rc4-sos-sev-es #1
[   95.566872] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS REX1006G 01/25/2020
[   95.575900] RIP: 0010:__pte_list_remove.cold+0x2e/0x48 [kvm]
[   95.582312] Code: c7 c6 40 6f f3 c0 48 c7 c7 aa da f3 c0 e8 79 3d a7 cd 0f 0b 48 89 fa 48 c7 c6 40 6f f3 c0 48 c7 c7 87 da f3 c0 e8 61 3d a7 cd <0f> 0b 48 89 fa 48 c7 c6 40 6f f3 c0 48 c7 c7 98 da f3 c0 e8 49 3d
[   95.603271] RSP: 0018:ffffc900143e7c78 EFLAGS: 00010246
[   95.609093] RAX: 000000000000002a RBX: 0000000000000000 RCX: 0000000000000000
[   95.617058] RDX: 0000000000000000 RSI: ffff88900e598950 RDI: ffff88900e598950
[   95.625019] RBP: ffff888165bf0090 R08: ffff88900e598950 R09: ffffc900143e7a98
[   95.632980] R10: 0000000000000001 R11: 0000000000000001 R12: ffffc9000ff29000
[   95.640944] R13: ffffc900143e7d18 R14: 0000000000000098 R15: 0000000000000000
[   95.648912] FS:  0000000000000000(0000) GS:ffff88900e580000(0000) knlGS:0000000000000000
[   95.657951] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   95.664361] CR2: 00007fb328d20c80 CR3: 00000001476d2000 CR4: 0000000000350ee0
[   95.672326] Call Trace:
[   95.675065]  mmu_page_zap_pte+0xf9/0x130 [kvm]
[   95.680103]  __kvm_mmu_prepare_zap_page+0x6d/0x380 [kvm]
[   95.686088]  kvm_mmu_zap_all+0x5e/0xe0 [kvm]
[   95.690911]  kvm_mmu_notifier_release+0x2b/0x60 [kvm]
[   95.696614]  __mmu_notifier_release+0x71/0x1e0
[   95.701585]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
[   95.707512]  ? __khugepaged_exit+0x111/0x160
[   95.712289]  exit_mmap+0x15b/0x1f0
[   95.716092]  ? __khugepaged_exit+0x111/0x160
[   95.720857]  ? kmem_cache_free+0x210/0x3f0
[   95.725428]  ? kmem_cache_free+0x387/0x3f0
[   95.729998]  mmput+0x56/0x130
[   95.733312]  do_exit+0x341/0xb50
[   95.736923]  do_group_exit+0x3a/0xa0
[   95.740925]  __x64_sys_exit_group+0x14/0x20
[   95.745600]  do_syscall_64+0x33/0x40
[   95.749601]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   95.755241] RIP: 0033:0x7fb333a442c6
[   95.759231] Code: Unable to access opcode bytes at RIP 0x7fb333a4429c.
[   95.766514] RSP: 002b:00007ffdf675cad8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[   95.774962] RAX: ffffffffffffffda RBX: 00007fb333b4b610 RCX: 00007fb333a442c6
[   95.782925] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
[   95.790892] RBP: 0000000000000000 R08: 00000000000000e7 R09: ffffffffffffdc38
[   95.798856] R10: 00007fb32945cf80 R11: 0000000000000246 R12: 00007fb333b4b610
[   95.806825] R13: 000000000000034c R14: 00007fb333b4efc8 R15: 0000000000000000
[   95.814803] Modules linked in: tun ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bridge stp llc intel_rapl_msr wmi_bmof intel_rapl_common amd64_edac_mod edac_mce_amd fuse kvm_amd kvm irqby
pass ipmi_ssif sg ccp k10temp acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler acpi_cpufreq sch_fq_codel parport_pc ppdev lp parport sunrpc ip_tables raid10 raid456 async_raid6_recov async_memcpy async_pq async_xo
r async_tx xor raid6_pq raid1 raid0 linear sd_mod t10_pi crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper ast drm_vram_helper i2c_algo_bit drm_ttm_helper 
ttm drm_kms_helper syscopyarea sysfillrect sysimgblt ahci fb_sys_fops libahci libata drm i2c_designware_platform e1000e i2c_piix4 wmi i2c_designware_core pinctrl_amd i2c_core
[   95.893646] ---[ end trace f40aac7ee7919c14 ]---
[   95.898848] RIP: 0010:__pte_list_remove.cold+0x2e/0x48 [kvm]
[   95.905258] Code: c7 c6 40 6f f3 c0 48 c7 c7 aa da f3 c0 e8 79 3d a7 cd 0f 0b 48 89 fa 48 c7 c6 40 6f f3 c0 48 c7 c7 87 da f3 c0 e8 61 3d a7 cd <0f> 0b 48 89 fa 48 c7 c6 40 6f f3 c0 48 c7 c7 98 da f3 c0 e8 49 3d
[   95.926234] RSP: 0018:ffffc900143e7c78 EFLAGS: 00010246
[   95.932109] RAX: 000000000000002a RBX: 0000000000000000 RCX: 0000000000000000
[   95.940087] RDX: 0000000000000000 RSI: ffff88900e598950 RDI: ffff88900e598950
[   95.948086] RBP: ffff888165bf0090 R08: ffff88900e598950 R09: ffffc900143e7a98
[   95.956068] R10: 0000000000000001 R11: 0000000000000001 R12: ffffc9000ff29000
[   95.964051] R13: ffffc900143e7d18 R14: 0000000000000098 R15: 0000000000000000
[   95.972031] FS:  0000000000000000(0000) GS:ffff88900e580000(0000) knlGS:0000000000000000
[   95.981081] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   95.987510] CR2: 00007fb328d20c80 CR3: 00000001476d2000 CR4: 0000000000350ee0
[   95.995492] Kernel panic - not syncing: Fatal exception
[   96.008273] Kernel Offset: disabled
[   96.012249] ---[ end Kernel panic - not syncing: Fatal exception ]---

Let me know if there's anything you want me to try.

Thanks,
Tom

> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index d12acf5eb871..e07aabb23b8a 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -94,7 +94,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
>   		     bool can_unsync, bool host_writable, bool ad_disabled,
>   		     u64 *new_spte)
>   {
> -	u64 spte = 0;
> +	u64 spte = SPTE_MMU_PRESENT_MASK;
>   	int ret = 0;
>   
>   	if (ad_disabled)
> @@ -183,10 +183,10 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
>   
>   u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
>   {
> -	u64 spte;
> +	u64 spte = SPTE_MMU_PRESENT_MASK;
>   
> -	spte = __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
> -	       shadow_user_mask | shadow_x_mask | shadow_me_mask;
> +	spte |= __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
> +		shadow_user_mask | shadow_x_mask | shadow_me_mask;
>   
>   	if (ad_disabled)
>   		spte |= SPTE_TDP_AD_DISABLED_MASK;
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 8996baa8da15..645e9bc2d4a2 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -5,6 +5,15 @@
>   
>   #include "mmu_internal.h"
>   
> +/*
> + * A MMU present SPTE is backed by actual memory and may or may not be present
> + * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
> + * is ignored by all flavors of SPTEs and checking a low bit often generates
> + * better code than for a high bit, e.g. 56+.  MMU present checks are pervasive
> + * enough that the improved code generation is noticeable in KVM's footprint.
> + */
> +#define SPTE_MMU_PRESENT_MASK		BIT_ULL(11)
> +
>   /*
>    * TDP SPTES (more specifically, EPT SPTEs) may not have A/D bits, and may also
>    * be restricted to using write-protection (for L2 when CPU dirty logging, i.e.
> @@ -241,7 +250,7 @@ static inline bool is_access_track_spte(u64 spte)
>   
>   static inline bool is_shadow_present_pte(u64 pte)
>   {
> -	return (pte != 0) && !is_mmio_spte(pte) && !is_removed_spte(pte);
> +	return !!(pte & SPTE_MMU_PRESENT_MASK);
>   }
>   
>   static inline bool is_large_pte(u64 pte)
> 
